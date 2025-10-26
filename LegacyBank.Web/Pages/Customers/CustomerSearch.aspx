<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerSearch.aspx.cs" Inherits="LegacyBank.Web.Pages.Customers.CustomerSearch" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Customer Search - LegacyBank</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #6c757d; color: white; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h1>Customer Search</h1>
        <div>
            <label>Search:</label>
            <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
        </div>
        <br />
        <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" />
                <asp:BoundField DataField="Name" HeaderText="Name" />
                <asp:BoundField DataField="NationalId" HeaderText="National ID" />
                <asp:BoundField DataField="RiskRating" HeaderText="Risk Rating" />
                <asp:BoundField DataField="LatestBalance" HeaderText="Latest Balance" DataFormatString="{0:C}" />
                <asp:HyperLinkField DataNavigateUrlFields="Id" DataNavigateUrlFormatString="CustomerDetails.aspx?id={0}" Text="Details" />
            </Columns>
        </asp:GridView>
    </form>
</body>
</html>
