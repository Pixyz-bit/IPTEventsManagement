-- ============================================================================
-- 05_ConsolidatedDatabaseSchema.sql
-- Consolidated SQL Server schema for UniversityEventDB.
-- Run this standalone script in SSMS or sqlcmd against a SQL Server instance
-- where UniversityEventDB does not already exist. Do not run migrations 01-04
-- afterward; their final schema changes are already represented here.
--
-- Source migration coverage:
--   01: All five tables, primary/foreign keys, defaults, and student lookup index.
--   02: EventsTable.EventPhotoPath is included directly in CREATE TABLE.
--   03: Student data purge is intentionally excluded: it changes data, not schema.
--       A new database starts empty, so no purge is needed. Use migration 03
--       separately only when an intentional student-data reset is required.
--   04: StudentTable omits YearLevel and Section. Event-specific academic details
--       remain in EventRegistrationTable.CurrentYearLvl and CurrentSection.
--
-- This file is a fresh database setup, not an upgrade for an existing database.
-- ============================================================================
-- 1. Create Database
CREATE DATABASE UniversityEventDB;
GO

USE UniversityEventDB;
GO

-- 2. User Table
CREATE TABLE dbo.UserTable (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(150) NOT NULL,
    PasswordHash VARCHAR(256) NOT NULL,
    PasswordSalt VARCHAR(128) NOT NULL,
    Role VARCHAR(50) NOT NULL, -- 'Admin', 'Student'
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- 3. Student Table
CREATE TABLE dbo.StudentTable (
    StudentId VARCHAR(50) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    MiddleName NVARCHAR(100) NULL,
    LastName NVARCHAR(100) NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    CampusBranch NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100) NOT NULL,
    Program NVARCHAR(100) NOT NULL,
    UserId INT NOT NULL,
    BirthDate DATE NULL,
    FOREIGN KEY (UserId) REFERENCES dbo.UserTable(UserId)
);
GO

-- 4. Events Table
CREATE TABLE dbo.EventsTable (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    VenueLocation NVARCHAR(200) NOT NULL,
    MaxCapacity INT NOT NULL,
    CurrentRegistrations INT NOT NULL DEFAULT 0,
    CreatedByUserId INT NOT NULL,
    EventStart DATETIME NOT NULL,
    EventEnd DATETIME NOT NULL,
    RegStart DATETIME NOT NULL,
    RegEnd DATETIME NOT NULL,
    Status VARCHAR(50) NOT NULL CONSTRAINT DF_EventsTable_Status DEFAULT 'Upcoming'
        CONSTRAINT CK_EventsTable_Status CHECK (
            (Status COLLATE Latin1_General_100_BIN2 = 'Upcoming' AND DATALENGTH(Status) = 8) OR
            (Status COLLATE Latin1_General_100_BIN2 = 'Cancelled' AND DATALENGTH(Status) = 9) OR
            (Status COLLATE Latin1_General_100_BIN2 = 'Completed' AND DATALENGTH(Status) = 9)),
    CancellationReason NVARCHAR(500) NULL,
    
    -- NULL audience fields indicate no restriction for that category.
    TargetBranch NVARCHAR(100) NULL,
    TargetDepartment NVARCHAR(100) NULL,
    TargetProgram NVARCHAR(100) NULL,
    TargetYearLevel INT NULL,
    EventPhotoPath NVARCHAR(500) NULL,

    FOREIGN KEY (CreatedByUserId) REFERENCES dbo.UserTable(UserId)
);
GO

-- 5. Sponsor List Table
CREATE TABLE dbo.SponsorListTable (
    SponsorEntryId INT IDENTITY(1,1) PRIMARY KEY,
    SponsorName NVARCHAR(150) NOT NULL,
    CreatedAt DATETIME NOT NULL,
    EventId INT NOT NULL,
    FOREIGN KEY (EventId) REFERENCES dbo.EventsTable(EventId)
);
GO

-- 6. Event Registration Table
CREATE TABLE dbo.EventRegistrationTable (
    EventRegistrationId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    StudentId VARCHAR(50) NOT NULL,
    CurrentYearLvl INT NOT NULL,
    CurrentSection VARCHAR(50) NOT NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'NoShow', -- 'NoShow', 'Cancelled', 'Present'
    CheckInTimestamp DATETIME NULL,
    FOREIGN KEY (EventId) REFERENCES dbo.EventsTable(EventId),
    FOREIGN KEY (StudentId) REFERENCES dbo.StudentTable(StudentId)
);
GO

-- 7. Performance Index
-- Supports student dashboard registration lookups.
CREATE INDEX IX_EventRegistrationTable_StudentId 
ON dbo.EventRegistrationTable (StudentId);
GO

