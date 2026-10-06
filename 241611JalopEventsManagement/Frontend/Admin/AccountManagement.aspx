<%@ Page Title="Account Management & Access Governance | QCU Admin" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AccountManagement.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.AccountManagement" EnableEventValidation="false" EnableSessionState="ReadOnly" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/account-management.css?v=3.5") %>" />
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header & Top Operations -->
    <div class="account-header-row">
        <div class="account-title-block">
            <h2>Account Management</h2>
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
            </div>
            <div class="kpi-card-value"><asp:Literal ID="litTotalAccounts" runat="server" Text="0" /></div>
        </div>

        <div class="account-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Active Administrators</span>
            </div>
            <div class="kpi-card-value" style="color:var(--accent-amber);"><asp:Literal ID="litActiveAdmins" runat="server" Text="0" /></div>
        </div>

        <div class="account-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Active Students</span>
            </div>
            <div class="kpi-card-value" style="color:var(--brand-primary);"><asp:Literal ID="litTotalStudents" runat="server" Text="0" /></div>
        </div>

        <div class="account-kpi-card">
            <div class="kpi-card-header">
                <span class="kpi-card-title">Inactive Accounts</span>
            </div>
            <div class="kpi-card-value" style="color:var(--accent-rose);"><asp:Literal ID="litLockedAccounts" runat="server" Text="0" /></div>
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
                                    CausesValidation="false">
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
    <asp:Panel ID="pnlCreateAdminModal" runat="server" Visible="false" CssClass="modal-overlay" style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(6px); -webkit-backdrop-filter: blur(6px); display: flex; align-items: center; justify-content: center; z-index: 99999; padding: 1.5rem; box-sizing: border-box;">
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
    <asp:Panel ID="pnlManageModal" runat="server" Visible="false" CssClass="modal-overlay" style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(6px); -webkit-backdrop-filter: blur(6px); display: flex; align-items: center; justify-content: center; z-index: 99999; padding: 1.5rem; box-sizing: border-box;">
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
    <asp:Panel ID="pnlLockModal" runat="server" Visible="false" CssClass="modal-overlay" style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(6px); -webkit-backdrop-filter: blur(6px); display: flex; align-items: center; justify-content: center; z-index: 99999; padding: 1.5rem; box-sizing: border-box;">
        <div class="modal-box-md" style="max-width: 490px; border-radius: 14px; overflow: hidden; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);">
            <div class="modal-header" style="padding: 1.1rem 1.35rem; border-bottom: 1px solid var(--border-subtle); display:flex; align-items:center; justify-content:space-between; background:#fafbfc;">
                <h3 class="modal-title" style="display:flex; align-items:center; gap:0.6rem; font-size:1.05rem; font-weight:700; color:var(--text-heading); margin:0;">
                    <asp:Literal ID="litLockModalIcon" runat="server" />
                    <asp:Literal ID="litLockModalTitle" runat="server" Text="Confirm Account Status Change" />
                </h3>
                <asp:LinkButton ID="btnCloseLockModal" runat="server" OnClick="btnCloseModals_Click" CausesValidation="false" Style="background:none; border:none; font-size:1.5rem; line-height:1; font-weight:bold; color:var(--text-muted); cursor:pointer;">&times;</asp:LinkButton>
            </div>
            <div class="modal-body" style="padding: 1.35rem 1.5rem; background: #ffffff;">
                <asp:HiddenField ID="hfLockTargetUserId" runat="server" />
                <asp:Literal ID="litLockActionVerb" runat="server" Visible="false" />

                <!-- Account Identity Card Preview -->
                <div style="background: #f8fafc; border: 1px solid var(--border-subtle); border-radius: 10px; padding: 0.95rem 1.15rem; margin-bottom: 1.15rem; display: flex; align-items: center; gap: 0.9rem;">
                    <div style="width: 42px; height: 42px; border-radius: 50%; background: #e2e8f0; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.95rem; color: var(--text-heading); flex-shrink: 0;">
                        <asp:Literal ID="litLockAvatarInitials" runat="server" Text="--" />
                    </div>
                    <div style="flex: 1; min-width: 0;">
                        <div style="display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap; margin-bottom: 0.2rem;">
                            <span style="font-weight: 700; font-size: 0.95rem; color: var(--text-heading);"><asp:Literal ID="litLockTargetName" runat="server" /></span>
                            <asp:Literal ID="litLockRoleBadge" runat="server" />
                        </div>
                        <div style="font-family: var(--font-mono); font-size: 0.8rem; color: var(--text-muted); word-break: break-all;">
                            <asp:Literal ID="litLockTargetEmail" runat="server" />
                        </div>
                    </div>
                </div>

                <!-- Current State to New State Status Row -->
                <div style="display: flex; align-items: center; justify-content: space-between; background: #ffffff; border: 1px dashed var(--border-medium); border-radius: 8px; padding: 0.75rem 1.15rem; margin-bottom: 1.15rem;">
                    <div>
                        <div style="font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.04em; color: var(--text-muted); font-weight: 600; margin-bottom: 0.25rem;">Current Status</div>
                        <div><asp:Literal ID="litLockCurrentStatusBadge" runat="server" /></div>
                    </div>
                    <div style="color: var(--text-muted); padding: 0 0.5rem;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.04em; color: var(--text-muted); font-weight: 600; margin-bottom: 0.25rem;">Target Status</div>
                        <div><asp:Literal ID="litLockNewStatusBadge" runat="server" /></div>
                    </div>
                </div>

                <!-- Contextual Notice Box -->
                <asp:Literal ID="litLockNoticeBox" runat="server" />
            </div>
            <div class="modal-footer" style="padding: 0.95rem 1.35rem; background: #fafbfc; border-top: 1px solid var(--border-subtle); display: flex; align-items: center; justify-content: flex-end; gap: 0.75rem;">
                <asp:Button ID="btnDismissLockModal" runat="server" Text="Cancel" CssClass="btn-action-secondary" OnClick="btnCloseModals_Click" CausesValidation="false" Style="padding: 0.6rem 1.25rem; font-weight: 600;" />
                <asp:Button ID="btnConfirmToggleLock" runat="server" Text="Confirm Status Change" CssClass="btn-action-primary" OnClick="btnConfirmToggleLock_Click" CausesValidation="false" Style="padding: 0.6rem 1.35rem; font-weight: 700; border-radius: 6px; cursor: pointer;" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
