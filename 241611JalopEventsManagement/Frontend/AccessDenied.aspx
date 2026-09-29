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
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/auth/access-denied.css") %>" />
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
