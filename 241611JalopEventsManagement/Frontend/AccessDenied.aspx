<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccessDenied.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.AccessDenied" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Access Restricted | University Event Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --bg-base: #0a0e17;
            --surface-panel: #111827;
            --border-subtle: #374151;
            --text-heading: #f9fafb;
            --text-body: #d1d5db;
            --text-muted: #9ca3af;
            --brand-primary: #2563eb;
            --brand-primary-hover: #1d4ed8;
            --warn-border: #92400e;
            --warn-bg: #451a03;
            --warn-text: #fde68a;
            --font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-base);
            color: var(--text-body);
            font-family: var(--font-family);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }

        .error-card {
            width: 100%;
            max-width: 500px;
            background: var(--surface-panel);
            border: 1px solid var(--border-subtle);
            border-radius: 16px;
            padding: 2.5rem;
            text-align: center;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5), 0 8px 10px -6px rgba(0, 0, 0, 0.4);
        }

        .icon-shield {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 64px;
            height: 64px;
            border-radius: 16px;
            background: var(--warn-bg);
            border: 1px solid var(--warn-border);
            color: var(--warn-text);
            margin-bottom: 1.5rem;
        }

        .error-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-heading);
            letter-spacing: -0.02em;
            margin-bottom: 0.75rem;
        }

        .error-message {
            font-size: 0.9375rem;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 2rem;
        }

        .actions-group {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .btn-primary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.8rem 1.5rem;
            font-size: 0.9375rem;
            font-weight: 600;
            font-family: var(--font-family);
            color: #ffffff;
            background: var(--brand-primary);
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.2s, transform 0.1s;
        }

        .btn-primary:hover {
            background: var(--brand-primary-hover);
        }

        .btn-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.8rem 1.5rem;
            font-size: 0.9375rem;
            font-weight: 500;
            font-family: var(--font-family);
            color: var(--text-heading);
            background: #1f2937;
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .btn-secondary:hover {
            background: #374151;
        }

        .incident-badge {
            margin-top: 2rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--border-subtle);
            font-size: 0.75rem;
            color: #6b7280;
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="error-card">
            <div class="icon-shield" aria-hidden="true">
                <!-- SVG Lock / Shield Monoline Icon -->
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
            </div>

            <h1 class="error-title">
                <asp:Label ID="lblTitle" runat="server" Text="Access Restricted"></asp:Label>
            </h1>

            <p class="error-message">
                <asp:Label ID="lblDescription" runat="server" 
                    Text="You do not have the required permissions to view this resource, or your session has expired."></asp:Label>
            </p>

            <div class="actions-group">
                <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Frontend/Login/Login.aspx" CssClass="btn-primary">
                    Return to Sign In
                </asp:HyperLink>
                <asp:HyperLink ID="lnkPortal" runat="server" Visible="false" CssClass="btn-secondary">
                    Go to Designated Portal
                </asp:HyperLink>
                <button type="button" class="btn-secondary" onclick="window.history.back();">
                    Go Back
                </button>
            </div>

            <div class="incident-badge">
                <span>Security Directive: 403 Forbidden</span>
                <span id="spnTimestamp" runat="server"></span>
            </div>
        </div>
    </form>
</body>
</html>
