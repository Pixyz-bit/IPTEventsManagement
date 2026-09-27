-- ============================================================================
-- Migration: 001_CreateCampusEventDBAndEventAttendance.sql
-- Description: Initializes the CampusEventDB database, EventAttendance table, 
--              primary key constraints, default constraints, and indexes.
-- Target Engine: Microsoft SQL Server (MSSQL / T-SQL)
-- Reference: SPEC-EMS-HYBRID-2026-MSSQL Section 3
-- ============================================================================

-- Step 1: Ensure Target Database Exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'CampusEventDB')
BEGIN
    CREATE DATABASE CampusEventDB;
    PRINT 'Database [CampusEventDB] created successfully.';
END
ELSE
BEGIN
    PRINT 'Database [CampusEventDB] already exists.';
END
GO

-- Step 2: Switch to CampusEventDB Context
USE CampusEventDB;
GO

-- Step 3: Create EventAttendance Table
IF OBJECT_ID(N'dbo.EventAttendance', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.EventAttendance (
        StudentID     VARCHAR(50)    NOT NULL,
        LastName      NVARCHAR(100)  NOT NULL,
        FirstName     NVARCHAR(100)  NOT NULL,
        Branch        NVARCHAR(100)  NOT NULL,
        Department    NVARCHAR(100)  NOT NULL,
        Course        VARCHAR(50)    NOT NULL,
        Section       VARCHAR(50)    NOT NULL,
        Email         VARCHAR(150)   NOT NULL,
        RegisteredAt  DATETIME2      NOT NULL,
        ScannedAt     DATETIME2      NOT NULL CONSTRAINT DF_EventAttendance_ScannedAt DEFAULT SYSUTCDATETIME(),
        IsWalkIn      BIT            NOT NULL,
        CONSTRAINT PK_EventAttendance_StudentID PRIMARY KEY CLUSTERED (StudentID ASC)
    );
    PRINT 'Table [dbo].[EventAttendance] created successfully with Primary Key PK_EventAttendance_StudentID.';
END
ELSE
BEGIN
    PRINT 'Table [dbo].[EventAttendance] already exists.';
END
GO

-- Step 4: Index for Fast Duplicate Pre-Checks and Timestamp Ingress Lookups
IF NOT EXISTS (
    SELECT name 
    FROM sys.indexes 
    WHERE name = N'IX_EventAttendance_ScannedAt' 
      AND object_id = OBJECT_ID(N'dbo.EventAttendance')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_EventAttendance_ScannedAt 
    ON dbo.EventAttendance (ScannedAt ASC);
    PRINT 'Index [IX_EventAttendance_ScannedAt] created successfully.';
END
ELSE
BEGIN
    PRINT 'Index [IX_EventAttendance_ScannedAt] already exists.';
END
GO

-- Step 5: Composite Index for Post-Event Demographics Aggregation and Analytics
IF NOT EXISTS (
    SELECT name 
    FROM sys.indexes 
    WHERE name = N'IX_EventAttendance_Demographics' 
      AND object_id = OBJECT_ID(N'dbo.EventAttendance')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_EventAttendance_Demographics 
    ON dbo.EventAttendance (Department, Course, Section, IsWalkIn);
    PRINT 'Index [IX_EventAttendance_Demographics] created successfully.';
END
ELSE
BEGIN
    PRINT 'Index [IX_EventAttendance_Demographics] already exists.';
END
GO
