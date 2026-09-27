<%@ Page Language="C#" AutoEventWireup="true" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Redirect("~/Frontend/Admin/TestConnection.aspx", true);
    }
</script>
<!DOCTYPE html>
<html>
<head>
    <title>Redirecting...</title>
    <meta http-equiv="refresh" content="0;url=Frontend/Admin/TestConnection.aspx" />
</head>
<body>
    <p>Redirecting to <a href="Frontend/Admin/TestConnection.aspx">Database Diagnostic</a>...</p>
</body>
</html>
