<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="addCircle.aspx.cs" Inherits="uk_forest.Forest.addCircle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
     <asp:UpdatePanel ID="UpdatePannel1" runat="server">
        <ContentTemplate>
    <div class="card mb-3 shadow-lg">
        <div class="card-header d-flex flex-row align-items-center justify-content-between custom-header"">
            <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Add Circle
            </h3>
        </div>

        <div class="card-body">
            <div class="row">

                <div class="col-md-3">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="lbl_zone_name" runat="server">Zone Name: <span style="color:red;"> *</span></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="ddl_zone_list" ErrorMessage="*" Style="font-weight: 600;" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                            </span>
                            <asp:DropDownList ID="ddl_zone_list" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddl_zone_list_SelectedIndexChanged" CssClass="dropdown-action"></asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <div class="col-md-3">
                    <asp:Label ID="Label1" runat="server">Circle Name
                        <span class="text-danger">*</span>
                    </asp:Label>
                    <span>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txt_circle_name" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                    </span>

                    <asp:TextBox ID="txt_circle_name" runat="server" MaxLength="50" placeholder="Enter Circle Name" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success"></asp:TextBox>
                    <asp:HiddenField ID="hf1" runat="server" />
                </div>

                <div class="col-md-3">
                    <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                        <ContentTemplate>
                            <asp:Button ID="btn_add_circle" runat="server" OnClick="btn_add_circle_Click" ValidationGroup="a" Text="Add" CssClass="btn-success btn-sm rounded my-4"/>

                            <asp:Button ID="btn_reset" runat="server" OnClick="btn_reset_Click" ValidationGroup="a" Text="Reset" CssClass="btn-danger btn-sm rounded my-4" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <div class="col-md-3">
                    </div>
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
                   <div class="card mb-3 shadow-lg">
                <div class="card-header d-flex flex-row align-items-center justify-content-between custom-header">
                    <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Circle Details
                    </h3>
                </div>

                <div class="card-body">
                    <div class="table-responsive table-striped pccfList">
                        <asp:Label ID="lbl_msg_alert" runat="server" ForeColor="Red" Visible="false"></asp:Label>
                         <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
                        <asp:GridView ID="grid_circle_names" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" DataKeyNames="circleId" runat="server" OnPageIndexChanging="grid_circle_names_PageIndexChanging" Width="100%" CssClass="styled-grid">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                   <asp:TemplateField HeaderText="Zone Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_zone_name" runat="server" Text='<%# string.Concat(Eval("ZoneName")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Circle Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_circle_name" runat="server" Text='<%# string.Concat(Eval("CircleName")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Circle Id" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_circle_id" runat="server" Text='<%# string.Concat(Eval("CircleId")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                              <%--  <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddl_status_approved" runat="server"  AutoPostBack="true" CssClass="form-control ddl-with-icon" Style="width: 50%;" EnableViewState="true"  CausesValidation="true" ValidationGroup="complete">
                                            <asp:ListItem Value="">Select</asp:ListItem>
                                            <asp:ListItem Value="edit">Edit</asp:ListItem>
                                            <asp:ListItem Value="delete">Delete</asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>--%>
                            </Columns>
                        </asp:GridView>
             </ContentTemplate>
    </asp:UpdatePanel>
                    </div>
                </div>
            </div>
            <br />
            <br />
      </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
