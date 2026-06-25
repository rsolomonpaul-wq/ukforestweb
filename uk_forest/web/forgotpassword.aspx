<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="forgotpassword.aspx.cs" 
         Inherits="uk_forest.web.forgotpassword" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reset Password - Uttarakhand Forest Department</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }

        body {
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        /* ===== CARD ===== */
        .reset-card {
            width: 100%;
            max-width: 750px;
            background: #fff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 6px 32px rgba(0,0,0,0.13);
        }

        /* ===== HEADER — flush top, full width green ===== */
        .card-header {
            background: #0b5d37;
            padding: 22px 28px 20px;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .logo-wrap {
            width: 48px;
            height: 48px;
            background: rgba(255,255,255,0.13);
            border: 1.5px solid rgba(255,255,255,0.28);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            overflow: hidden;
        }

        .logo-wrap img { width: 32px; height: auto; }

        .dept-name {
            color: #fff;
            font-size: 15px;
            font-weight: 700;
            line-height: 1.35;
        }

        .dept-tagline {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: 4px;
        }

        .tagline-dash {
            width: 22px;
            height: 1.5px;
            background: #d4a017;
            flex-shrink: 0;
        }

        .dept-tagline span {
            color: #8ecfac;
            font-size: 10px;
            letter-spacing: 0.4px;
        }

        /* ===== STEP BAR ===== */
        .steps-wrap {
            display: flex;
            align-items: center;
            padding: 20px 28px 0;
            margin-bottom: 20px;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
            flex: 1;
        }

        .step-dot {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #e8e8e8;
            color: #aaa;
            font-size: 12px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: .25s;
        }

        .step.active .step-dot { background: #107a49; color: #fff; }
        .step.done  .step-dot  { background: #107a49; color: #fff; }

        .step-lbl {
            font-size: 10px;
            color: #bbb;
            font-weight: 600;
            white-space: nowrap;
        }

        .step.active .step-lbl { color: #107a49; }
        .step.done   .step-lbl { color: #107a49; }

        .step-line {
            flex: 1;
            height: 1.5px;
            background: #e0e0e0;
            margin-bottom: 17px;
            transition: .25s;
        }

        .step-line.done { background: #107a49; }

        /* ===== BODY ===== */
        .card-body { padding: 0 28px 28px; }

        .panel-title {
            font-size: 17px;
            font-weight: 700;
            color: #0b5d37;
            margin-bottom: 4px;
        }

        .panel-sub {
            font-size: 12px;
            color: #999;
            margin-bottom: 18px;
            line-height: 1.6;
        }

        /* ===== EMAIL CHIP ===== */
        .email-chip {
            background: #f2faf6;
            border: 1px solid #b8dece;
            border-radius: 10px;
            padding: 11px 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 18px;
        }

        .email-chip i  { color: #107a49; font-size: 16px; }
        .email-chip span {
            font-size: 14px;
            font-weight: 700;
            color: #0b5d37;
        }

        /* ===== FIELD ===== */
        .field-lbl {
            font-size: 11px;
            font-weight: 700;
            color: #0b5d37;
            margin-bottom: 7px;
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .input-row {
            display: flex;
            align-items: center;
            border: 1.5px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 15px;
            transition: border-color .2s, box-shadow .2s;
        }

        .input-row:focus-within {
            border-color: #107a49;
            box-shadow: 0 0 0 3px rgba(16,122,73,.09);
        }

        .input-row i {
            width: 42px;
            text-align: center;
            color: #107a49;
            font-size: 14px;
            flex-shrink: 0;
        }

        .input-row input {
            flex: 1;
            height: 44px;
            border: none;
            outline: none;
            font-size: 14px;
            background: transparent;
            color: #222;
            padding-left:10px;
        }

        .toggle-eye {
            width: 38px;
            text-align: center;
            cursor: pointer;
            color: #bbb;
            font-size: 13px;
            background: none;
            border: none;
            flex-shrink: 0;
        }

        /* ===== STRENGTH BARS ===== */
        .str-bars {
            display: flex;
            gap: 4px;
            margin: -7px 0 5px;
        }

        .str-bars .b {
            flex: 1;
            height: 3px;
            border-radius: 3px;
            background: #eee;
            transition: background .3s;
        }

        .str-label {
            font-size: 11px;
            color: #bbb;
            text-align: right;
            margin-bottom: 13px;
        }

        /* ===== BUTTON ===== */
        .btn-main {
            width: 100%;
            height: 48px;
            background: #107a49;
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: background .2s, transform .15s;
            margin-top: 4px;
        }

        .btn-main:hover { background: #0b5d37; transform: translateY(-1px); }

        /* ===== ERROR BOX ===== */
        .err-box {
            background: #fff5f5;
            border: 1px solid #f5c6cb;
            border-radius: 9px;
            padding: 10px 14px;
            color: #c0392b;
            font-size: 12px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ===== SUCCESS PANEL ===== */
        .success-wrap { text-align: center; padding: 16px 0 10px; }

        .success-circle {
            width: 68px;
            height: 68px;
            background: #107a49;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 30px;
            color: #fff;
        }

        .success-wrap h3 {
            font-size: 18px;
            color: #0b5d37;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .success-wrap p {
            color: #777;
            font-size: 13px;
            line-height: 1.7;
            margin-bottom: 20px;
        }

        .btn-login {
            display: inline-block;
            background: #107a49;
            color: #fff;
            text-decoration: none;
            padding: 12px 36px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
        }

        .btn-login:hover { background: #0b5d37; }

        /* ===== INFO PANELS (Invalid / Expired) ===== */
        .info-wrap { text-align: center; padding: 16px 0 10px; }
        .info-icon  { font-size: 50px; margin-bottom: 12px; }

        .info-wrap h3 {
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #c0392b;
        }

        .info-wrap.expired h3 { color: #b07d00; }

        .info-wrap p { color: #888; font-size: 13px; line-height: 1.7; }

        /* ===== FOOTER ===== */
        .card-footer {
            background: #f7fbf8;
            border-top: 1px solid #eaf0eb;
            padding: 11px 28px;
            text-align: center;
            font-size: 11px;
            color: #bbb;
        }

        @media (max-width:480px) {
            .card-body   { padding: 0 18px 22px; }
            .card-header { padding: 18px 18px 16px; }
            .steps-wrap  { padding: 16px 18px 0; }
        }

/*======== header css ==========*/
#header{
    width: 100%;
    background-color: #fff;
    box-shadow: 0px 3px 10px #a7a7a73d;
    padding:0px 30px;
}
.headAssets {
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.logo img {
    width: 200px;
}
.portal-header {
    padding: 15px 0;
    text-align: center;
    letter-spacing: 1px;
    text-transform: uppercase;
    font-weight: 700;
    font-size: 2rem;
    user-select: none;
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 9px;
    color: #2d2d2d;
}
.portal-header .icon {
    font-size: 2.8rem;
    line-height: 1;
    color: #388e3c;
    text-shadow: 0 0 6px #66bb6a;
    user-select: none;
}
.portal-header h2 {
    font-size: 30px;
    font-weight: 700;
    padding: 0 15px;
    margin-bottom: 0;
}
.ministryLogo {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 20px;
}
.l_1 img {
    width: 130px;
}
.recentCol {
    width: 100%;
    height: calc(100vh - 100px);
    display: flex;
    align-items: center;
    justify-content: center;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true"/>
        <asp:HiddenField ID="hfEncryptedTime" runat="server"/>


        <header id="header">
        <div class="container-fluid m-0">
           <div class="headAssets">
                <div class="logo">
                    <a href="indexs.aspx"><img src="../images/uttrakhand_logo.jpg" alt="logo picture"></a>
                </div>
                 <div class="portal-header">
                   <div class="icon" aria-hidden="true"></div>
                     <h2>Forest Management Information System</h2>
               </div>
                <div class="ministryLogo">
                    <div class="l_1">
                        <a href="#!" target="_blank"><img src="../images/Ministry-of-Environment.jpg" alt="picture"></a>
                    </div>
                    <div class="l_2">
                        <a href="#!" target="_blank"><img src="../images/recap4NDC.png" class="recap4NDCLogo" style="width:50px; padding:5px 0;" alt="recap4NDC"></a>
                    </div>
                </div>
           </div>
        </div>
    </header>

        <div class="recentCol">
            <div class="reset-card">

    <%-- HEADER: flush to card top, full width green --%>
    <%--<div class="card-header">
        <div class="logo-wrap">
            <img src="../images/uttrakhand_logo.jpg" alt="Logo"/>
        </div>
        <div>
            <div class="dept-name">Uttarakhand<br/>Forest Department</div>
            <div class="dept-tagline">
                <div class="tagline-dash"></div>
                <span>Conserving Nature, Sustaining Future</span>
            </div>
        </div>
    </div>--%>

    <%-- STEP INDICATOR --%>
    <div class="steps-wrap" id="stepsBar" runat="server">
        <div class="step" id="step1Div" runat="server">
            <div class="step-dot">1</div>
            <div class="step-lbl">Verify Email</div>
        </div>
        <div class="step-line" id="stepLine1" runat="server"></div>
        <div class="step" id="step2Div" runat="server">
            <div class="step-dot">2</div>
            <div class="step-lbl">New Password</div>
        </div>
        <div class="step-line" id="stepLine2" runat="server"></div>
        <div class="step" id="step3Div" runat="server">
            <div class="step-dot">3</div>
            <div class="step-lbl">Done</div>
        </div>
    </div>

    <%-- PANELS --%>
    <div class="card-body">

        <%-- PANEL 1: VERIFY EMAIL --%>
        <asp:Panel ID="pnlVerify" runat="server" Visible="false">
            <div class="panel-title">Verify Your Email</div>
            <p class="panel-sub">Confirm your registered email address to proceed.</p>

            <div class="email-chip">
                <i class="fa fa-envelope"></i>
                <asp:Label ID="lblMaskedEmail" runat="server"/>
            </div>

            <asp:Panel ID="pnlVerifyError" runat="server" Visible="false">
                <div class="err-box">
                    <i class="fa fa-exclamation-circle"></i>
                    <asp:Label ID="lblVerifyError" runat="server"/>
                </div>
            </asp:Panel>

            <label class="field-lbl">Your Email Address</label>
            <div class="input-row">
                <asp:TextBox ID="txtConfirmEmail" runat="server"
                    placeholder="Enter your email address"
                    TextMode="Email"/>
            </div>

            <asp:Button ID="btnVerifyEmail" runat="server"
                CssClass="btn-main"
                Text="Verify &amp; Continue"
                OnClick="btnVerifyEmail_Click"/>
        </asp:Panel>

        <%-- PANEL 2: SET NEW PASSWORD --%>
        <asp:Panel ID="pnlPassword" runat="server" Visible="false">
            <div class="panel-title">Set New Password</div>
            <p class="panel-sub">Create a strong, unique password for your account.</p>

            <asp:Panel ID="pnlPasswordError" runat="server" Visible="false">
                <div class="err-box">
                    <i class="fa fa-exclamation-circle"></i>
                    <asp:Label ID="lblPasswordError" runat="server"/>
                </div>
            </asp:Panel>

            <label class="field-lbl">New Password</label>
            <div class="input-row">
                <i class="fa fa-lock"></i>
                <asp:TextBox ID="txtNewPassword" runat="server"
                    placeholder="Enter new password"
                    TextMode="Password"
                    onkeyup="checkStr(this.value)"/>
                <button type="button" class="toggle-eye"
                        onclick="togglePw('<%=txtNewPassword.ClientID%>',this)">
                    <i class="fa fa-eye"></i>
                </button>
            </div>

            <div class="str-bars">
                <div class="b" id="b1"></div>
                <div class="b" id="b2"></div>
                <div class="b" id="b3"></div>
                <div class="b" id="b4"></div>
            </div>
            <div class="str-label" id="strLbl"></div>

            <label class="field-lbl">Confirm Password</label>
            <div class="input-row">
                <i class="fa fa-lock"></i>
                <asp:TextBox ID="txtConfirmPassword" runat="server"
                    placeholder="Re-enter new password"
                    TextMode="Password"/>
                <button type="button" class="toggle-eye"
                        onclick="togglePw('<%=txtConfirmPassword.ClientID%>',this)">
                    <i class="fa fa-eye"></i>
                </button>
            </div>

            <asp:Button ID="btnResetPassword" runat="server"
                CssClass="btn-main"
                Text="Reset Password"
                OnClick="btnResetPassword_Click"/>
        </asp:Panel>

        <%-- PANEL 3: SUCCESS --%>
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <div class="success-wrap">
                <div class="success-circle">&#10003;</div>
                <h3>Password Updated!</h3>
                <p>Your password has been reset successfully.<br/>
                   You can now log in with your new password.</p>
                <a href="modules.aspx" class="btn-login">Go to login &rarr;</a>
            </div>
        </asp:Panel>

        <%-- PANEL 4: INVALID LINK --%>
        <asp:Panel ID="pnlInvalid" runat="server" Visible="false">
            <div class="info-wrap">
                <div class="info-icon">&#x26D4;</div>
                <h3>Invalid Link</h3>
                <p>This reset link is invalid.<br/>
                   Please request a new one from the login page.</p>
            </div>
        </asp:Panel>

        <%-- PANEL 5: EXPIRED LINK --%>
        <asp:Panel ID="pnlExpired" runat="server" Visible="false">
            <div class="info-wrap expired">
                <div class="info-icon">&#8987;</div>
                <h3>Link Expired</h3>
                <p>This reset link has expired (15-minute limit).<br/>
                   Please request a new reset link from the login page.</p>
            </div>
        </asp:Panel>

    </div>

    <div class="card-footer">
        &#127807; Uttarakhand Forest Department &nbsp;|&nbsp; ukforestgis.in
    </div>
</div>
        </div>
    </form>

    <script>
        function togglePw(id, btn) {
            var inp = document.getElementById(id);
            var ico = btn.querySelector('i');
            inp.type = inp.type === 'password' ? 'text' : 'password';
            ico.className = inp.type === 'text' ? 'fa fa-eye-slash' : 'fa fa-eye';
        }

        function checkStr(v) {
            var bars = ['b1', 'b2', 'b3', 'b4'].map(function (id) { return document.getElementById(id); });
            var lbl = document.getElementById('strLbl');
            var score = 0;
            if (v.length >= 8) score++;
            if (/[A-Z]/.test(v)) score++;
            if (/[0-9]/.test(v)) score++;
            if (/[^A-Za-z0-9]/.test(v)) score++;
            var clrs = ['#e74c3c', '#e67e22', '#f1c40f', '#27ae60'];
            var lbls = ['Weak', 'Fair', 'Good', 'Strong'];
            bars.forEach(function (b, i) {
                b.style.background = i < score ? clrs[score - 1] : '#eee';
            });
            lbl.textContent = v.length > 0 ? (lbls[score - 1] || '') : '';
            lbl.style.color = score > 0 ? clrs[score - 1] : '#bbb';
        }
    </script>
</body>
</html>
