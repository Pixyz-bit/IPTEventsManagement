<%@ Page Title="Events History & History | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EventHistory.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.EventHistory" EnableEventValidation="false" EnableSessionState="ReadOnly" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/event-history.css?v=20261007-local-fonts") %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Workspace Header -->
    <div class="history-header-row">
        <div class="history-title-block">
            <h2>Events History</h2>
            <p>Official permanent records repository for completed and cancelled campus events.</p>
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
                <span class="kpi-card-title">Total Events</span>
            </div>
            <div class="kpi-card-value"><asp:Literal ID="litTotalHistorical" runat="server" Text="0" /></div>
        </div>

        <div class="history-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Completed Events</span>
            </div>
            <div class="kpi-card-value" style="color:var(--accent-emerald);"><asp:Literal ID="litTotalCompleted" runat="server" Text="0" /></div>
        </div>

        <div class="history-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Cancelled Events</span>
            </div>
            <div class="kpi-card-value" style="color:var(--accent-rose);"><asp:Literal ID="litTotalCancelled" runat="server" Text="0" /></div>
        </div>

    </div>

    <!-- Master History Table Card (Unified with Filter Toolbar & Zero Gap) -->
    <div class="history-table-card">
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

                <asp:DropDownList ID="ddlOutcomeStatus" runat="server" CssClass="history-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                    <asp:ListItem Value="ALL" Text="All Outcome Statuses" />
                    <asp:ListItem Value="Completed" Text="Completed Only" />
                    <asp:ListItem Value="Cancelled" Text="Cancelled Only" />
                </asp:DropDownList>

                <asp:Button ID="btnFilterApply" runat="server" Text="Filter" CssClass="btn-action-primary" Style="height:38px; padding: 0 1rem;" OnClick="btnFilterApply_Click" CausesValidation="false" />
                <asp:Button ID="btnResetFilter" runat="server" Text="Reset" CssClass="btn-action-secondary" Style="height:38px; padding: 0 1rem;" OnClick="btnResetFilter_Click" CausesValidation="false" />
            </div>
        </div>

        <div class="table-responsive">
            <asp:Repeater ID="rptEventHistory" runat="server" OnItemCommand="rptEventHistory_ItemCommand">
                <HeaderTemplate>
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th style="width: 110px;">Status</th>
                                <th style="min-width: 250px;">Event Title &amp; Scope</th>
                                <th style="min-width: 170px;">Venue &amp; Schedule</th>
                                <th style="width: 100px; text-align: right;">Actions</th>
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

                        <!-- 3. Venue Location & Date -->
                        <td>
                            <div class="cell-venue-text"><%# Eval("VenueLocation") %></div>
                            <div class="cell-date-text"><%# Convert.ToDateTime(Eval("EventStart")).ToString("MMM dd, yyyy") %></div>
                        </td>

                        <!-- 4. Actions: Direct Navigation to EventAnalytics.aspx -->
                        <td style="text-align: right;">
                            <a href='<%# ResolveUrl(string.Format("~/Frontend/Admin/EventAnalytics.aspx?eventId={0}&from=history", Eval("EventId"))) %>' class="btn-view-link link-matrix-view" title="View Detailed Event Analytics &amp; Performance Telemetry">View</a>
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
</asp:Content>
