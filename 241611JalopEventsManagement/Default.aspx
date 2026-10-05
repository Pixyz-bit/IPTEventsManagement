<%@ Page Language="C#" AutoEventWireup="true" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] != null && Session["Role"] != null)
        {
            string role = Session["Role"].ToString();
            if (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Frontend/Admin/AdminEvents.aspx", true);
            }
            else
            {
                Response.Redirect("~/Frontend/User/Dashboard.aspx", true);
            }
        }
        else
        {
            Response.Redirect("~/Frontend/Login/Login.aspx", true);
        }
    }
</script>
<!DOCTYPE html>
<html>
<head>
    <title>Redirecting...</title>
    <meta http-equiv="refresh" content="0;url=Frontend/Login/Login.aspx" />
</head>
<body>
    <p>Redirecting to <a href="Frontend/Login/Login.aspx">University Event Portal</a>...</p>
</body>
</html>
