# Admin Events Matrix and lifecycle

The admin landing page is Frontend/Admin/AdminEvents.aspx. Every admin page inherits AdminPage, which checks authentication and the Admin role before page actions. Scanner web methods independently validate their sessions.

## Stored event statuses

dbo.EventsTable.Status supports exactly these three values:

| Status | Meaning | Allowed actions |
|---|---|---|
| Upcoming | Active event that has not ended; includes a running event | Edit or cancel before event end; registration also requires its date window and available capacity |
| Cancelled | Administrator cancelled the event with a recorded reason | Review records; registration and check-in are blocked |
| Completed | Event has ended | Review records; editing, cancellation, registration, and check-in are blocked |

The model rejects unsupported values. CK_EventsTable_Status enforces canonical spelling and length in the database. The database defaults to Upcoming.

Repository access persists Completed for Upcoming events whose end time has arrived. This happens on the next relevant request rather than through a background scheduler. Cancelled records are preserved. SQL date guards protect actions at the end-time boundary.

Individual registration status is separate: NoShow, Present, or Cancelled. Those values are not event lifecycle states.

## Matrix labels and colors

| Matrix label | Conditions | Color |
|---|---|---|
| Soon | Active event with seats available, before registration opens | Amber |
| Open | Active event, within registration dates, with seats available | Green |
| Close | Registration deadline passed, full capacity, or Completed event | Slate |
| Cancelled | Cancelled lifecycle status; takes priority over other conditions | Red |

These labels are calculated by EventModel.GetMatrixStatus, never saved into EventsTable.Status. Registration start and deadline are inclusive; event end is exclusive. Close can become Open again if capacity becomes available during the registration window. Closed registration does not itself mean the event is Completed.

Badges and filter tabs use the same colors. Visible text remains present so color is not the only indicator. The shared palette is defined in global.css.

## Cancel an unintended event

1. Click Cancel Event in the matrix or Event Details.
2. Review the title and consequences. Enter a reason of 1-500 characters.
3. Confirm Cancellation saves the change; Keep Event dismisses the dialog.
4. The event remains in the Cancelled tab and Event History.

Cancellation atomically updates only unfinished Upcoming events. It retains registrations, sponsors, attendance timestamps, and counts. Repeated or concurrent requests cannot replace the original reason. Ordinary editing cannot change lifecycle state or reopen an inactive event.

Event Details offers View Cancellation Details, which opens a modal containing the reason. The modal supports Close and Escape. Cancelled student passes show the reason, generate no admission QR, and offer no pass download. Scanner lookup and repository commits independently reject inactive events. No automatic email notifications are implemented.

## Database setup and migration

New installations use 01_DatabaseSchema.sql or 05_ConsolidatedDatabaseSchema.sql, which include the three-status constraint and default.

Existing installations run 06_EnforceEventLifecycleStatuses.sql against the configured application database. The transactional migration preserves records, refuses unsupported existing status values, adds the constraint/default, and completes ended Upcoming records. It can run repeatedly.

## Verification

Build before running tests/Invoke-CancellationRegression.ps1 in PowerShell 7. The suite uses a uniquely named disposable LocalDB database and a separate IIS Express clone. It checks the migration, status constraints, completion, registration boundaries, cancellation, attendance preservation, stale edits, pass validity, filtering, authorization, and database failures. It never targets the application database. The -Review option keeps the clone running for browser review until Enter.