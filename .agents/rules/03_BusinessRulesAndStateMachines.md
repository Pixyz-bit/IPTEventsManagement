# Domain & Business Rules: State Machines & Logic Contracts

- **Category:** Domain Logic, Business Rules & State Transitions
- **Applies to:** Event Scheduling, Student Registration, QR Attendance Verification, and Cancellation Rules.

---

## 1. 4-Tier Audience Matrix

University events can be tailored to specific student cohorts across 4 independent academic dimensions.

| Dimension | Schema Column (`dbo.EventsTable`) | Rule & Evaluation |
| :--- | :--- | :--- |
| **1. Campus Branch** | `TargetBranch NVARCHAR(100)` | If `NULL`, event is open to all university branches. If populated, must match `StudentTable.CampusBranch`. |
| **2. Department / College** | `TargetDepartment NVARCHAR(100)` | If `NULL`, open to all departments. If populated, must match `StudentTable.Department`. |
| **3. Academic Program / Courses** | `TargetProgram NVARCHAR(100)` | If `NULL` or empty, open to all programs. If populated with one or more comma-separated courses (e.g., `"BSIT, BSCS"`), student's `StudentTable.Program` must be contained in the selection. |
| **4. Year Level** | `TargetYearLevel INT` | If `NULL`, open to all year levels (1st–4th year). If populated, must match `StudentTable.YearLevel`. |

### Implementation Contract:
In `EventRepository.GetEventsForStudent`:
```sql
WHERE (@Branch IS NULL OR TargetBranch IS NULL OR TargetBranch = @Branch)
  AND (@Dept IS NULL OR TargetDepartment IS NULL OR TargetDepartment = @Dept)
  AND (TargetProgram IS NULL OR TargetProgram = '' OR @Program IS NULL OR @Program = '' OR ',' + REPLACE(TargetProgram, ' ', '') + ',' LIKE '%,' + @Program + ',%')
  AND (@YearLevel IS NULL OR TargetYearLevel IS NULL OR TargetYearLevel = @YearLevel)
```

### Event Schedule Model:
- **Event Date**: Events occur on a single designated calendar date.
- **Event Time Window**: Admin picks the kickoff time (`EventStartTime`) and conclusion time (`EventEndTime`) on that date (`EventStart = Date + StartTime`, `EventEnd = Date + EndTime`).
- **Registration Window**: Registration opens on `RegStart` and concludes at `RegEnd` (which must be before or equal to `EventStart`).
- **5-Step Publishing Wizard**:
  - `Step 01`: Core Event Specifications (Title, Venue, Max Capacity, Description)
  - `Step 02`: Schedule & Timeline (Single Date, Start Time, End Time, Registration Window)
  - `Step 03`: 4-Tier Demographic Audience Targeting (Multi-Course Program Selector)
  - `Step 04`: Partner & Corporate Sponsor Associations
  - `Step 05`: Event Specifications Summary & Final Confirmation (`btnConfirmPublish`)

---

## 2. Event Registration Lifecycle & 'NoShow' State Machine

Every student ticket in `dbo.EventRegistrationTable` traverses a deterministic state machine:

```text
               ┌───────────────────────────────┐
               │   Student Books Ticket        │
               │   (Status = 'NoShow')         │
               └───────────────┬───────────────┘
                               │
            ┌──────────────────┴──────────────────┐
            │                                     │
            ▼                                     ▼
 [Door Check-In Scanned]           [Student Cancels Before RegEnd]
 Status ➔ 'Present'                Status ➔ 'Cancelled'
 CheckInTimestamp ➔ GETDATE()      CurrentRegistrations ➔ Count - 1
            │                                     │
            ▼                                     ▼
 [Verified Attendee]               [Slot Re-opened in Room]
```

### Directives:
1. **Initial Default State (`'NoShow'`):**
   * Right upon registration, status is set to `'NoShow'` and `CheckInTimestamp = NULL`.
   * **Rationale:** Because the event has not yet happened, the student has not physically arrived.
2. **Attendance Transition (`'Present'`):**
   * When the student arrives at the venue door and their QR ticket is scanned, `RegistrationRepository.CheckInStudent` stamps `CheckInTimestamp = DateTime.Now` and sets `Status = 'Present'`.
3. **Absence State Retention:**
   * If an event concludes and the student never checked in and never cancelled, their record naturally remains `'NoShow'`, providing clean post-event attendance ratios (`Present / Total Registered`).

---

## 3. Registration Window & Cancellation Deadline Policy

### A. 3-State Registration Window Presentation Contract
To avoid misleading students with generic "CLOSED" indicators before registration begins, client interfaces (cards, modals, badges) must adhere to three distinct lifecycle states based on `DateTime.Now`:

