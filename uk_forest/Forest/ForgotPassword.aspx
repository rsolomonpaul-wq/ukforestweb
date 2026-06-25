<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="uk_forest.Forest.ForgotPassword" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Forgot Password - Human–Wildlife Conflict Compensation Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://fonts.googleapis.com/css?family=Inter:400,600&display=swap" rel="stylesheet" />
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
            width: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            z-index: 1;
            padding: 0 12px;
            box-sizing: border-box;
        }

        .page-title {
            color: #fff;
            font-size: 2em;
            font-weight: 600;
            text-align: center;
            margin-bottom: 36px;
            text-shadow: 2px 4px 12px rgba(0,0,0,0.3);
            letter-spacing: 0.7px;
        }

        .forgot-box {
            background: rgba(21, 77, 41, 0.18);
            border-radius: 16px;
            padding: 38px 36px 24px 36px;
            max-width: 420px;
            width: 100%;
            box-shadow: 0 6px 32px rgb(16, 24, 16);
            backdrop-filter: blur(2px);
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .forgot-title {
            color: #fff;
            font-size: 2em;
            font-weight: 600;
            text-align: center;
            margin-bottom: 28px;
            letter-spacing: 0.2px;
        }

        .forgot-form {
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        label {
            font-size: 1em;
            color: #cfcfcf;
            margin-bottom: 5px;
        }

        input[type="email"] {
            width: 100%;
            background: rgba(255, 255, 255, 0.10);
            border: 1.4px solid #32ba55;
            border-radius: 5px;
            padding: 13px 12px;
            font-size: 1em;
            color: #fff;
            font-family: 'Inter', Arial, sans-serif;
            outline: none;
            box-sizing: border-box;
            transition: border-color 0.2s, background 0.2s;
        }

            input[type="email"]:focus {
                border-color: #50ce84;
                background: rgba(255,255,255,0.15);
            }

        input::placeholder {
            color: #acb3a8;
            opacity: 1;
        }

        button {
            width: 100%;
            padding: 12px 0;
            font-size: 1.15em;
            font-family: 'Inter', Arial, sans-serif;
            font-weight: 600;
            background: #32ba55;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(50,186,85,0.08);
            transition: background 0.18s, transform 0.1s;
            margin-top: 7px;
        }

            button:hover {
                background: #27a54a;
                transform: translateY(-1px) scale(1.01);
            }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

            .back-link a {
                color: #acb3a8;
                text-decoration: none;
                font-size: 0.97em;
                transition: color 0.15s;
            }

                .back-link a:hover {
                    color: #fff;
                }

        /* Responsive */
        @media (max-width: 600px) {
            .page-title {
                font-size: 1.5em;
                margin-bottom: 24px;
            }

            .forgot-title {
                font-size: 1.5em;
                margin-bottom: 20px;
            }
        }

        #btnSendReset {
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

        .form-group {
            margin-bottom: 16px; /* Adjust this value for desired spacing */
        }
    </style>
</head>
<body>

    <div class="center-container">
        <div class="page-title">Forgot Password</div>
        <div class="forgot-box">
            <div class="forgot-title">Reset your password</div>


            <form id="form1" runat="server" class="forgot-form" autocomplete="on" method="post" action="">
                <asp:ScriptManager ID="ScriptManager1" runat="server" />
                <div class="form-group" id="Div1" runat="server">
                    <asp:Label AssociatedControlID="txtEmail" runat="server" Text="Enter your email address" />
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="you@example.com" TextMode="Email" autocomplete="email" />
                </div>

                <div class="form-group" id="otpdiv" runat="server" visible="false">
                    <asp:Label AssociatedControlID="txtotp" runat="server" Text="Enter Otp" />
                    <asp:TextBox ID="txtotp" runat="server" CssClass="form-control" placeholder="Enter OTP" TextMode="Email" autocomplete="email" />
                </div>

                <div class="form-group" id="Divpassword" runat="server" visible="false" style="width: 100%;">
                    <asp:Label AssociatedControlID="txtpassword" runat="server" Text="Enter Password" />
                    <div style="display: flex; align-items: center; border: 1px solid #32ba55; border-radius: 5px; background: rgba(255,255,255,0.10);">
                        <asp:TextBox ID="txtpassword" runat="server" CssClass="form-control" placeholder="Enter your new password" TextMode="Password" autocomplete="new-password" Style="flex: 1; border: none; background: transparent; padding: 13px 12px;" />
                        <span id="togglePassword" style="padding: 0 12px; cursor: pointer; user-select: none; color: #acb3a8; font-size: 1.5em;" title="Show/Hide Password">👁</span>
                    </div>
                </div>

                <div class="form-group" id="Divpasswordconfirm" runat="server" visible="false" style="width: 100%; margin-top: 10px;">
                    <asp:Label AssociatedControlID="txtpasswordconfirm" runat="server" Text="Confirm Password" />
                    <div style="display: flex; align-items: center; border: 1px solid #32ba55; border-radius: 5px; background: rgba(255,255,255,0.10);">
                        <asp:TextBox ID="txtpasswordconfirm" runat="server" CssClass="form-control" placeholder="Confirm your new password" TextMode="Password" autocomplete="new-password" Style="flex: 1; border: none; background: transparent; padding: 13px 12px;" />
                        <span id="togglePasswordConfirm" style="padding: 0 12px; cursor: pointer; user-select: none; color: #acb3a8; font-size: 1.5em;" title="Show/Hide Password">👁</span>
                    </div>
                </div>

                <asp:Button ID="btnSendReset" runat="server" Text="" CssClass="btn btn-success" OnClick="btnSendReset_Click" />
            </form>


            <div class="back-link">
                <a href="login.aspx">Back to Login</a>
            </div>
        </div>
    </div>

    <div id="successPopup" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: rgba(21,77,41,0.85); color: white; padding: 30px 40px; border-radius: 16px; box-shadow: 0 6px 32px rgba(16,24,16,0.8); font-family: 'Inter', Arial, sans-serif; z-index: 9999; text-align: center; font-size: 1.3em; letter-spacing: 0.5px; max-width: 90vw; min-width: 300px;">
        Password changed successfully!
    <br />
        <br />
        <button onclick="hidePopup()" style="padding: 10px 20px; background: #32ba55; border: none; color: #fff; font-weight: 600; cursor: pointer; border-radius: 6px;">
            OK
        </button>
    </div>

    <script>
        function showPopup() {
            document.getElementById('successPopup').style.display = 'block';
        }
        function hidePopup() {
            document.getElementById('successPopup').style.display = 'none';
        }
    </script>


    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var togglePwd = document.getElementById('togglePassword');
            var pwdInput = document.getElementById('<%= txtpassword.ClientID %>');

            var toggleConfirm = document.getElementById('togglePasswordConfirm');
            var pwdConfirmInput = document.getElementById('<%= txtpasswordconfirm.ClientID %>');

            togglePwd.addEventListener('click', function () {
                if (pwdInput.type === 'password') {
                    pwdInput.type = 'text';
                    togglePwd.style.color = '#32ba55';
                } else {
                    pwdInput.type = 'password';
                    togglePwd.style.color = '#acb3a8';
                }
            });

            toggleConfirm.addEventListener('click', function () {
                if (pwdConfirmInput.type === 'password') {
                    pwdConfirmInput.type = 'text';
                    toggleConfirm.style.color = '#32ba55';
                } else {
                    pwdConfirmInput.type = 'password';
                    toggleConfirm.style.color = '#acb3a8';
                }
            });
        });
    </script>




</body>
</html>

