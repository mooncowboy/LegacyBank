<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountList.aspx.cs" Inherits="LegacyBank.Web.Pages.Accounts.AccountList" %>
<!DOCTYPE html>
<html><head runat="server"><title>Account List</title>
<style>body{font-family:Arial;margin:20px}table{border-collapse:collapse;width:100%}th,td{border:1px solid #ddd;padding:8px}th{background-color:#ffc107;color:black}</style>
</head><body><form id="form1" runat="server"><h1>Account List</h1>
<div><label>Customer ID:</label><asp:TextBox ID="txtCustomerId" runat="server"></asp:TextBox>
<asp:Button ID="btnLoad" runat="server" Text="Load Accounts" OnClick="btnLoad_Click" /></div>
<asp:GridView ID="gvAccounts" runat="server" AutoGenerateColumns="True"></asp:GridView>
</form></body></html>
