<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestConnection.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.TestConnection" EnableSessionState="ReadOnly" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Database Diagnostic | University Event Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/test-connection.css") %>" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="glass-card">
                <!-- Header -->
                <div class="card-header">
                    <div>
                        <div class="brand-badge">
                            <span class="pulse-dot"></span>
                            Backend Diagnostic Tool
                        </div>
                        <h1 class="card-title">Database Connectivity Test</h1>
                        <p class="card-subtitle">Verifies connection pooling, catalog availability, and query latency.</p>
                    </div>
                    <asp:Button ID="btnRetest" runat="server" Text="Ping Database" CssClass="btn-test" OnClick="btnRetest_Click" />
                </div>

                <!-- Body -->
                <div class="card-body">
                    <!-- Status Hero Banner -->
                    <div class="status-hero">
                        <div class="status-meta">
                            <span class="status-label">Cluster State</span>
                            <span style="font-weight: 500; font-size: 0.9rem;">Microsoft SQL Server</span>
                        </div>
                        <asp:PlaceHolder ID="phStatusBadge" runat="server">
                            <!-- Populated in code-behind -->
                        </asp:PlaceHolder>
                    </div>

                    <!-- Metrics Grid -->
                    <div class="metric-grid">
                        <div class="metric-card">
                            <span class="metric-label">Target Database</span>
                            <span class="metric-value">UniversityEventDB</span>
                        </div>
                        <div class="metric-card">
                            <span class="metric-label">Ping Latency</span>
                            <asp:Label ID="lblLatency" runat="server" CssClass="metric-value" Text="-- ms"></asp:Label>
                        </div>
                        <div class="metric-card">
                            <span class="metric-label">Last Checked</span>
                            <asp:Label ID="lblTimestamp" runat="server" CssClass="metric-value" Text="--:--:--"></asp:Label>
                        </div>
                    </div>

                    <!-- Error Banner (visible only on failure) -->
                    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="error-banner">
                        <strong>Connection Error:</strong>
                        <div style="margin-top: 0.25rem;">
                            <asp:Label ID="lblErrorMessage" runat="server"></asp:Label>
                        </div>
                    </asp:Panel>

                    <!-- Connection String Inspection Box -->
                    <div class="details-box">
                        <span class="details-title">Resolved Connection String (Masked)</span>
                        <asp:Label ID="lblConnectionString" runat="server" Text="Fetching connection configuration..."></asp:Label>
                    </div>
                </div>

                <!-- Footer -->
                <div class="card-footer">
                    <span>Path: <code>Backend/Repository/DatabaseConnection.cs</code></span>
                    <span>Provider: <code>System.Data.SqlClient</code></span>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
