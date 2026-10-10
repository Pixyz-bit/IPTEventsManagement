# Admin layout audit — 9 October 2026

## Verdict

The admin interface has a recognizable shared visual system, but its responsive implementation fails the consistency check. Desktop page widths are largely consistent. The main problems are clipped controls, overlapping table content, duplicated component styles, and missing navigation on smaller screens.

**14 findings: 0 P0, 6 P1, 4 P2, 4 P3.** Fix the mobile navigation and clipped operational controls before cosmetic changes.

This is an audit report. No application files or records were changed.

## Coverage and evidence

Inspected all 11 ASPX pages in `Frontend/Admin`, the shared `Admin.Master`, `global.css`, and all 11 admin stylesheets. Used the running application at localhost:8080 with the authorized test admin account.

- Desktop: 1440 × 1000 viewport; screenshots and computed styles on all pages.
- Tablet: 768 × 1024 viewport; DOM measurements on all pages.
- Mobile: 390 × 844 viewport; screenshots and DOM measurements on all pages.
- Examined the Student Directory edit dialog and Account Management manage dialog on mobile. Closed both without saving.
- Event subpages used the same sample event, making header and tab comparisons meaningful.
- Higher Create Event steps were reviewed in source; only the initial step was exercised live in this audit. No event was published or draft fields entered.
- Camera acquisition, real touch gestures, text zoom, every empty/error state, exhaustive keyboard testing, and performance timing were not exercised. Viewport emulation proves layout, not physical-device behavior.
- Impeccable's launcher failed earlier in this session (`cache_directory_failed`). The bundled detector was unavailable; these are manual browser/source findings, not detector output.

The classic browser scrollbar reduced the usable page width by about 15px on long pages. That difference was excluded from the findings.

## Indicative health score

Scores describe the inspected implementation, not a WCAG certification or performance benchmark.

| Dimension | Score / 4 | Evidence |
| --- | --- | --- |
| Accessibility | 2 | Some labeled regions, accessible charts, and dialog support exist; Create Event tabs lack native keyboard access. |
| Performance | 2 | Directory and account pages render hundreds of records at once, producing very long pages. Runtime performance was not benchmarked. |
| Responsive design | 1 | Mobile navigation disappears and several core controls are clipped or overlap. |
| Theming | 2 | Shared palette/font tokens exist, but component values and colors are repeatedly overridden in page styles. |
| Implementation integrity | 2 | One master shell exists, but duplicated headers, tabs, filters, and dialogs have drifted. |
| **Total** | **9 / 20** | **Poor: resolve responsive failures, then consolidate components.** |

## Page coverage

| Page | Observations |
| --- | --- |
| AdminEvents.aspx | Main width follows the shared shell. Table has a working horizontal scroll container. Filter/control styles differ from other pages. |
| CreateEvent.aspx | Initial form stacks on mobile and the stepper scrolls. Step tabs lack keyboard behavior. Sponsors content-fit height is intentional. |
| EventHistory.aspx | KPIs stack and table scrolls on mobile. Header typography and filter controls use a separate implementation. |
| StudentList.aspx | Department filter extends beyond the mobile viewport. Edit-dialog footer clips Cancel. All 232 profiles render in one table. |
| AccountManagement.aspx | Mobile table columns overlap. All 234 accounts render at once. Manage dialog body scrolls, with its footer visible at the tested height. |
| EventDetails.aspx | Edit Specifications is outside the mobile viewport. Event context header is 24px higher than on sibling event pages. |
| EventPreRegistered.aspx | Roster table scrolls correctly. View is a text link rather than the shared blue action. Context header matches the other event subpages. |
| AttendanceScanner.aspx | Scanner and staging panels exceed available mobile width. Camera remained off during review. |
| EventAttendance.aspx | Roster has a working inline horizontal scroll wrapper; this was not counted as clipping. Filters use a different size from analytics. |
| EventAnalytics.aspx | Cancelled roster tab is clipped on mobile. Chart/roster scroll regions and labeled filter controls are positive examples. |
| TestConnection.aspx | Separate diagnostic design is understandable, but its card exceeds mobile width and is cropped on both sides. |

## P1 — major

