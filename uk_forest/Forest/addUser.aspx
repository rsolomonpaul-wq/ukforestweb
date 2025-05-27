<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="addUser.aspx.cs" Inherits="uk_forest.Forest.addUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:UpdatePanel ID="UpdatePannel1" runat="server">
        <ContentTemplate>
            <div class="card mb-3 shadow-lg">
                <div class="card-header d-flex flex-row align-items-center justify-content-between custom-header">
                    <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Add User</</h3>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <asp:Label ID="Label1" runat="server" CssClass="font-weight-bold" Text="Name <span class='text-danger'>*</span>"></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txt_user_name" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>

                            </span>
                            <asp:TextBox ID="txt_user_name" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter User Name"></asp:TextBox>
                            <asp:HiddenField ID="hf1" runat="server" />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="Label2" runat="server" CssClass="font-weight-bold" Text="Gender <span class='text-danger'>*</span>"></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator
                                    ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddl_gender" InitialValue="" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a">
                                </asp:RequiredFieldValidator>
                            </span>

                            <asp:DropDownList
                                ID="ddl_gender"
                                runat="server"
                                CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success">
                                <asp:ListItem Text="-- Select Gender --" Value="" />
                                <asp:ListItem Text="Male" Value="Male" />
                                <asp:ListItem Text="Female" Value="Female" />
                                <asp:ListItem Text="Other" Value="Other" />
                            </asp:DropDownList>

                            <asp:HiddenField ID="HiddenField1" runat="server" />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="Label3" runat="server" CssClass="font-weight-bold" Text="Mobile Number <span class='text-danger'>*</span>"></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txt_mobile_number" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>

                            </span>
                            <asp:TextBox ID="txt_mobile_number" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter Mobile Number"></asp:TextBox>
                            <asp:HiddenField ID="hf3" runat="server" />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="Label4" runat="server" CssClass="font-weight-bold" Text="Email Id <span class='text-danger'>*</span>"></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txt_email_id" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>

                            </span>
                            <asp:TextBox ID="txt_email_id" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter Email ID"></asp:TextBox>
                            <asp:HiddenField ID="hf4" runat="server" />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="Label5" runat="server" CssClass="font-weight-bold" Text="Address <span class='text-danger'>*</span>"></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txt_address" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>

                            </span>
                            <asp:TextBox ID="txt_address" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter Address"></asp:TextBox>
                            <asp:HiddenField ID="hf5" runat="server" />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="Label6" runat="server" CssClass="font-weight-bold" Text="Pincode <span class='text-danger'>*</span>"></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txt_pincode" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>

                            </span>
                            <asp:TextBox ID="txt_pincode" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter Pincode"></asp:TextBox>
                            <asp:HiddenField ID="hf6" runat="server" />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="Label7" runat="server" CssClass="font-weight-bold"
                                Text="PAN Number <span class='text-danger'>*</span>"></asp:Label>

                            <span>
                                <!-- Required Field Validator -->
                                <asp:RequiredFieldValidator
                                    ID="RequiredFieldValidator7"
                                    runat="server"
                                    ControlToValidate="txt_pan_number"
                                    ErrorMessage="required"
                                    ForeColor="Red"
                                    ValidationGroup="a">
                                </asp:RequiredFieldValidator>

                                <!-- PAN Format Validator -->
                                <asp:RegularExpressionValidator
                                    ID="RegexValidatorPAN"
                                    runat="server"
                                    ControlToValidate="txt_pan_number"
                                    ValidationExpression="^[A-Z]{4}[0-9]{4}[A-Z]{2}$"
                                    ErrorMessage="Invalid PAN format"
                                    ForeColor="Red"
                                    ValidationGroup="a">
                                </asp:RegularExpressionValidator>
                            </span>

                            <!-- PAN Input Box -->
                            <asp:TextBox
                                ID="txt_pan_number"
                                runat="server"
                                CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success"
                                MaxLength="10"
                                placeholder="Enter PAN Number"
                                oninput="enforcePANFormat(this);"
                                Style="text-transform: uppercase;">
                            </asp:TextBox>

                            <asp:HiddenField ID="hf7" runat="server" />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="Label8" runat="server" CssClass="font-weight-bold" Text="Aadhar Number <span class='text-danger'>*</span>"></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txt_aadhar_number" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>

                            </span>
                            <asp:TextBox ID="txt_aadhar_number" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter Aadhar Number"></asp:TextBox>
                            <asp:HiddenField ID="hf8" runat="server" />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="Label9" runat="server" CssClass="font-weight-bold" Text="Username <span class='text-danger'>*</span>"></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txt_username" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>

                            </span>
                            <asp:TextBox ID="txt_username" runat="server" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success" MaxLength="50" placeholder="Enter Username"></asp:TextBox>
                            <asp:HiddenField ID="hf9" runat="server" />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="Label10" runat="server" CssClass="font-weight-bold" Text="Password <span class='text-danger'>*</span>"></asp:Label>
                            <span>
                                <asp:RequiredFieldValidator
                                    ID="RequiredFieldValidator10" runat="server" ControlToValidate="txt_password" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a">
                                </asp:RequiredFieldValidator>
                            </span>

                            <div class="position-relative">
                                <asp:TextBox
                                    ID="txt_password" runat="server" MaxLength="50" TextMode="Password" placeholder="Enter Passwrd" CssClass="form-control rounded-pill border-primary shadow-sm px-4 py-2 border-success pr-5">
                                </asp:TextBox>

                                <span
                                    class="position-absolute"
                                    style="top: 50%; right: 15px; transform: translateY(-50%); cursor: pointer;"
                                    onclick="togglePasswordVisibility('<%= txt_password.ClientID %>', this)">
                                    <i class="fa fa-eye" id="eyeIcon"></i>
                                </span>
                            </div>

                            <asp:HiddenField ID="hf10" runat="server" />
                        </div>


                        <div class="col-md-3">

                            <asp:Button ID="btn_add_user" runat="server" OnClick="btn_add_user_Click" ValidationGroup="a" Text="Add" CssClass="btn-success btn-sm rounded my-4" />
                            <asp:Button ID="btn_reset" runat="server" OnClick="btn_reset_Click" ValidationGroup="a" Text="Reset" CssClass="btn-danger btn-sm rounded my-4" />

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
                    <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">User Details
                    </h3>
                </div>

                <div class="card-body">
                    <div class="table-responsive table-striped pccfList">
                        <asp:Label ID="lbl_msg_alert" runat="server" ForeColor="Red" Visible="false"></asp:Label>
                        <asp:GridView ID="grid_user_names" AutoGenerateColumns="false" AllowPaging="true" PageSize="10" DataKeyNames="userId" runat="server" OnPageIndexChanging="grid_user_names_PageIndexChanging" Width="100%" CssClass="styled-grid">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="User Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_user_name" runat="server" Text='<%# string.Concat(Eval("Name")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="User Id" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_user_id" runat="server" Text='<%# string.Concat(Eval("UserId")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Mobile Number">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_mobile_name" runat="server" Text='<%# string.Concat(Eval("MobileNo")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Email ID">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_email_id" runat="server" Text='<%# string.Concat(Eval("EmailId")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Address">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_address" runat="server" Text='<%# string.Concat(Eval("Address")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Pincode">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_pincode" runat="server" Text='<%# string.Concat(Eval("Pincode")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="PAN Number">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_pan_no" runat="server" Text='<%# string.Concat(Eval("PanNo")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Aadhar Number">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_aadhar_no" runat="server" Text='<%# string.Concat(Eval("AadharNo")) %>'></asp:Label>
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

        </ContentTemplate>
    </asp:UpdatePanel>


    
    <script type="text/javascript">
        function togglePasswordVisibility(inputId, iconElement) {
            var input = document.getElementById(inputId);
            var icon = iconElement.querySelector('i');

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = "password";
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        function enforcePANFormat(input) {
            let value = input.value.toUpperCase();
            let newValue = "";

            for (let i = 0; i < value.length; i++) {
                let char = value.charAt(i);

                if (i < 4 && /[A-Z]/.test(char)) {
                    newValue += char; // First 4 letters
                } else if (i >= 4 && i < 8 && /[0-9]/.test(char)) {
                    newValue += char; // Next 4 digits
                } else if (i >= 8 && i < 10 && /[A-Z]/.test(char)) {
                    newValue += char; // Last 2 letters
                }
            }

            input.value = newValue;
        }

    </script>

</asp:Content>
