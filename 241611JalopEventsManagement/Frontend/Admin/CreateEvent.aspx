<%@ Page Title="Publish New Event | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreateEvent.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.CreateEvent" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/create-event.css") %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Active Step State Tracker -->
    <asp:HiddenField ID="hfActiveStep" runat="server" Value="1" />

    <!-- Breadcrumbs Global Trail -->
    <nav class="breadcrumb-nav" aria-label="Breadcrumb">
        <ol class="breadcrumb-list">
            <li class="breadcrumb-item">
                <a href="<%= ResolveUrl("~/Frontend/Admin/Dashboard.aspx") %>">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7" rx="1.5"></rect>
                        <rect x="14" y="3" width="7" height="7" rx="1.5"></rect>
                        <rect x="14" y="14" width="7" height="7" rx="1.5"></rect>
                        <rect x="3" y="14" width="7" height="7" rx="1.5"></rect>
                    </svg>
                    <span>Admin Console</span>
                </a>
            </li>
            <li class="breadcrumb-separator">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </li>
            <li class="breadcrumb-item">
                <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>">
                    <span>Campus Events Matrix</span>
                </a>
            </li>
            <li class="breadcrumb-separator">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                <span>Publish New Event</span>
            </li>
        </ol>
    </nav>

    <!-- Page Workspace Header -->
    <div class="page-header-row">
        <div class="header-title-block">
            <h2>Publish New Campus Event</h2>
            <!--<p>Complete the guided 4-step procedure to register specifications, schedules, audience criteria, and partner sponsors.</p>-->
        </div>
        <!--<div class="header-actions">
            <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="btn-action-secondary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                <span>Back to Events Matrix</span>
            </a>
            <asp:Button ID="btnPublishTop" runat="server" Text="Publish Event" CssClass="btn-action-primary" OnClick="btnPublishEvent_Click" />
        </div>-->
    </div>

    <!-- Step-by-Step Procedure Breadcrumb Tabs -->
    <div class="procedure-stepper-container" role="tablist" aria-label="Event Creation Procedure Steps">
        <!-- Step 1 Tab -->
        <div class="procedure-step-tab active" id="tab-step-1" data-step="1" onclick="switchStep(1)" role="tab" aria-selected="true">
            <div class="step-badge">1</div>
            <div class="step-meta">
                <span class="step-number">Step 01</span>
                <span class="step-name">Event Details</span>
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
                <span class="step-name">Schedule & Registration</span>
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
                <span class="step-name">Target Audience</span>
            </div>
        </div>

        <div class="step-separator">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="9 18 15 12 9 6"></polyline>
            </svg>
        </div>

        <!-- Step 4 Tab -->
        <div class="procedure-step-tab" id="tab-step-4" data-step="4" onclick="switchStep(4)" role="tab" aria-selected="false">
            <div class="step-badge">4</div>
            <div class="step-meta">
                <span class="step-number">Step 04</span>
                <span class="step-name">Sponsors</span>
            </div>
        </div>

        <div class="step-separator">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="9 18 15 12 9 6"></polyline>
            </svg>
        </div>

        <!-- Step 5 Tab -->
        <div class="procedure-step-tab" id="tab-step-5" data-step="5" onclick="switchStep(5)" role="tab" aria-selected="false">
            <div class="step-badge">5</div>
            <div class="step-meta">
                <span class="step-number">Step 05</span>
                <span class="step-name">Summary & Confirm</span>
            </div>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="feedback-alert alert-success">
        <div>
            <asp:Literal ID="litSuccessMsg" runat="server" />
        </div>
        <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" style="color: #065f46; font-weight:700; text-decoration:underline;">View in Matrix &rarr;</a>
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="feedback-alert alert-error">
        <div>
            <asp:Literal ID="litErrorMsg" runat="server" />
        </div>
    </asp:Panel>

    <!-- Main Two-Column Layout -->
    <div class="create-form-layout">
        <!-- Left Column: Step Panels -->
        <div>
            <!-- STEP 1: Event Details -->
            <div id="step-panel-1" class="step-panel active-panel">
                <div class="form-section-card">
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label" for="<%= txtTitle.ClientID %>">Event Title <span class="required-mark">*</span></label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-input" placeholder="e.g. Annual University Tech Symposium 2026" MaxLength="200" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                        <!--<span class="form-hint">A clear, descriptive title visible across student portals and institutional calendars.</span>-->
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="<%= txtDescription.ClientID %>">Event Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" CssClass="form-textarea" placeholder="Detail the event objectives, keynote topics, speaker profiles, or student prerequisites..." />
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtVenueLocation.ClientID %>">Venue Location <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtVenueLocation" runat="server" CssClass="form-input" placeholder="e.g. Central Auditorium, Hall A" MaxLength="200" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                            <!--<span class="form-hint">Physical room, auditorium, or laboratory venue.</span>-->
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="<%= txtMaxCapacity.ClientID %>">Max Capacity (Seats) <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtMaxCapacity" runat="server" TextMode="Number" CssClass="form-input" Text="150" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                <!--<span class="form-hint">Enforces strict atomic concurrency lock against overbooking.</span>-->
                            </div>
                        </div>

                        <div class="form-group" style="margin-top: 0.5rem;">
                            <label class="form-label" for="<%= fuEventPhoto.ClientID %>">Event Promotional Banner / Poster Image</label>
                            <asp:FileUpload ID="fuEventPhoto" runat="server" CssClass="form-input" accept="image/*" />
                            <span class="form-hint" style="font-size:0.75rem; color:var(--text-muted); margin-top:0.25rem; display:block;">Optional. Supported formats: PNG, JPG, JPEG, WEBP. Uploaded asset is stored persistently in the dedicated assets folder.</span>
                        </div>

                        <!-- Step 1 Footer Navigation -->
                        <div class="step-nav-footer">
                            <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="btn-action-secondary">
                                Cancel & Discard
                            </a>
                            <button type="button" class="btn-action-primary" onclick="validateAndGoStep(2)">
                                <span>Schedule & Timeline</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 2 PANEL: Schedule & Timeline -->
            <div id="step-panel-2" class="step-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>Step 2: Schedule & Registration Timeline</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">2 of 5</span>
                    </div>
                    <div class="card-body">
                        <div class="info-callout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span><strong>Policy Directive:</strong> Events take place on a designated calendar date. Registration period must conclude before or at event kickoff.</span>
                        </div>

                        <!-- Single Event Date Picker -->
                        <div class="form-group">
                            <label class="form-label" for="<%= txtEventDate.ClientID %>">Event Date <span class="required-mark">*</span></label>
                            <asp:TextBox ID="txtEventDate" runat="server" TextMode="Date" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                            <span class="form-hint">The single designated calendar date on which the event takes place.</span>
                        </div>

                        <!-- Start and End Time Pickers -->
                        <div class="form-grid-2" style="margin-top: 1rem;">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtEventStartTime.ClientID %>">Event Start Time <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtEventStartTime" runat="server" TextMode="Time" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                <span class="form-hint">Kickoff time (e.g. 09:00)</span>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtEventEndTime.ClientID %>">Event End Time <span class="required-mark">*</span></label>
                                <asp:TextBox ID="txtEventEndTime" runat="server" TextMode="Time" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                <span class="form-hint">Conclusion time (e.g. 17:00)</span>
                            </div>
                        </div>

                        <!-- Registration Availability Window -->
                        <div style="margin-top: 1.25rem; padding-top: 1.15rem; border-top: 1px dashed var(--border-subtle);">
                            <label class="form-label" style="font-size:0.8rem; color:var(--brand-primary); margin-bottom:0.75rem;">
                                Registration Availability Window
                            </label>
                            <div class="form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtRegStart.ClientID %>">Registration Open Date & Time <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtRegStart" runat="server" TextMode="DateTimeLocal" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtRegEnd.ClientID %>">Registration Deadline <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtRegEnd" runat="server" TextMode="DateTimeLocal" CssClass="form-input" AutoPostBack="true" OnTextChanged="FormField_Changed" />
                                </div>
                            </div>
                        </div>

                        <!-- Step 2 Footer Navigation -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(1)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                <span>Event Details</span>
                            </button>
                            <button type="button" class="btn-action-primary" onclick="validateAndGoStep(3)">
                                <span>Target Audience</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 3 PANEL: 4-Tier Audience Targeting -->
            <div id="step-panel-3" class="step-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>Step 3: Target Audience</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">3 of 5</span>
                    </div>
                    <div class="card-body">
                        <div class="info-callout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span>Leaving dimensions as <em>"All / Open to All"</em> grants access to the entire student body. Specific selections enforce cohort-based eligibility filtering.</span>
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label" for="<%= ddlBranch.ClientID %>">1. Campus Branch</label>
                                <asp:DropDownList ID="ddlBranch" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FormField_Changed">
                                    <asp:ListItem Value="" Text="All University Branches (Open)" />
                                    <asp:ListItem Value="San Bartolome" Text="San Bartolome (Main Campus)" />
                                    <asp:ListItem Value="Batasan" Text="Batasan Campus" />
                                    <asp:ListItem Value="San Francisco" Text="San Francisco Campus" />
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="<%= ddlDepartment.ClientID %>">2. Academic College / Department</label>
                                <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select" onchange="filterProgramsByDepartment(this.value);" AutoPostBack="true" OnSelectedIndexChanged="FormField_Changed">
                                    <asp:ListItem Value="" Text="All Colleges / Open to All" />
                                    <asp:ListItem Value="College of Computer Studies" Text="College of Computer Studies (CCS)" />
                                    <asp:ListItem Value="College of Engineering" Text="College of Engineering (COE)" />
                                    <asp:ListItem Value="College of Business Administration and Accountancy" Text="College of Business Administration and Accountancy (CBAA)" />
                                    <asp:ListItem Value="College of Education" Text="College of Education (CED)" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- Multi-Select Academic Degree Programs / Courses -->
                        <div class="form-group" style="margin-top: 1.25rem;">
                            <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:0.4rem; flex-wrap:wrap; gap:0.5rem;">
                                <label class="form-label" style="margin-bottom:0;">
                                    3. Academic Degree Programs / Courses (Multi-Select)
                                </label>
                                <div style="display:flex; gap:0.4rem;">
                                    <button type="button" class="btn-micro" onclick="selectAllPrograms(true)">Select All</button>
                                    <button type="button" class="btn-micro" onclick="selectAllPrograms(false)">Clear (Open to All)</button>
                                </div>
                            </div>
                            <span class="form-hint" style="margin-bottom:0.6rem;">Leave all unchecked to keep open to all programs. Select one or more specific courses to restrict eligibility. Dynamic according to Academic College / Department.</span>
                            
                            <div class="course-picker-grid" id="coursePickerGrid">
                                <!-- College of Computer Studies (CCS) -->
                                <label class="course-picker-card" id="card_BSIT" data-dept="College of Computer Studies">
                                    <input type="checkbox" name="courseFilter" value="BSIT" id="chk_BSIT" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSIT</span>
                                        <span class="course-name">BS Information Technology</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSCS" data-dept="College of Computer Studies">
                                    <input type="checkbox" name="courseFilter" value="BSCS" id="chk_BSCS" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSCS</span>
                                        <span class="course-name">BS Computer Science</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSIS" data-dept="College of Computer Studies">
                                    <input type="checkbox" name="courseFilter" value="BSIS" id="chk_BSIS" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSIS</span>
                                        <span class="course-name">BS Information Systems</span>
                                    </div>
                                </label>

                                <!-- College of Engineering (COE) -->
                                <label class="course-picker-card" id="card_BSIE" data-dept="College of Engineering">
                                    <input type="checkbox" name="courseFilter" value="BSIE" id="chk_BSIE" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSIE</span>
                                        <span class="course-name">BS Industrial Engineering</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSCpE" data-dept="College of Engineering">
                                    <input type="checkbox" name="courseFilter" value="BSCpE" id="chk_BSCpE" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSCpE</span>
                                        <span class="course-name">BS Computer Engineering</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSECE" data-dept="College of Engineering">
                                    <input type="checkbox" name="courseFilter" value="BSECE" id="chk_BSECE" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSECE</span>
                                        <span class="course-name">BS Electronics Engineering</span>
                                    </div>
                                </label>

                                <!-- College of Business Administration and Accountancy (CBAA) -->
                                <label class="course-picker-card" id="card_BSA" data-dept="College of Business Administration and Accountancy">
                                    <input type="checkbox" name="courseFilter" value="BSA" id="chk_BSA" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSA</span>
                                        <span class="course-name">BS Accountancy</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSBA" data-dept="College of Business Administration and Accountancy">
                                    <input type="checkbox" name="courseFilter" value="BSBA" id="chk_BSBA" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSBA</span>
                                        <span class="course-name">BS Business Administration</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSEntrep" data-dept="College of Business Administration and Accountancy">
                                    <input type="checkbox" name="courseFilter" value="BSEntrep" id="chk_BSEntrep" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSEntrep</span>
                                        <span class="course-name">BS Entrepreneurship</span>
                                    </div>
                                </label>

                                <!-- College of Education (CED) -->
                                <label class="course-picker-card" id="card_BECEd" data-dept="College of Education">
                                    <input type="checkbox" name="courseFilter" value="BECEd" id="chk_BECEd" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BECEd</span>
                                        <span class="course-name">Bachelor of Early Childhood Education</span>
                                    </div>
                                </label>
                                <label class="course-picker-card" id="card_BSEd" data-dept="College of Education">
                                    <input type="checkbox" name="courseFilter" value="BSEd" id="chk_BSEd" onchange="onCourseSelectionChanged()" />
                                    <div class="course-picker-info">
                                        <span class="course-code">BSEd</span>
                                        <span class="course-name">BS Secondary Education</span>
                                    </div>
                                </label>
                            </div>
                            <asp:HiddenField ID="hfSelectedPrograms" runat="server" Value="" />
                        </div>

                        <!-- Year Level Selection -->
                        <div class="form-group" style="margin-top: 1.25rem;">
                            <label class="form-label" for="<%= ddlYearLevel.ClientID %>">4. Year Level Eligibility</label>
                            <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FormField_Changed" style="max-width:320px;">
                                <asp:ListItem Value="" Text="All Year Levels (1st - 4th)" />
                                <asp:ListItem Value="1" Text="1st Year Students Only" />
                                <asp:ListItem Value="2" Text="2nd Year Students Only" />
                                <asp:ListItem Value="3" Text="3rd Year Students Only" />
                                <asp:ListItem Value="4" Text="4th Year Graduating Seniors Only" />
                            </asp:DropDownList>
                        </div>

                        <!-- Step 3 Footer Navigation -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(2)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                <span>Schedule</span>
                            </button>
                            <button type="button" class="btn-action-primary" onclick="validateAndGoStep(4)">
                                <span>Sponsors</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 4 PANEL: Multi-Sponsor Associations -->
            <div id="step-panel-4" class="step-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>Step 4: Multi-Sponsor Associations</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">4 of 5</span>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label">Attach Corporate & Institutional Partners</label>
                            <div class="sponsor-input-row">
                                <asp:TextBox ID="txtNewSponsor" runat="server" CssClass="form-input" placeholder="Enter sponsor or partner organization name..." />
                                <asp:Button ID="btnAddSponsor" runat="server" Text="Add Sponsor" CssClass="btn-action-secondary" OnClick="btnAddSponsor_Click" CausesValidation="false" />
                            </div>
                        </div>

                        <!-- Active Sponsor Chips Container -->
                        <div class="sponsor-chips-container">
                            <asp:Repeater ID="rptSponsors" runat="server" OnItemCommand="rptSponsors_ItemCommand">
                                <ItemTemplate>
                                    <span class="sponsor-chip">
                                        <span><%# Container.DataItem %></span>
                                        <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn-remove-chip" CommandName="Remove" CommandArgument='<%# Container.DataItem %>' CausesValidation="false" ToolTip="Remove Sponsor">&times;</asp:LinkButton>
                                    </span>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Literal ID="litNoSponsorsHint" runat="server" Text="<span style='color:#94a3b8; font-size:0.75rem; font-style:italic;'>No sponsors attached yet. Type above or click quick presets below.</span>" />
                        </div>

                        <!-- Quick Add Preset Suggestions -->
                        <div class="form-group">
                            <span class="form-label" style="font-size:0.72rem; color:var(--text-muted); text-transform:uppercase;">Quick Partner Presets</span>
                            <div class="preset-sponsors-row">
                                <asp:LinkButton ID="btnPreset1" runat="server" CssClass="btn-preset-sponsor" Text="+ QCU Alumni Association" OnClick="PresetSponsor_Click" CommandArgument="QCU Alumni Association" CausesValidation="false" />
                                <asp:LinkButton ID="btnPreset2" runat="server" CssClass="btn-preset-sponsor" Text="+ DOST-NCR" OnClick="PresetSponsor_Click" CommandArgument="DOST-NCR" CausesValidation="false" />
                                <asp:LinkButton ID="btnPreset3" runat="server" CssClass="btn-preset-sponsor" Text="+ AWS Educate" OnClick="PresetSponsor_Click" CommandArgument="AWS Educate" CausesValidation="false" />
                                <asp:LinkButton ID="btnPreset4" runat="server" CssClass="btn-preset-sponsor" Text="+ Google Developer Student Clubs" OnClick="PresetSponsor_Click" CommandArgument="Google Developer Student Clubs" CausesValidation="false" />
                                <asp:LinkButton ID="btnPreset5" runat="server" CssClass="btn-preset-sponsor" Text="+ Microsoft Learn" OnClick="PresetSponsor_Click" CommandArgument="Microsoft Learn" CausesValidation="false" />
                            </div>
                        </div>

                        <!-- Pre-Publication Checklist -->
                        <div class="review-checklist-card">
                            <div class="review-checklist-title">Pre-Publication Readiness Verification</div>
                            <div class="checklist-item">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Core specifications and seat capacity allocated</span>
                            </div>
                            <div class="checklist-item">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Event single date, start time, and end time verified</span>
                            </div>
                            <div class="checklist-item">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Audience demographic and multi-course eligibility mapped</span>
                            </div>
                            <div class="checklist-item">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Partner sponsorship branding verified for event header</span>
                            </div>
                        </div>

                        <!-- Step 4 Footer Navigation -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(3)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                <span>Target Audience</span>
                            </button>
                            <button type="button" class="btn-action-primary" onclick="validateAndGoStep(5)">
                                <span>Summary & Confirmation</span>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 5 PANEL: Summary & Final Confirmation -->
            <div id="step-panel-5" class="step-panel">
                <div class="form-section-card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>Step 5: Event Summary & Confirmation</span>
                        </div>
                        <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">5 of 5</span>
                    </div>
                    <div class="card-body">
                        <div class="info-callout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span>Please review all event specifications below carefully before publishing. Clicking <strong>Confirm &amp; Publish Event</strong> will register this event into the database and make it live in the matrix.</span>
                        </div>

                        <!-- Summary Review Container -->
                        <div class="summary-container">
                            <!-- 1. Core Specifications Summary -->
                            <div class="summary-section-box">
                                <div class="summary-section-title">
                                    
                                    <span>Event Details</span>
                                </div>
                                <div class="summary-grid">
                                    <div class="summary-item full-width">
                                        <span class="summary-label">Event Title</span>
                                        <span id="sumTitle" class="summary-value" style="font-size:1.05rem; font-weight:800; color:var(--brand-primary);">-</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Venue Location</span>
                                        <span id="sumVenue" class="summary-value">-</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Max Seat Capacity</span>
                                        <span id="sumCapacity" class="summary-value highlight">-</span>
                                    </div>
                                    <div class="summary-item full-width">
                                        <span class="summary-label">Event Description</span>
                                        <div id="sumDesc" class="summary-value" style="font-size:0.8rem; font-weight:400; color:var(--text-body); white-space:pre-wrap;">-</div>
                                    </div>
                                </div>
                            </div>

                            <!-- 2. Schedule & Timeline Summary -->
                            <div class="summary-section-box">
                                <div class="summary-section-title">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                    <span>Schedule &amp; Registration</span>
                                </div>
                                <div class="summary-schedule-split">
                                    <!-- Left side: Date at top, Time below -->
                                    <div class="summary-schedule-left">
                                        <div class="summary-item">
                                            <span class="summary-label">Designated Event Date</span>
                                            <span id="sumEventDate" class="summary-value highlight">-</span>
                                        </div>
                                        <div class="summary-item">
                                            <span class="summary-label">Event Time Window</span>
                                            <span id="sumEventHours" class="summary-value highlight">-</span>
                                        </div>
                                    </div>
                                    <!-- Right side: Registration Availability Window -->
                                    <div class="summary-schedule-right">
                                        <span class="summary-label">Registration Availability Window</span>
                                        <div class="reg-window-card">
                                            <div class="reg-window-row">
                                                <span class="reg-window-tag opens">OPENS</span>
                                                <span id="sumRegOpen" class="reg-window-val">-</span>
                                            </div>
                                            <div class="reg-window-row">
                                                <span class="reg-window-tag deadline">DEADLINE</span>
                                                <span id="sumRegDeadline" class="reg-window-val">-</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 3. Demographic Targeting Summary -->
                            <div class="summary-section-box">
                                <div class="summary-section-title">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                    <span>Target Audience</span>
                                </div>
                                <div class="summary-grid">
                                    <div class="summary-item">
                                        <span class="summary-label">Campus Branch</span>
                                        <span id="sumBranch" class="summary-value">-</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Academic College</span>
                                        <span id="sumDept" class="summary-value">-</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Year Level</span>
                                        <span id="sumYearLevel" class="summary-value">-</span>
                                    </div>
                                    <div class="summary-item full-width">
                                        <span class="summary-label">Target Degree Programs / Courses</span>
                                        <div id="sumPrograms" class="summary-chips-wrap"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- 4. Sponsor Associations Summary -->
                            <div class="summary-section-box">
                                <div class="summary-section-title">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path></svg>
                                    <span>Partner &amp; Sponsor Associations</span>
                                </div>
                                <div id="sumSponsors" class="summary-chips-wrap"></div>
                            </div>

                            <!-- Policy Confirmation Callout -->
                            <div class="summary-confirm-callout">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                <div class="summary-confirm-text">
                                    <h4>Final Confirmation Required</h4>
                                    <p>By publishing, you confirm that all specifications, reservation limits, and eligibility cohorts comply with university event policies.</p>
                                </div>
                            </div>
                        </div>

                        <!-- Step 5 Footer Navigation -->
                        <div class="step-nav-footer">
                            <button type="button" class="btn-action-secondary" onclick="switchStep(4)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                <span>Sponsors</span>
                            </button>
                            <asp:Button ID="btnConfirmPublish" runat="server" Text="Confirm & Publish Event" CssClass="btn-action-primary" OnClick="btnPublishEvent_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Stepper Tab Controller Script -->
    <script type="text/javascript">
        function switchStep(stepNumber) {
            stepNumber = parseInt(stepNumber);
            if (isNaN(stepNumber) || stepNumber < 1 || stepNumber > 5) stepNumber = 1;

            // 1. Update Step Panels
            for (var i = 1; i <= 5; i++) {
                var panel = document.getElementById('step-panel-' + i);
                if (panel) {
                    if (i === stepNumber) {
                        panel.classList.add('active-panel');
                    } else {
                        panel.classList.remove('active-panel');
                    }
                }
            }

            // 2. Update Breadcrumb Tabs
            for (var s = 1; s <= 5; s++) {
                var tab = document.getElementById('tab-step-' + s);
                if (tab) {
                    tab.classList.remove('active', 'completed');
                    if (s === stepNumber) {
                        tab.classList.add('active');
                        tab.setAttribute('aria-selected', 'true');
                    } else if (s < stepNumber) {
                        tab.classList.add('completed');
                        tab.setAttribute('aria-selected', 'false');
                    } else {
                        tab.setAttribute('aria-selected', 'false');
                    }
                }
            }

            // 3. Persist active step in hidden field for postbacks
            var hf = document.getElementById('<%= hfActiveStep.ClientID %>');
            if (hf) {
                hf.value = stepNumber;
            }

            // 4. If switching to Step 5, populate all summary fields
            if (stepNumber === 5) {
                populateSummary();
            }
        }

        function validateAndGoStep(targetStep) {
            // Validate Step 1 if moving forward past Step 1
            if (targetStep > 1) {
                var title = document.getElementById('<%= txtTitle.ClientID %>');
                var venue = document.getElementById('<%= txtVenueLocation.ClientID %>');
                var cap = document.getElementById('<%= txtMaxCapacity.ClientID %>');

                if (title && !title.value.trim()) {
                    alert('Please enter the Event Title before proceeding.');
                    switchStep(1);
                    title.focus();
                    return;
                }
                if (venue && !venue.value.trim()) {
                    alert('Please specify the Venue / Room Location.');
                    switchStep(1);
                    venue.focus();
                    return;
                }
                if (cap && (!cap.value.trim() || parseInt(cap.value) <= 0)) {
                    alert('Please enter a valid seat capacity greater than 0.');
                    switchStep(1);
                    cap.focus();
                    return;
                }
            }

            // Validate Step 2 if moving forward past Step 2
            if (targetStep > 2) {
                var evDate = document.getElementById('<%= txtEventDate.ClientID %>');
                var startTime = document.getElementById('<%= txtEventStartTime.ClientID %>');
                var endTime = document.getElementById('<%= txtEventEndTime.ClientID %>');
                var regStart = document.getElementById('<%= txtRegStart.ClientID %>');
                var regEnd = document.getElementById('<%= txtRegEnd.ClientID %>');

                if (evDate && !evDate.value) {
                    alert('Please select the Event Date.');
                    switchStep(2);
                    evDate.focus();
                    return;
                }
                if (startTime && !startTime.value) {
                    alert('Please specify the Event Start Time.');
                    switchStep(2);
                    startTime.focus();
                    return;
                }
                if (endTime && !endTime.value) {
                    alert('Please specify the Event End Time.');
                    switchStep(2);
                    endTime.focus();
                    return;
                }
                if (startTime && endTime && startTime.value >= endTime.value) {
                    alert('Event Start Time must be earlier than Event End Time.');
                    switchStep(2);
                    startTime.focus();
                    return;
                }
                if (regStart && !regStart.value) {
                    alert('Please specify the Registration Opening Date & Time.');
                    switchStep(2);
                    regStart.focus();
                    return;
                }
                if (regEnd && !regEnd.value) {
                    alert('Please specify the Registration Deadline.');
                    switchStep(2);
                    regEnd.focus();
                    return;
                }
                if (regStart && regEnd && new Date(regStart.value) >= new Date(regEnd.value)) {
                    alert('Registration Open Date & Time must be earlier than Registration Deadline.');
                    switchStep(2);
                    regStart.focus();
                    return;
                }
                if (regEnd && evDate && startTime) {
                    var kickoff = new Date(evDate.value + 'T' + startTime.value);
                    var deadline = new Date(regEnd.value);
                    if (deadline > kickoff) {
                        alert('Registration Deadline must conclude before or at the Event Kickoff time.');
                        switchStep(2);
                        regEnd.focus();
                        return;
                    }
                }
            }

            switchStep(targetStep);
        }

        // ─── Multi-Course Selection Helpers ───
        function onCourseSelectionChanged() {
            var checkboxes = document.querySelectorAll('input[name="courseFilter"]');
            var selected = [];
            checkboxes.forEach(function (cb) {
                var card = document.getElementById('card_' + cb.value);
                if (cb.checked && card && card.style.display !== 'none') {
                    selected.push(cb.value);
                    card.classList.add('selected');
                } else {
                    if (card) card.classList.remove('selected');
                }
            });

            var hf = document.getElementById('<%= hfSelectedPrograms.ClientID %>');
            if (hf) {
                hf.value = selected.join(', ');
            }
        }

        function filterProgramsByDepartment(dept) {
            var cards = document.querySelectorAll('.course-picker-card');
            cards.forEach(function (card) {
                var cardDept = card.getAttribute('data-dept');
                if (!dept || cardDept === dept) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                    var cb = card.querySelector('input[name="courseFilter"]');
                    if (cb && cb.checked) {
                        cb.checked = false;
                        card.classList.remove('selected');
                    }
                }
            });
            onCourseSelectionChanged();
        }

        function selectAllPrograms(selectAll) {
            var cards = document.querySelectorAll('.course-picker-card');
            cards.forEach(function (card) {
                if (card.style.display !== 'none') {
                    var cb = card.querySelector('input[name="courseFilter"]');
                    if (cb) cb.checked = selectAll;
                }
            });
            onCourseSelectionChanged();
        }

        function restoreCourseSelection() {
            var deptDdl = document.getElementById('<%= ddlDepartment.ClientID %>');
            if (deptDdl) {
                filterProgramsByDepartment(deptDdl.value);
            }
            var hf = document.getElementById('<%= hfSelectedPrograms.ClientID %>');
            if (hf && hf.value) {
                var selected = hf.value.split(',').map(function (s) { return s.trim(); });
                var checkboxes = document.querySelectorAll('input[name="courseFilter"]');
                checkboxes.forEach(function (cb) {
                    var match = selected.indexOf(cb.value) !== -1;
                    cb.checked = match;
                    var card = document.getElementById('card_' + cb.value);
                    if (card) {
                        if (match && card.style.display !== 'none') card.classList.add('selected');
                        else card.classList.remove('selected');
                    }
                });
            }
        }

        // ─── Step 5 Live Summary Generation ───
        function formatDateTimePretty(isoStr) {
            if (!isoStr) return '-';
            var d = new Date(isoStr);
            if (isNaN(d.getTime())) return isoStr;
            var mm = ('0' + (d.getMonth() + 1)).slice(-2);
            var dd = ('0' + d.getDate()).slice(-2);
            var yyyy = d.getFullYear();
            var time = d.toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });
            return mm + '/' + dd + '/' + yyyy + ' ' + time;
        }

        function formatDateOnlyPretty(dateStr) {
            if (!dateStr) return '-';
            var parts = dateStr.split('-');
            if (parts.length === 3) {
                var mm = ('0' + parts[1]).slice(-2);
                var dd = ('0' + parts[2]).slice(-2);
                var yyyy = parts[0];
                return mm + '/' + dd + '/' + yyyy;
            }
            return dateStr;
        }

        function formatTime12h(timeStr) {
            if (!timeStr) return '';
            var parts = timeStr.split(':');
            if (parts.length >= 2) {
                var h = parseInt(parts[0]);
                var m = parts[1];
                var ampm = h >= 12 ? 'PM' : 'AM';
                h = h % 12;
                if (h === 0) h = 12;
                return (h < 10 ? '0' + h : h) + ':' + m + ' ' + ampm;
            }
            return timeStr;
        }

        function calculateGatesOpenTime(timeStr) {
            if (!timeStr) return '08:15 AM';
            var parts = timeStr.split(':');
            if (parts.length >= 2) {
                var h = parseInt(parts[0], 10);
                var m = parseInt(parts[1], 10);
                var totalMin = (h * 60 + m) - 45;
                if (totalMin < 0) totalMin += 24 * 60;
                var gh = Math.floor(totalMin / 60);
                var gm = totalMin % 60;
                var gAmpm = gh >= 12 ? 'PM' : 'AM';
                gh = gh % 12;
                if (gh === 0) gh = 12;
                return (gh < 10 ? '0' + gh : gh) + ':' + (gm < 10 ? '0' + gm : gm) + ' ' + gAmpm;
            }
            return '08:15 AM';
        }

        function updateTicketPreview() {
            var title = document.getElementById('<%= txtTitle.ClientID %>');
            var venue = document.getElementById('<%= txtVenueLocation.ClientID %>');
            var evDate = document.getElementById('<%= txtEventDate.ClientID %>');
            var startTime = document.getElementById('<%= txtEventStartTime.ClientID %>');
            var endTime = document.getElementById('<%= txtEventEndTime.ClientID %>');
            var hfProg = document.getElementById('<%= hfSelectedPrograms.ClientID %>');

            var ticketTitle = document.getElementById('ticketEventTitle');
            var ticketDate = document.getElementById('ticketEventDate');
            var ticketTime = document.getElementById('ticketEventTime');
            var ticketVenue = document.getElementById('ticketEventVenue');
            var ticketProgram = document.getElementById('ticketAttendeeProgram');

            if (ticketTitle) {
                ticketTitle.innerText = (title && title.value.trim()) ? title.value.trim() : 'Event Title Preview';
            }
            if (ticketVenue) {
                ticketVenue.innerText = (venue && venue.value.trim()) ? venue.value.trim() : 'University Grand Auditorium';
            }
            if (ticketDate) {
                ticketDate.innerText = (evDate && evDate.value) ? formatDateOnlyPretty(evDate.value) : '10/28/2026';
            }
            if (ticketTime) {
                var sTime = (startTime && startTime.value) ? formatTime12h(startTime.value) : '09:00 AM';
                var eTime = (endTime && endTime.value) ? formatTime12h(endTime.value) : '04:00 PM';
                var gates = (startTime && startTime.value) ? calculateGatesOpenTime(startTime.value) : '08:15 AM';
                ticketTime.innerText = sTime + ' - ' + eTime + ' (Gates Open: ' + gates + ')';
            }
            if (ticketProgram) {
                var prog = (hfProg && hfProg.value.trim()) ? hfProg.value.trim() : 'BS Information Technology (SBIT3C)';
                ticketProgram.innerText = prog;
            }
        }

        function populateSummary() {
            // Core Specs
            var title = document.getElementById('<%= txtTitle.ClientID %>');
            var venue = document.getElementById('<%= txtVenueLocation.ClientID %>');
            var cap = document.getElementById('<%= txtMaxCapacity.ClientID %>');
            var desc = document.getElementById('<%= txtDescription.ClientID %>');

            var sumTitle = document.getElementById('sumTitle');
            var sumVenue = document.getElementById('sumVenue');
            var sumCapacity = document.getElementById('sumCapacity');
            var sumDesc = document.getElementById('sumDesc');

            if (sumTitle) sumTitle.innerText = (title && title.value.trim()) ? title.value.trim() : 'Untitled Event';
            if (sumVenue) sumVenue.innerText = (venue && venue.value.trim()) ? venue.value.trim() : 'Location TBD';
            if (sumCapacity) sumCapacity.innerText = (cap && cap.value) ? (cap.value + ' Seats allocated') : '150 Seats allocated';
            if (sumDesc) sumDesc.innerText = (desc && desc.value.trim()) ? desc.value.trim() : '(No description provided)';

            // Schedule & Timeline
            var evDate = document.getElementById('<%= txtEventDate.ClientID %>');
            var startTime = document.getElementById('<%= txtEventStartTime.ClientID %>');
            var endTime = document.getElementById('<%= txtEventEndTime.ClientID %>');
            var regStart = document.getElementById('<%= txtRegStart.ClientID %>');
            var regEnd = document.getElementById('<%= txtRegEnd.ClientID %>');

            var sumEventDate = document.getElementById('sumEventDate');
            var sumEventHours = document.getElementById('sumEventHours');
            var sumRegOpen = document.getElementById('sumRegOpen');
            var sumRegDeadline = document.getElementById('sumRegDeadline');

            if (sumEventDate) {
                sumEventDate.innerText = (evDate && evDate.value) ? formatDateOnlyPretty(evDate.value) : '-';
            }
            if (sumEventHours) {
                var sFormatted = startTime ? formatTime12h(startTime.value) : '';
                var eFormatted = endTime ? formatTime12h(endTime.value) : '';
                sumEventHours.innerText = (sFormatted && eFormatted) ? (sFormatted + ' — ' + eFormatted) : '-';
            }
            if (sumRegOpen) {
                sumRegOpen.innerText = (regStart && regStart.value) ? formatDateTimePretty(regStart.value) : '-';
            }
            if (sumRegDeadline) {
                sumRegDeadline.innerText = (regEnd && regEnd.value) ? formatDateTimePretty(regEnd.value) : '-';
            }

            // Audience Eligibility
            var branch = document.getElementById('<%= ddlBranch.ClientID %>');
            var dept = document.getElementById('<%= ddlDepartment.ClientID %>');
            var yl = document.getElementById('<%= ddlYearLevel.ClientID %>');
            var hfProg = document.getElementById('<%= hfSelectedPrograms.ClientID %>');

            var sumBranch = document.getElementById('sumBranch');
            var sumDept = document.getElementById('sumDept');
            var sumYearLevel = document.getElementById('sumYearLevel');
            var sumPrograms = document.getElementById('sumPrograms');

            if (sumBranch) {
                sumBranch.innerText = (branch && branch.selectedIndex > 0) ? branch.options[branch.selectedIndex].text : 'All University Branches (Open)';
            }
            if (sumDept) {
                sumDept.innerText = (dept && dept.selectedIndex > 0) ? dept.options[dept.selectedIndex].text : 'All Colleges / Open to All';
            }
            if (sumYearLevel) {
                sumYearLevel.innerText = (yl && yl.selectedIndex > 0) ? yl.options[yl.selectedIndex].text : 'All Year Levels (1st - 4th)';
            }

            if (sumPrograms) {
                sumPrograms.innerHTML = '';
                var progStr = hfProg ? hfProg.value.trim() : '';
                if (progStr) {
                    var list = progStr.split(',').map(function (s) { return s.trim(); });
                    list.forEach(function (code) {
                        var chip = document.createElement('span');
                        chip.className = 'summary-chip-badge';
                        chip.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg> ' + code;
                        sumPrograms.appendChild(chip);
                    });
                } else {
                    sumPrograms.innerHTML = '<span style="color:#64748b; font-size:0.8rem; font-style:italic;">All Academic Programs (Open to all majors)</span>';
                }
            }

            // Sponsors Summary (No star icon)
            var sumSponsors = document.getElementById('sumSponsors');
            if (sumSponsors) {
                sumSponsors.innerHTML = '';
                var sponsorChips = document.querySelectorAll('.sponsor-chip span');
                if (sponsorChips && sponsorChips.length > 0) {
                    sponsorChips.forEach(function (s) {
                        var chip = document.createElement('span');
                        chip.className = 'summary-chip-badge';
                        chip.innerText = s.innerText;
                        sumSponsors.appendChild(chip);
                    });
                } else {
                    sumSponsors.innerHTML = '<span style="color:#64748b; font-size:0.8rem; font-style:italic;">No external partner sponsors attached (Institutional event).</span>';
                }
            }

            // Also keep ticket preview in sync
            updateTicketPreview();
        }

        function initLiveTicketListeners() {
            var inputs = [
                document.getElementById('<%= txtTitle.ClientID %>'),
                document.getElementById('<%= txtVenueLocation.ClientID %>'),
                document.getElementById('<%= txtEventDate.ClientID %>'),
                document.getElementById('<%= txtEventStartTime.ClientID %>'),
                document.getElementById('<%= txtEventEndTime.ClientID %>')
            ];

            inputs.forEach(function (el) {
                if (el) {
                    el.addEventListener('input', updateTicketPreview);
                    el.addEventListener('change', updateTicketPreview);
                    el.addEventListener('keyup', updateTicketPreview);
                }
            });
        }

        // Initialize state on page load
        document.addEventListener('DOMContentLoaded', function () {
            restoreCourseSelection();
            initLiveTicketListeners();
            updateTicketPreview();
            var hf = document.getElementById('<%= hfActiveStep.ClientID %>');
            var initialStep = (hf && hf.value) ? parseInt(hf.value) : 1;
            switchStep(initialStep);
        });

        // Re-apply step state, ticket preview, and course selections after partial or full postback
        if (typeof (Sys) !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                restoreCourseSelection();
                initLiveTicketListeners();
                updateTicketPreview();
                var hf = document.getElementById('<%= hfActiveStep.ClientID %>');
                var initialStep = (hf && hf.value) ? parseInt(hf.value) : 1;
                switchStep(initialStep);
            });
        }
    </script>
</asp:Content>
