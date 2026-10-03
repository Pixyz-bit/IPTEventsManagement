using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class EventAnalytics : Page
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

            LoadAnalyticsTelemetry();
        }

        protected void ddlEvents_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ddlEvents.SelectedValue, out int selectedId))
            {
                CurrentEventId = selectedId;
                Response.Redirect($"~/Frontend/Admin/EventAnalytics.aspx?eventId={selectedId}", true);
            }
        }

        private void LoadAnalyticsTelemetry()
        {
            var evt = _eventRepo.GetEventById(CurrentEventId);
            var registrations = _registrationRepo.GetRegistrationsByEvent(CurrentEventId);

            int maxCapacity = evt != null ? evt.MaxCapacity : 100;
            string evtTitle = evt != null ? evt.Title : "Demonstration Event Preview";
            DateTime evtStart = evt != null && evt.EventStart != DateTime.MinValue ? evt.EventStart : DateTime.Now;
            string evtVenue = evt != null ? evt.VenueLocation : "Main Campus Amphitheater";

            if (litEventTitle != null) litEventTitle.Text = Server.HtmlEncode(evtTitle);
            if (litEventDate != null) litEventDate.Text = evtStart.ToString("MM/dd/yyyy");
            if (litEventVenue != null) litEventVenue.Text = Server.HtmlEncode(evtVenue ?? "Campus Grounds");

            string status = evt != null ? evt.Status ?? "Upcoming" : "Upcoming";
            if (litEventStatusBadge != null) litEventStatusBadge.Text = $"<span class=\"meta-chip\" style=\"background-color:var(--brand-subtle); border-color:var(--brand-border); color:var(--brand-primary);\">&#9679; {Server.HtmlEncode(status.ToUpper())}</span>";
            if (litEventCapacitySummary != null) litEventCapacitySummary.Text = evt != null ? $"{evt.CurrentRegistrations} / {maxCapacity}" : $"0 / {maxCapacity}";

            // Active (non-cancelled) registrations
            var activeCohort = registrations.Where(r => !string.Equals(r.Status, "Cancelled", StringComparison.OrdinalIgnoreCase)).ToList();
            var presentCohort = registrations.Where(r => string.Equals(r.Status, "Present", StringComparison.OrdinalIgnoreCase)).ToList();
            var noShowCohort = registrations.Where(r => string.Equals(r.Status, "NoShow", StringComparison.OrdinalIgnoreCase)).ToList();
            var cancelledCohort = registrations.Where(r => string.Equals(r.Status, "Cancelled", StringComparison.OrdinalIgnoreCase)).ToList();

            // =========================================================================
            // PHASE 1: PRE-EVENT ANALYTICS (BEFORE)
            // =========================================================================
            int preRegisteredCount = activeCohort.Count;
            if (litBeforePreRegistered != null) litBeforePreRegistered.Text = preRegisteredCount.ToString("N0");

            // Total Reserved: CurrentRegistrations from EventsTable, or active registrations count if event entity is null
            int totalReservedCount = evt != null ? evt.CurrentRegistrations : preRegisteredCount;
            if (litBeforeTotalReserved != null) litBeforeTotalReserved.Text = totalReservedCount.ToString("N0");

            // Cancelled count (Photo 5: count of registrations where Status = 'Cancelled' before EventStart)
            int cancelledCount = cancelledCohort.Count;
            if (litBeforeCancelled != null) litBeforeCancelled.Text = cancelledCount.ToString("N0");

            // Pre-event Attrition Rate %
            int totalLoggedTransactions = preRegisteredCount + cancelledCount;
            double attritionRate = totalLoggedTransactions > 0 ? ((double)cancelledCount / totalLoggedTransactions) * 100.0 : 0.0;
            if (litBeforeAttritionRate != null) litBeforeAttritionRate.Text = $"{attritionRate:F1}%";

            // Capacity Saturation Meter (Photo 4: CurrentRegistrations / MaxCapacity from EventsTable)
            double saturationRate = maxCapacity > 0 ? ((double)totalReservedCount / maxCapacity) * 100.0 : 0.0;
            if (litBeforeSaturationRate != null) litBeforeSaturationRate.Text = $"{saturationRate:F1}%";
            if (litSaturationPercentDisplay != null) litSaturationPercentDisplay.Text = $"{saturationRate:F1}%";
            if (litCapacityMaxDisplay != null) litCapacityMaxDisplay.Text = maxCapacity.ToString("N0");

            // Saturation Status Indicator
            string saturationStatusText;
            if (saturationRate < 70.0)
            {
                saturationStatusText = "Undersubscribed (<70%)";
            }
            else if (saturationRate <= 95.0)
            {
                saturationStatusText = "At Healthy Capacity (70-95%)";
            }
            else if (saturationRate <= 100.0)
            {
                saturationStatusText = "At Maximum Capacity (100%)";
            }
            else
            {
                saturationStatusText = "Needs Larger Venue (>100%)";
            }
            if (litBeforeSaturationStatus != null) litBeforeSaturationStatus.Text = saturationStatusText;

            int availableQuota = Math.Max(0, maxCapacity - totalReservedCount);
            if (litBeforeAvailableQuota != null) litBeforeAvailableQuota.Text = availableQuota.ToString("N0");

            int daysUntilLaunch = Math.Max(0, (evtStart.Date - DateTime.Now.Date).Days);
            if (litBeforeDaysUntilLaunch != null) litBeforeDaysUntilLaunch.Text = $"{daysUntilLaunch} Days";

            // Saturation Progress Bar (with dynamic threshold styling)
            string barColor = saturationRate >= 95.0 ? "var(--accent-rose)" : (saturationRate >= 70.0 ? "var(--accent-emerald)" : "var(--brand-primary)");
            if (litSaturationProgressBar != null) litSaturationProgressBar.Text = $"<div class=\"progress-fill\" style=\"width:{Math.Min(100.0, saturationRate):F1}%; background-color:{barColor};\"></div>";

            // Demographic Breakdown: Campus Branch
            var branchGroups = activeCohort
                .GroupBy(r => string.IsNullOrWhiteSpace(r.StudentCampusBranch) ? "Main Campus" : r.StudentCampusBranch)
                .Select(g => new DemographicBarItem
                {
                    Label = g.Key,
                    Count = g.Count(),
                    Percentage = preRegisteredCount > 0 ? ((double)g.Count() / preRegisteredCount) * 100.0 : 0.0
                })
                .OrderByDescending(x => x.Count)
                .ToList();
            rptBranchDistribution.DataSource = branchGroups;
            rptBranchDistribution.DataBind();

            // Demographic Breakdown: Department
            var deptGroups = activeCohort
                .GroupBy(r => string.IsNullOrWhiteSpace(r.StudentDepartment) ? "Unassigned Department" : r.StudentDepartment)
                .Select(g => new DemographicBarItem
                {
                    Label = g.Key,
                    Count = g.Count(),
                    Percentage = preRegisteredCount > 0 ? ((double)g.Count() / preRegisteredCount) * 100.0 : 0.0
                })
                .OrderByDescending(x => x.Count)
                .ToList();
            rptDepartmentDistribution.DataSource = deptGroups;
            rptDepartmentDistribution.DataBind();

            // Demographic Breakdown: Course / Program (Top 5 + Others for clean pie slice display)
            var allCourses = activeCohort
                .GroupBy(r => string.IsNullOrWhiteSpace(r.StudentProgram) ? "General Studies" : r.StudentProgram)
                .Select(g => new DemographicBarItem
                {
                    Label = g.Key,
                    Count = g.Count(),
                    Percentage = preRegisteredCount > 0 ? ((double)g.Count() / preRegisteredCount) * 100.0 : 0.0
                })
                .OrderByDescending(x => x.Count)
                .ToList();

            List<DemographicBarItem> courseGroups;
            if (allCourses.Count > 6)
            {
                courseGroups = allCourses.Take(5).ToList();
                int othersCount = allCourses.Skip(5).Sum(x => x.Count);
                double othersPct = preRegisteredCount > 0 ? ((double)othersCount / preRegisteredCount) * 100.0 : 0.0;
                courseGroups.Add(new DemographicBarItem { Label = "Other Programs", Count = othersCount, Percentage = othersPct });
            }
            else
            {
                courseGroups = allCourses;
            }
            rptCourseDistribution.DataSource = courseGroups;
            rptCourseDistribution.DataBind();

            // Demographic Breakdown: Year Level
            var yearGroups = activeCohort
                .GroupBy(r => r.CurrentYearLvl > 0 ? $"Year {r.CurrentYearLvl}" : "General")
                .Select(g => new DemographicBarItem
                {
                    Label = g.Key,
                    Count = g.Count(),
                    Percentage = preRegisteredCount > 0 ? ((double)g.Count() / preRegisteredCount) * 100.0 : 0.0
                })
                .OrderBy(x => x.Label)
                .ToList();
            rptYearDistribution.DataSource = yearGroups;
            rptYearDistribution.DataBind();

            // Serialize Demographics cohorts for interactive Pie Chart
            var serializer = new JavaScriptSerializer();
            var demographicsPayload = new
            {
                department = deptGroups.Select(d => new { label = d.Label, count = d.Count, percentage = Math.Round(d.Percentage, 1) }),
                course = courseGroups.Select(c => new { label = c.Label, count = c.Count, percentage = Math.Round(c.Percentage, 1) }),
                branch = branchGroups.Select(b => new { label = b.Label, count = b.Count, percentage = Math.Round(b.Percentage, 1) }),
                year = yearGroups.Select(y => new { label = y.Label, count = y.Count, percentage = Math.Round(y.Percentage, 1) })
            };
            litDemographicsJson.Text = serializer.Serialize(demographicsPayload);

            // Registration Velocity Over Time
            var velocityList = new List<VelocityItem>();
            int cumulative = 0;
            var regDates = activeCohort
                .GroupBy(r => r.RegistrationTimestamp.HasValue ? r.RegistrationTimestamp.Value.Date : (evt != null ? evt.RegStart.Date : DateTime.Today))
                .OrderBy(g => g.Key)
                .ToList();

            foreach (var g in regDates)
            {
                cumulative += g.Count();
                velocityList.Add(new VelocityItem
                {
                    DateLabel = g.Key.ToString("MM/dd/yyyy"),
                    RegistrationsCount = g.Count(),
                    CumulativeCount = cumulative
                });
            }
            if (velocityList.Count == 0)
            {
                velocityList.Add(new VelocityItem { DateLabel = DateTime.Today.ToString("MM/dd/yyyy"), RegistrationsCount = preRegisteredCount, CumulativeCount = preRegisteredCount });
            }
            rptRegistrationVelocity.DataSource = velocityList;
            rptRegistrationVelocity.DataBind();

            // =========================================================================
            // PHASE 2: LIVE GATE TELEMETRY (DURING)
            // =========================================================================
            int checkedInCount = presentCohort.Count;
            if (litDuringCheckedIn != null) litDuringCheckedIn.Text = checkedInCount.ToString();
            if (litDuringRosterTotal != null) litDuringRosterTotal.Text = preRegisteredCount.ToString();

            double turnoutRate = preRegisteredCount > 0 ? ((double)checkedInCount / preRegisteredCount) * 100.0 : 0.0;
            if (litDuringTurnoutRate != null) litDuringTurnoutRate.Text = $"{turnoutRate:F1}%";

            double occupancyPercent = maxCapacity > 0 ? ((double)checkedInCount / maxCapacity) * 100.0 : 0.0;
            if (litDuringVenueOccupancy != null) litDuringVenueOccupancy.Text = $"{occupancyPercent:F1}%";

            int unscanned = Math.Max(0, preRegisteredCount - checkedInCount);
            if (litDuringUnscannedCohort != null) litDuringUnscannedCohort.Text = unscanned.ToString();

            // 15-Minute Peak Surge Velocity
            var intervalList = new List<IntervalTelemetryItem>();
            var checkInTimes = presentCohort.Where(r => r.CheckInTimestamp.HasValue).Select(r => r.CheckInTimestamp.Value).ToList();

            if (checkInTimes.Count > 0)
            {
                // Round to 15-min intervals
                var intervalGroups = checkInTimes
                    .GroupBy(dt => new DateTime(dt.Year, dt.Month, dt.Day, dt.Hour, (dt.Minute / 15) * 15, 0))
                    .OrderBy(g => g.Key)
                    .ToList();

                int maxInterval = intervalGroups.Max(g => g.Count());
                var peakGroup = intervalGroups.OrderByDescending(g => g.Count()).First();
                if (litDuringPeakWindow != null) litDuringPeakWindow.Text = $"{peakGroup.Key:hh:mm tt} - {peakGroup.Key.AddMinutes(15):hh:mm tt}";

                foreach (var ig in intervalGroups)
                {
                    intervalList.Add(new IntervalTelemetryItem
                    {
                        IntervalWindow = $"{ig.Key:hh:mm tt} - {ig.Key.AddMinutes(15):hh:mm tt}",
                        CheckInCount = ig.Count(),
                        IntensityPercent = maxInterval > 0 ? ((double)ig.Count() / maxInterval) * 100.0 : 0.0
                    });
                }
            }
            else
            {
                if (litDuringPeakWindow != null) litDuringPeakWindow.Text = "Awaiting Gate Traffic";
                intervalList.Add(new IntervalTelemetryItem { IntervalWindow = "Terminal Idle", CheckInCount = 0, IntensityPercent = 0.0 });
            }
            if (rptCheckInIntervals != null)
            {
                rptCheckInIntervals.DataSource = intervalList;
                rptCheckInIntervals.DataBind();
            }

            // =========================================================================
            // PHASE 3: POST-EVENT PERFORMANCE AUDIT (AFTER)
            // =========================================================================
            if (litAfterPreRegisteredTotal != null) litAfterPreRegisteredTotal.Text = preRegisteredCount.ToString();
            if (litAfterActualAttended != null) litAfterActualAttended.Text = checkedInCount.ToString();
            if (litAfterNoShows != null) litAfterNoShows.Text = noShowCohort.Count.ToString();
            if (litAfterCancellations != null) litAfterCancellations.Text = cancelledCohort.Count.ToString();

            double retentionRate = preRegisteredCount > 0 ? ((double)checkedInCount / preRegisteredCount) * 100.0 : 0.0;
            if (litAfterRetentionRate != null) litAfterRetentionRate.Text = $"{retentionRate:F1}%";

            // Demographic Audit Table (Department Breakdown with Engagement Rate)
            var deptAuditList = activeCohort
                .GroupBy(r => string.IsNullOrWhiteSpace(r.StudentDepartment) ? "General Studies" : r.StudentDepartment)
                .Select(g =>
                {
                    int totalInDept = g.Count();
                    int presentInDept = g.Count(r => string.Equals(r.Status, "Present", StringComparison.OrdinalIgnoreCase));
                    int noShowInDept = totalInDept - presentInDept;
                    return new DemographicAuditItem
                    {
                        Department = g.Key,
                        PreRegistered = totalInDept,
                        Attended = presentInDept,
                        NoShows = noShowInDept
                    };
                })
                .OrderByDescending(x => x.AttendanceRate)
                .ThenByDescending(x => x.Attended)
                .ToList();

            if (deptAuditList.Count > 0 && deptAuditList[0].Attended > 0)
            {
                if (litAfterTopDepartment != null) litAfterTopDepartment.Text = $"{deptAuditList[0].Department} ({deptAuditList[0].AttendanceRate:F1}% Turnout)";
            }
            else
            {
                if (litAfterTopDepartment != null) litAfterTopDepartment.Text = "Audit In-Progress";
            }

            if (rptDemographicAudit != null)
            {
                rptDemographicAudit.DataSource = deptAuditList;
                rptDemographicAudit.DataBind();
            }
        }

        protected void btnExportComprehensiveCsv_Click(object sender, EventArgs e)
        {
            var registrations = _registrationRepo.GetRegistrationsByEvent(CurrentEventId);
            var evt = _eventRepo.GetEventById(CurrentEventId);

            var sb = new StringBuilder();
            sb.AppendLine("=== QCU EVENT TELEMETRY & AUDIT INTELLIGENCE REPORT ===");
            sb.AppendLine($"Event Title:,\"{EscapeCsv(evt != null ? evt.Title : "Event")}\"");
            sb.AppendLine($"Date of Event:,{DateTime.Now:MM/dd/yyyy}");
            sb.AppendLine($"Exported By:,{CurrentAdminEmail}");
            sb.AppendLine();
            sb.AppendLine("Ticket Reference,Student ID,Attendee Full Name,Institutional Email,Campus Branch,Department,Program,Year Level,Section,Registration Timestamp,Gate Check-In Timestamp,Audit Status");

            foreach (var r in registrations)
            {
                string regTime = r.RegistrationTimestamp.HasValue ? r.RegistrationTimestamp.Value.ToString("MM/dd/yyyy hh:mm:ss tt") : "";
                string checkInTime = r.CheckInTimestamp.HasValue ? r.CheckInTimestamp.Value.ToString("MM/dd/yyyy hh:mm:ss tt") : "N/A";
                string line = $"\"{EscapeCsv(r.TicketReference)}\",\"{EscapeCsv(r.StudentId)}\",\"{EscapeCsv(r.StudentFullName)}\",\"{EscapeCsv(r.StudentEmail)}\",\"{EscapeCsv(r.StudentCampusBranch)}\",\"{EscapeCsv(r.StudentDepartment)}\",\"{EscapeCsv(r.StudentProgram)}\",\"{r.CurrentYearLvl}\",\"{EscapeCsv(r.CurrentSection)}\",\"{regTime}\",\"{checkInTime}\",\"{EscapeCsv(r.Status)}\"";
                sb.AppendLine(line);
            }

            string filename = $"Event_{CurrentEventId}_ComprehensiveAudit_{DateTime.Now:MMddyyyy_HHmmss}.csv";
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

    #region Telemetry Projection DTOs

    public class DemographicBarItem
    {
        public string Label { get; set; }
        public int Count { get; set; }
        public double Percentage { get; set; }
    }

    public class VelocityItem
    {
        public string DateLabel { get; set; }
        public int RegistrationsCount { get; set; }
        public int CumulativeCount { get; set; }
    }

    public class IntervalTelemetryItem
    {
        public string IntervalWindow { get; set; }
        public int CheckInCount { get; set; }
        public double IntensityPercent { get; set; }
    }

    public class DemographicAuditItem
    {
        public string Department { get; set; }
        public int PreRegistered { get; set; }
        public int Attended { get; set; }
        public int NoShows { get; set; }
        public double AttendanceRate => PreRegistered > 0 ? ((double)Attended / PreRegistered) * 100.0 : 0.0;
    }

    #endregion
}
