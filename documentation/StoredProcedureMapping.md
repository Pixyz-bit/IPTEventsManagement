# Stored procedure mapping

All business repository query calls now use these procedures with `CommandType.StoredProcedure`. C# checks, hashing, result mapping and transaction boundaries remain. Install `00_InstallAll.sql` before running this application version.

| Repository method | Query | Procedure | Parameters |
|---|---|---|---|
| `EventCancellationRepository.CancelEvent` | `sql` | `dbo.usp_EventCancellation_CancelEvent` | `@Reason NVARCHAR(500), @EventId INT` |
| `EventRepository.CreateEvent` | `sql` | `dbo.usp_Event_CreateEvent` | `@Title NVARCHAR(200), @Description NVARCHAR(MAX), @VenueLocation NVARCHAR(200), @MaxCapacity INT, @CreatedByUserId INT, @EventStart DATETIME, @EventEnd DATETIME, @RegStart DATETIME, @RegEnd DATETIME, @Status VARCHAR(50), @CancellationReason NVARCHAR(500), @TargetBranch NVARCHAR(100), @TargetDepartment NVARCHAR(100), @TargetProgram NVARCHAR(100), @TargetYearLevel INT, @EventPhotoPath NVARCHAR(500)` |
| `EventRepository.DecrementRegistrationCount` | `sql` | `dbo.usp_Event_DecrementRegistrationCount` | `@EventId INT` |
| `EventRepository.GetAllEvents` | `sql` | `dbo.usp_Event_GetAllEvents` | `` |
| `EventRepository.GetAllUpcomingEvents` | `sql` | `dbo.usp_Event_GetAllUpcomingEvents` | `` |
| `EventRepository.GetDistinctHistoricalAcademicYears` | `sql` | `dbo.usp_Event_GetDistinctHistoricalAcademicYears` | `` |
| `EventRepository.GetEventById` | `sql` | `dbo.usp_Event_GetEventById` | `@EventId INT` |
| `EventRepository.GetEventsCreatedByUser` | `sql` | `dbo.usp_Event_GetEventsCreatedByUser` | `@CreatedByUserId INT` |
| `EventRepository.GetEventsForStudent` | `sql` | `dbo.usp_Event_GetEventsForStudent` | `@Branch NVARCHAR(100), @Department NVARCHAR(100), @Program NVARCHAR(100), @YearLevel INT` |
| `EventRepository.GetHistoricalEvents` | `sql` | `dbo.usp_Event_GetHistoricalEvents` | `@Search NVARCHAR(200) = NULL, @OutcomeStatus VARCHAR(50) = NULL, @Semester NVARCHAR(20) = NULL, @StartYear INT = NULL, @EndYear INT = NULL` |
| `EventRepository.GetRegistrationUnavailableReason` | `sql` | `dbo.usp_Event_GetRegistrationUnavailableReason` | `@StudentId VARCHAR(50), @EventId INT, @YearLevel INT` |
| `EventRepository.IncrementRegistrationCount` | `sql` | `dbo.usp_Event_IncrementRegistrationCount` | `@EventId INT` |
| `EventRepository.SynchronizeCompletedEvents` | `Command1` | `dbo.usp_Event_SynchronizeCompletedEvents_Command1` | `` |
| `EventRepository.UpdateEvent` | `sql` | `dbo.usp_Event_UpdateEvent` | `@Title NVARCHAR(200), @Description NVARCHAR(MAX), @VenueLocation NVARCHAR(200), @MaxCapacity INT, @EventStart DATETIME, @EventEnd DATETIME, @RegStart DATETIME, @RegEnd DATETIME, @TargetBranch NVARCHAR(100), @TargetDepartment NVARCHAR(100), @TargetProgram NVARCHAR(100), @TargetYearLevel INT, @EventPhotoPath NVARCHAR(500), @EventId INT` |
| `RegistrationRepository.AdminVoidRegistration` | `sql` | `dbo.usp_Registration_AdminVoidRegistration` | `@EventRegistrationId INT` |
| `RegistrationRepository.CancelRegistration` | `sql` | `dbo.usp_Registration_CancelRegistration` | `@EventRegistrationId INT` |
| `RegistrationRepository.CheckInStudent` | `sql` | `dbo.usp_Registration_CheckInStudent` | `@EventId INT, @StudentId VARCHAR(50)` |
| `RegistrationRepository.ConfirmCheckIn` | `sql` | `dbo.usp_Registration_ConfirmCheckIn` | `@EventRegistrationId INT` |
| `RegistrationRepository.GetCheckedInAttendees` | `sql` | `dbo.usp_Registration_GetCheckedInAttendees` | `@EventId INT` |
| `RegistrationRepository.GetEventAttendanceSummary` | `sql` | `dbo.usp_Registration_GetEventAttendanceSummary` | `@EventId INT` |
| `RegistrationRepository.GetRegistrationById` | `sql` | `dbo.usp_Registration_GetRegistrationById` | `@EventRegistrationId INT` |
| `RegistrationRepository.GetRegistrationForScan` | `sqlAnyEvent` | `dbo.usp_Registration_GetRegistrationForScan_sqlAnyEvent` | `@ParsedId INT, @Query VARCHAR(100)` |
| `RegistrationRepository.GetRegistrationForScan` | `sqlTargetEvent` | `dbo.usp_Registration_GetRegistrationForScan_sqlTargetEvent` | `@EventId INT, @ParsedId INT, @Query VARCHAR(100)` |
| `RegistrationRepository.GetRegistrationsByEvent` | `sql` | `dbo.usp_Registration_GetRegistrationsByEvent` | `@EventId INT` |
| `RegistrationRepository.GetRegistrationsByStudent` | `sql` | `dbo.usp_Registration_GetRegistrationsByStudent` | `@StudentId VARCHAR(50)` |
| `RegistrationRepository.GetTotalPresentAttendees` | `sql` | `dbo.usp_Registration_GetTotalPresentAttendees` | `` |
| `RegistrationRepository.IsStudentRegistered` | `sql` | `dbo.usp_Registration_IsStudentRegistered` | `@EventId INT, @StudentId VARCHAR(50)` |
| `RegistrationRepository.RegisterStudent` | `sql` | `dbo.usp_Registration_RegisterStudent` | `@CurrentYearLvl INT, @StudentId VARCHAR(50), @EventId INT, @CurrentSection VARCHAR(50)` |
| `SponsorRepository.AddSponsor` | `sql` | `dbo.usp_Sponsor_AddSponsor` | `@SponsorName NVARCHAR(150), @CreatedAt DATETIME, @EventId INT` |
| `SponsorRepository.DeleteSponsor` | `sql` | `dbo.usp_Sponsor_DeleteSponsor` | `@SponsorEntryId INT` |
| `SponsorRepository.DeleteSponsorsByEventId` | `sql` | `dbo.usp_Sponsor_DeleteSponsorsByEventId` | `@EventId INT` |
| `SponsorRepository.GetSponsorsByEventId` | `sql` | `dbo.usp_Sponsor_GetSponsorsByEventId` | `@EventId INT` |
| `SponsorRepository.GetSponsorsForEvents` | `sql` | `dbo.usp_Sponsor_GetSponsorsForEvents` | `@EventIds NVARCHAR(MAX)` |
| `StudentRepository.CreateStudentWithAccount` | `checkSql` | `dbo.usp_Student_CreateStudentWithAccount_checkSql` | `@Email NVARCHAR(150), @StudentId VARCHAR(50)` |
| `StudentRepository.CreateStudentWithAccount` | `insertStudentSql` | `dbo.usp_Student_CreateStudentWithAccount_insertStudentSql` | `@StudentId VARCHAR(50), @FirstName NVARCHAR(100), @MiddleName NVARCHAR(100), @LastName NVARCHAR(100), @Gender VARCHAR(20), @CampusBranch NVARCHAR(100), @Department NVARCHAR(100), @Program NVARCHAR(100), @UserId INT, @BirthDate DATE` |
| `StudentRepository.CreateStudentWithAccount` | `insertUserSql` | `dbo.usp_Student_CreateStudentWithAccount_insertUserSql` | `@Email NVARCHAR(150), @PasswordHash VARCHAR(256), @PasswordSalt VARCHAR(128), @Role VARCHAR(50), @IsActive BIT` |
| `StudentRepository.EmailExists` | `sql` | `dbo.usp_Student_EmailExists` | `@Email NVARCHAR(150)` |
| `StudentRepository.GetAllStudents` | `sql` | `dbo.usp_Student_GetAllStudents` | `@Search NVARCHAR(150) = NULL, @Department NVARCHAR(100) = NULL, @Program NVARCHAR(100) = NULL, @Status VARCHAR(50) = NULL` |
| `StudentRepository.GetDistinctDepartments` | `sql` | `dbo.usp_Student_GetDistinctDepartments` | `` |
| `StudentRepository.GetDistinctPrograms` | `sql` | `dbo.usp_Student_GetDistinctPrograms` | `` |
| `StudentRepository.GetStudentById` | `sql` | `dbo.usp_Student_GetStudentById` | `@StudentId VARCHAR(50)` |
| `StudentRepository.GetStudentByUserId` | `sql` | `dbo.usp_Student_GetStudentByUserId` | `@UserId INT` |
| `StudentRepository.ResetStudentPassword` | `sql` | `dbo.usp_Student_ResetStudentPassword` | `@PasswordHash VARCHAR(256), @PasswordSalt VARCHAR(128), @StudentId VARCHAR(50)` |
| `StudentRepository.SaveManagedProfile` | `Command1` | `dbo.usp_Student_SaveManagedProfile_Command1` | `@UserId INT` |
| `StudentRepository.SaveManagedProfile` | `insert` | `dbo.usp_Student_SaveManagedProfile_insert` | `@StudentId VARCHAR(50), @FirstName NVARCHAR(100), @MiddleName NVARCHAR(100), @LastName NVARCHAR(100), @Gender VARCHAR(20), @CampusBranch NVARCHAR(100), @Department NVARCHAR(100), @Program NVARCHAR(100), @UserId INT` |
| `StudentRepository.SaveManagedProfile` | `update` | `dbo.usp_Student_SaveManagedProfile_update` | `@FirstName NVARCHAR(100), @MiddleName NVARCHAR(100), @LastName NVARCHAR(100), @Gender VARCHAR(20), @CampusBranch NVARCHAR(100), @Department NVARCHAR(100), @Program NVARCHAR(100), @UserId INT, @StudentId VARCHAR(50)` |
| `StudentRepository.StudentIdExists` | `sql` | `dbo.usp_Student_StudentIdExists` | `@StudentId VARCHAR(50)` |
| `StudentRepository.ToggleStudentStatus` | `sql` | `dbo.usp_Student_ToggleStudentStatus` | `@IsActive BIT, @StudentId VARCHAR(50)` |
| `StudentRepository.UpdateStudentFull` | `studentSql` | `dbo.usp_Student_UpdateStudentFull_studentSql` | `@FirstName NVARCHAR(100), @MiddleName NVARCHAR(100), @LastName NVARCHAR(100), @Gender VARCHAR(20), @CampusBranch NVARCHAR(100), @Department NVARCHAR(100), @Program NVARCHAR(100), @BirthDate DATE, @StudentId VARCHAR(50)` |
| `StudentRepository.UpdateStudentFull` | `userSql` | `dbo.usp_Student_UpdateStudentFull_userSql` | `@Email NVARCHAR(150), @StudentId VARCHAR(50)` |
| `UserRepository.CreateUser` | `sql` | `dbo.usp_User_CreateUser` | `@Email NVARCHAR(150), @PasswordHash VARCHAR(256), @PasswordSalt VARCHAR(128), @Role VARCHAR(50), @IsActive BIT` |
| `UserRepository.EmailExists` | `sql` | `dbo.usp_User_EmailExists` | `@Email NVARCHAR(150)` |
| `UserRepository.GetAccountStatistics` | `sql` | `dbo.usp_User_GetAccountStatistics` | `` |
| `UserRepository.GetAllUsers` | `sql` | `dbo.usp_User_GetAllUsers` | `@Search NVARCHAR(150) = NULL, @Role VARCHAR(50) = NULL, @Status VARCHAR(50) = NULL` |
| `UserRepository.GetUserByEmail` | `sql` | `dbo.usp_User_GetUserByEmail` | `@Email NVARCHAR(150)` |
| `UserRepository.GetUserById` | `sql` | `dbo.usp_User_GetUserById` | `@UserId INT` |
| `UserRepository.GetUserByIdentifier` | `sql` | `dbo.usp_User_GetUserByIdentifier` | `@Identifier NVARCHAR(150)` |
| `UserRepository.SaveManagedAccount` | `Command1` | `dbo.usp_User_SaveManagedAccount_Command1` | `` |
| `UserRepository.SaveManagedAccount` | `Command2` | `dbo.usp_User_SaveManagedAccount_Command2` | `@Email NVARCHAR(150), @UserId INT` |
| `UserRepository.SaveManagedAccount` | `Command3` | `dbo.usp_User_SaveManagedAccount_Command3` | `@Email NVARCHAR(150), @Role VARCHAR(50), @IsActive BIT, @Hash VARCHAR(256), @Salt VARCHAR(128), @UserId INT` |
| `UserRepository.ToggleUserActiveStatus` | `countSql` | `dbo.usp_User_ToggleUserActiveStatus_countSql` | `@TargetUserId INT` |
| `UserRepository.ToggleUserActiveStatus` | `toggleSql` | `dbo.usp_User_ToggleUserActiveStatus_toggleSql` | `@UserId INT` |
| `UserRepository.UpdatePassword` | `sql` | `dbo.usp_User_UpdatePassword` | `@PasswordHash VARCHAR(256), @PasswordSalt VARCHAR(128), @UserId INT` |
| `UserRepository.UpdateUserEmail` | `sql` | `dbo.usp_User_UpdateUserEmail` | `@Email NVARCHAR(150), @UserId INT` |
| `UserRepository.UpdateUserRole` | `countAdminsSql` | `dbo.usp_User_UpdateUserRole_countAdminsSql` | `@TargetUserId INT` |
| `UserRepository.UpdateUserRole` | `updateSql` | `dbo.usp_User_UpdateUserRole_updateSql` | `@Role VARCHAR(50), @UserId INT` |
| `UserRepository.UpdateUserStatus` | `sql` | `dbo.usp_User_UpdateUserStatus` | `@IsActive BIT, @UserId INT` |

Keep multiple commands for one method on the SAME SqlConnection and SqlTransaction, as in the existing code.
Keep C# duplicate checks, last-admin checks, password hashing, validation, scanner parsing and result mapping.
Registration and check-in procedures retain their existing SQL transaction blocks and result codes.
Search parameters accept LIKE patterns such as %Santos%. Omit inactive optional filters or pass DBNull.Value.
Directory Status: Active stays Active; Suspended/Locked/Inactive normalize to Inactive. ALL, empty and unknown statuses mean no filter.
History Semester: use the existing C# if/else priority to normalize to 1st, 2nd or Summer; otherwise omit the parameter.
History academic year is still parsed in C# into StartYear and EndYear. Keep outcome validation in C#.
Scanner keeps parsing ticket IDs in C# and passes ParsedId and Query to target-event and fallback procedures.
Sponsor batch accepts the comma-separated positive, distinct IDs already assembled by the C# method in EventIds.
GetDistinctHistoricalAcademicYears still constructs academic-year labels and fallbacks in C#.
Methods that only orchestrate other methods (AddSponsors, AdminResetPassword, CreateAdminUser) remain wrappers.
DatabaseConnection remains infrastructure. Its companion SQL file explains why it has no business procedure.
