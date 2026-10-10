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
                    <a href="<%= ResolveUrl("~/Frontend/Admin/EventHistory.aspx") %>" class="btn-action-secondary analytics-history-back">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Back to Events History</span>
                    </a>
            </asp:PlaceHolder>
            <h2>Unified Event Analytics &amp; Performance Audit</h2>
            <asp:Panel ID="pnlHistorySubtitle" runat="server" Visible="false" CssClass="analytics-event-summary">
                <div class="analytics-event-fact analytics-event-name">
                    <span class="analytics-fact-label">Event</span>
                    <strong class="analytics-fact-value"><asp:Literal ID="litSubEventTitle" runat="server" /></strong>
                </div>
                <div class="analytics-event-fact">
                    <span class="analytics-fact-label">Date</span>
                    <strong class="analytics-fact-value analytics-fact-mono"><asp:Literal ID="litSubEventDate" runat="server" /></strong>
                </div>
                <div class="analytics-event-fact">
                    <span class="analytics-fact-label">Venue</span>
                    <strong class="analytics-fact-value"><asp:Literal ID="litSubEventVenue" runat="server" /></strong>
                </div>
                <div class="analytics-event-fact">
                    <span class="analytics-fact-label">Capacity</span>
                    <strong class="analytics-fact-value analytics-fact-mono"><asp:Literal ID="litSubEventCapacity" runat="server" /></strong>
                </div>
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

        <!-- 4. Reserved versus cancelled registrations -->
        <div class="telemetry-panel demographics-bento-card reservation-bento-card">
            <div class="panel-header-bar demographics-header-compact">
                <div class="panel-title">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                            <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                        </svg>
                    <span>Reservation Status</span>
                </div>
            </div>
            <div class="panel-body demographics-bento-body">
                <div class="pie-chart-container-bento">
                    <div class="pie-svg-wrapper">
                        <svg id="reservationPieSvg" class="pie-chart-svg reservation-pie <%= ReservationChartTotal == 0 ? "is-empty" : "" %>" viewBox="0 0 240 240" role="img" aria-label="<%= ReservationChartTotal == 0 ? "No reserved or cancelled registrations" : string.Format("Reserved: {0:F1} percent. Cancelled: {1:F1} percent.", ReservationChartReservedPercent, ReservationChartCancelledPercent) %>"></svg>
                        <div class="pie-center-label-box reservation-center-label">
                            <div id="reservationCenterCount" class="reservation-center-count"><%= ReservationChartTotal.ToString("N0") %></div>
                            <div id="reservationCenterLabel" class="reservation-center-caption">Students</div>
                        </div>
                    </div>
                    <div id="reservationLegend" class="pie-chart-legend">
                        <div class="pie-legend-row">
                            <div class="pie-legend-left"><span class="pie-legend-dot reserved-swatch" aria-hidden="true"></span><span>Reserved</span></div>
                            <span class="pie-legend-meta"><%= ReservationChartReservedCount.ToString("N0") %> (<%= ReservationChartReservedPercent.ToString("F1") %>%)</span>
                        </div>
                        <div class="pie-legend-row">
                            <div class="pie-legend-left"><span class="pie-legend-dot cancelled-swatch" aria-hidden="true"></span><span>Cancelled</span></div>
                            <span class="pie-legend-meta"><asp:Literal ID="litBeforeCancelled" runat="server" Text="0" /> (<%= ReservationChartCancelledPercent.ToString("F1") %>%)</span>
                        </div>
                    </div>
                    <p class="reservation-chart-summary"><span id="reservationChartSummary" role="status" aria-live="polite"><%= ReservationChartTotal == 0 ? "No reserved or cancelled registrations" : ReservationChartTotal.ToString("N0") + " reserved or cancelled registrations" %></span><br />Reserved includes present, no-show, and unscanned students.</p>
                </div>
            </div>
        </div>
    </div>

    <section class="telemetry-panel check-in-flow-panel" aria-labelledby="checkInFlowTitle">
        <div class="panel-header-bar check-in-flow-header">
            <div class="check-in-flow-heading">
                <h2 id="checkInFlowTitle" class="panel-title">Check-ins every 15 minutes</h2>
                <p class="check-in-flow-caption" id="checkInFlowDescription">Arrival activity from the first confirmed check-in to the last.</p>
            </div>
            <div class="check-in-flow-controls">
                <div class="check-in-interval-control">
                    <label for="checkInInterval">Interval</label>
                    <select id="checkInInterval" class="dim-dropdown-select check-in-interval-select" onchange="renderCheckInFlowChart()" aria-controls="checkInFlowSvg checkInIntervalRows" <%= HasCheckInIntervals ? "" : "disabled" %>>
                        <option value="5">5 minutes</option>
                        <option value="15" selected="selected">15 minutes</option>
                        <option value="30">30 minutes</option>
                    </select>
                </div>
                <span id="checkInPeakSummary" class="check-in-peak-summary" role="status"><%= Server.HtmlEncode(PeakCheckInSummary) %></span>
            </div>
        </div>
        <div class="panel-body check-in-flow-body">
            <div class="check-in-flow-legend" id="checkInFlowLegend" aria-label="Chart legend">
                <span><i class="check-in-legend-line" aria-hidden="true"></i>Check-ins</span>
                <span><i class="check-in-legend-peak" aria-hidden="true"></i>Peak interval</span>
            </div>
            <p id="checkInFlowEmpty" class="check-in-flow-empty" <%= HasCheckInIntervals ? "hidden" : "" %>>No check-ins recorded yet. The graph will appear once attendance is confirmed.</p>
            <div id="checkInFlowChart" class="check-in-flow-chart" tabindex="0" role="region" aria-label="Check-in graph; scroll horizontally for more intervals" <%= HasCheckInIntervals ? "" : "hidden" %>>
                <svg id="checkInFlowSvg" class="check-in-flow-svg" role="group" aria-labelledby="checkInFlowTitle" aria-describedby="checkInFlowDescription"></svg>
            </div>
            <div class="check-in-flow-footer" id="checkInFlowFooter">
                <p id="checkInFlowPointDetail" class="check-in-point-detail" aria-live="polite">Hover or tap a point. Use arrow keys to explore.</p>
                <button type="button" class="check-in-inspect-peak" onclick="focusCheckInPeak()">Inspect peak
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="m9 18 6-6-6-6" /></svg>
                </button>
            </div>
            <details id="checkInIntervalDetails" class="check-in-interval-details" <%= HasCheckInIntervals ? "" : "hidden" %>>
                <summary>View interval data</summary>
                <div class="table-responsive">
                    <table class="analytics-table">
                        <caption id="checkInTableCaption" class="check-in-table-caption">Check-ins by 15-minute interval</caption>
                        <thead><tr><th scope="col">Time interval</th><th scope="col">Check-ins</th></tr></thead>
                        <tbody id="checkInIntervalRows">
                            <asp:Repeater ID="rptCheckInIntervals" runat="server">
                                <ItemTemplate><tr><td><%#: Eval("IntervalWindow") %></td><td><%#: Eval("CheckInCount") %></td></tr></ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </details>
        </div>
    </section>

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

        <!-- Search and academic filters apply to the active attendee sheet. -->
        <div class="roster-toolbar">
            <div class="controls-row roster-controls" role="group" aria-label="Attendee roster filters">
                <div class="search-box-wrapper">
                    <svg class="search-box-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <input type="search" id="txtCohortSearch" class="search-input" aria-label="Search attendees by Student ID or Full Name" placeholder="Search by Student ID, Name, or Ticket Reference..." oninput="filterCohortTable()" />
                </div>
                <div class="filter-dropdowns-group">
                    <select id="ddlCohortDepartment" class="filter-select" aria-label="Filter attendees by department" onchange="filterCohortTable()">
                        <option value="">All Departments</option>
                    </select>
                    <select id="ddlCohortCourse" class="filter-select" aria-label="Filter attendees by course" onchange="filterCohortTable()">
                        <option value="">All Courses</option>
                    </select>
                    <select id="ddlCohortYear" class="filter-select" aria-label="Filter attendees by year level" onchange="filterCohortTable()">
                        <option value="">All Year Levels</option>
                        <option value="1">1st Year</option>
                        <option value="2">2nd Year</option>
                        <option value="3">3rd Year</option>
                        <option value="4">4th Year</option>
                    </select>
                    <button type="button" class="btn-clear-filters" onclick="resetCohortFilters()">Reset Filters</button>
                </div>
            </div>
            <span id="rosterFilterSummary" class="roster-filter-summary" role="status" aria-live="polite"></span>
        </div>
        <p id="rosterFilterEmpty" class="roster-filter-empty" hidden></p>

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
                                <tr class="roster-row" data-search='<%#: string.Format("{0} {1} {2}", Eval("StudentId"), Eval("StudentFullName"), Eval("TicketReference")) %>'
                                    data-dept='<%#: Eval("StudentDepartment") %>' data-course='<%#: Eval("StudentProgram") %>' data-year='<%#: Eval("CurrentYearLvl") %>'>
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
                                <tr class="roster-row" data-search='<%#: string.Format("{0} {1} {2}", Eval("StudentId"), Eval("StudentFullName"), Eval("TicketReference")) %>'
                                    data-dept='<%#: Eval("StudentDepartment") %>' data-course='<%#: Eval("StudentProgram") %>' data-year='<%#: Eval("CurrentYearLvl") %>'>
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
                                <tr class="roster-row" data-search='<%#: string.Format("{0} {1} {2}", Eval("StudentId"), Eval("StudentFullName"), Eval("TicketReference")) %>'
                                    data-dept='<%#: Eval("StudentDepartment") %>' data-course='<%#: Eval("StudentProgram") %>' data-year='<%#: Eval("CurrentYearLvl") %>'>
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
    </asp:PlaceHolder>

    <!-- Hidden Demographics & Telemetry Data JSON Literal -->
    <script id="demographicsJsonData" type="application/json"><asp:Literal ID="litDemographicsJson" runat="server"></asp:Literal></script>

