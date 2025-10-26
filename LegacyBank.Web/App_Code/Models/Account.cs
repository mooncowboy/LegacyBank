using System;

namespace LegacyBank.Web.Models
{
    public class Account
    {
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public string IBAN { get; set; }
        public decimal Balance { get; set; }
    }
}
