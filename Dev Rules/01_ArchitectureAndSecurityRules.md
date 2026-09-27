# Engineering & Security Directives: Architecture & Security Rules

- **Category:** Core Engineering Standards
- **Applies to:** Backend Models, Repositories, Helpers, Services, Data Access, and ASP.NET Web Forms Code-Behind.

---

## 1. Strict Layered Architecture

All codebase additions and refactorings must strictly follow the unidirectional layered architecture:

```text
[Presentation Layer (.aspx / .aspx.cs)]
                  │
                  ▼
[Helpers & Security Layer (Backend/Helpers/)]
                  │
                  ▼
[Repository Layer (Backend/Repository/)]
                  │
                  ▼
[Database Provider (DatabaseConnection.cs)]
                  │
                  ▼
[SQL Server Database (UniversityEventDB)]
```

### Directives:
1. **Zero Database Leaks in UI:** Never write raw SQL, instantiate `SqlConnection`, or execute ADO.NET commands inside `.aspx.cs` code-behind files. All data operations must flow through dedicated Repositories.
2. **Single Responsibility Repositories:** Each database table maps to its dedicated repository:
   * `dbo.UserTable` ➔ `UserRepository`
   * `dbo.StudentTable` ➔ `StudentRepository`
   * `dbo.EventsTable` ➔ `EventRepository`
   * `dbo.EventRegistrationTable` ➔ `RegistrationRepository`
   * `dbo.SponsorListTable` ➔ `SponsorRepository`
3. **Repository Connection Pooling:** Always route queries through `DatabaseConnection.cs` (`ExecuteNonQuery`, `ExecuteScalar`, `ExecuteDataTable`) to ensure connection pooling and proper disposal of SQL connections.

---

## 2. Model Design & Validation Boundary

1. **Clean POCO Models:** Keep entity models in `Backend/Models/` as clean Plain Old CLR Objects (POCOs) without unnecessary `[Required]`, `[StringLength]`, or `System.ComponentModel.DataAnnotations` attributes.
2. **Validation Layering:**
   * **UI Boundary Validation:** Field presence, string lengths, date formats, and regex validation are performed at the Presentation Layer (`.aspx.cs` code-behind) before invoking repositories.
   * **Domain & Defensive Validation:** Repositories validate non-null objects, valid primary keys (`id > 0`), and non-empty foreign keys, throwing explicit `ArgumentNullException` or `ArgumentException`.
3. **Computed Domain Helpers:** Models may expose read-only computed properties (e.g., `RemainingCapacity`, `IsRegistrationOpen`, `IsCheckedIn`, `CanCancel`) to prevent code duplication across UI pages.

---

## 3. Concurrency Control & Atomic Transactions

1. **Capacity Locks:** When reserving seats or modifying event capacity, always use SQL transactions with table locking hints:
   ```sql
   BEGIN TRANSACTION;
   SELECT @Current = CurrentRegistrations, @Max = MaxCapacity 
   FROM dbo.EventsTable WITH (UPDLOCK, HOLDLOCK)
   WHERE EventId = @EventId;
   -- Validate capacity and proceed or rollback
   ```
2. **Safe Counters:** Never increment or decrement numeric counters blindly. Always enforce lower and upper bounds:
   ```sql
   UPDATE dbo.EventsTable
   SET CurrentRegistrations = CASE 
                               WHEN CurrentRegistrations > 0 THEN CurrentRegistrations - 1 
                               ELSE 0 
                              END
   WHERE EventId = @EventId;
   ```

---

## 4. Defensive Security & Cryptography

1. **Zero Raw Password Storage:** Plain-text passwords must never be stored in `dbo.UserTable` or transmitted unhashed.
2. **PBKDF2 Cryptography:** Always use `PasswordHelper.cs` which enforces:
   * `Rfc2898DeriveBytes` with HMAC-SHA1
   * Minimum 10,000 hash iterations
   * 32-byte (256-bit) cryptographically random salt (`RNGCryptoServiceProvider`)
   * Constant-time byte array comparison (`SlowEquals`) to eliminate timing attacks.
3. **Parameterized SQL Only:** Every external parameter passed into SQL must use strongly-typed `SqlParameter` with explicit `SqlDbType` and length:
   ```csharp
   new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() }
   ```
   **Never concatenate strings to build SQL queries.**

---

## 5. Session State & Authorization Guards

1. **Centralized SessionHelper:** Never read or assign raw session strings like `Session["Role"]` directly in page code-behind. Always use `SessionHelper.cs`:
   * `SessionHelper.IsAuthenticated`
   * `SessionHelper.IsAdmin`
   * `SessionHelper.IsStudent`
   * `SessionHelper.CurrentUserId`
   * `SessionHelper.CurrentStudentId`
2. **Strict 2-Role System:** The application strictly supports only two roles:
   * `'Admin'` (University event administrators and coordinators)
   * `'Student'` (Enrolled university student attendees)
   * Any other role value must be rejected at authentication and persistence boundaries.
3. **Page Authorization Guards:** Protected pages must interrogate role rights on `Page_Init` or `Page_Load`:
   * Admin views: Redirect unauthorized requests to `~/Frontend/AccessDenied.aspx?reason=admin_required`.
   * Expired sessions: Redirect unauthenticated requests to `~/Frontend/Login/Login.aspx`.

---

## 6. Build Integrity & Solution Registration

1. **Project File Registration:** Every new `.cs`, `.aspx`, `.Master`, or asset file must be explicitly added to `241611JalopEventsManagement.csproj` under the appropriate `<Compile>` or `<Content>` ItemGroup with dependent relationships configured (`<DependentUpon>`).
2. **Zero-Warning Compilation:** Every change must be validated by running MSBuild against the solution file, requiring **0 Errors and 0 Warnings**.
