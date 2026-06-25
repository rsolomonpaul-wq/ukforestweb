<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="add_incident_document.aspx.cs" Inherits="uk_forest.Forest.add_incident_document" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <title>Upload Documents</title>
    <style>
        table {
            border-collapse: collapse;
            width: 90%;
        }

        th, td {
            border: 1px solid #999;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #709e3c;
            color: white;
        }

        .form-group {
            margin-bottom: 10px;
        }

        label {
            font-weight: bold;
            display: inline-block;
            width: 200px;
        }
    </style>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div>

        <h3>Bank Details</h3>
        <div class="form-group">
            <label>Account Holder Name:</label>
            <asp:TextBox ID="txtAccountHolder" runat="server" Width="300px" />
        </div>
        <div class="form-group">
            <label>Account Number:</label>
            <asp:TextBox ID="txtAccountNo" runat="server" Width="300px" />
        </div>
        <div class="form-group">
            <label>IFSC Code:</label>
            <asp:TextBox ID="txtIFSC" runat="server" Width="300px" />
        </div>


        <asp:Button ID="btnBankSubmit" runat="server" Text="Save Bank Details" OnClick="btnBankSubmit_Click"  CssClass="btn btn-success rounded-pill shadow-sm px-4 py-2 btn-bubble"/>
        <hr />
    

        <h3>Upload Documents</h3>
        <asp:GridView ID="gvUpload" runat="server" AutoGenerateColumns="False" OnRowCommand="gvUpload_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="S. No">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Document Type">
                    <ItemTemplate>
                        <asp:TextBox ID="txtDocType" runat="server" Text='<%# Bind("DocumentType") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Document Upload">
                    <ItemTemplate>
                        <asp:FileUpload ID="fuDocument" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteRow" CommandArgument='<%# Container.DataItemIndex %>'>Delete</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <asp:LinkButton ID="lnkAddRow" runat="server" OnClick="lnkAddRow_Click">Add row</asp:LinkButton>
        <br />
        <br />
        <asp:Button ID="btnUploadSubmit" runat="server" Text="Submit Documents" OnClick="btnUploadSubmit_Click" CssClass="btn btn-success rounded-pill shadow-sm px-4 py-2 btn-bubble"/>


    </div>


</asp:Content>
