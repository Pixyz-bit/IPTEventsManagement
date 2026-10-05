<%@ Page Title="Event Attendance Roster" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventAttendance.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventAttendance" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Live Event Attendance Roster | QCU Event Management
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/event-attendance.css") %>?v=<%= DateTime.UtcNow.Ticks %>" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="attendance-container">

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
                <span>Live Event Attendance Roster</span>
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
                        <span>Capacity: <strong><asp:Literal ID="litCapacitySummary" runat="server" Text="0 / 0"></asp:Literal></strong></span>
                    </span>
                    <asp:Literal ID="litCheckedInCount" runat="server" Visible="false"></asp:Literal>
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
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAttendance.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item active">
                <span>Event Attendance</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAnalytics.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <span>Event Analytics</span>
            </a>
        </div>
    </div>

    <!-- Attendance Summary Metrics -->
    <!-- Hidden State Holders for Legacy References -->
    <asp:PlaceHolder ID="phAttendanceMetricsHidden" runat="server" Visible="false">
        <asp:Literal ID="litKpiTotalCheckedIn" runat="server" Text="0"></asp:Literal>
        <asp:Literal ID="litKpiTurnoutRate" runat="server" Text="0.0%"></asp:Literal>
        <asp:Literal ID="litKpiLatestCheckIn" runat="server" Text="--:--:--"></asp:Literal>
    </asp:PlaceHolder>

    <!-- Connected Search, Filters, and Live Attendance Roster Container -->
    <div class="unified-attendance-card">
                    <!-- Live Checked-In Attendance Header Bar -->
        <div class="table-header-bar">
            <div class="table-header-title">
                <span class="live-indicator-dot"></span>
                <span>Live Checked-In Attendance Roster</span>
            </div>
            <div style="font-size:0.8rem; color:var(--text-muted);">
                Chronological gate log &bull; Authenticated database commits
            </div>
        </div>
        <!-- Controls Bar -->
        <div class="unified-controls-bar">
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



        <!-- Table Viewport -->
        <div style="overflow-x:auto;">
            <table class="attendance-table" id="tblAttendance">
                <thead>
                    <tr>
                        <th style="width: 22%;">Verified Timestamp</th>
                        <th style="width: 18%;">Ticket Ref</th>
                        <th style="width: 15%;">Student ID</th>
                        <th style="width: 23%;">Attendee Full Name</th>
                        <th style="width: 22%;">Program &amp; Year / Section</th>
                    </tr>
                </thead>
                <tbody id="tbodyAttendance">
                    <asp:Repeater ID="rptCheckedInAttendees" runat="server" EnableViewState="false">
                        <ItemTemplate>
                            <tr class="attendance-row"
                                data-student-id='<%# Eval("StudentId") %>'
                                data-full-name='<%# Eval("StudentFullName") %>'
                                data-ticket='<%# Eval("TicketReference") %>'
                                data-dept='<%# Eval("StudentDepartment") %>'
                                data-course='<%# Eval("StudentProgram") %>'>
                                <td>
                                    <!-- Date above, time below (containerless) -->
                                    <div class="timestamp-stack">
                                        <span class="timestamp-date"><%# FormatDate(Eval("CheckInTimestamp")) %></span>
                                        <span class="timestamp-time"><%# FormatTime(Eval("CheckInTimestamp")) %></span>
                                    </div>
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
