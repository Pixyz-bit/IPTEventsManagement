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

            litTotalHistorical.Text = totalHistorical.ToString();
            litTotalCompleted.Text = totalCompleted.ToString();
            litTotalCancelled.Text = totalCancelled.ToString();
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

        public string GetOutcomeStatusBadgeClass(string status)
        {
            if (string.Equals(status, "Completed", StringComparison.OrdinalIgnoreCase))
                return "status-pill-completed";
            if (string.Equals(status, "Cancelled", StringComparison.OrdinalIgnoreCase))
                return "status-pill-cancelled";
            if (string.Equals(status, "Upcoming", StringComparison.OrdinalIgnoreCase))
                return "status-pill-upcoming";
            return "status-pill-upcoming";
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