### 1. Admin navigation disappears below 992px

**Location:** `Frontend/Assets/css/global.css:1093`; `Frontend/Admin/Admin.Master:154`.

**Category:** Responsive design / navigation.

**Evidence:** The responsive rule translates the fixed sidebar left by 100%. At 768px and 390px, its measured x position is −250px. The topbar contains no menu button, drawer trigger, or replacement navigation. This affects every page using Admin.Master, including Sign Out.

**Impact:** Tablet and phone users lose the normal route between admin modules.

**Recommendation:** Add a keyboard-accessible mobile menu trigger and drawer, preserving the current navigation and sign-out action. Manage expanded state, focus, dismissal, and background interaction. Suggested command: `$impeccable adapt`.

### 2. Account table content overlaps adjacent columns on mobile

**Location:** `Frontend/Assets/css/admin/account-management.css:227`, `:298`; `Frontend/Admin/AccountManagement.aspx:90`.

**Category:** Responsive design / table layout.

**Evidence:** `.account-table` uses `table-layout: fixed` and `width: 100%` without an adequate minimum width. At 390px, the email cell was approximately 130px wide; its text extended across Role and Status. The screenshot shows overlapping email/status text and clipped action buttons.

**Impact:** Admins cannot reliably scan account identity, role, status, and actions together.

**Recommendation:** Give the table a meaningful minimum width inside its existing scroll container, or create an intentional mobile record layout. Wrap long email addresses safely within their column. Suggested command: `$impeccable adapt`.

### 3. Student Directory department filter is cut off

**Location:** `Frontend/Assets/css/admin/student-list.css:23`, `:30`.

**Category:** Responsive design / form layout.

**Evidence:** At 390px, the department select measured 391px wide and began at x=53px. The filter card was only 311px wide. The native select's intrinsic width expands the filter group beyond its container, while the main shell hides horizontal overflow.

**Impact:** The right side and dropdown affordance fall outside the screen.

**Recommendation:** Use `min-width: 0` on the group and controls; stack filters with `width: 100%` at narrow widths. Keep horizontal scrolling inside tables, not form toolbars. Suggested command: `$impeccable adapt`.

### 4. Edit Specifications disappears from Event Details on mobile

**Location:** `Frontend/Assets/css/admin/event-details.css:215` (`.mode-actions`).

**Category:** Responsive design / action layout.

**Evidence:** The outer mode banner wraps, but its nested action group does not. At 390px, Edit Specifications began at x=377px and extended to about x=534px; the shell clipped it. Back and Cancel were visible, while Edit was absent from the screenshot.

**Impact:** A primary management action becomes unavailable through the visible mobile UI.

**Recommendation:** Let the nested group wrap or stack at narrow widths, and size each action to the available container width. Suggested command: `$impeccable adapt`.

### 5. Scanner panels overflow on mobile

**Location:** `Frontend/Assets/css/admin/attendance-scanner.css:163`, `:198`, `:468`, `:663`, `:694`.

**Category:** Responsive design / operational layout.

**Evidence:** The outer grid switches to one column, but its track uses `1fr` and inner rows retain their intrinsic minimum widths. At 390px, the workspace's content extended to about x=422px. Stage Lookup ended beyond x=400px, and Discard extended beyond x=397px. The camera selector/toggle header and staging panel also exceeded the card area.

**Impact:** Operators lose parts of the scanner controls and manual verification actions.

**Recommendation:** Use `minmax(0, 1fr)` with shrinkable grid children, wrap the camera header, stack manual input/actions, and adapt the staging fields and footer to narrow widths. Suggested command: `$impeccable adapt`.

### 6. Analytics clips the Cancelled roster tab

**Location:** `Frontend/Assets/css/admin/event-analytics.css:1433`, `:1442`.

**Category:** Responsive design / tabs.

**Evidence:** At 390px, the tab strip had a 429px scroll width inside a roughly 310px panel. Its overflow was `visible`, while the parent panel used `overflow: hidden`. Cancelled began at x≈317px and ended at x≈462px. Only a fragment was visible; the strip has no horizontal scroll treatment.

**Impact:** Phone users cannot readily see or select the complete set of roster categories.

