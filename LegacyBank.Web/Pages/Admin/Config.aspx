<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Config.aspx.cs" Inherits="LegacyBank.Web.Pages.Admin.Config" %>
<!DOCTYPE html>
<html><head runat="server"><title>Configuration</title>
<style>body{font-family:Arial;margin:20px}input,button{padding:8px;margin:5px 0}button{background-color:#dc3545;color:white;border:none;cursor:pointer}.warning{background-color:#fff3cd;padding:15px;margin:10px 0;border:1px solid #ffc107}</style>
</head><body><form id="form1" runat="server"><h1>Configuration Management</h1>
<div class="warning"><strong>Warning:</strong> This page allows editing configuration values. Use with caution!</div>
<h2>Current Settings</h2><asp:Label ID="lblSettings" runat="server"></asp:Label>
<h2>Update API Key</h2>
<div><label>Credit Score API Key:</label><br/><asp:TextBox ID="txtApiKey" runat="server" Width="400px"></asp:TextBox><br/>
<asp:Button ID="btnUpdateKey" runat="server" Text="Update Key" OnClick="btnUpdateKey_Click" /><br/>
<asp:Label ID="lblResult" runat="server"></asp:Label></div>
<h2>Connection String</h2><asp:Label ID="lblConnectionString" runat="server"></asp:Label>
</form></body></html>
