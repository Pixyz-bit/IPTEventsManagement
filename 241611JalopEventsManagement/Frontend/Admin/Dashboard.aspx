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
            padding: 0.6rem 1.1rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            border: 1px solid rgba(255, 255, 255, 0.1);
            cursor: pointer;
            transition: background 0.15s ease, transform 0.1s ease;
        }

        .btn-action-primary:hover {
            background-color: var(--brand-primary-hover);
            transform: translateY(-1px);
        }

        .btn-action-secondary {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background-color: var(--bg-card);
            color: var(--text-heading);
            padding: 0.6rem 1rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            border: 1px solid var(--border-subtle);
            cursor: pointer;
            transition: background 0.15s ease, border-color 0.15s ease;
        }

        .btn-action-secondary:hover {
            background-color: rgba(255, 255, 255, 0.05);
            border-color: #3b82f6;
        }

        /* ─── Metric Cards Grid ─── */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
            margin-bottom: 2rem;
        }

        .metric-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            transition: border-color 0.15s ease;
        }

        .metric-card:hover {
            border-color: rgba(59, 130, 246, 0.4);
        }

        .metric-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .metric-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .metric-icon-wrap {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            background-color: rgba(37, 99, 235, 0.1);
            color: #60a5fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .metric-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-heading);
            letter-spacing: -0.02em;
            line-height: 1.1;
        }

        .metric-hint {
            font-size: 0.75rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }

        .hint-positive {
            color: var(--accent-emerald);
            font-weight: 600;
        }

        /* ─── Main Content Columns ─── */
        .dashboard-body-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
        }

        .content-panel {
            background-color: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            overflow: hidden;
        }

        .panel-header {
            padding: 1.1rem 1.25rem;
            border-bottom: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .panel-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-heading);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .panel-meta {
            font-size: 0.75rem;
            color: var(--text-muted);
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
            padding: 0.8rem 1rem;
            font-size: 0.72rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            border-bottom: 1px solid var(--border-subtle);
            background-color: rgba(9, 13, 22, 0.4);
        }

        .events-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-subtle);
            vertical-align: middle;
        }

        .events-table tr:last-child td {
            border-bottom: none;
        }

        .events-table tr:hover td {
            background-color: rgba(255, 255, 255, 0.02);
        }

        .event-cell-title {
            font-weight: 600;
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
            background-color: #1e293b;
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 0.3rem;
        }

        .capacity-bar-fill {
            height: 100%;
            background-color: var(--brand-primary);
            border-radius: 3px;
        }

        .capacity-text {
            font-size: 0.7rem;
            color: var(--text-muted);
            font-family: var(--font-mono);
        }

        /* ─── Status Badges ─── */
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.2rem 0.55rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .status-upcoming {
            background-color: rgba(37, 99, 235, 0.15);
            color: #93c5fd;
            border: 1px solid rgba(37, 99, 235, 0.3);
        }

        .status-ongoing {
            background-color: rgba(16, 185, 129, 0.15);
            color: #6ee7b7;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .status-completed {
            background-color: rgba(100, 116, 139, 0.15);
            color: #cbd5e1;
            border: 1px solid rgba(100, 116, 139, 0.3);
        }

        .status-cancelled {
            background-color: rgba(244, 63, 94, 0.15);
            color: #fca5a5;
            border: 1px solid rgba(244, 63, 94, 0.3);
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
            font-weight: 500;
            color: var(--text-heading);
        }

        .dept-item-count {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            font-family: var(--font-mono);
        }

        .dept-progress-track {
            height: 7px;
            background-color: #1e293b;
            border-radius: 4px;
            overflow: hidden;
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
            background-color: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--border-subtle);
            border-radius: 6px;
            text-decoration: none;
            color: var(--text-body);
            font-size: 0.82rem;
            transition: all 0.15s ease;
        }

        .quick-link-item:hover {
            background-color: rgba(37, 99, 235, 0.08);
            border-color: #3b82f6;
            color: var(--text-heading);
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
            <a href="#events-roster" class="btn-action-primary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                <span>Create New Event</span>
            </a>
        </div>
    </div>

    <!-- 4 Key Metric Cards -->
    <div class="metrics-grid">
        <div class="metric-card">
            <div class="metric-top">
                <span class="metric-label">Total Events</span>
                <div class="metric-icon-wrap">
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
                <span class="hint-positive"><asp:Literal ID="litUpcomingCount" runat="server" Text="0" /></span> active / upcoming
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-top">
                <span class="metric-label">Registrations</span>
                <div class="metric-icon-wrap" style="background-color: rgba(16, 185, 129, 0.1); color: #34d399;">
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
                Seats booked across all venues
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-top">
                <span class="metric-label">Avg Fill Rate</span>
                <div class="metric-icon-wrap" style="background-color: rgba(245, 158, 11, 0.1); color: #fbbf24;">
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
                Of total institutional capacity
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-top">
                <span class="metric-label">Total Students</span>
                <div class="metric-icon-wrap" style="background-color: rgba(168, 85, 247, 0.1); color: #c084fc;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                </div>
            </div>
            <div class="metric-value">
                <asp:Literal ID="litStudentCount" runat="server" Text="0" />
            </div>
            <div class="metric-hint">
                Registered profiles in matrix
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
                                <span style="font-size: 0.75rem; color: var(--text-body); background-color: rgba(255,255,255,0.04); padding: 0.15rem 0.5rem; border-radius: 4px; border: 1px solid var(--border-subtle);">
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
                    <a href="<%= ResolveUrl("~/Frontend/Admin/TestConnection.aspx") %>" class="quick-link-item">
                        <span>Database Diagnostic Tool</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </a>
                    <a href="<%= ResolveUrl("~/Frontend/AccessDenied.aspx?reason=preview") %>" class="quick-link-item">
                        <span>Access Denied Warning Preview</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </a>
                    <a href="<%= ResolveUrl("~/Frontend/Login/Login.aspx") %>" class="quick-link-item">
                        <span>Authentication Gateway Preview</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
