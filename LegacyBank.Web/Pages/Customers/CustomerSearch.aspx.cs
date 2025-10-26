using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using LegacyBank.Web.Data;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Customers
{
    public partial class CustomerSearch : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAllCustomers();
            }
        }

        private void LoadAllCustomers()
        {
            // Legacy smell: Load ALL customers into memory
            Log.Info("Loading all customers into memory");
            string sql = "SELECT Id, Name, NationalId, RiskRating FROM Customers";
            var dt = Db.ExecuteDataTable(sql);
            
            // N+1 anti-pattern: for each customer, query latest balance
            dt.Columns.Add("LatestBalance", typeof(decimal));
            foreach (DataRow row in dt.Rows)
            {
                int customerId = Convert.ToInt32(row["Id"]);
                decimal balance = GetLatestBalance(customerId);
                row["LatestBalance"] = balance;
            }
            
            gvCustomers.DataSource = dt;
            gvCustomers.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Filter in memory (legacy smell)
            string searchTerm = txtSearch.Text.ToLower();
            
            string sql = "SELECT Id, Name, NationalId, RiskRating FROM Customers";
            var dt = Db.ExecuteDataTable(sql);
            
            // In-memory filtering
            var filtered = dt.Select($"Name LIKE '%{searchTerm}%' OR NationalId LIKE '%{searchTerm}%'");
            
            if (filtered.Length > 0)
            {
                var resultTable = filtered.CopyToDataTable();
                resultTable.Columns.Add("LatestBalance", typeof(decimal));
                
                foreach (DataRow row in resultTable.Rows)
                {
                    int customerId = Convert.ToInt32(row["Id"]);
                    row["LatestBalance"] = GetLatestBalance(customerId);
                }
                
                gvCustomers.DataSource = resultTable;
            }
            else
            {
                gvCustomers.DataSource = null;
            }
            
            gvCustomers.DataBind();
        }

        private decimal GetLatestBalance(int customerId)
        {
            // N+1 query (legacy smell)
            string sql = "SELECT COALESCE(SUM(Balance), 0) FROM Accounts WHERE CustomerId = @CustomerId";
            var result = Db.ExecuteScalar(sql, new SqlParameter("@CustomerId", customerId));
            return result != null && result != DBNull.Value ? Convert.ToDecimal(result) : 0;
        }
    }
}
