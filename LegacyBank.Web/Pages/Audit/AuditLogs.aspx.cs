using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Audit
{
    public partial class AuditLogs : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLogs();
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadLogs();
        }

        private void LoadLogs()
        {
            try
            {
                string logPath = Server.MapPath("~/App_Data/logs/legacybank.log");
                
                if (File.Exists(logPath))
                {
                    // Legacy smell: parse text file (slow/brittle)
                    var lines = File.ReadAllLines(logPath);
                    var last200 = lines.Skip(Math.Max(0, lines.Length - 200)).ToArray();
                    
                    litLogs.Text = Server.HtmlEncode(string.Join("\n", last200));
                    Log.Info("Audit logs loaded");
                }
                else
                {
                    litLogs.Text = "Log file not found. Application may not have logged anything yet.";
                }
            }
            catch (Exception ex)
            {
                litLogs.Text = "Error loading logs: " + ex.Message;
                Log.Error("Error loading audit logs", ex);
            }
        }

        protected void btnDownload_Click(object sender, EventArgs e)
        {
            try
            {
                string logPath = Server.MapPath("~/App_Data/logs/legacybank.log");
                
                if (File.Exists(logPath))
                {
                    // Stream file synchronously (legacy smell - blocks UI thread)
                    Response.Clear();
                    Response.ContentType = "text/plain";
                    Response.AddHeader("Content-Disposition", "attachment;filename=legacybank.log");
                    Response.TransmitFile(logPath);
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                Log.Error("Error downloading logs", ex);
            }
        }
    }
}
