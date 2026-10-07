using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class EventDetails : _241611JalopEventsManagement.Backend.Helpers.AdminPage
    {
        private readonly EventRepository _eventRepository = new EventRepository();
        private readonly SponsorRepository _sponsorRepository = new SponsorRepository();
        private readonly RegistrationRepository _registrationRepository = new RegistrationRepository();
        private bool _eventAvailable;

        public int CurrentEventId
        {
            get
            {
                string idParam = Request.QueryString["eventId"] ?? Request.QueryString["id"];
                if (int.TryParse(idParam, out int id) && id > 0)
                {
                    return id;
                }

                return 0;
            }
        }

        public bool IsEditMode
        {
            get => (ViewState["IsEditMode"] as bool?) ?? false;
            set => ViewState["IsEditMode"] = value;
        }

        public string HeaderStatusBadgeClass
        {
            get
            {
                string status = litHeaderStatus.Text?.Trim().ToLowerInvariant() ?? "upcoming";
                if (status == "open") return "status-open";
                if (status == "soon") return "status-soon";
                if (status == "close" || status == "closed") return "status-close";
                if (status == "cancelled") return "status-cancelled";
                return "status-soon";
            }
        }

        public int OccupancyBarWidth
        {
            get
            {
                if (ViewState["OccupancyBarWidth"] != null)
                {
                    return (int)ViewState["OccupancyBarWidth"];
                }
                return 0;
            }
            set => ViewState["OccupancyBarWidth"] = Math.Max(0, Math.Min(100, value));
        }

        private List<string> Sponsors
        {
            get
            {
                if (ViewState["SponsorsList"] == null)
                {
                    ViewState["SponsorsList"] = new List<string>();
                }
                return (List<string>)ViewState["SponsorsList"];
            }
            set => ViewState["SponsorsList"] = value;
        }

        public string RegistrationTimeZoneLabel => RegistrationDateTime.TimeZoneLabel;

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            EventCollegeOptions.Bind(ddlDepartment);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Validate on every request, including postbacks from a stale details/edit page.
            EventModel ev;
            if (!TryLoadEvent(out ev)) return;
            if (!IsPostBack)
            {
                PopulateEventDropdown();
                BindEventData(ev);
                UpdateModeUI();
            }
        }

        private void PopulateEventDropdown()
        {
            var events = _eventRepository.GetAllEvents().OrderByDescending(ev => ev.EventStart).ToList();
            ddlEvents.Items.Clear();

            foreach (var evt in events)
            {
                string dateText = evt.EventStart.ToString("MM/dd/yyyy");
                string itemText = $"{evt.Title} ({dateText})";
                ddlEvents.Items.Add(new ListItem(itemText, evt.EventId.ToString()));
            }

            if (ddlEvents.Items.FindByValue(CurrentEventId.ToString()) != null)
            {
                ddlEvents.SelectedValue = CurrentEventId.ToString();
            }
            else if (ddlEvents.Items.Count > 0)
            {
                ddlEvents.SelectedIndex = 0;
            }
        }

        protected void ddlEvents_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!_eventAvailable) return;
            if (int.TryParse(ddlEvents.SelectedValue, out int selectedId))
            {
                Response.Redirect($"~/Frontend/Admin/EventDetails.aspx?eventId={selectedId}");
            }
        }

        private void LoadEventData()
        {
            EventModel ev;
            if (TryLoadEvent(out ev)) BindEventData(ev);
        }

        private bool TryLoadEvent(out EventModel ev)
        {
            ev = null;
            try
            {
                if (CurrentEventId > 0)
                {
                    ev = _eventRepository.GetEventById(CurrentEventId);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Loading event details failed: {0}", ex);
                ShowUnavailable("Unable to load event", "Event records are temporarily unavailable. Please refresh this page or return to the Events Matrix.", 503);
                return false;
            }

            if (ev == null)
            {
                ShowUnavailable("Event not found", "The requested event does not exist or is no longer available. Return to the Events Matrix to choose an event.", 404);
                return false;
            }

            _eventAvailable = true;
            phEventContent.Visible = true;
            pnlUnavailable.Visible = false;
            return true;
        }

        private void ShowUnavailable(string title, string message, int statusCode)
        {
            _eventAvailable = false;
            IsEditMode = false;
            phEventContent.Visible = false;
            pnlUnavailable.Visible = true;
            litUnavailableTitle.Text = Server.HtmlEncode(title);
            litUnavailableMessage.Text = Server.HtmlEncode(message);
            Page.Title = title + " | QCU Admin";
            Response.StatusCode = statusCode;
            Response.TrySkipIisCustomErrors = true;
        }

        private void BindEventData(EventModel ev)
        {

            // Header Elements & Chips
            litHeaderEventId.Text = $"EVENT #{ev.EventId}";
            litHeaderTitle.Text = Server.HtmlEncode(ev.Title);
            litEventDate.Text = ev.EventStart.ToString("MM/dd/yyyy");
            litEventVenue.Text = Server.HtmlEncode(ev.VenueLocation);
            litEventCapacitySummary.Text = $"{ev.CurrentRegistrations} / {ev.MaxCapacity}";
            string matrixStatus = EvaluateMatrixStatus(ev);
            litHeaderStatus.Text = matrixStatus;
            litSidebarStatus.Text = matrixStatus;
            litMetaEventId.Text = ev.EventId.ToString();

            lnkCancelEvent.Visible = ev.CanCancel;
            lnkCancelEvent.NavigateUrl = "~/Frontend/Admin/AdminEvents.aspx?cancelEventId=" + ev.EventId;
            btnToggleEdit.Enabled = string.Equals(ev.Status, "Upcoming", StringComparison.OrdinalIgnoreCase);
            pnlCancelledNotice.Visible = ev.IsCancelled;
            litCancellationReason.Text = Server.HtmlEncode(ev.CancellationReason ?? "No reason recorded.");
            // Section 1: General Info (View)
            litTitleView.Text = Server.HtmlEncode(ev.Title);
            litVenueView.Text = Server.HtmlEncode(ev.VenueLocation);
            litCapacityView.Text = ev.MaxCapacity.ToString();
            litDescView.Text = string.IsNullOrWhiteSpace(ev.Description)
                ? "<em style='color:#94a3b8;'>No description provided for this campus event.</em>"
                : Server.HtmlEncode(ev.Description);

            // Section 1: General Info (Edit Form)
            txtTitle.Text = ev.Title;
            txtVenueLocation.Text = ev.VenueLocation;
            txtMaxCapacity.Text = ev.MaxCapacity.ToString();
            txtDescription.Text = ev.Description ?? string.Empty;

            // Section 2: Schedule & Lifecycle (Strict MM/dd/yyyy format)
            litEventDateView.Text = ev.EventStart.ToString("MM/dd/yyyy");
            litEventHoursView.Text = $"{ev.EventStart:hh:mm tt} — {ev.EventEnd:hh:mm tt}";
            litRegStartView.Text = RegistrationDateTime.ToDisplay(ev.RegStart);
            litRegEndView.Text = RegistrationDateTime.ToDisplay(ev.RegEnd);

            txtEventDate.Text = ev.EventStart.ToString("yyyy-MM-dd");
            txtStartTime.Text = ev.EventStart.ToString("HH:mm");
            txtEndTime.Text = ev.EventEnd.ToString("HH:mm");
            txtRegStart.Text = RegistrationDateTime.ToInput(ev.RegStart);
            txtRegEnd.Text = RegistrationDateTime.ToInput(ev.RegEnd);

            // Section 3: Dual-Ratio Banners
            if (!string.IsNullOrWhiteSpace(ev.EventPhotoPath))
            {
                imgWideBanner.ImageUrl = ResolveUrl(ev.EventPhotoPath);
                imgSquareBanner.ImageUrl = ResolveUrl(ev.EventPhotoPath);
            }
            else
            {
                imgWideBanner.ImageUrl = ResolveUrl("~/Frontend/Assets/campus-clean.jpg");
                imgSquareBanner.ImageUrl = ResolveUrl("~/Frontend/Assets/hero_cloud_lab.jpg");
            }

            // Section 4: Target Demographics
            litBranchView.Text = string.IsNullOrWhiteSpace(ev.TargetBranch) ? "All University Branches (Open to All)" : Server.HtmlEncode(ev.TargetBranch);
            litDeptView.Text = string.IsNullOrWhiteSpace(ev.TargetDepartment) ? "All Academic Colleges (Open to All)" : Server.HtmlEncode(ev.TargetDepartment);
            litYearLevelView.Text = ev.TargetYearLevel.HasValue ? $"{ev.TargetYearLevel.Value} Year Standing Only" : "All Year Standings (1st - 4th)";

            if (!string.IsNullOrWhiteSpace(ev.TargetProgram))
            {
                var progs = ev.TargetProgram.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(p => p.Trim());
                litProgramsChips.Text = string.Join(" ", progs.Select(p => $"<span class='badge-chip'>{Server.HtmlEncode(p)}</span>"));
                txtPrograms.Text = ev.TargetProgram;
            }
            else
            {
                litProgramsChips.Text = "<span style='color:#64748b; font-size:0.8rem; font-style:italic;'>All Degree Programs (Open to all majors)</span>";
                txtPrograms.Text = string.Empty;
            }

            if (ddlBranch.Items.FindByValue(ev.TargetBranch ?? string.Empty) != null)
                ddlBranch.SelectedValue = ev.TargetBranch ?? string.Empty;

            if (ddlDepartment.Items.FindByValue(ev.TargetDepartment ?? string.Empty) != null)
                ddlDepartment.SelectedValue = ev.TargetDepartment ?? string.Empty;

            if (ev.TargetYearLevel.HasValue && ddlYearLevel.Items.FindByValue(ev.TargetYearLevel.Value.ToString()) != null)
                ddlYearLevel.SelectedValue = ev.TargetYearLevel.Value.ToString();
            else
                ddlYearLevel.SelectedIndex = 0;

            // Section 5: Sponsors
            LoadSponsors(ev.EventId);

            // Fetch live attendance data via RegistrationRepository
            RegistrationRepository.EventAttendanceSummary attendanceSummary = null;
            if (ev.EventId > 0)
            {
                try
                {
                    attendanceSummary = _registrationRepository.GetEventAttendanceSummary(ev.EventId);
                }
                catch
                {
                    // Fallback to model values
                }
            }

            int totalReg = (attendanceSummary != null && attendanceSummary.TotalRegistered > 0)
                ? attendanceSummary.TotalRegistered
                : Math.Max(0, ev.CurrentRegistrations);

            int maxCap = Math.Max(1, ev.MaxCapacity);

            // Gate Occupancy & Quota cockpit calculations
            double occupancy = maxCap > 0 ? ((double)totalReg / maxCap) * 100.0 : 0.0;
            OccupancyBarWidth = (int)Math.Max(0, Math.Min(100, Math.Round(occupancy)));
            litOccupancyCount.Text = $"{totalReg} / {maxCap}";
            litOccupancyPct.Text = $"{occupancy:F1}%";
            int remSpots = Math.Max(0, maxCap - totalReg);
            litRemainingSpots.Text = remSpots == 0 ? "Capacity Saturated" : $"{remSpots} spots open";
        }

        private void LoadSponsors(int eventId)
        {
            List<string> sponsorNames = new List<string>();

            if (eventId > 0)
            {
                try
                {
                    var spList = _sponsorRepository.GetSponsorsByEventId(eventId);
                    if (spList != null && spList.Count > 0)
                    {
                        sponsorNames = spList.Select(s => s.SponsorName).ToList();
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Loading event sponsors failed: {0}", ex);
                    ShowUnavailable("Unable to load sponsors", "Sponsor records are temporarily unavailable. Please refresh before editing this event.", 503);
                    throw new System.Web.HttpException(503, "Sponsor records are temporarily unavailable.");
                }
            }

            Sponsors = sponsorNames;
            BindSponsorsRepeater();
        }

        private void BindSponsorsRepeater()
        {
            rptSponsors.DataSource = Sponsors;
            rptSponsors.DataBind();

            litNoSponsors.Visible = (Sponsors == null || Sponsors.Count == 0);
            litMetaSponsorCount.Text = (Sponsors?.Count ?? 0).ToString();
        }

        private void UpdateModeUI()
        {
            if (!_eventAvailable) return;
            bool editing = IsEditMode;

            // Visibility Toggles
            phViewActions.Visible = !editing;
            phEditActions.Visible = editing;

            phGeneralView.Visible = !editing;
            phGeneralEdit.Visible = editing;

            phScheduleView.Visible = !editing;
            phScheduleEdit.Visible = editing;

            phWideUpload.Visible = editing;
            phSquareUpload.Visible = editing;

            phDemographicsView.Visible = !editing;
            phDemographicsEdit.Visible = editing;

            phAddSponsor.Visible = editing;

            litModeDescription.Text = editing
                ? "Authoritative Event Configuration &bull; Inline Edit Mode Active"
                : "Authoritative Event Configuration &bull; Read-Only Mode";

            BindSponsorsRepeater();
        }

        protected void btnToggleEdit_Click(object sender, EventArgs e)
        {
            if (!_eventAvailable) return;
            EventModel current = _eventRepository.GetEventById(CurrentEventId);
            if (current == null || current.Status != "Upcoming")
            {
                ShowError("This event is inactive and cannot be edited.");
                return;
            }
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
            IsEditMode = true;
            UpdateModeUI();
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            if (!_eventAvailable) return;
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
            IsEditMode = false;
            LoadEventData();
            UpdateModeUI();
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            if (!_eventAvailable) return;
            pnlError.Visible = false;
            pnlSuccess.Visible = false;

            // 1. Validate General Info
            string title = txtTitle.Text.Trim();
            if (string.IsNullOrWhiteSpace(title))
            {
                ShowError("Event Title is required.");
                txtTitle.Focus();
                return;
            }

            string venue = txtVenueLocation.Text.Trim();
            if (string.IsNullOrWhiteSpace(venue))
            {
                ShowError("Physical Venue / Room Location is required.");
                txtVenueLocation.Focus();
                return;
            }

            if (!int.TryParse(txtMaxCapacity.Text.Trim(), out int capacity) || capacity <= 0)
            {
                ShowError("Maximum Seating Capacity must be a positive integer greater than zero.");
                txtMaxCapacity.Focus();
                return;
            }

            // 2. Validate Schedule & Logical Timestamps
            if (!DateTime.TryParse(txtEventDate.Text, out DateTime eventDate))
            {
                ShowError("Please provide a valid Event Date.");
                txtEventDate.Focus();
                return;
            }

            if (!TimeSpan.TryParse(txtStartTime.Text, out TimeSpan startTime))
            {
                ShowError("Please provide a valid Event Start Time (e.g. 09:00).");
                txtStartTime.Focus();
                return;
            }

            if (!TimeSpan.TryParse(txtEndTime.Text, out TimeSpan endTime))
            {
                ShowError("Please provide a valid Event End Time (e.g. 17:00).");
                txtEndTime.Focus();
                return;
            }

            if (startTime >= endTime)
            {
                ShowError("Logical Time Violation: Event Start Time must precede Event End Time.");
                txtStartTime.Focus();
                return;
            }

            DateTime eventStart = eventDate.Date.Add(startTime);
            DateTime eventEnd = eventDate.Date.Add(endTime);

            if (!RegistrationDateTime.TryParse(txtRegStart.Text, out DateTime regStart))
            {
                ShowError("Please provide a valid Registration Opening Date & Time.");
                txtRegStart.Focus();
                return;
            }

            if (!RegistrationDateTime.TryParse(txtRegEnd.Text, out DateTime regEnd))
            {
                ShowError("Please provide a valid Registration Final Deadline.");
                txtRegEnd.Focus();
                return;
            }

            // Domain Rule: Registration Start Date must precede Registration End Date
            if (regStart >= regEnd)
            {
                ShowError("Logical Timestamp Violation: Registration Start Date must precede Registration End Date.");
                txtRegStart.Focus();
                return;
            }

            // Registration dates must both strictly precede the event date, as in creation.
            if (regStart.Date >= eventDate.Date || regEnd.Date >= eventDate.Date)
            {
                ShowError("Registration opening and deadline must both be strictly before the event date.");
                txtRegEnd.Focus();
                return;
            }

            // 3. Build & Persist Updated Model
            try
            {
                EventModel existing = _eventRepository.GetEventById(CurrentEventId);
                if (existing == null || existing.Status != "Upcoming")
                {
                    ShowError("This event is inactive and cannot be edited. Refresh to see its current status.");
                    return;
                }
                int currentRegs = existing?.CurrentRegistrations ?? 0;

                if (capacity < currentRegs)
                {
                    ShowError($"Capacity Adjustment Error: Cannot reduce capacity to {capacity} because {currentRegs} attendees are already registered.");
                    return;
                }

                string photoPath = existing?.EventPhotoPath;

                // Handle Banner Uploads if provided
                if (fuWideBanner != null && fuWideBanner.HasFile)
                {
                    string uploaded = HandleBannerUpload(fuWideBanner, "wide_banner");
                    if (!string.IsNullOrEmpty(uploaded))
                    {
                        photoPath = uploaded;
                    }
                }
                else if (hfEditPhotoBase64 != null && !string.IsNullOrWhiteSpace(hfEditPhotoBase64.Value))
                {
                    string uploaded = HandleBase64BannerUpload(hfEditPhotoBase64.Value, hfEditPhotoFileName.Value, "wide_banner");
                    if (!string.IsNullOrEmpty(uploaded))
                    {
                        photoPath = uploaded;
                    }
                }
                else if (fuSquareBanner != null && fuSquareBanner.HasFile)
                {
                    string uploaded = HandleBannerUpload(fuSquareBanner, "square_banner");
                    if (!string.IsNullOrEmpty(uploaded))
                    {
                        photoPath = uploaded;
                    }
                }

                var updated = new EventModel
                {
                    EventId = CurrentEventId,
                    Title = title,
                    Description = txtDescription.Text.Trim(),
                    VenueLocation = venue,
                    MaxCapacity = capacity,
                    CurrentRegistrations = currentRegs,
                    CreatedByUserId = existing?.CreatedByUserId ?? (SessionHelper.CurrentUserId > 0 ? SessionHelper.CurrentUserId : 1),
                    EventStart = eventStart,
                    EventEnd = eventEnd,
                    RegStart = regStart,
                    RegEnd = regEnd,
                    Status = existing?.Status ?? "Upcoming",
                    CancellationReason = existing?.CancellationReason,
                    TargetBranch = string.IsNullOrWhiteSpace(ddlBranch.SelectedValue) ? null : ddlBranch.SelectedValue,
                    TargetDepartment = string.IsNullOrWhiteSpace(ddlDepartment.SelectedValue) ? null : ddlDepartment.SelectedValue,
                    TargetProgram = string.IsNullOrWhiteSpace(txtPrograms.Text) ? null : txtPrograms.Text.Trim(),
                    TargetYearLevel = int.TryParse(ddlYearLevel.SelectedValue, out int yl) ? (int?)yl : null,
                    EventPhotoPath = photoPath
                };

                bool success = _eventRepository.UpdateEvent(updated);
                if (!success)
                {
                    ShowError("The event was not updated. It may have been cancelled while you were editing. Refresh the page.");
                    return;
                }

                // 4. Update Attached Sponsors
                try
                {
                    _sponsorRepository.DeleteSponsorsByEventId(CurrentEventId);
                    if (Sponsors != null && Sponsors.Count > 0)
                    {
                        _sponsorRepository.AddSponsors(CurrentEventId, Sponsors);
                    }
                }
                catch
                {
                    // Graceful handling for test database setups
                }

                litSuccessMsg.Text = $"<strong>Success!</strong> Event specifications for <em>&ldquo;{Server.HtmlEncode(title)}&rdquo;</em> (Event #{CurrentEventId}) were updated successfully in the authoritative database record.";
                pnlSuccess.Visible = true;
                IsEditMode = false;
                LoadEventData();
                UpdateModeUI();
            }
            catch (Exception ex)
            {
                ShowError($"Failed to update event in database: {ex.Message}");
            }
        }

        private string HandleBannerUpload(FileUpload fu, string prefix)
        {
            if (fu != null && fu.HasFile)
            {
                try
                {
                    string ext = Path.GetExtension(fu.FileName).ToLowerInvariant();
                    if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".webp")
                    {
                        string uploadsDir = Server.MapPath("~/Frontend/Assets/Events/");
                        if (!Directory.Exists(uploadsDir))
                        {
                            Directory.CreateDirectory(uploadsDir);
                        }
                        string fileName = $"{prefix}_{CurrentEventId}_{Guid.NewGuid():N}{ext}";
                        fu.SaveAs(Path.Combine(uploadsDir, fileName));
                        return "~/Frontend/Assets/Events/" + fileName;
                    }
                }
                catch
                {
                    // Fall back cleanly
                }
            }
            return null;
        }

        private string HandleBase64BannerUpload(string base64Data, string originalFileName, string prefix)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(base64Data)) return null;
                int commaIdx = base64Data.IndexOf(',');
                if (commaIdx >= 0)
                {
                    base64Data = base64Data.Substring(commaIdx + 1);
                }
                byte[] imageBytes = Convert.FromBase64String(base64Data);
                string ext = ".jpg";
                if (!string.IsNullOrWhiteSpace(originalFileName))
                {
                    ext = Path.GetExtension(originalFileName).ToLowerInvariant();
                }
                if (string.IsNullOrWhiteSpace(ext)) ext = ".jpg";

                string uploadsDir = Server.MapPath("~/Frontend/Assets/Events/");
                if (!Directory.Exists(uploadsDir))
                {
                    Directory.CreateDirectory(uploadsDir);
                }
                string fileName = $"{prefix}_{CurrentEventId}_{Guid.NewGuid():N}{ext}";
                File.WriteAllBytes(Path.Combine(uploadsDir, fileName), imageBytes);
                return "~/Frontend/Assets/Events/" + fileName;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("HandleBase64BannerUpload error: " + ex.Message);
                return null;
            }
        }

        protected void btnAddSponsor_Click(object sender, EventArgs e)
        {
            if (!_eventAvailable) return;
            string newSponsor = txtNewSponsor.Text.Trim();
            if (!string.IsNullOrWhiteSpace(newSponsor))
            {
                var list = Sponsors;
                if (!list.Any(s => s.Equals(newSponsor, StringComparison.OrdinalIgnoreCase)))
                {
                    list.Add(newSponsor);
                    Sponsors = list;
                }
                txtNewSponsor.Text = string.Empty;
                BindSponsorsRepeater();
            }
        }

        protected void rptSponsors_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!_eventAvailable) return;
            if (e.CommandName == "Remove" && e.CommandArgument != null)
            {
                string target = e.CommandArgument.ToString();
                var list = Sponsors;
                list.RemoveAll(s => s.Equals(target, StringComparison.OrdinalIgnoreCase));
                Sponsors = list;
                BindSponsorsRepeater();
            }
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }

        private void ShowError(string message)
        {
            litErrorMsg.Text = $"<strong>Action Failed:</strong> {message}";
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
        }

        private static string EvaluateMatrixStatus(EventModel ev)
        {
            return AdminEvents.GetEventMatrixStatus(ev);
        }
    }
}
