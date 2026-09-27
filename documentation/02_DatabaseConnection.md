# Architecture Documentation: DatabaseConnection Factory

- **Component:** [`DatabaseConnection`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/DatabaseConnection.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Database`
- **Assembly Target:** .NET Framework 4.7.2 / ADO.NET (`System.Data.SqlClient`)
- **Primary Configuration:** [`Web.config`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Web.config#L7-L11)

---

## 1. Architectural Purpose & Role

`DatabaseConnection` is the centralized database factory for the entire backend architecture. In accordance with the project's layered architectural rules:
1. **Zero Secret Hardcoding:** Reads connection strings through an established resolution hierarchy (`Web.config` primary, fallback, and environment variables).
2. **Defensive Resource Management:** Provides callers with `SqlConnection` instances designed for deterministic `using` scope disposal, preventing SQL Server connection pool exhaustion.
3. **Connectivity Health Check:** Exposes non-throwing diagnostic probes (`TestConnection`) for runtime readiness checks.

---

## 2. Public API Contract & Signatures

| Member | Signature | Purpose | Throws / Errors |
| :--- | :--- | :--- | :--- |
| `ConnectionString` | `public static string ConnectionString { get; }` | Returns the resolved connection string. | None |
| `CreateConnection()` | `public static SqlConnection CreateConnection()` | Creates and returns a new closed `SqlConnection`. | `InvalidOperationException` if connection string is missing/empty. |
| `GetOpenConnection()` | `public static SqlConnection GetOpenConnection()` | Creates, opens, and returns an active `SqlConnection`. | `InvalidOperationException` wrapping underlying `SqlException` if database is offline. |
| `TestConnection(out string)` | `public static bool TestConnection(out string errorMessage)` | Performs a diagnostic `SELECT 1;` health ping. | None (safe boolean return). |

---

## 3. Internal Mechanics & Operational Flow

```text
[Repository Layer / Service]
            │
            ▼
DatabaseConnection.GetOpenConnection()
            │
            ├──► Check CachedConnectionString
            │       ├── 1. ConfigurationManager.ConnectionStrings["UniversityEventDBConnection"]
            │       ├── 2. ConfigurationManager.ConnectionStrings["DefaultConnection"]
            │       └── 3. Environment.GetEnvironmentVariable("UNIVERSITY_EVENT_DB_CONN")
            │
            ├──► Instantiate new SqlConnection(CachedConnectionString)
            │
            ├──► connection.Open()
            │       │
            │       ├── Success ──► Return open SqlConnection
            │       └── Failure ──► Dispose connection, throw sanitized InvalidOperationException
            ▼
[using (var conn = ...)] (Deterministic disposal returns connection to ADO.NET Pool)
```

---

## 4. Usage Patterns in Repositories

### Standard Command Execution (Safe Parameterized Query)
```csharp
using _241611JalopEventsManagement.Backend.Database;

public StudentModel GetStudentById(string studentId)
{
    const string sql = @"
        SELECT StudentId, FirstName, LastName, CampusBranch, Department, Program 
        FROM dbo.StudentTable 
        WHERE StudentId = @StudentId;";

    using (var conn = DatabaseConnection.GetOpenConnection())
    using (var cmd = new SqlCommand(sql, conn))
    {
        cmd.Parameters.Add("@StudentId", SqlDbType.VarChar, 50).Value = studentId;

        using (var reader = cmd.ExecuteReader())
        {
            if (reader.Read())
            {
                return new StudentModel
                {
                    StudentId = reader["StudentId"].ToString(),
                    FirstName = reader["FirstName"].ToString(),
                    LastName = reader["LastName"].ToString(),
                    CampusBranch = reader["CampusBranch"].ToString(),
                    Department = reader["Department"].ToString(),
                    Program = reader["Program"].ToString()
                };
            }
        }
    }
    return null;
}
```
