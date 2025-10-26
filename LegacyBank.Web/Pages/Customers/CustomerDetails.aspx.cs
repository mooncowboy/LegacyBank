using System;
using System.Configuration;
using System.Data.SQLite;
using System.Web.UI;
using LegacyBank.Web.Data;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Customers
{
    public partial class CustomerDetails : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int customerId = Request.QueryString["id"] != null ? int.Parse(Request.QueryString["id"]) : 0;
                
                // Store in session (legacy smell)
                Session["lastViewedCustomerId"] = customerId;
                
                // Check if we have a previous view
                if (Session["lastViewedCustomerId"] != null)
                {
                    Log.Info($"Loading customer details for ID: {customerId}");
                }
                
                LoadCustomerDetails(customerId);
            }
        }

        private void LoadCustomerDetails(int customerId)
        {
            // Mixed data access: inline SQL + Db helper
            using (var conn = new SQLiteConnection(ConfigurationManager.ConnectionStrings["LegacyBankDb"].ConnectionString))
            {
                conn.Open();
                
                // Get customer info (inline SQL)
                string sql = "SELECT Name, NationalId, RiskRating FROM Customers WHERE Id = @Id";
                using (var cmd = new SQLiteCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", customerId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblCustomerInfo.Text = $@"
                                <strong>Customer ID:</strong> {customerId}<br />
                                <strong>Name:</strong> {reader["Name"]}<br />
                                <strong>National ID:</strong> {reader["NationalId"]}<br />
                                <strong>Risk Rating:</strong> {reader["RiskRating"]}
                            ";
                        }
                    }
                }
            }
            
            // Get accounts (using Db helper)
            string accountsSql = "SELECT Id, IBAN, Balance FROM Accounts WHERE CustomerId = @CustomerId";
            var accountsDt = Db.ExecuteDataTable(accountsSql, new SQLiteParameter("@CustomerId", customerId));
            gvAccounts.DataSource = accountsDt;
            gvAccounts.DataBind();
            
            // Get last 5 transactions (inline SQL)
            string transSql = @"
                SELECT t.Id, t.AccountId, t.TxDate, t.Amount, t.Type 
                FROM Transactions t
                INNER JOIN Accounts a ON t.AccountId = a.Id
                WHERE a.CustomerId = @CustomerId
                ORDER BY t.TxDate DESC
                LIMIT 5";
            var transDt = Db.ExecuteDataTable(transSql, new SQLiteParameter("@CustomerId", customerId));
            gvTransactions.DataSource = transDt;
            gvTransactions.DataBind();
        }
    }
}
