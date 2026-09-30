<%@ Page Title="Account Management & Access Governance | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AccountManagement.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.AccountManagement" EnableEventValidation="false" EnableSessionState="ReadOnly" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/account-management.css?v=2.3") %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header & Top Operations -->
    <div class="account-header-row">
        <div class="account-title-block">
            <h2>Account Management &amp; Access Governance</h2>
            <p>Institutional identity console, Role-Based Access Control (RBAC), and security credential lifecycle.</p>
        </div>
        <div style="display:none;">
            <asp:LinkButton ID="btnExportAccountsCsv" runat="server" Visible="false" OnClick="btnExportAccountsCsv_Click" />
            <asp:LinkButton ID="btnOpenCreateAdminModal" runat="server" Visible="false" OnClick="btnOpenCreateAdminModal_Click" />
        </div>
    </div>

    <!-- Feedback Notification Banner -->
    <asp:Panel ID="pnlNotification" runat="server" Visible="false" CssClass="feedback-alert">
        <asp:Literal ID="litNotificationMsg" runat="server" />
        <asp:LinkButton ID="btnCloseNotification" runat="server" OnClick="btnCloseNotification_Click" Text="&times;" Style="font-size: 1.25rem; font-weight: bold; background: none; border: none; cursor: pointer; color: inherit;" CausesValidation="false" />
    </asp:Panel>

    <!-- KPI Metrics Ribbon -->
    <div class="account-kpi-grid">
        <div class="account-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Total System Accounts</span>
                <svg class="kpi-card-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
            </div>
            <div class="kpi-card-value"><asp:Literal ID="litTotalAccounts" runat="server" Text="0" /></div>
            <div class="kpi-card-caption">All registered institutional user entities</div>
        </div>

        <div class="account-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Active Administrators</span>
                <svg class="kpi-card-icon" style="color:var(--accent-amber);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                </svg>
            </div>
            <div class="kpi-card-value" style="color:var(--accent-amber);"><asp:Literal ID="litActiveAdmins" runat="server" Text="0" /></div>
            <div class="kpi-card-caption">Authorized governance and event coordinators</div>
        </div>

        <div class="account-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Enrolled Students</span>
                <svg class="kpi-card-icon" style="color:var(--brand-primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                </svg>
            </div>
            <div class="kpi-card-value" style="color:var(--brand-primary);"><asp:Literal ID="litTotalStudents" runat="server" Text="0" /></div>
            <div class="kpi-card-caption">Active student event portal accounts</div>
        </div>

        <div class="account-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Locked / Inactive</span>
                <svg class="kpi-card-icon" style="color:var(--accent-rose);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                </svg>
            </div>
            <div class="kpi-card-value" style="color:var(--accent-rose);"><asp:Literal ID="litLockedAccounts" runat="server" Text="0" /></div>
            <div class="kpi-card-caption">Deactivated or security suspended access</div>
        </div>
    </div>

    <!-- Unified System Accounts Registry Card (Filter Toolbar & Table Combined in 1 div) -->
    <div class="account-table-card">
        <!-- Filtering & Universal Search Toolbar -->
        <div class="account-toolbar">
            <div class="account-search-wrapper">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="account-search-input" Placeholder="Search by email, name, or student ID..." AutoPostBack="true" OnTextChanged="FilterChanged" />
            </div>

            <div class="account-filters-group">
                <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="account-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                    <asp:ListItem Value="ALL" Text="All System Roles" />
                    <asp:ListItem Value="Admin" Text="Administrators (Admin)" />
                    <asp:ListItem Value="Student" Text="Students (Student)" />
                </asp:DropDownList>

                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="account-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                    <asp:ListItem Value="ALL" Text="All Account Statuses" />
                    <asp:ListItem Value="Active" Text="Active Accounts" />
                    <asp:ListItem Value="Locked" Text="Locked / Inactive" />
                </asp:DropDownList>

                <asp:Button ID="btnFilterApply" runat="server" Text="Filter" CssClass="btn-action-primary" Style="height:38px; padding: 0 1rem;" OnClick="btnFilterApply_Click" CausesValidation="false" />
                <asp:Button ID="btnResetFilter" runat="server" Text="Reset" CssClass="btn-action-secondary" Style="height:38px; padding: 0 1rem;" OnClick="btnResetFilter_Click" CausesValidation="false" />
            </div>
        </div>

        <div class="account-table-header-meta">
            <h3>
                <span>System Accounts Registry</span>
                <span class="count-pill"><asp:Literal ID="litShowingCount" runat="server">0</asp:Literal> Accounts</span>
            </h3>
            <span style="font-size:0.775rem; color:var(--text-muted);">
                Centralized Role-Based Access Control (RBAC)
            </span>
        </div>

        <div class="table-responsive">
            <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                <HeaderTemplate>
                    <table class="account-table">
                        <thead>
                            <tr>
                                <th style="width: 42%;">Email Address</th>
                                <th style="width: 18%;">Role</th>
                                <th style="width: 18%;">Status</th>
                                <th style="width: 22%; text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <!-- 1. Email Address -->
                        <td>
                            <div class="user-email-cell">
                                <span class="account-email-text"><%# Eval("Email") %></span>
                            </div>
                        </td>

                        <!-- 2. Role Badge -->
                        <td>
                            <span class='<%# string.Equals(Eval("Role") as string, "Admin", StringComparison.OrdinalIgnoreCase) ? "role-badge-admin" : "role-badge-student" %>'>
                                <%# string.Equals(Eval("Role") as string, "Admin", StringComparison.OrdinalIgnoreCase) ? "&#9733; Admin" : "Student" %>
                            </span>
                        </td>

                        <!-- 3. Account Status -->
                        <td>
                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-badge-active" : "status-badge-locked" %>'>
                                <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-dot-active" : "status-dot-locked" %>'></span>
                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Locked" %>
                            </span>
                        </td>

                        <!-- 4. Action Buttons (Strictly Activate/Deactivate and Manage) -->
                        <td style="text-align: right; white-space: nowrap;">
                            <div class="action-buttons-group">
                                <asp:LinkButton ID="btnToggleActive" runat="server" 
                                    CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "btn-account-action danger" : "btn-account-action success" %>' 
                                    CommandName="ToggleActive" 
                                    CommandArgument='<%# Eval("UserId") %>' 
                                    ToolTip='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate Account" : "Activate Account" %>' 
                                    CausesValidation="false"
                                    OnClientClick='<%# Convert.ToBoolean(Eval("IsActive")) ? "return confirm(\"Are you sure you want to deactivate this account?\");" : "return confirm(\"Are you sure you want to activate this account?\");" %>'>
                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnManage" runat="server" 
                                    CssClass="btn-account-action primary" 
                                    CommandName="Manage" 
                                    CommandArgument='<%# Eval("UserId") %>' 
                                    ToolTip="Manage Account & Credentials" 
                                    CausesValidation="false">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 20h9"></path>
                                        <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                                    </svg>
                                    <span>Manage</span>
                                </asp:LinkButton>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <!-- Zero State Fallback -->
            <asp:Panel ID="pnlNoAccounts" runat="server" Visible="false" Style="padding: 3.5rem 1.5rem; text-align: center; color: var(--text-muted);">
                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin: 0 auto 0.75rem; color: var(--border-medium);">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                </svg>
                <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--text-heading); margin-bottom: 0.35rem;">No Accounts Found</h3>
                <p style="font-size: 0.85rem; max-width: 420px; margin: 0 auto 1.25rem;">No user accounts match the selected role, status, or search query.</p>
                <asp:Button ID="btnResetZeroState" runat="server" Text="Reset Filters" CssClass="btn-action-secondary" OnClick="btnResetFilter_Click" CausesValidation="false" />
            </asp:Panel>
        </div>
    </div>

    <!-- 1. Provision Administrator Modal Dialog -->
    <asp:Panel ID="pnlCreateAdminModal" runat="server" Visible="false" CssClass="modal-overlay">
        <div class="modal-box-md">
            <div class="modal-header">
                <h3 class="modal-title">Provision Administrator Account</h3>
                <asp:LinkButton ID="btnCloseCreateAdminModal" runat="server" OnClick="btnCloseModals_Click" CausesValidation="false" Style="background:none; border:none; font-size:1.5rem; line-height:1; font-weight:bold; color:var(--text-muted); cursor:pointer;">&times;</asp:LinkButton>
            </div>
            <div class="modal-body">
                <div class="modal-notice-box">
                    <strong>Privilege Notice:</strong> Administrator accounts have full administrative governance access, including event publishing, attendance gate clearance overrides, and credential management.
                </div>

                <div class="form-group-modal">
                    <label class="form-label-modal">Institutional Email Address *</label>
                    <asp:TextBox ID="txtNewAdminEmail" runat="server" CssClass="form-input-modal" Placeholder="e.g., coordinator@qcu.edu.ph" TextMode="Email" />
                </div>

                <div class="form-group-modal">
                    <label class="form-label-modal">Temporary Password (Minimum 6 chars) *</label>
                    <asp:TextBox ID="txtNewAdminPassword" runat="server" CssClass="form-input-modal" TextMode="Password" Placeholder="Enter temporary password" />
                </div>

                <div class="form-group-modal">
                    <label class="form-label-modal">Confirm Password *</label>
                    <asp:TextBox ID="txtNewAdminPasswordConfirm" runat="server" CssClass="form-input-modal" TextMode="Password" Placeholder="Re-enter password" />
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnDismissCreateAdmin" runat="server" Text="Cancel" CssClass="btn-action-secondary" OnClick="btnCloseModals_Click" CausesValidation="false" />
                <asp:Button ID="btnSaveNewAdmin" runat="server" Text="Create Administrator" CssClass="btn-action-primary" OnClick="btnSaveNewAdmin_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- 2. Manage Account Modal Dialog (Triggered by 'Manage' button) -->
    <asp:Panel ID="pnlManageModal" runat="server" Visible="false" CssClass="modal-overlay">
        <div class="modal-box-lg">
            <div class="modal-header">
                <h3 class="modal-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color:var(--brand-primary); margin-right:0.35rem; vertical-align:middle;">
                        <path d="M12 20h9"></path>
                        <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                    </svg>
                    <span>Manage User Account &amp; Access Governance</span>
                </h3>
                <asp:LinkButton ID="btnCloseManageModal" runat="server" OnClick="btnCloseModals_Click" CausesValidation="false" Style="background:none; border:none; font-size:1.5rem; line-height:1; font-weight:bold; color:var(--text-muted); cursor:pointer;">&times;</asp:LinkButton>
            </div>
            <div class="modal-body" style="max-height: 75vh; overflow-y: auto; padding: 1.25rem;">
                <asp:HiddenField ID="hfManageUserId" runat="server" />

                <!-- Account Identity Header (No Photo) -->
                <div class="manage-identity-header">
                    <asp:Image ID="imgManageAvatar" runat="server" Visible="false" Style="display:none;" />
                    <asp:Panel ID="pnlManageAvatarPlaceholder" runat="server" Visible="false" Style="display:none;"><asp:Literal ID="litManageAvatarInitials" runat="server" Visible="false" /></asp:Panel>
                    <div class="manage-identity-info">
                        <h4 class="manage-identity-name"><asp:Literal ID="litManageDisplayName" runat="server" /></h4>
                        <div class="manage-identity-email"><asp:Literal ID="litManageEmailSub" runat="server" /></div>
                        <div class="manage-identity-badges">
                            <span class="manage-id-pill">User ID: #<asp:Literal ID="litManageUserIdText" runat="server" /></span>
                            <asp:Literal ID="litManageRoleBadge" runat="server" />
                            <asp:Literal ID="litManageStatusBadge" runat="server" />
                        </div>
                    </div>
                </div>

                <!-- Section A: Account & Security Credentials -->
                <div class="manage-section-card">
                    <h5 class="manage-section-title">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <span>Account Credentials &amp; Access Control</span>
                    </h5>

                    <div class="manage-form-grid">
                        <div class="form-group-modal">
                            <label class="form-label-modal">Institutional Email Address *</label>
                            <asp:TextBox ID="txtManageEmail" runat="server" CssClass="form-input-modal" TextMode="Email" />
                        </div>

                        <div class="form-group-modal">
                            <label class="form-label-modal">Assigned System Role *</label>
                            <asp:DropDownList ID="ddlManageRole" runat="server" CssClass="form-input-modal" AutoPostBack="true" OnSelectedIndexChanged="ddlManageRole_SelectedIndexChanged">
                                <asp:ListItem Value="Admin" Text="Administrator (Admin)" />
                                <asp:ListItem Value="Student" Text="Student (Student)" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="manage-form-grid">
                        <div class="form-group-modal">
                            <label class="form-label-modal">Account Status</label>
                            <asp:DropDownList ID="ddlManageStatus" runat="server" CssClass="form-input-modal">
                                <asp:ListItem Value="Active" Text="Active (Authorized)" />
                                <asp:ListItem Value="Locked" Text="Deactivated / Locked" />
                            </asp:DropDownList>
                        </div>

                        <div class="form-group-modal">
                            <label class="form-label-modal">Reset Password (Optional)</label>
                            <asp:TextBox ID="txtManageNewPassword" runat="server" CssClass="form-input-modal" Placeholder="Leave empty to retain current password" />
                            <small style="color:var(--text-muted); font-size:0.75rem; display:block; margin-top:0.25rem;">
                                Enter at least 6 characters to securely re-hash and update credentials.
                            </small>
                        </div>
                    </div>
                </div>

                <!-- Section B: Academic & Demographic Identity (For Students) -->
                <asp:Panel ID="pnlManageStudentFields" runat="server" CssClass="manage-section-card" Style="margin-top: 1rem;">
                    <h5 class="manage-section-title">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        <span>Student Profile &amp; Academic Demographics</span>
                    </h5>

                    <div class="manage-form-grid">
                        <div class="form-group-modal">
                            <label class="form-label-modal">Student Matriculation ID *</label>
                            <asp:TextBox ID="txtManageStudentId" runat="server" CssClass="form-input-modal" Placeholder="e.g., 24-1611" />
                        </div>

                        <div class="form-group-modal">
                            <label class="form-label-modal">Campus Branch *</label>
                            <asp:DropDownList ID="ddlManageCampus" runat="server" CssClass="form-input-modal">
                                <asp:ListItem Text="San Bartolome (Main)" Value="San Bartolome" />
                                <asp:ListItem Text="Batasan Campus" Value="Batasan" />
                                <asp:ListItem Text="San Francisco Campus" Value="San Francisco" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="manage-form-grid" style="grid-template-columns: 1fr 1fr 1fr;">
                        <div class="form-group-modal">
                            <label class="form-label-modal">First Name *</label>
                            <asp:TextBox ID="txtManageFirstName" runat="server" CssClass="form-input-modal" />
                        </div>
                        <div class="form-group-modal">
                            <label class="form-label-modal">Middle Name</label>
                            <asp:TextBox ID="txtManageMiddleName" runat="server" CssClass="form-input-modal" />
                        </div>
                        <div class="form-group-modal">
                            <label class="form-label-modal">Last Name *</label>
                            <asp:TextBox ID="txtManageLastName" runat="server" CssClass="form-input-modal" />
                        </div>
                    </div>

                    <div class="manage-form-grid">
                        <div class="form-group-modal">
                            <label class="form-label-modal">Department / College *</label>
                            <asp:DropDownList ID="ddlManageDepartment" runat="server" CssClass="form-input-modal" AutoPostBack="true" OnSelectedIndexChanged="ddlManageDepartment_SelectedIndexChanged">
                                <asp:ListItem Text="College of Computer Studies" Value="College of Computer Studies" />
                                <asp:ListItem Text="College of Engineering" Value="College of Engineering" />
                                <asp:ListItem Text="College of Business Administration and Accountancy" Value="College of Business Administration and Accountancy" />
                                <asp:ListItem Text="College of Education" Value="College of Education" />
                            </asp:DropDownList>
                        </div>

                        <div class="form-group-modal">
                            <label class="form-label-modal">Academic Program / Course *</label>
                            <asp:DropDownList ID="ddlManageProgram" runat="server" CssClass="form-input-modal">
                                <asp:ListItem Text="BS Information Technology" Value="BS Information Technology" />
                                <asp:ListItem Text="BS Computer Science" Value="BS Computer Science" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="manage-form-grid">
                        <div class="form-group-modal">
                            <label class="form-label-modal">Gender</label>
                            <asp:DropDownList ID="ddlManageGender" runat="server" CssClass="form-input-modal">
                                <asp:ListItem Text="Male" Value="Male" />
                                <asp:ListItem Text="Female" Value="Female" />
                                <asp:ListItem Text="Non-Binary" Value="Non-Binary" />
                                <asp:ListItem Text="Prefer not to say" Value="Prefer not to say" />
                            </asp:DropDownList>
                        </div>

                        <div class="form-group-modal" style="display:none;">
                            <asp:FileUpload ID="fuManagePhoto" runat="server" Visible="false" accept=".png,.jpg,.jpeg" />
                        </div>
                    </div>
                </asp:Panel>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnDismissManageModal" runat="server" Text="Cancel" CssClass="btn-action-secondary" OnClick="btnCloseModals_Click" CausesValidation="false" />
                <asp:Button ID="btnSaveManageAccount" runat="server" Text="Save Account Changes" CssClass="btn-action-primary" OnClick="btnSaveManageAccount_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- 3. Account Activate / Deactivate Confirmation Modal Dialog -->
    <asp:Panel ID="pnlLockModal" runat="server" Visible="false" CssClass="modal-overlay">
        <div class="modal-box-md">
            <div class="modal-header">
                <h3 class="modal-title"><asp:Literal ID="litLockModalTitle" runat="server" Text="Confirm Account Status Change" /></h3>
                <asp:LinkButton ID="btnCloseLockModal" runat="server" OnClick="btnCloseModals_Click" CausesValidation="false" Style="background:none; border:none; font-size:1.5rem; line-height:1; font-weight:bold; color:var(--text-muted); cursor:pointer;">&times;</asp:LinkButton>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfLockTargetUserId" runat="server" />
                <p style="font-size:0.875rem; color:var(--text-body); margin-bottom:1rem; line-height:1.45;">
                    Are you sure you want to <strong id="actionText"><asp:Literal ID="litLockActionVerb" runat="server" /></strong> access for:
                    <br />
                    <span style="font-family:var(--font-mono); font-weight:600; color:var(--text-heading);"><asp:Literal ID="litLockTargetEmail" runat="server" /></span>?
                </p>

                <div class="modal-notice-box warning">
                    <strong>Security Impact:</strong> Deactivating an account immediately invalidates active sessions and rejects upcoming authentication attempts.
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnDismissLockModal" runat="server" Text="Cancel" CssClass="btn-action-secondary" OnClick="btnCloseModals_Click" CausesValidation="false" />
                <asp:Button ID="btnConfirmToggleLock" runat="server" Text="Confirm Status Change" CssClass="btn-action-primary" Style="background-color:#dc2626; border-color:#dc2626;" OnClick="btnConfirmToggleLock_Click" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
