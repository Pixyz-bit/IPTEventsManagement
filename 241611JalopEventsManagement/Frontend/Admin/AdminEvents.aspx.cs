using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class AdminEvents : _241611JalopEventsManagement.Backend.Helpers.AdminPage
    {
        private readonly EventRepository _eventRepository = new EventRepository();
        private readonly EventCancellationRepository _cancellationRepository = new EventCancellationRepository();

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
                if (new[] { "All", "Open", "Soon", "Close" }.Contains(tabParam, StringComparer.OrdinalIgnoreCase))
                {
                    CurrentStatusFilter = tabParam.Trim();
                }

                BindEventsMatrix();
                if (int.TryParse(Request.QueryString["cancelEventId"], out int eventId)) OpenCancellationDialog(eventId);
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
            public bool IsCancelled { get; set; }
            public bool CanCancel { get; set; }
            public string CancellationReason { get; set; }
            public string TargetDepartment { get; set; }
            public string EventPhotoPath { get; set; }
            public string BannerThumbnailUrl => !string.IsNullOrWhiteSpace(EventPhotoPath)
                ? EventPhotoPath
                : "~/Frontend/Assets/campus-clean.jpg";
        }

        private void BindEventsMatrix()
        {
            List<EventModel> allEvents = null;

            try
            {
                allEvents = _eventRepository.GetAllUpcomingEvents();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Loading events failed: {0}", ex);
                ShowFeedback("Unable to load events. Check the database connection and refresh this page.", false);
            }
            allEvents = allEvents ?? new List<EventModel>();

            // 1. Evaluate registration states within Upcoming events only.
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
            btnTabAll.Text = GetTabCaption("All Upcoming", totalCount);
            btnTabOpen.Text = GetTabCaption("Open", openCount);
            btnTabSoon.Text = GetTabCaption("Soon", soonCount);
            btnTabClose.Text = GetTabCaption("Close", closeCount);

            // 3. Highlight Active Tab
            UpdateTabStyles();

            // 4. Apply the selected status filter.
            IEnumerable<EventModel> filtered = allEvents;
            if (!string.Equals(CurrentStatusFilter, "All", StringComparison.OrdinalIgnoreCase))
            {
                filtered = filtered.Where(ev => string.Equals(GetEventMatrixStatus(ev), CurrentStatusFilter, StringComparison.OrdinalIgnoreCase));
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
                IsCancelled = ev.IsCancelled,
                CanCancel = ev.CanCancel,
                CancellationReason = ev.CancellationReason,
                TargetDepartment = ev.TargetDepartment,
                EventPhotoPath = ev.EventPhotoPath
            }).ToList();

            rptEventsMatrix.DataSource = rowViewModels;
            rptEventsMatrix.DataBind();

            pnlNoEvents.Visible = rowViewModels.Count == 0;
            rptEventsMatrix.Visible = rowViewModels.Count > 0;
        }

        private string GetTabCaption(string label, int count)
        {
            // LinkButton restores Text through ViewState. Mixing literal markup with nested
            // server controls can clear those children on postback, leaving an empty anchor.
            return "<span>" + Server.HtmlEncode(label) + "</span><span class=\"tab-badge\">" + count + "</span>";
        }

        private void UpdateTabStyles()
        {
            btnTabAll.CssClass = "tab-btn" + (CurrentStatusFilter.Equals("All", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabOpen.CssClass = "tab-btn tab-status-open" + (CurrentStatusFilter.Equals("Open", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabSoon.CssClass = "tab-btn tab-status-soon" + (CurrentStatusFilter.Equals("Soon", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnTabClose.CssClass = "tab-btn tab-status-close" + (CurrentStatusFilter.Equals("Close", StringComparison.OrdinalIgnoreCase) ? " active" : "");

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

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            CurrentStatusFilter = "All";
            txtSearch.Text = string.Empty;
            BindEventsMatrix();
        }

        private void OpenCancellationDialog(int eventId)
        {
            try
            {
                EventModel ev = _eventRepository.GetEventById(eventId);
                if (ev == null || !ev.CanCancel)
                {
                    ShowFeedback("This event is unavailable for cancellation. It may already be cancelled or completed.", false);
                    return;
                }
                // Store the confirmed identity in signed ViewState, never trust a posted hidden field.
                ViewState["CancellationEventId"] = ev.EventId;
                litModalEventTitle.Text = Server.HtmlEncode(ev.Title);
                txtCancellationReason.Text = string.Empty;
                litCancellationError.Text = string.Empty;
                pnlCancelModal.Visible = true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Opening cancellation failed: {0}", ex);
                ShowFeedback("Unable to load the selected event. Check the database connection and try again.", false);
            }
        }

        private void ShowFeedback(string message, bool success)
        {
            pnlFeedback.Visible = true;
            pnlFeedback.CssClass = success ? "feedback-alert alert-success" : "feedback-alert alert-error";
            litFeedbackMessage.Text = Server.HtmlEncode(message);
        }

        protected void btnConfirmCancellation_Click(object sender, EventArgs e)
        {
            var cancellation = new EventCancellationModel
            {
                EventId = (ViewState["CancellationEventId"] as int?) ?? 0,
                Reason = txtCancellationReason.Text
            };
            if (!cancellation.IsValid)
            {
                litCancellationError.Text = "Enter a cancellation reason between 1 and 500 characters.";
                pnlCancelModal.Visible = cancellation.EventId > 0;
                return;
            }
            try
            {
                bool success = _cancellationRepository.CancelEvent(cancellation);
                pnlCancelModal.Visible = false;
                ViewState.Remove("CancellationEventId");
                if (success)
                {
                    CurrentStatusFilter = "All";
                    txtSearch.Text = string.Empty;
                }
                BindEventsMatrix();
                ShowFeedback(success
                    ? "Event cancelled. Registration and check-in are closed; existing records are retained in Event History. No automatic notifications are sent."
                    : "The event was not cancelled. It may already be cancelled, completed, or removed. Refresh before trying again.", success);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Event cancellation failed: {0}", ex);
                litCancellationError.Text = "Unable to save cancellation. Check the database connection and try again. Your reason has been kept.";
                pnlCancelModal.Visible = true;
            }
        }
        protected void btnDismissModal_Click(object sender, EventArgs e)
        {
            pnlCancelModal.Visible = false;
            ViewState.Remove("CancellationEventId");
        }

        protected void btnCloseFeedback_Click(object sender, EventArgs e)
        {
            pnlFeedback.Visible = false;
        }

        public static string GetEventMatrixStatus(EventModel ev)
        {
            return ev == null ? "Close" : ev.GetMatrixStatus(DateTime.Now);
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
                case "cancelled":
                    return "status-cancelled";
                case "close":
                default:
                    return "status-close";
            }
        }

    }
}