</div>

<!-- Floating interactive tooltip for mouse hover over pie slices, points, and legend items -->
<div id="checkInFlowTooltip" class="check-in-flow-tooltip" role="tooltip" hidden>
    <div class="check-in-tooltip-header">
        <span id="checkInTooltipWindow" class="check-in-tooltip-window"></span>
        <span id="checkInTooltipPeak" class="check-in-tooltip-peak" hidden>Peak interval</span>
    </div>
    <div class="check-in-tooltip-measure"><strong id="checkInTooltipCount"></strong><span>check-ins</span></div>
    <div id="checkInTooltipShare" class="check-in-tooltip-share"></div>
    <div id="checkInTooltipChange" class="check-in-tooltip-change"></div>
</div>
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
        initializeCohortFilters();
        renderReservationChart();
        renderCheckInFlowChart();
        filterCohortTable();
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
        const department = document.getElementById('ddlCohortDepartment').value;
        const course = document.getElementById('ddlCohortCourse').value;
        const year = document.getElementById('ddlCohortYear').value;
        let tableId = 'tblPresent';
        if (currentCohortSheet === 'noshow') tableId = 'tblNoShow';
        else if (currentCohortSheet === 'cancelled') tableId = 'tblCancelled';

        const rows = document.querySelectorAll('#' + tableId + ' tbody tr.roster-row');
        let visibleCount = 0;
        rows.forEach(function (row) {
            const dataSearch = (row.getAttribute('data-search') || row.innerText || '').toLowerCase();
            const matches = (!query || dataSearch.includes(query)) &&
                (!department || row.getAttribute('data-dept') === department) &&
                (!course || row.getAttribute('data-course') === course) &&
                (!year || row.getAttribute('data-year') === year);
            row.style.display = matches ? '' : 'none';
            if (matches) visibleCount++;
        });
        const label = { present: 'present', noshow: 'no-show', cancelled: 'cancelled' }[currentCohortSheet];
        document.getElementById('rosterFilterSummary').textContent = 'Showing ' + visibleCount.toLocaleString() +
            ' of ' + rows.length.toLocaleString() + ' ' + label + ' attendees';
        const empty = document.getElementById('rosterFilterEmpty');
        empty.hidden = visibleCount > 0;
        empty.textContent = rows.length ? 'No attendees match these filters. Reset Filters to show all records in this tab.' :
            'No ' + label + ' attendees for this event.';
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
        renderDonutChart(list, 'demographicsPieSvg', 'demographicsLegend', 'pieCenterCount', 'pieCenterLabel', displayLabel, 'No demographic cohorts registered yet.');
    }

    function initializeCohortFilters() {
        const registrations = telemetryData.registrations || [];
        [['ddlCohortDepartment', 'department'], ['ddlCohortCourse', 'course']].forEach(function (filter) {
            const select = document.getElementById(filter[0]);
            if (!select) return;
            const values = Array.from(new Set(registrations.map(function (r) { return r[filter[1]]; }).filter(Boolean))).sort();
            values.forEach(function (value) {
                const option = document.createElement('option');
                option.value = value;
                option.textContent = value;
                select.appendChild(option);
            });
        });
    }

    function renderReservationChart() {
        const all = telemetryData.registrations || [];
        const total = all.length;
        const cancelled = all.filter(function (r) { return r.cancelled; }).length;
        const counts = [total - cancelled, cancelled];
        const list = ['Reserved', 'Cancelled'].map(function (label, index) {
            return { label: label, count: counts[index], percentage: total ? 100 * counts[index] / total : 0,
                color: index === 0 ? 'var(--accent-emerald)' : 'var(--accent-rose)' };
        });
        renderDonutChart(list, 'reservationPieSvg', 'reservationLegend', 'reservationCenterCount', 'reservationCenterLabel', 'Students',
            'No reserved or cancelled registrations');
        document.getElementById('reservationChartSummary').textContent = total ? total.toLocaleString() + ' reserved or cancelled registrations' : 'No reserved or cancelled registrations';
    }

    let dismissCheckInTooltip = function () {};
    let repositionCheckInTooltip = function () {};
    let checkInPeakPoint = null;

    function focusCheckInPeak() {
        if (checkInPeakPoint) checkInPeakPoint.focus();
    }

    function getCheckInTooltipPosition(rect, width, height, viewportWidth, viewportHeight) {
        const margin = 12, gap = 12;
        const center = rect.left + rect.width / 2;
        const left = Math.max(margin, Math.min(center - width / 2, viewportWidth - width - margin));
        const fitsAbove = rect.top - height - gap >= margin;
        const top = Math.max(margin, Math.min(fitsAbove ? rect.top - height - gap : rect.bottom + gap, viewportHeight - height - margin));
        return { left: left, top: top, placement: fitsAbove ? 'above' : 'below',
            anchor: Math.max(18, Math.min(center - left, width - 18)) };
    }

    function renderCheckInFlowChart() {
        dismissCheckInTooltip();
        repositionCheckInTooltip = function () {};
        checkInPeakPoint = null;
        const svg = document.getElementById('checkInFlowSvg');
        if (!svg) return;
        const chart = document.getElementById('checkInFlowChart');
        const tooltip = document.getElementById('checkInFlowTooltip');
        const detail = document.getElementById('checkInFlowPointDetail');
        const selector = document.getElementById('checkInInterval');
        const selectedMinutes = Number(selector.value);
        const minutes = [5, 15, 30].includes(selectedMinutes) ? selectedMinutes : 15;
        selector.value = String(minutes);
        const intervals = telemetryData.intervalSeries ? telemetryData.intervalSeries[minutes] || [] : telemetryData.intervals || [];
        const hasData = intervals.length > 0;
        selector.disabled = !hasData;
        document.getElementById('checkInFlowTitle').textContent = 'Check-ins every ' + minutes + ' minutes';
        document.getElementById('checkInTableCaption').textContent = 'Check-ins by ' + minutes + '-minute interval';
        const rows = document.getElementById('checkInIntervalRows');
        rows.innerHTML = '';
        intervals.forEach(function (item) {
            const row = document.createElement('tr');
            [item.window, item.count.toLocaleString()].forEach(function (value) {
                const cell = document.createElement('td');
                cell.textContent = value;
                row.appendChild(cell);
            });
            rows.appendChild(row);
        });
        const peak = intervals.reduce(function (max, item) { return Math.max(max, item.count); }, 0);
        const peaks = intervals.filter(function (item) { return item.count === peak; });
        document.getElementById('checkInPeakSummary').textContent = hasData
            ? 'Peak: ' + peak.toLocaleString() + ' check-ins · ' + peaks[0].window
                + (peaks.length > 1 ? ' (first of ' + peaks.length + ' tied intervals)' : '')
            : 'No check-ins recorded yet.';
        document.getElementById('checkInFlowEmpty').hidden = hasData;
        ['checkInFlowChart', 'checkInIntervalDetails', 'checkInFlowLegend', 'checkInFlowFooter'].forEach(function (id) {
            document.getElementById(id).hidden = !hasData;
        });
        detail.hidden = !hasData;
        svg.innerHTML = '';
        if (!hasData) return;
        detail.textContent = 'Hover or tap a point. Use arrow keys to explore.';

        const height = 300, left = 48, right = 28, top = 40, bottom = 52;
        const width = Math.max(320, chart.clientWidth || 640, intervals.length * 44 + left + right);
        const plotWidth = width - left - right, plotHeight = height - top - bottom;
        const total = intervals.reduce(function (sum, item) { return sum + item.count; }, 0);
        const rawStep = Math.max(1, peak / 5);
        const magnitude = Math.pow(10, Math.floor(Math.log10(rawStep)));
        const step = [1, 2, 5, 10].find(function (value) { return value * magnitude >= rawStep; }) * magnitude;
        const ticks = Math.max(2, Math.ceil(peak / step));
        const maximum = step * ticks;
        const x = function (index) { return intervals.length === 1 ? left + plotWidth / 2 : left + index * plotWidth / (intervals.length - 1); };
        const y = function (count) { return top + plotHeight * (1 - count / maximum); };
        svg.setAttribute('viewBox', '0 0 ' + width + ' ' + height);
        svg.style.width = width + 'px';
        svg.style.minWidth = width + 'px';
        svg.setAttribute('aria-label', 'Check-ins every ' + minutes + ' minutes. Peak: ' + peak.toLocaleString() + ' check-ins.');

        function node(tag, attributes, text, parent) {
            const element = document.createElementNS('http://www.w3.org/2000/svg', tag);
            Object.keys(attributes).forEach(function (key) { element.setAttribute(key, attributes[key]); });
            if (text !== undefined) element.textContent = text;
            (parent || svg).appendChild(element);
            return element;
        }
        for (let tick = 0; tick <= ticks; tick++) {
            const value = tick * step;
            node('line', { x1: left, y1: y(value), x2: width - right, y2: y(value), class: 'check-in-grid-line' });
            node('text', { x: left - 14, y: y(value) + 4, 'text-anchor': 'end', class: 'check-in-axis-label' }, value.toLocaleString());
        }
        node('text', { x: left, y: 17, class: 'check-in-axis-label' }, 'Check-ins');
        node('text', { x: left + plotWidth / 2, y: height - 4, 'text-anchor': 'middle', class: 'check-in-axis-caption' }, 'Interval start time');
        const coordinates = intervals.map(function (item, index) { return x(index) + ',' + y(item.count); }).join(' ');
        node('polygon', { points: x(0) + ',' + y(0) + ' ' + coordinates + ' ' + x(intervals.length - 1) + ',' + y(0), class: 'check-in-area' });
        node('polyline', { points: coordinates, class: 'check-in-line' });
        const guide = node('line', { x1: left, y1: top, x2: left, y2: y(0), class: 'check-in-inspect-guide', visibility: 'hidden' });
        const labelEvery = Math.max(1, Math.ceil(intervals.length / Math.max(1, plotWidth / 108)));
        const points = [];
        let activePoint = null, focusedPoint = null, hideTimer = null;
        function cancelHide() { if (hideTimer !== null) { clearTimeout(hideTimer); hideTimer = null; } }
        function hide() {
            cancelHide();
            if (activePoint) activePoint.classList.remove('is-inspected');
            activePoint = null;
            tooltip.hidden = true;
            guide.setAttribute('visibility', 'hidden');
        }
        function scheduleHide() {
            cancelHide();
            if (!focusedPoint) hideTimer = setTimeout(hide, 180);
        }
        dismissCheckInTooltip = hide;
        repositionCheckInTooltip = function () {
            if (!activePoint || tooltip.hidden) return;
            const rect = activePoint.getBoundingClientRect();
            const chartRect = chart.getBoundingClientRect();
            const center = rect.left + rect.width / 2;
            if (rect.bottom < 0 || rect.top > window.innerHeight || center < 0 || center > window.innerWidth
                || center < chartRect.left || center > chartRect.left + chartRect.width) { hide(); return; }
            const position = getCheckInTooltipPosition(rect, tooltip.offsetWidth, tooltip.offsetHeight, window.innerWidth, window.innerHeight);
            tooltip.style.left = position.left + 'px';
            tooltip.style.top = position.top + 'px';
            tooltip.style.setProperty('--tooltip-anchor', position.anchor + 'px');
            tooltip.setAttribute('data-placement', position.placement);
        };
        tooltip.onmouseenter = cancelHide;
        tooltip.onmouseleave = scheduleHide;
        chart.onmouseleave = scheduleHide;

        intervals.forEach(function (item, index) {
            const px = x(index), py = y(item.count);
            const isPeak = item.count === peak && peak > 0;
            const isLast = index === intervals.length - 1;
            if (index % labelEvery === 0 || (isLast && index % labelEvery * plotWidth / Math.max(1, intervals.length - 1) >= 94)) {
                node('text', { x: px, y: height - 28, 'text-anchor': index === 0 ? 'start' : isLast ? 'end' : 'middle', class: 'check-in-axis-label' }, item.label);
            }
            if (isPeak) node('text', { x: px, y: py - 16, 'text-anchor': 'middle', class: 'check-in-peak-label' }, item.count.toLocaleString());
            const label = item.window + ': ' + item.count.toLocaleString() + ' check-ins' + (isPeak ? ' (peak)' : '');
            const point = node('g', { class: 'check-in-point' + (isPeak ? ' is-peak' : ''), tabindex: 0,
                role: 'img', 'aria-label': label, 'aria-keyshortcuts': 'ArrowLeft ArrowRight Home End Escape',
                'aria-describedby': 'checkInFlowTooltip', 'data-interval-index': index });
            node('circle', { cx: px, cy: py, r: 22, class: 'check-in-hit-area' }, undefined, point);
            node('circle', { cx: px, cy: py, r: isPeak ? 6 : 4.5, class: 'check-in-point-dot' }, undefined, point);
            points.push(point);
            if (isPeak && !checkInPeakPoint) checkInPeakPoint = point;

            function inspect() {
                cancelHide();
                if (activePoint) activePoint.classList.remove('is-inspected');
                activePoint = point;
                point.classList.add('is-inspected');
                detail.textContent = label;
                document.getElementById('checkInTooltipWindow').textContent = item.window;
                document.getElementById('checkInTooltipCount').textContent = item.count.toLocaleString();
                document.getElementById('checkInTooltipPeak').hidden = !isPeak;
                document.getElementById('checkInTooltipShare').textContent = (total ? 100 * item.count / total : 0).toFixed(1) + '% of confirmed arrivals';
                const delta = index > 0 ? item.count - intervals[index - 1].count : 0;
                document.getElementById('checkInTooltipChange').textContent = index === 0 ? 'First recorded interval'
                    : delta === 0 ? 'Same as the previous interval'
                    : Math.abs(delta).toLocaleString() + (delta > 0 ? ' more' : ' fewer') + ' than the previous interval';
                tooltip.hidden = false;
                const position = getCheckInTooltipPosition(point.getBoundingClientRect(), tooltip.offsetWidth, tooltip.offsetHeight, window.innerWidth, window.innerHeight);
                tooltip.style.left = position.left + 'px';
                tooltip.style.top = position.top + 'px';
                tooltip.style.setProperty('--tooltip-anchor', position.anchor + 'px');
                tooltip.setAttribute('data-placement', position.placement);
                guide.setAttribute('x1', px);
                guide.setAttribute('x2', px);
                guide.setAttribute('visibility', 'visible');
            }
            point.addEventListener('mouseenter', inspect);
            point.addEventListener('mouseleave', scheduleHide);
            point.addEventListener('focus', function () { focusedPoint = point; inspect(); });
            point.addEventListener('blur', function () { focusedPoint = null; scheduleHide(); });
            point.addEventListener('click', inspect);
            point.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') { hide(); return; }
                const next = event.key === 'ArrowRight' ? Math.min(index + 1, points.length - 1)
                    : event.key === 'ArrowLeft' ? Math.max(0, index - 1)
                    : event.key === 'Home' ? 0 : event.key === 'End' ? points.length - 1 : null;
                if (next !== null) { event.preventDefault(); points[next].focus(); }
            });
        });
    }

    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') dismissCheckInTooltip();
    });
    document.addEventListener('pointerdown', function (event) {
        const tooltip = document.getElementById('checkInFlowTooltip');
        const svg = document.getElementById('checkInFlowSvg');
        if (tooltip && !tooltip.hidden && !tooltip.contains(event.target) && !svg.contains(event.target)) dismissCheckInTooltip();
    });
    if (window.addEventListener) {
        let chartResizeTimer;
        window.addEventListener('resize', function () {
            dismissCheckInTooltip();
            clearTimeout(chartResizeTimer);
            chartResizeTimer = setTimeout(renderCheckInFlowChart, 120);
        });
        window.addEventListener('scroll', function () { repositionCheckInTooltip(); }, true);
    }

    function resetCohortFilters() {
        ['txtCohortSearch', 'ddlCohortDepartment', 'ddlCohortCourse', 'ddlCohortYear'].forEach(function (id) {
            document.getElementById(id).value = '';
        });
        filterCohortTable();
    }

    // Both charts share geometry, legend highlighting, tooltips, and keyboard inspection.
    function renderDonutChart(list, svgId, legendId, countId, labelId, displayLabel, emptyMessage) {
        const svg = document.getElementById(svgId);
        const legend = document.getElementById(legendId);
        const centerCount = document.getElementById(countId);
        const centerLabel = document.getElementById(labelId);
        const tooltip = document.getElementById('pieInteractiveTooltip');
        const tooltipTitle = document.getElementById('pieTooltipTitle');
        const tooltipCount = document.getElementById('pieTooltipCount');
        const tooltipPercent = document.getElementById('pieTooltipPercent');

        if (!svg || !legend) return;

        svg.innerHTML = '';
        legend.innerHTML = '';
        if (tooltip) tooltip.style.display = 'none';

        const totalStudents = list.reduce(function (sum, item) { return sum + item.count; }, 0);
        if (centerCount) centerCount.textContent = totalStudents.toLocaleString();
        if (centerLabel) centerLabel.textContent = displayLabel;
        svg.setAttribute('role', 'img');
        svg.setAttribute('aria-label', totalStudents ? list.map(function (item) {
            return item.label + ': ' + item.count.toLocaleString() + ' (' + item.percentage.toFixed(1) + '%)';
        }).join('. ') : emptyMessage);
        svg.classList.toggle('is-empty', totalStudents === 0);

        if (totalStudents === 0 || list.length === 0) {
            svg.innerHTML = '<circle cx="120" cy="120" r="77" fill="none" stroke="var(--border-subtle)" stroke-width="38" />';
            const message = document.createElement('div');
            message.className = 'pie-empty-message';
            message.textContent = emptyMessage;
            legend.appendChild(message);
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
            const color = item.color || palette[index % palette.length];
            const fraction = item.count / totalStudents;
            const sliceAngle = fraction * 2 * Math.PI;
            const startAngle = currentAngle;
            const endAngle = currentAngle + sliceAngle;
            currentAngle = endAngle;

            let pathD = '';
            if (fraction === 1) {
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
            path.setAttribute('fill-rule', 'evenodd');
            if (item.count > 0) svg.appendChild(path);

            // Legend item row
            const row = document.createElement('div');
            row.className = 'pie-legend-row';
            row.setAttribute('data-index', index);
            row.tabIndex = 0;
            const left = document.createElement('div');
            left.className = 'pie-legend-left';
            const dot = document.createElement('span');
            dot.className = 'pie-legend-dot';
            dot.style.backgroundColor = color;
            dot.setAttribute('aria-hidden', 'true');
            const label = document.createElement('span');
            label.title = item.label;
            label.textContent = item.label;
            left.appendChild(dot);
            left.appendChild(label);
            const meta = document.createElement('span');
            meta.className = 'pie-legend-meta';
            meta.textContent = item.count.toLocaleString() + ' (' + item.percentage.toFixed(1) + '%)';
            row.appendChild(left);
            row.appendChild(meta);
            legend.appendChild(row);

            // Hover interactions
            function onHover(e) {
                path.classList.add('is-highlighted');
                row.classList.add('is-highlighted');

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
                path.classList.remove('is-highlighted');
                row.classList.remove('is-highlighted');
                tooltip.style.display = 'none';
            }

            path.addEventListener('mouseenter', onHover);
            path.addEventListener('mousemove', onMove);
            path.addEventListener('mouseleave', onLeave);

            row.addEventListener('mouseenter', onHover);
            row.addEventListener('mousemove', onMove);
            row.addEventListener('mouseleave', onLeave);
            row.addEventListener('focus', onHover);
            row.addEventListener('blur', onLeave);
            row.addEventListener('keydown', function (e) { if (e.key === 'Escape') onLeave(); });
        });
    }

    function updateTooltipPosition(e) {
        const tooltip = document.getElementById('pieInteractiveTooltip');
        if (!tooltip) return;
        const offset = 14;
        const rect = e.currentTarget.getBoundingClientRect();
        const x = Number.isFinite(e.clientX) ? e.clientX : rect.left;
        const y = Number.isFinite(e.clientY) ? e.clientY : rect.bottom;
        tooltip.style.left = Math.max(8, Math.min(x + offset, window.innerWidth - tooltip.offsetWidth - 8)) + 'px';
        tooltip.style.top = Math.max(8, Math.min(y + offset, window.innerHeight - tooltip.offsetHeight - 8)) + 'px';
    }

    document.addEventListener('DOMContentLoaded', function () {
        initUnifiedDashboard();
    });
</script>

</asp:Content>
