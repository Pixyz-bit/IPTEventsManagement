# UI & Architecture Documentation: Admin Dashboard & Master Layout

- **Components:**
  - Master Page Layout: [`Frontend/Admin/Admin.Master`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Admin.Master)
  - Master Page Code-Behind: [`Frontend/Admin/Admin.Master.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Admin.Master.cs)
  - Dashboard View: [`Frontend/Admin/Dashboard.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Dashboard.aspx)
  - Dashboard Code-Behind: [`Frontend/Admin/Dashboard.aspx.cs`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/Dashboard.aspx.cs)
- **Target Roles:** Strictly `'Admin'`
- **Live Preview URL:** `http://localhost:51717/Frontend/Admin/Dashboard.aspx`

---

## 1. Architectural Purpose & Layout Shell

The Admin Dashboard provides the operational command center for university event coordinators and administrators:
1. **Master Page Architecture (`Admin.Master`):** Establishes the standardized institutional layout containing the persistent navigation sidebar, the university crest and branch indicator, system status indicators, authenticated user profile pill, and `<asp:ContentPlaceHolder ID="MainContent">` into which all subsequent administrative pages are injected.
2. **Dashboard Overview (`Dashboard.aspx`):** Surfaces high-level institutional telemetry, including total events created, active seat capacity fill rates, student registration metrics, the real-time event manifest table, and academic department audience distribution bars.
3. **Session Enforcement & Preview Guard:** Interrogates [`SessionHelper.IsAuthenticated`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Helpers/SessionHelper.cs#L29) and [`SessionHelper.IsAdmin`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Helpers/SessionHelper.cs#L34). If authenticated as `'Student'`, access is trapped and routed to `AccessDenied.aspx`. If unauthenticated during developer preview, an interactive preview banner is displayed with demonstrative event telemetry.

---

## 2. Navigation Structure & Future Pages Hub

The persistent sidebar in `Admin.Master` establishes navigation routing for upcoming modules:

| Section | Route / Anchor | Description |
| :--- | :--- | :--- |
| **Core Management** | `~/Frontend/Admin/Dashboard.aspx` | Real-time administrative overview and KPI telemetry. |
| | `#events-roster` | Chronological event schedule, venue capacity, and status badges. |
| | `#create-event-flow` | Wizard/modal trigger to schedule new events with 4-tier audience matrix. |
| **Attendance & Users** | `#scanner-quick` | QR attendance verification and check-in desk. |
| | `#students-registry` | University student matriculation lookup and profile directory. |
| **System & Diagnostic** | `~/Frontend/Admin/TestConnection.aspx` | Database roundtrip latency and schema connectivity tool. |
| | `~/Frontend/AccessDenied.aspx` | 403 authorization violation and session expiration preview. |

---

## 3. Granular Lifecycle & Method Breakdown

### 3.1 `Admin.Master.cs: Page_Load`
* **Purpose:** Enforces administrative access control and hydrates administrator identity in the sidebar.
* **Internal Mechanics:**
  - Evaluates `SessionHelper.IsAuthenticated`.
  - If authenticated, ensures `SessionHelper.IsAdmin == true`; if not, redirects to `~/Frontend/AccessDenied.aspx?reason=admin_required`.
  - Binds `litAdminEmail` to `SessionHelper.CurrentEmail` and computes uppercase initials for the profile avatar.
  - If unauthenticated, displays `pnlPreviewBanner` to allow instant UI evaluation without terminating execution.
* **When it is used:** Triggers on every request to any child page inheriting `Admin.Master`.
* **Why:** Guarantees that unprivileged student accounts cannot navigate to administrative views.
  - `Session["Role"] == "Admin"`

---

### 3.2 `Admin.Master.cs: btnLogout_Click`
* **Purpose:** Clears active server session state and redirects to the login screen.
* **Internal Mechanics:**
  - Invokes `SessionHelper.ClearSession()` (`Session.Clear()` and `Session.Abandon()`).
  - Redirects to `~/Frontend/Login/Login.aspx`.
* **When it is used:** Triggered when the administrator clicks the sign-out icon in the sidebar footer.
* **Why:** Invalidates the server-side authentication ticket to prevent unauthorized re-entry on shared campus workstations.

---

### 3.3 `Dashboard.aspx.cs: LoadDashboardMetrics`
* **Purpose:** Queries database repositories to calculate event capacity, registration numbers, and upcoming rosters.
* **Internal Mechanics:**
  - Calls `EventRepository.GetAllUpcomingEvents()`.
  - If data is returned:
    - Calculates `litTotalEvents`, `litUpcomingCount`, `litTotalRegistrations`, and `litFillRate`.
    - Binds `events` collection to `rptEvents`.
  - If the database is freshly initialized with 0 rows:
    - Invokes `BindDemonstrationData()` with realistic university academic events so administrators can evaluate formatting, typography, and status badge styling.
* **When it is used:** Invoked on initial page load (`!IsPostBack`) of `Dashboard.aspx`.
* **Why:** Provides immediate situational awareness of upcoming event attendance and venue capacity limits.
  - `EventRepository.GetAllUpcomingEvents()`

---

### 3.4 `Dashboard.aspx.cs: GetCapacityPercentage`
* **Purpose:** Computes capacity percentage for inline progress bars in the events roster.
* **Signature:** `public static int GetCapacityPercentage(object registrations, object maxCapacity)`
* **Internal Mechanics:** Computes `(CurrentRegistrations / MaxCapacity) * 100`, bounded between 0% and 100%.
* **When it is used:** Evaluated by ASP.NET data-binding expressions `<%# GetCapacityPercentage(...) %>` on each row of `rptEvents`.
