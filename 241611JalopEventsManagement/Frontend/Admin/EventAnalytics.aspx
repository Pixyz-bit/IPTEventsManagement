<%@ Page Title="Event Telemetry & Analytics" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventAnalytics.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventAnalytics" EnableSessionState="ReadOnly" EnableViewState="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Event Telemetry &amp; Performance Analytics | QCU Event Management
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/event-analytics.css") %>?v=<%= DateTime.UtcNow.Ticks %>" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="analytics-container">

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
            <asp:PlaceHolder ID="phBreadcrumbMatrix" runat="server">
                <li class="breadcrumb-item">
                    <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>">
                        <span>Campus Events Matrix</span>
                    </a>
                </li>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="phBreadcrumbHistory" runat="server" Visible="false">
                <li class="breadcrumb-item">
                    <a href="<%= ResolveUrl("~/Frontend/Admin/EventHistory.aspx") %>">
                        <span>Events History</span>
                    </a>
                </li>
            </asp:PlaceHolder>
            <li class="breadcrumb-separator">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                <span>Event Telemetry &amp; Analytics</span>
            </li>
        </ol>
    </nav>

    <!-- Context Header Banner -->
    <asp:Panel ID="pnlEventContextCard" runat="server" CssClass="event-context-card">
        <div class="event-context-top">
            <div class="event-title-group">
                <h1>
                    <asp:Literal ID="litEventTitle" runat="server" Text="Select an Event"></asp:Literal>
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
                    <asp:Literal ID="litEventStatusBadge" runat="server" Visible="false"></asp:Literal>
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
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventDetails.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
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
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAnalytics.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item active">
                <span>Event Analytics</span>
            </a>
        </div>
    </asp:Panel>

    <!-- Unified Executive Action Bar -->
    <div class="dashboard-action-bar">
        <div class="dashboard-action-title">
            <asp:PlaceHolder ID="phHistoryBack" runat="server" Visible="false">
                <div style="margin-bottom:0.5rem;">
                    <a href="<%= ResolveUrl("~/Frontend/Admin/EventHistory.aspx") %>" class="btn-action-secondary" style="display:inline-flex; align-items:center; gap:0.4rem; padding:0.35rem 0.75rem; text-decoration:none; font-size:0.8rem; font-weight:600; border-radius:var(--radius-md); border:1px solid var(--border-medium); background:#ffffff; color:var(--text-heading);">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Back to Events History</span>
                    </a>
                </div>
            </asp:PlaceHolder>
            <h2>Unified Event Analytics &amp; Performance Audit</h2>
            <asp:Panel ID="pnlHistorySubtitle" runat="server" Visible="false" Style="margin-top:0.35rem; display:flex; gap:0.75rem; align-items:center; flex-wrap:wrap; font-size:0.825rem; color:var(--text-muted);">
                <span>Event: <strong style="color:var(--text-heading);"><asp:Literal ID="litSubEventTitle" runat="server" /></strong></span>
                <span>&bull;</span>
                <span>Date: <strong style="color:var(--text-heading);"><asp:Literal ID="litSubEventDate" runat="server" /></strong></span>
                <span>&bull;</span>
                <span>Venue: <strong style="color:var(--text-heading);"><asp:Literal ID="litSubEventVenue" runat="server" /></strong></span>
                <span>&bull;</span>
                <span>Capacity: <strong style="color:var(--text-heading);"><asp:Literal ID="litSubEventCapacity" runat="server" /></strong></span>
            </asp:Panel>
        </div>
    </div>

        <!-- ROW 1: EXECUTIVE TELEMETRY BENTO GRID -->
    <div class="executive-bento-grid">
        <!-- 1. Attendance Turnout (Bento Subpanel) -->
        <div class="telemetry-subpanel turnout-bento-card">
            <div class="telemetry-panel-header">
                <span class="telemetry-panel-title">Attendance Turnout</span>
                <span class="telemetry-panel-icon turnout-icon">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                </span>
            </div>

            <div class="telemetry-rate-row">
                <span class="telemetry-rate-label">Rate</span>
                <span class="telemetry-rate-value turnout-accent">
                    <asp:Literal ID="litTurnoutRate" runat="server" Text="0.0%" />
                </span>
            </div>

            <div class="telemetry-bar-wrapper">
                <div class="telemetry-bar-track">
                    <div class="telemetry-bar-fill turnout-fill" style="width: <%= TurnoutRateBarWidth %>%;"></div>
                </div>
            </div>

            <ul class="telemetry-stats-list">
                <li>
                    <span class="stat-dot registered-dot"></span>
                    <span class="stat-name">Registered:</span>
                    <span class="stat-val"><asp:Literal ID="litRegisteredCount" runat="server" Text="0" /></span>
                </li>
                <li>
                    <span class="stat-dot turnout-dot"></span>
                    <span class="stat-name">Checked In:</span>
                    <span class="stat-val"><asp:Literal ID="litCheckedInCount" runat="server" Text="0" /></span>
                </li>
                <li>
                    <span class="stat-dot noshow-dot"></span>
                    <span class="stat-name">No-Show:</span>
                    <span class="stat-val"><asp:Literal ID="litNoShowCount" runat="server" Text="0" /> <span class="stat-sub-pct">(<asp:Literal ID="litNoShowPct" runat="server" Text="0.0%" />)</span></span>
                </li>
            </ul>

            <div class="telemetry-status-row">
                <span class="telemetry-status-label">Status</span>
                <span class="telemetry-status-tag turnout-status">
                    <asp:Literal ID="litTurnoutStatus" runat="server" Text="AWAITING REGISTRATIONS" />
                </span>
            </div>
        </div>

        <!-- 2. Capacity Saturation (Bento Subpanel) -->
        <div class="telemetry-subpanel capacity-bento-card">
            <div class="telemetry-panel-header">
                <span class="telemetry-panel-title">Capacity Saturation</span>
                <span class="telemetry-panel-icon capacity-icon">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                        <line x1="8" y1="21" x2="16" y2="21"></line>
                        <line x1="12" y1="17" x2="12" y2="21"></line>
                    </svg>
                </span>
            </div>

            <div class="telemetry-rate-row">
                <span class="telemetry-rate-label">Venue Load</span>
                <span class="telemetry-rate-value capacity-accent">
                    <asp:Literal ID="litVenueLoadRate" runat="server" Text="0.0%" />
                </span>
            </div>

            <div class="telemetry-bar-wrapper">
                <div class="telemetry-bar-track">
                    <div class="telemetry-bar-fill capacity-fill" style="width: <%= VenueLoadBarWidth %>%;"></div>
                </div>
            </div>

            <ul class="telemetry-stats-list">
                <li>
                    <span class="stat-dot limit-dot"></span>
                    <span class="stat-name">Venue Limit:</span>
                    <span class="stat-val"><asp:Literal ID="litVenueLimit" runat="server" Text="100" /></span>
                </li>
                <li>
                    <span class="stat-dot present-dot"></span>
                    <span class="stat-name">Present On-Site:</span>
                    <span class="stat-val"><asp:Literal ID="litPresentOnSite" runat="server" Text="0" /></span>
                </li>
                <li>
                    <span class="stat-dot remaining-dot"></span>
                    <span class="stat-name">Seats Remaining:</span>
                    <span class="stat-val"><asp:Literal ID="litSeatsRemainingCount" runat="server" Text="100" /> <span class="stat-sub-pct">(<asp:Literal ID="litSeatsRemainingPct" runat="server" Text="100.0%" />)</span></span>
                </li>
            </ul>

            <div class="telemetry-status-row">
                <span class="telemetry-status-label">Status</span>
                <span class="telemetry-status-tag capacity-status">
                    <asp:Literal ID="litCapacityStatus" runat="server" Text="SEATS AVAILABLE" />
                </span>
            </div>
        </div>

        <!-- 3. Target Demographics Distribution (Square Bento Card) -->
        <div class="telemetry-panel demographics-bento-card">
            <div class="panel-header-bar demographics-header-compact">
                <div class="panel-title">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                        <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                    </svg>
                    <span>Target Demographics</span>
                </div>
                <div class="dim-dropdown-group" style="width:auto; margin:0;">
                    <select id="ddlDemographicDimension" class="dim-dropdown-select dim-select-compact" onchange="switchDemographicDimension(this.value)" title="Cohort Dimension">
                        <option value="course" selected="selected">Program</option>
                        <option value="department">Department</option>
                        <option value="year">Year Level</option>
                        <option value="branch">Branch</option>
                    </select>
                </div>
            </div>
            <div class="panel-body demographics-bento-body">
                <div class="pie-chart-container-bento" id="pieChartWrapper">
                    <div class="pie-svg-wrapper">
                        <svg id="demographicsPieSvg" class="pie-chart-svg" viewBox="0 0 240 240"></svg>
                        <div class="pie-center-label-box" style="position:absolute; text-align:center; pointer-events:none;">
                            <div id="pieCenterCount" style="font-size:1.25rem; font-weight:800; color:var(--text-heading); font-family:var(--font-mono); line-height:1.1;">0</div>
                            <div id="pieCenterLabel" style="font-size:0.65rem; font-weight:700; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.04em;">Attendees</div>
                        </div>
                    </div>
                    <div id="demographicsLegend" class="pie-chart-legend">
                        <!-- Dynamically populated via JS -->
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. Cancelled Reservations (Horizontal Bento Strip) -->
        <div class="analytics-card cancelled-bento-card">
            <div class="cancelled-bento-content">
                <div class="cancelled-bento-left">
                    <span class="telemetry-panel-icon cancelled-icon">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="15" y1="9" x2="9" y2="15"></line>
                            <line x1="9" y1="9" x2="15" y2="15"></line>
                        </svg>
                    </span>
                    <div class="cancelled-bento-titles">
                        <span class="analytics-card-label">Cancelled Reservations</span>
                        <span class="cancelled-bento-desc">Revoked or released registrations prior to gate check-in</span>
                    </div>
                </div>
                <div class="cancelled-bento-right">
                    <span class="analytics-card-value cancelled-accent">
                        <asp:Literal ID="litBeforeCancelled" runat="server" Text="0" />
                    </span>
                    <span class="cancelled-unit-label">Students</span>
                </div>
            </div>
        </div>
    </div>

    <!-- ROW 2: ATTENDEE COHORT ROSTER AUDIT (PRESENT, NO-SHOW, CANCELLED) -->
    <div class="telemetry-panel attendee-roster-panel">
        <div class="sheet-tabs-container">
            <button type="button" id="tabPresent" class="sheet-tab-btn active active-present" onclick="switchSheet('present')">
                <span>Present</span>
                <span class="sheet-badge sheet-badge-present">
                    <asp:Literal ID="litTabCountPresent" runat="server" Text="0"></asp:Literal>
                </span>
            </button>

            <button type="button" id="tabNoShow" class="sheet-tab-btn" onclick="switchSheet('noshow')">
                <span>No Show</span>
                <span class="sheet-badge sheet-badge-noshow">
                    <asp:Literal ID="litTabCountNoShow" runat="server" Text="0"></asp:Literal>
                </span>
            </button>

            <button type="button" id="tabCancelled" class="sheet-tab-btn" onclick="switchSheet('cancelled')">
                <span>Cancelled</span>
                <span class="sheet-badge sheet-badge-cancelled">
                    <asp:Literal ID="litTabCountCancelled" runat="server" Text="0"></asp:Literal>
                </span>
            </button>
        </div>

        <!-- Search Bar -->
        <div class="roster-toolbar">
            <div class="search-box-wrapper">
                <svg class="search-box-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="txtCohortSearch" class="search-input" placeholder="Search by Student ID, Name, or Ticket Reference..." onkeyup="filterCohortTable()" />
            </div>
            <div style="font-size:0.8rem; color:var(--text-muted); font-weight:600;">
                Showing real-time student check-in status
            </div>
        </div>

        <!-- 1. Present Table -->
        <div id="sheetPresent" class="cohort-sheet-view" style="display:block;">
            <div class="table-responsive">
                <table class="roster-table" id="tblPresent">
                    <thead>
                        <tr>
                            <th style="width: 16%;">Ticket Ref</th>
                            <th style="width: 14%;">Student ID</th>
                            <th style="width: 24%;">Student Name</th>
                            <th style="width: 24%;">Department &amp; Program</th>
                            <th style="width: 10%;">Year &amp; Section</th>
                            <th style="width: 12%;">Verified At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptPresentAttendees" runat="server">
                            <ItemTemplate>
                                <tr class="roster-row" data-search='<%# string.Format("{0} {1} {2}", Eval("StudentId"), Eval("StudentFullName"), Eval("TicketReference")).ToLower() %>'>
                                    <td><span class="ticket-code"><%# Eval("TicketReference") %></span></td>
                                    <td><span class="student-id-text"><%# Eval("StudentId") %></span></td>
                                    <td><strong style="color:var(--text-heading);"><%# Eval("StudentFullName") %></strong></td>
                                    <td><%# Eval("StudentProgram") %></td>
                                    <td>Yr <%# Eval("CurrentYearLvl") %> - <%# Eval("CurrentSection") %></td>
                                    <td><span style="font-size:0.75rem;"><%# FormatTimestamp(Eval("CheckInTimestamp")) %></span></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 2. No Show Table -->
        <div id="sheetNoShow" class="cohort-sheet-view" style="display:none;">
            <div class="table-responsive">
                <table class="roster-table" id="tblNoShow">
                    <thead>
                        <tr>
                            <th style="width: 16%;">Ticket Ref</th>
                            <th style="width: 14%;">Student ID</th>
                            <th style="width: 24%;">Student Name</th>
                            <th style="width: 24%;">Department &amp; Program</th>
                            <th style="width: 10%;">Year &amp; Section</th>
                            <th style="width: 12%;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptNoShowAttendees" runat="server">
                            <ItemTemplate>
                                <tr class="roster-row" data-search='<%# string.Format("{0} {1} {2}", Eval("StudentId"), Eval("StudentFullName"), Eval("TicketReference")).ToLower() %>'>
                                    <td><span class="ticket-code"><%# Eval("TicketReference") %></span></td>
                                    <td><span class="student-id-text"><%# Eval("StudentId") %></span></td>
                                    <td><strong style="color:var(--text-heading);"><%# Eval("StudentFullName") %></strong></td>
                                    <td><%# Eval("StudentProgram") %></td>
                                    <td>Yr <%# Eval("CurrentYearLvl") %> - <%# Eval("CurrentSection") %></td>
                                    <td><span class="rate-badge rate-badge-mid" style="font-size:0.75rem;">No-Show</span></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 3. Cancelled Table -->
        <div id="sheetCancelled" class="cohort-sheet-view" style="display:none;">
            <div class="table-responsive">
                <table class="roster-table" id="tblCancelled">
                    <thead>
                        <tr>
                            <th style="width: 16%;">Ticket Ref</th>
                            <th style="width: 14%;">Student ID</th>
                            <th style="width: 24%;">Student Name</th>
                            <th style="width: 24%;">Department &amp; Program</th>
                            <th style="width: 10%;">Year &amp; Section</th>
                            <th style="width: 12%;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptCancelledAttendees" runat="server">
                            <ItemTemplate>
                                <tr class="roster-row" data-search='<%# string.Format("{0} {1} {2}", Eval("StudentId"), Eval("StudentFullName"), Eval("TicketReference")).ToLower() %>'>
                                    <td><span class="ticket-code ticket-code-cancelled"><%# Eval("TicketReference") %></span></td>
                                    <td><span class="student-id-text"><%# Eval("StudentId") %></span></td>
                                    <td><strong style="color:var(--text-heading);"><%# Eval("StudentFullName") %></strong></td>
                                    <td><%# Eval("StudentProgram") %></td>
                                    <td>Yr <%# Eval("CurrentYearLvl") %> - <%# Eval("CurrentSection") %></td>
                                    <td><span class="rate-badge rate-badge-low" style="font-size:0.75rem;">Cancelled</span></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Hidden State Holders for Legacy References & Backward Compatibility -->
    <asp:PlaceHolder ID="phLegacyStateHolders" runat="server" Visible="false">
        <asp:Literal ID="litBeforePreRegistered" runat="server" Text="0"></asp:Literal>
        <asp:Literal ID="litBeforeDaysUntilLaunch" runat="server" Text="0 Days"></asp:Literal>
        <asp:Literal ID="litDuringRosterTotal" runat="server" Text="0"></asp:Literal>
        <asp:Literal ID="litDuringVenueOccupancy" runat="server" Text="0.0%"></asp:Literal>
        <asp:Literal ID="litAfterPreRegisteredTotal" runat="server" Text="0"></asp:Literal>
        <asp:Literal ID="litAfterCancellations" runat="server" Text="0"></asp:Literal>
        <asp:Literal ID="litAfterRetentionRate" runat="server" Text="0.0%"></asp:Literal>
        <asp:Literal ID="litAfterTopDepartment" runat="server" Text=""></asp:Literal>
        <asp:Repeater ID="rptDemographicAudit" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
        <asp:Repeater ID="rptBranchDistribution" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
        <asp:Repeater ID="rptDepartmentDistribution" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
        <asp:Repeater ID="rptCourseDistribution" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
        <asp:Repeater ID="rptYearDistribution" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
        <asp:Literal ID="litSaturationPercentDisplay" runat="server" Text="0 / 100"></asp:Literal>
        <asp:Literal ID="litBeforeSaturationRate" runat="server" Text="0.0%"></asp:Literal>
        <asp:Literal ID="litSaturationProgressBar" runat="server"></asp:Literal>
        <asp:Literal ID="litBeforeSaturationStatus" runat="server" Text="Undersubscribed"></asp:Literal>
        <asp:Literal ID="litBeforeAttritionRate" runat="server" Text="0.0%"></asp:Literal>
        <asp:Literal ID="litBeforeAvailableQuota" runat="server" Text="0"></asp:Literal>
        <asp:Literal ID="litDuringPeakWindow" runat="server" Text="Awaiting Traffic"></asp:Literal>
        <asp:Repeater ID="rptRegistrationVelocity" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
        <asp:Repeater ID="rptCheckInIntervals" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
    </asp:PlaceHolder>

    <!-- Hidden Demographics & Telemetry Data JSON Literal -->
    <script id="demographicsJsonData" type="application/json"><asp:Literal ID="litDemographicsJson" runat="server"></asp:Literal></script>

