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
