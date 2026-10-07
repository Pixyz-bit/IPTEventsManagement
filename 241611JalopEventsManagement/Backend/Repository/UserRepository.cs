using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using _241611JalopEventsManagement.Backend.Helpers;
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

        /// <summary>
        /// Saves account-management fields atomically. Existing student birthdates and IDs are preserved.
        /// </summary>
        public void SaveManagedAccount(UserModel user, StudentProfile profile, string newPassword, int currentAdminUserId)
        {
            if (user == null || user.UserId <= 0 || currentAdminUserId <= 0)
                throw new ArgumentException("A valid account and administrator are required.");
            if (string.IsNullOrWhiteSpace(user.Email) || user.Email.Trim().Length > 150)
                throw new ArgumentException("Email is required and must not exceed 150 characters.");
            if (user.Role != RoleAdmin && user.Role != RoleStudent)
                throw new ArgumentException("Role must be Admin or Student.");
            if (!string.IsNullOrEmpty(newPassword) && (string.IsNullOrWhiteSpace(newPassword) || newPassword.Length < 6))
                throw new ArgumentException("Password must be at least 6 characters in length.");
            if (user.Role == RoleStudent)
            {
                if (profile == null || string.IsNullOrWhiteSpace(profile.StudentId) ||
                    string.IsNullOrWhiteSpace(profile.FirstName) || string.IsNullOrWhiteSpace(profile.LastName) ||
                    string.IsNullOrWhiteSpace(profile.Department) || string.IsNullOrWhiteSpace(profile.Program))
                    throw new ArgumentException("Student ID, name, department and program are required.");
                if (profile.StudentId.Trim().Length > 50 || profile.FirstName.Length > 100 ||
                    (profile.MiddleName?.Length ?? 0) > 100 || profile.LastName.Length > 100 ||
                    (profile.Gender?.Length ?? 0) > 20 || (profile.CampusBranch?.Length ?? 0) > 100 ||
                    profile.Department.Length > 100 || profile.Program.Length > 100)
                    throw new ArgumentException("A student field exceeds its maximum length.");
            }

            string salt = string.IsNullOrEmpty(newPassword) ? null : PasswordHelper.GenerateSalt();
            string hash = salt == null ? null : PasswordHelper.HashPassword(newPassword, salt);
            using (var connection = DatabaseConnection.GetOpenConnection())
            using (var transaction = connection.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    // Serialize account-management changes before checking administrator and email invariants.
                    using (var command = new SqlCommand(@"
                        SELECT UserId, Role, IsActive FROM dbo.UserTable WITH (UPDLOCK, HOLDLOCK)
                        ORDER BY UserId;", connection, transaction))
                    using (var reader = command.ExecuteReader())
                    {
                        bool found = false, authorized = false;
                        int otherAdmins = 0;
                        while (reader.Read())
                        {
                            int id = reader.GetInt32(0);
                            bool activeAdmin = reader.GetString(1) == RoleAdmin && reader.GetBoolean(2);
                            if (id == user.UserId) found = true;
                            if (id == currentAdminUserId) authorized = activeAdmin;
                            if (id != user.UserId && activeAdmin) otherAdmins++;
                        }
                        if (!authorized) throw new InvalidOperationException("An active administrator account is required.");
                        if (!found) throw new InvalidOperationException("The account no longer exists.");
                        if (user.UserId == currentAdminUserId && (user.Role != RoleAdmin || !user.IsActive))
                            throw new InvalidOperationException("You cannot demote or deactivate your own administrator account.");
                        if ((user.Role != RoleAdmin || !user.IsActive) && otherAdmins == 0)
                            throw new InvalidOperationException("At least one active administrator must remain.");
                    }
                    using (var command = new SqlCommand(@"
                        SELECT COUNT(1) FROM dbo.UserTable WHERE Email = @Email AND UserId <> @UserId;", connection, transaction))
                    {
                        command.Parameters.Add(new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = user.Email.Trim() });
                        command.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = user.UserId });
                        if (Convert.ToInt32(command.ExecuteScalar()) != 0)
                            throw new InvalidOperationException("That email address is already registered to another account.");
                    }
                    if (user.Role == RoleStudent)
                        new StudentRepository().SaveManagedProfile(connection, transaction, user.UserId, profile);
                    using (var command = new SqlCommand(@"
                        UPDATE dbo.UserTable SET Email = @Email, Role = @Role, IsActive = @IsActive,
                            PasswordHash = CASE WHEN @Hash IS NULL THEN PasswordHash ELSE @Hash END,
                            PasswordSalt = CASE WHEN @Salt IS NULL THEN PasswordSalt ELSE @Salt END
                        WHERE UserId = @UserId;", connection, transaction))
                    {
                        command.Parameters.Add(new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = user.Email.Trim() });
                        command.Parameters.Add(new SqlParameter("@Role", SqlDbType.VarChar, 50) { Value = user.Role });
                        command.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Value = user.IsActive });
                        command.Parameters.Add(new SqlParameter("@Hash", SqlDbType.VarChar, 256) { Value = (object)hash ?? DBNull.Value });
                        command.Parameters.Add(new SqlParameter("@Salt", SqlDbType.VarChar, 128) { Value = (object)salt ?? DBNull.Value });
                        command.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = user.UserId });
                        if (command.ExecuteNonQuery() != 1) throw new InvalidOperationException("The account could not be updated.");
                    }
                    transaction.Commit();
                }
                catch
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }

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

        /// <summary>
        /// Retrieves a user record strictly by their Email address (Student and Admin login).
        /// </summary>
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

        /// Updates the email address of a user account.
        public bool UpdateUserEmail(int userId, string email)
        {
            if (userId <= 0 || string.IsNullOrWhiteSpace(email))
            {
                return false;
            }

            const string sql = "UPDATE dbo.UserTable SET Email = @Email WHERE UserId = @UserId;";
            var parameters = new[]
            {
                new SqlParameter("@Email", SqlDbType.NVarChar, 150) { Value = email.Trim() },
                new SqlParameter("@UserId", SqlDbType.Int) { Value = userId }
            };

            int rowsAffected = DatabaseConnection.ExecuteNonQuery(sql, parameters);
            return rowsAffected > 0;
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

        /// <summary>
        /// Retrieves all registered user accounts joined with student profiles (if any),
        /// supporting keyword search, role filtering, and account status filtering.
        /// </summary>
        public List<UserModel> GetAllUsers(string search = null, string roleFilter = null, string statusFilter = null)
        {
            var list = new List<UserModel>();

            string sql = @"
                SELECT u.UserId, u.Email, u.PasswordHash, u.PasswordSalt, u.Role, u.IsActive,
                       s.StudentId, s.FirstName, s.MiddleName, s.LastName, s.Gender, 
                       s.CampusBranch, s.Department, s.Program
                FROM dbo.UserTable u
                LEFT JOIN dbo.StudentTable s ON u.UserId = s.UserId
                WHERE 1=1";

            var parameters = new List<SqlParameter>();

            if (!string.IsNullOrWhiteSpace(search))
            {
                sql += @" AND (
                    u.Email LIKE @Search OR 
                    s.StudentId LIKE @Search OR 
                    s.FirstName LIKE @Search OR 
                    s.LastName LIKE @Search OR 
                    (s.FirstName + ' ' + s.LastName) LIKE @Search
                )";
                parameters.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 150) { Value = $"%{search.Trim()}%" });
            }

            if (!string.IsNullOrWhiteSpace(roleFilter) && !string.Equals(roleFilter, "ALL", StringComparison.OrdinalIgnoreCase))
            {
                sql += " AND u.Role = @Role";
                parameters.Add(new SqlParameter("@Role", SqlDbType.VarChar, 50) { Value = roleFilter.Trim() });
            }

            if (!string.IsNullOrWhiteSpace(statusFilter) && !string.Equals(statusFilter, "ALL", StringComparison.OrdinalIgnoreCase))
            {
                if (statusFilter.Equals("Active", StringComparison.OrdinalIgnoreCase))
                {
                    sql += " AND u.IsActive = 1";
                }
                else if (statusFilter.Equals("Locked", StringComparison.OrdinalIgnoreCase) || statusFilter.Equals("Inactive", StringComparison.OrdinalIgnoreCase))
                {
                    sql += " AND u.IsActive = 0";
                }
            }

            sql += " ORDER BY u.UserId DESC;";

            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, parameters.ToArray());
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    list.Add(MapRowToUserModel(row));
                }
            }

            return list;
        }

        /// <summary>
        /// Updates the access control role of a target user account while enforcing strict RBAC guards.
        /// Prevents self-demotion and ensures at least one active Administrator always exists.
        /// </summary>
        public bool UpdateUserRole(int targetUserId, string newRole, int currentAdminUserId)
        {
            if (targetUserId <= 0)
            {
                throw new ArgumentException("Target UserId must be valid.", nameof(targetUserId));
            }

            string cleanRole = newRole?.Trim();
            if (cleanRole != RoleAdmin && cleanRole != RoleStudent)
            {
                throw new ArgumentException($"Invalid role '{cleanRole}'. Allowed roles are '{RoleAdmin}' or '{RoleStudent}'.", nameof(newRole));
            }

            // Guard 1: Prevent an admin from demoting themselves
            if (targetUserId == currentAdminUserId && cleanRole != RoleAdmin)
            {
                throw new InvalidOperationException("Security Violation: You cannot revoke Administrator privileges from your own active session account.");
            }

            // Guard 2: If demoting an admin, ensure at least one other active admin remains
            if (cleanRole == RoleStudent)
            {
                const string countAdminsSql = "SELECT COUNT(1) FROM dbo.UserTable WHERE Role = 'Admin' AND IsActive = 1 AND UserId != @TargetUserId;";
                var countParam = new SqlParameter("@TargetUserId", SqlDbType.Int) { Value = targetUserId };
                int remainingAdmins = Convert.ToInt32(DatabaseConnection.ExecuteScalar(countAdminsSql, countParam));

                if (remainingAdmins <= 0)
                {
                    throw new InvalidOperationException("Action Blocked: At least one active Administrator account must remain in the institution to prevent system lockout.");
                }
            }

            const string updateSql = "UPDATE dbo.UserTable SET Role = @Role WHERE UserId = @UserId;";
            var parameters = new[]
            {
                new SqlParameter("@Role", SqlDbType.VarChar, 50) { Value = cleanRole },
                new SqlParameter("@UserId", SqlDbType.Int) { Value = targetUserId }
            };

            int rows = DatabaseConnection.ExecuteNonQuery(updateSql, parameters);
            return rows > 0;
        }

        /// <summary>
        /// Toggles active/locked status for a user with authorization guards against self-lockout.
        /// </summary>
        public bool ToggleUserActiveStatus(int targetUserId, int currentAdminUserId)
        {
            if (targetUserId <= 0)
            {
                return false;
            }

            if (targetUserId == currentAdminUserId)
            {
                throw new InvalidOperationException("Security Violation: You cannot deactivate or lock your own active administrative account.");
            }

            // Verify if target is an Admin being locked out; verify other active Admins exist
            var targetUser = GetUserById(targetUserId);
            if (targetUser != null && targetUser.Role == RoleAdmin && targetUser.IsActive)
            {
                const string countSql = "SELECT COUNT(1) FROM dbo.UserTable WHERE Role = 'Admin' AND IsActive = 1 AND UserId != @TargetUserId;";
                var p = new SqlParameter("@TargetUserId", SqlDbType.Int) { Value = targetUserId };
                int otherAdmins = Convert.ToInt32(DatabaseConnection.ExecuteScalar(countSql, p));
                if (otherAdmins <= 0)
                {
                    throw new InvalidOperationException("Action Blocked: Cannot deactivate the last remaining active Administrator account.");
                }
            }

            const string toggleSql = "UPDATE dbo.UserTable SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE UserId = @UserId;";
            var param = new SqlParameter("@UserId", SqlDbType.Int) { Value = targetUserId };
            int rows = DatabaseConnection.ExecuteNonQuery(toggleSql, param);
            return rows > 0;
        }

        /// <summary>
        /// Administrative password reset using PBKDF2 cryptography.
        /// </summary>
        public bool AdminResetPassword(int targetUserId, string newPlainPassword)
        {
            if (targetUserId <= 0)
            {
                throw new ArgumentException("Target UserId must be valid.", nameof(targetUserId));
            }

            if (string.IsNullOrWhiteSpace(newPlainPassword) || newPlainPassword.Length < 6)
            {
                throw new ArgumentException("New password must be at least 6 characters.", nameof(newPlainPassword));
            }

            string salt = PasswordHelper.GenerateSalt();
            string hash = PasswordHelper.HashPassword(newPlainPassword.Trim(), salt);

            return UpdatePassword(targetUserId, hash, salt);
        }

        /// <summary>
        /// Creates a new institutional administrative user account.
        /// </summary>
        public int CreateAdminUser(string email, string plainPassword)
        {
            if (string.IsNullOrWhiteSpace(email))
            {
                throw new ArgumentException("Institutional email is required.", nameof(email));
            }

            if (string.IsNullOrWhiteSpace(plainPassword) || plainPassword.Length < 6)
            {
                throw new ArgumentException("Password must be at least 6 characters in length.", nameof(plainPassword));
            }

            if (EmailExists(email.Trim()))
            {
                throw new InvalidOperationException($"The email '{email.Trim()}' is already registered in the system.");
            }

            string salt = PasswordHelper.GenerateSalt();
            string hash = PasswordHelper.HashPassword(plainPassword.Trim(), salt);

            var adminUser = new UserModel
            {
                Email = email.Trim(),
                PasswordHash = hash,
                PasswordSalt = salt,
                Role = RoleAdmin,
                IsActive = true
            };

            return CreateUser(adminUser);
        }

        /// <summary>
        /// Returns aggregate account metrics across the institution.
        /// </summary>
        public (int TotalAccounts, int ActiveAdmins, int TotalStudents, int LockedAccounts) GetAccountStatistics()
        {
            const string sql = @"
                SELECT 
                    COUNT(1) AS TotalAccounts,
                    COUNT(CASE WHEN Role = 'Admin' AND IsActive = 1 THEN 1 END) AS ActiveAdmins,
                    COUNT(CASE WHEN Role = 'Student' THEN 1 END) AS TotalStudents,
                    COUNT(CASE WHEN IsActive = 0 THEN 1 END) AS LockedAccounts
                FROM dbo.UserTable;";

            DataTable dt = DatabaseConnection.ExecuteDataTable(sql);
            if (dt != null && dt.Rows.Count > 0)
            {
                var r = dt.Rows[0];
                return (
                    Convert.ToInt32(r["TotalAccounts"]),
                    Convert.ToInt32(r["ActiveAdmins"]),
                    Convert.ToInt32(r["TotalStudents"]),
                    Convert.ToInt32(r["LockedAccounts"])
                );
            }

            return (0, 0, 0, 0);
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
