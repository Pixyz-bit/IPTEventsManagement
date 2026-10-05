# Student Event Registration Wizard & Digital Attendance Pass

Cancelled events are excluded from registration. Existing passes show **EVENT CANCELLED**, display the recorded reason, generate no QR, and hide the download action. Missing registrations redirect to the dashboard instead of generating a mock admission pass. Scanner commits independently reject cancelled events. See [the cancellation flow](11_AdminDashboard.md).

- **Document ID:** `17_StudentEventRegistrationAndPass.md`
- **Location:** 
  - `Frontend/User/EventRegistration.aspx`, `.cs`, `.designer.cs`
  - `Frontend/User/EventPass.aspx`, `.cs`, `.designer.cs`
  - `Frontend/User/Dashboard.aspx`, `.cs`, `.designer.cs`
- **Related Models:** [EventModel.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/EventModel.cs), [EventRegistrationModel.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/EventRegistrationModel.cs), [StudentProfile.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/StudentProfile.cs)
- **Related Repositories:** [EventRepository.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/EventRepository.cs), [RegistrationRepository.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/RegistrationRepository.cs), [StudentRepository.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/StudentRepository.cs)
- **Gate Interoperability:** [AttendanceScanner.aspx](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/AttendanceScanner.aspx)
- **Primary Color Tokens:** `#2563eb` (Brand Primary), `#090D16` (Deep Canvas), `#FFFFFF` (Card Surfaces & Boarding Pass Body)

---

## 1. Page 2: Event Registration Wizard (`EventRegistration.aspx`)

### Purpose & Architecture
A structured, multi-step tabbed workflow that validates student identity and captures dynamic term-specific academic details before writing the registration record to the database.

```
[ User Dashboard ]
       │
       ▼ (Clicks "Register For Event")
[ EventRegistration.aspx?eventId={id} ]
       │
       ├── Tab 1: Student Profile Review (View-Only / Anti-Spoofing)
       │      │
       │      ▼ (Clicks "Next: Academic Information ->")
       │
       └── Tab 2: Academic Enrollment & Confirmation (Active Inputs)
              │
              ▼ (Clicks "Confirm & Complete Registration")
         [ SQL Transaction: Capacity Check + Double-Booking Check + Insert ]
              │
              ▼ (Redirects with Ticket Token)
[ EventPass.aspx?regId={newId}&ticketRef={code} ]
```

### Tab 1: Student Profile Review (View-Only)
- **Objective:** Verifies that the ticket will be issued to the authenticated student account without allowing identity spoofing.
- **UI Components (Read-Only Fields):**
  - **Student ID Number:** University standardized format (`24-1611`).
  - **Full Name:** First Name, Middle Name, Last Name.
  - **Institutional Email Address:** Official university domain account.
  - **Academic Department / College:** Division (e.g., `College of Computer Studies`).
  - **Degree Program / Course:** Enrolled curriculum (e.g., `BS Information Technology`).
  - **Campus / Branch:** Assigned branch (e.g., `San Bartolome (Main)`).
- **Informational Notice:**
  > *"These profile details are synchronized directly from your official university record. If any information is incorrect, please contact the Registrar’s Office."*
- **Navigation Action:**
  `[ Next: Academic Information -> ]`: Seamlessly activates Tab 2 without round-trip latency.

### Tab 2: Academic Enrollment & Confirmation (Active Inputs)
- **Objective:** Collects current, changeable term-specific details that vary per semester, followed by user confirmation.
- **UI Components (Interactive Inputs):**
  - **Current Year Level (Dropdown):** `1st Year`, `2nd Year`, `3rd Year`, `4th Year`, `Irregular`. Pre-selected from the student's profile.
  - **Class Section (Text Input):** Freeform or validated class section identifier (e.g., `SBIT-3C`).
  - **Terms & Commitment Checkbox:**
    `[X] I confirm that I will attend this event and agree to follow university event guidelines.`
- **Action Controls:**
  - `[ <- Back to Profile ]`: Re-activates Tab 1.
  - `[ Confirm & Complete Registration ]`: Primary submission button triggering server-side validation.

### Backend Processing & Transaction Rules
1. **Atomic Transaction Scope:** Database insert executes inside `BEGIN TRANSACTION` with `UPDLOCK, HOLDLOCK` on `dbo.EventsTable`.
2. **Capacity Lock:** Evaluates `CurrentRegistrations < MaxCapacity`. Returns `-1` if venue is full.
3. **Registration Window Validation:** Evaluates `GETDATE() >= RegStart AND GETDATE() <= RegEnd` and `Status = 'Upcoming'`.
4. **Anti-Duplicate Rule:** Checks `IsStudentRegistered(EventId, StudentId)` before committing. If active reservation exists, redirects to `EventPass.aspx`.
5. **State Initialization:** Writes registration record with `Status = 'NoShow'` and `IsCheckedIn = 0`.
6. **Token Generation:** Produces cryptographically formatted Ticket Reference `TCK-{EventId:D4}-{RegistrationId:D5}` and unique GUID token, redirecting directly to `EventPass.aspx`.

---

## 2. Page 3: Digital Ticket & QR Attendance Pass (`EventPass.aspx`)

### Purpose
The post-registration confirmation destination and persistent digital boarding pass that the student presents at the venue entrance scanner.

### Core UI & Data Components
1. **Registration Success Banner:**
   - Vibrant emerald confirmation banner:
     > *"You're Registered! Present this pass at the gate scanner."*
2. **Digital Boarding Pass Card:**
   - **Visual Theme:** Clean editorial boarding pass layout with header crest bar, dashed perforation divider line, and left/right notch cutouts.
   - **Event Metadata:** Event Title, Event Date & Start/End Times, Venue / Hall location.
   - **Attendee Credentials:** Student Full Name, Student ID (`24-1611`), Academic Program, Year Level, and Class Section.
   - **Ticket Reference Code:** Monospace uppercase code (`TCK-0003-00007`).
   - **Dynamic Status Pill:**
     - `CONFIRMED PASS` (Initial state prior to event check-in)
     - `● PRESENT & CHECKED IN` (After gate scanner confirmation)
     - `✕ PASS REVOKED` (If pass was cancelled)
3. **Personalized High-Contrast QR Code:**
   - Centered scannable barcode rendered on `<canvas>` using embedded JavaScript with zero third-party internet dependencies.
   - Encodes authenticated Ticket Reference payload (`TCK-{EventId:D4}-{RegistrationId:D5}`) and security hash token.
4. **Utility Actions:**
   - `[ Download Pass (PNG) ]`: Renders and downloads a high-fidelity PNG image of the `boarding-pass-card`, preserving its exact canonical width and length dimensions (with transparent rounded corners and ticket notch cutouts), directly incorporating the scanned QR code canvas.
   - `[ Return to My Events Dashboard ]`: Links directly back to `Frontend/User/Dashboard.aspx`.

### Security & Gate Scanner Interoperability
- When scanned at the gate terminal by [`AttendanceScanner.aspx`](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Frontend/Admin/AttendanceScanner.aspx):
  1. The optical viewfinder camera decodes the QR code payload.
  2. The AJAX endpoint `AttendanceScanner.aspx/LookupAttendee` queries `RegistrationRepository.GetRegistrationForScan(eventId, query)`.
  3. The repository extracts the numeric registration ID from the `TCK-XXXX-XXXXX` prefix.
  4. The attendee's full profile (Student ID, Name, Photo, Department, Program, Section) is staged in the verification panel for physical ID card inspection.
  5. The gate operator clicks `[ Confirm & Check-In ]`, atomically committing `Status = 'Present'` and recording the microsecond timestamp.