**Recommendation:** Make the strip horizontally scrollable with nonshrinking tabs, or provide a compact layout that fits all categories. Keep the selected tab visible. Suggested command: `$impeccable adapt`.

## P2 — minor

### 7. Student edit-dialog footer clips Cancel

**Location:** `Frontend/Admin/StudentList.aspx:387`; `Frontend/Assets/css/global.css:1021` (`.modal-footer`).

**Category:** Responsive design / dialog layout.

**Evidence:** On mobile the dialog began at x=24px, but Cancel began at x≈9px. The long Save Demographic Updates button and fixed footer spacing push the Cancel button outside the dialog's clipped bounds.

**Impact:** One action appears cropped and misaligned with the dialog's content.

**Recommendation:** Stack footer actions on mobile or allow a deliberate wrap; make buttons fit the dialog's inner width. Preserve the scrolling body and visible footer. Suggested command: `$impeccable adapt`.

### 8. Large directories have no pagination

**Location:** `Frontend/Admin/StudentList.aspx.cs:73`; `Frontend/Admin/AccountManagement.aspx.cs:117`.

**Category:** Performance / information layout.

**Evidence:** The repeaters bind complete result sets. The current dataset rendered 232 student rows and 234 account rows. Desktop tables were about 17,850px and 15,276px tall respectively; mobile wrapping makes them longer. There is no page navigation or bounded result view.

**Impact:** Long scrolling makes browsing and returning to filters inefficient; rendering costs grow with the dataset.

**Recommendation:** Introduce server-side pagination with result counts and preserved filters. Consider a sticky table/filter header if it helps the workflow. Suggested commands: `$impeccable optimize`, `$impeccable layout`.

### 9. Diagnostic page exceeds mobile width

**Location:** `Frontend/Assets/css/admin/test-connection.css:26`, `:41`, `:198`; `Frontend/Admin/TestConnection.aspx:14`.

**Category:** Responsive design.

**Evidence:** At 390px, the card measured approximately 629px wide, centered from x≈−127px to x≈502px. The server form is a flex child without a shrinkable width constraint, and long diagnostic content contributes to its intrinsic width. Both sides of the card were cropped.

**Impact:** Diagnostic labels and controls are difficult to read on a phone.

**Recommendation:** Constrain the form/container to the available width, allow shrinking, and wrap long diagnostic text. The separate visual identity can remain if this is intentionally a developer tool. Suggested command: `$impeccable adapt`.

### 10. Create Event step tabs lack keyboard access

**Location:** `Frontend/Admin/CreateEvent.aspx:54`, `:671`.

**Category:** Accessibility / interaction consistency.

**Evidence:** Source review: the tabs are clickable `div` elements with `role="tab"`, but no `tabindex` or key handlers. The controller changes selected state without managing keyboard focus. Other parts of the admin use native links/buttons for navigation.

**Impact:** Keyboard users cannot activate the step strip directly, although the form's Next/Back actions provide partial alternatives.

**Standard:** WCAG 2.1.1 Keyboard; ARIA tab interaction conventions. This was source-verified, not exhaustively keyboard-tested live.

**Recommendation:** Use buttons with a managed tab index and arrow/Home/End behavior, preserving step validation. Suggested command: `$impeccable harden`.

## P3 — polish and consistency

### 11. Event context header jumps when switching subpages

**Location:** `Frontend/Assets/css/admin/event-details.css:42`; `Frontend/Assets/css/admin/event-preregistered.css:6`; sibling scanner/attendance/analytics container rules.

**Category:** Implementation integrity / spacing.

**Evidence:** With the same event at desktop width, the context card started around y=127px in Details and y=151px in Pre-Registered, Scanner, Attendance, and Analytics. The latter combine a 24px container gap with the breadcrumb's existing bottom margin.

**Impact:** The shared title and navigation move vertically between tabs, making the pages feel like separate implementations.

**Recommendation:** Give breadcrumb-to-context spacing one owner; extract the shared event context layout and tab styles. Suggested command: `$impeccable layout`.

### 12. Shared filter controls use inconsistent dimensions

