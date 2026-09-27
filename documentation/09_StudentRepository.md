# Repository Documentation: StudentRepository

- **Component:** [`StudentRepository`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/StudentRepository.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Repository`
- **Target Entity / Table:** [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L19-L32) (`dbo.StudentTable`)
- **Associated Model:** [`StudentProfile`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/StudentProfile.cs)

---

## 1. Architectural Purpose & Role

The `StudentRepository` serves as the dedicated data access layer for all academic demographics and student identity records residing in `dbo.StudentTable`. By separating `StudentRepository` from [`UserRepository`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/UserRepository.cs), the application strictly adheres to the Single Responsibility Principle:
- **`UserRepository`:** Governs authentication identity, credentials (`PasswordHash`, `PasswordSalt`), account status (`IsActive`), and role permissions (`'Admin'` vs `'Student'`).
- **`StudentRepository`:** Governs university demographic profiles, matriculation identifier uniqueness (`StudentId`), academic program affiliations (`CampusBranch`, `Department`, `Program`), and personal information (`Gender`).

This clear boundary ensures that higher-level registration, event attendance tracking, and audience matrix verification logic can access student profile records without conflating authentication security concerns.

---

## 2. Granular Function Breakdown

### 2.1 `GetStudentByUserId`
* **Purpose:** Retrieves a student's full demographic profile by their associated user account foreign key (`UserId`).
* **Signature & Contracts:**
  - Input: `int userId` (Must be greater than 0).
  - Output: [`StudentProfile`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/StudentProfile.cs) or `null` if no profile matches.
* **Internal Mechanics:**
  - Executes a parameterized SQL `SELECT` against `dbo.StudentTable WHERE UserId = @UserId`.
  - Hydrates and returns a `StudentProfile` object mapping `StudentId`, `FirstName`, `MiddleName`, `LastName`, `Gender`, `CampusBranch`, `Department`, `Program`, and `UserId`.
* **When It Is Used:**
  - Invoked during user login (`Login.aspx.cs`) when a user with the `'Student'` role logs in with their email address, populating session demographic state.
  - Invoked on student profile pages and dashboards to display account information.

---

### 2.2 `GetStudentById`
* **Purpose:** Retrieves a student's profile using their unique matriculation string identifier (`StudentId`).
* **Signature & Contracts:**
  - Input: `string studentId` (Cannot be null, empty, or whitespace).
  - Output: [`StudentProfile`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/StudentProfile.cs) or `null` if not found.
* **Internal Mechanics:**
  - Executes a parameterized query `SELECT ... FROM dbo.StudentTable WHERE StudentId = @StudentId;`.
  - Uses `SqlParameter("@StudentId", SqlDbType.VarChar, 50)`.
* **When It Is Used:**
  - Invoked during QR code event check-in scans (`CheckIn.aspx`) to verify student identity prior to recording attendance.
  - Used in administrative attendee verification lookups and event registration badge generation.

---

### 2.3 `CreateStudent`
* **Purpose:** Inserts a newly provisioned student profile linked to an existing user account in `dbo.UserTable`.
* **Signature & Contracts:**
  - Input: `StudentProfile student` (Requires non-empty `StudentId` and `UserId > 0`).
  - Output: `bool` (`true` if inserted successfully; `false` otherwise).
* **Internal Mechanics:**
  - Validates `student != null`, `StudentId` is non-empty, and `UserId > 0`.
  - Executes a parameterized `INSERT INTO dbo.StudentTable` containing all demographic fields.
  - Safely handles optional fields (`MiddleName`) by passing `DBNull.Value` if null.
* **When It Is Used:**
  - Invoked during the student onboarding or registration flow after a `UserModel` account has been created and issued a `UserId`.
  - Invoked in administrative user provisioning tools when enrolling new students.

---

### 2.4 `UpdateStudent`
* **Purpose:** Updates existing demographic and academic affiliation details for a student.
* **Signature & Contracts:**
  - Input: `StudentProfile student` (Requires valid `StudentId`).
  - Output: `bool` (`true` if rows affected > 0; `false` otherwise).
* **Internal Mechanics:**
  - Executes a parameterized `UPDATE dbo.StudentTable` updating `FirstName`, `MiddleName`, `LastName`, `Gender`, `CampusBranch`, `Department`, and `Program` where `StudentId = @StudentId`.
* **When It Is Used:**
  - Invoked when a student updates their personal profile information.
  - Invoked by registrar administrators when correcting student records or recording changes in academic department/program.

---

### 2.5 `StudentIdExists`
* **Purpose:** Verifies whether a given student matriculation number is already registered in the system.
* **Signature & Contracts:**
  - Input: `string studentId`
  - Output: `bool` (`true` if found; `false` otherwise).
* **Internal Mechanics:**
  - Executes an optimized count query: `SELECT COUNT(1) FROM dbo.StudentTable WHERE StudentId = @StudentId;` via `DatabaseConnection.ExecuteScalar`.
* **When It Is Used:**
  - Invoked during pre-registration boundary validation to ensure matriculation IDs cannot be duplicated.

---

## 3. Operational Flow in Layered Architecture

```text
[Web Forms UI (Login.aspx / Profile.aspx)]
                   │
                   ▼
       [SessionHelper / Services]
                   │
                   ▼
         [StudentRepository]
       ┌───────────┴───────────┐
       ▼                       ▼
[StudentProfile (POCO)]  [DatabaseConnection]
                               │
                               ▼
                       [dbo.StudentTable]
```
