-- Repository stored procedures for the EXISTING UniversityEventDB database.
-- SQL Server 2016 SP1+ is required for CREATE OR ALTER.
-- Installation defines procedures only. It does not execute them or change data.
-- C# validation, authentication, hashing, result mapping, transaction boundaries,
-- duplicate checks and warning decisions MUST remain when converting calls.
-- NOCOUNT OFF deliberately preserves existing ExecuteNonQuery affected-row counts.
-- Run the entire file in SSMS; SQLCMD mode is NOT required.
USE [UniversityEventDB];
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Source: RegistrationRepository.RegisterStudent / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_RegisterStudent
    @CurrentYearLvl INT,
    @StudentId VARCHAR(50),
    @EventId INT,
    @CurrentSection VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    BEGIN TRANSACTION;

    DECLARE @Branch NVARCHAR(100), @Department NVARCHAR(100), @Program NVARCHAR(100),
            @YearLevel INT = @CurrentYearLvl, @StudentExists BIT = 0;
    SELECT @Branch = LTRIM(RTRIM(CampusBranch)), @Department = LTRIM(RTRIM(Department)),
           @Program = LTRIM(RTRIM(Program)), @StudentExists = 1
    FROM dbo.StudentTable WITH (HOLDLOCK) WHERE StudentId = @StudentId;

    DECLARE @Current INT, @Max INT, @RegStart DATETIME, @RegEnd DATETIME, @EventEnd DATETIME, @EvtStatus VARCHAR(50);
    SELECT @Current = CurrentRegistrations, 
           @Max = MaxCapacity,
           @RegStart = RegStart,
           @RegEnd = RegEnd,
           @EventEnd = EventEnd,
           @EvtStatus = Status
    FROM dbo.EventsTable WITH (UPDLOCK, HOLDLOCK)
    WHERE EventId = @EventId;

    -- Registration is strictly permitted during the event's registration window
    IF @EvtStatus IS NULL OR @EvtStatus != 'Upcoming' OR GETDATE() < @RegStart OR GETDATE() > @RegEnd OR GETDATE() >= @EventEnd
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT -2; -- Registration window closed or event inactive
    END
    ELSE IF @Current >= @Max
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT -1; -- Venue capacity reached
    END
    ELSE IF @StudentExists = 0 OR NOT EXISTS (
        SELECT 1 FROM dbo.EventsTable WHERE EventId = @EventId

      AND (NULLIF(LTRIM(RTRIM(TargetBranch)), '') IS NULL OR LTRIM(RTRIM(TargetBranch)) = @Branch)
      AND (NULLIF(LTRIM(RTRIM(TargetDepartment)), '') IS NULL OR LTRIM(RTRIM(TargetDepartment)) = @Department)
      AND (NULLIF(LTRIM(RTRIM(TargetProgram)), '') IS NULL OR
           (NULLIF(LTRIM(RTRIM(@Program)), '') IS NOT NULL AND
            (CHARINDEX(',' + REPLACE(LTRIM(RTRIM(@Program)), ' ', '') + ',', ',' + REPLACE(TargetProgram, ' ', '') + ',') > 0
             OR EXISTS (
                SELECT 1 FROM (VALUES
                    ('BSIT', 'BSInformationTechnology'),
                    ('BSCS', 'BSComputerScience'),
                    ('BSIS', 'BSInformationSystems'),
                    ('BSIE', 'BSIndustrialEngineering'),
                    ('BSCpE', 'BSComputerEngineering'),
                    ('BSECE', 'BSElectronicsEngineering'),
                    ('BSA', 'BSAccountancy'),
                    ('BSBA', 'BSBusinessAdministration'),
                    ('BSEntrep', 'BSEntrepreneurship'),
                    ('BECEd', 'BachelorofEarlyChildhoodEducation'),
                    ('BSEd', 'BSSecondaryEducation'),
                    ('BSEd', 'BachelorofSecondaryEducation')
                ) AS ProgramAliases(Code, FullName)
                WHERE REPLACE(LTRIM(RTRIM(@Program)), ' ', '') IN (Code, FullName)
                  AND (CHARINDEX(',' + Code + ',', ',' + REPLACE(TargetProgram, ' ', '') + ',') > 0
                       OR CHARINDEX(',' + FullName + ',', ',' + REPLACE(TargetProgram, ' ', '') + ',') > 0)
             ))))
      AND (TargetYearLevel IS NULL OR @YearLevel IS NULL OR TargetYearLevel = @YearLevel))
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT -3; -- Student does not meet the event audience restrictions
    END
    ELSE
    BEGIN
        -- Default status right after registration is 'NoShow'
        INSERT INTO dbo.EventRegistrationTable (
            EventId, StudentId, CurrentYearLvl, CurrentSection, Status, CheckInTimestamp
        )
        VALUES (
            @EventId, @StudentId, @CurrentYearLvl, @CurrentSection, 'NoShow', NULL
        );

        DECLARE @NewId INT = CAST(SCOPE_IDENTITY() AS INT);

        UPDATE dbo.EventsTable
        SET CurrentRegistrations = CurrentRegistrations + 1
        WHERE EventId = @EventId;

        COMMIT TRANSACTION;
        SELECT @NewId;
    END
