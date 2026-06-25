<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="addApplicant.aspx.cs" Inherits="uk_forest.Forest.addApplicant" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:UpdatePanel ID="UpdatePannel1" runat="server">
        <ContentTemplate>

         <div class="card mb-3 shadow-lg">
    <div class="card-header d-flex flex-row align-items-center justify-content-between custom-header">
        <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Add Applicant</h3>
    </div>

    <div class="card-body">
        <div class="row align-items-end"> 

            <div class="col-md-4">
                <asp:Label ID="Label1" runat="server" CssClass="font-weight-bold"
                    Text='Name <span class="text-danger">*</span>'></asp:Label>
                <span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                        ControlToValidate="txt_name" ErrorMessage="Required"
                        ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                </span>
                <asp:TextBox ID="txt_name" runat="server"
                    CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success"
                    MaxLength="50" placeholder="Enter Applicant Name"></asp:TextBox>
                <asp:HiddenField ID="hf1" runat="server" />
            </div>

            <div class="col-md-4">
                <asp:Label ID="Label3" runat="server" CssClass="font-weight-bold"
                    Text='Mobile Number <span class="text-danger">*</span>'></asp:Label>
                <span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                        ControlToValidate="txt_mobile_number" ErrorMessage="Required"
                        ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                </span>
                <asp:TextBox ID="txt_mobile_number" runat="server"
                    CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success"
                    MaxLength="50" TextMode="Number" placeholder="Enter Mobile Number"></asp:TextBox>
                <asp:HiddenField ID="hf3" runat="server" />
            </div>

              
       
            <div class="col-md-4 d-flex align-items-end">
                <asp:Button ID="btn_add_user" runat="server" ValidationGroup="a"
                    Text="Add" OnClick="btn_add_user_Click"
                    CssClass="btn btn-success btn-sm rounded-pill shadow-sm w-90" />
            </div>

      </div>

        <div class="row mt-4">
            <div class="col-sm-12 font-weight-bold" style="color: #000;">
                The fields marked with an <span style="color: red; font-weight: 800;">*</span> are mandatory.
            </div>
        </div>
    </div>
</div>

                      

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
