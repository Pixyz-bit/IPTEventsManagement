<%@ Page Title="Campus Events Matrix | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminEvents.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.AdminEvents" EnableEventValidation="false" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ─── Page Workspace Header ─── */
        .page-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .header-title-block h2 {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.02em;
            margin-bottom: 0.25rem;
        }

        .header-title-block p {
            font-size: 0.85rem;
            color: var(--text-muted);
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .btn-action-primary {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background-color: var(--brand-primary);
            color: #ffffff;
            padding: 0.6rem 1.15rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            border: 1px solid var(--brand-primary);
            box-shadow: 0 1px 2px rgba(29, 78, 216, 0.2);
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .btn-action-primary:hover {
            background-color: var(--brand-primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(29, 78, 216, 0.25);
        }

        .btn-action-secondary {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background-color: #ffffff;
            color: #334155;
            padding: 0.6rem 1rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            border: 1px solid #cbd5e1;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .btn-action-secondary:hover {
            background-color: #f8fafc;
            border-color: #94a3b8;
            color: #0f172a;
        }

        /* ─── Metric Summary Cards ─── */
        .summary-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
            margin-bottom: 1.75rem;
        }

        .summary-kpi-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            padding: 1.1rem 1.25rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            box-shadow: var(--shadow-subtle);
        }

        .summary-kpi-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .summary-kpi-info {
            display: flex;
            flex-direction: column;
        }

        .summary-kpi-label {
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .summary-kpi-value {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-heading);
            line-height: 1.2;
            font-family: var(--font-mono), var(--font-sans);
        }

        /* ─── Filter & Search Toolbar ─── */
        .matrix-toolbar {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            padding: 0.85rem 1.25rem;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            box-shadow: var(--shadow-subtle);
        }

        .status-tabs-group {
            display: flex;
            align-items: center;
            gap: 0.35rem;
            flex-wrap: wrap;
        }

        .tab-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.45rem 0.85rem;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            color: #475569;
            background-color: transparent;
            border: 1px solid transparent;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.15s ease;
        }

        .tab-btn:hover {
            background-color: #f1f5f9;
            color: #0f172a;
        }

        .tab-btn.active {
            background-color: #eff6ff;
            color: #1d4ed8;
            border-color: #bfdbfe;
            font-weight: 700;
        }

        .tab-badge {
            font-size: 0.68rem;
            font-weight: 700;
            padding: 0.1rem 0.4rem;
            border-radius: 9999px;
            background-color: #e2e8f0;
            color: #475569;
        }

        .tab-btn.active .tab-badge {
            background-color: #dbeafe;
            color: #1d4ed8;
        }

        .filters-right-group {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .search-box-wrap {
            position: relative;
            display: flex;
            align-items: center;
        }

        .search-box-wrap svg {
            position: absolute;
            left: 0.75rem;
            color: #94a3b8;
            pointer-events: none;
        }

        .input-search {
            padding: 0.45rem 0.85rem 0.45rem 2.2rem;
            border: 1px solid var(--border-subtle);
            border-radius: 6px;
            font-size: 0.82rem;
            font-family: var(--font-sans);
            color: var(--text-heading);
            background-color: #f8fafc;
            width: 220px;
            transition: all 0.15s ease;
        }

        .input-search:focus {
            outline: none;
            border-color: var(--border-focus);
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .select-filter {
            padding: 0.45rem 0.85rem;
            border: 1px solid var(--border-subtle);
            border-radius: 6px;
            font-size: 0.82rem;
            font-family: var(--font-sans);
            color: var(--text-heading);
            background-color: #f8fafc;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .select-filter:focus {
            outline: none;
            border-color: var(--border-focus);
            background-color: #ffffff;
        }

        /* ─── Matrix Table Surface ─── */
        .matrix-panel {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: var(--shadow-subtle);
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .matrix-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.82rem;
            text-align: left;
        }

        .matrix-table th {
            padding: 0.85rem 1rem;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            border-bottom: 1px solid var(--border-subtle);
            background-color: #f8fafc;
            white-space: nowrap;
        }

        .matrix-table td {
            padding: 1rem;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .matrix-table tr:last-child td {
            border-bottom: none;
        }

        .matrix-table tr:hover td {
            background-color: #f8fafc;
        }

        .cell-event-title {
            font-weight: 700;
            color: var(--text-heading);
            font-size: 0.86rem;
            margin-bottom: 0.2rem;
            max-width: 220px;
            word-wrap: break-word;
            line-height: 1.35;
        }

        .cell-event-venue {
            color: var(--text-muted);
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }

        /* 4-Tier Matrix Pills */
        .cohort-matrix-wrap {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
            font-size: 0.72rem;
        }

        .cohort-badge-row {
            display: flex;
            align-items: center;
            gap: 0.35rem;
            flex-wrap: wrap;
        }

        .badge-branch {
            background-color: #f1f5f9;
            color: #475569;
            padding: 0.15rem 0.45rem;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
            font-weight: 600;
        }

        .badge-dept {
            background-color: #eff6ff;
            color: #1d4ed8;
            padding: 0.15rem 0.45rem;
            border-radius: 4px;
            border: 1px solid #bfdbfe;
            font-weight: 600;
        }

        .badge-all {
            background-color: #f8fafc;
            color: #64748b;
            padding: 0.15rem 0.45rem;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
            font-style: italic;
        }

        /* Capacity Progress Bar */
        .capacity-bar-wrap {
            width: 120px;
        }

        .capacity-bar-track {
            height: 6px;
            background-color: #e2e8f0;
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 0.3rem;
        }

        .capacity-bar-fill {
            height: 100%;
            background-color: #2563eb;
            border-radius: 3px;
        }

        .capacity-text {
            font-size: 0.7rem;
            color: var(--text-muted);
            font-family: var(--font-mono);
            font-weight: 600;
        }

        /* Status Pills */
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.22rem 0.6rem;
            border-radius: 9999px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            white-space: nowrap;
        }

        .status-open {
            background-color: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
        }

        .status-soon {
            background-color: #fefce8;
            color: #a16207;
            border: 1px solid #fef08a;
        }

        .status-close {
            background-color: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
        }

        /* ─── Wireframe Matrix Elements ─── */
        .cell-event-title {
            font-size: 0.92rem;
            font-weight: 700;
            color: var(--text-heading);
            line-height: 1.35;
        }

        .cell-venue-text {
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--text-heading);
            line-height: 1.25;
            margin-bottom: 0.2rem;
        }

        .cell-date-text {
            font-size: 0.78rem;
            color: var(--text-muted);
            font-family: var(--font-mono);
            font-weight: 600;
        }

        .cell-reg-deadline {
            display: flex;
            flex-direction: column;
            font-family: var(--font-mono);
        }

        .cell-reg-deadline .reg-label {
            font-size: 0.68rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            line-height: 1.2;
        }

        .cell-reg-deadline .reg-date {
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--text-heading);
            line-height: 1.25;
        }

        .cell-occupancy-text {
            font-size: 0.9rem;
            font-weight: 800;
            font-family: var(--font-mono);
            color: var(--text-heading);
        }

        .link-matrix-view {
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--brand-primary);
            text-decoration: underline;
            text-underline-offset: 3px;
            cursor: pointer;
            transition: color 0.15s ease;
            white-space: nowrap;
        }

        .link-matrix-view:hover {
            color: var(--brand-primary-hover);
        }

        /* Row Actions */
        .row-actions-group {
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .btn-table-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.35rem 0.65rem;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
            text-decoration: none;
            border: 1px solid #cbd5e1;
            background-color: #ffffff;
            color: #334155;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .btn-table-action:hover {
            background-color: #f1f5f9;
            border-color: #94a3b8;
            color: #0f172a;
        }

        .btn-table-action.action-edit:hover {
            background-color: #eff6ff;
            border-color: #bfdbfe;
            color: #1d4ed8;
        }

        .btn-table-action.action-cancel {
            color: #b91c1c;
        }

        .btn-table-action.action-cancel:hover {
            background-color: #fef2f2;
            border-color: #fecaca;
            color: #991b1b;
        }

        /* ─── Feedback Banner ─── */
        .feedback-alert {
            padding: 0.75rem 1.25rem;
            border-radius: 6px;
            font-size: 0.82rem;
            font-weight: 600;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .alert-success {
            background-color: #ecfdf5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background-color: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        /* ─── Modal Dialog ─── */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 100;
        }

        .modal-box {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            border: 1px solid var(--border-subtle);
            width: 90%;
            max-width: 480px;
            overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        .modal-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-title {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--text-heading);
        }

        .modal-body {
            padding: 1.5rem;
        }

        .modal-footer {
            padding: 1rem 1.5rem;
            background-color: #f8fafc;
            border-top: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 0.75rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-label {
            display: block;
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 0.4rem;
        }

        .form-textarea {
            width: 100%;
            padding: 0.6rem 0.85rem;
            border: 1px solid var(--border-subtle);
            border-radius: 6px;
            font-size: 0.82rem;
            font-family: var(--font-sans);
            color: var(--text-heading);
            background-color: #f8fafc;
            resize: vertical;
            min-height: 80px;
        }

        .form-textarea:focus {
            outline: none;
            border-color: var(--border-focus);
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        @media (max-width: 1200px) {
            .summary-kpi-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 640px) {
            .summary-kpi-grid {
                grid-template-columns: 1fr;
            }
            .matrix-toolbar {
                flex-direction: column;
                align-items: stretch;
            }
            .filters-right-group {
                flex-direction: column;
                align-items: stretch;
            }
            .input-search {
                width: 100%;
            }
        }
    </style>
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
