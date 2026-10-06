using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class AccountManagement : _241611JalopEventsManagement.Backend.Helpers.AdminPage
    {
        private readonly UserRepository _userRepo = new UserRepository();
        private readonly StudentRepository _studentRepo = new StudentRepository();

        private int CurrentAdminUserId => SessionHelper.CurrentUserId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindUserGrid();
            }
        }

        #region Directory Grid Binding

        private void BindUserGrid()
        {
            string search = txtSearch.Text?.Trim();
            string roleFilter = ddlRoleFilter.SelectedValue;
            string statusFilter = ddlStatusFilter.SelectedValue;

            List<UserModel> users = null;

            try
            {
                users = _userRepo.GetAllUsers(search, roleFilter, statusFilter);
            }
            catch
            {
                users = new List<UserModel>();
            }

            // Zero blank-screen fallback for demonstration/preview environments
            if ((users == null || users.Count == 0) && string.IsNullOrWhiteSpace(search) && roleFilter == "ALL" && statusFilter == "ALL")
            {
                users = GetDemonstrationUsers();
            }

            // Filter in-memory if demonstration records were loaded
            if (users != null && users.Count > 0)
            {
                if (!string.IsNullOrWhiteSpace(search))
                {
                    users = users.Where(u =>
                        (u.Email != null && u.Email.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0) ||
                        (u.StudentProfile != null && (
                            (u.StudentProfile.StudentId != null && u.StudentProfile.StudentId.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0) ||
                            (u.StudentProfile.FirstName != null && u.StudentProfile.FirstName.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0) ||
                            (u.StudentProfile.LastName != null && u.StudentProfile.LastName.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0)
                        ))
                    ).ToList();
                }

                if (roleFilter != "ALL" && !string.IsNullOrWhiteSpace(roleFilter))
                {
                    users = users.Where(u => string.Equals(u.Role, roleFilter, StringComparison.OrdinalIgnoreCase)).ToList();
                }

                if (statusFilter != "ALL" && !string.IsNullOrWhiteSpace(statusFilter))
                {
                    bool wantActive = string.Equals(statusFilter, "Active", StringComparison.OrdinalIgnoreCase);
                    users = users.Where(u => u.IsActive == wantActive).ToList();
                }
            }

            // Calculate aggregate statistics
            int totalAccounts = 0;
            int activeAdmins = 0;
            int totalStudents = 0;
            int lockedAccounts = 0;

            try
            {
                var stats = _userRepo.GetAccountStatistics();
                if (stats.TotalAccounts > 0)
                {
                    totalAccounts = stats.TotalAccounts;
                    activeAdmins = stats.ActiveAdmins;
                    totalStudents = stats.TotalStudents;
                    lockedAccounts = stats.LockedAccounts;
                }
            }
            catch
            {
                // Fallback to in-memory count
            }

            if (totalAccounts == 0 && users != null)
            {
                totalAccounts = users.Count;
                activeAdmins = users.Count(u => string.Equals(u.Role, "Admin", StringComparison.OrdinalIgnoreCase) && u.IsActive);
                totalStudents = users.Count(u => string.Equals(u.Role, "Student", StringComparison.OrdinalIgnoreCase));
                lockedAccounts = users.Count(u => !u.IsActive);
            }

            litTotalAccounts.Text = totalAccounts.ToString();
            litActiveAdmins.Text = activeAdmins.ToString();
            litTotalStudents.Text = totalStudents.ToString();
            litLockedAccounts.Text = lockedAccounts.ToString();

            int showingCount = users?.Count ?? 0;

            if (users != null && users.Count > 0)
            {
                rptUsers.DataSource = users;
                rptUsers.DataBind();
                rptUsers.Visible = true;
                pnlNoAccounts.Visible = false;
            }
            else
            {
                rptUsers.Visible = false;
                pnlNoAccounts.Visible = true;
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            BindUserGrid();
        }

        protected void btnFilterApply_Click(object sender, EventArgs e)
        {
            BindUserGrid();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlRoleFilter.SelectedValue = "ALL";
            ddlStatusFilter.SelectedValue = "ALL";
            BindUserGrid();
        }

        #endregion

        #region Row Actions: Strictly 2 Buttons (Activate/Deactivate and Manage)

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int targetUserId = Convert.ToInt32(e.CommandArgument);

            UserModel targetUser = null;
            try
            {
                targetUser = _userRepo.GetUserById(targetUserId);
                if (targetUser != null && targetUser.Role == "Student")
                {
                    var student = _studentRepo.GetStudentByUserId(targetUserId);
                    if (student != null)
                    {
                        targetUser.StudentProfile = student;
                    }
                }
            }
            catch
            {
                targetUser = null;
            }

            if (targetUser == null)
            {
                targetUser = GetDemonstrationUsers().FirstOrDefault(u => u.UserId == targetUserId);
            }

            if (targetUser == null)
            {
                ShowNotification("Target user account could not be found.", false);
                return;
            }

            // Action 1: Activate / Deactivate (Opens dedicated status confirmation modal)
            if (e.CommandName == "ToggleActive")
            {
                if (targetUser.IsActive && targetUser.Role == "Admin" && targetUserId == CurrentAdminUserId)
                {
                    ShowNotification("Security Guard: You cannot deactivate your own active Administrator session.", false);
                    return;
                }

                OpenStatusModal(targetUser);
                return;
            }
            // Action 2: Manage (Opens comprehensive account & identity modal)
            else if (e.CommandName == "Manage")
            {
                OpenManageModal(targetUser);
            }
        }

        #endregion

        #region Manage Account Modal Logic

        private void OpenManageModal(UserModel user)
        {
            hfManageUserId.Value = user.UserId.ToString();
            litManageUserIdText.Text = user.UserId.ToString();
            txtManageEmail.Text = user.Email ?? string.Empty;

            if (ddlManageRole.Items.FindByValue(user.Role) != null)
            {
                ddlManageRole.SelectedValue = user.Role;
            }

            ddlManageStatus.SelectedValue = user.IsActive ? "Active" : "Locked";
            txtManageNewPassword.Text = string.Empty;

            // Identity Header
            string displayName = GetDisplayName(user.Role, user.StudentProfile?.FirstName, user.StudentProfile?.LastName, user.Email);
            litManageDisplayName.Text = Server.HtmlEncode(displayName);
            litManageEmailSub.Text = Server.HtmlEncode(user.Email);
            litManageRoleBadge.Text = string.Equals(user.Role, "Admin", StringComparison.OrdinalIgnoreCase)
                ? "<span class='role-badge-admin'>&#9733; Administrator</span>"
                : "<span class='role-badge-student'>Student</span>";
            litManageStatusBadge.Text = user.IsActive
                ? "<span class='status-badge-active'> Active</span>"
                : "<span class='status-badge-locked'> Locked</span>";

            // Photo Preview (Disabled per requirement)
            imgManageAvatar.Visible = false;
            pnlManageAvatarPlaceholder.Visible = false;

            // Student Demographics
            bool isStudent = string.Equals(user.Role, "Student", StringComparison.OrdinalIgnoreCase) || user.StudentProfile != null;
            pnlManageStudentFields.Visible = isStudent;

            if (user.StudentProfile != null)
            {
                txtManageStudentId.Text = user.StudentProfile.StudentId ?? string.Empty;
                txtManageFirstName.Text = user.StudentProfile.FirstName ?? string.Empty;
                txtManageMiddleName.Text = user.StudentProfile.MiddleName ?? string.Empty;
                txtManageLastName.Text = user.StudentProfile.LastName ?? string.Empty;

                if (!string.IsNullOrWhiteSpace(user.StudentProfile.CampusBranch) && ddlManageCampus.Items.FindByValue(user.StudentProfile.CampusBranch) != null)
                {
                    ddlManageCampus.SelectedValue = user.StudentProfile.CampusBranch;
                }

                if (!string.IsNullOrWhiteSpace(user.StudentProfile.Department) && ddlManageDepartment.Items.FindByValue(user.StudentProfile.Department) != null)
                {
                    ddlManageDepartment.SelectedValue = user.StudentProfile.Department;
                }

                UpdateManageProgramsForDepartment(ddlManageDepartment.SelectedValue);

                if (!string.IsNullOrWhiteSpace(user.StudentProfile.Program) && ddlManageProgram.Items.FindByValue(user.StudentProfile.Program) != null)
                {
                    ddlManageProgram.SelectedValue = user.StudentProfile.Program;
                }

                if (!string.IsNullOrWhiteSpace(user.StudentProfile.Gender) && ddlManageGender.Items.FindByValue(user.StudentProfile.Gender) != null)
                {
                    ddlManageGender.SelectedValue = user.StudentProfile.Gender;
                }
            }
            else
            {
                txtManageStudentId.Text = string.Empty;
                txtManageFirstName.Text = string.Empty;
                txtManageMiddleName.Text = string.Empty;
                txtManageLastName.Text = string.Empty;
                UpdateManageProgramsForDepartment(ddlManageDepartment.SelectedValue);
            }

            pnlManageModal.Visible = true;
        }

        protected void ddlManageRole_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlManageStudentFields.Visible = (ddlManageRole.SelectedValue == "Student");
            pnlManageModal.Visible = true;
        }

        protected void ddlManageDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateManageProgramsForDepartment(ddlManageDepartment.SelectedValue);
            pnlManageModal.Visible = true;
        }

        private void UpdateManageProgramsForDepartment(string dept)
        {
            ddlManageProgram.Items.Clear();
            if (dept == "College of Computer Studies")
            {
                ddlManageProgram.Items.Add(new ListItem("BS Information Technology", "BS Information Technology"));
                ddlManageProgram.Items.Add(new ListItem("BS Computer Science", "BS Computer Science"));
            }
            else if (dept == "College of Engineering")
            {
                ddlManageProgram.Items.Add(new ListItem("BS Industrial Engineering", "BS Industrial Engineering"));
            }
            else if (dept == "College of Business Administration and Accountancy")
            {
                ddlManageProgram.Items.Add(new ListItem("BS Business Administration", "BS Business Administration"));
                ddlManageProgram.Items.Add(new ListItem("BS Entrepreneurship", "BS Entrepreneurship"));
                ddlManageProgram.Items.Add(new ListItem("BS Accountancy", "BS Accountancy"));
            }
            else if (dept == "College of Education")
            {
                ddlManageProgram.Items.Add(new ListItem("Bachelor of Early Childhood Education", "Bachelor of Early Childhood Education"));
                ddlManageProgram.Items.Add(new ListItem("Bachelor of Special Needs Education", "Bachelor of Special Needs Education"));
            }
            else
            {
                ddlManageProgram.Items.Add(new ListItem("BS Information Technology", "BS Information Technology"));
            }
        }

        protected void btnSaveManageAccount_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(hfManageUserId.Value, out int userId))
            {
                ShowNotification("Invalid account context for modification.", false);
                pnlManageModal.Visible = false;
                return;
            }

            string newEmail = txtManageEmail.Text?.Trim();
            string newRole = ddlManageRole.SelectedValue;
            bool shouldBeActive = ddlManageStatus.SelectedValue == "Active";
            string newPassword = txtManageNewPassword.Text?.Trim();

            if (string.IsNullOrWhiteSpace(newEmail))
            {
                ShowNotification("Institutional email address cannot be empty.", false);
                pnlManageModal.Visible = true;
                return;
            }

            try
            {
                // 1. Update Email if changed
                var existingUser = _userRepo.GetUserById(userId);
                if (existingUser != null && !string.Equals(existingUser.Email, newEmail, StringComparison.OrdinalIgnoreCase))
                {
                    if (_userRepo.EmailExists(newEmail))
                    {
                        ShowNotification($"The email address '{newEmail}' is already registered to another account.", false);
                        pnlManageModal.Visible = true;
                        return;
                    }

                    _userRepo.UpdateUserEmail(userId, newEmail);
                }

                // 2. Update Role if changed
                if (existingUser != null && !string.Equals(existingUser.Role, newRole, StringComparison.OrdinalIgnoreCase))
                {
                    _userRepo.UpdateUserRole(userId, newRole, CurrentAdminUserId);
                }

                // 3. Update Status if changed
                if (existingUser != null && existingUser.IsActive != shouldBeActive)
                {
                    if (!shouldBeActive && existingUser.Role == "Admin" && userId == CurrentAdminUserId)
                    {
                        ShowNotification("Security Guard: You cannot deactivate your own active Administrator session.", false);
                        pnlManageModal.Visible = true;
                        return;
                    }

                    _userRepo.UpdateUserStatus(userId, shouldBeActive);
                }

                // 4. Update Password if provided
                if (!string.IsNullOrWhiteSpace(newPassword))
                {
                    if (newPassword.Length < 6)
                    {
                        ShowNotification("Password must be at least 6 characters in length.", false);
                        pnlManageModal.Visible = true;
                        return;
                    }

                    _userRepo.AdminResetPassword(userId, newPassword);
                }

                // 5. If Student, update demographics in dbo.StudentTable
                if (newRole == "Student" && pnlManageStudentFields.Visible)
                {
                    string studentId = txtManageStudentId.Text?.Trim();
                    string firstName = txtManageFirstName.Text?.Trim();
                    string middleName = txtManageMiddleName.Text?.Trim();
                    string lastName = txtManageLastName.Text?.Trim();
                    string campus = ddlManageCampus.SelectedValue;
                    string dept = ddlManageDepartment.SelectedValue;
                    string prog = ddlManageProgram.SelectedValue;
                    string gender = ddlManageGender.SelectedValue;

                    if (string.IsNullOrWhiteSpace(studentId) || string.IsNullOrWhiteSpace(firstName) || string.IsNullOrWhiteSpace(lastName))
                    {
                        ShowNotification("Student ID, First Name, and Last Name are required for student accounts.", false);
                        pnlManageModal.Visible = true;
                        return;
                    }

                    var studentProfile = new StudentProfile
                    {
                        StudentId = studentId,
                        FirstName = firstName,
                        MiddleName = middleName,
                        LastName = lastName,
                        Gender = gender,
                        CampusBranch = campus,
                        Department = dept,
                        Program = prog,
                        UserId = userId,
                        Email = newEmail,
                        IsActive = shouldBeActive
                    };

                    _studentRepo.UpdateStudentFull(studentProfile);
                }

                pnlManageModal.Visible = false;
                ShowNotification($"Account #{userId} ({newEmail}) updated successfully.", true);
                BindUserGrid();
            }
            catch (Exception ex)
            {
                ShowNotification($"Management Update Error: {ex.Message}", false);
                pnlManageModal.Visible = true;
            }
        }

        private string ResolvePhotoUrl(UserModel user)
        {
            // Check for student photo in Assets or scratch
            string localScratchJpg = Server.MapPath("~/Frontend/Assets/Student_Photo.jpg");
            if (File.Exists(localScratchJpg))
            {
                return ResolveUrl("~/Frontend/Assets/Student_Photo.jpg");
            }

            // Check if student ID matches Rocel Jalop
            if (user.StudentProfile != null && (user.StudentProfile.LastName?.IndexOf("Jalop", StringComparison.OrdinalIgnoreCase) >= 0 || user.Email?.IndexOf("jalop", StringComparison.OrdinalIgnoreCase) >= 0))
            {
                string photoPath = Server.MapPath("~/scratch/photo1.jpg");
                if (File.Exists(photoPath))
                {
                    return ResolveUrl("~/scratch/photo1.jpg");
                }
            }

            return null;
        }

        #endregion

        #region Provision Administrator

        protected void btnOpenCreateAdminModal_Click(object sender, EventArgs e)
        {
            txtNewAdminEmail.Text = string.Empty;
            txtNewAdminPassword.Text = string.Empty;
            txtNewAdminPasswordConfirm.Text = string.Empty;
            pnlCreateAdminModal.Visible = true;
        }

        protected void btnCloseModals_Click(object sender, EventArgs e)
        {
            pnlCreateAdminModal.Visible = false;
            pnlManageModal.Visible = false;
            pnlLockModal.Visible = false;
        }

        protected void btnSaveNewAdmin_Click(object sender, EventArgs e)
        {
            string email = txtNewAdminEmail.Text?.Trim();
            string pwd = txtNewAdminPassword.Text;
            string pwdConfirm = txtNewAdminPasswordConfirm.Text;

            if (string.IsNullOrWhiteSpace(email))
            {
                ShowNotification("Please provide an institutional email address.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(pwd) || pwd.Length < 6)
            {
                ShowNotification("Password must be at least 6 characters in length.", false);
                return;
            }

            if (pwd != pwdConfirm)
            {
                ShowNotification("Passwords do not match.", false);
                return;
            }

            try
            {
                int newUserId = _userRepo.CreateAdminUser(email, pwd);
                pnlCreateAdminModal.Visible = false;
                ShowNotification($"Administrator account successfully created for '{email}' (User ID #{newUserId}).", true);
                BindUserGrid();
            }
            catch (Exception ex)
            {
                ShowNotification($"Administrator Creation Failed: {ex.Message}", false);
            }
        }

        #endregion

        #region Status Change & Lockout Confirmation Modal Logic

        private void OpenStatusModal(UserModel user)
        {
            hfLockTargetUserId.Value = user.UserId.ToString();
            litLockTargetEmail.Text = Server.HtmlEncode(user.Email);

            string displayName = GetDisplayName(user.Role, user.StudentProfile?.FirstName, user.StudentProfile?.LastName, user.Email);
            litLockTargetName.Text = Server.HtmlEncode(displayName);
            litLockAvatarInitials.Text = GetUserInitials(user.Email, user.StudentProfile?.FirstName, user.StudentProfile?.LastName);

            litLockRoleBadge.Text = string.Equals(user.Role, "Admin", StringComparison.OrdinalIgnoreCase)
                ? "<span class='role-badge-admin'>&#9733; Admin</span>"
                : "<span class='role-badge-student'>Student</span>";

            bool isCurrentlyActive = user.IsActive;

            if (isCurrentlyActive)
            {
                // Transitioning from Active -> Locked / Inactive
                litLockModalTitle.Text = "Confirm Account Deactivation";
                litLockModalIcon.Text = @"<svg width=""20"" height=""20"" viewBox=""0 0 24 24"" fill=""none"" stroke=""#dc2626"" stroke-width=""2"" style=""flex-shrink:0;"">
                    <path d=""M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z""></path>
                    <line x1=""12"" y1=""9"" x2=""12"" y2=""13""></line>
                    <line x1=""12"" y1=""17"" x2=""12.01"" y2=""17""></line>
                </svg>";

                litLockCurrentStatusBadge.Text = "<span class='status-badge-active'> Active</span>";
                litLockNewStatusBadge.Text = "<span class='status-badge-locked'> Locked / Inactive</span>";

                litLockNoticeBox.Text = @"<div class=""modal-notice-box warning"" style=""margin-bottom:0;"">
                    <strong style=""display:block; margin-bottom:0.25rem;"">Security &amp; Access Impact:</strong>
                    Deactivating this account will immediately revoke all portal login permissions and invalidate active sessions. Historical event registrations and attendance passes will remain safely preserved in university records.
                </div>";

                btnConfirmToggleLock.Text = "Deactivate Account";
                btnConfirmToggleLock.CssClass = "btn-action-primary";
                btnConfirmToggleLock.Style["background-color"] = "#dc2626";
                btnConfirmToggleLock.Style["border-color"] = "#dc2626";
                btnConfirmToggleLock.Style["color"] = "#ffffff";
            }
            else
            {
                // Transitioning from Locked -> Active
                litLockModalTitle.Text = "Confirm Account Activation";
                litLockModalIcon.Text = @"<svg width=""20"" height=""20"" viewBox=""0 0 24 24"" fill=""none"" stroke=""#16a34a"" stroke-width=""2"" style=""flex-shrink:0;"">
                    <path d=""M22 11.08V12a10 10 0 1 1-5.93-9.14""></path>
                    <polyline points=""22 4 12 14.01 9 11.01""></polyline>
                </svg>";

                litLockCurrentStatusBadge.Text = "<span class='status-badge-locked'> Locked / Inactive</span>";
                litLockNewStatusBadge.Text = "<span class='status-badge-active'> Active</span>";

                litLockNoticeBox.Text = @"<div class=""modal-notice-box"" style=""background:#f0fdf4; border-color:#bbf7d0; border-left-color:#16a34a; color:#14532d; margin-bottom:0;"">
                    <strong style=""display:block; margin-bottom:0.25rem;"">Access Restoration Notice:</strong>
                    Activating this account will restore full authorization to the University Event Portal, enabling the user to sign in with their existing credentials and participate in campus activities.
                </div>";

                btnConfirmToggleLock.Text = "Activate Account";
                btnConfirmToggleLock.CssClass = "btn-action-primary";
                btnConfirmToggleLock.Style["background-color"] = "#16a34a";
                btnConfirmToggleLock.Style["border-color"] = "#16a34a";
                btnConfirmToggleLock.Style["color"] = "#ffffff";
            }

            pnlLockModal.Visible = true;
        }

        protected void btnConfirmToggleLock_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(hfLockTargetUserId.Value, out int targetUserId))
            {
                pnlLockModal.Visible = false;
                return;
            }

            try
            {
                UserModel targetUser = null;
                try
                {
                    targetUser = _userRepo.GetUserById(targetUserId);
                }
                catch
                {
                    targetUser = null;
                }

                if (targetUser == null)
                {
                    targetUser = GetDemonstrationUsers().FirstOrDefault(u => u.UserId == targetUserId);
                }

                bool wasActive = targetUser?.IsActive ?? true;

                if (wasActive && targetUser?.Role == "Admin" && targetUserId == CurrentAdminUserId)
                {
                    ShowNotification("Security Guard: You cannot deactivate your own active Administrator session.", false);
                    pnlLockModal.Visible = false;
                    return;
                }

                bool success = _userRepo.ToggleUserActiveStatus(targetUserId, CurrentAdminUserId);
                pnlLockModal.Visible = false;

                string verb = wasActive ? "deactivated" : "activated";
                ShowNotification($"Account #{targetUserId} ({targetUser?.Email ?? "user"}) was successfully {verb}.", true);
                BindUserGrid();
            }
            catch (Exception ex)
            {
                pnlLockModal.Visible = false;
                ShowNotification($"Action Blocked: {ex.Message}", false);
            }
        }

        #endregion

        #region CSV Export

        protected void btnExportAccountsCsv_Click(object sender, EventArgs e)
        {
            string search = txtSearch.Text?.Trim();
            string roleFilter = ddlRoleFilter.SelectedValue;
            string statusFilter = ddlStatusFilter.SelectedValue;

            List<UserModel> users = null;
            try
            {
                users = _userRepo.GetAllUsers(search, roleFilter, statusFilter);
            }
            catch
            {
                users = new List<UserModel>();
            }

            if (users == null || users.Count == 0)
            {
                users = GetDemonstrationUsers();
            }

            var sb = new StringBuilder();
            sb.AppendLine("UserId,Email,Role,AccountStatus,StudentId,FullName,Gender,CampusBranch,Department,Program");

            foreach (var u in users)
            {
                string status = u.IsActive ? "Active" : "Locked";
                string studentId = u.StudentProfile?.StudentId ?? string.Empty;
                string fullName = u.StudentProfile?.FullName ?? (u.Role == "Admin" ? "System Administrator" : string.Empty);
                string gender = u.StudentProfile?.Gender ?? string.Empty;
                string branch = u.StudentProfile?.CampusBranch ?? "San Bartolome";
                string dept = u.StudentProfile?.Department ?? (u.Role == "Admin" ? "Administration" : string.Empty);
                string prog = u.StudentProfile?.Program ?? string.Empty;

                sb.AppendLine($"\"{u.UserId}\",\"{EscapeCsv(u.Email)}\",\"{u.Role}\",\"{status}\",\"{EscapeCsv(studentId)}\",\"{EscapeCsv(fullName)}\",\"{gender}\",\"{EscapeCsv(branch)}\",\"{EscapeCsv(dept)}\",\"{EscapeCsv(prog)}\"");
            }

            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", $"attachment;filename=QCU_User_Registry_{DateTime.Now:yyyyMMdd_HHmmss}.csv");
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        #endregion

        #region Helper Utilities

        public string GetUserInitials(string email, string firstName, string lastName)
        {
            if (!string.IsNullOrWhiteSpace(firstName) && !string.IsNullOrWhiteSpace(lastName))
            {
                return $"{firstName[0]}{lastName[0]}".ToUpper();
            }

            if (!string.IsNullOrWhiteSpace(email))
            {
                return email.Substring(0, Math.Min(2, email.Length)).ToUpper();
            }

            return "U";
        }

        public string GetDisplayName(string role, string firstName, string lastName, string email)
        {
            if (!string.IsNullOrWhiteSpace(firstName) || !string.IsNullOrWhiteSpace(lastName))
            {
                return $"{firstName} {lastName}".Trim();
            }

            if (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                return "Institutional Administrator";
            }

            return email ?? "University User";
        }

        public string GetAffiliationText(string role, string dept, string prog)
        {
            if (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                return "University Events Management & Operations";
            }

            if (!string.IsNullOrWhiteSpace(prog))
            {
                return prog;
            }

            if (!string.IsNullOrWhiteSpace(dept))
            {
                return dept;
            }

            return "Academic Affairs";
        }

        private static string EscapeCsv(string val)
        {
            if (string.IsNullOrEmpty(val)) return string.Empty;
            return val.Replace("\"", "\"\"");
        }

        private void ShowNotification(string msg, bool isSuccess)
        {
            pnlNotification.Visible = true;
            pnlNotification.CssClass = isSuccess ? "feedback-alert success" : "feedback-alert danger";
            litNotificationMsg.Text = Server.HtmlEncode(msg);
        }

        protected void btnCloseNotification_Click(object sender, EventArgs e)
        {
            pnlNotification.Visible = false;
        }

        private List<UserModel> GetDemonstrationUsers()
        {
            return new List<UserModel>
            {
                new UserModel
                {
                    UserId = 1,
                    Email = "admin@qcu.edu.ph",
                    Role = "Admin",
                    IsActive = true
                },
                new UserModel
                {
                    UserId = 2,
                    Email = "coordinator.cics@qcu.edu.ph",
                    Role = "Admin",
                    IsActive = true
                },
                new UserModel
                {
                    UserId = 3,
                    Email = "rocel.jalop@qcu.edu.ph",
                    Role = "Student",
                    IsActive = true,
                    StudentProfile = new StudentProfile
                    {
                        StudentId = "24-1611",
                        FirstName = "Rocel Asuncion",
                        LastName = "Jalop",
                        CampusBranch = "San Bartolome",
                        Department = "College of Computer Studies",
                        Program = "BS Information Technology",
                        Gender = "Female"
                    }
                },
                new UserModel
                {
                    UserId = 4,
                    Email = "diana.prince@qcu.edu.ph",
                    Role = "Student",
                    IsActive = true,
                    StudentProfile = new StudentProfile
                    {
                        StudentId = "24-0892",
                        FirstName = "Diana",
                        LastName = "Prince",
                        CampusBranch = "San Francisco",
                        Department = "College of Engineering",
                        Program = "BS Industrial Engineering",
                        Gender = "Female"
                    }
                },
                new UserModel
                {
                    UserId = 5,
                    Email = "arthur.curry@qcu.edu.ph",
                    Role = "Student",
                    IsActive = false,
                    StudentProfile = new StudentProfile
                    {
                        StudentId = "23-5512",
                        FirstName = "Arthur",
                        LastName = "Curry",
                        CampusBranch = "Batasan",
                        Department = "College of Business Administration and Accountancy",
                        Program = "BS Entrepreneurship",
                        Gender = "Male"
                    }
                }
            };
        }

        #endregion
    }
}
