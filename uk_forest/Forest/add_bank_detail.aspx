<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="add_bank_detail.aspx.cs" Inherits="uk_forest.Forest.add_bank_detail" %>

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
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="card mb-3 shadow-lg">
        <div class="card-header d-flex flex-row align-items-center justify-content-between custom-header">
            <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Add Bank Detail
            </h3>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <asp:Label ID="lblBankName" runat="server" CssClass="font-weight-bold">Bank Name:<span style="color: red;">*</span></asp:Label>
                    <asp:TextBox ID="txt_BankName" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" ClientIDMode="Static" oninput="validateInput_green(this)"></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <asp:Label ID="lblAccountNo" runat="server" CssClass="font-weight-bold">Bank Account No. :<span style="color: red;">*</span></asp:Label>
                    <asp:TextBox ID="txtAccountNo" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" ClientIDMode="Static" oninput="validateInput_green(this)"></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <asp:Label ID="lblIFSC" runat="server" CssClass="font-weight-bold">Bank IFSC Code : :<span style="color: red;">*</span></asp:Label>
                    <asp:TextBox ID="txtIFSC" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" ClientIDMode="Static" oninput="validateInput_green(this)"></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <asp:Label ID="lblAccountHolder" runat="server" CssClass="font-weight-bold">Account Holder Name : :<span style="color: red;">*</span></asp:Label>
                    <asp:TextBox ID="txtAccountHolder" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" ClientIDMode="Static" oninput="validateInput_green(this)"></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <asp:Label ID="lblFileUpload" runat="server" CssClass="font-weight-bold">Upload Passbook Copy : :<span style="color: red;">*</span></asp:Label>
                    <asp:FileUpload ID="FileUpload" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" />
                </div>

            </div>

              <div class="col-md-4 mt-2">
                    <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                        <ContentTemplate>
                            <asp:Button ID="btnBankSubmit" OnClick="btnBankSubmit_Click" runat="server" ValidationGroup="a" Text="Add" CssClass="btn btn-success rounded-pill shadow-sm px-4 py-2 btn-bubble" />
                            <asp:Button ID="btn_reset" OnClick="btn_reset_Click" runat="server" Text="Reset" CssClass="btn btn-danger rounded-pill shadow-sm px-4 py-2 btn-bubble"/>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>


            <div class="row">
                <div class="col-sm-6 font-weight-bold" style="color: #000">
                    The fields marked with an <span style="color: red; font-weight: 800;">*</span> are mandatory.         
                </div>

                <div class="col-sm-6 offset-1">
                </div>
            </div>
        </div>
    </div>

</asp:Content>
