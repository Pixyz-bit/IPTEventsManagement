<%@ Page Title="Events History & Archive | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventHistory.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventHistory" EnableEventValidation="false" EnableSessionState="ReadOnly" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/event-history.css") %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Workspace Header -->
    <div class="history-header-row">
        <div class="history-title-block">
            <h2>Events History &amp; Institutional Archive</h2>
            <p>Official permanent records repository for concluded, completed, and cancelled campus events.</p>
        </div>
        <div class="history-actions">
            <asp:LinkButton ID="btnExportArchiveCsv" runat="server" CssClass="btn-action-secondary" OnClick="btnExportArchiveCsv_Click" ToolTip="Export Master Archive Ledger (CSV)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                    <polyline points="7 10 12 15 17 10"></polyline>
                    <line x1="12" y1="15" x2="12" y2="3"></line>
                </svg>
                <span>Export Archive (CSV)</span>
            </asp:LinkButton>

            <button type="button" class="btn-action-primary" onclick="window.print();" title="Print Accreditation Ledger Summary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="6 9 6 2 18 2 18 9"></polyline>
                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                    <rect x="6" y="14" width="12" height="8"></rect>
                </svg>
                <span>Print Audit Summary</span>
            </button>
        </div>
    </div>    

    <!-- Feedback Notification Banner -->
    <asp:Panel ID="pnlNotification" runat="server" Visible="false" CssClass="feedback-alert">
        <asp:Literal ID="litNotificationMsg" runat="server" />
        <asp:LinkButton ID="btnCloseNotification" runat="server" OnClick="btnCloseNotification_Click" Text="&times;" Style="font-size: 1.25rem; font-weight: bold; background: none; border: none; cursor: pointer; color: inherit;" CausesValidation="false" />
    </asp:Panel>

    <!-- KPI Metrics Ribbon -->
    <div class="history-kpi-grid">
        <div class="history-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Total Archived Events</span>
                <svg class="kpi-card-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path>
                </svg>
            </div>
            <div class="kpi-card-value"><asp:Literal ID="litTotalArchived" runat="server" Text="0" /></div>
            <div class="kpi-card-caption">All recorded historical campus activities</div>
        </div>

        <div class="history-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Successfully Completed</span>
                <svg class="kpi-card-icon" style="color:var(--accent-emerald);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
            </div>
            <div class="kpi-card-value" style="color:var(--accent-emerald);"><asp:Literal ID="litTotalCompleted" runat="server" Text="0" /></div>
            <div class="kpi-card-caption">Fully concluded with verified turnouts</div>
        </div>

        <div class="history-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Cancelled Events</span>
                <svg class="kpi-card-icon" style="color:var(--accent-rose);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
            </div>
            <div class="kpi-card-value" style="color:var(--accent-rose);"><asp:Literal ID="litTotalCancelled" runat="server" Text="0" /></div>
            <div class="kpi-card-caption">Voided with audit justification logs</div>
        </div>

        <div class="history-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Average Turnout Rate</span>
                <svg class="kpi-card-icon" style="color:var(--brand-primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="20" x2="18" y2="10"></line>
                    <line x1="12" y1="20" x2="12" y2="4"></line>
                    <line x1="6" y1="20" x2="6" y2="14"></line>
                </svg>
            </div>
            <div class="kpi-card-value" style="color:var(--brand-primary);"><asp:Literal ID="litTurnoutAvg" runat="server" Text="0.0%" /></div>
            <div class="kpi-card-caption">Cumulative attendee participation ratio</div>
        </div>
    </div>

    <!-- Filtering & Universal Search Toolbar -->
    <div class="history-toolbar">
        <div class="history-search-wrapper">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
            <asp:TextBox ID="txtSearch" runat="server" CssClass="history-search-input" Placeholder="Search event title, venue, or college..." AutoPostBack="true" OnTextChanged="FilterChanged" />
        </div>

        <div class="history-filters-group">
            <asp:DropDownList ID="ddlAcademicYear" runat="server" CssClass="history-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                <asp:ListItem Value="ALL" Text="All Academic Years" />
            </asp:DropDownList>

            <asp:DropDownList ID="ddlSemester" runat="server" CssClass="history-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                <asp:ListItem Value="ALL" Text="All Semesters" />
                <asp:ListItem Value="1st Semester" Text="1st Semester (Aug - Dec)" />
                <asp:ListItem Value="2nd Semester" Text="2nd Semester (Jan - May)" />
                <asp:ListItem Value="Summer Term" Text="Summer Term (Jun - Jul)" />
            </asp:DropDownList>

            <asp:DropDownList ID="ddlOutcomeStatus" runat="server" CssClass="history-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                <asp:ListItem Value="ALL" Text="All Outcome Statuses" />
                <asp:ListItem Value="Completed" Text="Completed Only" />
                <asp:ListItem Value="Cancelled" Text="Cancelled Only" />
                <asp:ListItem Value="Concluded" Text="Concluded (Date Passed)" />
            </asp:DropDownList>

            <asp:Button ID="btnFilterApply" runat="server" Text="Filter" CssClass="btn-action-primary" Style="height:38px; padding: 0 1rem;" OnClick="btnFilterApply_Click" CausesValidation="false" />
            <asp:Button ID="btnResetFilter" runat="server" Text="Reset" CssClass="btn-action-secondary" Style="height:38px; padding: 0 1rem;" OnClick="btnResetFilter_Click" CausesValidation="false" />
        </div>
    </div>

    <!-- Master Archive Table Card -->
    <div class="history-table-card">
        <div class="history-table-header-meta">
            <h3>
                <span>Institutional Event Records</span>
                <span class="count-pill"><asp:Literal ID="litShowingCount" runat="server">0</asp:Literal> Records</span>
            </h3>
            <span style="font-size:0.775rem; color:var(--text-muted);">
                Audited Archive Pool &bull; Immutable History
            </span>
        </div>

        <div class="table-responsive">
            <asp:Repeater ID="rptEventHistory" runat="server" OnItemCommand="rptEventHistory_ItemCommand">
                <HeaderTemplate>
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th style="width: 110px;">Outcome</th>
                                <th style="min-width: 260px;">Event Title &amp; Academic Scope</th>
                                <th style="min-width: 180px;">Venue Location</th>
                                <th style="width: 130px;">Registrations</th>
                                <th style="width: 160px;">Turnout Ratio</th>
                                <th style="width: 140px; text-align: right;">Accreditation Audit</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <!-- 1. Outcome Status Badge -->
                        <td>
                            <span class='<%# GetOutcomeStatusBadgeClass(Eval("EffectiveOutcomeStatus").ToString()) %>'>
                                <%# Eval("EffectiveOutcomeStatus") %>
                            </span>
                        </td>

                        <!-- 2. Event Title -->
                        <td>
                            <div class="cell-event-title"><%# Eval("Title") %></div>
                            <div class="cell-event-dept">
                                <%# string.IsNullOrWhiteSpace(Eval("TargetDepartment") as string) ? "Open to All Colleges" : Eval("TargetDepartment") %>
                            </div>
                        </td>

                        <!-- 3. Venue Location -->
                        <td>
                            <div class="cell-venue-text"><%# Eval("VenueLocation") %></div>
                        </td>

                        <!-- 5. Capacity Quota -->
                        <td>
                            <div style="font-family:var(--font-mono); font-weight:600; color:var(--text-heading); font-size:0.85rem;">
                                <%# Eval("CurrentRegistrations") %> / <%# Eval("MaxCapacity") %>
                            </div>
                            <div style="font-size:0.725rem; color:var(--text-muted);">Capacity Saturation</div>
                        </td>

                        <!-- 6. Turnout Statistics Bar -->
                        <td>
                            <div class="turnout-stat-block">
                                <div class="turnout-label-row">
                                    <span class="turnout-numbers"><%# Eval("AttendedCount") %> / <%# Eval("PreRegisteredCount") %></span>
                                    <span class="turnout-pct"><%# Eval("TurnoutPercentage", "{0:F1}%") %></span>
                                </div>
                                <div class="turnout-progress-track">
                                    <div class="turnout-progress-fill" style='width: <%# Math.Min(100.0, Convert.ToDouble(Eval("TurnoutPercentage"))) %>%;'></div>
                                </div>
                            </div>
                        </td>

                        <!-- 7. Actions -->
                        <td style="text-align: right;">
                            <div style="display:flex; justify-content:flex-end; gap:0.35rem;">
                                <asp:LinkButton ID="btnViewReport" runat="server" CssClass="btn-archive-view" CommandName="ViewReport" CommandArgument='<%# Eval("EventId") %>' CausesValidation="false" ToolTip="View Detailed Audit Report">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                    <span>Report</span>
                                </asp:LinkButton>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <!-- Zero State Fallback -->
            <asp:Panel ID="pnlNoRecords" runat="server" Visible="false" Style="padding: 3.5rem 1.5rem; text-align: center; color: var(--text-muted);">
                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin: 0 auto 0.75rem; color: var(--border-medium);">
                    <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path>
                </svg>
                <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--text-heading); margin-bottom: 0.35rem;">No Historical Records Found</h3>
                <p style="font-size: 0.85rem; max-width: 420px; margin: 0 auto 1.25rem;">No campus events match the selected academic year, semester, or search criteria.</p>
                <asp:Button ID="btnResetZeroState" runat="server" Text="Clear Filters" CssClass="btn-action-secondary" OnClick="btnResetFilter_Click" CausesValidation="false" />
            </asp:Panel>
        </div>
    </div>

    <!-- Archived Turnout Audit Modal Dialog -->
    <asp:Panel ID="pnlReportModal" runat="server" Visible="false" CssClass="modal-overlay">
        <div class="modal-box-lg">
            <div class="modal-header">
                <div>
                    <asp:Literal ID="litModalEventCode" runat="server" Visible="false" />
                    <h3 class="modal-title"><asp:Literal ID="litModalEventTitle" runat="server" /></h3>
                </div>
                <asp:LinkButton ID="btnCloseModal" runat="server" OnClick="btnCloseModal_Click" CausesValidation="false" Style="background:none; border:none; font-size:1.5rem; line-height:1; font-weight:bold; color:var(--text-muted); cursor:pointer;">&times;</asp:LinkButton>
            </div>

            <div class="modal-body">
                <!-- Status Row -->
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem;">
                    <div>
                        <span class="report-detail-label">Archive Outcome Status</span>
                        <div style="margin-top:0.25rem;"><asp:Literal ID="litModalStatusPill" runat="server" /></div>
                    </div>
                    <asp:Literal ID="litModalAcademicTerm" runat="server" Visible="false" />
                </div>

                <!-- Event Details Section Grid -->
                <div class="report-section-grid">
                    <div class="report-detail-item">
                        <div class="report-detail-label">Venue Location</div>
                        <div class="report-detail-val"><asp:Literal ID="litModalVenue" runat="server" /></div>
                    </div>
                    <div class="report-detail-item">
                        <div class="report-detail-label">Concluded Date &amp; Time</div>
                        <div class="report-detail-val"><asp:Literal ID="litModalDateTime" runat="server" /></div>
                    </div>
                    <div class="report-detail-item">
                        <div class="report-detail-label">Target Academic College</div>
                        <div class="report-detail-val"><asp:Literal ID="litModalDepartment" runat="server" /></div>
                    </div>
                    <div class="report-detail-item">
                        <div class="report-detail-label">Degree Program &amp; Year Level</div>
                        <div class="report-detail-val"><asp:Literal ID="litModalProgram" runat="server" /></div>
                    </div>
                </div>

                <!-- Cancellation Reason Callout if applicable -->
                <asp:Panel ID="pnlModalCancellationReason" runat="server" Visible="false" Style="background:#fff1f2; border:1px solid #fecdd3; border-radius:var(--radius-md); padding:0.85rem 1rem; margin-bottom:1.25rem;">
                    <div style="font-size:0.75rem; font-weight:700; color:var(--accent-rose); text-transform:uppercase; margin-bottom:0.25rem;">
                        Official Cancellation Justification Log:
                    </div>
                    <div style="font-size:0.85rem; color:#9f1239; line-height:1.4;">
                        <asp:Literal ID="litModalCancellationReason" runat="server" />
                    </div>
                </asp:Panel>

                <!-- Quantitative Telemetry Audit Grid -->
                <div style="margin-bottom:0.5rem; font-size:0.775rem; font-weight:700; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.05em;">
                    Accreditation Attendance Metrics
                </div>
                <div class="report-stats-grid">
                    <div class="report-stat-box">
                        <div class="report-stat-num"><asp:Literal ID="litModalCapacity" runat="server">0</asp:Literal></div>
                        <div class="report-stat-sub">Max Quota</div>
                    </div>
                    <div class="report-stat-box">
                        <div class="report-stat-num"><asp:Literal ID="litModalPreReg" runat="server">0</asp:Literal></div>
                        <div class="report-stat-sub">Pre-Registered</div>
                    </div>
                    <div class="report-stat-box highlight">
                        <div class="report-stat-num"><asp:Literal ID="litModalAttended" runat="server">0</asp:Literal></div>
                        <div class="report-stat-sub">Actual Attended</div>
                    </div>
                    <div class="report-stat-box">
                        <div class="report-stat-num"><asp:Literal ID="litModalTurnoutPct" runat="server">0.0%</asp:Literal></div>
                        <div class="report-stat-sub">Turnout Rate</div>
                    </div>
                </div>

                <!-- Auditor Disclaimer -->
                <div style="background:#f8fafc; border:1px solid var(--border-subtle); border-radius:var(--radius-md); padding:0.85rem 1rem; font-size:0.775rem; color:var(--text-muted); line-height:1.45;">
                    <strong>Audit Verification Notice:</strong> This document represents an immutable post-event record extracted from the University Event Database. Attendance figures were validated at institutional entrance gates via cryptographic optical pass validation.
                </div>
            </div>

            <div class="modal-footer">
                <asp:HiddenField ID="hfModalEventId" runat="server" />
                <asp:Button ID="btnExportSingleReportCsv" runat="server" Text="Export Event CSV" CssClass="btn-action-secondary" OnClick="btnExportSingleReportCsv_Click" CausesValidation="false" />
                <button type="button" class="btn-action-primary" onclick="window.print();">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right:0.35rem; vertical-align:middle;">
                        <polyline points="6 9 6 2 18 2 18 9"></polyline>
                        <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                        <rect x="6" y="14" width="12" height="8"></rect>
                    </svg>
                    Print Audit PDF
                </button>
                <asp:Button ID="btnDismissModal" runat="server" Text="Close Record" CssClass="btn-action-secondary" OnClick="btnCloseModal_Click" CausesValidation="false" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
