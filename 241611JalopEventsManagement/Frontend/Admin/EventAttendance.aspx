<%@ Page Title="Event Attendance Roster" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventAttendance.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventAttendance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Live Event Attendance Roster | QCU Event Management
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ==========================================================================
           Event Attendance Roster - Dedicated Table Page
           Institutional Clean White Palette (#ffffff surfaces, #2563eb primary)
           Strict MM/dd/yyyy hh:mm:ss tt Timestamp Standard
           ========================================================================== */

        .attendance-container {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            width: 100%;
        }

        /* Context Header Banner (Pure White Card) */
        .event-context-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-left: 4px solid var(--brand-primary);
            border-radius: var(--radius-lg);
            padding: 1.5rem 1.75rem;
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
            box-shadow: var(--shadow-card);
        }

        .event-context-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .event-title-group h1 {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.02em;
            margin: 0 0 0.45rem 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .event-meta-chips {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.65rem;
            font-size: 0.825rem;
            color: var(--text-body);
        }

        .meta-chip {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background-color: var(--bg-subtle);
            padding: 0.3rem 0.75rem;
            border-radius: var(--radius-full);
            border: 1px solid var(--border-subtle);
            color: var(--text-body);
            font-size: 0.8rem;
        }

        .meta-chip strong {
            color: var(--text-heading);
            font-weight: 700;
        }

        .event-switcher {
            display: flex;
            align-items: center;
            gap: 0.65rem;
        }

        .event-switcher label {
            font-size: 0.825rem;
            color: var(--text-muted);
            font-weight: 700;
            white-space: nowrap;
        }

        .event-dropdown-select {
            background-color: #ffffff;
            border: 1px solid var(--border-medium);
            color: var(--text-heading);
            padding: 0.5rem 0.85rem;
            border-radius: var(--radius-md);
            font-size: 0.85rem;
            font-family: inherit;
            outline: none;
            cursor: pointer;
            min-width: 250px;
            box-shadow: var(--shadow-subtle);
            transition: all 0.15s ease;
        }

        .event-dropdown-select:focus {
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 3px var(--brand-focus-ring);
        }

        /* Sub-module Pipeline Tabs */
        .pipeline-tabs-wrapper {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border-top: 1px solid var(--border-subtle);
            padding-top: 1rem;
            overflow-x: auto;
        }

        .pipeline-tab-item {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.45rem 1rem;
            border-radius: var(--radius-md);
            font-size: 0.825rem;
            font-weight: 600;
            color: var(--text-muted);
            text-decoration: none;
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            box-shadow: var(--shadow-subtle);
            transition: all 0.15s ease;
            white-space: nowrap;
        }

        .pipeline-tab-item:hover {
            color: var(--brand-primary);
            border-color: var(--brand-border);
            background-color: var(--brand-subtle);
        }

        .pipeline-tab-item.active {
            color: var(--brand-primary);
            background-color: var(--brand-subtle);
            border-color: var(--brand-border);
            font-weight: 700;
        }

        /* Attendance Summary Metric Cards */
        .metrics-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem;
        }

        .metric-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 1.25rem 1.35rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: var(--shadow-card);
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        .metric-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-elevated);
        }

        .metric-details {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .metric-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .metric-value {
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--text-heading);
            line-height: 1.2;
        }

        .metric-subtext {
            font-size: 0.75rem;
            color: var(--text-muted);
        }

        .metric-icon-badge {
            width: 46px;
            height: 46px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .metric-icon-emerald {
            background-color: var(--accent-emerald-subtle);
            color: var(--accent-emerald);
            border: 1px solid var(--accent-emerald-border);
        }

        .metric-icon-blue {
            background-color: var(--brand-subtle);
            color: var(--brand-primary);
            border: 1px solid var(--brand-border);
        }

        .metric-icon-amber {
            background-color: var(--accent-amber-subtle);
            color: var(--accent-amber);
            border: 1px solid var(--accent-amber-border);
        }

        /* Filter & Search Bar */
        .controls-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 1.15rem 1.35rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            box-shadow: var(--shadow-card);
        }

        .controls-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .search-box-wrapper {
            position: relative;
            flex: 1 1 280px;
            max-width: 420px;
        }

        .search-box-icon {
            position: absolute;
            left: 0.85rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            pointer-events: none;
        }

        .search-input {
            width: 100%;
            background-color: #ffffff;
            border: 1px solid var(--border-medium);
            border-radius: var(--radius-md);
            padding: 0.55rem 0.85rem 0.55rem 2.4rem;
            color: var(--text-heading);
            font-size: 0.85rem;
            font-family: inherit;
            outline: none;
            transition: all 0.15s ease;
        }

        .search-input:focus {
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 3px var(--brand-focus-ring);
        }

        .filter-dropdowns-group {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.65rem;
        }

        .filter-select {
            background-color: #ffffff;
            border: 1px solid var(--border-medium);
            color: var(--text-heading);
            padding: 0.5rem 0.85rem;
            border-radius: var(--radius-md);
            font-size: 0.825rem;
            font-family: inherit;
            outline: none;
            cursor: pointer;
            box-shadow: var(--shadow-subtle);
            transition: all 0.15s ease;
        }

        .filter-select:focus {
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 3px var(--brand-focus-ring);
        }

        .btn-export-csv {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            background-color: var(--accent-emerald-subtle);
            color: var(--accent-emerald-text);
            border: 1px solid var(--accent-emerald-border);
            padding: 0.5rem 1rem;
            border-radius: var(--radius-md);
            font-size: 0.825rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            box-shadow: var(--shadow-subtle);
            transition: all 0.15s ease;
        }

        .btn-export-csv:hover {
            background-color: #d1fae5;
            color: var(--accent-emerald);
        }

        /* Dedicated Attendance Table Card */
        .table-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-card);
        }

        .table-header-bar {
            padding: 1.15rem 1.35rem;
            border-bottom: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #fafbfc;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        .table-header-title {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-heading);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .live-indicator-dot {
            width: 8px;
            height: 8px;
            background-color: var(--accent-emerald);
            border-radius: 50%;
            display: inline-block;
            box-shadow: 0 0 8px var(--accent-emerald);
            animation: pulseDot 2s infinite ease-in-out;
        }

        @keyframes pulseDot {
            0%, 100% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.3); opacity: 0.6; }
        }

        .attendance-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.85rem;
        }

        .attendance-table th {
            background-color: #fafbfc;
            color: var(--text-muted);
            font-weight: 700;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 0.9rem 1.15rem;
            border-bottom: 1px solid var(--border-subtle);
            white-space: nowrap;
        }

        .attendance-table td {
            padding: 0.95rem 1.15rem;
            border-bottom: 1px solid var(--border-subtle);
            color: var(--text-body);
            vertical-align: middle;
        }

        .attendance-table tbody tr:hover td {
            background-color: var(--bg-hover);
        }

        .timestamp-badge {
            font-family: var(--font-mono);
            font-size: 0.8rem;
            color: var(--accent-emerald-text);
            background-color: var(--accent-emerald-subtle);
            border: 1px solid var(--accent-emerald-border);
            padding: 0.25rem 0.6rem;
            border-radius: var(--radius-sm);
            white-space: nowrap;
            font-weight: 700;
        }

        .ticket-code {
            font-family: var(--font-mono);
            font-weight: 700;
            color: var(--brand-primary);
            background-color: var(--brand-subtle);
            padding: 0.25rem 0.6rem;
            border-radius: var(--radius-sm);
            border: 1px solid var(--brand-border);
            font-size: 0.8rem;
            display: inline-block;
            white-space: nowrap;
        }

        .student-id-text {
            font-family: var(--font-mono);
            font-size: 0.875rem;
            font-weight: 700;
            color: var(--text-heading);
            letter-spacing: -0.01em;
            white-space: nowrap;
        }

        .method-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            font-size: 0.75rem;
            padding: 0.2rem 0.6rem;
            border-radius: var(--radius-sm);
            background-color: var(--bg-subtle);
            border: 1px solid var(--border-subtle);
            color: var(--text-body);
            font-weight: 600;
            white-space: nowrap;
        }

        .empty-roster-state {
            padding: 4rem 1.5rem;
            text-align: center;
            color: var(--text-muted);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
        }

        .empty-roster-state svg {
            color: var(--text-light);
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="attendance-container">

    <!-- Context Header Banner -->
    <div class="event-context-card">
        <div class="event-context-top">
            <div class="event-title-group">
                <h1>
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                        <path d="M9 11l3 3L22 4"></path>
                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
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
                    <span class="meta-chip">
                        <span>Verified Present: <strong><asp:Literal ID="litCheckedInCount" runat="server" Text="0"></asp:Literal></strong></span>
                    </span>
                    <span class="meta-chip">
                        <span>Event Quota: <strong><asp:Literal ID="litCapacitySummary" runat="server" Text="0 / 0"></asp:Literal></strong></span>
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
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAttendance.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item active">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M9 11l3 3L22 4"></path>
                    <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                </svg>
                <span>4. Event Attendance</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAnalytics.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="20" x2="18" y2="10"></line>
                    <line x1="12" y1="20" x2="12" y2="4"></line>
                    <line x1="6" y1="20" x2="6" y2="14"></line>
                </svg>
                <span>5. Event Analytics</span>
            </a>
        </div>
    </div>

    <!-- Attendance Summary Metrics -->
    <div class="metrics-row">
        <div class="metric-card">
            <div class="metric-details">
                <span class="metric-label">Total Verified Checked-In</span>
                <span class="metric-value"><asp:Literal ID="litKpiTotalCheckedIn" runat="server" Text="0"></asp:Literal></span>
                <span class="metric-subtext">Authenticated physical door entries</span>
            </div>
            <div class="metric-icon-badge metric-icon-emerald">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 6L9 17l-5-5"></path>
                </svg>
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-details">
                <span class="metric-label">Actual Turnout Rate</span>
                <span class="metric-value"><asp:Literal ID="litKpiTurnoutRate" runat="server" Text="0.0%"></asp:Literal></span>
                <span class="metric-subtext">Present vs. pre-registered pool</span>
            </div>
            <div class="metric-icon-badge metric-icon-blue">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                    <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                </svg>
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-details">
                <span class="metric-label">Latest Check-In</span>
                <span class="metric-value" style="font-size:1.35rem;"><asp:Literal ID="litKpiLatestCheckIn" runat="server" Text="--:--:--"></asp:Literal></span>
                <span class="metric-subtext">Most recent gate transaction</span>
            </div>
            <div class="metric-icon-badge metric-icon-amber">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <polyline points="12 6 12 12 16 14"></polyline>
                </svg>
            </div>
        </div>
    </div>

    <!-- Search & Filter Controls -->
    <div class="controls-card">
        <div class="controls-row">
            <div class="search-box-wrapper">
                <svg class="search-box-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" Placeholder="Search by Student ID, Attendee Name, or Ticket Ref..." onkeyup="filterAttendanceTable()" />
            </div>

            <div class="filter-dropdowns-group">
                <asp:DropDownList ID="ddlDepartmentFilter" runat="server" CssClass="filter-select" onchange="filterAttendanceTable()">
                    <asp:ListItem Text="All Departments" Value="" />
                </asp:DropDownList>

                <asp:DropDownList ID="ddlProgramFilter" runat="server" CssClass="filter-select" onchange="filterAttendanceTable()">
                    <asp:ListItem Text="All Courses" Value="" />
                </asp:DropDownList>

                <asp:LinkButton ID="btnExportCsv" runat="server" CssClass="btn-export-csv" OnClick="btnExportCsv_Click">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="7 10 12 15 17 10"></polyline>
                        <line x1="12" y1="15" x2="12" y2="3"></line>
                    </svg>
                    <span>Export Attendance CSV</span>
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <!-- Dedicated Table: Live Checked-In Attendance Roster (Photo 4) -->
    <div class="table-card">
        <div class="table-header-bar">
            <div class="table-header-title">
                <span class="live-indicator-dot"></span>
                <span>Live Checked-In Attendance Roster</span>
            </div>
            <div style="font-size:0.8rem; color:var(--text-muted);">
                Chronological gate log &bull; Authenticated database commits
            </div>
        </div>

        <div style="overflow-x:auto;">
            <table class="attendance-table" id="tblAttendance">
                <thead>
                    <tr>
                        <th style="width: 17%;">Verified Timestamp</th>
                        <th style="width: 14%;">Ticket Ref</th>
                        <th style="width: 12%;">Student ID</th>
                        <th style="width: 20%;">Attendee Full Name</th>
                        <th style="width: 21%;">Program &amp; Year / Section</th>
                        <th style="width: 16%;">Verification Method</th>
                        <th>Inspecting Admin</th>
                    </tr>
                </thead>
                <tbody id="tbodyAttendance">
                    <asp:Repeater ID="rptCheckedInAttendees" runat="server">
                        <ItemTemplate>
                            <tr class="attendance-row"
                                data-student-id='<%# Eval("StudentId") %>'
                                data-full-name='<%# Eval("StudentFullName") %>'
                                data-ticket='<%# Eval("TicketReference") %>'
                                data-dept='<%# Eval("StudentDepartment") %>'
                                data-course='<%# Eval("StudentProgram") %>'>
                                <td>
                                    <!-- Strict MM/dd/yyyy hh:mm:ss tt format -->
                                    <span class="timestamp-badge">
                                        <%# FormatTimestamp(Eval("CheckInTimestamp")) %>
                                    </span>
                                </td>
                                <td>
                                    <span class="ticket-code">
                                        <%# Eval("TicketReference") %>
                                    </span>
                                </td>
                                <td>
                                    <span class="student-id-text"><%# Eval("StudentId") %></span>
                                </td>
                                <td>
                                    <strong style="color:var(--text-heading);"><%# Eval("StudentFullName") %></strong>
                                </td>
                                <td>
                                    <%# Eval("StudentProgram") %> (Yr <%# Eval("CurrentYearLvl") %> - <%# Eval("CurrentSection") %>)
                                </td>
                                <td>
                                    <span class="method-pill">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="2.5">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                        <span>Gate Verification</span>
                                    </span>
                                </td>
                                <td>
                                    <span style="color:var(--text-muted);"><%= CurrentAdminEmail %></span>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <asp:Panel ID="pnlEmptyRoster" runat="server" Visible="false" CssClass="empty-roster-state">
                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                </svg>
                <div style="font-weight:700; font-size:1rem; color:var(--text-heading);">No Attendees Checked In Yet</div>
                <div style="font-size:0.825rem;">Gate entries confirmed by administrative inspection will appear chronologically here.</div>
            </asp:Panel>
        </div>
    </div>

</div>

<script type="text/javascript">
    function filterAttendanceTable() {
        const query = (document.getElementById('<%= txtSearch.ClientID %>').value || '').trim().toLowerCase();
        const deptFilter = (document.getElementById('<%= ddlDepartmentFilter.ClientID %>').value || '').trim().toLowerCase();
        const courseFilter = (document.getElementById('<%= ddlProgramFilter.ClientID %>').value || '').trim().toLowerCase();

        const rows = document.querySelectorAll('#tblAttendance tbody tr.attendance-row');

        rows.forEach(function (row) {
            const studentId = (row.getAttribute('data-student-id') || '').toLowerCase();
            const fullName = (row.getAttribute('data-full-name') || '').toLowerCase();
            const ticket = (row.getAttribute('data-ticket') || '').toLowerCase();
            const dept = (row.getAttribute('data-dept') || '').toLowerCase();
            const course = (row.getAttribute('data-course') || '').toLowerCase();

            const matchesQuery = !query || studentId.includes(query) || fullName.includes(query) || ticket.includes(query);
            const matchesDept = !deptFilter || dept === deptFilter;
            const matchesCourse = !courseFilter || course === courseFilter;

            if (matchesQuery && matchesDept && matchesCourse) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>

</asp:Content>
