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

-- EventCancellationRepository
-- Source: EventCancellationRepository.CancelEvent / sql
CREATE OR ALTER PROCEDURE dbo.usp_EventCancellation_CancelEvent
    @Reason NVARCHAR(500),
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.EventsTable
    SET Status = 'Cancelled', CancellationReason = @Reason
    WHERE EventId = @EventId AND Status = 'Upcoming' AND EventEnd > GETDATE();
END;
GO

-- EventRepository
-- Source: EventRepository.SynchronizeCompletedEvents / Command1
CREATE OR ALTER PROCEDURE dbo.usp_Event_SynchronizeCompletedEvents_Command1
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.EventsTable SET Status = 'Completed'
    WHERE Status = 'Upcoming' AND EventEnd <= GETDATE();
END;
GO

-- Source: EventRepository.CreateEvent / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_CreateEvent
    @Title NVARCHAR(200),
    @Description NVARCHAR(MAX),
    @VenueLocation NVARCHAR(200),
    @MaxCapacity INT,
    @CreatedByUserId INT,
    @EventStart DATETIME,
    @EventEnd DATETIME,
    @RegStart DATETIME,
    @RegEnd DATETIME,
    @Status VARCHAR(50),
    @CancellationReason NVARCHAR(500),
    @TargetBranch NVARCHAR(100),
    @TargetDepartment NVARCHAR(100),
    @TargetProgram NVARCHAR(100),
    @TargetYearLevel INT,
    @EventPhotoPath NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT OFF;
    INSERT INTO dbo.EventsTable (
        Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
        CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
        CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
        EventPhotoPath
    )
    VALUES (
        @Title, @Description, @VenueLocation, @MaxCapacity, 0, 
        @CreatedByUserId, @EventStart, @EventEnd, @RegStart, @RegEnd, @Status, 
        @CancellationReason, @TargetBranch, @TargetDepartment, @TargetProgram, @TargetYearLevel,
        @EventPhotoPath
    );
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END;
GO

-- Source: EventRepository.GetEventById / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_GetEventById
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
           CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
           CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
           EventPhotoPath
    FROM dbo.EventsTable 
    WHERE EventId = @EventId;
END;
GO

-- Source: EventRepository.GetAllUpcomingEvents / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_GetAllUpcomingEvents
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
           CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
           CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
           EventPhotoPath
    FROM dbo.EventsTable 
    WHERE Status = 'Upcoming'
    ORDER BY EventStart ASC;
END;
GO

-- Source: EventRepository.GetAllEvents / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_GetAllEvents
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
           CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
           CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
           EventPhotoPath
    FROM dbo.EventsTable 
    ORDER BY EventStart DESC;
END;
GO

-- Source: EventRepository.GetEventsForStudent / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_GetEventsForStudent
    @Branch NVARCHAR(100),
    @Department NVARCHAR(100),
    @Program NVARCHAR(100),
    @YearLevel INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
           CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
           CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
           EventPhotoPath
    FROM dbo.EventsTable 
    WHERE Status = 'Upcoming'

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
      AND (TargetYearLevel IS NULL OR @YearLevel IS NULL OR TargetYearLevel = @YearLevel) ORDER BY EventStart ASC;
END;
GO

-- Source: EventRepository.GetRegistrationUnavailableReason / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_GetRegistrationUnavailableReason
    @StudentId VARCHAR(50),
    @EventId INT,
    @YearLevel INT
