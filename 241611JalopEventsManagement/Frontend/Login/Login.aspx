<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Login.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QCU Events Portal | Student & Campus Authentication</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@500;600;700;800&display=swap" rel="stylesheet" />

    <style>
        :root {
            /* Cinematic Modern Dark Palette */
            --bg-canvas: #090D16;
            --bg-surface: #101626;
            --bg-surface-elevated: #161F33;
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-medium: rgba(255, 255, 255, 0.14);
            --border-focus: rgba(59, 130, 246, 0.6);
            
            --text-primary: #FFFFFF;
            --text-secondary: #94A3B8;
            --text-muted: #64748B;
            
            --accent-gold: #FFDE59;
            --accent-gold-gradient: linear-gradient(135deg, #FFDE59 0%, #F59E0B 100%);
            --accent-emerald: #10B981;
            
            --font-sans: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            --font-mono: 'JetBrains Mono', monospace;
            
            --shadow-card: 0 20px 40px -15px rgba(0, 0, 0, 0.7), 0 0 1px 1px rgba(255, 255, 255, 0.06);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font-sans);
            min-height: 100vh;
            background-color: var(--bg-canvas);
            background-image: 
                radial-gradient(circle at 50% 15%, rgba(37, 99, 235, 0.09) 0%, transparent 60%),
                radial-gradient(circle at 85% 75%, rgba(245, 158, 11, 0.04) 0%, transparent 40%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1.25rem;
            color: var(--text-primary);
            -webkit-font-smoothing: antialiased;
        }

        .auth-container {
            width: 100%;
            max-width: 440px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* ─── Top Brand Header ─── */
        .brand-block {
            text-align: center;
            margin-bottom: 1.75rem;
            width: 100%;
        }

        .brand-badge-ticker {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            color: #CBD5E1;
            padding: 0.35rem 0.95rem;
            border-radius: 9999px;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            margin-bottom: 1.15rem;
            backdrop-filter: blur(8px);
        }

        .ticker-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background-color: var(--accent-emerald);
            display: inline-block;
            box-shadow: 0 0 8px var(--accent-emerald);
        }

        .brand-seal-wrapper {
            margin-bottom: 0.85rem;
            display: inline-block;
        }

        .brand-seal-img {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid var(--border-medium);
            background-color: #FFFFFF;
            padding: 2px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
        }

        .brand-title {
            font-size: 1.9rem;
            font-weight: 800;
            color: #FFFFFF;
            letter-spacing: -0.03em;
            line-height: 1.15;
            margin-bottom: 0.35rem;
        }

        .brand-subtitle {
            font-size: 0.84rem;
            color: var(--text-secondary);
            font-weight: 500;
        }

        /* ─── Structural Auth Card ─── */
        .auth-card {
            width: 100%;
            background: var(--bg-surface);
            border: 1px solid var(--border-medium);
            border-radius: 20px;
            box-shadow: var(--shadow-card);
            overflow: hidden;
            backdrop-filter: blur(12px);
        }

        .card-topbar {
            background: rgba(255, 255, 255, 0.03);
            border-bottom: 1px solid var(--border-subtle);
            padding: 0.85rem 1.4rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-topbar-label {
            font-family: var(--font-mono);
            font-size: 0.74rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-topbar-label svg {
            color: var(--accent-gold);
        }

        .card-inner {
            padding: 2rem 1.75rem;
        }

        /* ─── Form Inputs ─── */
        .form-group {
            margin-bottom: 1.35rem;
        }

        .form-label-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .form-label {
            font-size: 0.82rem;
            font-weight: 700;
            color: #FFFFFF;
            letter-spacing: 0.01em;
        }

        .form-tag-hint {
            font-family: var(--font-mono);
            font-size: 0.7rem;
            color: var(--text-muted);
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            padding: 0.85rem 1.05rem;
            font-size: 0.92rem;
            font-family: var(--font-sans);
            font-weight: 500;
            color: #FFFFFF;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            outline: none;
            transition: all 0.15s ease;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.07);
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        .form-control::placeholder {
            color: var(--text-muted);
            font-weight: 400;
            font-size: 0.85rem;
        }

        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.65rem;
        }

        .checkbox-label {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            color: var(--text-secondary);
            font-size: 0.82rem;
            font-weight: 500;
            cursor: pointer;
            user-select: none;
        }

        .checkbox-label input[type="checkbox"] {
            width: 16px;
            height: 16px;
            border: 1px solid var(--border-medium);
            border-radius: 4px;
            cursor: pointer;
            accent-color: var(--accent-gold);
        }

        /* ─── Modern Submit Button ─── */
        .btn-submit {
            width: 100%;
            padding: 0.85rem 1.25rem;
            font-size: 0.92rem;
            font-weight: 800;
            font-family: var(--font-sans);
            text-transform: uppercase;
            letter-spacing: 0.03em;
            color: #090D16;
            background: var(--accent-gold-gradient);
            border: none;
            border-radius: 10px;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(245, 158, 11, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .btn-submit:hover {
            box-shadow: 0 6px 20px rgba(245, 158, 11, 0.45);
            transform: translateY(-2px);
        }

        .btn-submit:active {
            transform: translateY(1px);
            box-shadow: 0 2px 6px rgba(245, 158, 11, 0.2);
        }

        /* ─── Clean Alert Box ─── */
        .alert-error {
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.3);
            border-radius: 10px;
            padding: 0.85rem 1rem;
            margin-bottom: 1.35rem;
            color: #FCA5A5;
            font-size: 0.84rem;
            line-height: 1.4;
            display: flex;
            align-items: center;
            gap: 0.65rem;
        }

        .alert-error-tag {
            background: rgba(239, 68, 68, 0.25);
            color: #FFFFFF;
            font-family: var(--font-mono);
            font-size: 0.7rem;
            font-weight: 800;
            padding: 0.15rem 0.45rem;
            border-radius: 4px;
            flex-shrink: 0;
        }

        .alert-error-msg {
            font-weight: 600;
        }

        /* ─── Footer ─── */
        .auth-footer {
            margin-top: 1.75rem;
            text-align: center;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            color: var(--text-muted);
            font-weight: 600;
            letter-spacing: 0.03em;
        }

        @media (max-width: 480px) {
            .brand-title {
                font-size: 1.65rem;
            }
            .card-inner {
                padding: 1.5rem 1.25rem;
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

                <h1 class="brand-title">Campus Event Portal</h1>
                <div class="brand-subtitle">Quezon City University &bull; Student Gateway</div>
            </div>

            <!-- Cinematic Modern Auth Card Container -->
            <div class="auth-card">        
                <div class="card-inner">
                    <!-- Server-Side Error Alert -->
                    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert-error">
                        <span class="alert-error-tag">! ERROR</span>
                        <div class="alert-error-msg">
                            <asp:Label ID="lblErrorMessage" runat="server"></asp:Label>
                        </div>
                    </asp:Panel>

                    <!-- Email Address Input -->
                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="txtIdentifier" class="form-label">Email Address</label>
                        </div>
                        <asp:TextBox ID="txtIdentifier" runat="server" CssClass="form-control" TextMode="Email"
                             autocomplete="email"></asp:TextBox>
                    </div>

                    <!-- Password Input -->
                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="txtPassword" class="form-label">Password</label>
                        </div>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                            autocomplete="current-password"></asp:TextBox>
                    </div>

                    <!-- Remember Session Checkbox -->
                    <div class="form-options">
                        <label class="checkbox-label">
                            <asp:CheckBox ID="chkRememberMe" runat="server" />
                            <span>Remember Me</span>
                        </label>
                    </div>

                    <!-- Modern Gold Accent Submit Button -->
                    <asp:Button ID="btnLogin" runat="server" Text="Sign In to Portal &rarr;" CssClass="btn-submit"
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