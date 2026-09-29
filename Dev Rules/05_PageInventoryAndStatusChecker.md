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
| **P-09** | Admin | **Campus Events Matrix** | [`Frontend/Admin/AdminEvents.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/AdminEvents.aspx) | `/Frontend/Admin/AdminEvents.aspx` | `[x] COMPLETED` | `EventRepository`, `SponsorRepository` |
| **P-10** | Admin | **Create Event Form** | [`Frontend/Admin/CreateEvent.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/CreateEvent.aspx) | `/Frontend/Admin/CreateEvent.aspx` | `[x] COMPLETED` | `EventRepository`, `SponsorRepository`, File Upload Handler |
| **P-11** | Admin | **Event Details** | [`Frontend/Admin/EventDetails.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/EventDetails.aspx) | `/Frontend/Admin/EventDetails.aspx?eventId={id}` | `[x] COMPLETED` | `EventRepository`, `SponsorRepository`, Audit Logger |
| **P-12** | Admin | **Event Pre-Registered** | [`Frontend/Admin/EventPreRegistered.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/EventPreRegistered.aspx) | `/Frontend/Admin/EventPreRegistered.aspx?eventId={id}` | `[x] COMPLETED` | `RegistrationRepository`, `StudentRepository`, Dual-Sheet Roster, CSV Export |
| **P-13** | Admin | **Event Scanner and Attendance** | [`Frontend/Admin/AttendanceScanner.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/AttendanceScanner.aspx) | `/Frontend/Admin/AttendanceScanner.aspx?eventId={id}` | `[x] COMPLETED` | Optical Camera Viewfinder, Staging Area, Audiovisual Chimes, Live Attendance Roster |
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

#### [x] P-09: All Events Management Matrix (`AdminEvents.aspx`)
- **Physical File Location:** [`Frontend/Admin/AdminEvents.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/AdminEvents.aspx)
- **Access Rule:** Administrator.
- **Primary Objective:** Serves as the central operational cockpit exclusively for `Closed`, `Open`, and `Upcoming` events. Concluded or cancelled events are explicitly excluded and deferred to Events History.
- **Parent Hub Role:** Acts as the single entry gateway to the four event-level sub-modules. Selecting an event (`View >`) routes the admin into the sub-module pipeline:
  $$\text{Event Details (EventDetails.aspx)} \longrightarrow \text{Event PreRegistered} \longrightarrow \text{Event Scanner \& Attendance} \longrightarrow \text{Event Analytics}$$
- **Operational Monitoring:** Allows administrators to track live registration windows (open, closing, or scheduled) and real-time seat occupancy before launching event gates.
- **Visual Design:** Clean searchable table with real-time occupancy KPI summaries, status pill filters (`All`, `Open`, `Soon`, `Close`), and department filtering dropdown.
- **Key Capabilities:**
  - Comprehensive listing of active/upcoming campus events with occupancy ratios (`CurrentRegistrations/MaxCapacity`).
  - Status management: Tab filtering for `Open`, `Soon`, and `Close` registration windows.
  - Action shortcuts per event row: `View >` link navigating to [`EventDetails.aspx?eventId={id}`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/EventDetails.aspx).
  - Quick event cancellation modal with reason capture.
- **Status:** `[x] COMPLETED`.

---

