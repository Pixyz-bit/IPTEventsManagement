using System;
using System.Web.UI;

namespace _241611JalopEventsManagement.Backend.Helpers
{
    /// <summary>
    /// Authorizes admin requests before page controls load or postback handlers run.
    /// </summary>
    public class AdminPage : Page
    {
        protected override void OnPreInit(EventArgs e)
        {
            if (!SessionHelper.IsAuthenticated)
            {
                Response.Redirect("~/Frontend/Login/Login.aspx", true);
                return;
            }

            if (!SessionHelper.IsAdmin)
            {
                Response.Redirect("~/Frontend/AccessDenied.aspx?reason=admin_required", true);
                return;
            }

            base.OnPreInit(e);
        }
    }
}
