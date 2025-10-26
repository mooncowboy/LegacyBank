using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using LegacyBank.Web.Data;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Notifications
{
    public partial class EmailNotifications : Page
    {
        protected void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                int customerId = int.Parse(txtCustomerId.Text);
                string subject = txtSubject.Text;
                string body = txtBody.Text;
                
                Log.Info($"Sending notification to customer {customerId}");
                
                // Insert notification record
                string sql = @"INSERT INTO Notifications (CustomerId, Subject, Body, CreatedAt, Status) 
                              VALUES (@CustomerId, @Subject, @Body, @CreatedAt, @Status)";
                Db.ExecuteNonQuery(sql, 
                    new SqlParameter("@CustomerId", customerId),
                    new SqlParameter("@Subject", subject),
                    new SqlParameter("@Body", body),
                    new SqlParameter("@CreatedAt", DateTime.Now),
                    new SqlParameter("@Status", "Sent"));
                
                // Pretend to send email (no actual SMTP if not configured)
                string smtpHost = ConfigurationManager.AppSettings["smtpHost"];
                Log.Info($"Email would be sent via SMTP server: {smtpHost}");
                
                lblResult.Text = "Notification sent successfully!";
                lblResult.ForeColor = System.Drawing.Color.Green;
                
                // Store in session (legacy smell)
                Session["lastNotificationResult"] = "Success";
            }
            catch (Exception ex)
            {
                Log.Error("Error sending notification", ex);
                lblResult.Text = "Error: " + ex.Message;
                lblResult.ForeColor = System.Drawing.Color.Red;
                Session["lastNotificationResult"] = "Failed";
            }
        }
    }
}
