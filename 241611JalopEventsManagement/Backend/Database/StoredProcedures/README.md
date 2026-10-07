# Installing the repository stored procedures

This folder contains one file for each business repository and `00_InstallAll.sql`, a combined, self-contained installer. The combined file contains all 67 procedure definitions: it does not rely on `:r` includes or SQLCMD mode.

Installing procedures and changing C# to call them are two different steps. The C# migration is now implemented: all business repositories call the procedures in this folder. The installation script is unchanged from the version already provided. Once installed, rebuild/restart the application to use the new calls.

Verification: the application builds successfully; 12 database-free validation checks and 86 stored-procedure integration checks passed. Integration checks ran in a disposable LocalDB database, not the application database. Run `tests/Invoke-StoredProcedureRegression.ps1` after building to repeat them.

## Files

| File | Operations |
|---|---|
| `UserRepository.sql` | User lookups, account statistics, updates, and the queries used by account-management guards |
| `StudentRepository.sql` | Student directory, account creation, profile changes, and duplicate checks |
| `EventRepository.sql` | Event creation, catalog, audience filtering, history, capacity, and completion |
| `RegistrationRepository.sql` | Registrations, cancellation, scanner lookup, and attendance |
| `EventCancellationRepository.sql` | Whole-event cancellation |
| `SponsorRepository.sql` | Sponsor lookups, additions, and removal |
| `DatabaseConnection.sql` | Explains why opening connections and running commands remain in C#; it creates no procedure |
| `00_InstallAll.sql` | Installs every procedure above in one execution |

One repository can need several procedures. For example, creating a student uses a duplicate-check query, an account insert, and a profile insert. Keeping those separate allows the existing C# transaction and logic to remain intact.

## 1. Connect to the same SQL Server as the application

Open SQL Server Management Studio (SSMS). Use the server from `Web.config` under `UniversityEventDBConnection`, with the matching authentication method. The current application uses `localhost`, Windows authentication, and database `UniversityEventDB`.

Expand **Databases** and confirm `UniversityEventDB` exists and contains the application's five tables. Do not run migration `07_FinalDatabaseSchema.sql` on an existing database: that is a fresh-install schema, not this procedure installer.

The script requires SQL Server 2016 SP1 or later. You can inspect the installed version with:

```sql
SELECT CONVERT(varchar(100), SERVERPROPERTY('ProductVersion')) AS ProductVersion;
```

For a practice run, use a backup restored into a separate database and change the installer's `USE [UniversityEventDB]` to that database's name. Creating procedures requires `CREATE PROCEDURE` permission on the database and `ALTER` permission on the `dbo` schema.

## 2. Execute the combined installer

1. Choose **File > Open > File** in SSMS.
2. Open `Backend/Database/StoredProcedures/00_InstallAll.sql`.
3. Confirm its first `USE` statement names the correct database.
4. Make sure no small portion of the script is selected. SSMS executes only highlighted text if a selection exists.
5. Click **Execute**, or press **F5**.
6. Read the **Messages** tab. If any error appears, resolve it before switching the C# calls.

The installer creates or updates procedure definitions; it does not call the procedures, insert students, cancel events, or modify tables. `CREATE OR ALTER` means a second run updates the same procedure names. It can replace an existing procedure with the same name, so review before running against a database with custom procedures.

Do not run all individual files after running the combined installer. They contain the same definitions. Use an individual file later if you want to update only that repository's procedures.

## 3. Verify installation

Refresh **UniversityEventDB > Programmability > Stored Procedures**. Names begin with `dbo.usp_`.

You can also run:

```sql
USE [UniversityEventDB];
GO
SELECT SCHEMA_NAME(schema_id) AS SchemaName, name
FROM sys.procedures
WHERE name LIKE 'usp[_]Event[_]%'
   OR name LIKE 'usp[_]EventCancellation[_]%'
   OR name LIKE 'usp[_]Registration[_]%'
   OR name LIKE 'usp[_]Sponsor[_]%'
   OR name LIKE 'usp[_]Student[_]%'
   OR name LIKE 'usp[_]User[_]%'
ORDER BY name;
```

