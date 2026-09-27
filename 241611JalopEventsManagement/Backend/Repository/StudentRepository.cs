using System;
using System.Data;
using System.Data.SqlClient;
using _241611JalopEventsManagement.Backend.Models;

namespace _241611JalopEventsManagement.Backend.Repository
{
    /// <summary>
    /// Repository managing persistent operations on dbo.StudentTable.
    /// Encapsulates academic demographic profiles, matriculation lookups, and student-user associations.
    /// </summary>
    public class StudentRepository
    {
        /// <summary>
        /// Retrieves a student demographic profile by their associated user account identifier (UserId).
        /// </summary>
        public StudentProfile GetStudentByUserId(int userId)
        {
            if (userId <= 0)
            {
                return null;
            }

            const string sql = @"
                SELECT StudentId, FirstName, MiddleName, LastName, Gender, CampusBranch, Department, Program, UserId 
                FROM dbo.StudentTable 
                WHERE UserId = @UserId;";

            var param = new SqlParameter("@UserId", SqlDbType.Int) { Value = userId };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToStudentProfile(dt.Rows[0]);
            }

            return null;
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
                SELECT StudentId, FirstName, MiddleName, LastName, Gender, CampusBranch, Department, Program, UserId 
                FROM dbo.StudentTable 
                WHERE StudentId = @StudentId;";

            var param = new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToStudentProfile(dt.Rows[0]);
            }

            return null;
        }

        /// <summary>
        /// Creates a new student profile in dbo.StudentTable linked to an existing user account.
        /// </summary>
        public bool CreateStudent(StudentProfile student)
        {
            if (student == null)
            {
                throw new ArgumentNullException(nameof(student), "Student profile cannot be null.");
            }

            if (string.IsNullOrWhiteSpace(student.StudentId))
            {
                throw new ArgumentException("StudentId is required.", nameof(student.StudentId));
            }

            if (student.UserId <= 0)
            {
                throw new ArgumentException("UserId must reference a valid user account.", nameof(student.UserId));
            }

            const string sql = @"
                INSERT INTO dbo.StudentTable (
                    StudentId, FirstName, MiddleName, LastName, Gender, CampusBranch, Department, Program, UserId
                )
                VALUES (
                    @StudentId, @FirstName, @MiddleName, @LastName, @Gender, @CampusBranch, @Department, @Program, @UserId
                );";

            var parameters = new[]
            {
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = student.StudentId.Trim() },
                new SqlParameter("@FirstName", SqlDbType.NVarChar, 100) { Value = student.FirstName.Trim() },
                new SqlParameter("@MiddleName", SqlDbType.NVarChar, 100) { Value = (object)student.MiddleName ?? DBNull.Value },
                new SqlParameter("@LastName", SqlDbType.NVarChar, 100) { Value = student.LastName.Trim() },
                new SqlParameter("@Gender", SqlDbType.VarChar, 20) { Value = student.Gender.Trim() },
                new SqlParameter("@CampusBranch", SqlDbType.NVarChar, 100) { Value = student.CampusBranch.Trim() },
                new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = student.Department.Trim() },
                new SqlParameter("@Program", SqlDbType.NVarChar, 100) { Value = student.Program.Trim() },
                new SqlParameter("@UserId", SqlDbType.Int) { Value = student.UserId }
            };

            int rows = DatabaseConnection.ExecuteNonQuery(sql, parameters);
            return rows > 0;
        }

        /// <summary>
        /// Updates demographic and academic details for an existing student profile.
        /// </summary>
        public bool UpdateStudent(StudentProfile student)
        {
            if (student == null || string.IsNullOrWhiteSpace(student.StudentId))
            {
                return false;
            }

            const string sql = @"
                UPDATE dbo.StudentTable 
                SET FirstName = @FirstName,
                    MiddleName = @MiddleName,
                    LastName = @LastName,
                    Gender = @Gender,
                    CampusBranch = @CampusBranch,
                    Department = @Department,
                    Program = @Program
                WHERE StudentId = @StudentId;";

            var parameters = new[]
            {
                new SqlParameter("@FirstName", SqlDbType.NVarChar, 100) { Value = student.FirstName.Trim() },
                new SqlParameter("@MiddleName", SqlDbType.NVarChar, 100) { Value = (object)student.MiddleName ?? DBNull.Value },
                new SqlParameter("@LastName", SqlDbType.NVarChar, 100) { Value = student.LastName.Trim() },
                new SqlParameter("@Gender", SqlDbType.VarChar, 20) { Value = student.Gender.Trim() },
                new SqlParameter("@CampusBranch", SqlDbType.NVarChar, 100) { Value = student.CampusBranch.Trim() },
                new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = student.Department.Trim() },
                new SqlParameter("@Program", SqlDbType.NVarChar, 100) { Value = student.Program.Trim() },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = student.StudentId.Trim() }
            };

            int rows = DatabaseConnection.ExecuteNonQuery(sql, parameters);
            return rows > 0;
        }

        /// <summary>
        /// Verifies whether a student matriculation ID is already registered in the system.
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

        #region Helper Mapping

        private static StudentProfile MapRowToStudentProfile(DataRow row)
        {
            return new StudentProfile
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
        }

        #endregion
    }
}
