<%@ Page Title="Dashboard Overview | University Admin Console" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.Dashboard" %>

<asp:Content ID="HeadContentArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .dashboard-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .header-title-block h2 {
            font-size: 1.5rem;
            font-weight: 700;
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

        /* ─── Metric Cards Grid ─── */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
            margin-bottom: 2rem;
        }

        .metric-card {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            box-shadow: var(--shadow-subtle);
            transition: all 0.15s ease;
        }

        .metric-card:hover {
            border-color: #93c5fd;
            box-shadow: 0 4px 8px -2px rgba(0, 0, 0, 0.06), 0 2px 4px -2px rgba(0, 0, 0, 0.04);
        }

        .metric-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .metric-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .metric-icon-wrap {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .metric-value {
            font-size: 1.85rem;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.02em;
            line-height: 1.1;
            font-family: var(--font-mono), var(--font-sans);
        }

        .metric-hint {
            font-size: 0.75rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 0.35rem;
            font-weight: 500;
        }

        .hint-positive {
            color: var(--accent-emerald);
            font-weight: 700;
        }

        /* ─── Main Content Columns ─── */
        .dashboard-body-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
        }

        .content-panel {
            background-color: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: var(--shadow-subtle);
        }

        .panel-header {
            padding: 1.1rem 1.25rem;
            border-bottom: 1px solid var(--border-subtle);
            background-color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .panel-title {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-heading);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .panel-meta {
            font-size: 0.75rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* ─── Events Table ─── */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .events-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.82rem;
            text-align: left;
        }

        .events-table th {
            padding: 0.85rem 1rem;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            border-bottom: 1px solid var(--border-subtle);
            background-color: #f8fafc;
        }

        .events-table td {
            padding: 1rem;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .events-table tr:last-child td {
            border-bottom: none;
        }

        .events-table tr:hover td {
            background-color: #f8fafc;
        }

        .event-cell-title {
            font-weight: 700;
            color: var(--text-heading);
            font-size: 0.88rem;
            margin-bottom: 0.2rem;
        }

        .event-cell-venue {
            color: var(--text-muted);
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }

        .capacity-bar-container {
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

        .audience-badge {
            font-size: 0.72rem;
            color: #334155;
            background-color: #f1f5f9;
            padding: 0.2rem 0.55rem;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
            font-weight: 600;
            display: inline-block;
        }

        /* ─── Status Badges ─── */
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
        }

        .status-upcoming {
            background-color: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
        }

        .status-ongoing {
            background-color: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
        }

        .status-completed {
            background-color: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
        }

        .status-cancelled {
            background-color: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        /* ─── Audience Department Bars ─── */
        .dept-list {
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            gap: 1.1rem;
        }

        .dept-item-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.8rem;
            margin-bottom: 0.4rem;
        }

        .dept-item-name {
            font-weight: 600;
            color: var(--text-heading);
        }

        .dept-item-count {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-muted);
            font-family: var(--font-mono);
        }

        .dept-progress-track {
            height: 7px;
            background-color: #f1f5f9;
            border-radius: 4px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }

        .dept-progress-fill {
            height: 100%;
            border-radius: 4px;
        }

        /* ─── Quick Diagnostic List ─── */
        .quick-links-list {
            padding: 0.75rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .quick-link-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem 1rem;
            background-color: #f8fafc;
            border: 1px solid var(--border-subtle);
            border-radius: 6px;
            text-decoration: none;
            color: #334155;
            font-size: 0.82rem;
            font-weight: 500;
            transition: all 0.15s ease;
        }

        .quick-link-item:hover {
            background-color: #eff6ff;
            border-color: #bfdbfe;
            color: #1d4ed8;
        }

        @media (max-width: 1200px) {
            .metrics-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .dashboard-body-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 640px) {
            .metrics-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContentArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Dashboard Workspace Header -->
    <div class="dashboard-header">
        <div class="header-title-block">
            <h2>Administrative Operations</h2>
            <p>University-wide event scheduling, cohort demographics, and capacity tracking.</p>
        </div>
        <div class="header-actions">
            <a href="<%= ResolveUrl("~/Frontend/Admin/TestConnection.aspx") %>" class="btn-action-secondary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <circle cx="12" cy="12" r="3"></circle>
                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                </svg>
                <span>DB Diagnostic</span>
            </a>
            <a href="<%= ResolveUrl("~/Frontend/Admin/CheckIn.aspx") %>" class="btn-action-secondary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M4 7V4h3M20 7V4h-3M4 17v3h3M20 17v3h-3M9 9h6v6H9z"></path>
                </svg>
                <span>QR Scanner</span>
            </a>
            <a href="<%= ResolveUrl("~/Frontend/Admin/CreateEvent.aspx") %>" class="btn-action-primary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                <span>Create New Event</span>
            </a>
        </div>
    </div>

    <!-- 4 Key Metric Cards (Events, Registrations, Attendees, Fill Rate) -->
    <div class="metrics-grid">
        <!-- 1. Total Events -->
        <div class="metric-card">
            <div class="metric-top">
                <span class="metric-label">Events</span>
                <div class="metric-icon-wrap" style="background-color: #eff6ff; color: #1d4ed8;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                </div>
            </div>
            <div class="metric-value">
                <asp:Literal ID="litTotalEvents" runat="server" Text="0" />
            </div>
            <div class="metric-hint">
                <span class="hint-positive"><asp:Literal ID="litUpcomingCount" runat="server" Text="0" /></span> active & upcoming
            </div>
        </div>

        <!-- 2. Registrations -->
        <div class="metric-card">
            <div class="metric-top">
                <span class="metric-label">Registrations</span>
                <div class="metric-icon-wrap" style="background-color: #ecfdf5; color: #059669;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                </div>
            </div>
            <div class="metric-value">
                <asp:Literal ID="litTotalRegistrations" runat="server" Text="0" />
            </div>
            <div class="metric-hint">
                Seats booked across venues
            </div>
        </div>

        <!-- 3. Attendees -->
        <div class="metric-card">
            <div class="metric-top">
                <span class="metric-label">Attendees</span>
                <div class="metric-icon-wrap" style="background-color: #fffbeb; color: #d97706;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="8.5" cy="7" r="4"></circle>
                        <polyline points="17 11 19 13 23 9"></polyline>
                    </svg>
                </div>
            </div>
            <div class="metric-value">
                <asp:Literal ID="litTotalAttendees" runat="server" Text="0" />
            </div>
            <div class="metric-hint">
                Verified door check-ins
            </div>
        </div>

        <!-- 4. Fill Rate -->
        <div class="metric-card">
            <div class="metric-top">
                <span class="metric-label">Fill Rate</span>
                <div class="metric-icon-wrap" style="background-color: #f5f3ff; color: #7c3aed;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                        <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                    </svg>
                </div>
            </div>
            <div class="metric-value">
                <asp:Literal ID="litFillRate" runat="server" Text="0%" />
            </div>
            <div class="metric-hint">
                Of total venue capacity
            </div>
        </div>
    </div>

    <!-- Main Two-Column Operations Section -->
    <div class="dashboard-body-grid">
        <!-- Left: Event Manifest Roster -->
        <div class="content-panel" id="events-roster">
            <div class="panel-header">
                <div class="panel-title">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <line x1="8" y1="6" x2="21" y2="6"></line>
                        <line x1="8" y1="12" x2="21" y2="12"></line>
                        <line x1="8" y1="18" x2="21" y2="18"></line>
                        <line x1="3" y1="6" x2="3.01" y2="6"></line>
                        <line x1="3" y1="12" x2="3.01" y2="12"></line>
                        <line x1="3" y1="18" x2="3.01" y2="18"></line>
                    </svg>
                    <span>Event Manifest & Roster</span>
                </div>
                <span class="panel-meta">Ordered by Schedule Date</span>
            </div>

            <div class="table-responsive">
                <asp:Repeater ID="rptEvents" runat="server">
                    <HeaderTemplate>
                        <table class="events-table">
                            <thead>
                                <tr>
                                    <th>Event & Venue</th>
                                    <th>Schedule</th>
                                    <th>Capacity</th>
                                    <th>Audience Target</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <div class="event-cell-title"><%# Eval("Title") %></div>
                                <div class="event-cell-venue">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                    <span><%# Eval("VenueLocation") %></span>
                                </div>
                            </td>
                            <td>
                                <div style="font-weight: 500; color: var(--text-heading);"><%# Eval("EventStart", "{0:MMM dd, yyyy}") %></div>
                                <div style="color: var(--text-muted); font-size: 0.72rem; font-family: var(--font-mono);"><%# Eval("EventStart", "{0:hh:mm tt}") %></div>
                            </td>
                            <td>
                                <div class="capacity-bar-container">
                                    <div class="capacity-bar-track">
                                        <div class="capacity-bar-fill" style='width: <%# GetCapacityPercentage(Eval("CurrentRegistrations"), Eval("MaxCapacity")) %>%;'></div>
                                    </div>
                                    <div class="capacity-text"><%# Eval("CurrentRegistrations") %> / <%# Eval("MaxCapacity") %></div>
                                </div>
                            </td>
                            <td>
                                <span class="audience-badge">
                                    <%# Eval("IsOpenToAll").ToString() == "True" ? "All Departments" : Eval("TargetDepartment") %>
                                </span>
                            </td>
                            <td>
                                <span class='status-pill <%# GetStatusClass(Eval("Status")) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoEvents" runat="server" Visible="false" Style="padding: 2.5rem; text-align: center; color: var(--text-muted);">
                    <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin: 0 auto 0.75rem; color: var(--text-muted);">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <p style="font-size: 0.9rem; font-weight: 500; color: var(--text-heading); margin-bottom: 0.25rem;">No Events Scheduled Yet</p>
                    <p style="font-size: 0.8rem;">Create your first institutional event using the button above.</p>
                </asp:Panel>
            </div>
        </div>

        <!-- Right: Audience Demographics & Quick Links -->
        <div style="display: flex; flex-direction: column; gap: 1.5rem;">
            <!-- Audience Matrix Breakdown -->
            <div class="content-panel">
                <div class="panel-header">
                    <div class="panel-title">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                            <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                        </svg>
                        <span>Audience Cohorts</span>
                    </div>
                    <span class="panel-meta">Academic Matrix</span>
                </div>

                <div class="dept-list">
                    <div>
                        <div class="dept-item-header">
                            <span class="dept-item-name">College of Computer Studies</span>
                            <span class="dept-item-count">42%</span>
                        </div>
                        <div class="dept-progress-track">
                            <div class="dept-progress-fill" style="width: 42%; background-color: #3b82f6;"></div>
                        </div>
                    </div>

                    <div>
                        <div class="dept-item-header">
                            <span class="dept-item-name">College of Engineering</span>
                            <span class="dept-item-count">28%</span>
                        </div>
                        <div class="dept-progress-track">
                            <div class="dept-progress-fill" style="width: 28%; background-color: #10b981;"></div>
                        </div>
                    </div>

                    <div>
                        <div class="dept-item-header">
                            <span class="dept-item-name">College of Business & Acctg</span>
                            <span class="dept-item-count">18%</span>
                        </div>
                        <div class="dept-progress-track">
                            <div class="dept-progress-fill" style="width: 18%; background-color: #f59e0b;"></div>
                        </div>
                    </div>

                    <div>
                        <div class="dept-item-header">
                            <span class="dept-item-name">College of Arts & Sciences</span>
                            <span class="dept-item-count">12%</span>
                        </div>
                        <div class="dept-progress-track">
                            <div class="dept-progress-fill" style="width: 12%; background-color: #8b5cf6;"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Access Tools -->
            <div class="content-panel">
                <div class="panel-header">
                    <div class="panel-title">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                        </svg>
                        <span>Quick Tools</span>
                    </div>
                </div>

                <div class="quick-links-list">
                    <a href="<%= ResolveUrl("~/Frontend/Admin/CheckIn.aspx") %>" class="quick-link-item">
                        <span>QR Attendance Desk</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </a>
                    <a href="<%= ResolveUrl("~/Frontend/Admin/EventAttendees.aspx") %>" class="quick-link-item">
                        <span>Attendee Roster</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </a>
                    <a href="<%= ResolveUrl("~/Frontend/Admin/StudentList.aspx") %>" class="quick-link-item">
                        <span>Student Directory</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </a>
                    <a href="<%= ResolveUrl("~/Frontend/Admin/TestConnection.aspx") %>" class="quick-link-item">
                        <span>Database Diagnostic Tool</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
