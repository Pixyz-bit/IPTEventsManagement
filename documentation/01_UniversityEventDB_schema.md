# Final database schema: UniversityEventDB

- **Engine:** Microsoft SQL Server (T-SQL).
- **Authoritative fresh-install script:** `241611JalopEventsManagement/Backend/Database/Migration/07_FinalDatabaseSchema.sql`.
- **Historical setup scripts:** 01 and 05 remain for reference. Use 07 alone for new installations; do not apply 01-06 afterward.
- **Existing database upgrade:** `06_EnforceEventLifecycleStatuses.sql` enforces event statuses without deleting records. It is not the final fresh-install script.

## Installation contract

The final script creates UniversityEventDB only if it does not exist, then refuses to proceed if any of the five application tables already exist. It creates tables, constraints and the lookup index in one transaction. It contains no DROP, DELETE, TRUNCATE or seed-data operations. Saving the file does not modify the live database. Existing databases should not be recreated using this script.

Tables are ordered by their dependencies: UserTable, StudentTable, EventsTable, SponsorListTable, EventRegistrationTable. All primary keys, foreign keys and defaults have explicit names; foreign keys use NO ACTION for updates and deletions.

## Tables and columns

All lengths below are declared SQL character lengths. Unmarked columns are NOT NULL.

### dbo.UserTable

| Column | Type | Details |
|---|---|---|
| UserId | INT | IDENTITY(1,1), clustered primary key |
| Email | NVARCHAR(150) | |
| PasswordHash | VARCHAR(256) | |
| PasswordSalt | VARCHAR(128) | |
| Role | VARCHAR(50) | Admin/Student validation is in the application |
| IsActive | BIT | Default 1 |

### dbo.StudentTable

| Column | Type | Details |
|---|---|---|
| StudentId | VARCHAR(50) | Clustered primary key |
| FirstName | NVARCHAR(100) | |
| MiddleName | NVARCHAR(100) | NULL allowed |
| LastName | NVARCHAR(100) | |
| Gender | VARCHAR(20) | |
| CampusBranch | NVARCHAR(100) | |
| Department | NVARCHAR(100) | |
| Program | NVARCHAR(100) | |
| UserId | INT | Foreign key to UserTable.UserId |
| BirthDate | DATE | NULL allowed |

UserId has no database UNIQUE constraint in this schema. Year and section belong to each event registration, not the student profile.

### dbo.EventsTable

| Column | Type | Details |
|---|---|---|
| EventId | INT | IDENTITY(1,1), clustered primary key |
| Title | NVARCHAR(200) | |
| Description | NVARCHAR(MAX) | NULL allowed |
| VenueLocation | NVARCHAR(200) | |
| MaxCapacity | INT | |
| CurrentRegistrations | INT | Default 0 |
| CreatedByUserId | INT | Foreign key to UserTable.UserId |
| EventStart | DATETIME | |
| EventEnd | DATETIME | |
| RegStart | DATETIME | Registration opening |
| RegEnd | DATETIME | Registration deadline |
| Status | VARCHAR(50) | Default Upcoming; lifecycle check constraint |
| CancellationReason | NVARCHAR(500) | NULL allowed |
| TargetBranch | NVARCHAR(100) | NULL allowed |
| TargetDepartment | NVARCHAR(100) | NULL allowed |
| TargetProgram | NVARCHAR(100) | NULL allowed; application interprets program selection |
| TargetYearLevel | INT | NULL allowed |
| EventPhotoPath | NVARCHAR(500) | NULL allowed |

CK_EventsTable_Status admits exactly Upcoming, Cancelled and Completed. Binary collation and DATALENGTH checks reject case variations and trailing spaces. NULL audience fields mean no restriction for that category. There is no separate audience-matrix or venue table.

### dbo.SponsorListTable

| Column | Type | Details |
|---|---|---|
| SponsorEntryId | INT | IDENTITY(1,1), clustered primary key |
| SponsorName | NVARCHAR(150) | |
| CreatedAt | DATETIME | Supplied by the application; no database default |
| EventId | INT | Foreign key to EventsTable.EventId |

### dbo.EventRegistrationTable

| Column | Type | Details |
|---|---|---|
| EventRegistrationId | INT | IDENTITY(1,1), clustered primary key |
| EventId | INT | Foreign key to EventsTable.EventId |
| StudentId | VARCHAR(50) | Foreign key to StudentTable.StudentId |
| CurrentYearLvl | INT | Event-specific academic snapshot |
| CurrentSection | VARCHAR(50) | Event-specific academic snapshot |
| Status | VARCHAR(50) | Default NoShow; application uses NoShow, Present, Cancelled |
| CheckInTimestamp | DATETIME | NULL until attendance confirmation |

Ticket creation dates are not collected. Registration totals, cancellation deadlines and attendance operate without a reservation creation-time column. RegStart/RegEnd describe the event's registration window; CheckInTimestamp describes attendance.

## Indexes and constraints

- Five clustered primary keys, one per table.
- Five foreign keys as described above, each with NO ACTION on delete/update.
- Four default constraints: UserTable.IsActive, EventsTable.CurrentRegistrations, EventsTable.Status, EventRegistrationTable.Status.
- One check constraint: CK_EventsTable_Status.
- One additional nonclustered index: IX_EventRegistrationTable_StudentId on StudentId (no included columns).

No extra uniqueness, date-window, year-level or capacity check constraints are introduced by this final schema. Repository and page validation implement those application rules.

## Live database verification

Read-only verification on October 7, 2026 found DF_EventsTable_Status and the exact CK_EventsTable_Status from migration 06 enabled and trusted, with no ended Upcoming events at the time of the check. There is no migration-history ledger, so this verifies the resulting state rather than proving a particular file was executed.

The live database uses generated names for several primary/default/foreign keys. The final script uses readable deterministic names with equivalent relationships. The two existing registration foreign keys are enabled but untrusted; new installations create trusted keys. This file does not change the trust state or records of an existing database.