END;
GO

-- Source: RegistrationRepository.IsStudentRegistered / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_IsStudentRegistered
    @EventId INT,
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(1) 
    FROM dbo.EventRegistrationTable 
    WHERE EventId = @EventId 
      AND StudentId = @StudentId 
      AND Status != 'Cancelled';
END;
GO

-- Source: RegistrationRepository.GetRegistrationById / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_GetRegistrationById
    @EventRegistrationId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
           r.Status, r.CheckInTimestamp,
           e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
           e.EventPhotoPath,
           s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
           s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
           u.Email AS StudentEmail
    FROM dbo.EventRegistrationTable r
    INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
    INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
    LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE r.EventRegistrationId = @EventRegistrationId;
END;
GO

-- Source: RegistrationRepository.GetRegistrationsByStudent / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_GetRegistrationsByStudent
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
           r.Status, r.CheckInTimestamp,
           e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
           e.EventPhotoPath,
           s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
           s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
           u.Email AS StudentEmail
    FROM dbo.EventRegistrationTable r
    INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
    INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
    LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE r.StudentId = @StudentId
    ORDER BY e.EventStart DESC;
END;
GO

-- Source: RegistrationRepository.GetRegistrationsByEvent / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_GetRegistrationsByEvent
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
           r.Status, r.CheckInTimestamp,
           e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
           e.EventPhotoPath,
           s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
           s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
           u.Email AS StudentEmail
    FROM dbo.EventRegistrationTable r
    INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
    INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
    LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE r.EventId = @EventId
    ORDER BY r.EventRegistrationId ASC;
END;
GO

-- Source: RegistrationRepository.CheckInStudent / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_CheckInStudent
    @EventId INT,
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT EventRegistrationId FROM dbo.EventRegistrationTable
                    WHERE EventId = @EventId AND StudentId = @StudentId;
END;
GO

-- Source: RegistrationRepository.GetTotalPresentAttendees / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_GetTotalPresentAttendees
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE Status = 'Present';
END;
GO

-- Source: RegistrationRepository.GetEventAttendanceSummary / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_GetEventAttendanceSummary
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT 
        COUNT(CASE WHEN Status != 'Cancelled' THEN 1 END) AS TotalRegistered,
        COUNT(CASE WHEN Status = 'Present' THEN 1 END) AS TotalCheckedIn
    FROM dbo.EventRegistrationTable
    WHERE EventId = @EventId;
END;
GO

-- Source: RegistrationRepository.CancelRegistration / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_CancelRegistration
    @EventRegistrationId INT
AS
BEGIN
    SET NOCOUNT OFF;
    BEGIN TRANSACTION;

    DECLARE @EvtId INT, @CurStatus VARCHAR(50), @RegEnd DATETIME, @EventEnd DATETIME, @EvtStatus VARCHAR(50);

    SELECT @EvtId = r.EventId, 
           @CurStatus = r.Status, 
           @RegEnd = e.RegEnd, @EvtStatus = e.Status
    FROM dbo.EventRegistrationTable r WITH (UPDLOCK, HOLDLOCK)
    INNER JOIN dbo.EventsTable e WITH (UPDLOCK, HOLDLOCK) ON r.EventId = e.EventId
    WHERE r.EventRegistrationId = @EventRegistrationId;

    -- Strictly enforce: 
    -- 1. Status must be default 'NoShow' (cannot cancel if already 'Present' or 'Cancelled')
    -- 2. Current time must be within registration window (GETDATE() <= RegEnd)
    IF @EvtId IS NOT NULL AND @CurStatus = 'NoShow' AND GETDATE() <= @RegEnd AND @EvtStatus = 'Upcoming' AND EXISTS (SELECT 1 FROM dbo.EventsTable WHERE EventId = @EvtId AND EventEnd > GETDATE())
    BEGIN
        UPDATE dbo.EventRegistrationTable
        SET Status = 'Cancelled'
        WHERE EventRegistrationId = @EventRegistrationId;

        UPDATE dbo.EventsTable
        SET CurrentRegistrations = CASE 
                                    WHEN CurrentRegistrations > 0 THEN CurrentRegistrations - 1 
                                    ELSE 0 
                                   END
        WHERE EventId = @EvtId;

        COMMIT TRANSACTION;
        SELECT 1;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 0;
    END
