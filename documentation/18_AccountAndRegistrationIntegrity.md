# Account and registration integrity fixes

## SaveManagedAccount
- **Purpose:** Save account-management fields together without erasing unedited student data.
- **Signature & Contracts:** `UserRepository.SaveManagedAccount(UserModel user, StudentProfile profile, string newPassword, int currentAdminUserId)` returns void; profile is required for Student, and an empty password preserves existing credentials.
- **Internal Mechanics:** Validate all supplied fields; hash a supplied password; begin one serializable transaction; lock account records; check the acting administrator, target, remaining administrators, and email; save the student profile through StudentRepository on that transaction; update exactly one account; commit.
- **Side Effects & Thrown Errors:** Updates credentials, role, status, email and supplied demographics together. Throws on invalid input, missing/ambiguous identities or failed writes; all writes roll back. Existing BirthDate and StudentId are untouched. Converting an account without a student profile to Student creates a profile, whose birthdate remains unknown.
- **When it is used:** Account Management Save.
- **Why:** Separate account writes previously survived later validation failures; UpdateStudentFull also wrote an omitted BirthDate as NULL.

## SaveManagedProfile
- **Purpose:** Save only student fields owned by account management.
- **Signature & Contracts:** Internal `StudentRepository.SaveManagedProfile(SqlConnection connection, SqlTransaction transaction, int userId, StudentProfile profile)` participates in the caller's transaction.
- **Internal Mechanics:** Resolve the student through UserId under a lock, reject multiple profiles or a changed existing StudentId, update supplied demographics or insert a new linked profile. Verify exactly one affected row.
- **Side Effects & Thrown Errors:** Never updates BirthDate. Throws for mismatched identity or failed writes, causing the account transaction to roll back.
- **When it is used:** SaveManagedAccount for Student accounts.
- **Why:** The editable StudentId must not select another account's profile.

## Registration data and reporting
Per the chosen scope, ticket creation dates are not collected. No timestamp-column migration is required for the existing database, and database records are not changed by this removal. Fresh-install schemas match the existing registration columns.

- **Purpose:** Support reservations and attendance without tracking when each reservation was made.
- **Signature & Contracts:** `EventRegistrationModel` retains ticket identity, academic snapshot, status and nullable `CheckInTimestamp`.
- **Internal Mechanics:** RegisterStudent inserts the existing registration columns; registration queries and MapRowToRegistration use the same projection. Analytics retains reservation totals, cancellations, turnout, demographics and check-in intervals. Reservation-date fields and registration-over-time projections are removed.
- **Side Effects & Thrown Errors:** No invented registration dates or database schema changes. Existing registration-window validation and attendance recording remain.
- **When it is used:** Ticket creation, manifests, scans and analytics.
- **Why:** Reservation totals and attendance do not require a ticket creation date. Registration opening/deadline are event policy fields, not substitutes for ticket creation dates.

## ValidateWindow
- **Purpose:** Enforce the same registration-window rule at repository boundaries.
- **Signature & Contracts:** `RegistrationDateTime.ValidateWindow(DateTime opening, DateTime deadline, DateTime eventStart, DateTime eventEnd)` returns void.
- **Internal Mechanics:** Reject reversed windows, SQL DATETIME dates before 1753, and registration dates on/after the event's calendar date. CreateEvent and UpdateEvent call it before writes.
- **Side Effects & Thrown Errors:** ArgumentException on invalid dates; no writes for invalid requests. Existing datetime-local inputs preserve seconds and use local server/application time.
- **When it is used:** Event creation and editing, including callers outside page handlers.
- **Why:** Preserve the current calendar-date policy rather than silently introducing same-day registration.

## Operational data
Account/student lists and exports no longer substitute sample records. Empty results remain empty; failed queries are logged and displayed as failures. Account actions reject missing users. New events start with no sponsors. Event modules require an actual event and fail with 404 for missing context or 503 for failed event lookup. Missing query parameters may select a real listed event; invalid supplied IDs never silently select another one. Sponsor lookup failures block editing rather than replacing the sponsor set with an empty list.

## Verification
Run MSBuild first, then `tests/AccountAndRegistrationFixes.Tests.ps1`. These regression checks are database-free and cover deadline round trips, repository boundary rejection, account validation, the existing registration projection and attendance timestamp mapping. Database transaction and browser tests require a controlled environment; do not run existing database-mutating test scripts against production records.

Run `node tests/RegistrationModal.Tests.js` to verify both roster modal buttons preserve their status, ticket reference and record ID after removing the date argument, and to check the changed inline JavaScript syntax.
