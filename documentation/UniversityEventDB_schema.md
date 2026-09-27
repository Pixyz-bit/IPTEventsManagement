# Database Schema Documentation: UniversityEventDB

- **Database Name:** `UniversityEventDB`
- **Engine:** Microsoft SQL Server (MSSQL / T-SQL)
- **Primary Migration File:** [`02_UniversityEventSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/02_UniversityEventSchema.sql)

---

## 1. Overview & Architectural Specifications

This schema implements the institutional event management, user authentication, student profiling, event scheduling, and registration auditing pipeline:

1. **Embedded Venue & Capacity:** `RoomsTable` has been superseded; `VenueLocation`, `MaxCapacity`, and `CurrentRegistrations` counters are stored directly on [`EventsTable`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/02_UniversityEventSchema.sql#L68-L108).
2. **Event Ownership:** `CreatedByUserId` links each event to an administrative/organizer user account in [`UserTable`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/02_UniversityEventSchema.sql#L33-L47).
3. **1:1 Student-to-User Mapping:** [`StudentTable.UserId`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/02_UniversityEventSchema.sql#L51-L64) contains a unique non-clustered constraint enforcing strict 1:1 account association.
4. **Registration Uniqueness:** A composite unique constraint on `(EventId, StudentId)` prevents double-booking.
5. **Entry Auditing:** `CheckInTimestamp` records real-time gate entry alongside attendance statuses (`NoShow`, `Present`, `Cancelled`).

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
Event scheduling, venue location, capacity, and lifecycle tracking.

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
| `Status` | `VARCHAR(20)` | No | `DEFAULT ('Upcoming')`, `CHECK IN ('Upcoming', 'Cancelled', 'Completed')` | Lifecycle status |
| `CancellationReason` | `NVARCHAR(500)` | Yes | | Justification if cancelled |
| `CreatedByUserId` | `INT` | No | `FK -> UserTable(UserId)` | Event owner / creator |
| `CreatedAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Record created UTC |
| `UpdatedAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Last modified UTC |

### 2.4 `dbo.SponsorListTable`
Event corporate & institutional sponsors.

| Column | Type | Nullable | Constraints & Defaults | Description |
| :--- | :--- | :--- | :--- | :--- |
| `SponsorEntryId` | `INT IDENTITY(1,1)` | No | `PK_SponsorListTable` | Primary Key |
| `EventId` | `INT` | No | `FK -> EventsTable(EventId) ON DELETE CASCADE` | Associated Event |
| `SponsorName` | `NVARCHAR(150)` | No | | Sponsor entity name |
| `CreatedAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Created UTC timestamp |

### 2.5 `dbo.EventRegistrationTable`
Student event registration tickets with gate check-in auditing.

| Column | Type | Nullable | Constraints & Defaults | Description |
| :--- | :--- | :--- | :--- | :--- |
| `EventRegistrationId` | `BIGINT IDENTITY(1,1)` | No | `PK_EventRegistrationTable` | Primary Key |
| `EventId` | `INT` | No | `FK -> EventsTable(EventId)` | Target event |
| `StudentId` | `VARCHAR(50)` | No | `FK -> StudentTable(StudentId)` | Registered student |
| `CurrentYearLvl` | `INT` | No | `CHECK (BETWEEN 1 AND 6)` | Student year level |
| `CurrentSection` | `VARCHAR(50)` | No | | Section identifier |
| `Status` | `VARCHAR(20)` | No | `DEFAULT ('NoShow')`, `CHECK IN ('NoShow', 'Present', 'Cancelled')` | Attendance state |
| `CheckInTimestamp` | `DATETIME2(7)` | Yes | | Timestamp of physical gate entry |
| `RegisteredAt` | `DATETIME2(7)` | No | `DEFAULT (SYSUTCDATETIME())` | Ticket reservation timestamp |

---

## 3. Dedicated Indexes

1. **`IX_EventsTable_VenueSchedule`**
   - Target: `dbo.EventsTable (VenueLocation, EventStart, EventEnd) WHERE Status <> 'Cancelled'`
   - Purpose: Real-time overlap detection for venue double-booking prevention.

2. **`IX_EventRegistrationTable_GateLookup`**
   - Target: `dbo.EventRegistrationTable (EventId, StudentId) INCLUDE (Status, CheckInTimestamp)`
   - Purpose: Sub-millisecond gate verification and attendance barcode/QR lookups.
