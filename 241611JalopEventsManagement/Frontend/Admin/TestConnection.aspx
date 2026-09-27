<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestConnection.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.TestConnection" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Database Diagnostic | University Event Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" />
    <style>
        :root {
            --bg-body: #0b0f19;
            --surface-card: rgba(18, 24, 38, 0.75);
            --surface-subtle: rgba(255, 255, 255, 0.03);
            --border-glass: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(99, 102, 241, 0.35);
            --primary: #6366f1;
            --primary-hover: #4f46e5;
            --primary-glow: rgba(99, 102, 241, 0.25);
            --success: #10b981;
            --success-bg: rgba(16, 185, 129, 0.12);
            --danger: #ef4444;
            --danger-bg: rgba(239, 68, 68, 0.12);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --font-sans: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
            --font-mono: 'JetBrains Mono', monospace;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-body);
            background-image: 
                radial-gradient(circle at 15% 15%, rgba(99, 102, 241, 0.15) 0%, transparent 40%),
                radial-gradient(circle at 85% 85%, rgba(16, 185, 129, 0.08) 0%, transparent 40%);
            background-attachment: fixed;
            color: var(--text-main);
            font-family: var(--font-sans);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1.5rem;
        }

        .container {
            width: 100%;
            max-width: 780px;
        }

        .glass-card {
            background: var(--surface-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-glass);
            border-radius: 20px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(255, 255, 255, 0.05);
            overflow: hidden;
            transition: border-color 0.3s ease;
        }

        .glass-card:hover {
            border-color: var(--border-hover);
        }

        .card-header {
            padding: 2rem 2.25rem 1.5rem;
            border-bottom: 1px solid var(--border-glass);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .brand-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.35rem 0.75rem;
            border-radius: 9999px;
            background: var(--surface-subtle);
            border: 1px solid var(--border-glass);
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.6rem;
        }

        .pulse-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--primary);
            box-shadow: 0 0 8px var(--primary);
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: var(--text-main);
        }

        .card-subtitle {
            font-size: 0.875rem;
            color: var(--text-muted);
            margin-top: 0.25rem;
        }

        .card-body {
            padding: 2.25rem;
            display: flex;
            flex-direction: column;
            gap: 1.75rem;
        }

        .status-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.25rem 1.5rem;
            border-radius: 14px;
            background: var(--surface-subtle);
            border: 1px solid var(--border-glass);
            gap: 1rem;
            flex-wrap: wrap;
        }

        .status-meta {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .status-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            font-weight: 600;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.95rem;
            font-weight: 600;
            padding: 0.45rem 1rem;
            border-radius: 9999px;
            letter-spacing: 0.01em;
        }

        .badge.online {
            background: var(--success-bg);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.3);
            box-shadow: 0 0 16px rgba(16, 185, 129, 0.2);
        }

        .badge.offline {
            background: var(--danger-bg);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.3);
            box-shadow: 0 0 16px rgba(239, 68, 68, 0.2);
        }

        .badge-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: currentColor;
        }

        .badge.online .badge-dot {
            animation: pulse-ring 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
        }

        @keyframes pulse-ring {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(1.3); }
        }

        .metric-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .metric-card {
            background: var(--surface-subtle);
            border: 1px solid var(--border-glass);
            border-radius: 12px;
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }

        .metric-label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.04em;
            font-weight: 500;
        }

        .metric-value {
            font-size: 1.15rem;
            font-weight: 600;
            color: var(--text-main);
            font-family: var(--font-mono);
            word-break: break-all;
        }

        .details-box {
            background: rgba(0, 0, 0, 0.35);
            border: 1px solid var(--border-glass);
            border-radius: 12px;
            padding: 1.25rem;
            font-family: var(--font-mono);
            font-size: 0.85rem;
            color: var(--text-muted);
            line-height: 1.6;
        }

        .details-title {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            color: var(--text-muted);
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
            display: block;
        }

        .error-banner {
            background: var(--danger-bg);
            border: 1px solid rgba(239, 68, 68, 0.3);
            border-radius: 12px;
            padding: 1rem 1.25rem;
            color: #fca5a5;
            font-size: 0.875rem;
            line-height: 1.5;
            word-break: break-word;
        }

        .btn-test {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            background: var(--primary);
            color: #ffffff;
            border: none;
            padding: 0.85rem 1.75rem;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: 12px;
            cursor: pointer;
            box-shadow: 0 4px 14px var(--primary-glow);
            transition: all 0.2s ease;
            text-decoration: none;
            font-family: var(--font-sans);
        }

        .btn-test:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
        }

        .btn-test:active {
            transform: translateY(0);
        }

        .card-footer {
            padding: 1.25rem 2.25rem;
            border-top: 1px solid var(--border-glass);
            background: var(--surface-subtle);
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.8rem;
            color: var(--text-muted);
            flex-wrap: wrap;
            gap: 0.75rem;
        }
    </style>
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
