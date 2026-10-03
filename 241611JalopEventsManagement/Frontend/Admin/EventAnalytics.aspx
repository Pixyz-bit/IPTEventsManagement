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
                <a href="<%= ResolveUrl("~/Frontend/Admin/Dashboard.aspx") %>">
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
                <span>Event Telemetry &amp; Analytics</span>
            </li>
        </ol>
    </nav>

    <!-- Context Header Banner -->
    <div class="event-context-card">
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
    </div>

    <!-- 3-Phase Lifecycle Master Navigation Tabs (Before, During, After) -->
    <div class="lifecycle-tabs-bar">
        <div class="lifecycle-tabs-group">
            <button type="button" id="tabPhaseBefore" class="lifecycle-tab-btn active" onclick="switchLifecycleTab('before')">
                <span>(Before) Pre-Event Analytics</span>
            </button>
            <button type="button" id="tabPhaseDuring" class="lifecycle-tab-btn" onclick="switchLifecycleTab('during')">
                <span>(During) Live Gate Telemetry</span>
            </button>
            <button type="button" id="tabPhaseAfter" class="lifecycle-tab-btn" onclick="switchLifecycleTab('after')">
                <span>(After) Post-Event Performance Audit</span>
            </button>
        </div>

        <div class="export-actions-group">
            <asp:LinkButton ID="btnExportSummaryPdf" runat="server" CssClass="btn-export-pdf" OnClientClick="window.print(); return false;" ToolTip="Print / Export Official University Summary PDF">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="6 9 6 2 18 2 18 9"></polyline>
                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                    <rect x="6" y="14" width="12" height="8"></rect>
                </svg>
                <span>Export University Summary (PDF)</span>
            </asp:LinkButton>

            <asp:LinkButton ID="btnExportComprehensiveCsv" runat="server" CssClass="btn-export-excel" OnClick="btnExportComprehensiveCsv_Click" ToolTip="Download Detailed Multi-Cohort Telemetry CSV">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                    <polyline points="7 10 12 15 17 10"></polyline>
                    <line x1="12" y1="15" x2="12" y2="3"></line>
                </svg>
                <span>Export Detailed Excel / CSV</span>
            </asp:LinkButton>
        </div>
    </div>

    <!-- =========================================================================
         PHASE 1: BEFORE - PRE-EVENT ANALYTICS
         ========================================================================= -->
    <div id="sectionPhaseBefore" class="lifecycle-phase-section">
        <!-- Before KPI Grid -->
        <div class="analytics-kpi-grid">
            <!-- 1. Total Pre-Registered -->
            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Total Pre-Registered</span>
                    <span class="analytics-card-value"><asp:Literal ID="litBeforePreRegistered" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>

            <!-- 2. Total Reserved -->
            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Total Reserved</span>
                    <span class="analytics-card-value"><asp:Literal ID="litBeforeTotalReserved" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>

            <!-- 3. Cancelled -->
            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Cancelled</span>
                    <span class="analytics-card-value"><asp:Literal ID="litBeforeCancelled" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>

            <!-- Hidden State Holders for Removed Controls/Cards -->
            <asp:PlaceHolder ID="phAttritionAndSaturationHidden" runat="server" Visible="false">
                <asp:Literal ID="litBeforeAttritionRate" runat="server" Text="0.0%"></asp:Literal>
                <asp:Literal ID="litBeforeSaturationRate" runat="server" Text="0.0%"></asp:Literal>
                <asp:Literal ID="litBeforeSaturationStatus" runat="server" Text="Undersubscribed"></asp:Literal>
                <asp:Literal ID="litBeforeDaysUntilLaunch" runat="server" Text="0 Days"></asp:Literal>
                <asp:Literal ID="litDuringRosterTotal" runat="server" Text="0"></asp:Literal>
                <asp:Literal ID="litAfterRetentionRate" runat="server" Text="0.0%"></asp:Literal>
            </asp:PlaceHolder>

            <!-- 6. Available Capacity Pool -->
            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Available Capacity Pool</span>
                    <span class="analytics-card-value"><asp:Literal ID="litBeforeAvailableQuota" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>
        </div>

        <!-- Before Telemetry Grid -->
        <div class="telemetry-dashboard-grid" style="margin-top:1.5rem;">
            <!-- Left: Capacity Saturation & Pre-Event Attrition Formula Callouts + Timeline -->
            <div class="telemetry-panel">
                <div class="panel-header-bar">
                    <div class="panel-title">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="20" x2="18" y2="10"></line>
                            <line x1="12" y1="20" x2="12" y2="4"></line>
                            <line x1="6" y1="20" x2="6" y2="14"></line>
                        </svg>
                        <span>Capacity Saturation Meter &amp; Attrition Audit</span>
                    </div>
                    <span style="font-size:0.75rem; color:var(--text-muted); font-weight:700;">LIVE QUOTA TELEMETRY</span>
                </div>
                <div class="panel-body">
                    <!-- Photo 4 Formula Card -->
                    <div class="formula-spec-card">
                        <div class="formula-spec-top">
                            <span class="formula-title">Capacity Saturation Meter</span>
                            <span class="formula-code">CurrentRegistrations / MaxCapacity</span>
                        </div>
                        <div class="formula-desc">Real-time gauge showing whether the event is undersubscribed, at capacity, or needs a larger venue.</div>
                    </div>

                    <!-- Photo 5 Formula Card -->
                    <div class="formula-spec-card">
                        <div class="formula-spec-top">
                            <span class="formula-title">Pre-Event Attrition Rate</span>
                            <span class="formula-code">Status = 'Cancelled' before EventStart</span>
                        </div>
                        <div class="formula-desc">Identifies drop-offs and tickets released back into the pool.</div>
                    </div>

                    <!-- Real-time Quota Saturation Gauge -->
                    <div style="margin-top:0.25rem;">
                        <div style="display:flex; justify-content:space-between; align-items:center; font-size:0.85rem; font-weight:700; margin-bottom:0.4rem;">
                            <span>Target Quota Utilization</span>
                            <span style="font-family:var(--font-mono); font-size:0.875rem;"><asp:Literal ID="litSaturationPercentDisplay" runat="server">0.0%</asp:Literal></span>
                        </div>
                        <div class="progress-bar-container">
                            <asp:Literal ID="litSaturationProgressBar" runat="server"></asp:Literal>
                        </div>
                        <div style="display:flex; justify-content:space-between; font-size:0.75rem; color:var(--text-muted); margin-top:0.4rem;">
                            <span>0 Enrolled</span>
                            <span>Max Capacity: <asp:Literal ID="litCapacityMaxDisplay" runat="server">100</asp:Literal> Seats</span>
                        </div>
                    </div>

                    <!-- Registration Velocity Timeline Table -->
                    <div style="margin-top:0.75rem;">
                        <h4 style="font-size:0.875rem; font-weight:700; margin-bottom:0.75rem; color:var(--text-heading);">Registration Velocity Timeline</h4>
                        <table class="analytics-table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Daily Enrollees</th>
                                    <th>Cumulative Cohort</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptRegistrationVelocity" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><strong><%# Eval("DateLabel") %></strong></td>
                                            <td>+<%# Eval("RegistrationsCount") %> Students</td>
                                            <td><span class="rate-badge rate-badge-mid"><%# Eval("CumulativeCount") %> Total</span></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Right: Target Demographics Distribution (Interactive SVG Pie / Donut Chart) -->
            <div class="telemetry-panel">
                <div class="panel-header-bar">
                    <div class="panel-title">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                            <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                        </svg>
                        <span>Target Demographics Distribution</span>
                    </div>
                    <span style="font-size:0.75rem; color:var(--text-muted); font-weight:700;">INTERACTIVE COHORT AUDIT</span>
                </div>
                <div class="panel-body">
                    <!-- Dimension Switcher Bar -->
                    <div class="dimension-switcher-bar">
                        <div class="dim-dropdown-group">
                            <label for="ddlDemographicDimension" class="dim-dropdown-label">Cohort Breakdown:</label>
                            <select id="ddlDemographicDimension" class="dim-dropdown-select" onchange="switchDemographicDimension(this.value)">
                                <option value="department" selected="selected">Department</option>
                                <option value="course">Program / Course</option>
                                <option value="branch">Campus Branch</option>
                                <option value="year">Year Level</option>
                            </select>
                        </div>
                    </div>

                    <!-- Pie Chart & Legend Grid -->
                    <div class="pie-dashboard-layout">
                        <div class="pie-chart-container" id="pieChartWrapper">
                            <svg id="demographicsPieSvg" class="pie-chart-svg" viewBox="0 0 240 240"></svg>
                        </div>
                        <div id="demographicsLegend" class="pie-chart-legend">
                            <!-- Populated via JS -->
                        </div>
                    </div>

                    <!-- Hidden Demographics Data JSON Literal -->
                    <script id="demographicsJsonData" type="application/json"><asp:Literal ID="litDemographicsJson" runat="server"></asp:Literal></script>

                    <!-- Hidden Legacy Repeaters for Seamless Designer / Backward Compatibility -->
                    <div style="display:none;" aria-hidden="true">
                        <asp:Repeater ID="rptBranchDistribution" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
                        <asp:Repeater ID="rptDepartmentDistribution" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
                        <asp:Repeater ID="rptCourseDistribution" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
                        <asp:Repeater ID="rptYearDistribution" runat="server"><ItemTemplate></ItemTemplate></asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- =========================================================================
         PHASE 2: DURING - LIVE GATE TELEMETRY
         ========================================================================= -->
    <div id="sectionPhaseDuring" class="lifecycle-phase-section" style="display:none;">
        <div class="analytics-kpi-grid">
            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Total Verified Checked-In</span>
                    <span class="analytics-card-value"><asp:Literal ID="litDuringCheckedIn" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Real-Time Turnout Rate</span>
                    <span class="analytics-card-value"><asp:Literal ID="litDuringTurnoutRate" runat="server" Text="0.0%"></asp:Literal></span>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Venue Physical Occupancy</span>
                    <span class="analytics-card-value"><asp:Literal ID="litDuringVenueOccupancy" runat="server" Text="0.0%"></asp:Literal></span>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Unscanned Attendees</span>
                    <span class="analytics-card-value"><asp:Literal ID="litDuringUnscannedCohort" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>
        </div>

        <div class="telemetry-dashboard-grid" style="margin-top:1.5rem;">
            <!-- 15-Minute Peak Surge Velocity -->
            <div class="telemetry-panel">
                <div class="panel-header-bar">
                    <div class="panel-title">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                        </svg>
                        <span>Check-In Velocity Timeline (15-Min Surges)</span>
                    </div>
                    <span style="font-size:0.75rem; color:var(--brand-primary); font-weight:700;">PEAK: <asp:Literal ID="litDuringPeakWindow" runat="server"></asp:Literal></span>
                </div>
                <div class="panel-body">
                    <table class="analytics-table">
                        <thead>
                            <tr>
                                <th>15-Minute Time Interval</th>
                                <th>Admitted Attendees</th>
                                <th>Gate Surge Intensity</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptCheckInIntervals" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><strong><%# Eval("IntervalWindow") %></strong></td>
                                        <td><span class="rate-badge rate-badge-high"><%# Eval("CheckInCount") %> Check-Ins</span></td>
                                        <td>
                                            <div class="dist-track" style="height:6px; max-width:180px;">
                                                <div class="dist-fill-emerald" style='width:<%# Eval("IntensityPercent") %>%;'></div>
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Terminal Operations Integrity -->
            <div class="telemetry-panel">
                <div class="panel-header-bar">
                    <div class="panel-title">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                        <span>Terminal Gate Integrity &amp; Flow Control</span>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="accreditation-block">
                        <div class="accreditation-seal">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                            <span>Live Transactional State Active</span>
                        </div>
                        <p style="color:var(--text-body); line-height:1.5;">
                            All attendance entries are cryptographically stamped with high-precision server timestamps. 
                            Duplicate check-ins and un-registered pass attempts are atomically intercepted at the gate.
                        </p>
                        <div style="font-size:0.75rem; color:var(--text-muted);">
                            Active Admin Operator: <strong><%= CurrentAdminEmail %></strong> &bull; Database Connection: <strong>ONLINE</strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- =========================================================================
         PHASE 3: AFTER - POST-EVENT PERFORMANCE AUDIT
         ========================================================================= -->
    <div id="sectionPhaseAfter" class="lifecycle-phase-section" style="display:none;">
        <div class="analytics-kpi-grid">
            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Pre-Registered Roster</span>
                    <span class="analytics-card-value"><asp:Literal ID="litAfterPreRegisteredTotal" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Actual Attended</span>
                    <span class="analytics-card-value"><asp:Literal ID="litAfterActualAttended" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Verified No-Shows</span>
                    <span class="analytics-card-value"><asp:Literal ID="litAfterNoShows" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Voided Cancellations</span>
                    <span class="analytics-card-value"><asp:Literal ID="litAfterCancellations" runat="server" Text="0"></asp:Literal></span>
                </div>
            </div>
        </div>

        <!-- Comparative Demographic Turnout Audit Table -->
        <div class="telemetry-panel" style="margin-top:1.5rem;">
            <div class="panel-header-bar">
                <div class="panel-title">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="16" y1="13" x2="8" y2="13"></line>
                        <line x1="16" y1="17" x2="8" y2="17"></line>
                    </svg>
                    <span>Comparative Departmental Engagement Audit</span>
                </div>
                <span style="font-size:0.75rem; color:var(--brand-primary); font-weight:700;">TOP ENGAGED: <asp:Literal ID="litAfterTopDepartment" runat="server"></asp:Literal></span>
            </div>
            <div class="panel-body" style="padding:0;">
                <table class="analytics-table">
                    <thead>
                        <tr>
                            <th>Academic Department</th>
                            <th>Pre-Registered Total</th>
                            <th>Actual Attended</th>
                            <th>Verified No-Shows</th>
                            <th>Turnout Engagement Rate</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptDemographicAudit" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><strong><%# Eval("Department") %></strong></td>
                                    <td><%# Eval("PreRegistered") %> Students</td>
                                    <td><strong style="color:var(--accent-emerald-text);"><%# Eval("Attended") %></strong></td>
                                    <td><span style="color:var(--text-muted);"><%# Eval("NoShows") %></span></td>
                                    <td>
                                        <span class='<%# Convert.ToDouble(Eval("AttendanceRate")) >= 80 ? "rate-badge rate-badge-high" : (Convert.ToDouble(Eval("AttendanceRate")) >= 50 ? "rate-badge rate-badge-mid" : "rate-badge rate-badge-low") %>'>
                                            <%# Eval("AttendanceRate", "{0:F1}") %>% Turnout
                                        </span>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Institutional Compliance Certificate -->
        <div class="telemetry-panel" style="margin-top:1.5rem;">
            <div class="panel-header-bar">
                <div class="panel-title">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="8" r="7"></circle>
                        <polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline>
                    </svg>
                    <span>Official University Accreditation &amp; Academic Credit Audit Certification</span>
                </div>
            </div>
            <div class="panel-body">
                <div class="accreditation-block">
                    <div class="accreditation-seal">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                        </svg>
                        <span>Official Compliance Verification Statement</span>
                    </div>
                    <p style="color:var(--text-body); line-height:1.6;">
                        This document certifies that the event attendance telemetry recorded herein represents authentic, verified physical door entries 
                        conducted in strict compliance with Quezon City University academic activity guidelines. 
                        Records are validated for institutional accreditation credits, extracurricular participation logs, and CHED compliance audits.
                    </p>
                    <div style="display:flex; justify-content:space-between; align-items:flex-end; margin-top:1.5rem; flex-wrap:wrap; gap:1rem;">
                        <div>
                            <div style="font-size:0.75rem; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.05em; font-weight:700;">Auditing Administrator</div>
                            <div style="font-weight:700; color:var(--text-heading); font-size:0.95rem;"><%= CurrentAdminEmail %></div>
                            <div style="font-size:0.75rem; color:var(--text-muted);">Office of Student Affairs &amp; University Events Console</div>
                        </div>
                        <div>
                            <div style="font-size:0.75rem; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.05em; font-weight:700;">Certified Audit Date</div>
                            <div style="font-weight:700; color:var(--text-heading); font-size:0.95rem;"><%= DateTime.Now.ToString("MM/dd/yyyy") %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- Floating interactive tooltip for mouse hover over pie slices and legend items -->
