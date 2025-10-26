<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PaymentPosting.aspx.cs" Inherits="LegacyBank.Web.Pages.Payments.PaymentPosting" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Payment Posting - LegacyBank</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #28a745; color: white; }
        input, button { padding: 8px; margin: 5px 0; }
        button { background-color: #28a745; color: white; border: none; cursor: pointer; }
        .form-section { background-color: #f9f9f9; padding: 15px; margin: 20px 0; border: 1px solid #ccc; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>Payment Posting</h1>
            
            <div class="form-section">
                <h2>Post New Payment</h2>
                <table style="border: none;">
                    <tr style="background-color: transparent;">
                        <td style="border: none;">Customer ID:</td>
                        <td style="border: none;">
                            <asp:TextBox ID="txtCustomerId" runat="server" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="background-color: transparent;">
                        <td style="border: none;">Amount:</td>
                        <td style="border: none;">
                            <asp:TextBox ID="txtAmount" runat="server" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="background-color: transparent;">
                        <td style="border: none;">Currency:</td>
                        <td style="border: none;">
                            <asp:TextBox ID="txtCurrency" runat="server" Width="150px" Text="USD"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="background-color: transparent;">
                        <td style="border: none;">Reference:</td>
                        <td style="border: none;">
                            <asp:TextBox ID="txtReference" runat="server" Width="300px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="background-color: transparent;">
                        <td style="border: none;"></td>
                        <td style="border: none;">
                            <asp:Button ID="btnPost" runat="server" Text="Post Payment" OnClick="btnPost_Click" />
                        </td>
                    </tr>
                </table>
            </div>

            <asp:Panel ID="pnlReceipt" runat="server" Visible="false">
                <h2>Payment Receipt</h2>
                <asp:GridView ID="gvReceipt" runat="server" AutoGenerateColumns="True"></asp:GridView>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
