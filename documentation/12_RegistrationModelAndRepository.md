# Model & Repository Documentation: EventRegistration

Event-wide cancellation is distinct from cancelling one registration. Joined projections include `EventStatus` and `EventCancellationReason`; `IsPassValid` and `CanCancel` reject inactive events. Both check-in entry points enforce event status in the transactional repository, so a saved QR cannot bypass cancellation. Existing attendance and registration rows are preserved. See [the cancellation flow](11_AdminDashboard.md).

- **Model Component:** [`EventRegistrationModel`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/EventRegistrationModel.cs)
- **Repository Component:** [`RegistrationRepository`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/RegistrationRepository.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Models` / `_241611JalopEventsManagement.Backend.Repository`
- **Target Entity / Table:** [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L78-L88) (`dbo.EventRegistrationTable`)

---

## 1. Architectural Purpose & Data Flow

[`EventRegistrationTable`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L78-L88) is the transactional join entity binding students (`dbo.StudentTable`) to university events (`dbo.EventsTable`).

`RegistrationRepository` guarantees:
1. **Attendance State Machine & 'NoShow' Default:**
   * **Initial State:** Upon booking, the status is immediately set to `'NoShow'`. Because the event has not occurred yet, the attendee has not physically arrived.
   * **During Event Check-In:** When the student arrives at the venue door and their QR ticket is scanned, `CheckInTimestamp` is recorded and the status transitions to `'Present'`.
   * **Post-Event State:** If the student never attends and never cancelled, their record naturally remains `'NoShow'`.
2. **Registration Period Cancellation Deadline:**
   * **Active Period:** Students can cancel their registration **only during the event's active registration period** (`DateTime.Now <= EventsTable.RegEnd`).
   * **Post-Deadline Lock:** Once the registration period closes (`DateTime.Now > RegEnd`), the registration is permanently locked and cannot be cancelled.
3. **Atomic Capacity Reservation:** Prevents seat over-allocation when concurrent students book the last available ticket (`WITH (UPDLOCK, HOLDLOCK)`).
4. **Capacity Re-crediting:** Atomically decrements `CurrentRegistrations` on event cancellation during the active registration window.

---

## 2. Model Specification: `EventRegistrationModel`

| Property | Data Type | Nullability | Description & Schema Mapping |
| :--- | :--- | :--- | :--- |
| `EventRegistrationId` | `int` | No | Primary Key (`dbo.EventRegistrationTable.EventRegistrationId (PK, IDENTITY)`). |
| `EventId` | `int` | No | Foreign Key referencing `dbo.EventsTable.EventId`. |
| `StudentId` | `string` | No | Foreign Key referencing `dbo.StudentTable.StudentId`. |
| `CurrentYearLvl` | `int` | No | Student year level snapshot at time of enrollment. |
| `CurrentSection` | `string` | No | Student section code snapshot at time of enrollment. |
| `Status` | `string` | No | Registration state: `'NoShow'` (default), `'Present'`, or `'Cancelled'`. |
| `CheckInTimestamp` | `DateTime?` | Yes | Nullable timestamp captured at the venue door during physical attendance check-in. |
| `IsCheckedIn` | `bool` | No | Computed domain helper: `CheckInTimestamp.HasValue && Status == "Present"`. |
| `IsCancelled` | `bool` | No | Computed domain helper: `Status == "Cancelled"`. |

---

## 3. Granular Repository Function Breakdown

### 3.1 `RegisterStudent`
* **Purpose:** Atomically books an event seat for a student while verifying capacity constraints.
* **Signature & Contracts:**
  - Input: `EventRegistrationModel registration`
  - Output: `int` (New `EventRegistrationId` on success, or `-1` if venue is full).
* **Internal Mechanics:**
  - Validates model inputs (`EventId > 0`, non-empty `StudentId`).
  - Executes a single SQL Server transaction with `UPDLOCK, HOLDLOCK` on `dbo.EventsTable`.
  - Verifies `CurrentRegistrations < MaxCapacity`. If true, inserts the registration row and increments `CurrentRegistrations + 1`. If full, rolls back and returns `-1`.
* **When it is used:** Triggered when a student clicks "Register for Event" on the Student Portal (`User/EventDetails.aspx`).
* **Why:** Guarantees seat availability without concurrency race conditions.
  - `[EventsTable.CurrentRegistrations < EventsTable.MaxCapacity]`

---

### 3.2 `IsStudentRegistered`
* **Purpose:** Determines whether a student holds an active, non-cancelled ticket for an event.
* **Signature & Contracts:**
  - Input: `int eventId`, `string studentId`
  - Output: `bool` (`true` if already enrolled).
* **Internal Mechanics:**
  - Executes parameterized count query `WHERE EventId = @EventId AND StudentId = @StudentId AND Status != 'Cancelled'`.
* **When it is used:** Evaluated when rendering event catalog cards to toggle between "Register" and "Registered / View Ticket" states.
* **Why:** Prevents duplicate active registrations for the same student on an event.

---

### 3.3 `CheckInStudent`
* **Purpose:** Confirms door attendance and records the check-in time stamp.
* **Signature & Contracts:**
  - Input: `int eventId`, `string studentId`
  - Output: `bool` (`true` if check-in was successfully recorded).
* **Internal Mechanics:**
  - Updates `dbo.EventRegistrationTable` setting `Status = 'Present'` and `CheckInTimestamp = DateTime.Now`.
* **When it is used:** Triggered at event entry desks by QR code scanner or attendee check-in desk (`Admin/CheckIn.aspx`).
* **Why:** Distinguishes verified attendees from absent students for certificate generation and post-event analytics.
  - `[EventRegistrationTable.CheckInTimestamp = GETDATE()]`

---

### 3.4 `CancelRegistration`
* **Purpose:** Cancels a student registration and re-opens the seat for other students, strictly within the active registration period.
* **Signature & Contracts:**
  - Input: `int eventRegistrationId`
  - Output: `bool` (`true` if cancelled; `false` if registration period ended or ticket already used/cancelled).
* **Internal Mechanics:**
  - In a transaction with `UPDLOCK, HOLDLOCK`, verifies that `r.Status == 'NoShow'` and `GETDATE() <= e.RegEnd`.
  - If valid, updates `Status = 'Cancelled'` and decrements `dbo.EventsTable.CurrentRegistrations` by 1.
  - If `GETDATE() > e.RegEnd`, the transaction rolls back and returns `false`, preventing late cancellations.
* **When it is used:** Triggered when a student clicks "Cancel Registration" on their student dashboard before `RegEnd`.
* **Why:** Enforces the institutional rule that cancellations are barred once registration closes so organizers can finalize venue seating and catering counts.
  - `[EventsTable.RegEnd >= GETDATE()]`

---

### 3.5 `GetRegistrationsByStudent`
* **Purpose:** Retrieves all active and past tickets booked by a student.
* **Signature & Contracts:**
  - Input: `string studentId`
  - Output: `List<EventRegistrationModel>`
* **Internal Mechanics:**
  - Joins `dbo.EventRegistrationTable` with `dbo.EventsTable` and `dbo.StudentTable` ordered by `EventStart DESC`.
* **When it is used:** Triggered on the student's "My Registrations" portal view.
  - `Session["StudentId"]`

---

### 3.6 `GetRegistrationsByEvent`
* **Purpose:** Retrieves the full attendee manifest for an event.
* **Signature & Contracts:**
  - Input: `int eventId`
  - Output: `List<EventRegistrationModel>`
* **Internal Mechanics:**
  - Joins `dbo.EventRegistrationTable` with `dbo.StudentTable` to return attendee names, programs, sections, and check-in statuses.
* **When it is used:** Triggered on the administrator event management view (`Admin/ManageEvents.aspx`) or when exporting attendance sheets.
