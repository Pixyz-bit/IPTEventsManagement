using System;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Web.UI;
using _241611JalopEventsManagement.Backend.Repository;

namespace _241611JalopEventsManagement.Frontend.Admin
{
    public partial class TestConnection : _241611JalopEventsManagement.Backend.Helpers.AdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ExecuteConnectivityDiagnostic();
            }
        }

        protected void btnRetest_Click(object sender, EventArgs e)
        {
            ExecuteConnectivityDiagnostic();
        }

        private void ExecuteConnectivityDiagnostic()
        {
            lblTimestamp.Text = DateTime.Now.ToString("HH:mm:ss");

            // Mask any sensitive password tokens in connection string for display
            string rawConn = DatabaseConnection.ConnectionString;
            lblConnectionString.Text = MaskSensitiveTokens(rawConn);

            var stopwatch = Stopwatch.StartNew();
            string errorMessage;
            bool isConnected = DatabaseConnection.TestConnection(out errorMessage);
            stopwatch.Stop();

            lblLatency.Text = $"{stopwatch.ElapsedMilliseconds} ms";

            phStatusBadge.Controls.Clear();
            if (isConnected)
            {
                pnlError.Visible = false;
                phStatusBadge.Controls.Add(new LiteralControl(
                    "<span class=\"badge online\">Operational</span>"
                ));
            }
            else
            {
                pnlError.Visible = true;
                lblErrorMessage.Text = Server.HtmlEncode(errorMessage ?? "Unknown connection error occurred.");
                phStatusBadge.Controls.Add(new LiteralControl(
                    "<span class=\"badge offline\">Unreachable</span>"
                ));
            }
        }

        private static string MaskSensitiveTokens(string connectionString)
        {
            if (string.IsNullOrWhiteSpace(connectionString))
            {
                return "[Unconfigured / Empty]";
            }

            // Mask Password / Pwd / User Id if present
            string masked = Regex.Replace(connectionString, @"(?i)(Password|Pwd)\s*=\s*[^;]+", "$1=********");
            return masked;
        }
    }
}
