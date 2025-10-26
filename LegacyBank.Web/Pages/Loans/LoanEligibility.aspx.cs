using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using LegacyBank.Web.Data;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Loans
{
    public partial class LoanEligibility : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Log.Info("LoanEligibility page loaded");
            }
        }

        protected void btnCheck_Click(object sender, EventArgs e)
        {
            try
            {
                int customerId = int.Parse(txtCustomerId.Text);
                Log.Info($"Checking loan eligibility for CustomerId: {customerId}");

                // Check cache first (legacy smell - Session + Cache)
                string cacheKey = $"eligibility:{customerId}";
                if (Cache[cacheKey] != null && Session["eligibilityCache"] != null)
                {
                    Log.Info("Returning cached eligibility result");
                    var cachedResult = (bool)Cache[cacheKey];
                    DisplayResult(cachedResult, "CACHED DATA", 0, 0, 0);
                    return;
                }

                // Step 1: Get credit score via ASMX service (synchronous - legacy smell)
                var creditService = new Services.CreditScoreService();
                string apiKey = ConfigurationManager.AppSettings["creditScoreApiKey"];
                int creditScore = creditService.GetScore(customerId, apiKey);
                Log.Info($"Credit score retrieved: {creditScore}");

                // Step 2: Calculate average monthly inflow for last 3 months (mixed data access)
                decimal avgMonthlyInflow = CalculateAvgMonthlyInflow(customerId);
                Log.Info($"Average monthly inflow: {avgMonthlyInflow}");

                // Step 3: Calculate DTI (dummy calculation for demo)
                decimal dtiRatio = CalculateDTI(customerId);
                Log.Info($"DTI ratio: {dtiRatio}");

                // Business rule: eligible if score >= 650 AND avg inflow >= 1500 AND DTI <= 0.35
                bool isEligible = creditScore >= 650 && avgMonthlyInflow >= 1500 && dtiRatio <= 0.35m;

                // Cache result (legacy smell - both Session and Cache)
                Cache.Insert(cacheKey, isEligible, null, DateTime.Now.AddMinutes(2), System.Web.Caching.Cache.NoSlidingExpiration);
                Session["eligibilityCache"] = DateTime.Now;

                DisplayResult(isEligible, isEligible ? "ELIGIBLE" : "NOT ELIGIBLE", creditScore, avgMonthlyInflow, dtiRatio);
                Log.Info($"Eligibility check complete: {isEligible}");
            }
            catch (Exception ex)
            {
                Log.Error("Error checking loan eligibility", ex);
                lblResult.Text = "Error: " + ex.Message;
                pnlResult.Visible = true;
            }
        }

        private decimal CalculateAvgMonthlyInflow(int customerId)
        {
            // Mixed data access: inline SQL + Db helper
            // Get last 3 months of positive transactions
            DateTime threeMonthsAgo = DateTime.Now.AddMonths(-3);
            
            string sql = @"
                SELECT AVG(CAST(MonthlySum AS DECIMAL(18,2))) as AvgInflow
                FROM (
                    SELECT FORMAT(t.TxDate, 'yyyy-MM') as Month, SUM(t.Amount) as MonthlySum
                    FROM Transactions t
                    INNER JOIN Accounts a ON t.AccountId = a.Id
                    WHERE a.CustomerId = @CustomerId 
                        AND t.Amount > 0 
                        AND t.TxDate >= @ThreeMonthsAgo
                    GROUP BY FORMAT(t.TxDate, 'yyyy-MM')
                ) MonthlyTotals";

            var result = Db.ExecuteScalar(sql, 
                new SqlParameter("@CustomerId", customerId),
                new SqlParameter("@ThreeMonthsAgo", threeMonthsAgo));

            return result != null && result != DBNull.Value ? Convert.ToDecimal(result) : 0;
        }

        private decimal CalculateDTI(int customerId)
        {
            // Inline SQL (legacy smell)
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["LegacyBankDb"].ConnectionString))
            {
                conn.Open();
                string sql = @"
                    SELECT COALESCE(SUM(CASE WHEN Amount < 0 THEN ABS(Amount) ELSE 0 END), 0) as TotalDebt,
                           COALESCE(SUM(CASE WHEN Amount > 0 THEN Amount ELSE 0 END), 0) as TotalIncome
                    FROM Transactions t
                    INNER JOIN Accounts a ON t.AccountId = a.Id
                    WHERE a.CustomerId = @CustomerId 
                        AND t.TxDate >= DATEADD(MONTH, -3, GETDATE())";

                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CustomerId", customerId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            decimal debt = reader.GetDecimal(0);
                            decimal income = reader.GetDecimal(1);
                            return income > 0 ? debt / income : 1.0m;
                        }
                    }
                }
            }
            return 1.0m;
        }

        private void DisplayResult(bool isEligible, string status, decimal creditScore, decimal avgInflow, decimal dti)
        {
            pnlResult.Visible = true;
            pnlResult.CssClass = isEligible ? "result eligible" : "result ineligible";
            lblResult.Text = $"<strong>{status}</strong>";
            lblDetails.Text = $@"
                <strong>Customer ID:</strong> {txtCustomerId.Text}<br />
                <strong>Credit Score:</strong> {creditScore}<br />
                <strong>Avg Monthly Inflow:</strong> ${avgInflow:N2}<br />
                <strong>DTI Ratio:</strong> {dti:P2}<br />
                <strong>Requirements:</strong><br />
                - Credit Score ≥ 650: {(creditScore >= 650 ? "✓" : "✗")}<br />
                - Monthly Inflow ≥ $1,500: {(avgInflow >= 1500 ? "✓" : "✗")}<br />
                - DTI Ratio ≤ 35%: {(dti <= 0.35m ? "✓" : "✗")}
            ";
        }
    }
}
