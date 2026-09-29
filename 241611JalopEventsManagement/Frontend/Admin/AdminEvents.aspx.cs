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

        public class AdminEventRowViewModel
        {
            public int EventId { get; set; }
            public string Title { get; set; }
            public string VenueLocation { get; set; }
            public DateTime EventStart { get; set; }
            public DateTime EventEnd { get; set; }
            public DateTime RegStart { get; set; }
            public DateTime RegEnd { get; set; }
            public int CurrentRegistrations { get; set; }
            public int MaxCapacity { get; set; }
            public string MatrixStatus { get; set; }
            public string TargetDepartment { get; set; }
        }

        private void BindEventsMatrix()
        {
            DateTime now = DateTime.Now;
            List<EventModel> allEvents = null;

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

            // 1. Evaluate 3 Statuses: Close, Open, Soon
            int totalCount = allEvents.Count;
            int openCount = allEvents.Count(ev => GetEventMatrixStatus(ev) == "Open");
            int soonCount = allEvents.Count(ev => GetEventMatrixStatus(ev) == "Soon");
            int closeCount = allEvents.Count(ev => GetEventMatrixStatus(ev) == "Close");

            // Update Summary KPI Cards (if present in markup)
            if (litTotalMatrixCount != null) litTotalMatrixCount.Text = totalCount.ToString();
            if (litOpenCount != null) litOpenCount.Text = openCount.ToString();
            if (litSoonCount != null) litSoonCount.Text = soonCount.ToString();
            if (litCloseCount != null) litCloseCount.Text = closeCount.ToString();

            // 2. Update Status Filter Badges
            litBadgeAll.Text = totalCount.ToString();
            litBadgeOpen.Text = openCount.ToString();
            litBadgeSoon.Text = soonCount.ToString();
            litBadgeClose.Text = closeCount.ToString();

            // 3. Highlight Active Tab
            UpdateTabStyles();

            // 4. Apply Tab Filter (All, Open, Soon, Close)
            IEnumerable<EventModel> filtered = allEvents;
            if (!string.Equals(CurrentStatusFilter, "All", StringComparison.OrdinalIgnoreCase))
            {
                filtered = filtered.Where(ev => string.Equals(GetEventMatrixStatus(ev), CurrentStatusFilter, StringComparison.OrdinalIgnoreCase));
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

            // 7. Chronological Ordering: From the most upcoming to the furthest out
            // Rows naturally arrange in Close, Open, Soon based on which event happens sooner
            List<EventModel> resultList = filtered
                .OrderBy(ev => ev.EventStart)
                .ToList();

            // 8. Project to wireframe row model
            var rowViewModels = resultList.Select(ev => new AdminEventRowViewModel
            {
                EventId = ev.EventId,
                Title = ev.Title,
                VenueLocation = ev.VenueLocation,
                EventStart = ev.EventStart,
                EventEnd = ev.EventEnd,
                RegStart = ev.RegStart,
                RegEnd = ev.RegEnd,
                CurrentRegistrations = ev.CurrentRegistrations,
                MaxCapacity = ev.MaxCapacity,
                MatrixStatus = GetEventMatrixStatus(ev),
                TargetDepartment = ev.TargetDepartment
            }).ToList();

            rptEventsMatrix.DataSource = rowViewModels;
            rptEventsMatrix.DataBind();

            pnlNoEvents.Visible = rowViewModels.Count == 0;
            rptEventsMatrix.Visible = rowViewModels.Count > 0;
        }

        private void UpdateTabStyles()
        {
            btnTabAll.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("All", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabOpen.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("Open", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabSoon.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("Soon", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabClose.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("Close", StringComparison.OrdinalIgnoreCase) ? " active" : "");
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

        public static string GetEventMatrixStatus(EventModel ev)
        {
            if (ev == null) return "Close";
            DateTime now = DateTime.Now;

            // 1. If cancelled or completed, it's Close
            if (string.Equals(ev.Status, "Cancelled", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(ev.Status, "Completed", StringComparison.OrdinalIgnoreCase))
            {
                return "Close";
            }

            // 2. If registration deadline passed, or event already started/ended, or fully booked
            if (now > ev.RegEnd || ev.CurrentRegistrations >= ev.MaxCapacity || now >= ev.EventEnd)
            {
                return "Close";
            }

            // 3. If registration has not yet opened
            if (now < ev.RegStart)
            {
                return "Soon";
            }

            // 4. Otherwise, registration is actively open
            return "Open";
        }

        public static string GetMatrixStatusClass(object statusObj)
        {
            string status = statusObj?.ToString()?.Trim() ?? string.Empty;
            switch (status.ToLowerInvariant())
            {
                case "open":
                    return "status-open";
                case "soon":
                    return "status-soon";
                case "close":
                default:
                    return "status-close";
            }
        }

        private List<EventModel> GetDemonstrationEvents()
        {
            DateTime now = DateTime.Now;

            return new List<EventModel>
            {
                // 1. Closest upcoming event (Starts in 1 day) -> Reg Deadline passed yesterday -> Status: Close
                new EventModel
                {
                    EventId = 1,
                    Title = "AI & Cloud Architecture Workshop",
                    Description = "Deep dive into serverless cloud infrastructure and production container scaling.",
                    VenueLocation = "QCU San Bartolome - Tech Lab 3",
                    MaxCapacity = 50,
                    CurrentRegistrations = 42,
                    EventStart = now.AddDays(1).AddHours(9),
                    EventEnd = now.AddDays(1).AddHours(16),
                    RegStart = now.AddDays(-10),
                    RegEnd = now.AddDays(-1), // Registration closed yesterday
                    Status = "Upcoming",
                    TargetBranch = "San Bartolome",
                    TargetDepartment = "College of Computer Studies",
                    TargetProgram = "BSIT",
                    TargetYearLevel = 3
                },
                // 2. Next upcoming event (Starts in 6 days) -> Currently in registration window -> Status: Open
                new EventModel
                {
                    EventId = 2,
                    Title = "Annual University Tech & Innovation Summit",
                    Description = "Flagship academic conference bringing together university students and tech sponsors.",
                    VenueLocation = "QCU Main Campus - University Hall",
                    MaxCapacity = 200,
                    CurrentRegistrations = 142,
                    EventStart = now.AddDays(6).AddHours(8).AddMinutes(30),
                    EventEnd = now.AddDays(6).AddHours(16).AddMinutes(30),
                    RegStart = now.AddDays(-5),
                    RegEnd = now.AddDays(4), // Registration closes in 4 days
                    Status = "Upcoming",
                    TargetBranch = null,
                    TargetDepartment = "College of Computer Studies",
                    TargetProgram = "BSIT, BSCS",
                    TargetYearLevel = null
                },
                // 3. Furthest out event (Starts in 14 days) -> Registration opens in 3 days -> Status: Soon
                new EventModel
                {
                    EventId = 3,
                    Title = "National Cybersecurity & Ethical Hacking Forum",
                    Description = "Interactive conference on penetration testing, offensive security, and student defense drills.",
                    VenueLocation = "Main Campus - University Gymnasium",
                    MaxCapacity = 100,
                    CurrentRegistrations = 0,
                    EventStart = now.AddDays(14).AddHours(8),
                    EventEnd = now.AddDays(14).AddHours(17),
                    RegStart = now.AddDays(3), // Opens in 3 days
                    RegEnd = now.AddDays(12),
                    Status = "Upcoming",
                    TargetBranch = "San Bartolome",
                    TargetDepartment = "College of Computer Studies",
                    TargetProgram = "BSIT",
                    TargetYearLevel = null
                },
                // 4. Furthest out event (Starts in 21 days) -> Registration opens in 7 days -> Status: Soon
                new EventModel
                {
                    EventId = 4,
                    Title = "Inter-University Robotics Invitational",
                    Description = "Autonomous robot maze-solving and combat competition across campus branches.",
                    VenueLocation = "Central Grounds & Covered Court",
                    MaxCapacity = 300,
                    CurrentRegistrations = 0,
                    EventStart = now.AddDays(21).AddHours(9),
                    EventEnd = now.AddDays(21).AddHours(18),
                    RegStart = now.AddDays(7), // Opens in 7 days
                    RegEnd = now.AddDays(19),
                    Status = "Upcoming",
                    TargetBranch = "San Bartolome",
                    TargetDepartment = "College of Engineering",
                    TargetProgram = null,
                    TargetYearLevel = null
                }
            };
        }
    }
}
