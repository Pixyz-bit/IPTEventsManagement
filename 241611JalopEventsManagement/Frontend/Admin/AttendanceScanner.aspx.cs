using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class AttendanceScanner : Page
    {
        private readonly EventRepository _eventRepo = new EventRepository();
        private readonly RegistrationRepository _registrationRepo = new RegistrationRepository();

        public int CurrentEventId
        {
            get
            {
                if (ViewState["CurrentEventId"] != null)
                {
                    return (int)ViewState["CurrentEventId"];
                }
                return 0;
            }
            set
            {
                ViewState["CurrentEventId"] = value;
            }
        }

        public string CurrentAdminEmail
        {
            get
            {
                return SessionHelper.CurrentEmail ?? "admin@gmail.com";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security verification: administrator session gate
            if (!SessionHelper.IsAuthenticated || !SessionHelper.IsAdmin)
            {
                if (!SessionHelper.IsAuthenticated)
                {
                    Response.Redirect("~/Frontend/Login/Login.aspx", true);
                    return;
                }
            }

            if (!IsPostBack)
            {
                InitializeEventContext();
            }
        }

        private void InitializeEventContext()
        {
            // 1. Populate Events Selector Dropdown
            var allEvents = _eventRepo.GetAllEvents();
            ddlEvents.Items.Clear();

            if (allEvents != null && allEvents.Count > 0)
            {
                foreach (var evt in allEvents)
                {
                    string dateText = evt.EventStart != DateTime.MinValue ? evt.EventStart.ToString("MM/dd/yyyy") : "TBD";
                    string itemText = $"{evt.Title} ({dateText})";
                    ddlEvents.Items.Add(new ListItem(itemText, evt.EventId.ToString()));
                }
            }

            // 2. Resolve target event ID from QueryString or fallback
            int eventId = 0;
            if (Request.QueryString["eventId"] != null && int.TryParse(Request.QueryString["eventId"], out int parsedId))
            {
                eventId = parsedId;
            }
            else if (ddlEvents.Items.Count > 0)
            {
                eventId = int.Parse(ddlEvents.Items[0].Value);
            }

            CurrentEventId = eventId;

            if (ddlEvents.Items.FindByValue(eventId.ToString()) != null)
            {
                ddlEvents.SelectedValue = eventId.ToString();
            }

            LoadTerminalData();
        }

        protected void ddlEvents_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ddlEvents.SelectedValue, out int selectedId))
            {
                CurrentEventId = selectedId;
                Response.Redirect($"~/Frontend/Admin/AttendanceScanner.aspx?eventId={selectedId}", true);
            }
        }

        private void LoadTerminalData()
        {
            var evt = _eventRepo.GetEventById(CurrentEventId);

            if (evt != null)
            {
                litEventTitle.Text = Server.HtmlEncode(evt.Title);
                litEventDate.Text = evt.EventStart != DateTime.MinValue ? evt.EventStart.ToString("MM/dd/yyyy") : "MM/dd/yyyy";
                litEventVenue.Text = Server.HtmlEncode(evt.VenueLocation ?? "Campus Grounds");
            }
            else
            {
                litEventTitle.Text = "Demonstration Event Gate Terminal";
                litEventDate.Text = DateTime.Now.ToString("MM/dd/yyyy");
                litEventVenue.Text = "Main Academic Amphitheater";
            }

            litCurrentAdminEmail.Text = Server.HtmlEncode(CurrentAdminEmail);

            // Fetch registrations for headcounts
            var allRegistrations = _registrationRepo.GetRegistrationsByEvent(CurrentEventId);
            var checkedInList = _registrationRepo.GetCheckedInAttendees(CurrentEventId);

            int checkedInCount = checkedInList.Count;
            int totalActive = allRegistrations.Count(r => !string.Equals(r.Status, "Cancelled", StringComparison.OrdinalIgnoreCase));
            int expectedCount = Math.Max(0, totalActive - checkedInCount);

            litCheckedInCount.Text = checkedInCount.ToString();
            litExpectedCount.Text = expectedCount.ToString();

            double turnoutRate = totalActive > 0 ? ((double)checkedInCount / totalActive) * 100.0 : 0.0;
            litTurnoutRate.Text = $"{turnoutRate:F1}%";

            // Note: Live Roster Table display is rendered on EventAttendance.aspx
        }

        #region AJAX WebMethods for Optical QR Scanner Terminal

        /// <summary>
        /// Pre-Commit State Validation & Profile Staging.
        /// Evaluates preliminary states (Valid Ticket, Duplicate Warning, Wrong Event, Cancelled)
        /// WITHOUT committing to the database.
        /// </summary>
        [WebMethod]
        public static ScanLookupResult LookupAttendee(int eventId, string query)
        {
            var repo = new RegistrationRepository();
            var reg = repo.GetRegistrationForScan(eventId, query);

            if (reg == null)
            {
                return new ScanLookupResult
                {
                    Success = false,
                    State = "NotFound",
                    Message = "No matching attendee registration found for the provided code or ID."
                };
            }

            var result = new ScanLookupResult
            {
                Success = true,
                EventRegistrationId = reg.EventRegistrationId,
                EventId = reg.EventId,
                EventTitle = reg.EventTitle,
                TicketReference = reg.TicketReference,
                StudentId = reg.StudentId,
                FullName = reg.StudentFullName,
                Email = reg.StudentEmail,
                Branch = reg.StudentCampusBranch,
                Department = reg.StudentDepartment,
                Course = reg.StudentProgram,
                YearLevel = reg.CurrentYearLvl,
                Section = reg.CurrentSection,
                CheckInTimestamp = reg.CheckInTimestamp.HasValue ? reg.CheckInTimestamp.Value.ToString("MM/dd/yyyy hh:mm:ss tt") : string.Empty
            };

            // State Validation Evaluation
            if (reg.EventId != eventId)
            {
                result.State = "WrongEventWarning";
                result.Message = $"Warning: This ticket pass is for Event #{reg.EventId} '{reg.EventTitle}', not the current active gate.";
            }
            else if (string.Equals(reg.Status, "Present", StringComparison.OrdinalIgnoreCase))
            {
                result.State = "DuplicateWarning";
                string timeStr = reg.CheckInTimestamp.HasValue ? reg.CheckInTimestamp.Value.ToString("MM/dd/yyyy hh:mm:ss tt") : "earlier today";
                result.Message = $"Duplicate Check-In Warning: This pass was already checked in on {timeStr}.";
            }
            else if (string.Equals(reg.Status, "Cancelled", StringComparison.OrdinalIgnoreCase))
            {
                result.State = "CancelledWarning";
                result.Message = "Warning: This student's registration pass was revoked / cancelled.";
            }
            else
            {
                result.State = "ValidPending";
                result.Message = "Valid Ticket: Attendee profile staged. Please verify student University ID card before confirming check-in.";
            }

            return result;
        }

        /// <summary>
        /// Final Database Commit.
        /// Officially commits attendance (Status = 'Present', CheckInTimestamp = GETDATE())
        /// ONLY after explicit administrative confirmation.
        /// </summary>
        [WebMethod]
        public static CheckInResult CommitCheckIn(int eventRegistrationId, string verificationMethod)
        {
            var repo = new RegistrationRepository();
            bool success = repo.ConfirmCheckIn(eventRegistrationId, out string errorMsg);

            if (!success)
            {
                return new CheckInResult
                {
                    Success = false,
                    Message = errorMsg
                };
            }

            var reg = repo.GetRegistrationById(eventRegistrationId);
            DateTime checkInTime = reg?.CheckInTimestamp ?? DateTime.Now;

            int checkedInCount = 0;
            if (reg != null)
            {
                checkedInCount = repo.GetCheckedInAttendees(reg.EventId).Count;
            }

            string adminUser = SessionHelper.CurrentEmail ?? "admin@gmail.com";

            return new CheckInResult
            {
                Success = true,
                Message = "Attendee successfully checked in.",
                CheckInTimestamp = checkInTime.ToString("MM/dd/yyyy hh:mm:ss tt"),
                EventRegistrationId = eventRegistrationId,
                TicketReference = reg?.TicketReference ?? $"TCK-{eventRegistrationId:D5}",
                StudentId = reg?.StudentId,
                FullName = reg?.StudentFullName,
                CourseAndYear = $"{reg?.StudentProgram} (Yr {reg?.CurrentYearLvl} - {reg?.CurrentSection})",
                VerificationMethod = string.IsNullOrWhiteSpace(verificationMethod) ? "Gate Scan" : verificationMethod,
                AdminUser = adminUser,
                UpdatedCheckedInCount = checkedInCount
            };
        }

        #endregion
    }

    #region Data Contracts for AJAX Scanner Operations

    public class ScanLookupResult
    {
        public bool Success { get; set; }
        public string State { get; set; } // "ValidPending", "DuplicateWarning", "WrongEventWarning", "CancelledWarning", "NotFound"
        public string Message { get; set; }
        public int EventRegistrationId { get; set; }
        public int EventId { get; set; }
        public string EventTitle { get; set; }
        public string TicketReference { get; set; }
        public string StudentId { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Branch { get; set; }
        public string Department { get; set; }
        public string Course { get; set; }
        public int YearLevel { get; set; }
        public string Section { get; set; }
        public string CheckInTimestamp { get; set; }
    }

    public class CheckInResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string CheckInTimestamp { get; set; }
        public int EventRegistrationId { get; set; }
        public string TicketReference { get; set; }
        public string StudentId { get; set; }
        public string FullName { get; set; }
        public string CourseAndYear { get; set; }
        public string VerificationMethod { get; set; }
        public string AdminUser { get; set; }
        public int UpdatedCheckedInCount { get; set; }
    }

    #endregion
}
