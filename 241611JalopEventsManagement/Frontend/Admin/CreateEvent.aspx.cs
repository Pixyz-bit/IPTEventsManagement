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
    public partial class CreateEvent : Page
    {
        private readonly EventRepository _eventRepository = new EventRepository();
        private readonly SponsorRepository _sponsorRepository = new SponsorRepository();

        private List<string> Sponsors
        {
            get
            {
                if (ViewState["SponsorList"] == null)
                {
                    ViewState["SponsorList"] = new List<string>();
                }
                return (List<string>)ViewState["SponsorList"];
            }
            set => ViewState["SponsorList"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeFormDefaults();
                BindSponsors();
                UpdatePreviewCard();
            }
        }

        private void InitializeFormDefaults()
        {
            DateTime now = DateTime.Now;
            DateTime defaultEventDate = now.AddDays(7).Date;

            // Suggested Default Event Schedule: 7 days out, 09:00 - 17:00
            DateTime defaultEventStart = defaultEventDate.AddHours(9);
            DateTime defaultEventEnd = defaultEventDate.AddHours(17);

            // Suggested Default Registration Window: Today to 1 day prior to kickoff
            DateTime defaultRegStart = now;
            DateTime defaultRegEnd = defaultEventDate.AddDays(-1).AddHours(23).AddMinutes(59);

            txtEventStart.Text = defaultEventStart.ToString("yyyy-MM-ddTHH:mm");
            txtEventEnd.Text = defaultEventEnd.ToString("yyyy-MM-ddTHH:mm");
            txtRegStart.Text = defaultRegStart.ToString("yyyy-MM-ddTHH:mm");
            txtRegEnd.Text = defaultRegEnd.ToString("yyyy-MM-ddTHH:mm");

            // Seed sample partner associations for rapid staging
            Sponsors = new List<string>
            {
                "QCU Alumni Association",
                "AWS Educate"
            };
        }

        private void BindSponsors()
        {
            rptSponsors.DataSource = Sponsors;
            rptSponsors.DataBind();

            litNoSponsorsHint.Visible = (Sponsors == null || Sponsors.Count == 0);
            litPreviewSponsorCount.Text = $"{Sponsors?.Count ?? 0} Partners";
        }

        protected void FormField_Changed(object sender, EventArgs e)
        {
            UpdatePreviewCard();
        }

        private void UpdatePreviewCard()
        {
            litPreviewTitle.Text = string.IsNullOrWhiteSpace(txtTitle.Text)
                ? "Event Title Preview"
                : Server.HtmlEncode(txtTitle.Text.Trim());

            litPreviewVenue.Text = string.IsNullOrWhiteSpace(txtVenueLocation.Text)
                ? "Central Auditorium, Hall A"
                : Server.HtmlEncode(txtVenueLocation.Text.Trim());

            litPreviewCapacity.Text = string.IsNullOrWhiteSpace(txtMaxCapacity.Text)
                ? "150 seats"
                : $"{txtMaxCapacity.Text.Trim()} seats";

            litPreviewBranch.Text = string.IsNullOrWhiteSpace(ddlBranch.SelectedValue)
                ? "All Branches"
                : ddlBranch.SelectedItem.Text;

            litPreviewDept.Text = string.IsNullOrWhiteSpace(ddlDepartment.SelectedValue)
                ? "All Colleges"
                : ddlDepartment.SelectedItem.Text;

            litPreviewSponsorCount.Text = $"{Sponsors?.Count ?? 0} Partners";
        }

        protected void btnAddSponsor_Click(object sender, EventArgs e)
        {
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
                hfActiveStep.Value = "4";
                BindSponsors();
            }
        }

        protected void PresetSponsor_Click(object sender, EventArgs e)
        {
            if (sender is LinkButton btn && !string.IsNullOrWhiteSpace(btn.CommandArgument))
            {
                string sponsorName = btn.CommandArgument.Trim();
                var list = Sponsors;
                if (!list.Any(s => s.Equals(sponsorName, StringComparison.OrdinalIgnoreCase)))
                {
                    list.Add(sponsorName);
                    Sponsors = list;
                }
                hfActiveStep.Value = "4";
                BindSponsors();
            }
        }

        protected void rptSponsors_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Remove" && e.CommandArgument != null)
            {
                string target = e.CommandArgument.ToString();
                var list = Sponsors;
                list.RemoveAll(s => s.Equals(target, StringComparison.OrdinalIgnoreCase));
                Sponsors = list;
                hfActiveStep.Value = "4";
                BindSponsors();
            }
        }

        protected void btnPublishEvent_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;

            // 1. Validate Form Fields
            string title = txtTitle.Text.Trim();
            if (string.IsNullOrWhiteSpace(title))
            {
                hfActiveStep.Value = "1";
                ShowError("Event Title is required.");
                txtTitle.Focus();
                return;
            }

            string venue = txtVenueLocation.Text.Trim();
            if (string.IsNullOrWhiteSpace(venue))
            {
                hfActiveStep.Value = "1";
                ShowError("Venue / Room Location is required.");
                txtVenueLocation.Focus();
                return;
            }

            if (!int.TryParse(txtMaxCapacity.Text.Trim(), out int capacity) || capacity <= 0)
            {
                hfActiveStep.Value = "1";
                ShowError("Max Capacity must be a positive integer greater than zero.");
                txtMaxCapacity.Focus();
                return;
            }

            if (!DateTime.TryParse(txtEventStart.Text, out DateTime eventStart))
            {
                hfActiveStep.Value = "2";
                ShowError("Please provide a valid Event Start Date & Time.");
                txtEventStart.Focus();
                return;
            }

            if (!DateTime.TryParse(txtEventEnd.Text, out DateTime eventEnd))
            {
                hfActiveStep.Value = "2";
                ShowError("Please provide a valid Event End Date & Time.");
                txtEventEnd.Focus();
                return;
            }

            if (!DateTime.TryParse(txtRegStart.Text, out DateTime regStart))
            {
                hfActiveStep.Value = "2";
                ShowError("Please provide a valid Registration Opening Date & Time.");
                txtRegStart.Focus();
                return;
            }

            if (!DateTime.TryParse(txtRegEnd.Text, out DateTime regEnd))
            {
                hfActiveStep.Value = "2";
                ShowError("Please provide a valid Registration Deadline.");
                txtRegEnd.Focus();
                return;
            }

            // Domain Rule Validations
            if (regStart >= regEnd)
            {
                hfActiveStep.Value = "2";
                ShowError("Registration Open time must be earlier than Registration Deadline.");
                return;
            }

            if (eventStart >= eventEnd)
            {
                hfActiveStep.Value = "2";
                ShowError("Event Start time must be earlier than Event End time.");
                return;
            }

            if (regEnd > eventStart)
            {
                hfActiveStep.Value = "2";
                ShowError("Registration Deadline must conclude before or at the Event Start time.");
                return;
            }

            // 2. Build Event Domain Model
            int adminUserId = SessionHelper.CurrentUserId > 0 ? SessionHelper.CurrentUserId : 1;

            var newEvent = new EventModel
            {
                Title = title,
                Description = txtDescription.Text.Trim(),
                VenueLocation = venue,
                MaxCapacity = capacity,
                CurrentRegistrations = 0,
                CreatedByUserId = adminUserId,
                EventStart = eventStart,
                EventEnd = eventEnd,
                RegStart = regStart,
                RegEnd = regEnd,
                Status = "Upcoming",
                CancellationReason = null,
                TargetBranch = string.IsNullOrWhiteSpace(ddlBranch.SelectedValue) ? null : ddlBranch.SelectedValue,
                TargetDepartment = string.IsNullOrWhiteSpace(ddlDepartment.SelectedValue) ? null : ddlDepartment.SelectedValue,
                TargetProgram = string.IsNullOrWhiteSpace(ddlProgram.SelectedValue) ? null : ddlProgram.SelectedValue,
                TargetYearLevel = int.TryParse(ddlYearLevel.SelectedValue, out int yl) ? (int?)yl : null
            };

            try
            {
                // 3. Persist Event
                int generatedEventId = _eventRepository.CreateEvent(newEvent);

                // 4. Attach Multi-Sponsor Associations
                if (Sponsors != null && Sponsors.Count > 0)
                {
                    _sponsorRepository.AddSponsors(generatedEventId, Sponsors);
                }

                // 5. Success Feedback
                litSuccessMsg.Text = $"<strong>Success!</strong> Event <em>&ldquo;{Server.HtmlEncode(title)}&rdquo;</em> (ID #{generatedEventId}) was published successfully to the Campus Events Matrix with {Sponsors?.Count ?? 0} attached partner sponsors.";
                pnlSuccess.Visible = true;

                // Reset form fields
                txtTitle.Text = string.Empty;
                txtDescription.Text = string.Empty;
                txtVenueLocation.Text = string.Empty;
                txtMaxCapacity.Text = "150";
                InitializeFormDefaults();
                UpdatePreviewCard();
            }
            catch (Exception ex)
            {
                ShowError($"Unable to publish event to database: {ex.Message}");
            }
        }

        private void ShowError(string message)
        {
            litErrorMsg.Text = $"<strong>Action Failed:</strong> {message}";
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
        }
    }
}
