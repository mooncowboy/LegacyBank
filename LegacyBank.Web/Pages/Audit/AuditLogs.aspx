<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AuditLogs.aspx.cs" Inherits="LegacyBank.Web.Pages.Audit.AuditLogs" %>
<!DOCTYPE html>
<html><head runat="server"><title>Audit Logs</title>
<style>body{font-family:Arial;margin:20px}pre{background-color:#f4f4f4;padding:15px;border:1px solid #ccc;max-height:600px;overflow:auto}button{padding:8px;background-color:#6c757d;color:white;border:none;cursor:pointer}</style>
</head><body><form id="form1" runat="server"><h1>Audit Logs</h1>
<div><asp:Button ID="btnRefresh" runat="server" Text="Refresh" OnClick="btnRefresh_Click" />
<asp:Button ID="btnDownload" runat="server" Text="Download Full Log" OnClick="btnDownload_Click" /></div>
<h2>Last 200 Lines</h2><pre><asp:Literal ID="litLogs" runat="server"></asp:Literal></pre>
</form></body></html>
