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
