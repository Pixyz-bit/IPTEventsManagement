# Helper Architecture Documentation: PasswordHelper & SessionHelper

- **Location:** `Backend/Helpers/`
- **Components:**
  - Cryptography Helper: [`Backend/Helpers/PasswordHelper.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Helpers/PasswordHelper.cs)
  - State & Security Helper: [`Backend/Helpers/SessionHelper.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Helpers/SessionHelper.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Helpers`

---

## 1. Architectural Purpose & Organization

To maintain high maintainability and prevent code duplication or security fragmentation, cross-cutting backend utility classes are consolidated under the dedicated namespace and directory `_241611JalopEventsManagement.Backend.Helpers`:

1. **`PasswordHelper`:** Encapsulates zero-compromise PBKDF2 salting and hashing routines with constant-time byte comparisons to protect user credentials against rainbow table and side-channel timing attacks.
2. **`SessionHelper`:** Encapsulates strongly-typed HTTP session state management, role authorization interrogations (`IsAdmin`, `IsStudent`), and user identity extraction, eliminating string typing bugs across all ASP.NET Web Forms code-behind files.

---

## 2. PasswordHelper Breakdown

### 2.1 Technical Specifications
- **Algorithm:** PBKDF2 (`Rfc2898DeriveBytes`) with HMAC-SHA1
- **Iteration Count:** 10,000 rounds
- **Salt Byte Size:** 32 bytes (256 bits), generated via `RNGCryptoServiceProvider`
- **Hash Byte Size:** 32 bytes (256 bits)
- **Format:** Base64 encoded strings for seamless database persistence in `dbo.UserTable.PasswordHash` and `dbo.UserTable.PasswordSalt`.

### 2.2 Method Contracts & When It Is Used

#### `PasswordHelper.GenerateSalt()`
- **Signature:** `public static string GenerateSalt()`
- **Purpose:** Produces a cryptographically secure random salt.
- **When It Is Used:** Invoked during user account provisioning or password resets prior to hashing the user's plain-text password.

#### `PasswordHelper.HashPassword(string password, string salt)`
- **Signature:** `public static string HashPassword(string password, string salt)`
- **Purpose:** Derives a 256-bit PBKDF2 hash using the provided password and salt string.
- **When It Is Used:** Invoked during account registration and password reset workflows.

#### `PasswordHelper.VerifyPassword(string enteredPassword, string storedHash, string storedSalt)`
- **Signature:** `public static bool VerifyPassword(string enteredPassword, string storedHash, string storedSalt)`
- **Purpose:** Recomputes the hash of `enteredPassword` using `storedSalt` and compares it to `storedHash` using a constant-time equality check (`SlowEquals`).
- **When It Is Used:** Invoked on `Login.aspx.cs` when authenticating user credentials.

---

## 3. SessionHelper Breakdown

### 3.1 Session Keys Standardized
All session access is centralized to prevent hard-coded string key discrepancies:
- `UserId` (`int`)
- `Role` (`string`) – Strictly `'Admin'` or `'Student'`
- `Email` (`string`)
- `StudentId` (`string`)
- `FirstName` (`string`)
- `LastName` (`string`)
- `Gender` (`string`)
- `CampusBranch` (`string`)
- `Department` (`string`)
- `Program` (`string`)

### 3.2 Property & Method Contracts & When It Is Used

#### `SessionHelper.IsAuthenticated`
- **Signature:** `public static bool IsAuthenticated => CurrentUserId > 0 && !string.IsNullOrEmpty(CurrentUserRole);`
- **When It Is Used:** Invoked in `Page_Init` or `Page_Load` across all protected pages to check whether a valid session ticket exists, redirecting to `Login.aspx` if expired.

#### `SessionHelper.IsAdmin` and `SessionHelper.IsStudent`
- **Signature:** `public static bool IsAdmin` / `public static bool IsStudent`
- **When It Is Used:**
  - Evaluated on administrative pages (`Frontend/Admin/*`) to prevent unauthorized student access, redirecting to `AccessDenied.aspx`.
  - Evaluated on student portals (`Frontend/User/*`) to configure personalized student views.

#### `SessionHelper.InitializeSession(UserModel user, StudentProfile profile = null)`
- **Signature:** `public static void InitializeSession(UserModel user, StudentProfile profile = null)`
- **Purpose:** Populates all identity and demographic session keys in a single atomic call upon successful credential verification.
- **When It Is Used:** Called exclusively in `Login.aspx.cs` immediately after password verification succeeds.

#### `SessionHelper.ClearSession()`
- **Signature:** `public static void ClearSession()`
- **Purpose:** Calls `Session.Clear()` and `Session.Abandon()` to cleanly terminate the user's active session.
- **When It Is Used:** Called upon logout (`Logout.aspx` / sign-out button click).
