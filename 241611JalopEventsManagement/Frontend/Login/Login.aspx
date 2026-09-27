<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Login.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QCU Events Portal | Student & Campus Authentication</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@600;700;800;900&family=JetBrains+Mono:wght@600;700;800&display=swap" rel="stylesheet" />

    <style>
        :root {
            /* User Restricted Palette */
            --nb-black: #000000;
            --nb-canvas: #FAF7EE;
            --nb-card-bg: #FFFFFF;
            --nb-input-bg: #FFFDF7;
            --nb-yellow: #FFDE59;
            --nb-yellow-hover: #FACC15;
            --nb-lime: #A6F4C5;
            --nb-lime-hover: #86EFAC;
            --nb-border: 2px solid #000000;
            --font-sans: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            --font-mono: 'JetBrains Mono', monospace;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font-sans);
            min-height: 100vh;
            background-color: var(--nb-canvas);
            background-image: 
                radial-gradient(rgba(0, 0, 0, 0.12) 1.25px, transparent 1.25px),
                radial-gradient(rgba(0, 0, 0, 0.06) 1.25px, var(--nb-canvas) 1.25px);
            background-size: 24px 24px;
            background-position: 0 0, 12px 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1.25rem;
            color: var(--nb-black);
        }

        .auth-container {
            width: 100%;
            max-width: 440px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* ─── Top Brand Header (No box shadows on small tags/seals) ─── */
        .brand-block {
            text-align: center;
            margin-bottom: 1.5rem;
            width: 100%;
        }

        .brand-badge-ticker {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background-color: #000000;
            color: #FFFFFF;
            padding: 0.3rem 0.85rem;
            border-radius: 9999px;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            margin-bottom: 0.85rem;
        }

        .ticker-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background-color: var(--nb-lime);
            display: inline-block;
        }

        .brand-seal-wrapper {
            margin-bottom: 0.75rem;
            display: inline-block;
        }

        .brand-seal-img {
            width: 68px;
            height: 68px;
            border-radius: 14px;
            object-fit: cover;
            border: var(--nb-border);
            background-color: #FFFFFF;
            padding: 3px;
        }

        .brand-title {
            font-size: 2rem;
            font-weight: 900;
            color: var(--nb-black);
            letter-spacing: -0.035em;
            line-height: 1.1;
            text-transform: uppercase;
            margin-bottom: 0.35rem;
        }

        .brand-subtitle {
            font-size: 0.82rem;
            font-family: var(--font-mono);
            color: #000000;
            font-weight: 700;
            background: #FFFFFF;
            display: inline-block;
            padding: 0.2rem 0.7rem;
            border: 1.5px solid #000000;
            border-radius: 6px;
        }

        /* ─── Structural Card (Only container has box-shadow: 4px 4px 0px #000) ─── */
        .auth-card {
            width: 100%;
            background: var(--nb-card-bg);
            border: var(--nb-border);
            border-radius: 16px;
            box-shadow: 4px 4px 0px #000000;
            overflow: hidden;
        }

        .card-topbar {
            background-color: var(--nb-yellow);
            border-bottom: var(--nb-border);
            padding: 0.7rem 1.25rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-topbar-label {
            font-family: var(--font-mono);
            font-size: 0.76rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .card-inner {
            padding: 1.85rem 1.65rem;
        }

        /* ─── Form Inputs (No box shadows on fields) ─── */
        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-label-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.4rem;
        }

        .form-label {
            font-size: 0.8rem;
            font-weight: 800;
            color: var(--nb-black);
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .form-tag-hint {
            font-family: var(--font-mono);
            font-size: 0.7rem;
            color: #000000;
            font-weight: 700;
        }

        .form-control {
            width: 100%;
            padding: 0.8rem 0.95rem;
            font-size: 0.92rem;
            font-family: var(--font-sans);
            font-weight: 600;
            color: var(--nb-black);
            background-color: var(--nb-input-bg);
            border: var(--nb-border);
            border-radius: 8px;
            outline: none;
            transition: background-color 0.12s ease;
        }

        .form-control:focus {
            background-color: #FFFFFF;
            border-color: #000000;
        }

        .form-control::placeholder {
            color: #71717a;
            font-weight: 500;
            font-size: 0.85rem;
        }

        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
        }

        .checkbox-label {
            display: inline-flex;
            align-items: center;
            gap: 0.55rem;
            color: var(--nb-black);
            font-size: 0.8rem;
            font-family: var(--font-mono);
            font-weight: 700;
            cursor: pointer;
            user-select: none;
        }

        .checkbox-label input[type="checkbox"] {
            width: 17px;
            height: 17px;
            border: 1.5px solid #000000;
            border-radius: 3px;
            cursor: pointer;
            accent-color: #000000;
        }

        /* ─── Tactile Submit Button (Box shadow strictly on action CTA) ─── */
        .btn-submit {
            width: 100%;
            padding: 0.9rem 1.25rem;
            font-size: 0.95rem;
            font-weight: 900;
            font-family: var(--font-sans);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #000000;
            background-color: var(--nb-yellow);
            border: var(--nb-border);
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 3px 3px 0px #000000;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: transform 0.08s ease, box-shadow 0.08s ease, background-color 0.1s ease;
        }

        .btn-submit:hover {
            background-color: var(--nb-yellow-hover);
        }

        /* Depress into shadow on click */
        .btn-submit:active {
            transform: translate(3px, 3px);
            box-shadow: 0px 0px 0px #000000;
        }

        /* ─── Clean Alert Box (No box shadow) ─── */
        .alert-error {
            background-color: var(--nb-input-bg);
            border: var(--nb-border);
            border-radius: 8px;
            padding: 0.8rem 0.95rem;
            margin-bottom: 1.25rem;
            color: #000000;
            font-size: 0.82rem;
            line-height: 1.4;
            display: flex;
            align-items: center;
            gap: 0.65rem;
        }

        .alert-error-tag {
            background: #000000;
            color: #FFFFFF;
            font-family: var(--font-mono);
            font-size: 0.7rem;
            font-weight: 800;
            padding: 0.15rem 0.45rem;
            border-radius: 3px;
            flex-shrink: 0;
        }

        .alert-error-msg {
            font-weight: 700;
        }

        /* ─── Footer ─── */
        .auth-footer {
            margin-top: 1.5rem;
            text-align: center;
            font-family: var(--font-mono);
            font-size: 0.74rem;
            color: #000000;
            font-weight: 700;
        }

        @media (max-width: 480px) {
            .brand-title {
                font-size: 1.7rem;
            }
            .card-inner {
                padding: 1.35rem 1.15rem;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="auth-container">
            <!-- Brand Badge & Header -->
            <div class="brand-block">
                <div class="brand-badge-ticker">
                    <span class="ticker-dot"></span>
                    <span>QCU PORTAL // AUTHENTICATION</span>
                </div>
                
                <div>
                    <div class="brand-seal-wrapper">
                        <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="University Seal" class="brand-seal-img" />
                    </div>
                </div>

                <h1 class="brand-title">CAMPUS EVENTS</h1>
                <div class="brand-subtitle">[ DISCOVER &bull; RESERVE &bull; ATTEND ]</div>
            </div>

            <!-- Neo-Brutalism Card Container (4px 4px 0px #000 shadow) -->
            <div class="auth-card">
                <!-- Card Window Top Header Bar -->
                <div class="card-topbar">
                    <div class="card-topbar-label">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#000000" stroke-width="2.5">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <span>STUDENT GATEWAY</span>
                    </div>
                    <span style="font-family: var(--font-mono); font-size: 0.7rem; font-weight: 800;">v2.6</span>
                </div>

                <div class="card-inner">
                    <!-- Server-Side Error Alert -->
                    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert-error">
                        <span class="alert-error-tag">! ERROR</span>
                        <div class="alert-error-msg">
                            <asp:Label ID="lblErrorMessage" runat="server"></asp:Label>
                        </div>
                    </asp:Panel>

                    <!-- Identifier Input (Student ID or Email) -->
                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="txtIdentifier" class="form-label">Student ID or Email</label>
                            <span class="form-tag-hint">2024-XXXXX</span>
                        </div>
                        <asp:TextBox ID="txtIdentifier" runat="server" CssClass="form-control"
                            placeholder="e.g. 2024-00101 or student@qcu.edu.ph" autocomplete="username"></asp:TextBox>
                    </div>

                    <!-- Password Input -->
                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="txtPassword" class="form-label">Password</label>
                            <span class="form-tag-hint">SECURE KEY</span>
                        </div>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                            placeholder="Enter your portal password" autocomplete="current-password"></asp:TextBox>
                    </div>

                    <!-- Remember Session Checkbox -->
                    <div class="form-options">
                        <label class="checkbox-label">
                            <asp:CheckBox ID="chkRememberMe" runat="server" />
                            <span>Keep session remembered</span>
                        </label>
                    </div>

                    <!-- Tactile Submit Button -->
                    <asp:Button ID="btnLogin" runat="server" Text="Sign In to Portal →" CssClass="btn-submit"
                        OnClick="btnLogin_Click" />
                </div>
            </div>

            <!-- Footer Notice -->
            <div class="auth-footer">
                &copy; 2026 QUEZON CITY UNIVERSITY &bull; STUDENT AFFAIRS
            </div>
        </div>
    </form>
</body>
</html>