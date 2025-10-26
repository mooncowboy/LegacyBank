using System;
using System.ServiceModel;
using System.Web.UI;
using LegacyBank.BackOffice;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Payments
{
    public partial class PaymentPosting : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Log.Info("PaymentPosting page loaded");
            }
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            try
            {
                int customerId = int.Parse(txtCustomerId.Text);
                decimal amount = decimal.Parse(txtAmount.Text);
                string currency = txtCurrency.Text;
                string reference = txtReference.Text;

                Log.Info($"Posting payment for CustomerId: {customerId}, Amount: {amount} {currency}");

                // Call WCF BackOffice service synchronously (legacy smell - blocking UI thread)
                var binding = new BasicHttpBinding();
                var endpoint = new EndpointAddress("http://localhost:8080/Services/BackOfficeService.svc");
                var channelFactory = new ChannelFactory<IBackOfficeService>(binding, endpoint);
                var client = channelFactory.CreateChannel();

                // Synchronous WCF call (legacy smell)
                var receiptDataSet = client.PostPayment(customerId, amount, currency, reference);
                
                ((IClientChannel)client).Close();
                channelFactory.Close();

                // Display DataSet receipt (legacy smell)
                if (receiptDataSet.Tables.Contains("Receipt"))
                {
                    gvReceipt.DataSource = receiptDataSet.Tables["Receipt"];
                    gvReceipt.DataBind();
                    pnlReceipt.Visible = true;
                }

                Log.Info("Payment posted successfully via WCF service");
            }
            catch (Exception ex)
            {
                Log.Error("Error posting payment", ex);
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }
    }
}
