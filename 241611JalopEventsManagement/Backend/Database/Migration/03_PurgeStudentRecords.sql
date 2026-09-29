-- ===============================================================================
-- Migration Script: Purge/Truncate Student Records Only (Preserve Admin Accounts)
-- Target Database: UniversityEventDB
-- Purpose:
--   Deletes all student profiles and student user accounts without affecting
--   Administrator accounts or admin-created campus events.
--   Respects foreign key dependencies by deleting downstream registrations first.
-- ===============================================================================

USE UniversityEventDB;
GO

SET NOCOUNT ON;

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '>> Starting student data purge transaction...';

    -- 1. Identify all student UserIds and StudentIds to be removed
    DECLARE @StudentUserIds TABLE (UserId INT PRIMARY KEY);
    DECLARE @StudentIds TABLE (StudentId VARCHAR(50) PRIMARY KEY);

    INSERT INTO @StudentUserIds (UserId)
    SELECT UserId 
    FROM dbo.UserTable 
    WHERE Role = 'Student' AND Role <> 'Admin';

    INSERT INTO @StudentIds (StudentId)
    SELECT s.StudentId 
    FROM dbo.StudentTable s
    INNER JOIN @StudentUserIds u ON s.UserId = u.UserId;

    -- 2. Delete downstream Event Registrations tied to these students
    --    (Must be deleted first to prevent FOREIGN KEY constraint violations)
    DELETE reg
    FROM dbo.EventRegistrationTable reg
    INNER JOIN @StudentIds s ON reg.StudentId = s.StudentId;

    DECLARE @DeletedRegistrationsCount INT = @@ROWCOUNT;
    PRINT '   [1/4] Removed ' + CAST(@DeletedRegistrationsCount AS VARCHAR(10)) + ' student event registration(s).';

    -- 3. Resynchronize CurrentRegistrations counter in EventsTable
    UPDATE e
    SET e.CurrentRegistrations = ISNULL(
        (SELECT COUNT(1) FROM dbo.EventRegistrationTable r WHERE r.EventId = e.EventId), 
        0
    )
    FROM dbo.EventsTable e;
    PRINT '   [2/4] Resynchronized event registration counters.';

    -- 4. Delete Student profiles from StudentTable
    DELETE s
    FROM dbo.StudentTable s
    INNER JOIN @StudentIds del ON s.StudentId = del.StudentId;

    DECLARE @DeletedStudentsCount INT = @@ROWCOUNT;
    PRINT '   [3/4] Removed ' + CAST(@DeletedStudentsCount AS VARCHAR(10)) + ' row(s) from StudentTable.';

    -- 5. Delete Student authentication accounts from UserTable (strictly Role = 'Student')
    DELETE u
    FROM dbo.UserTable u
    INNER JOIN @StudentUserIds del ON u.UserId = del.UserId
    WHERE u.Role = 'Student' AND u.Role <> 'Admin';

    DECLARE @DeletedUsersCount INT = @@ROWCOUNT;
    PRINT '   [4/4] Removed ' + CAST(@DeletedUsersCount AS VARCHAR(10)) + ' student row(s) from UserTable.';

    -- 6. Commit Transaction
    COMMIT TRANSACTION;
    PRINT '>> Student purge completed successfully.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT '>> ERROR ENCOUNTERED! Transaction rolled back.';
    END

    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrState INT = ERROR_STATE();
    RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
END CATCH;
GO

-- ===============================================================================
-- Verification / Audit Output
-- ===============================================================================
PRINT '';
PRINT '==================== AUDIT VERIFICATION ====================';
PRINT 'Remaining User Accounts (Admins):';
SELECT UserId, Email, Role, IsActive 
FROM dbo.UserTable;

PRINT 'Remaining Student Profiles:';
SELECT COUNT(1) AS [StudentTable_RowCount] 
FROM dbo.StudentTable;
GO
