<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="user_registration.aspx.cs" Inherits="uk_forest.Forest.user_registration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePannel1" runat="server">
        <ContentTemplate>
            <div class="card mb-3 shadow-lg">
                <div class="card-header d-flex flex-row align-items-center justify-content-between custom-header">
                    <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">
                        <asp:Literal ID="litTitle" runat="server" Text="Add User"></asp:Literal>
                    </h3>
                    <asp:Button ID="btnback" CssClass="btn btn-success me-2 " runat="server" Text="Back" OnClick="btnback_Click" />
                </div>
                <div class="card-body">

                    <div class="row mb-3">
                        <div class="col-md-3">
                            <asp:Label ID="lbl_role" runat="server" CssClass="font-weight-bold">User Role <span class="text-danger">*</span></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="ddl_role" ErrorMessage="Required" Style="font-weight: 600;" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                            </span>
                            <asp:DropDownList ID="ddl_role" runat="server" AutoPostBack="true"
                                OnSelectedIndexChanged="ddl_role_SelectedIndexChanged"
                                CssClass="dropdown-action">
                                <asp:ListItem Value="0">-- Select Role --</asp:ListItem>
                                <asp:ListItem Value="3">HOFF</asp:ListItem>
                                <asp:ListItem Value="4">PCCF</asp:ListItem>
                                <asp:ListItem Value="5">APCCF</asp:ListItem>
                                <asp:ListItem Value="6">CCF</asp:ListItem>
                                <asp:ListItem Value="7">CF</asp:ListItem>
                                <asp:ListItem Value="8">DFO</asp:ListItem>
                                <asp:ListItem Value="9">SDO</asp:ListItem>
                                <asp:ListItem Value="10">RO</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="row mb-3" id="divReporting" runat="server" visible="false">
                        <div class="col-md-12">
                            <asp:Label ID="lbl_reporting_to" runat="server" CssClass="font-weight-bold"><span class="d-inline-block mb-2">Administrative Control Under:</span>  <span class="text-danger">*</span></asp:Label>
                            <asp:UpdatePanel ID="updReporting" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:RadioButtonList ID="rbl_reporting_to" runat="server" AutoPostBack="true"
                                        OnSelectedIndexChanged="rbl_reporting_to_SelectedIndexChanged"
                                        RepeatDirection="Horizontal"
                                        RepeatLayout="Flow"
                                        CssClass="d-flex gap-2">

                                        <asp:ListItem Text="HOFF" Value="HOFF"></asp:ListItem>
                                        <asp:ListItem Text="PCCF" Value="PCCF"></asp:ListItem>
                                        <asp:ListItem Text="APCCF" Value="APCCF"></asp:ListItem>
                                        <asp:ListItem Text="CCF" Value="CCF"></asp:ListItem>
                                        <asp:ListItem Text="CF" Value="CF"></asp:ListItem>
                                        <asp:ListItem Text="DFO" Value="DFO"></asp:ListItem>
                                        <asp:ListItem Text="SDO" Value="SDO"></asp:ListItem>

                                    </asp:RadioButtonList>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>


                    <div id="divHierarchy" runat="server" visible="false">
                        <div class="row">

                            <div class="col-md-3" id="divHoff" runat="server" visible="false">
                                <asp:Label ID="lbl_hoff" runat="server" CssClass="font-weight-bold">HOFF <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_hoff" runat="server" CssClass="dropdown-action" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddl_hoff_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>


                            <div class="col-md-3" id="divPccf" runat="server" visible="false">
                                <asp:Label ID="lbl_pccf" runat="server" CssClass="font-weight-bold">PCCF <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_pccf" runat="server" CssClass="dropdown-action" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddl_pccf_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>


                            <div class="col-md-3" id="divApccf" runat="server" visible="false">
                                <asp:Label ID="lbl_apccf" runat="server" CssClass="font-weight-bold">APCCF <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_apccf" runat="server" CssClass="dropdown-action" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddl_apccf_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>


                            <div class="col-md-3" id="divCcf" runat="server" visible="false">
                                <asp:Label ID="lbl_ccf" runat="server" CssClass="font-weight-bold">CCF <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_ccf" runat="server" CssClass="dropdown-action" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddl_ccf_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>


                            <div class="col-md-3" id="divCF" runat="server" visible="false">
                                <asp:Label ID="lbl_cf" runat="server" CssClass="font-weight-bold">CF <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_cf" runat="server" CssClass="dropdown-action" AutoPostBack="true" OnSelectedIndexChanged="ddl_cf_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>


                            <div class="col-md-3" id="divZone" runat="server" visible="false">
                                <asp:Label ID="lbl_zone" runat="server" CssClass="font-weight-bold">Zone <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_zone" runat="server" CssClass="dropdown-action" AutoPostBack="true" OnSelectedIndexChanged="ddl_zone_SelectedIndexChanged"></asp:DropDownList>
                            </div>


                            <div class="col-md-3" id="divCircle" runat="server" visible="false">
                                <asp:Label ID="lbl_circle" runat="server" CssClass="font-weight-bold">Circle <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_circle" runat="server" OnSelectedIndexChanged="ddl_circle_SelectedIndexChanged" AutoPostBack="true" CssClass="dropdown-action"></asp:DropDownList>
                            </div>


                            <div class="col-md-3" id="divDivision" runat="server" visible="false">
                                <asp:Label ID="lbl_division" runat="server" CssClass="font-weight-bold">Division <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_division" runat="server" OnSelectedIndexChanged="ddl_division_SelectedIndexChanged" AutoPostBack="true" CssClass="dropdown-action"></asp:DropDownList>
                            </div>

                            <div class="col-md-3" id="divSubDivision" runat="server" visible="false">
                                <asp:Label ID="lbl_sub_division" runat="server" CssClass="font-weight-bold">Sub-Division <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_sub_division" runat="server" CssClass="dropdown-action" AutoPostBack="true" OnSelectedIndexChanged="ddl_sub_division_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>


                            <div class="col-md-3" id="divRange" runat="server" visible="false">
                                <asp:Label ID="lbl_range" runat="server" CssClass="font-weight-bold">Range <span class="text-danger">*</span></asp:Label>
                                <asp:DropDownList ID="ddl_range" runat="server" CssClass="dropdown-action" AutoPostBack="true" OnSelectedIndexChanged="ddl_range_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>


                        </div>
                    </div>


                    <div class="row mt-3">

                        <%-- <div class="col-md-3">
                            <asp:Label ID="lbl_emp_id" runat="server" CssClass="font-weight-bold">Emp Id <span class="text-danger">*</span></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txt_emp_id" ErrorMessage="Required" Style="font-weight: 600;" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txt_emp_id" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter Employee Id"></asp:TextBox>
                        </div>--%>

                        <div class="col-md-3">
                            <asp:Label ID="lbl_name" runat="server" CssClass="font-weight-bold">Name <span class="text-danger">*</span></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txt_name" ErrorMessage="Required" Style="font-weight: 600;" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txt_name" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter Name"></asp:TextBox>
                        </div>


                        <div class="col-md-3">
                            <asp:Label ID="lbl_mobile" runat="server" CssClass="font-weight-bold">Mobile Number <span class="text-danger">*</span></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="txt_mobile" ErrorMessage="Required" Style="font-weight: 600;" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txt_mobile" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="10" placeholder="Enter Mobile Number"></asp:TextBox>
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="lbl_email" runat="server" CssClass="font-weight-bold">Email Id <span class="text-danger">*</span></asp:Label>
                            <asp:TextBox ID="txt_email" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter Email ID"></asp:TextBox>
                        </div>

                        <%-- <div class="col-md-3">
                            <asp:Label ID="lbl_remarks" runat="server" CssClass="font-weight-bold">Remarks <span class="text-danger">*</span></asp:Label>
                            <asp:TextBox ID="txt_remarks" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="200" TextMode="MultiLine"  placeholder="Enter remarks"></asp:TextBox>
                        </div>--%>
                        <%--  
                        <div class="col-md-3" visible="false" id="divstatus" runat="server">
                            <asp:Label ID="lbl_status" runat="server" CssClass="font-weight-bold">Status <span class="text-danger">*</span></asp:Label>
                            <asp:TextBox ID="txt_status" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter status"></asp:TextBox>
                        </div>--%>
                    </div>
                    </br>

                    <div class="row mb-3">

                        <div class="col-md-6 d-flex align-items-end">
                            <asp:Button ID="btn_save" runat="server" Text="Save" ValidationGroup="a" CssClass="btn btn-primary me-2" OnClick="btn_save_Click" />
                            <asp:Button ID="btn_update" runat="server" Text="Update" ValidationGroup="a" CssClass="btn btn-primary" OnClick="btn_update_Click" Visible="false" />

                            <asp:Button ID="btn_approve" runat="server" Text="Approve" ValidationGroup="a" CssClass="btn btn-success me-2" OnClick="btn_approve_Click" />

                            <asp:Button ID="btn_reject" runat="server" Text="Reject" ValidationGroup="a" CssClass="btn btn-danger me-2" OnClick="btn_reject_Click" />


                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-md-12">
                            <asp:ValidationSummary ID="valSummary" runat="server" ShowMessageBox="true" ShowSummary="false" />
                        </div>
                    </div>
                </div>
            </div>


            <div class="row mt-3">
                <div class="col-md-12">
                    <asp:GridView ID="gv_users" runat="server" CssClass="table table-bordered table-striped"
                        AutoGenerateColumns="false" AllowPaging="true" PageSize="10"
                        OnPageIndexChanging="gv_users_PageIndexChanging" DataKeyNames="UserId">
                        <Columns>
                            <asp:BoundField DataField="EmpId" HeaderText="Employee ID" />
                            <asp:BoundField DataField="Name" HeaderText="Name" />
                            <asp:BoundField DataField="RoleName" HeaderText="Role" />
                            <asp:BoundField DataField="MobileNo" HeaderText="Mobile" />
                            <asp:BoundField DataField="EmailId" HeaderText="Email" />
                            <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <%-- Loading Overlay --%>
            <div id="divLoader" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.45); z-index: 9999; align-items: center; justify-content: center;">
                <div style="background: #fff; border-radius: 10px; padding: 30px 40px; text-align: center; box-shadow: 0 4px 20px rgba(0,0,0,0.2);">
                    <div class="spinner-border text-success" role="status" style="width: 3rem; height: 3rem;"></div>
                    <p class="mt-3 mb-0 fw-semibold">Please wait, saving user...</p>
                </div>
            </div>


        </ContentTemplate>

        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddl_role" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddl_hoff" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddl_pccf" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddl_apccf" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddl_ccf" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddl_zone" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddl_circle" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="rbl_reporting_to" EventName="SelectedIndexChanged" />
        </Triggers>

    </asp:UpdatePanel>



    <script type="text/javascript">
    var prm = Sys.WebForms.PageRequestManager.getInstance();

    prm.add_beginRequest(function (sender, args) {
        var src = args.get_postBackElement();
        // Sirf Save aur Update button pe loader dikhao
        if (src && (src.id === '<%= btn_save.ClientID %>' ||
                    src.id === '<%= btn_update.ClientID %>')) {
            showLoader();
        }
    });

    prm.add_endRequest(function () {
        hideLoader();
    });

    function showLoader() {
        var loader = document.getElementById('divLoader');
        loader.style.display = 'flex';
    }

    function hideLoader() {
        var loader = document.getElementById('divLoader');
        loader.style.display = 'none';
    }
    </script>



</asp:Content>
