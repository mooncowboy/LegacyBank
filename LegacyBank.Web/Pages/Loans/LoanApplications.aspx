<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoanApplications.aspx.cs" Inherits="LegacyBank.Web.Pages.Loans.LoanApplications" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Loan Applications - LegacyBank</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 1000px; margin: 0 auto; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #007bff; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        input, button, select { padding: 8px; margin: 5px 0; }
        button { background-color: #007bff; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #0056b3; }
        .form-section { background-color: #f9f9f9; padding: 15px; margin: 20px 0; border: 1px solid #ccc; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>Loan Applications</h1>
            
            <div class="form-section">
                <h2>Submit New Application</h2>
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
                        <td style="border: none;">Term (Months):</td>
                        <td style="border: none;">
                            <asp:TextBox ID="txtTermMonths" runat="server" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="background-color: transparent;">
                        <td style="border: none;"></td>
                        <td style="border: none;">
                            <asp:Button ID="btnSubmit" runat="server" Text="Submit Application" OnClick="btnSubmit_Click" />
                        </td>
                    </tr>
                </table>
                <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
            </div>

            <h2>Existing Applications</h2>
            <asp:GridView ID="gvApplications" runat="server" AutoGenerateColumns="False" 
                OnRowEditing="gvApplications_RowEditing" 
                OnRowUpdating="gvApplications_RowUpdating" 
                OnRowCancelingEdit="gvApplications_RowCancelingEdit"
                DataKeyNames="Id">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="True" />
                    <asp:BoundField DataField="CustomerId" HeaderText="Customer ID" ReadOnly="True" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" ReadOnly="True" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="TermMonths" HeaderText="Term (Months)" ReadOnly="True" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# Eval("Status") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlStatus" runat="server" SelectedValue='<%# Bind("Status") %>'>
                                <asp:ListItem>Pending</asp:ListItem>
                                <asp:ListItem>Approved</asp:ListItem>
                                <asp:ListItem>Rejected</asp:ListItem>
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CreatedAt" HeaderText="Created At" ReadOnly="True" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    <asp:CommandField ShowEditButton="True" />
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>
