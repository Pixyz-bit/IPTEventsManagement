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
    public partial class EventAttendance : _241611JalopEventsManagement.Backend.Helpers.AdminPage
    {
        private readonly EventRepository _eventRepo = new EventRepository();
        private readonly RegistrationRepository _registrationRepo = new RegistrationRepository();

        public int CurrentEventId
        {
            get => ViewState["CurrentEventId"] != null ? (int)ViewState["CurrentEventId"] : 0;
            set => ViewState["CurrentEventId"] = value;
        }

        public string CurrentAdminEmail => SessionHelper.CurrentEmail ?? "admin@gmail.com";

        protected void Page_Load(object sender, EventArgs e)
        {
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
            LoadAttendanceData();
        }

        private void LoadAttendanceData()
        {
            var evt = RequireEvent(_eventRepo, CurrentEventId);

            if (evt != null)
            {
                litEventTitle.Text = Server.HtmlEncode(evt.Title);
                litEventDate.Text = evt.EventStart != DateTime.MinValue ? evt.EventStart.ToString("MM/dd/yyyy") : "MM/dd/yyyy";
                litEventVenue.Text = Server.HtmlEncode(evt.VenueLocation ?? "Campus Grounds");
                litCapacitySummary.Text = $"{evt.CurrentRegistrations} / {evt.MaxCapacity}";
            }


            // Fetch live checked-in attendees
            var checkedInList = _registrationRepo.GetCheckedInAttendees(CurrentEventId);
            var summary = _registrationRepo.GetEventAttendanceSummary(CurrentEventId);

            int totalRegistered = summary.TotalRegistered;
            int totalCheckedIn = checkedInList.Count > 0 ? checkedInList.Count : summary.TotalCheckedIn;

            litCheckedInCount.Text = totalCheckedIn.ToString();
            litKpiTotalCheckedIn.Text = totalCheckedIn.ToString();

            double turnoutRate = totalRegistered > 0 ? ((double)totalCheckedIn / totalRegistered) * 100.0 : 0.0;
            litKpiTurnoutRate.Text = $"{turnoutRate:F1}%";

            if (checkedInList.Count > 0 && checkedInList[0].CheckInTimestamp.HasValue)
            {
                litKpiLatestCheckIn.Text = checkedInList[0].CheckInTimestamp.Value.ToString("hh:mm:ss tt");
            }
            else
            {
                litKpiLatestCheckIn.Text = "--:--:--";
            }

            rptCheckedInAttendees.DataSource = checkedInList;
            rptCheckedInAttendees.DataBind();
            pnlEmptyRoster.Visible = checkedInList.Count == 0;

            PopulateFilterOptions(checkedInList);
        }

        private void PopulateFilterOptions(List<EventRegistrationModel> list)
        {
            string selectedDept = ddlDepartmentFilter.SelectedValue;
            string selectedProgram = ddlProgramFilter.SelectedValue;

            ddlDepartmentFilter.Items.Clear();
            ddlDepartmentFilter.Items.Add(new ListItem("All Departments", ""));

            ddlProgramFilter.Items.Clear();
            ddlProgramFilter.Items.Add(new ListItem("All Courses", ""));

            if (list == null || list.Count == 0) return;

            var depts = list.Select(r => r.StudentDepartment)
                            .Where(d => !string.IsNullOrWhiteSpace(d))
                            .Distinct()
                            .OrderBy(d => d);

            foreach (var d in depts)
            {
                ddlDepartmentFilter.Items.Add(new ListItem(d, d));
            }

            var programs = list.Select(r => r.StudentProgram)
                               .Where(p => !string.IsNullOrWhiteSpace(p))
                               .Distinct()
                               .OrderBy(p => p);

            foreach (var p in programs)
            {
                ddlProgramFilter.Items.Add(new ListItem(p, p));
            }

            if (ddlDepartmentFilter.Items.FindByValue(selectedDept) != null)
            {
                ddlDepartmentFilter.SelectedValue = selectedDept;
            }

            if (ddlProgramFilter.Items.FindByValue(selectedProgram) != null)
            {
                ddlProgramFilter.SelectedValue = selectedProgram;
            }
        }

        public string FormatDate(object timestampObj)
        {
            if (timestampObj != null && DateTime.TryParse(timestampObj.ToString(), out DateTime dt))
            {
                return dt.ToString("MM/dd/yyyy");
            }
            return DateTime.Now.ToString("MM/dd/yyyy");
        }

        public string FormatTime(object timestampObj)
        {
            if (timestampObj != null && DateTime.TryParse(timestampObj.ToString(), out DateTime dt))
            {
                return dt.ToString("hh:mm:ss tt");
            }
            return DateTime.Now.ToString("hh:mm:ss tt");
        }

        public string FormatTimestamp(object timestampObj)
        {
            if (timestampObj != null && DateTime.TryParse(timestampObj.ToString(), out DateTime dt))
            {
                return dt.ToString("MM/dd/yyyy hh:mm:ss tt");
            }
            return DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss tt");
        }

    }
}
