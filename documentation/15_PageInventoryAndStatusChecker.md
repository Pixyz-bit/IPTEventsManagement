# System Page Inventory & Deliverables Status Checker

- **Document ID:** `DOC-PAGE-015`
- **Related Architecture:** [`01_ArchitectureAndSecurityRules.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/Dev%20Rules/01_ArchitectureAndSecurityRules.md), [`05_PageInventoryAndStatusChecker.md`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/Dev%20Rules/05_PageInventoryAndStatusChecker.md)
- **Target Platform:** ASP.NET Web Forms (.NET Framework 4.7.2, C# 7.3)
- **Local Server:** IIS Express (`http://localhost:51717`)
- **Last Updated:** 2026-09-28

---

## 1. Master Page Matrix & Implementation Checker

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
| **P-10** | Admin | **Create Event Form** | [`Frontend/Admin/CreateEvent.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/CreateEvent.aspx) | `/Frontend/Admin/CreateEvent.aspx` | `[x] COMPLETED` | `EventRepository`, `SponsorRepository`, 5-Step Guided Wizard |
| **P-11** | Admin | **Event Details** | [`Frontend/Admin/EventDetails.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/EventDetails.aspx) | `/Frontend/Admin/EventDetails.aspx?eventId={id}` | `[x] COMPLETED` | `EventRepository`, `SponsorRepository`, Audit Logger |
| **P-12** | Admin | **Event Pre-Registered** | [`Frontend/Admin/EventPreRegistered.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/EventPreRegistered.aspx) | `/Frontend/Admin/EventPreRegistered.aspx?eventId={id}` | `[x] COMPLETED` | `RegistrationRepository`, `StudentRepository`, Dual-Sheet Roster, CSV Export |
| **P-13** | Admin | **Event Scanner and Attendance** | [`Frontend/Admin/AttendanceScanner.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/AttendanceScanner.aspx) | `/Frontend/Admin/AttendanceScanner.aspx?eventId={id}` | `[x] COMPLETED` | Optical Camera Viewfinder, Staging Area, Audiovisual Chimes, Live Attendance Roster |
| **P-14** | Admin | **Student Directory & Accounts** | `Frontend/Admin/StudentList.aspx` | `/Frontend/Admin/StudentList.aspx` | `[ ] NOT YET STARTED` | `StudentRepository`, `UserRepository`, CSV Bulk Import Parser |
| **P-15** | Admin | **System Audit Logs** | `Frontend/Admin/AuditLogs.aspx` | `/Frontend/Admin/AuditLogs.aspx` | `[ ] NOT YET STARTED` | `AuditRepository`, `dbo.AuditLogsTable` |
| **P-16** | Admin | **Reports & Analytics** | `Frontend/Admin/Reports.aspx` | `/Frontend/Admin/Reports.aspx` | `[ ] NOT YET STARTED` | Analytics Engine, Chart.js / SVG Visualizer, CSV/PDF Export |

---

## 2. Module Status & Verification Breakdown

### Shared / Public Pages (2 / 2 Completed - 100%)
1. **`Login.aspx` (`[x] COMPLETED`):**
   - PBKDF2 authentication against `dbo.UsersTable`.
   - Temporary password onboarding support (`[First letter of Middle Name] + [MMDDYYYY birthdate]`, e.g., `N03242006`).
   - Session initialization (`SessionHelper`).
   - Dark slate glassmorphic aesthetic verified on `http://localhost:51717/Frontend/Login/Login.aspx`.
2. **`AccessDenied.aspx` (`[x] COMPLETED`):**
   - Route interception for unauthorized role access and unauthenticated expirations.
   - Tested on `http://localhost:51717/Frontend/AccessDenied.aspx`.

### Student / User Module (1 / 4 Completed - 25%)
1. **`Dashboard.aspx` (`[x] COMPLETED`):**
   - Dedicated top navigation bar above main content with QCU Emblem, University Event Portal branding, student avatar badge, and sign out button.
   - Hero showcase container with fixed, consistent height (`480px` desktop, `460px` tablet, `520px` mobile) and smooth slide switching.
   - Segmented tab toggle: *"Campus Event Matrix"* vs *"My Registered Events & Passes"*.
   - Event card element hierarchy adhering to Photo 2 standard.
   - Tested across Desktop, Tablet (900x700), and Mobile (420x800).
2. **`EventDetails.aspx` (`[ ] NOT YET STARTED`):**
   - Full event view, requirements checklist, speaker lineup, full sponsors grid, atomic registration and cancellation.
3. **`MyTicket.aspx` (`[ ] NOT YET STARTED`):**
   - Digital e-ticket / boarding pass with personalized QR code for check-in desk scanning, entry instructions, and ticket download/print.
4. **`Profile.aspx` (`[ ] NOT YET STARTED`):**
   - Student academic demographics from `dbo.StudentTable`, password change form, and attendance history ledger.

### Administrative Module (4 / 10 Completed - 40%)
1. **`Admin.Master` (`[x] COMPLETED`):**
   - Shared shell with responsive navigation rail, role verification, and admin header.
2. **`Dashboard.aspx` (`[x] COMPLETED`):**
   - KPI metrics (Events, Registrations, Attendees, Fill Rate) with professional enterprise light theme.
3. **`AdminEvents.aspx` (`[x] COMPLETED`):**
   - **Primary Objective:** Central operational cockpit exclusively for `Closed`, `Open`, and `Upcoming` events. Concluded or cancelled events are explicitly excluded and deferred to Events History.
   - **Parent Hub Role:** Single entry gateway to the four event-level sub-modules. Selecting an event (`View >`) routes into the pipeline: $\text{Event Details (EventDetails.aspx)} \rightarrow \text{Event PreRegistered} \rightarrow \text{Event Scanner \& Attendance} \rightarrow \text{Event Analytics}$.
   - **Operational Monitoring:** Real-time tracking of live registration windows and seat occupancy before gate opening.
   - Campus events matrix with 3-status tabs (`Open`, `Soon`, `Close`), department dropdown filtering, instant keyword search, and occupancy KPI summaries.
4. **`CreateEvent.aspx` (`[x] COMPLETED`):**
   - 5-step guided wizard (Core Specs -> Single Date Schedule & Times -> Multi-Course Audience Targeting -> Sponsors -> Summary & Confirm).
   - Dynamic real-time preview sidebar and live summary review card before publishing.
5. **[`EventDetails.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/EventDetails.aspx) (`[x] COMPLETED`):**
   - **Purpose:** Serves as the authoritative configuration console and single source of truth for individual event metadata, scheduling windows, physical venue capacity, media assets, and demographic eligibility rules.
   - **Core Data & UI Components:**
     - *General Information:* Form inputs for Event Title, Detailed Description, Venue/Location, and Maximum Seating Capacity.
     - *Event Execution Schedule:* Discrete controls for Event Date (strict `MM/dd/yyyy`), Start Time, and End Time.
     - *Registration Lifecycle Window:* Separate timestamp selectors for Registration Start Date & Time and Registration End Date & Time (`MM/dd/yyyy hh:mm tt`) to enforce automated opening and closing of attendee signups.
     - *Dual-Ratio Banner Upload:* Media upload module requiring two distinct image formats/ratios (wide desktop banner vs. square/portrait mobile card view) for responsive rendering across web and mobile student portals.
     - *Target Demographics (Audience Restrictions):* Institutional targeting rules configurable by Target Branch, Target Department, Target Course, and Target Year Level.
     - *Sponsor Configuration:* Multi-sponsor attachment and management.
   - **Actions & Operational Directives:**
     - Toggle inline Edit Mode to modify active metadata, capacity limits, or schedules.
     - Enforce logical timestamp rules (`RegEnd` <= `EventEnd`; `RegStart` < `RegEnd`; `StartTime` < `EndTime`).
     - Enforce access rules: Cross-checks student demographic credentials against configured Target Demographics before issuing a pass.
6. **`EventPreRegistered.aspx` (`[x] COMPLETED`):**
   - Serves as the pre-event roster management center, providing administrative tracking and triage for all registered attendees before gate check-in.
   - Dual-sheet roster organization (Pre-Registered vs. Cancelled), universal search and multi-filtering (Department, Course, Year Level), student profile inspection modal, ticket cancellation with real-time seat releasing back to capacity, and CSV/Excel export.
7. **`AttendanceScanner.aspx` (`[x] COMPLETED`):**
   - Real-time entrance gate operations terminal combining optical QR code decoding, instant attendee profile staging area, mandatory administrative inspection review (no auto-checkin), operator confirmation controls ([Confirm & Check-In] vs [Cancel / Discard]), audiovisual chimes, manual fallback console, and live checked-in attendance roster.
8. **`StudentList.aspx` (`[ ] NOT YET STARTED`):**
   - Student accounts management: single student form with birthdate-based temporary password generation + CSV batch roster import.
9. **`AuditLogs.aspx` (`[ ] NOT YET STARTED`):**
   - Administrative action history ledger.
10. **`Reports.aspx` (`[ ] NOT YET STARTED`):**
    - Visual turnout analytics and exportable administrative reports.
