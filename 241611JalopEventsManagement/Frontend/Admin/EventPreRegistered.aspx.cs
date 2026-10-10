using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class EventPreRegistered : _241611JalopEventsManagement.Backend.Helpers.AdminPage
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
            // Keep event navigation tied to the URL; preserve the existing no-ID fallback.
            int eventId = 0;
            if (Request.QueryString["eventId"] != null)
            {
                int.TryParse(Request.QueryString["eventId"], out eventId);
            }
            else
            {
                eventId = _eventRepo.GetAllEvents()?.FirstOrDefault()?.EventId ?? 0;
            }

            CurrentEventId = eventId;
            LoadEventData();
        }

        private void LoadEventData()
        {
            var evt = RequireEvent(_eventRepo, CurrentEventId);

            if (evt != null)
            {
                litEventTitle.Text = Server.HtmlEncode(evt.Title);
                litEventDate.Text = evt.EventStart != DateTime.MinValue ? evt.EventStart.ToString("MM/dd/yyyy") : "MM/dd/yyyy";
                litEventVenue.Text = Server.HtmlEncode(evt.VenueLocation ?? "Campus Grounds");
                litEventCapacitySummary.Text = $"{evt.CurrentRegistrations} / {evt.MaxCapacity}";

                // Status Badge
                string statusText = evt.Status ?? "Upcoming";
                if (string.Equals(statusText, "Open", StringComparison.OrdinalIgnoreCase))
                {
                    litEventStatusBadge.Text = "<span class=\"meta-chip\" style=\"background:rgba(16,185,129,0.15); border-color:rgba(16,185,129,0.3); color:#34d399;\">REGISTRATION OPEN</span>";
                }
                else if (string.Equals(statusText, "Closed", StringComparison.OrdinalIgnoreCase))
                {
                    litEventStatusBadge.Text = "<span class=\"meta-chip\" style=\"background:rgba(244,63,94,0.15); border-color:rgba(244,63,94,0.3); color:#f43f5e;\">REGISTRATION CLOSED</span>";
                }
                else
                {
                    litEventStatusBadge.Text = "<span class=\"meta-chip\" style=\"background-color:var(--brand-subtle); border-color:var(--brand-border); color:var(--brand-primary);\">" + Server.HtmlEncode(statusText.ToUpper()) + "</span>";
                }
            }


            // Load Attendees for this event
            var registrations = _registrationRepo.GetRegistrationsByEvent(CurrentEventId);

            // Triage into dual-sheet cohorts:
            // 1. Expected Attendees: All active registrations (includes Reserved/NoShow and Present).
            //    RULE: Once scanned, an attendee's row remains in EventPreRegistered and changes status to 'Present'.
            var preRegisteredList = registrations.Where(r => !string.Equals(r.Status, "Cancelled", StringComparison.OrdinalIgnoreCase)).ToList();
            
            // 2. Revoked Passes: Cancelled registrations
            var cancelledList = registrations.Where(r => string.Equals(r.Status, "Cancelled", StringComparison.OrdinalIgnoreCase)).ToList();

            // Populate KPIs
            litKpiPreRegistered.Text = preRegisteredList.Count.ToString();
            litKpiCancelled.Text = cancelledList.Count.ToString();

            int maxCap = evt != null ? evt.MaxCapacity : 100;
            int currentRegs = evt != null ? evt.CurrentRegistrations : preRegisteredList.Count;
            int availablePool = Math.Max(0, maxCap - currentRegs);
            litKpiAvailablePool.Text = availablePool.ToString();

            double occupancyRate = maxCap > 0 ? ((double)currentRegs / maxCap) * 100.0 : 0;
            litKpiOccupancyRate.Text = $"{occupancyRate:F1}%";

            // Tab Badges
            litTabCountPreReg.Text = preRegisteredList.Count.ToString();
            litTabCountCancelled.Text = cancelledList.Count.ToString();

            // Bind Repeaters
            rptPreRegistered.DataSource = preRegisteredList;
            rptPreRegistered.DataBind();
            pnlEmptyPreRegistered.Visible = preRegisteredList.Count == 0;

            rptCancelled.DataSource = cancelledList;
            rptCancelled.DataBind();
            pnlEmptyCancelled.Visible = cancelledList.Count == 0;

            // Populate Filter Dropdowns dynamically
            PopulateFilterOptions(registrations);
        }

        public string GetStatusBadgeHtml(object statusObj)
        {
            string status = statusObj?.ToString() ?? "Reserved";
            if (string.Equals(status, "Present", StringComparison.OrdinalIgnoreCase))
            {
                return "<span class=\"status-pill status-pill-present\">Present</span>";
            }
            else if (string.Equals(status, "Cancelled", StringComparison.OrdinalIgnoreCase))
            {
                return "<span class=\"status-pill status-pill-cancelled\">Cancelled</span>";
            }
            else
            {
                return "<span class=\"status-pill status-pill-reserved\">Reserved</span>";
            }
        }

        private void PopulateFilterOptions(List<EventRegistrationModel> list)
        {
            string selectedDept = ddlFilterDepartment.SelectedValue;
            string selectedCourse = ddlFilterCourse.SelectedValue;

            ddlFilterDepartment.Items.Clear();
            ddlFilterDepartment.Items.Add(new ListItem("All Departments", ""));

            ddlFilterCourse.Items.Clear();
            ddlFilterCourse.Items.Add(new ListItem("All Courses", ""));

            if (list == null || list.Count == 0)
            {
                return;
            }

            var depts = list.Select(r => r.StudentDepartment)
                            .Where(d => !string.IsNullOrWhiteSpace(d))
                            .Distinct()
                            .OrderBy(d => d);

            foreach (var d in depts)
            {
                ddlFilterDepartment.Items.Add(new ListItem(d, d));
            }

            var courses = list.Select(r => r.StudentProgram)
                              .Where(c => !string.IsNullOrWhiteSpace(c))
                              .Distinct()
                              .OrderBy(c => c);

            foreach (var c in courses)
            {
                ddlFilterCourse.Items.Add(new ListItem(c, c));
            }

            if (ddlFilterDepartment.Items.FindByValue(selectedDept) != null)
            {
                ddlFilterDepartment.SelectedValue = selectedDept;
            }

            if (ddlFilterCourse.Items.FindByValue(selectedCourse) != null)
            {
                ddlFilterCourse.SelectedValue = selectedCourse;
            }
        }

        protected void btnModalCancelPass_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfModalEventRegId.Value, out int regId) && regId > 0)
            {
                bool success = _registrationRepo.AdminVoidRegistration(regId);
                if (success)
                {
                    ShowAlert("Attendee registration pass successfully voided. 1 seat has been released back to the event capacity pool in real time.", true);
                    LoadEventData();
                }
                else
                {
                    ShowAlert("Unable to void registration. The pass may already be cancelled or invalid.", false);
                }
            }
        }

        private void ShowAlert(string message, bool isSuccess)
        {
            pnlAlert.Visible = true;
            lblAlertMessage.Text = message;
            divAlertBox.Attributes["class"] = isSuccess ? "alert-toast alert-toast-success" : "alert-toast alert-toast-danger";
        }
    }
}
