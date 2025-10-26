<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoanEligibility.aspx.cs" Inherits="LegacyBank.Web.Pages.Loans.LoanEligibility" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Loan Eligibility Check - LegacyBank</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .result { padding: 15px; margin: 20px 0; border: 1px solid #ccc; background-color: #f9f9f9; }
        .eligible { background-color: #d4edda; border-color: #c3e6cb; }
        .ineligible { background-color: #f8d7da; border-color: #f5c6cb; }
        input, button { padding: 8px; margin: 5px 0; }
        button { background-color: #007bff; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>Loan Eligibility Check</h1>
            <p>Check if a customer is eligible for a loan based on credit score, income, and DTI ratio.</p>
            
            <div>
                <label for="txtCustomerId">Customer ID:</label><br />
                <asp:TextBox ID="txtCustomerId" runat="server" Width="200px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCustomerId" runat="server" 
                    ControlToValidate="txtCustomerId" ErrorMessage="Required" ForeColor="Red" />
                <br /><br />
                <asp:Button ID="btnCheck" runat="server" Text="Check Eligibility" OnClick="btnCheck_Click" />
            </div>
            
            <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="result">
                <h2>Eligibility Result</h2>
                <asp:Label ID="lblResult" runat="server"></asp:Label>
                <hr />
                <asp:Label ID="lblDetails" runat="server"></asp:Label>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
