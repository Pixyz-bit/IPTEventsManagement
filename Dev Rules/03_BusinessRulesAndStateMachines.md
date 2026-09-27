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
| **3. Academic Program** | `TargetProgram NVARCHAR(100)` | If `NULL`, open to all programs. If populated, must match `StudentTable.Program`. |
| **4. Year Level** | `TargetYearLevel INT` | If `NULL`, open to all year levels (1st–4th year). If populated, must match `StudentTable.YearLevel`. |

### Implementation Contract:
In `EventRepository.GetEventsForStudent`:
```sql
WHERE (@Branch IS NULL OR TargetBranch IS NULL OR TargetBranch = @Branch)
  AND (@Dept IS NULL OR TargetDepartment IS NULL OR TargetDepartment = @Dept)
  AND (@Program IS NULL OR TargetProgram IS NULL OR TargetProgram = @Program)
  AND (@YearLevel IS NULL OR TargetYearLevel IS NULL OR TargetYearLevel = @YearLevel)
```

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

1. **Active Registration Period:**
   * Students may only register when:
     * `EventsTable.Status = 'Upcoming'`
     * `DateTime.Now >= EventsTable.RegStart`
     * `DateTime.Now <= EventsTable.RegEnd`
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
