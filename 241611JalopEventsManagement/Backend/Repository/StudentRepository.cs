using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;

namespace _241611JalopEventsManagement.Backend.Repository
{
    /// <summary>
    /// Repository managing persistent operations on dbo.StudentTable and joined dbo.UserTable.
    /// Acts as the single source of truth for student identity, academic credentials, and directory lookups.
    /// </summary>
    public class StudentRepository
    {
        // Participates in the account transaction; this screen does not own BirthDate or StudentId changes.
        internal void SaveManagedProfile(SqlConnection connection, SqlTransaction transaction, int userId, StudentProfile profile)
        {
            string existingId = null;
            using (var command = new SqlCommand("dbo.usp_Student_SaveManagedProfile_Command1", connection, transaction) { CommandType = CommandType.StoredProcedure })
            {
                command.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read()) existingId = reader.GetString(0);
                    if (reader.Read()) throw new InvalidOperationException("This account has multiple student profiles. Resolve them before editing.");
                }
            }
            if (existingId != null && !string.Equals(existingId, profile.StudentId.Trim(), StringComparison.Ordinal))
                throw new InvalidOperationException("Student ID cannot be changed through account management.");
            const string update = "dbo.usp_Student_SaveManagedProfile_update";
            const string insert = "dbo.usp_Student_SaveManagedProfile_insert";
            using (var command = new SqlCommand(existingId == null ? insert : update, connection, transaction) { CommandType = CommandType.StoredProcedure })
            {
                command.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                command.Parameters.Add(new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = profile.StudentId.Trim() });
                command.Parameters.Add(new SqlParameter("@FirstName", SqlDbType.NVarChar, 100) { Value = profile.FirstName.Trim() });
                command.Parameters.Add(new SqlParameter("@MiddleName", SqlDbType.NVarChar, 100) { Value = (object)profile.MiddleName?.Trim() ?? DBNull.Value });
                command.Parameters.Add(new SqlParameter("@LastName", SqlDbType.NVarChar, 100) { Value = profile.LastName.Trim() });
                command.Parameters.Add(new SqlParameter("@Gender", SqlDbType.VarChar, 20) { Value = profile.Gender ?? "Not Specified" });
                command.Parameters.Add(new SqlParameter("@CampusBranch", SqlDbType.NVarChar, 100) { Value = profile.CampusBranch ?? "San Bartolome" });
                command.Parameters.Add(new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = profile.Department.Trim() });
                command.Parameters.Add(new SqlParameter("@Program", SqlDbType.NVarChar, 100) { Value = profile.Program.Trim() });
                if (command.ExecuteNonQuery() != 1) throw new InvalidOperationException("The student profile could not be saved.");
            }
        }
        private const string RoleStudent = "Student";

        /// <summary>
        /// Retrieves all students joined with user account credentials, supporting filtering and searching.
        /// </summary>
        public List<StudentProfile> GetAllStudents(string search = null, string department = null, string program = null, int? yearLevel = null, string status = null)
        {
            var list = new List<StudentProfile>();

            string sql = "dbo.usp_Student_GetAllStudents";

            var parameters = new List<SqlParameter>();

            if (!string.IsNullOrWhiteSpace(search))
            {
                parameters.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 150) { Value = $"%{search.Trim()}%" });
            }

            if (!string.IsNullOrWhiteSpace(department) && department != "ALL")
            {
                parameters.Add(new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = department.Trim() });
            }

            if (!string.IsNullOrWhiteSpace(program) && program != "ALL")
            {
                parameters.Add(new SqlParameter("@Program", SqlDbType.NVarChar, 100) { Value = program.Trim() });
            }

            if (!string.IsNullOrWhiteSpace(status) && status != "ALL")
            {
                if (status.Equals("Active", StringComparison.OrdinalIgnoreCase))
                {
                    parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 50) { Value = "Active" });
                }
                else if (status.Equals("Suspended", StringComparison.OrdinalIgnoreCase) || status.Equals("Inactive", StringComparison.OrdinalIgnoreCase))
                {
                    parameters.Add(new SqlParameter("@Status", SqlDbType.VarChar, 50) { Value = "Inactive" });
                }
            }

            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, parameters.ToArray());
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    list.Add(MapRowToStudentProfile(row));
                }
            }

            return list;
        }

        /// <summary>
        /// Retrieves a student profile by their unique matriculation ID (StudentId).
        /// </summary>
        public StudentProfile GetStudentById(string studentId)
        {
            if (string.IsNullOrWhiteSpace(studentId))
            {
                return null;
            }

            const string sql = "dbo.usp_Student_GetStudentById";

            var param = new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() };
            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, param);

            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToStudentProfile(dt.Rows[0]);
            }

            return null;
        }

        /// <summary>
        /// Retrieves a student profile by their associated user account identifier (UserId).
        /// </summary>
        public StudentProfile GetStudentByUserId(int userId)
        {
            if (userId <= 0)
            {
                return null;
            }

            const string sql = "dbo.usp_Student_GetStudentByUserId";

            var param = new SqlParameter("@UserId", SqlDbType.Int) { Value = userId };
            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, param);

            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToStudentProfile(dt.Rows[0]);
            }

            return null;
        }

        /// <summary>
        /// Atomically creates a user login account in dbo.UserTable and the associated academic profile in dbo.StudentTable.
        /// </summary>
        public bool CreateStudentWithAccount(StudentProfile student, string plainPassword)
        {
            if (student == null)
            {
                throw new ArgumentNullException(nameof(student), "Student profile cannot be null.");
            }

            if (string.IsNullOrWhiteSpace(student.StudentId))
            {
                throw new ArgumentException("Student ID is required.", nameof(student.StudentId));
            }

            if (string.IsNullOrWhiteSpace(student.Email))
            {
                throw new ArgumentException("Institutional Email is required.", nameof(student.Email));
            }

            if (string.IsNullOrWhiteSpace(plainPassword))
            {
                throw new ArgumentException("Password is required.", nameof(plainPassword));
            }

            string salt = PasswordHelper.GenerateSalt();
            string hash = PasswordHelper.HashPassword(plainPassword, salt);

            using (var conn = DatabaseConnection.GetOpenConnection())
            using (var trans = conn.BeginTransaction())
            {
                try
                {
                    // 1. Check if Email or StudentId already exists
                    const string checkSql = "dbo.usp_Student_CreateStudentWithAccount_checkSql";

                    using (var checkCmd = new SqlCommand(checkSql, conn, trans) { CommandType = CommandType.StoredProcedure })
                    {
                        checkCmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = student.Email.Trim() });
                        checkCmd.Parameters.Add(new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = student.StudentId.Trim() });
                        int checkResult = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (checkResult == 1)
                        {
                            throw new InvalidOperationException($"The email '{student.Email}' is already registered.");
                        }
                        if (checkResult == 2)
                        {
                            throw new InvalidOperationException($"Student ID '{student.StudentId}' is already registered.");
                        }
                    }

                    // 2. Insert into dbo.UserTable
                    int newUserId;
                    const string insertUserSql = "dbo.usp_Student_CreateStudentWithAccount_insertUserSql";

                    using (var userCmd = new SqlCommand(insertUserSql, conn, trans) { CommandType = CommandType.StoredProcedure })
                    {
                        userCmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = student.Email.Trim() });
                        userCmd.Parameters.Add(new SqlParameter("@PasswordHash", SqlDbType.VarChar, 256) { Value = hash });
                        userCmd.Parameters.Add(new SqlParameter("@PasswordSalt", SqlDbType.VarChar, 128) { Value = salt });
                        userCmd.Parameters.Add(new SqlParameter("@Role", SqlDbType.VarChar, 50) { Value = RoleStudent });
                        userCmd.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Value = student.IsActive });
                        newUserId = Convert.ToInt32(userCmd.ExecuteScalar());
                    }

                    // 3. Insert into dbo.StudentTable
                    const string insertStudentSql = "dbo.usp_Student_CreateStudentWithAccount_insertStudentSql";

                    using (var studentCmd = new SqlCommand(insertStudentSql, conn, trans) { CommandType = CommandType.StoredProcedure })
                    {
                        studentCmd.Parameters.Add(new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = student.StudentId.Trim() });
                        studentCmd.Parameters.Add(new SqlParameter("@FirstName", SqlDbType.NVarChar, 100) { Value = student.FirstName.Trim() });
                        studentCmd.Parameters.Add(new SqlParameter("@MiddleName", SqlDbType.NVarChar, 100) { Value = (object)student.MiddleName?.Trim() ?? DBNull.Value });
                        studentCmd.Parameters.Add(new SqlParameter("@LastName", SqlDbType.NVarChar, 100) { Value = student.LastName.Trim() });
                        studentCmd.Parameters.Add(new SqlParameter("@Gender", SqlDbType.VarChar, 20) { Value = student.Gender?.Trim() ?? "Not Specified" });
                        studentCmd.Parameters.Add(new SqlParameter("@CampusBranch", SqlDbType.NVarChar, 100) { Value = student.CampusBranch?.Trim() ?? "San Bartolome" });
                        studentCmd.Parameters.Add(new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = student.Department.Trim() });
                        studentCmd.Parameters.Add(new SqlParameter("@Program", SqlDbType.NVarChar, 100) { Value = student.Program.Trim() });
                        studentCmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = newUserId });
                        studentCmd.Parameters.Add(new SqlParameter("@BirthDate", SqlDbType.Date) { Value = (object)student.BirthDate ?? DBNull.Value });

                        studentCmd.ExecuteNonQuery();
                    }

                    trans.Commit();
                    student.UserId = newUserId;
                    return true;
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }

        /// <summary>
        /// Updates an existing student demographic and academic profile, including user email if modified.
        /// </summary>
        public bool UpdateStudentFull(StudentProfile student)
        {
            if (student == null || string.IsNullOrWhiteSpace(student.StudentId))
            {
                return false;
            }

            using (var conn = DatabaseConnection.GetOpenConnection())
            using (var trans = conn.BeginTransaction())
            {
                try
                {
                    // 1. Update StudentTable
                    const string studentSql = "dbo.usp_Student_UpdateStudentFull_studentSql";

                    using (var cmd = new SqlCommand(studentSql, conn, trans) { CommandType = CommandType.StoredProcedure })
                    {
                        cmd.Parameters.Add(new SqlParameter("@FirstName", SqlDbType.NVarChar, 100) { Value = student.FirstName.Trim() });
                        cmd.Parameters.Add(new SqlParameter("@MiddleName", SqlDbType.NVarChar, 100) { Value = (object)student.MiddleName?.Trim() ?? DBNull.Value });
                        cmd.Parameters.Add(new SqlParameter("@LastName", SqlDbType.NVarChar, 100) { Value = student.LastName.Trim() });
                        cmd.Parameters.Add(new SqlParameter("@Gender", SqlDbType.VarChar, 20) { Value = student.Gender?.Trim() ?? "Not Specified" });
                        cmd.Parameters.Add(new SqlParameter("@CampusBranch", SqlDbType.NVarChar, 100) { Value = student.CampusBranch?.Trim() ?? "San Bartolome" });
                        cmd.Parameters.Add(new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = student.Department.Trim() });
                        cmd.Parameters.Add(new SqlParameter("@Program", SqlDbType.NVarChar, 100) { Value = student.Program.Trim() });
                        cmd.Parameters.Add(new SqlParameter("@BirthDate", SqlDbType.Date) { Value = (object)student.BirthDate ?? DBNull.Value });
                        cmd.Parameters.Add(new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = student.StudentId.Trim() });

                        cmd.ExecuteNonQuery();
                    }

                    // 2. Update UserTable email if provided
                    if (!string.IsNullOrWhiteSpace(student.Email))
                    {
                        const string userSql = "dbo.usp_Student_UpdateStudentFull_userSql";

                        using (var userCmd = new SqlCommand(userSql, conn, trans) { CommandType = CommandType.StoredProcedure })
                        {
                            userCmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = student.Email.Trim() });
                            userCmd.Parameters.Add(new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = student.StudentId.Trim() });
                            userCmd.ExecuteNonQuery();
                        }
                    }

                    trans.Commit();
                    return true;
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }

        /// <summary>
        /// Toggles student user account active/suspended state.
        /// </summary>
        public bool ToggleStudentStatus(string studentId, bool isActive)
        {
            if (string.IsNullOrWhiteSpace(studentId))
            {
                return false;
            }

            const string sql = "dbo.usp_Student_ToggleStudentStatus";

            var parameters = new[]
            {
                new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() }
            };

            int rows = DatabaseConnection.ExecuteProcedureNonQuery(sql, parameters);
            return rows > 0;
        }

        /// <summary>
        /// Resets a student's password in dbo.UserTable.
        /// </summary>
        public bool ResetStudentPassword(string studentId, string newPlainPassword)
        {
            if (string.IsNullOrWhiteSpace(studentId) || string.IsNullOrWhiteSpace(newPlainPassword))
            {
                return false;
            }

            string salt = PasswordHelper.GenerateSalt();
            string hash = PasswordHelper.HashPassword(newPlainPassword, salt);

            const string sql = "dbo.usp_Student_ResetStudentPassword";

            var parameters = new[]
            {
                new SqlParameter("@PasswordHash", SqlDbType.VarChar, 256) { Value = hash },
                new SqlParameter("@PasswordSalt", SqlDbType.VarChar, 128) { Value = salt },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() }
            };

            int rows = DatabaseConnection.ExecuteProcedureNonQuery(sql, parameters);
            return rows > 0;
        }

        /// <summary>
        /// Checks if a matriculation ID already exists in dbo.StudentTable.
        /// </summary>
        public bool StudentIdExists(string studentId)
        {
            if (string.IsNullOrWhiteSpace(studentId))
            {
                return false;
            }

            const string sql = "dbo.usp_Student_StudentIdExists";
            var param = new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() };

            object result = DatabaseConnection.ExecuteProcedureScalar(sql, param);
            return Convert.ToInt32(result) > 0;
        }

        /// <summary>
        /// Checks if an email is registered in dbo.UserTable.
        /// </summary>
        public bool EmailExists(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
            {
                return false;
            }

            const string sql = "dbo.usp_Student_EmailExists";
            var param = new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = email.Trim() };

            object result = DatabaseConnection.ExecuteProcedureScalar(sql, param);
            return Convert.ToInt32(result) > 0;
        }

        /// <summary>
        /// Retrieves distinct departments represented in the student directory, cached in HttpRuntime.Cache for 30 minutes.
        /// </summary>
        public List<string> GetDistinctDepartments()
        {
            const string cacheKey = "Cache_Student_DistinctDepartments";
            if (HttpRuntime.Cache != null && HttpRuntime.Cache[cacheKey] is List<string> cached)
            {
                return cached;
            }

            var list = new List<string>();
            try
            {
                const string sql = "dbo.usp_Student_GetDistinctDepartments";
                DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        list.Add(row["Department"].ToString());
                    }
                }

                if (HttpRuntime.Cache != null && list.Count > 0)
                {
                    HttpRuntime.Cache.Insert(cacheKey, list, null, DateTime.Now.AddMinutes(30), System.Web.Caching.Cache.NoSlidingExpiration);
                }
            }
            catch
            {
                // Fallback to static list if database is offline
                list = new List<string>
                {
                    "College of Computer Studies",
                    "College of Engineering",
                    "College of Business Administration and Accountancy",
                    "College of Education"
                };
            }

            return list;
        }

        /// <summary>
        /// Retrieves distinct academic programs/courses represented in the student directory, cached in HttpRuntime.Cache for 30 minutes.
        /// </summary>
        public List<string> GetDistinctPrograms()
        {
            const string cacheKey = "Cache_Student_DistinctPrograms";
            if (HttpRuntime.Cache != null && HttpRuntime.Cache[cacheKey] is List<string> cached)
            {
                return cached;
            }

            var list = new List<string>();
            try
            {
                const string sql = "dbo.usp_Student_GetDistinctPrograms";
                DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        list.Add(row["Program"].ToString());
                    }
                }

                if (HttpRuntime.Cache != null && list.Count > 0)
                {
                    HttpRuntime.Cache.Insert(cacheKey, list, null, DateTime.Now.AddMinutes(30), System.Web.Caching.Cache.NoSlidingExpiration);
                }
            }
            catch
            {
                // Fallback to static list if database is offline
                list = new List<string>
                {
                    "BS Information Technology",
                    "BS Computer Science",
                    "BS Industrial Engineering",
                    "BS Electronics Engineering",
                    "BS Entrepreneurship",
                    "BS Accountancy"
                };
            }

            return list;
        }

        #region Helper Mapping

        private static StudentProfile MapRowToStudentProfile(DataRow row)
        {
            var student = new StudentProfile
            {
                StudentId = row["StudentId"]?.ToString(),
                FirstName = row["FirstName"]?.ToString(),
                MiddleName = row["MiddleName"] != DBNull.Value ? row["MiddleName"].ToString() : null,
                LastName = row["LastName"]?.ToString(),
                Gender = row["Gender"]?.ToString(),
                CampusBranch = row["CampusBranch"]?.ToString(),
                Department = row["Department"]?.ToString(),
                Program = row["Program"]?.ToString(),
                UserId = Convert.ToInt32(row["UserId"])
            };

            if (row.Table.Columns.Contains("YearLevel") && row["YearLevel"] != DBNull.Value)
            {
                student.YearLevel = Convert.ToInt32(row["YearLevel"]);
            }

            if (row.Table.Columns.Contains("Section") && row["Section"] != DBNull.Value)
            {
                student.Section = row["Section"].ToString();
            }

            if (row.Table.Columns.Contains("BirthDate") && row["BirthDate"] != DBNull.Value)
            {
                student.BirthDate = Convert.ToDateTime(row["BirthDate"]);
            }

            if (row.Table.Columns.Contains("Email") && row["Email"] != DBNull.Value)
            {
                student.Email = row["Email"].ToString();
            }

            if (row.Table.Columns.Contains("IsActive") && row["IsActive"] != DBNull.Value)
            {
                student.IsActive = Convert.ToBoolean(row["IsActive"]);
            }

            return student;
        }

        #endregion
    }
}
