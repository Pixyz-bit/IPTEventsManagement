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
            min-width: 140px;
            display: flex;
            align-items: center;
            gap: 0.65rem;
            padding: 0.65rem 0.75rem;
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
            grid-template-columns: minmax(0, 1fr) 350px;
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
            text-decoration: none !important;
        }

        .btn-remove-chip:hover,
        .btn-remove-chip:focus {
            color: #ef4444;
            text-decoration: none !important;
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

        /* ─── Preview Ticket Pass Card (Mockup Format) ─── */
        .preview-summary-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            padding: 1.15rem;
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

        .ticket-pass-card {
            background-color: #18181b;
            border: 1px dashed #3f3f46;
            border-radius: 10px;
            color: #e4e4e7;
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
            overflow: hidden;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.2);
            margin-bottom: 1.15rem;
        }

        .ticket-header-section {
            padding: 0.9rem;
            border-bottom: 1px dashed #3f3f46;
        }

        .ticket-promo-image-box {
            background: #27272a;
            border: 1px dashed #52525b;
            border-radius: 6px;
            height: 95px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #a1a1aa;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.04em;
            margin-bottom: 0.75rem;
        }

        .ticket-event-title {
            font-size: 1rem;
            font-weight: 700;
            color: #ffffff;
            line-height: 1.35;
            font-family: var(--font-sans), system-ui, -apple-system, sans-serif;
            word-break: break-word;
        }

        .ticket-section {
            padding: 0.8rem 0.9rem;
            border-bottom: 1px dashed #3f3f46;
        }

        .ticket-section-label {
            font-size: 0.68rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: #a1a1aa;
            margin-bottom: 0.5rem;
        }

        .ticket-kv-grid {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
        }

        .ticket-kv-row {
            display: flex;
            font-size: 0.74rem;
            line-height: 1.35;
        }

        .ticket-kv-key {
            width: 76px;
            flex-shrink: 0;
            color: #a1a1aa;
        }

        .ticket-kv-val {
            flex: 1;
            color: #fafafa;
            font-weight: 500;
            word-break: break-word;
        }

        .ticket-status-badge {
            display: inline-block;
            color: #34d399;
            font-weight: 700;
            font-size: 0.72rem;
            letter-spacing: 0.05em;
        }

        .ticket-qr-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1.1rem 0.9rem;
            text-align: center;
        }

        .ticket-qr-frame {
            padding: 6px;
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.35);
            margin-bottom: 0.65rem;
            display: inline-block;
        }

        .ticket-qr-instruction {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.06em;
            color: #e4e4e7;
            margin-bottom: 0.2rem;
        }

        .ticket-qr-ref {
            font-size: 0.68rem;
            color: #a1a1aa;
            letter-spacing: 0.04em;
        }

        .ticket-footer-section {
            padding: 0.75rem 0.9rem;
            font-size: 0.71rem;
            color: #a1a1aa;
            line-height: 1.5;
            background: #18181b;
        }

        .ticket-bullet-item {
            margin-bottom: 0.15rem;
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

        /* Course Picker Grid & Micro Buttons */
        .course-picker-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
            gap: 0.65rem;
            margin-top: 0.5rem;
        }

        .course-picker-card {
            display: flex;
            align-items: flex-start;
            gap: 0.65rem;
            padding: 0.75rem 0.85rem;
            background-color: #f8fafc;
            border: 1px solid var(--border-subtle);
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.15s ease;
            user-select: none;
        }

        .course-picker-card:hover {
            background-color: #eff6ff;
            border-color: #bfdbfe;
        }

        .course-picker-card.selected {
            background-color: #eff6ff;
            border-color: #2563eb;
            box-shadow: 0 0 0 1px #2563eb;
        }

        .course-picker-card input[type="checkbox"] {
            margin-top: 0.2rem;
            width: 16px;
            height: 16px;
            accent-color: var(--brand-primary);
            cursor: pointer;
            flex-shrink: 0;
        }

        .course-picker-info {
            display: flex;
            flex-direction: column;
        }

        .course-code {
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--text-heading);
        }

        .course-name {
            font-size: 0.72rem;
            color: var(--text-muted);
            line-height: 1.3;
        }

        .btn-micro {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            color: var(--text-heading);
            padding: 0.25rem 0.65rem;
            font-size: 0.72rem;
            font-weight: 600;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .btn-micro:hover {
            background-color: #f1f5f9;
            border-color: #cbd5e1;
            color: var(--brand-primary);
        }

        /* Step 5 Summary Review Card Styles */
        .summary-container {
            display: flex;
            flex-direction: column;
            gap: 1.15rem;
        }

        .summary-section-box {
            background-color: #f8fafc;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            padding: 1.15rem;
        }

        .summary-section-title {
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--text-heading);
            margin-bottom: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 0.85rem 1.25rem;
        }

        .summary-item {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .summary-item.full-width {
            grid-column: 1 / -1;
        }

        .summary-label {
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.02em;
        }

        .summary-value {
            font-size: 0.88rem;
            font-weight: 600;
            color: var(--text-heading);
            word-break: break-word;
        }

        .summary-value.highlight {
            color: var(--brand-primary);
            font-family: var(--font-mono), var(--font-sans);
        }

        /* Schedule & Timeline 2-Column Split */
        .summary-schedule-split {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            align-items: stretch;
        }

        .summary-schedule-left {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .summary-schedule-right {
            display: flex;
            flex-direction: column;
            gap: 0.45rem;
        }

        .reg-window-card {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.85rem 1rem;
            display: flex;
            flex-direction: column;
            gap: 0.65rem;
            height: 100%;
            justify-content: center;
        }

        .reg-window-row {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .reg-window-tag {
            font-size: 0.68rem;
            font-weight: 700;
            padding: 0.2rem 0.55rem;
            border-radius: 4px;
            letter-spacing: 0.05em;
            min-width: 65px;
            text-align: center;
        }

        .reg-window-tag.opens {
            background-color: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
        }

        .reg-window-tag.deadline {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .reg-window-val {
            font-size: 0.86rem;
            font-weight: 600;
            color: #1e293b;
            font-family: var(--font-mono), monospace;
        }

        .summary-chips-wrap {
            display: flex;
            flex-wrap: wrap;
            gap: 0.4rem;
            margin-top: 0.2rem;
        }

        .summary-chip-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            background-color: #ffffff;
            border: 1px solid #bfdbfe;
            color: #1e40af;
            font-size: 0.74rem;
            font-weight: 600;
            padding: 0.2rem 0.6rem;
            border-radius: 9999px;
        }

        .summary-confirm-callout {
            background-color: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 8px;
            padding: 1rem 1.15rem;
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            margin-top: 0.5rem;
        }

        .summary-confirm-callout svg {
            color: #16a34a;
            flex-shrink: 0;
            margin-top: 0.15rem;
        }

        .summary-confirm-text h4 {
            font-size: 0.86rem;
            font-weight: 700;
            color: #166534;
            margin-bottom: 0.2rem;
        }

        .summary-confirm-text p {
            font-size: 0.76rem;
            color: #15803d;
            line-height: 1.4;
            margin: 0;
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
                min-width: 110px;
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
            <!--<p>Complete the guided 4-step procedure to register specifications, schedules, audience criteria, and partner sponsors.</p>-->
        </div>
        <!--<div class="header-actions">
            <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="btn-action-secondary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                <span>Back to Events Matrix</span>
            </a>
            <asp:Button ID="btnPublishTop" runat="server" Text="Publish Event" CssClass="btn-action-primary" OnClick="btnPublishEvent_Click" />
        </div>-->
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
                <span class="step-name">Sponsors</span>
            </div>
        </div>

        <div class="step-separator">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="9 18 15 12 9 6"></polyline>
            </svg>
        </div>

        <!-- Step 5 Tab -->
        <div class="procedure-step-tab" id="tab-step-5" data-step="5" onclick="switchStep(5)" role="tab" aria-selected="false">
            <div class="step-badge">5</div>
            <div class="step-meta">
                <span class="step-number">Step 05</span>
                <span class="step-name">Summary & Confirm</span>
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
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">1 of 5</span>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label" for="<%= txtTitle.ClientID %>">Event Title <span class="required-mark">*</span></label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-input" placeholder="e.g. Annual University Tech Symposium 2026" MaxLength="200" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                        <!--<span class="form-hint">A clear, descriptive title visible across student portals and institutional calendars.</span>-->
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="<%= txtDescription.ClientID %>">Event Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" CssClass="form-textarea" placeholder="Detail the event objectives, keynote topics, speaker profiles, or student prerequisites..." />
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtVenueLocation.ClientID %>">Venue Location <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtVenueLocation" runat="server" CssClass="form-input" placeholder="e.g. Central Auditorium, Hall A" MaxLength="200" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                            <!--<span class="form-hint">Physical room, auditorium, or laboratory venue.</span>-->
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="<%= txtMaxCapacity.ClientID %>">Max Capacity (Seats) <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtMaxCapacity" runat="server" TextMode="Number" CssClass="form-input" Text="150" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                <!--<span class="form-hint">Enforces strict atomic concurrency lock against overbooking.</span>-->
                            </div>
                        </div>

                        <div class="form-group" style="margin-top: 0.5rem;">
                            <label class="form-label" for="<%= fuEventPhoto.ClientID %>">Event Promotional Banner / Poster Image</label>
                            <asp:FileUpload ID="fuEventPhoto" runat="server" CssClass="form-input" accept="image/*" />
                            <span class="form-hint" style="font-size:0.75rem; color:var(--text-muted); margin-top:0.25rem; display:block;">Optional. Supported formats: PNG, JPG, JPEG, WEBP. Uploaded asset is stored persistently in the dedicated assets folder.</span>
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
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">2 of 5</span>
                    </div>
                    <div class="card-body">
                        <div class="info-callout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span><strong>Policy Directive:</strong> Events take place on a designated calendar date. Registration period must conclude before or at event kickoff.</span>
                        </div>

                        <!-- Single Event Date Picker -->
                        <div class="form-group">
                            <label class="form-label" for="<%= txtEventDate.ClientID %>">Event Date <span class="required-mark">*</span></label>
                            <asp:TextBox ID="txtEventDate" runat="server" TextMode="Date" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                            <span class="form-hint">The single designated calendar date on which the event takes place.</span>
                        </div>

                        <!-- Start and End Time Pickers -->
                        <div class="form-grid-2" style="margin-top: 1rem;">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtEventStartTime.ClientID %>">Event Start Time <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtEventStartTime" runat="server" TextMode="Time" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                <span class="form-hint">Kickoff time (e.g. 09:00)</span>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtEventEndTime.ClientID %>">Event End Time <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtEventEndTime" runat="server" TextMode="Time" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                <span class="form-hint">Conclusion time (e.g. 17:00)</span>
                            </div>
                        </div>

                        <!-- Registration Availability Window -->
                        <div style="margin-top: 1.25rem; padding-top: 1.15rem; border-top: 1px dashed var(--border-subtle);">
                            <label class="form-label" style="font-size:0.8rem; color:var(--brand-primary); margin-bottom:0.75rem;">
                                Registration Availability Window
                            </label>
                            <div class="form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtRegStart.ClientID %>">Registration Open Date & Time <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtRegStart" runat="server" TextMode="DateTimeLocal" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtRegEnd.ClientID %>">Registration Deadline <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtRegEnd" runat="server" TextMode="DateTimeLocal" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                </div>
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
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">3 of 5</span>
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

                        <!-- Multi-Select Academic Degree Programs / Courses -->
                        <div class="form-group" style="margin-top: 1.25rem;">
                            <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:0.4rem; flex-wrap:wrap; gap:0.5rem;">
                                <label class="form-label" style="margin-bottom:0;">
                                    3. Academic Degree Programs / Courses (Multi-Select)
                                </label>
                                <div style="display:flex; gap:0.4rem;">
                                    <button type="button" class="btn-micro" onclick="selectAllPrograms(true)">Select All</button>
                                    <button type="button" class="btn-micro" onclick="selectAllPrograms(false)">Clear (Open to All)</button>
                                </div>
                            </div>
                            <span class="form-hint" style="margin-bottom:0.6rem;">Leave all unchecked to keep open to all programs. Select one or more specific courses (e.g. BSIT and BSCS) to restrict eligibility.</span>
                            
                            <div class="course-picker-grid">
                                <label class="course-picker-card" id="card_BSIT">
                                    <input type="checkbox" name="courseFilter" value="BSIT" id="chk_BSIT" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSIT</span>
                                        <span class="course-name">BS Information Technology</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSCS">
                                    <input type="checkbox" name="courseFilter" value="BSCS" id="chk_BSCS" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSCS</span>
                                        <span class="course-name">BS Computer Science</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSIE">
                                    <input type="checkbox" name="courseFilter" value="BSIE" id="chk_BSIE" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSIE</span>
                                        <span class="course-name">BS Industrial Engineering</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSBA">
                                    <input type="checkbox" name="courseFilter" value="BSBA" id="chk_BSBA" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSBA</span>
                                        <span class="course-name">BS Business Administration</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSA">
                                    <input type="checkbox" name="courseFilter" value="BSA" id="chk_BSA" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSA</span>
                                        <span class="course-name">BS Accountancy</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSEd">
                                    <input type="checkbox" name="courseFilter" value="BSEd" id="chk_BSEd" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSEd</span>
                                        <span class="course-name">BS Secondary Education</span>
                                    </div>
                                </label>
                            </div>
                            <asp:HiddenField ID="hfSelectedPrograms" runat="server" Value="" />
                        </div>

                        <!-- Year Level Selection -->
                        <div class="form-group" style="margin-top: 1.25rem;">
                            <label class="form-label" for="<%= ddlYearLevel.ClientID %>">4. Year Level Eligibility</label>
                            <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FormField_Changed" style="max-width:320px;">
                                <asp:ListItem Value="" Text="All Year Levels (1st - 4th)" />
                                <asp:ListItem Value="1" Text="1st Year Students Only" />
                                <asp:ListItem Value="2" Text="2nd Year Students Only" />
                                <asp:ListItem Value="3" Text="3rd Year Students Only" />
                                <asp:ListItem Value="4" Text="4th Year Graduating Seniors Only" />
                            </asp:DropDownList>
                        </div>

                        <!-- Step 3 Footer Navigation -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(2)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                <span>Back: Schedule</span>
                            </button>
                            <button type="button" class="btn-action-primary" onclick="validateAndGoStep(4)">
                                <span>Next: Sponsors</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 4 PANEL: Multi-Sponsor Associations -->
            <div id="step-panel-4" class="step-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                            </svg>
                            <span>Step 4: Multi-Sponsor Associations</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">4 of 5</span>
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
                                <span>Event single date, start time, and end time verified</span>
                            </div>
                            <div class="checklist-item">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Audience demographic and multi-course eligibility mapped</span>
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
                            <button type="button" class="btn-action-primary" onclick="validateAndGoStep(5)">
                                <span>Next: Summary & Confirmation</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 5 PANEL: Summary & Final Confirmation -->
            <div id="step-panel-5" class="step-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M9 11l3 3L22 4"></path>
                                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                            </svg>
                            <span>Step 5: Event Specifications Summary & Confirmation</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">5 of 5</span>
                    </div>
                    <div class="card-body">
                        <div class="info-callout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span>Please review all event specifications below carefully before publishing. Clicking <strong>Confirm &amp; Publish Event</strong> will register this event into the database and make it live in the matrix.</span>
                        </div>

                        <!-- Summary Review Container -->
                        <div class="summary-container">
                            <!-- 1. Core Specifications Summary -->
                            <div class="summary-section-box">
                                <div class="summary-section-title">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                    <span>Core Specifications</span>
                                </div>
                                <div class="summary-grid">
                                    <div class="summary-item full-width">
                                        <span class="summary-label">Event Title</span>
                                        <span id="sumTitle" class="summary-value" style="font-size:1.05rem; font-weight:800; color:var(--brand-primary);">-</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Venue Location</span>
                                        <span id="sumVenue" class="summary-value">-</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Max Seat Capacity</span>
                                        <span id="sumCapacity" class="summary-value highlight">-</span>
                                    </div>
                                    <div class="summary-item full-width">
                                        <span class="summary-label">Event Description</span>
                                        <div id="sumDesc" class="summary-value" style="font-size:0.8rem; font-weight:400; color:var(--text-body); white-space:pre-wrap;">-</div>
                                    </div>
                                </div>
                            </div>

                            <!-- 2. Schedule & Timeline Summary -->
                            <div class="summary-section-box">
                                <div class="summary-section-title">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                    <span>Event Schedule &amp; Timeline</span>
                                </div>
                                <div class="summary-schedule-split">
                                    <!-- Left side: Date at top, Time below -->
                                    <div class="summary-schedule-left">
                                        <div class="summary-item">
                                            <span class="summary-label">Designated Event Date</span>
                                            <span id="sumEventDate" class="summary-value highlight">-</span>
                                        </div>
                                        <div class="summary-item">
                                            <span class="summary-label">Event Time Window</span>
                                            <span id="sumEventHours" class="summary-value highlight">-</span>
                                        </div>
                                    </div>
                                    <!-- Right side: Registration Availability Window -->
                                    <div class="summary-schedule-right">
                                        <span class="summary-label">Registration Availability Window</span>
                                        <div class="reg-window-card">
                                            <div class="reg-window-row">
                                                <span class="reg-window-tag opens">OPENS</span>
                                                <span id="sumRegOpen" class="reg-window-val">-</span>
                                            </div>
                                            <div class="reg-window-row">
                                                <span class="reg-window-tag deadline">DEADLINE</span>
                                                <span id="sumRegDeadline" class="reg-window-val">-</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 3. Demographic Targeting Summary -->
                            <div class="summary-section-box">
                                <div class="summary-section-title">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                    <span>Audience Eligibility Targeting</span>
                                </div>
                                <div class="summary-grid">
                                    <div class="summary-item">
                                        <span class="summary-label">Campus Branch</span>
                                        <span id="sumBranch" class="summary-value">-</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Academic College</span>
                                        <span id="sumDept" class="summary-value">-</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Year Level</span>
                                        <span id="sumYearLevel" class="summary-value">-</span>
                                    </div>
                                    <div class="summary-item full-width">
                                        <span class="summary-label">Target Degree Programs / Courses</span>
                                        <div id="sumPrograms" class="summary-chips-wrap"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- 4. Sponsor Associations Summary -->
                            <div class="summary-section-box">
                                <div class="summary-section-title">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path></svg>
                                    <span>Partner &amp; Sponsor Associations</span>
                                </div>
                                <div id="sumSponsors" class="summary-chips-wrap"></div>
                            </div>

                            <!-- Policy Confirmation Callout -->
                            <div class="summary-confirm-callout">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                <div class="summary-confirm-text">
                                    <h4>Final Confirmation Required</h4>
                                    <p>By publishing, you confirm that all specifications, reservation limits, and eligibility cohorts comply with university event policies.</p>
                                </div>
                            </div>
                        </div>

                        <!-- Step 5 Footer Navigation -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(4)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                <span>Back: Sponsors</span>
                            </button>
                            <asp:Button ID="btnConfirmPublish" runat="server" Text="Confirm & Publish Event" CssClass="btn-action-primary" OnClick="btnPublishEvent_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Stepper Tab Controller Script -->
    <script type="text/javascript">
        function switchStep(stepNumber) {
            stepNumber = parseInt(stepNumber);
            if (isNaN(stepNumber) || stepNumber < 1 || stepNumber > 5) stepNumber = 1;

            // 1. Update Step Panels
            for (var i = 1; i <= 5; i++) {
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
            for (var s = 1; s <= 5; s++) {
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

            // 4. If switching to Step 5, populate all summary fields
            if (stepNumber === 5) {
                populateSummary();
            }
        }

        function validateAndGoStep(targetStep) {
            // Validate Step 1 if moving forward past Step 1
            if (targetStep > 1) {
                var title = document.getElementById('<%= txtTitle.ClientID %>');
                var venue = document.getElementById('<%= txtVenueLocation.ClientID %>');
                var cap = document.getElementById('<%= txtMaxCapacity.ClientID %>');

                if (title && !title.value.trim()) {
                    alert('Please enter the Event Title before proceeding.');
                    switchStep(1);
                    title.focus();
                    return;
                }
                if (venue && !venue.value.trim()) {
                    alert('Please specify the Venue / Room Location.');
                    switchStep(1);
                    venue.focus();
                    return;
                }
                if (cap && (!cap.value.trim() || parseInt(cap.value) <= 0)) {
                    alert('Please enter a valid seat capacity greater than 0.');
                    switchStep(1);
                    cap.focus();
                    return;
                }
            }

            // Validate Step 2 if moving forward past Step 2
            if (targetStep > 2) {
                var evDate = document.getElementById('<%= txtEventDate.ClientID %>');
                var startTime = document.getElementById('<%= txtEventStartTime.ClientID %>');
                var endTime = document.getElementById('<%= txtEventEndTime.ClientID %>');
                var regStart = document.getElementById('<%= txtRegStart.ClientID %>');
                var regEnd = document.getElementById('<%= txtRegEnd.ClientID %>');

                if (evDate && !evDate.value) {
                    alert('Please select the Event Date.');
                    switchStep(2);
                    evDate.focus();
                    return;
                }
                if (startTime && !startTime.value) {
                    alert('Please specify the Event Start Time.');
                    switchStep(2);
                    startTime.focus();
                    return;
                }
                if (endTime && !endTime.value) {
                    alert('Please specify the Event End Time.');
                    switchStep(2);
                    endTime.focus();
                    return;
                }
                if (startTime && endTime && startTime.value >= endTime.value) {
                    alert('Event Start Time must be earlier than Event End Time.');
                    switchStep(2);
                    startTime.focus();
                    return;
                }
                if (regStart && !regStart.value) {
                    alert('Please specify the Registration Opening Date & Time.');
                    switchStep(2);
                    regStart.focus();
                    return;
                }
                if (regEnd && !regEnd.value) {
                    alert('Please specify the Registration Deadline.');
                    switchStep(2);
                    regEnd.focus();
                    return;
                }
                if (regStart && regEnd && new Date(regStart.value) >= new Date(regEnd.value)) {
                    alert('Registration Open Date & Time must be earlier than Registration Deadline.');
                    switchStep(2);
                    regStart.focus();
                    return;
                }
                if (regEnd && evDate && startTime) {
                    var kickoff = new Date(evDate.value + 'T' + startTime.value);
                    var deadline = new Date(regEnd.value);
                    if (deadline > kickoff) {
                        alert('Registration Deadline must conclude before or at the Event Kickoff time.');
                        switchStep(2);
                        regEnd.focus();
                        return;
                    }
                }
            }

            switchStep(targetStep);
        }

        // ─── Multi-Course Selection Helpers ───
        function onCourseSelectionChanged() {
            var checkboxes = document.querySelectorAll('input[name="courseFilter"]');
            var selected = [];
            checkboxes.forEach(function (cb) {
                var card = document.getElementById('card_' + cb.value);
                if (cb.checked) {
                    selected.push(cb.value);
                    if (card) card.classList.add('selected');
                } else {
                    if (card) card.classList.remove('selected');
                }
            });

            var hf = document.getElementById('<%= hfSelectedPrograms.ClientID %>');
            if (hf) {
                hf.value = selected.join(', ');
            }
        }

        function selectAllPrograms(selectAll) {
            var checkboxes = document.querySelectorAll('input[name="courseFilter"]');
            checkboxes.forEach(function (cb) {
                cb.checked = selectAll;
            });
            onCourseSelectionChanged();
        }

        function restoreCourseSelection() {
            var hf = document.getElementById('<%= hfSelectedPrograms.ClientID %>');
            if (hf && hf.value) {
                var selected = hf.value.split(',').map(function (s) { return s.trim(); });
                var checkboxes = document.querySelectorAll('input[name="courseFilter"]');
                checkboxes.forEach(function (cb) {
                    var match = selected.indexOf(cb.value) !== -1;
                    cb.checked = match;
                    var card = document.getElementById('card_' + cb.value);
                    if (card) {
                        if (match) card.classList.add('selected');
                        else card.classList.remove('selected');
                    }
                });
            }
        }

        // ─── Step 5 Live Summary Generation ───
        function formatDateTimePretty(isoStr) {
            if (!isoStr) return '-';
            var d = new Date(isoStr);
            if (isNaN(d.getTime())) return isoStr;
            var mm = ('0' + (d.getMonth() + 1)).slice(-2);
            var dd = ('0' + d.getDate()).slice(-2);
            var yyyy = d.getFullYear();
            var time = d.toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });
            return mm + '/' + dd + '/' + yyyy + ' ' + time;
        }

        function formatDateOnlyPretty(dateStr) {
            if (!dateStr) return '-';
            var parts = dateStr.split('-');
            if (parts.length === 3) {
                var mm = ('0' + parts[1]).slice(-2);
                var dd = ('0' + parts[2]).slice(-2);
                var yyyy = parts[0];
                return mm + '/' + dd + '/' + yyyy;
            }
            return dateStr;
        }

        function formatTime12h(timeStr) {
            if (!timeStr) return '';
            var parts = timeStr.split(':');
            if (parts.length >= 2) {
                var h = parseInt(parts[0]);
                var m = parts[1];
                var ampm = h >= 12 ? 'PM' : 'AM';
                h = h % 12;
                if (h === 0) h = 12;
                return (h < 10 ? '0' + h : h) + ':' + m + ' ' + ampm;
            }
            return timeStr;
        }

        function calculateGatesOpenTime(timeStr) {
            if (!timeStr) return '08:15 AM';
            var parts = timeStr.split(':');
            if (parts.length >= 2) {
                var h = parseInt(parts[0], 10);
                var m = parseInt(parts[1], 10);
                var totalMin = (h * 60 + m) - 45;
                if (totalMin < 0) totalMin += 24 * 60;
                var gh = Math.floor(totalMin / 60);
                var gm = totalMin % 60;
                var gAmpm = gh >= 12 ? 'PM' : 'AM';
                gh = gh % 12;
                if (gh === 0) gh = 12;
                return (gh < 10 ? '0' + gh : gh) + ':' + (gm < 10 ? '0' + gm : gm) + ' ' + gAmpm;
            }
            return '08:15 AM';
        }

        function updateTicketPreview() {
            var title = document.getElementById('<%= txtTitle.ClientID %>');
            var venue = document.getElementById('<%= txtVenueLocation.ClientID %>');
            var evDate = document.getElementById('<%= txtEventDate.ClientID %>');
            var startTime = document.getElementById('<%= txtEventStartTime.ClientID %>');
            var endTime = document.getElementById('<%= txtEventEndTime.ClientID %>');
            var hfProg = document.getElementById('<%= hfSelectedPrograms.ClientID %>');

            var ticketTitle = document.getElementById('ticketEventTitle');
            var ticketDate = document.getElementById('ticketEventDate');
            var ticketTime = document.getElementById('ticketEventTime');
            var ticketVenue = document.getElementById('ticketEventVenue');
            var ticketProgram = document.getElementById('ticketAttendeeProgram');

            if (ticketTitle) {
                ticketTitle.innerText = (title && title.value.trim()) ? title.value.trim() : 'Event Title Preview';
            }
            if (ticketVenue) {
                ticketVenue.innerText = (venue && venue.value.trim()) ? venue.value.trim() : 'University Grand Auditorium';
            }
            if (ticketDate) {
                ticketDate.innerText = (evDate && evDate.value) ? formatDateOnlyPretty(evDate.value) : '10/28/2026';
            }
            if (ticketTime) {
                var sTime = (startTime && startTime.value) ? formatTime12h(startTime.value) : '09:00 AM';
                var eTime = (endTime && endTime.value) ? formatTime12h(endTime.value) : '04:00 PM';
                var gates = (startTime && startTime.value) ? calculateGatesOpenTime(startTime.value) : '08:15 AM';
                ticketTime.innerText = sTime + ' - ' + eTime + ' (Gates Open: ' + gates + ')';
            }
            if (ticketProgram) {
                var prog = (hfProg && hfProg.value.trim()) ? hfProg.value.trim() : 'BS Information Technology (SBIT3C)';
                ticketProgram.innerText = prog;
            }
        }

        function populateSummary() {
            // Core Specs
            var title = document.getElementById('<%= txtTitle.ClientID %>');
            var venue = document.getElementById('<%= txtVenueLocation.ClientID %>');
            var cap = document.getElementById('<%= txtMaxCapacity.ClientID %>');
            var desc = document.getElementById('<%= txtDescription.ClientID %>');

            var sumTitle = document.getElementById('sumTitle');
            var sumVenue = document.getElementById('sumVenue');
            var sumCapacity = document.getElementById('sumCapacity');
            var sumDesc = document.getElementById('sumDesc');

            if (sumTitle) sumTitle.innerText = (title && title.value.trim()) ? title.value.trim() : 'Untitled Event';
            if (sumVenue) sumVenue.innerText = (venue && venue.value.trim()) ? venue.value.trim() : 'Location TBD';
            if (sumCapacity) sumCapacity.innerText = (cap && cap.value) ? (cap.value + ' Seats allocated') : '150 Seats allocated';
            if (sumDesc) sumDesc.innerText = (desc && desc.value.trim()) ? desc.value.trim() : '(No description provided)';

            // Schedule & Timeline
            var evDate = document.getElementById('<%= txtEventDate.ClientID %>');
            var startTime = document.getElementById('<%= txtEventStartTime.ClientID %>');
            var endTime = document.getElementById('<%= txtEventEndTime.ClientID %>');
            var regStart = document.getElementById('<%= txtRegStart.ClientID %>');
            var regEnd = document.getElementById('<%= txtRegEnd.ClientID %>');

            var sumEventDate = document.getElementById('sumEventDate');
            var sumEventHours = document.getElementById('sumEventHours');
            var sumRegOpen = document.getElementById('sumRegOpen');
            var sumRegDeadline = document.getElementById('sumRegDeadline');

            if (sumEventDate) {
                sumEventDate.innerText = (evDate && evDate.value) ? formatDateOnlyPretty(evDate.value) : '-';
            }
            if (sumEventHours) {
                var sFormatted = startTime ? formatTime12h(startTime.value) : '';
                var eFormatted = endTime ? formatTime12h(endTime.value) : '';
                sumEventHours.innerText = (sFormatted && eFormatted) ? (sFormatted + ' — ' + eFormatted) : '-';
            }
            if (sumRegOpen) {
                sumRegOpen.innerText = (regStart && regStart.value) ? formatDateTimePretty(regStart.value) : '-';
            }
            if (sumRegDeadline) {
                sumRegDeadline.innerText = (regEnd && regEnd.value) ? formatDateTimePretty(regEnd.value) : '-';
            }

            // Audience Eligibility
            var branch = document.getElementById('<%= ddlBranch.ClientID %>');
            var dept = document.getElementById('<%= ddlDepartment.ClientID %>');
            var yl = document.getElementById('<%= ddlYearLevel.ClientID %>');
            var hfProg = document.getElementById('<%= hfSelectedPrograms.ClientID %>');

            var sumBranch = document.getElementById('sumBranch');
            var sumDept = document.getElementById('sumDept');
            var sumYearLevel = document.getElementById('sumYearLevel');
            var sumPrograms = document.getElementById('sumPrograms');

            if (sumBranch) {
                sumBranch.innerText = (branch && branch.selectedIndex > 0) ? branch.options[branch.selectedIndex].text : 'All University Branches (Open)';
            }
            if (sumDept) {
                sumDept.innerText = (dept && dept.selectedIndex > 0) ? dept.options[dept.selectedIndex].text : 'All Colleges / Open to All';
            }
            if (sumYearLevel) {
                sumYearLevel.innerText = (yl && yl.selectedIndex > 0) ? yl.options[yl.selectedIndex].text : 'All Year Levels (1st - 4th)';
            }

            if (sumPrograms) {
                sumPrograms.innerHTML = '';
                var progStr = hfProg ? hfProg.value.trim() : '';
                if (progStr) {
                    var list = progStr.split(',').map(function (s) { return s.trim(); });
                    list.forEach(function (code) {
                        var chip = document.createElement('span');
                        chip.className = 'summary-chip-badge';
                        chip.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg> ' + code;
                        sumPrograms.appendChild(chip);
                    });
                } else {
                    sumPrograms.innerHTML = '<span style="color:#64748b; font-size:0.8rem; font-style:italic;">All Academic Programs (Open to all majors)</span>';
                }
            }

            // Sponsors Summary (No star icon)
            var sumSponsors = document.getElementById('sumSponsors');
            if (sumSponsors) {
                sumSponsors.innerHTML = '';
                var sponsorChips = document.querySelectorAll('.sponsor-chip span');
                if (sponsorChips && sponsorChips.length > 0) {
                    sponsorChips.forEach(function (s) {
                        var chip = document.createElement('span');
                        chip.className = 'summary-chip-badge';
                        chip.innerText = s.innerText;
                        sumSponsors.appendChild(chip);
                    });
                } else {
                    sumSponsors.innerHTML = '<span style="color:#64748b; font-size:0.8rem; font-style:italic;">No external partner sponsors attached (Institutional event).</span>';
                }
            }

            // Also keep ticket preview in sync
            updateTicketPreview();
        }

        function initLiveTicketListeners() {
            var inputs = [
                document.getElementById('<%= txtTitle.ClientID %>'),
                document.getElementById('<%= txtVenueLocation.ClientID %>'),
                document.getElementById('<%= txtEventDate.ClientID %>'),
                document.getElementById('<%= txtEventStartTime.ClientID %>'),
                document.getElementById('<%= txtEventEndTime.ClientID %>')
            ];

            inputs.forEach(function (el) {
                if (el) {
                    el.addEventListener('input', updateTicketPreview);
                    el.addEventListener('change', updateTicketPreview);
                    el.addEventListener('keyup', updateTicketPreview);
                }
            });
        }

        // Initialize state on page load
        document.addEventListener('DOMContentLoaded', function () {
            restoreCourseSelection();
            initLiveTicketListeners();
            updateTicketPreview();
            var hf = document.getElementById('<%= hfActiveStep.ClientID %>');
            var initialStep = (hf && hf.value) ? parseInt(hf.value) : 1;
            switchStep(initialStep);
        });

        // Re-apply step state, ticket preview, and course selections after partial or full postback
        if (typeof (Sys) !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                restoreCourseSelection();
                initLiveTicketListeners();
                updateTicketPreview();
                var hf = document.getElementById('<%= hfActiveStep.ClientID %>');
                var initialStep = (hf && hf.value) ? parseInt(hf.value) : 1;
                switchStep(initialStep);
            });
        }
    </script>
</asp:Content>
