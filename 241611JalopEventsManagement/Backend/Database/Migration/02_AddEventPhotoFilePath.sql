USE UniversityEventDB;
GO

-- ============================================================================
-- Migration 02: Add EventPhotoPath column to dbo.EventsTable
-- Allows persistent storage of uploaded promotional image / poster asset paths
-- ============================================================================

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'EventsTable' AND COLUMN_NAME = 'EventPhotoPath'
)
BEGIN
    ALTER TABLE dbo.EventsTable 
    ADD EventPhotoPath NVARCHAR(500) NULL;
    
    PRINT 'Column EventPhotoPath successfully added to dbo.EventsTable.';
END
ELSE
BEGIN
    PRINT 'Column EventPhotoPath already exists in dbo.EventsTable.';
END
GO
