using System;
using System.Web.UI;

namespace _241611JalopEventsManagement.Frontend
{
    public partial class AccessDenied : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                spnTimestamp.InnerText = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss") + " UTC";

                string reason = Request.QueryString["reason"]?.ToLowerInvariant();

                switch (reason)
                {
                    case "expired":
                        lblTitle.Text = "Session Expired";
                        lblDescription.Text = "Your security session has timed out due to inactivity. Please sign in again to resume your work.";
                        break;

                    case "admin_required":
                    case "role":
                        lblTitle.Text = "Administrative Privileges Required";
                        lblDescription.Text = "This resource is reserved for system administrators. Student accounts are not permitted to access administrative controls or management endpoints.";
                        break;

                    case "auth_required":
                        lblTitle.Text = "Authentication Required";
                        lblDescription.Text = "You must be signed in to view this event or register. Please enter your credentials to proceed.";
                        break;

                    default:
                        lblTitle.Text = "Access Restricted";
                        lblDescription.Text = "You do not have authorization to view the requested resource, or your session permissions have changed.";
                        break;
                }

                // If user is currently authenticated as a student, offer a direct path back to their portal
                if (Session["Role"] != null)
                {
                    string role = Session["Role"].ToString();
                    lnkPortal.Visible = true;

                    if (string.Equals(role, "Student", StringComparison.OrdinalIgnoreCase))
                    {
                        lnkPortal.Text = "Go to Student Events Portal";
                        lnkPortal.NavigateUrl = "~/Frontend/User/Dashboard.aspx";
                    }
                    else if (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase))
                    {
                        lnkPortal.Text = "Go to Admin Dashboard";
                        lnkPortal.NavigateUrl = "~/Frontend/Admin/Dashboard.aspx";
                    }
                }
            }
        }
    }
}
