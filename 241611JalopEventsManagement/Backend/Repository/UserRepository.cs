using System;
using System.Data;
using System.Data.SqlClient;
using _241611JalopEventsManagement.Backend.Models;

namespace _241611JalopEventsManagement.Backend.Repository
{
    /// <summary>
    /// Repository managing persistent operations on dbo.UserTable.
    /// Strictly enforces the layered architecture and allowed user roles ('Admin', 'Student').
    /// </summary>
    public class UserRepository
    {
        private const string RoleAdmin = "Admin";
        private const string RoleStudent = "Student";

        /// Retrieves a user record by their unique institutional email address.
        public UserModel GetUserByEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
            {
                return null;
            }

            const string sql = @"
                SELECT UserId, Email, PasswordHash, PasswordSalt, Role, IsActive 
                FROM dbo.UserTable 
                WHERE Email = @Email;";

            var param = new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = email.Trim() };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToUserModel(dt.Rows[0]);
            }

            return null;
        }

        /// Retrieves a user record by either their Student ID or Email address.
        public UserModel GetUserByIdentifier(string identifier)
        {
            if (string.IsNullOrWhiteSpace(identifier))
            {
                return null;
            }

            const string sql = @"
                SELECT u.UserId, u.Email, u.PasswordHash, u.PasswordSalt, u.Role, u.IsActive,
                       s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, s.CampusBranch, s.Department, s.Program
                FROM dbo.UserTable u
                LEFT JOIN dbo.StudentTable s ON u.UserId = s.UserId
                WHERE u.Email = @Identifier OR s.StudentId = @Identifier;";

            var param = new SqlParameter("@Identifier", SqlDbType.NVarChar, 150) { Value = identifier.Trim() };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToUserModel(dt.Rows[0]);
            }

            return null;
        }

        /// Retrieves a user record by their primary key (UserId).
        public UserModel GetUserById(int userId)
        {
            if (userId <= 0)
            {
                return null;
            }

            const string sql = @"
                SELECT UserId, Email, PasswordHash, PasswordSalt, Role, IsActive 
                FROM dbo.UserTable 
                WHERE UserId = @UserId;";

            var param = new SqlParameter("@UserId", SqlDbType.Int) { Value = userId };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToUserModel(dt.Rows[0]);
            }

            return null;
        }


        /// Creates a new user record in dbo.UserTable.
        public int CreateUser(UserModel user)
        {
            if (user == null)
            {
                throw new ArgumentNullException(nameof(user), "User model cannot be null.");
            }

            if (string.IsNullOrWhiteSpace(user.Email))
            {
                throw new ArgumentException("Email is required for user creation.", nameof(user.Email));
            }

            if (string.IsNullOrWhiteSpace(user.PasswordHash) || string.IsNullOrWhiteSpace(user.PasswordSalt))
            {
                throw new InvalidOperationException("PasswordHash and PasswordSalt must be computed before persisting.");
            }

            // Strictly enforce project role rules: Admin or Student only
            string role = user.Role?.Trim();
            if (role != RoleAdmin && role != RoleStudent)
            {
                throw new ArgumentException($"Invalid role '{role}'. Allowed roles are strictly '{RoleAdmin}' or '{RoleStudent}'.", nameof(user.Role));
            }

            const string sql = @"
                INSERT INTO dbo.UserTable (Email, PasswordHash, PasswordSalt, Role, IsActive)
                VALUES (@Email, @PasswordHash, @PasswordSalt, @Role, @IsActive);
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            var parameters = new[]
            {
                new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = user.Email.Trim() },
                new SqlParameter("@PasswordHash", SqlDbType.VarChar, 256) { Value = user.PasswordHash },
                new SqlParameter("@PasswordSalt", SqlDbType.VarChar, 128) { Value = user.PasswordSalt },
                new SqlParameter("@Role", SqlDbType.VarChar, 50) { Value = role },
                new SqlParameter("@IsActive", SqlDbType.Bit) { Value = user.IsActive }
            };

            object result = DatabaseConnection.ExecuteScalar(sql, parameters);
            if (result != null && int.TryParse(result.ToString(), out int newUserId))
            {
                user.UserId = newUserId;
                return newUserId;
            }

            throw new InvalidOperationException("Failed to retrieve generated UserId from dbo.UserTable.");
        }


        /// Checks whether an email address is already registered in the system.
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

        /// Updates the activation status of a user account.
        public bool UpdateUserStatus(int userId, bool isActive)
        {
            if (userId <= 0)
            {
                return false;
            }

            const string sql = "UPDATE dbo.UserTable SET IsActive = @IsActive WHERE UserId = @UserId;";
            var parameters = new[]
            {
                new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive },
                new SqlParameter("@UserId", SqlDbType.Int) { Value = userId }
            };

            int rowsAffected = DatabaseConnection.ExecuteNonQuery(sql, parameters);
            return rowsAffected > 0;
        }

        /// Updates the password hash and cryptographic salt for a user.
        public bool UpdatePassword(int userId, string passwordHash, string passwordSalt)
        {
            if (userId <= 0)
            {
                return false;
            }

            if (string.IsNullOrWhiteSpace(passwordHash) || string.IsNullOrWhiteSpace(passwordSalt))
            {
                throw new ArgumentException("Password hash and salt cannot be empty.");
            }

            const string sql = @"
                UPDATE dbo.UserTable 
                SET PasswordHash = @PasswordHash, PasswordSalt = @PasswordSalt 
                WHERE UserId = @UserId;";

            var parameters = new[]
            {
                new SqlParameter("@PasswordHash", SqlDbType.VarChar, 256) { Value = passwordHash },
                new SqlParameter("@PasswordSalt", SqlDbType.VarChar, 128) { Value = passwordSalt },
                new SqlParameter("@UserId", SqlDbType.Int) { Value = userId }
            };

            int rowsAffected = DatabaseConnection.ExecuteNonQuery(sql, parameters);
            return rowsAffected > 0;
        }

        #region Helper Mapping

        private static UserModel MapRowToUserModel(DataRow row)
        {
            var user = new UserModel
            {
                UserId = Convert.ToInt32(row["UserId"]),
                Email = row["Email"]?.ToString(),
                PasswordHash = row["PasswordHash"]?.ToString(),
                PasswordSalt = row["PasswordSalt"]?.ToString(),
                Role = row["Role"]?.ToString(),
                IsActive = row["IsActive"] != DBNull.Value && Convert.ToBoolean(row["IsActive"])
            };

            if (row.Table.Columns.Contains("StudentId") && row["StudentId"] != DBNull.Value)
            {
                user.StudentProfile = new StudentProfile
                {
                    StudentId = row["StudentId"].ToString(),
                    FirstName = row.Table.Columns.Contains("FirstName") && row["FirstName"] != DBNull.Value ? row["FirstName"].ToString() : null,
                    MiddleName = row.Table.Columns.Contains("MiddleName") && row["MiddleName"] != DBNull.Value ? row["MiddleName"].ToString() : null,
                    LastName = row.Table.Columns.Contains("LastName") && row["LastName"] != DBNull.Value ? row["LastName"].ToString() : null,
                    Gender = row.Table.Columns.Contains("Gender") && row["Gender"] != DBNull.Value ? row["Gender"].ToString() : null,
                    CampusBranch = row.Table.Columns.Contains("CampusBranch") && row["CampusBranch"] != DBNull.Value ? row["CampusBranch"].ToString() : null,
                    Department = row.Table.Columns.Contains("Department") && row["Department"] != DBNull.Value ? row["Department"].ToString() : null,
                    Program = row.Table.Columns.Contains("Program") && row["Program"] != DBNull.Value ? row["Program"].ToString() : null,
                    UserId = user.UserId
                };
            }

            return user;
        }

        #endregion
    }
}
