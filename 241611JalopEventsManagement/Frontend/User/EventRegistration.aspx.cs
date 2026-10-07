using System;
using System.Collections.Generic;
using System.Web.UI;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.User
{
    public partial class EventRegistration : StudentPage
    {
        private readonly EventRepository _eventRepo = new EventRepository();
        private readonly StudentRepository _studentRepo = new StudentRepository();
        private readonly RegistrationRepository _regRepo = new RegistrationRepository();

        public int CurrentEventId
        {
            get => ViewState["CurrentEventId"] != null ? (int)ViewState["CurrentEventId"] : 0;
            set => ViewState["CurrentEventId"] = value;
        }

        public int CurrentStep
        {
            get => ViewState["CurrentStep"] != null ? (int)ViewState["CurrentStep"] : 1;
            set
            {
                ViewState["CurrentStep"] = value;
                if (hfCurrentStep != null)
                {
                    hfCurrentStep.Value = value.ToString();
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                InitializeRegistrationWizard();
            }
            else
            {
                EventModel ev;
                StudentProfile student;
                if (!LoadRegistrationContext(out ev, out student)) return;
                // Sync current step from client hidden field if posted back
                if (int.TryParse(hfCurrentStep.Value, out int step) && step >= 1 && step <= 3)
                {
                    CurrentStep = step;
                }
            }
        }

        private void InitializeRegistrationWizard()
        {
            EventModel ev;
            StudentProfile student;
            if (!LoadRegistrationContext(out ev, out student)) return;
            CurrentStep = 1;
            hfCurrentStep.Value = "1";

            if (litContextEventTitle != null) litContextEventTitle.Text = Server.HtmlEncode(ev.Title);
            if (litContextEventDate != null) litContextEventDate.Text = ev.EventStart != DateTime.MinValue ? ev.EventStart.ToString("MM/dd/yyyy") : "TBD";
            if (litContextVenue != null) litContextVenue.Text = Server.HtmlEncode(ev.VenueLocation ?? "Campus Grounds");
            if (litContextSchedule != null) litContextSchedule.Text = $"{ev.EventStart:hh:mm tt} - {ev.EventEnd:hh:mm tt}";

            int remaining = Math.Max(0, ev.MaxCapacity - ev.CurrentRegistrations);
            if (remaining <= 0)
            {
                litCapacityBadge.Text = "<span class='context-tag' style='background:#fee2e2; color:#b91c1c; border-color:#fca5a5;'>FULLY BOOKED</span>";
            }
            else
            {
                litCapacityBadge.Text = $"<span class='context-tag' style='background:#ecfdf5; color:#047857; border-color:#a7f3d0;'>{remaining} SPOTS LEFT</span>";
            }

            // Populate Step 1: Core Event Specifications
            litStep1Title.Text = Server.HtmlEncode(ev.Title);
            litStep1Description.Text = !string.IsNullOrWhiteSpace(ev.Description)
                ? Server.HtmlEncode(ev.Description)
                : "No extended description provided for this campus event.";
            litStep1Venue.Text = Server.HtmlEncode(ev.VenueLocation ?? "Central Campus Auditorium");
            litStep1Date.Text = ev.EventStart != DateTime.MinValue ? ev.EventStart.ToString("MM/dd/yyyy") : "TBD";
            litStep1Schedule.Text = $"{ev.EventStart:hh:mm tt} - {ev.EventEnd:hh:mm tt}";
            litStep1Capacity.Text = $"{ev.MaxCapacity:N0} Seats";
            litStep1Spots.Text = remaining > 0 ? $"{remaining:N0} Seats Available" : "Fully Booked (0 Seats)";

            if (ev.IsOpenToAll)
            {
                litStep1Audience.Text = "Open to All Programs & Year Levels";
            }
            else
            {
                var audienceParts = new List<string>();
                if (!string.IsNullOrWhiteSpace(ev.TargetBranch)) audienceParts.Add(ev.TargetBranch);
                if (!string.IsNullOrWhiteSpace(ev.TargetDepartment)) audienceParts.Add(ev.TargetDepartment);
                if (!string.IsNullOrWhiteSpace(ev.TargetProgram)) audienceParts.Add(ev.TargetProgram);
                if (ev.TargetYearLevel.HasValue) audienceParts.Add($"Year {ev.TargetYearLevel.Value}");
                litStep1Audience.Text = string.Join(" • ", audienceParts);
            }

            if (!string.IsNullOrWhiteSpace(ev.EventPhotoPath))
            {
                pnlEventPhoto.Visible = true;
                imgEventPhoto.ImageUrl = ResolveUrl(ev.EventPhotoPath);
            }
            else
            {
                pnlEventPhoto.Visible = false;
            }

            // Populate Step 2: Student Profile (View-Only)
            litProfileStudentId.Text = Server.HtmlEncode(student.StudentId);
            litProfileFullName.Text = Server.HtmlEncode(student.FullName);
            litProfileEmail.Text = Server.HtmlEncode(student.Email);
            litProfileCampus.Text = Server.HtmlEncode(student.CampusBranch ?? "San Bartolome (Main)");
            litProfileDepartment.Text = Server.HtmlEncode(student.Department ?? "College of Computer Studies");
            litProfileProgram.Text = Server.HtmlEncode(student.Program ?? "BS Information Technology");

            // Populate Step 3 Defaults
            txtSection.Text = student.Section ?? "";
            if (ev.TargetYearLevel.HasValue)
            {
                for (int i = ddlYearLevel.Items.Count - 1; i >= 0; i--)
                {
                    if (ddlYearLevel.Items[i].Value != "" && ddlYearLevel.Items[i].Value != ev.TargetYearLevel.Value.ToString())
                        ddlYearLevel.Items.RemoveAt(i);
                }
                pnlYearRequirement.Visible = true;
                litYearRequirement.Text = Server.HtmlEncode($"This event is restricted to Year {ev.TargetYearLevel.Value}. Select this year only if it is your current standing.");
            }
        }

        private bool LoadRegistrationContext(out EventModel ev, out StudentProfile student, int? yearLevel = null)
        {
            ev = null;
            student = _studentRepo.GetStudentByUserId(SessionHelper.CurrentUserId)
                ?? _studentRepo.GetStudentById(SessionHelper.CurrentStudentId);
            if (student == null)
            {
                ShowUnavailable("Your student profile is unavailable. Update your profile before registering.");
                return false;
            }

            litNavStudentName.Text = Server.HtmlEncode(student.FullName);
            litNavStudentId.Text = Server.HtmlEncode(student.StudentId);
            litNavAvatarInitials.Text = !string.IsNullOrEmpty(student.FirstName) && !string.IsNullOrEmpty(student.LastName)
                ? Server.HtmlEncode($"{student.FirstName[0]}{student.LastName[0]}".ToUpperInvariant()) : "ST";

            if (!int.TryParse(Request.QueryString["eventId"], out int eventId) || eventId <= 0)
            {
                ShowUnavailable("This event could not be found. Choose an event from the dashboard.");
                return false;
            }
            CurrentEventId = eventId;
            ev = _eventRepo.GetEventById(eventId);

            // Existing pass holders must still reach their pass when booking is closed or full.
            var existing = _regRepo.GetRegistrationsByStudent(student.StudentId)
                .Find(r => r.EventId == eventId && !string.Equals(r.Status, "Cancelled", StringComparison.OrdinalIgnoreCase));
            if (existing != null)
            {
                Response.Redirect($"~/Frontend/User/EventPass.aspx?regId={existing.EventRegistrationId}", true);
                return false;
            }

            string reason = _eventRepo.GetRegistrationUnavailableReason(eventId, student.StudentId, yearLevel);
            if (!string.IsNullOrEmpty(reason))
            {
                ShowUnavailable(reason, ev);
                return false;
            }
            pnlUnavailable.Visible = false;
            pnlRegistration.Visible = true;
            return true;
        }

        private void ShowUnavailable(string reason, EventModel ev = null)
        {
            pnlRegistration.Visible = false;
            pnlUnavailable.Visible = true;
            pnlError.Visible = false;
            litCapacityBadge.Text = "";
            phUnavailableEvent.Visible = ev != null;
            litUnavailableEvent.Text = Server.HtmlEncode(ev?.Title ?? "");
            litUnavailableReason.Text = Server.HtmlEncode(reason);
        }

        protected void btnConfirmRegistration_Click(object sender, EventArgs e)
        {
            if (!pnlRegistration.Visible) return;
            pnlError.Visible = false;

            if (!chkTerms.Checked)
            {
                ShowError("You must accept and confirm the terms & commitment agreement to complete your registration.");
                CurrentStep = 3;
                return;
            }

            string section = txtSection.Text.Trim();
            if (string.IsNullOrWhiteSpace(section))
            {
                ShowError("Please provide your active academic class section (e.g. SBIT-3C).");
                CurrentStep = 3;
                return;
            }

            int yearLvl;
            if (!int.TryParse(ddlYearLevel.SelectedValue, out yearLvl) || yearLvl < 1 || yearLvl > 5)
            {
                ShowError("Please select your current year level.");
                CurrentStep = 3;
                return;
            }

            EventModel ev;
            StudentProfile student;
            if (!LoadRegistrationContext(out ev, out student, yearLvl)) return;

            string studentId = SessionHelper.CurrentStudentId;
            if (string.IsNullOrWhiteSpace(studentId))
            {
                ShowError("Your student profile is unavailable. Please sign in again.");
                return;
            }

            // Check if already registered
            if (_regRepo.IsStudentRegistered(CurrentEventId, studentId))
            {
                ShowError("You already have an active registration pass for this event.");
                CurrentStep = 3;
                return;
            }

            // Create registration model
            var reg = new EventRegistrationModel
            {
                EventId = CurrentEventId,
                StudentId = studentId,
                CurrentYearLvl = yearLvl,
                CurrentSection = section,
                Status = "NoShow" // Default initial status per university state machine
            };

            int newRegId = _regRepo.RegisterStudent(reg);

            if (newRegId > 0)
            {

                // Generate cryptographically unique GUID token for QR validation
                string ticketGuid = Guid.NewGuid().ToString("N");
                string ticketRef = $"TCK-{CurrentEventId:D4}-{newRegId:D5}";

                // Redirect to Digital Ticket & QR Attendance Pass
                Response.Redirect($"~/Frontend/User/EventPass.aspx?regId={newRegId}&ticketId={ticketGuid}&ticketRef={ticketRef}&success=1", true);
            }
            else if (newRegId == -1)
            {
                ShowUnavailable("This event is fully booked. No registration seats remain.", ev);
            }
            else if (newRegId == -2)
            {
                ShowUnavailable("Registration is now closed or the event is no longer available.", ev);
            }
            else if (newRegId == -3)
            {
                ShowUnavailable("Your campus, college, program, or selected year does not meet this event's audience requirements.", ev);
            }
            else
            {
                ShowError("An unexpected error occurred while booking your registration. Please try again.");
                CurrentStep = 3;
            }
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litErrorMsg.Text = Server.HtmlEncode(message);
        }
    }
}