#### [x] P-10: Create Event Page (`CreateEvent.aspx`)
- **Physical File Location:** [`Frontend/Admin/CreateEvent.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/CreateEvent.aspx)
- **Access Rule:** Administrator.
- **Visual Design:** 5-step guided wizard (Core Specs -> Single Date Schedule & Times -> Multi-Course Audience Targeting -> Sponsors -> Summary & Confirm) with dynamic real-time ticket preview sidebar.
- **Key Capabilities:**
  - Fields for Title, Description, Venue, Single Date, Start/End Time, and Registration Start/End Deadlines.
  - Seat capacity validation with auto-focus error alerts.
  - **4-Tier Audience Targeting Selector:** Branch, Department, Multi-Program checkboxes, and Year Levelstanding (NULL = campus-wide open).
  - **Sponsors Association:** Dynamic repeater to attach/remove multiple partner sponsors.
  - Step 5 interactive summary review and live ticket pass preview.
- **Status:** `[x] COMPLETED`.

---

#### [x] P-11: Event Details (`EventDetails.aspx`)
- **Physical File Location:** [`Frontend/Admin/EventDetails.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/EventDetails.aspx)
- **Target URL:** `/Frontend/Admin/EventDetails.aspx?eventId={id}`
- **Access Rule:** Administrator.
- **Purpose:** Serves as the authoritative configuration console and single source of truth for individual event metadata, scheduling windows, physical venue capacity, media assets, and demographic eligibility rules.
- **Core Data & UI Components:**
  - **General Information:** Form inputs for Event Title, Detailed Description, Venue/Location, and Maximum Seating Capacity.
  - **Event Execution Schedule:** Discrete controls for Event Date (strict `MM/dd/yyyy`), Start Time, and End Time.
  - **Registration Lifecycle Window:** Separate timestamp selectors for Registration Start Date & Time and Registration End Date & Time (`MM/dd/yyyy hh:mm tt`) to enforce automated opening and closing of attendee signups.
  - **Dual-Ratio Banner Upload:** Media upload module requiring two distinct image formats/ratios (wide desktop banner vs. square/portrait mobile card view) to guarantee responsive rendering across web and mobile student portals.
  - **Target Demographics (Audience Restrictions):** Institutional targeting rules configurable by Target Branch, Target Department, Target Course, and Target Year Level to restrict or permit registration eligibility.
  - **Sponsor Configuration:** Attachment and management of corporate and academic partner sponsors.
- **Actions & Operational Directives:**
  - Toggle inline Edit Mode to modify active metadata, capacity limits, or schedules.
  - Enforce logical timestamp rules (`RegEnd` <= `EventEnd`; `RegStart` < `RegEnd`; `StartTime` < `EndTime`).
  - Enforce access rules: Registration engine must cross-check incoming student registration attempts against configured Target Demographics before issuing a pass.
- **Status:** `[x] COMPLETED`.

---

#### [x] P-12: Event Pre-Registered (`EventPreRegistered.aspx`)
- **Physical File Location:** [`Frontend/Admin/EventPreRegistered.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/EventPreRegistered.aspx)
- **Target URL:** `/Frontend/Admin/EventPreRegistered.aspx?eventId={id}`
- **Access Rule:** Administrator.
- **Purpose:** Serves as the pre-event roster management center, providing administrative tracking and triage for all registered attendees before gate check-in.
- **Core Data & UI Components:**
  - **Search & Multi-Filter Controls:** Universal search bar (evaluating Student ID and Full Name) alongside toggle/dropdown filters to segment attendees by Department, Course, and Year Level.
  - **Dual-Sheet Roster Organization:** Distinct, switchable tabbed sheets separating:
    - *Pre-Registered Sheet:* Active registered students awaiting attendance (designated as expected attendees / initial "No-Show" state prior to physical scanning).
    - *Cancelled Sheet:* Historical record of revoked registrations.
  - **Row-Level Action Controls:**
    - *View:* Launches a detailed pop-up modal containing complete student profile information (Student ID, Full Name, Institutional Email, Branch, Department, Course, Year Level, Section, and Registration Timestamp).
    - *Cancel:* Voids the student's registration pass and immediately migrates the entry to the Cancelled Sheet.
- **Actions & Operational Directives:**
  - Releasing cancelled slots back to the event’s available seating capacity pool in real time (`CurrentRegistrations` atomically decremented on `dbo.EventsTable`).
  - Providing roster export functionality (CSV/Excel) for gate security backups and administrative archiving.
- **Status:** `[x] COMPLETED`.

---

#### [x] P-13: Event Scanner and Attendance (`AttendanceScanner.aspx`)
- **Physical File Location:** [`Frontend/Admin/AttendanceScanner.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/AttendanceScanner.aspx)
- **Target URL:** `/Frontend/Admin/AttendanceScanner.aspx?eventId={id}`
- **Access Rule:** Administrator / Desk Staff.
- **Purpose:** Functions as the real-time entrance gate operations terminal, combining optical QR code decoding, instant attendee profile staging, mandatory administrative inspection, and authenticated attendance logging.
- **Core Data & UI Components:**
  - **Optical Viewfinder Stream:** Direct camera interface (supporting external webcams, built-in laptop cameras, and mobile web browsers) configured to scan physical or digital attendee QR passes.
  - **Auto-Populating Verification Panel (Staging Area):** Read-only inspection fields that immediately populate with the attendee's data upon a valid scan (Student ID, Full Name, Academic Department, Course, Year Level, Section, and Assigned Ticket Reference) without committing the record to the database.
  - **Operator Confirmation Controls:** Explicit action triggers within the verification panel:
    - `[ CONFIRM & CHECK-IN ]` (or keyboard shortcut like Enter/Space) to officially validate attendance.
    - `[ CANCEL / DISCARD ]` to reject or clear the staged record and resume camera scanning without saving.
  - **Live Checked-In Attendance Roster:** Chronologically updating data table beneath the scanner listing confirmed students, displaying verified check-in timestamps (`MM/dd/yyyy hh:mm:ss tt`), verification methods, and inspecting admin credentials.
  - **Manual Fallback Console:** An input field allowing gate operators to manually look up a Student ID or Ticket Reference number when a student's camera stream or physical ticket is unreadable. Manual submissions populate the verification panel for confirmation before check-in.
