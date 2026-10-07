using System;
using System.Web.UI;

namespace _241611JalopEventsManagement.Backend.Helpers
{
    /// <summary>
    /// Authorizes admin requests before page controls load or postback handlers run.
    /// </summary>
    public class AdminPage : Page
    {
        protected Models.EventModel RequireEvent(Repository.EventRepository repository, int eventId)
        {
            Models.EventModel ev;
            try
            {
                ev = eventId > 0 ? repository.GetEventById(eventId) : null;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Loading event context failed: {0}", ex);
                throw new System.Web.HttpException(503, "Event records are temporarily unavailable. Please try again.");
            }
            if (ev == null)
                throw new System.Web.HttpException(404, "The requested event was not found. Choose an existing event from the Events Matrix.");
            return ev;
        }

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

            ViewStateUserKey = Session.SessionID;
            base.OnPreInit(e);
        }
    }
}
