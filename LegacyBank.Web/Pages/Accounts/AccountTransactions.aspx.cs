using System;
using System.Configuration;
using System.Data.SQLite;
using System.Web.UI;
using LegacyBank.Web.Data;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Accounts
{
    public partial class AccountTransactions : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["accountId"] != null)
            {
                txtAccountId.Text = Request.QueryString["accountId"];
                LoadTransactions();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadTransactions();
        }

        private void LoadTransactions()
        {
            if (!string.IsNullOrEmpty(txtAccountId.Text))
            {
                int accountId = int.Parse(txtAccountId.Text);
                Log.Info($"Loading transactions for account {accountId}");
                
                // Intentional SQL injection risk (string concatenation for demo)
                string sql = "SELECT * FROM Transactions WHERE AccountId = " + accountId;
                
                if (!string.IsNullOrEmpty(txtStartDate.Text) && !string.IsNullOrEmpty(txtEndDate.Text))
                {
                    sql += " AND TxDate >= '" + txtStartDate.Text + "' AND TxDate <= '" + txtEndDate.Text + "'";
                }
                
                sql += " ORDER BY TxDate DESC";
                
                var dt = Db.ExecuteDataTable(sql);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();
            }
        }
    }
}
