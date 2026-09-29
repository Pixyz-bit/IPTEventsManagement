<%@ Page Title="Event Pre-Registered Roster" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventPreRegistered.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventPreRegistered" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Event Pre-Registered Roster | QCU Event Management
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ==========================================================================
           Event Pre-Registered Roster Styling System
           Institutional Clean White Palette (#ffffff surfaces, #2563eb primary)
           ========================================================================== */
        
        .prereg-container {
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
            position: relative;
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

        /* KPI Metric Cards (Crisp White with High-Contrast Text) */
        .kpi-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem;
        }

        .kpi-card {
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

        .kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-elevated);
        }

        .kpi-details {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .kpi-label {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
        }

        .kpi-value {
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--text-heading);
            line-height: 1.2;
        }

        .kpi-subtext {
            font-size: 0.75rem;
            color: var(--text-muted);
        }

        .kpi-icon-badge {
            width: 44px;
            height: 44px;
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .kpi-icon-blue {
            background-color: var(--brand-subtle);
            color: var(--brand-primary);
            border: 1px solid var(--brand-border);
        }

        .kpi-icon-amber {
            background-color: var(--accent-amber-subtle);
            color: var(--accent-amber);
            border: 1px solid var(--accent-amber-border);
        }

        .kpi-icon-red {
            background-color: var(--accent-rose-subtle);
            color: var(--accent-rose);
            border: 1px solid var(--accent-rose-border);
        }

        .kpi-icon-emerald {
            background-color: var(--accent-emerald-subtle);
            color: var(--accent-emerald);
            border: 1px solid var(--accent-emerald-border);
        }

        /* Multi-Filter & Search Controls Bar */
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
            max-width: 440px;
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

        .actions-group {
            display: flex;
            align-items: center;
            gap: 0.65rem;
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

        .btn-clear-filters {
            background-color: #ffffff;
            color: var(--text-muted);
            border: 1px solid var(--border-medium);
            padding: 0.5rem 0.95rem;
            border-radius: var(--radius-md);
            font-size: 0.825rem;
            font-weight: 500;
            cursor: pointer;
            box-shadow: var(--shadow-subtle);
            transition: all 0.15s ease;
        }

        .btn-clear-filters:hover {
            background-color: var(--bg-hover);
            color: var(--text-heading);
        }

        /* Dual-Sheet Tabbed Roster Navigation */
        .sheet-tabs-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border-bottom: 2px solid var(--border-subtle);
            margin-bottom: 0.5rem;
        }

        .sheet-tab-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.65rem;
            padding: 0.75rem 1.25rem;
            background: transparent;
            border: none;
            border-bottom: 2px solid transparent;
            margin-bottom: -2px;
            color: var(--text-muted);
            font-size: 0.9rem;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .sheet-tab-btn:hover {
            color: var(--text-heading);
        }

        .sheet-tab-btn.active {
            color: var(--brand-primary);
            border-bottom-color: var(--brand-primary);
            font-weight: 700;
        }

        .sheet-tab-btn.active-cancelled {
            color: var(--accent-rose);
            border-bottom-color: var(--accent-rose);
            font-weight: 700;
        }

        .sheet-badge {
            font-size: 0.725rem;
            padding: 0.2rem 0.55rem;
            border-radius: var(--radius-full);
            font-weight: 700;
        }

        .sheet-badge-primary {
            background-color: var(--brand-subtle);
            color: var(--brand-primary);
            border: 1px solid var(--brand-border);
        }

        .sheet-badge-cancelled {
            background-color: var(--accent-rose-subtle);
            color: var(--accent-rose);
            border: 1px solid var(--accent-rose-border);
        }

        /* Roster Table Card (Pure White with Crisp High-Contrast) */
        .roster-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-card);
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .roster-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.85rem;
        }

        .roster-table th {
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

        .roster-table td {
            padding: 0.95rem 1.15rem;
            border-bottom: 1px solid var(--border-subtle);
            color: var(--text-body);
            vertical-align: middle;
        }

        .roster-table tbody tr {
            transition: background-color 0.15s ease;
        }

        .roster-table tbody tr:hover td {
            background-color: var(--bg-hover);
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

        .ticket-code-cancelled {
            color: var(--accent-rose);
            background-color: var(--accent-rose-subtle);
            border-color: var(--accent-rose-border);
        }

        .student-id-text {
            font-family: var(--font-mono);
            font-size: 0.875rem;
            font-weight: 700;
            color: var(--text-heading);
            letter-spacing: -0.01em;
            white-space: nowrap;
        }

        .student-name-block {
            display: flex;
            flex-direction: column;
            gap: 0.15rem;
        }

        .student-name-text {
            font-weight: 700;
            color: var(--text-heading);
            font-size: 0.875rem;
        }

        .student-email-text {
            font-size: 0.775rem;
            color: var(--text-muted);
        }

        /* Stacked Department (small on top) & Course (bold below) - Matches Student Directory */
        .dept-course-cell {
            display: flex;
            flex-direction: column;
            gap: 0.15rem;
        }

        .dept-text {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.02em;
        }

        .course-text {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-heading);
        }

        /* Stacked Year Level & Section */
        .year-section-cell {
            display: flex;
            flex-direction: column;
            gap: 0.15rem;
        }

        .year-text {
            font-size: 0.825rem;
            font-weight: 600;
            color: var(--text-heading);
        }

        .section-text {
            font-size: 0.75rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* Status Pills (Present, Reserved, Cancelled) */
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 0.25rem 0.65rem;
            border-radius: var(--radius-full);
            white-space: nowrap;
            text-transform: uppercase;
            letter-spacing: 0.02em;
        }

        .status-pill-reserved {
            background-color: var(--brand-subtle);
            color: var(--brand-primary);
            border: 1px solid var(--brand-border);
        }

        .status-pill-present {
            background-color: var(--accent-emerald-subtle);
            color: var(--accent-emerald-text);
            border: 1px solid var(--accent-emerald-border);
        }

        .status-pill-cancelled {
            background-color: var(--accent-rose-subtle);
            color: var(--accent-rose-text);
            border: 1px solid var(--accent-rose-border);
        }

        .status-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            display: inline-block;
        }

        .status-dot-present {
            background-color: var(--accent-emerald);
        }

        .status-dot-reserved {
            background-color: var(--brand-primary);
        }

        .status-dot-cancelled {
            background-color: var(--accent-rose);
        }

        /* View > Link (Underlined text link per Student Directory reference) */
        .btn-view-link {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-heading);
            text-decoration: underline;
            text-underline-offset: 3px;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
            font-family: inherit;
            transition: color 0.15s ease;
            white-space: nowrap;
        }

        .btn-view-link:hover {
            color: var(--brand-primary);
        }

        .btn-modal-cancel {
            background-color: var(--accent-rose-subtle);
            color: var(--accent-rose);
            border: 1px solid var(--accent-rose-border);
            padding: 0.5rem 1.15rem;
            border-radius: var(--radius-md);
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: var(--shadow-subtle);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            transition: all 0.15s ease;
        }

        .btn-modal-cancel:hover {
            background-color: #fee2e2;
            color: var(--accent-rose-hover);
        }

        .empty-roster-state {
            padding: 3.5rem 1.5rem;
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

        /* Modal Pop-Up Dialog Styling (Clean White) */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(15, 23, 42, 0.55);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.2s ease;
        }

        .modal-overlay.open {
            opacity: 1;
            pointer-events: auto;
        }

        .modal-dialog {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            width: 90%;
            max-width: 580px;
            box-shadow: var(--shadow-modal);
            overflow: hidden;
            transform: scale(0.96);
            transition: transform 0.2s ease;
        }

        .modal-overlay.open .modal-dialog {
            transform: scale(1);
        }

        .modal-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #ffffff;
        }

        .modal-header h3 {
            margin: 0;
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-heading);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .modal-close-btn {
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 1.25rem;
            cursor: pointer;
            padding: 0.25rem;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: var(--radius-sm);
        }

        .modal-close-btn:hover {
            color: var(--text-heading);
            background-color: var(--bg-hover);
        }

        .modal-body {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
            background-color: #ffffff;
        }

        .profile-summary-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding-bottom: 1.25rem;
            border-bottom: 1px solid var(--border-subtle);
        }

        .profile-avatar-placeholder {
            width: 54px;
            height: 54px;
            border-radius: 50%;
            background-color: var(--brand-subtle);
            color: var(--brand-primary);
            font-size: 1.25rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid var(--brand-border);
        }

        .profile-name-title h4 {
            margin: 0 0 0.25rem 0;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-heading);
        }

        .profile-name-title p {
            margin: 0;
            font-size: 0.825rem;
            color: var(--brand-primary);
            font-weight: 600;
        }

        .profile-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .profile-field-block {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .profile-field-label {
            font-size: 0.725rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
        }

        .profile-field-value {
            font-size: 0.875rem;
            color: var(--text-heading);
            font-weight: 600;
            background-color: var(--bg-subtle);
            border: 1px solid var(--border-subtle);
            padding: 0.45rem 0.75rem;
            border-radius: var(--radius-sm);
        }

        .modal-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border-subtle);
            background-color: #ffffff;
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
        }

        .btn-modal-close {
            background-color: #ffffff;
            color: var(--text-body);
            border: 1px solid var(--border-medium);
            padding: 0.5rem 1.15rem;
            border-radius: var(--radius-md);
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: var(--shadow-subtle);
            transition: all 0.15s ease;
        }

        .btn-modal-close:hover {
            background-color: var(--bg-hover);
            color: var(--text-heading);
        }

        /* Alert Toast */
        .alert-toast {
            padding: 0.85rem 1.25rem;
            border-radius: var(--radius-md);
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.65rem;
            margin-bottom: 0.5rem;
            box-shadow: var(--shadow-subtle);
        }

        .alert-toast-success {
            background-color: var(--accent-emerald-subtle);
            border: 1px solid var(--accent-emerald-border);
            color: var(--accent-emerald-text);
        }

        .alert-toast-danger {
            background-color: var(--accent-rose-subtle);
            border: 1px solid var(--accent-rose-border);
            color: var(--accent-rose-text);
        }
    </style>
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

    <!-- Live KPI Metrics Cards -->
    <div class="kpi-row">
        <div class="kpi-card">
            <div class="kpi-details">
                <span class="kpi-label">Pre-Registered Roster</span>
                <span class="kpi-value"><asp:Literal ID="litKpiPreRegistered" runat="server" Text="0"></asp:Literal></span>
                <span class="kpi-subtext">Expected gate check-in cohort</span>
            </div>
            <div class="kpi-icon-badge kpi-icon-blue">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="8.5" cy="7" r="4"></circle>
                    <polyline points="17 11 19 13 23 9"></polyline>
                </svg>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-details">
                <span class="kpi-label">Available Capacity Pool</span>
                <span class="kpi-value"><asp:Literal ID="litKpiAvailablePool" runat="server" Text="0"></asp:Literal></span>
                <span class="kpi-subtext">Remaining seats for event</span>
            </div>
            <div class="kpi-icon-badge kpi-icon-emerald">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
                </svg>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-details">
                <span class="kpi-label">Revoked / Cancelled</span>
                <span class="kpi-value"><asp:Literal ID="litKpiCancelled" runat="server" Text="0"></asp:Literal></span>
                <span class="kpi-subtext">Slots released back to pool</span>
            </div>
            <div class="kpi-icon-badge kpi-icon-red">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-details">
                <span class="kpi-label">Occupancy Rate</span>
                <span class="kpi-value"><asp:Literal ID="litKpiOccupancyRate" runat="server" Text="0%"></asp:Literal></span>
                <span class="kpi-subtext">Of maximum venue quota</span>
            </div>
            <div class="kpi-icon-badge kpi-icon-amber">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                    <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                </svg>
            </div>
        </div>
    </div>

    <!-- Search & Multi-Filter Controls Card -->
    <div class="controls-card">
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

    <!-- Dual-Sheet Tabbed Navigation -->
    <div class="sheet-tabs-container">
        <button type="button" id="tabPreRegistered" class="sheet-tab-btn active" onclick="switchSheet('preregistered')">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
            </svg>
            <span>Pre-Registered Sheet (Expected Attendees)</span>
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
            <span>Cancelled Sheet (Revoked Passes)</span>
            <span class="sheet-badge sheet-badge-cancelled">
                <asp:Literal ID="litTabCountCancelled" runat="server" Text="0"></asp:Literal>
            </span>
        </button>
    </div>

    <!-- Sheet 1: Pre-Registered Roster Table -->
    <div id="sheetPreRegistered" class="roster-card">
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
    <div id="sheetCancelled" class="roster-card" style="display:none;">
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
