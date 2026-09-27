# Model & Repository Documentation: SponsorModel & SponsorRepository

- **Model Component:** [`SponsorModel`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/SponsorModel.cs)
- **Repository Component:** [`SponsorRepository`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/SponsorRepository.cs)
- **Namespace:** `_241611JalopEventsManagement.Backend.Models` / `_241611JalopEventsManagement.Backend.Repository`
- **Target Entity / Table:** [`01_DatabaseSchema.sql`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Database/Migration/01_DatabaseSchema.sql#L65-L72) (`dbo.SponsorListTable`)

---

## 1. Architectural Purpose & Data Flow

`dbo.SponsorListTable` maintains the corporate, organizational, and institutional sponsors associated with university events. 

`SponsorRepository` provides dedicated data access methods to query, associate, and manage sponsors for events without polluting the core `EventRepository`, maintaining clean adherence to the Single Responsibility Principle.

---

## 2. Model Specification: `SponsorModel`

| Property | Data Type | Nullability | Description & Schema Mapping |
| :--- | :--- | :--- | :--- |
| `SponsorEntryId` | `int` | No | Primary Key (`dbo.SponsorListTable.SponsorEntryId (PK, IDENTITY)`). |
| `SponsorName` | `string` | No | Name of corporate or institutional partner (`NVARCHAR(150)`). |
| `CreatedAt` | `DateTime` | No | Date and time the sponsor was linked to the event. |
| `EventId` | `int` | No | Foreign Key referencing `dbo.EventsTable.EventId`. |
| `EventTitle` | `string` | Yes | Navigation projection from `dbo.EventsTable.Title`. |

---

## 3. Granular Repository Function Breakdown

### 3.1 `GetSponsorsByEventId`
* **Purpose:** Retrieves all sponsors linked to a given event.
* **Signature & Contracts:**
  - Input: `int eventId` (Must be > 0).
  - Output: `List<SponsorModel>` (Ordered by `SponsorEntryId ASC`).
* **Internal Mechanics:**
  - Executes a parameterized `SELECT ... FROM dbo.SponsorListTable s INNER JOIN dbo.EventsTable e ON s.EventId = e.EventId WHERE s.EventId = @EventId`.
  - Maps each returned row to a `SponsorModel` instance.
* **When it is used:** Invoked on event details views (`EventDetails.aspx`) and event edit wizards to show partner logos/names.
* **Why:** Surfaces institutional and corporate sponsors on public event cards.
  - `[SponsorListTable.EventId = EventsTable.EventId]`

---

### 3.2 `AddSponsor`
* **Purpose:** Adds a single sponsor record for an event.
* **Signature & Contracts:**
  - Input: `SponsorModel sponsor` (Must contain valid `SponsorName` and `EventId > 0`).
  - Output: `int` (The generated `SponsorEntryId`).
* **Internal Mechanics:**
  - Executes a parameterized `INSERT INTO dbo.SponsorListTable (SponsorName, CreatedAt, EventId)` and returns `SCOPE_IDENTITY()`.
* **When it is used:** Invoked during event creation (`CreateEvent.aspx`) or when an administrator adds an individual sponsor.
* **Why:** Links a verified partner to the specified event.

---

### 3.3 `AddSponsors`
* **Purpose:** Batch adds multiple sponsor names to an event.
* **Signature & Contracts:**
  - Input: `int eventId`, `IEnumerable<string> sponsorNames`
  - Output: `int` (Count of sponsors successfully created).
* **Internal Mechanics:**
  - Iterates through the collection, skips empty entries, and creates `SponsorModel` records.
* **When it is used:** Invoked when saving a new event with multiple sponsors input via chip/tag selector.

---

### 3.4 `DeleteSponsor`
* **Purpose:** Removes a single sponsor record from an event.
* **Signature & Contracts:**
  - Input: `int sponsorEntryId`
  - Output: `bool` (`true` if deleted; `false` otherwise).
* **Internal Mechanics:**
  - Parameterized `DELETE FROM dbo.SponsorListTable WHERE SponsorEntryId = @SponsorEntryId;`.
* **When it is used:** Invoked when an administrator removes a specific sponsor badge from an event.

---

### 3.5 `DeleteSponsorsByEventId`
* **Purpose:** Deletes all sponsor associations for an event.
* **Signature & Contracts:**
  - Input: `int eventId`
  - Output: `bool` (`true` if deleted; `false` otherwise).
* **Internal Mechanics:**
  - Parameterized `DELETE FROM dbo.SponsorListTable WHERE EventId = @EventId;`.
* **When it is used:** Invoked when an event is updated with a completely replaced sponsor list or before an event is deleted.
