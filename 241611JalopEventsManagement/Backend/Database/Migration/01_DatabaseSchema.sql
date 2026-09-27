-- 1. Create Database
CREATE DATABASE UniversityEventDB;
GO

USE UniversityEventDB;
GO

-- 2. User Table
CREATE TABLE UserTable (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(150) NOT NULL,
    PasswordHash VARCHAR(256) NOT NULL,
    PasswordSalt VARCHAR(128) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- 3. Rooms Table
CREATE TABLE RoomsTable (
    RoomId INT IDENTITY(1,1) PRIMARY KEY,
    VenueLocation NVARCHAR(200) NOT NULL,
    RoomNumber NVARCHAR(50) NOT NULL,
    MaxCapacity INT NOT NULL
);
GO

-- 4. Student Table
CREATE TABLE StudentTable (
    StudentId VARCHAR(50) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    MiddleName NVARCHAR(100) NULL,
    LastName NVARCHAR(100) NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    CampusBranch NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100) NOT NULL,
    Program NVARCHAR(100) NOT NULL,
    UserId INT NOT NULL,
    FOREIGN KEY (UserId) REFERENCES UserTable(UserId)
);
GO

-- 5. Events Table
-- Addresses:
--   Issue 3: MaxCapacity & CurrentRegistrations counter directly on the event
--   Issue 4: CreatedByUserId foreign key referencing UserTable
--   Issue D: 4-tier audience matrix (NULL = Open to All)
CREATE TABLE EventsTable (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    RoomId INT NOT NULL,
    MaxCapacity INT NOT NULL,
    CurrentRegistrations INT NOT NULL DEFAULT 0,
    CreatedByUserId INT NOT NULL,
    EventStart DATETIME NOT NULL,
    EventEnd DATETIME NOT NULL,
    RegStart DATETIME NOT NULL,
    RegEnd DATETIME NOT NULL,
    Status VARCHAR(50) NOT NULL, -- 'Upcoming', 'Cancelled', 'Completed'
    CancellationReason NVARCHAR(500) NULL,
    
    -- Issue D: Target Audience Matrix (NULL = Open to All)
    TargetBranch NVARCHAR(100) NULL,
    TargetDepartment NVARCHAR(100) NULL,
    TargetProgram NVARCHAR(100) NULL,
    TargetYearLevel INT NULL,

    FOREIGN KEY (RoomId) REFERENCES RoomsTable(RoomId),
    FOREIGN KEY (CreatedByUserId) REFERENCES UserTable(UserId)
);
GO

-- 6. Sponsor List Table
CREATE TABLE SponsorListTable (
    SponsorEntryId INT IDENTITY(1,1) PRIMARY KEY,
    SponsorName NVARCHAR(150) NOT NULL,
    CreatedAt DATETIME NOT NULL,
    EventId INT NOT NULL,
    FOREIGN KEY (EventId) REFERENCES EventsTable(EventId)
);
GO

-- 7. Event Registration Table
-- Addresses:
--   Missing Check-In Timestamp: Added CheckInTimestamp DATETIME NULL
--   Default Status: 'NoShow'
CREATE TABLE EventRegistrationTable (
    EventRegistrationId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    StudentId VARCHAR(50) NOT NULL,
    CurrentYearLvl INT NOT NULL,
    CurrentSection VARCHAR(50) NOT NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'NoShow', -- 'NoShow', 'Cancelled', 'Present'
    CheckInTimestamp DATETIME NULL,
    FOREIGN KEY (EventId) REFERENCES EventsTable(EventId),
    FOREIGN KEY (StudentId) REFERENCES StudentTable(StudentId)
);
GO

-- 8. Performance Index
-- Addresses Issue B: Eliminates full table scan on student dashboard queries
CREATE INDEX IX_EventRegistrationTable_StudentId 
ON EventRegistrationTable (StudentId);
GO
