using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using LegacyBank.Web.Data;
using LegacyBank.Web.Logging;

namespace LegacyBank.Web.Pages.Loans
{
    public partial class LoanApplications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Log.Info("LoanApplications page loaded");
                LoadApplications();
            }
        }

        private void LoadApplications()
        {
            string sql = "SELECT Id, CustomerId, Amount, TermMonths, Status, CreatedAt FROM LoanApplications ORDER BY CreatedAt DESC";
            var dt = Db.ExecuteDataTable(sql);
            gvApplications.DataSource = dt;
            gvApplications.DataBind();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                // Inline SQL - legacy smell, no validation
                int customerId = int.Parse(txtCustomerId.Text);
                decimal amount = decimal.Parse(txtAmount.Text);
                int termMonths = int.Parse(txtTermMonths.Text);

                Log.Info($"Submitting new loan application for CustomerId: {customerId}, Amount: {amount}");

                // Direct inline SQL insert (legacy smell)
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["LegacyBankDb"].ConnectionString))
                {
                    conn.Open();
                    string sql = "INSERT INTO LoanApplications (CustomerId, Amount, TermMonths, Status, CreatedAt) VALUES (@CustomerId, @Amount, @TermMonths, @Status, @CreatedAt)";
                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@CustomerId", customerId);
                        cmd.Parameters.AddWithValue("@Amount", amount);
                        cmd.Parameters.AddWithValue("@TermMonths", termMonths);
                        cmd.Parameters.AddWithValue("@Status", "Pending");
                        cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblMessage.Text = "Application submitted successfully!";
                txtCustomerId.Text = "";
                txtAmount.Text = "";
                txtTermMonths.Text = "";
                LoadApplications();

                Log.Info("Loan application submitted successfully");
            }
            catch (Exception ex)
            {
                Log.Error("Error submitting loan application", ex);
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void gvApplications_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvApplications.EditIndex = e.NewEditIndex;
            LoadApplications();
        }

        protected void gvApplications_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int id = Convert.ToInt32(gvApplications.DataKeys[e.RowIndex].Value);
                GridViewRow row = gvApplications.Rows[e.RowIndex];
                DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatus");
                string newStatus = ddlStatus.SelectedValue;

                Log.Info($"Updating loan application {id} status to: {newStatus}");

                // Inline SQL update - no validation (legacy smell)
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["LegacyBankDb"].ConnectionString))
                {
                    conn.Open();
                    string sql = "UPDATE LoanApplications SET Status = @Status WHERE Id = @Id";
                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@Id", id);
                        cmd.ExecuteNonQuery();
                    }
                }

                gvApplications.EditIndex = -1;
                LoadApplications();
                lblMessage.Text = "Application updated successfully!";
            }
            catch (Exception ex)
            {
                Log.Error("Error updating loan application", ex);
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void gvApplications_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvApplications.EditIndex = -1;
            LoadApplications();
        }
    }
}
