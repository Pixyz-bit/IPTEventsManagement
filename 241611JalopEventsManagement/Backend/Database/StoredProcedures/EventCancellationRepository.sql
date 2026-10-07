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
