<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="changePassword.aspx.cs" Inherits="uk_forest.Forest.changePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <style>
        .password-wrapper {
            position: relative;
        }

            .password-wrapper i {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                z-index: 10;
                color: #6c757d;
            }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="card mb-6">
        <div class="card shadow-lg">
            <div class="card-header bg-success d-flex flex-row align-items-center justify-content-between">
              <h3 class="m-0 font-weight-bolder text-uppercase text-white d-flex align-items-center gap-2" style="font-size: larger;">
  Change Password
</h3>

            </div>
        </div>
        <div class="card-body">
            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                <ContentTemplate>
                    <div class="row">
                       <div class="col-md-6">
                             <div class="shadow-lg p-4 rounded mainForm bg-light">
                                     <h5 class="mb-4 font-weight-bold text-center">
                                    <img src="../web/img/user-icon1.png"  style="width: 97px; height: 97px;" /></h5>
                       
                                 <div class="form-group">
                                    <asp:Label ID="Label4" runat="server" CssClass="font-weight-bold">Existing Password <span class="text-danger">*</span></asp:Label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txt_Existing_Pass" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a" />

                                      <div class="password-wrapper">
                                    <asp:TextBox ID="txt_Existing_Pass" TextMode="Password" runat="server"  ClientIDMode="Static" CssClass="form-control" MaxLength="50" Placeholder="Enter your current password"></asp:TextBox>
                                     <i class="fas fa-eye toggle-password" data-target="txt_Existing_Pass" style="display: none;"></i>
                                    </div>
                                </div>
                        
                             

                                <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" CssClass="font-weight-bold">
        New Password <span class="text-danger">*</span>
                                    </asp:Label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server"
                                        ControlToValidate="txt_new_pass" ErrorMessage="Required"
                                        ForeColor="Red" ValidationGroup="a" />

                                    <div class="password-wrapper">
                                        <asp:TextBox ID="txt_new_pass" runat="server" TextMode="Password"
                                            ClientIDMode="Static" CssClass="form-control" MaxLength="50"  Placeholder="Enter your new password"/>
                                        <i class="fas fa-eye toggle-password" data-target="txt_new_pass" style="display: none;"></i>
                                    </div>
                                </div>
                               

                                <div class="form-group">
                                    <asp:Label ID="Label2" runat="server" CssClass="font-weight-bold">Confirm Password <span class="text-danger">*</span></asp:Label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txt_cPass" ErrorMessage="Required" ForeColor="Red" ValidationGroup="a" />
                                      <div class="password-wrapper">
                                    <asp:TextBox ID="txt_cPass" TextMode="Password" runat="server" ClientIDMode="Static" CssClass="form-control" MaxLength="50" Placeholder="Confirm your new password"></asp:TextBox>
                                          <i class="fas fa-eye toggle-password" data-target="txt_cPass" style="display: none;"></i>
                                    </div>
                                </div>

                                <div class="text-muted mb-3">
                                    <small>Fields marked with <span style="color: red; font-weight: bold;">*</span> are mandatory.</small>
                                </div>


                                <div class="text-center">
                                    <asp:Button runat="server" ID="btn_submit" OnClick="btn_submit_Click" CssClass="btn btn-success rounded btn-sm px-4" Text="Submit" ValidationGroup="a" />
                                </div>

                                <div class="text-center mt-2">
                                    <asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>
                                </div>
                            </div>
                        </div>

                        
                           <div class="col-md-6">
                            <div class="shadow-lg p-4 rounded bg-white h-100">
                                <h5 class="mb-4 font-weight-bold text-center">Password Requirements</h5>
                                <ul class="list-unstyled">
                                    <li>🔒 At least 8 characters long</li>
                                    <li>🔠 At least 1 uppercase letter (A-Z)</li>
                                    <li>🔡 At least 1 lowercase letter (a-z)</li>
                                    <li>🔢 At least 1 numeric digit (0-9)</li>
                                    <li>💥 At least 1 special character (e.g., @, #, $, %)</li>
                                    <li>🚫 Must not be the same as previous password</li>
                                </ul>
                                <div class="alert alert-warning mt-4" role="alert">
                                    Tip: Use a combination of letters, numbers, and symbols for a stronger password.
                                </div>
                            </div>
                        </div>
                    </div>

                    <%------------%>
                    <%-- <form action="verify_recaptcha.php" method="post">
        <div class="g-recaptcha" data-sitekey="6Ld5OSkrAAAAAHi-TD9NZe7LBJV_p5At2EI9W2l1"></div>
        <br />
     <%--  <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" CssClass="btn btn-primary" /> 
    </form>--%>
                    <%----------------%>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <%-- <script src="https://www.google.com/recaptcha/api.js" async defer></script>--%>
 <script>
     document.addEventListener("DOMContentLoaded", function () {
         document.querySelectorAll('.toggle-password').forEach(function (icon) {
             const targetId = icon.getAttribute('data-target');
             const input = document.getElementById(targetId);

             // Hide icon initially
             icon.style.display = "none";

             // Show icon when user starts typing
             input.addEventListener("input", function () {
                 icon.style.display = input.value.trim().length > 0 ? "block" : "none";
             });

             // Toggle password visibility
             icon.addEventListener("click", function () {
                 if (input.type === "password") {
                     input.type = "text";
                     icon.classList.remove("fa-eye");
                     icon.classList.add("fa-eye-slash");
                 } else {
                     input.type = "password";
                     icon.classList.remove("fa-eye-slash");
                     icon.classList.add("fa-eye");
                 }
             });
         });
     });
 </script>




</asp:Content>

