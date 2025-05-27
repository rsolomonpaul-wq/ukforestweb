<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="profile.aspx.cs" Inherits="uk_forest.profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePannel1" runat="server">
        <ContentTemplate>
            <div class="card mb-3 shadow-lg" style="padding: 20px;">
                <div class="card-header position-relative custom-header" style="height: 60px;">
                    <div class="position-absolute end-0 top-50 translate-middle-y">
                        <asp:Button ID="btnback" CssClass="btn btn-success me-2" runat="server" Text="Back" OnClick="btnback_Click" />
                    </div>

                    <h3 class="m-0 text-uppercase font-weight-bold text-center position-absolute top-50 start-50 translate-middle">
                        <asp:Literal ID="litTitle" runat="server" Text="My Profile"></asp:Literal>
                    </h3>
                </div>

                <div class="card-body" style="padding-left: 260px;">
                    <div class="col-md-8">
                        <asp:Label ID="lblId" runat="server" CssClass="font-weight-bold">User Id</asp:Label>
                        <asp:TextBox ID="txtId" runat="server"
                            CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success"
                            MaxLength="50" placeholder="Enter ID" />
                    </div>

               <%--     <div class="col-md-8">
                        <asp:Label ID="lbl_emp_id" runat="server" CssClass="font-weight-bold">Emp ID</asp:Label>
                        <asp:TextBox ID="txt_emp_id" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" />
                    </div>--%>

                    <div class="col-md-8">
                        <asp:Label ID="lbl_name" runat="server" CssClass="font-weight-bold">Full Name</asp:Label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" />
                    </div>

                    <div class="col-md-8">
                        <asp:Label ID="lbl_email_id" runat="server" CssClass="font-weight-bold">Email Id</asp:Label>
                        <asp:TextBox ID="txt_email_id" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" />
                    </div>

                    <div class="col-md-8">
                        <asp:Label ID="lbl_phone" runat="server" CssClass="font-weight-bold">Mobile No.</asp:Label>
                        <asp:TextBox ID="txt_phone_no" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" />
                    </div>


                    <%--  <div class="col-md-4 text-center mt-4 mt-md-0">
                <img src="../web/img/user-icon1.png" runat="server"
                    alt="User Icon"
                    style="width: 200px; height: 200px; object-fit: cover; border-radius: 50%; border: 4px solid #ccc;" />
            </div>--%>
                </div>
            </div>


        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>