<div id="pieInteractiveTooltip" class="pie-interactive-tooltip">
    <div id="pieTooltipTitle" class="tooltip-title">Demographic Category</div>
    <div id="pieTooltipBody" class="tooltip-body">
        <span id="pieTooltipCount" style="font-weight:700;">0 Students</span>
        <span id="pieTooltipPercent" style="opacity:0.85;">(0.0%)</span>
    </div>
</div>

<script type="text/javascript">
    function switchLifecycleTab(phase) {
        // Tab buttons
        document.getElementById('tabPhaseBefore').classList.remove('active');
        document.getElementById('tabPhaseDuring').classList.remove('active');
        document.getElementById('tabPhaseAfter').classList.remove('active');

        // Content sections
        document.getElementById('sectionPhaseBefore').style.display = 'none';
        document.getElementById('sectionPhaseDuring').style.display = 'none';
        document.getElementById('sectionPhaseAfter').style.display = 'none';

        if (phase === 'before') {
            document.getElementById('tabPhaseBefore').classList.add('active');
            document.getElementById('sectionPhaseBefore').style.display = 'block';
        } else if (phase === 'during') {
            document.getElementById('tabPhaseDuring').classList.add('active');
            document.getElementById('sectionPhaseDuring').style.display = 'block';
        } else if (phase === 'after') {
            document.getElementById('tabPhaseAfter').classList.add('active');
            document.getElementById('sectionPhaseAfter').style.display = 'block';
        }
    }

    // =========================================================================
    // INTERACTIVE PIE / DONUT GRAPH FOR TARGET DEMOGRAPHICS
    // =========================================================================
    let demographicsData = {};

    function initDemographicsPieChart() {
        const rawDataEl = document.getElementById('demographicsJsonData');
        if (rawDataEl && rawDataEl.textContent.trim()) {
            try {
                demographicsData = JSON.parse(rawDataEl.textContent);
            } catch (e) {
                console.error("Failed to parse demographics data:", e);
            }
        }
        const select = document.getElementById('ddlDemographicDimension');
        const initialDim = select ? select.value : 'department';
        let label = 'Department';
        if (initialDim === 'course') label = 'Program';
        else if (initialDim === 'branch') label = 'Branch';
        else if (initialDim === 'year') label = 'Year Level';
        renderDemographicDimension(initialDim, label);
    }

    function switchDemographicDimension(dimensionKey) {
        const select = document.getElementById('ddlDemographicDimension');
        if (select && select.value !== dimensionKey) {
            select.value = dimensionKey;
        }

        let label = 'Department';
        if (dimensionKey === 'course') label = 'Program';
        else if (dimensionKey === 'branch') label = 'Branch';
        else if (dimensionKey === 'year') label = 'Year Level';

        renderDemographicDimension(dimensionKey, label);
    }

    function renderDemographicDimension(dimensionKey, displayLabel) {
        const list = (demographicsData && demographicsData[dimensionKey]) ? demographicsData[dimensionKey] : [];
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
        let currentAngle = -Math.PI / 2; // start at top (12 o'clock)

        list.forEach(function (item, index) {
            const color = palette[index % palette.length];
            const fraction = item.count / totalStudents;
            const sliceAngle = fraction * 2 * Math.PI;
            const startAngle = currentAngle;
            const endAngle = currentAngle + sliceAngle;
            currentAngle = endAngle;

            let pathD = '';
            if (fraction >= 0.999) {
                // Single 100% slice donut
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

            // Hover handlers for both slice & legend row
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
        initDemographicsPieChart();
    });
</script>

</asp:Content>
