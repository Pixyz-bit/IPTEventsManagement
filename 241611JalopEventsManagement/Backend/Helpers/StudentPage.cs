using System;
using System.Web.UI;

namespace _241611JalopEventsManagement.Backend.Helpers
{
    /// <summary>Authorizes student requests before controls or postback handlers run.</summary>
    public class StudentPage : Page
    {
        protected override void OnPreInit(EventArgs e)
        {
            if (!SessionHelper.IsAuthenticated)
            {
                Response.Redirect("~/Frontend/Login/Login.aspx", true);
                return;
            }
            if (!SessionHelper.IsStudent)
            {
                Response.Redirect("~/Frontend/AccessDenied.aspx?reason=student_required", true);
                return;
            }
            ViewStateUserKey = Session.SessionID;
            base.OnPreInit(e);
        }
    }
}
