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
    public partial class Dashboard : Page
    {
        private readonly EventRepository _eventRepo = new EventRepository();
        private readonly SponsorRepository _sponsorRepo = new SponsorRepository();
        private readonly RegistrationRepository _regRepo = new RegistrationRepository();
        private readonly StudentRepository _studentRepo = new StudentRepository();

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
                pnlPreviewBanner.Visible = false;
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
                litStudentId.Text = Server.HtmlEncode(studentId ?? "STU-2026");
                litAvatarInitials.Text = GetInitials(firstName, lastName);

                litCampusBranch.Text = Server.HtmlEncode(profile?.CampusBranch ?? SessionHelper.CurrentCampusBranch ?? "San Bartolome");
                litDepartment.Text = Server.HtmlEncode(profile?.Department ?? SessionHelper.CurrentDepartment ?? "College of Computer Studies");
                litProgram.Text = Server.HtmlEncode(profile?.Program ?? SessionHelper.CurrentProgram ?? "BSIT");
                litYearLevel.Text = "3rd Year";
            }
            else
            {
                // Preview mode standard as per dev rules
                pnlPreviewBanner.Visible = true;
                litStudentName.Text = "Martin Jalop";
                litStudentId.Text = "24-1611";
                litAvatarInitials.Text = "MJ";
                litCampusBranch.Text = "San Bartolome";
                litDepartment.Text = "College of Computer Studies";
                litProgram.Text = "BSIT";
                litYearLevel.Text = "3rd Year";
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
                string branch = litCampusBranch.Text;
                string dept = litDepartment.Text;
                string prog = litProgram.Text;
                int year = 3;

                List<EventModel> events = _eventRepo.GetEventsForStudent(branch, dept, prog, year);

                if (events == null || events.Count == 0)
                {
                    events = _eventRepo.GetAllUpcomingEvents();
                }

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

                        // Ensure demo sponsors if none registered in DB
                        if (vm.Sponsors.Count == 0)
                        {
                            vm.Sponsors = new List<string> { "AWS", "Microsoft", "LESIT" };
                        }

                        vm.SponsorBadgesHtml = BuildSponsorBadgesHtml(vm.Sponsors);
                        viewModels.Add(vm);
                    }
                }
            }
            catch
            {
                // Database query unavailable - fallback to demonstrative data
            }

            // Zero Blank-Screen Guarantee: Bind wireframe demo cards if DB is empty
            if (viewModels.Count == 0)
            {
                viewModels = GetDemonstrationEvents();
            }

            rptEventCards.DataSource = viewModels;
            rptEventCards.DataBind();

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
                foreach (var vm in viewModels.Take(4))
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

            if (slidesList.Count < 4)
            {
                var fallbackPresets = new[]
                {
                    new {
                        id = 0,
                        title = "Cybersecurity and AI Convention",
                        description = "Flagship cybersecurity conference and defensive hacking competition with enterprise penetration testers and student defense drills.",
                        venue = "QCU Auditorium",
                        date = "Oct 09, 2026",
                        time = "10:00 AM - 03:00 PM",
                        bgUrl = ResolveUrl("~/Frontend/Assets/hero_cyber_ai.jpg"),
                        regUrl = "#events-section"
                    },
                    new {
                        id = 0,
                        title = "AI & Cloud Architecture Workshop",
                        description = "Deep dive into serverless cloud infrastructure, neural network deployments, and production container scaling with industry guest speakers.",
                        venue = "QCU San Bartolome - Tech Lab 3",
                        date = "Oct 09, 2026",
                        time = "10:00 AM - 03:00 PM",
                        bgUrl = ResolveUrl("~/Frontend/Assets/hero_cloud_lab.jpg"),
                        regUrl = "#events-section"
                    },
                    new {
                        id = 0,
                        title = "Tech & Innovation Summit",
                        description = "Annual academic showcase bringing together university students and tech sponsors for student capstone demonstrations and keynote sessions.",
                        venue = "QCU Main Campus - University Hall",
                        date = "Nov 12, 2026",
                        time = "08:30 AM - 04:30 PM",
                        bgUrl = ResolveUrl("~/Frontend/Assets/campus-clean.jpg"),
                        regUrl = "#events-section"
                    },
                    new {
                        id = 0,
                        title = "Grand Org Fair & SportsFest",
                        description = "Campus-wide student organization recruitment showcase, intramural games opening ceremony, and student creative exhibition.",
                        venue = "QCU Main Plaza & Athletic Grounds",
                        date = "Nov 20, 2026",
                        time = "08:00 AM - 06:00 PM",
                        bgUrl = ResolveUrl("~/Frontend/Assets/QCU Background.png"),
                        regUrl = "#events-section"
                    }
                };

                foreach (var fb in fallbackPresets)
                {
                    if (slidesList.Count >= 4) break;
                    slidesList.Add(fb);
                }
            }

            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            HeroSlidesJson = serializer.Serialize(slidesList);
        }

        private EventCardViewModel MapEventToCardViewModel(EventModel ev)
        {
            DateTime now = DateTime.Now;
            bool isOpen = ev.Status == "Upcoming" && now >= ev.RegStart && now <= ev.RegEnd && ev.CurrentRegistrations < ev.MaxCapacity;

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
            bool isUpcoming = string.Equals(model.Status, "Upcoming", StringComparison.OrdinalIgnoreCase);
            bool isBeforeReg = isUpcoming && now < model.RegStart;
            bool isOpen = isUpcoming && now >= model.RegStart && now <= model.RegEnd && model.CurrentRegistrations < model.MaxCapacity;
            bool isFullyBooked = isUpcoming && now >= model.RegStart && now <= model.RegEnd && model.CurrentRegistrations >= model.MaxCapacity;

            model.IsRegistrationOpen = isOpen;

            if (isBeforeReg)
            {
                // Strict rule: Display "SOON" (never "opens soon")
                model.RegStatusBadgeHtml = "<div class=\"card-status-pill card-status-soon\"><span class=\"status-dot-amber\"></span> SOON</div>";
                model.RegSpotsHintHtml = $"<div class=\"spots-left-hint soon\"><svg viewBox=\"0 0 24 24\"><circle cx=\"12\" cy=\"12\" r=\"10\" stroke=\"currentColor\" stroke-width=\"2\" fill=\"none\"></circle><polyline points=\"12 6 12 12 16 14\" stroke=\"currentColor\" stroke-width=\"2\" fill=\"none\"></polyline></svg><span>OPENS {model.RegStart:MMM dd}</span></div>";
            }
            else if (isOpen)
            {
                model.RegStatusBadgeHtml = "<div class=\"card-status-pill\"><span class=\"status-dot-green\"></span> OPEN</div>";
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

        private List<EventCardViewModel> GetDemonstrationEvents()
        {
            var list = new List<EventCardViewModel>
            {
                new EventCardViewModel
                {
                    EventId = 100,
                    Title = "Hackathon Event 2026",
                    Description = "Annual university-wide hackathon, software engineering challenge, and developer showcase.",
                    VenueLocation = "Covered Court",
                    MaxCapacity = 200,
                    CurrentRegistrations = 150,
                    EventStart = new DateTime(2026, 3, 1, 8, 0, 0),
                    EventEnd = new DateTime(2026, 3, 1, 10, 0, 0),
                    RegStart = DateTime.Today.AddDays(-5),
                    RegEnd = DateTime.Today.AddDays(10),
                    Status = "Upcoming",
                    IsRegistrationOpen = true,
                    FormattedSchedule = "March 1, 2026 | 8:00 AM - 10:00 AM",
                    CategoryTag = "Hackathon",
                    CategoryFilterKey = "hackathon",
                    BannerImageUrl = ResolveUrl("~/Frontend/Assets/hero_cyber_ai.jpg"),
                    Sponsors = new List<string> { "QCU Alumni Association", "AWS Educate", "DOST-NCR" },
                    SponsorBadgesHtml = "<span class=\"sponsor-pill\">QCU Alumni Association</span> <span class=\"sponsor-pill\">AWS Educate</span> <span class=\"sponsor-pill\">DOST-NCR</span>"
                },
                new EventCardViewModel
                {
                    EventId = 101,
                    Title = "AI & Cloud Architecture Workshop",
                    Description = "Deep dive into serverless cloud infrastructure, neural network deployments, and production container scaling with industry guest speakers.",
                    VenueLocation = "QCU San Bartolome - Tech Lab 3",
                    MaxCapacity = 50,
                    CurrentRegistrations = 42,
                    EventStart = DateTime.Today.AddDays(7).AddHours(10),
                    EventEnd = DateTime.Today.AddDays(7).AddHours(15),
                    RegStart = DateTime.Today.AddDays(-2),
                    RegEnd = DateTime.Today.AddDays(5),
                    Status = "Upcoming",
                    IsRegistrationOpen = true,
                    FormattedSchedule = "Oct 09, 2026 | 10:00 AM - 03:00 PM",
                    CategoryTag = "Workshop",
                    CategoryFilterKey = "workshop",
                    BannerImageUrl = ResolveUrl("~/Frontend/Assets/hero_cloud_lab.jpg"),
                    Sponsors = new List<string> { "AWS", "Google" },
                    SponsorBadgesHtml = "<span class=\"sponsor-pill\">AWS</span> <span class=\"sponsor-pill\">Google</span>"
                },
                new EventCardViewModel
                {
                    EventId = 102,
                    Title = "National Cybersecurity & Ethical Hacking Forum",
                    Description = "Interactive conference on enterprise penetration testing, offensive security, and student defense competitions.",
                    VenueLocation = "Main Campus - University Gymnasium",
                    MaxCapacity = 100,
                    CurrentRegistrations = 86,
                    EventStart = DateTime.Today.AddDays(12).AddHours(9),
                    EventEnd = DateTime.Today.AddDays(12).AddHours(16),
                    RegStart = DateTime.Today.AddDays(-3),
                    RegEnd = DateTime.Today.AddDays(9),
                    Status = "Upcoming",
                    IsRegistrationOpen = true,
                    FormattedSchedule = "Oct 24, 2026 | 09:00 AM - 04:00 PM",
                    CategoryTag = "Hackathon",
                    CategoryFilterKey = "hackathon",
                    BannerImageUrl = ResolveUrl("~/Frontend/Assets/hero_cyber_ai.jpg"),
                    Sponsors = new List<string> { "Microsoft", "LESIT" },
                    SponsorBadgesHtml = "<span class=\"sponsor-pill\">Microsoft</span> <span class=\"sponsor-pill\">LESIT</span>"
                },
                new EventCardViewModel
                {
                    EventId = 103,
                    Title = "Annual University Tech & Innovation Summit",
                    Description = "Flagship academic conference bringing together university students and tech sponsors for student capstone demonstrations and keynotes.",
                    VenueLocation = "QCU Main Campus - University Hall",
                    MaxCapacity = 200,
                    CurrentRegistrations = 142,
                    EventStart = DateTime.Today.AddDays(18).AddHours(8),
                    EventEnd = DateTime.Today.AddDays(18).AddHours(17),
                    RegStart = DateTime.Today.AddDays(-5),
                    RegEnd = DateTime.Today.AddDays(14),
                    Status = "Upcoming",
                    IsRegistrationOpen = true,
                    FormattedSchedule = "Nov 12, 2026 | 08:30 AM - 04:30 PM",
                    CategoryTag = "Seminar",
                    CategoryFilterKey = "seminar",
                    BannerImageUrl = ResolveUrl("~/Frontend/Assets/campus-clean.jpg"),
                    Sponsors = new List<string> { "AWS", "Microsoft" },
                    SponsorBadgesHtml = "<span class=\"sponsor-pill\">AWS</span> <span class=\"sponsor-pill\">Microsoft</span>"
                },
                new EventCardViewModel
                {
                    EventId = 104,
                    Title = "Campus Grand Org Fair & SportsFest Kickoff",
                    Description = "Annual student organization recruitment showcase, intramural games opening ceremony, and campus-wide creative exhibition.",
                    VenueLocation = "QCU Main Plaza & Athletic Grounds",
                    MaxCapacity = 350,
                    CurrentRegistrations = 210,
                    EventStart = DateTime.Today.AddDays(25).AddHours(8),
                    EventEnd = DateTime.Today.AddDays(25).AddHours(18),
                    RegStart = DateTime.Today.AddDays(3),
                    RegEnd = DateTime.Today.AddDays(20),
                    Status = "Upcoming",
                    IsRegistrationOpen = false,
                    FormattedSchedule = "Nov 20, 2026 | 08:00 AM - 06:00 PM",
                    CategoryTag = "SportsFest",
                    CategoryFilterKey = "sportsfest",
                    BannerImageUrl = ResolveUrl("~/Frontend/Assets/QCU Background.png"),
                    Sponsors = new List<string> { "Red Bull", "Smart", "GCash" },
                    SponsorBadgesHtml = "<span class=\"sponsor-pill\">Red Bull</span> <span class=\"sponsor-pill\">Smart</span> <span class=\"sponsor-pill\">GCash</span>"
                }
            };

            foreach (var item in list)
            {
                PopulateRegistrationPresentation(item);
            }

            return list;
        }

        #endregion

        #region Student Registrations

        private void LoadStudentRegistrations()
        {
            string studentId = litStudentId.Text;
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

                        string badgeHtml = "<div class=\"card-status-pill\"><span class=\"status-dot-green\"></span> CONFIRMED PASS</div>";
                        if (string.Equals(reg.Status, "Present", StringComparison.OrdinalIgnoreCase))
                        {
                            badgeHtml = "<div class=\"card-status-pill\"><span class=\"status-dot-green\"></span> ATTENDED</div>";
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
                            EventPhotoPath = reg.EventPhotoPath,
                            BannerImageUrl = !string.IsNullOrWhiteSpace(reg.EventPhotoPath) ? ResolveUrl(reg.EventPhotoPath) : ResolveUrl("~/Frontend/Assets/campus-clean.jpg")
                        });
                    }
                }
            }
            catch
            {
                // Fallback for demonstration
            }

            if (list.Count == 0 && pnlPreviewBanner.Visible)
            {
                // Mock registered event in preview mode
                DateTime demoDate = DateTime.Today.AddDays(7);
                list.Add(new StudentRegistrationViewModel
                {
                    EventRegistrationId = 501,
                    EventId = 101,
                    EventTitle = "AI & Cloud Architecture Workshop",
                    VenueLocation = "QCU San Bartolome - Tech Lab 3",
                    EventDateFormatted = $"{demoDate:MMM dd, yyyy} • 10:00 AM",
                    FormattedDate = demoDate.ToString("MMM dd, yyyy"),
                    FormattedTime = "10:00 AM - 03:00 PM",
                    Status = "NoShow", // Default status per business rule #1
                    RegStatusBadgeHtml = "<div class=\"card-status-pill\"><span class=\"status-dot-green\"></span> CONFIRMED PASS</div>",
                    PassIdChipText = "PASS #501",
                    SponsorBadgesHtml = "<span class=\"sponsor-pill\">OFFICIAL PASS</span>",
                    CanCancel = true, // Active registration period
                    BannerImageUrl = ResolveUrl("~/Frontend/Assets/hero_cloud_lab.jpg")
                });
            }

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
                return "<span class=\"status-badge-reg status-badge-present\">● PRESENT</span>";
            }
            else if (string.Equals(status, "Cancelled", StringComparison.OrdinalIgnoreCase))
            {
                return "<span class=\"status-badge-reg status-badge-cancelled\">✕ CANCELLED</span>";
            }
            else
            {
                // Default: NoShow
                return "<span class=\"status-badge-reg status-badge-noshow\">● REGISTERED (NOSHOW)</span>";
            }
        }

        public string GetStatusBadgeCss(string status)
        {
            if (string.Equals(status, "Present", StringComparison.OrdinalIgnoreCase)) return "status-badge-present";
            if (string.Equals(status, "Cancelled", StringComparison.OrdinalIgnoreCase)) return "status-badge-cancelled";
            return "status-badge-noshow";
        }

        #endregion

        #region Event Handlers & Modal Interactions

        protected void rptEventCards_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int eventId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"~/Frontend/User/EventRegistration.aspx?eventId={eventId}", true);
            }
        }

        private void ShowEventDetailsModal(int eventId)
        {
            hfSelectedEventId.Value = eventId.ToString();

            // Try loading from repository
            EventModel ev = null;
            try
            {
                ev = _eventRepo.GetEventById(eventId);
            }
            catch
            {
                // DB not reachable
            }

            if (ev != null)
            {
                litModalTitle.Text = Server.HtmlEncode(ev.Title);
                litModalDescription.Text = Server.HtmlEncode(string.IsNullOrEmpty(ev.Description) ? "Comprehensive campus event organized for academic and technical development." : ev.Description);
                litModalVenue.Text = Server.HtmlEncode(ev.VenueLocation);
                litModalSchedule.Text = $"{ev.EventStart:MMM dd, yyyy} | {ev.EventStart:hh:mm tt} - {ev.EventEnd:hh:mm tt}";
                litModalCapacity.Text = $"{ev.CurrentRegistrations} / {ev.MaxCapacity} ({ev.RemainingCapacity} slots remaining)";
                litModalRegPeriod.Text = $"{ev.RegStart:MMM dd} - {ev.RegEnd:MMM dd, yyyy}";

                List<string> sponsorNames = new List<string>();
                try
                {
                    var sponsors = _sponsorRepo.GetSponsorsByEventId(eventId);
                    if (sponsors != null && sponsors.Count > 0)
                    {
                        sponsorNames = sponsors.Select(s => s.SponsorName).ToList();
                    }
                }
                catch { }

                if (sponsorNames.Count == 0)
                {
                    sponsorNames = new List<string> { "AWS", "Microsoft", "LESIT" };
                }

                litModalSponsors.Text = BuildSponsorBadgesHtml(sponsorNames);

                DateTime now = DateTime.Now;
                bool isUpcoming = string.Equals(ev.Status, "Upcoming", StringComparison.OrdinalIgnoreCase);
                bool isBeforeReg = isUpcoming && now < ev.RegStart;
                bool isOpen = isUpcoming && now >= ev.RegStart && now <= ev.RegEnd && ev.CurrentRegistrations < ev.MaxCapacity;
                bool isFullyBooked = isUpcoming && now >= ev.RegStart && now <= ev.RegEnd && ev.CurrentRegistrations >= ev.MaxCapacity;

                if (isBeforeReg)
                {
                    btnConfirmRegistration.Enabled = false;
                    btnConfirmRegistration.Text = $"Registration Opens on {ev.RegStart:MMM dd, h:mm tt}";
                }
                else if (isOpen)
                {
                    btnConfirmRegistration.Enabled = true;
                    btnConfirmRegistration.Text = "Register For Event";
                }
                else if (isFullyBooked)
                {
                    btnConfirmRegistration.Enabled = false;
                    btnConfirmRegistration.Text = "Fully Booked";
                }
                else
                {
                    btnConfirmRegistration.Enabled = false;
                    btnConfirmRegistration.Text = "Registration Closed";
                }
            }
            else
            {
                // Fallback demo matching wireframe
                var demo = GetDemonstrationEvents().FirstOrDefault(x => x.EventId == eventId) ?? GetDemonstrationEvents()[0];

                litModalTitle.Text = Server.HtmlEncode(demo.Title);
                litModalDescription.Text = Server.HtmlEncode(demo.Description);
                litModalVenue.Text = Server.HtmlEncode(demo.VenueLocation);
                litModalSchedule.Text = demo.FormattedSchedule;
                litModalCapacity.Text = $"{demo.CurrentRegistrations} / {demo.MaxCapacity} ({demo.MaxCapacity - demo.CurrentRegistrations} slots remaining)";
                litModalRegPeriod.Text = $"{demo.RegStart:MMM dd} - {demo.RegEnd:MMM dd, yyyy}";
                litModalSponsors.Text = demo.SponsorBadgesHtml;

                DateTime now = DateTime.Now;
                bool isUpcoming = string.Equals(demo.Status, "Upcoming", StringComparison.OrdinalIgnoreCase);
                bool isBeforeReg = isUpcoming && now < demo.RegStart;
                bool isOpen = isUpcoming && now >= demo.RegStart && now <= demo.RegEnd && demo.CurrentRegistrations < demo.MaxCapacity;
                bool isFullyBooked = isUpcoming && now >= demo.RegStart && now <= demo.RegEnd && demo.CurrentRegistrations >= demo.MaxCapacity;

                if (isBeforeReg)
                {
                    btnConfirmRegistration.Enabled = false;
                    btnConfirmRegistration.Text = $"Registration Opens on {demo.RegStart:MMM dd, h:mm tt}";
                }
                else if (isOpen)
                {
                    btnConfirmRegistration.Enabled = true;
                    btnConfirmRegistration.Text = "Register For Event";
                }
                else if (isFullyBooked)
                {
                    btnConfirmRegistration.Enabled = false;
                    btnConfirmRegistration.Text = "Fully Booked";
                }
                else
                {
                    btnConfirmRegistration.Enabled = false;
                    btnConfirmRegistration.Text = "Registration Closed";
                }
            }

            pnlModalDetails.Visible = true;
            pnlModalDetails.CssClass = "modal-overlay active";
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlModalDetails.Visible = false;
            pnlModalDetails.CssClass = "modal-overlay";
        }

        protected void btnConfirmRegistration_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfSelectedEventId.Value, out int eventId) && eventId > 0)
            {
                Response.Redirect($"~/Frontend/User/EventRegistration.aspx?eventId={eventId}", true);
            }
        }

        protected void rptMyRegistrations_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "CancelRegistration")
            {
                int regId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    bool cancelled = _regRepo.CancelRegistration(regId);
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
                    // Simulated success in preview mode
                    ShowToast("Registration cancelled in preview mode. Slot reopened for other students.", true);
                }

                LoadEventsCatalog();
                LoadStudentRegistrations();
            }
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
