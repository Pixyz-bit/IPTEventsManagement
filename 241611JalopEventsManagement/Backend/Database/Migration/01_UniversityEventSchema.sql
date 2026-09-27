-- ============================================================================
-- Complete MSSQL Database Initialization & DDL Specification
-- Schema based on ERD with updated specifications:
--   1. RoomsTable and RoomNumber removed; VenueLocation and MaxCapacity 
--      embedded directly into EventsTable with CurrentRegistrations.
--   2. CreatedByUserId added to EventsTable referencing UserTable(UserId).
--   3. CheckInTimestamp added to EventRegistrationTable for entry audits.
--   4. Composite unique constraint on EventRegistrationTable(EventId, StudentId).
--   5. Unique constraint on StudentTable(UserId) for 1:1 user-to-student mapping.
-- ============================================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'UniversityEventDB')
BEGIN
    CREATE DATABASE UniversityEventDB;
    PRINT 'Database [UniversityEventDB] created successfully.';
END
ELSE
BEGIN
    PRINT 'Database [UniversityEventDB] already exists.';
END
GO

USE UniversityEventDB;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- ----------------------------------------------------------------------------
-- 1. Table: dbo.UserTable
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.UserTable', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserTable (
        UserId INT IDENTITY(1,1) NOT NULL,
        Email NVARCHAR(150) NOT NULL,
        PasswordHash VARCHAR(256) NOT NULL,
        PasswordSalt VARCHAR(128) NOT NULL,
        Role VARCHAR(50) NOT NULL CONSTRAINT DF_UserTable_Role DEFAULT ('Student'),
        IsActive BIT NOT NULL CONSTRAINT DF_UserTable_IsActive DEFAULT (1),
        CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_UserTable_CreatedAt DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_UserTable PRIMARY KEY CLUSTERED (UserId),
        CONSTRAINT UQ_UserTable_Email UNIQUE NONCLUSTERED (Email),
        CONSTRAINT CK_UserTable_Role CHECK (Role IN ('Admin', 'Organizer', 'Staff', 'Student'))
    );
    PRINT 'Table [dbo].[UserTable] created successfully.';
END
GO

-- ----------------------------------------------------------------------------
-- 2. Table: dbo.StudentTable
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.StudentTable', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.StudentTable (
        StudentId VARCHAR(50) NOT NULL,
        FirstName NVARCHAR(100) NOT NULL,
        MiddleName NVARCHAR(100) NULL,
        LastName NVARCHAR(100) NOT NULL,
        Gender VARCHAR(20) NOT NULL,
        CampusBranch NVARCHAR(100) NOT NULL,
        Department NVARCHAR(100) NOT NULL,
        Program NVARCHAR(100) NOT NULL,
        UserId INT NOT NULL,
        CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_StudentTable_CreatedAt DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_StudentTable PRIMARY KEY CLUSTERED (StudentId),
        -- Ensures a 1:1 relationship between User authentication and Student profile
        CONSTRAINT UQ_StudentTable_UserId UNIQUE NONCLUSTERED (UserId),
        CONSTRAINT FK_StudentTable_UserTable FOREIGN KEY (UserId) 
            REFERENCES dbo.UserTable (UserId) ON DELETE CASCADE,
        CONSTRAINT CK_StudentTable_Gender CHECK (Gender IN ('Male', 'Female', 'Non-Binary', 'Other', 'Prefer Not to Say'))
    );
    PRINT 'Table [dbo].[StudentTable] created successfully.';
END
GO

-- ----------------------------------------------------------------------------
-- 3. Table: dbo.EventsTable
-- (VenueLocation and decoupled capacity limits embedded directly)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.EventsTable', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.EventsTable (
        EventId INT IDENTITY(1,1) NOT NULL,
        Title NVARCHAR(200) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        
        -- Location & Capacity
        VenueLocation NVARCHAR(200) NOT NULL,
        MaxCapacity INT NOT NULL,
        CurrentRegistrations INT NOT NULL CONSTRAINT DF_EventsTable_CurrentRegistrations DEFAULT (0),
        
        -- Scheduling and Lifecycle
        EventStart DATETIME2(7) NOT NULL,
        EventEnd DATETIME2(7) NOT NULL,
        RegStart DATETIME2(7) NOT NULL,
        RegEnd DATETIME2(7) NOT NULL,
        Status VARCHAR(20) NOT NULL CONSTRAINT DF_EventsTable_Status DEFAULT ('Upcoming'),
        CancellationReason NVARCHAR(500) NULL,
        
        -- Ownership / Accountability
        CreatedByUserId INT NOT NULL,
        
        CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_EventsTable_CreatedAt DEFAULT (SYSUTCDATETIME()),
        UpdatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_EventsTable_UpdatedAt DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_EventsTable PRIMARY KEY CLUSTERED (EventId),
        CONSTRAINT FK_EventsTable_UserTable FOREIGN KEY (CreatedByUserId) 
            REFERENCES dbo.UserTable (UserId),
        CONSTRAINT CK_EventsTable_MaxCapacity CHECK (MaxCapacity > 0),
        CONSTRAINT CK_EventsTable_CurrentRegistrations CHECK (
            CurrentRegistrations >= 0 AND CurrentRegistrations <= MaxCapacity
        ),
        CONSTRAINT CK_EventsTable_Status CHECK (Status IN ('Upcoming', 'Cancelled', 'Completed')),
        CONSTRAINT CK_EventsTable_Timeline CHECK (
            RegStart < RegEnd 
            AND RegEnd <= EventStart 
            AND EventStart < EventEnd
        )
    );
    PRINT 'Table [dbo].[EventsTable] created successfully.';
