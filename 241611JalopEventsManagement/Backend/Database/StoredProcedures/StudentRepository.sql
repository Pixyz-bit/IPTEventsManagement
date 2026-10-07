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

-- Source: StudentRepository.SaveManagedProfile / update
CREATE OR ALTER PROCEDURE dbo.usp_Student_SaveManagedProfile_update
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Gender VARCHAR(20),
    @CampusBranch NVARCHAR(100),
    @Department NVARCHAR(100),
    @Program NVARCHAR(100),
    @UserId INT,
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.StudentTable SET FirstName=@FirstName, MiddleName=@MiddleName,
                    LastName=@LastName, Gender=@Gender, CampusBranch=@CampusBranch, Department=@Department, Program=@Program
                    WHERE UserId=@UserId AND StudentId=@StudentId;
END;
GO

-- Source: StudentRepository.SaveManagedProfile / insert
CREATE OR ALTER PROCEDURE dbo.usp_Student_SaveManagedProfile_insert
    @StudentId VARCHAR(50),
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Gender VARCHAR(20),
    @CampusBranch NVARCHAR(100),
    @Department NVARCHAR(100),
    @Program NVARCHAR(100),
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    INSERT INTO dbo.StudentTable
                    (StudentId, FirstName, MiddleName, LastName, Gender, CampusBranch, Department, Program, UserId)
                    VALUES (@StudentId, @FirstName, @MiddleName, @LastName, @Gender, @CampusBranch, @Department, @Program, @UserId);
END;
GO

-- Source: StudentRepository.SaveManagedProfile / Command1
CREATE OR ALTER PROCEDURE dbo.usp_Student_SaveManagedProfile_Command1
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT StudentId FROM dbo.StudentTable WITH (UPDLOCK, HOLDLOCK) WHERE UserId = @UserId;
END;
GO

-- Source: StudentRepository.GetAllStudents / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetAllStudents
    @Search NVARCHAR(150) = NULL,
    @Department NVARCHAR(100) = NULL,
    @Program NVARCHAR(100) = NULL,
    @Status VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
                          s.CampusBranch, s.Department, s.Program, s.UserId, s.BirthDate,
                          u.Email, u.IsActive
                   FROM dbo.StudentTable s
                   INNER JOIN dbo.UserTable u ON s.UserId = u.UserId
                   WHERE 1=1
    AND (@Search IS NULL OR s.StudentId LIKE @Search OR s.FirstName LIKE @Search OR s.LastName LIKE @Search
         OR (s.FirstName+' '+s.LastName) LIKE @Search OR u.Email LIKE @Search)
    AND (@Department IS NULL OR s.Department=@Department)
    AND (@Program IS NULL OR s.Program=@Program)
    AND (@Status IS NULL OR (@Status='Active' AND u.IsActive=1) OR (@Status='Inactive' AND u.IsActive=0))
    ORDER BY s.StudentId ASC;
END;
GO

-- Source: StudentRepository.GetStudentById / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetStudentById
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
           s.CampusBranch, s.Department, s.Program, s.UserId, s.BirthDate,
           u.Email, u.IsActive
    FROM dbo.StudentTable s
    INNER JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE s.StudentId = @StudentId;
END;
GO

-- Source: StudentRepository.GetStudentByUserId / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetStudentByUserId
    @UserId INT
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
           s.CampusBranch, s.Department, s.Program, s.UserId, s.BirthDate,
           u.Email, u.IsActive
    FROM dbo.StudentTable s
    INNER JOIN dbo.UserTable u ON s.UserId = u.UserId
    WHERE s.UserId = @UserId;
END;
GO

-- Source: StudentRepository.CreateStudentWithAccount / checkSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_CreateStudentWithAccount_checkSql
    @Email NVARCHAR(150),
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    IF EXISTS (SELECT 1 FROM dbo.UserTable WHERE Email = @Email)
        SELECT 1;
    ELSE IF EXISTS (SELECT 1 FROM dbo.StudentTable WHERE StudentId = @StudentId)
        SELECT 2;
    ELSE
        SELECT 0;
