# System audit — 7 October 2026

This audit combines source review, compilation, database-free regression tests, and live browser checks at `http://localhost:8080`. It does not certify every possible case. No application source, database schema, existing event, registration, account, or password was changed as part of this audit. Wizard drafts were discarded. Normal repository reads can still invoke the application's existing automatic event-completion synchronization.

## Findings to address first

Evidence labels distinguish **reproduced** behavior from **source review** risks that still need an isolated database test.

### 1. Course targeting is silently cleared by a sponsor postback — high priority, reproduced

Source: `Frontend/Admin/CreateEvent.aspx:1026`, `restoreCourseSelection`; `:997`, `filterProgramsByDepartment`; `:978`, `onCourseSelectionChanged` (line numbers can move with concurrent edits).

Reproduction:

1. Enter valid event details and schedule.
2. Choose College of Computer Studies and select BSIT.
3. Continue to Sponsors and add QCU Alumni Association.
4. Continue to the summary.

The BSIT checkbox is now unchecked, `hfSelectedPrograms` is empty, and the summary says “All Academic Programs (Open to all majors).” The department remains selected, so this case broadens the audience to all programs in CCS. With no department selected, it can broaden it to all programs university-wide.

Cause: restoration first calls `filterProgramsByDepartment`, which calls `onCourseSelectionChanged`. Newly rendered native checkboxes are unchecked after a full postback, so that call overwrites the saved hidden value before it is restored. The publisher subsequently reads the empty hidden value as an unrestricted program audience.

Recommended change: preserve and validate the saved codes before any synchronization writes the hidden field; restore checks, apply department visibility, then serialize the final selection. Cover adding/removing sponsors, validation postbacks, and publishing retries. `tests/CreateEventAudience.Audit.js` reproduces the bug without database writes: **7 checks pass, 1 finding**.

![Summary after course selection was lost](C:/Users/arlan/.codex/visualizations/2026/10/07/01a11645-ceef-7a71-8090-e233b6d620ef/audit-course-reset.jpg)

### 2. Same-student duplicate registration has a concurrency gap — high priority, source review

Source: `Backend/Repository/RegistrationRepository.cs:37–103`; `Backend/Database/Migration/07_FinalDatabaseSchema.sql:113–138`.

`IsStudentRegistered` runs before the registration transaction. The transaction locks the event and protects its seat counter, but does not repeat the duplicate-ticket check after acquiring that lock. Two requests for the same student can both pass the preliminary check and then each insert a ticket if capacity remains. The supplied schema has no unique constraint preventing multiple active tickets for the same event/student.

Recommended change: check for an active ticket within the same locked transaction before insertion, return a distinct duplicate outcome to the page, and test simultaneous submissions. Consider a database constraint compatible with cancelled-ticket rebooking. This race was **not executed** because the isolated database run was not approved.

### 3. Banner upload validation differs between creation and editing — high priority, source review

Source: `Frontend/Admin/CreateEvent.aspx.cs:250–305`; `Frontend/Admin/EventDetails.aspx.cs:505–560`.

Creation's direct upload saves the submitted extension without a server-side image allowlist. Both creation and editing's Base64 path use the hidden filename's extension and write decoded bytes without checking the image format. Editing's direct-file path has an extension allowlist, but its Base64 alternative bypasses it. Client-side `accept` and preview checks do not validate a crafted server submission. The upload folder is inside the web application; no assets-folder configuration disabling executable handlers was found.

Recommended change: use one server-side uploader with an extension allowlist, decoded image validation, an explicit size limit, generated filenames, and a non-executable upload location. Reject invalid uploads visibly. Do not use a hidden filename or MIME prefix as proof of image content. No executable or malicious file was uploaded during this audit.

### 4. Scanner lookup can select an old cancelled registration after rebooking — medium priority, source review

Source: `Backend/Repository/RegistrationRepository.cs:483–510`.

The target-event query selects `TOP 1` by student ID/email without ordering or prioritizing non-cancelled registrations. Rebooking after cancellation creates another row. An ID/email lookup can therefore return the old cancelled pass even when the student has a current pass. The cross-event fallback has an ordering clause, but the target-event lookup does not.

Recommended change: keep exact ticket/registration lookup exact; for ID/email lookup prioritize the current active registration, then the most recent record. Test cancelled → rebooked → scanned using ticket, student ID, and email.

### 5. Capacity reduction is checked outside the update transaction — medium priority, source review

Source: `Frontend/Admin/EventDetails.aspx.cs:404–419`; `Backend/Repository/EventRepository.cs:276–321`.

The page reads the registration count and rejects a lower capacity before calling `UpdateEvent`. A new registration can commit between that read and the update. The update does not enforce `@MaxCapacity >= CurrentRegistrations` atomically. This can leave more tickets than seats after a concurrent edit.

Recommended change: protect capacity changes in the repository with the event lock and current counter check, using the same lock order as registration. Keep the page check for friendly feedback. The concurrency case was not executed.

### 6. Event and sponsor publication can partially succeed — medium priority, source review

