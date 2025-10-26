<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerDetails.aspx.cs" Inherits="LegacyBank.Web.Pages.Customers.CustomerDetails" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Customer Details - LegacyBank</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #6c757d; color: white; }
        .info { background-color: #f9f9f9; padding: 15px; margin: 10px 0; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h1>Customer Details</h1>
        <div class="info">
            <asp:Label ID="lblCustomerInfo" runat="server"></asp:Label>
        </div>
        <h2>Accounts</h2>
        <asp:GridView ID="gvAccounts" runat="server" AutoGenerateColumns="True"></asp:GridView>
        <h2>Recent Transactions (Last 5)</h2>
        <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="True"></asp:GridView>
    </form>
</body>
</html>
