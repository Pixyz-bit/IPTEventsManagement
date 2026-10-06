<%@ Page Title="Campus Events Matrix | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminEvents.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.AdminEvents" EnableSessionState="ReadOnly" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/admin-events.css?v=20261006-cleanup") %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Workspace Header -->
    <div class="page-header-row">
        <div class="header-title-block">
            <h2>Campus Events Matrix</h2>
            <p>Manage registration, review events, and cancel unintended events safely.</p>
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
            <asp:LinkButton ID="btnTabAll" runat="server" CssClass="tab-btn active" OnClick="FilterTab_Click" CommandArgument="All" CausesValidation="false" Text="All Upcoming" />
            <asp:LinkButton ID="btnTabOpen" runat="server" CssClass="tab-btn" OnClick="FilterTab_Click" CommandArgument="Open" CausesValidation="false" Text="Open" />
            <asp:LinkButton ID="btnTabSoon" runat="server" CssClass="tab-btn" OnClick="FilterTab_Click" CommandArgument="Soon" CausesValidation="false" Text="Soon" />
            <asp:LinkButton ID="btnTabClose" runat="server" CssClass="tab-btn" OnClick="FilterTab_Click" CommandArgument="Close" CausesValidation="false" Text="Close" />
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
                                <th style="text-align: right; width: 150px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr class='event-matrix-row <%# (bool)Eval("IsCancelled") ? "is-cancelled-row" : "" %>' data-status='<%# Eval("MatrixStatus") %>' data-dept='<%# Eval("TargetDepartment") %>'>
                        <!-- 1. Registration status within Upcoming events: Close, Open, Soon -->
                        <td>
                            <span class='status-pill <%# GetMatrixStatusClass(Eval("MatrixStatus")) %>'>
                                <%# Eval("MatrixStatus") %>
                            </span>
                        </td>

                        <!-- 2. Event Title -->
                        <td>
                            <div style="display:flex; align-items:center; gap:0.75rem;">
                                <div>
                                    <div class="cell-event-title"><%#: Eval("Title") %></div>
                                </div>
                            </div>
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

                        <!-- 6. View & Cancellation Actions -->
                        <td style="text-align: right; white-space: nowrap;">
                            <asp:LinkButton ID="btnCancelEventRow" runat="server"
                                CommandName="RequestCancel"
                                CommandArgument='<%# Eval("EventId") %>'
                                CssClass="btn-matrix-cancel"
                                Visible='<%# Eval("CanCancel") %>'
                                ToolTip="Cancel this event and close registration and check-in"
                                CausesValidation="false">Cancel Event</asp:LinkButton>
                            <a href='<%# ResolveUrl("~/Frontend/Admin/EventDetails.aspx?eventId=" + Eval("EventId")) %>' class="btn-view-link link-matrix-view">View &gt;</a>
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
        <div class="modal-box" role="dialog" aria-modal="true" aria-labelledby="cancelDialogTitle">
            <div class="modal-header">
                <span class="modal-title" id="cancelDialogTitle">Confirm Event Cancellation</span>
                <asp:LinkButton ID="btnDismissModal" runat="server" OnClick="btnDismissModal_Click" CausesValidation="false" aria-label="Keep event and close dialog" Style="background:none; border:none; font-size:1.25rem; font-weight:bold; color:var(--text-muted); cursor:pointer;">&times;</asp:LinkButton>
            </div>
            <div class="modal-body">
                <p style="font-size: 0.85rem; color: var(--text-body); margin-bottom: 1rem;">
                    Are you sure you want to cancel <strong id="modalEventTitle"><asp:Literal ID="litModalEventTitle" runat="server" /></strong>? Registration and check-in will close. Existing registrations and attendance records will be kept. Cancellation cannot be undone here, and no automatic email notifications are sent.
                </p>
                <div class="form-group">
                    <label class="form-label" for="<%= txtCancellationReason.ClientID %>">Cancellation reason (required, up to 500 characters)</label>
                    <asp:TextBox ID="txtCancellationReason" runat="server" TextMode="MultiLine" MaxLength="500" CssClass="form-textarea" aria-describedby="cancellationError" placeholder="e.g., Created this event by mistake" />
                    <p id="cancellationError" role="alert" style="color:#991b1b;"><asp:Literal ID="litCancellationError" runat="server" /></p>
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCancelDismiss" runat="server" Text="Keep Event" CssClass="btn-action-secondary" OnClick="btnDismissModal_Click" CausesValidation="false" />
                <asp:Button ID="btnConfirmCancellation" runat="server" Text="Confirm Cancellation" CssClass="btn-action-primary" Style="background-color:#dc2626; border-color:#dc2626;" OnClick="btnConfirmCancellation_Click" />
            </div>
        </div>
    </asp:Panel>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var dialog = document.querySelector('[role="dialog"]');
            if (!dialog) return;
            var reason = document.getElementById('<%= txtCancellationReason.ClientID %>');
            reason.setAttribute('maxlength', '500');
            reason.focus();
            dialog.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') {
                    event.preventDefault();
                    document.getElementById('<%= btnCancelDismiss.ClientID %>').click();
                }
                if (event.key !== 'Tab') return;
                var controls = dialog.querySelectorAll('a[href], button, input:not([type="hidden"]), textarea');
                var first = controls[0], last = controls[controls.length - 1];
                if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
                else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
            });
        });
    </script>
</asp:Content>
