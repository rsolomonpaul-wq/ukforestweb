<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="applicantlogin.aspx.cs" Inherits="uk_forest.Forest.applicantlogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
          <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            font-family: 'Inter', Arial, sans-serif;
            background: linear-gradient(90deg, rgb(15, 15, 15) 0%, rgba(34, 40, 39, 0.86) 60%, rgba(0, 0, 0, 0.57) 100%), url('http://rfpmo.provincemongala.com/images/11.jpg') no-repeat center center fixed;
            background-size: cover;
        }

        .form-group {
            margin-bottom: 18px;
            width: 100%;
        }

        .center-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 100%;
            background: none;
        }

        .portal-title {
            color: #fff;
            font-size: 2em;
            font-weight: 600;
            text-align: center;
            margin-bottom: 5px;
            text-shadow: 2px 4px 12px rgba(0,0,0,0.3);
            letter-spacing: 0.7px;
        }

        .portal-subtitle {
            color: #d8d8d8;
            font-size: 1em;
            text-align: center;
            margin-bottom: 22px;
            letter-spacing: 0.05em;
        }

        .form-box {
            background: linear-gradient(45deg, #3c4d53, #071c03);
            border-radius: 18px;
            box-shadow: 0 6px 32px rgba(16, 24, 16, 0.45);
            max-width: 475px;
            min-width: 300px;
            width: 96vw;
            padding: 36px 38px 28px 38px;
            display: flex;
            flex-direction: column;
            align-items: stretch;
            border-bottom: 2px solid #fff;
        }

        .form-tabs {
            display: flex;
            width: 100%;
            margin-bottom: 26px;
            font-size: 1.04em;
        }

        .form-tab {
            flex: 1;
            text-align: left;
            letter-spacing: 0.06em;
            padding-bottom: 14px;
            border-bottom: 2px solid transparent;
            color: #bababa;
            opacity: 0.65;
            cursor: pointer;
            transition: color 0.18s, border-bottom 0.28s;
        }

            .form-tab.active {
                color: #eee;
                opacity: 0.87;
                border-bottom: 2px solid #32ba55;
                cursor: default;
            }

            .form-tab:hover:not(.active) {
                color: #81d58a;
            }

        .form-group label {
            color: #d0d0d0;
            font-size: 1em;
            margin-bottom: 5px;
            display: block;
            font-weight: 400;
            letter-spacing: 0.03em;
        }

        .aspNetTextBoxStyle {
            width: 100%;
            padding: 13px 12px;
            border-radius: 5px;
            font-size: 1em;
            font-family: inherit;
            background: #fff;
            border: 0;
            outline: none;
            color:#000;
            margin-top: 3px;
            margin-bottom: 0;
            box-sizing: border-box;
            transition: border-color 0.2s, background 0.15s;
        }

            /*.aspNetTextBoxStyle:focus {
                border-color: #50ce84;
                outline: none;
                background: rgba(255,255,255,0.15);
            }*/

            .aspNetTextBoxStyle[disabled] {
                color: #bababa !important;
                background: rgba(255,255,255,0.07);
                cursor: not-allowed;
            }

        .form-row {
            display: flex;
            align-items: flex-start;
            gap: 14px;
        }

        .gender-group label {
            margin-bottom: 6px;
            color: #d0d0d0;
        }

        .genders {
            margin-top: 7px;
            display: flex;
            gap: 19px;
            align-items: center;
        }

            .genders label {
                font-weight: 400;
                font-size: 1em;
                color: #ddd;
                margin-right: 7px;
                cursor: pointer;
            }

            .genders input[type="radio"] {
                accent-color: #32ba55;
                margin-right: 4px;
                vertical-align: -1.5px;
            }

        .or-row {
            text-align: center;
            color: #acb3a8;
            font-size: 0.97em;
            font-weight: 600;
            margin: -2px 0 10px 0;
            letter-spacing: 0.03em;
        }

        .captcha-row {
            margin-top: 6px;
            margin-bottom: 18px;
        }

        .g-recaptcha {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 1px 6px #0001;
            width: 55%;
            min-width: 210px;
            min-height: 75px;
            display: flex;
            align-items: center;
            padding: 3px 0px 3px 15px;
            justify-content: flex-start;
            margin-top: 0px;
        }

        .submit-btn {
            width: 100%;
            padding: 13px 0;
            background: #208d3c;
            border: none;
            border-radius: 7px;
            color: #fff;
            font-weight: 600;
            font-size: 1.13em;
            cursor: pointer;
            margin-top: 9px;
            letter-spacing: 0.02em;
            transition: background 0.19s, transform 0.10s;
            box-shadow: 0 2px 7px rgba(50,186,85,0.14);
        }

            .submit-btn:hover {
                background: #27a54a;
                transform: scale(1.01) translateY(-2px);
            }

        .forgot-link {
            margin-top: 17px;
            text-align: left;
        }

            .forgot-link a {
                color:#d0d0d0;
                text-decoration: none;
                font-size: 1em;
            }

                .forgot-link a:hover {
                    color: #fff;
                    text-decoration: underline;
                }
        /* OTP PANEL */
        #otpPanel .portal-title {
            font-size: 1.4em;
            margin-bottom: 28px;
        }

        #otpPanel .form-group {
            margin-bottom: 22px;
        }

        #otpPanel .submit-btn {
            margin-top: 14px;
        }

        #otpPanel .forgot-link {
            margin-top: 26px;
            text-align: center;
        }

            #otpPanel .forgot-link a {
                color: #fff;
                opacity: .7;
                font-size: 1.08em;
            }

                #otpPanel .forgot-link a:hover {
                    opacity: 1;
                    text-decoration: underline;
                }

        @media (max-width: 600px) {
            .portal-title {
                font-size: 1.15em;
            }

            .form-box {
                padding: 15px 4vw 18px 4vw;
                min-width: 0;
                max-width: 98vw;
            }

            .form-tabs {
                font-size: 1em;
            }

            .submit-btn {
                font-size: 1em;
            }
        }
    </style>
    <title></title>
