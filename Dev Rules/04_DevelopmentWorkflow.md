# Development Workflow & Engineering Protocol

- **Category:** Agent Directives, Code Generation & Communication Protocol
- **Applies to:** Pair Programming Iterations, Feature Delivery, Verification & Documentation.

---

## 1. Response Structure & Transparency Mandate

For every non-trivial implementation, refactoring, or feature addition, the response must provide a numbered, step-by-step logic breakdown:

1. **Objective:** A concise statement defining the problem being solved or feature introduced.
2. **Architectural Path:** Which models, repositories, helpers, or UI views are affected and why.
3. **Implementation Steps:** Chronological sequence detailing how the changes were designed, constructed, and registered.
4. **Edge Cases Handled:** Concurrency controls, input sanitization, error traps, or lifecycle boundaries accounted for.

---

## 2. Living Documentation Protocol

All architectural artifacts, models, repositories, and UI systems must be documented inside `/documentation/`.

### Granular Function Documentation Template:
Whenever a function or endpoint is documented, it must follow this exact template:

* **Purpose:** Single-sentence summary of what the function accomplishes.
* **Signature & Contracts:** Input parameters, types, nullability, and return structure.
* **Internal Mechanics:** Step-by-step execution breakdown (SQL statements, queries, transactions, mapping).
* **Side Effects & Thrown Errors:** Mutations, exceptions (`ArgumentNullException`, `InvalidOperationException`), or status codes.
* **When it is used:** Exact lifecycle stage or user action triggering execution (e.g., *Post-authentication on Login.aspx*, *During QR scan on CheckIn.aspx*).
* **Why:** The technical rationale, session/state dependencies, and database/code references:
  * `[Code snippet, Session key, or Table.ColumnReference]`

---

## 3. Pre-Flight Verification & Testing Protocol

Before marking any task as complete:

1. **MSBuild Compilation Check:**
   Compile the solution file to ensure zero errors and zero warnings:
   ```powershell
   & "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" "c:\Martin Archive\Programming\ASP NET\241611JalopEventsManagement\241611JalopEventsManagement.sln" /t:Build /p:Configuration=Debug
   ```
2. **IIS Express Runtime Validation:**
   Verify that the target page returns an HTTP `200 OK` status against the running server on port `51717`:
   ```powershell
   Invoke-WebRequest -Uri "http://localhost:51717/Frontend/Admin/Dashboard.aspx" -UseBasicParsing | Select-Object StatusCode, StatusDescription
   ```
3. **Project File Registration Check:**
   Verify that any newly created `.cs`, `.aspx`, `.Master`, or `.sql` file has been properly registered inside `241611JalopEventsManagement.csproj`.

---

## 4. Code Preservation & Minimal Diff Restraint

1. **Surgical Modifications:** Only modify lines strictly necessary to fulfill the request. Never reorder unrelated imports or reformat entire files.
2. **Preserve Documentation & Comments:** Never delete existing docstrings, summary blocks, or comments unless explicitly requested.
3. **Style & Idioms:** Follow the existing C# 7.3 / .NET Framework 4.7.2 idioms and ASP.NET Web Forms paradigms present across the repository.

---

## 5. Communication & Link Standards

1. **Clickable Links:** Always use GitHub-style markdown links with the `file:///` scheme (with forward slashes) for all referenced files, classes, methods, and line numbers:
   * `[EventRepository.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/EventRepository.cs)`
2. **Concise & Direct:** Keep explanations professional, precise, and actionable without conversational filler.
