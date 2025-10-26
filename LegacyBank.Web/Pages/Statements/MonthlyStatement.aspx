<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MonthlyStatement.aspx.cs" Inherits="LegacyBank.Web.Pages.Statements.MonthlyStatement" %>
<!DOCTYPE html>
<html><head runat="server"><title>Monthly Statement</title>
<style>body{font-family:Arial;margin:20px}table{border-collapse:collapse;width:100%}th,td{border:1px solid #ddd;padding:8px}th{background-color:#6f42c1;color:white}</style>
</head><body><form id="form1" runat="server"><h1>Monthly Statement</h1>
<div><label>Account ID:</label><asp:TextBox ID="txtAccountId" runat="server"></asp:TextBox>
<label>Year:</label><asp:TextBox ID="txtYear" runat="server"></asp:TextBox>
<label>Month:</label><asp:TextBox ID="txtMonth" runat="server"></asp:TextBox>
<asp:Button ID="btnGenerate" runat="server" Text="Generate" OnClick="btnGenerate_Click" />
<asp:Button ID="btnDownload" runat="server" Text="Download CSV" OnClick="btnDownload_Click" /></div>
<asp:Panel ID="pnlStatement" runat="server" Visible="false">
<h2>Statement</h2>
<asp:GridView ID="gvStatement" runat="server" AutoGenerateColumns="True"></asp:GridView>
</asp:Panel>
</form></body></html>