</head>
<body>
    <div class="center-container">
        <form id="form1" runat="server" autocomplete="on">
            <div class="portal-title">
                Human–Wildlife Conflict<br />
                Compensation Portal
            </div>
            <div class="portal-subtitle">
                Login or New Registration<br />
                Track your claim
            </div>
            <div class="form-box">
                <!-- Form Tabs & Content Container -->
                <div id="loginRegisterSections">
                    <div class="form-tabs">
                        <div id="tabLogin" class="form-tab active" onclick="showSection('login')">
                            Login to Your Account
                        </div>
                        <div id="tabCreate" class="form-tab" onclick="showSection('register')">
                            Create New Account
                        </div>
                    </div>
                    <!-- LOGIN SECTION -->
                    <div id="loginSection">
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtLoginMobile" runat="server" Text="Registered Mobile No." />
                            <asp:TextBox
                                ID="txtLoginMobile"
                                runat="server"
                                CssClass="aspNetTextBoxStyle"
                                placeholder="0000000000"
                                MaxLength="10"
                                onkeypress="return isNumberKey(event)" />

                            <span id="mobileError" style="display:none; color:red; font-size:0.9em;"></span>
                        </div>
                        <asp:Button ID="btnSendOTP" runat="server" CssClass="submit-btn" Text="Send OTP Code" OnClientClick="showOtpPanel(); return false;" />
                        <div class="forgot-link">
                            <a href="#">Forgot Password</a>
                        </div>
                    </div>
                    <!-- CREATE ACCOUNT SECTION (hidden by default) -->
                    <div id="registerSection" style="display: none;">
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtFullName" runat="server" Text="Full Name" />
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="aspNetTextBoxStyle" placeholder="Suraj Kumar" />
                        </div>
                        <div class="form-row">
                            <div class="form-group" style="flex: 2;">
                                <asp:Label AssociatedControlID="txtMobile" runat="server" Text="Mobile No." />
                                <asp:TextBox ID="txtMobile" runat="server" CssClass="aspNetTextBoxStyle" placeholder="0000000000" />
                            </div>
                            <div class="form-group gender-group" style="flex: 1.5; margin-left: 8px; color: white;">
                                <asp:Label Text="Gender" runat="server" />
                                <div class="genders">
                                    <label>
                                        <asp:RadioButton ID="rdbMale" runat="server" GroupName="gender" Checked="true" />
                                        Male</label>
                                    <label>
                                        <asp:RadioButton ID="rdbFemale" runat="server" GroupName="gender" />
                                        Female</label>
                                    <label>
                                        <asp:RadioButton ID="rdbOther" runat="server" GroupName="gender" />
                                        Other</label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtEmail" runat="server" Text="Email" />
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="aspNetTextBoxStyle" placeholder="surajkumar@gmail.com" />
                        </div>
                        <div class="or-row">OR</div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtAltPhone" runat="server" Text="Alternative Phone Number" />
                            <asp:TextBox ID="txtAltPhone" runat="server" CssClass="aspNetTextBoxStyle" placeholder="" />
                        </div>
                        <div class="form-group captcha-row">
                            <div class="g-recaptcha">
                                <asp:CheckBox ID="chkRobot" runat="server" />
                                <label for="chkRobot" style="margin-left: 8px; color: #333; font-weight: bolder;">I'm not a robot</label>
                                <img src="../images/applicant/recaptcha.png" alt="reCAPTCHA" style="height: 57px; margin-left: 32px;" />
                            </div>
                        </div>
                        <asp:Button ID="btnCreateAccount" runat="server" OnClick="btnCreateAccount_Click" CssClass="submit-btn" Text="Create Account" />
                    </div>
                </div>
                <!-- OTP PANEL (hidden by default) -->
                <div id="otpPanel" style="display: none;">
                    <div class="portal-title" style="font-size: 1.4em; margin-bottom: 28px;">Enter OTP Code</div>
                    <div class="form-group">
                        <asp:Label AssociatedControlID="txtOtpCode" runat="server" Text="Enter OTP Code" />
                        <asp:TextBox ID="txtOtpCode" runat="server" CssClass="aspNetTextBoxStyle" placeholder="************" TextMode="Password" />
                    </div>
                    <asp:Button ID="btnVerifyOTP" runat="server" OnClick="btnVerifyOTP_Click" CssClass="submit-btn" Text="Verify OTP Code" />
                    <div class="forgot-link" style="margin-top: 18px; text-align: center;">
                        <a href="#" style="color: #fff; opacity: .6; font-size: 1.08em; text-align: center;">Resend OTP Code</a>
                    </div>
                </div>
                <!-- /OTP PANEL -->
            </div>
        </form>
    </div>

    <script type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            // Allow only numbers (0-9)
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }
    </script>


    <script>
        function showSection(which) {
            var tabLogin = document.getElementById('tabLogin');
            var tabCreate = document.getElementById('tabCreate');
            var secLogin = document.getElementById('loginSection');
            var secRegister = document.getElementById('registerSection');
            if (which === "register") {
                tabLogin.classList.remove('active');
                tabCreate.classList.add('active');
                secLogin.style.display = "none";
                secRegister.style.display = "";
            } else {
                tabLogin.classList.add('active');
                tabCreate.classList.remove('active');
                secLogin.style.display = "";
                secRegister.style.display = "none";
            }
        }
        // OTP panel show/hide logic
        function showOtpPanel() {
            Swal.fire({
                title: '',
                text: 'OTP has been successfully sent',
                icon: 'success',
                showConfirmButton: true,
                confirmButtonText: 'OK',
                background: '#f0f9ff',
                color: '#1a202c',
                iconColor: '#38a169',
                showClass: { popup: 'animate__animated animate__fadeInDown' },
                hideClass: { popup: 'animate__animated animate__fadeOutUp' }
            }).then(() => {
                // hide login section and show OTP panel
                document.getElementById('loginRegisterSections').style.display = "none";
                document.getElementById('otpPanel').style.display = "";

                // auto focus OTP textbox
                var otpTextbox = document.getElementById('txtOTP'); // replace with your OTP textbox ID
                otpTextbox.focus();

                // optionally, auto-trigger any "enter" action
                otpTextbox.addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault(); // prevent form submit if needed
                        document.getElementById('btnVerifyOTP').click(); // trigger OTP verify button
                    }
                });
            });
        }


    </script>


     <script>
         document.addEventListener("DOMContentLoaded", function () {
             const txtFullName = document.getElementById("<%= txtFullName.ClientID %>");

             txtFullName.addEventListener("input", function () {
                 // Split the value by spaces
                 let words = this.value.split(' ');
                 // Capitalize first letter of each word
                 words = words.map(word => {
                     if (word.length > 0) {
                         return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
                     }
                     return '';
                 });
                 // Join the words back with space
                 this.value = words.join(' ');
             });
         });
     </script>


    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const txtMobile = document.getElementById("<%= txtMobile.ClientID %>");
            const errorLabel = document.getElementById("mobileError");

            txtMobile.addEventListener("input", function () {
                // Remove non-numeric characters
                let numericValue = this.value.replace(/\D/g, '');
                if (numericValue.length > 10) {
                    numericValue = numericValue.slice(0, 10);
                }
                this.value = numericValue;

                // Show error if non-numeric attempted
                if (this.value.length < numericValue.length) {
                    errorLabel.style.display = "block";
                } else {
                    errorLabel.style.display = "none";
                }
            });

            txtMobile.addEventListener("blur", function () {
                if (this.value.length !== 10) {
                    errorLabel.textContent = "Mobile number must be exactly 10 digits";
                    errorLabel.style.display = "block";
                } else {
                    errorLabel.style.display = "none";
                }
            });
        });
    </script>
</body>
</html>
