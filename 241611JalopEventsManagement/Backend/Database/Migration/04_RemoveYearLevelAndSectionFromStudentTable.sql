-- ===============================================================================
-- Migration Script: 04_RemoveYearLevelAndSectionFromStudentTable.sql
-- Target Database: UniversityEventDB
-- Purpose:
--   Safely removes 'YearLevel' and 'Section' columns from dbo.StudentTable
--   if they exist in the live database schema.
--   Preserves core student identity columns (StudentId, FirstName, MiddleName,
--   LastName, Gender, CampusBranch, Department, Program, UserId).
-- ===============================================================================

USE UniversityEventDB;
GO

SET NOCOUNT ON;

PRINT '>> Checking dbo.StudentTable schema for YearLevel and Section columns...';

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Check and drop any default constraints associated with 'YearLevel'
    DECLARE @YearLevelConstraint NVARCHAR(128);
    SELECT @YearLevelConstraint = dc.name
    FROM sys.default_constraints dc
    INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    WHERE dc.parent_object_id = OBJECT_ID('dbo.StudentTable') AND c.name = 'YearLevel';

    IF @YearLevelConstraint IS NOT NULL
    BEGIN
        EXEC('ALTER TABLE dbo.StudentTable DROP CONSTRAINT ' + @YearLevelConstraint + ';');
        PRINT '   [1/4] Dropped default constraint on YearLevel: ' + @YearLevelConstraint;
    END

    -- 2. Check and drop any default constraints associated with 'Section'
    DECLARE @SectionConstraint NVARCHAR(128);
    SELECT @SectionConstraint = dc.name
    FROM sys.default_constraints dc
    INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    WHERE dc.parent_object_id = OBJECT_ID('dbo.StudentTable') AND c.name = 'Section';

    IF @SectionConstraint IS NOT NULL
    BEGIN
        EXEC('ALTER TABLE dbo.StudentTable DROP CONSTRAINT ' + @SectionConstraint + ';');
        PRINT '   [2/4] Dropped default constraint on Section: ' + @SectionConstraint;
    END

    -- 3. Drop 'YearLevel' column if it exists in dbo.StudentTable
    IF EXISTS (
        SELECT 1 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'dbo' 
          AND TABLE_NAME = 'StudentTable' 
          AND COLUMN_NAME = 'YearLevel'
    )
    BEGIN
        ALTER TABLE dbo.StudentTable DROP COLUMN YearLevel;
        PRINT '   [3/4] Successfully removed YearLevel column from dbo.StudentTable.';
    END
    ELSE
    BEGIN
        PRINT '   [3/4] YearLevel column does not exist in dbo.StudentTable (Skipped).';
    END

    -- 4. Drop 'Section' column if it exists in dbo.StudentTable
    IF EXISTS (
        SELECT 1 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'dbo' 
          AND TABLE_NAME = 'StudentTable' 
          AND COLUMN_NAME = 'Section'
    )
    BEGIN
        ALTER TABLE dbo.StudentTable DROP COLUMN Section;
        PRINT '   [4/4] Successfully removed Section column from dbo.StudentTable.';
    END
    ELSE
    BEGIN
        PRINT '   [4/4] Section column does not exist in dbo.StudentTable (Skipped).';
    END

    COMMIT TRANSACTION;
    PRINT '>> Migration 04 completed successfully. dbo.StudentTable aligns with core identity schema.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT '!! Migration failed. Transaction rolled back.';
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO

-- ===============================================================================
-- Verification Query: Show remaining columns in dbo.StudentTable
-- ===============================================================================
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'StudentTable'
ORDER BY ORDINAL_POSITION;
GO
