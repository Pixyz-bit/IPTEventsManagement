-- Removes only the dedicated fixture created by SeedAnalyticsVerification.sql.
-- Run manually when finished: sqlcmd -S localhost -E -b -f 65001 -i this-file.sql
USE [UniversityEventDB];
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @Marker nvarchar(200) = N'[QA-ANALYTICS-VERIFICATION-V1]';
DECLARE @EventId int, @LockResult int;
DECLARE @Students TABLE (StudentId varchar(50) PRIMARY KEY, UserId int UNIQUE);
BEGIN TRY
    BEGIN TRANSACTION;
    EXEC @LockResult = sys.sp_getapplock @Resource = N'QA-ANALYTICS-VERIFICATION-V1',
        @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 5000;
    IF @LockResult < 0 THROW 51101, 'Unable to lock the QA fixture; nothing deleted.', 1;
    IF (SELECT COUNT(*) FROM dbo.EventsTable WHERE LEFT(Description, LEN(@Marker)) = @Marker) > 1
        THROW 51102, 'Multiple fixture events found; nothing deleted.', 1;
    SELECT @EventId = EventId FROM dbo.EventsTable WHERE LEFT(Description, LEN(@Marker)) = @Marker;
    IF @EventId IS NULL
    BEGIN
        COMMIT TRANSACTION;
        PRINT 'No analytics verification fixture found; nothing deleted.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM dbo.EventsTable WHERE EventId = @EventId AND Title = N'QA - Analytics Verification')
        THROW 51103, 'The fixture title was changed; review it before cleanup. Nothing deleted.', 1;

    INSERT @Students (StudentId, UserId)
    SELECT s.StudentId, s.UserId FROM dbo.EventRegistrationTable r
    JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
    JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE r.EventId = @EventId AND s.StudentId LIKE 'QA-ANALYTICS-[0-9][0-9][0-9]'
        AND TRY_CONVERT(int, RIGHT(s.StudentId, 3)) BETWEEN 1 AND 100
        AND u.Email = N'qa.analytics.verify.' + RIGHT(s.StudentId, 3) + N'@example.invalid'
        AND u.Role = 'Student' AND u.IsActive = 0;
    IF (SELECT COUNT(*) FROM @Students) <> 100
        OR (SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE EventId = @EventId) <> 100
        THROW 51104, 'Fixture identities or attendees changed; nothing deleted.', 1;
    IF EXISTS (SELECT 1 FROM dbo.EventRegistrationTable r JOIN @Students s ON r.StudentId = s.StudentId WHERE r.EventId <> @EventId)
        OR EXISTS (SELECT 1 FROM dbo.EventsTable e JOIN @Students s ON e.CreatedByUserId = s.UserId)
        OR EXISTS (SELECT 1 FROM dbo.StudentTable s JOIN @Students owned ON s.UserId = owned.UserId WHERE s.StudentId <> owned.StudentId)
        THROW 51105, 'QA accounts have records outside this fixture; nothing deleted.', 1;

    DELETE dbo.EventRegistrationTable WHERE EventId = @EventId;
    DELETE dbo.SponsorListTable WHERE EventId = @EventId;
    DELETE dbo.EventsTable WHERE EventId = @EventId;
    DELETE s FROM dbo.StudentTable s JOIN @Students owned ON s.StudentId = owned.StudentId;
    DELETE u FROM dbo.UserTable u JOIN @Students owned ON u.UserId = owned.UserId;
    COMMIT TRANSACTION;
    SELECT @EventId AS RemovedEventId, 100 AS RemovedSyntheticStudents, 100 AS RemovedInactiveAccounts;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