END
GO

-- ----------------------------------------------------------------------------
-- 4. Table: dbo.SponsorListTable
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.SponsorListTable', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.SponsorListTable (
        SponsorEntryId INT IDENTITY(1,1) NOT NULL,
        EventId INT NOT NULL,
        SponsorName NVARCHAR(150) NOT NULL,
        CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_SponsorListTable_CreatedAt DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_SponsorListTable PRIMARY KEY CLUSTERED (SponsorEntryId),
        CONSTRAINT FK_SponsorListTable_EventsTable FOREIGN KEY (EventId) 
            REFERENCES dbo.EventsTable (EventId) ON DELETE CASCADE
    );
    PRINT 'Table [dbo].[SponsorListTable] created successfully.';
END
GO

-- ----------------------------------------------------------------------------
-- 5. Table: dbo.EventRegistrationTable
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.EventRegistrationTable', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.EventRegistrationTable (
        EventRegistrationId BIGINT IDENTITY(1,1) NOT NULL,
        EventId INT NOT NULL,
        StudentId VARCHAR(50) NOT NULL,
        CurrentYearLvl INT NOT NULL,
        CurrentSection VARCHAR(50) NOT NULL,
        
        -- Defaulted to 'NoShow' per your original model
        Status VARCHAR(20) NOT NULL CONSTRAINT DF_EventRegistrationTable_Status DEFAULT ('NoShow'),
        
        -- Audit timestamp for arrival tracking
        CheckInTimestamp DATETIME2(7) NULL,
        
        RegisteredAt DATETIME2(7) NOT NULL CONSTRAINT DF_EventRegistrationTable_RegisteredAt DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_EventRegistrationTable PRIMARY KEY CLUSTERED (EventRegistrationId),
        CONSTRAINT FK_EventRegistrationTable_EventsTable FOREIGN KEY (EventId) 
            REFERENCES dbo.EventsTable (EventId),
        CONSTRAINT FK_EventRegistrationTable_StudentTable FOREIGN KEY (StudentId) 
            REFERENCES dbo.StudentTable (StudentId),
        
        -- Prevents a student from holding multiple tickets for the same event
        CONSTRAINT UQ_EventRegistrationTable_Event_Student UNIQUE NONCLUSTERED (EventId, StudentId),
        CONSTRAINT CK_EventRegistrationTable_YearLvl CHECK (CurrentYearLvl BETWEEN 1 AND 6),
        CONSTRAINT CK_EventRegistrationTable_Status CHECK (Status IN ('NoShow', 'Present', 'Cancelled'))
    );
    PRINT 'Table [dbo].[EventRegistrationTable] created successfully.';
END
GO

-- ----------------------------------------------------------------------------
-- 6. Indexes for Performance & Conflict Detection
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_EventsTable_VenueSchedule' AND object_id = OBJECT_ID(N'dbo.EventsTable'))
BEGIN
    -- Detects and optimizes queries checking for venue booking overlaps
    CREATE NONCLUSTERED INDEX IX_EventsTable_VenueSchedule
    ON dbo.EventsTable (VenueLocation, EventStart, EventEnd)
    WHERE Status <> 'Cancelled';
    PRINT 'Index [IX_EventsTable_VenueSchedule] created.';
END
GO

IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_EventRegistrationTable_GateLookup' AND object_id = OBJECT_ID(N'dbo.EventRegistrationTable'))
BEGIN
    -- Accelerates entry verification lookups during attendance scanning
    CREATE NONCLUSTERED INDEX IX_EventRegistrationTable_GateLookup
    ON dbo.EventRegistrationTable (EventId, StudentId)
    INCLUDE (Status, CheckInTimestamp);
    PRINT 'Index [IX_EventRegistrationTable_GateLookup] created.';
END
GO
