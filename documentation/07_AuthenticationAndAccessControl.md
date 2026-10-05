# Security & Architecture Documentation: Authentication and Access Control

- **Components:** 
  - Login View: [`Frontend/Login/Login.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Login/Login.aspx)
  - Login Code-Behind: [`Frontend/Login/Login.aspx.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Login/Login.aspx.cs)
  - Access Denied View: [`Frontend/AccessDenied.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/AccessDenied.aspx)
  - Cryptography Helper: [`Backend/Helpers/PasswordHelper.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Helpers/PasswordHelper.cs)
  - Session Helper: [`Backend/Helpers/SessionHelper.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Helpers/SessionHelper.cs)
  - User Repository: [`Backend/Repository/UserRepository.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/UserRepository.cs)
  - Student Repository: [`Backend/Repository/StudentRepository.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/StudentRepository.cs)

---

## 1. Architectural Purpose & Role

This module establishes access control and visual authentication for the University Event Management System:
1. **Unified Dual-Identifier Login:** Authenticates students via `StudentId` (e.g. `2024-00123`) or institutional email, and administrators via email.
2. **White & Blue Institutional Theme:** Adopts the university's visual identity featuring the circular Quezon City University seal, full-bleed campus building backdrop with royal blue sky overlay, and a crisp white elevated card (`#ffffff`) with royal blue inputs and focus accents (`#2563eb`).
3. **Cryptographic Salted Hashing:** Employs PBKDF2 (`Rfc2898DeriveBytes`) with 10,000 iterations and constant-time string comparisons to eliminate timing vulnerabilities.
4. **Session State Initialization:** Establishes session keys required for role authorization and the 4-tier audience matrix.
5. **Access Violation Trapping:** Catches unauthorized direct URL navigation and expired sessions via `AccessDenied.aspx`.

---

## 2. Session State Contract

Upon successful credential validation, the following session keys are populated:

| Session Key | Data Type | Populated Roles | Description |
| :--- | :--- | :--- | :--- |
| `Session["UserId"]` | `int` | `Admin`, `Student` | Primary key referencing `dbo.UserTable.UserId`. |
| `Session["Role"]` | `string` | `Admin`, `Student` | Authorization role ('Admin' or 'Student'). |
| `Session["Email"]` | `string` | `Admin`, `Student` | Institutional email address. |
| `Session["StudentId"]` | `string` | `Student` only | Institutional student matriculation ID. |
| `Session["CampusBranch"]`| `string` | `Student` only | University branch (matches `EventsTable.TargetBranch`). |
| `Session["Department"]` | `string` | `Student` only | Academic department (matches `EventsTable.TargetDepartment`). |
| `Session["Program"]` | `string` | `Student` only | Degree course/program (matches `EventsTable.TargetProgram`). |

---

## 3. Role-Based Routing Matrix

```text
[Credentials Submitted]
           │
           ▼
[UserRepository.GetUserByIdentifier]
           │
           ├──► User Not Found / Wrong Password ──► Display Error Message
           ├──► IsActive == false               ──► Display Deactivated Account Alert
           │
           ▼
[Establish Session State]
           │
           ├──► Role == "Admin"   ──► Redirect to ~/Frontend/Admin/AdminEvents.aspx
           └──► Role == "Student" ──► Redirect to ~/Frontend/User/Dashboard.aspx
```

---

## 4. Granular Function Breakdown

### 4.1 `PasswordHelper.HashPassword`
* **Purpose:** Computes a PBKDF2 cryptographic hash from a plain-text password and unique salt.
* **Signature & Contracts:**
  - Input: `string password`, `string salt`.
  - Output: `string` (Base64-encoded 256-bit hash).
* **When it is used:** Invoked during account registration and password resets before inserting into `dbo.UserTable`.
* **Why:** In [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L12-L13), plain-text passwords must never be stored. Salting ensures duplicate passwords produce unique hashes.

---

### 4.2 `PasswordHelper.VerifyPassword`
* **Purpose:** Validates entered login credentials against stored cryptographic hashes without leaking timing information.
* **Signature & Contracts:**
  - Input: `string enteredPassword`, `string storedHash`, `string storedSalt`.
  - Output: `bool` (`true` if hash matches; `false` otherwise).
* **When it is used:** Invoked on the login form button click handler (`Login.aspx.cs`).
* **Why:** Compares password hashes using a bitwise XOR loop (`SlowEquals`) to protect against timing attacks:
  * `[UserTable.PasswordHash, UserTable.PasswordSalt]`

---

### 4.3 `UserRepository.GetUserByIdentifier`
* **Purpose:** Performs a strict user lookup using `UserTable.Email` (Student ID login is explicitly disabled; students can only log in through their institutional email).
* **Signature & Contracts:**
  - Input: `string identifier` (Email address).
  - Output: `UserModel` (Populated with user credentials and joined student demographics).
* **When it is used:** Triggered immediately when the user clicks "Sign In to Portal" on [`Login.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Login/Login.aspx).
* **Why:** Enforces the institutional security rule where students must authenticate using their registered institutional email address:
  * `[UserTable.Email, UserTable.UserId, StudentTable.StudentId]`

---

## 5. Development & Testing Credentials

| Role | Email / Identifier | Password | Access Area |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@gmail.com` | `admin@gmail.com` | `~/Frontend/Admin/*` |
| **Student** | Registered Institutional Email (e.g. `*.qcu.edu.ph`) | Configured Student Password | `~/Frontend/User/*` |

> [!NOTE]
> Use `admin@gmail.com` / `admin@gmail.com` as the authoritative administrative test account across all automated browser testing and manual admin verification flows.


## Admin request enforcement (October 5, 2026)

All admin pages inherit Backend/Helpers/AdminPage.cs. Its OnPreInit rejects anonymous sessions before controls load or postback handlers run, and rejects authenticated non-admin sessions. The master page also checks access. AttendanceScanner.LookupAttendee and CommitCheckIn enforce the same checks independently because static page methods bypass the normal page lifecycle. Anonymous admin preview access has been removed. The administrator landing page is AdminEvents.aspx; the former admin dashboard and its dedicated stylesheet have been removed.

Student pages (Dashboard, StudentProfile, EventRegistration, and EventPass) inherit StudentPage. OnPreInit redirects anonymous requests to login and other roles to AccessDenied before controls load or postback handlers run. Student demo banners, fabricated profiles, events, registrations, and simulated cancellation success have been removed. Event passes and cancellation requests must belong to the current student.
