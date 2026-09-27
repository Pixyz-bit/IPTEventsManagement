# Model Documentation: EventModel

- **Component:** [`EventModel`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/EventModel.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Models`
- **Schema Mapping Source:** [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L43-L72) (`dbo.EventsTable`)

---

## 1. Architectural Purpose & Role

The `EventModel` is a clean Plain Old CLR Object (POCO) representing an event entity, schedule, venue location, capacity limit, lifecycle status, and 4-tier audience targeting criteria. UI validation is handled directly at the Web Forms boundary (`.aspx` validators and code-behind `.aspx.cs`), keeping this model lightweight and decoupled.

---

## 2. Properties & Data Contracts

| Property | Data Type | Nullability | Schema Mapping Reference |
| :--- | :--- | :--- | :--- |
| `EventId` | `int` | No | `dbo.EventsTable.EventId (INT IDENTITY, PK)` |
| `Title` | `string` | No | `dbo.EventsTable.Title (NVARCHAR(200), NOT NULL)` |
| `Description` | `string` | Yes | `dbo.EventsTable.Description (NVARCHAR(MAX), NULL)` |
| `VenueLocation` | `string` | No | `dbo.EventsTable.VenueLocation (NVARCHAR(200), NOT NULL)` |
| `MaxCapacity` | `int` | No | `dbo.EventsTable.MaxCapacity (INT, NOT NULL)` |
| `CurrentRegistrations` | `int` | No | `dbo.EventsTable.CurrentRegistrations (INT, NOT NULL, DEFAULT 0)` |
| `CreatedByUserId` | `int` | No | `dbo.EventsTable.CreatedByUserId (INT, NOT NULL, FK -> UserTable)` |
| `EventStart` | `DateTime` | No | `dbo.EventsTable.EventStart (DATETIME, NOT NULL)` |
| `EventEnd` | `DateTime` | No | `dbo.EventsTable.EventEnd (DATETIME, NOT NULL)` |
| `RegStart` | `DateTime` | No | `dbo.EventsTable.RegStart (DATETIME, NOT NULL)` |
| `RegEnd` | `DateTime` | No | `dbo.EventsTable.RegEnd (DATETIME, NOT NULL)` |
| `Status` | `string` | No | `dbo.EventsTable.Status (VARCHAR(50), NOT NULL, DEFAULT 'Upcoming')` |
| `CancellationReason` | `string` | Yes | `dbo.EventsTable.CancellationReason (NVARCHAR(500), NULL)` |
| `TargetBranch` | `string` | Yes | `dbo.EventsTable.TargetBranch (NVARCHAR(100), NULL)` |
| `TargetDepartment` | `string` | Yes | `dbo.EventsTable.TargetDepartment (NVARCHAR(100), NULL)` |
| `TargetProgram` | `string` | Yes | `dbo.EventsTable.TargetProgram (NVARCHAR(100), NULL)` |
| `TargetYearLevel` | `int?` | Yes | `dbo.EventsTable.TargetYearLevel (INT, NULL)` |

---

## 3. Computed Domain Helpers

### 3.1 `RemainingCapacity`
* **Purpose:** Calculates remaining ticket availability.
* **Signature & Contracts:**
  - Output: `int` (`Math.Max(0, MaxCapacity - CurrentRegistrations)`)
* **When it is used:** Displayed on public event cards and checked prior to ticket reservation.
* **Why:** In [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L48-L54), `MaxCapacity` and `CurrentRegistrations` reside on the event itself. Computing availability dynamically prevents overbooking without running costly `COUNT(*)` queries on `EventRegistrationTable`.

---

### 3.2 `IsRegistrationOpen`
* **Purpose:** Evaluates whether registration is currently permitted based on time window, status, and remaining capacity.
* **Signature & Contracts:**
  - Output: `bool` (`Status == "Upcoming" && now >= RegStart && now <= RegEnd && CurrentRegistrations < MaxCapacity`)
* **When it is used:** Evaluated when rendering the "Register" button on event detail pages and validated in the registration service.
* **Why:** Enforces that students cannot register before `RegStart`, after `RegEnd`, or once `MaxCapacity` is reached:
  * `[EventsTable.RegStart, EventsTable.RegEnd, EventsTable.Status, EventsTable.CurrentRegistrations]`

---

### 3.3 `IsOpenToAll`
* **Purpose:** Evaluates whether the event is accessible to the entire student body without cohort restrictions.
* **Signature & Contracts:**
  - Output: `bool` (`TargetBranch == null && TargetDepartment == null && TargetProgram == null && !TargetYearLevel.HasValue`)
* **When it is used:** Evaluated by the event catalog filter when presenting events to unauthenticated guests or non-restricted feeds.
* **Why:** In Issue D, a `NULL` audience value denotes an open event. This helper avoids null checks in UI and repository layers:
  * `[EventsTable.TargetBranch, EventsTable.TargetDepartment, EventsTable.TargetProgram, EventsTable.TargetYearLevel]`
