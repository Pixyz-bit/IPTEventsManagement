<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs"
    Inherits="_241611JalopEventsManagement.Frontend.Login.Login" %>

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">

    <head runat="server">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Portal Authentication | University Event Management</title>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet" />
        <style>
            :root {
                --bg-base: #0a0e17;
                --surface-panel: #111827;
                --surface-input: #1f2937;
                --border-subtle: #374151;
                --border-focus: #3b82f6;
                --text-heading: #f9fafb;
                --text-body: #d1d5db;
                --text-muted: #9ca3af;
                --brand-primary: #2563eb;
                --brand-primary-hover: #1d4ed8;
                --state-danger: #ef4444;
                --state-danger-bg: #450a0a;
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

            .auth-container {
                width: 100%;
                max-width: 440px;
            }

            .brand-block {
                text-align: center;
                margin-bottom: 2rem;
            }

            .brand-seal {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 52px;
                height: 52px;
                border-radius: 12px;
                background: #1e293b;
                border: 1px solid var(--border-subtle);
                margin-bottom: 1rem;
                color: #60a5fa;
            }

            .brand-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--text-heading);
                letter-spacing: -0.02em;
            }

            .brand-subtitle {
                font-size: 0.875rem;
                color: var(--text-muted);
                margin-top: 0.25rem;
            }

            .auth-card {
                background: var(--surface-panel);
                border: 1px solid var(--border-subtle);
                border-radius: 16px;
                padding: 2.25rem;
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5), 0 8px 10px -6px rgba(0, 0, 0, 0.4);
            }

            .form-group {
                margin-bottom: 1.35rem;
            }

            .form-label {
                display: block;
                font-size: 0.8125rem;
                font-weight: 600;
                color: var(--text-heading);
                margin-bottom: 0.5rem;
                letter-spacing: 0.01em;
            }

            .form-control {
                width: 100%;
                padding: 0.75rem 1rem;
                font-size: 0.9375rem;
                font-family: var(--font-family);
                color: var(--text-heading);
                background: var(--surface-input);
                border: 1px solid var(--border-subtle);
                border-radius: 8px;
                outline: none;
                transition: border-color 0.2s, box-shadow 0.2s;
            }

            .form-control:focus {
                border-color: var(--border-focus);
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
            }

            .form-control::placeholder {
                color: #6b7280;
            }

            .form-options {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 1.5rem;
                font-size: 0.8125rem;
            }

            .checkbox-label {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                color: var(--text-muted);
                cursor: pointer;
                user-select: none;
            }

            .checkbox-label input[type="checkbox"] {
                accent-color: var(--brand-primary);
                width: 16px;
                height: 16px;
                cursor: pointer;
            }

            .btn-submit {
                width: 100%;
                padding: 0.8rem 1.25rem;
                font-size: 0.9375rem;
                font-weight: 600;
                font-family: var(--font-family);
                color: #ffffff;
                background: var(--brand-primary);
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: background-color 0.2s, transform 0.1s;
            }

            .btn-submit:hover {
                background: var(--brand-primary-hover);
            }

            .btn-submit:active {
                transform: scale(0.99);
            }

            .alert-error {
                background: var(--state-danger-bg);
                border: 1px solid var(--state-danger);
                border-radius: 8px;
                padding: 0.85rem 1rem;
                margin-bottom: 1.35rem;
                color: #fca5a5;
                font-size: 0.84rem;
                line-height: 1.45;
                display: flex;
                align-items: flex-start;
                gap: 0.6rem;
            }

            .alert-icon {
                flex-shrink: 0;
                margin-top: 1px;
            }

            .auth-footer {
                margin-top: 2rem;
                text-align: center;
                font-size: 0.8rem;
                color: #6b7280;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="auth-container">
                <div class="brand-block">
                    <div class="brand-seal" aria-hidden="true">
                        <!-- SVG University Icon -->
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                            <path d="M6 12v5c3 3 9 3 12 0v-5" />
                        </svg>
                    </div>
                    <h1 class="brand-title">University Event Portal</h1>
                    <p class="brand-subtitle">Enter your institutional credentials to continue</p>
                </div>

                <div class="auth-card">
                    <!-- Server-Side Error Alert -->
                    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert-error">
                        <svg class="alert-icon" width="16" height="16" viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="8" x2="12" y2="12" />
                            <line x1="12" y1="16" x2="12.01" y2="16" />
                        </svg>
                        <div>
                            <asp:Label ID="lblErrorMessage" runat="server"></asp:Label>
                        </div>
                    </asp:Panel>

                    <!-- Identifier Input (Student ID or Email) -->
                    <div class="form-group">
                        <label for="txtIdentifier" class="form-label">Student ID or Email Address</label>
                        <asp:TextBox ID="txtIdentifier" runat="server" CssClass="form-control"
                            placeholder="Enter Student ID or University Email" autocomplete="username"></asp:TextBox>
                    </div>

                    <!-- Password Input -->
                    <div class="form-group">
                        <label for="txtPassword" class="form-label">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                            placeholder="Enter Password" autocomplete="current-password"></asp:TextBox>
                    </div>

                    <!-- Remember Me -->
                    <div class="form-options">
                        <label class="checkbox-label">
                            <asp:CheckBox ID="chkRememberMe" runat="server" />
                            Remember session
                        </label>
                    </div>

                    <!-- Submit Button -->
                    <asp:Button ID="btnLogin" runat="server" Text="Sign In to Portal" CssClass="btn-submit"
                        OnClick="btnLogin_Click" />
                </div>

                <div class="auth-footer">
                    &copy; University Events Management. Institutional access only.
                </div>
            </div>
        </form>
    </body>

    </html>