Source: `Frontend/Admin/CreateEvent.aspx.cs:328–358`.

The event is inserted before sponsors are added. If sponsor persistence fails, the catch displays an overall publish failure although the event already exists. A retry can create another event. A successful publication also resets `Sponsors` without rebinding `rptSponsors`, allowing stale sponsor chips to remain visible for the next draft.

Recommended change: make event/sponsor publication atomic, or explicitly report partial success and prevent a duplicate retry. Rebind the sponsor list after resetting it. Also reset branch, department, and year selections intentionally; currently resetting defaults does not clear these dropdowns.

### 7. Login retains a plaintext-password fallback — high priority before deployment, source review

Source: `Frontend/Login/Login.aspx.cs:65–66`.

Authentication accepts either PBKDF2 verification or direct equality between the entered password and `PasswordHash`. The comment identifies this as local test-seed compatibility. New password writes are hashed, but the fallback still permits plaintext legacy rows to authenticate.

Recommended change: review and migrate legacy seed accounts before removing this fallback. Keep test-only authentication separate from deployed authentication. No password or credential record was changed or exposed in this audit.

### 8. Validation toast covers the wizard action on narrow screens — low priority, reproduced

After triggering the zero-capacity validation at the browser's approximately 545-pixel-wide viewport, the toast overlays the Schedule & Timeline button. Correcting the capacity and clicking Continue does not advance until the toast is dismissed. After dismissal, navigation works.

Recommended change: place validation feedback beside the field or reserve space for the toast so the primary action remains reachable.

### 9. Profile tab accessibility state is stale — low priority, reproduced

Source: `Frontend/User/StudentProfile.aspx:270–298`.

Switching to Account Credentials & Security changes visible panels and CSS classes but leaves Academic Demographics with `aria-selected="true"` and Security with `aria-selected="false"`.

Recommended change: synchronize `aria-selected`, controlled panel IDs, and keyboard tab behavior with the visible tab.

### 10. Existing sessions do not revalidate account deactivation or role changes — high priority, source review

Source: `Backend/Helpers/SessionHelper.cs:28–38`; `Backend/Helpers/AdminPage.cs:30–51`; `Backend/Helpers/StudentPage.cs:10–25`; `Frontend/Login/Login.aspx.cs:57`.

Login checks the database's `IsActive`, but protected-page guards subsequently trust the user ID and role stored in the session. Deactivating another logged-in account or changing its role does not invalidate that session in these guards. A previously authenticated user can therefore retain old privileges until the session expires or is cleared. Some account-management writes revalidate the acting administrator, but that does not cover every protected operation.

Recommended change: add centralized session revocation/version checking or revalidate active status and role at protected request boundaries. Test deactivation and role changes while a second browser remains logged in. This was not reproduced by modifying a real account.

## Audience filtering: what currently works and what does not

| Dimension | Current enforcement | Evidence |
|---|---|---|
| Campus | Target must match the stored campus unless unrestricted. A missing campus does not bypass a non-empty target. | Shared SQL predicate in `EventRepository.AudienceEligibilitySql`; full campus matrix not executed. |
| College | Target must match the stored department unless unrestricted. | Shared SQL predicate; full college matrix not executed. |
| Program | Comma-delimited exact matching plus supported code/full-name aliases; multiple selections are OR within this dimension. | Live BSA-only event 9 is hidden from the BSIT student and its direct registration URL is rejected. Program persistence has finding 1. |
| Year | A null browsing year bypasses the year restriction; final booking checks the year chosen by the student. | Dashboard passes `null` at `Dashboard.aspx.cs:155–156`; predicate allows `@YearLevel IS NULL`; registration restricts the dropdown and checks the submitted year. |
| Combined | All targeted dimensions must match; matching a program alone does not bypass a different department/campus. | Shared predicate is used for catalog, direct registration eligibility, and atomic booking. Full combination matrix not executed. |

**Year filtering does not hide events by a verified student year.** The final schema deliberately removed student YearLevel/Section, and the profile says “Selected during event registration.” A student can select an event's required year because there is no stored academic year against which to verify the declaration. This is an existing policy/design limitation, not a change made during this audit. If the intended requirement is that only students of a verified year can see and book an event, a trusted year source is necessary. Do not silently restore a removed database field without deciding that policy.

Live audience comparison:

- The test account's profile is San Bartolome / College of Computer Studies / BS Information Technology.
- Admin event 9, Kitchen Cooking, targets **BSA** with other dimensions open. It is absent from this student's six-card catalog and a direct link displays the audience mismatch message.
- Admin event 8, Utilizing AI in the Modern World, has all dimensions unrestricted and is visible to the student.
- Cancelled events tested through direct links reject registration.

![Student direct link blocked for a program mismatch](C:/Users/arlan/.codex/visualizations/2026/10/07/01a11645-ceef-7a71-8090-e233b6d620ef/audit-audience-denied.jpg)

## Unused code and cleanup candidates

`node tests/UnusedCode.Audit.js` found **19 method definitions with no application-source references**. This is a candidate inventory, not permission to blindly delete public APIs. Tests, external consumers, reflection, and ASP.NET event binding must be checked first.