</div>

<!-- Floating interactive tooltip for mouse hover over pie slices, points, and legend items -->
<div id="pieInteractiveTooltip" class="pie-interactive-tooltip">
    <div id="pieTooltipTitle" class="tooltip-title">Category</div>
    <div id="pieTooltipBody" class="tooltip-body">
        <span id="pieTooltipCount" style="font-weight:700;">0</span>
        <span id="pieTooltipPercent" style="opacity:0.85;"></span>
    </div>
</div>

<script type="text/javascript">
    let telemetryData = {};

    function initUnifiedDashboard() {
        const rawDataEl = document.getElementById('demographicsJsonData');
        if (rawDataEl && rawDataEl.textContent.trim()) {
            try {
                telemetryData = JSON.parse(rawDataEl.textContent);
            } catch (e) {
                console.error("Failed to parse telemetry data:", e);
            }
        }

        // 1. Render Demographic Donut Chart
        const select = document.getElementById('ddlDemographicDimension');
        const initialDim = select ? select.value : 'course';
        let initialLabel = 'Program';
        if (initialDim === 'department') initialLabel = 'Department';
        else if (initialDim === 'branch') initialLabel = 'Branch';
        else if (initialDim === 'year') initialLabel = 'Year Level';

        renderDemographicDimension(initialDim, initialLabel);
    }

        // =========================================================================
    // 1. DUAL/MULTI SHEET COHORT SWITCHER & CLIENT SEARCH
    // =========================================================================
    let currentCohortSheet = 'present';

    function switchSheet(sheetName) {
        currentCohortSheet = sheetName;
        const tabPresent = document.getElementById('tabPresent');
        const tabNoShow = document.getElementById('tabNoShow');
        const tabCancelled = document.getElementById('tabCancelled');

        const sheetPresent = document.getElementById('sheetPresent');
        const sheetNoShow = document.getElementById('sheetNoShow');
        const sheetCancelled = document.getElementById('sheetCancelled');

        if (tabPresent) tabPresent.className = 'sheet-tab-btn';
        if (tabNoShow) tabNoShow.className = 'sheet-tab-btn';
        if (tabCancelled) tabCancelled.className = 'sheet-tab-btn';

        if (sheetPresent) sheetPresent.style.display = 'none';
        if (sheetNoShow) sheetNoShow.style.display = 'none';
        if (sheetCancelled) sheetCancelled.style.display = 'none';

        if (sheetName === 'present') {
            if (tabPresent) tabPresent.className = 'sheet-tab-btn active active-present';
            if (sheetPresent) sheetPresent.style.display = 'block';
        } else if (sheetName === 'noshow') {
            if (tabNoShow) tabNoShow.className = 'sheet-tab-btn active active-noshow';
            if (sheetNoShow) sheetNoShow.style.display = 'block';
        } else if (sheetName === 'cancelled') {
            if (tabCancelled) tabCancelled.className = 'sheet-tab-btn active active-cancelled';
            if (sheetCancelled) sheetCancelled.style.display = 'block';
        }

        filterCohortTable();
    }

    function filterCohortTable() {
        const searchEl = document.getElementById('txtCohortSearch');
        const query = (searchEl ? searchEl.value : '').trim().toLowerCase();
        let tableId = 'tblPresent';
        if (currentCohortSheet === 'noshow') tableId = 'tblNoShow';
        else if (currentCohortSheet === 'cancelled') tableId = 'tblCancelled';

        const rows = document.querySelectorAll('#' + tableId + ' tbody tr.roster-row');
        rows.forEach(function (row) {
            const dataSearch = (row.getAttribute('data-search') || row.innerText || '').toLowerCase();
            row.style.display = (!query || dataSearch.includes(query)) ? '' : 'none';
        });
    }

    // =========================================================================
    // 2. DEMOGRAPHIC BREAKDOWN (DONUT + DROPDOWN SWITCHER)
    // =========================================================================
    function switchDemographicDimension(dimensionKey) {
        const select = document.getElementById('ddlDemographicDimension');
        if (select && select.value !== dimensionKey) {
            select.value = dimensionKey;
        }

        let label = 'Program';
        if (dimensionKey === 'department') label = 'Department';
        else if (dimensionKey === 'branch') label = 'Branch';
        else if (dimensionKey === 'year') label = 'Year Level';

        renderDemographicDimension(dimensionKey, label);
    }

    function renderDemographicDimension(dimensionKey, displayLabel) {
        const list = (telemetryData && telemetryData[dimensionKey]) ? telemetryData[dimensionKey] : [];
        const svg = document.getElementById('demographicsPieSvg');
        const legend = document.getElementById('demographicsLegend');
        const centerCount = document.getElementById('pieCenterCount');
        const centerLabel = document.getElementById('pieCenterLabel');
        const tooltip = document.getElementById('pieInteractiveTooltip');
        const tooltipTitle = document.getElementById('pieTooltipTitle');
        const tooltipCount = document.getElementById('pieTooltipCount');
        const tooltipPercent = document.getElementById('pieTooltipPercent');

        if (!svg || !legend) return;

        svg.innerHTML = '';
        legend.innerHTML = '';

        const totalStudents = list.reduce(function (sum, item) { return sum + item.count; }, 0);
        if (centerCount) centerCount.textContent = totalStudents.toLocaleString();
        if (centerLabel) centerLabel.textContent = displayLabel;

        if (totalStudents === 0 || list.length === 0) {
            svg.innerHTML = '<circle cx="120" cy="120" r="80" fill="none" stroke="#e2e8f0" stroke-width="26" />' +
                            '<text x="120" y="125" text-anchor="middle" font-size="12" fill="#94a3b8" font-family="sans-serif">No Records</text>';
            legend.innerHTML = '<div style="color:var(--text-muted); font-size:0.8rem; padding:0.5rem;">No demographic cohorts registered yet.</div>';
            return;
        }

        const palette = [
            '#2563eb', // Royal Blue
            '#059669', // Emerald
            '#d97706', // Amber
            '#7c3aed', // Violet
            '#e11d48', // Rose
            '#0891b2', // Cyan
            '#4f46e5', // Indigo
            '#16a34a', // Green
            '#ea580c', // Orange
            '#64748b'  // Slate
        ];

        const cx = 120;
        const cy = 120;
        const outerR = 96;
        const innerR = 58;
        let currentAngle = -Math.PI / 2; // start at 12 o'clock

        list.forEach(function (item, index) {
            const color = palette[index % palette.length];
            const fraction = item.count / totalStudents;
            const sliceAngle = fraction * 2 * Math.PI;
            const startAngle = currentAngle;
            const endAngle = currentAngle + sliceAngle;
            currentAngle = endAngle;

            let pathD = '';
            if (fraction >= 0.999) {
                pathD = 'M ' + cx + ' ' + (cy - outerR) +
                        ' A ' + outerR + ' ' + outerR + ' 0 1 1 ' + cx + ' ' + (cy + outerR) +
                        ' A ' + outerR + ' ' + outerR + ' 0 1 1 ' + cx + ' ' + (cy - outerR) +
                        ' M ' + cx + ' ' + (cy - innerR) +
                        ' A ' + innerR + ' ' + innerR + ' 0 1 0 ' + cx + ' ' + (cy + innerR) +
                        ' A ' + innerR + ' ' + innerR + ' 0 1 0 ' + cx + ' ' + (cy - innerR) + ' Z';
            } else {
                const x1 = cx + outerR * Math.cos(startAngle);
                const y1 = cy + outerR * Math.sin(startAngle);
                const x2 = cx + outerR * Math.cos(endAngle);
                const y2 = cy + outerR * Math.sin(endAngle);

                const ix1 = cx + innerR * Math.cos(startAngle);
                const iy1 = cy + innerR * Math.sin(startAngle);
                const ix2 = cx + innerR * Math.cos(endAngle);
                const iy2 = cy + innerR * Math.sin(endAngle);

                const largeArc = (sliceAngle > Math.PI) ? 1 : 0;

                pathD = 'M ' + x1.toFixed(3) + ' ' + y1.toFixed(3) +
                        ' A ' + outerR + ' ' + outerR + ' 0 ' + largeArc + ' 1 ' + x2.toFixed(3) + ' ' + y2.toFixed(3) +
                        ' L ' + ix2.toFixed(3) + ' ' + iy2.toFixed(3) +
                        ' A ' + innerR + ' ' + innerR + ' 0 ' + largeArc + ' 0 ' + ix1.toFixed(3) + ' ' + iy1.toFixed(3) + ' Z';
            }

            const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            path.setAttribute('d', pathD);
            path.setAttribute('fill', color);
            path.setAttribute('class', 'pie-slice');
            path.setAttribute('data-index', index);
            svg.appendChild(path);

            // Legend item row
            const row = document.createElement('div');
            row.className = 'pie-legend-row';
            row.setAttribute('data-index', index);
            row.innerHTML =
                '<div class="pie-legend-left">' +
                    '<span class="pie-legend-dot" style="background-color:' + color + ';"></span>' +
                    '<span title="' + escapeHtml(item.label) + '">' + escapeHtml(item.label) + '</span>' +
                '</div>' +
                '<span class="pie-legend-meta">' + item.count.toLocaleString() + ' (' + item.percentage.toFixed(1) + '%)</span>';
            legend.appendChild(row);

            // Hover interactions
            function onHover(e) {
                path.style.filter = 'drop-shadow(0 6px 12px rgba(0,0,0,0.22))';
                path.style.transform = 'scale(1.045)';
                row.style.backgroundColor = 'var(--brand-subtle)';
                row.style.borderColor = 'var(--brand-border)';

                tooltipTitle.textContent = item.label;
                tooltipCount.textContent = item.count.toLocaleString() + ' Students';
                tooltipPercent.textContent = '(' + item.percentage.toFixed(1) + '%)';
                tooltip.style.display = 'block';
                updateTooltipPosition(e);
            }

            function onMove(e) {
                updateTooltipPosition(e);
            }

            function onLeave() {
                path.style.filter = '';
                path.style.transform = '';
                row.style.backgroundColor = '';
                row.style.borderColor = '';
                tooltip.style.display = 'none';
            }

            path.addEventListener('mouseenter', onHover);
            path.addEventListener('mousemove', onMove);
            path.addEventListener('mouseleave', onLeave);

            row.addEventListener('mouseenter', onHover);
            row.addEventListener('mousemove', onMove);
            row.addEventListener('mouseleave', onLeave);
        });
    }

    function updateTooltipPosition(e) {
        const tooltip = document.getElementById('pieInteractiveTooltip');
        if (!tooltip) return;
        const offset = 14;
        tooltip.style.left = (e.pageX + offset) + 'px';
        tooltip.style.top = (e.pageY + offset) + 'px';
    }

    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    document.addEventListener('DOMContentLoaded', function () {
        initUnifiedDashboard();
    });
</script>

</asp:Content>
