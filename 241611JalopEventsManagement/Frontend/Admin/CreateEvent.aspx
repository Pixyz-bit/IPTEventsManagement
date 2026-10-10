<%@ Page Title="Publish New Event | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreateEvent.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.CreateEvent" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/create-event.css?v=" + DateTime.Now.Ticks) %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Active Step State Tracker -->
    <asp:HiddenField ID="hfActiveStep" runat="server" Value="1" />

    <!-- Breadcrumbs Global Trail -->
    <nav class="breadcrumb-nav" aria-label="Breadcrumb">
        <ol class="breadcrumb-list">
            <li class="breadcrumb-item">
                <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>">
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
        </div>
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
        <div class="procedure-step-tab" id="tab-step-2" data-step="2" onclick="validateAndGoStep(2)" role="tab" aria-selected="false">
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
        <div class="procedure-step-tab" id="tab-step-3" data-step="3" onclick="validateAndGoStep(3)" role="tab" aria-selected="false">
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
        <div class="procedure-step-tab" id="tab-step-4" data-step="4" onclick="validateAndGoStep(4)" role="tab" aria-selected="false">
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
        <div class="procedure-step-tab" id="tab-step-5" data-step="5" onclick="validateAndGoStep(5)" role="tab" aria-selected="false">
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
                        <div class="step1-bento-grid">
                            <!-- Left Column: Overview & Location/Capacity -->
                            <div class="step1-left-col">
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtTitle.ClientID %>">Event Title <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-input" placeholder="e.g. Annual University Tech Symposium 2026" MaxLength="200" />
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="<%= txtDescription.ClientID %>">Event Description</label>
                                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" CssClass="form-textarea" placeholder="Detail the event objectives, keynote topics, speaker profiles, or student prerequisites..." rows="4" />
                                </div>

                                <div class="form-grid-2">
                                    <div class="form-group">
                                        <label class="form-label" for="<%= txtVenueLocation.ClientID %>">Venue Location <span class="required-mark">*</span></label>
                                        <asp:TextBox ID="txtVenueLocation" runat="server" CssClass="form-input" placeholder="e.g. Central Auditorium, Hall A" MaxLength="200" />
                                        <span class="form-hint">Physical room, auditorium, or laboratory venue.</span>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="<%= txtMaxCapacity.ClientID %>">Max Capacity (Seats) <span class="required-mark">*</span></label>
                                        <asp:TextBox ID="txtMaxCapacity" runat="server" TextMode="Number" CssClass="form-input" Text="150" />
                                        <span class="form-hint">Attendance Ceiling (Seats)</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column: Media & Branding -->
                            <div class="step1-right-col">
                                <div class="media-upload-card">
                                    <label class="form-label" for="<%= fuEventPhoto.ClientID %>">Promotional Banner / Poster</label>
                                    <span class="form-hint" style="margin-top:-0.2rem; margin-bottom:0.75rem;">(Optional Asset Upload)</span>

                                    <asp:HiddenField ID="hfPhotoBase64" runat="server" />
                                    <asp:HiddenField ID="hfPhotoFileName" runat="server" />

                                    <div id="dropzoneContent" class="upload-dropzone" style="cursor:pointer;" onclick="triggerPhotoUpload();">
                                        <svg class="upload-icon" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                            <polyline points="17 8 12 3 7 8"></polyline>
                                            <line x1="12" y1="3" x2="12" y2="15"></line>
                                        </svg>
                                        <asp:FileUpload ID="fuEventPhoto" runat="server" CssClass="form-input banner-file-input" accept="image/*" onchange="handleBannerFileSelect(this);" style="display:none;" />
                                        <span style="font-weight:600; color:var(--text-heading); margin-bottom:0.25rem;">Click to Upload Promotional Banner</span>
                                        <span class="upload-formats-hint">Supported formats: PNG, JPG, JPEG, WEBP</span>
                                    </div>

                                    <!-- Live Interactive Banner Preview -->
                                    <div id="bannerPreviewContainer" style="display:none; margin-top:0.75rem; border-radius:8px; overflow:hidden; border:1px solid var(--border-color); background:var(--card-bg);">
                                        <img id="imgBannerPreview" src="" alt="Selected Banner Preview" style="width:100%; height:160px; object-fit:cover; display:block;" />
                                        <div style="display:flex; justify-content:space-between; align-items:center; padding:0.65rem 0.85rem; background:rgba(0,0,0,0.03);">
                                            <div style="display:flex; align-items:center; gap:0.5rem; overflow:hidden;">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                <span id="lblBannerFileName" style="font-size:0.82rem; font-weight:600; color:var(--text-heading); text-overflow:ellipsis; overflow:hidden; white-space:nowrap; max-width:180px;"></span>
                                            </div>
                                            <div style="display:flex; gap:0.5rem;">
                                                <button type="button" onclick="triggerPhotoUpload();" style="background:#e0f2fe; color:#0284c7; border:none; border-radius:4px; padding:4px 8px; font-size:0.75rem; font-weight:600; cursor:pointer;">Change</button>
                                                <button type="button" onclick="removeSelectedBanner();" style="background:#fee2e2; color:#ef4444; border:none; border-radius:4px; padding:4px 8px; font-size:0.75rem; font-weight:600; cursor:pointer;">Remove</button>
                                            </div>
                                        </div>
                                    </div>

                                    <span class="form-hint" style="margin-top:0.75rem;">Stored persistently in the dedicated assets folder.</span>
                                </div>
                            </div>
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

                    <div class="card-body">
                        <!-- Policy Directive -->
                        <div class="info-callout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span><strong>Policy Directive:</strong> Events occur on a designated date. Registration concludes prior to kickoff.</span>
                        </div>

                        <!-- 2-Column Bento Grid: Event Runtime & Registration Window -->
                        <div class="step2-bento-grid">
                            <!-- Left: Event Runtime -->
                            <div class="bento-col-box">
                                <div class="bento-box-label">Event Runtime</div>

                                <div class="form-group">
                                    <label class="form-label" for="<%= txtEventDate.ClientID %>">Event Date <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtEventDate" runat="server" TextMode="Date" CssClass="form-input" />
                                    <span class="form-hint">Designated calendar date (Format: MM/DD/YYYY)</span>
                                </div>

                                <div class="form-grid-2">
                                    <div class="form-group" style="margin-bottom:0;">
                                        <label class="form-label" for="<%= txtEventStartTime.ClientID %>">Start Time <span class="required-mark">*</span></label>
                                        <asp:TextBox ID="txtEventStartTime" runat="server" TextMode="Time" CssClass="form-input" />
                                        <span class="form-hint">Start (e.g. 09:00 AM)</span>
                                    </div>
                                    <div class="form-group" style="margin-bottom:0;">
                                        <label class="form-label" for="<%= txtEventEndTime.ClientID %>">End Time <span class="required-mark">*</span></label>
                                        <asp:TextBox ID="txtEventEndTime" runat="server" TextMode="Time" CssClass="form-input" />
                                        <span class="form-hint">End (e.g. 05:00 PM)</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Right: Registration Window -->
                            <div class="bento-col-box">
                                <div class="bento-box-label">Registration Window</div>
                                <p class="form-hint">All registration times use <%= RegistrationTimeZoneLabel %>.</p>

                                <div class="form-group">
                                    <label class="form-label" for="<%= txtRegStart.ClientID %>">Registration Open Date & Time <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtRegStart" runat="server" TextMode="DateTimeLocal" step="1" CssClass="form-input" />
                                    <span class="form-hint">Initial access timestamp (Format: MM/DD/YYYY HH:MM)</span>
                                </div>

                                <div class="form-group" style="margin-bottom:0;">
                                    <label class="form-label" for="<%= txtRegEnd.ClientID %>">Registration Deadline <span class="required-mark">*</span></label>
                                    <asp:TextBox ID="txtRegEnd" runat="server" TextMode="DateTimeLocal" step="1" CssClass="form-input" />
                                    <span class="form-hint">Strict enrollment cutoff (Format: MM/DD/YYYY HH:MM)</span>
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

                    <div class="card-body">
                        <!-- Policy Directive -->
                        <div class="info-callout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span><strong>Policy Directive:</strong> "Open to All" grants universal access. Cohort picks enforce restrictions.</span>
                        </div>

                        <!-- 2-Column Bento Grid: Institutional Filters vs Degree Programs Matrix -->
                        <div class="step3-bento-grid">
                            <!-- Left: Institutional Filters (1, 2, 4) -->
                            <div class="bento-col-box">
                                <div class="bento-box-label">Institutional Filters</div>

                                <div class="form-group">
                                    <label class="form-label" for="<%= ddlBranch.ClientID %>">1. Campus Branch</label>
                                    <asp:DropDownList ID="ddlBranch" runat="server" CssClass="form-select">
                                        <asp:ListItem Value="" Text="All Branches (Open)" />
                                        <asp:ListItem Value="San Bartolome" Text="San Bartolome (Main Campus)" />
                                        <asp:ListItem Value="Batasan" Text="Batasan Campus" />
                                        <asp:ListItem Value="San Francisco" Text="San Francisco Campus" />
                                    </asp:DropDownList>
                                </div>

                                <div class="form-group" style="margin-top: 1rem;">
                                    <label class="form-label" for="<%= ddlDepartment.ClientID %>">2. Academic College / Dept</label>
                                    <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select" onchange="filterProgramsByDepartment(this.value);">
                                        <asp:ListItem Value="" Text="All Colleges / Open" />
                                    </asp:DropDownList>
                                </div>

                                <div class="form-group" style="margin-top: 1rem; margin-bottom: 0;">
                                    <label class="form-label" for="<%= ddlYearLevel.ClientID %>">4. Year Level Eligibility</label>
                                    <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-select">
                                        <asp:ListItem Value="" Text="All Year Levels (1-4)" />
                                        <asp:ListItem Value="1" Text="1st Year Students Only" />
                                        <asp:ListItem Value="2" Text="2nd Year Students Only" />
                                        <asp:ListItem Value="3" Text="3rd Year Students Only" />
                                        <asp:ListItem Value="4" Text="4th Year Graduating Seniors Only" />
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <!-- Right: Degree Programs Matrix (3) -->
                            <div class="bento-col-box">
                                <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:0.6rem; flex-wrap:wrap; gap:0.5rem;">
                                    <div class="bento-box-label" style="margin-bottom:0; padding-bottom:0; border-bottom:none;">
                                        3. Degree Programs (Multi-Select)
                                    </div>
                                    <div style="display:flex; gap:0.4rem;">
                                        <button type="button" class="btn-micro" onclick="selectAllPrograms(true)">Select All</button>
                                        <button type="button" class="btn-micro" onclick="selectAllPrograms(false)">Clear All (Open)</button>
                                    </div>
                                </div>

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

                                <div style="margin-top:0.75rem; padding-top:0.5rem; border-top:1px dashed var(--border-subtle);">
                                    <span class="form-hint" style="margin:0; font-style:italic;">Note: Open to all majors when unselected. Dynamic according to Academic College / Department.</span>
                                </div>
                            </div>
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
                                        <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn-remove-chip" CommandName="Remove" CommandArgument='<%# Container.DataItem %>' CausesValidation="false" ToolTip="Remove Sponsor"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg></asp:LinkButton>
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
                    <div class="card-body">
                        <!-- Bento 2x2 Layout Container -->
                        <div class="step5-bento-layout">
                            <div class="step5-bento-grid">
                                <!-- Box 1: Event Identity -->
                                <div class="bento-col-box">
                                    <div class="bento-box-label">EVENT IDENTITY</div>
                                    <div class="event-identity-split">
                                        <!-- Left Side: Title, Venue, Capacity -->
                                        <div class="event-identity-left">
                                            <div class="bento-kv-row">
                                                <span class="bento-kv-label" style="width:75px;">TITLE:</span>
                                                <span id="sumTitle" class="bento-kv-val" style="font-weight:700; color:var(--brand-primary);">-</span>
                                            </div>
                                            <div class="bento-kv-row">
                                                <span class="bento-kv-label" style="width:75px;">VENUE:</span>
                                                <span id="sumVenue" class="bento-kv-val" style="font-weight:600; color:#1e293b;">-</span>
                                            </div>
                                            <div class="bento-kv-row">
                                                <span class="bento-kv-label" style="width:75px;">CAPACITY:</span>
                                                <span id="sumCapacity" class="bento-kv-val" style="font-weight:600; color:#1e293b;">-</span>
                                            </div>
                                        </div>

                                        <!-- Right Side: Description & Banner Preview -->
                                        <div class="event-identity-right">
                                            <span class="bento-kv-label" style="display:block; margin-bottom:0.35rem;">DESC:</span>
                                            <div id="sumDesc" class="bento-kv-val summary-desc-text">-</div>

                                            <div id="sumBannerContainer" style="margin-top:0.75rem; border-top:1px dashed #e2e8f0; padding-top:0.75rem; display:none;">
                                                <span class="bento-kv-label" style="display:block; margin-bottom:0.35rem;">ATTACHED PROMOTIONAL BANNER:</span>
                                                <img id="sumBannerImg" src="" alt="Attached Promotional Banner" style="width:100%; max-height:130px; object-fit:cover; border-radius:6px; border:1px solid #cbd5e1; display:block;" />
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Box 2: Schedule & Registration -->
                                <div class="bento-col-box">
                                    <div class="bento-box-label">SCHEDULE &amp; REGISTRATION</div>
                                    <div class="schedule-split">
                                        <!-- Left Side: Event Date & Time Window -->
                                        <div class="schedule-split-col">
                                            <div class="bento-kv-row">
                                                <span class="bento-kv-label" style="width:105px;">EVENT DATE:</span>
                                                <span id="sumEventDate" class="bento-kv-val schedule-val">-</span>
                                            </div>
                                            <div class="bento-kv-row">
                                                <span class="bento-kv-label" style="width:105px;">TIME WINDOW:</span>
                                                <span id="sumEventHours" class="bento-kv-val schedule-val">-</span>
                                            </div>
                                        </div>

                                        <!-- Right Side: Opens & Deadline -->
                                        <div class="schedule-split-col schedule-right-col">
                                            <div class="bento-kv-row">
                                                <span class="bento-kv-label" style="width:85px;">OPENS:</span>
                                                <span id="sumRegOpen" class="bento-kv-val schedule-val">-</span>
                                            </div>
                                            <div class="bento-kv-row">
                                                <span class="bento-kv-label" style="width:85px;">DEADLINE:</span>
                                                <span id="sumRegDeadline" class="bento-kv-val schedule-val">-</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Box 3: Sponsors -->
                                <div class="bento-col-box sponsors-bento-box">
                                    <div class="bento-box-label">SPONSORS</div>
                                    <div id="sumSponsors" class="summary-chips-wrap"></div>
                                </div>

                                <!-- Box 4: Audience Specifications -->
                                <div class="bento-col-box">
                                    <div class="bento-box-label">AUDIENCE SPECIFICATIONS</div>
                                    <div class="bento-kv-list">
                                        <div class="bento-kv-row">
                                            <span class="bento-kv-label" style="width:100px;">CAMPUS:</span>
                                            <span id="sumBranch" class="bento-kv-val">-</span>
                                        </div>
                                        <div class="bento-kv-row">
                                            <span class="bento-kv-label" style="width:100px;">COLLEGE:</span>
                                            <span id="sumDept" class="bento-kv-val">-</span>
                                        </div>
                                        <div class="bento-kv-row">
                                            <span class="bento-kv-label" style="width:100px;">COHORT:</span>
                                            <span id="sumYearLevel" class="bento-kv-val">-</span>
                                        </div>
                                        <div class="bento-kv-row" style="align-items:flex-start;">
                                            <span class="bento-kv-label" style="width:100px; margin-top:0.2rem;">PROGRAMS:</span>
                                            <div id="sumPrograms" class="summary-chips-wrap" style="flex:1;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Bottom Row: Final Confirmation & Publication -->
                            <div class="bento-col-box step5-confirm-box">
                                <div class="bento-box-label">FINAL CONFIRMATION &amp; PUBLICATION</div>
                                <div class="bento-compliance-notice">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                    <span><strong>Ready to Publish:</strong> Event details and registration rules verified.</span>
                                </div>
                                <div class="bento-confirm-actions">
                                    <button type="button" class="btn-action-secondary" onclick="switchStep(4)">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                            <polyline points="15 18 9 12 15 6"></polyline>
                                        </svg>
                                        <span>Back to Edit</span>
                                    </button>
                                    <asp:Button ID="btnConfirmPublish" runat="server" Text="Confirm &amp; Publish Event" CssClass="btn-action-primary" OnClick="btnPublishEvent_Click" OnClientClick="return validateFinalPublish();" />
                                </div>
                            </div>
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

            var sponsorPanel = document.getElementById('step-panel-4');
            if (sponsorPanel) {
                sponsorPanel.parentElement.classList.toggle('sponsor-step-active', stepNumber === 4);
            }

            // 1. Update Step Panels
            for (var i = 1; i <= 5; i++) {
                var panel = document.getElementById('step-panel-' + i);
                if (panel) {
                    panel.inert = i !== stepNumber;
                    panel.setAttribute('aria-hidden', i === stepNumber ? 'false' : 'true');
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

        // ─── Schedule & Form Validation Feedback (Toast Notification) ───
        function showDateValidationToast(title, message, fieldToFocus) {
            // Trigger floating toast notification via global AppToast engine
            if (window.AppToast && typeof window.AppToast.show === 'function') {
                window.AppToast.show({
                    type: 'warning',
                    title: title || 'Validation Notice',
                    message: message || 'Please review and complete the required event details.',
                    duration: 6500
                });
            } else if (typeof window.showToast === 'function') {
                window.showToast(message, 'warning', title || 'Validation Notice', 6500);
            }

            // Smoothly focus and scroll to the invalid field if supplied
            if (fieldToFocus) {
                var el = (typeof fieldToFocus === 'string') ? document.getElementById(fieldToFocus) : fieldToFocus;
                if (el) {
                    setTimeout(function () {
                        el.focus();
                        if (typeof el.select === 'function') el.select();
                        if (typeof el.scrollIntoView === 'function') {
                            el.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        }
                    }, 120);
                }
            }
        }

        // Backward compatibility alias for any existing invocation
        function showDateValidationModal(title, message, fieldToFocus) {
            showDateValidationToast(title, message, fieldToFocus);
        }

        // Safe stubs for legacy call sites
        function closeDateValidationModal(shouldFocus) { }
        function handleDateModalBackdrop(event) { }

        function validateFinalPublish() {
            // Validate Step 1 before final submit
            var title = document.getElementById('<%= txtTitle.ClientID %>');
            var venue = document.getElementById('<%= txtVenueLocation.ClientID %>');
            var cap = document.getElementById('<%= txtMaxCapacity.ClientID %>');

            if (!title || !title.value.trim()) {
                showDateValidationToast('Event Title Required', 'Please enter the <strong>Event Title</strong> before publishing.', '<%= txtTitle.ClientID %>');
                switchStep(1);
                return false;
            }
            if (!venue || !venue.value.trim()) {
                showDateValidationToast('Venue Location Required', 'Please specify the <strong>Venue / Room Location</strong> before publishing.', '<%= txtVenueLocation.ClientID %>');
                switchStep(1);
                return false;
            }
            if (!cap || !cap.value.trim() || parseInt(cap.value) <= 0) {
                showDateValidationToast('Invalid Seat Capacity', 'Please enter a valid seat capacity greater than 0.', '<%= txtMaxCapacity.ClientID %>');
                switchStep(1);
                return false;
            }

            // Validate Step 2 before final submit
            var evDate = document.getElementById('<%= txtEventDate.ClientID %>');
            var startTime = document.getElementById('<%= txtEventStartTime.ClientID %>');
            var endTime = document.getElementById('<%= txtEventEndTime.ClientID %>');
            var regStart = document.getElementById('<%= txtRegStart.ClientID %>');
            var regEnd = document.getElementById('<%= txtRegEnd.ClientID %>');

            if (!evDate || !evDate.value) {
                showDateValidationToast('Event Date Required', 'Please specify the designated <strong>Event Date (Format: MM/DD/YYYY)</strong>.', '<%= txtEventDate.ClientID %>');
                switchStep(2);
                return false;
            }
            if (!startTime || !startTime.value) {
                showDateValidationToast('Kickoff Time Required', 'Please specify the <strong>Event Kickoff Time</strong>.', '<%= txtEventStartTime.ClientID %>');
                switchStep(2);
                return false;
            }
            if (!endTime || !endTime.value) {
                showDateValidationToast('End Time Required', 'Please specify the <strong>Event End Time</strong>.', '<%= txtEventEndTime.ClientID %>');
                switchStep(2);
                return false;
            }
            if (startTime.value >= endTime.value) {
                showDateValidationToast('Invalid Time Window', 'Event Kickoff Time must be <strong>earlier</strong> than Event End Time.', '<%= txtEventStartTime.ClientID %>');
                switchStep(2);
                return false;
            }
            if (!regStart || !regStart.value) {
                showDateValidationToast('Registration Open Date Required', 'Please specify the <strong>Registration Opening Date &amp; Time</strong>.', '<%= txtRegStart.ClientID %>');
                switchStep(2);
                return false;
            }
            if (!regEnd || !regEnd.value) {
                showDateValidationToast('Registration Deadline Required', 'Please specify the <strong>Registration Deadline</strong>.', '<%= txtRegEnd.ClientID %>');
                switchStep(2);
                return false;
            }
            if (normalizeRegistrationDateTime(regStart.value) >= normalizeRegistrationDateTime(regEnd.value)) {
                showDateValidationToast('Invalid Registration Window', 'Registration Opening Date &amp; Time must be <strong>earlier</strong> than the Registration Deadline.', '<%= txtRegStart.ClientID %>');
                switchStep(2);
                return false;
            }
            var evDateStr = evDate.value;
            var regStartDateStr = regStart.value.split('T')[0];
            var regEndDateStr = regEnd.value.split('T')[0];
            if (regStartDateStr >= evDateStr || regEndDateStr >= evDateStr) {
                var formattedEvDate = formatDateOnlyPretty(evDateStr);
                showDateValidationToast(
                    'Registration Must Precede Event Date',
                    'Registration Opening Date and Registration Deadline must both conclude <strong>before the Event Date (' + formattedEvDate + ')</strong>.',
                    '<%= txtRegEnd.ClientID %>'
                );
                switchStep(2);
                return false;
            }

            return true;
        }

        function validateAndGoStep(targetStep) {
            targetStep = parseInt(targetStep);
            var hf = document.getElementById('<%= hfActiveStep.ClientID %>');
            var currentStep = (hf && hf.value) ? parseInt(hf.value) : 1;

            // Navigating backwards is always allowed
            if (targetStep <= currentStep) {
                switchStep(targetStep);
                return;
            }

            // Validate Step 1 if moving forward past Step 1
            if (targetStep > 1) {
                var title = document.getElementById('<%= txtTitle.ClientID %>');
                var venue = document.getElementById('<%= txtVenueLocation.ClientID %>');
                var cap = document.getElementById('<%= txtMaxCapacity.ClientID %>');

                if (title && !title.value.trim()) {
                    showDateValidationToast(
                        'Event Title Required',
                        'Please enter the <strong>Event Title</strong> before proceeding to subsequent steps.',
                        '<%= txtTitle.ClientID %>'
                    );
                    switchStep(1);
                    return;
                }
                if (venue && !venue.value.trim()) {
                    showDateValidationToast(
                        'Venue Location Required',
                        'Please specify the <strong>Venue / Room Location</strong>.',
                        '<%= txtVenueLocation.ClientID %>'
                    );
                    switchStep(1);
                    return;
                }
                if (cap && (!cap.value.trim() || parseInt(cap.value) <= 0)) {
                    showDateValidationToast(
                        'Invalid Seat Capacity',
                        'Please enter a valid seat capacity greater than 0.',
                        '<%= txtMaxCapacity.ClientID %>'
                    );
                    switchStep(1);
                    return;
                }
            }

            // Validate Step 2 if moving forward past Step 2 (e.g. Target Audience button or tabs 3, 4, 5)
            if (targetStep > 2) {
                var evDate = document.getElementById('<%= txtEventDate.ClientID %>');
                var startTime = document.getElementById('<%= txtEventStartTime.ClientID %>');
                var endTime = document.getElementById('<%= txtEventEndTime.ClientID %>');
                var regStart = document.getElementById('<%= txtRegStart.ClientID %>');
                var regEnd = document.getElementById('<%= txtRegEnd.ClientID %>');

                if (evDate && !evDate.value) {
                    showDateValidationToast(
                        'Event Date Required',
                        'Please specify the designated <strong>Event Date (Format: MM/DD/YYYY)</strong> before proceeding to Target Audience.',
                        '<%= txtEventDate.ClientID %>'
                    );
                    switchStep(2);
                    return;
                }
                if (startTime && !startTime.value) {
                    showDateValidationToast(
                        'Kickoff Time Required',
                        'Please specify the <strong>Event Kickoff Time</strong> (e.g. 09:00 AM).',
                        '<%= txtEventStartTime.ClientID %>'
                    );
                    switchStep(2);
                    return;
                }
                if (endTime && !endTime.value) {
                    showDateValidationToast(
                        'End Time Required',
                        'Please specify the <strong>Event End Time</strong> (e.g. 05:00 PM).',
                        '<%= txtEventEndTime.ClientID %>'
                    );
                    switchStep(2);
                    return;
                }
                if (startTime && endTime && startTime.value >= endTime.value) {
                    showDateValidationToast(
                        'Invalid Time Window',
                        'Event Kickoff Time must be <strong>earlier</strong> than Event End Time.',
                        '<%= txtEventStartTime.ClientID %>'
                    );
                    switchStep(2);
                    return;
                }
                if (regStart && !regStart.value) {
                    showDateValidationToast(
                        'Registration Open Date Required',
                        'Please specify the <strong>Registration Opening Date &amp; Time</strong>.',
                        '<%= txtRegStart.ClientID %>'
                    );
                    switchStep(2);
                    return;
                }
                if (regEnd && !regEnd.value) {
                    showDateValidationToast(
                        'Registration Deadline Required',
                        'Please specify the <strong>Registration Deadline Date &amp; Time</strong>.',
                        '<%= txtRegEnd.ClientID %>'
                    );
                    switchStep(2);
                    return;
                }

                // Check 1: Registration Open must be strictly earlier than Registration Deadline
                var dtRegStart = normalizeRegistrationDateTime(regStart.value);
                var dtRegEnd = normalizeRegistrationDateTime(regEnd.value);
                if (dtRegStart >= dtRegEnd) {
                    showDateValidationToast(
                        'Invalid Registration Window',
                        'Registration Opening Date &amp; Time must be <strong>earlier</strong> than the Registration Deadline.',
                        '<%= txtRegStart.ClientID %>'
                    );
                    switchStep(2);
                    return;
                }

                // Check 2: Core directive - Registration Open Date and Registration Closing Date must BOTH be strictly before the Event Date itself!
                var evDateStr = evDate.value; // "YYYY-MM-DD"
                var regStartDateStr = regStart.value.split('T')[0]; // "YYYY-MM-DD"
                var regEndDateStr = regEnd.value.split('T')[0]; // "YYYY-MM-DD"

                if (regStartDateStr >= evDateStr || regEndDateStr >= evDateStr) {
                    var formattedEvDate = formatDateOnlyPretty(evDateStr);
                    showDateValidationToast(
                        'Registration Must Precede Event Date',
                        'The <strong>Registration Opening Date</strong> and <strong>Registration Deadline</strong> must both conclude <strong>before the Event Date itself (' + formattedEvDate + ')</strong>.<br><br>Please adjust your registration dates so they occur strictly prior to the scheduled event date.',
                        '<%= txtRegEnd.ClientID %>'
                    );
                    switchStep(2);
                    return;
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
            // Read the posted selection before filtering synchronizes the hidden field.
            var hf = document.getElementById('<%= hfSelectedPrograms.ClientID %>');
            var selected = hf && hf.value ? hf.value.split(',').map(function (s) { return s.trim(); }) : [];
            document.querySelectorAll('input[name="courseFilter"]').forEach(function (cb) {
                cb.checked = selected.indexOf(cb.value) !== -1;
            });
            var deptDdl = document.getElementById('<%= ddlDepartment.ClientID %>');
            filterProgramsByDepartment(deptDdl ? deptDdl.value : '');
        }

        // ─── Step 5 Live Summary Generation ───
        function normalizeRegistrationDateTime(value) {
            return value.length === 16 ? value + ':00' : value;
        }

        function formatDateTimePretty(isoStr) {
            if (!isoStr) return '-';
            // Format the selected wall-clock components; date-only ISO strings parse as UTC in Date().
            var parts = isoStr.split('T');
            var time = parts.length > 1 ? parts[1] : '00:00';
            var clock = time.split(':');
            var seconds = clock.length > 2 && parseInt(clock[2], 10) > 0 ? ':' + clock[2] : '';
            var formatted = formatTime12h(time);
            if (seconds) formatted = formatted.replace(/ (AM|PM)$/, seconds + ' $1');
            return formatDateOnlyPretty(parts[0]) + ' ' + formatted;
        }

        function formatDateOnlyPretty(dateStr) {
            if (!dateStr) return '-';
            var clean = (typeof dateStr === 'string') ? dateStr.split('T')[0] : '';
            var parts = clean.split('-');
            if (parts.length === 3) {
                var mm = ('0' + parseInt(parts[1], 10)).slice(-2);
                var dd = ('0' + parseInt(parts[2], 10)).slice(-2);
                var yyyy = parts[0];
                return mm + '/' + dd + '/' + yyyy;
            }
            var d = new Date(dateStr);
            if (!isNaN(d.getTime())) {
                var mm = ('0' + (d.getMonth() + 1)).slice(-2);
                var dd = ('0' + d.getDate()).slice(-2);
                var yyyy = d.getFullYear();
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
            if (sumCapacity) sumCapacity.innerText = (cap && cap.value) ? (cap.value + ' seats') : '150 seats';
            if (sumDesc) sumDesc.innerText = (desc && desc.value.trim()) ? desc.value.trim() : '(No description provided)';

            // Promotional Banner Preview in Step 5
            var hfData = document.getElementById('<%= hfPhotoBase64.ClientID %>');
            var sumBannerBox = document.getElementById('sumBannerContainer');
            var sumBannerImg = document.getElementById('sumBannerImg');
            if (hfData && hfData.value && sumBannerBox && sumBannerImg) {
                sumBannerImg.src = hfData.value;
                sumBannerBox.style.display = 'block';
            } else if (sumBannerBox) {
                sumBannerBox.style.display = 'none';
            }

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

        function triggerPhotoUpload() {
            var fu = document.getElementById('<%= fuEventPhoto.ClientID %>');
            if (fu) fu.click();
        }

        function handleBannerFileSelect(input) {
            if (input.files && input.files[0]) {
                var file = input.files[0];
                var reader = new FileReader();
                reader.onload = function(e) {
                    var preview = document.getElementById('imgBannerPreview');
                    var nameLabel = document.getElementById('lblBannerFileName');
                    var container = document.getElementById('bannerPreviewContainer');
                    var dropzone = document.getElementById('dropzoneContent');
                    if (preview) preview.src = e.target.result;
                    if (nameLabel) nameLabel.innerText = file.name;
                    if (container) container.style.display = 'block';
                    if (dropzone) dropzone.style.display = 'none';

                    var hfData = document.getElementById('<%= hfPhotoBase64.ClientID %>');
                    var hfName = document.getElementById('<%= hfPhotoFileName.ClientID %>');
                    if (hfData) hfData.value = e.target.result;
                    if (hfName) hfName.value = file.name;
                };
                reader.readAsDataURL(file);
            }
        }

        function removeSelectedBanner() {
            var fu = document.getElementById('<%= fuEventPhoto.ClientID %>');
            if (fu) fu.value = '';
            var hfData = document.getElementById('<%= hfPhotoBase64.ClientID %>');
            var hfName = document.getElementById('<%= hfPhotoFileName.ClientID %>');
            if (hfData) hfData.value = '';
            if (hfName) hfName.value = '';
            var container = document.getElementById('bannerPreviewContainer');
            var dropzone = document.getElementById('dropzoneContent');
            if (container) container.style.display = 'none';
            if (dropzone) dropzone.style.display = 'block';
        }

        // Initialize state on page load
        document.addEventListener('DOMContentLoaded', function () {
            restoreCourseSelection();
            initLiveTicketListeners();
            updateTicketPreview();

            // Check if photo was previously stored in hidden field
            var hfData = document.getElementById('<%= hfPhotoBase64.ClientID %>');
            var hfName = document.getElementById('<%= hfPhotoFileName.ClientID %>');
            if (hfData && hfData.value) {
                var preview = document.getElementById('imgBannerPreview');
                var nameLabel = document.getElementById('lblBannerFileName');
                var container = document.getElementById('bannerPreviewContainer');
                var dropzone = document.getElementById('dropzoneContent');
                if (preview) preview.src = hfData.value;
                if (nameLabel && hfName && hfName.value) nameLabel.innerText = hfName.value;
                if (container) container.style.display = 'block';
                if (dropzone) dropzone.style.display = 'none';
            }

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
