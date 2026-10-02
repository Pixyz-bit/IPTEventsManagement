<%@ Page Title="Event Pre-Registered Roster" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventPreRegistered.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventPreRegistered" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Event Pre-Registered Roster | QCU Event Management
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/event-preregistered.css") %>" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="prereg-container">

    <!-- Notification Toasts -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false">
        <div id="divAlertBox" runat="server" class="alert-toast">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
        </div>
    </asp:Panel>

    <!-- Context Header Banner -->
    <div class="event-context-card">
        <div class="event-context-top">
            <div class="event-title-group">
                <h1>
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
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
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                </svg>
                <span>1. Event Details</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventPreRegistered.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item active">
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

    <!-- Hidden State Holders for Legacy References -->
    <asp:PlaceHolder ID="phKpiHidden" runat="server" Visible="false">
        <asp:Literal ID="litKpiPreRegistered" runat="server" Text="0"></asp:Literal>
        <asp:Literal ID="litKpiAvailablePool" runat="server" Text="0"></asp:Literal>
        <asp:Literal ID="litKpiCancelled" runat="server" Text="0"></asp:Literal>
        <asp:Literal ID="litKpiOccupancyRate" runat="server" Text="0%"></asp:Literal>
    </asp:PlaceHolder>

    <!-- White Surface Container -->
    <div class="white-container roster-white-container">
        <div class="unified-roster-card">
        
        <!-- 1. Dual-Sheet Tabbed Navigation (At the Top) -->
        <div class="sheet-tabs-container">
            <button type="button" id="tabPreRegistered" class="sheet-tab-btn active" onclick="switchSheet('preregistered')">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                </svg>
                <span>Pre-Registered Students</span>
                <span class="sheet-badge sheet-badge-primary">
                    <asp:Literal ID="litTabCountPreReg" runat="server" Text="0"></asp:Literal>
                </span>
            </button>

            <button type="button" id="tabCancelled" class="sheet-tab-btn" onclick="switchSheet('cancelled')">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
                <span>Cancelled</span>
                <span class="sheet-badge sheet-badge-cancelled">
                    <asp:Literal ID="litTabCountCancelled" runat="server" Text="0"></asp:Literal>
                </span>
            </button>
        </div>

        <!-- 2. Search & Multi-Filter Controls Bar (Immediately Beneath Tabs) -->
        <div class="unified-controls-bar">
            <div class="controls-row">
                <!-- Universal Search (Student ID and Full Name) -->
                <div class="search-box-wrapper">
                    <svg class="search-box-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <input type="text" id="txtUniversalSearch" class="search-input" placeholder="Search by Student ID or Full Name..." onkeyup="filterRosterTable()" />
                </div>

                <!-- Multi-Filter Dropdowns -->
                <div class="filter-dropdowns-group">
                    <asp:DropDownList ID="ddlFilterDepartment" runat="server" CssClass="filter-select" onchange="filterRosterTable()">
                        <asp:ListItem Value="" Text="All Departments"></asp:ListItem>
                    </asp:DropDownList>

                    <asp:DropDownList ID="ddlFilterCourse" runat="server" CssClass="filter-select" onchange="filterRosterTable()">
                        <asp:ListItem Value="" Text="All Courses"></asp:ListItem>
                    </asp:DropDownList>

                    <asp:DropDownList ID="ddlFilterYearLevel" runat="server" CssClass="filter-select" onchange="filterRosterTable()">
                        <asp:ListItem Value="" Text="All Year Levels"></asp:ListItem>
                        <asp:ListItem Value="1" Text="1st Year"></asp:ListItem>
                        <asp:ListItem Value="2" Text="2nd Year"></asp:ListItem>
                        <asp:ListItem Value="3" Text="3rd Year"></asp:ListItem>
                        <asp:ListItem Value="4" Text="4th Year"></asp:ListItem>
                    </asp:DropDownList>

                    <button type="button" class="btn-clear-filters" onclick="resetFilters()">Reset Filters</button>
                </div>

                <!-- Export Actions -->
                <div class="actions-group">
                    <asp:LinkButton ID="btnExportCsv" runat="server" CssClass="btn-export-csv" OnClick="btnExportCsv_Click">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                            <polyline points="7 10 12 15 17 10"></polyline>
                            <line x1="12" y1="15" x2="12" y2="3"></line>
                        </svg>
                        <span>Export Roster (CSV)</span>
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <!-- 3. Sheet 1: Pre-Registered Roster Table -->
        <div id="sheetPreRegistered" class="unified-sheet-content">
        <div class="table-responsive">
            <table class="roster-table" id="tblPreRegistered">
                <thead>
                    <tr>
                        <th style="width: 14%;">Ticket Ref</th>
                        <th style="width: 13%;">Student ID</th>
                        <th style="width: 22%;">Student Name</th>
                        <th style="width: 26%;">Department &amp; Course</th>
                        <th style="width: 12%;">Year &amp; Section</th>
                        <th style="width: 8%;">Status</th>
                        <th style="width: 5%; text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptPreRegistered" runat="server">
                        <ItemTemplate>
                            <tr class="roster-row" 
                                data-student-id='<%# Eval("StudentId") %>' 
                                data-full-name='<%# Eval("StudentFullName") %>' 
                                data-dept='<%# Eval("StudentDepartment") %>' 
                                data-course='<%# Eval("StudentProgram") %>' 
                                data-year='<%# Eval("CurrentYearLvl") %>'>
                                <td>
                                    <span class="ticket-code"><%# Eval("TicketReference") %></span>
                                </td>
                                <td>
                                    <span class="student-id-text"><%# Eval("StudentId") %></span>
                                </td>
                                <td>
                                    <div class="student-name-block">
                                        <span class="student-name-text"><%# Eval("StudentFullName") %></span>
                                        <span class="student-email-text"><%# Eval("StudentEmail") %></span>
                                    </div>
                                </td>
                                <td>
                                    <div class="dept-course-cell">
                                        <span class="dept-text"><%# Eval("StudentDepartment") %></span>
                                        <span class="course-text"><%# Eval("StudentProgram") %></span>
                                    </div>
                                </td>
                                <td>
                                    <div class="year-section-cell">
                                        <span class="year-text">Year <%# Eval("CurrentYearLvl") %></span>
                                        <span class="section-text"><%# Eval("CurrentSection") %></span>
                                    </div>
                                </td>
                                <td>
                                    <%# GetStatusBadgeHtml(Eval("Status")) %>
                                </td>
                                <td style="text-align: right;">
                                    <a href="javascript:void(0);" class="btn-view-link" 
                                        onclick='openStudentModal("<%# Eval("StudentId") %>", "<%# Eval("StudentFullName") %>", "<%# Eval("StudentEmail") %>", "<%# Eval("StudentCampusBranch") %>", "<%# Eval("StudentDepartment") %>", "<%# Eval("StudentProgram") %>", "<%# Eval("CurrentYearLvl") %>", "<%# Eval("CurrentSection") %>", "<%# Eval("TicketReference") %>", "<%# FormatRegistrationDate(Eval("RegistrationTimestamp"), Eval("RegStart")) %>", "<%# Eval("Status") %>", "<%# Eval("EventRegistrationId") %>")'>
                                        View &gt;
                                    </a>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
            
            <asp:Panel ID="pnlEmptyPreRegistered" runat="server" Visible="false" CssClass="empty-roster-state">
                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                </svg>
                <div style="font-size:1rem; font-weight:600; color:var(--text-heading);">No Pre-Registered Attendees Found</div>
                <div style="font-size:0.825rem;">There are currently no active pre-registered students awaiting gate scanning for this event.</div>
            </asp:Panel>
        </div>
    </div>

    <!-- Sheet 2: Cancelled Roster Table -->
    <div id="sheetCancelled" class="unified-sheet-content" style="display:none;">
        <div class="table-responsive">
            <table class="roster-table" id="tblCancelled">
                <thead>
                    <tr>
                        <th style="width: 14%;">Ticket Ref</th>
                        <th style="width: 13%;">Student ID</th>
                        <th style="width: 22%;">Student Name</th>
                        <th style="width: 26%;">Department &amp; Course</th>
                        <th style="width: 12%;">Year &amp; Section</th>
                        <th style="width: 8%;">Status</th>
                        <th style="width: 5%; text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptCancelled" runat="server">
                        <ItemTemplate>
                            <tr class="roster-row" 
                                data-student-id='<%# Eval("StudentId") %>' 
                                data-full-name='<%# Eval("StudentFullName") %>' 
                                data-dept='<%# Eval("StudentDepartment") %>' 
                                data-course='<%# Eval("StudentProgram") %>' 
                                data-year='<%# Eval("CurrentYearLvl") %>'>
                                <td>
                                    <span class="ticket-code ticket-code-cancelled"><%# Eval("TicketReference") %></span>
                                </td>
                                <td>
                                    <span class="student-id-text"><%# Eval("StudentId") %></span>
                                </td>
                                <td>
                                    <div class="student-name-block">
                                        <span class="student-name-text"><%# Eval("StudentFullName") %></span>
                                        <span class="student-email-text"><%# Eval("StudentEmail") %></span>
                                    </div>
                                </td>
                                <td>
                                    <div class="dept-course-cell">
                                        <span class="dept-text"><%# Eval("StudentDepartment") %></span>
                                        <span class="course-text"><%# Eval("StudentProgram") %></span>
                                    </div>
                                </td>
                                <td>
                                    <div class="year-section-cell">
                                        <span class="year-text">Year <%# Eval("CurrentYearLvl") %></span>
                                        <span class="section-text"><%# Eval("CurrentSection") %></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-pill status-pill-cancelled"><span class="status-dot status-dot-cancelled"></span>Cancelled</span>
                                </td>
                                <td style="text-align: right;">
                                    <a href="javascript:void(0);" class="btn-view-link" 
                                        onclick='openStudentModal("<%# Eval("StudentId") %>", "<%# Eval("StudentFullName") %>", "<%# Eval("StudentEmail") %>", "<%# Eval("StudentCampusBranch") %>", "<%# Eval("StudentDepartment") %>", "<%# Eval("StudentProgram") %>", "<%# Eval("CurrentYearLvl") %>", "<%# Eval("CurrentSection") %>", "<%# Eval("TicketReference") %>", "<%# FormatRegistrationDate(Eval("RegistrationTimestamp"), Eval("RegStart")) %>", "<%# Eval("Status") %>", "<%# Eval("EventRegistrationId") %>")'>
                                        View &gt;
                                    </a>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <asp:Panel ID="pnlEmptyCancelled" runat="server" Visible="false" CssClass="empty-roster-state">
                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
                <div style="font-size:1rem; font-weight:600; color:var(--text-heading);">No Cancelled Registrations</div>
                <div style="font-size:0.825rem;">There are no revoked registration entries recorded for this event.</div>
            </asp:Panel>
        </div>
    </div>
    </div>

