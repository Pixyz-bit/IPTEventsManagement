# Model Documentation: StudentProfile

- **Component:** [`StudentProfile`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/StudentProfile.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Models`
- **Schema Mapping Source:** [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L19-L32) (`dbo.StudentTable`)

---

## 1. Architectural Purpose & Role

The `StudentProfile` model represents the academic demographics and personal identity of a student enrolled in the university. It encapsulates student matriculation numbers, campus branches, colleges/departments, programs, and gender identity.

It is linked 1:1 with [`UserModel`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/UserModel.cs) via `UserId`, cleanly separating authentication security credentials from academic demographic profiles.

---

## 2. Properties & Data Contracts

| Property | Data Type | Nullability | Description & Schema Mapping |
| :--- | :--- | :--- | :--- |
| `StudentId` | `string` | No | Institutional student matriculation number (`dbo.StudentTable.StudentId (VARCHAR(50), PK)`). |
| `FirstName` | `string` | No | Student first name (`dbo.StudentTable.FirstName (NVARCHAR(100), NOT NULL)`). |
| `MiddleName` | `string` | Yes | Student middle name (`dbo.StudentTable.MiddleName (NVARCHAR(100), NULL)`). |
| `LastName` | `string` | No | Student surname (`dbo.StudentTable.LastName (NVARCHAR(100), NOT NULL)`). |
| `Gender` | `string` | No | Student gender identity (`dbo.StudentTable.Gender (VARCHAR(20), NOT NULL)`). |
| `CampusBranch` | `string` | No | Enrolled campus branch (`dbo.StudentTable.CampusBranch (NVARCHAR(100), NOT NULL)`). |
| `Department` | `string` | No | College / academic division (`dbo.StudentTable.Department (NVARCHAR(100), NOT NULL)`). |
| `Program` | `string` | No | Degree program / course code (`dbo.StudentTable.Program (NVARCHAR(100), NOT NULL)`). |
| `UserId` | `int` | No | Foreign key linking 1:1 to `dbo.UserTable.UserId`. |
| `FullName` | `string` | No | Computed read-only property concatenating First, Middle, and Last names. |

---

## 3. Operational Flow in Layered Architecture

```text
[Login.aspx / User Input]
           │
           ▼
[UserRepository.GetUserByIdentifier]
           │ (Joins dbo.UserTable with dbo.StudentTable)
           ▼
[UserModel.StudentProfile] ──► Populates Session["StudentId"], Session["CampusBranch"], etc.
           │
           ▼
[Student Events Portal (Dashboard.aspx)]
           │ (Filters EventsTable using 4-tier audience matrix)
```
