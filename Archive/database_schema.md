# Database Schema Documentation: CampusEventDB

- **Document Version:** 1.0.0
- **Target Engine:** Microsoft SQL Server (MSSQL / T-SQL)
- **Primary Migration File:** [`001_CreateCampusEventDBAndEventAttendance.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/001_CreateCampusEventDBAndEventAttendance.sql)
- **Specification Reference:** [`SPECIFICATIONS.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/SPECIFICATIONS.md) (Section 3)

---

## 1. Overview & Architectural Role

`CampusEventDB` is a localized relational database designed to manage physical event admissions, anti-passback integrity, and real-time attendance analytics for institutional campus events. It acts as the local persistence authority for the hybrid stateless QR code ingress pipeline.

```text
[Stateless QR / Phone Screen]
             │
             ▼
[Webcam & OBS Virtual Camera]
             │
             ▼
[ASP.NET Localhost Admission Engine]
             │
             ▼
┌───────────────────────────────────────────────┐
│              CampusEventDB                    │
│  ┌─────────────────────────────────────────┐  │
│  │ dbo.EventAttendance                     │  │
│  │  - PK: StudentID (Anti-Passback Guard)  │  │
│  │  - ScannedAt Index (Timeline Ingress)   │  │
│  │  - Demographics Index (Post-Analytics)  │  │
│  └─────────────────────────────────────────┘  │
└───────────────────────────────────────────────┘
```

---

## 2. Table: `dbo.EventAttendance`

### 2.1 Schema Definition & Data Dictionary

| Column Name | SQL Type | Nullable | Default | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| `StudentID` | `VARCHAR(50)` | No | *None* | **Primary Key (Clustered).** Institutional student ID (e.g., `2024-00123`). Strictly enforces anti-passback protection by disallowing duplicate admissions. |
| `LastName` | `NVARCHAR(100)` | No | *None* | Legal surname of the attendee. Stored as `NVARCHAR` for Unicode/international naming compatibility. Editable by gate marshal upon physical ID review. |
| `FirstName` | `NVARCHAR(100)` | No | *None* | Legal first name of the attendee. Stored as `NVARCHAR` for Unicode character support. Editable by gate marshal upon physical ID review. |
| `Branch` | `NVARCHAR(100)` | No | *None* | Institutional campus branch (e.g., `San Bartolome`, `Batasan`). |
| `Department` | `NVARCHAR(100)` | No | *None* | Academic department or college (e.g., `CICS`, `CEA`). |
| `Course` | `VARCHAR(50)` | No | *None* | Degree program code (e.g., `BSIT`, `BSCS`, `BSCPE`). |
| `Section` | `VARCHAR(50)` | No | *None* | Class section identifier (e.g., `SBIT3C`). |
| `Email` | `VARCHAR(150)` | No | *None* | Institutional or personal email address of the attendee. |
| `RegisteredAt` | `DATETIME2` | No | *None* | UTC timestamp decoded and converted from Unix epoch timestamp (QR index 8). |
| `ScannedAt` | `DATETIME2` | No | `SYSUTCDATETIME()` | Hardware timestamp generated upon physical admission insert on localhost. |
| `IsWalkIn` | `BIT` | No | *None* | `0` = Pre-registered before cutoff; `1` = Walk-in attendee registered on or after event start time. |

---

## 3. Constraints & Referential Integrity

### 3.1 Clustered Primary Key
* **Constraint Name:** `PK_EventAttendance_StudentID`
* **Target Columns:** `(StudentID ASC)`
* **Operational Purpose:** 
  1. Guarantees physical row order sorted by student ID for $O(\log N)$ point lookups.
  2. Blocks duplicate entry attempts at the storage engine level. If an operator or attendee attempts to reuse an ID, MSSQL raises error `2627` (Violation of PRIMARY KEY constraint).

### 3.2 Default Constraint
* **Constraint Name:** `DF_EventAttendance_ScannedAt`
* **Column:** `ScannedAt`
* **Default Value Expression:** `SYSUTCDATETIME()`
* **Operational Purpose:** Enforces sub-microsecond precision UTC recording directly from the host operating system clock upon physical record insertion.

---

## 4. Indexing Strategy

### 4.1 Index: `IX_EventAttendance_ScannedAt`
* **Type:** Nonclustered
* **Target Columns:** `(ScannedAt ASC)`
* **Operational Purpose:**
  - Optimizes fast duplicate pre-check queries retrieving scan history:
    ```sql
    SELECT ScannedAt FROM EventAttendance WHERE StudentID = @StudentID;
    ```
  - Optimizes time-series ingress rate monitoring and arrival bracket analytics (e.g., early vs. on-time vs. late arrivals).

### 4.2 Index: `IX_EventAttendance_Demographics`
* **Type:** Nonclustered Composite
* **Target Columns:** `(Department, Course, Section, IsWalkIn)`
* **Operational Purpose:**
  - Provides index-covered group-by performance for post-event analytical suites:
    ```sql
    SELECT Department, Course, Section, COUNT(1) AS TotalPresent
    FROM EventAttendance
    GROUP BY Department, Course, Section;
    ```

---

## 5. Granular Operational Query Breakdown

### Query 1: Fail-Fast Duplicate Pre-Check
* **Purpose:** Determines whether a scanned student token has already been redeemed at the gate.
* **Signature & Contracts:**
  - Input: `@StudentID VARCHAR(50)`
  - Output: `ScannedAt DATETIME2` (single row) or empty result set.
* **Internal Mechanics:** Executes a clustered index seek on `PK_EventAttendance_StudentID`. If found, returns the exact timestamp of the previous check-in.
* **Side Effects & Thrown Errors:** None (read-only query). Returns empty if attendee has not entered.

### Query 2: Venue Capacity Ceiling Guard & Atomic Persistence
* **Purpose:** Safely commits attendee record only when venue capacity ceiling has not been exceeded.
* **Signature & Contracts:**
  - Inputs: `@StudentID`, `@LastName`, `@FirstName`, `@Branch`, `@Department`, `@Course`, `@Section`, `@Email`, `@RegisteredAt`, `@IsWalkIn`, `@MaxCapacity INT`
  - Output: Number of rows inserted (`1` on success, `0` if full).
* **Internal Mechanics:**
  ```sql
  IF (SELECT COUNT(1) FROM dbo.EventAttendance) < @MaxCapacity
  BEGIN
      INSERT INTO dbo.EventAttendance 
      (StudentID, LastName, FirstName, Branch, Department, Course, Section, Email, RegisteredAt, ScannedAt, IsWalkIn)
      VALUES 
      (@StudentID, @LastName, @FirstName, @Branch, @Department, @Course, @Section, @Email, @RegisteredAt, SYSUTCDATETIME(), @IsWalkIn);
  END
  ```
* **Side Effects & Thrown Errors:**
  - Inserts 1 row into `dbo.EventAttendance`.
  - Throws MSSQL Error 2627 if `StudentID` already exists.
