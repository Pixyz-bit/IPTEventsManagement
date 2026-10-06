# Database Schema Documentation: UniversityEventDB

- **Database Name:** `UniversityEventDB`
- **Engine:** Microsoft SQL Server (MSSQL / T-SQL)
- **Base Schema File:** 241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql
- **Consolidated schema:** 241611JalopEventsManagement/Backend/Database/Migration/05_ConsolidatedDatabaseSchema.sql
- **Existing database upgrade:** 241611JalopEventsManagement/Backend/Database/Migration/06_EnforceEventLifecycleStatuses.sql

---

## 1. Overview & Architectural Specifications

This schema implements institutional event management, student identity pre-provisioning, event scheduling, dynamic 4-tier audience targeting, registration ticketing, and gate clearance auditing:

1. **Embedded Venue & Capacity:** Embedded `VenueLocation`, `MaxCapacity`, and `CurrentRegistrations` counters directly on [`EventsTable`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_UniversityEventSchema.sql#L84-L125).
2. **Event Ownership:** `CreatedByUserId` links each event to an administrative/organizer user account in [`UserTable`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_UniversityEventSchema.sql#L33-L49).
3. **1:1 Student-to-User Mapping:** [`StudentTable.UserId`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_UniversityEventSchema.sql#L55-L77) contains a unique non-clustered constraint enforcing strict 1:1 account association.
4. **4-Tier Target Audience Matrix (Issue D):** [`EventAudienceMatrixTable`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/02_AddAudienceMatrixAndStudentIndex.sql#L54-L83) supports multi-select restriction rules across University Branch, Department/College, Degree Program/Course, and Year Level, with `HasAudienceRestrictions` on `EventsTable` for open-access bypass.
5. **Covering Student Dashboard Index (Issue B):** `IX_EventRegistrationTable_StudentId` covers `(EventId, Status, RegisteredAt)` to eliminate full table scans when students load their personal dashboard.
6. **Entry Auditing:** `CheckInTimestamp` records real-time gate entry alongside attendance statuses (`NoShow`, `Present`, `Cancelled`).

---

## 2. Entity Specifications & Tables

### 2.1 `dbo.UserTable`
Central authentication and identity repository.

| Column | Type | Nullable | Constraints & Defaults | Description |
| :--- | :--- | :--- | :--- | :--- |
| `UserId` | `INT IDENTITY(1,1)` | No | `PK_UserTable` | Primary Key |
| `Email` | `NVARCHAR(150)` | No | `UQ_UserTable_Email` | Unique institutional email address |
| `PasswordHash` | `VARCHAR(256)` | No | | Secure password hash |
| `PasswordSalt` | `VARCHAR(128)` | No | | Cryptographic salt |
| `Role` | `VARCHAR(50)` | No | `DEFAULT ('Student')`, `IN ('Admin', 'Organizer', 'Staff', 'Student')` | Access control role |
| `IsActive` | `BIT` | No | `DEFAULT (1)` | Account status flag |
| `CreatedAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Creation UTC timestamp |

### 2.2 `dbo.StudentTable`
Academic demographics linked 1:1 with User accounts.

| Column | Type | Nullable | Constraints & Defaults | Description |
| :--- | :--- | :--- | :--- | :--- |
| `StudentId` | `VARCHAR(50)` | No | `PK_StudentTable` | Institutional student ID |
| `FirstName` | `NVARCHAR(100)` | No | | First name |
| `MiddleName` | `NVARCHAR(100)` | Yes | | Middle name |
| `LastName` | `NVARCHAR(100)` | No | | Last name |
| `Gender` | `VARCHAR(20)` | No | `CHECK (Gender IN ('Male', 'Female', 'Non-Binary', 'Other', 'Prefer Not to Say'))` | Student gender |
| `CampusBranch` | `NVARCHAR(100)` | No | | Campus branch |
| `Department` | `NVARCHAR(100)` | No | | College / department |
| `Program` | `NVARCHAR(100)` | No | | Degree program |
| `UserId` | `INT` | No | `UQ_StudentTable_UserId`, `FK -> UserTable (CASCADE)` | 1:1 User mapping |
| `CreatedAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Profile creation UTC timestamp |

### 2.3 `dbo.EventsTable`
Event scheduling, venue location, capacity, audience restriction flag, and lifecycle tracking.

| Column | Type | Nullable | Constraints & Defaults | Description |
| :--- | :--- | :--- | :--- | :--- |
| `EventId` | `INT IDENTITY(1,1)` | No | `PK_EventsTable` | Primary Key |
| `Title` | `NVARCHAR(200)` | No | | Event title |
| `Description` | `NVARCHAR(MAX)` | Yes | | Description & agenda |
| `VenueLocation`| `NVARCHAR(200)` | No | | Physical venue / location |
| `MaxCapacity` | `INT` | No | `CHECK (MaxCapacity > 0)` | Maximum attendee limit |
| `CurrentRegistrations` | `INT` | No | `DEFAULT (0)`, `CHECK (>= 0 AND <= MaxCapacity)` | Active ticket counter |
| `EventStart` | `DATETIME2(7)` | No | `Timeline Check` | Event start time |
| `EventEnd` | `DATETIME2(7)` | No | `Timeline Check` | Event end time |
| `RegStart` | `DATETIME2(7)` | No | `Timeline Check` | Registration window open |
| `RegEnd` | `DATETIME2(7)` | No | `Timeline Check` | Registration window close |
| Status | VARCHAR(50) | No | DEFAULT Upcoming; CK_EventsTable_Status accepts exactly Upcoming, Cancelled, Completed | Event lifecycle; matrix availability is calculated separately |
| `CancellationReason` | `NVARCHAR(500)` | Yes | | Justification if cancelled |
| `HasAudienceRestrictions` | `BIT` | No | `DEFAULT (0)` | Flag indicating 4-tier filtering rules exist |
| `CreatedByUserId` | `INT` | No | `FK -> UserTable(UserId)` | Event owner / creator |
| `CreatedAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Record created UTC |
| `UpdatedAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Last modified UTC |

### 2.4 `dbo.EventAudienceMatrixTable` *(Added in Migration 02)*
Multi-select restriction rules configured across four discrete vectors: University Branch, College/Department, Degree Program/Course, and Year Level.

| Column | Type | Nullable | Constraints & Defaults | Description |
| :--- | :--- | :--- | :--- | :--- |
| `AudienceCriteriaId` | `INT IDENTITY(1,1)` | No | `PK_EventAudienceMatrixTable` | Primary Key |
| `EventId` | `INT` | No | `FK -> EventsTable(EventId) ON DELETE CASCADE` | Associated Event |
| `CriteriaType` | `VARCHAR(20)` | No | `CHECK (CriteriaType IN ('Branch', 'Department', 'Program', 'YearLevel'))` | Restriction vector |
| `CriteriaValue` | `NVARCHAR(100)` | No | | Target value (e.g. 'CICS', 'BSIT', '3') |
| `CreatedAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Created UTC timestamp |

*Note: Enforces composite uniqueness on `(EventId, CriteriaType, CriteriaValue)` to prevent redundant rules.*

### 2.5 `dbo.SponsorListTable`
Event corporate & institutional sponsors.

| Column | Type | Nullable | Constraints & Defaults | Description |
| :--- | :--- | :--- | :--- | :--- |
| `SponsorEntryId` | `INT IDENTITY(1,1)` | No | `PK_SponsorListTable` | Primary Key |
| `EventId` | `INT` | No | `FK -> EventsTable(EventId) ON DELETE CASCADE` | Associated Event |
| `SponsorName` | `NVARCHAR(150)` | No | | Sponsor entity name |
| `CreatedAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Created UTC timestamp |

### 2.6 `dbo.EventRegistrationTable`
Student event registration tickets with gate check-in auditing.

| Column | Type | Nullable | Constraints & Defaults | Description |
| :--- | :--- | :--- | :--- | :--- |
| `EventRegistrationId` | `BIGINT IDENTITY(1,1)` | No | `PK_EventRegistrationTable` | Primary Key |
| `EventId` | `INT` | No | `FK -> EventsTable(EventId)` | Target event |
| `StudentId` | `VARCHAR(50)` | No | `FK -> StudentTable(StudentId)` | Registered student |
| `CurrentYearLvl` | `INT` | No | `CHECK (BETWEEN 1 AND 6)` | Student year level snapshot |
| `CurrentSection` | `VARCHAR(50)` | No | | Section identifier snapshot |
| `Status` | `VARCHAR(20)` | No | `DEFAULT ('NoShow')`, `CHECK IN ('NoShow', 'Present', 'Cancelled')` | Attendance state |
| `CheckInTimestamp` | `DATETIME2(7)` | Yes | | Timestamp of physical gate entry |
| `RegisteredAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Ticket reservation timestamp |

---

## 3. Dedicated Performance Indexes

1. **`IX_EventsTable_VenueSchedule`**
   - Target: `dbo.EventsTable (VenueLocation, EventStart, EventEnd) WHERE Status <> 'Cancelled'`
   - Purpose: Real-time overlap detection for venue double-booking prevention.

2. **`IX_EventRegistrationTable_GateLookup`**
   - Target: `dbo.EventRegistrationTable (EventId, StudentId) INCLUDE (Status, CheckInTimestamp)`
   - Purpose: Sub-millisecond gate verification and attendance barcode/QR lookups.

3. **`IX_EventRegistrationTable_StudentId`** *(Added in Migration 02)*
   - Target: `dbo.EventRegistrationTable (StudentId) INCLUDE (EventId, Status, RegisteredAt)`
   - Purpose: Eliminates table scans when querying registered events for student dashboards.

4. **`IX_EventAudienceMatrixTable_CriteriaLookup`** *(Added in Migration 02)*
   - Target: `dbo.EventAudienceMatrixTable (CriteriaType, CriteriaValue) INCLUDE (EventId)`
   - Purpose: Instant candidate filtering of restricted events matching student profile demographics.

5. **`IX_EventAudienceMatrixTable_EventId`** *(Added in Migration 02)*
   - Target: `dbo.EventAudienceMatrixTable (EventId) INCLUDE (CriteriaType, CriteriaValue)`
   - Purpose: Fast retrieval of targeting rules in the Event Wizard and administrative portal.
