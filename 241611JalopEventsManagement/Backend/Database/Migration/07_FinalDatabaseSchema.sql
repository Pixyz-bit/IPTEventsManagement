-- ============================================================================
-- FINAL / AUTHORITATIVE FRESH-INSTALL SCHEMA: UniversityEventDB
-- SQL Server T-SQL; run in SSMS or sqlcmd. GO is a client batch separator.
--
-- Based on the five-table schema, including migration 06's event-status rule
-- and the existing student-registration lookup index. No ticket creation date
-- is stored. CheckInTimestamp records confirmed attendance only.
--
-- Use this file alone for a NEW installation; do not run scripts 01-06 afterward.
-- This is NOT an upgrade, reset or replacement operation for an existing database.
-- Existing application tables cause an error before any table changes occur.
-- No records are deleted, truncated or seeded. The live database is not changed
-- by saving this file. Migration 06 remains available for older databases.
-- ============================================================================

USE [master];
GO

IF DB_ID(N'UniversityEventDB') IS NULL
    EXEC(N'CREATE DATABASE [UniversityEventDB];');
GO

USE [UniversityEventDB];
GO

SET XACT_ABORT ON;

IF EXISTS (
    SELECT 1 FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE s.name = N'dbo' AND t.name IN (
        N'UserTable', N'StudentTable', N'EventsTable',
        N'SponsorListTable', N'EventRegistrationTable')
)
    THROW 51001, 'Application tables already exist. This final schema is for a fresh installation only; no tables were changed.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Parent tables are created before the tables that reference them.
    CREATE TABLE [dbo].[UserTable] (
        [UserId] INT IDENTITY(1,1) NOT NULL,
        [Email] NVARCHAR(150) NOT NULL,
        [PasswordHash] VARCHAR(256) NOT NULL,
        [PasswordSalt] VARCHAR(128) NOT NULL,
        [Role] VARCHAR(50) NOT NULL, -- Admin or Student; validated by the application.
        [IsActive] BIT NOT NULL CONSTRAINT [DF_UserTable_IsActive] DEFAULT (1),
        CONSTRAINT [PK_UserTable] PRIMARY KEY CLUSTERED ([UserId])
    );

    CREATE TABLE [dbo].[StudentTable] (
        [StudentId] VARCHAR(50) NOT NULL,
        [FirstName] NVARCHAR(100) NOT NULL,
        [MiddleName] NVARCHAR(100) NULL,
        [LastName] NVARCHAR(100) NOT NULL,
        [Gender] VARCHAR(20) NOT NULL,
        [CampusBranch] NVARCHAR(100) NOT NULL,
        [Department] NVARCHAR(100) NOT NULL,
        [Program] NVARCHAR(100) NOT NULL,
        [UserId] INT NOT NULL,
        [BirthDate] DATE NULL,
        CONSTRAINT [PK_StudentTable] PRIMARY KEY CLUSTERED ([StudentId]),
        CONSTRAINT [FK_StudentTable_UserTable] FOREIGN KEY ([UserId])
            REFERENCES [dbo].[UserTable] ([UserId])
            ON DELETE NO ACTION ON UPDATE NO ACTION
    );

    CREATE TABLE [dbo].[EventsTable] (
        [EventId] INT IDENTITY(1,1) NOT NULL,
        [Title] NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(MAX) NULL,
        [VenueLocation] NVARCHAR(200) NOT NULL,
        [MaxCapacity] INT NOT NULL,
        [CurrentRegistrations] INT NOT NULL CONSTRAINT [DF_EventsTable_CurrentRegistrations] DEFAULT (0),
        [CreatedByUserId] INT NOT NULL,
        [EventStart] DATETIME NOT NULL,
        [EventEnd] DATETIME NOT NULL,
        [RegStart] DATETIME NOT NULL,
        [RegEnd] DATETIME NOT NULL,
        [Status] VARCHAR(50) NOT NULL CONSTRAINT [DF_EventsTable_Status] DEFAULT ('Upcoming'),
        [CancellationReason] NVARCHAR(500) NULL,
        -- NULL audience fields mean no restriction for that category.
        [TargetBranch] NVARCHAR(100) NULL,
        [TargetDepartment] NVARCHAR(100) NULL,
        [TargetProgram] NVARCHAR(100) NULL,
        [TargetYearLevel] INT NULL,
        [EventPhotoPath] NVARCHAR(500) NULL,
        CONSTRAINT [PK_EventsTable] PRIMARY KEY CLUSTERED ([EventId]),
        CONSTRAINT [CK_EventsTable_Status] CHECK (
            ([Status] COLLATE Latin1_General_100_BIN2 = 'Upcoming' AND DATALENGTH([Status]) = 8) OR
            ([Status] COLLATE Latin1_General_100_BIN2 = 'Cancelled' AND DATALENGTH([Status]) = 9) OR
            ([Status] COLLATE Latin1_General_100_BIN2 = 'Completed' AND DATALENGTH([Status]) = 9)
        ),
        CONSTRAINT [FK_EventsTable_UserTable] FOREIGN KEY ([CreatedByUserId])
            REFERENCES [dbo].[UserTable] ([UserId])
            ON DELETE NO ACTION ON UPDATE NO ACTION
    );

    CREATE TABLE [dbo].[SponsorListTable] (
        [SponsorEntryId] INT IDENTITY(1,1) NOT NULL,
        [SponsorName] NVARCHAR(150) NOT NULL,
        [CreatedAt] DATETIME NOT NULL,
        [EventId] INT NOT NULL,
        CONSTRAINT [PK_SponsorListTable] PRIMARY KEY CLUSTERED ([SponsorEntryId]),
        CONSTRAINT [FK_SponsorListTable_EventsTable] FOREIGN KEY ([EventId])
            REFERENCES [dbo].[EventsTable] ([EventId])
            ON DELETE NO ACTION ON UPDATE NO ACTION
    );

    CREATE TABLE [dbo].[EventRegistrationTable] (
        [EventRegistrationId] INT IDENTITY(1,1) NOT NULL,
        [EventId] INT NOT NULL,
        [StudentId] VARCHAR(50) NOT NULL,
        [CurrentYearLvl] INT NOT NULL,
        [CurrentSection] VARCHAR(50) NOT NULL,
        [Status] VARCHAR(50) NOT NULL CONSTRAINT [DF_EventRegistrationTable_Status] DEFAULT ('NoShow'),
        [CheckInTimestamp] DATETIME NULL,
        CONSTRAINT [PK_EventRegistrationTable] PRIMARY KEY CLUSTERED ([EventRegistrationId]),
        CONSTRAINT [FK_EventRegistrationTable_EventsTable] FOREIGN KEY ([EventId])
            REFERENCES [dbo].[EventsTable] ([EventId])
            ON DELETE NO ACTION ON UPDATE NO ACTION,
        CONSTRAINT [FK_EventRegistrationTable_StudentTable] FOREIGN KEY ([StudentId])
            REFERENCES [dbo].[StudentTable] ([StudentId])
            ON DELETE NO ACTION ON UPDATE NO ACTION
    );

    CREATE NONCLUSTERED INDEX [IX_EventRegistrationTable_StudentId]
        ON [dbo].[EventRegistrationTable] ([StudentId]);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
