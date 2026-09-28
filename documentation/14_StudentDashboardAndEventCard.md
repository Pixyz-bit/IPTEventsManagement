# Student Dashboard & Login Portal: Neo-Brutalism / Editorial Campus Web Redesign

- **Document ID:** `14_StudentDashboardAndEventCard.md`
- **Location:** 
  - `Frontend/Login/Login.aspx`, `Frontend/Login/Login.aspx.cs`, `Frontend/Login/Login.aspx.designer.cs`
  - `Frontend/User/Dashboard.aspx`, `Frontend/User/Dashboard.aspx.cs`, `Frontend/User/Dashboard.aspx.designer.cs`
- **Related Models:** [EventModel.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/EventModel.cs), [SponsorModel.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/SponsorModel.cs), [EventRegistrationModel.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/EventRegistrationModel.cs), [StudentProfile.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Models/StudentProfile.cs)
- **Related Repositories:** [EventRepository.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/EventRepository.cs), [SponsorRepository.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/SponsorRepository.cs), [RegistrationRepository.cs](file:///c:/Martin%20Archive/Programming/ASP%20NET/241611JalopEventsManagement/241611JalopEventsManagement/Backend/Repository/RegistrationRepository.cs)

---

## 1. Neo-Brutalism Design System & Vocabulary

Both the **Portal Login** and **User Dashboard** were refactored into a **Neo-Brutalism / Editorial Campus Web** aesthetic tailored specifically for student-facing event discovery, campus org fairs, and hackathons.

### Design Tokens & Keywords

| Token / Element | Implementation | Style Specification |
| :--- | :--- | :--- |
| **Card Shells** | Raw geometric cards | `border: 2.5px solid #000000; box-shadow: 6px 6px 0px #000000; border-radius: 16px to 20px;` |
| **Hard Offset Shadows** | Offset drop shadows | `4px 4px 0px #000` to `8px 8px 0px #000` without blur filter |
| **Borders** | Solid high-contrast outlines | `1.5px` to `2.5px solid #000000` |
| **Tactile Buttons** | Depressing button click interaction | Depress directly into drop shadow on `:active` (`transform: translate(3px, 3px); box-shadow: 0px 0px 0px #000;`) |
| **Category Pill Badges** | Contrasting neon fills | Lime (`#A6F4C5`), Warm Yellow (`#FFDE59`), Lavender (`#E9D5FF`), Coral (`#FECDD3`), Cyan (`#BAE6FD`) |
| **Monospace Data Tags** | Technical data labels | `JetBrains Mono` for capacity ratios (`[ 42/50 SEATS ]`), student IDs, dates (`OCT 24 // 09:00 AM`) |
| **Background Canvas** | Retro architectural dot grid | `radial-gradient(rgba(0, 0, 0, 0.14) 1.25px, transparent 1.25px)` on `#FAF7EE` warm ivory paper |

---

## 2. Page Architectures & Features

### A. Authentication Gateway (`Frontend/Login/Login.aspx`)
1. **Editorial Brand Seal**: Circular QCU seal with 2.5px black outline, 4px hard drop shadow, and monospace status ticker `[ QCU CAMPUS PORTAL v2.6 // SECURE ]`.
2. **Neo-Brutalist Auth Card**: Window header bar in warm yellow with macOS-style window dots, solid 2.5px border, and 6px drop shadow.
3. **High-Contrast Input Fields**: 2px solid black borders with tactile `:focus` lift and offset shadows.
4. **Tactile Submit Button**: Heavy black outlined button with active click depress effect into shadow.
5. **Floating Decorative Stickers**: SVG 4-point star stickers in electric lavender and neon yellow with solid black borders.

### B. Student Dashboard (`Frontend/User/Dashboard.aspx`)
1. **Interactive Hero Gallery Section**:
   - **Spotlight Exhibition Stage**: Promotes current flagship campus events with vibrant Neo-Brutal color blocking, live countdown schedule badges, seat availability meters, and instant `INSPECT & RESERVE →` action button.
   - **Gallery Thumbnail Rail**: 4 interactive slides (`#Hackathon`, `#Workshop`, `#Seminar`, `#SportsFest`) with `PREV` and `NEXT` tactile controls and thumbnail card selection.
   - **Student Cohort Matrix Bar**: Editorial monospace badge chips displaying Branch, Department, Program, and Year Standing.
2. **Tab-Like Toggle (All Open Events vs. My Registered Events)**:
   - High-contrast segmented switch (`All Open Events [ 4 OPEN ]` vs. `My Registered Events [ MY PASSES ]`).
   - Tactile active tab depression with zero page-reload latency.
3. **Contrasting Neon Category Filter Pills**:
   - Instant client-side filtering for `#All Events`, `#Seminar`, `#Hackathon`, `#Workshop`, `#SportsFest`, and `#OrgFair`.
4. **Sharp Geometric Event Cards**:
   - Alternating vibrant header banners with category tags, monospace capacity meters, and **Registration Lifecycle Pills**:
     - **`SOON`**: Active when `DateTime.Now < RegStart` (warm amber/yellow fill `#FEF08A` with `#854D0E` text, solid black outline). Footer displays `⚡ OPENS [DATE]` (e.g. `⚡ OPENS OCT 15`). Modal registration button is disabled with text `"Registration Opens on [Date/Time]"`.
     - **`OPEN`**: Active when `RegStart <= DateTime.Now <= RegEnd` and capacity is available (green capsule with pulsing dot). Footer displays `⚡ [REMAINING] SPOTS LEFT`. Modal registration button is enabled with text `"Register For Event"`.
     - **`CLOSED`**: Active when `DateTime.Now > RegEnd` or event is not Upcoming (dark slate pill). Footer displays `REGISTRATION CLOSED`. Modal registration button is disabled with text `"Registration Closed"`.
   - Passive Neo-Brutalist sponsor chips (AWS, Microsoft, Google, LESIT).
   - Tactile `View Details →` button launching the registration modal.
5. **My Registered Events Electronic Passes**:
   - Bold Neo-Brutalist table with black header bar, monospace uppercase tags, attendance status badge (`● REGISTERED (NOSHOW)`, `● PRESENT`, `✕ CANCELLED`), and tactile `Cancel Pass` action.
6. **Registration & Details Modal**:
   - Geometric modal with 2.5px black border, 8px drop shadow, comprehensive itinerary grid, and responsive action button reflecting the exact registration timeline state (`SOON` / `OPEN` / `CLOSED` / `FULLY BOOKED`).

---

## 3. Verification & Build Status

- **Compilation Status:** `0 Warning(s), 0 Error(s)` via Visual Studio 2022 MSBuild.
- **Runtime Endpoints:**
  - Login: `http://localhost:51717/Frontend/Login/Login.aspx` (HTTP 200 OK)
  - Student Dashboard: `http://localhost:51717/Frontend/User/Dashboard.aspx` (HTTP 200 OK)
- **Browser Automation Verification:** Verified with headless subagent testing hero gallery slide navigation, category filter pill toggling, tab-like view switching, and event registration modal popup.