- **Actions & Operational Directives:**
  - **Pre-Commit State Validation:** Run millisecond database checks upon optical scan or manual lookup against three preliminary states:
    - *Valid Ticket / Pending Admin Confirmation:* Staged for review.
    - *Duplicate Check-In Warning:* Flags that the pass was already used, showing the original check-in timestamp and gate location.
    - *Invalid Ticket / Wrong Event:* Flags unassigned or incorrect event passes.
  - **Mandatory Review Gate (No Automatic Check-In):** The system must not automatically mark a student as attended immediately upon scanning. It must hold the scanned data in a staged preview state so the administrator can physically verify the attendee's identity (e.g., verifying their physical University ID card against the displayed name and photo/details).
  - **Audiovisual Feedback:** Trigger a preview chime/prompt when a code is detected, and distinct audiovisual indicators upon final action (green chime on confirmed check-in, red tone on error, duplicate, or administrative rejection).
  - **Final Database Commit:** Only after the administrator clicks Confirm & Check-In does the system commit the record to the database (`IsCheckedIn = 1`, `CheckInDateTime = GETDATE()`), increment the live gate headcount, and append the attendee to the live checked-in attendance roster.
- **Status:** `[x] COMPLETED`.

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
  ├── [x] Completed & Verified:      10  (62.5%)
  └── [ ] Not Yet Started:            6  (37.5%)
```

### Module Breakdown:
1. **Shared / Public:** 2 / 2 Completed (100%)
2. **Student / User:** 1 / 4 Completed (25%)
3. **Administrative:** 7 / 10 Completed (70%)

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

3. **Phase 3: Event Roster Triage & Gate Check-In Desk**
   - Build `Frontend/Admin/EventPreRegistered.aspx` (Dual-sheet pre-registered triage roster, filtering, student modal, real-time seat release cancellation, CSV/Excel export).
   - Build `Frontend/Admin/AttendanceScanner.aspx` (Optical QR camera viewfinder, pre-commit verification staging area, mandatory operator review, audiovisual chimes, live checked-in attendance roster).

4. **Phase 4: User Directory & Administrative Governance**
   - Build `Frontend/Admin/StudentList.aspx` (Single student form with birthdate password generation + CSV bulk import).
   - Build `Frontend/Admin/AuditLogs.aspx` (System audit logging).
   - Build `Frontend/Admin/Reports.aspx` (Turnout analytics and exportable reports).
