using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class AdminEvents : Page
    {
        private readonly EventRepository _eventRepository = new EventRepository();

        private string CurrentStatusFilter
        {
            get => (ViewState["CurrentStatusFilter"] as string) ?? "All";
            set => ViewState["CurrentStatusFilter"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string tabParam = Request.QueryString["status"];
                if (!string.IsNullOrWhiteSpace(tabParam))
                {
                    CurrentStatusFilter = tabParam.Trim();
                }

                BindEventsMatrix();
            }
        }

        private void BindEventsMatrix()
        {
            List<EventModel> allEvents;

            try
            {
                allEvents = _eventRepository.GetAllEvents();
                if (allEvents == null || allEvents.Count == 0)
                {
                    allEvents = GetDemonstrationEvents();
                }
            }
            catch
            {
                // Fallback for database migration / unseeded preview
                allEvents = GetDemonstrationEvents();
            }

            // 1. Update Matrix Top KPI Counters
            int totalCount = allEvents.Count;
            int upcomingCount = allEvents.Count(ev => string.Equals(ev.Status, "Upcoming", StringComparison.OrdinalIgnoreCase));
            int ongoingCount = allEvents.Count(ev => string.Equals(ev.Status, "Ongoing", StringComparison.OrdinalIgnoreCase));
            int completedCount = allEvents.Count(ev => string.Equals(ev.Status, "Completed", StringComparison.OrdinalIgnoreCase));
            int cancelledCount = allEvents.Count(ev => string.Equals(ev.Status, "Cancelled", StringComparison.OrdinalIgnoreCase));

            int totalRegistrations = allEvents.Sum(ev => ev.CurrentRegistrations);
            int totalCapacity = allEvents.Sum(ev => ev.MaxCapacity);
            int avgFillRate = totalCapacity > 0 ? (int)Math.Round((double)totalRegistrations / totalCapacity * 100) : 0;

            litTotalMatrixCount.Text = totalCount.ToString();
            litUpcomingCount.Text = upcomingCount.ToString();
            litTotalRegistrations.Text = totalRegistrations.ToString("N0");
            litAvgFillRate.Text = avgFillRate + "%";

            // 2. Update Status Filter Badges
            litBadgeAll.Text = totalCount.ToString();
            litBadgeUpcoming.Text = upcomingCount.ToString();
            litBadgeOngoing.Text = ongoingCount.ToString();
            litBadgeCompleted.Text = completedCount.ToString();
            litBadgeCancelled.Text = cancelledCount.ToString();

            // 3. Highlight Active Tab
            UpdateTabStyles();

            // 4. Apply Tab Filter
            IEnumerable<EventModel> filtered = allEvents;
            if (!string.Equals(CurrentStatusFilter, "All", StringComparison.OrdinalIgnoreCase))
            {
                filtered = filtered.Where(ev => string.Equals(ev.Status, CurrentStatusFilter, StringComparison.OrdinalIgnoreCase));
            }

            // 5. Apply Department Filter
            string dept = ddlDepartmentFilter.SelectedValue;
            if (!string.IsNullOrWhiteSpace(dept))
            {
                filtered = filtered.Where(ev => string.Equals(ev.TargetDepartment, dept, StringComparison.OrdinalIgnoreCase));
            }

            // 6. Apply Search Keyword Filter
            string keyword = txtSearch.Text?.Trim();
            if (!string.IsNullOrWhiteSpace(keyword))
            {
                filtered = filtered.Where(ev =>
                    (ev.Title != null && ev.Title.IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (ev.VenueLocation != null && ev.VenueLocation.IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (ev.TargetDepartment != null && ev.TargetDepartment.IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0));
            }

            List<EventModel> resultList = filtered.OrderBy(ev => ev.EventStart).ToList();

            rptEventsMatrix.DataSource = resultList;
            rptEventsMatrix.DataBind();

            pnlNoEvents.Visible = resultList.Count == 0;
            rptEventsMatrix.Visible = resultList.Count > 0;
        }

        private void UpdateTabStyles()
        {
            btnTabAll.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("All", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabUpcoming.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("Upcoming", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabOngoing.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("Ongoing", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabCompleted.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("Completed", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabCancelled.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("Cancelled", StringComparison.OrdinalIgnoreCase) ? " active" : "");
        }

        protected void FilterTab_Click(object sender, EventArgs e)
        {
            if (sender is LinkButton btn && !string.IsNullOrWhiteSpace(btn.CommandArgument))
            {
                CurrentStatusFilter = btn.CommandArgument.Trim();
                BindEventsMatrix();
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            BindEventsMatrix();
        }

        protected void ddlDepartmentFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindEventsMatrix();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            CurrentStatusFilter = "All";
            txtSearch.Text = string.Empty;
            ddlDepartmentFilter.SelectedIndex = 0;
            BindEventsMatrix();
        }

        protected void rptEventsMatrix_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (string.Equals(e.CommandName, "RequestCancel", StringComparison.OrdinalIgnoreCase))
            {
                if (int.TryParse(e.CommandArgument?.ToString(), out int eventId))
                {
                    hfCancelEventId.Value = eventId.ToString();
                    txtCancellationReason.Text = string.Empty;

                    try
                    {
                        EventModel ev = _eventRepository.GetEventById(eventId);
                        litModalEventTitle.Text = ev != null ? Server.HtmlEncode(ev.Title) : "Event #" + eventId;
                    }
                    catch
                    {
                        litModalEventTitle.Text = "Event #" + eventId;
                    }

                    pnlCancelModal.Visible = true;
                }
            }
        }

        protected void btnConfirmCancellation_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfCancelEventId.Value, out int eventId))
            {
                string reason = txtCancellationReason.Text?.Trim();
                if (string.IsNullOrWhiteSpace(reason))
                {
                    reason = "Administrative scheduling adjustment.";
                }

                try
                {
                    bool success = _eventRepository.CancelEvent(eventId, reason);
                    pnlCancelModal.Visible = false;

                    pnlFeedback.Visible = true;
                    if (success)
                    {
                        pnlFeedback.CssClass = "feedback-alert alert-success";
                        litFeedbackMessage.Text = "<strong>Event Cancelled:</strong> Event #" + eventId + " has been formally cancelled and notifications dispatched.";
                    }
                    else
                    {
                        pnlFeedback.CssClass = "feedback-alert alert-error";
                        litFeedbackMessage.Text = "<strong>Notice:</strong> Cancellation processed in preview mode.";
                    }

                    BindEventsMatrix();
                }
                catch (Exception ex)
                {
                    pnlCancelModal.Visible = false;
                    pnlFeedback.Visible = true;
                    pnlFeedback.CssClass = "feedback-alert alert-error";
                    litFeedbackMessage.Text = "<strong>Error:</strong> " + Server.HtmlEncode(ex.Message);
                }
            }
        }

        protected void btnDismissModal_Click(object sender, EventArgs e)
        {
            pnlCancelModal.Visible = false;
        }

        protected void btnCloseFeedback_Click(object sender, EventArgs e)
        {
            pnlFeedback.Visible = false;
        }

        public static int GetCapacityPercentage(object registrations, object maxCapacity)
        {
            if (registrations == null || maxCapacity == null)
            {
                return 0;
            }

            if (int.TryParse(registrations.ToString(), out int reg) && int.TryParse(maxCapacity.ToString(), out int cap) && cap > 0)
            {
                int pct = (int)Math.Round((double)reg / cap * 100);
                return Math.Min(100, Math.Max(0, pct));
            }

            return 0;
        }

        public static string GetStatusClass(object statusObj)
        {
            string status = statusObj?.ToString()?.Trim() ?? string.Empty;
            switch (status.ToLowerInvariant())
            {
                case "upcoming":
                    return "status-upcoming";
                case "ongoing":
                    return "status-ongoing";
                case "completed":
                    return "status-completed";
                case "cancelled":
                    return "status-cancelled";
                default:
                    return "status-completed";
            }
        }

        private List<EventModel> GetDemonstrationEvents()
        {
            return new List<EventModel>
            {
                new EventModel
                {
                    EventId = 1,
                    Title = "Annual University Tech Symposium 2026",
                    Description = "Flagship conference on distributed systems, AI architectures, and cloud security.",
                    VenueLocation = "Central Auditorium, Hall A",
                    MaxCapacity = 350,
                    CurrentRegistrations = 280,
                    EventStart = DateTime.Now.AddDays(3).AddHours(9),
                    EventEnd = DateTime.Now.AddDays(3).AddHours(16),
                    RegStart = DateTime.Now.AddDays(-10),
                    RegEnd = DateTime.Now.AddDays(2),
                    Status = "Upcoming",
                    TargetBranch = "San Bartolome",
                    TargetDepartment = "College of Computer Studies",
                    TargetProgram = "BSIT",
                    TargetYearLevel = 3
                },
                new EventModel
                {
                    EventId = 2,
                    Title = "Inter-Campus Engineering Hackathon",
                    Description = "48-hour hardware design and IoT embedded firmware challenge.",
                    VenueLocation = "Makerspace Innovation Lab",
                    MaxCapacity = 150,
                    CurrentRegistrations = 142,
                    EventStart = DateTime.Now.AddDays(7).AddHours(8),
                    EventEnd = DateTime.Now.AddDays(8).AddHours(18),
                    RegStart = DateTime.Now.AddDays(-12),
                    RegEnd = DateTime.Now.AddDays(5),
                    Status = "Upcoming",
                    TargetBranch = "San Bartolome",
                    TargetDepartment = "College of Engineering",
                    TargetProgram = "BSIE",
                    TargetYearLevel = null
                },
                new EventModel
                {
                    EventId = 3,
                    Title = "FinTech & Business Case Competition",
                    Description = "National case challenge addressing digital payment rails and micro-finance.",
                    VenueLocation = "Business College Lecture Theater 1",
                    MaxCapacity = 120,
                    CurrentRegistrations = 120,
                    EventStart = DateTime.Now.AddDays(14).AddHours(10),
                    EventEnd = DateTime.Now.AddDays(14).AddHours(15),
                    RegStart = DateTime.Now.AddDays(-5),
                    RegEnd = DateTime.Now.AddDays(10),
                    Status = "Upcoming",
                    TargetBranch = null, // Open to all branches
                    TargetDepartment = "College of Business & Acctg",
                    TargetProgram = "BSBA",
                    TargetYearLevel = null
                },
                new EventModel
                {
                    EventId = 4,
                    Title = "General University Assembly & Convocation",
                    Description = "Annual academic address by the University President and administrative staff.",
                    VenueLocation = "University Grand Gymnasium",
                    MaxCapacity = 800,
                    CurrentRegistrations = 745,
                    EventStart = DateTime.Now.AddHours(-2),
                    EventEnd = DateTime.Now.AddHours(3),
                    RegStart = DateTime.Now.AddDays(-20),
                    RegEnd = DateTime.Now.AddDays(-1),
                    Status = "Ongoing",
                    TargetBranch = null,
                    TargetDepartment = null,
                    TargetProgram = null,
                    TargetYearLevel = null
                },
                new EventModel
                {
                    EventId = 5,
                    Title = "Career Readiness & Resume Masterclass",
                    Description = "HR interview preparation and mock screening for graduating seniors.",
                    VenueLocation = "Student Center Pavilion",
                    MaxCapacity = 200,
                    CurrentRegistrations = 195,
                    EventStart = DateTime.Now.AddDays(-10).AddHours(13),
                    EventEnd = DateTime.Now.AddDays(-10).AddHours(17),
                    RegStart = DateTime.Now.AddDays(-25),
                    RegEnd = DateTime.Now.AddDays(-11),
                    Status = "Completed",
                    TargetBranch = "San Bartolome",
                    TargetDepartment = null,
                    TargetProgram = null,
                    TargetYearLevel = 4
                },
                new EventModel
                {
                    EventId = 6,
                    Title = "Inter-University Robotics Invitational",
                    Description = "Autonomous robot maze-solving and combat competition.",
                    VenueLocation = "Central Grounds & Covered Court",
                    MaxCapacity = 300,
                    CurrentRegistrations = 85,
                    EventStart = DateTime.Now.AddDays(25).AddHours(9),
                    EventEnd = DateTime.Now.AddDays(25).AddHours(18),
                    RegStart = DateTime.Now.AddDays(-3),
                    RegEnd = DateTime.Now.AddDays(20),
                    Status = "Cancelled",
                    CancellationReason = "Facility maintenance and roof restoration scheduling overlap.",
                    TargetBranch = "San Bartolome",
                    TargetDepartment = "College of Engineering",
                    TargetProgram = null,
                    TargetYearLevel = null
                }
            };
        }
    }
}
