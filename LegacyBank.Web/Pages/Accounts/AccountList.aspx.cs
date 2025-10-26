using System;
using System.Web.UI;
using LegacyBank.Web.Data;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Accounts
{
    public partial class AccountList : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["customerId"] != null)
            {
                txtCustomerId.Text = Request.QueryString["customerId"];
                LoadAccounts();
            }
        }

        protected void btnLoad_Click(object sender, EventArgs e)
        {
            LoadAccounts();
        }

        private void LoadAccounts()
        {
            if (!string.IsNullOrEmpty(txtCustomerId.Text))
            {
                int customerId = int.Parse(txtCustomerId.Text);
                Log.Info($"Loading accounts for customer {customerId}");
                string sql = "SELECT Id, IBAN, Balance FROM Accounts WHERE CustomerId = @CustomerId";
                var dt = Db.ExecuteDataTable(sql, new System.Data.SQLite.SQLiteParameter("@CustomerId", customerId));
                gvAccounts.DataSource = dt;
                gvAccounts.DataBind();
            }
        }
    }
}
