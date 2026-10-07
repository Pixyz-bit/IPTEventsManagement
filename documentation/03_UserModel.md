# Model Documentation: UserModel

- **Component:** [`UserModel`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/UserModel.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Models`
- **Schema Mapping Source:** [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L8-L17) (`dbo.UserTable`)

---

## 1. Architectural Purpose & Role

The `UserModel` represents the user entity across authentication, session persistence, and repository queries. It bridges user input with the underlying `dbo.UserTable` storage format.

---

## 2. Properties & Data Contracts

| Property | Data Type | Nullability | Constraints & Validation | Schema Mapping Reference |
| :--- | :--- | :--- | :--- | :--- |
| `UserId` | `int` | No | Primary Key | `dbo.UserTable.UserId (INT IDENTITY, PK)` |
| `Email` | `string` | No | `[Required]`, `[EmailAddress]`, `[StringLength(150)]` | `dbo.UserTable.Email (NVARCHAR(150), NOT NULL)` |
| `Password` | `string` | No | `[Required]`, `[DataType(DataType.Password)]` | Plain-text credential during auth/registration |
| `Role` | `string` | No | `[StringLength(50)]` | `dbo.UserTable.Role (VARCHAR(50), NOT NULL)` |
| `IsActive` | `bool` | No | Default `true` | `dbo.UserTable.IsActive (BIT, NOT NULL, DEFAULT 1)` |

---

## 3. Operational Flow in Layered Architecture

```text
[Frontend / Login View]
           │
           ▼ (Transfers credentials via UserModel)
[Auth Service Layer]
           │ (Validates input, checks IsActive flag, verifies hash)
           ▼
[User Repository Layer]
           │ (Maps SQL columns <-> UserModel)
           ▼
[Database (dbo.UserTable)]
```
