<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Login.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <link rel="icon" type="image/png" href="<%= ResolveUrl("~/Frontend/Assets/QCU%20Logo.png") %>" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QCU Events Portal | Student & Campus Authentication</title>
    
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/fonts.css?v=20261007") %>" />

    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/auth/login.css?v=4.0") %>" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/toast.css") %>" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="auth-container">
            <!-- Brand Badge & Header Matching Photo -->
            <div class="brand-block">
                <div class="brand-seal-wrapper">
                    <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="University Seal" class="brand-seal-img" />
                </div>

                <h1 class="brand-title">University Event Portal</h1>
                <div class="brand-subtitle">&ldquo;Discover campus activities, reserve your slots, and get your digital pass.&rdquo;</div>
            </div>

            <!-- Cinematic Modern Auth Card Container -->
            <div class="auth-card">        
                <div class="card-inner">
                    <!-- Student ID or Email Address Input -->
                    <div class="form-group">
                        <label for="<%= txtIdentifier.ClientID %>" class="form-label">Email Address</label>
                        <asp:TextBox ID="txtIdentifier" runat="server" CssClass="form-control" 
                            placeholder="Enter University Email" autocomplete="username"></asp:TextBox>
                    </div>

                    <!-- Password Input -->
                    <div class="form-group">
                        <label for="<%= txtPassword.ClientID %>" class="form-label">Password</label>
                        <div class="password-input-wrapper">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                                placeholder="Enter Password" autocomplete="current-password"></asp:TextBox>
                            <button type="button" class="btn-toggle-password" id="btnTogglePassword" onclick="togglePasswordVisibility()" aria-label="Toggle password visibility" title="Show/Hide Password" tabindex="-1">
                                <svg id="eyeIconOpen" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="10" r="3"></circle>
                                </svg>
                                <svg id="eyeIconClosed" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:none;">
                                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                    <line x1="1" y1="1" x2="23" y2="23"></line>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <!-- Sign In to Portal Button Matching Photo -->
                    <asp:Button ID="btnLogin" runat="server" Text="Sign In to Portal" CssClass="btn-submit"
                        OnClick="btnLogin_Click" />
                </div>
            </div>
        </div>

        <!-- Enterprise Floating Lower-Right Toast Container -->
        <div id="appToastContainer" class="app-toast-container" aria-live="polite" aria-atomic="true"></div>
    </form>

    <script type="text/javascript">
        function togglePasswordVisibility() {
            var pwd = document.getElementById('<%= txtPassword.ClientID %>');
            var eyeOpen = document.getElementById('eyeIconOpen');
            var eyeClosed = document.getElementById('eyeIconClosed');
            if (!pwd) return;
            if (pwd.type === 'password') {
                pwd.type = 'text';
                eyeOpen.style.display = 'none';
                eyeClosed.style.display = 'block';
            } else {
                pwd.type = 'password';
                eyeOpen.style.display = 'block';
                eyeClosed.style.display = 'none';
            }
        }
    </script>

    <!-- Universal Toast Engine -->
    <script type="text/javascript" src="<%= ResolveUrl("~/Frontend/Assets/js/toast.js") %>"></script>
</body>
</html>
