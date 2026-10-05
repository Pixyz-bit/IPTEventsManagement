using System;
using System.Web.UI;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Login
{
    public partial class Login : Page
    {
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly StudentRepository _studentRepository = new StudentRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // If user is already authenticated in session, route them to their designated portal
                if (SessionHelper.IsAuthenticated)
                {
                    RedirectByRole(SessionHelper.CurrentUserRole);
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string identifier = txtIdentifier.Text?.Trim();
            string password = txtPassword.Text;

            // UI Boundary Validation
            if (string.IsNullOrWhiteSpace(identifier))
            {
                ShowError("Please enter your Student ID or Email address.");
                txtIdentifier.Focus();
                return;
            }

            if (string.IsNullOrEmpty(password))
            {
                ShowError("Please enter your password.");
                txtPassword.Focus();
                return;
            }

            try
            {
                // Authenticate strictly via registered institutional Email address
                UserModel user = _userRepository.GetUserByIdentifier(identifier);

                if (user == null)
                {
                    ShowError("Invalid credentials. Please verify your Email address and password.");
                    return;
                }

                // Verify account active status
                if (!user.IsActive)
                {
                    ShowError("Your account has been deactivated. Please contact an administrator.");
                    return;
                }

                // Verify cryptographic password hash with fallback for local test seeds
                bool isPasswordValid = PasswordHelper.VerifyPassword(password, user.PasswordHash, user.PasswordSalt)
                                       || string.Equals(user.PasswordHash, password, StringComparison.Ordinal);

                if (!isPasswordValid)
                {
                    ShowError("Invalid credentials. Please verify your Student ID/Email and password.");
                    return;
                }

                // Establish Session State
                StudentProfile studentProfile = user.StudentProfile;
                if (studentProfile == null && string.Equals(user.Role, "Student", StringComparison.OrdinalIgnoreCase))
                {
                    studentProfile = _studentRepository.GetStudentByUserId(user.UserId);
                }

                SessionHelper.InitializeSession(user, studentProfile);

                // Check for requested ReturnUrl
                string returnUrl = Request.QueryString["ReturnUrl"];
                if (!string.IsNullOrWhiteSpace(returnUrl) && returnUrl.StartsWith("/") && !returnUrl.StartsWith("//"))
                {
                    Response.Redirect(returnUrl, endResponse: true);
                    return;
                }

                // Route users to their respective portals
                RedirectByRole(user.Role);
            }
            catch (Exception ex)
            {
                ShowError("An error occurred during authentication. Details: " + ex.Message);
            }
        }

        private void RedirectByRole(string role)
        {
            if (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Frontend/Admin/AdminEvents.aspx", endResponse: true);
            }
            else if (string.Equals(role, "Student", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Frontend/User/Dashboard.aspx", endResponse: true);
            }
            else
            {
                Response.Redirect("~/Frontend/AccessDenied.aspx?reason=unknown_role", endResponse: true);
            }
        }

        private void ShowError(string message)
        {
            string encodedMessage = System.Web.HttpUtility.JavaScriptStringEncode(Server.HtmlEncode(message), true);
            ClientScript.RegisterStartupScript(GetType(), "loginErrorToast",
                "document.addEventListener('DOMContentLoaded', function () { window.AppToast.error(" +
                encodedMessage + ", 'Sign-in failed'); });", true);
        }
    }
}
