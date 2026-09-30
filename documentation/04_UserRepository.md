# Repository Documentation: UserRepository

- **Component:** [`UserRepository`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/UserRepository.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Repository`
- **Target Entity / Table:** [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L8-L17) (`dbo.UserTable`)
- **Associated Model:** [`UserModel`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/UserModel.cs)

---

## 1. Architectural Purpose & Role

The `UserRepository` acts as the exclusive data access gateway for `dbo.UserTable`. It isolates all SQL statements, parameter mappings, and entity hydration away from higher-level service classes and UI pages, strictly adhering to the project's layered architectural directives.

Role constraints are strictly enforced: the repository only permits users with roles `'Admin'` or `'Student'`.

---

## 2. Granular Function Breakdown

### 2.1 `GetUserByEmail`
* **Purpose:** Retrieves a single user record by their unique institutional email address.
* **Signature & Contracts:**
  - Input: `string email` (Must not be null or whitespace).
  - Output: `UserModel` (Populated with `UserId`, `Email`, `PasswordHash`, `PasswordSalt`, `Role`, `IsActive`) or `null` if not found.
* **Internal Mechanics:**
  - Trims the input email and executes a parameterized `SELECT` query via `DatabaseConnection.ExecuteDataTable`.
  - Maps the first returned `DataRow` to a `UserModel` instance.
* **Side Effects & Thrown Errors:**
  - Read-only; no database state mutations. Returns `null` on empty input.

---

### 2.2 `GetUserById`
* **Purpose:** Retrieves a user entity by its primary key (`UserId`).
* **Signature & Contracts:**
  - Input: `int userId` (Must be greater than 0).
  - Output: `UserModel` or `null` if the record does not exist.
* **Internal Mechanics:**
  - Executes a parameterized `SELECT ... WHERE UserId = @UserId` query.
  - Hydrates and returns the matching `UserModel`.
* **Side Effects & Thrown Errors:**
  - Read-only. Returns `null` if `userId <= 0` or record not found.

---

### 2.3 `CreateUser`
* **Purpose:** Inserts a newly provisioned user record into `dbo.UserTable` and assigns the generated primary key.
* **Signature & Contracts:**
  - Input: `UserModel user` (Must contain valid `Email`, `PasswordHash`, `PasswordSalt`, and `Role`).
  - Output: `int` (The newly created `UserId`).
* **Internal Mechanics:**
  - Validates that `Role` is strictly `'Admin'` or `'Student'`.
  - Executes an `INSERT INTO dbo.UserTable` statement with parameterized values and retrieves `SCOPE_IDENTITY()`.
  - Assigns the generated ID back to `user.UserId`.
* **Side Effects & Thrown Errors:**
  - Persists a new row in SQL Server.
  - Throws `ArgumentNullException` if `user` is null.
  - Throws `ArgumentException` if `Email` is missing or `Role` is not `'Admin'` or `'Student'`.
  - Throws `InvalidOperationException` if hash/salt are unpopulated or identity retrieval fails.

---

### 2.4 `EmailExists`
* **Purpose:** Performs an efficient existence check for an email address to prevent duplicate registrations.
* **Signature & Contracts:**
  - Input: `string email`
  - Output: `bool` (`true` if registered; `false` otherwise).
* **Internal Mechanics:**
  - Executes `SELECT COUNT(1) FROM dbo.UserTable WHERE Email = @Email;` via `DatabaseConnection.ExecuteScalar`.
* **Side Effects & Thrown Errors:**
  - Read-only; returns `false` if `email` is null/empty.

---

### 2.5 `UpdateUserStatus`
* **Purpose:** Modifies account status (`IsActive`), enabling administrators to deactivate or reinstate user access.
* **Signature & Contracts:**
  - Input: `int userId`, `bool isActive`
  - Output: `bool` (`true` if a record was updated; `false` otherwise).
* **Internal Mechanics:**
  - Executes `UPDATE dbo.UserTable SET IsActive = @IsActive WHERE UserId = @UserId;` via `DatabaseConnection.ExecuteNonQuery`.
* **Side Effects & Thrown Errors:**
  - Mutates `IsActive` column in SQL Server.

---

### 2.6 `UpdatePassword`
* **Purpose:** Updates cryptographic credentials when a user resets or changes their password.
* **Signature & Contracts:**
  - Input: `int userId`, `string passwordHash`, `string passwordSalt`
  - Output: `bool`
* **Internal Mechanics:**
  - Parameterized `UPDATE` modifying `PasswordHash` and `PasswordSalt` for the specified `UserId`.
* **Side Effects & Thrown Errors:**
  - Mutates password credentials. Throws `ArgumentException` if hash or salt is empty.

---

### 2.7 `GetAllUsers`
* **Purpose:** Retrieves all user accounts joined with demographic records from `dbo.StudentTable`, supporting universal search, role filtering, and account status filtering.
* **Signature & Contracts:**
  - Input: `string search = null`, `string roleFilter = null`, `string statusFilter = null`.
  - Output: `List<UserModel>` (Populated with `StudentProfile` if student role).
* **When it is used:** Invoked on `Page_Load` and filter triggers in `Frontend/Admin/AccountManagement.aspx`.
* **Why:** Powers the central identity and access control table:
  * `[UserTable.UserId, StudentTable.UserId, AccountManagement.aspx]`

---

### 2.8 `UpdateUserRole`
* **Purpose:** Modifies a user's access control role while enforcing strict RBAC guards against self-demotion and ensuring system availability.
* **Signature & Contracts:**
  - Input: `int targetUserId`, `string newRole`, `int currentAdminUserId`.
  - Output: `bool`.
* **Internal Mechanics:**
  - Validates `newRole` is strictly `'Admin'` or `'Student'`.
  - Throws `InvalidOperationException` if an administrator attempts to revoke their own rights.
  - Verifies that at least one other active Administrator remains before allowing an Admin demotion.
* **When it is used:** Invoked when an Administrator changes an account's role in `Frontend/Admin/AccountManagement.aspx`.
* **Why:** Enforces zero unauthorized privilege escalation or accidental administrative lockout:
  * `[UserTable.Role, SessionHelper.CurrentUserId]`

---

### 2.9 `ToggleUserActiveStatus`
* **Purpose:** Toggles active / locked status (`IsActive`) with defensive guards preventing self-lockout or deactivation of the last remaining admin.
* **Signature & Contracts:**
  - Input: `int targetUserId`, `int currentAdminUserId`.
  - Output: `bool`.
* **When it is used:** Invoked on lockout/unlock triggers in `Frontend/Admin/AccountManagement.aspx`.
* **Why:** Immediately cuts off system access for suspended accounts while protecting administrative uptime:
  * `[UserTable.IsActive]`

---

### 2.10 `AdminResetPassword`
* **Purpose:** Securely resets a user's password using PBKDF2 cryptography with HMAC-SHA1 and a 32-byte salt.
* **Signature & Contracts:**
  - Input: `int targetUserId`, `string newPlainPassword`.
  - Output: `bool`.
* **When it is used:** Invoked when an Administrator executes a password dispatch in `Frontend/Admin/AccountManagement.aspx`.
* **Why:** Allows administrative credential recovery without ever storing or handling plain-text secrets in the database:
  * `[PasswordHelper.HashPassword, UserTable.PasswordHash]`

---

### 2.11 `CreateAdminUser`
* **Purpose:** Directly provisions an administrative user account in `dbo.UserTable` with active status and validated institutional email.
* **Signature & Contracts:**
  - Input: `string email`, `string plainPassword`.
  - Output: `int` (Generated `UserId`).
* **When it is used:** Invoked when creating a new administrator in `Frontend/Admin/AccountManagement.aspx`.
* **Why:** Establishes administrative accounts without requiring an academic student enrollment record:
  * `[UserTable.Role = 'Admin']`

---

### 2.12 `GetAccountStatistics`
* **Purpose:** Computes institutional account metrics (Total Accounts, Active Admins, Enrolled Students, Locked Accounts) in a single database aggregation.
* **Signature & Contracts:**
  - Input: None.
  - Output: `(int TotalAccounts, int ActiveAdmins, int TotalStudents, int LockedAccounts)`.
* **When it is used:** Invoked to render top KPI cards in `Frontend/Admin/AccountManagement.aspx`.
* **Why:** Provides instantaneous real-time identity governance telemetry:
  * `[UserTable.Role, UserTable.IsActive]`

