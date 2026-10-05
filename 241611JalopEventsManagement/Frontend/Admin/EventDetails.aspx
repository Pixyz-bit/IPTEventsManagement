<%@ Page Title="Event Specifications & Configuration | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventDetails.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventDetails" EnableSessionState="ReadOnly" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/event-details.css") %>?v=<%= DateTime.UtcNow.Ticks %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb Global Trail -->
    <nav class="breadcrumb-nav" aria-label="Breadcrumb">
        <ol class="breadcrumb-list">
            <li class="breadcrumb-item">
                <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7" rx="1.5"></rect>
                        <rect x="14" y="3" width="7" height="7" rx="1.5"></rect>
                        <rect x="14" y="14" width="7" height="7" rx="1.5"></rect>
                        <rect x="3" y="14" width="7" height="7" rx="1.5"></rect>
                    </svg>
                    <span>Admin Console</span>
                </a>
            </li>
            <li class="breadcrumb-separator">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </li>
            <li class="breadcrumb-item">
                <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>">
                    <span>Campus Events Matrix</span>
                </a>
            </li>
            <li class="breadcrumb-separator">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                <span>Event Specifications &amp; Details</span>
            </li>
        </ol>
    </nav>

    <!-- Feedback Alerts -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="feedback-alert alert-success">
        <div>
            <asp:Literal ID="litSuccessMsg" runat="server" />
        </div>
        <asp:LinkButton ID="btnCloseSuccess" runat="server" Text="&times;" OnClick="btnCloseAlert_Click" Style="color:inherit; font-size:1.25rem; font-weight:bold; background:none; border:none; cursor:pointer;" CausesValidation="false" />
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="feedback-alert alert-error">
        <div>
            <asp:Literal ID="litErrorMsg" runat="server" />
        </div>
        <asp:LinkButton ID="btnCloseError" runat="server" Text="&times;" OnClick="btnCloseAlert_Click" Style="color:inherit; font-size:1.25rem; font-weight:bold; background:none; border:none; cursor:pointer;" CausesValidation="false" />
    </asp:Panel>

    <asp:Panel ID="pnlDemoNotice" runat="server" Visible="false" CssClass="feedback-alert alert-info">
        <div>
            <strong>Notice:</strong> <asp:Literal ID="litDemoNotice" runat="server" Text="Displaying demonstration event specifications. Select an active event from the Events Matrix to manage live records." />
        </div>
    </asp:Panel>

    <!-- Context Header Banner -->
    <div class="event-context-card">
        <div class="event-context-top">
            <div class="event-title-group">
                <h1>
                    <asp:Literal ID="litHeaderTitle" runat="server" Text="Event Specifications" />
                </h1>
                <div class="event-meta-chips">
                    <span class="meta-chip">
                        <span>Date: <strong><asp:Literal ID="litEventDate" runat="server" Text="--/--/----"></asp:Literal></strong></span>
                    </span>
                    <span class="meta-chip">
                        <span>Venue: <strong><asp:Literal ID="litEventVenue" runat="server" Text="--"></asp:Literal></strong></span>
                    </span>
                    <span class="meta-chip">
                        <span>Capacity: <strong><asp:Literal ID="litEventCapacitySummary" runat="server" Text="0 / 0"></asp:Literal></strong></span>
                    </span>
                </div>
            </div>

            <!-- Event Selector Switcher -->
            <div class="event-switcher">
                <label for="<%= ddlEvents.ClientID %>">Active Event:</label>
                <asp:DropDownList ID="ddlEvents" runat="server" CssClass="event-dropdown-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEvents_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
        </div>

        <!-- Sub-Module Pipeline Progression Tabs -->
        <div class="pipeline-tabs-wrapper">
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventDetails.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item active">
                <span>Event Details</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventPreRegistered.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <span>Pre-Registered</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/AttendanceScanner.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <span>Attendance Scanner</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAttendance.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <span>Event Attendance</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAnalytics.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <span>Event Analytics</span>
            </a>
        </div>
    </div>

    <!-- Hidden State Holders for Legacy References -->
    <asp:PlaceHolder ID="phHeaderHidden" runat="server" Visible="false">
        <asp:Literal ID="litHeaderEventId" runat="server" Text="EVENT #-" />
        <asp:Literal ID="litHeaderStatus" runat="server" Text="Upcoming" />
    </asp:PlaceHolder>

    <!-- Mode Banner & Controller -->
    <div class="mode-banner-bar <%= IsEditMode ? "edit-mode" : "view-mode" %>">
        <div class="mode-status-info">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="16" x2="12" y2="12"></line>
                <line x1="12" y1="8" x2="12.01" y2="8"></line>
            </svg>
            <span>
                <asp:Literal ID="litModeDescription" runat="server" Text="Authoritative Event Configuration &bull; Read-Only Mode" />
            </span>
        </div>
        <div class="mode-actions">
            <asp:PlaceHolder ID="phViewActions" runat="server">
                <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="btn-action-secondary">
                    <span>&larr; Back to Events Matrix</span>
                </a>
                <asp:HyperLink ID="lnkCancelEvent" runat="server" Text="Cancel Event" CssClass="btn-action-secondary" />
                <asp:Button ID="btnToggleEdit" runat="server" Text="Edit Specifications" CssClass="btn-action-primary" OnClick="btnToggleEdit_Click" CausesValidation="false" />
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="phEditActions" runat="server" Visible="false">
                <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel Editing" CssClass="btn-action-secondary" OnClick="btnCancelEdit_Click" CausesValidation="false" />
                <asp:Button ID="btnSaveChanges" runat="server" Text="Save Modifications" CssClass="btn-action-primary" OnClick="btnSaveChanges_Click" />
            </asp:PlaceHolder>
        </div>
    </div>

    <!-- Cancelled Event Notice -->
    <asp:Panel ID="pnlCancelledNotice" runat="server" Visible="false" Style="margin-bottom:1.25rem; padding:0.85rem 1.25rem; background-color:#fef2f2; border:1px solid #fecaca; border-radius:8px; display:flex; align-items:center; gap:0.75rem; color:#991b1b;">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink:0;">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="12" y1="8" x2="12" y2="12"></line>
            <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <span style="font-size:0.875rem; font-weight:600;">
            <strong>Event cancelled.</strong> Registration and check-in are closed. Records are retained. Reason: <asp:Literal ID="litCancellationReason" runat="server" />
        </span>
    </asp:Panel>

    <!-- Main Content Bento Box Grid -->
    <div class="bento-box-layout">
        
        <!-- BENTO ROW 1: CELL 1 (Span 8) - Hero Identity & Visual Media Showcase -->
        <div class="bento-card bento-span-8">
            <div class="bento-card-header">
                <div class="bento-card-title">
                    <span>General Event Overview &amp; Branding</span>
                </div>
                <span class="event-id-tag">SECTION 01</span>
            </div>

            <div class="bento-card-body">
                <!-- Read-Only View Mode -->
                <asp:PlaceHolder ID="phGeneralView" runat="server">
                    <div class="bento-hero-grid">
                        <div class="bento-hero-info">
                            <div class="kv-item full-width" style="margin-bottom:0.75rem;">
                                <span class="kv-label">Event Specification Title</span>
                                <span class="hero-event-title"><asp:Literal ID="litTitleView" runat="server" /></span>
                            </div>

                            <div class="kv-item full-width" style="margin-bottom:1rem; flex:1;">
                                <span class="kv-label">Detailed Event Description &amp; Objectives</span>
                                <div class="hero-event-desc"><asp:Literal ID="litDescView" runat="server" /></div>
                            </div>

                            <div class="hero-pills-row">
                                <div class="hero-pill-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                    <div class="hero-pill-text">
                                        <span class="hero-pill-label">Physical Venue</span>
                                        <span class="hero-pill-val"><asp:Literal ID="litVenueView" runat="server" /></span>
                                    </div>
                                </div>
                                <div class="hero-pill-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                    <div class="hero-pill-text">
                                        <span class="hero-pill-label">Allocated Seating</span>
                                        <span class="hero-pill-val mono"><asp:Literal ID="litCapacityView" runat="server" /> Seats</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="bento-hero-media">
                            <div class="media-preview-container">
                                <div class="banner-preview-box ratio-wide" style="height: 100%; min-height: 160px; position: relative; overflow: hidden; border-radius: 8px;">
                                    <asp:Image ID="imgWideBanner" runat="server" CssClass="banner-img" ImageUrl="~/Frontend/Assets/campus-clean.jpg" AlternateText="Wide Banner Preview" />
                                    <div class="banner-badge-overlay" style="position: absolute; top: 0.5rem; right: 0.5rem; z-index: 2;">
                                        <span class="banner-ratio-tag" style="white-space: nowrap; font-size: 0.65rem; padding: 0.2rem 0.45rem;">16:9 BANNER</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:PlaceHolder>

                <!-- Editable Form Controls -->
                <asp:PlaceHolder ID="phGeneralEdit" runat="server" Visible="false">
                    <div class="bento-hero-edit-grid">
                        <div class="bento-hero-edit-fields">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtTitle.ClientID %>">Event Title <span style="color:#ef4444;">*</span></label>
                                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="200" placeholder="e.g. Annual University Tech Symposium 2026" />
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="<%= txtDescription.ClientID %>">Event Description</label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Detail the event objectives, keynote topics, speaker profiles, or student prerequisites..." />
                            </div>

                            <div class="form-grid-2">
                                <div class="form-group" style="margin-bottom:0;">
                                    <label class="form-label" for="<%= txtVenueLocation.ClientID %>">Venue Location <span style="color:#ef4444;">*</span></label>
                                    <asp:TextBox ID="txtVenueLocation" runat="server" CssClass="form-control" MaxLength="200" placeholder="e.g. Central Auditorium, Hall A" />
                                </div>

                                <div class="form-group" style="margin-bottom:0;">
                                    <label class="form-label" for="<%= txtMaxCapacity.ClientID %>">Max Capacity (Seats) <span style="color:#ef4444;">*</span></label>
                                    <asp:TextBox ID="txtMaxCapacity" runat="server" CssClass="form-control" TextMode="Number" />
                                </div>
                            </div>
                        </div>

                            <asp:PlaceHolder ID="phWideUpload" runat="server" Visible="true">
                                <div class="upload-slot-group">
                                    <div class="upload-slot-header">
                                        <label class="form-label" style="margin-bottom:0;">16:9 Banner (Desktop / Web)</label>
                                        <span class="banner-ratio-tag">16:9 WIDE</span>
                                    </div>
                                    <asp:HiddenField ID="hfEditPhotoBase64" runat="server" />
                                    <asp:HiddenField ID="hfEditPhotoFileName" runat="server" />
                                    <div id="editDropzoneContent" class="upload-dropzone" style="min-height:95px; padding:0.85rem; cursor:pointer;" onclick="triggerEditPhotoUpload();">
                                        <svg class="upload-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                            <polyline points="17 8 12 3 7 8"></polyline>
                                            <line x1="12" y1="3" x2="12" y2="15"></line>
                                        </svg>
                                        <asp:FileUpload ID="fuWideBanner" runat="server" CssClass="form-control banner-file-input" accept="image/*" onchange="handleEditBannerFileSelect(this);" style="display:none;" />
                                        <span style="font-weight:600; font-size:0.85rem; color:var(--text-heading); margin-bottom:0.25rem;">Click to Upload New Promotional Banner</span>
                                        <span class="upload-formats-hint">Supported formats: PNG, JPG, JPEG, WEBP</span>
                                    </div>

                                    <!-- Live Interactive Banner Preview in Edit Mode -->
                                    <div id="editBannerPreviewContainer" style="display:none; margin-top:0.65rem; border-radius:8px; overflow:hidden; border:1px solid var(--border-color); background:var(--card-bg);">
                                        <img id="imgEditBannerPreview" src="" alt="New Selected Banner" style="width:100%; height:130px; object-fit:cover; display:block;" />
                                        <div style="display:flex; justify-content:space-between; align-items:center; padding:0.5rem 0.75rem; background:rgba(0,0,0,0.03);">
                                            <span id="lblEditBannerFileName" style="font-size:0.8rem; font-weight:600; color:var(--text-heading); text-overflow:ellipsis; overflow:hidden; white-space:nowrap; max-width:140px;"></span>
                                            <div style="display:flex; gap:0.4rem;">
                                                <button type="button" onclick="triggerEditPhotoUpload();" style="background:#e0f2fe; color:#0284c7; border:none; border-radius:4px; padding:3px 7px; font-size:0.75rem; font-weight:600; cursor:pointer;">Change</button>
                                                <button type="button" onclick="removeEditBanner();" style="background:#fee2e2; color:#ef4444; border:none; border-radius:4px; padding:3px 7px; font-size:0.75rem; font-weight:600; cursor:pointer;">Remove</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </asp:PlaceHolder>
                    </div>
                </asp:PlaceHolder>
            </div>
        </div>

        <!-- BENTO ROW 1: CELL 2 (Span 4) - Live Gate Cockpit & Real-Time Occupancy -->
        <div class="bento-card bento-span-4">
            <div class="bento-card-header">
                <div class="bento-card-title">
                    <span>Gate Occupancy &amp; Quota</span>
                </div>
                <span class="status-pill <%= HeaderStatusBadgeClass %>">
                    <asp:Literal ID="litSidebarStatus" runat="server" Text="Upcoming" />
                </span>
            </div>

            <div class="bento-card-body">
                <div class="cockpit-hero-metric">
                    <span class="cockpit-pct"><asp:Literal ID="litOccupancyPct" runat="server" Text="0%" /></span>
                    <span class="cockpit-ratio-badge"><asp:Literal ID="litOccupancyCount" runat="server" Text="0 / 150" /> Seats</span>
                </div>

                <div class="cockpit-track-container">
                    <div class="capacity-bar-track">
                        <div class="capacity-bar-fill" style="width: <%= OccupancyBarWidth %>%;"></div>
                    </div>
                </div>

                <div class="cockpit-meta-grid">
                    <div class="cockpit-meta-tile">
                        <span class="cockpit-meta-label">Remaining Spots</span>
                        <span class="cockpit-meta-value"><asp:Literal ID="litRemainingSpots" runat="server" Text="0 spots open" /></span>
                    </div>
                    <div class="cockpit-meta-tile">
                        <span class="cockpit-meta-label">Record Key</span>
                        <span class="cockpit-meta-value mono">#<%= CurrentEventId %></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- BENTO ROW 2: CELL 3 (Span 6) - Execution Schedule & Registration Lifecycle -->
        <div class="bento-card bento-span-6">
            <div class="bento-card-header">
                <div class="bento-card-title">
                    <span>Execution Schedule &amp; Lifecycle</span>
                </div>
                <span class="event-id-tag">SECTION 02</span>
            </div>

            <div class="bento-card-body">
                <!-- Read-Only View -->
                <asp:PlaceHolder ID="phScheduleView" runat="server">
                    <div class="telemetry-tile-grid">
                        <div class="telemetry-tile">
                            <span class="telemetry-label">Event Date</span>
                            <span class="telemetry-val mono accent"><asp:Literal ID="litEventDateView" runat="server" /></span>
                        </div>
                        <div class="telemetry-tile">
                            <span class="telemetry-label">Execution Hours</span>
                            <span class="telemetry-val mono"><asp:Literal ID="litEventHoursView" runat="server" /></span>
                        </div>
                        <div class="telemetry-tile">
                            <span class="telemetry-label">Registration Opens</span>
                            <span class="telemetry-val mono"><asp:Literal ID="litRegStartView" runat="server" /></span>
                        </div>
                        <div class="telemetry-tile">
                            <span class="telemetry-label">Registration Deadline</span>
                            <span class="telemetry-val mono rose"><asp:Literal ID="litRegEndView" runat="server" /></span>
                        </div>
                    </div>
                </asp:PlaceHolder>

                <!-- Editable Controls -->
                <asp:PlaceHolder ID="phScheduleEdit" runat="server" Visible="false">
                    <div class="form-group">
                        <label class="form-label" for="<%= txtEventDate.ClientID %>">Event Date <span style="color:#ef4444;">*</span></label>
                        <asp:TextBox ID="txtEventDate" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.5rem; margin-bottom:0.75rem;">
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= txtStartTime.ClientID %>">Start Time <span style="color:#ef4444;">*</span></label>
                            <asp:TextBox ID="txtStartTime" runat="server" CssClass="form-control" TextMode="Time" />
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= txtEndTime.ClientID %>">End Time <span style="color:#ef4444;">*</span></label>
                            <asp:TextBox ID="txtEndTime" runat="server" CssClass="form-control" TextMode="Time" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="<%= txtRegStart.ClientID %>">Registration Start <span style="color:#ef4444;">*</span></label>
                        <asp:TextBox ID="txtRegStart" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label class="form-label" for="<%= txtRegEnd.ClientID %>">Registration Deadline <span style="color:#ef4444;">*</span></label>
                        <asp:TextBox ID="txtRegEnd" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                </asp:PlaceHolder>
            </div>
        </div>

        <!-- BENTO ROW 2: CELL 4 (Span 6) - Target Demographics & Audience Matrix -->
        <div class="bento-card bento-span-6">
            <div class="bento-card-header">
                <div class="bento-card-title">
                    <span>Target Demographics</span>
                </div>
                <span class="event-id-tag">SECTION 03</span>
            </div>

            <div class="bento-card-body">
                <!-- Read-Only View -->
                <asp:PlaceHolder ID="phDemographicsView" runat="server">
                    <div class="telemetry-tile-grid">
                        <div class="telemetry-tile">
                            <span class="telemetry-label">Campus Branch</span>
                            <span class="telemetry-val"><asp:Literal ID="litBranchView" runat="server" Text="All University Branches (Open)" /></span>
                        </div>
                        <div class="telemetry-tile">
                            <span class="telemetry-label">Academic College</span>
                            <span class="telemetry-val"><asp:Literal ID="litDeptView" runat="server" Text="All Academic Colleges" /></span>
                        </div>
                        <div class="telemetry-tile">
                            <span class="telemetry-label">Student Year Level</span>
                            <span class="telemetry-val"><asp:Literal ID="litYearLevelView" runat="server" Text="All Year Levels (1st - 4th)" /></span>
                        </div>
                        <div class="telemetry-tile">
                            <span class="telemetry-label">Target Degree Programs</span>
                            <div class="chips-container">
                                <asp:Literal ID="litProgramsChips" runat="server" />
                            </div>
                        </div>
                    </div>
                </asp:PlaceHolder>

                <!-- Editable Controls -->
                <asp:PlaceHolder ID="phDemographicsEdit" runat="server" Visible="false">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.75rem; margin-bottom:1rem;">
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= ddlBranch.ClientID %>">Target Campus Branch</label>
                            <asp:DropDownList ID="ddlBranch" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All University Branches (Open to All)" />
                                <asp:ListItem Value="San Bartolome" Text="San Bartolome (Main Campus)" />
                                <asp:ListItem Value="San Francisco" Text="San Francisco Campus" />
                                <asp:ListItem Value="Batasan" Text="Batasan Campus" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= ddlDepartment.ClientID %>">Target Academic College</label>
                            <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All Academic Colleges (Open to All)" />
                                <asp:ListItem Value="College of Computer Studies" Text="College of Computer Studies (CCS)" />
                                <asp:ListItem Value="College of Business Administration" Text="College of Business Administration (CBA)" />
                                <asp:ListItem Value="College of Engineering" Text="College of Engineering (COE)" />
                                <asp:ListItem Value="College of Education" Text="College of Education (CED)" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.75rem;">
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= ddlYearLevel.ClientID %>">Target Standing Year Level</label>
                            <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All Year Standings (1st - 4th Year)" />
                                <asp:ListItem Value="1" Text="1st Year Standing Only" />
                                <asp:ListItem Value="2" Text="2nd Year Standing Only" />
                                <asp:ListItem Value="3" Text="3rd Year Standing Only" />
                                <asp:ListItem Value="4" Text="4th Year Standing Only" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= txtPrograms.ClientID %>">Target Degree Programs</label>
                            <asp:TextBox ID="txtPrograms" runat="server" CssClass="form-control" placeholder="e.g. BSIT, BSCS, BSECE (or blank for all)" />
                        </div>
                    </div>
                </asp:PlaceHolder>
            </div>
        </div>

        <!-- BENTO ROW 3: CELL 5 (Span 12) - Institutional Partners & Sponsors -->
        <div class="bento-card bento-span-12">
            <div class="bento-card-header">
                <div class="bento-card-title">
                    <span>Institutional Partners &amp; Sponsors</span>
                </div>
                <span class="event-id-tag"><asp:Literal ID="litMetaSponsorCount" runat="server" Text="0" /> PARTNERS</span>
            </div>

            <div class="bento-card-body">
                <!-- Sponsors List Chips -->
                <div class="sponsors-shelf-layout">
                    <div class="chips-container sponsors-chips-grid">
                        <asp:Repeater ID="rptSponsors" runat="server" OnItemCommand="rptSponsors_ItemCommand">
                            <ItemTemplate>
                                <span class='badge-chip <%# IsEditMode ? "removable" : "" %>'>
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                    </svg>
                                    <span><%# Container.DataItem %></span>
                                    <asp:LinkButton ID="btnRemoveSponsor" runat="server" CommandName="Remove" CommandArgument='<%# Container.DataItem %>' CssClass="btn-chip-remove" Visible='<%# IsEditMode %>' CausesValidation="false" title="Remove sponsor">&times;</asp:LinkButton>
                                </span>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Literal ID="litNoSponsors" runat="server" Text="<span style='color:#64748b; font-size:0.85rem; font-style:italic;'>No corporate or academic sponsors attached to this event record.</span>" />
                    </div>

                    <!-- Add Sponsor Input (In Edit Mode) -->
                    <asp:PlaceHolder ID="phAddSponsor" runat="server" Visible="false">
                        <div style="display:flex; gap:0.5rem; margin-top:1rem; max-width:420px;">
                            <asp:TextBox ID="txtNewSponsor" runat="server" CssClass="form-control" placeholder="Enter sponsor / partner organization name" />
                            <asp:Button ID="btnAddSponsor" runat="server" Text="Add Partner" CssClass="btn-action-secondary" OnClick="btnAddSponsor_Click" CausesValidation="false" />
                        </div>
                    </asp:PlaceHolder>
                </div>

                <div style="margin-top:1.25rem; padding-top:0.75rem; border-top:1px solid #f1f5f9; font-size:0.75rem; color:var(--text-muted); display:flex; justify-content:space-between; align-items:center;">
                    <span>Official institutional partners and organizations sponsoring this university event.</span>
                    <span class="mono" style="font-size:0.72rem; color:#64748b;">Event ID: #<%= CurrentEventId %></span>
                </div>
            </div>
        </div>

    </div>

    <!-- Hidden Backing Controls for Code-Behind & ViewState Integrity -->
    <asp:PlaceHolder ID="phHiddenBackingControls" runat="server" Visible="false">
        <asp:Literal ID="litMetaEventId" runat="server" Text="-" />
        <asp:PlaceHolder ID="phSquareUpload" runat="server" Visible="false">
            <asp:FileUpload ID="fuSquareBanner" runat="server" />
            <asp:Image ID="imgSquareBanner" runat="server" />
        </asp:PlaceHolder>
    </asp:PlaceHolder>

    <script type="text/javascript">
        function triggerEditPhotoUpload() {
            var fu = document.getElementById('<%= fuWideBanner.ClientID %>');
            if (fu) fu.click();
        }

        function handleEditBannerFileSelect(input) {
            if (input.files && input.files[0]) {
                var file = input.files[0];
                var reader = new FileReader();
                reader.onload = function(e) {
                    var preview = document.getElementById('imgEditBannerPreview');
                    var nameLabel = document.getElementById('lblEditBannerFileName');
                    var container = document.getElementById('editBannerPreviewContainer');
                    var dropzone = document.getElementById('editDropzoneContent');
                    if (preview) preview.src = e.target.result;
                    if (nameLabel) nameLabel.innerText = file.name;
                    if (container) container.style.display = 'block';
                    if (dropzone) dropzone.style.display = 'none';

                    var hfData = document.getElementById('<%= hfEditPhotoBase64.ClientID %>');
                    var hfName = document.getElementById('<%= hfEditPhotoFileName.ClientID %>');
                    if (hfData) hfData.value = e.target.result;
                    if (hfName) hfName.value = file.name;
                };
                reader.readAsDataURL(file);
            }
        }

        function removeEditBanner() {
            var fu = document.getElementById('<%= fuWideBanner.ClientID %>');
            if (fu) fu.value = '';
            var hfData = document.getElementById('<%= hfEditPhotoBase64.ClientID %>');
            var hfName = document.getElementById('<%= hfEditPhotoFileName.ClientID %>');
            if (hfData) hfData.value = '';
            if (hfName) hfName.value = '';
            var container = document.getElementById('editBannerPreviewContainer');
            var dropzone = document.getElementById('editDropzoneContent');
            if (container) container.style.display = 'none';
            if (dropzone) dropzone.style.display = 'block';
        }

        document.addEventListener('DOMContentLoaded', function () {
            var hfData = document.getElementById('<%= hfEditPhotoBase64.ClientID %>');
            var hfName = document.getElementById('<%= hfEditPhotoFileName.ClientID %>');
            if (hfData && hfData.value) {
                var preview = document.getElementById('imgEditBannerPreview');
                var nameLabel = document.getElementById('lblEditBannerFileName');
                var container = document.getElementById('editBannerPreviewContainer');
                var dropzone = document.getElementById('editDropzoneContent');
                if (preview) preview.src = hfData.value;
                if (nameLabel && hfName && hfName.value) nameLabel.innerText = hfName.value;
                if (container) container.style.display = 'block';
                if (dropzone) dropzone.style.display = 'none';
            }
        });
    </script>
</asp:Content>
