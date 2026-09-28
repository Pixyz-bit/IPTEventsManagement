<%@ Page Title="Publish New Event | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreateEvent.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.CreateEvent" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ─── Standard Breadcrumb Navigation ─── */
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

        /* ─── Page Workspace Header ─── */
        .page-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.25rem;
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
            padding: 0.6rem 1.25rem;
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
            color: var(--text-heading);
            padding: 0.6rem 1.1rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            border: 1px solid var(--border-subtle);
            box-shadow: var(--shadow-subtle);
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .btn-action-secondary:hover {
            background-color: #f8fafc;
            border-color: #cbd5e1;
            color: var(--brand-primary);
        }

        /* ─── Step-by-Step Procedure Breadcrumb Tabs ─── */
        .procedure-stepper-container {
            display: flex;
            align-items: center;
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            padding: 0.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            overflow-x: auto;
            gap: 0.35rem;
        }

        .procedure-step-tab {
            flex: 1;
            min-width: 175px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.65rem 0.9rem;
            border-radius: 7px;
            cursor: pointer;
            background: transparent;
            border: 1px solid transparent;
            transition: all 0.2s ease;
            user-select: none;
        }

        .procedure-step-tab:hover {
            background-color: #f8fafc;
        }

        .procedure-step-tab.active {
            background-color: #eff6ff;
            border-color: #bfdbfe;
            box-shadow: 0 1px 2px rgba(37, 99, 235, 0.08);
        }

        .procedure-step-tab.completed {
            background-color: #ffffff;
        }

        .procedure-step-tab .step-badge {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.78rem;
            font-weight: 700;
            background-color: #e2e8f0;
            color: #64748b;
            flex-shrink: 0;
            transition: all 0.2s ease;
        }

        .procedure-step-tab.active .step-badge {
            background-color: #2563eb;
            color: #ffffff;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
        }

        .procedure-step-tab.completed .step-badge {
            background-color: #10b981;
            color: #ffffff;
        }

        .procedure-step-tab .step-meta {
            display: flex;
            flex-direction: column;
            line-height: 1.2;
        }

        .procedure-step-tab .step-number {
            font-size: 0.68rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #94a3b8;
            margin-bottom: 0.15rem;
        }

        .procedure-step-tab.active .step-number {
            color: #2563eb;
        }

        .procedure-step-tab.completed .step-number {
            color: #059669;
        }

        .procedure-step-tab .step-name {
            font-size: 0.82rem;
            font-weight: 700;
            color: #334155;
            white-space: nowrap;
        }

        .procedure-step-tab.active .step-name {
            color: #1d4ed8;
        }

        .step-separator {
            color: #cbd5e1;
            display: flex;
            align-items: center;
            flex-shrink: 0;
            padding: 0 0.15rem;
        }

        /* Step Panels Visibility */
        .step-panel {
            display: none;
        }

        .step-panel.active-panel {
            display: block;
        }

        /* Step Footer Navigation */
        .step-nav-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid #e2e8f0;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        /* ─── Two-Column Layout ─── */
        .create-form-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 330px;
            gap: 1.5rem;
            align-items: flex-start;
        }

        /* ─── Card Design ─── */
        .form-section-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-subtle);
            overflow: hidden;
        }

        .card-header {
            padding: 1rem 1.25rem;
            background-color: #ffffff;
            border-bottom: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-title {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-heading);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-body {
            padding: 1.25rem;
        }

        /* ─── Form Fields ─── */
        .form-group {
            margin-bottom: 1.15rem;
        }

        .form-group:last-child {
            margin-bottom: 0;
        }

        .form-label {
            display: block;
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 0.35rem;
        }

        .form-label .required-mark {
            color: var(--accent-rose);
        }

        .form-input, .form-textarea, .form-select {
            width: 100%;
            padding: 0.55rem 0.85rem;
            border: 1px solid var(--border-subtle);
            border-radius: 6px;
            font-size: 0.84rem;
            font-family: var(--font-sans);
            color: var(--text-heading);
            background-color: #f8fafc;
            transition: all 0.15s ease;
        }

        .form-input:focus, .form-textarea:focus, .form-select:focus {
            outline: none;
            border-color: var(--border-focus);
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-textarea {
            resize: vertical;
            min-height: 90px;
        }

        .form-hint {
            font-size: 0.72rem;
            color: var(--text-muted);
            margin-top: 0.3rem;
            display: block;
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        /* Informational Callout */
        .info-callout {
            background-color: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 6px;
            padding: 0.75rem 1rem;
            font-size: 0.78rem;
            color: #1e40af;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
            line-height: 1.45;
        }

        .info-callout svg {
            flex-shrink: 0;
            margin-top: 0.1rem;
        }

        /* Multi-Sponsor Management */
        .sponsor-input-row {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 0.85rem;
        }

        .sponsor-chips-container {
            display: flex;
            flex-wrap: wrap;
            gap: 0.45rem;
            min-height: 38px;
            padding: 0.6rem;
            background-color: #f8fafc;
            border: 1px dashed var(--border-subtle);
            border-radius: 6px;
            align-items: center;
            margin-bottom: 1rem;
        }

        .sponsor-chip {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background-color: #ffffff;
            border: 1px solid #bfdbfe;
            color: #1e40af;
            font-size: 0.76rem;
            font-weight: 600;
            padding: 0.25rem 0.65rem;
            border-radius: 9999px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
        }

        .btn-remove-chip {
            background: none;
            border: none;
            color: #94a3b8;
            font-size: 1rem;
            line-height: 1;
            cursor: pointer;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color 0.15s ease;
        }

        .btn-remove-chip:hover {
            color: #ef4444;
        }

        .preset-sponsors-row {
            display: flex;
            flex-wrap: wrap;
            gap: 0.4rem;
        }

        .btn-preset-sponsor {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            font-size: 0.72rem;
            font-weight: 500;
            color: #475569;
            padding: 0.2rem 0.55rem;
            cursor: pointer;
            transition: all 0.15s ease;
            text-decoration: none;
        }

        .btn-preset-sponsor:hover {
            background-color: #eff6ff;
            border-color: #bfdbfe;
            color: #1d4ed8;
        }

        /* Step 4 Review Manifest Checklist */
        .review-checklist-card {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .review-checklist-title {
            font-size: 0.8rem;
            font-weight: 700;
            color: #334155;
            margin-bottom: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .checklist-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.78rem;
            color: #475569;
            padding: 0.25rem 0;
        }

        .checklist-item svg {
            color: #10b981;
            flex-shrink: 0;
        }

        /* ─── Preview Card ─── */
        .preview-summary-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            padding: 1.25rem;
            box-shadow: var(--shadow-subtle);
            position: sticky;
            top: calc(var(--topbar-height) + 1.5rem);
        }

        .preview-card-header {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .preview-badge-status {
            background-color: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
            font-size: 0.68rem;
            font-weight: 700;
            padding: 0.15rem 0.5rem;
            border-radius: 9999px;
            text-transform: uppercase;
        }

        .preview-event-box {
            background-color: #f8fafc;
            border: 1px solid var(--border-subtle);
            border-radius: 6px;
            padding: 1rem;
            margin-bottom: 1.25rem;
        }

        .preview-event-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 0.35rem;
            line-height: 1.3;
        }

        .preview-event-venue {
            font-size: 0.78rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 0.35rem;
            margin-bottom: 0.75rem;
        }

        .preview-meta-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.75rem;
            padding: 0.35rem 0;
            border-top: 1px solid #e2e8f0;
            color: var(--text-body);
        }

        .preview-meta-row span:first-child {
            color: var(--text-muted);
        }

        .preview-meta-row span:last-child {
            font-weight: 600;
            font-family: var(--font-mono), var(--font-sans);
        }

        /* ─── Feedback Alerts ─── */
        .feedback-alert {
            padding: 0.85rem 1.25rem;
            border-radius: 6px;
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

        @media (max-width: 1024px) {
            .create-form-layout {
                grid-template-columns: 1fr;
            }
            .preview-summary-card {
                position: static;
            }
        }

        @media (max-width: 640px) {
            .form-grid-2 {
                grid-template-columns: 1fr;
            }
            .procedure-step-tab {
                min-width: 130px;
                padding: 0.5rem;
            }
            .procedure-step-tab .step-number {
                display: none;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Active Step State Tracker -->
    <asp:HiddenField ID="hfActiveStep" runat="server" Value="1" />

    <!-- Breadcrumbs Global Trail -->
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
                <span>Publish New Event</span>
            </li>
        </ol>
    </nav>

    <!-- Page Workspace Header -->
    <div class="page-header-row">
        <div class="header-title-block">
            <h2>Publish New Campus Event</h2>
            <p>Complete the guided 4-step procedure to register specifications, schedules, audience criteria, and partner sponsors.</p>
        </div>
        <div class="header-actions">
            <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="btn-action-secondary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                <span>Back to Events Matrix</span>
            </a>
            <asp:Button ID="btnPublishTop" runat="server" Text="Publish Event" CssClass="btn-action-primary" OnClick="btnPublishEvent_Click" />
        </div>
    </div>

    <!-- Step-by-Step Procedure Breadcrumb Tabs -->
    <div class="procedure-stepper-container" role="tablist" aria-label="Event Creation Procedure Steps">
        <!-- Step 1 Tab -->
        <div class="procedure-step-tab active" id="tab-step-1" data-step="1" onclick="switchStep(1)" role="tab" aria-selected="true">
            <div class="step-badge">1</div>
            <div class="step-meta">
                <span class="step-number">Step 01</span>
                <span class="step-name">Core Information</span>
            </div>
        </div>

        <div class="step-separator">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="9 18 15 12 9 6"></polyline>
            </svg>
        </div>

        <!-- Step 2 Tab -->
        <div class="procedure-step-tab" id="tab-step-2" data-step="2" onclick="switchStep(2)" role="tab" aria-selected="false">
            <div class="step-badge">2</div>
            <div class="step-meta">
                <span class="step-number">Step 02</span>
                <span class="step-name">Schedule & Timeline</span>
            </div>
        </div>

        <div class="step-separator">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="9 18 15 12 9 6"></polyline>
            </svg>
        </div>

        <!-- Step 3 Tab -->
        <div class="procedure-step-tab" id="tab-step-3" data-step="3" onclick="switchStep(3)" role="tab" aria-selected="false">
            <div class="step-badge">3</div>
            <div class="step-meta">
                <span class="step-number">Step 03</span>
                <span class="step-name">Audience Targeting</span>
            </div>
        </div>

        <div class="step-separator">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="9 18 15 12 9 6"></polyline>
            </svg>
        </div>

        <!-- Step 4 Tab -->
        <div class="procedure-step-tab" id="tab-step-4" data-step="4" onclick="switchStep(4)" role="tab" aria-selected="false">
            <div class="step-badge">4</div>
            <div class="step-meta">
                <span class="step-number">Step 04</span>
                <span class="step-name">Sponsors & Review</span>
            </div>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="feedback-alert alert-success">
        <div>
            <asp:Literal ID="litSuccessMsg" runat="server" />
        </div>
        <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" style="color: #065f46; font-weight:700; text-decoration:underline;">View in Matrix &rarr;</a>
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="feedback-alert alert-error">
        <div>
            <asp:Literal ID="litErrorMsg" runat="server" />
        </div>
    </asp:Panel>

    <!-- Main Two-Column Layout -->
    <div class="create-form-layout">
        <!-- Left Column: Step Panels -->
        <div>
            <!-- STEP 1 PANEL: Core Event Information -->
            <div id="step-panel-1" class="step-panel active-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <span>Step 1: Core Event Specifications</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">1 of 4</span>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label" for="<%= txtTitle.ClientID %>">Event Title <span class="required-mark">*</span></label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-input" placeholder="e.g. Annual University Tech Symposium 2026" MaxLength="200" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                            <span class="form-hint">A clear, descriptive title visible across student portals and institutional calendars.</span>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="<%= txtDescription.ClientID %>">Description & Agenda</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" CssClass="form-textarea" placeholder="Detail the event objectives, keynote topics, speaker profiles, or student prerequisites..." />
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtVenueLocation.ClientID %>">Venue / Room Location <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtVenueLocation" runat="server" CssClass="form-input" placeholder="e.g. Central Auditorium, Hall A" MaxLength="200" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                <span class="form-hint">Physical room, auditorium, or laboratory venue.</span>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="<%= txtMaxCapacity.ClientID %>">Max Capacity (Seats) <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtMaxCapacity" runat="server" TextMode="Number" CssClass="form-input" Text="150" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                <span class="form-hint">Enforces strict atomic concurrency lock against overbooking.</span>
                            </div>
                        </div>

                        <!-- Step 1 Footer Navigation -->
                        <div class="step-nav-footer">
                            <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="btn-action-secondary">
                                Cancel & Discard
                            </a>
                            <button type="button" class="btn-action-primary" onclick="validateAndGoStep(2)">
                                <span>Next: Schedule & Timeline</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 2 PANEL: Schedule & Timeline -->
            <div id="step-panel-2" class="step-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <span>Step 2: Schedule & Registration Timeline</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">2 of 4</span>
                    </div>
                    <div class="card-body">
                        <div class="info-callout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span><strong>Policy Directive:</strong> Registration period must conclude before or at event kickoff. Cancellations are strictly locked after the registration deadline.</span>
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtEventStart.ClientID %>">Event Start Date & Time <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtEventStart" runat="server" TextMode="DateTimeLocal" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtEventEnd.ClientID %>">Event End Date & Time <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtEventEnd" runat="server" TextMode="DateTimeLocal" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                            </div>
                        </div>

                        <div class="form-grid-2" style="margin-top: 1rem;">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtRegStart.ClientID %>">Registration Open Date & Time <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtRegStart" runat="server" TextMode="DateTimeLocal" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtRegEnd.ClientID %>">Registration Deadline <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtRegEnd" runat="server" TextMode="DateTimeLocal" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                            </div>
                        </div>

                        <!-- Step 2 Footer Navigation -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(1)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                <span>Back: Core Details</span>
                            </button>
                            <button type="button" class="btn-action-primary" onclick="validateAndGoStep(3)">
                                <span>Next: Audience Targeting</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 3 PANEL: 4-Tier Audience Targeting -->
            <div id="step-panel-3" class="step-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            <span>Step 3: 4-Tier Academic Audience Targeting</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">3 of 4</span>
                    </div>
                    <div class="card-body">
                        <div class="info-callout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span>Leaving dimensions as <em>"All / Open to All"</em> grants access to the entire student body. Specific selections enforce cohort-based eligibility filtering.</span>
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= ddlBranch.ClientID %>">1. Campus Branch</label>
                                <asp:DropDownList ID="ddlBranch" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FormField_Changed">
                                    <asp:ListItem Value="" Text="All University Branches (Open)" />
                                    <asp:ListItem Value="San Bartolome" Text="San Bartolome (Main Campus)" />
                                    <asp:ListItem Value="Batasan" Text="Batasan Campus" />
                                    <asp:ListItem Value="San Francisco" Text="San Francisco Campus" />
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="<%= ddlDepartment.ClientID %>">2. Academic College / Department</label>
                                <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FormField_Changed">
                                    <asp:ListItem Value="" Text="All Colleges / Open to All" />
                                    <asp:ListItem Value="College of Computer Studies" Text="College of Computer Studies (CCS)" />
                                    <asp:ListItem Value="College of Engineering" Text="College of Engineering (COE)" />
                                    <asp:ListItem Value="College of Business & Acctg" Text="College of Business & Accountancy (CBA)" />
                                    <asp:ListItem Value="College of Arts & Sciences" Text="College of Arts & Sciences (CAS)" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="form-grid-2" style="margin-top: 1rem;">
                            <div class="form-group">
                                <label class="form-label" for="<%= ddlProgram.ClientID %>">3. Academic Program</label>
                                <asp:DropDownList ID="ddlProgram" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FormField_Changed">
                                    <asp:ListItem Value="" Text="All Academic Programs (Open)" />
                                    <asp:ListItem Value="BSIT" Text="BS Information Technology (BSIT)" />
                                    <asp:ListItem Value="BSCS" Text="BS Computer Science (BSCS)" />
                                    <asp:ListItem Value="BSIE" Text="BS Industrial Engineering (BSIE)" />
                                    <asp:ListItem Value="BSBA" Text="BS Business Administration (BSBA)" />
                                    <asp:ListItem Value="BSA" Text="BS Accountancy (BSA)" />
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="<%= ddlYearLevel.ClientID %>">4. Year Level</label>
                                <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FormField_Changed">
                                    <asp:ListItem Value="" Text="All Year Levels (1st - 4th)" />
                                    <asp:ListItem Value="1" Text="1st Year Students Only" />
                                    <asp:ListItem Value="2" Text="2nd Year Students Only" />
                                    <asp:ListItem Value="3" Text="3rd Year Students Only" />
                                    <asp:ListItem Value="4" Text="4th Year Graduating Seniors Only" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- Step 3 Footer Navigation -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(2)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                <span>Back: Schedule</span>
                            </button>
                            <button type="button" class="btn-action-primary" onclick="switchStep(4)">
                                <span>Next: Sponsors & Review</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 4 PANEL: Multi-Sponsor Association & Final Review -->
            <div id="step-panel-4" class="step-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                            </svg>
                            <span>Step 4: Multi-Sponsor Association & Final Review</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">4 of 4</span>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label">Attach Corporate & Institutional Partners</label>
                            <div class="sponsor-input-row">
                                <asp:TextBox ID="txtNewSponsor" runat="server" CssClass="form-input" placeholder="Enter sponsor or partner organization name..." />
                                <asp:Button ID="btnAddSponsor" runat="server" Text="Add Sponsor" CssClass="btn-action-secondary" OnClick="btnAddSponsor_Click" CausesValidation="false" />
                            </div>
                        </div>

                        <!-- Active Sponsor Chips Container -->
                        <div class="sponsor-chips-container">
                            <asp:Repeater ID="rptSponsors" runat="server" OnItemCommand="rptSponsors_ItemCommand">
                                <ItemTemplate>
                                    <span class="sponsor-chip">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                                        </svg>
                                        <span><%# Container.DataItem %></span>
                                        <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn-remove-chip" CommandName="Remove" CommandArgument='<%# Container.DataItem %>' CausesValidation="false" ToolTip="Remove Sponsor">&times;</asp:LinkButton>
                                    </span>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Literal ID="litNoSponsorsHint" runat="server" Text="<span style='color:#94a3b8; font-size:0.75rem; font-style:italic;'>No sponsors attached yet. Type above or click quick presets below.</span>" />
                        </div>

                        <!-- Quick Add Preset Suggestions -->
                        <div class="form-group">
                            <span class="form-label" style="font-size:0.72rem; color:var(--text-muted); text-transform:uppercase;">Quick Partner Presets</span>
                            <div class="preset-sponsors-row">
                                <asp:LinkButton ID="btnPreset1" runat="server" CssClass="btn-preset-sponsor" Text="+ QCU Alumni Association" OnClick="PresetSponsor_Click" CommandArgument="QCU Alumni Association" CausesValidation="false" />
                                <asp:LinkButton ID="btnPreset2" runat="server" CssClass="btn-preset-sponsor" Text="+ DOST-NCR" OnClick="PresetSponsor_Click" CommandArgument="DOST-NCR" CausesValidation="false" />
                                <asp:LinkButton ID="btnPreset3" runat="server" CssClass="btn-preset-sponsor" Text="+ AWS Educate" OnClick="PresetSponsor_Click" CommandArgument="AWS Educate" CausesValidation="false" />
                                <asp:LinkButton ID="btnPreset4" runat="server" CssClass="btn-preset-sponsor" Text="+ Google Developer Student Clubs" OnClick="PresetSponsor_Click" CommandArgument="Google Developer Student Clubs" CausesValidation="false" />
                                <asp:LinkButton ID="btnPreset5" runat="server" CssClass="btn-preset-sponsor" Text="+ Microsoft Learn" OnClick="PresetSponsor_Click" CommandArgument="Microsoft Learn" CausesValidation="false" />
                            </div>
                        </div>

                        <!-- Pre-Publication Checklist -->
                        <div class="review-checklist-card">
                            <div class="review-checklist-title">Pre-Publication Readiness Verification</div>
                            <div class="checklist-item">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Core specifications and seat capacity allocated</span>
                            </div>
                            <div class="checklist-item">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Registration deadline verified prior to event kickoff</span>
                            </div>
                            <div class="checklist-item">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>4-tier demographic eligibility filters mapped</span>
                            </div>
                            <div class="checklist-item">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Partner sponsorship branding verified for event header</span>
                            </div>
                        </div>

                        <!-- Step 4 Footer Navigation -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(3)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                <span>Back: Audience Targeting</span>
                            </button>
                            <asp:Button ID="btnPublishBottom" runat="server" Text="Publish Event to Matrix" CssClass="btn-action-primary" OnClick="btnPublishEvent_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column: Live Publishing Summary Card -->
        <div>
            <div class="preview-summary-card">
                <div class="preview-card-header">
                    <span>Live Event Card Preview</span>
                    <span class="preview-badge-status">Upcoming</span>
                </div>

                <div class="preview-event-box">
                    <div class="preview-event-title">
                        <asp:Literal ID="litPreviewTitle" runat="server" Text="Event Title Preview" />
                    </div>
                    <div class="preview-event-venue">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                        </svg>
                        <span><asp:Literal ID="litPreviewVenue" runat="server" Text="Central Auditorium, Hall A" /></span>
                    </div>

                    <div class="preview-meta-row" onclick="switchStep(1)" style="cursor:pointer;" title="Click to edit Core Information">
                        <span>Max Capacity</span>
                        <span><asp:Literal ID="litPreviewCapacity" runat="server" Text="150 seats" /></span>
                    </div>
                    <div class="preview-meta-row" onclick="switchStep(3)" style="cursor:pointer;" title="Click to edit Audience Targeting">
                        <span>Target Branch</span>
                        <span><asp:Literal ID="litPreviewBranch" runat="server" Text="All Branches" /></span>
                    </div>
                    <div class="preview-meta-row" onclick="switchStep(3)" style="cursor:pointer;" title="Click to edit Audience Targeting">
                        <span>Target College</span>
                        <span><asp:Literal ID="litPreviewDept" runat="server" Text="All Colleges" /></span>
                    </div>
                    <div class="preview-meta-row" onclick="switchStep(4)" style="cursor:pointer;" title="Click to edit Sponsors">
                        <span>Attached Sponsors</span>
                        <span><asp:Literal ID="litPreviewSponsorCount" runat="server" Text="0 Partners" /></span>
                    </div>
                </div>

                <div style="display:flex; flex-direction:column; gap:0.65rem;">
                    <asp:Button ID="btnPublishCard" runat="server" Text="Publish Event to Matrix" CssClass="btn-action-primary" Style="width:100%; justify-content:center;" OnClick="btnPublishEvent_Click" />
                    <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="btn-action-secondary" style="width:100%; justify-content:center;">
                        Cancel & Discard
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Stepper Tab Controller Script -->
    <script type="text/javascript">
        function switchStep(stepNumber) {
            stepNumber = parseInt(stepNumber);
            if (isNaN(stepNumber) || stepNumber < 1 || stepNumber > 4) stepNumber = 1;

            // 1. Update Step Panels
            for (var i = 1; i <= 4; i++) {
                var panel = document.getElementById('step-panel-' + i);
                if (panel) {
                    if (i === stepNumber) {
                        panel.classList.add('active-panel');
                    } else {
                        panel.classList.remove('active-panel');
                    }
                }
            }

            // 2. Update Breadcrumb Tabs
            for (var s = 1; s <= 4; s++) {
                var tab = document.getElementById('tab-step-' + s);
                if (tab) {
                    tab.classList.remove('active', 'completed');
                    if (s === stepNumber) {
                        tab.classList.add('active');
                        tab.setAttribute('aria-selected', 'true');
                    } else if (s < stepNumber) {
                        tab.classList.add('completed');
                        tab.setAttribute('aria-selected', 'false');
                    } else {
                        tab.setAttribute('aria-selected', 'false');
                    }
                }
            }

            // 3. Persist active step in hidden field for postbacks
            var hf = document.getElementById('<%= hfActiveStep.ClientID %>');
            if (hf) {
                hf.value = stepNumber;
            }
        }

        function validateAndGoStep(targetStep) {
            if (targetStep === 2) {
                var title = document.getElementById('<%= txtTitle.ClientID %>');
                var venue = document.getElementById('<%= txtVenueLocation.ClientID %>');
                var cap = document.getElementById('<%= txtMaxCapacity.ClientID %>');

                if (title && !title.value.trim()) {
                    alert('Please enter the Event Title before proceeding.');
                    title.focus();
                    return;
                }
                if (venue && !venue.value.trim()) {
                    alert('Please specify the Venue / Room Location.');
                    venue.focus();
                    return;
                }
                if (cap && (!cap.value.trim() || parseInt(cap.value) <= 0)) {
                    alert('Please enter a valid seat capacity.');
                    cap.focus();
                    return;
                }
            }
            switchStep(targetStep);
        }

        // Initialize state on page load
        document.addEventListener('DOMContentLoaded', function () {
            var hf = document.getElementById('<%= hfActiveStep.ClientID %>');
            var initialStep = (hf && hf.value) ? parseInt(hf.value) : 1;
            switchStep(initialStep);
        });

        // Re-apply step state after partial or full postback
        if (typeof (Sys) !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                var hf = document.getElementById('<%= hfActiveStep.ClientID %>');
                var initialStep = (hf && hf.value) ? parseInt(hf.value) : 1;
                switchStep(initialStep);
            });
        }
    </script>
</asp:Content>
