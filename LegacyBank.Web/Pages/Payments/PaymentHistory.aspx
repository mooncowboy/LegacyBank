<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PaymentHistory.aspx.cs" Inherits="LegacyBank.Web.Pages.Payments.PaymentHistory" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Payment History - LegacyBank</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #17a2b8; color: white; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h1>Payment History</h1>
        <div>
            <label>Customer ID:</label>
            <asp:TextBox ID="txtCustomerId" runat="server"></asp:TextBox>
            <asp:Button ID="btnFilter" runat="server" Text="Filter" OnClick="btnFilter_Click" />
            <asp:Button ID="btnExport" runat="server" Text="Export CSV" OnClick="btnExport_Click" />
        </div>
        <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="True"></asp:GridView>
    </form>
</body>
</html>
