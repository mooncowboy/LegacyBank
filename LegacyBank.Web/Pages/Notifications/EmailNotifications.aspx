<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmailNotifications.aspx.cs" Inherits="LegacyBank.Web.Pages.Notifications.EmailNotifications" %>
<!DOCTYPE html>
<html><head runat="server"><title>Email Notifications</title>
<style>body{font-family:Arial;margin:20px}input,textarea,button{padding:8px;margin:5px 0;width:300px}button{background-color:#17a2b8;color:white;border:none;cursor:pointer}</style>
</head><body><form id="form1" runat="server"><h1>Email Notifications</h1>
<div><label>Customer ID:</label><br/><asp:TextBox ID="txtCustomerId" runat="server"></asp:TextBox><br/>
<label>Subject:</label><br/><asp:TextBox ID="txtSubject" runat="server"></asp:TextBox><br/>
<label>Body:</label><br/><asp:TextBox ID="txtBody" runat="server" TextMode="MultiLine" Rows="5"></asp:TextBox><br/>
<asp:Button ID="btnSend" runat="server" Text="Send Notification" OnClick="btnSend_Click" /><br/>
<asp:Label ID="lblResult" runat="server"></asp:Label></div>
</form></body></html>
