using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.User
{
    public partial class Dashboard : StudentPage
    {
        private readonly EventRepository _eventRepo = new EventRepository();
        private readonly SponsorRepository _sponsorRepo = new SponsorRepository();
        private readonly RegistrationRepository _regRepo = new RegistrationRepository();
        private readonly StudentRepository _studentRepo = new StudentRepository();
        private Dictionary<int, bool> _registrationClosedByEvent = new Dictionary<int, bool>();

        #region View Models for Presentation

        public class EventCardViewModel
        {
            public int EventId { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
            public string VenueLocation { get; set; }
            public int MaxCapacity { get; set; }
            public int CurrentRegistrations { get; set; }
            public DateTime EventStart { get; set; }
            public DateTime EventEnd { get; set; }
            public DateTime RegStart { get; set; }
            public DateTime RegEnd { get; set; }
            public string Status { get; set; }
            public bool IsRegistrationOpen { get; set; }
            public bool IsRegistrationClosed { get; set; }
            public string FormattedSchedule { get; set; }
            public string FormattedDate => EventStart != DateTime.MinValue ? EventStart.ToString("MM/dd/yyyy") : "TBA";
            public string FormattedTime
            {
                get
                {
                    if (EventStart == DateTime.MinValue) return "TBA";
                    if (EventEnd == DateTime.MinValue || EventEnd == EventStart)
                        return EventStart.ToString("h:mm tt");
                    return $"{EventStart:h:mm tt} to {EventEnd:h:mm tt}";
                }
            }
            public string SponsorBadgesHtml { get; set; }
            public List<string> Sponsors { get; set; } = new List<string>();
            public int RemainingCapacity => Math.Max(0, MaxCapacity - CurrentRegistrations);

            // Category & Imagery
            public string CategoryTag { get; set; } = string.Empty;
            public string CategoryFilterKey { get; set; } = "seminar";
            public string CategoryColorClass { get; set; } = "cat-pill-cyan";
            public string BannerClass { get; set; } = "banner-gradient-1";
            public string BannerImageUrl { get; set; } = "";
            public string RegStatusBadgeHtml { get; set; } = "";
            public string RegSpotsHintHtml { get; set; } = "";
        }

        public class StudentRegistrationViewModel
        {
            public int EventRegistrationId { get; set; }
            public int EventId { get; set; }
            public string EventTitle { get; set; }
            public string VenueLocation { get; set; }
            public string EventDateFormatted { get; set; }
            public string FormattedDate { get; set; }
            public string FormattedTime { get; set; }
            public string Status { get; set; }
            public string RegStatusBadgeHtml { get; set; }
            public string PassIdChipText { get; set; }
            public string SponsorBadgesHtml { get; set; }
            public bool CanCancel { get; set; }
            public bool IsRegistrationClosed { get; set; }
            public string EventPhotoPath { get; set; }
            public string BannerImageUrl { get; set; }
        }

        #endregion

        public string HeroSlidesJson { get; set; } = "[]";
        public string EventsCatalogJson { get; set; } = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SetupStudentContext();
                LoadEventsCatalog();
                LoadStudentRegistrations();
            }
            else
            {
                if (string.IsNullOrEmpty(HeroSlidesJson) || HeroSlidesJson == "[]")
                {
                    LoadEventsCatalog();
                }
            }
        }

        #region Setup Context & Profile

        private void SetupStudentContext()
        {
            if (SessionHelper.IsAuthenticated && SessionHelper.IsStudent)
            {
                string studentId = SessionHelper.CurrentStudentId;

                StudentProfile profile = null;
                try
                {
                    profile = _studentRepo.GetStudentByUserId(SessionHelper.CurrentUserId);
                }
                catch
                {
                    // Fall back to session values
                }

                string firstName = profile?.FirstName ?? Session[SessionHelper.KeyFirstName]?.ToString() ?? "Student";
                string lastName = profile?.LastName ?? Session[SessionHelper.KeyLastName]?.ToString() ?? "";
                string fullName = $"{firstName} {lastName}".Trim();

                litStudentName.Text = Server.HtmlEncode(string.IsNullOrEmpty(fullName) ? "Student User" : fullName);
                litStudentId.Text = Server.HtmlEncode(studentId ?? "Not available");
                litAvatarInitials.Text = GetInitials(firstName, lastName);

                litCampusBranch.Text = Server.HtmlEncode(profile?.CampusBranch ?? SessionHelper.CurrentCampusBranch ?? "San Bartolome");
                litDepartment.Text = Server.HtmlEncode(profile?.Department ?? SessionHelper.CurrentDepartment ?? "College of Computer Studies");
                litProgram.Text = Server.HtmlEncode(profile?.Program ?? SessionHelper.CurrentProgram ?? "BSIT");
                litYearLevel.Text = "Provided during registration";
            }

        }

        private string GetInitials(string first, string last)
        {
            string initials = "";
            if (!string.IsNullOrEmpty(first)) initials += char.ToUpper(first[0]);
            if (!string.IsNullOrEmpty(last)) initials += char.ToUpper(last[0]);
            return string.IsNullOrEmpty(initials) ? "ST" : initials;
        }

        #endregion

        #region Event Catalog Data Loading

        private void LoadEventsCatalog()
        {
            List<EventCardViewModel> viewModels = new List<EventCardViewModel>();

            try
            {
                var profile = _studentRepo.GetStudentByUserId(SessionHelper.CurrentUserId);
                List<EventModel> events = profile == null ? new List<EventModel>() :
                    _eventRepo.GetEventsForStudent(profile.CampusBranch, profile.Department, profile.Program,
                        null);

                DateTime now = DateTime.Now;
                _registrationClosedByEvent = (events ?? new List<EventModel>()).ToDictionary(
                    ev => ev.EventId, ev => ev.GetMatrixStatus(now) != "Open" && ev.GetMatrixStatus(now) != "Soon");

                // A current pass belongs exclusively in My Registered Events.
                // Cancelled passes release their event back to the available catalog.
                var registeredEventIds = new HashSet<int>(_regRepo
                    .GetRegistrationsByStudent(SessionHelper.CurrentStudentId)
                    .Where(reg => !reg.IsCancelled)
                    .Select(reg => reg.EventId));
                events = events?.Where(ev => !registeredEventIds.Contains(ev.EventId)).ToList();

                if (events != null && events.Count > 0)
                {
                    // Batch fetch sponsors for all events in a single SQL query
                    Dictionary<int, List<string>> sponsorsMap = new Dictionary<int, List<string>>();
                    try
                    {
                        var eventIds = events.Select(ev => ev.EventId).Distinct();
                        sponsorsMap = _sponsorRepo.GetSponsorsForEvents(eventIds);
                    }
                    catch
                    {
                        // Sponsor table gracefully bypassed
                    }

                    foreach (var ev in events)
                    {
                        var vm = MapEventToCardViewModel(ev);
                        if (sponsorsMap.TryGetValue(ev.EventId, out var sponsors) && sponsors != null && sponsors.Count > 0)
                        {
                            vm.Sponsors = sponsors;
                        }

                        vm.SponsorBadgesHtml = BuildSponsorBadgesHtml(vm.Sponsors);
                        viewModels.Add(vm);
                    }
                }
            }
            catch
            {
                // Keep the catalog empty when event data is unavailable.
            }

            // Open registration leads the catalog and showcase; closed events stay last.
            // Stable ordering preserves the existing schedule order within each group.
            viewModels = viewModels.OrderBy(vm => vm.IsRegistrationOpen ? 0 : vm.IsRegistrationClosed ? 2 : 1).ToList();
            rptEventCards.DataSource = viewModels;
            rptEventCards.DataBind();
            pnlNoEligibleEvents.Visible = viewModels.Count == 0;

            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            EventsCatalogJson = serializer.Serialize(viewModels.Select(vm => new
            {
                id = vm.EventId,
                title = vm.Title,
                description = vm.Description,
                venue = vm.VenueLocation,
                capacity = vm.MaxCapacity,
                currentRegistrations = vm.CurrentRegistrations,
                remainingSpots = vm.RemainingCapacity,
                schedule = vm.FormattedSchedule,
                dateFormatted = vm.FormattedDate,
                timeFormatted = vm.FormattedTime,
                isRegistrationOpen = vm.IsRegistrationOpen,
                isRegistrationClosed = vm.IsRegistrationClosed,
                status = vm.Status,
                regStatusBadgeHtml = vm.RegStatusBadgeHtml,
                bannerUrl = vm.BannerImageUrl,
                category = vm.CategoryTag,
                sponsors = vm.Sponsors ?? new List<string>(),
                regStart = vm.RegStart.ToString("MM/dd/yyyy hh:mm tt"),
                regEnd = vm.RegEnd.ToString("MM/dd/yyyy hh:mm tt"),
                eventStart = vm.EventStart.ToString("MM/dd/yyyy hh:mm tt"),
                eventEnd = vm.EventEnd.ToString("MM/dd/yyyy hh:mm tt"),
                regUrl = ResolveUrl($"~/Frontend/User/EventRegistration.aspx?eventId={vm.EventId}")
            }));

            PopulateHeroShowcase(viewModels);
        }

        private void PopulateHeroShowcase(List<EventCardViewModel> viewModels)
        {
            var slidesList = new List<object>();

            if (viewModels != null)
            {
                foreach (var vm in viewModels)
                {
                    string desc = !string.IsNullOrWhiteSpace(vm.Description)
                        ? (vm.Description.Length > 180 ? vm.Description.Substring(0, 177) + "..." : vm.Description)
                        : "Discover event agenda, network with university partners, and confirm your attendance pass.";

                    slidesList.Add(new
                    {
                        id = vm.EventId,
                        title = vm.Title,
                        description = desc,
                        venue = vm.VenueLocation,
                        date = vm.EventStart.ToString("MMM dd, yyyy"),
                        time = $"{vm.EventStart:hh:mm tt} - {vm.EventEnd:hh:mm tt}",
                        bgUrl = vm.BannerImageUrl,
                        regUrl = ResolveUrl($"~/Frontend/User/EventRegistration.aspx?eventId={vm.EventId}")
                    });
                }
            }

            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            HeroSlidesJson = serializer.Serialize(slidesList);
        }

        private EventCardViewModel MapEventToCardViewModel(EventModel ev)
        {
            DateTime now = DateTime.Now;
            bool isOpen = ev.IsRegistrationOpen;

            string schedule = $"{ev.EventStart:MM/dd/yyyy} | {ev.EventStart:hh:mm tt} - {ev.EventEnd:hh:mm tt}";

            // Modern category & banner image derivation
            string combined = ((ev.Title ?? "") + " " + (ev.Description ?? "")).ToLowerInvariant();
            string catTag = "#Seminar";
            string filterKey = "seminar";
            string bannerImg = ResolveUrl("~/Frontend/Assets/campus-clean.jpg");

            if (combined.Contains("hack") || combined.Contains("cyber") || combined.Contains("security") || combined.Contains("code"))
            {
                catTag = "Hackathon";
                filterKey = "hackathon";
                bannerImg = ResolveUrl("~/Frontend/Assets/hero_cyber_ai.jpg");
            }
            else if (combined.Contains("workshop") || combined.Contains("lab") || combined.Contains("cloud") || combined.Contains("ai "))
            {
                catTag = "Workshop";
                filterKey = "workshop";
                bannerImg = ResolveUrl("~/Frontend/Assets/hero_cloud_lab.jpg");
            }
            else if (combined.Contains("sport") || combined.Contains("fest") || combined.Contains("game") || combined.Contains("tournament"))
            {
                catTag = "SportsFest";
                filterKey = "sportsfest";
                bannerImg = ResolveUrl("~/Frontend/Assets/QCU Background.png");
            }
            else if (combined.Contains("org") || combined.Contains("fair") || combined.Contains("club") || combined.Contains("expo"))
            {
                catTag = "OrgFair";
                filterKey = "orgfair";
                bannerImg = ResolveUrl("~/Frontend/Assets/QCU Background.png");
            }
            else if (combined.Contains("summit") || combined.Contains("innovation") || combined.Contains("conference"))
            {
                catTag = "TechSummit";
                filterKey = "seminar";
                bannerImg = ResolveUrl("~/Frontend/Assets/campus-clean.jpg");
            }

            // Prioritize explicitly uploaded promotional banner if available
            if (!string.IsNullOrWhiteSpace(ev.EventPhotoPath))
            {
                bannerImg = ResolveUrl(ev.EventPhotoPath);
            }

            var vm = new EventCardViewModel
            {
                EventId = ev.EventId,
                Title = ev.Title,
                Description = ev.Description,
                VenueLocation = ev.VenueLocation,
                MaxCapacity = ev.MaxCapacity,
                CurrentRegistrations = ev.CurrentRegistrations,
                EventStart = ev.EventStart,
                EventEnd = ev.EventEnd,
                RegStart = ev.RegStart,
                RegEnd = ev.RegEnd,
                Status = ev.Status,
                FormattedSchedule = schedule,
                CategoryTag = catTag,
                CategoryFilterKey = filterKey,
                BannerImageUrl = bannerImg
            };

            PopulateRegistrationPresentation(vm);
            return vm;
        }

        private void PopulateRegistrationPresentation(EventCardViewModel model)
        {
            DateTime now = DateTime.Now;
            bool isUpcoming = string.Equals(model.Status, "Upcoming", StringComparison.OrdinalIgnoreCase) && now < model.EventEnd;
            bool isBeforeReg = isUpcoming && now < model.RegStart;
            bool isOpen = isUpcoming && now >= model.RegStart && now <= model.RegEnd && model.CurrentRegistrations < model.MaxCapacity;
            bool isFullyBooked = isUpcoming && now >= model.RegStart && now <= model.RegEnd && model.CurrentRegistrations >= model.MaxCapacity;

            model.IsRegistrationOpen = isOpen;
            model.IsRegistrationClosed = !isBeforeReg && !isOpen;

            if (isBeforeReg)
            {
                // Strict rule: Display "SOON" (never "opens soon")
                model.RegStatusBadgeHtml = "<div class=\"card-status-pill card-status-soon\"> SOON</div>";
                model.RegSpotsHintHtml = $"<div class=\"spots-left-hint soon\"><svg viewBox=\"0 0 24 24\"><circle cx=\"12\" cy=\"12\" r=\"10\" stroke=\"currentColor\" stroke-width=\"2\" fill=\"none\"></circle><polyline points=\"12 6 12 12 16 14\" stroke=\"currentColor\" stroke-width=\"2\" fill=\"none\"></polyline></svg><span>OPENS {model.RegStart:MMM dd}</span></div>";
            }
            else if (isOpen)
            {
                model.RegStatusBadgeHtml = "<div class=\"card-status-pill\"> OPEN</div>";
                model.RegSpotsHintHtml = $"<div class=\"spots-left-hint\"><svg viewBox=\"0 0 24 24\"><path d=\"M13 2L3 14h9l-1 8 10-12h-9l1-8z\" /></svg><span>{model.RemainingCapacity} SPOTS LEFT</span></div>";
            }
            else if (isFullyBooked)
            {
                model.RegStatusBadgeHtml = "<div class=\"card-status-pill card-status-closed\">CLOSED</div>";
                model.RegSpotsHintHtml = "<div class=\"spots-left-hint closed\"><svg viewBox=\"0 0 24 24\"><path d=\"M13 2L3 14h9l-1 8 10-12h-9l1-8z\" /></svg><span>FULLY BOOKED</span></div>";
            }
            else
            {
                model.RegStatusBadgeHtml = "<div class=\"card-status-pill card-status-closed\">CLOSED</div>";
                model.RegSpotsHintHtml = "<div class=\"spots-left-hint closed\"><svg viewBox=\"0 0 24 24\"><path d=\"M13 2L3 14h9l-1 8 10-12h-9l1-8z\" /></svg><span>REGISTRATION CLOSED</span></div>";
            }
        }

        private string BuildSponsorBadgesHtml(IEnumerable<string> sponsors)
        {
            if (sponsors == null || !sponsors.Any())
            {
                return "<span class=\"sponsor-pill\">NONE</span>";
            }

            var badges = new List<string>();
            foreach (var sp in sponsors)
            {
                string clean = sp?.Trim();
                if (string.IsNullOrEmpty(clean)) continue;

                badges.Add($"<span class=\"sponsor-pill\">{Server.HtmlEncode(clean)}</span>");
            }

            return string.Join(" ", badges);
        }

        #endregion

        #region Student Registrations

        private void LoadStudentRegistrations()
        {
            string studentId = SessionHelper.CurrentStudentId;
            var list = new List<StudentRegistrationViewModel>();

            try
            {
                var registrations = _regRepo.GetRegistrationsByStudent(studentId);
                if (registrations != null && registrations.Count > 0)
                {
                    foreach (var reg in registrations)
                    {
                        DateTime? start = reg.EventStart;
                        DateTime? end = reg.EventEnd;

                        string formattedDate = start.HasValue ? start.Value.ToString("MMM dd, yyyy") : "TBA";
                        string formattedTime = "TBA";
                        if (start.HasValue)
                        {
                            if (!end.HasValue || end.Value == start.Value)
                                formattedTime = start.Value.ToString("h:mm tt");
                            else
                                formattedTime = $"{start.Value:h:mm tt} to {end.Value:h:mm tt}";
                        }

                        string badgeHtml = "<div class=\"card-status-pill\"> CONFIRMED PASS</div>";
                        if (reg.IsEventCancelled)
                        {
                            badgeHtml = "<div class=\"card-status-pill card-status-closed\">EVENT CANCELLED</div>";
                        }
                        else if (string.Equals(reg.Status, "Present", StringComparison.OrdinalIgnoreCase))
                        {
                            badgeHtml = "<div class=\"card-status-pill\"> ATTENDED</div>";
                        }
                        else if (string.Equals(reg.Status, "Cancelled", StringComparison.OrdinalIgnoreCase))
                        {
                            badgeHtml = "<div class=\"card-status-pill card-status-closed\">CANCELLED</div>";
                        }

                        list.Add(new StudentRegistrationViewModel
                        {
                            EventRegistrationId = reg.EventRegistrationId,
                            EventId = reg.EventId,
                            EventTitle = reg.EventTitle,
                            VenueLocation = reg.VenueLocation,
                            EventDateFormatted = start.HasValue ? start.Value.ToString("MM/dd/yyyy • hh:mm tt") : "TBA",
                            FormattedDate = formattedDate,
                            FormattedTime = formattedTime,
                            Status = reg.Status,
                            RegStatusBadgeHtml = badgeHtml,
                            PassIdChipText = $"PASS #{reg.EventRegistrationId}",
                            SponsorBadgesHtml = "<span class=\"sponsor-pill\">OFFICIAL PASS</span>",
                            CanCancel = reg.CanCancel,
                            IsRegistrationClosed = (_registrationClosedByEvent.TryGetValue(reg.EventId, out bool eventClosed) && eventClosed)
                                || reg.IsCancelled || reg.IsEventCancelled
                                || string.Equals(reg.EventStatus, "Completed", StringComparison.OrdinalIgnoreCase)
                                || (reg.EventEnd.HasValue && DateTime.Now >= reg.EventEnd.Value)
                                || (reg.RegEnd.HasValue && DateTime.Now > reg.RegEnd.Value),
                            EventPhotoPath = reg.EventPhotoPath,
                            BannerImageUrl = !string.IsNullOrWhiteSpace(reg.EventPhotoPath) ? ResolveUrl(reg.EventPhotoPath) : ResolveUrl("~/Frontend/Assets/campus-clean.jpg")
                        });
                    }
                }
            }
            catch
            {
                // Keep registrations empty when data is unavailable.
            }

            list = list.OrderBy(reg => reg.IsRegistrationClosed ? 1 : 0).ToList();
            if (list.Count > 0)
            {
                pnlNoRegistrations.Visible = false;
                rptMyRegistrations.Visible = true;
                rptMyRegistrations.DataSource = list;
                rptMyRegistrations.DataBind();
            }
            else
            {
                pnlNoRegistrations.Visible = true;
                rptMyRegistrations.Visible = false;
            }
        }

        public string GetStatusBadgeHtml(string status)
        {
            if (string.Equals(status, "Present", StringComparison.OrdinalIgnoreCase))
            {
                return "<span class=\"status-badge-reg status-badge-present\">PRESENT</span>";
            }
            else if (string.Equals(status, "Cancelled", StringComparison.OrdinalIgnoreCase))
            {
                return "<span class=\"status-badge-reg status-badge-cancelled\">✕ CANCELLED</span>";
            }
            else
            {
                // Default: NoShow
                return "<span class=\"status-badge-reg status-badge-noshow\">REGISTERED (NOSHOW)</span>";
            }
        }

        #endregion

        #region Event Handlers

        protected void rptEventCards_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int eventId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"~/Frontend/User/EventRegistration.aspx?eventId={eventId}", true);
            }
        }

        protected void btnConfirmCancelRegistration_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfCancelRegistrationId.Value, out int regId) && regId > 0)
            {
                PerformCancelRegistration(regId);
            }
        }

        protected void rptMyRegistrations_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "CancelRegistration")
            {
                int regId = Convert.ToInt32(e.CommandArgument);
                PerformCancelRegistration(regId);
            }
        }

        private void PerformCancelRegistration(int regId)
        {
            try
            {
                var registration = _regRepo.GetRegistrationById(regId);
                bool cancelled = registration != null
                    && string.Equals(registration.StudentId, SessionHelper.CurrentStudentId, StringComparison.OrdinalIgnoreCase)
                    && _regRepo.CancelRegistration(regId);
                if (cancelled)
                {
                    ShowToast("Registration successfully cancelled. One seat has been released back to capacity.", true);
                }
                else
                {
                    ShowToast("Unable to cancel registration. Cancellation is only permitted during the open registration period.", false);
                }
            }
            catch
            {
                // Report failure without changing the displayed registration status.
                ShowToast("Unable to cancel registration right now. Please try again.", false);
            }

            LoadEventsCatalog();
            LoadStudentRegistrations();
        }

        private void ShowToast(string message, bool isSuccess)
        {
            pnlToast.Visible = true;
            pnlToast.CssClass = isSuccess ? "toast-banner toast-success" : "toast-banner toast-error";
            litToastMsg.Text = Server.HtmlEncode(message);
        }

        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            SessionHelper.ClearSession();
            Response.Redirect("~/Frontend/Login/Login.aspx");
        }

        #endregion
    }
}
