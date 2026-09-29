using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class EventAttendance : Page
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
            var allEvents = _eventRepo.GetAllEvents();
            ddlEvents.Items.Clear();

            if (allEvents != null && allEvents.Count > 0)
            {
                foreach (var evt in allEvents)
                {
                    string dateText = evt.EventStart != DateTime.MinValue ? evt.EventStart.ToString("MM/dd/yyyy") : "TBD";
                    ddlEvents.Items.Add(new ListItem($"{evt.Title} ({dateText})", evt.EventId.ToString()));
                }
            }

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

            LoadAttendanceData();
        }

        protected void ddlEvents_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ddlEvents.SelectedValue, out int selectedId))
            {
                CurrentEventId = selectedId;
                Response.Redirect($"~/Frontend/Admin/EventAttendance.aspx?eventId={selectedId}", true);
            }
        }

        private void LoadAttendanceData()
        {
            var evt = _eventRepo.GetEventById(CurrentEventId);

            if (evt != null)
            {
                litEventTitle.Text = Server.HtmlEncode(evt.Title);
                litEventDate.Text = evt.EventStart != DateTime.MinValue ? evt.EventStart.ToString("MM/dd/yyyy") : "MM/dd/yyyy";
                litEventVenue.Text = Server.HtmlEncode(evt.VenueLocation ?? "Campus Grounds");
                litCapacitySummary.Text = $"{evt.CurrentRegistrations} / {evt.MaxCapacity}";
            }
            else
            {
                litEventTitle.Text = "Demonstration Event Preview";
                litEventDate.Text = DateTime.Now.ToString("MM/dd/yyyy");
                litEventVenue.Text = "Main Academic Amphitheater";
                litCapacitySummary.Text = "0 / 100";
            }

            // Fetch live checked-in attendees
            var checkedInList = _registrationRepo.GetCheckedInAttendees(CurrentEventId);
            var allRegistrations = _registrationRepo.GetRegistrationsByEvent(CurrentEventId);

            int totalRegistered = allRegistrations.Count(r => !string.Equals(r.Status, "Cancelled", StringComparison.OrdinalIgnoreCase));
            int totalCheckedIn = checkedInList.Count;

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

        public string FormatTimestamp(object timestampObj)
        {
            if (timestampObj != null && DateTime.TryParse(timestampObj.ToString(), out DateTime dt))
            {
                return dt.ToString("MM/dd/yyyy hh:mm:ss tt");
            }
            return DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss tt");
        }

        protected void btnExportCsv_Click(object sender, EventArgs e)
        {
            var checkedInList = _registrationRepo.GetCheckedInAttendees(CurrentEventId);
            var sb = new StringBuilder();
            sb.AppendLine("Verified Timestamp,Ticket Reference,Student ID,Attendee Full Name,Institutional Email,Department,Program,Year Level,Section,Verification Method,Inspecting Admin");

            foreach (var r in checkedInList)
            {
                string timestamp = r.CheckInTimestamp.HasValue ? r.CheckInTimestamp.Value.ToString("MM/dd/yyyy hh:mm:ss tt") : "";
                string line = $"\"{timestamp}\",\"{EscapeCsv(r.TicketReference)}\",\"{EscapeCsv(r.StudentId)}\",\"{EscapeCsv(r.StudentFullName)}\",\"{EscapeCsv(r.StudentEmail)}\",\"{EscapeCsv(r.StudentDepartment)}\",\"{EscapeCsv(r.StudentProgram)}\",\"{r.CurrentYearLvl}\",\"{EscapeCsv(r.CurrentSection)}\",\"Gate Verification\",\"{EscapeCsv(CurrentAdminEmail)}\"";
                sb.AppendLine(line);
            }

            string filename = $"Event_{CurrentEventId}_LiveAttendance_{DateTime.Now:MMddyyyy_HHmmss}.csv";
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", $"attachment;filename={filename}");
            Response.ContentType = "text/csv";
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        private static string EscapeCsv(string value)
        {
            if (string.IsNullOrEmpty(value)) return string.Empty;
            return value.Replace("\"", "\"\"");
        }
    }
}