| Area | Candidates |
|---|---|
| EventRepository | `GetEventsCreatedByUser`, `IncrementRegistrationCount`, `DecrementRegistrationCount` |
| RegistrationRepository | `CheckInStudent`, `GetTotalPresentAttendees` |
| SponsorRepository | `DeleteSponsor` |
| UserRepository | `GetUserByEmail`, `UpdateUserEmail`, `UpdateUserStatus`, `UpdateUserRole`, `AdminResetPassword` |
| AccountManagement code-behind | `ResolvePhotoUrl`, `GetAffiliationText` |
| AdminEvents code-behind | `GetCapacityPercentage` |
| CreateEvent code-behind | `FormField_Changed` |
| EventPreRegistered code-behind | `btnCancelRow_Command` |
| Dashboard code-behind | `GetStatusBadgeCss`, `ShowEventDetailsModal`, `btnCloseModal_Click` |

Additional confirmed obsolete structures:

- Dashboard retains an invisible `phModalHidden` control tree and its old server-modal filling code even though the current modal is client-rendered. Remove the hidden controls, related handlers/methods, and designer fields together after checking all references.
- EventAnalytics retains invisible `phLegacyStateHolders` and old distribution repeaters while still calculating/binding them. These do not contribute to the rendered UI; review and remove only calculations unused by current charts and metrics.
- StudentProfile model still has YearLevel/Section, and StudentRepository has optional mapping for columns absent from the final schema. These compatibility paths no longer establish a trusted student year.
- `tests/Invoke-CancellationRegression.ps1` is stale relative to current UI: it expects a Cancel Event matrix row button that has intentionally been removed. Its assertions/fixture interactions must be updated before treating a failure as a regression.
- Two missing literal `Student_Photo.jpg` references are inside the unused, file-existence-guarded `ResolvePhotoUrl` helper. They are cleanup candidates, **not confirmed broken images on the current page**.

No candidate was deleted during this audit.

## Verification performed

| Check | Result |
|---|---|
| Solution MSBuild | Passed, no errors or warnings reported |
| ASP.NET page precompilation | Passed |
| Actual inline/external JavaScript syntax inventory | 15 executable script blocks parsed, zero syntax errors; JSON script blocks excluded |
| Account/date/registration mapping regression | 12 checks passed, database-free |
| Registration modal data and script regression | Passed |
| Analytics filters, reset, empty roster, tab persistence, chart hover/keyboard tooltips | Passed |
| Course selection/select-all/clear/department switch/postback audit | 7 passed, 1 reproduced course-restoration finding |
| Admin and student sign-in | Passed with user-supplied test accounts |
| Blank login | Rejected with feedback |
| Anonymous admin details access | Redirected to login |
| Student accessing AdminEvents | Denied |
| Wizard empty title / zero capacity | Rejected |
| Reversed registration window / same-day registration deadline / reversed event times | Rejected in the live wizard |
| Matching unrestricted event catalog visibility | Passed |
| Nonmatching program catalog visibility and direct URL access | Passed, event 9 hidden and direct URL rejected |
| Cancelled / expired / nonexistent registration event | Rejected with specific feedback |
| Incomplete student registration without commitment confirmation | Rejected; no ticket created |
| Student's no-registration state | Rendered correctly |
| EventPass without a registration | Redirected to dashboard |
| Access to a known other student's ticket | Redirected to dashboard |
| Matrix Soon/Open status tabs | Correct empty state and four open-event rows |
| Student security tab / updated button appearance | Rendered correctly; accessibility-state issue noted |
| Sign-out | Returned to login |

## Limits and next test set

The isolated LocalDB attempt could not connect inside the sandbox. Permission to run the disposable-database audit outside the sandbox was rejected, so it was not retried through another route. No new events or registrations were submitted on the user's application database. Therefore these cases remain **unverified at runtime**:

- Full campus/college/program/year cross-product, aliases and malformed targets.
- Simultaneous duplicate bookings and last-seat booking races.
- Capacity edit while another student registers.
- Cancel → rebook → ID/email scanner lookup.
- Successful registration, cancellation, and attendance mutations in this audit.
- Event cancellation rollback and event/sponsor partial-failure rollback.
- Upload rejection paths and file cleanup after a failed publish.
- Account editing/deactivation, email uniqueness races, password changes, and import writes.

`tests/SystemAudit.cs` and `tests/Invoke-SystemAudit.ps1` prepare a repository simulation against a randomly named database only; the executable refuses any database whose name does not begin `JalopAudit_`. The runner source compiles, but its database cases were **not run**. Several checks deliberately report known/potential defects instead of claiming that all cases pass. Before running it, review the optional check-in-before-start policy: current code permits early admin check-in while the event is Upcoming; whether that should be blocked is a business decision.

Further source-review items to include in a follow-up fix batch: target-event context should be verified again by the check-in commit endpoint (it currently receives only a registration ID); edited program text needs length/token validation; and user-facing database exception details should be logged rather than displayed verbatim.
