# Repository Documentation: EventRepository

- **Component:** [`EventRepository`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/EventRepository.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Repository`
- **Target Entity / Table:** [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L43-L72) (`dbo.EventsTable`)
- **Associated Model:** [`EventModel`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/EventModel.cs)

---

## 1. Architectural Purpose & Role

The `EventRepository` is the sole data-access interface for managing institutional events in `dbo.EventsTable`. It encapsulates:
1. **Event Creation & Modification:** Full parameterized persistence for event schedules, embedded venues, quotas, and descriptions.
2. **Issue D (4-Tier Audience Matrix Filtering):** Cohort matching queries evaluating Branch, Department, Program, and Year Level (with `NULL` denoting unrestricted open access).
3. **Issue 3 (High-Concurrency Registration Counter):** Atomic increment/decrement queries that eliminate race conditions and overbooking without requiring expensive table locks.

---

## 2. Granular Function Breakdown

Event-wide cancellation uses `EventCancellationRepository` and `EventCancellationModel`. Archive/restore operations are removed. `UpdateEvent` preserves lifecycle status/reason and rejects inactive events. Reporting uses `GetHistoricalEvents` and `GetDistinctHistoricalAcademicYears`. See [the cancellation flow](11_AdminDashboard.md).

### 2.1 `CreateEvent`
* **Purpose:** Inserts a new event into `dbo.EventsTable` and populates the auto-generated `EventId`.
* **Signature & Contracts:**
  - Input: `EventModel ev` (Title, VenueLocation, MaxCapacity > 0, CreatedByUserId > 0 required).
  - Output: `int` (The generated `EventId`).
* **Internal Mechanics:**
  - Parameterizes all properties (converting null targeting criteria to `DBNull.Value`).
  - Executes `INSERT INTO dbo.EventsTable ... SELECT CAST(SCOPE_IDENTITY() AS INT);` via `DatabaseConnection.ExecuteScalar`.
* **Side Effects & Thrown Errors:**
  - Persists a new row in SQL Server.
  - Throws `ArgumentNullException` if `ev` is null.
  - Throws `ArgumentException` if title, venue, capacity, or creator ID are invalid.
* **When it is used:** Invoked when an Administrator completes and submits the Event Creation Wizard (`Frontend/Admin/CreateEvent.aspx`).
* **Why:** Persists the new event definition, assigns ownership via `EventsTable.CreatedByUserId`, and initializes `CurrentRegistrations = 0`:
  * `[EventsTable.CreatedByUserId, EventsTable.MaxCapacity, EventsTable.CurrentRegistrations]`

---

### 2.2 `GetEventById`
* **Purpose:** Retrieves a single event record by its primary key (`EventId`).
* **Signature & Contracts:**
  - Input: `int eventId` (Must be greater than 0).
  - Output: `EventModel` or `null` if not found.
* **Internal Mechanics:**
  - Runs a parameterized `SELECT ... WHERE EventId = @EventId` query.
  - Maps the resulting `DataRow` to an `EventModel`.
* **Side Effects & Thrown Errors:**
  - Read-only; returns `null` if `eventId <= 0`.
* **When it is used:** Invoked when rendering an Event Details view (`EventDetails.aspx?id=12`) or preparing an event for editing in the Admin portal.
* **Why:** Fetches event metadata and calculates live ticket availability via `EventModel.RemainingCapacity`:
  * `[EventsTable.EventId, Request.QueryString["id"]]`

---

### 2.3 `GetEventsForStudent`
* **Purpose:** Retrieves upcoming events filtered to match a student's demographic profile using the 4-tier audience matrix.
* **Signature & Contracts:**
  - Input: `string branch`, `string department`, `string program`, `int yearLevel`.
  - Output: `List<EventModel>`.
* **Internal Mechanics:**
  - Executes a multi-tier conditional SQL query:
    ```sql
    WHERE Status = 'Upcoming'
      AND (TargetBranch IS NULL OR TargetBranch = @Branch)
      AND (TargetDepartment IS NULL OR TargetDepartment = @Department)
      AND (TargetProgram IS NULL OR TargetProgram = @Program)
      AND (TargetYearLevel IS NULL OR TargetYearLevel = @YearLevel)
    ```
* **Side Effects & Thrown Errors:**
  - Read-only.
* **When it is used:** Invoked on the Student Dashboard (`Frontend/User/Dashboard.aspx`) upon page load.
* **Why:** In Issue D, students must only see events they are eligible to attend, plus events marked `NULL` (open to all). Reads student demographics from the authenticated session:
  * `[Session["CampusBranch"], Session["Department"], Session["Program"], Session["YearLevel"]]`

---

### 2.4 `GetAllUpcomingEvents`
* **Purpose:** Retrieves all active upcoming events across the entire institution.
* **Signature & Contracts:**
  - Output: `List<EventModel>` ordered by `EventStart ASC`.
* **When it is used:** Invoked on the public event calendar or master administrative overview.
* **Why:** Displays all scheduled events regardless of audience targeting:
  * `[EventsTable.Status = 'Upcoming']`

---

### 2.5 `GetEventsCreatedByUser`
* **Purpose:** Retrieves events authored by a specific administrator.
* **Signature & Contracts:**
  - Input: `int userId`.
  - Output: `List<EventModel>` ordered by `EventStart DESC`.
* **When it is used:** Invoked on the Administrator Event Management dashboard (`Frontend/Admin/ManageEvents.aspx`).
* **Why:** Scopes event management and cancellation controls to the authoring administrator:
  * `[EventsTable.CreatedByUserId = Session["UserId"]]`

---

### 2.6 `UpdateEvent`
* **Purpose:** Updates event details, venue location, schedule, and audience restrictions.
* **Signature & Contracts:**
  - Input: `EventModel ev`.
  - Output: `bool` (`true` if updated; `false` otherwise).
* **When it is used:** Invoked when an Administrator saves edits to an existing event.
* **Why:** Updates all mutable event columns in `dbo.EventsTable`:
  * `[EventsTable.EventId, EventsTable.VenueLocation, EventsTable.MaxCapacity]`

---

### 2.7 `CancelEvent`
* **Purpose:** Formally cancels an event and records the mandatory justification.
* **Signature & Contracts:**
  - Input: `int eventId`, `string cancellationReason`.
  - Output: `bool`.
* **When it is used:** Invoked when an Administrator clicks "Cancel Event" in the admin console.
* **Why:** Updates `EventsTable.Status = 'Cancelled'` and logs `EventsTable.CancellationReason`:
  * `[EventsTable.Status, EventsTable.CancellationReason]`

---

### 2.8 `IncrementRegistrationCount`
* **Purpose:** Atomically increments `CurrentRegistrations` if the event is not sold out.
* **Signature & Contracts:**
  - Input: `int eventId`.
  - Output: `bool` (`true` if seat reserved; `false` if event is full or inactive).
* **Internal Mechanics:**
  - Executes atomic conditional update:
    ```sql
    UPDATE dbo.EventsTable 
    SET CurrentRegistrations = CurrentRegistrations + 1 
    WHERE EventId = @EventId 
      AND CurrentRegistrations < MaxCapacity 
      AND Status = 'Upcoming';
    ```
* **When it is used:** Invoked inside the Registration Transaction (`RegistrationService.Register`) before creating a ticket in `EventRegistrationTable`.
* **Why:** Solves Issue 3. Prevents race conditions and overbooking during high-traffic registration spikes without needing full table locks:
  * `[EventsTable.CurrentRegistrations < EventsTable.MaxCapacity]`

---

### 2.9 `DecrementRegistrationCount`
* **Purpose:** Atomically decrements `CurrentRegistrations` when a student cancels their registration ticket.
* **Signature & Contracts:**
  - Input: `int eventId`.
  - Output: `bool`.
* **When it is used:** Invoked when a student cancels their event ticket (`RegistrationService.CancelTicket`).
* **Why:** Frees up ticket capacity for other students:
  * `[EventsTable.CurrentRegistrations = CurrentRegistrations - 1]`

---

### 2.10 `GetArchivedEvents`
* **Purpose:** Retrieves closed, concluded, or cancelled historical campus events with aggregate attendee telemetry, supporting multi-criteria filtering across Academic Year, Semester, Outcome Status, and Universal Search.
* **Signature & Contracts:**
  - Input: `string semester = null`, `string academicYear = null`, `string outcomeStatus = null`, `string search = null`.
  - Output: `List<EventModel>` (Models populated with `PreRegisteredCount`, `AttendedCount`, `NoShowCount`, and `CancelledCount`).
* **Internal Mechanics:**
  - Queries `dbo.EventsTable` left joined with a pre-aggregated subquery against `dbo.EventRegistrationTable`.
  - Evaluates `(Status IN ('Completed', 'Cancelled') OR (Status = 'Upcoming' AND EventEnd < GETDATE()))`.
  - Applies parameterized filters for semester months, academic year ranges, and text searches.
* **When it is used:** Invoked on `Page_Load` and filter triggers in the Events History module (`Frontend/Admin/EventHistory.aspx`).
* **Why:** Keeps daily operational dashboards uncluttered by isolating historical events into a dedicated, read-only accreditation archive:
  * `[EventsTable.Status, EventRegistrationTable.Status, EventHistory.aspx]`

---

### 2.11 `GetDistinctArchivedAcademicYears`
* **Purpose:** Extracts distinct academic years present across historical events to populate archive dropdown filters dynamically.
* **Signature & Contracts:**
  - Input: None.
  - Output: `List<string>` (e.g. `["A.Y. 2026-2027", "A.Y. 2025-2026"]`).
* **When it is used:** Invoked during filter dropdown initialization in `Frontend/Admin/EventHistory.aspx`.
* **Why:** Eliminates hardcoded calendar years and guarantees filter choices accurately reflect recorded database history:
  * `[EventsTable.EventStart, ddlAcademicYear]`

