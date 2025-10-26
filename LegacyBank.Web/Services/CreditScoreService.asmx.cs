using System;
using System.Web.Services;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Services
{
    [WebService(Namespace = "http://legacybank.local/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    public class CreditScoreService : WebService
    {
        [WebMethod]
        public int GetScore(int customerId, string apiKey)
        {
            Log.Info($"CreditScoreService.GetScore called for CustomerId: {customerId}");

            // Legacy smell: check API key (hardcoded validation)
            if (string.IsNullOrEmpty(apiKey))
            {
                Log.Warn("GetScore called without API key");
                return 500; // Default low score
            }

            // Simulate pseudo-stable score based on customer ID
            // This creates a deterministic score between 500-800
            var baseScore = 500;
            var seed = customerId * 137; // Prime number for better distribution
            var variance = Math.Abs(seed % 301); // 0-300 range
            var score = baseScore + variance;

            Log.Info($"Credit score for CustomerId {customerId}: {score}");
            return score;
        }
    }
}
