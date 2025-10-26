using System;
using System.Data;
using System.Text;
using System.Web.UI;
using LegacyBank.Web.Data;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Payments
{
    public partial class PaymentHistory : Page
    {
        private DataTable _data;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHistory(null);
            }
        }

        private void LoadHistory(int? customerId)
        {
            string sql = @"SELECT t.Id, t.AccountId, a.CustomerId, t.TxDate, t.Amount, t.Type 
                          FROM Transactions t 
                          INNER JOIN Accounts a ON t.AccountId = a.Id";
            
            if (customerId.HasValue)
            {
                sql += " WHERE a.CustomerId = " + customerId.Value;
            }
            
            sql += " ORDER BY t.TxDate DESC";
            
            _data = Db.ExecuteDataTable(sql);
            
            // Naive in-memory paging (legacy smell - loads all data)
            gvHistory.DataSource = _data;
            gvHistory.DataBind();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtCustomerId.Text))
            {
                LoadHistory(int.Parse(txtCustomerId.Text));
            }
            else
            {
                LoadHistory(null);
            }
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            // Blocking IO on UI thread (legacy smell)
            Log.Info("Exporting payment history to CSV");
            
            var csv = new StringBuilder();
            csv.AppendLine("Id,AccountId,CustomerId,TxDate,Amount,Type");
            
            foreach (DataRow row in _data.Rows)
            {
                csv.AppendLine($"{row["Id"]},{row["AccountId"]},{row["CustomerId"]},{row["TxDate"]},{row["Amount"]},{row["Type"]}");
            }
            
            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", "attachment;filename=payment_history.csv");
            Response.Write(csv.ToString());
            Response.End();
        }
    }
}
