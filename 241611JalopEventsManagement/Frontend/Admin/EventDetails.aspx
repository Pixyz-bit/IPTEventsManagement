<%@ Page Title="Event Specifications & Configuration | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventDetails.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventDetails" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ─── Breadcrumb Navigation ─── */
        .breadcrumb-nav {
            margin-bottom: 0.85rem;
        }

        .breadcrumb-list {
            list-style: none;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.5rem;
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        .breadcrumb-item a {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.15s ease;
        }

        .breadcrumb-item a:hover {
            color: var(--brand-primary);
        }

        .breadcrumb-separator {
            color: #cbd5e1;
            display: flex;
            align-items: center;
        }

        .breadcrumb-item.active {
            color: var(--text-heading);
            font-weight: 700;
        }

        /* ─── Context Header & Event Pipeline Bar ─── */
        .event-hub-header {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.25rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .hub-title-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .hub-title-left {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .event-id-tag {
            font-family: var(--font-mono);
            font-size: 0.75rem;
            font-weight: 700;
            background-color: #f1f5f9;
            color: #475569;
            padding: 0.25rem 0.6rem;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
        }

        .hub-title-text {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.02em;
        }

        /* Status Badges */
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.25rem 0.65rem;
            border-radius: 9999px;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-pill.status-open {
            background-color: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
        }

        .status-pill.status-soon {
            background-color: #fefce8;
            color: #a16207;
            border: 1px solid #fef08a;
        }

        .status-pill.status-close {
            background-color: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
        }

        .status-pill.status-cancelled {
            background-color: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        /* Sub-Module Pipeline Tabs */
        .hub-pipeline-tabs {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border-top: 1px solid #f1f5f9;
            padding-top: 0.85rem;
            flex-wrap: wrap;
        }

        .pipeline-tab {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            padding: 0.5rem 0.95rem;
            border-radius: 6px;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-muted);
            text-decoration: none;
            transition: all 0.15s ease;
            background-color: #f8fafc;
            border: 1px solid transparent;
        }

        .pipeline-tab:hover {
            color: var(--brand-primary);
            background-color: #eff6ff;
            border-color: #bfdbfe;
        }

        .pipeline-tab.active {
            color: #ffffff;
            background-color: var(--brand-primary);
            border-color: var(--brand-primary);
        }

        /* ─── Mode Toolbar Banner ─── */
        .mode-banner-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.85rem 1.25rem;
            border-radius: 8px;
            margin-bottom: 1.25rem;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        .mode-banner-bar.view-mode {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            color: #334155;
        }

        .mode-banner-bar.edit-mode {
            background-color: #eff6ff;
            border: 1px solid #93c5fd;
            color: #1e40af;
        }

        .mode-status-info {
            display: flex;
            align-items: center;
            gap: 0.65rem;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .mode-actions {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Buttons */
        .btn-action-primary {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            background-color: var(--brand-primary);
            color: #ffffff;
            padding: 0.55rem 1.15rem;
            border-radius: 6px;
            font-size: 0.82rem;
            font-weight: 600;
            border: 1px solid var(--brand-primary);
            cursor: pointer;
            transition: all 0.15s ease;
            text-decoration: none;
        }

        .btn-action-primary:hover {
            background-color: var(--brand-primary-hover);
        }

        .btn-action-secondary {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            background-color: #ffffff;
            color: #334155;
            padding: 0.55rem 1.15rem;
            border-radius: 6px;
            font-size: 0.82rem;
            font-weight: 600;
            border: 1px solid var(--border-subtle);
            cursor: pointer;
            transition: all 0.15s ease;
            text-decoration: none;
        }

        .btn-action-secondary:hover {
            background-color: #f1f5f9;
            color: #0f172a;
        }

        .btn-action-danger {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            background-color: #ffffff;
            color: #b91c1c;
            padding: 0.55rem 1.15rem;
            border-radius: 6px;
            font-size: 0.82rem;
            font-weight: 600;
            border: 1px solid #fecaca;
            cursor: pointer;
            transition: all 0.15s ease;
            text-decoration: none;
        }

        .btn-action-danger:hover {
            background-color: #fef2f2;
            border-color: #f87171;
        }

        /* ─── Layout Grid (2 Columns) ─── */
        .details-grid-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.25rem;
            align-items: start;
        }

        /* Section Card Container */
        .spec-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            padding: 1.35rem 1.5rem;
            margin-bottom: 1.25rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
        }

        .spec-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.15rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid #f1f5f9;
        }

        .spec-card-title {
            display: flex;
            align-items: center;
            gap: 0.55rem;
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-heading);
        }

        .spec-card-title svg {
            color: var(--brand-primary);
        }

        /* Data Key-Value Presentation (View Mode) */
        .kv-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .kv-item {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .kv-item.full-width {
            grid-column: 1 / -1;
        }

        .kv-label {
            font-size: 0.73rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .kv-value {
            font-size: 0.88rem;
            font-weight: 600;
            color: var(--text-heading);
            word-break: break-word;
        }

        .kv-value.mono {
            font-family: var(--font-mono);
        }

        .kv-value.highlight {
            color: var(--brand-primary);
        }

        /* Form Controls (Edit Mode) */
        .form-group {
            margin-bottom: 1rem;
        }

        .form-label {
            display: block;
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 0.35rem;
        }

        .form-control {
            width: 100%;
            padding: 0.6rem 0.85rem;
            border: 1px solid var(--border-subtle);
            border-radius: 6px;
            font-size: 0.85rem;
            font-family: var(--font-sans);
            color: var(--text-heading);
            background-color: #ffffff;
            transition: all 0.15s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 85px;
        }

        /* Dual-Ratio Banner Grid */
        .banner-upload-grid {
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 1.25rem;
            align-items: start;
        }

        .banner-slot {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1rem;
        }

        .banner-slot-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--text-heading);
        }

        .banner-ratio-tag {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            font-weight: 700;
            background-color: #eff6ff;
            color: #1e40af;
            padding: 0.15rem 0.45rem;
            border-radius: 4px;
            border: 1px solid #bfdbfe;
        }

        .banner-preview-box {
            position: relative;
            background-color: #0f172a;
            border-radius: 6px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #334155;
        }

        .banner-preview-box.ratio-wide {
            aspect-ratio: 16 / 9;
        }

        .banner-preview-box.ratio-square {
            aspect-ratio: 1 / 1;
        }

        .banner-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .banner-spec-hint {
            font-size: 0.72rem;
            color: var(--text-muted);
            line-height: 1.35;
        }

        /* Chips & Badges */
        .chips-container {
            display: flex;
            flex-wrap: wrap;
            gap: 0.4rem;
            margin-top: 0.25rem;
        }

        .badge-chip {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.25rem 0.6rem;
            background-color: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1e40af;
            border-radius: 9999px;
            font-size: 0.76rem;
            font-weight: 600;
        }

        .badge-chip.removable {
            padding-right: 0.35rem;
        }

        .btn-chip-remove {
            background: none;
            border: none;
            color: #ef4444;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: bold;
            padding: 0 0.2rem;
            line-height: 1;
        }

        /* Capacity Progress Bar */
        .occupancy-card {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 0.5rem;
        }

        .occupancy-metric-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 0.4rem;
        }

        .occupancy-num {
            font-family: var(--font-mono);
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--text-heading);
        }

        .occupancy-pct {
            font-family: var(--font-mono);
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--brand-primary);
        }

        .capacity-bar-track {
            height: 8px;
            background-color: #e2e8f0;
            border-radius: 9999px;
            overflow: hidden;
        }

        .capacity-bar-fill {
            height: 100%;
            background-color: var(--brand-primary);
            border-radius: 9999px;
            transition: width 0.3s ease;
        }

        /* Alerts */
        .feedback-alert {
            padding: 0.85rem 1.25rem;
            border-radius: 8px;
            font-size: 0.84rem;
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

        .alert-info {
            background-color: #f0f9ff;
            color: #0369a1;
            border: 1px solid #bae6fd;
        }

        /* Enforcement Callout */
        .enforcement-callout {
            background-color: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 8px;
            padding: 0.85rem 1rem;
            display: flex;
            align-items: flex-start;
            gap: 0.65rem;
            margin-top: 0.75rem;
        }

        .enforcement-callout svg {
            color: #16a34a;
            flex-shrink: 0;
            margin-top: 0.15rem;
        }

        .enforcement-callout-text h5 {
            font-size: 0.82rem;
            font-weight: 700;
            color: #166534;
            margin-bottom: 0.15rem;
        }

        .enforcement-callout-text p {
            font-size: 0.74rem;
            color: #15803d;
            margin: 0;
            line-height: 1.35;
        }

        @media (max-width: 1024px) {
            .details-grid-layout {
                grid-template-columns: 1fr;
            }
            .banner-upload-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
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
                <span>Event Specifications &amp; Details</span>
            </li>
        </ol>
    </nav>

    <!-- Feedback Alerts -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="feedback-alert alert-success">
        <div>
            <asp:Literal ID="litSuccessMsg" runat="server" />
        </div>
        <asp:LinkButton ID="btnCloseSuccess" runat="server" Text="&times;" OnClick="btnCloseAlert_Click" Style="color:inherit; font-size:1.25rem; font-weight:bold; background:none; border:none; cursor:pointer;" CausesValidation="false" />
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="feedback-alert alert-error">
        <div>
            <asp:Literal ID="litErrorMsg" runat="server" />
        </div>
        <asp:LinkButton ID="btnCloseError" runat="server" Text="&times;" OnClick="btnCloseAlert_Click" Style="color:inherit; font-size:1.25rem; font-weight:bold; background:none; border:none; cursor:pointer;" CausesValidation="false" />
    </asp:Panel>

    <asp:Panel ID="pnlDemoNotice" runat="server" Visible="false" CssClass="feedback-alert alert-info">
        <div>
            <strong>Notice:</strong> <asp:Literal ID="litDemoNotice" runat="server" Text="Displaying demonstration event specifications. Select an active event from the Events Matrix to manage live records." />
        </div>
    </asp:Panel>

    <!-- Event Context Header & Sub-Module Pipeline Hub -->
    <div class="event-hub-header">
        <div class="hub-title-row">
            <div class="hub-title-left">
                <span class="event-id-tag"><asp:Literal ID="litHeaderEventId" runat="server" Text="EVENT #-" /></span>
                <span class="hub-title-text"><asp:Literal ID="litHeaderTitle" runat="server" Text="Event Specifications" /></span>
                <span class="status-pill <%= HeaderStatusBadgeClass %>">
                    <asp:Literal ID="litHeaderStatus" runat="server" Text="Upcoming" />
                </span>
            </div>
            <div>
                <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="btn-action-secondary">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="19" y1="12" x2="5" y2="12"></line>
                        <polyline points="12 19 5 12 12 5"></polyline>
                    </svg>
                    <span>Back to Events Matrix</span>
                </a>
            </div>
        </div>

        <!-- 4-Module Pipeline Tabs -->
        <div class="hub-pipeline-tabs">
            <a href="<%= ResolveUrl("~/Frontend/Admin/EventDetails.aspx?eventId=" + CurrentEventId) %>" class="pipeline-tab active">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                </svg>
                <span>1. Event Details (Active)</span>
            </a>
            <a href="<%= ResolveUrl("~/Frontend/Admin/EventAttendees.aspx?eventId=" + CurrentEventId) %>" class="pipeline-tab">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
                <span>2. Pre-Registered Roster</span>
            </a>
            <a href="<%= ResolveUrl("~/Frontend/Admin/CheckIn.aspx?eventId=" + CurrentEventId) %>" class="pipeline-tab">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M4 7V4h3M20 7V4h-3M4 17v3h3M20 17v3h-3M9 9h6v6H9z"></path>
                </svg>
                <span>3. Check-In Scanner</span>
            </a>
            <a href="<%= ResolveUrl("~/Frontend/Admin/Reports.aspx?eventId=" + CurrentEventId) %>" class="pipeline-tab">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="20" x2="18" y2="10"></line>
                    <line x1="12" y1="20" x2="12" y2="4"></line>
                    <line x1="6" y1="20" x2="6" y2="14"></line>
                </svg>
                <span>4. Event Turnout Analytics</span>
            </a>
        </div>
    </div>

    <!-- Mode Banner & Controller -->
    <div class="mode-banner-bar <%= IsEditMode ? "edit-mode" : "view-mode" %>">
        <div class="mode-status-info">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="16" x2="12" y2="12"></line>
                <line x1="12" y1="8" x2="12.01" y2="8"></line>
            </svg>
            <span>
                <asp:Literal ID="litModeDescription" runat="server" Text="Authoritative Event Configuration &bull; Read-Only Mode" />
            </span>
        </div>
        <div class="mode-actions">
            <asp:PlaceHolder ID="phViewActions" runat="server">
                <asp:Button ID="btnToggleEdit" runat="server" Text="Edit Specifications" CssClass="btn-action-primary" OnClick="btnToggleEdit_Click" CausesValidation="false" />
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="phEditActions" runat="server" Visible="false">
                <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel Editing" CssClass="btn-action-secondary" OnClick="btnCancelEdit_Click" CausesValidation="false" />
                <asp:Button ID="btnSaveChanges" runat="server" Text="Save Modifications" CssClass="btn-action-primary" OnClick="btnSaveChanges_Click" />
            </asp:PlaceHolder>
        </div>
    </div>

    <!-- Main Content 2-Column Grid -->
    <div class="details-grid-layout">
        <!-- Left / Primary Column -->
        <div>
            <!-- Section 1: General Information & Venue Allocation -->
            <div class="spec-card">
                <div class="spec-card-header">
                    <div class="spec-card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                        </svg>
                        <span>General Event Information</span>
                    </div>
                    <span class="event-id-tag">SECTION 01</span>
                </div>

                <!-- Read-Only View -->
                <asp:PlaceHolder ID="phGeneralView" runat="server">
                    <div class="kv-grid-2">
                        <div class="kv-item full-width">
                            <span class="kv-label">Event Title</span>
                            <span class="kv-value"><asp:Literal ID="litTitleView" runat="server" /></span>
                        </div>
                        <div class="kv-item">
                            <span class="kv-label">Physical Venue / Location</span>
                            <span class="kv-value"><asp:Literal ID="litVenueView" runat="server" /></span>
                        </div>
                        <div class="kv-item">
                            <span class="kv-label">Allocated Seating Capacity</span>
                            <span class="kv-value mono highlight"><asp:Literal ID="litCapacityView" runat="server" /> Seats</span>
                        </div>
                        <div class="kv-item full-width">
                            <span class="kv-label">Detailed Event Description</span>
                            <span class="kv-value" style="font-weight:400; line-height:1.5;"><asp:Literal ID="litDescView" runat="server" /></span>
                        </div>
                    </div>
                </asp:PlaceHolder>

                <!-- Editable Form Controls -->
                <asp:PlaceHolder ID="phGeneralEdit" runat="server" Visible="false">
                    <div class="form-group">
                        <label class="form-label" for="<%= txtTitle.ClientID %>">Event Title <span style="color:#ef4444;">*</span></label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="200" />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="<%= txtVenueLocation.ClientID %>">Physical Venue / Location <span style="color:#ef4444;">*</span></label>
                        <asp:TextBox ID="txtVenueLocation" runat="server" CssClass="form-control" MaxLength="200" />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="<%= txtMaxCapacity.ClientID %>">Maximum Seating Capacity <span style="color:#ef4444;">*</span></label>
                        <asp:TextBox ID="txtMaxCapacity" runat="server" CssClass="form-control" TextMode="Number" />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="<%= txtDescription.ClientID %>">Detailed Event Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" />
                    </div>
                </asp:PlaceHolder>
            </div>

            <!-- Section 2: Execution Schedule & Registration Window -->
            <div class="spec-card">
                <div class="spec-card-header">
                    <div class="spec-card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <span>Event Execution Schedule &amp; Registration Lifecycle</span>
                    </div>
                    <span class="event-id-tag">SECTION 02</span>
                </div>

                <!-- Read-Only View -->
                <asp:PlaceHolder ID="phScheduleView" runat="server">
                    <div class="kv-grid-2">
                        <div class="kv-item">
                            <span class="kv-label">Event Date (MM/DD/YYYY)</span>
                            <span class="kv-value mono"><asp:Literal ID="litEventDateView" runat="server" /></span>
                        </div>
                        <div class="kv-item">
                            <span class="kv-label">Event Execution Hours</span>
                            <span class="kv-value mono"><asp:Literal ID="litEventHoursView" runat="server" /></span>
                        </div>
                        <div class="kv-item">
                            <span class="kv-label">Registration Opening Window</span>
                            <span class="kv-value mono"><asp:Literal ID="litRegStartView" runat="server" /></span>
                        </div>
                        <div class="kv-item">
                            <span class="kv-label">Registration Final Deadline</span>
                            <span class="kv-value mono"><asp:Literal ID="litRegEndView" runat="server" /></span>
                        </div>
                    </div>
                </asp:PlaceHolder>

                <!-- Editable Controls -->
                <asp:PlaceHolder ID="phScheduleEdit" runat="server" Visible="false">
                    <div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:0.75rem; margin-bottom:1rem;">
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= txtEventDate.ClientID %>">Event Date <span style="color:#ef4444;">*</span></label>
                            <asp:TextBox ID="txtEventDate" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= txtStartTime.ClientID %>">Start Time <span style="color:#ef4444;">*</span></label>
                            <asp:TextBox ID="txtStartTime" runat="server" CssClass="form-control" TextMode="Time" />
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= txtEndTime.ClientID %>">End Time <span style="color:#ef4444;">*</span></label>
                            <asp:TextBox ID="txtEndTime" runat="server" CssClass="form-control" TextMode="Time" />
                        </div>
                    </div>

                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.75rem;">
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= txtRegStart.ClientID %>">Registration Start Date &amp; Time <span style="color:#ef4444;">*</span></label>
                            <asp:TextBox ID="txtRegStart" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= txtRegEnd.ClientID %>">Registration Deadline Date &amp; Time <span style="color:#ef4444;">*</span></label>
                            <asp:TextBox ID="txtRegEnd" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                        </div>
                    </div>
                </asp:PlaceHolder>

                <!-- Logic Rules Callout -->
                <div class="enforcement-callout">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 14 14"></polyline>
                    </svg>
                    <div class="enforcement-callout-text">
                        <h5>Logical Timestamp Sequencing Policy</h5>
                        <p>Registration End Date must conclude before or at Event Kickoff. Registration Start Date must strictly precede the Registration Deadline.</p>
                    </div>
                </div>
            </div>

            <!-- Section 3: Dual-Ratio Banner Media Assets -->
            <div class="spec-card">
                <div class="spec-card-header">
                    <div class="spec-card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                            <circle cx="8.5" cy="8.5" r="1.5"></circle>
                            <polyline points="21 15 16 10 5 21"></polyline>
                        </svg>
                        <span>Dual-Ratio Media Assets &amp; Banners</span>
                    </div>
                    <span class="event-id-tag">SECTION 03</span>
                </div>

                <div class="banner-upload-grid">
                    <!-- Ratio 1: Wide Desktop Banner (16:9) -->
                    <div class="banner-slot">
                        <div class="banner-slot-title">
                            <span>Desktop Portal Hero</span>
                            <span class="banner-ratio-tag">16:9 WIDE</span>
                        </div>
                        <div class="banner-preview-box ratio-wide">
                            <asp:Image ID="imgWideBanner" runat="server" CssClass="banner-img" ImageUrl="~/Frontend/Assets/campus-clean.jpg" AlternateText="Wide Banner Preview" />
                        </div>
                        <div class="banner-spec-hint">
                            Recommended: 1920&times;1080px (PNG, JPG, or WEBP &bull; Max 4MB). Renders prominently on student portal catalog headers.
                        </div>
                        <asp:PlaceHolder ID="phWideUpload" runat="server" Visible="false">
                            <asp:FileUpload ID="fuWideBanner" runat="server" CssClass="form-control" style="font-size:0.75rem; padding:0.4rem;" />
                        </asp:PlaceHolder>
                    </div>

                    <!-- Ratio 2: Square Mobile Pass Banner (1:1) -->
                    <div class="banner-slot">
                        <div class="banner-slot-title">
                            <span>Mobile Ticket Card</span>
                            <span class="banner-ratio-tag">1:1 SQUARE</span>
                        </div>
                        <div class="banner-preview-box ratio-square">
                            <asp:Image ID="imgSquareBanner" runat="server" CssClass="banner-img" ImageUrl="~/Frontend/Assets/hero_cloud_lab.jpg" AlternateText="Square Banner Preview" />
                        </div>
                        <div class="banner-spec-hint">
                            Recommended: 800&times;800px. Guaranteed responsive display on smartphone digital wallets and QR passes.
                        </div>
                        <asp:PlaceHolder ID="phSquareUpload" runat="server" Visible="false">
                            <asp:FileUpload ID="fuSquareBanner" runat="server" CssClass="form-control" style="font-size:0.75rem; padding:0.4rem;" />
                        </asp:PlaceHolder>
                    </div>
                </div>
            </div>

            <!-- Section 4: Target Demographics (Audience Restrictions) -->
            <div class="spec-card">
                <div class="spec-card-header">
                    <div class="spec-card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        <span>Target Demographics (4-Tier Audience Matrix)</span>
                    </div>
                    <span class="event-id-tag">SECTION 04</span>
                </div>

                <!-- Read-Only View -->
                <asp:PlaceHolder ID="phDemographicsView" runat="server">
                    <div class="kv-grid-2">
                        <div class="kv-item">
                            <span class="kv-label">Campus Branch</span>
                            <span class="kv-value"><asp:Literal ID="litBranchView" runat="server" Text="All University Branches (Open)" /></span>
                        </div>
                        <div class="kv-item">
                            <span class="kv-label">Academic College / Department</span>
                            <span class="kv-value"><asp:Literal ID="litDeptView" runat="server" Text="All Academic Colleges" /></span>
                        </div>
                        <div class="kv-item">
                            <span class="kv-label">Student Standing Year Level</span>
                            <span class="kv-value"><asp:Literal ID="litYearLevelView" runat="server" Text="All Year Levels (1st - 4th)" /></span>
                        </div>
                        <div class="kv-item">
                            <span class="kv-label">Target Degree Programs</span>
                            <div class="chips-container">
                                <asp:Literal ID="litProgramsChips" runat="server" />
                            </div>
                        </div>
                    </div>
                </asp:PlaceHolder>

                <!-- Editable Controls -->
                <asp:PlaceHolder ID="phDemographicsEdit" runat="server" Visible="false">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.75rem; margin-bottom:1rem;">
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= ddlBranch.ClientID %>">Target Campus Branch</label>
                            <asp:DropDownList ID="ddlBranch" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All University Branches (Open to All)" />
                                <asp:ListItem Value="San Bartolome" Text="San Bartolome (Main Campus)" />
                                <asp:ListItem Value="San Francisco" Text="San Francisco Campus" />
                                <asp:ListItem Value="Batasan" Text="Batasan Campus" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= ddlDepartment.ClientID %>">Target Academic College</label>
                            <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All Academic Colleges (Open to All)" />
                                <asp:ListItem Value="College of Computer Studies" Text="College of Computer Studies (CCS)" />
                                <asp:ListItem Value="College of Business Administration" Text="College of Business Administration (CBA)" />
                                <asp:ListItem Value="College of Engineering" Text="College of Engineering (COE)" />
                                <asp:ListItem Value="College of Education" Text="College of Education (CED)" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.75rem;">
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= ddlYearLevel.ClientID %>">Target Standing Year Level</label>
                            <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All Year Standings (1st - 4th Year)" />
                                <asp:ListItem Value="1" Text="1st Year Standing Only" />
                                <asp:ListItem Value="2" Text="2nd Year Standing Only" />
                                <asp:ListItem Value="3" Text="3rd Year Standing Only" />
                                <asp:ListItem Value="4" Text="4th Year Standing Only" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label" for="<%= txtPrograms.ClientID %>">Target Degree Programs (Comma separated)</label>
                            <asp:TextBox ID="txtPrograms" runat="server" CssClass="form-control" placeholder="e.g. BSIT, BSCS, BSECE (or leave blank for all)" />
                        </div>
                    </div>
                </asp:PlaceHolder>

                <div class="enforcement-callout">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    <div class="enforcement-callout-text">
                        <h5>Registration Gate Enforcement</h5>
                        <p>The student registration engine strictly cross-checks student demographic profiles against these rules. If restrictions are configured, ineligible students are prevented from claiming an e-ticket.</p>
                    </div>
                </div>
            </div>

            <!-- Section 5: Partner & Sponsor Configuration -->
            <div class="spec-card">
                <div class="spec-card-header">
                    <div class="spec-card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                        </svg>
                        <span>Sponsors &amp; Institutional Partnerships</span>
                    </div>
                    <span class="event-id-tag">SECTION 05</span>
                </div>

                <!-- Sponsors List Chips -->
                <div class="chips-container" style="margin-bottom:1rem;">
                    <asp:Repeater ID="rptSponsors" runat="server" OnItemCommand="rptSponsors_ItemCommand">
                        <ItemTemplate>
                            <span class='badge-chip <%= IsEditMode ? "removable" : "" %>'>
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                                <span><%# Container.DataItem %></span>
                                <asp:LinkButton ID="btnRemoveSponsor" runat="server" CommandName="Remove" CommandArgument='<%# Container.DataItem %>' CssClass="btn-chip-remove" Visible='<%# IsEditMode %>' CausesValidation="false" title="Remove sponsor">&times;</asp:LinkButton>
                            </span>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Literal ID="litNoSponsors" runat="server" Text="<span style='color:#64748b; font-size:0.8rem; font-style:italic;'>No corporate or academic sponsors attached (Institutional event).</span>" />
                </div>

                <!-- Add Sponsor Input (In Edit Mode) -->
                <asp:PlaceHolder ID="phAddSponsor" runat="server" Visible="false">
                    <div style="display:flex; gap:0.5rem; max-width:400px;">
                        <asp:TextBox ID="txtNewSponsor" runat="server" CssClass="form-control" placeholder="Enter sponsor / partner name" />
                        <asp:Button ID="btnAddSponsor" runat="server" Text="Add" CssClass="btn-action-secondary" OnClick="btnAddSponsor_Click" CausesValidation="false" />
                    </div>
                </asp:PlaceHolder>
            </div>
        </div>

        <!-- Right / Operational Sidebar Column -->
        <div>
            <!-- Cockpit Status & Occupancy Card -->
            <div class="spec-card">
                <div class="spec-card-header">
                    <div class="spec-card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 14"></polyline>
                        </svg>
                        <span>Live Gate Occupancy</span>
                    </div>
                    <span class="status-pill <%= HeaderStatusBadgeClass %>">
                        <asp:Literal ID="litSidebarStatus" runat="server" Text="Upcoming" />
                    </span>
                </div>

                <!-- Occupancy Ratio Gauge -->
                <div class="occupancy-card">
                    <div class="occupancy-metric-row">
                        <span class="kv-label">Reserved Seats / Quota</span>
                        <span class="occupancy-pct"><asp:Literal ID="litOccupancyPct" runat="server" Text="0%" /></span>
                    </div>
                    <div class="occupancy-metric-row">
                        <span class="occupancy-num"><asp:Literal ID="litOccupancyCount" runat="server" Text="0 / 150" /></span>
                        <span style="font-size:0.75rem; color:#64748b;"><asp:Literal ID="litRemainingSpots" runat="server" Text="150 spots open" /></span>
                    </div>
                    <div class="capacity-bar-track">
                        <div class="capacity-bar-fill" style="width: <%= OccupancyBarWidth %>%;"></div>
                    </div>
                </div>

                <!-- Quick Navigation to Operational Sub-Modules -->
                <div style="margin-top:1.25rem; display:flex; flex-direction:column; gap:0.65rem;">
                    <a href="<%= ResolveUrl("~/Frontend/Admin/EventAttendees.aspx?eventId=" + CurrentEventId) %>" class="btn-action-secondary" style="justify-content:center;">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                        </svg>
                        <span>View Pre-Registered Attendees</span>
                    </a>

                    <a href="<%= ResolveUrl("~/Frontend/Admin/CheckIn.aspx?eventId=" + CurrentEventId) %>" class="btn-action-primary" style="justify-content:center;">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 7V4h3M20 7V4h-3M4 17v3h3M20 17v3h-3M9 9h6v6H9z"></path>
                        </svg>
                        <span>Launch QR Gate Scanner</span>
                    </a>

                    <a href="<%= ResolveUrl("~/Frontend/Admin/Reports.aspx?eventId=" + CurrentEventId) %>" class="btn-action-secondary" style="justify-content:center;">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="20" x2="18" y2="10"></line>
                            <line x1="12" y1="20" x2="12" y2="4"></line>
                            <line x1="6" y1="20" x2="6" y2="14"></line>
                        </svg>
                        <span>View Turnout Analytics</span>
                    </a>
                </div>
            </div>

            <!-- Event Administrative Metadata Card -->
            <div class="spec-card">
                <div class="spec-card-header">
                    <div class="spec-card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                        <span>Administrative Record</span>
                    </div>
                </div>

                <div class="kv-grid-2">
                    <div class="kv-item full-width">
                        <span class="kv-label">Event Record ID</span>
                        <span class="kv-value mono">#<asp:Literal ID="litMetaEventId" runat="server" Text="-" /></span>
                    </div>
                    <div class="kv-item full-width">
                        <span class="kv-label">Date Format Standard</span>
                        <span class="kv-value mono" style="font-size:0.78rem; color:#047857;">MM/DD/YYYY (Compliant)</span>
                    </div>
                    <div class="kv-item full-width">
                        <span class="kv-label">Configured Sponsors Count</span>
                        <span class="kv-value mono"><asp:Literal ID="litMetaSponsorCount" runat="server" Text="0" /> Sponsors</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
