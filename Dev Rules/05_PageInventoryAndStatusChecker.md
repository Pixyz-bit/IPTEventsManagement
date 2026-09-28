# University Event Management System: Page Inventory & Status Checker

- **Category:** Architecture Specification, Living Deliverables Matrix & Completion Checker
- **Authoritative Source:** QCU Event Management System Technical Specification
- **Target Platform:** ASP.NET Web Forms (.NET Framework 4.7.2, C# 7.3)
- **Local Server:** IIS Express (`http://localhost:51717`)
- **Last Updated:** 2026-09-28

---

## 1. Executive Summary & Master Status Dashboard

This document tracks all pages, templates, and views across the **Shared/Public**, **Student/User**, and **Admin** modules of the University Event Management System. It serves as the single source of truth for implementation progress, verification status, architectural dependencies, and outstanding roadmap items.

### Legend:
- `[x] COMPLETED` – Page created, registered in `.csproj`, compiled cleanly, integrated with backend/data layers, and visually verified in browser.
- `[-] IN PROGRESS / POLISH` – Core view exists and functions, but scheduled for visual redesign or pending additional UI alignment with the dark cinematic design system.
- `[ ] NOT YET STARTED` – Fully scoped and architected below, but code files are yet to be implemented.

---

### Master Status Matrix

| ID | Module | Page / View | Physical Path | Target URL | Status | Core Dependencies |
| :--- | :--- | :--- | :--- | :--- | :---: | :--- |
| **P-01** | Shared | **Login** | [`Frontend/Login/Login.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Login/Login.aspx) | `/Frontend/Login/Login.aspx` | `[x] COMPLETED` | `UserRepository`, `PasswordHelper`, `SessionHelper` |
| **P-02** | Shared | **Access Denied / Error** | [`Frontend/AccessDenied.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/AccessDenied.aspx) | `/Frontend/AccessDenied.aspx` | `[x] COMPLETED` | `SessionHelper`, `AuthHelper` |
| **P-03** | User | **Student Events Portal** | [`Frontend/User/Dashboard.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/User/Dashboard.aspx) | `/Frontend/User/Dashboard.aspx` | `[x] COMPLETED` | `EventRepository`, `RegistrationRepository`, `SponsorRepository`, `StudentRepository` |
| **P-04** | User | **Event Details & Booking** | `Frontend/User/EventDetails.aspx` | `/Frontend/User/EventDetails.aspx?eventId={id}` | `[ ] NOT YET STARTED` | `EventRepository`, `RegistrationRepository`, `SponsorRepository` |
| **P-05** | User | **Electronic Pass / E-Ticket** | `Frontend/User/MyTicket.aspx` | `/Frontend/User/MyTicket.aspx?regId={id}` | `[ ] NOT YET STARTED` | `RegistrationRepository`, `EventRepository`, QR Generation Engine |
| **P-06** | User | **Student Profile & Security** | `Frontend/User/Profile.aspx` | `/Frontend/User/Profile.aspx` | `[ ] NOT YET STARTED` | `StudentRepository`, `UserRepository`, `PasswordHelper` |
| **P-07** | Admin | **Admin Master Layout** | [`Frontend/Admin/Admin.Master`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Admin.Master) | *(Master Shell for Admin Views)* | `[x] COMPLETED` | `SessionHelper`, Navigation Sidebar Component |
| **P-08** | Admin | **Executive Dashboard** | [`Frontend/Admin/Dashboard.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Dashboard.aspx) | `/Frontend/Admin/Dashboard.aspx` | `[-] POLISH PENDING` | `EventRepository`, `RegistrationRepository`, KPI Metrics Engine |
| **P-09** | Admin | **Campus Events Matrix** | `Frontend/Admin/AdminEvents.aspx` | `/Frontend/Admin/AdminEvents.aspx` | `[ ] NOT YET STARTED` | `EventRepository`, `SponsorRepository` |
| **P-10** | Admin | **Create Event Form** | `Frontend/Admin/CreateEvent.aspx` | `/Frontend/Admin/CreateEvent.aspx` | `[ ] NOT YET STARTED` | `EventRepository`, `SponsorRepository`, File Upload Handler |
| **P-11** | Admin | **Edit & Manage Event** | `Frontend/Admin/EditEvent.aspx` | `/Frontend/Admin/EditEvent.aspx?eventId={id}` | `[ ] NOT YET STARTED` | `EventRepository`, `SponsorRepository`, Audit Logger |
| **P-12** | Admin | **Check-In / QR Scanner** | `Frontend/Admin/CheckIn.aspx` | `/Frontend/Admin/CheckIn.aspx` | `[ ] NOT YET STARTED` | `RegistrationRepository`, Camera Scanner API, Sound Synthesis |
| **P-13** | Admin | **Event Attendees Roster** | `Frontend/Admin/EventAttendees.aspx` | `/Frontend/Admin/EventAttendees.aspx?eventId={id}` | `[ ] NOT YET STARTED` | `RegistrationRepository`, `StudentRepository`, CSV Export Helper |
| **P-14** | Admin | **Student Directory & Accounts** | `Frontend/Admin/StudentList.aspx` | `/Frontend/Admin/StudentList.aspx` | `[ ] NOT YET STARTED` | `StudentRepository`, `UserRepository`, CSV Bulk Import Parser |
| **P-15** | Admin | **System Audit Logs** | `Frontend/Admin/AuditLogs.aspx` | `/Frontend/Admin/AuditLogs.aspx` | `[ ] NOT YET STARTED` | `AuditRepository`, `dbo.AuditLogsTable` |
| **P-16** | Admin | **Reports & Analytics** | `Frontend/Admin/Reports.aspx` | `/Frontend/Admin/Reports.aspx` | `[ ] NOT YET STARTED` | Analytics Engine, Chart.js / SVG Visualizer, CSV/PDF Export |

---

## 2. Detailed Page Specifications & Implementation Checker

---

### Module 1: Shared / Public Pages

#### [x] P-01: Login Page (`Login.aspx`)
- **File Location:** [`Frontend/Login/Login.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Login/Login.aspx)
- **Code-Behind:** [`Frontend/Login/Login.aspx.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Login/Login.aspx.cs)
- **Access Rule:** Public (Anonymous Allowed). Automatically redirects authenticated sessions to their corresponding module.
- **Visual Design:** Dark slate canvas (`#090D16`), glassmorphic authentication container, QCU University crest, gold focus accents, responsive card layout.
- **Key Capabilities:**
  - Authenticates users via Student ID / Username and Password using PBKDF2 cryptography (`PasswordHelper.VerifyPassword`).
  - Resolves roles (`Admin` vs `User/Student`).
  - Enforces temporary password onboarding: students initially receive a structured default password (`[First letter of Middle Name] + [MMDDYYYY birthdate]`, e.g., `N03242006`). Flags initial logins requiring a mandatory password update.
  - Establishes session state (`Session["UserId"]`, `Session["Role"]`, `Session["StudentNumber"]`, `Session["StudentName"]`).
  - Routes `Admin` users to `/Frontend/Admin/Dashboard.aspx` and `User` students to `/Frontend/User/Dashboard.aspx`.
- **Status:** `[x] COMPLETED` (Fully styled, registered, and verified).

---

#### [x] P-02: Access Denied / Error Page (`AccessDenied.aspx`)
- **File Location:** [`Frontend/AccessDenied.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/AccessDenied.aspx)
- **Code-Behind:** [`Frontend/AccessDenied.aspx.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/AccessDenied.aspx.cs)
- **Access Rule:** Public.
- **Visual Design:** Dark slate aesthetic with warning perimeter badge, 403 shield icon, and clear action routes.
- **Key Capabilities:**
  - Handles unauthorized route interception when a student attempts to access administrative pages (`/Frontend/Admin/*`).
  - Handles unauthenticated session expiration and provides a direct return path to `Login.aspx`.
  - Captures and displays security incident context (Target URL, timestamp, user role if authenticated).
- **Status:** `[x] COMPLETED` (Fully styled, registered, and verified).

---

### Module 2: Student / User Module

#### [x] P-03: Student Events Portal / Dashboard (`Dashboard.aspx`)
- **File Location:** [`Frontend/User/Dashboard.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/User/Dashboard.aspx)
- **Code-Behind:** [`Frontend/User/Dashboard.aspx.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/User/Dashboard.aspx.cs)
- **Access Rule:** Student / User (`SessionHelper.Role == "User"`). Includes fallback demo preview mode for frictionless UI inspection.
- **Visual Design:** Premium dark university portal aesthetic (`#090D16`), sticky glassmorphic navigation bar, fixed-dimension cinematic hero gallery, structured event cards with gold/emerald accents.
- **Key Capabilities:**
  - **Standalone Navigation Bar:** Positioned at page top with QCU emblem, system branding, student avatar badge (`MJ [2024-00101]`), and logout action.
  - **Cinematic Hero Showcase:** Interactive carousel highlighting flagship events with consistent height across slide transitions (`480px` desktop, `460px` tablet, `520px` mobile).
  - **Segmented Tab Views:** Toggle between *"Campus Event Matrix"* (browse open events) and *"My Registered Events & Passes"* (view active registrations).
  - **Audience Filtering:** Automatically evaluates 4-tier audience criteria (Department, Year Level, Section) to show events relevant to the student's cohort.
  - **Event Card Organization (Photo 2 Standard):**
    - Top Banner: Category pill, live status indicator (`● OPEN`), capacity cap badge.
    - Body: Bold event title, venue with map pin icon, date and time with calendar icon, attached sponsor logos/names, capacity indicator (e.g., `84 spots left`), and `View Details →` CTA button.
  - **Integrated Details & Booking Modal:** Built-in modal window to inspect detailed descriptions, speaker lineups, sponsors, and trigger one-click registrations.
- **Status:** `[x] COMPLETED` (Tested and verified across Desktop, Tablet, and Mobile viewports).

---

#### [ ] P-04: Event Details & Booking Page (`EventDetails.aspx`)
- **Planned File Location:** `Frontend/User/EventDetails.aspx`
- **Access Rule:** Student / User.
- **Visual Design:** Full-page immersive layout with high-resolution banner hero, tabbed content blocks, sticky registration action drawer.
- **Key Capabilities:**
  - Comprehensive event view displaying full markdown description, speaker dossiers, full high-res sponsors grid, and venue directions/map.
  - Eligibility checklist highlighting whether the student satisfies the event's 4-tier audience targeting (Department, Year Level, Section).
  - Live quota countdown with real-time remaining seat calculation.
  - Atomic booking trigger invoking `RegistrationRepository.RegisterStudentForEvent`:
    - Prevents double bookings.
    - Enforces capacity locks using `UPDLOCK, HOLDLOCK`.
    - Enforces cancellation deadlines (`RegistrationDeadline` / `EventStartDate`).
- **Status:** `[ ] NOT YET STARTED` (Next phase after dashboard review).

---

#### [ ] P-05: Electronic Pass / E-Ticket (`MyTicket.aspx`)
- **Planned File Location:** `Frontend/User/MyTicket.aspx`
- **Access Rule:** Student / User (must own the registration or be Admin).
- **Visual Design:** Sleek boarding-pass/e-ticket card with holographic gradient borders, notch cutouts, and dark glass styling.
- **Key Capabilities:**
  - Generates a cryptographically signed QR code containing `RegistrationId`, `StudentNumber`, and `EventId` for swift scan at check-in desks.
  - Displays check-in instructions, gate opening times, dress codes, and venue rules.
  - "Save as Image" / "Print Electronic Pass" utility for offline entry.
  - Live attendance state indicator (`Registered (Pending)` vs `Attended`).
- **Status:** `[ ] NOT YET STARTED`.

---

#### [ ] P-06: Student Profile & Security Page (`Profile.aspx`)
- **Planned File Location:** `Frontend/User/Profile.aspx`
- **Access Rule:** Student / User.
- **Visual Design:** Clean personal dossier card with demographic chips and tabbed history table.
- **Key Capabilities:**
  - Displays read-only academic demographic data retrieved from `dbo.StudentTable` (Student ID, Full Name, Department, Year Level, Section, Email).
  - Password update interface:
    - Allows students to replace their temporary birthdate password (`[Middle Initial] + [Birthdate]`) with a secure custom password.
    - Enforces strength validation (minimum 8 characters, alphanumeric).
  - Lifetime event attendance ledger:
    - Chronological list of attended events, certificates earned, and participation stats.
- **Status:** `[ ] NOT YET STARTED`.

---

### Module 3: Administrative Module

#### [x] P-07: Admin Master Shell (`Admin.Master`)
- **File Location:** [`Frontend/Admin/Admin.Master`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Admin.Master)
- **Code-Behind:** [`Frontend/Admin/Admin.Master.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Admin.Master.cs)
- **Access Rule:** Administrator (`SessionHelper.Role == "Admin"`).
- **Visual Design:** Dark dashboard frame with fixed collapsible sidebar, brand badge, admin profile card, and main content canvas.
- **Key Capabilities:**
  - Enforces administrative session authorization across all child `.aspx` views.
  - Centralized navigation rail with links to Events, Create Event, Scanner, Students, Audit Logs, and Analytics.
  - Admin logout action and breadcrumb hierarchy.
- **Status:** `[x] COMPLETED`.

---

#### [-] P-08: Executive Dashboard (`Dashboard.aspx`)
- **File Location:** [`Frontend/Admin/Dashboard.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Dashboard.aspx)
- **Code-Behind:** [`Frontend/Admin/Dashboard.aspx.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Dashboard.aspx.cs)
- **Access Rule:** Administrator.
- **Visual Design:** Multi-column metrics layout with KPI counters, upcoming event widgets, and quick action tiles.
- **Key Capabilities:**
  - Executive KPI summary cards: Total Published Events, Total Registrations, Attendance Turnout Rate, Upcoming Events in next 7 days.
  - Event capacity warnings: highlights events nearing or exceeding 90% seat capacity.
  - Quick action shortcuts to Create Event, Launch Scanner, and Manage Students.
- **Status:** `[-] POLISH PENDING` (Functionally complete; scheduled for visual theme alignment to match the new dark cinematic design language).

---

#### [ ] P-09: All Events Management Matrix (`AdminEvents.aspx`)
- **Planned File Location:** `Frontend/Admin/AdminEvents.aspx`
- **Access Rule:** Administrator.
- **Visual Design:** Searchable and filterable data grid with status pill filters (`All`, `Upcoming`, `Ongoing`, `Closed`, `Completed`).
- **Key Capabilities:**
  - Comprehensive listing of all campus events with quick-glance metrics (Registered / Capacity ratio bar).
  - Status management: Publish, Close Registration, Mark Completed, Archive.
  - Action shortcuts per event row:
    - `[View Public Page]`
    - `[Edit Details]`
    - `[View Attendees Roster]`
    - `[Launch QR Scanner]`
- **Status:** `[ ] NOT YET STARTED`.

---

#### [ ] P-10: Create Event Page (`CreateEvent.aspx`)
- **Planned File Location:** `Frontend/Admin/CreateEvent.aspx`
- **Access Rule:** Administrator.
- **Visual Design:** Clean multi-section form with input groups: Basic Info, Schedule & Venue, Capacity & Quotas, Audience Matrix, and Sponsors.
- **Key Capabilities:**
  - Fields for Title, Description, Category, Venue, Start/End DateTime, and Registration Start/End Deadlines.
  - Seat capacity caps (`MaxCapacity`) with auto-validation against room limits.
  - **4-Tier Audience Targeting Selector:** Allows restricting events to specific Departments, Year Levels, or Sections (or leaving `NULL` for campus-wide open events).
  - **Sponsors Association:** Dynamic selector to attach multiple corporate/academic sponsors (`dbo.EventSponsorsTable`) to the event.
  - Banner image file uploader with preview.
- **Status:** `[ ] NOT YET STARTED`.

---

#### [ ] P-11: Edit Event Page (`EditEvent.aspx`)
- **Planned File Location:** `Frontend/Admin/EditEvent.aspx`
- **Access Rule:** Administrator.
- **Visual Design:** Tabbed administrative form pre-populated with active event data, change diff indicators, and danger zone actions.
- **Key Capabilities:**
  - Update event titles, dates, descriptions, and venue information.
  - Capacity adjustment logic: prevents reducing capacity below current active registrations without warning.
  - Registration deadline extension tools.
  - Manage attached sponsors (add new sponsors, remove existing).
  - Cancellation / Archival triggers: cancels event and logs action to audit logs.
- **Status:** `[ ] NOT YET STARTED`.

---

#### [ ] P-12: Event Attendance / QR Check-In Scanner (`CheckIn.aspx`)
- **Planned File Location:** `Frontend/Admin/CheckIn.aspx`
- **Access Rule:** Administrator / Desk Staff.
- **Visual Design:** High-contrast kiosk view with live camera viewport, manual student ID fallback input box, and large visual verification banner.
- **Key Capabilities:**
  - Browser camera QR code scanner (via HTML5 QR scanner library).
  - Manual fallback input box for student ID numbers.
  - Instant real-time attendance verification:
    - **`GREEN (SUCCESS)`**: Student successfully checked in; state updated to `'Attended'`.
    - **`YELLOW (ALREADY CHECKED IN)`**: Student was already scanned; displays timestamp of initial scan.
    - **`RED (NOT REGISTERED)`**: Student holds no valid registration for this event.
    - **`RED (EVENT NOT TODAY / CANCELLED)`**: Validation error.
  - Audio-visual feedback chimes on successful and rejected scans.
- **Status:** `[ ] NOT YET STARTED`.

---

#### [ ] P-13: Event Attendees Roster (`EventAttendees.aspx`)
- **Planned File Location:** `Frontend/Admin/EventAttendees.aspx`
- **Access Rule:** Administrator.
- **Visual Design:** Data table with real-time search, status filter (`All`, `Attended`, `NoShow`), and attendance counter badges.
- **Key Capabilities:**
  - View full roster of registered students for a selected event.
  - Manual attendance override toggle: mark student as `Attended` or revert to `NoShow`.
  - Manual student registration entry (administrator emergency override).
  - Export attendee roster to CSV for university administrative filing.
- **Status:** `[ ] NOT YET STARTED`.

---

#### [ ] P-14: Student Directory & Accounts Management (`StudentList.aspx`)
- **Planned File Location:** `Frontend/Admin/StudentList.aspx`
- **Access Rule:** Administrator.
- **Visual Design:** Two-part management interface: Single Student Creation drawer / modal alongside a filterable student accounts table.
- **Key Capabilities:**
  - **Single Student Creation Form (User Requirement #5):**
    - Input fields: Student Number, First Name, Middle Name, Last Name, Department, Year Level, Section, Email, Birthdate.
    - Auto-generates initial login account with temporary password convention: `[First letter of Middle Name] + [MMDDYYYY birthdate]` (e.g., `N03242006`).
  - **Batch Student CSV Import:**
    - Bulk upload tool accepting student rosters via CSV.
    - Validates rows, creates user accounts, hashes default passwords, and inserts demographic records.
  - **Directory Roster:**
    - Filterable table by Department, Year Level, and Account Status.
    - Administrative password reset trigger (resets password back to default structured password).
    - Account status toggles (`Active` / `Suspended`).
- **Status:** `[ ] NOT YET STARTED`.

---

#### [ ] P-15: System Audit Logs (`AuditLogs.aspx`)
- **Planned File Location:** `Frontend/Admin/AuditLogs.aspx`
- **Access Rule:** Administrator.
- **Visual Design:** Immutable chronological audit timeline with filter by action type, admin actor, and date range.
- **Key Capabilities:**
  - Read-only historical ledger tracking:
    - Event publishing, quota edits, and cancellations.
    - Manual attendance overrides.
    - Student account creation and password resets.
    - Role changes and administrative logins.
  - IP address and timestamp recording for accountability.
- **Status:** `[ ] NOT YET STARTED`.

---

#### [ ] P-16: Reports & Analytics (`Reports.aspx`)
- **Planned File Location:** `Frontend/Admin/Reports.aspx`
- **Access Rule:** Administrator.
- **Visual Design:** Analytics dashboard with visual attendance charts, department turnout leaderboards, and report generation controls.
- **Key Capabilities:**
  - Visual metrics:
    - Attendance Turnout Percentage (`Attended` vs `NoShow`).
    - Most active departments and year levels.
    - Peak event registration hours and capacity utilization curves.
  - Date range filtering and academic semester groupings.
  - One-click export to CSV and formatted print/PDF reports.
- **Status:** `[ ] NOT YET STARTED`.

---

## 3. Implementation Progress Summary

```
Total Identified Pages: 16
  ├── [x] Completed & Verified:       4  (25.0%)
  ├── [-] Polish / Redesign Pending:  1  ( 6.3%)
  └── [ ] Not Yet Started:           11  (68.7%)
```

### Module Breakdown:
1. **Shared / Public:** 2 / 2 Completed (100%)
2. **Student / User:** 1 / 4 Completed (25%)
3. **Administrative:** 1 / 10 Completed, 1 In Progress (20%)

---

## 4. Recommended Sequential Build Roadmap

To maintain maximum engineering velocity and adhere to the project's layered architecture, pages should be developed in the following dependency order:

1. **Phase 1: Student Self-Service Flow (Current Focus)**
   - Complete `Frontend/User/EventDetails.aspx` (Deep dive booking, requirements check, speaker details).
   - Complete `Frontend/User/MyTicket.aspx` (E-ticket with personal QR code for check-in).
   - Complete `Frontend/User/Profile.aspx` (Student profile, password change from temporary birthdate format, event history).

2. **Phase 2: Administrative Core Event Operations**
   - Align `Frontend/Admin/Dashboard.aspx` with the dark cinematic design system.
   - Build `Frontend/Admin/AdminEvents.aspx` (Event listings with status filters and quick actions).
   - Build `Frontend/Admin/CreateEvent.aspx` and `Frontend/Admin/EditEvent.aspx` (Event publishing, multi-tier targeting, and multi-sponsor management).

3. **Phase 3: Event Day Execution & Check-In Desk**
   - Build `Frontend/Admin/CheckIn.aspx` (Camera QR scanner and manual fallback).
   - Build `Frontend/Admin/EventAttendees.aspx` (Live attendee roster and attendance toggles).

4. **Phase 4: User Directory & Administrative Governance**
   - Build `Frontend/Admin/StudentList.aspx` (Single student form with birthdate password generation + CSV bulk import).
   - Build `Frontend/Admin/AuditLogs.aspx` (System audit logging).
   - Build `Frontend/Admin/Reports.aspx` (Turnout analytics and exportable reports).
