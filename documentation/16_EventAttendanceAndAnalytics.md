# Event Attendance Roster & 3-Phase Lifecycle Telemetry Analytics

- **Document ID:** `16_EventAttendanceAndAnalytics.md`
- **Location:** 
  - `Frontend/Admin/EventPreRegistered.aspx`, `.cs`, `.designer.cs`
  - `Frontend/Admin/AttendanceScanner.aspx`, `.cs`, `.designer.cs`
  - `Frontend/Admin/EventAttendance.aspx`, `.cs`, `.designer.cs`
  - `Frontend/Admin/EventAnalytics.aspx`, `.cs`, `.designer.cs`
- **Related Models:** [EventModel.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/EventModel.cs), [EventRegistrationModel.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/EventRegistrationModel.cs), [StudentProfile.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/StudentProfile.cs)
- **Related Repositories:** [EventRepository.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/EventRepository.cs), [RegistrationRepository.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/RegistrationRepository.cs)
- **Primary Color Tokens:** `#2563eb` (Brand Primary), `#ffffff` (Card Surfaces, Tables, Headers)

---

## 1. Event Pre-Registered Roster (`EventPreRegistered.aspx`)

### A. Directory-Aligned Table Layout
To maintain visual and mental parity with the **Student Directory**, the Pre-Registered table structure was refined into 7 standardized columns:

| Column Header | Field Source | Visual Treatment |
| :--- | :--- | :--- |
| **Ticket Ref** | `r.TicketReference` | Distinct monospace blue code badge (`TCK-0003-XXXXX`) placed immediately left of the Student ID |
| **Student ID** | `r.StudentId` | High-contrast bold numeric identifier in standardized university format (`24-1611`) |
| **Student Name** | `r.StudentName` | Primary dark heading typography (`var(--text-heading)`) with subtle email hint |
| **Department / Course** | `r.StudentDepartment` & `r.StudentProgram` | Two-row stacked cell: Department in small uppercase muted text (`0.75rem`), Program / Course in bold text (`0.85rem`) |
| **Year / Section** | `r.CurrentYearLvl` & `r.Section` | Two-row stacked cell: Academic Year in muted text (`Yr 3`), Section code in bold text (`SBIT-3A`) |
| **Status** | Calculated Attendance State | High-contrast pill badges: `Reserved` (Soft Blue), `Present` (Emerald), or `Cancelled` (Rose) |
| **Action** | `View >` trigger | Sleek inline button opening the attendee inspection and credential modal |

### B. Persistent Row Rule for Scanned Attendees
- **Operational Requirement:** Once an attendee is checked in at the gate scanner, their record must **NOT disappear** from the Expected Attendees view in `EventPreRegistered.aspx`.
- **Implementation:**
  - Query in `EventPreRegistered.aspx.cs` filters all non-voided registrations (`!r.Status.Equals("Cancelled", StringComparison.OrdinalIgnoreCase)`).
  - Attendees whose status transitions to `Present` remain prominently in the roster with a vibrant emerald check badge (`● Present`).
  - Active counters (`litExpectedCount` and `litRevokedCount`) dynamically update while preserving continuous audit visibility over the complete pre-registered cohort.

---

## 2. Dedicated Event Attendance Ledger (`EventAttendance.aspx`)

Placed immediately following `AttendanceScanner.aspx` in the administration pipeline, `EventAttendance.aspx` provides an unencumbered, dedicated ledger containing exclusively the **Live Checked-In Attendance Roster**.

### A. Table Structure & Fields
Designed to match university gate checkpoint compliance standards:

1. **Verified Timestamp:** Formatted as `MM/dd/yyyy hh:mm:ss tt` within an emerald highlighted badge, guaranteeing microsecond verification traceability.
2. **Ticket Ref:** Monospace hyperlink style pointing directly to ticket credential tokens.
3. **Student ID:** Bold university identifier (`24-1611`).
4. **Attendee Full Name:** Verified registrant name cross-checked with institutional identity registers.
5. **Program & Year / Section:** Formatted as `[Course] (Yr [Level] - [Section])` (e.g. `BS Information Technology (Yr 3 - SBIT-3A)`).
6. **Verification Method:** Visual badge verifying checkpoint entry (`✓ Gate Verification` or `QR Scanned`).
7. **Inspecting Admin:** Operating administrator email recorded during gate admission.

