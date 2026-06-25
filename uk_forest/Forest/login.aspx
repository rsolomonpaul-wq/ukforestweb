<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="uk_forest.Forest.login" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Human–Wildlife Conflict Compensation Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css?family=Inter:400,600&display=swap" rel="stylesheet">
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

        .center-container {
            min-height: 100vh;
            min-width: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            z-index: 1;
            width: 100%;
        }

        .portal-title {
            color: #fff;
            font-size: 2em;
            font-weight: 600;
            text-align: center;
            margin-bottom: 36px;
            margin-top: 0;
            text-shadow: 2px 4px 12px rgba(0,0,0,0.3);
            letter-spacing: 0.7px;
        }

        .login-box {
            background: rgba(21, 77, 41, 0.18);
            border-radius: 16px;
            padding: 38px 36px 24px 36px;
            max-width: 420px;
            min-width: 0;
            width: 96vw;
            box-shadow: 0 6px 32px rgb(16, 24, 16);
            display: flex;
            flex-direction: column;
            align-items: center;
            backdrop-filter: blur(2px);
        }

        .login-title {
            color: #fff;
            font-size: 2em;
            font-weight: 600;
            text-align: center;
            margin-bottom: 28px;
            margin-top: 0;
            letter-spacing: 0.2px;
        }

        .login-form {
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

            .login-form label {
                font-size: 1em;
                color: #cfcfcf;
                margin-bottom: 5px;
            }

            .login-form input,
            .login-form select,
            .form-control {
                width: 100%;
                background: rgba(255,255,255,0.10);
                border: 1.4px solid #32ba55 !important;
                border-radius: 5px;
                padding: 13px 12px;
                font-size: 1em;
                color: #fff;
                font-family: 'Inter', Arial, sans-serif;
                outline: none;
                box-sizing: border-box;
                transition: border-color 0.2s, background 0.2s;
            }

                .login-form input:focus, .login-form select:focus,
                .form-control:focus {
                    border-color: #50ce84 !important;
                    background: rgba(255,255,255,0.15);
                }

                .login-form input::placeholder {
                    color: #acb3a8;
                    opacity: 1;
                }

                .login-form select.form-control {
                    appearance: none;
                    -webkit-appearance: none;
                    -moz-appearance: none;
                    background: rgba(255,255,255,0.10) url('data:image/svg+xml;utf8,<svg fill="white" width="14" height="8" xmlns="http://www.w3.org/2000/svg"><path d="M1 1l6 6 6-6"/></svg>') no-repeat right 14px center/14px 8px;
                    color: #fff;
                    padding-right: 38px !important;
                }

            .btn-success, .login-form button, #btnLogin {
                width: 100%;
                padding: 12px 0;
                font-size: 1.15em;
                font-family: 'Inter', Arial, sans-serif;
                font-weight: 600;
                background: #32ba55;
                color: #fff;
                border: none;
                border-radius: 5px;
                margin-top: 7px;
                cursor: pointer;
                box-shadow: 0 2px 8px rgba(50,186,85,0.08);
                transition: background 0.18s, transform 0.1s;
            }

                .btn-success:hover, .login-form button:hover, #btnLogin:hover {
                    background: #27a54a;
                    transform: translateY(-1px) scale(1.01);
                }

        .forgot-link {
            text-align: center;
            margin-top: 15px;
        }

            .forgot-link a,
            .forgot-link .forgot-link {
                text-decoration: none;
                color: #acb3a8;
                font-size: 0.97em;
                transition: color 0.15s;
            }

                .forgot-link a:hover,
                .forgot-link .forgot-link:hover {
                    color: #fff;
                }

        /* Responsive for all screen sizes */
        @media (max-width: 600px) {
            .portal-title {
                font-size: 1.25em;
                margin-bottom: 16px;
            }

            .login-box {
                padding: 18px 6vw 14px 6vw;
                max-width: 98vw;
            }

            .login-form label {
                font-size: 0.95em;
            }

            .login-title {
                font-size: 1.2em;
            }
        }

        @media (max-width: 350px) {
            .login-box {
                padding-left: 2vw;
                padding-right: 2vw;
            }
        }

        @media (min-width: 900px) {
            .portal-title {
                font-size: 2.1em;
            }

            .login-box {
                max-width: 425px;
            }
        }
    </style>
</head>
<body>
    <div class="center-container">
        <div class="portal-title">
            Human–Wildlife Conflict<br />
            Compensation Portal
        </div>
        <div class="login-box">
            <div class="login-title">Login</div>
            <form id="form1" runat="server" class="login-form" autocomplete="on">
                <asp:Label AssociatedControlID="ddlRole" runat="server" Text="Select Role:" />
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control" Style="border: 1px solid #32ba55;">
                    <asp:ListItem Selected="True">Account Officer</asp:ListItem>
                    <asp:ListItem>Field Officer</asp:ListItem>
                    <asp:ListItem>Admin</asp:ListItem>
                    <asp:ListItem>User</asp:ListItem>
                </asp:DropDownList>
                <asp:Label AssociatedControlID="txtEmail" runat="server" Text="Email Address:" />
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="doon.account@gmail.com" TextMode="Email" autocomplete="email" Style="border: 1px solid #32ba55;" />
                <asp:Label AssociatedControlID="txtPassword" runat="server" Text="Password:" />
                <div style="position: relative; width: 100%;">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                        placeholder="***************" TextMode="Password" autocomplete="current-password"
                        Style="border: 1px solid #32ba55; padding-right: 38px;" />
                    <!-- Eye icon button -->
                    <span id="togglePassword" style="position: absolute; top: 50%; right: 12px; transform: translateY(-50%); cursor: pointer; user-select: none; color: #acb3a8; font-size: 1.5em;" title="Show/Hide Password">&#128065;</span>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-success" />
            </form>
            <div class="forgot-link">
                <asp:HyperLink ID="lnkForgotPassword" runat="server" CssClass="forgot-link" NavigateUrl="~/Forest/ForgotPassword.aspx">Forgot Password</asp:HyperLink>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var toggle = document.getElementById('togglePassword');
            var passwordInput = document.getElementById('<%= txtPassword.ClientID %>');

            toggle.addEventListener('click', function () {
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    toggle.style.color = '#32ba55'; // Optional: highlight when visible
                } else {
                    passwordInput.type = 'password';
                    toggle.style.color = '#acb3a8';
                }
            });
        });
    </script>


   <%--  <script>
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
     </script>--%>
</body>
</html>
