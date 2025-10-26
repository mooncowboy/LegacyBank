using System;

namespace LegacyBank.Web.Models
{
    public class Notification
    {
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
        public DateTime CreatedAt { get; set; }
        public string Status { get; set; }
    }
}
