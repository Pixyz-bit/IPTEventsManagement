# Admin landing page, access checks, and event archiving

The administrator landing page is `Frontend/Admin/AdminEvents.aspx` (Events Matrix). The former `Frontend/Admin/Dashboard.aspx`, its code-behind/designer, and its dedicated stylesheet were removed. Login, default routing, Access Denied links, sidebar branding, and admin breadcrumbs now point to Events Matrix.

Every admin page inherits `Backend/Helpers/AdminPage.cs`, which checks authentication and the Admin role in `OnPreInit`, before data loading and postback actions. The standalone TestConnection page is included. The scanner's static lookup and check-in methods perform independent session checks. The master page no longer offers anonymous preview access.

## Archive storage and behavior

The supplied SQL schema uses `dbo.EventsTable.Status VARCHAR(50)`. There is no dedicated event-status lookup table. `EventRegistrationTable.Status` is a separate attendance/registration state.

- Archive updates only the event status to `Archived`. The event, registrations, sponsors, and attendance records remain stored. Student catalog queries select `Upcoming`, so an archived event is hidden and registration is blocked by the repository's status check.
- The Events Matrix retains archived records and offers an Archived filter.
- Restore updates status to `Upcoming`. Schedule, audience, and capacity rules still apply.
- Limitation: archival replaces the previous lifecycle status. Restore does not recover an earlier `Cancelled` or `Completed` status. No schema redesign or database migration was applied in this change.

## Events Matrix postback repair

The event repeater now retains ViewState so row controls and archive command arguments are reconstructed on postback. Previously it disabled ViewState while only binding on the initial request, causing the matrix to appear empty after row actions. Archive handling now checks affected rows and displays encoded failure feedback for invalid/missing events or database errors.

## Verification

The C# project compiled successfully with temporary build outputs. HTTP checks against an isolated IIS Express copy with its database connection disabled verified all eleven admin-page anonymous/student guards, both scanner endpoint guards, admin landing routing, Archive postback row retention/error feedback, the Archived filter, and logout/session clearing. No real registration, attendance, or event records were changed. Live database inspection timed out; successful SQL archive writes still require testing against a running database.