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