A read-only example is:

```sql
EXEC dbo.usp_Registration_GetEventAttendanceSummary @EventId = 1;
```

Replace `1` with an existing event ID. This returns `TotalRegistered` and `TotalCheckedIn`. An event with no registrations returns zero counts.

## 4. Understand what changes in C#

Current flow:

```text
C# repository sends SQL text -> SQL Server executes it
```

Stored-procedure flow:

```text
C# repository sends procedure name and parameters -> SQL Server executes the saved SQL
```

SQL installation alone does not switch the application. The migrated C# now sets `CommandType.StoredProcedure` and supplies the procedure name instead of the old SQL text.

For example, the lookup command for `UserRepository.GetUserById` becomes:

```csharp
using (var conn = DatabaseConnection.GetOpenConnection())
using (var cmd = new SqlCommand("dbo.usp_User_GetUserById", conn))
{
    cmd.CommandType = CommandType.StoredProcedure;
    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int)
    {
        Value = userId
    });

    var table = new DataTable();
    using (var adapter = new SqlDataAdapter(cmd))
    {
        adapter.Fill(table);
    }

    // Keep the repository's existing row-to-UserModel mapping and no-result handling.
}
```

Use `System.Data` and `System.Data.SqlClient`, which the repositories already import. `DatabaseConnection.ExecuteScalar`, `ExecuteNonQuery`, and `ExecuteDataTable` still support text commands for infrastructure/test use. Business repositories now use the dedicated `ExecuteProcedureScalar`, `ExecuteProcedureNonQuery`, and `ExecuteProcedureDataTable` helpers. Commands within existing C# transactions set their command type directly and retain the same connection and transaction.

## 5. Preserve current behavior when converting calls

The complete query-to-procedure list, with SQL parameter names and types, is in `documentation/StoredProcedureMapping.md` at the repository root.

- Keep existing C# validation, password hashing, sessions, duplicate checks, role checks, and result mapping.
- Keep the same `SqlConnection` and `SqlTransaction` when a method currently groups several commands. Each command becomes `new SqlCommand(procedureName, conn, trans)` with `CommandType.StoredProcedure`. Do not open separate connections for the account and student inserts.
- `SaveManagedAccount` continues to perform its administrator checks and call `SaveManagedProfile` inside the existing transaction.
- The SQL for registration, student cancellation, administrative voiding, and confirmed check-in already owns its own transaction. Those procedure bodies preserve the existing SQL transaction blocks and scalar result codes.
- The scripts deliberately use `SET NOCOUNT OFF`: existing `ExecuteNonQuery()` calls that check affected rows can continue using the same result. Procedures containing `SELECT` should use the same scalar or table-reading operation as before.
- Optional list filters now use nullable SQL parameters instead of appended SQL clauses. Preserve C# handling of `ALL`, whitespace, unknown values, and search wildcards as described in the mapping file.
- Scanner parsing and target-event-first/fallback decisions stay in C#. Pass the existing parsed ID and original query to the corresponding lookup procedures.
- Do not pass plain passwords to SQL. PasswordHelper still generates the hash and salt first.

After conversion, test login, CSV duplicates, student/account editing, event audience filtering, full capacity, registration cancellation, whole-event cancellation, and repeated QR check-in. Syntax validation alone does not prove integration or transaction behavior.

## Troubleshooting

- **Cannot open database:** connect to the correct server, confirm the database name, and check access.
- **Permission denied:** ask the database owner for the database/schema permissions described above.
- **Syntax error near OR:** check the SQL Server version; this script uses `CREATE OR ALTER`.
- **Could not find stored procedure:** check that installation succeeded on the exact database used by `Web.config`, and use the procedure names from the mapping.
- **Procedure expects a parameter:** use the names/types in the mapping; send `DBNull.Value` for required parameters whose values are null.

Reference: [Microsoft: create a stored procedure](https://learn.microsoft.com/en-us/sql/relational-databases/stored-procedures/create-a-stored-procedure) and [CREATE PROCEDURE syntax](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql).
