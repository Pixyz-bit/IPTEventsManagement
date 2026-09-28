# University Event Management System: Engineering Rules & Directives

This directory contains the authoritative engineering standards, UI/UX design principles, domain state machines, and development workflows for the **241611 Jalop Events Management** ASP.NET Web Forms project.

---

## Directives Directory & Index

| File | Primary Focus | Key Standards |
| :--- | :--- | :--- |
| **[`Pixyz Rules.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/Dev%20Rules/Pixyz%20Rules.md)** | Core Foundation Directives | Layered architecture, living documentation requirement, defensive security, error handling. |
| **[`anti-ai-slop.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/Dev%20Rules/anti-ai-slop.md)** | Craftsmanship & Anti-Slop | Prohibition of Tailwind indigo `#6366f1`, two-stop gradients, emojis, and filler copy; guidelines for adding soul. |
| **[`01_ArchitectureAndSecurityRules.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/Dev%20Rules/01_ArchitectureAndSecurityRules.md)** | Architecture & Security | Clean POCO models, repository patterns, parameterized SQL, atomic `UPDLOCK, HOLDLOCK`, PBKDF2 cryptography, typed `SessionHelper`. |
| **[`02_UIUXDesignPrinciples.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/Dev%20Rules/02_UIUXDesignPrinciples.md)** | UI/UX & Design System | Dark slate palette tokens (`#090d16`, `#0d1322`), typography scales (`Plus Jakarta Sans`), 1.8px monoline SVGs, master page shells, preview mode fallback. |
| **[`03_BusinessRulesAndStateMachines.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/Dev%20Rules/03_BusinessRulesAndStateMachines.md)** | Business Rules & Logic | 4-tier audience matrix (NULL = Open to All), registration `'NoShow'` state machine, `RegEnd` cancellation deadline, atomic slot release. |
| **[`04_DevelopmentWorkflow.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/Dev%20Rules/04_DevelopmentWorkflow.md)** | Workflow & Verification | 4-part response breakdown, living documentation "When It Is Used" template, MSBuild verification, IIS Express port 51717 testing. |
| **[`05_PageInventoryAndStatusChecker.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/Dev%20Rules/05_PageInventoryAndStatusChecker.md)** | Page Inventory & Status Checker | Master matrix of all 16 project pages across modules, architectural dependencies, current completion state, and roadmap. |

---

## Active Server Environment
- **Platform:** ASP.NET Web Forms (.NET Framework 4.7.2, C# 7.3)
- **Local Test Server:** IIS Express running at **`http://localhost:51717`**
- **Database Engine:** Microsoft SQL Server (`localhost` / `UniversityEventDB`)
