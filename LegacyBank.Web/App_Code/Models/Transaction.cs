using System;

namespace LegacyBank.Web.Models
{
    public class Transaction
    {
        public int Id { get; set; }
        public int AccountId { get; set; }
        public DateTime TxDate { get; set; }
        public decimal Amount { get; set; }
        public string Type { get; set; }
    }
}