| Timeline Condition | Registration Window State | Badge / Pill Text | Badge Style Specification | Action Button State |
| :--- | :--- | :--- | :--- | :--- |
| **`DateTime.Now < EventsTable.RegStart`** | **Not Yet Started** | **`SOON`** *(Strictly "SOON", never "OPENS SOON")* | Amber / Gold pill (`#FEF08A` / `#854D0E`), solid border | **Disabled:** `"Opens on [RegStart Date]"` |
| **`DateTime.Now >= EventsTable.RegStart` AND `DateTime.Now <= EventsTable.RegEnd`** | **Active Window** | **`OPEN`** | Neon Emerald pill with pulsing green indicator dot | **Active:** `"Register For Event"` (if capacity permits) |
| **`DateTime.Now > EventsTable.RegEnd`** OR Event is Cancelled / Completed | **Closed Window** | **`CLOSED`** | Slate/Dark neutral pill | **Disabled:** `"Registration Closed"` |

### B. Business Directives & Rules
1. **Active Registration Period:**
   * Students may only register when:
     * `EventsTable.Status = 'Upcoming'`
     * `DateTime.Now >= EventsTable.RegStart`
     * `DateTime.Now <= EventsTable.RegEnd`
     * `EventsTable.CurrentRegistrations < EventsTable.MaxCapacity`
2. **Strict Cancellation Deadline:**
   * **Before `RegEnd`:** Students are allowed to cancel their reservation.
   * **After `RegEnd`:** The registration is **permanently locked**. The student cannot cancel their ticket because registration has closed and event organizers have finalized venue seating and logistical preparations.
   * **Checked-In Tickets:** A student who has already been marked `'Present'` cannot cancel their registration.
3. **Atomic Slot Release:**
   * When a valid cancellation occurs before `RegEnd`, `EventsTable.CurrentRegistrations` is atomically decremented by 1, instantly freeing up a seat in SQL Server for another student.

---

## 4. Fully Booked Mechanics & Layer Responsibility

Capacity enforcement requires distinct, coordinated responsibilities between the Repository and Code-Behind:

### Repository Layer Responsibility (The Concurrency Shield):
* Must use transactions with `WITH (UPDLOCK, HOLDLOCK)`.
* Checks `IF @Current >= @Max`. If full, rolls back and returns `-1`.
* **Never rely solely on UI checks to prevent overbooking**, as concurrent HTTP requests can cause overselling.

### Presentation Layer Responsibility (`.aspx.cs`):
* Evaluates `event.RemainingCapacity <= 0` or `!event.IsRegistrationOpen`.
* If full, disables the "Register" button and displays a `"Fully Booked"` badge.
* When a student cancels in their portal, the database decrements the count; upon the next page refresh, `RemainingCapacity > 0` and the button automatically re-enables.
* Handles return codes from `RegisterStudent`:
  * `-1`: Display `"Sorry, this event is fully booked."`
  * `-2`: Display `"Registration period is closed."`
  * `> 0`: Display `"Registration successful!"`

---

## 5. Campus Events Matrix Display, Columns & Sorting Contract (`AdminEvents.aspx`)

### Operational Context & Role
- **Primary Objective:** Serves as the central operational cockpit exclusively for `Closed`, `Open`, and `Upcoming` events. Concluded or cancelled events are explicitly excluded and deferred to Events History.
- **Parent Hub Role:** Acts as the single entry gateway to the four event-level sub-modules. Selecting an event (`View >`) routes the admin into the sub-module pipeline:
  $$\text{Event Details (EventDetails.aspx)} \longrightarrow \text{Event PreRegistered} \longrightarrow \text{Event Scanner \& Attendance} \longrightarrow \text{Event Analytics}$$
- **Operational Monitoring:** Allows administrators to track live registration windows (open, closing, or scheduled) and real-time seat occupancy before launching event gates.

### A. 3-Status Lifecycle Standard
The administrative Events Matrix strictly recognizes only **three (3)** display and filter statuses:
1. **`Open`**: The event registration is actively open (`DateTime.Now >= RegStart && DateTime.Now <= RegEnd && Status == 'Upcoming' && CurrentRegistrations < MaxCapacity`).
2. **`Soon`**: The event is scheduled in the future, but registration has not yet opened (`DateTime.Now < RegStart && Status == 'Upcoming'`).
3. **`Close`**: The registration period has expired (`DateTime.Now > RegEnd`), capacity is saturated (`CurrentRegistrations >= MaxCapacity`), or the event is closed.

### B. Chronological Row Sorting Rule
* Rows must be ordered **from the most upcoming to the furthest out**:
  * Active and upcoming events appear first, sorted ascending by `EventStart` (the event happening soonest is at the top).
  * Past or concluded events are deferred to historical views, maintaining clean forward-looking operational focus.

### C. Column Structure & Arrangement
The matrix table columns must adhere to this exact left-to-right order:
1. **`Status`**: Pill badge displaying `Open`, `Soon`, or `Close`.
2. **`Event Title`**: Prominent event title.
3. **`Venue and Date`**: 
   * Line 1: `VenueLocation` (e.g., `QCU Auditorium`)
   * Line 2: `EventStart` formatted as date (e.g., `9/13/2026`)
4. **`Reg. Deadline`**:
   * `From:` followed by `RegStart` date (e.g., `9/8/2026`)
   * `To:` followed by `RegEnd` date (e.g., `9/10/2026`)
5. **`Occupancy`**: Ratio format `CurrentRegistrations/MaxCapacity` (e.g., `150/200`).
6. **Action**: `View >` link navigating to [`EventDetails.aspx?eventId={id}`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/EventDetails.aspx).
