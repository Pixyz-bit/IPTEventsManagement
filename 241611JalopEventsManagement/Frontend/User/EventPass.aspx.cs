using System;
using System.Web.UI;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.User
{
    public partial class EventPass : StudentPage
    {
        private readonly RegistrationRepository _regRepo = new RegistrationRepository();
        private readonly EventRepository _eventRepo = new EventRepository();

        public bool IsPassValid { get; private set; }
        public string PassWarning { get; private set; } = string.Empty;
        public string QrPayload { get; set; } = "TCK-0000-00000";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDigitalPass();
            }
        }

        private void LoadDigitalPass()
        {
            int regId = 0;
            if (int.TryParse(Request.QueryString["regId"], out int parsedRegId) && parsedRegId > 0)
            {
                regId = parsedRegId;
            }

            string ticketRef = Request.QueryString["ticketRef"]?.Trim();

            EventRegistrationModel reg = null;

            if (regId > 0)
            {
                reg = _regRepo.GetRegistrationById(regId);
            }
            else if (!string.IsNullOrWhiteSpace(ticketRef))
            {
                reg = _regRepo.GetRegistrationForScan(0, ticketRef);
            }

            // Fallback: If student logged in, check for their latest registration
            if (reg == null && !string.IsNullOrWhiteSpace(SessionHelper.CurrentStudentId))
            {
                var studentRegs = _regRepo.GetRegistrationsByStudent(SessionHelper.CurrentStudentId);
                if (studentRegs != null && studentRegs.Count > 0)
                {
                    reg = studentRegs[0];
                }
            }

            // Missing records must never generate a fabricated admission pass.
            if (reg == null || !string.Equals(reg.StudentId, SessionHelper.CurrentStudentId, StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Frontend/User/Dashboard.aspx", true);
                return;
            }
            IsPassValid = reg.IsPassValid;
            if (reg.IsEventCancelled)
                PassWarning = "Event cancelled. This pass is invalid. Reason: " + (reg.EventCancellationReason ?? "No reason recorded.");
            else if (!IsPassValid)
                PassWarning = reg.IsCheckedIn ? "This pass has already been checked in." : "This pass is inactive and cannot be used for admission.";

            // Bind QR Code Payload (Ticket reference format matches AttendanceScanner.aspx)
            QrPayload = reg.TicketReference;

            // Show or hide success banner
            bool isNewRegistration = string.Equals(Request.QueryString["success"], "1", StringComparison.OrdinalIgnoreCase);
            pnlSuccessBanner.Visible = isNewRegistration && IsPassValid;

            // Populate Boarding Pass UI
            litPassEventTitle.Text = Server.HtmlEncode(reg.EventTitle ?? "Campus Event");
            litPassStudentName.Text = Server.HtmlEncode(reg.StudentFullName);
            litPassStudentId.Text = Server.HtmlEncode(reg.StudentId);
            litPassCourse.Text = Server.HtmlEncode(reg.StudentProgram ?? "BS Information Technology");
            litPassYearSection.Text = $"Yr {reg.CurrentYearLvl} - {Server.HtmlEncode(reg.CurrentSection ?? "SBIT-3A")}";

            if (reg.EventStart.HasValue)
            {
                litPassEventDate.Text = reg.EventStart.Value.ToString("MMM dd, yyyy");
                litPassEventTime.Text = reg.EventEnd.HasValue
                    ? $"{reg.EventStart:hh:mm tt} - {reg.EventEnd:hh:mm tt}"
                    : $"{reg.EventStart:hh:mm tt}";
            }
            else
            {
                litPassEventDate.Text = "Date TBD";
                litPassEventTime.Text = "Schedule TBD";
            }

            litPassVenue.Text = Server.HtmlEncode(reg.VenueLocation ?? "Campus Grounds");
            litPassTicketRef.Text = Server.HtmlEncode(reg.TicketReference);

            // Generate security hash token
            string token = Request.QueryString["token"];
            if (string.IsNullOrWhiteSpace(token))
            {
                token = $"SEC-{Math.Abs((reg.StudentId + reg.EventId + reg.TicketReference).GetHashCode()):X8}";
            }
            litPassSecurityToken.Text = Server.HtmlEncode(token);

            // Dynamic Pass Status Pill
            if (reg.IsEventCancelled)
            {
                litPassStatusPill.Text = "EVENT CANCELLED — PASS INVALID";
            }
            else if (string.Equals(reg.Status, "Present", StringComparison.OrdinalIgnoreCase))
            {
                litPassStatusPill.Text = "● PRESENT & CHECKED IN";
            }
            else if (string.Equals(reg.Status, "Cancelled", StringComparison.OrdinalIgnoreCase))
            {
                litPassStatusPill.Text = "✕ PASS REVOKED";
            }
            else
            {
                litPassStatusPill.Text = "CONFIRMED PASS";
            }
        }
    }
}
