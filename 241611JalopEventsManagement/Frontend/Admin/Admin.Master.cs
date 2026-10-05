using System;
using System.Web.UI;
using _241611JalopEventsManagement.Backend.Helpers;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class Admin : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!SessionHelper.IsAuthenticated)
            {
                Response.Redirect("~/Frontend/Login/Login.aspx", endResponse: true);
                return;
            }

            if (!SessionHelper.IsAdmin)
            {
                Response.Redirect("~/Frontend/AccessDenied.aspx?reason=admin_required", endResponse: true);
                return;
            }

            string email = SessionHelper.CurrentEmail ?? string.Empty;
            litAdminEmail.Text = Server.HtmlEncode(email);
            litAvatarInitials.Text = Server.HtmlEncode(email.Length > 0 ? email.Substring(0, 1).ToUpper() : "A");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            SessionHelper.ClearSession();
            Response.Redirect("~/Frontend/Login/Login.aspx", endResponse: true);
        }
    }
}
