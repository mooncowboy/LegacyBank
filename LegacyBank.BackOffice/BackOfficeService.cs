using System;
using System.Configuration;
using System.Data;
using System.Data.SQLite;

namespace LegacyBank.BackOffice
{
    public class BackOfficeService : IBackOfficeService
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["LegacyBankDb"].ConnectionString; }
        }

        public DataSet PostPayment(int customerId, decimal amount, string currency, string reference)
        {
            var ds = new DataSet();
            var receiptTable = new DataTable("Receipt");
            receiptTable.Columns.Add("Id", typeof(int));
            receiptTable.Columns.Add("Timestamp", typeof(DateTime));
            receiptTable.Columns.Add("Status", typeof(string));
            receiptTable.Columns.Add("Message", typeof(string));

            try
            {
                // Find first account for customer
                using (var conn = new SQLiteConnection(ConnectionString))
                {
                    conn.Open();
                    
                    var accountId = 0;
                    using (var cmd = new SQLiteCommand("SELECT Id FROM Accounts WHERE CustomerId = @CustomerId LIMIT 1", conn))
                    {
                        cmd.Parameters.AddWithValue("@CustomerId", customerId);
                        var result = cmd.ExecuteScalar();
                        if (result == null)
                        {
                            throw new Exception("No account found for customer");
                        }
                        accountId = Convert.ToInt32(result);
                    }

                    // Update account balance (no transaction scope - legacy smell)
                    using (var cmd = new SQLiteCommand("UPDATE Accounts SET Balance = Balance + @Amount WHERE Id = @AccountId", conn))
                    {
                        cmd.Parameters.AddWithValue("@Amount", amount);
                        cmd.Parameters.AddWithValue("@AccountId", accountId);
                        cmd.ExecuteNonQuery();
                    }

                    // Insert transaction
                    using (var cmd = new SQLiteCommand(
                        "INSERT INTO Transactions (AccountId, TxDate, Amount, Type) VALUES (@AccountId, @TxDate, @Amount, @Type)",
                        conn))
                    {
                        cmd.Parameters.AddWithValue("@AccountId", accountId);
                        cmd.Parameters.AddWithValue("@TxDate", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        cmd.Parameters.AddWithValue("@Amount", amount);
                        cmd.Parameters.AddWithValue("@Type", amount >= 0 ? "Credit" : "Debit");
                        cmd.ExecuteNonQuery();
                    }

                    var row = receiptTable.NewRow();
                    row["Id"] = new Random().Next(10000, 99999);
                    row["Timestamp"] = DateTime.Now;
                    row["Status"] = "Success";
                    row["Message"] = $"Payment of {amount} {currency} posted successfully. Ref: {reference}";
                    receiptTable.Rows.Add(row);
                }
            }
            catch (Exception ex)
            {
                var row = receiptTable.NewRow();
                row["Id"] = 0;
                row["Timestamp"] = DateTime.Now;
                row["Status"] = "Failed";
                row["Message"] = "Payment failed: " + ex.Message;
                receiptTable.Rows.Add(row);
            }

            ds.Tables.Add(receiptTable);
            return ds;
        }

        public DataSet GetCustomerBalance(int customerId)
        {
            var ds = new DataSet();
            
            using (var conn = new SQLiteConnection(ConnectionString))
            {
                conn.Open();
                using (var cmd = new SQLiteCommand(
                    "SELECT a.Id, a.IBAN, a.Balance FROM Accounts a WHERE a.CustomerId = @CustomerId",
                    conn))
                {
                    cmd.Parameters.AddWithValue("@CustomerId", customerId);
                    using (var adapter = new SQLiteDataAdapter(cmd))
                    {
                        adapter.Fill(ds, "Balances");
                    }
                }
            }

            return ds;
        }
    }
}