</div>

<!-- Student Profile Detail Pop-Up Modal -->
<div id="modalStudentProfile" class="modal-overlay" onclick="handleBackdropClick(event)">
    <div class="modal-dialog" onclick="event.stopPropagation()">
        <div class="modal-header">
            <h3>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
                <span>Attendee Profile Information</span>
            </h3>
            <button type="button" class="modal-close-btn" onclick="closeStudentModal()">&times;</button>
        </div>
        <div class="modal-body">
            <div class="profile-summary-header">
                <div class="profile-avatar-placeholder" id="modalAvatarInitials">ST</div>
                <div class="profile-name-title">
                    <h4 id="modalFullName">Student Full Name</h4>
                    <p id="modalTicketRef">TCK-0000-00000</p>
                </div>
            </div>

            <div class="profile-grid">
                <div class="profile-field-block">
                    <span class="profile-field-label">Student ID Number</span>
                    <span class="profile-field-value" id="modalStudentId">--</span>
                </div>
                <div class="profile-field-block">
                    <span class="profile-field-label">Campus Branch</span>
                    <span class="profile-field-value" id="modalBranch">--</span>
                </div>
                <div class="profile-field-block" style="grid-column: span 2;">
                    <span class="profile-field-label">Institutional Email</span>
                    <span class="profile-field-value" id="modalEmail">--</span>
                </div>
                <div class="profile-field-block" style="grid-column: span 2;">
                    <span class="profile-field-label">Academic Department</span>
                    <span class="profile-field-value" id="modalDepartment">--</span>
                </div>
                <div class="profile-field-block" style="grid-column: span 2;">
                    <span class="profile-field-label">Program / Course</span>
                    <span class="profile-field-value" id="modalCourse">--</span>
                </div>
                <div class="profile-field-block">
                    <span class="profile-field-label">Year Level & Section</span>
                    <span class="profile-field-value" id="modalYearSection">--</span>
                </div>
                <div class="profile-field-block">
                    <span class="profile-field-label">Current Status</span>
                    <span class="profile-field-value" id="modalStatusText">--</span>
                </div>
                <div class="profile-field-block" style="grid-column: span 2;">
                    <span class="profile-field-label">Registration Date</span>
                    <span class="profile-field-value" id="modalRegDate">--/--/----</span>
                </div>
            </div>
        </div>
        <div class="modal-footer" style="display:flex; justify-content:space-between; align-items:center;">
            <div>
                <asp:HiddenField ID="hfModalEventRegId" runat="server" ClientIDMode="Static" />
                <asp:LinkButton ID="btnModalCancelPass" runat="server" CssClass="btn-modal-cancel" OnClick="btnModalCancelPass_Click" OnClientClick="return confirm('Are you sure you want to void this student registration pass? This slot will immediately be released back to the event capacity pool.');">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="15" y1="9" x2="9" y2="15"></line>
                        <line x1="9" y1="9" x2="15" y2="15"></line>
                    </svg>
                    <span>Void / Cancel Pass</span>
                </asp:LinkButton>
            </div>
            <button type="button" class="btn-modal-close" onclick="closeStudentModal()">Dismiss</button>
        </div>
    </div>
