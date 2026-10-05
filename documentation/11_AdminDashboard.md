# Admin Events Matrix and cancellation

The admin landing page is `Frontend/Admin/AdminEvents.aspx`. The obsolete admin Dashboard and its stylesheet were removed. Admin login, sidebar branding, breadcrumbs and Access Denied links lead to Events Matrix.

Every admin page inherits `Backend/Helpers/AdminPage.cs`, which checks authentication and the Admin role in `OnPreInit`, before data loading and postback actions. Scanner web methods check their own sessions. Admin ViewState is bound to the current session.

## Cancel an unintended event

1. In Events Matrix, click **Cancel Event**, or use that link in Event Details.
2. Review the event title and consequences. Enter a reason of 1–500 characters.
3. Click **Confirm Cancellation**. **Keep Event** dismisses the dialog without saving.
4. The event appears in the **Cancelled** tab and remains available in Event History.

Cancellation uses `EventCancellationModel` and `EventCancellationRepository`. It atomically changes `EventsTable.Status` to `Cancelled` and stores `CancellationReason`. It does not delete events, registrations, sponsors, attendance timestamps, or registration counts. Completed and already-cancelled events cannot be cancelled. A repeated or concurrent request cannot overwrite the original reason. Ordinary event editing cannot modify lifecycle status or reopen a cancelled event.

Registration queries exclude cancelled events. Existing student registration cards display **EVENT CANCELLED**. Their pass shows the reason, generates no QR, and offers no admission-pass download. Scanner lookup and the authoritative check-in repository both block cancelled/inactive events, including previously downloaded QR codes. No automatic email notifications are implemented.

## Storage and legacy records

The supplied schema stores lifecycle state in `dbo.EventsTable.Status VARCHAR(50)` and reasons in `CancellationReason NVARCHAR(500)`. There is no separate event-status lookup table. Registration/attendance state in `EventRegistrationTable.Status` is separate and remains historical evidence after event-wide cancellation. No schema migration is needed.

Archive and restore buttons, handlers, and repository methods have been removed. Existing records with legacy `Archived` status remain inactive; they are not automatically restored, converted, or deleted. An administrator can explicitly cancel a legacy hidden event with a reason. Event History and CSV export remain available for records and reporting.

The matrix retains repeater ViewState across postbacks. It uses actual database events rather than fabricated action rows; database failures show an error. Cancellation failures preserve the entered reason and confirmation dialog.

Status tabs render their label and badge through `LinkButton.Text`, avoiding nested controls that Web Forms can clear when restoring Text from ViewState. Regression tests click every status tab and verify that all labels, counts, and the selected state remain present after each postback.

## Verification

Build the project before running `tests/Invoke-CancellationRegression.ps1` from PowerShell 7. The script requires installed SQL Server LocalDB, sqlcmd, .NET Framework and IIS Express. It creates a uniquely named disposable LocalDB database from the supplied consolidated schema and tests the compiled application through a separate clone. The runner refuses to target the real database and removes its temporary database afterward. It does not add verification/session helpers to the application checkout.

The suite checks lifecycle transitions, reason validation, preservation of attendance and registrations, concurrent/repeated requests, stale edits, pass invalidation, scanner protections, admin authorization, real repeater postbacks, and database failure handling. `-Review` keeps the isolated app open until Enter is pressed for a browser inspection. Temporary diagnostic files remain in the printed temp directory.
