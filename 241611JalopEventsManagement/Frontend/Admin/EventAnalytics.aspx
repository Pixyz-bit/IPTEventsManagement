<%@ Page Title="Event Telemetry & Analytics" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventAnalytics.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventAnalytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Event Telemetry &amp; Performance Analytics | QCU Event Management
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/event-analytics.css") %>" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="analytics-container">

    <!-- Context Header Banner -->
    <div class="event-context-card">
        <div class="event-context-top">
            <div class="event-title-group">
                <h1>
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <asp:Literal ID="litEventTitle" runat="server" Text="Select an Event"></asp:Literal>
                </h1>
                <div class="event-meta-chips">
                    <span class="meta-chip">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <span>Date: <strong><asp:Literal ID="litEventDate" runat="server" Text="--/--/----"></asp:Literal></strong></span>
                    </span>
                    <span class="meta-chip">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                        </svg>
                        <span>Venue: <strong><asp:Literal ID="litEventVenue" runat="server" Text="--"></asp:Literal></strong></span>
                    </span>
                    <asp:Literal ID="litEventStatusBadge" runat="server"></asp:Literal>
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
            <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="pipeline-tab-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                <span>1. Event Matrix</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventPreRegistered.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="8.5" cy="7" r="4"></circle>
                    <polyline points="17 11 19 13 23 9"></polyline>
                </svg>
                <span>2. Pre-Registered</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/AttendanceScanner.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M4 7V4h3M20 7V4h-3M4 17v3h3M20 17v3h-3M9 9h6v6H9z"></path>
                </svg>
                <span>3. Attendance Scanner</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAttendance.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M9 11l3 3L22 4"></path>
                    <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                </svg>
                <span>4. Event Attendance</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAnalytics.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item active">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="20" x2="18" y2="10"></line>
                    <line x1="12" y1="20" x2="12" y2="4"></line>
                    <line x1="6" y1="20" x2="6" y2="14"></line>
                </svg>
                <span>5. Event Analytics (Active)</span>
            </a>
        </div>
    </div>

    <!-- 3-Phase Lifecycle Master Navigation Tabs (Before, During, After) -->
    <div class="lifecycle-tabs-bar">
        <div class="lifecycle-tabs-group">
            <button type="button" id="tabPhaseBefore" class="lifecycle-tab-btn active" onclick="switchLifecycleTab('before')">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <polyline points="12 6 12 12 16 14"></polyline>
                </svg>
                <span>Before: Pre-Event Analytics</span>
            </button>
            <button type="button" id="tabPhaseDuring" class="lifecycle-tab-btn" onclick="switchLifecycleTab('during')">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="5 3 19 12 5 21 5 3"></polygon>
                </svg>
                <span>During: Live Gate Telemetry</span>
            </button>
            <button type="button" id="tabPhaseAfter" class="lifecycle-tab-btn" onclick="switchLifecycleTab('after')">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
                <span>After: Post-Event Performance Audit</span>
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
            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Total Pre-Registered</span>
                    <span class="analytics-card-value"><asp:Literal ID="litBeforePreRegistered" runat="server" Text="0"></asp:Literal></span>
                    <span class="analytics-card-subtext">Active student enrollments</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--brand-subtle); color:var(--brand-primary); border:1px solid var(--brand-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                    </svg>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Capacity Saturation</span>
                    <span class="analytics-card-value"><asp:Literal ID="litBeforeSaturationRate" runat="server" Text="0.0%"></asp:Literal></span>
                    <span class="analytics-card-subtext">Registered vs venue capacity</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--accent-emerald-subtle); color:var(--accent-emerald); border:1px solid var(--accent-emerald-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
                    </svg>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Available Capacity Pool</span>
                    <span class="analytics-card-value"><asp:Literal ID="litBeforeAvailableQuota" runat="server" Text="0"></asp:Literal></span>
                    <span class="analytics-card-subtext">Seats remaining open</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--accent-amber-subtle); color:var(--accent-amber); border:1px solid var(--accent-amber-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="18" height="18" rx="2"></rect>
                        <line x1="9" y1="9" x2="15" y2="15"></line>
                        <line x1="15" y1="9" x2="9" y2="15"></line>
                    </svg>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Days to Event Launch</span>
                    <span class="analytics-card-value"><asp:Literal ID="litBeforeDaysUntilLaunch" runat="server" Text="0 Days"></asp:Literal></span>
                    <span class="analytics-card-subtext">Countdown to door opening</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--brand-subtle); color:var(--brand-primary); border:1px solid var(--brand-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                </div>
            </div>
        </div>

        <!-- Before Telemetry Grid -->
        <div class="telemetry-dashboard-grid" style="margin-top:1.5rem;">
            <!-- Capacity Saturation & Registration Velocity -->
            <div class="telemetry-panel">
                <div class="panel-header-bar">
                    <div class="panel-title">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="20" x2="18" y2="10"></line>
                            <line x1="12" y1="20" x2="12" y2="4"></line>
                            <line x1="6" y1="20" x2="6" y2="14"></line>
                        </svg>
                        <span>Capacity Saturation Meter</span>
                    </div>
                    <span style="font-size:0.75rem; color:var(--text-muted); font-weight:700;">LIVE QUOTA STATUS</span>
                </div>
                <div class="panel-body">
                    <div style="display:flex; justify-content:space-between; font-size:0.85rem; font-weight:700;">
                        <span>Target Enrollment Progress</span>
                        <span>Pre-Registered Quota Fill</span>
                    </div>
                    <div class="progress-bar-container">
                        <asp:Literal ID="litSaturationProgressBar" runat="server"></asp:Literal>
                    </div>

                    <div style="margin-top:1rem;">
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

            <!-- Demographic Breakdown -->
            <div class="telemetry-panel">
                <div class="panel-header-bar">
                    <div class="panel-title">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        <span>Target Demographics Distribution</span>
                    </div>
                    <span style="font-size:0.75rem; color:var(--text-muted); font-weight:700;">ACADEMIC AUDIT</span>
                </div>
                <div class="panel-body">
                    <h5 style="font-size:0.8rem; text-transform:uppercase; letter-spacing:0.05em; color:var(--text-muted); font-weight:700;">Branch Distribution</h5>
                    <div class="distribution-list">
                        <asp:Repeater ID="rptBranchDistribution" runat="server">
                            <ItemTemplate>
                                <div class="dist-item">
                                    <div class="dist-item-top">
                                        <span class="dist-label"><%# Eval("Label") %></span>
                                        <span class="dist-meta"><%# Eval("Count") %> (<%# Eval("Percentage", "{0:F1}") %>%)</span>
                                    </div>
                                    <div class="dist-track">
                                        <div class="dist-fill-blue" style='width:<%# Eval("Percentage") %>%;'></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <h5 style="font-size:0.8rem; text-transform:uppercase; letter-spacing:0.05em; color:var(--text-muted); font-weight:700; margin-top:0.75rem;">Department Distribution</h5>
                    <div class="distribution-list">
                        <asp:Repeater ID="rptDepartmentDistribution" runat="server">
                            <ItemTemplate>
                                <div class="dist-item">
                                    <div class="dist-item-top">
                                        <span class="dist-label"><%# Eval("Label") %></span>
                                        <span class="dist-meta"><%# Eval("Count") %> (<%# Eval("Percentage", "{0:F1}") %>%)</span>
                                    </div>
                                    <div class="dist-track">
                                        <div class="dist-fill-emerald" style='width:<%# Eval("Percentage") %>%;'></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <h5 style="font-size:0.8rem; text-transform:uppercase; letter-spacing:0.05em; color:var(--text-muted); font-weight:700; margin-top:0.75rem;">Program / Course Distribution (Top 5)</h5>
                    <div class="distribution-list">
                        <asp:Repeater ID="rptCourseDistribution" runat="server">
                            <ItemTemplate>
                                <div class="dist-item">
                                    <div class="dist-item-top">
                                        <span class="dist-label"><%# Eval("Label") %></span>
                                        <span class="dist-meta"><%# Eval("Count") %> (<%# Eval("Percentage", "{0:F1}") %>%)</span>
                                    </div>
                                    <div class="dist-track">
                                        <div class="dist-fill-blue" style='width:<%# Eval("Percentage") %>%;'></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <h5 style="font-size:0.8rem; text-transform:uppercase; letter-spacing:0.05em; color:var(--text-muted); font-weight:700; margin-top:0.75rem;">Year Level Distribution</h5>
                    <div class="distribution-list">
                        <asp:Repeater ID="rptYearDistribution" runat="server">
                            <ItemTemplate>
                                <div class="dist-item">
                                    <div class="dist-item-top">
                                        <span class="dist-label"><%# Eval("Label") %></span>
                                        <span class="dist-meta"><%# Eval("Count") %> (<%# Eval("Percentage", "{0:F1}") %>%)</span>
                                    </div>
                                    <div class="dist-track">
                                        <div class="dist-fill-blue" style='width:<%# Eval("Percentage") %>%;'></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
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
                    <span class="analytics-card-subtext">Out of <asp:Literal ID="litDuringRosterTotal" runat="server" Text="0"></asp:Literal> pre-registered cohort</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--accent-emerald-subtle); color:var(--accent-emerald); border:1px solid var(--accent-emerald-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 6L9 17l-5-5"></path>
                    </svg>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Real-Time Turnout Rate</span>
                    <span class="analytics-card-value"><asp:Literal ID="litDuringTurnoutRate" runat="server" Text="0.0%"></asp:Literal></span>
                    <span class="analytics-card-subtext">Present vs pre-registered cohort</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--brand-subtle); color:var(--brand-primary); border:1px solid var(--brand-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                        <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                    </svg>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Venue Physical Occupancy</span>
                    <span class="analytics-card-value"><asp:Literal ID="litDuringVenueOccupancy" runat="server" Text="0.0%"></asp:Literal></span>
                    <span class="analytics-card-subtext">Of maximum venue safety limit</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--accent-amber-subtle); color:var(--accent-amber); border:1px solid var(--accent-amber-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Unscanned Attendees</span>
                    <span class="analytics-card-value"><asp:Literal ID="litDuringUnscannedCohort" runat="server" Text="0"></asp:Literal></span>
                    <span class="analytics-card-subtext">Pending door arrival</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--bg-hover); color:var(--text-muted); border:1px solid var(--border-medium);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
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
                    <span class="analytics-card-subtext">Original baseline cohort</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--brand-subtle); color:var(--brand-primary); border:1px solid var(--brand-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="8.5" cy="7" r="4"></circle>
                    </svg>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Actual Attended</span>
                    <span class="analytics-card-value"><asp:Literal ID="litAfterActualAttended" runat="server" Text="0"></asp:Literal></span>
                    <span class="analytics-card-subtext">Verified present (<asp:Literal ID="litAfterRetentionRate" runat="server" Text="0.0%"></asp:Literal> retention)</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--accent-emerald-subtle); color:var(--accent-emerald); border:1px solid var(--accent-emerald-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Verified No-Shows</span>
                    <span class="analytics-card-value"><asp:Literal ID="litAfterNoShows" runat="server" Text="0"></asp:Literal></span>
                    <span class="analytics-card-subtext">Absent reserved attendees</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--accent-amber-subtle); color:var(--accent-amber); border:1px solid var(--accent-amber-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="8" y1="12" x2="16" y2="12"></line>
                    </svg>
                </div>
            </div>

            <div class="analytics-card">
                <div class="analytics-card-info">
                    <span class="analytics-card-label">Voided Cancellations</span>
                    <span class="analytics-card-value"><asp:Literal ID="litAfterCancellations" runat="server" Text="0"></asp:Literal></span>
                    <span class="analytics-card-subtext">Revoked passes</span>
                </div>
                <div class="analytics-card-badge" style="background-color:var(--accent-rose-subtle); color:var(--accent-rose); border:1px solid var(--accent-rose-border);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="15" y1="9" x2="9" y2="15"></line>
                        <line x1="9" y1="9" x2="15" y2="15"></line>
                    </svg>
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
                            <div style="font-weight:700; color:var(--text-heading); font-size:0.95rem;"><%= DateTime.Now.ToString("MMMM dd, yyyy") %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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
</script>

</asp:Content>
