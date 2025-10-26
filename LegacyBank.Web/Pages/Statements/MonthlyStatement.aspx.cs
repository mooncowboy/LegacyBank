using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using LegacyBank.Web.Data;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Statements
{
    public partial class MonthlyStatement : Page
    {
        private DataTable _statementData;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["accountId"] != null)
                {
                    txtAccountId.Text = Request.QueryString["accountId"];
                    txtYear.Text = Request.QueryString["year"] ?? DateTime.Now.Year.ToString();
                    txtMonth.Text = Request.QueryString["month"] ?? DateTime.Now.Month.ToString();
                }
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            int accountId = int.Parse(txtAccountId.Text);
            int year = int.Parse(txtYear.Text);
            int month = int.Parse(txtMonth.Text);
            
            string cacheKey = $"statement:{accountId}:{year:D4}{month:D2}";
            
            // Check cache (legacy smell - 5 minute TTL)
            if (Cache[cacheKey] != null)
            {
                Log.Info("Returning cached statement");
                _statementData = (DataTable)Cache[cacheKey];
            }
            else
            {
                Log.Info($"Generating statement for account {accountId}, {year}-{month}");
                
                // Query OLTP tables directly (legacy smell - locks UI)
                string sql = @"SELECT TxDate, Amount, Type 
                              FROM Transactions 
                              WHERE AccountId = @AccountId 
                              AND YEAR(TxDate) = @Year 
                              AND MONTH(TxDate) = @Month
                              ORDER BY TxDate";
                
                _statementData = Db.ExecuteDataTable(sql, 
                    new SqlParameter("@AccountId", accountId),
                    new SqlParameter("@Year", year),
                    new SqlParameter("@Month", month));
                
                Cache.Insert(cacheKey, _statementData, null, DateTime.Now.AddMinutes(5), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            
            gvStatement.DataSource = _statementData;
            gvStatement.DataBind();
            pnlStatement.Visible = true;
        }

        protected void btnDownload_Click(object sender, EventArgs e)
        {
            if (_statementData == null)
            {
                btnGenerate_Click(sender, e);
            }
            
            var csv = new StringBuilder();
            csv.AppendLine("TxDate,Amount,Type");
            foreach (DataRow row in _statementData.Rows)
            {
                csv.AppendLine($"{row["TxDate"]},{row["Amount"]},{row["Type"]}");
            }
            
            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", "attachment;filename=statement.csv");
            Response.Write(csv.ToString());
            Response.End();
        }
    }
}
