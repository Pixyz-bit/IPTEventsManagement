using System;
using System.Web.UI;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.User
{
    public partial class StudentProfilePage : Page
    {
        private readonly StudentRepository _studentRepo = new StudentRepository();
        private readonly UserRepository _userRepo = new UserRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStudentProfileData();
            }
        }

        private void LoadStudentProfileData()
        {
            if (SessionHelper.IsAuthenticated && SessionHelper.IsStudent)
            {
                pnlPreviewBanner.Visible = false;
                int userId = SessionHelper.CurrentUserId;
                string studentId = SessionHelper.CurrentStudentId;

                _241611JalopEventsManagement.Backend.Models.StudentProfile profile = null;
                try
                {
                    profile = _studentRepo.GetStudentByUserId(userId);
                    if (profile == null && !string.IsNullOrEmpty(studentId))
                    {
                        profile = _studentRepo.GetStudentById(studentId);
                    }
                }
                catch
                {
                    // Fall back to session values if repository query encounters any issues
                }

                string firstName = profile?.FirstName ?? Session[SessionHelper.KeyFirstName]?.ToString() ?? "Student";
                string middleName = profile?.MiddleName ?? "";
                string lastName = profile?.LastName ?? Session[SessionHelper.KeyLastName]?.ToString() ?? "";
                string matriculationId = profile?.StudentId ?? studentId ?? "STU-2026";

                litNavName.Text = Server.HtmlEncode($"{firstName} {lastName}".Trim());
                litNavId.Text = Server.HtmlEncode(matriculationId);
                litNavAvatar.Text = GetInitials(firstName, lastName);

                // Tab 1: Academic Demographics
                txtStudentId.Text = matriculationId;
                txtCampusBranch.Text = profile?.CampusBranch ?? SessionHelper.CurrentCampusBranch ?? "San Bartolome (Main)";
                txtFirstName.Text = firstName;
                txtMiddleName.Text = string.IsNullOrWhiteSpace(middleName) ? "—" : middleName;
                txtLastName.Text = lastName;
                txtDepartment.Text = profile?.Department ?? SessionHelper.CurrentDepartment ?? "College of Computer Studies";
                txtProgram.Text = profile?.Program ?? SessionHelper.CurrentProgram ?? "BS Information Technology";
                txtGender.Text = profile?.Gender ?? Session[SessionHelper.KeyGender]?.ToString() ?? "Not Specified";
                txtYearLevel.Text = profile?.YearLevel.HasValue == true ? $"{profile.YearLevel.Value}th Year" : "3rd Year";

                // Tab 2: Account Credentials
                txtEmail.Text = profile?.Email ?? SessionHelper.CurrentEmail ?? "student@qcu.edu.ph";
                txtRole.Text = "Student (Student)";
                txtStatus.Text = (profile?.IsActive ?? true) ? "Active (Authorized)" : "Suspended / Inactive";
            }
            else
            {
                // Unauthenticated / Demo Preview Mode
                pnlPreviewBanner.Visible = true;
                litDemoName.Text = "Martin Jalop";
                litNavName.Text = "Martin Jalop";
                litNavId.Text = "24-1611";
                litNavAvatar.Text = "MJ";

                txtStudentId.Text = "24-1611";
                txtCampusBranch.Text = "San Bartolome (Main)";
                txtFirstName.Text = "Martin";
                txtMiddleName.Text = "—";
                txtLastName.Text = "Jalop";
                txtDepartment.Text = "College of Computer Studies";
                txtProgram.Text = "BS Information Technology";
                txtGender.Text = "Male";
                txtYearLevel.Text = "3rd Year";

                txtEmail.Text = "martinj@qcu.edu.ph";
                txtRole.Text = "Student (Student)";
                txtStatus.Text = "Active (Authorized)";
            }
        }

        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
            hfActiveTab.Value = "security";

            if (!SessionHelper.IsAuthenticated || !SessionHelper.IsStudent)
            {
                pnlError.Visible = true;
                litErrorMsg.Text = "You must be authenticated with an active student account to update security credentials.";
                return;
            }

            string currentPassword = txtCurrentPassword.Text?.Trim();
            string newPassword = txtNewPassword.Text?.Trim();
            string confirmPassword = txtConfirmPassword.Text?.Trim();

            // UI Boundary Validations
            if (string.IsNullOrEmpty(currentPassword))
            {
                pnlError.Visible = true;
                litErrorMsg.Text = "Please enter your current account password.";
                txtCurrentPassword.Focus();
                return;
            }

            if (string.IsNullOrEmpty(newPassword) || newPassword.Length < 6)
            {
                pnlError.Visible = true;
                litErrorMsg.Text = "New password must be at least 6 characters in length.";
                txtNewPassword.Focus();
                return;
            }

            if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
            {
                pnlError.Visible = true;
                litErrorMsg.Text = "The confirmation password does not match the new password.";
                txtConfirmPassword.Focus();
                return;
            }

            int userId = SessionHelper.CurrentUserId;
            UserModel user = _userRepo.GetUserById(userId);

            if (user == null)
            {
                pnlError.Visible = true;
                litErrorMsg.Text = "Unable to locate your user account in the system database.";
                return;
            }

            // Cryptographic Verification of Current Password
            bool isCurrentPasswordValid = PasswordHelper.VerifyPassword(currentPassword, user.PasswordHash, user.PasswordSalt);
            if (!isCurrentPasswordValid)
            {
                pnlError.Visible = true;
                litErrorMsg.Text = "Current password does not match our records. Please try again.";
                txtCurrentPassword.Focus();
                return;
            }

            try
            {
                // Generate cryptographically secure salt & PBKDF2 hash
                string newSalt = PasswordHelper.GenerateSalt();
                string newHash = PasswordHelper.HashPassword(newPassword, newSalt);

                bool success = _userRepo.UpdatePassword(userId, newHash, newSalt);
                if (success)
                {
                    pnlSuccess.Visible = true;
                    litSuccessMsg.Text = "Your account password has been updated securely. Please use your new password on next login.";
                    txtCurrentPassword.Text = string.Empty;
                    txtNewPassword.Text = string.Empty;
                    txtConfirmPassword.Text = string.Empty;
                }
                else
                {
                    pnlError.Visible = true;
                    litErrorMsg.Text = "Failed to update your password in the database. Please try again or contact system support.";
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litErrorMsg.Text = "A server error occurred while updating your credentials: " + Server.HtmlEncode(ex.Message);
            }
        }

        private static string GetInitials(string first, string last)
        {
            string f = !string.IsNullOrEmpty(first) ? first.Substring(0, 1).ToUpper() : "S";
            string l = !string.IsNullOrEmpty(last) ? last.Substring(0, 1).ToUpper() : "T";
            return $"{f}{l}";
        }
    }
}
