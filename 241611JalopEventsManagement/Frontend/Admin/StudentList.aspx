<%@ Page Title="Students Directory & Identity Master | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="StudentList.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.StudentList" EnableSessionState="ReadOnly" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/student-list.css?v=20261008-csv-layout") %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header & Top Operations -->
    <div class="directory-header-row">
        <div class="header-title-block">
            <h2>Students Directory</h2>
        </div>
        <div class="header-actions">
            <asp:LinkButton ID="btnOpenBatchModal" runat="server" CssClass="btn-action-secondary" OnClick="btnOpenBatchModal_Click">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="12" y1="18" x2="12" y2="12"></line>
                    <line x1="9" y1="15" x2="15" y2="15"></line>
                </svg>
                <span>Batch CSV Import</span>
            </asp:LinkButton>

            <asp:LinkButton ID="btnOpenAddModal" runat="server" CssClass="btn-action-primary" OnClick="btnOpenAddModal_Click">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                <span>Add New Student</span>
            </asp:LinkButton>
        </div>
    </div>

    <!-- Feedback Notification Banner -->
    <asp:Panel ID="pnlNotification" runat="server" Visible="false">
        <asp:Literal ID="litNotificationMsg" runat="server" />
    </asp:Panel>

    <!-- Filters & Search Toolbar (Photo 3 Layout) -->
    <div class="filters-toolbar">
        <div class="search-box-wrapper">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" Placeholder="Search by Student ID or Full Name..." />
        </div>

        <div class="filter-controls-group">
            <asp:DropDownList ID="ddlDepartmentFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                <asp:ListItem Text="All Departments" Value="ALL" />
            </asp:DropDownList>

            <asp:DropDownList ID="ddlProgramFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                <asp:ListItem Text="All Courses" Value="ALL" />
            </asp:DropDownList>

            <asp:Button ID="btnFilter" runat="server" Text="Search" CssClass="btn-filter-apply" OnClick="btnFilter_Click" />
            <asp:Button ID="btnClearFilter" runat="server" Text="Reset Filters" CssClass="btn-filter-reset" OnClick="btnClearFilter_Click" />

            <asp:LinkButton ID="btnExportCsv" runat="server" CssClass="btn-icon-export" OnClick="btnExportCsv_Click" ToolTip="Export Directory CSV">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                    <polyline points="7 10 12 15 17 10"></polyline>
                    <line x1="12" y1="15" x2="12" y2="3"></line>
                </svg>
            </asp:LinkButton>
        </div>
    </div>

    <!-- Student Master Directory Table (Photo 1 Structure) -->
    <div class="table-card">
        <div class="table-header-meta">
            <h3>
                <span>Directory Master Roster</span>
                <span class="count-pill"><asp:Literal ID="litShowingCount" runat="server">0</asp:Literal> Profiles</span>
            </h3>
        </div>

        <div class="table-responsive">
            <asp:Repeater ID="rptStudents" runat="server" OnItemCommand="rptStudents_ItemCommand">
                <HeaderTemplate>
                    <table class="directory-table">
                        <thead>
                            <tr>
                                <th style="width: 16%;">Student ID</th>
                                <th style="width: 26%;">Student Name</th>
                                <th style="width: 32%;">Department &amp; Course</th>
                                <th style="width: 16%;">Branch</th>
                                <th style="width: 10%; text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td>
                            <span class="student-id-text"><%# Eval("StudentId") %></span>
                        </td>
                        <td>
                            <span class="student-name-text"><%# Eval("FullName") %></span>
                        </td>
                        <td>
                            <div class="dept-course-cell">
                                <span class="dept-text"><%# Eval("Department") %></span>
                                <span class="course-text"><%# Eval("Program") %></span>
                            </div>
                        </td>
                        <td>
                            <span class="branch-text"><%# Eval("CampusBranch") %></span>
                        </td>
                        <td style="text-align: right;">
                            <asp:LinkButton ID="btnViewStudent" runat="server" CssClass="btn-view-link link-matrix-view" CommandName="EditStudent" CommandArgument='<%# Eval("StudentId") %>'>
                                View
                            </asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlEmptyState" runat="server" Visible="false" CssClass="empty-state">
                <svg class="empty-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="8" y1="12" x2="16" y2="12"></line>
                </svg>
                <div class="empty-title">No Student Profiles Found</div>
                <div class="empty-desc">No academic records match the current filter or search criteria. Try modifying your search keywords or clearing active filters.</div>
                <asp:Button ID="btnEmptyClear" runat="server" Text="Reset Filters" CssClass="btn-action-secondary" OnClick="btnClearFilter_Click" />
            </asp:Panel>
        </div>
    </div>

    <!-- ─── Modal 1: Add New Student Profile ─── -->
    <asp:Panel ID="pnlAddModal" runat="server" Visible="false" CssClass="modal-backdrop">
        <div class="modal-card">
            <div class="modal-header">
                <h3>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="8.5" cy="7" r="4"></circle>
                        <line x1="20" y1="8" x2="20" y2="14"></line>
                        <line x1="23" y1="11" x2="17" y2="11"></line>
                    </svg>
                    <span>Register New Student Profile</span>
                </h3>
                <asp:LinkButton ID="btnCloseAddModal" runat="server" CssClass="btn-modal-close" OnClick="btnCloseAddModal_Click">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </asp:LinkButton>
            </div>

            <div class="modal-body">
                <div class="password-info-box">
                    Identity Master: Creating this student record automatically registers an active login account in <strong>dbo.UserTable</strong> with the temporary password structured as <strong>[First letter of Middle Name] + [MMDDYYYY birthdate]</strong> (e.g. <strong>N03242006</strong>).
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label>Student Matriculation ID <span class="required-star">*</span> (e.g. 24-1611)</label>
                        <asp:TextBox ID="txtAddStudentId" runat="server" CssClass="form-input" Placeholder="e.g. 24-1611" />
                    </div>
                    <div class="form-group">
                        <label>Institutional Email <span class="required-star">*</span></label>
                        <asp:TextBox ID="txtAddEmail" runat="server" CssClass="form-input" Placeholder="name@qcu.edu.ph" TextMode="Email" />
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label>First Name <span class="required-star">*</span></label>
                        <asp:TextBox ID="txtAddFirstName" runat="server" CssClass="form-input" Placeholder="First Name" />
                    </div>
                    <div class="form-group">
                        <label>Middle Name (Optional)</label>
                        <asp:TextBox ID="txtAddMiddleName" runat="server" CssClass="form-input" Placeholder="Middle Name" />
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label>Last Name <span class="required-star">*</span></label>
                        <asp:TextBox ID="txtAddLastName" runat="server" CssClass="form-input" Placeholder="Last Name" />
                    </div>
                    <div class="form-group">
                        <label>Birthdate <span class="required-star">*</span> (mm/dd/yyyy)</label>
                        <asp:TextBox ID="txtAddBirthDate" runat="server" CssClass="form-input" Placeholder="mm/dd/yyyy" />
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label>Gender <span class="required-star">*</span></label>
                        <asp:DropDownList ID="ddlAddGender" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Male" Value="Male" />
                            <asp:ListItem Text="Female" Value="Female" />
                            <asp:ListItem Text="Non-Binary" Value="Non-Binary" />
                            <asp:ListItem Text="Prefer not to say" Value="Prefer not to say" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Campus Branch <span class="required-star">*</span></label>
                        <asp:DropDownList ID="ddlAddCampus" runat="server" CssClass="form-select">
                            <asp:ListItem Text="San Bartolome (Main)" Value="San Bartolome" />
                            <asp:ListItem Text="Batasan Campus" Value="Batasan" />
                            <asp:ListItem Text="San Francisco Campus" Value="San Francisco" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label>Department <span class="required-star">*</span></label>
                        <asp:DropDownList ID="ddlAddDepartment" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlAddDepartment_SelectedIndexChanged">
                            <asp:ListItem Text="College of Computer Studies" Value="College of Computer Studies" />
                            <asp:ListItem Text="College of Engineering" Value="College of Engineering" />
                            <asp:ListItem Text="College of Business Administration and Accountancy" Value="College of Business Administration and Accountancy" />
                            <asp:ListItem Text="College of Education" Value="College of Education" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Academic Program / Course <span class="required-star">*</span></label>
                        <asp:DropDownList ID="ddlAddProgram" runat="server" CssClass="form-select">
                            <asp:ListItem Text="BS Information Technology" Value="BS Information Technology" />
                            <asp:ListItem Text="BS Computer Science" Value="BS Computer Science" />
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <asp:Button ID="btnCancelAdd" runat="server" Text="Cancel" CssClass="btn-action-secondary" OnClick="btnCloseAddModal_Click" />
                <asp:Button ID="btnSaveNewStudent" runat="server" Text="Register & Create Credentials" CssClass="btn-action-primary" OnClick="btnSaveNewStudent_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- ─── Modal 2: Edit Student Profile (Fixed Scroll & 2 Tabs: Student Info & Account Info) ─── -->
    <asp:Panel ID="pnlEditModal" runat="server" Visible="false" CssClass="modal-backdrop">
        <div class="modal-card">
            <div class="modal-header">
                <h3>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                    </svg>
                    <span>Edit Student Profile - <asp:Literal ID="litEditStudentIdHeading" runat="server" /></span>
                </h3>
                <asp:LinkButton ID="btnCloseEditModal" runat="server" CssClass="btn-modal-close" OnClick="btnCloseEditModal_Click">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </asp:LinkButton>
            </div>

            <!-- Two Tab Switcher Header -->
            <div class="modal-tabs-header">
                <button type="button" id="tabBtnStudent" class="modal-tab-btn active" onclick="switchEditTab('student')">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                    <span>Student Information</span>
                </button>
                <button type="button" id="tabBtnAccount" class="modal-tab-btn" onclick="switchEditTab('account')">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    <span>Account Information</span>
                </button>
            </div>

            <asp:HiddenField ID="hfActiveEditTab" runat="server" Value="student" />

            <div class="modal-body">
                <asp:HiddenField ID="hfEditStudentId" runat="server" />

                <!-- Tab 1: Student Information -->
                <div id="tabPaneStudent" class="edit-tab-pane" style="display: block;">
                    <div class="form-grid-2">
                        <div class="form-group">
                            <label>Student Matriculation ID</label>
                            <asp:TextBox ID="txtEditStudentId" runat="server" CssClass="form-input" ReadOnly="true" BackColor="#F8FAFC" />
                        </div>
                        <div class="form-group">
                            <label>Campus Branch <span class="required-star">*</span></label>
                            <asp:DropDownList ID="ddlEditCampus" runat="server" CssClass="form-select">
                                <asp:ListItem Text="San Bartolome (Main)" Value="San Bartolome" />
                                <asp:ListItem Text="Batasan Campus" Value="Batasan" />
                                <asp:ListItem Text="San Francisco Campus" Value="San Francisco" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label>First Name <span class="required-star">*</span></label>
                            <asp:TextBox ID="txtEditFirstName" runat="server" CssClass="form-input" />
                        </div>
                        <div class="form-group">
                            <label>Middle Name</label>
                            <asp:TextBox ID="txtEditMiddleName" runat="server" CssClass="form-input" />
                        </div>
                    </div>

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label>Last Name <span class="required-star">*</span></label>
                            <asp:TextBox ID="txtEditLastName" runat="server" CssClass="form-input" />
                        </div>
                        <div class="form-group">
                            <label>Birthdate (mm/dd/yyyy)</label>
                            <asp:TextBox ID="txtEditBirthDate" runat="server" CssClass="form-input" Placeholder="mm/dd/yyyy" />
                        </div>
                    </div>

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label>Gender <span class="required-star">*</span></label>
                            <asp:DropDownList ID="ddlEditGender" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Male" Value="Male" />
                                <asp:ListItem Text="Female" Value="Female" />
                                <asp:ListItem Text="Non-Binary" Value="Non-Binary" />
                                <asp:ListItem Text="Prefer not to say" Value="Prefer not to say" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>Department <span class="required-star">*</span></label>
                            <asp:DropDownList ID="ddlEditDepartment" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEditDepartment_SelectedIndexChanged">
                                <asp:ListItem Text="College of Computer Studies" Value="College of Computer Studies" />
                                <asp:ListItem Text="College of Engineering" Value="College of Engineering" />
                                <asp:ListItem Text="College of Business Administration and Accountancy" Value="College of Business Administration and Accountancy" />
                                <asp:ListItem Text="College of Education" Value="College of Education" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Academic Program / Course <span class="required-star">*</span></label>
                        <asp:DropDownList ID="ddlEditProgram" runat="server" CssClass="form-select">
                            <asp:ListItem Text="BS Information Technology" Value="BS Information Technology" />
                            <asp:ListItem Text="BS Computer Science" Value="BS Computer Science" />
                        </asp:DropDownList>
                    </div>
                </div>

                <!-- Tab 2: Account Information -->
                <div id="tabPaneAccount" class="edit-tab-pane" style="display: none;">
                    <div class="form-grid-2">
                        <div class="form-group">
                            <label>Institutional Email <span class="required-star">*</span></label>
                            <asp:TextBox ID="txtEditEmail" runat="server" CssClass="form-input" TextMode="Email" />
                        </div>
                        <div class="form-group">
                            <label>Account Access Status</label>
                            <asp:DropDownList ID="ddlEditStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Active (Authorized)" Value="Active" />
                                <asp:ListItem Text="Suspended (Revoked)" Value="Suspended" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="password-info-box" style="margin-top: 1rem;">
                        <strong>Institutional Structured Password Formula:</strong><br />
                        <span>[First Letter of Middle Name] + [MMDDYYYY Birthdate]</span><br />
                        <span style="font-size: 0.8rem; color: var(--text-muted);">Current Calculated Default: </span>
                        <strong style="color: var(--brand-primary);"><asp:Literal ID="litEditStructuredPassword" runat="server" Text="N/A" /></strong>
                    </div>

                    <div class="form-group" style="margin-top: 1rem;">
                        <label>Reset Account Password (Optional)</label>
                        <asp:TextBox ID="txtEditNewPassword" runat="server" CssClass="form-input" Placeholder="Leave blank to keep existing password, or enter new password" />
                        <small style="color: var(--text-muted); font-size: 0.75rem; margin-top: 0.25rem;">
                            Entering a value here will securely re-hash and update this student's login credentials upon saving.
                        </small>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="btn-action-secondary" OnClick="btnCloseEditModal_Click" />
                <asp:Button ID="btnUpdateStudent" runat="server" Text="Save Demographic Updates" CssClass="btn-action-primary" OnClick="btnUpdateStudent_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- ─── Modal 3: Password Reset ─── -->
    <asp:Panel ID="pnlResetModal" runat="server" Visible="false" CssClass="modal-backdrop">
        <div class="modal-card" style="max-width: 480px;">
            <div class="modal-header">
                <h3>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    <span>Reset Account Password</span>
                </h3>
                <asp:LinkButton ID="btnCloseResetModal" runat="server" CssClass="btn-modal-close" OnClick="btnCloseResetModal_Click">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </asp:LinkButton>
            </div>

            <div class="modal-body">
                <asp:HiddenField ID="hfResetStudentId" runat="server" />
                <p style="font-size: 0.85rem; color: var(--text-body); margin-bottom: 0.75rem;">
                    Resetting password for student: <strong><asp:Literal ID="litResetStudentInfo" runat="server" /></strong>.
                </p>

                <div class="password-info-box">
                    Default Structured Password: <strong><asp:Literal ID="litDefaultTempPassword" runat="server" /></strong><br />
                    Clicking below will re-hash credentials using PBKDF2 with dynamic cryptographic salt.
                </div>

                <div class="form-group" style="margin-top: 1rem;">
                    <label>Or Enter Custom Temporary Password (Optional):</label>
                    <asp:TextBox ID="txtCustomPassword" runat="server" CssClass="form-input" Placeholder="Leave empty to use structured default" TextMode="Password" />
                </div>
            </div>

            <div class="modal-footer">
                <asp:Button ID="btnCancelReset" runat="server" Text="Cancel" CssClass="btn-action-secondary" OnClick="btnCloseResetModal_Click" />
                <asp:Button ID="btnConfirmReset" runat="server" Text="Confirm Reset" CssClass="btn-action-primary" OnClick="btnConfirmReset_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- ─── Modal 4: Batch CSV Import ─── -->
    <asp:Panel ID="pnlBatchModal" runat="server" Visible="false" CssClass="modal-backdrop">
        <div class="modal-card" style="max-width: 580px;">
            <div class="modal-header">
                <h3>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="12" y1="18" x2="12" y2="12"></line>
                        <line x1="9" y1="15" x2="15" y2="15"></line>
                    </svg>
                    <span>Batch CSV Student Roster Import</span>
                </h3>
                <asp:LinkButton ID="btnCloseBatchModal" runat="server" CssClass="btn-modal-close" OnClick="btnCloseBatchModal_Click">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </asp:LinkButton>
            </div>

            <div class="modal-body">
                <p style="font-size: 0.85rem; color: var(--text-body); margin-bottom: 0.75rem;">
                    Upload a standardized CSV file to register multiple student academic records and provision their event access accounts.
                </p>

                <div class="password-info-box csv-format-info">
                    <strong>Standard CSV Header Format:</strong>
                    <code>StudentId,FirstName,MiddleName,LastName,Gender,CampusBranch,Department,Program,Email,BirthDate</code>
                    <em>Dates must follow the strict MM/dd/yyyy standard (e.g. 03/24/2004).</em>
                </div>

                <div class="form-group" style="margin-top: 1rem;">
                    <label>Select CSV File (.csv) <span class="required-star">*</span></label>
                    <asp:FileUpload ID="fuCsvRoster" runat="server" CssClass="form-input" accept=".csv" />
                </div>
            </div>

            <div class="modal-footer">
                <asp:LinkButton ID="btnDownloadTemplate" runat="server" CssClass="btn-action-secondary" OnClick="btnDownloadTemplate_Click">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="7 10 12 15 17 10"></polyline>
                        <line x1="12" y1="15" x2="12" y2="3"></line>
                    </svg>
                    <span>Download CSV Template</span>
                </asp:LinkButton>
                <asp:Button ID="btnProcessCsv" runat="server" Text="Upload & Process Roster" CssClass="btn-action-primary" OnClick="btnProcessCsv_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- Client-Side Modal Tab Switcher Script -->
    <script type="text/javascript">
        function switchEditTab(tabName) {
            var studentPane = document.getElementById('tabPaneStudent');
            var accountPane = document.getElementById('tabPaneAccount');
            var btnStudent = document.getElementById('tabBtnStudent');
            var btnAccount = document.getElementById('tabBtnAccount');
            var hfTab = document.getElementById('<%= hfActiveEditTab.ClientID %>');

            if (tabName === 'account') {
                if (studentPane) studentPane.style.display = 'none';
                if (accountPane) accountPane.style.display = 'block';
                if (btnStudent) btnStudent.classList.remove('active');
                if (btnAccount) btnAccount.classList.add('active');
                if (hfTab) hfTab.value = 'account';
            } else {
                if (studentPane) studentPane.style.display = 'block';
                if (accountPane) accountPane.style.display = 'none';
                if (btnStudent) btnStudent.classList.add('active');
                if (btnAccount) btnAccount.classList.remove('active');
                if (hfTab) hfTab.value = 'student';
            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            var hfTab = document.getElementById('<%= hfActiveEditTab.ClientID %>');
            if (hfTab && hfTab.value === 'account') {
                switchEditTab('account');
            }

            // Instant Client-Side Directory Filtering for Zero-Lag Search
            var searchInput = document.getElementById('<%= txtSearch.ClientID %>');
            var deptFilter = document.getElementById('<%= ddlDepartmentFilter.ClientID %>');
            var progFilter = document.getElementById('<%= ddlProgramFilter.ClientID %>');
            var countPill = document.getElementById('<%= litShowingCount.ClientID %>') || document.querySelector('.count-pill');
            var tableBody = document.querySelector('.directory-table tbody');

            if (tableBody && searchInput) {
                var rows = Array.from(tableBody.querySelectorAll('tr'));
                var rowCache = rows.map(function(row) {
                    var idEl = row.querySelector('.student-id-text');
                    var nameEl = row.querySelector('.student-name-text');
                    var deptEl = row.querySelector('.dept-text');
                    var courseEl = row.querySelector('.course-text');
                    var branchEl = row.querySelector('.branch-text');
                    return {
                        row: row,
                        id: idEl ? idEl.textContent.toLowerCase() : '',
                        name: nameEl ? nameEl.textContent.toLowerCase() : '',
                        dept: deptEl ? deptEl.textContent.toLowerCase() : '',
                        course: courseEl ? courseEl.textContent.toLowerCase() : '',
                        branch: branchEl ? branchEl.textContent.toLowerCase() : ''
                    };
                });

                function applyInstantFilter() {
                    var query = searchInput.value.toLowerCase().trim();
                    var dept = deptFilter ? deptFilter.value.toLowerCase() : 'all';
                    var prog = progFilter ? progFilter.value.toLowerCase() : 'all';
                    var visibleCount = 0;

                    rowCache.forEach(function(item) {
                        var matchesSearch = !query || 
                            item.id.indexOf(query) !== -1 || 
                            item.name.indexOf(query) !== -1 || 
                            item.dept.indexOf(query) !== -1 || 
                            item.course.indexOf(query) !== -1 || 
                            item.branch.indexOf(query) !== -1;
                        var matchesDept = (dept === 'all' || dept === '') || item.dept.indexOf(dept) !== -1 || dept.indexOf(item.dept) !== -1;
                        var matchesProg = (prog === 'all' || prog === '') || item.course.indexOf(prog) !== -1 || prog.indexOf(item.course) !== -1;

                        if (matchesSearch && matchesDept && matchesProg) {
                            item.row.style.display = '';
                            visibleCount++;
                        } else {
                            item.row.style.display = 'none';
                        }
                    });

                    if (countPill) {
                        countPill.textContent = visibleCount.toLocaleString();
                    }
                }

                searchInput.addEventListener('input', applyInstantFilter);
            }
        });
    </script>
</asp:Content>
