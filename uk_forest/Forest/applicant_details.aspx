<%--<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="applicant_details.aspx.cs" Inherits="uk_forest.Forest.applicant_details" %>--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="applicant_details.aspx.cs" Inherits="uk_forest.Forest.applicant_details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .step-flow {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            margin: 25px auto;
            font-family: Arial, sans-serif;
        }

        .step-item {
            display: flex;
            align-items: center;
            font-size: 15px;
            font-weight: 600;
            color: #333;
        }

        .circle {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #4CAF50;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 8px;
            font-size: 14px;
        }

        .arrow {
            margin: 0 10px;
            color: #4CAF50;
            font-size: 18px;
            font-weight: bold;
        }

        .label {
            white-space: nowrap;
        }

        /* Highlight current step (optional) */
        .active .circle {
            background-color: #4CAF50;
        }

        .active .label {
            color: #4CAF50;
            font-weight: 700;
            font-size: 20px;
        }
    </style>

    <style>
        .step-header {
            margin-bottom: 30px;
        }

        .section-title {
            color: #23a510;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-indicator {
            color: #43a047;
            font-weight: bold;
            margin-left: 5px;
        }

        .document-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #e9ecef;
        }

        .document-row {
            margin-bottom: 20px;
        }

        .upload-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .upload-item {
            background: white;
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s ease;
        }

            .upload-item:hover {
                border-color: #23a510;
                background: #f8fff9;
            }

        .upload-label {
            font-weight: 600;
            color: #23a510;
            margin-bottom: 12px;
            display: block;
            font-size: 0.95rem;
        }

        .file-upload-wrapper {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100px;
            justify-content: center;
            border: 2px dashed #adb5bd;
            border-radius: 8px;
            background: #f8f9fa;
            transition: all 0.3s ease;
            cursor: pointer;
        }

            .file-upload-wrapper:hover {
                border-color: #23a510;
                background: #f0f8f0;
            }

            .file-upload-wrapper.dragover {
                border-color: #23a510;
                background: #e8f5e8;
                transform: scale(1.02);
            }

        .file-upload {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .file-upload-label {
            color: #6c757d;
            text-align: center;
            cursor: pointer;
            transition: color 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
        }

            .file-upload-label:hover {
                color: #23a510;
            }

            .file-upload-label i {
                font-size: 2rem;
                color: #adb5bd;
            }

        .file-info {
            font-size: 0.8rem;
            color: #6c757d;
            margin-top: 8px;
            text-align: center;
        }

        .file-status {
            margin-top: 8px;
            font-size: 0.85rem;
            display: block;
        }

            .file-status.success {
                color: #28a745;
            }

            .file-status.error {
                color: #dc3545;
            }

        .note-section {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
        }

            .note-section .alert {
                margin: 0;
                border: none;
                background: transparent;
            }

        .disclaimer-box {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .disclaimer-text {
            font-size: 0.9rem;
            color: #495057;
            line-height: 1.5;
        }

            .disclaimer-text i {
                color: #ffc107;
                margin-right: 8px;
            }

        .submit-section {
            text-align: center;
            padding: 30px 0;
        }

        .btn-large {
            padding: 15px 40px;
            font-size: 1.1rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(35, 165, 16, 0.3);
        }

        .required::after {
            content: " *";
            color: #dc3545;
        }

        .form-text {
            font-size: 0.8rem;
            color: #6c757d;
            margin-top: 4px;
            display: block;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .document-row {
                flex-direction: column;
            }

            .upload-section {
                gap: 15px;
            }

            .upload-item {
                padding: 15px;
            }

            .file-upload-wrapper {
                min-height: 80px;
            }

            .section-title {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 20px 15px;
            }

            .document-section {
                padding: 20px 15px;
            }

            .btn-large {
                padding: 12px 30px;
                font-size: 1rem;
            }
        }


        .tabs {
            position: relative;
            height: 120px; /* adjust height as needed */
            top: 35px;
        }

        .tab-bg-left, .tab-bg-right {
            height: 100%;
            background-size: cover;
            background-repeat: no-repeat;
            opacity: 0.08; /* lightest opacity */
        }

        .tab-bg-left {
            background-image: url('../images/applicant/tab-bg.jpg'); /* replace with your image */
        }

        .tab-bg-right {
            background-image: url('../images/applicant/tab-bg.jpg');
        }

        .tabs-inner {
            display: flex;
            justify-content: center;
            gap: 60px; /* 20px gap between tabs */
        }

            .tabs-inner .tab {
                position: relative;
                z-index: 2; /* ensure tabs are on top of images */
            }

        .tab {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-weight: normal;
            color: #379135;
            padding: 0.8rem 2rem 0.8rem 1.5rem;
            border-radius: 4px 0 0 4px;
            border: 2px solid #43a047;
            background: transparent;
            transition: background-color 0.3s ease, color 0.3s ease, transform 0.3s ease;
        }

            .tab:hover {
                background: rgba(67,160,71,0.08);
                transform: scale(1.03);
            }

            .tab::after {
                content: "";
                position: absolute;
                right: -22px;
                top: -2px;
                width: 0;
                height: 0;
                border-top: calc(1.8rem + 4px) solid transparent;
                border-bottom: calc(1.8rem + 4px) solid transparent;
                border-left: 20px solid transparent;
                border-left-color: #43a047;
                transition: border-left-color 0.3s ease;
            }

            .tab.active {
                background: #43a047;
                color: white;
                font-weight: bold;
                transform: scale(1.05);
            }

                .tab.active::after {
                    border-left-color: #43a047;
                }

        .tab-content-wrapper {
            margin-top: 12px;
            /* padding: 1rem 1.5rem; */
            background: #fcfcfc;
            border-radius: 8px;
            /* box-shadow: 0 0 15px rgba(85, 95, 51, 0.32); */
            max-width: 1557px;
            margin-left: auto;
            margin-right: auto;
        }

        .tab-content {
            display: none;
            padding: 10px;
            background: #ffffff;
            border-radius: 5px;
            box-shadow: 0 0 11px rgb(167 167 167 / 13%);
            min-height: 120px;
            color: #222;
            opacity: 0;
            transform: translateY(10px);
            transition: opacity 0.4s ease, transform 0.4s ease;
        }

            .tab-content.active {
                display: block;
                opacity: 1;
                transform: translateY(0);
            }

        .form-container {
            /* margin: 40px auto;
            padding: 30px;*/
            /* border: 1px solid #e2e2e2;
  border-radius: 6px;*/
            /* width: 100%;*/
        }

        .form-title {
            color: #000000;
            font-size: 1.3rem;
            background-color: #2b4764;
            display: inline-block;
            padding: 9px 30px 11px 30px;
            float: right;
            /*margin-right: -12px;*/
            /*position: absolute;*/
            top: 0;
            right: 15px;
        }

        .applicantDetailsHead {
               display: flex;
                align-items: center;
                justify-content: space-around;
                gap: 20px;
        }

        .grid-container .table {
            width: 100%;
            border-collapse: collapse;
        }

            .grid-container .table th,
            .grid-container .table td {
                padding: 8px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            .grid-container .table th {
                background-color: #f2f2f2;
                font-weight: bold;
            }

        .form-title span.applicant-id.font-weight-bold {
            color: #fff !important;
        }

        select.form-control:not([size]):not([multiple]) {
            height: 45px;
            font-size: 16px;
        }

        .applicant-id {
            color: #444;
            font-size: 1rem;
        }

        .form-row {
            display: flex;
            gap: 20px;
            padding: 10px;
            background: #e8f5e9;
            border-radius: 6px;
            margin-bottom: 35px !important;
            width: 100%;
        }

        .form-control[type=file]:not(:disabled):not([readonly]) {
            cursor: pointer;
            font-size: 16px;
        }

        label {
            font-weight: 500;
            display: block;
            margin-bottom: 3px;
        }

        input[type="text"], select {
            width: 100%;
            height: 45px;
            padding: 9px;
            margin-bottom: 6px;
            border-radius: 3px;
            border: 1px solid #b6b6b6;
            background-color: #ffffff !important;
            box-shadow: 0px 0px 10px #e7e7e7;
            font-size: 16px;
        }

        input[readonly] {
            background: #f5f5f5;
        }

        .info-text {
            color: #23a510;
            font-size: 0.95rem;
            margin: 14px 0 8px;
        }

        .error-text {
            color: #c42a0e;
            font-size: 0.92rem;
            margin-left: 4px;
        }

        .radio-group {
            border: 2px solid #23a510;
            margin: 27px 10px 28px;
        }

        .radio-option {
            margin: 8px 0 0 0;
            padding: 0;
            display: flex;
            gap: 30px;
        }

        .submit-btn {
            background-color: #12450b;
            color: white;
            padding: 10px 26px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            margin-bottom: 20px;
            transition: background-color 0.3s ease, opacity 0.3s ease;
        }

            .submit-btn:disabled {
                opacity: 0.5; /* light/faded */
                cursor: not-allowed; /* show unclickable cursor */
                background-color: #008000; /* maintain color but faded */
            }

            .submit-btn:enabled:hover {
                background-color: #12450b; /* dark green on hover */
                color: #fff;
            }

        label {
            font-weight: 500;
            display: block;
            margin-bottom: 3px;
            float: left;
            font-size: 16px;
        }

        /* Radio group layout */
        .claim-radio-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 10px;
        }

            .claim-radio-list input[type="radio"] {
                margin-right: 8px;
                accent-color: #23a510; /* Modern green radio color */
                transform: scale(1.2); /* Slightly larger for professional look */
            }

            .claim-radio-list label {
                margin-right: 20px;
                font-weight: 500;
                color: #333;
                cursor: pointer;
            }

                /* Optional: hover effect */
                .claim-radio-list label:hover {
                    color: #23a510;
                }


        legend {
            display: block;
            width: 100%;
            max-width: 100%;
            padding: 0;
            margin-bottom: .5rem;
            font-size: 1.5rem;
            line-height: inherit;
            color: inherit;
            white-space: normal;
        }

        .map-container iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        .form-label {
            font-weight: 600;
            margin-bottom: 5px;
            margin-left: 3px;
            display: block;
            text-align: left;
            font-size: 16px;
        }

        .small-input {
            flex: 1;
        }

        .gender-radio-list input[type="radio"] {
            margin-right: 5px;
        }

        .gender-radio-list label {
            margin-right: 15px;
            font-weight: 500;
        }

        @media (min-width: 1200px) {
            .container {
                max-width: 1580px;
            }
        }

        input#ContentPlaceHolder1_btnreset {
            background-color: #b51515;
            color: white;
            padding: 10px 26px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            margin-bottom: 20px;
            transition: background-color 0.3s ease, opacity 0.3s ease;
        }
    </style>
    <title></title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="step-flow">

        <div class="step-item active">
            <div class="circle">①</div>
            <div class="label">Applicant Details / आवेदक का विवरण</div>
        </div>
        <div class="arrow">→</div>

        <div class="step-item">
            <div class="circle">②</div>
            <div class="label">Beneficiary Details / लाभार्थी विवरण
</div>
        </div>
        <div class="arrow">→</div>

        <div class="step-item">
            <div class="circle">③</div>
            <div class="label">Victim Incident Details / घटना का विवरण
</div>
        </div>
        <div class="arrow">→</div>

        <div class="step-item">
            <div class="circle">④</div>
            <div class="label">Victim Incident List / पीड़ित घटना सूची
</div>
        </div>
    </div>


    <%--    <form id="form1" enctype="multipart/form-data" runat="server">--%>
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="grid_item text-center">
        <div class="container divtab">
            <div class="tab-content-wrapper">

                <div id="div1" class="tab-content active">
                    <div class="form-container">
                        <div class="applicantDetailsHead">
                            <h3 class="font-weight-bold titleHeading">Applicant Details / आवेदक का विवरण
</h3>
                            <h2 class="form-title">
                                <span class="applicant-id font-weight-bold">Applicant ID / आवेदक आईडी :
                                            <asp:Label ID="lblApplicantID" runat="server"></asp:Label>
                                </span>
                            </h2>
                        </div>

                        <div class="form-row my-4">
                            <div style="flex: 2">
                                <asp:Label ID="lblFullName" runat="server" Text="Full Name / पूरा नाम" AssociatedControlID="txtFullName"></asp:Label>
                                <asp:TextBox ID="txtFullName" ReadOnly="true" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div style="flex: 2">
                                <asp:Label ID="lblMobileNumber" runat="server" Text="Mobile No. / मोबाइल नंबर" AssociatedControlID="txtMobileNumber"></asp:Label>
                                <asp:TextBox ID="txtMobileNumber" ReadOnly="true" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div style="flex: 2">
                                <asp:Label ID="lblGender" runat="server" Text="Gender / लिंग" AssociatedControlID="ddlGender"></asp:Label>
                                <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control" Enabled="false">
                                    <asp:ListItem Text="-- Select Gender --" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Male / पुरुष" Value="Male"></asp:ListItem>
                                    <asp:ListItem Text="Female / महिला" Value="Female"></asp:ListItem>
                                    <asp:ListItem Text="Other / अन्य" Value="Other"></asp:ListItem>
                                </asp:DropDownList>

                            </div>
                        </div>

                        <div class="form-row">
                            <div style="flex: 2">
                                <asp:Label ID="lblAddress" runat="server" Text="Address / पता" AssociatedControlID="txtAddress"></asp:Label>
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div style="flex: 2">

                                <asp:Label ID="lblPincode" runat="server" Text="Pincode / पिनकोड" AssociatedControlID="txtPincode"></asp:Label>
                                <asp:TextBox ID="txtPincode" runat="server" CssClass="form-control" MaxLength="6"
                                    onkeypress="return isNumberKey(event)">
                                </asp:TextBox>
                            </div>
                            <div style="flex: 2">
                                        <asp:Label ID="lblDistrict" runat="server" Text="District / ज़िला" CssClass="form-label"></asp:Label>
                                        <asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-control"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlDistrict_SelectedIndexChanged">
                                            <asp:ListItem Text="Select District" Value="0" />
                                        </asp:DropDownList>
                                    </div>
                        </div>

                        <asp:UpdatePanel ID="updLocation" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <div class="form-row" style="display: flex; gap: 20px;">
                                    

                                    <div style="flex: 1">
                                        <asp:Label ID="lblTehsil" runat="server" Text="Tehsil / तहसील" CssClass="form-label"></asp:Label>
                                        <asp:DropDownList ID="ddlTehsil" runat="server" CssClass="form-control"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlTehsil_SelectedIndexChanged">
                                            <asp:ListItem Text="Select Tehsil" Value="0" />
                                        </asp:DropDownList>
                                    </div>

                                    <div style="flex: 1">
                                        <asp:Label ID="lblVillage" runat="server" Text="Village / गाँव" CssClass="form-label"></asp:Label>
                                        <asp:DropDownList ID="ddlVillage" OnSelectedIndexChanged="ddlVillage_SelectedIndexChanged" runat="server" CssClass="form-control">
                                            <asp:ListItem Text="Select Village" Value="0" />
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>



                        <div class="form-row">
                            <div style="flex: 2">
                                <asp:Label ID="lblAadhar" runat="server" Text="Applicant Aadhaar No. / आवेदक का आधार नं." AssociatedControlID="txtAadhar"></asp:Label>
                                <asp:TextBox ID="txtAadhar" runat="server" CssClass="form-control" MaxLength="12"
                                    onkeypress="return isNumberKey(event)">
                                </asp:TextBox>
                            </div>
                             <div style="flex: 2; position: relative;">
                                <asp:Label ID="lblAadharFile" runat="server" Text="Upload Aadhaar File / आधार फ़ाइल अपलोड करें" AssociatedControlID="fuAadhar"></asp:Label>

                                <asp:FileUpload
                                    ID="fuAadhar"
                                    runat="server"
                                    CssClass="form-control"
                                    accept=".jpg,.jpeg,.png,.pdf" />

                                <div class="mt-2 d-flex align-items-center gap-3">
                                    <asp:LinkButton
                                        ID="btnPreview"
                                        runat="server"
                                        OnClientClick="return false;"
                                        CssClass="btn btn-link p-0 text-decoration-none d-flex align-items-center gap-1"
                                        Style="display: none;">
            <i class="bi bi-eye"></i>
            Preview / पूर्व दर्शन
                                    </asp:LinkButton>

                                    <asp:Label
                                        ID="lblFileSizeWarning"
                                        runat="server"
                                        Text="File size exceeds 10MB! Please upload a smaller file. / फ़ाइल का आकार 10MB से ज़्यादा है! कृपया छोटी फ़ाइल अपलोड करें।"
                                        CssClass="text-danger fw-bold"
                                        Style="display: none;"></asp:Label>
                                </div>
                            </div>
                        </div>
                       <asp:Button ID="btnNext" OnClick="btnNext_Click1" runat="server" 
    Text="Submit" 
    CssClass="submit-btn btn rounded" 
    title="Click to submit the form" />

<asp:Button ID="btnreset" runat="server" 
    Text="Reset" 
    CssClass="submit-btn-reset btn rounded" 
    title="Click to reset the form" />

                    </div>

                    <div class="grid-container">
                        <h4 class="font-weight-bold titleHeading mb-4">Applicant Details / आवेदक का विवरण</h4>

                        <asp:GridView ID="gvApplicantInfo" runat="server" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True" EmptyDataText="No applicant information available." CssClass="table table-bordered table-striped table-hover" GridLines="None" Width="100%" OnPageIndexChanging="gvApplicantInfo_PageIndexChanging" AllowPaging="True" PageSize="10">
                            <Columns>
                                <asp:TemplateField HeaderText="Applicant ID / आवेदक आईडी">
                                    <ItemTemplate>
                                        <asp:Label ID="lblApplicantID" runat="server" Text='<%# Eval("ApplicantID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Full Name / पूरा नाम">
                                    <ItemTemplate>
                                        <asp:Label ID="lblFullName" runat="server" Text='<%# Eval("FullName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Mobile No. / मोबाइल नंबर">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMobileNo" runat="server" Text='<%# Eval("MobileNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Alternate Mobile No. / वैकल्पिक मोबाइल नंबर">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAlternateMobile" runat="server" Text='<%# Eval("AlternateMobile") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Email ID / ईमेल आईडी">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmailID" runat="server" Text='<%# Eval("EmailID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Gender / लिंग">
                                    <ItemTemplate>
                                        <asp:Label ID="lblGender" runat="server" Text='<%# Eval("Gender") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Aadhaar No. / आधार नंबर">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAadharNo" runat="server" Text='<%# Eval("AadharNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Address / पता">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAddress" runat="server" Text='<%# Eval("Address") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Pincode / पिनकोड">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPincode" runat="server" Text='<%# Eval("Pincode") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Aadhaar Doc. / आधार दस्तावेज़.">
                                    <ItemTemplate>
                                        <asp:LinkButton
                                            ID="lnkAadharDoc"
                                            runat="server"
                                            Text="View Aadhaar / आधार देखें"
                                            Style="font-weight: bold; color: #007BFF; background-color: #F0F8FF; padding: 3px 6px; border-radius: 4px;"
                                            title="Click to view Aadhaar document"
                                            OnClientClick='<%# "showDocumentPopup(\"" + Eval("Aadhar") + "\", \"Aadhar Document\"); return false;" %>'>
                                        </asp:LinkButton>

                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>

                            <PagerStyle HorizontalAlign="Center" CssClass="pagination" />
                            <HeaderStyle BackColor="#23a510" ForeColor="White" Font-Bold="true" Height="40px" />
                            <RowStyle BackColor="White" ForeColor="#333" Height="35px" />
                            <AlternatingRowStyle BackColor="#f8f9fa" />
                        </asp:GridView>


                    </div>

                </div>


            </div>


        </div>
    </div>

    <%--  <div id="div1" class="tab-content active">
        <div class="form-container">
            <div class="applicantDetailsHead">
                <h3 class="font-weight-bold titleHeading">Applicant Details</h3>
                <h2 class="form-title"></h2>
            </div>--%>



    <%--</div>--%>
    <%--</form>--%>


    <!-- Modal for preview -->
    <div id="previewModal"
        style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 15px; border-radius: 10px; box-shadow: 0 5px 20px rgba(0,0,0,0.4); z-index: 1000; width: 400px; height: 400px; text-align: center;">

        <!-- Close button -->
        <span id="closeModal"
            style="cursor: pointer; position: absolute; top: 8px; right: 12px; font-weight: bold; font-size: 20px;">&times;
        </span>

        <!-- Image Preview -->
        <img id="previewImage"
            src="#"
            style="width: 100%; height: 100%; object-fit: contain; display: none; border-radius: 6px;" />

        <!-- PDF Preview -->
        <iframe id="previewPDF"
            style="width: 100%; height: 100%; display: none; border: none; border-radius: 6px;"></iframe>
    </div>




    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script type="text/javascript">
        function showDocumentPopup(fileUrl, title) {
            console.log("File URL:", fileUrl);

            if (!fileUrl || fileUrl.trim() === '#' || fileUrl.trim() === '') {
                Swal.fire({
                    html: '<b>No Document Found</b>',
                    icon: 'warning',
                    showConfirmButton: true,
                    confirmButtonText: 'OK',
                    background: '#f0f9ff',
                    color: '#1a202c'
                });
                return;
            }

            // Replace backslashes with forward slashes
            fileUrl = fileUrl.replace(/\\/g, "/");

            // Detect file type
            const isImage = /\.(jpg|jpeg|png|gif)$/i.test(fileUrl);
            const isPdf = /\.pdf$/i.test(fileUrl);

            if (isImage) {
                // Show image
                Swal.fire({
                    title: title || 'Document Preview',
                    imageUrl: fileUrl,
                    imageAlt: 'Image Document',
                    showCloseButton: true,
                    showConfirmButton: false,
                    width: '600px',
                    padding: '1rem',
                    background: '#f0f9ff'
                });
            } else if (isPdf) {
                // Show PDF inside iframe
                Swal.fire({
                    title: title || 'PDF Preview',
                    html: `<iframe src="${fileUrl}" width="100%" height="500px" style="border:none;"></iframe>`,
                    showCloseButton: true,
                    showConfirmButton: false,
                    width: '700px',
                    padding: '1rem',
                    background: '#f0f9ff'
                });
            } else {
                // Unknown type → open in new tab
                window.open(fileUrl, '_blank');
            }
        }
    </script>



    <%--<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!-- Must include this -->

<script type="text/javascript">
    function showImagePopup(imageUrl) {
        console.log("File URL:", imageUrl);
        if (!imageUrl || imageUrl === '#') {
            Swal.fire({
                html: '<b>No Image Found</b>',
                icon: 'warning',
                showConfirmButton: true,
                confirmButtonText: 'OK',
                background: '#f0f9ff',
                color: '#1a202c'
            });
            return;
        }

        Swal.fire({
            title: 'Aadhar Document',
            imageUrl: imageUrl,
            imageAlt: 'No Image Found',
            showCloseButton: true,
            showConfirmButton: false,
            width: '500px',
            padding: '1rem',
            background: '#f0f9ff'
        });
    }
</script>--%>









    <script type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode < 48 || charCode > 57) {
                return false; // Only numbers allowed
            }
            return true;
        }
    </script>


     <script>
         document.addEventListener("DOMContentLoaded", function () {
             const fileUpload = document.getElementById("<%= fuAadhar.ClientID %>");
            const btnPreview = document.getElementById("<%= btnPreview.ClientID %>");
    const lblWarning = document.getElementById("<%= lblFileSizeWarning.ClientID %>");
            const modal = document.getElementById("previewModal");
            const previewImg = document.getElementById("previewImage");
            const previewPDF = document.getElementById("previewPDF");
            const closeModal = document.getElementById("closeModal");

            // Hide preview button & warning label on load
            btnPreview.style.display = "none";
            lblWarning.style.display = "none";

            fileUpload.addEventListener("change", function () {
                if (fileUpload.files && fileUpload.files.length > 0) {
                    const file = fileUpload.files[0];
                    const allowedTypes = ["image/jpeg", "image/jpg", "image/png", "application/pdf"];
                    const fileSizeMB = file.size / (1024 * 1024);

                    if (!allowedTypes.includes(file.type)) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Invalid File',
                            text: 'Only JPG, JPEG, PNG, and PDF files are allowed.',
                            confirmButtonColor: '#d33'
                        });
                        fileUpload.value = "";
                        btnPreview.style.display = "none";
                        lblWarning.style.display = "none";
                        return;
                    }

                    if (fileSizeMB > 10) {
                        lblWarning.style.display = "inline"; // show warning
                        btnPreview.style.display = "none";    // hide preview
                        fileUpload.value = "";                 // clear file
                    } else {
                        lblWarning.style.display = "none";     // hide warning
                        btnPreview.style.display = "inline-flex"; // show preview
                    }
                } else {
                    btnPreview.style.display = "none";
                }
            });

            // Preview button click
            btnPreview.addEventListener("click", function (e) {
                e.preventDefault();

                // ✅ Check if no file is selected
                if (!fileUpload.files || fileUpload.files.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'No File Selected',
                        text: 'Please upload a file before clicking Preview.',
                        confirmButtonColor: '#3085d6'
                    });
                    return;
                }

                // Show preview if file exists
                const file = fileUpload.files[0];
                const reader = new FileReader();

                reader.onload = function (e) {
                    const fileType = file.type;
                    if (fileType.includes("image")) {
                        previewPDF.style.display = "none";
                        previewImg.style.display = "block";
                        previewImg.src = e.target.result;
                    } else if (fileType === "application/pdf") {
                        previewImg.style.display = "none";
                        previewPDF.style.display = "block";
                        previewPDF.src = e.target.result;
                    }
                    modal.style.display = "block";
                };

                reader.readAsDataURL(file);
            });

            // Close modal
            closeModal.addEventListener("click", function () {
                modal.style.display = "none";
                previewImg.src = "";
                previewPDF.src = "";
            });

            window.addEventListener("click", function (e) {
                if (e.target === modal) {
                    modal.style.display = "none";
                    previewImg.src = "";
                    previewPDF.src = "";
                }
            });
        });
     </script>


    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const tabs = document.querySelectorAll(".tab");
            const contents = document.querySelectorAll(".tab-content");
            tabs.forEach(tab => {
                tab.addEventListener("click", function () {
                    tabs.forEach(t => t.classList.remove("active"));
                    contents.forEach(c => c.classList.remove("active"));
                    this.classList.add("active");
                    document.getElementById(this.dataset.target).classList.add("active");
                });
            });
        });
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


    <%--   <script>
        document.addEventListener("DOMContentLoaded", function () {
            const btnNext = document.getElementById("<%= btnNext.ClientID %>");
            btnNext.disabled = true; // initially disable

            // List all required input controls
            const requiredInputs = [
                document.getElementById("<%= txtFullName.ClientID %>"),
                document.getElementById("<%= txtMobileNumber.ClientID %>"),
                document.getElementById("<%= txtGender.ClientID %>"),
                document.getElementById("<%= txtAddress.ClientID %>"),
                document.getElementById("<%= txtPincode.ClientID %>"),
                document.getElementById("<%= ddlDistrict.ClientID %>"),
                document.getElementById("<%= ddlTehsil.ClientID %>"),
                document.getElementById("<%= ddlVillage.ClientID %>"),
                document.getElementById("<%= txtAadhar.ClientID %>"),
                document.getElementById("<%= fuAadhar.ClientID %>")
            ];

            function checkAllFields() {
                let allFilled = true;

                requiredInputs.forEach(input => {
                    if (!input.value || input.value.trim() === "") {
                        allFilled = false;
                    }

                    // For DropDownList, check if selected value is empty
                    if (input.tagName === "SELECT" && input.value === "") {
                        allFilled = false;
                    }

                    // For FileUpload, check if file is selected
                    if (input.type === "file" && input.files.length === 0) {
                        allFilled = false;
                    }
                });

                btnNext.disabled = !allFilled; // Enable if all filled
            }

            // Add event listeners
            requiredInputs.forEach(input => {
                input.addEventListener("input", checkAllFields);
                input.addEventListener("change", checkAllFields);
            });
        });
    </script>--%>


    <script>
        function allowOnlyNumbers(event) {
            const charCode = event.which ? event.which : event.keyCode;

            // Allow: Backspace, Delete, Tab, Arrow keys
            if (charCode === 8 || charCode === 46 || charCode === 9 ||
                (charCode >= 37 && charCode <= 40)) {
                return true;
            }

            // Allow only 0-9
            if (charCode < 48 || charCode > 57) {
                event.preventDefault();
                return false;
            }
            return true;
        }
    </script>


</asp:Content>
