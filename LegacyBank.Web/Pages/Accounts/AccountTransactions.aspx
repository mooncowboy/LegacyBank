<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountTransactions.aspx.cs" Inherits="LegacyBank.Web.Pages.Accounts.AccountTransactions" %>
<!DOCTYPE html>
<html><head runat="server"><title>Account Transactions</title>
<style>body{font-family:Arial;margin:20px}table{border-collapse:collapse;width:100%}th,td{border:1px solid #ddd;padding:8px}th{background-color:#ffc107;color:black}</style>
</head><body><form id="form1" runat="server"><h1>Account Transactions</h1>
<div><label>Account ID:</label><asp:TextBox ID="txtAccountId" runat="server"></asp:TextBox>
<label>Start Date:</label><asp:TextBox ID="txtStartDate" runat="server"></asp:TextBox>
<label>End Date:</label><asp:TextBox ID="txtEndDate" runat="server"></asp:TextBox>
<asp:Button ID="btnFilter" runat="server" Text="Filter" OnClick="btnFilter_Click" /></div>
<asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="True"></asp:GridView>
</form></body></html>
