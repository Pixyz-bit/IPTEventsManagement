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
    public partial class EventHistory : _241611JalopEventsManagement.Backend.Helpers.AdminPage
    {
        private readonly EventRepository _eventRepo = new EventRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateAcademicYears();
                BindKpiMetrics();
                BindHistoryGrid();
            }
        }

        private void PopulateAcademicYears()
        {
            try
            {
                var years = _eventRepo.GetDistinctHistoricalAcademicYears();
                ddlAcademicYear.Items.Clear();
                ddlAcademicYear.Items.Add(new ListItem("All Academic Years", "ALL"));

                foreach (var ay in years)
                {
                    ddlAcademicYear.Items.Add(new ListItem(ay, ay));
                }
            }
            catch
            {
                int y = DateTime.Now.Year;
                ddlAcademicYear.Items.Add(new ListItem($"A.Y. {y}-{y + 1}", $"A.Y. {y}-{y + 1}"));
                ddlAcademicYear.Items.Add(new ListItem($"A.Y. {y - 1}-{y}", $"A.Y. {y - 1}-{y}"));
            }
        }

        private void BindKpiMetrics()
        {
            List<EventModel> masterEvents = null;
            try
            {
                masterEvents = _eventRepo.GetHistoricalEvents(null, null, null, null);
            }
            catch
            {
                masterEvents = new List<EventModel>();
            }

            int totalHistorical = masterEvents?.Count ?? 0;
            int totalCompleted = masterEvents?.Count(e => string.Equals(e.EffectiveOutcomeStatus, "Completed", StringComparison.OrdinalIgnoreCase)) ?? 0;
            int totalCancelled = masterEvents?.Count(e => string.Equals(e.EffectiveOutcomeStatus, "Cancelled", StringComparison.OrdinalIgnoreCase)) ?? 0;

            double avgTurnout = 0.0;
            if (masterEvents != null && masterEvents.Any(e => e.PreRegisteredCount > 0))
            {
                var validEvents = masterEvents.Where(e => e.PreRegisteredCount > 0).ToList();
                avgTurnout = validEvents.Average(e => e.TurnoutPercentage);
            }

            litTotalHistorical.Text = totalHistorical.ToString();
            litTotalCompleted.Text = totalCompleted.ToString();
            litTotalCancelled.Text = totalCancelled.ToString();
            litTurnoutAvg.Text = $"{avgTurnout:F1}%";
        }

        private void BindHistoryGrid()
        {
            string search = txtSearch.Text?.Trim();
            string ay = ddlAcademicYear.SelectedValue;
            string outcome = ddlOutcomeStatus.SelectedValue;

            List<EventModel> events = null;

            try
            {
                events = _eventRepo.GetHistoricalEvents(null, ay, outcome, search);
            }
            catch
            {
                events = new List<EventModel>();
            }

            if (events != null && events.Count > 0)
            {
                rptEventHistory.DataSource = events;
                rptEventHistory.DataBind();
                rptEventHistory.Visible = true;
                pnlNoRecords.Visible = false;
            }
            else
            {
                rptEventHistory.Visible = false;
                pnlNoRecords.Visible = true;
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            BindHistoryGrid();
        }

        protected void btnFilterApply_Click(object sender, EventArgs e)
        {
            BindHistoryGrid();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlAcademicYear.SelectedValue = "ALL";
            ddlOutcomeStatus.SelectedValue = "ALL";
            BindHistoryGrid();
        }

        protected void rptEventHistory_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewReport")
            {
                int eventId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"~/Frontend/Admin/EventAnalytics.aspx?eventId={eventId}&from=history", true);
            }
        }

        protected void btnExportHistoryCsv_Click(object sender, EventArgs e)
        {
            string search = txtSearch.Text?.Trim();
            string ay = ddlAcademicYear.SelectedValue;
            string outcome = ddlOutcomeStatus.SelectedValue;

            List<EventModel> events = null;
            try
            {
                events = _eventRepo.GetHistoricalEvents(null, ay, outcome, search);
            }
            catch
            {
                events = new List<EventModel>();
            }

            if (events == null)
            {
                events = new List<EventModel>();
            }

            var sb = new StringBuilder();
            sb.AppendLine("EventId,EventCode,Title,TargetCollege,TargetProgram,VenueLocation,ConcludedDate,AcademicYear,Semester,OutcomeStatus,MaxCapacity,PreRegisteredCount,ActualAttendedCount,TurnoutPercentage,CancellationReason");

            foreach (var ev in events)
            {
                string code = $"#EVT-{ev.EventId:D4}";
                string dept = ev.TargetDepartment ?? "All Colleges";
                string prog = ev.TargetProgram ?? "All Programs";
                string date = ev.EventEnd.ToString("MM/dd/yyyy HH:mm");
                string cancelReason = ev.CancellationReason ?? string.Empty;

                sb.AppendLine($"\"{ev.EventId}\",\"{code}\",\"{EscapeCsv(ev.Title)}\",\"{EscapeCsv(dept)}\",\"{EscapeCsv(prog)}\",\"{EscapeCsv(ev.VenueLocation)}\",\"{date}\",\"{ev.AcademicYear}\",\"{ev.Semester}\",\"{ev.EffectiveOutcomeStatus}\",\"{ev.MaxCapacity}\",\"{ev.PreRegisteredCount}\",\"{ev.AttendedCount}\",\"{ev.TurnoutPercentage:F1}%\",\"{EscapeCsv(cancelReason)}\"");
            }

            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", $"attachment;filename=QCU_Events_History_Ledger_{DateTime.Now:yyyyMMdd_HHmmss}.csv");
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        public string GetOutcomeStatusBadgeClass(string status)
        {
            if (string.Equals(status, "Completed", StringComparison.OrdinalIgnoreCase))
                return "status-pill-completed";
            if (string.Equals(status, "Cancelled", StringComparison.OrdinalIgnoreCase))
                return "status-pill-cancelled";
            if (string.Equals(status, "Upcoming", StringComparison.OrdinalIgnoreCase))
                return "status-pill-upcoming";
            return "status-pill-concluded";
        }

        private static string EscapeCsv(string val)
        {
            if (string.IsNullOrEmpty(val)) return string.Empty;
            return val.Replace("\"", "\"\"");
        }

        private void ShowNotification(string msg, bool isSuccess)
        {
            pnlNotification.Visible = true;
            pnlNotification.CssClass = isSuccess ? "feedback-alert success" : "feedback-alert danger";
            litNotificationMsg.Text = Server.HtmlEncode(msg);
        }

        protected void btnCloseNotification_Click(object sender, EventArgs e)
        {
            pnlNotification.Visible = false;
        }
    }
}
