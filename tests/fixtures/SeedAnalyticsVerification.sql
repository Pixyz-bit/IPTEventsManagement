-- Synthetic analytics fixture. Run with sqlcmd -b -f 65001 -i this-file.sql.
-- Inserts only dedicated QA records. Re-running returns the existing fixture.
USE [UniversityEventDB];
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @Marker nvarchar(200) = N'[QA-ANALYTICS-VERIFICATION-V1]';
DECLARE @Title nvarchar(200) = N'QA - Analytics Verification';
DECLARE @EventId int, @AdminId int, @LockResult int;
DECLARE @Day datetime = CONVERT(datetime, '20261007', 112);

BEGIN TRY
    BEGIN TRANSACTION;
    EXEC @LockResult = sys.sp_getapplock @Resource = N'QA-ANALYTICS-VERIFICATION-V1',
        @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 5000;
    IF @LockResult < 0 THROW 51001, 'Unable to lock the QA fixture; no records changed.', 1;

    IF (SELECT COUNT(*) FROM dbo.EventsTable WHERE LEFT(Description, LEN(@Marker)) = @Marker) > 1
        THROW 51002, 'Multiple fixture events found; refusing to create another.', 1;
    SELECT @EventId = EventId FROM dbo.EventsTable WHERE LEFT(Description, LEN(@Marker)) = @Marker;
    IF @EventId IS NOT NULL
    BEGIN
        COMMIT TRANSACTION;
        SELECT @EventId AS EventId, N'Existing QA fixture retained; no records changed.' AS Result;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM dbo.EventsTable WHERE Title = @Title)
        OR EXISTS (SELECT 1 FROM dbo.StudentTable WHERE StudentId LIKE 'QA-ANALYTICS-%')
        OR EXISTS (SELECT 1 FROM dbo.UserTable WHERE Email LIKE N'qa.analytics.verify.%@example.invalid')
        THROW 51003, 'QA identifiers already exist outside the fixture; no records changed.', 1;

    SELECT TOP (1) @AdminId = UserId FROM dbo.UserTable WHERE Role = 'Admin' AND IsActive = 1 ORDER BY UserId;
    IF @AdminId IS NULL THROW 51004, 'An existing active administrator is required; no records changed.', 1;

    INSERT dbo.EventsTable (Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations,
        CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status,
        TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel)
    VALUES (@Title, @Marker + N' Synthetic analytics data: 100 fictional attendees; 60 present, 30 no-show, 10 cancelled. Safe to remove using CleanupAnalyticsVerification.sql.',
        N'QA Test Auditorium', 100, 90, @AdminId, DATEADD(hour, 9, @Day), DATEADD(hour, 11, @Day),
        DATEADD(hour, 9, DATEADD(day, -6, @Day)), DATEADD(second, 86399, DATEADD(day, -1, @Day)),
        'Completed', NULL, NULL, NULL, NULL);
    SET @EventId = CONVERT(int, SCOPE_IDENTITY());

    DECLARE @N int = 1, @UserId int, @Suffix varchar(3), @StudentId varchar(50),
        @Program nvarchar(100), @Department nvarchar(100), @BucketMinute int;
    WHILE @N <= 100
    BEGIN
        SET @Suffix = RIGHT('000' + CONVERT(varchar(3), @N), 3);
        SET @StudentId = 'QA-ANALYTICS-' + @Suffix;
        -- Inactive accounts with random, unusable credentials; no login passwords are distributed.
        INSERT dbo.UserTable (Email, PasswordHash, PasswordSalt, Role, IsActive)
        VALUES (N'qa.analytics.verify.' + @Suffix + N'@example.invalid',
            CONVERT(varchar(64), CRYPT_GEN_RANDOM(32), 2), CONVERT(varchar(64), CRYPT_GEN_RANDOM(32), 2), 'Student', 0);
        SET @UserId = CONVERT(int, SCOPE_IDENTITY());
        SET @Program = CASE WHEN (@N - 1) % 10 < 4 THEN N'BSIT'
            WHEN (@N - 1) % 10 < 7 THEN N'BSCS'
            WHEN (@N - 1) % 10 < 9 THEN N'BS Industrial Engineering' ELSE N'BS Accountancy' END;
        SET @Department = CASE WHEN (@N - 1) % 10 < 7 THEN N'College of Computer Studies'
            WHEN (@N - 1) % 10 < 9 THEN N'College of Engineering'
            ELSE N'College of Business Administration and Accountancy' END;
        INSERT dbo.StudentTable (StudentId, FirstName, MiddleName, LastName, Gender, CampusBranch, Department, Program, UserId, BirthDate)
        VALUES (@StudentId, N'QA Student', NULL, @Suffix,
            CASE WHEN @N % 2 = 0 THEN 'Female' ELSE 'Male' END,
            CASE (@N - 1) % 3 WHEN 0 THEN N'San Bartolome' WHEN 1 THEN N'Batasan' ELSE N'San Francisco' END,
            @Department, @Program, @UserId, CONVERT(date, '20050115', 112));

        SET @BucketMinute = CASE WHEN @N <= 5 THEN 0 WHEN @N <= 20 THEN 15
            WHEN @N <= 45 THEN 30 WHEN @N <= 55 THEN 60 ELSE 75 END;
        INSERT dbo.EventRegistrationTable (EventId, StudentId, CurrentYearLvl, CurrentSection, Status, CheckInTimestamp)
        VALUES (@EventId, @StudentId, (@N - 1) % 4 + 1, 'QA-' + CHAR(65 + (@N - 1) % 4),
            CASE WHEN @N <= 60 THEN 'Present' WHEN @N <= 90 THEN 'NoShow' ELSE 'Cancelled' END,
            CASE WHEN @N <= 60 THEN DATEADD(second, ((@N - 1) % 15) * 60 + (@N - 1) % 50,
                DATEADD(minute, @BucketMinute, DATEADD(hour, 9, @Day))) ELSE NULL END);
        SET @N += 1;
    END;
    INSERT dbo.SponsorListTable (SponsorName, CreatedAt, EventId)
    VALUES (N'QA Campus Partners', DATEADD(day, -6, @Day), @EventId),
        (N'QA Technology Club', DATEADD(day, -6, @Day), @EventId);

    IF (SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE EventId = @EventId) <> 100
        OR (SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE EventId = @EventId AND Status = 'Present') <> 60
        OR (SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE EventId = @EventId AND Status = 'NoShow') <> 30
        OR (SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE EventId = @EventId AND Status = 'Cancelled') <> 10
        THROW 51005, 'Unexpected fixture totals; all inserts rolled back.', 1;
    COMMIT TRANSACTION;
    SELECT @EventId AS EventId, @Title AS Title, 100 AS Attendees, 60 AS Present, 30 AS NoShow, 10 AS Cancelled;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