### B. Integrated Tooling
- **Client-Side Instant Search:** High-performance JavaScript filter scanning ticket references, student IDs, attendee names, and sections in real-time with zero round-trip lag.
- **One-Click CSV Export:** Server-side CSV streaming engine (`btnExportCsv_Click`) generating compliant Excel-compatible spreadsheets (`EventAttendance_Event[Id]_[Timestamp].csv`).

---

## 3. Event Analytics & Telemetry Engine (`EventAnalytics.aspx`)

### Purpose
The **Event Analytics** module serves as the telemetry, reporting, and statistical intelligence engine visualizing event performance across all three critical phases of an event's lifecycle: before launch, during active execution, and after event conclusion.

### 3-Phase Lifecycle Architecture

#### Phase 1: Pre-Event Analytics (Before)
- **Capacity Saturation Gauge:** Real-time ratio of pre-registered cohort versus total venue capacity limit (`Registered / Total Capacity * 100%`) with dynamic fill meter and warning thresholds.
- **Quota Pool Metrics:** Remaining available attendee seats, baseline reserved enrollees, and launch countdown timer.
- **Target Demographics Distributions:**
  - **Campus Branch Breakdown:** Distribution across San Bartolome, San Francisco, and Batasan campuses with proportion percentage meters.
  - **Department Distribution:** Registration share across academic divisions (e.g., College of Computer Studies, College of Engineering).
  - **Program / Course Distribution:** Top 5 enrolled academic degrees.
  - **Year Level Distribution:** Distribution across Year 1 through Year 4 cohorts.
- **Registration Velocity Timeline:** Chronological timeline tracking daily enrollment velocity and cumulative registrant volume leading up to launch.

#### Phase 2: Live Gate Telemetry (During)
- **Turnout Rate Meter:** Present attendees measured against the pre-registered cohort (`Checked-In / Pre-Registered * 100%`).
- **Physical Venue Occupancy:** Real-time venue headcount compared against safe maximum venue capacity.
- **Unscanned Cohort Tracker:** Real-time counter of attendees pending arrival at gate terminals.
- **15-Minute Peak Surge Velocity:** Analytical timeline grouping check-in transactions into 15-minute windows with relative intensity meters, automatically pinpointing peak arrival surge windows.
- **Gate Integrity & Flow Control:** Operating operator identity tracking, transaction health confirmation, and gate synchronization telemetry.

#### Phase 3: Post-Event Performance Audit (After)
- **Turnout Performance Audit:** Comparative audit metrics contrasting:
  - `Pre-Registered Roster` (baseline expected attendees)
  - `Actual Attended` (verified gate check-ins)
  - `Verified No-Shows` (unscanned reserved slots)
  - `Voided Cancellations` (explicitly revoked passes)
- **Attendance Retention Rate:** Final institutional engagement metric (`Attended / Pre-Registered * 100%`).
- **Comparative Departmental Engagement Audit Table:** Multi-metric breakdown by academic department displaying total registered, actual attended, no-shows, and turnout engagement rates to identify high-engagement programs.

### Export Tools & Institutional Compliance
- **Official University Summary (PDF):** Leverages dedicated `@media print` stylesheets that isolate executive metrics, demographic charts, and audit certification blocks while stripping navigation chrome, creating audit-ready PDF reports for accreditation boards.
- **Detailed Multi-Cohort Excel / CSV Spreadsheet:** One-click data export tool (`btnExportComprehensiveCsv_Click`) outputting full attendee rows, timestamps, statuses, and academic standing for academic activity credit validation.

---

## 4. Pipeline Navigation Progression
The event management lifecycle is unified across all sub-modules via a standardized 5-step pipeline header:
1. **1. Event Matrix** (`AdminEvents.aspx` / `EventDetails.aspx`)
2. **2. Pre-Registered** (`EventPreRegistered.aspx`)
3. **3. Attendance Scanner** (`AttendanceScanner.aspx`)
4. **4. Event Attendance** (`EventAttendance.aspx`)
5. **5. Event Analytics** (`EventAnalytics.aspx`)