END;
GO

-- Source: RegistrationRepository.AdminVoidRegistration / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_AdminVoidRegistration
    @EventRegistrationId INT
AS
BEGIN
    SET NOCOUNT OFF;
    BEGIN TRANSACTION;

    DECLARE @EvtId INT, @CurStatus VARCHAR(50);

    SELECT @EvtId = r.EventId, 
           @CurStatus = r.Status
    FROM dbo.EventRegistrationTable r WITH (UPDLOCK, HOLDLOCK)
    WHERE r.EventRegistrationId = @EventRegistrationId;

    IF @EvtId IS NOT NULL AND @CurStatus != 'Cancelled'
    BEGIN
        UPDATE dbo.EventRegistrationTable
        SET Status = 'Cancelled'
        WHERE EventRegistrationId = @EventRegistrationId;

        UPDATE dbo.EventsTable
        SET CurrentRegistrations = CASE 
                                    WHEN CurrentRegistrations > 0 THEN CurrentRegistrations - 1 
                                    ELSE 0 
                                   END
        WHERE EventId = @EvtId;

        COMMIT TRANSACTION;
        SELECT 1;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 0;
    END
END;
GO

-- Source: RegistrationRepository.GetRegistrationForScan / sqlTargetEvent
CREATE OR ALTER PROCEDURE dbo.usp_Registration_GetRegistrationForScan_sqlTargetEvent
    @EventId INT,
    @ParsedId INT,
    @Query VARCHAR(100)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT TOP 1 r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
           r.Status, r.CheckInTimestamp,
           e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
           e.EventPhotoPath,
           s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
           s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
           u.Email AS StudentEmail
    FROM dbo.EventRegistrationTable r
    INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
    INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
    LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE r.EventId = @EventId 
      AND (r.EventRegistrationId = @ParsedId OR r.StudentId = @Query OR u.Email = @Query);
END;
GO

-- Source: RegistrationRepository.GetRegistrationForScan / sqlAnyEvent
CREATE OR ALTER PROCEDURE dbo.usp_Registration_GetRegistrationForScan_sqlAnyEvent
    @ParsedId INT,
    @Query VARCHAR(100)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT TOP 1 r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
           r.Status, r.CheckInTimestamp,
           e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
           e.EventPhotoPath,
           s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
           s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
           u.Email AS StudentEmail
    FROM dbo.EventRegistrationTable r
    INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
    INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
    LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE (r.EventRegistrationId = @ParsedId OR r.StudentId = @Query OR u.Email = @Query)
    ORDER BY r.EventRegistrationId DESC;
END;
GO

-- Source: RegistrationRepository.ConfirmCheckIn / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_ConfirmCheckIn
    @EventRegistrationId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;

    DECLARE @CurStatus VARCHAR(50), @EventId INT, @EvtStatus VARCHAR(50), @EventEnd DATETIME;

    SELECT @CurStatus = Status, @EventId = EventId
    FROM dbo.EventRegistrationTable WITH (UPDLOCK, HOLDLOCK)
    WHERE EventRegistrationId = @EventRegistrationId;

    SELECT @EvtStatus = Status, @EventEnd = EventEnd FROM dbo.EventsTable WITH (UPDLOCK, HOLDLOCK)
    WHERE EventId = @EventId;

    IF @CurStatus IS NULL
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT -1; -- Not found
    END
    ELSE IF @EvtStatus IS NULL OR @EvtStatus <> 'Upcoming' OR GETDATE() >= @EventEnd
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT -4; -- Cancelled or inactive event
    END
    ELSE IF @CurStatus = 'Present'
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT -2; -- Already checked in
    END
    ELSE IF @CurStatus = 'Cancelled'
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT -3; -- Cancelled pass
    END
    ELSE
    BEGIN
        UPDATE dbo.EventRegistrationTable
        SET Status = 'Present',
            CheckInTimestamp = GETDATE()
        WHERE EventRegistrationId = @EventRegistrationId;

        COMMIT TRANSACTION;
        SELECT 1; -- Success
    END
END;
GO

-- Source: RegistrationRepository.GetCheckedInAttendees / sql
CREATE OR ALTER PROCEDURE dbo.usp_Registration_GetCheckedInAttendees
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
           r.Status, r.CheckInTimestamp,
           e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
           s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
           s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
           u.Email AS StudentEmail
    FROM dbo.EventRegistrationTable r
    INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
    INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
    LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE r.EventId = @EventId AND r.Status = 'Present'
    ORDER BY r.CheckInTimestamp DESC;
END;
GO
