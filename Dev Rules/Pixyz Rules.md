\# Antigravity AI Workspace Rules & Engineering Directives

\#\# 1\. Architectural Integrity & Data Layering  
\* \*\*Adhere to Layered Architecture:\*\* When writing or refactoring any data access, mutation, or query logic, you MUST strictly adhere to the project's layered architectural pattern (Controller/API Handler \-\> Service Layer \-\> Repository Layer \-\> Database Schema/Models).  
\* \*\*Zero Direct Leaks:\*\* NEVER write raw database queries or direct table access within UI components, controllers, or route handlers. All database operations must flow through dedicated Repository/Service interfaces.  
\* \*\*Schema & Model Grounding:\*\* Before creating or modifying any data-handling function:  
  1\. Inspect the existing database schemas, migration files, and table constraints.  
  2\. Inspect the corresponding entity models, types, and Data Transfer Objects (DTOs).  
  3\. Ensure all fields, types, foreign key relationships, and nullability constraints match the single source of truth.

\---

\#\# 2\. Code Generation & Reasoning Transparency  
\* \*\*Targeted Code Snippets:\*\* Provide concrete, complete, and syntactically correct code snippets for all proposed changes. Clearly indicate file paths and whether the snippet replaces an existing method or introduces a new module.  
\* \*\*Step-by-Step Logic Breakdown:\*\* For every non-trivial implementation or code modification, explicitly output a numbered, step-by-step explanation detailing:  
  1\. \*\*Objective:\*\* What problem the solution solves.  
  2\. \*\*Architectural Path:\*\* Which models, services, and repositories are affected and why.  
  3\. \*\*Implementation Steps:\*\* The chronological sequence of how the logic was constructed.  
  4\. \*\*Edge Cases Handled:\*\* Concurrency controls, input sanitization, error handling, or validation rules included.

\---

\#\# 3\. Project Documentation Hierarchy & Function Breakdown  
All architectural artifacts, workflows, schemas, and API contracts must be systematically maintained inside the \`/documentation\` directory.   
\* \*\*Living Documentation Rule:\*\* Whenever a new repository function, service method, or schema migration is generated, update or create the corresponding markdown file in the relevant \`/documentation/\` subfolder.  
\* \*\*Granular Function Explanations:\*\* Every documented function must include an internal operational breakdown:  
  1\. \*\*Purpose:\*\* A single-sentence summary of what the function accomplishes.  
  2\. \*\*Signature & Contracts:\*\* Expected inputs (types, constraints, optionality) and return structure.  
  3\. \*\*Internal Mechanics:\*\* Step-by-step breakdown of how the function works under the hood (data transformations, queries executed, third-party services invoked).  
  4\. \*\*Side Effects & Thrown Errors:\*\* Any state mutations, database writes, cache updates, or exceptions/error codes the caller must handle.

\---

\#\# 4\. UI/UX Consistency & Design System Alignment  
\* \*\*Strict Theme Compliance:\*\* All styling, layout structures, and UI components MUST strictly inherit and adhere to the established design system, color palette, typography scale, spacing units, and component themes of the existing application.  
\* \*\*Zero Rogue Styling:\*\* NEVER invent arbitrary one-off styles, arbitrary hex codes, or conflicting CSS frameworks. Always leverage existing theme variables, CSS custom properties, utility classes, or shared UI design tokens.  
\* \*\*Visual Harmony:\*\* Match the interaction paradigms (e.g., hover states, transition timings, button padding, border radiuses, dark/light mode tokens) of neighboring and existing views to preserve a unified user experience.

\---

\#\# 5\. Scope Control & Minimal Diff Restraint  
\* \*\*Surgical Modifications:\*\* Modify only the functions, files, and lines strictly required to complete the objective. Never refactor surrounding code, reorder imports, or reformat entire files unless explicitly instructed.  
\* \*\*Preserve Project Style:\*\* Match the existing naming conventions, indentation, code idioms, and file structure found in the surrounding codebase.  
\* \*\*No Unsolicited Removals:\*\* Do not delete existing code comments, todo notices, or helper functions that seem unused without explicit confirmation.

\---

\#\# 6\. Defensive Security & Data Protection  
\* \*\*No Hardcoded Secrets:\*\* NEVER hardcode API keys, database credentials, encryption tokens, IP addresses, or secrets. Always read from environment variables or dedicated secret management services.  
\* \*\*Strict Input Validation:\*\* Treat all external inputs (request payloads, URL parameters, file uploads, headers) as untrusted. Validate types, formats, ranges, and lengths at system boundaries before processing.  
\* \*\*Injection Prevention:\*\* Never use raw string concatenation or interpolation when constructing database queries, shell commands, or dynamic templates. Always use parameterized statements or validated APIs.

\---

\#\# 7\. Error Handling & Observability  
\* \*\*No Silent Failures:\*\* Never write empty \`catch\` blocks or swallow errors. Catch blocks must log meaningful context and either handle the failure gracefully or bubble up a structured error.  
\* \*\*Contextual Error Messages:\*\* Provide clear, actionable error messages that explain what failed, why it failed, and what parameters caused the failure—without exposing sensitive internal stack traces to end users.  
\* \*\*Explicit Boundary Handling:\*\* Always account for edge cases before writing core logic: empty arrays/lists, \`null\`/\`undefined\` references, zero values, network timeouts, and boundary limits.

\---

\#\# 8\. Testability & Verification  
\* \*\*Decoupled Business Logic:\*\* Keep business logic decoupled from transport layers (e.g., HTTP requests, UI view rendering, CLI outputs) so core algorithms can be unit tested in isolation.  
\* \*\*Provide Verification Steps:\*\* Whenever generating a new feature or bug fix, always include:  
  1\. A clear command or method to verify the fix works.  
  2\. Edge-case test cases to validate boundaries and failure paths.

