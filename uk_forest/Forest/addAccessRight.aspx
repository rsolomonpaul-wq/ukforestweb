<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="addAccessRight.aspx.cs" Inherits="uk_forest.Forest.addAccessRight" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="card-body">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
    </div>

    <div class="card addRolesBox">
        <div class="card-header d-flex flex-row align-items-center justify-content-between">
            <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Add Access Right</h3>
        </div>

        <asp:UpdatePanel ID="updatepnl" runat="server">
            <ContentTemplate>
                <div class="card-body">
                    <div class="row">
                        <div class="col-sm-2">
                            <label class="font-weight-bold">Role Name </label>
                        </div>

                        <div class="col-sm-4">
                            <asp:TextBox runat="server" ID="txtrole" CssClass="form-control" Enabled="false"></asp:TextBox>
                        </div>

                        <div class="col-sm-2">
                            <label class="font-weight-bold">User Id </label>
                        </div>

                        <div class="col-sm-4">
                            <asp:TextBox runat="server" ID="txt_user_name" CssClass="form-control" Enabled="false"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row my-3">
                        <div class="col-sm-2">
                            <label class="font-weight-bold">Email-ID </label>
                        </div>

                        <div class="col-sm-4">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txt_email" Enabled="false"></asp:TextBox>
                        </div>

                        <div class="col-sm-2">
                            <label class="font-weight-bold">Module Name</label>
                        </div>

                        <div class="col-sm-4">
                            <asp:DropDownList ID="ddl_module_list" runat="server" CssClass="form-control ddl-with-icon" AutoPostBack="true" OnSelectedIndexChanged="ddl_module_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-5">
                            <label class="font-weight-bold">Sub-Modules</label>
                        </div>
                        <div class="col-md-2"></div>
                        <div class="col-md-5">
                            <label class="font-weight-bold">Sub Module Access</label>
                        </div>
                        <%--<div class="col-md-2" runat="server" visible="false">
                            <label class="font-weight-bold" style="color: #000;">Permissions:</label>
                        </div>--%>

                    </div>

                    <div class="row">
                        <div class=" col-md-5 check">
                            <asp:ListBox ID="ListBox2" class="listdata form-control" runat="server" SelectionMode="Multiple" Height="200"></asp:ListBox>
                        </div>

                        <div class=" col-md-2 check my-5 ml-4 text-center">
                            <asp:Button ID="btnSave" runat="server" CssClass="btn btn-success leftBtnArrowIcon rounded btn_position " Text="   🡺   " OnClick="btnSave_Click" />
                            <asp:Button ID="btnback" CssClass="btn btn-success rightBtnArrowIcon rounded " runat="server" Text="   🡸   " OnClick="btnback_Click" />
                        </div>

                        <div class=" col-md-5 check">
                            <asp:Label ID="Label2" runat="server"> </asp:Label>
                            <asp:ListBox ID="ListBox1" runat="server" class="listdata form-control" SelectionMode="Multiple" Height="200"></asp:ListBox>
                        </div>

                        <%--<div class="col-md-2" runat="server" visible="false">
                            <asp:CheckBox ID="chkAll" Text="Tous" class="font-weight-bold" Style="color: #000;" runat="server" OnCheckedChanged="chkAll_CheckedChanged" AutoPostBack="true" />
                            <asp:CheckBoxList ID="chkAccess" runat="server">
                                <asp:ListItem Value="View"> &nbsp View</asp:ListItem>
                                <asp:ListItem Value="Add">&nbsp Add</asp:ListItem>
                                <asp:ListItem Value="Edit">&nbsp Edit</asp:ListItem>
                                <asp:ListItem Value="Delete">&nbsp Delete</asp:ListItem>
                            </asp:CheckBoxList>
                        </div>--%>
                    </div>

                    <div class="row">
                        <div class="col-md-12 text-center my-3">
                            <div class="btn_assign">
                                <asp:Button ID="btnAssign" CssClass="btn btn-success rounded" runat="server" Text="Submit" OnClick="btnAssign_Click" />
                                <asp:Button ID="btn_Back" CssClass="btn btn-success rounded" runat="server" Text="Back" Style="text-align: center" OnClick="btn_Back_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <div class="card shadow-lg my-4">
        <div class="card-header d-flex flex-row align-items-center justify-content-between">
            <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Access Right Details
            </h3>
        </div>

        <div class="card-body">
            <asp:UpdatePanel ID="UpdatePanelw1" runat="server">
                <ContentTemplate>
                    <div class="table-responsive accessRightTable table-striped">
                        <asp:Label ID="lbl_msg_alert" runat="server" ForeColor="Red" Visible="false"></asp:Label>
                        <asp:GridView ID="grid_accessRight_name" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" runat="server" Width="100%" OnPageIndexChanging="grid_accessRight_name_PageIndexChanging">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="User Id">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_user_id" runat="server" Text='<%# string.Concat(Eval("EmailId")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Module Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_module_name" runat="server" Text='<%# string.Concat(Eval("ModuleName")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Sub Module Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_sub_module_name" runat="server" Text='<%# string.Concat(Eval("SubModuleName")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Add Access" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_add_access" runat="server" Text='<%# string.Concat(Eval("AddAccess")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Edit Access" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_edit_access" runat="server" Text='<%# string.Concat(Eval("EditAccess")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="View Access" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_view_access" runat="server" Text='<%# string.Concat(Eval("ViewAccess")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Delete Access" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_delete_access" runat="server" Text='<%# string.Concat(Eval("DeleteAccess")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
