using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
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
        private const string RoleStudent = "Student";

        /// <summary>
        /// Retrieves all students joined with user account credentials, supporting filtering and searching.
        /// </summary>
        public List<StudentProfile> GetAllStudents(string search = null, string department = null, string program = null, int? yearLevel = null, string status = null)
        {
            var list = new List<StudentProfile>();

            string sql = @"
                SELECT s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
                       s.CampusBranch, s.Department, s.Program, s.UserId, s.BirthDate,
                       u.Email, u.IsActive
                FROM dbo.StudentTable s
                INNER JOIN dbo.UserTable u ON s.UserId = u.UserId
                WHERE 1=1";

            var parameters = new List<SqlParameter>();

            if (!string.IsNullOrWhiteSpace(search))
            {
                sql += @" AND (
                    s.StudentId LIKE @Search OR 
                    s.FirstName LIKE @Search OR 
                    s.LastName LIKE @Search OR 
                    (s.FirstName + ' ' + s.LastName) LIKE @Search OR
                    u.Email LIKE @Search
                )";
                parameters.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 150) { Value = $"%{search.Trim()}%" });
            }

            if (!string.IsNullOrWhiteSpace(department) && department != "ALL")
            {
                sql += " AND s.Department = @Department";
                parameters.Add(new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = department.Trim() });
            }

            if (!string.IsNullOrWhiteSpace(program) && program != "ALL")
            {
                sql += " AND s.Program = @Program";
                parameters.Add(new SqlParameter("@Program", SqlDbType.NVarChar, 100) { Value = program.Trim() });
            }

            if (!string.IsNullOrWhiteSpace(status) && status != "ALL")
            {
                if (status.Equals("Active", StringComparison.OrdinalIgnoreCase))
                {
                    sql += " AND u.IsActive = 1";
                }
                else if (status.Equals("Suspended", StringComparison.OrdinalIgnoreCase) || status.Equals("Inactive", StringComparison.OrdinalIgnoreCase))
                {
                    sql += " AND u.IsActive = 0";
                }
            }

            sql += " ORDER BY s.StudentId ASC;";

            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, parameters.ToArray());
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

            const string sql = @"
                SELECT s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
                       s.CampusBranch, s.Department, s.Program, s.UserId, s.BirthDate,
                       u.Email, u.IsActive
                FROM dbo.StudentTable s
                INNER JOIN dbo.UserTable u ON s.UserId = u.UserId
                WHERE s.StudentId = @StudentId;";

            var param = new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

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

            const string sql = @"
                SELECT s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
                       s.CampusBranch, s.Department, s.Program, s.UserId, s.BirthDate,
                       u.Email, u.IsActive
                FROM dbo.StudentTable s
                INNER JOIN dbo.UserTable u ON s.UserId = u.UserId
                WHERE s.UserId = @UserId;";

            var param = new SqlParameter("@UserId", SqlDbType.Int) { Value = userId };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

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
                    const string checkSql = @"
                        IF EXISTS (SELECT 1 FROM dbo.UserTable WHERE Email = @Email)
                            SELECT 1;
                        ELSE IF EXISTS (SELECT 1 FROM dbo.StudentTable WHERE StudentId = @StudentId)
                            SELECT 2;
                        ELSE
                            SELECT 0;";

                    using (var checkCmd = new SqlCommand(checkSql, conn, trans))
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
                    const string insertUserSql = @"
                        INSERT INTO dbo.UserTable (Email, PasswordHash, PasswordSalt, Role, IsActive)
                        VALUES (@Email, @PasswordHash, @PasswordSalt, @Role, @IsActive);
                        SELECT CAST(SCOPE_IDENTITY() AS INT);";

                    using (var userCmd = new SqlCommand(insertUserSql, conn, trans))
                    {
                        userCmd.Parameters.Add(new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = student.Email.Trim() });
                        userCmd.Parameters.Add(new SqlParameter("@PasswordHash", SqlDbType.VarChar, 256) { Value = hash });
                        userCmd.Parameters.Add(new SqlParameter("@PasswordSalt", SqlDbType.VarChar, 128) { Value = salt });
                        userCmd.Parameters.Add(new SqlParameter("@Role", SqlDbType.VarChar, 50) { Value = RoleStudent });
                        userCmd.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Value = student.IsActive });
                        newUserId = Convert.ToInt32(userCmd.ExecuteScalar());
                    }

                    // 3. Insert into dbo.StudentTable
                    const string insertStudentSql = @"
                        INSERT INTO dbo.StudentTable (
                            StudentId, FirstName, MiddleName, LastName, Gender, CampusBranch, 
                            Department, Program, UserId, BirthDate
                        )
                        VALUES (
                            @StudentId, @FirstName, @MiddleName, @LastName, @Gender, @CampusBranch, 
                            @Department, @Program, @UserId, @BirthDate
                        );";

                    using (var studentCmd = new SqlCommand(insertStudentSql, conn, trans))
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
                    const string studentSql = @"
                        UPDATE dbo.StudentTable 
                        SET FirstName = @FirstName,
                            MiddleName = @MiddleName,
                            LastName = @LastName,
                            Gender = @Gender,
                            CampusBranch = @CampusBranch,
                            Department = @Department,
                            Program = @Program,
                            BirthDate = @BirthDate
                        WHERE StudentId = @StudentId;";

                    using (var cmd = new SqlCommand(studentSql, conn, trans))
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
                        const string userSql = @"
                            UPDATE dbo.UserTable
                            SET Email = @Email
                            WHERE UserId = (SELECT UserId FROM dbo.StudentTable WHERE StudentId = @StudentId);";

                        using (var userCmd = new SqlCommand(userSql, conn, trans))
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

            const string sql = @"
                UPDATE dbo.UserTable 
                SET IsActive = @IsActive 
                WHERE UserId = (SELECT UserId FROM dbo.StudentTable WHERE StudentId = @StudentId);";

            var parameters = new[]
            {
                new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() }
            };

            int rows = DatabaseConnection.ExecuteNonQuery(sql, parameters);
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

            const string sql = @"
                UPDATE dbo.UserTable 
                SET PasswordHash = @PasswordHash,
                    PasswordSalt = @PasswordSalt
                WHERE UserId = (SELECT UserId FROM dbo.StudentTable WHERE StudentId = @StudentId);";

            var parameters = new[]
            {
                new SqlParameter("@PasswordHash", SqlDbType.VarChar, 256) { Value = hash },
                new SqlParameter("@PasswordSalt", SqlDbType.VarChar, 128) { Value = salt },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() }
            };

            int rows = DatabaseConnection.ExecuteNonQuery(sql, parameters);
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

            const string sql = "SELECT COUNT(1) FROM dbo.StudentTable WHERE StudentId = @StudentId;";
            var param = new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() };

            object result = DatabaseConnection.ExecuteScalar(sql, param);
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

            const string sql = "SELECT COUNT(1) FROM dbo.UserTable WHERE Email = @Email;";
            var param = new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = email.Trim() };

            object result = DatabaseConnection.ExecuteScalar(sql, param);
            return Convert.ToInt32(result) > 0;
        }

        /// <summary>
        /// Retrieves distinct departments represented in the student directory.
        /// </summary>
        public List<string> GetDistinctDepartments()
        {
            var list = new List<string>();
            const string sql = "SELECT DISTINCT Department FROM dbo.StudentTable WHERE Department IS NOT NULL AND Department <> '' ORDER BY Department ASC;";
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql);
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    list.Add(row["Department"].ToString());
                }
            }
            return list;
        }

        /// <summary>
        /// Retrieves distinct academic programs/courses represented in the student directory.
        /// </summary>
        public List<string> GetDistinctPrograms()
        {
            var list = new List<string>();
            const string sql = "SELECT DISTINCT Program FROM dbo.StudentTable WHERE Program IS NOT NULL AND Program <> '' ORDER BY Program ASC;";
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql);
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    list.Add(row["Program"].ToString());
                }
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
