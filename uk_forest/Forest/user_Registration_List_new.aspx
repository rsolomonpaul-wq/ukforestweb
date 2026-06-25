<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="user_Registration_List_new.aspx.cs" Inherits="uk_forest.Forest.user_Registration_List_new" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePannel1" runat="server">
        <ContentTemplate>
            <div class="card mb-3 shadow-lg">
                <div class="card-header d-flex flex-row align-items-center justify-content-between custom-header">
                    <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">
                        <asp:Literal ID="litTitle" runat="server" Text="User List"></asp:Literal>
                    </h3>
                </div>
                <div class="card-body">
                    <!-- Role Selection -->
                    <div class="row mt-3">
                        <%--<div class="col-md-12">
                            <asp:Label ID="lbl_role" runat="server" CssClass="font-weight-bold">User Role <span class="text-danger">*</span></asp:Label>
                            <asp:DropDownList ID="ddl_role" runat="server" AutoPostBack="true"
                                OnSelectedIndexChanged="ddl_role_SelectedIndexChanged"
                                CssClass="dropdown-action">
                                <asp:ListItem Value="0">-- Select Role --</asp:ListItem>
                                <asp:ListItem Value="3">HOFF</asp:ListItem>
                                <asp:ListItem Value="4">PCCF</asp:ListItem>
                                <asp:ListItem Value="5">APCCF</asp:ListItem>
                                <asp:ListItem Value="6">CCF (Zone)</asp:ListItem>
                                <asp:ListItem Value="7">CF (Circle)</asp:ListItem>
                                <asp:ListItem Value="8">DFO (Division)</asp:ListItem>
                            </asp:DropDownList>
                        </div>--%>
                        <div class="col-md-3">
                            <asp:Label ID="lbl_role" runat="server" CssClass="font-weight-bold">
        User Role <span class="text-danger">*</span>
                            </asp:Label>

                            <asp:DropDownList ID="ddl_role"
                                runat="server"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddl_role_SelectedIndexChanged"
                                CssClass="dropdown-action">
                                <asp:ListItem Value="0">-- Select Role --</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                    </div>
                    <%-- </div>--%>

                    <div class="row tableColumn my-3">
                        <div class="col-md-12">
                            <asp:Label ID="lbl_msg_alert" runat="server" ForeColor="Red" Visible="false"></asp:Label>
                            <asp:GridView ID="gv_user" OnRowDataBound="gv_users_RowDataBound" AutoGenerateColumns="false" AllowPaging="true" PageSize="50" DataKeyNames="UserId" EmptyDataText="No Data Found!" OnPageIndexChanging="gv_users_PageIndexChanging" runat="server" Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="User Id" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_UserId" runat="server" Text='<%# Eval("UserId") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Role ID" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_RoleId" runat="server"
                                                Text='<%# Eval("RoleId") != null ? Eval("RoleId") : "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Role Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_RoleName" runat="server"
                                                Text='<%# Eval("RoleName") != null ? Eval("RoleName") : "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_name" runat="server"
                                                Text='<%# Eval("Name") != null ? Eval("Name") : "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Email Id">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_emailId" runat="server"
                                                Text='<%# Eval("EmailId") != null ? Eval("EmailId") : "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Mobile No">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_mobileNo" runat="server"
                                                Text='<%# Eval("MobileNo") != null ? Eval("MobileNo") : "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%--   <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_Status" runat="server"
                                                Text='<%# Eval("Status") != null ? Eval("Status") : "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>

                                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="150px">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddl_status_approved" OnSelectedIndexChanged="ddl_status_approved_SelectedIndexChanged" runat="server" AutoPostBack="true" CssClass="form-control ddl-with-icon" EnableViewState="true" CausesValidation="true" ValidationGroup="complete">
                                                <asp:ListItem Value="">Select</asp:ListItem>
                                                <asp:ListItem Value="View">View</asp:ListItem>
                                                <asp:ListItem Value="Edit">Edit</asp:ListItem>
                                                <asp:ListItem Value="Delete">Delete</asp:ListItem>
                                                <asp:ListItem Value="AccessRight">Access Right</asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
