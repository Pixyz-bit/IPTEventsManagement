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
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/toast.css") %>" />
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
                    <h1>Student Account Settings</h1>
                    <p>Review verified institutional student records and manage account security credentials.</p>
                </div>
            </div>

            <!-- Tab Switcher Navigation (Segmented Control) -->
            <div class="profile-tabs-nav" role="tablist">
                <button type="button" class="tab-btn active" id="tabBtnProfile" onclick="switchProfileTab('profile')" role="tab" aria-selected="true">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                    <span>Academic Demographics</span>
                </button>
                <button type="button" class="tab-btn" id="tabBtnSecurity" onclick="switchProfileTab('security')" role="tab" aria-selected="false">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    <span>Account Credentials &amp; Security</span>
                </button>
            </div>

            <!-- Feedback Notification Banners -->
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="feedback-alert alert-success">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
                <div>
                    <asp:Literal ID="litSuccessMsg" runat="server" />
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="feedback-alert alert-error">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <div>
                    <asp:Literal ID="litErrorMsg" runat="server" />
                </div>
            </asp:Panel>

            <!-- ══════════════════════════════════════════════════════════════
                 TAB 1: Student Profile & Academic Demographics
                 ══════════════════════════════════════════════════════════════ -->
            <div id="tabContentProfile" class="tab-content-panel active-tab">
                <div class="profile-card">
                    <div class="profile-card-header">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        <h2>Student Profile &amp; Academic Demographics</h2>
                    </div>

                    <div class="profile-card-body">
                        <!-- Verified Notice -->
                        <div class="verified-notice-box">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            </svg>
                            <span><strong>Verified Academic Record:</strong> This demographic information is synchronized with university registrar records and is strictly read-only. For updates or major corrections, please coordinate with your college dean or campus registrar.</span>
                        </div>

                        <!-- Form Row 1: Matriculation ID & Campus Branch -->
                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtStudentId.ClientID %>">Student Matriculation ID <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtStudentId" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtCampusBranch.ClientID %>">Campus Branch <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtCampusBranch" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                        </div>

                        <!-- Form Row 2: Full Name (3-column layout) -->
                        <div class="form-grid-3">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtFirstName.ClientID %>">First Name <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtMiddleName.ClientID %>">Middle Name</label>
                                <asp:TextBox ID="txtMiddleName" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtLastName.ClientID %>">Last Name <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                        </div>

                        <!-- Form Row 3: Department / College & Academic Program -->
                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtDepartment.ClientID %>">Department / College <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtDepartment" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtProgram.ClientID %>">Academic Program / Course <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtProgram" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                        </div>

                        <!-- Form Row 4: Gender & Cohort -->
                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtGender.ClientID %>">Gender</label>
                                <asp:TextBox ID="txtGender" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtYearLevel.ClientID %>">Academic Cohort / Year Level</label>
                                <asp:TextBox ID="txtYearLevel" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ══════════════════════════════════════════════════════════════
                 TAB 2: Account Credentials & Access Control
                 ══════════════════════════════════════════════════════════════ -->
            <div id="tabContentSecurity" class="tab-content-panel">
                <div class="profile-card">
                    <div class="profile-card-header">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <h2>Account Credentials &amp; Access Control</h2>
                    </div>
                    <div class="profile-card-body">
                        <!-- Credentials Overview -->
                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtEmail.ClientID %>">Institutional Email Address <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input read-only" ReadOnly="true" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtRole.ClientID %>">Assigned System Role <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtRole" runat="server" CssClass="form-input read-only" ReadOnly="true" Text="Student (Student)" />
                            </div>
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtStatus.ClientID %>">Account Status</label>
                                <asp:TextBox ID="txtStatus" runat="server" CssClass="form-input read-only" ReadOnly="true" Text="Active (Authorized)" />
                            </div>
                        </div>

                        <!-- Self-Service Password Change Section -->
                        <div class="security-sub-section">
                            <div class="security-sub-header">
                                <h3>Reset Password (Optional)</h3>
                                <span class="form-hint">Enter at least 6 characters to securely re-hash and update credentials.</span>
                            </div>

                            <div class="form-grid-3">
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtCurrentPassword.ClientID %>">Current Password <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="Current password..." />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtNewPassword.ClientID %>">New Password <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="Min. 6 characters..." />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtConfirmPassword.ClientID %>">Confirm New Password <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="Re-enter password..." />
                                </div>
                            </div>

                            <div style="margin-top: 1.5rem;">
                                <asp:Button ID="btnUpdatePassword" runat="server" Text="Update Password" CssClass="btn-update-pwd" OnClick="btnUpdatePassword_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Enterprise Floating Lower-Right Toast Container -->
        <div id="appToastContainer" class="app-toast-container" aria-live="polite" aria-atomic="true"></div>
    </form>

    <!-- Tab Controller Script -->
    <script type="text/javascript">
        function switchProfileTab(tabName) {
            var btnProfile = document.getElementById('tabBtnProfile');
            var btnSecurity = document.getElementById('tabBtnSecurity');
            var contentProfile = document.getElementById('tabContentProfile');
            var contentSecurity = document.getElementById('tabContentSecurity');
            var hf = document.getElementById('<%= hfActiveTab.ClientID %>');

            if (tabName === 'security') {
                if (btnProfile) btnProfile.classList.remove('active');
                if (btnSecurity) btnSecurity.classList.add('active');
                if (contentProfile) contentProfile.classList.remove('active-tab');
                if (contentSecurity) contentSecurity.classList.add('active-tab');
                if (hf) hf.value = 'security';
            } else {
                if (btnSecurity) btnSecurity.classList.remove('active');
                if (btnProfile) btnProfile.classList.add('active');
                if (contentSecurity) contentSecurity.classList.remove('active-tab');
                if (contentProfile) contentProfile.classList.add('active-tab');
                if (hf) hf.value = 'profile';
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            var hf = document.getElementById('<%= hfActiveTab.ClientID %>');
            if (hf && hf.value === 'security') {
                switchProfileTab('security');
            }
        });
    </script>

    <!-- Universal Toast Engine -->
    <script type="text/javascript" src="<%= ResolveUrl("~/Frontend/Assets/js/toast.js") %>"></script>
</body>
</html>