AS
BEGIN
    SET NOCOUNT OFF;
    DECLARE @Branch NVARCHAR(100), @Department NVARCHAR(100), @Program NVARCHAR(100), @StudentExists BIT = 0;
    SELECT @Branch = LTRIM(RTRIM(CampusBranch)), @Department = LTRIM(RTRIM(Department)),
           @Program = LTRIM(RTRIM(Program)), @StudentExists = 1
    FROM dbo.StudentTable WHERE StudentId = @StudentId;

    SELECT CASE
        WHEN Status = 'Cancelled' THEN 'This event has been cancelled. Registration is unavailable.'
        WHEN Status != 'Upcoming' OR GETDATE() >= EventEnd THEN 'This event has ended. Registration is closed.'
        WHEN GETDATE() < RegStart THEN 'Registration has not opened yet. Please return when registration opens.'
        WHEN GETDATE() > RegEnd THEN 'The registration deadline has passed. Registration is closed.'
        WHEN CurrentRegistrations >= MaxCapacity THEN 'This event is fully booked. No registration seats remain.'
        WHEN @StudentExists = 0 OR NOT EXISTS (
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
            THEN 'Your campus, college, program, or selected year does not meet this event''s audience requirements.'
        ELSE '' END
    FROM dbo.EventsTable WHERE EventId = @EventId;
END;
GO

-- Source: EventRepository.GetEventsCreatedByUser / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_GetEventsCreatedByUser
    @CreatedByUserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
           CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
           CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
           EventPhotoPath
    FROM dbo.EventsTable 
    WHERE CreatedByUserId = @CreatedByUserId
    ORDER BY EventStart DESC;
END;
GO

-- Source: EventRepository.UpdateEvent / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_UpdateEvent
    @Title NVARCHAR(200),
    @Description NVARCHAR(MAX),
    @VenueLocation NVARCHAR(200),
    @MaxCapacity INT,
    @EventStart DATETIME,
    @EventEnd DATETIME,
    @RegStart DATETIME,
    @RegEnd DATETIME,
    @TargetBranch NVARCHAR(100),
    @TargetDepartment NVARCHAR(100),
    @TargetProgram NVARCHAR(100),
    @TargetYearLevel INT,
    @EventPhotoPath NVARCHAR(500),
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.EventsTable 
    SET Title = @Title,
        Description = @Description,
        VenueLocation = @VenueLocation,
        MaxCapacity = @MaxCapacity,
        EventStart = @EventStart,
        EventEnd = @EventEnd,
        RegStart = @RegStart,
        RegEnd = @RegEnd,
        TargetBranch = @TargetBranch,
        TargetDepartment = @TargetDepartment,
        TargetProgram = @TargetProgram,
        TargetYearLevel = @TargetYearLevel,
        EventPhotoPath = @EventPhotoPath
    WHERE EventId = @EventId AND Status = 'Upcoming' AND EventEnd > GETDATE();
END;
GO

-- Source: EventRepository.IncrementRegistrationCount / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_IncrementRegistrationCount
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.EventsTable 
    SET CurrentRegistrations = CurrentRegistrations + 1 
    WHERE EventId = @EventId 
      AND CurrentRegistrations < MaxCapacity 
      AND Status = 'Upcoming' AND EventEnd > GETDATE();
END;
GO

-- Source: EventRepository.DecrementRegistrationCount / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_DecrementRegistrationCount
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.EventsTable 
    SET CurrentRegistrations = CurrentRegistrations - 1 
    WHERE EventId = @EventId 
      AND CurrentRegistrations > 0;
END;
GO

-- Source: EventRepository.GetHistoricalEvents / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_GetHistoricalEvents
    @Search NVARCHAR(200) = NULL,
    @OutcomeStatus VARCHAR(50) = NULL,
    @Semester NVARCHAR(20) = NULL,
    @StartYear INT = NULL,
    @EndYear INT = NULL
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT e.EventId, e.Title, e.Description, e.VenueLocation, e.MaxCapacity, e.CurrentRegistrations, 
                          e.CreatedByUserId, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status, 
                          e.CancellationReason, e.TargetBranch, e.TargetDepartment, e.TargetProgram, e.TargetYearLevel,
                          e.EventPhotoPath,
                          ISNULL(regStats.PreRegisteredCount, 0) AS PreRegisteredCount,
                          ISNULL(regStats.AttendedCount, 0) AS AttendedCount,
                          ISNULL(regStats.NoShowCount, 0) AS NoShowCount,
                          ISNULL(regStats.CancelledCount, 0) AS CancelledCount
                   FROM dbo.EventsTable e
                   LEFT JOIN (
                       SELECT EventId,
                              COUNT(CASE WHEN Status != 'Cancelled' THEN 1 END) AS PreRegisteredCount,
                              COUNT(CASE WHEN Status = 'Present' THEN 1 END) AS AttendedCount,
                              COUNT(CASE WHEN Status = 'NoShow' THEN 1 END) AS NoShowCount,
                              COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledCount
                       FROM dbo.EventRegistrationTable
                       GROUP BY EventId
                   ) regStats ON e.EventId = regStats.EventId
                   WHERE e.Status IN ('Completed', 'Cancelled')
    AND (@Search IS NULL OR e.Title LIKE @Search OR e.VenueLocation LIKE @Search
         OR e.TargetDepartment LIKE @Search OR e.TargetProgram LIKE @Search)
    AND (@OutcomeStatus IS NULL OR e.Status=@OutcomeStatus)
    AND (@Semester IS NULL OR (@Semester='1st' AND MONTH(e.EventStart) BETWEEN 8 AND 12)
         OR (@Semester='2nd' AND MONTH(e.EventStart) BETWEEN 1 AND 5)
         OR (@Semester='Summer' AND MONTH(e.EventStart) BETWEEN 6 AND 7))
    AND (@StartYear IS NULL OR @EndYear IS NULL OR (MONTH(e.EventStart)>=8 AND YEAR(e.EventStart)=@StartYear)
         OR (MONTH(e.EventStart)<8 AND YEAR(e.EventStart)=@EndYear))
    ORDER BY e.EventStart DESC;
END;
GO

-- Source: EventRepository.GetDistinctHistoricalAcademicYears / sql
CREATE OR ALTER PROCEDURE dbo.usp_Event_GetDistinctHistoricalAcademicYears
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT DISTINCT YEAR(EventStart) AS EvtYear, MONTH(EventStart) AS EvtMonth
    FROM dbo.EventsTable
    WHERE Status IN ('Completed', 'Cancelled')
    ORDER BY EvtYear DESC;
END;
GO

-- RegistrationRepository
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

-- SponsorRepository
-- Source: SponsorRepository.GetSponsorsByEventId / sql
CREATE OR ALTER PROCEDURE dbo.usp_Sponsor_GetSponsorsByEventId
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT s.SponsorEntryId, s.SponsorName, s.CreatedAt, s.EventId, e.Title AS EventTitle
    FROM dbo.SponsorListTable s
    INNER JOIN dbo.EventsTable e ON s.EventId = e.EventId
    WHERE s.EventId = @EventId
    ORDER BY s.SponsorEntryId ASC;
END;
GO

-- Source: SponsorRepository.GetSponsorsForEvents / sql
CREATE OR ALTER PROCEDURE dbo.usp_Sponsor_GetSponsorsForEvents
    @EventIds NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT EventId,SponsorName FROM dbo.SponsorListTable
    WHERE EventId IN (
        SELECT TRY_CONVERT(INT,T.N.value('.','nvarchar(20)'))
        FROM (SELECT CONVERT(XML,'<i>'+REPLACE(@EventIds,',','</i><i>')+'</i>') AS Ids) X
        CROSS APPLY X.Ids.nodes('/i') T(N)
    )
    ORDER BY SponsorEntryId ASC;
END;
GO

-- Source: SponsorRepository.AddSponsor / sql
CREATE OR ALTER PROCEDURE dbo.usp_Sponsor_AddSponsor
    @SponsorName NVARCHAR(150),
    @CreatedAt DATETIME,
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    INSERT INTO dbo.SponsorListTable (SponsorName, CreatedAt, EventId)
    VALUES (@SponsorName, @CreatedAt, @EventId);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END;
GO

-- Source: SponsorRepository.DeleteSponsor / sql
CREATE OR ALTER PROCEDURE dbo.usp_Sponsor_DeleteSponsor
    @SponsorEntryId INT
AS
BEGIN
    SET NOCOUNT OFF;
    DELETE FROM dbo.SponsorListTable WHERE SponsorEntryId = @SponsorEntryId;
END;
GO

-- Source: SponsorRepository.DeleteSponsorsByEventId / sql
CREATE OR ALTER PROCEDURE dbo.usp_Sponsor_DeleteSponsorsByEventId
    @EventId INT
AS
BEGIN
    SET NOCOUNT OFF;
    DELETE FROM dbo.SponsorListTable WHERE EventId = @EventId;
END;
GO

-- StudentRepository
-- Source: StudentRepository.SaveManagedProfile / update
CREATE OR ALTER PROCEDURE dbo.usp_Student_SaveManagedProfile_update
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Gender VARCHAR(20),
    @CampusBranch NVARCHAR(100),
    @Department NVARCHAR(100),
    @Program NVARCHAR(100),
    @UserId INT,
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.StudentTable SET FirstName=@FirstName, MiddleName=@MiddleName,
                    LastName=@LastName, Gender=@Gender, CampusBranch=@CampusBranch, Department=@Department, Program=@Program
                    WHERE UserId=@UserId AND StudentId=@StudentId;
END;
GO

-- Source: StudentRepository.SaveManagedProfile / insert
CREATE OR ALTER PROCEDURE dbo.usp_Student_SaveManagedProfile_insert
    @StudentId VARCHAR(50),
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Gender VARCHAR(20),
    @CampusBranch NVARCHAR(100),
    @Department NVARCHAR(100),
    @Program NVARCHAR(100),
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    INSERT INTO dbo.StudentTable
                    (StudentId, FirstName, MiddleName, LastName, Gender, CampusBranch, Department, Program, UserId)
                    VALUES (@StudentId, @FirstName, @MiddleName, @LastName, @Gender, @CampusBranch, @Department, @Program, @UserId);
END;
GO

-- Source: StudentRepository.SaveManagedProfile / Command1
CREATE OR ALTER PROCEDURE dbo.usp_Student_SaveManagedProfile_Command1
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT StudentId FROM dbo.StudentTable WITH (UPDLOCK, HOLDLOCK) WHERE UserId = @UserId;
END;
GO

-- Source: StudentRepository.GetAllStudents / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetAllStudents
    @Search NVARCHAR(150) = NULL,
    @Department NVARCHAR(100) = NULL,
    @Program NVARCHAR(100) = NULL,
    @Status VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
                          s.CampusBranch, s.Department, s.Program, s.UserId, s.BirthDate,
                          u.Email, u.IsActive
                   FROM dbo.StudentTable s
                   INNER JOIN dbo.UserTable u ON s.UserId = u.UserId
                   WHERE 1=1
    AND (@Search IS NULL OR s.StudentId LIKE @Search OR s.FirstName LIKE @Search OR s.LastName LIKE @Search
         OR (s.FirstName+' '+s.LastName) LIKE @Search OR u.Email LIKE @Search)
    AND (@Department IS NULL OR s.Department=@Department)
    AND (@Program IS NULL OR s.Program=@Program)
    AND (@Status IS NULL OR (@Status='Active' AND u.IsActive=1) OR (@Status='Inactive' AND u.IsActive=0))
    ORDER BY s.StudentId ASC;
END;
GO

-- Source: StudentRepository.GetStudentById / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetStudentById
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
           s.CampusBranch, s.Department, s.Program, s.UserId, s.BirthDate,
           u.Email, u.IsActive
    FROM dbo.StudentTable s
    INNER JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE s.StudentId = @StudentId;
END;
GO

-- Source: StudentRepository.GetStudentByUserId / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetStudentByUserId
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
           s.CampusBranch, s.Department, s.Program, s.UserId, s.BirthDate,
           u.Email, u.IsActive
    FROM dbo.StudentTable s
    INNER JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE s.UserId = @UserId;
END;
GO

-- Source: StudentRepository.CreateStudentWithAccount / checkSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_CreateStudentWithAccount_checkSql
    @Email NVARCHAR(150),
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    IF EXISTS (SELECT 1 FROM dbo.UserTable WHERE Email = @Email)
        SELECT 1;
    ELSE IF EXISTS (SELECT 1 FROM dbo.StudentTable WHERE StudentId = @StudentId)
        SELECT 2;
    ELSE
        SELECT 0;
END;
GO

-- Source: StudentRepository.CreateStudentWithAccount / insertUserSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_CreateStudentWithAccount_insertUserSql
    @Email NVARCHAR(150),
    @PasswordHash VARCHAR(256),
    @PasswordSalt VARCHAR(128),
    @Role VARCHAR(50),
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT OFF;
    INSERT INTO dbo.UserTable (Email, PasswordHash, PasswordSalt, Role, IsActive)
    VALUES (@Email, @PasswordHash, @PasswordSalt, @Role, @IsActive);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END;
GO

-- Source: StudentRepository.CreateStudentWithAccount / insertStudentSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_CreateStudentWithAccount_insertStudentSql
    @StudentId VARCHAR(50),
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Gender VARCHAR(20),
    @CampusBranch NVARCHAR(100),
    @Department NVARCHAR(100),
    @Program NVARCHAR(100),
    @UserId INT,
    @BirthDate DATE
AS
BEGIN
    SET NOCOUNT OFF;
    INSERT INTO dbo.StudentTable (
        StudentId, FirstName, MiddleName, LastName, Gender, CampusBranch, 
        Department, Program, UserId, BirthDate
    )
    VALUES (
        @StudentId, @FirstName, @MiddleName, @LastName, @Gender, @CampusBranch, 
        @Department, @Program, @UserId, @BirthDate
    );
END;
GO

-- Source: StudentRepository.UpdateStudentFull / studentSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_UpdateStudentFull_studentSql
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Gender VARCHAR(20),
    @CampusBranch NVARCHAR(100),
    @Department NVARCHAR(100),
    @Program NVARCHAR(100),
    @BirthDate DATE,
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.StudentTable 
    SET FirstName = @FirstName,
        MiddleName = @MiddleName,
        LastName = @LastName,
        Gender = @Gender,
        CampusBranch = @CampusBranch,
        Department = @Department,
        Program = @Program,
        BirthDate = @BirthDate
    WHERE StudentId = @StudentId;
END;
GO

-- Source: StudentRepository.UpdateStudentFull / userSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_UpdateStudentFull_userSql
    @Email NVARCHAR(150),
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable
    SET Email = @Email
    WHERE UserId = (SELECT UserId FROM dbo.StudentTable WHERE StudentId = @StudentId);
END;
GO

-- Source: StudentRepository.ToggleStudentStatus / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_ToggleStudentStatus
    @IsActive BIT,
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable 
    SET IsActive = @IsActive 
    WHERE UserId = (SELECT UserId FROM dbo.StudentTable WHERE StudentId = @StudentId);
END;
GO

-- Source: StudentRepository.ResetStudentPassword / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_ResetStudentPassword
    @PasswordHash VARCHAR(256),
    @PasswordSalt VARCHAR(128),
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable 
    SET PasswordHash = @PasswordHash,
        PasswordSalt = @PasswordSalt
    WHERE UserId = (SELECT UserId FROM dbo.StudentTable WHERE StudentId = @StudentId);
END;
GO

-- Source: StudentRepository.StudentIdExists / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_StudentIdExists
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(1) FROM dbo.StudentTable WHERE StudentId = @StudentId;
END;
GO

-- Source: StudentRepository.EmailExists / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_EmailExists
    @Email NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(1) FROM dbo.UserTable WHERE Email = @Email;
END;
GO

-- Source: StudentRepository.GetDistinctDepartments / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetDistinctDepartments
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT DISTINCT Department FROM dbo.StudentTable WHERE Department IS NOT NULL AND Department <> '' ORDER BY Department ASC;
END;
GO

-- Source: StudentRepository.GetDistinctPrograms / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetDistinctPrograms
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT DISTINCT Program FROM dbo.StudentTable WHERE Program IS NOT NULL AND Program <> '' ORDER BY Program ASC;
END;
GO

-- UserRepository
-- Source: UserRepository.SaveManagedAccount / Command1
CREATE OR ALTER PROCEDURE dbo.usp_User_SaveManagedAccount_Command1
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT UserId, Role, IsActive FROM dbo.UserTable WITH (UPDLOCK, HOLDLOCK)
    ORDER BY UserId;
END;
GO

-- Source: UserRepository.SaveManagedAccount / Command2
CREATE OR ALTER PROCEDURE dbo.usp_User_SaveManagedAccount_Command2
    @Email NVARCHAR(150),
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(1) FROM dbo.UserTable WHERE Email = @Email AND UserId <> @UserId;
END;
GO

-- Source: UserRepository.SaveManagedAccount / Command3
CREATE OR ALTER PROCEDURE dbo.usp_User_SaveManagedAccount_Command3
    @Email NVARCHAR(150),
    @Role VARCHAR(50),
    @IsActive BIT,
    @Hash VARCHAR(256),
    @Salt VARCHAR(128),
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable SET Email = @Email, Role = @Role, IsActive = @IsActive,
        PasswordHash = CASE WHEN @Hash IS NULL THEN PasswordHash ELSE @Hash END,
        PasswordSalt = CASE WHEN @Salt IS NULL THEN PasswordSalt ELSE @Salt END
    WHERE UserId = @UserId;
END;
GO

-- Source: UserRepository.GetUserByEmail / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_GetUserByEmail
    @Email NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT UserId, Email, PasswordHash, PasswordSalt, Role, IsActive 
    FROM dbo.UserTable 
    WHERE Email = @Email;
END;
GO

-- Source: UserRepository.GetUserByIdentifier / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_GetUserByIdentifier
    @Identifier NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT u.UserId, u.Email, u.PasswordHash, u.PasswordSalt, u.Role, u.IsActive,
           s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, s.CampusBranch, s.Department, s.Program
    FROM dbo.UserTable u
    LEFT JOIN dbo.StudentTable s ON u.UserId = s.UserId
    WHERE u.Email = @Identifier OR s.StudentId = @Identifier;
END;
GO

-- Source: UserRepository.GetUserById / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_GetUserById
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT UserId, Email, PasswordHash, PasswordSalt, Role, IsActive 
    FROM dbo.UserTable 
    WHERE UserId = @UserId;
END;
GO

-- Source: UserRepository.CreateUser / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_CreateUser
    @Email NVARCHAR(150),
    @PasswordHash VARCHAR(256),
    @PasswordSalt VARCHAR(128),
    @Role VARCHAR(50),
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT OFF;
    INSERT INTO dbo.UserTable (Email, PasswordHash, PasswordSalt, Role, IsActive)
    VALUES (@Email, @PasswordHash, @PasswordSalt, @Role, @IsActive);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END;
GO

-- Source: UserRepository.EmailExists / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_EmailExists
    @Email NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(1) FROM dbo.UserTable WHERE Email = @Email;
END;
GO

-- Source: UserRepository.UpdateUserEmail / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_UpdateUserEmail
    @Email NVARCHAR(150),
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable SET Email = @Email WHERE UserId = @UserId;
END;
GO

-- Source: UserRepository.UpdateUserStatus / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_UpdateUserStatus
    @IsActive BIT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable SET IsActive = @IsActive WHERE UserId = @UserId;
END;
GO

-- Source: UserRepository.UpdatePassword / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_UpdatePassword
    @PasswordHash VARCHAR(256),
    @PasswordSalt VARCHAR(128),
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable 
    SET PasswordHash = @PasswordHash, PasswordSalt = @PasswordSalt 
    WHERE UserId = @UserId;
END;
GO

-- Source: UserRepository.GetAllUsers / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_GetAllUsers
    @Search NVARCHAR(150) = NULL,
    @Role VARCHAR(50) = NULL,
    @Status VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT u.UserId, u.Email, u.PasswordHash, u.PasswordSalt, u.Role, u.IsActive,
                          s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
                          s.CampusBranch, s.Department, s.Program
                   FROM dbo.UserTable u
                   LEFT JOIN dbo.StudentTable s ON u.UserId = s.UserId
                   WHERE 1=1
    AND (@Search IS NULL OR u.Email LIKE @Search OR s.StudentId LIKE @Search OR s.FirstName LIKE @Search
         OR s.LastName LIKE @Search OR (s.FirstName+' '+s.LastName) LIKE @Search)
    AND (@Role IS NULL OR u.Role=@Role)
    AND (@Status IS NULL OR (@Status='Active' AND u.IsActive=1) OR (@Status='Inactive' AND u.IsActive=0))
    ORDER BY u.UserId DESC;
END;
GO

-- Source: UserRepository.UpdateUserRole / countAdminsSql
CREATE OR ALTER PROCEDURE dbo.usp_User_UpdateUserRole_countAdminsSql
    @TargetUserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(1) FROM dbo.UserTable WHERE Role = 'Admin' AND IsActive = 1 AND UserId != @TargetUserId;
END;
GO

-- Source: UserRepository.UpdateUserRole / updateSql
CREATE OR ALTER PROCEDURE dbo.usp_User_UpdateUserRole_updateSql
    @Role VARCHAR(50),
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable SET Role = @Role WHERE UserId = @UserId;
END;
GO

-- Source: UserRepository.ToggleUserActiveStatus / countSql
CREATE OR ALTER PROCEDURE dbo.usp_User_ToggleUserActiveStatus_countSql
    @TargetUserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(1) FROM dbo.UserTable WHERE Role = 'Admin' AND IsActive = 1 AND UserId != @TargetUserId;
END;
GO

-- Source: UserRepository.ToggleUserActiveStatus / toggleSql
CREATE OR ALTER PROCEDURE dbo.usp_User_ToggleUserActiveStatus_toggleSql
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE UserId = @UserId;
END;
GO

-- Source: UserRepository.GetAccountStatistics / sql
CREATE OR ALTER PROCEDURE dbo.usp_User_GetAccountStatistics
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT 
        COUNT(1) AS TotalAccounts,
        COUNT(CASE WHEN Role = 'Admin' AND IsActive = 1 THEN 1 END) AS ActiveAdmins,
        COUNT(CASE WHEN Role = 'Student' THEN 1 END) AS TotalStudents,
        COUNT(CASE WHEN IsActive = 0 THEN 1 END) AS LockedAccounts
    FROM dbo.UserTable;
END;
GO
