<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventRegistration.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.User.EventRegistration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Event Registration | Quezon City University</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet" />

    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/user/event-registration.css") %>" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Persistent Hidden Field to maintain active step state -->
        <asp:HiddenField ID="hfCurrentStep" runat="server" Value="1" />

        <!-- Top University Navigation Bar -->
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
                            <asp:Literal ID="litNavAvatarInitials" runat="server" Text="ST" />
                        </div>
                        <div class="nav-user-info">
                            <span class="nav-user-name"><asp:Literal ID="litNavStudentName" runat="server" Text="Student Account" /></span>
                            <span class="nav-user-id">[ <asp:Literal ID="litNavStudentId" runat="server" Text="24-1611" /> ]</span>
                        </div>
                    </div>

                    <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-link-back">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Cancel & Return</span>
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
                            <span>User Portal</span>
                        </a>
                    </li>
                    <li class="breadcrumb-separator">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>">
                            <span>Campus Events</span>
                        </a>
                    </li>
                    <li class="breadcrumb-separator">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </li>
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

            <!-- Step-by-Step Procedure Breadcrumb Stepper (Matching Design System) -->
            <div class="procedure-stepper-container" role="tablist" aria-label="Event Registration Procedure Steps">
                <!-- Step 1 Tab -->
                <div class="procedure-step-tab active" id="tab-step-1" data-step="1" onclick="switchStep(1)" role="tab" aria-selected="true">
                    <div class="step-badge">1</div>
                    <div class="step-meta">
                        <span class="step-number">Step 01</span>
                        <span class="step-name">Core Information</span>
                    </div>
                </div>

                <div class="step-separator">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                </div>

                <!-- Step 2 Tab -->
                <div class="procedure-step-tab" id="tab-step-2" data-step="2" onclick="switchStep(2)" role="tab" aria-selected="false">
                    <div class="step-badge">2</div>
                    <div class="step-meta">
                        <span class="step-number">Step 02</span>
                        <span class="step-name">Student Information</span>
                    </div>
                </div>

                <div class="step-separator">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                </div>

                <!-- Step 3 Tab -->
                <div class="procedure-step-tab" id="tab-step-3" data-step="3" onclick="switchStep(3)" role="tab" aria-selected="false">
                    <div class="step-badge">3</div>
                    <div class="step-meta">
                        <span class="step-number">Step 03</span>
                        <span class="step-name">Year &amp; Section</span>
                    </div>
                </div>
            </div>

            <!-- Wizard Workspace Card -->
            <div class="wizard-workspace-card">

                <!-- =========================================================================
                     STEP 1: INFORMATION ABOUT THE EVENTS
                     ========================================================================= -->
                <div id="step-panel-1" class="step-panel">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <span>Step 1: Core Event Specifications</span>
                        </div>
                    </div>

                    <div class="card-body">
                        <!-- Event Title -->
                        <div class="form-group">
                            <label class="form-label">
                                <span>Event Title <span class="req">*</span></span>
                            </label>
                            <div class="form-control-display">
                                <strong><asp:Literal ID="litStep1Title" runat="server" Text="--" /></strong>
                            </div>
                        </div>

                        <!-- Event Description -->
                        <div class="form-group">
                            <label class="form-label">
                                <span>Event Description</span>
                            </label>
                            <div class="form-control-display multiline">
                                <asp:Literal ID="litStep1Description" runat="server" Text="--" />
                            </div>
                        </div>

                        <!-- Venue & Capacity Row -->
                        <div class="form-grid-2col">
                            <div class="form-group">
                                <label class="form-label">
                                    <span>Venue Location <span class="req">*</span></span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                    <span><asp:Literal ID="litStep1Venue" runat="server" Text="--" /></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <span>Max Capacity (Seats) <span class="req">*</span></span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                    </svg>
                                    <span><asp:Literal ID="litStep1Capacity" runat="server" Text="--" /> &bull; <asp:Literal ID="litStep1Spots" runat="server" Text="--" /></span>
                                </div>
                            </div>
                        </div>

                        <!-- Schedule & Audience Row -->
                        <div class="form-grid-2col">
                            <div class="form-group">
                                <label class="form-label">
                                    <span>Event Date &amp; Schedule</span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    <span><asp:Literal ID="litStep1Date" runat="server" Text="--" /> (<asp:Literal ID="litStep1Schedule" runat="server" Text="--" />)</span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <span>Target Audience Eligibility</span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                    <span><asp:Literal ID="litStep1Audience" runat="server" Text="Open to All Programs & Year Levels" /></span>
                                </div>
                            </div>
                        </div>

                        <!-- Optional Event Promotional Banner -->
                        <asp:Panel ID="pnlEventPhoto" runat="server" Visible="false" CssClass="form-group">
                            <label class="form-label">
                                <span>Event Promotional Banner</span>
                            </label>
                            <div class="event-banner-card">
                                <asp:Image ID="imgEventPhoto" runat="server" AlternateText="Event Banner Poster" />
                            </div>
                        </asp:Panel>

                        <!-- Step 1 Nav Footer -->
                        <div class="step-nav-footer">
                            <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="btn-action-secondary">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="19" y1="12" x2="5" y2="12"></line>
                                    <polyline points="12 19 5 12 12 5"></polyline>
                                </svg>
                                <span>Cancel &amp; Return</span>
                            </a>

                            <button type="button" class="btn-action-primary" onclick="switchStep(2)">
                                <span>Proceed to Step 2: Student Information</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- =========================================================================
                     STEP 2: VIEW ONLY STUDENT INFO
                     ========================================================================= -->
                <div id="step-panel-2" class="step-panel" style="display: none;">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <span>Step 2: Student Profile Verification (View-Only)</span>
                        </div>
                    </div>

                    <div class="card-body">
                        <p class="step-subtitle-desc">
                            Verify that your official university credentials are correct. Your verified electronic event pass will be securely generated under this matriculation record.
                        </p>

                        <div class="form-grid-2col">
                            <div class="form-group">
                                <label class="form-label">
                                    <span>Student ID Number</span>
                                    <span class="form-label-muted">Matriculation Code</span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="16" rx="2"></rect>
                                        <line x1="7" y1="8" x2="17" y2="8"></line>
                                        <line x1="7" y1="12" x2="13" y2="12"></line>
                                    </svg>
                                    <strong><asp:Literal ID="litProfileStudentId" runat="server" Text="24-1611" /></strong>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <span>Full Name</span>
                                    <span class="form-label-muted">Official University Record</span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                    <span><asp:Literal ID="litProfileFullName" runat="server" Text="--" /></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <span>Institutional Email Address</span>
                                    <span class="form-label-muted">University Account</span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                        <polyline points="22,6 12,13 2,6"></polyline>
                                    </svg>
                                    <span><asp:Literal ID="litProfileEmail" runat="server" Text="--" /></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <span>Campus / Branch</span>
                                    <span class="form-label-muted">Assigned Campus</span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                    </svg>
                                    <span><asp:Literal ID="litProfileCampus" runat="server" Text="--" /></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <span>Academic Department / College</span>
                                    <span class="form-label-muted">Division</span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                                    </svg>
                                    <span><asp:Literal ID="litProfileDepartment" runat="server" Text="--" /></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <span>Degree Program / Course</span>
                                    <span class="form-label-muted">Registered Curriculum</span>
                                </label>
                                <div class="form-control-display">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                    <span><asp:Literal ID="litProfileProgram" runat="server" Text="--" /></span>
                                </div>
                            </div>
                        </div>

                        <!-- University Sync Notice -->
                        <div class="info-notice-banner">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <div>
                                <strong>Official University Synchronization:</strong> These profile details are synchronized directly from your university registrar record. If any information is out of date, please contact the University Registrar's Office.
                            </div>
                        </div>

                        <!-- Step 2 Nav Footer -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(1)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="19" y1="12" x2="5" y2="12"></line>
                                    <polyline points="12 19 5 12 12 5"></polyline>
                                </svg>
                                <span>Back to Step 1: Core Information</span>
                            </button>

                            <button type="button" class="btn-action-primary" onclick="switchStep(3)">
                                <span>Proceed to Step 3: Year &amp; Section</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- =========================================================================
                     STEP 3: FILLING OF YEAR AND SECTION
                     ========================================================================= -->
                <div id="step-panel-3" class="step-panel" style="display: none;">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            </svg>
                            <span>Step 3: Academic Standing &amp; Final Confirmation</span>
                        </div>
                    </div>

                    <div class="card-body">
                        <p class="step-subtitle-desc">
                            Provide your current academic year level and class section to ensure accurate cohort auditing and entry pass validation.
                        </p>

                        <div class="form-grid-2col">
                            <div class="form-group">
                                <label class="form-label" for="<%= ddlYearLevel.ClientID %>">
                                    <span>Current Year Level <span class="req">*</span></span>
                                    <span class="form-label-muted">Academic Standing</span>
                                </label>
                                <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="1" Text="1st Year"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="2nd Year"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="3rd Year" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="4th Year"></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Irregular"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="<%= txtSection.ClientID %>">
                                    <span>Class Section <span class="req">*</span></span>
                                    <span class="form-label-muted">e.g. SBIT-3A, SBIT-3C</span>
                                </label>
                                <asp:TextBox ID="txtSection" runat="server" CssClass="form-input" MaxLength="50" placeholder="e.g. SBIT-3C"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Commitment & Terms Card -->
                        <div class="commitment-card">
                            <label class="commitment-checkbox-label" for="<%= chkTerms.ClientID %>">
                                <asp:CheckBox ID="chkTerms" runat="server" />
                                <span>I confirm that I will attend this event and agree to follow all official university event guidelines and campus health/safety protocols.</span>
                            </label>
                            <p style="font-size:0.78rem; color:var(--text-muted); margin-left: 28px;">
                                Note: Reserved seats that result in unexcused absences will be audited as No-Shows in accordance with the campus extracurricular attendance charter.
                            </p>
                        </div>

                        <!-- Step 3 Nav Footer -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(2)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="19" y1="12" x2="5" y2="12"></line>
                                    <polyline points="12 19 5 12 12 5"></polyline>
                                </svg>
                                <span>Back to Step 2: Student Information</span>
                            </button>

                            <asp:Button ID="btnConfirmRegistration" runat="server" 
                                CssClass="btn-action-primary" 
                                Text="Confirm & Complete Registration" 
                                OnClick="btnConfirmRegistration_Click" />
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </form>

    <!-- Client-side Stepper Switcher Script -->
    <script>
        function switchStep(step) {
            if (step < 1 || step > 3) return;

            // Update hidden field
            var hf = document.getElementById('<%= hfCurrentStep.ClientID %>');
            if (hf) {
                hf.value = step;
            }

            // Update panels & tabs
            for (var i = 1; i <= 3; i++) {
                var panel = document.getElementById('step-panel-' + i);
                var tab = document.getElementById('tab-step-' + i);

                if (panel) {
                    panel.style.display = (i === step) ? 'block' : 'none';
                }

                if (tab) {
                    tab.classList.remove('active', 'completed');
                    if (i === step) {
                        tab.classList.add('active');
                        tab.setAttribute('aria-selected', 'true');
                    } else if (i < step) {
                        tab.classList.add('completed');
                        tab.setAttribute('aria-selected', 'false');
                    } else {
                        tab.setAttribute('aria-selected', 'false');
                    }
                }
            }
        }

        // Initialize state based on server-rendered step value
        document.addEventListener('DOMContentLoaded', function () {
            var hf = document.getElementById('<%= hfCurrentStep.ClientID %>');
            var initialStep = (hf && parseInt(hf.value)) ? parseInt(hf.value) : 1;
            switchStep(initialStep);
        });
    </script>
</body>
</html>