END;
GO

-- Source: StudentRepository.CreateStudentWithAccount / insertUserSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_CreateStudentWithAccount_insertUserSql
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

-- Source: StudentRepository.CreateStudentWithAccount / insertStudentSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_CreateStudentWithAccount_insertStudentSql
    @StudentId VARCHAR(50),
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Gender VARCHAR(20),
    @CampusBranch NVARCHAR(100),
    @Department NVARCHAR(100),
    @Program NVARCHAR(100),
    @UserId INT,
    @BirthDate DATE
AS
BEGIN
    SET NOCOUNT OFF;
    INSERT INTO dbo.StudentTable (
        StudentId, FirstName, MiddleName, LastName, Gender, CampusBranch, 
        Department, Program, UserId, BirthDate
    )
    VALUES (
        @StudentId, @FirstName, @MiddleName, @LastName, @Gender, @CampusBranch, 
        @Department, @Program, @UserId, @BirthDate
    );
END;
GO

-- Source: StudentRepository.UpdateStudentFull / studentSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_UpdateStudentFull_studentSql
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Gender VARCHAR(20),
    @CampusBranch NVARCHAR(100),
    @Department NVARCHAR(100),
    @Program NVARCHAR(100),
    @BirthDate DATE,
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.StudentTable 
    SET FirstName = @FirstName,
        MiddleName = @MiddleName,
        LastName = @LastName,
        Gender = @Gender,
        CampusBranch = @CampusBranch,
        Department = @Department,
        Program = @Program,
        BirthDate = @BirthDate
    WHERE StudentId = @StudentId;
END;
GO

-- Source: StudentRepository.UpdateStudentFull / userSql
CREATE OR ALTER PROCEDURE dbo.usp_Student_UpdateStudentFull_userSql
    @Email NVARCHAR(150),
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable
    SET Email = @Email
    WHERE UserId = (SELECT UserId FROM dbo.StudentTable WHERE StudentId = @StudentId);
END;
GO

-- Source: StudentRepository.ToggleStudentStatus / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_ToggleStudentStatus
    @IsActive BIT,
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable 
    SET IsActive = @IsActive 
    WHERE UserId = (SELECT UserId FROM dbo.StudentTable WHERE StudentId = @StudentId);
END;
GO

-- Source: StudentRepository.ResetStudentPassword / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_ResetStudentPassword
    @PasswordHash VARCHAR(256),
    @PasswordSalt VARCHAR(128),
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    UPDATE dbo.UserTable 
    SET PasswordHash = @PasswordHash,
        PasswordSalt = @PasswordSalt
    WHERE UserId = (SELECT UserId FROM dbo.StudentTable WHERE StudentId = @StudentId);
END;
GO

-- Source: StudentRepository.StudentIdExists / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_StudentIdExists
    @StudentId VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(1) FROM dbo.StudentTable WHERE StudentId = @StudentId;
END;
GO

-- Source: StudentRepository.EmailExists / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_EmailExists
    @Email NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT COUNT(1) FROM dbo.UserTable WHERE Email = @Email;
END;
GO

-- Source: StudentRepository.GetDistinctDepartments / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetDistinctDepartments
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT DISTINCT Department FROM dbo.StudentTable WHERE Department IS NOT NULL AND Department <> '' ORDER BY Department ASC;
END;
GO

-- Source: StudentRepository.GetDistinctPrograms / sql
CREATE OR ALTER PROCEDURE dbo.usp_Student_GetDistinctPrograms
AS
BEGIN
    SET NOCOUNT OFF;
    SELECT DISTINCT Program FROM dbo.StudentTable WHERE Program IS NOT NULL AND Program <> '' ORDER BY Program ASC;
END;
GO
