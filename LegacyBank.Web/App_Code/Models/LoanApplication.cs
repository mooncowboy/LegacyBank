using System;

namespace LegacyBank.Web.Models
{
    public class LoanApplication
    {
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public decimal Amount { get; set; }
        public int TermMonths { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
