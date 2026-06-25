<%@ Page Language="C#" MasterPageFile="~/Forest/forestmaster.Master" Async="true" AutoEventWireup="true" CodeBehind="ForestGuardAsign.aspx.cs" Inherits="uk_forest.Forest.ForestGuardAsign" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #2a4d39 0%, #4a7043 100%);
            min-height: 100vh;
        }
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
        }
        .form-container:hover {
            transform: translateY(-5px);
        }
        .form-header {
            color: #2a4d39;
            font-weight: 700;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
        }
        .form-label {
            color: #355e3b;
            font-weight: 500;
        }
        .form-control, .form-select {
            border: 2px solid #4a7043;
            border-radius: 8px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #2a4d39;
            box-shadow: 0 0 8px rgba(42, 77, 57, 0.3);
        }
        .new-guard-section {
            margin-top: 15px;
            padding: 15px;
            background-color: #f1f8f0;
            border-radius: 8px;
            transition: opacity 0.3s ease;
        }
        .new-guard-section.show {
            opacity: 1;
        }
        .btn-custom {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background-color: #355e3b;
            border-color: #355e3b;
        }
        .btn-primary:hover {
            background-color: #2a4d39;
            border-color: #2a4d39;
            transform: scale(1.05);
        }
        .btn-success {
            background-color: #4a7043;
            border-color: #4a7043;
        }
        .btn-success:hover {
            background-color: #3d5c37;
            border-color: #3d5c37;
            transform: scale(1.05);
        }
        .input-icon {
            position: relative;
        }
        .input-icon i {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #4a7043;
        }
        .input-icon input {
            padding-left: 35px;
        }
        @media (max-width: 576px) {
            .form-container {
                margin: 20px;
                padding: 20px;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="form-container">
        <h2 class="form-header text-center mb-4">Forest Guard Assignment</h2>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hdidforest" runat="server" />
                <div class="mb-3">
                    <label for="ddlForestGuard" class="form-label"><i class="fas fa-user me-2"></i>Forest Guard Name</label>
                    <asp:DropDownList ID="ddlForestGuard" runat="server" CssClass="form-select" OnSelectedIndexChanged="ddlForestGuard_SelectedIndexChanged" AutoPostBack="true">
                    </asp:DropDownList>
                </div>
                <asp:Panel ID="pnlNewGuardSection" runat="server" CssClass="new-guard-section" Visible="false">
                    <div class="mb-3">
                        <label for="txtNewGuardName" class="form-label"><i class="fas fa-plus-circle me-2"></i>New Guard Name</label>
                        <div class="input-icon">
                            <i class="fas fa-user-plus"></i>
                            <asp:TextBox ID="txtNewGuardName" runat="server" CssClass="form-control" placeholder="Enter new guard name"></asp:TextBox>
                        </div>
                    </div>
                  
                </asp:Panel>
                <div class="mb-3">
                    <label for="txtMobileNumber" class="form-label"><i class="fas fa-phone me-2"></i>Mobile Number</label>
                    <div class="input-icon">
                        <i class="fas fa-phone-alt"></i>
                        <asp:TextBox ID="txtMobileNumber" runat="server" CssClass="form-control" placeholder="Enter mobile number" TextMode="Phone"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="txtEmail" class="form-label"><i class="fas fa-envelope me-2"></i>Email</label>
                    <div class="input-icon">
                        <i class="fas fa-envelope"></i>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter email" TextMode="Email"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="ddlPriority" class="form-label"><i class="fas fa-exclamation-circle me-2"></i>Priority</label>
                    <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-select">
                        <asp:ListItem Value="">Select Priority</asp:ListItem>
                        <asp:ListItem Value="High">High</asp:ListItem>
                        <asp:ListItem Value="Medium">Medium</asp:ListItem>
                        <asp:ListItem Value="Low">Low</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="d-flex justify-content-between mt-4">
                    <asp:Button ID="btnSubmit" runat="server" Text="Assign" CssClass="btn btn-primary btn-custom" OnClick="btnSubmit_Click" Visible="true" />
                    <asp:Button ID="btnAsign" runat="server" Text="Add/Assign" CssClass="btn btn-primary btn-custom" OnClick="btnAsign_Click" Visible="false" />
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>