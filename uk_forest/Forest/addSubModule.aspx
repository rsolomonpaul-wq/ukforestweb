<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="addSubModule.aspx.cs" Inherits="uk_forest.Forest.addSubModule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="card mb-3 shadow-lg">
        <div class="card-header d-flex flex-row align-items-center justify-content-between custom-header">
            <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Add Sub Module
            </h3>
        </div>

        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <asp:Label ID="lbl_module_name" runat="server" CssClass="font-weight-bold">Module Name:
                                <span style="color: red;">*
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="ddl_module_list" ErrorMessage="Required" Style="font-weight: 600;" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                                </span>
                    </asp:Label>

                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="ddl_module_list" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddl_module_list_SelectedIndexChanged" CssClass="dropdown-action"></asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <div class="col-md-3">
                    <asp:Label ID="Label1" runat="server">Sub-Module Name: <span style="color:red;"> *</span></asp:Label>
                    <span>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txt_Sub_module" ErrorMessage="Required" Style="font-weight: 600;" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                    </span>
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <asp:TextBox ID="txt_Sub_module" runat="server" MaxLength="60" ClientIDMode="Static" oninput="validateInput_green(this)" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success"></asp:TextBox>
                            <asp:HiddenField ID="hf1" runat="server" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <div class="col-md-3">
                    <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                        <ContentTemplate>
                            <asp:Button ID="btn_sub_module" OnClick="btn_sub_module_Click" runat="server" ValidationGroup="a" Text="Add" CssClass="btn-success btn-sm rounded my-4" />
                            <asp:Button ID="btn_reset" OnClick="btn_reset_Click" runat="server" Text="Reset" CssClass="btn-danger btn-sm rounded my-4" />
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
            <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Sub Module Details
            </h3>
        </div>

        <div class="card-body">
            <div class="table-responsive table-striped pccfList">
                <asp:Label ID="lbl_msg_alert" runat="server" ForeColor="Red" Visible="false"></asp:Label>
                <asp:GridView ID="grid_submodule_names" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" DataKeyNames="subModuleId" runat="server" OnPageIndexChanging="grid_submodule_names_PageIndexChanging" Width="100%" CssClass="styled-grid">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Sub Module Name">
                            <ItemTemplate>
                                <asp:Label ID="lbl_submodule_name" runat="server" Text='<%# string.Concat(Eval("SubModuleName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Sub Module Id" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lbl_submodule_id" runat="server" Text='<%# string.Concat(Eval("SubModuleId")) %>'></asp:Label>
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
            </div>
        </div>
    </div>
    <br />
    <br />
</asp:Content>
