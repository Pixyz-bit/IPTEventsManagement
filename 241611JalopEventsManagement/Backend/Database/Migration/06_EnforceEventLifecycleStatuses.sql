-- Run against the application's existing database. This migration preserves all records.
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF EXISTS (
    SELECT 1 FROM dbo.EventsTable
    WHERE NOT (
        (Status COLLATE Latin1_General_100_BIN2 = 'Upcoming' AND DATALENGTH(Status) = 8) OR
        (Status COLLATE Latin1_General_100_BIN2 = 'Cancelled' AND DATALENGTH(Status) = 9) OR
        (Status COLLATE Latin1_General_100_BIN2 = 'Completed' AND DATALENGTH(Status) = 9)))
    THROW 51000, 'Unsupported event statuses exist. Resolve them explicitly before applying this migration.', 1;

IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_EventsTable_Status' AND parent_object_id = OBJECT_ID('dbo.EventsTable'))
    ALTER TABLE dbo.EventsTable DROP CONSTRAINT CK_EventsTable_Status;

ALTER TABLE dbo.EventsTable WITH CHECK ADD CONSTRAINT CK_EventsTable_Status CHECK (
    (Status COLLATE Latin1_General_100_BIN2 = 'Upcoming' AND DATALENGTH(Status) = 8) OR
    (Status COLLATE Latin1_General_100_BIN2 = 'Cancelled' AND DATALENGTH(Status) = 9) OR
    (Status COLLATE Latin1_General_100_BIN2 = 'Completed' AND DATALENGTH(Status) = 9));

IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('dbo.EventsTable') AND parent_column_id = COLUMNPROPERTY(OBJECT_ID('dbo.EventsTable'), 'Status', 'ColumnId'))
    ALTER TABLE dbo.EventsTable ADD CONSTRAINT DF_EventsTable_Status DEFAULT 'Upcoming' FOR Status;

UPDATE dbo.EventsTable SET Status = 'Completed'
WHERE Status = 'Upcoming' AND EventEnd <= GETDATE();

COMMIT TRANSACTION;
