<%@ Page Title="Campus Events Matrix | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminEvents.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.AdminEvents" EnableEventValidation="false" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/admin-events.css") %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Workspace Header -->
    <div class="page-header-row">
        <div class="header-title-block">
            <h2>Campus Events Matrix</h2>
        </div>
        <div class="header-actions">
            <a href="<%= ResolveUrl("~/Frontend/Admin/CreateEvent.aspx") %>" class="btn-action-primary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                <span>Create New Event</span>
            </a>
        </div>
    </div>

    <!-- Alert / Feedback Banner -->
    <asp:Panel ID="pnlFeedback" runat="server" Visible="false" CssClass="feedback-alert">
        <asp:Literal ID="litFeedbackMessage" runat="server" />
        <asp:LinkButton ID="btnCloseFeedback" runat="server" OnClick="btnCloseFeedback_Click" Text="&times;" Style="font-size: 1.25rem; font-weight: bold; background: none; border: none; cursor: pointer; color: inherit;" CausesValidation="false" />
    </asp:Panel>



    <!-- Filter & Search Toolbar -->
    <div class="matrix-toolbar">
        <div class="status-tabs-group">
            <asp:LinkButton ID="btnTabAll" runat="server" CssClass="tab-btn active" OnClick="FilterTab_Click" CommandArgument="All" CausesValidation="false" OnClientClick="filterMatrixByStatus('All', this); return false;">
                <span>All Events</span>
                <span class="tab-badge"><asp:Literal ID="litBadgeAll" runat="server" Text="0" /></span>
            </asp:LinkButton>
            <asp:LinkButton ID="btnTabOpen" runat="server" CssClass="tab-btn" OnClick="FilterTab_Click" CommandArgument="Open" CausesValidation="false" OnClientClick="filterMatrixByStatus('Open', this); return false;">
                <span>Open</span>
                <span class="tab-badge"><asp:Literal ID="litBadgeOpen" runat="server" Text="0" /></span>
            </asp:LinkButton>
            <asp:LinkButton ID="btnTabSoon" runat="server" CssClass="tab-btn" OnClick="FilterTab_Click" CommandArgument="Soon" CausesValidation="false" OnClientClick="filterMatrixByStatus('Soon', this); return false;">
                <span>Soon</span>
                <span class="tab-badge"><asp:Literal ID="litBadgeSoon" runat="server" Text="0" /></span>
            </asp:LinkButton>
            <asp:LinkButton ID="btnTabClose" runat="server" CssClass="tab-btn" OnClick="FilterTab_Click" CommandArgument="Close" CausesValidation="false" OnClientClick="filterMatrixByStatus('Close', this); return false;">
                <span>Close</span>
                <span class="tab-badge"><asp:Literal ID="litBadgeClose" runat="server" Text="0" /></span>
            </asp:LinkButton>
        </div>

        <div class="filters-right-group">
            <div class="search-box-wrap">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="input-search" placeholder="Search event or venue..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" />
            </div>

            <asp:DropDownList ID="ddlDepartmentFilter" runat="server" CssClass="select-filter" AutoPostBack="true" OnSelectedIndexChanged="ddlDepartmentFilter_SelectedIndexChanged">
                <asp:ListItem Value="" Text="All Academic Colleges" />
                <asp:ListItem Value="College of Computer Studies" Text="College of Computer Studies (CCS)" />
                <asp:ListItem Value="College of Engineering" Text="College of Engineering (COE)" />
                <asp:ListItem Value="College of Business & Acctg" Text="College of Business & Accountancy (CBA)" />
                <asp:ListItem Value="College of Arts & Sciences" Text="College of Arts & Sciences (CAS)" />
            </asp:DropDownList>
        </div>
    </div>

    <!-- Main Events Matrix Table Panel -->
    <div class="matrix-panel">
        <div class="table-responsive">
            <asp:Repeater ID="rptEventsMatrix" runat="server" OnItemCommand="rptEventsMatrix_ItemCommand">
                <HeaderTemplate>
                    <table class="matrix-table">
                        <thead>
                            <tr>
                                <th style="width: 95px;">Status</th>
                                <th style="width: 230px; max-width: 250px;">Event Title</th>
                                <th>Venue and Date</th>
                                <th>Reg. Deadline</th>
                                <th style="width: 130px;">Occupancy</th>
                                <th style="text-align: right; width: 85px;"></th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr class="event-matrix-row" data-status='<%# Eval("MatrixStatus") %>' data-dept='<%# Eval("TargetDepartment") %>'>
                        <!-- 1. Status: Close, Open, Soon -->
                        <td>
                            <span class='status-pill <%# GetMatrixStatusClass(Eval("MatrixStatus")) %>'>
                                <%# Eval("MatrixStatus") %>
                            </span>
                        </td>

                        <!-- 2. Event Title -->
                        <td>
                            <div class="cell-event-title"><%# Eval("Title") %></div>
                        </td>

                        <!-- 3. Venue and Date (Venue on top, Event Start date below) -->
                        <td>
                            <div class="cell-venue-text"><%# Eval("VenueLocation") %></div>
                            <div class="cell-date-text"><%# Eval("EventStart", "{0:MM/dd/yyyy}") %></div>
                        </td>

                        <!-- 4. Reg. Deadline (From: [date], To: [date]) -->
                        <td>
                            <div class="cell-reg-deadline">
                                <span class="reg-label">From:</span>
                                <span class="reg-date"><%# Eval("RegStart", "{0:MM/dd/yyyy}") %></span>
                                <span class="reg-label" style="margin-top: 0.25rem;">To:</span>
                                <span class="reg-date"><%# Eval("RegEnd", "{0:MM/dd/yyyy}") %></span>
                            </div>
                        </td>

                        <!-- 5. Occupancy ([CurrentRegistrations]/[MaxCapacity]) -->
                        <td>
                            <div class="cell-occupancy-text">
                                <%# Eval("CurrentRegistrations") %>/<%# Eval("MaxCapacity") %>
                            </div>
                        </td>

                        <!-- 6. View Action (Routes to Event Details in sub-module pipeline) -->
                        <td style="text-align: right;">
                            <a href='<%# ResolveUrl("~/Frontend/Admin/EventDetails.aspx?eventId=" + Eval("EventId")) %>' class="link-matrix-view">View &gt;</a>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <!-- Zero State Fallback -->
            <asp:Panel ID="pnlNoEvents" runat="server" Visible="false" Style="padding: 3rem 1.5rem; text-align: center; color: var(--text-muted);">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin: 0 auto 0.75rem; color: #94a3b8;">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                <h3 style="font-size: 1rem; font-weight: 700; color: var(--text-heading); margin-bottom: 0.35rem;">No Events Found</h3>
                <p style="font-size: 0.85rem; max-width: 400px; margin: 0 auto 1.25rem;">No campus events match the selected status tab or search criteria.</p>
                <asp:Button ID="btnResetFilter" runat="server" Text="Reset Filters" CssClass="btn-action-secondary" OnClick="btnResetFilter_Click" CausesValidation="false" />
            </asp:Panel>
        </div>
    </div>

    <!-- Cancellation Confirmation Modal Dialog -->
    <asp:Panel ID="pnlCancelModal" runat="server" Visible="false" CssClass="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <span class="modal-title">Confirm Event Cancellation</span>
                <asp:LinkButton ID="btnDismissModal" runat="server" OnClick="btnDismissModal_Click" CausesValidation="false" Style="background:none; border:none; font-size:1.25rem; font-weight:bold; color:var(--text-muted); cursor:pointer;">&times;</asp:LinkButton>
            </div>
            <div class="modal-body">
                <p style="font-size: 0.85rem; color: var(--text-body); margin-bottom: 1rem;">
                    Are you sure you want to cancel <strong id="modalEventTitle"><asp:Literal ID="litModalEventTitle" runat="server" /></strong>? This will permanently close registration and notify attached cohort channels.
                </p>
                <asp:HiddenField ID="hfCancelEventId" runat="server" />
                <div class="form-group">
                    <label class="form-label">Official Cancellation Reason *</label>
                    <asp:TextBox ID="txtCancellationReason" runat="server" TextMode="MultiLine" CssClass="form-textarea" placeholder="e.g., Venue maintenance scheduling conflict or typhoon advisory..." />
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCancelDismiss" runat="server" Text="Keep Event" CssClass="btn-action-secondary" OnClick="btnDismissModal_Click" CausesValidation="false" />
                <asp:Button ID="btnConfirmCancellation" runat="server" Text="Confirm Cancellation" CssClass="btn-action-primary" Style="background-color:#dc2626; border-color:#dc2626;" OnClick="btnConfirmCancellation_Click" />
            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        function filterMatrixByStatus(status, clickedTab) {
            // 1. Update active tab pill styling
            var tabs = document.querySelectorAll('.status-tabs-group .tab-btn');
            tabs.forEach(function (tab) {
                tab.classList.remove('active');
            });
            if (clickedTab) {
                clickedTab.classList.add('active');
            }

            // 2. Filter table rows
            var rows = document.querySelectorAll('.matrix-table tbody tr.event-matrix-row');
            var visibleCount = 0;
            var normalizedStatus = (status || 'All').toLowerCase();

            rows.forEach(function (row) {
                var rowStatus = (row.getAttribute('data-status') || '').toLowerCase();
                if (normalizedStatus === 'all' || rowStatus === normalizedStatus) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            // 3. Toggle Zero State / Empty State message
            var noEventsPnl = document.getElementById('<%= pnlNoEvents.ClientID %>');
            var tableElement = document.querySelector('.matrix-table');
            if (noEventsPnl) {
                if (visibleCount === 0 && rows.length > 0) {
                    noEventsPnl.style.display = 'block';
                    if (tableElement) tableElement.style.display = 'none';
                } else {
                    noEventsPnl.style.display = 'none';
                    if (tableElement) tableElement.style.display = '';
                }
            }

            // 4. Update browser URL without reload
            if (window.history && window.history.replaceState) {
                var newUrl = window.location.pathname + (normalizedStatus === 'all' ? '' : '?status=' + encodeURIComponent(status));
                window.history.replaceState(null, '', newUrl);
            }
        }
    </script>
</asp:Content>
