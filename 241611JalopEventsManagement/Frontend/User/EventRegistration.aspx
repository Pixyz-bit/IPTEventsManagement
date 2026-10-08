<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventRegistration.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.User.EventRegistration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <link rel="icon" type="image/png" href="<%= ResolveUrl("~/Frontend/Assets/QCU%20Logo.png") %>" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Event Registration | Quezon City University</title>
    
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/fonts.css?v=20261007") %>" />

    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/user/event-registration.css?v=" + DateTime.Now.Ticks) %>" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/toast.css") %>" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Persistent Hidden Field to maintain state for code-behind -->
        <asp:HiddenField ID="hfCurrentStep" runat="server" Value="3" />

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
                    <a href="<%= ResolveUrl("~/Frontend/User/StudentProfile.aspx") %>" class="nav-user-badge" style="text-decoration:none; color:inherit;">
                        <div class="nav-user-avatar">
                            <asp:Literal ID="litNavAvatarInitials" runat="server" Text="ST" />
                        </div>
                        <div class="nav-user-info">
                            <span class="nav-user-name"><asp:Literal ID="litNavStudentName" runat="server" Text="Student Account" /></span>
                            <span class="nav-user-id">[ <asp:Literal ID="litNavStudentId" runat="server" Text="" /> ]</span>
                        </div>
                    </a>

                    <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-link-back" title="Return to Dashboard">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Cancel &amp; Return</span>
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Workspace -->
        <main class="registration-container">
            <!-- Breadcrumbs Navigation -->
            <nav class="breadcrumb-nav" aria-label="Breadcrumb">
                <ol class="breadcrumb-list">
                    <li class="breadcrumb-item">
                        <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="3" width="7" height="7"></rect>
                                <rect x="14" y="3" width="7" height="7"></rect>
                                <rect x="14" y="14" width="7" height="7"></rect>
                                <rect x="3" y="14" width="7" height="7"></rect>
                            </svg>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="breadcrumb-separator">/</li>
                    <li class="breadcrumb-item">
                        <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx#events-section") %>">
                            <span>Campus Events</span>
                        </a>
                    </li>
                    <li class="breadcrumb-separator">/</li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <span>Event Registration</span>
                    </li>
                </ol>
            </nav>

            <!-- Page Title Block -->
            <div class="page-header-row">
                <h2>Campus Event Registration</h2>
                <div>
                    <asp:Literal ID="litCapacityBadge" runat="server" />
                </div>
            </div>

            <!-- Error Banner (if any) -->
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="error-alert-banner">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <asp:Literal ID="litErrorMsg" runat="server" />
            </asp:Panel>

            <asp:Panel ID="pnlUnavailable" runat="server" Visible="false" CssClass="event-summary-card" role="status">
                <h3 class="event-summary-title">Registration unavailable</h3>
                <asp:PlaceHolder ID="phUnavailableEvent" runat="server"><p><asp:Literal ID="litUnavailableEvent" runat="server" /></p></asp:PlaceHolder>
                <p><asp:Literal ID="litUnavailableReason" runat="server" /></p>
                <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx#events-section") %>" class="btn-secondary">Back to Campus Events</a>
            </asp:Panel>

            <asp:Panel ID="pnlRegistration" runat="server">
            <!-- Event Context Summary Card -->
            <div class="event-summary-card">
                <div class="event-summary-header">
                    <div>
                        <div style="font-size:0.75rem; font-family:var(--font-mono); font-weight:700; color:var(--accent-gold); text-transform:uppercase; letter-spacing:0.04em; margin-bottom:0.35rem;">
                            REGISTERING FOR:
                        </div>
                        <h3 class="event-summary-title">
                            <asp:Literal ID="litStep1Title" runat="server" Text="--" />
                        </h3>
                        <p style="font-size:0.9rem; color:var(--text-secondary); line-height:1.5; max-width:800px; margin:0;">
                            <asp:Literal ID="litStep1Description" runat="server" Text="--" />
                        </p>
                    </div>

                    <!-- Optional Event Promotional Banner Poster -->
                    <asp:Panel ID="pnlEventPhoto" runat="server" Visible="false" style="flex-shrink:0;">
                        <asp:Image ID="imgEventPhoto" runat="server" AlternateText="Event Banner Poster" 
                            style="width:140px; height:85px; object-fit:cover; border-radius:10px; border:1px solid rgba(255,255,255,0.15);" />
                    </asp:Panel>
                </div>

                <div class="event-summary-meta-grid">
                    <div class="meta-chip">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <span><asp:Literal ID="litStep1Date" runat="server" Text="--" /> (<asp:Literal ID="litStep1Schedule" runat="server" Text="--" />)</span>
                    </div>

                    <div class="meta-chip">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                        </svg>
                        <span><asp:Literal ID="litStep1Venue" runat="server" Text="--" /></span>
                    </div>

                    <div class="meta-chip">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                        </svg>
                        <span><asp:Literal ID="litStep1Spots" runat="server" Text="--" /></span>
                    </div>
                </div>

                <!-- Hidden literal placeholders retained for code-behind bindings -->
                <div style="display:none;">
                    <asp:Literal ID="litStep1Capacity" runat="server" />
                    <asp:Literal ID="litStep1Audience" runat="server" />
                </div>
            </div>

            <!-- Main Form Card: View-Only Student Info + Interactive Year & Section Inputs -->
            <div class="registration-form-card">
                <!-- Section Header -->
                <div class="card-section-header">
                    <div class="section-title-wrap">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        <span class="section-title">Student Profile &amp; Enrollment Information</span>
                    </div>
                    <span class="section-badge-locked">
                        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="display:inline-block; vertical-align:middle; margin-right:3px;">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        OFFICIAL RECORD
                    </span>
                </div>

                <!-- Section Body -->
                <div class="card-section-body">
                    <!-- 1. VIEW-ONLY STUDENT DETAILS -->
                    <p class="section-desc-note">
                        Your electronic event pass and attendance QR ticket will be verified against your official matriculation record below:
                    </p>

                    <div class="viewonly-student-grid">
                        <!-- Student ID -->
                        <div class="viewonly-item">
                            <span class="viewonly-label">
                                <span>Student ID Number</span>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            </span>
                            <span class="viewonly-value highlight-id">
                                <asp:Literal ID="litProfileStudentId" runat="server" Text="" />
                            </span>
                        </div>

                        <!-- Full Name -->
                        <div class="viewonly-item">
                            <span class="viewonly-label">
                                <span>Full Student Name</span>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            </span>
                            <span class="viewonly-value">
                                <asp:Literal ID="litProfileFullName" runat="server" Text="--" />
                            </span>
                        </div>

                        <!-- University Email -->
                        <div class="viewonly-item">
                            <span class="viewonly-label">
                                <span>Institutional Email</span>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            </span>
                            <span class="viewonly-value">
                                <asp:Literal ID="litProfileEmail" runat="server" Text="--" />
                            </span>
                        </div>

                        <!-- Campus Branch -->
                        <div class="viewonly-item">
                            <span class="viewonly-label">
                                <span>Campus Branch</span>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            </span>
                            <span class="viewonly-value">
                                <asp:Literal ID="litProfileCampus" runat="server" Text="--" />
                            </span>
                        </div>

                        <!-- College / Department -->
                        <div class="viewonly-item">
                            <span class="viewonly-label">
                                <span>College / Department</span>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            </span>
                            <span class="viewonly-value">
                                <asp:Literal ID="litProfileDepartment" runat="server" Text="--" />
                            </span>
                        </div>

                        <!-- Degree Program -->
                        <div class="viewonly-item">
                            <span class="viewonly-label">
                                <span>Degree Program</span>
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            </span>
                            <span class="viewonly-value">
                                <asp:Literal ID="litProfileProgram" runat="server" Text="--" />
                            </span>
                        </div>
                    </div>

                    <!-- 2. INTERACTIVE COHORT INPUTS: YEAR AND SECTION -->
                    <div class="inputs-subheading">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <polyline points="9 11 12 14 22 4"></polyline>
                            <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                        </svg>
                        <span>Please Specify Your Current Standing &amp; Section</span>
                    </div>

                    <div class="inputs-grid-2col">
                        <!-- Year Level Input -->
                        <div class="form-group">
                            <label class="form-label" for="<%= ddlYearLevel.ClientID %>">
                                <span>Current Year Level <span class="req">*</span></span>
                                <span class="form-label-muted">Select Academic Year</span>
                            </label>
                            <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-select">
                                <asp:ListItem Value="" Text="Select your current year" />
                                <asp:ListItem Value="1" Text="1st Year"></asp:ListItem>
                                <asp:ListItem Value="2" Text="2nd Year"></asp:ListItem>
                                <asp:ListItem Value="3" Text="3rd Year"></asp:ListItem>
                                <asp:ListItem Value="4" Text="4th Year"></asp:ListItem>
                                <asp:ListItem Value="5" Text="Irregular"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Panel ID="pnlYearRequirement" runat="server" Visible="false">
                                <p><asp:Literal ID="litYearRequirement" runat="server" /></p>
                            </asp:Panel>
                        </div>

                        <!-- Class Section Input -->
                        <div class="form-group">
                            <label class="form-label" for="<%= txtSection.ClientID %>">
                                <span>Class Section <span class="req">*</span></span>
                                <span class="form-label-muted">e.g. SBIT-3A, SBIT-3C</span>
                            </label>
                            <asp:TextBox ID="txtSection" runat="server" CssClass="form-input" MaxLength="50" placeholder="e.g. SBIT-3C"></asp:TextBox>
                        </div>
                    </div>

                    <!-- 3. COMMITMENT & GUIDELINES CONFIRMATION -->
                    <div class="commitment-card">
                        <label class="commitment-checkbox-label" for="<%= chkTerms.ClientID %>">
                            <asp:CheckBox ID="chkTerms" runat="server" />
                            <span>I confirm that I will attend this event and agree to follow all official university event guidelines and campus health/safety protocols.</span>
                        </label>
                        <p class="commitment-subtext">
                            Note: Reserved seats that result in unexcused absences will be audited as No-Shows in accordance with the campus extracurricular attendance charter.
                        </p>
                    </div>

                    <!-- 4. ACTION BUTTONS -->
                    <div class="form-actions-footer">
                        <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="btn-secondary">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="19" y1="12" x2="5" y2="12"></line>
                                <polyline points="12 19 5 12 12 5"></polyline>
                            </svg>
                            <span>Back to Events Dashboard</span>
                        </a>

                        <asp:Button ID="btnConfirmRegistration" runat="server" 
                            CssClass="btn-primary-confirm" 
                            Text="Confirm & Complete Registration" 
                            OnClick="btnConfirmRegistration_Click" />
                    </div>
                </div>
            </div>
            </asp:Panel>
        </main>

        <!-- Enterprise Floating Lower-Right Toast Container -->
        <div id="appToastContainer" class="app-toast-container" aria-live="polite" aria-atomic="true"></div>
    </form>

    <!-- Universal Toast Engine -->
    <script type="text/javascript" src="<%= ResolveUrl("~/Frontend/Assets/js/toast.js") %>"></script>
</body>
</html>