</div>

<script type="text/javascript">
    // Dual-Sheet Switching Logic
    let currentSheet = 'preregistered';

    function switchSheet(sheetName) {
        currentSheet = sheetName;
        const preregTab = document.getElementById('tabPreRegistered');
        const cancelledTab = document.getElementById('tabCancelled');
        const preregSheet = document.getElementById('sheetPreRegistered');
        const cancelledSheet = document.getElementById('sheetCancelled');

        if (sheetName === 'preregistered') {
            preregTab.classList.add('active');
            cancelledTab.classList.remove('active-cancelled');
            preregSheet.style.display = 'block';
            cancelledSheet.style.display = 'none';
        } else {
            preregTab.classList.remove('active');
            cancelledTab.classList.add('active-cancelled');
            preregSheet.style.display = 'none';
            cancelledSheet.style.display = 'block';
        }

        filterRosterTable();
    }

    // Client-side Multi-Filter & Universal Search
    function filterRosterTable() {
        const query = (document.getElementById('txtUniversalSearch').value || '').trim().toLowerCase();
        const deptFilter = (document.getElementById('<%= ddlFilterDepartment.ClientID %>').value || '').trim().toLowerCase();
        const courseFilter = (document.getElementById('<%= ddlFilterCourse.ClientID %>').value || '').trim().toLowerCase();
        const yearFilter = (document.getElementById('<%= ddlFilterYearLevel.ClientID %>').value || '').trim().toLowerCase();

        const activeTableId = (currentSheet === 'preregistered') ? 'tblPreRegistered' : 'tblCancelled';
        const rows = document.querySelectorAll('#' + activeTableId + ' tbody tr.roster-row');

        rows.forEach(function (row) {
            const studentId = (row.getAttribute('data-student-id') || '').toLowerCase();
            const fullName = (row.getAttribute('data-full-name') || '').toLowerCase();
            const dept = (row.getAttribute('data-dept') || '').toLowerCase();
            const course = (row.getAttribute('data-course') || '').toLowerCase();
            const year = (row.getAttribute('data-year') || '').toLowerCase();

            const matchesQuery = !query || studentId.includes(query) || fullName.includes(query);
            const matchesDept = !deptFilter || dept === deptFilter;
            const matchesCourse = !courseFilter || course === courseFilter;
            const matchesYear = !yearFilter || year === yearFilter;

            if (matchesQuery && matchesDept && matchesCourse && matchesYear) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function resetFilters() {
        document.getElementById('txtUniversalSearch').value = '';
        document.getElementById('<%= ddlFilterDepartment.ClientID %>').value = '';
        document.getElementById('<%= ddlFilterCourse.ClientID %>').value = '';
        document.getElementById('<%= ddlFilterYearLevel.ClientID %>').value = '';
        filterRosterTable();
    }

    // Pop-Up Modal Controls
    function openStudentModal(studentId, fullName, email, branch, dept, course, year, section, ticketRef, regDate, status, eventRegId) {
        document.getElementById('modalStudentId').innerText = studentId || '--';
        document.getElementById('modalFullName').innerText = fullName || 'Student Attendee';
        document.getElementById('modalEmail').innerText = email || 'No email provided';
        document.getElementById('modalBranch').innerText = branch || 'Main Campus';
        document.getElementById('modalDepartment').innerText = dept || '--';
        document.getElementById('modalCourse').innerText = course || '--';
        document.getElementById('modalYearSection').innerText = 'Year ' + year + ' - ' + section;
        document.getElementById('modalTicketRef').innerText = ticketRef || '--';
        document.getElementById('modalRegDate').innerText = regDate || '--/--/----';
        document.getElementById('modalStatusText').innerText = status || 'Reserved';

        const hf = document.getElementById('hfModalEventRegId');
        if (hf) {
            hf.value = eventRegId || '';
        }

        const btnCancel = document.getElementById('<%= btnModalCancelPass.ClientID %>');
        if (btnCancel) {
            if (status && status.toLowerCase() === 'cancelled') {
                btnCancel.style.display = 'none';
            } else {
                btnCancel.style.display = 'inline-flex';
            }
        }

        // Set avatar initials
        let initials = 'ST';
        if (fullName) {
            const parts = fullName.trim().split(' ');
            if (parts.length >= 2) {
                initials = (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
            } else if (parts.length === 1 && parts[0].length > 0) {
                initials = parts[0][0].toUpperCase();
            }
        }
        document.getElementById('modalAvatarInitials').innerText = initials;

        const modal = document.getElementById('modalStudentProfile');
        modal.classList.add('open');
    }

    function closeStudentModal() {
        const modal = document.getElementById('modalStudentProfile');
        modal.classList.remove('open');
    }

    function handleBackdropClick(e) {
        if (e.target && e.target.id === 'modalStudentProfile') {
            closeStudentModal();
        }
    }

    // Keyboard ESC to close modal
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            closeStudentModal();
        }
    });
</script>

</asp:Content>
