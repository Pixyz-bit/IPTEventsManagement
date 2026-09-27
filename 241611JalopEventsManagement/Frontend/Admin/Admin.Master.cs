using System;
using System.Web.UI;
using _241611JalopEventsManagement.Backend.Helpers;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class Admin : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (SessionHelper.IsAuthenticated)
            {
                if (!SessionHelper.IsAdmin)
                {
                    Response.Redirect("~/Frontend/AccessDenied.aspx?reason=admin_required", endResponse: true);
                    return;
                }

                pnlPreviewBanner.Visible = false;
                string email = SessionHelper.CurrentEmail ?? "admin@university.edu";
                litAdminEmail.Text = Server.HtmlEncode(email);

                // Compute initials from email
                string initial = email.Length > 0 ? email.Substring(0, 1).ToUpper() : "A";
                litAvatarInitials.Text = initial;
            }
            else
            {
                // UI Preview Mode enabled for immediate frontend visualization
                pnlPreviewBanner.Visible = true;
                litAdminEmail.Text = "preview.admin@univ.edu";
                litAvatarInitials.Text = "PA";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            SessionHelper.ClearSession();
            Response.Redirect("~/Frontend/Login/Login.aspx", endResponse: true);
        }
    }
}
