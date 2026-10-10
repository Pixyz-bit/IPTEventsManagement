<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentProfile.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.User.StudentProfilePage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <link rel="icon" type="image/png" href="<%= ResolveUrl("~/Frontend/Assets/QCU%20Logo.png") %>" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Student Account Settings | Quezon City University</title>
    
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/fonts.css?v=20261007") %>" />

    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/user/student-profile.css?v=" + DateTime.Now.Ticks) %>" />
</head>
<body>
    <form id="studentProfileForm" runat="server">
        <!-- Active Tab State Tracker -->
        <asp:HiddenField ID="hfActiveTab" runat="server" Value="profile" />


        <!-- Top Navigation Bar (Consistent with Dashboard) -->
        <header class="portal-navbar">
            <div class="navbar-inner">
                <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-brand">
                    <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="University Emblem" class="nav-logo-img" />
                    <div>
                        <div class="nav-brand-title">University Event Portal</div>
                        <div class="nav-brand-subtitle">Quezon City University</div>
                    </div>
                </a>

                <div class="nav-user-bar">
                    <div class="nav-user-badge">
                        <div class="nav-user-avatar">
                            <asp:Literal ID="litNavAvatar" runat="server" Text="ST" />
                        </div>
                        <div class="nav-user-info">
                            <span class="nav-user-name"><asp:Literal ID="litNavName" runat="server" Text="Student Account" /></span>
                            <span class="nav-user-id">[ <asp:Literal ID="litNavId" runat="server" Text="" /> ]</span>
                        </div>
                    </div>

                    <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-link-back" title="Return to Dashboard">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Dashboard</span>
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Workspace -->
        <main class="profile-container">
            <!-- Breadcrumbs Global Trail -->
            <nav class="breadcrumb-nav" aria-label="Breadcrumb">
                <ol class="breadcrumb-list">
                    <li class="breadcrumb-item">
                        <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                <polyline points="9 22 9 12 15 12 15 22"></polyline>
                            </svg>
                            <span>Student Portal</span>
                        </a>
                    </li>
                    <li class="breadcrumb-separator">/</li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <span>Account Settings</span>
                    </li>
                </ol>
            </nav>

            <!-- Page Workspace Header -->
            <div class="page-header-row">
                <div class="header-title-block">
                    <h1>Account settings</h1>
                    <p>View your academic information and manage your password.</p>
                </div>
            </div>

            <!-- Tab Switcher Navigation (Segmented Control) -->
            <div class="profile-tabs-nav" role="tablist" aria-label="Account settings">
                <button type="button" class="tab-btn active" id="tabBtnProfile" onclick="switchProfileTab('profile')" role="tab" aria-controls="tabContentProfile" aria-selected="true" tabindex="0">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                    <span>Student profile</span>
                </button>
                <button type="button" class="tab-btn" id="tabBtnSecurity" onclick="switchProfileTab('security')" role="tab" aria-controls="tabContentSecurity" aria-selected="false" tabindex="-1">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    <span>Account &amp; security</span>
                </button>
            </div>



            <!-- ══════════════════════════════════════════════════════════════
                 TAB 1: Student Profile & Academic Demographics
                 ══════════════════════════════════════════════════════════════ -->
            <div id="tabContentProfile" class="tab-content-panel active-tab" role="tabpanel" aria-labelledby="tabBtnProfile" tabindex="0">
                <div class="profile-card">
                    <div class="profile-card-header">
                        <div class="profile-section-title">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <h2>Academic information</h2>
                        </div>
                        <span class="profile-record-badge">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                                <rect x="3" y="11" width="18" height="11" rx="2"></rect>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                            </svg>
                            Official record
                        </span>
                    </div>

                    <div class="profile-card-body">
                        <!-- Verified Notice -->
                        <div class="verified-notice-box">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            </svg>
                            <span><strong>Verified Academic Record:</strong> This demographic information is synchronized with university registrar records and is strictly read-only. For updates or major corrections, please coordinate with your college dean or campus registrar.</span>
                        </div>

                        <dl class="academic-record">
                            <div class="academic-record-field">
                                <dt><span>Student ID</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd class="highlight-id"><asp:Literal ID="txtStudentId" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>Campus branch</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtCampusBranch" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>First name</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtFirstName" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>Middle name</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtMiddleName" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>Last name</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtLastName" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>College / department</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtDepartment" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>Academic program</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtProgram" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>Gender</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtGender" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>Year level</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtYearLevel" runat="server" Mode="Encode" /></dd>
                            </div>
                        </dl>
                    </div>
                </div>
            </div>

            <!-- ══════════════════════════════════════════════════════════════
                 TAB 2: Account Credentials & Access Control
                 ══════════════════════════════════════════════════════════════ -->
            <div id="tabContentSecurity" class="tab-content-panel" role="tabpanel" aria-labelledby="tabBtnSecurity" tabindex="0" hidden="hidden">
                <div class="profile-card">
                    <div class="profile-card-header">
                        <div class="profile-section-title">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                <rect x="3" y="11" width="18" height="11" rx="2"></rect>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                            </svg>
                            <h2>Account details</h2>
                        </div>
                    </div>
                    <div class="profile-card-body">
                        <dl class="academic-record account-record">
                            <div class="academic-record-field">
                                <dt><span>Institutional email</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtEmail" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>Account role</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtRole" runat="server" Mode="Encode" /></dd>
                            </div>
                            <div class="academic-record-field">
                                <dt><span>Account status</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></dt>
                                <dd><asp:Literal ID="txtStatus" runat="server" Mode="Encode" /></dd>
                            </div>
                        </dl>

                        <!-- Self-Service Password Change Section -->
                        <div class="security-sub-section">
                            <div class="security-sub-header">
                                <h3>Change password</h3>
                                <span class="form-hint" id="passwordHint">Your new password must contain at least 6 characters.</span>
                            </div>

                            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="feedback-alert alert-success" role="status">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                                <div>
                                    <asp:Literal ID="litSuccessMsg" runat="server" />
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="feedback-alert alert-error" role="alert">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                                <div>
                                    <asp:Literal ID="litErrorMsg" runat="server" />
                                </div>
                            </asp:Panel>

                            <div class="form-grid-3 password-grid">
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtCurrentPassword.ClientID %>">Current password <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-input" autocomplete="current-password" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtNewPassword.ClientID %>">New password <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-input" autocomplete="new-password" aria-describedby="passwordHint" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtConfirmPassword.ClientID %>">Confirm new password <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-input" autocomplete="new-password" />
                                </div>
                            </div>

                            <div class="password-actions">
                                <asp:Button ID="btnUpdatePassword" runat="server" Text="Update password" CssClass="btn-update-pwd" OnClick="btnUpdatePassword_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

    </form>

    <!-- Tab Controller Script -->
    <script type="text/javascript">
        function switchProfileTab(tabName) {
            var btnProfile = document.getElementById('tabBtnProfile');
            var btnSecurity = document.getElementById('tabBtnSecurity');
            var contentProfile = document.getElementById('tabContentProfile');
            var contentSecurity = document.getElementById('tabContentSecurity');
            var hf = document.getElementById('<%= hfActiveTab.ClientID %>');

            var securitySelected = tabName === 'security';
            [btnProfile, btnSecurity].forEach(function (button, index) {
                if (!button) return;
                var selected = index === (securitySelected ? 1 : 0);
                button.classList.toggle('active', selected);
                button.setAttribute('aria-selected', selected ? 'true' : 'false');
                button.tabIndex = selected ? 0 : -1;
            });
            [contentProfile, contentSecurity].forEach(function (panel, index) {
                if (!panel) return;
                var selected = index === (securitySelected ? 1 : 0);
                panel.classList.toggle('active-tab', selected);
                panel.hidden = !selected;
            });
            if (hf) hf.value = securitySelected ? 'security' : 'profile';
        }

        document.addEventListener('DOMContentLoaded', function () {
            var hf = document.getElementById('<%= hfActiveTab.ClientID %>');
            switchProfileTab(hf && hf.value === 'security' ? 'security' : 'profile');

            var buttons = [document.getElementById('tabBtnProfile'), document.getElementById('tabBtnSecurity')];
            buttons.forEach(function (button, index) {
                if (!button) return;
                button.addEventListener('keydown', function (event) {
                    var next;
                    if (event.key === 'ArrowRight' || event.key === 'ArrowLeft') next = 1 - index;
                    else if (event.key === 'Home') next = 0;
                    else if (event.key === 'End') next = 1;
                    else return;
                    event.preventDefault();
                    switchProfileTab(next === 1 ? 'security' : 'profile');
                    buttons[next].focus();
                });
            });
        });
    </script>

</body>
</html>