**Location:** `Frontend/Assets/css/global.css:690`; `Frontend/Assets/css/admin/event-preregistered.css`; `Frontend/Assets/css/admin/event-attendance.css:266`; `Frontend/Assets/css/admin/event-analytics.css:817`.

**Category:** Implementation integrity / component geometry.

**Evidence:** The preregistration toolbar renders search at 38px, selects at 36px, and Reset Filters at 34px. Analytics uses 40px roster controls. History/Accounts use 38px filters, and the scanner camera select is 32px. Heading scales also vary between 23.2px/800 and 24px/700.

**Impact:** Similar controls have visibly different baselines and density between pages. The 2px differences alone are cosmetic, rather than a task blocker.

**Recommendation:** Define a default control size and an explicitly scoped compact variant; consolidate filter/button/header rules in the shared stylesheet. Use adequate touch targets for mobile rather than copying the smallest desktop size. Suggested command: `$impeccable layout`.

### 13. View actions use different visual treatments

**Location:** `Frontend/Assets/css/global.css:616`, `:639`; `Frontend/Admin/EventPreRegistered.aspx:218`.

**Category:** Implementation integrity / action consistency.

**Evidence:** Matrix, History, and Student Directory use the blue 40px View button. Pre-Registered uses an underlined `View >` link approximately 21px tall.

**Impact:** The same action appears to have a different importance and click area depending on the table.

**Recommendation:** Choose one shared table View treatment and apply it consistently; distinguish different behavior through meaningful labels only when needed. Suggested command: `$impeccable polish`.

### 14. Event subpages lose sidebar context highlighting

**Location:** `Frontend/Admin/Admin.Master:37`, `:58`.

**Category:** Implementation integrity / navigation state.

**Evidence:** Sidebar active-state rules match only individual landing-page filenames. No sidebar item was active on Details, Pre-Registered, Scanner, Attendance, or Analytics, although the event pipeline marks its current subpage.

**Impact:** The persistent navigation stops showing which parent area the admin is working in.

**Recommendation:** Resolve the active parent section for event subroutes and preserve the appropriate Matrix/History context when entering from either list. Suggested command: `$impeccable harden`.

## Recurring causes

- Shared event-context headers and pipeline tabs are implemented independently in five page stylesheets.
- Common buttons, filters, headings, tables, and dialogs are repeatedly redeclared after `global.css`, allowing page-specific spacing and heights to override the shared system.
- Mobile adaptations often change the outer grid but leave nested action rows and intrinsic control widths unchanged.
- `overflow-x: hidden` on the body/main wrapper masks overflow by cropping it. Keep scrolling localized to tables/tabs; fix the overflowing controls themselves.
- The workspace retains 32px horizontal padding on phones, leaving only about 311px for content at the tested viewport. A shared 16–20px mobile gutter would give forms more room, but must accompany the structural fixes.

## What to preserve

- The shared master shell, blue/neutral palette, local fonts, and generally aligned desktop content edges.
- Existing horizontal scroll wrappers on Matrix, History, Directory, preregistration, and attendance tables. Wide tables inside these wrappers are intentional, not page overflow defects.
- Mobile stacking of History/Account KPI cards and the working responsive analytics filter grid.
- Student edit-dialog body scrolling and Account Manage's visible footer at the tested height.
- The content-fit Sponsors step. Different content heights are intentional; forcing every page or tab to the same height would add empty space.
- Accessible analytics labels, chart keyboard support, and the event cancellation dialog's focus/Escape handling as patterns to extend.

## Recommended sequence

1. **P1 — `$impeccable adapt`:** Restore mobile navigation; fix Accounts, Directory, Details, Scanner, and Analytics clipping.
2. **P2 — `$impeccable adapt`:** Repair dialog footer wrapping and diagnostic page sizing.
3. **P2/P3 — `$impeccable harden`:** Add keyboard step navigation and parent-section active state.
4. **P2 — `$impeccable optimize`:** Add bounded/paginated directory and account results.
5. **P3 — `$impeccable layout`:** Consolidate headers, spacing, toolbar controls, and event pipeline geometry.
6. **P3 — `$impeccable polish`:** Align the final View actions, typography, and border treatment after structural fixes.

You can ask to run these individually or together. Re-run `$impeccable audit` after fixes to verify the result.
