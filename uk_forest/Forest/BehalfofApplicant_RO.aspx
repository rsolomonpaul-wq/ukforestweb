<%@ Page Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" Async="true" CodeBehind="BehalfofApplicant_RO.aspx.cs" Inherits="uk_forest.Forest.BehalfofApplicant_RO" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css" />
    <style>
        
        .file-upload-wrapper {
            position: relative;
            display: inline-block;
        }

        .remove-file-btn {
            position: absolute;
            right: 10px;
            top: 6px;
            background: #ff4d4d;
            color: white;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            line-height: 22px;
            text-align: center;
            font-size: 14px;
            cursor: pointer;
            display: none;
            z-index: 10;
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
            width: 100%;
            max-width: 700px;
            margin: 0 auto;
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

        .file-upload {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
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
            pointer-events: none;
        }

        .file-upload-wrapper:hover .file-upload-label {
            color: #23a510;
        }

        .file-upload-label i {
            font-size: 2rem;
            color: #adb5bd;
        }

        @media (min-width: 1200px) {
            .container {
                max-width: 1580px;
            }
        }

        .tab-content-wrapper {
            margin-top: 12px;
            background: #fff;
            border-radius: 8px;
            max-width: 1557px;
            margin-left: auto;
            margin-right: auto;
            padding: 20px;
            box-shadow: 0 0 11px rgb(167 167 167 / 13%);
        }
        .form-row {
            display: flex;
            gap: 20px;
            padding: 10px;
            background: #8080800a;
            border-left: 1px solid gray;
            border-radius:6px;
            margin-bottom:20px;
        }
        label{
            font-weight: 500;
            display: block;
            margin-bottom: 3px;
            float: left;
        }

        input[type="text"], select {
            width: 100%;
            padding: 6px;
            margin-bottom: 6px;
            border-radius: 3px;
            border: 1px solid #b6b6b6;
        }

        .form-control {
            display: block;
            width: 100%;
            padding: .375rem .75rem;
            font-size: 1rem;
            line-height: 1.5;
            color: #495057;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            border-radius: .25rem;
            transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out;
        }

        .submit-btn {
            background-color: #008000;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            margin-top: 20px;
            transition: background-color 0.3s ease, opacity 0.3s ease;
        }

            .submit-btn:hover {
                background-color: #006400;
            }

        .radio-group {
            border: 2px solid #23a510;
            margin: 27px 10px 28px;
        }

        .claim-radio-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 10px;
        }

            .claim-radio-list input[type="radio"] {
                margin-right: 8px;
                accent-color: #23a510;
                transform: scale(1.2);
            }

            .claim-radio-list label {
                margin-right: 20px;
                font-weight: 500;
                color: #333;
                cursor: pointer;
            }

                .claim-radio-list label:hover {
                    color: #23a510;
                }

        .gender-radio-list input[type="radio"] {
            margin-right: 5px;
        }

        .gender-radio-list span {
            display: block;
            margin-bottom: 5px;
        }

        .form-title {
            background-color: #2b4764;
            display: inline-block;
            padding: 9px 30px 11px 30px;
            float: right;
            margin-right: -12px;
            position: absolute;
            top: 10px;
            right: 5px;
            font-size: 1rem;
            color: #fff;
        }

        table#ContentPlaceHolder1_rblGender {
            position: relative;
            top: 8px;
        }

        label#ContentPlaceHolder1_Label1 {
            display: block;
            width: 100%;
        }

        table#ContentPlaceHolder1_rblGender tbody, td, tfoot, th, thead, tr {
            border: 0 !important;
        }

        table#ContentPlaceHolder1_rblGender tr, td {
            border: 0 !important;
        }

            table#ContentPlaceHolder1_rblGender tr, td label {
                margin-block: 0;
            }

            table#ContentPlaceHolder1_rblGender tr, td label {
                margin-block: 0;
                margin-right: 5px;
                position: relative;
                top: -2px;
            }
            .gemderOption > label{
                width: 100%;
                margin-bottom: 0.5rem !important;
            }

    </style>

    <script>
        // ✅ Allow only alphabets and space while typing
        function allowOnlyAlphabets(e) {
            const char = String.fromCharCode(e.which);
            // allow alphabets and space
            if (!/[a-zA-Z ]/.test(char)) {
                e.preventDefault();
            }
        }

        // ✅ Format and capitalize words
        function validateAndFormatName(input) {
            // Remove everything except letters and spaces
            let value = input.value.replace(/[^a-zA-Z ]/g, "");

            // Capitalize first letter of every word
            value = value.replace(/\b\w/g, function (char) {
                return char.toUpperCase();
            });

            // Remove multiple spaces
            value = value.replace(/\s+/g, " ").trimStart();

            input.value = value;
        }
    </script>

    <script>
        // ✅ Allow only number keys while typing
        function allowOnlyNumbers(e) {
            const charCode = e.which ? e.which : e.keyCode;
            // Allow control keys like backspace, delete, arrow keys
            if (charCode === 8 || charCode === 46 || (charCode >= 37 && charCode <= 40)) {
                return;
            }
            // Block everything except digits (0–9)
            if (charCode < 48 || charCode > 57) {
                e.preventDefault();
            }
        }

        // ✅ Sanitize input (remove non-numeric) + limit to maxLength
        function sanitizeAndLimit(input, maxLength) {
            // Remove any non-digit character
            input.value = input.value.replace(/\D/g, '');
            // Enforce 10-digit limit
            if (input.value.length > maxLength) {
                input.value = input.value.slice(0, maxLength);
            }
        }
    </script>

    <script type="text/javascript">
        function allowOnlyNumbers(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode < 48 || charCode > 57) {
                return false; // block non-numeric
            }
            return true;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <div class="grid_item">
        <div class="container divtab">
            <div class="tab-content-wrapper">
                <div class="form-container">
                    <div class="position-relative mb-3" style="display: flex; align-items: center; justify-content: center;">
                        <h2 class="font-weight-bold titleHeading mb-0 text-center" style="flex: 1;">Victim Incident Details</h2>
                    </div>

                    <fieldset class="radio-group" style="border: 1px solid #b1c7ad; padding: 15px; border-radius: 8px; margin-top: 30px;">
                        <legend style="font-weight: 500; float: inherit; padding: 2px 10px; color: #fff; border-radius: 5px; background-color: #13460c; margin-bottom: 10px; text-align: center; width: auto; margin-left: auto; margin-right: auto; font-size: 18px;">
                            <asp:Label ID="lblClaimType" runat="server" Text="Type of Claim Category / दावा श्रेणी का प्रकार"></asp:Label>
                        </legend>
                        <div class="d-flex flex-wrap justify-content-center" style="gap: 20px;">
                            <asp:RadioButtonList ID="rblClaimType" runat="server" RepeatDirection="Horizontal" CssClass="claim-radio-list" RepeatLayout="Flow" OnSelectedIndexChanged="rblClaimType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Text="Human Death / Injury (मानव मृत्यु / घायल)" Value="Human" />
            <asp:ListItem Text="Crop Damage (फसल क्षति)" Value="Crop" />
            <asp:ListItem Text="Cattle Kill (पशु मृत्यु)" Value="Cattle" />
            <asp:ListItem Text="Property Damage (संपत्ति क्षति)" Value="House" />
                            </asp:RadioButtonList>
                        </div>
                    </fieldset>




                    <h3 class="mt-2 text-success text-center">Applicant Personal Details / आवेदक का व्यक्तिगत विवरण</h3>

                    <div class="form-row">
                        <div style="flex: 4; margin-right: 10px;">
                            <asp:Label ID="Label6" runat="server"
                                Text="Applicant Full Name / आवेदक का पूरा नाम"
                                AssociatedControlID="txt_applicant_fullname"
                                CssClass="form-label"></asp:Label>
                            <asp:TextBox
                                ID="txt_applicant_fullname"
                                runat="server"
                                CssClass="form-control"
                                Placeholder="Enter Full Name / पूरा नाम दर्ज करें"
                                oninput="validateAndFormatName(this)"
                                onkeypress="allowOnlyAlphabets(event)">
                            </asp:TextBox>
                        </div>

                        <div style="flex: 4;">
                            <asp:Label ID="Label26" runat="server"
                                Text="Applicant Mobile No. / आवेदक का मोबाइल नंबर"
                                AssociatedControlID="txt_applicant_mobile"
                                CssClass="form-label"></asp:Label>
                            <asp:TextBox
                                ID="txt_applicant_mobile"
                                runat="server"
                                CssClass="form-control"
                                Placeholder="Enter Mobile Number / मोबाइल नंबर दर्ज करें"
                                onkeypress="allowOnlyNumbers(event)"
                                oninput="sanitizeAndLimit(this, 10)">
                            </asp:TextBox>
                        </div>

                        <div style="flex: 4;" class="gemderOption">
                            <asp:Label ID="Label27" runat="server"
                                Text="Gender / लिंग"
                                AssociatedControlID="rblGender"
                                CssClass="form-label d-block mb-2"
                                Style="100%"></asp:Label>
                            <asp:RadioButtonList
                                ID="rblapplicantgender"
                                runat="server"
                                RepeatDirection="Horizontal"
                                RepeatLayout="Table"
                                CssClass="gender-radio-list">
                                <asp:ListItem Text="Male / पुरुष" Value="Male" />
                                <asp:ListItem Text="Female / महिला" Value="Female" />
                                <asp:ListItem Text="Other / अन्य" Value="Other" />
                            </asp:RadioButtonList>
                        </div>

                        <div style="flex: 4;">
                            <asp:Label ID="Label28" runat="server"
                                Text="Applicant Email / आवेदक का ईमेल"
                                AssociatedControlID="txt_applicant_email"
                                CssClass="form-label"></asp:Label>
                            <asp:TextBox
                                ID="txt_applicant_email"
                                runat="server"
                                CssClass="form-control"
                                Placeholder="Enter Applicant Email / ईमेल दर्ज करें">
                            </asp:TextBox>
                        </div>

                        <div style="flex: 4;">
                            <asp:Label ID="Label29" runat="server"
                                Text="Alternate No. / वैकल्पिक नंबर"
                                AssociatedControlID="txt_applicant_alternateno"
                                CssClass="form-label"></asp:Label>
                            <asp:TextBox
                                ID="txt_applicant_alternateno"
                                runat="server"
                                CssClass="form-control"
                                Placeholder="Enter Alternate Number / वैकल्पिक नंबर दर्ज करें"
                                onkeypress="allowOnlyNumbers(event)"
                                oninput="sanitizeAndLimit(this, 10)">
                            </asp:TextBox>
                        </div>
                    </div>


                    <hr />
                    <h3 class="mt-2 text-success text-center">Applicant Beneficiary Details / आवेदक लाभार्थी विवरण
                    </h3>

                    <asp:HiddenField ID="hfId" runat="server" />
                    <asp:HiddenField ID="hfBeneficiaryId" runat="server" />

                    <div class="form-row">
                        <div style="flex: 4; margin-right: 10px;">
                            <asp:Label ID="Label30" runat="server"
                                Text="Select Bank / बैंक चुनें"
                                AssociatedControlID="ddlBanks"
                                CssClass="form-label"></asp:Label>
                            <asp:DropDownList ID="ddlBanks" runat="server" CssClass="form-control">
                                <asp:ListItem Value="0">Select Bank / बैंक चुनें</asp:ListItem>

                                <asp:ListItem Value="Bank of Baroda">Bank of Baroda</asp:ListItem>
                                <asp:ListItem Value="Bank of India">Bank of India</asp:ListItem>
                                <asp:ListItem Value="Bank of Maharashtra">Bank of Maharashtra</asp:ListItem>
                                <asp:ListItem Value="Canara Bank">Canara Bank</asp:ListItem>
                                <asp:ListItem Value="Central Bank of India">Central Bank of India</asp:ListItem>
                                <asp:ListItem Value="Indian Bank">Indian Bank</asp:ListItem>
                                <asp:ListItem Value="Indian Overseas Bank">Indian Overseas Bank</asp:ListItem>
                                <asp:ListItem Value="Punjab & Sind Bank">Punjab & Sind Bank</asp:ListItem>
                                <asp:ListItem Value="Punjab National Bank">Punjab National Bank</asp:ListItem>
                                <asp:ListItem Value="State Bank of India">State Bank of India</asp:ListItem>
                                <asp:ListItem Value="UCO Bank">UCO Bank</asp:ListItem>
                                <asp:ListItem Value="Union Bank of India">Union Bank of India</asp:ListItem>
                                <asp:ListItem Value="Axis Bank">Axis Bank</asp:ListItem>
                                <asp:ListItem Value="Bandhan Bank">Bandhan Bank</asp:ListItem>
                                <asp:ListItem Value="CSB Bank">CSB Bank</asp:ListItem>
                                <asp:ListItem Value="City Union Bank">City Union Bank</asp:ListItem>
                                <asp:ListItem Value="DCB Bank">DCB Bank</asp:ListItem>
                                <asp:ListItem Value="Dhanlaxmi Bank">Dhanlaxmi Bank</asp:ListItem>
                                <asp:ListItem Value="Federal Bank">Federal Bank</asp:ListItem>
                                <asp:ListItem Value="HDFC Bank">HDFC Bank</asp:ListItem>
                                <asp:ListItem Value="ICICI Bank">ICICI Bank</asp:ListItem>
                                <asp:ListItem Value="IndusInd Bank">IndusInd Bank</asp:ListItem>
                                <asp:ListItem Value="IDFC First Bank">IDFC First Bank</asp:ListItem>
                                <asp:ListItem Value="IDBI Bank">IDBI Bank</asp:ListItem>
                                <asp:ListItem Value="Jammu & Kashmir Bank">Jammu & Kashmir Bank</asp:ListItem>
                                <asp:ListItem Value="Karnataka Bank">Karnataka Bank</asp:ListItem>
                                <asp:ListItem Value="Karur Vysya Bank">Karur Vysya Bank</asp:ListItem>
                                <asp:ListItem Value="Kotak Mahindra Bank">Kotak Mahindra Bank</asp:ListItem>
                                <asp:ListItem Value="Lakshmi Vilas Bank">Lakshmi Vilas Bank</asp:ListItem>
                                <asp:ListItem Value="Nainital Bank">Nainital Bank</asp:ListItem>
                                <asp:ListItem Value="RBL Bank">RBL Bank</asp:ListItem>
                                <asp:ListItem Value="South Indian Bank">South Indian Bank</asp:ListItem>
                                <asp:ListItem Value="Tamilnad Mercantile Bank">Tamilnad Mercantile Bank</asp:ListItem>
                                <asp:ListItem Value="YES Bank">YES Bank</asp:ListItem>
                                <asp:ListItem Value="AU Small Finance Bank">AU Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="Capital Small Finance Bank">Capital Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="Equitas Small Finance Bank">Equitas Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="ESAF Small Finance Bank">ESAF Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="Fincare Small Finance Bank">Fincare Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="Jana Small Finance Bank">Jana Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="North East Small Finance Bank">North East Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="Suryoday Small Finance Bank">Suryoday Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="Ujjivan Small Finance Bank">Ujjivan Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="Utkarsh Small Finance Bank">Utkarsh Small Finance Bank</asp:ListItem>
                                <asp:ListItem Value="Airtel Payments Bank">Airtel Payments Bank</asp:ListItem>
                                <asp:ListItem Value="India Post Payments Bank">India Post Payments Bank</asp:ListItem>
                                <asp:ListItem Value="Fino Payments Bank">Fino Payments Bank</asp:ListItem>
                                <asp:ListItem Value="Jio Payments Bank">Jio Payments Bank</asp:ListItem>
                                <asp:ListItem Value="Paytm Payments Bank">Paytm Payments Bank</asp:ListItem>
                                <asp:ListItem Value="American Express Banking Corporation">American Express Banking Corporation</asp:ListItem>
                                <asp:ListItem Value="Bank of America">Bank of America</asp:ListItem>
                                <asp:ListItem Value="Barclays Bank">Barclays Bank</asp:ListItem>
                                <asp:ListItem Value="Citibank">Citibank</asp:ListItem>
                                <asp:ListItem Value="DBS Bank">DBS Bank</asp:ListItem>
                                <asp:ListItem Value="Deutsche Bank">Deutsche Bank</asp:ListItem>
                                <asp:ListItem Value="HSBC Bank">HSBC Bank</asp:ListItem>
                                <asp:ListItem Value="Standard Chartered Bank">Standard Chartered Bank</asp:ListItem>
                                <asp:ListItem Value="Saraswat Cooperative Bank">Saraswat Cooperative Bank</asp:ListItem>
                                <asp:ListItem Value="Shamrao Vithal Cooperative Bank">Shamrao Vithal Cooperative Bank</asp:ListItem>
                                <asp:ListItem Value="NKGSB Cooperative Bank">NKGSB Cooperative Bank</asp:ListItem>
                                <asp:ListItem Value="Cosmos Cooperative Bank">Cosmos Cooperative Bank</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div style="flex: 4;">
                            <asp:Label ID="lblFullName" runat="server"
                                Text="Bank Account Holder Name / बैंक खाते धारक का नाम"
                                AssociatedControlID="txt_bankaccountholdername"
                                CssClass="form-label"></asp:Label>
                            <asp:TextBox
                                ID="txt_bankaccountholdername"
                                runat="server"
                                CssClass="form-control"
                                Placeholder="Enter Account Holder Name / खाता धारक का नाम दर्ज करें"
                                onkeyup="toTitleCase(this)"
                                onkeypress="return onlyAlphabets(event)">
                            </asp:TextBox>
                        </div>

                        <div style="flex: 4;">
                            <asp:Label ID="lblAccountNumber" runat="server"
                                Text="Bank Account No. / बैंक खाता संख्या"
                                AssociatedControlID="txtAccountNumber"
                                CssClass="form-label"></asp:Label>
                            <asp:TextBox
                                ID="txtAccountNumber"
                                runat="server"
                                CssClass="form-control"
                                Placeholder="Enter Account Number / खाता संख्या दर्ज करें"
                                MaxLength="18"
                                onkeypress="return isNumberKey(event)">
                            </asp:TextBox>
                        </div>
                    </div>


                    <div class="form-row">
                        <div style="flex: 4; margin-right: 10px;">
                            <asp:Label ID="lblIFSC" runat="server" Text="IFSC Code / आई.एफ.एस.सी कोड" AssociatedControlID="txtIFSC"></asp:Label>
                            <asp:TextBox
                                ID="txtIFSC"
                                runat="server"
                                CssClass="form-control"
                                MaxLength="11"
                                Placeholder="Enter IFSC Code / आई.एफ.एस.सी कोड दर्ज करें"
                                onkeypress="return isAlphaNumeric(event)"
                                onkeyup="toUpperCaseText(this)">
                            </asp:TextBox>
                        </div>

                        <div style="flex: 4;">
                            <asp:Label ID="lblPanNumber" runat="server" Text="PAN No. (Optional) / पैन नंबर (वैकल्पिक)" AssociatedControlID="txtPanNumber"></asp:Label>
                            <asp:TextBox
                                ID="txtPanNumber"
                                runat="server"
                                CssClass="form-control"
                                MaxLength="10"
                                Placeholder="Enter PAN Number / पैन नंबर दर्ज करें"
                                onkeyup="toUpperCaseText(this)"
                                onkeypress="return validatePAN(event, this)">
                            </asp:TextBox>
                        </div>

                        <div style="flex: 4; margin-right: 10px;">
                            <asp:Label ID="Label31" runat="server" Text="Aadhaar No. / आधार नंबर" AssociatedControlID="txtAadhar"></asp:Label>
                            <asp:TextBox
                                ID="TextBox3"
                                runat="server"
                                CssClass="form-control"
                                MaxLength="12"
                                Placeholder="Enter Aadhaar Number / आधार नंबर दर्ज करें"
                                onkeypress="return allowOnlyNumbers(event)">
                            </asp:TextBox>
                        </div>

                        <div style="flex: 4; margin-right: 10px;">
                            <asp:Label ID="Label32" runat="server" Text="Upload Aadhaar File / आधार फ़ाइल अपलोड करें" AssociatedControlID="filebeneficiary"></asp:Label>
                            <asp:FileUpload
                                ID="filebeneficiary"
                                runat="server"
                                CssClass="form-control"
                                accept=".jpg,.jpeg,.png,.pdf"
                                ToolTip="Upload Aadhaar File / आधार फ़ाइल अपलोड करें" />

                            <div class="mt-2 d-flex align-items-center gap-3">
                                <asp:LinkButton
                                    ID="LinkButton1"
                                    runat="server"
                                    Text="Preview / पूर्वावलोकन"
                                    OnClientClick="return false;"
                                    CssClass="btn btn-link mt-2 d-flex align-items-center gap-1"
                                    Style="display: none;">
                <i class="bi bi-eye"></i> Preview
                                </asp:LinkButton>

                                <asp:Label
                                    ID="lblFileSizeWarning"
                                    runat="server"
                                    Text="File size exceeds 10MB! Please upload a smaller file. / फ़ाइल का आकार 10MB से अधिक है! कृपया छोटी फ़ाइल अपलोड करें।"
                                    CssClass="text-danger fw-bold"
                                    Style="display: none;">
                                </asp:Label>
                            </div>
                        </div>
                    </div>



                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const fileUpload = document.getElementById("<%= filebeneficiary.ClientID %>");
                            const btnPreview = document.getElementById("<%= btnPreview.ClientID %>");
                            const lblWarning = document.getElementById("<%= lblFileSizeWarning.ClientID %>");
                            const modal = document.getElementById("previewModal");
                            const previewImg = document.getElementById("previewImage");
                            const previewPDF = document.getElementById("previewPDF");
                            const closeModal = document.getElementById("closeModal");

                            // Force hide preview & warning on page load
                            btnPreview.style.display = "none";
                            lblWarning.style.display = "none";

                            fileUpload.addEventListener("change", function () {
                                if (fileUpload.files && fileUpload.files.length > 0) {
                                    const file = fileUpload.files[0];
                                    const allowedTypes = ["image/jpeg", "image/jpg", "image/png", "application/pdf"];
                                    const fileSizeMB = file.size / (1024 * 1024); // bytes → MB

                                    // Validate type
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

                                    // Validate size
                                    if (fileSizeMB > 10) {
                                        lblWarning.style.display = "inline";
                                        fileUpload.value = ""; // clear file
                                        btnPreview.style.display = "none";
                                    } else {
                                        lblWarning.style.display = "none";
                                        btnPreview.style.display = "inline-flex";
                                    }
                                } else {
                                    btnPreview.style.display = "none";
                                }
                            });

                            // Preview button click
                            btnPreview.addEventListener("click", function (e) {
                                e.preventDefault();

                                // No file selected
                                if (!fileUpload.files || fileUpload.files.length === 0) {
                                    Swal.fire({
                                        icon: 'warning',
                                        title: 'No File Selected',
                                        text: 'Please upload a file before clicking Preview.',
                                        confirmButtonColor: '#3085d6'
                                    });
                                    return;
                                }

                                const file = fileUpload.files[0];
                                const reader = new FileReader();

                                reader.onload = function (e) {
                                    if (file.type.includes("image")) {
                                        previewPDF.style.display = "none";
                                        previewImg.style.display = "block";
                                        previewImg.src = e.target.result;
                                    } else if (file.type === "application/pdf") {
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


                    <script type="text/javascript">
                        function isAlphaNumeric(e) {
                            let charCode = e.which || e.keyCode;
                            if ((charCode >= 65 && charCode <= 90) ||
                                (charCode >= 97 && charCode <= 122) ||
                                (charCode >= 48 && charCode <= 57) ||
                                charCode == 8) {
                                return true;
                            }
                            return false;
                        }

                        function toUpperCaseText(input) {
                            input.value = input.value.toUpperCase();
                        }
                    </script>

                    <script type="text/javascript">
                        function toUpperCaseText(input) {
                            input.value = input.value.toUpperCase();
                        }

                        function validatePAN(e, input) {
                            let charCode = e.which || e.keyCode;
                            let value = input.value;

                            if (value.length < 5) {
                                if (charCode >= 65 && charCode <= 90 || charCode >= 97 && charCode <= 122) {
                                    return true;
                                }
                            } else if (value.length >= 5 && value.length < 9) {
                                if (charCode >= 48 && charCode <= 57) {
                                    return true;
                                }
                            } else if (value.length == 9) {
                                if (charCode >= 65 && charCode <= 90 || charCode >= 97 && charCode <= 122) {
                                    return true;
                                }
                            }

                            if (charCode == 8) return true;

                            return false;
                        }
                    </script>

                    <script type="text/javascript">
                        function toTitleCase(input) {
                            let value = input.value.toLowerCase();
                            input.value = value.replace(/\b\w/g, function (char) {
                                return char.toUpperCase();
                            });
                        }

                        function onlyAlphabets(e) {
                            let charCode = e.which || e.keyCode;
                            if ((charCode >= 65 && charCode <= 90) ||
                                (charCode >= 97 && charCode <= 122) ||
                                charCode == 32 || charCode == 8) {
                                return true;
                            }
                            return false;
                        }
                    </script>




                    <hr />


                    <h3 class="mt-2 text-success text-center">Victim Personal Details / पीड़ित के व्यक्तिगत विवरण</h3>

                    <div class="form-row">
                        <!-- Full Name -->
                        <div style="flex: 4; margin-right: 10px;">
                            <asp:Label ID="Label2" runat="server" Text="Full Name / पूरा नाम" AssociatedControlID="txtFullName" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"
                                Placeholder="Enter Full Name / पूरा नाम दर्ज करें"
                                oninput="validateAndFormatName(this)"
                                onkeypress="allowOnlyAlphabets(event)"></asp:TextBox>
                        </div>

                        <!-- Father Name -->
                        <div style="flex: 4;">
                            <asp:Label ID="lblFatherName" runat="server" Text="Father's Name / पिता का नाम" AssociatedControlID="txtFatherName" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="txtFatherName" runat="server" CssClass="form-control"
                                Placeholder="Enter Father Name / पिता का नाम दर्ज करें"
                                oninput="validateAndFormatName(this)"
                                onkeypress="allowOnlyAlphabets(event)"></asp:TextBox>
                        </div>

                        <!-- Gender -->
                        <div style="flex: 4;">
                            <asp:Label ID="Label1" runat="server" Text="Gender / लिंग" AssociatedControlID="rblGender" CssClass="form-label d-block mb-2" Style="100%"></asp:Label>
                            <asp:RadioButtonList ID="rblGender" runat="server"
                                RepeatDirection="Horizontal" RepeatLayout="Table"
                                CssClass="gender-radio-list">
                                <asp:ListItem Text="Male / पुरुष" Value="Male" />
                                <asp:ListItem Text="Female / महिला" Value="Female" />
                                <asp:ListItem Text="Other / अन्य" Value="Other" />
                            </asp:RadioButtonList>
                        </div>
                    </div>

                    <!-- Conditional section for human death -->
                    <div class="form-row" id="humandeath" runat="server" visible="false">
                        <!-- Age -->
                        <div style="flex: 4;">
                            <asp:Label ID="lblAge" runat="server" Text="Age / आयु" AssociatedControlID="txtAge" CssClass="form-label d-block mb-2"></asp:Label>
                            <asp:TextBox ID="txtAge" runat="server" CssClass="form-control"
                                Placeholder="Enter Age / आयु दर्ज करें" MaxLength="3" onkeypress="return allowDecimal(event)"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="revAge" runat="server"
                                ControlToValidate="txtAge"
                                ValidationExpression="^\d+(\.\d+)?$"
                                ErrorMessage="Only numbers or decimals allowed / केवल अंक या दशमलव स्वीकार्य हैं"
                                CssClass="text-danger" Display="Dynamic" />
                        </div>

                        <div class="form-row">
                            <!-- Aadhaar -->
                            <div style="flex: 2">
                                <asp:Label ID="lblAadhar" runat="server" Text="Aadhaar Number / आधार नंबर" AssociatedControlID="txtAadhar"></asp:Label>
                                <asp:TextBox ID="txtAadhar" runat="server" CssClass="form-control"
                                    MaxLength="12" Placeholder="Enter Aadhaar Number / आधार नंबर दर्ज करें"
                                    onkeypress="return allowOnlyNumbers(event)"></asp:TextBox>

                                <asp:RegularExpressionValidator ID="revAadhar" runat="server"
                                    ControlToValidate="txtAadhar"
                                    ValidationExpression="^\d{12}$"
                                    ErrorMessage="Enter valid 12-digit Aadhaar number / 12 अंकों का मान्य आधार नंबर दर्ज करें"
                                    CssClass="text-danger" Display="Dynamic" />
                            </div>

                            <!-- Upload Aadhaar -->
                            <div style="flex: 2; position: relative;">
                                <asp:Label ID="lblAadharFile" runat="server" Text="Upload Aadhaar File / आधार फ़ाइल अपलोड करें" AssociatedControlID="fuAadhar"></asp:Label>
                                <asp:FileUpload ID="fuAadhar" runat="server" CssClass="form-control"
                                    ToolTip="Upload Aadhaar File / आधार फ़ाइल अपलोड करें" />
                                <asp:LinkButton ID="btnPreview" runat="server" Text="Preview / पूर्वावलोकन"
                                    OnClientClick="return false;" CssClass="btn btn-link mt-2" Style="display: none;"></asp:LinkButton>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Info -->
                    <div class="row mb-3">
                        <!-- Mobile -->
                        <div class="col-md-4">
                            <asp:Label ID="Label23" runat="server" Text="Mobile No. / मोबाइल नंबर" AssociatedControlID="TextMob" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="TextMob" runat="server" CssClass="form-control"
                                Placeholder="Enter Mobile No. / मोबाइल नंबर दर्ज करें"
                                onkeypress="allowOnlyNumbers(event)"
                                oninput="sanitizeAndLimit(this, 10)"></asp:TextBox>
                        </div>

                        <!-- Alternate Mobile -->
                        <div class="col-md-4">
                            <asp:Label ID="Label24" runat="server" Text="Alternate Mobile No. / वैकल्पिक मोबाइल नंबर" AssociatedControlID="TextMobalter" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="TextMobalter" runat="server" CssClass="form-control"
                                Placeholder="Enter Alternate Mobile No. / वैकल्पिक मोबाइल नंबर दर्ज करें"
                                onkeypress="allowOnlyNumbers(event)"
                                oninput="sanitizeAndLimit(this, 10)"></asp:TextBox>
                        </div>

                        <!-- Email -->
                        <div class="col-md-4">
                            <asp:Label ID="Label25" runat="server" Text="Email / ईमेल" AssociatedControlID="Textemail" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="Textemail" runat="server" CssClass="form-control"
                                Placeholder="Enter Email / ईमेल दर्ज करें"></asp:TextBox>
                        </div>
                    </div>


                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>

                            <!-- Crop Damage Section -->
                            <div class="form-row" id="cropdamage" runat="server" visible="false">
                                <div style="flex: 4; margin-right: 10px;">
                                    <asp:Label ID="Label3" runat="server" Text="Farmer Name / किसान का नाम" AssociatedControlID="TextBox1" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" Placeholder="Enter Farmer Full Name / किसान का पूरा नाम दर्ज करें"></asp:TextBox>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="Label4" runat="server" Text="Father's Name / पिता का नाम" AssociatedControlID="TextBox2" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" Placeholder="Enter Father Name / पिता का नाम दर्ज करें"></asp:TextBox>
                                </div>
                            </div>

                            <!-- Cattle Kill Section -->
                            <div class="form-row" id="cattlekill" runat="server" visible="false">
                                <div style="flex: 4; margin-right: 10px;">
                                    <asp:Label ID="Label8" runat="server" Text="Cattle Owner Name / पशु मालिक का नाम" AssociatedControlID="txt_cattle_owner" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_cattle_owner" runat="server" CssClass="form-control" Placeholder="Enter Cattle Owner Full Name / पशु मालिक का पूरा नाम दर्ज करें"></asp:TextBox>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="Label9" runat="server" Text="Father's Name / पिता का नाम" AssociatedControlID="txt_cattle_father_name" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_cattle_father_name" runat="server" CssClass="form-control" Placeholder="Enter Father Name / पिता का नाम दर्ज करें"></asp:TextBox>
                                </div>

                                <asp:Panel ID="pnlCattleDetails" runat="server" CssClass="cattle-details-container">
                                    <div class="cattle-row" style="display: flex; gap: 20px; margin-bottom: 10px;">
                                        <div style="flex: 4;">
                                            <asp:Label ID="Label10" runat="server" Text="Species Type / पशु की जाति" AssociatedControlID="ddl_cattle_species" CssClass="form-label d-block mb-2"></asp:Label>
                                            <asp:DropDownList ID="ddl_cattle_species" runat="server" CssClass="form-control cattle-species">
                                                <asp:ListItem Text="Select Species / पशु की जाति चुनें" Value="" />
                                                <asp:ListItem Text="Cattle (गाय/बैल)" Value="Cattle" />
                                                <asp:ListItem Text="Buffalo (भैंस)" Value="Buffalo" />
                                                <asp:ListItem Text="Goat (बकरी)" Value="Goat" />
                                                <asp:ListItem Text="Sheep (भेड़)" Value="Sheep" />
                                                <asp:ListItem Text="Horse (घोड़ा)" Value="Horse" />
                                                <asp:ListItem Text="Mule (खच्चर)" Value="Mule" />
                                                <asp:ListItem Text="Donkey (गधा)" Value="Donkey" />
                                                <asp:ListItem Text="Pig (सुअर)" Value="Pig" />
                                                <asp:ListItem Text="Poultry (मुर्गी)" Value="Poultry" />
                                            </asp:DropDownList>
                                        </div>

                                        <div style="flex: 4;">
                                            <asp:Label ID="Label11" runat="server" Text="Age of Dead Cattle / मृत पशु की आयु" AssociatedControlID="ddl_cattle_age" CssClass="form-label d-block mb-2"></asp:Label>
                                            <asp:DropDownList ID="ddl_cattle_age" runat="server" CssClass="form-control cattle-age">
                                                <asp:ListItem Text="Select Age (in Years) / आयु चुनें (वर्षों में)" Value="" />
                                                <asp:ListItem Text="1" Value="1" />
                                                <asp:ListItem Text="2" Value="2" />
                                                <asp:ListItem Text="3" Value="3" />
                                                <asp:ListItem Text="4" Value="4" />
                                                <asp:ListItem Text="5" Value="5" />
                                                <asp:ListItem Text="6" Value="6" />
                                                <asp:ListItem Text="7" Value="7" />
                                                <asp:ListItem Text="8" Value="8" />
                                                <asp:ListItem Text="9" Value="9" />
                                                <asp:ListItem Text="10" Value="10" />
                                                <asp:ListItem Text="11" Value="11" />
                                                <asp:ListItem Text="12" Value="12" />
                                                <asp:ListItem Text="13" Value="13" />
                                                <asp:ListItem Text="14" Value="14" />
                                                <asp:ListItem Text="15" Value="15" />
                                                <asp:ListItem Text="16" Value="16" />
                                                <asp:ListItem Text="17" Value="17" />
                                                <asp:ListItem Text="18" Value="18" />
                                                <asp:ListItem Text="19" Value="19" />
                                                <asp:ListItem Text="20" Value="20" />
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div id="dynamicCattleFields" runat="server" class="dynamic-cattle-fields"></div>
                                    <asp:Button ID="btnAddCattle" runat="server" Text="&#43; Add Another / एक और जोड़ें" CssClass="btn btn-primary" OnClientClick="addCattleField(); return false;" />

                                    <asp:HiddenField ID="hfCattleSpecies" runat="server" />
                                    <asp:HiddenField ID="hfCattleAges" runat="server" />
                                </asp:Panel>
                            </div>

                            <!-- House Damage Section -->
                            <div class="form-row" id="housedamage" runat="server" visible="false">
                                <div style="flex: 4; margin-right: 10px;">
                                    <asp:Label ID="Label12" runat="server" Text="House Owner Name / मकान मालिक का नाम" AssociatedControlID="txt_house_owner_name" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_house_owner_name" runat="server" CssClass="form-control" Placeholder="Enter House Owner Name / मकान मालिक का नाम दर्ज करें"></asp:TextBox>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="Label13" runat="server" Text="Father's Name / पिता का नाम" AssociatedControlID="txt_house_father_name" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_house_father_name" runat="server" CssClass="form-control" Placeholder="Enter Father Name / पिता का नाम दर्ज करें"></asp:TextBox>
                                </div>
                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>


                    <h4 class="mt-2 text-success text-center">Incident Details (घटना का विवरण)</h4>

                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <!-- First Row -->
                            <div class="form-row">
                                <!-- District -->
                                <div style="flex: 4;">
                                    <asp:Label ID="lblDistrict3" runat="server"
                                        Text="District / जिला"
                                        CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-control"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlDistrict_SelectedIndexChanged">
                                        <asp:ListItem Text="Select District / जिला चुनें" Value="0" />
                                    </asp:DropDownList>
                                </div>

                                <!-- Tehsil -->
                                <div style="flex: 4;">
                                    <asp:Label ID="lblTehsil3" runat="server"
                                        Text="Tehsil / तहसील"
                                        CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddlTehsil" runat="server" CssClass="form-control"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlTehsil_SelectedIndexChanged">
                                        <asp:ListItem Text="Select Tehsil / तहसील चुनें" Value="0" />
                                    </asp:DropDownList>
                                </div>

                                <!-- Village -->
                                <div style="flex: 4;">
                                    <asp:Label ID="lblVillage3" runat="server"
                                        Text="Village / गाँव"
                                        CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddlVillage" runat="server" CssClass="form-control"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlVillage_SelectedIndexChanged">
                                        <asp:ListItem Text="Select Village / गाँव चुनें" Value="0" />
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <!-- Second Row -->
                            <div class="form-row mt-3">
                                <!-- Division -->
                                <div style="flex: 4;">
                                    <asp:Label ID="lblDivision3" runat="server"
                                        Text="Division / प्रभाग"
                                        CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddlDivision" runat="server" CssClass="form-control" ReadOnly="true">
                                        <asp:ListItem Text="Select Division / प्रभाग चुनें" Value="0" />
                                    </asp:DropDownList>
                                </div>

                                <!-- Range -->
                                <div style="flex: 4;">
                                    <asp:Label ID="lblRange3" runat="server"
                                        Text="Range / परिक्षेत्र"
                                        CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddlRange3" runat="server" CssClass="form-control" ReadOnly="true">
                                        <asp:ListItem Text="Select Range / परिक्षेत्र चुनें" Value="0" />
                                    </asp:DropDownList>
                                </div>

                                <!-- Incident By -->
                                <div style="flex: 4;">
                                    <asp:Label ID="lblIncidentBy" runat="server"
                                        Text="Incident Occurred By (Animal) / घटना का कारण (पशु)"
                                        CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddlIncidentBy" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="Select Animal / पशु चुनें" Value="0" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>




                    <div class="form-row mt-4">
                        <div style="flex: 3; margin-right: 10px;">
                            <asp:Label ID="lblDateIncident" runat="server" Text="Date of Incident / घटना की तारीख" AssociatedControlID="txtDateIncident" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="txtDateIncident" runat="server" CssClass="form-control" TextMode="Date" required="required"></asp:TextBox>
                        </div>
                        <div style="flex: 3;">
                            <asp:Label ID="lblTimeIncident" runat="server" Text="Time of Incident / घटना का समय" AssociatedControlID="txtTimeIncident" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="txtTimeIncident" runat="server" CssClass="form-control" TextMode="Time" required="required"></asp:TextBox>
                        </div>
                        <div style="flex: 3;" id="yes_no" runat="server" visible="false">
                            <asp:Label ID="Label16" runat="server" Text="Whether Owner was Present at the time / क्या मालिक घटना स्थल पर उपस्थित था" AssociatedControlID="ddl_yes_no" CssClass="form-label d-block mb-2"></asp:Label>
                            <asp:DropDownList ID="ddl_yes_no" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select / चयन करें" Value="" />
                                <asp:ListItem Text="Yes / हाँ" Value="1" />
                                <asp:ListItem Text="No / नहीं" Value="2" />
                            </asp:DropDownList>
                        </div>

                        <asp:Panel ID="pnlCropDetails" runat="server" CssClass="crop-details-container">
                            <div class="crop-row" style="display: flex; gap: 20px; margin-bottom: 10px;">
                                <div style="flex: 3;" id="cropdamagedname" visible="false" runat="server">
                                    <asp:Label ID="Label5" runat="server" Text="Crop Damage Name / क्षतिग्रस्त फसल का नाम" AssociatedControlID="ddl_damage_crop" CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddl_damage_crop" runat="server" CssClass="form-control crop-name">
                                        <asp:ListItem Text="Select / चयन करें" Value="" />
                                        <asp:ListItem Text="Rice (धान)" Value="Rice" />
                                        <asp:ListItem Text="Wheat (गेहूँ)" Value="Wheat" />
                                        <asp:ListItem Text="Maize (मक्का)" Value="Maize" />
                                        <asp:ListItem Text="Barley (जौ)" Value="Barley" />
                                        <asp:ListItem Text="Barnyard Millet (झंगोरा)" Value="BarnyardMillet" />
                                        <asp:ListItem Text="Finger Millet (मडुवा)" Value="FingerMillet" />
                                        <asp:ListItem Text="Kodo Millet (कोदो)" Value="Kodo" />
                                        <asp:ListItem Text="Lentil (मसूर)" Value="Lentil" />
                                        <asp:ListItem Text="Gram (चना)" Value="Gram" />
                                        <asp:ListItem Text="Kidney Beans (राजमा)" Value="KidneyBeans" />
                                        <asp:ListItem Text="Horsegram (गहत)" Value="Horsegram" />
                                        <asp:ListItem Text="Black Gram (उड़द)" Value="BlackGram" />
                                        <asp:ListItem Text="Mustard (सरसों)" Value="Mustard" />
                                        <asp:ListItem Text="Sesame (तिल)" Value="Sesame" />
                                        <asp:ListItem Text="Potato (आलू)" Value="Potato" />
                                        <asp:ListItem Text="Ginger (अदरक)" Value="Ginger" />
                                        <asp:ListItem Text="Turmeric (हल्दी)" Value="Turmeric" />
                                        <asp:ListItem Text="Sugarcane (गन्ना)" Value="Sugarcane" />
                                        <asp:ListItem Text="Apple (सेब)" Value="Apple" />
                                        <asp:ListItem Text="Litchi (लीची)" Value="Litchi" />
                                        <asp:ListItem Text="Orange (संतरा)" Value="Orange" />
                                        <asp:ListItem Text="Tomato (टमाटर)" Value="Tomato" />
                                        <asp:ListItem Text="Onion (प्याज)" Value="Onion" />
                                        <asp:ListItem Text="Green Vegetables (हरी सब्जियाँ)" Value="GreenVegetables" />
                                    </asp:DropDownList>
                                </div>

                                <div style="flex: 3;" id="croparea" visible="false" runat="server">
                                    <asp:Label ID="Label7" runat="server" Text="Area (in Ha) / क्षेत्र (हेक्टेयर में)" AssociatedControlID="txt_crop_area" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_crop_area" runat="server" CssClass="form-control crop-area"
                                        Placeholder="Enter crop area in hectares / हेक्टेयर में फसल क्षेत्र दर्ज करें"
                                        onkeypress="return allowDecimal(event)"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="revCropArea" runat="server"
                                        ControlToValidate="txt_crop_area"
                                        ValidationExpression="^\d+(\.\d+)?$"
                                        ErrorMessage="Enter valid decimal value / मान्य दशमलव मान दर्ज करें"
                                        CssClass="text-danger" Display="Dynamic" />
                                </div>
                            </div>

                            <div id="dynamicCropFields" runat="server" class="dynamic-crop-fields"></div>
                            <asp:Button ID="btnAddCrop" runat="server" Text="&#43;" Visible="false" CssClass="btn btn-primary" OnClientClick="addCropField(); return false;" />

                            <asp:HiddenField ID="hfCropNames" runat="server" />
                            <asp:HiddenField ID="hfCropAreas" runat="server" />
                        </asp:Panel>

                        <div style="flex: 3;" id="incidentplace" runat="server" visible="false">
                            <asp:Label ID="Label14" runat="server" Text="Incident Place / घटना स्थल" AssociatedControlID="ddl_incidentplace" CssClass="form-label d-block mb-2"></asp:Label>
                            <asp:DropDownList ID="ddl_incidentplace" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select Place / स्थान चुनें" Value="" />
                                <asp:ListItem Text="Agricultural Field (खेत)" Value="Field" />
                                <asp:ListItem Text="Village (गाँव)" Value="Village" />
                                <asp:ListItem Text="Forest Area (जंगल)" Value="Forest" />
                                <asp:ListItem Text="Road / Highway (सड़क)" Value="Road" />
                                <asp:ListItem Text="Water Source / River Bank (नदी किनारा)" Value="WaterSource" />
                                <asp:ListItem Text="House / Cattle Shed (घर / गोठ)" Value="House" />
                                <asp:ListItem Text="Near Protected Area (संरक्षित क्षेत्र के पास)" Value="ProtectedArea" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <h4 class="mt-2">Incident Summary / घटना का सारांश</h4>
                    <div class="form-row mt-2">
                        <div style="flex: 1;">
                            <asp:Label ID="lblIncidentLocation" runat="server" Text="Incident Location on Map / नक्शे पर घटना का स्थान" CssClass="form-label"></asp:Label>
                            <div class="d-flex" style="gap: 10px; margin-top: 5px;">
                                <asp:TextBox ID="txtLongitude" runat="server" CssClass="form-control small-input" placeholder="Longitude / देशांतर"></asp:TextBox>
                                <asp:TextBox ID="txtLatitude" runat="server" CssClass="form-control small-input" placeholder="Latitude / अक्षांश"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <!-- Left side : Incident Summary / घटना का विवरण -->
                    <div class="col-md-6">
                        <asp:Label ID="lblIncidentSummary" runat="server"
                            Text="Incident Summary / घटना का विवरण"
                            AssociatedControlID="txtIncidentSummary"
                            CssClass="form-label"></asp:Label>

                        <asp:TextBox ID="txtIncidentSummary" runat="server"
                            CssClass="form-control full-width"
                            TextMode="MultiLine" Rows="10"
                            placeholder="Describe the incident in detail / घटना का पूरा विवरण लिखें">
                        </asp:TextBox>
                    </div>

                    <!-- Right side : Map / नक्शा -->
                    <div class="col-md-6">
                        <script src="../GIS/js/jquery.min.js"></script>
                        <div class="form-group">
                            <label class="form-label">
                                NOTE / नोट : Find your location and click on the map to get 
                'Latitude' and 'Longitude' automatically.  
                अपनी स्थिति खोजें और नक्शे पर क्लिक करें ताकि अक्षांश (Latitude) और देशांतर (Longitude) अपने आप भर जाएं।
                            </label>
                            <div id="map" style="width: 100%; height: 310px; border: 1px solid #ccc;"></div>
                        </div>
                    </div>
                </div>

                <!-- Upload Document Information -->
                <div class="info-text">
                    <asp:Label ID="lblUploadInfo" runat="server" CssClass="info-text"
                        Text="Upload Documents (Document size should not be more than 2 MB) / 
              दस्तावेज़ अपलोड करें (फ़ाइल आकार 2 MB से अधिक नहीं होना चाहिए)">
                    </asp:Label>
                </div>

                <div class="form-row mt-5" id="humandocuments" runat="server" visible="false">
                    <!-- Incident Photograph -->
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Incident Photograph / घटना का फ़ोटो</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="incidentphotograph" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= incidentphotograph.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / यहाँ दस्तावेज़ अपलोड करें
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label18" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>

                    <!-- Applicant Application Form -->
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Applicant Application Form / आवेदक आवेदन पत्र</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="applicantapplication" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= applicantapplication.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / यहाँ दस्तावेज़ अपलोड करें
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="lblEndorsementStatus" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>

                    <!-- Gram Panchayat Certificate -->
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Gram Panchayat Certificate / ग्राम पंचायत प्रमाणपत्र</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="grampanchayatform" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= grampanchayatform.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / यहाँ दस्तावेज़ अपलोड करें
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label15" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>

                    <!-- Applicant Endorsement Application -->
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Applicant Endorsement Application / आवेदक समर्थन आवेदन</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="EndorsementApp" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= EndorsementApp.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / यहाँ दस्तावेज़ अपलोड करें
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label17" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                </div>


                <div class="form-row mt-5" id="cropdamagedocument" runat="server" visible="false">
                    <!-- Incident Photograph -->
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Incident Photograph / घटना का फ़ोटो</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="cropdamage_incidentphotograph" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= cropdamage_incidentphotograph.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / यहाँ दस्तावेज़ अपलोड करें
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label19" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>

                    <!-- Applicant Application Form -->
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Applicant Application Form / आवेदक आवेदन पत्र</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="cropdamage_applicantform" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= cropdamage_applicantform.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / यहाँ दस्तावेज़ अपलोड करें
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label20" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>

                    <!-- Lekhpal / Patwari Certificate -->
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Lekhpal / Patwari Certificate / लेखपाल / पटवारी प्रमाणपत्र</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="cropdamage_lekhpal" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= cropdamage_lekhpal.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / यहाँ दस्तावेज़ अपलोड करें
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label21" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>

                    <!-- Applicant Endorsement Application -->
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Applicant Endorsement Application / आवेदक समर्थन आवेदन</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="cropdamage_applicantendorsemet" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= cropdamage_applicantendorsemet.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / यहाँ दस्तावेज़ अपलोड करें
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label22" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                </div>


                <div class="form-row" style="justify-content: center; margin-top: 30px;">
                    <asp:Button
                        ID="btn_submit_victim_incident"
                        runat="server"
                        Text="Submit / जमा करें"
                        CssClass="submit-btn"
                        OnClick="btn_submit_victim_incident_Click" />
                </div>
            </div>
        </div>
    </div>


    <div id="previewModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); justify-content: center; align-items: center;">
        <div style="background: white; padding: 20px; border-radius: 8px; max-width: 80%; max-height: 80%; overflow: auto; position: relative;">
            <span id="closeModal" style="position: absolute; top: 10px; right: 10px; cursor: pointer; font-size: 20px;">&times;</span>
            <img id="previewImage" style="display: none; max-width: 100%; max-height: 100%;" />
            <iframe id="previewPDF" style="display: none; width: 100%; height: 500px;"></iframe>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const fileUploads = [
                '<%= incidentphotograph.ClientID %>',
                '<%= applicantapplication.ClientID %>',
                '<%= grampanchayatform.ClientID %>',
                '<%= EndorsementApp.ClientID %>',
                '<%= cropdamage_incidentphotograph.ClientID %>',
                '<%= cropdamage_applicantform.ClientID %>',
                '<%= cropdamage_lekhpal.ClientID %>',
                '<%= cropdamage_applicantendorsemet.ClientID %>'
            ];

           <%-- const statusLabels = {
                '<%= incidentphotograph.ClientID %>': '<%= Label18.ClientID %>',
                '<%= applicantapplication.ClientID %>': '<%= lblEndorsementStatus.ClientID %>',
                '<%= grampanchayatform.ClientID %>': '<%= Label15.ClientID %>',
                '<%= EndorsementApp.ClientID %>': '<%= Label17.ClientID %>',
                '<%= cropdamage_incidentphotograph.ClientID %>': '<%= Label19.ClientID %>',
                '<%= cropdamage_applicantform.ClientID %>': '<%= Label20.ClientID %>',
                '<%= cropdamage_lekhpal.ClientID %>': '<%= Label21.ClientID %>',
                '<%= cropdamage_applicantendorsemet.ClientID %>': '<%= Label22.ClientID %>'
            };--%>

            //fileUploads.forEach(uploadId => {
            //    const upload = document.getElementById(uploadId);
            //    if (!upload) return; // Skip if element doesn't exist

            //    const wrapper = upload.closest('.file-upload-wrapper');
            //    if (!wrapper) return; // Skip if wrapper doesn't exist

            //    const statusLabelId = statusLabels[uploadId];
            //    const statusLabel = statusLabelId ? document.getElementById(statusLabelId) : null;

            //    let actionsDiv = wrapper.querySelector('.file-actions');
            //    if (!actionsDiv) {
            //        actionsDiv = document.createElement('div');
            //        actionsDiv.classList.add('file-actions');
            //        actionsDiv.style.display = 'none';
            //        actionsDiv.style.marginTop = '10px';
            //        actionsDiv.style.gap = '10px';
            //        actionsDiv.innerHTML = `
            //            <button type="button" class="btn-preview"><i class="fas fa-eye"></i> Preview</button>
            //            <button type="button" class="btn-delete"><i class="fas fa-trash"></i> Delete</button>
            //        `;
            //        wrapper.appendChild(actionsDiv);
            //    }

            //    const previewBtn = actionsDiv.querySelector('.btn-preview');
            //    const deleteBtn = actionsDiv.querySelector('.btn-delete');

            //    upload.addEventListener('change', function (e) {
            //        const file = e.target.files[0];
            //        if (file) handleFile(file, upload, statusLabel, wrapper, actionsDiv, previewBtn, deleteBtn);
            //    });

            //    wrapper.addEventListener('dragover', e => { e.preventDefault(); wrapper.classList.add('dragover'); });
            //    wrapper.addEventListener('dragleave', e => { e.preventDefault(); wrapper.classList.remove('dragover'); });
            //    wrapper.addEventListener('drop', e => {
            //        e.preventDefault();
            //        wrapper.classList.remove('dragover');
            //        const files = e.dataTransfer.files;
            //        if (files.length > 0) {
            //            upload.files = files;
            //            handleFile(files[0], upload, statusLabel, wrapper, actionsDiv, previewBtn, deleteBtn);
            //        }
            //    });
            //});

            function handleFile(file, upload, statusLabel, wrapper, actionsDiv, previewBtn, deleteBtn) {
                const maxSize = 2 * 1024 * 1024; // 2MB
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf'];

                if (file.size > maxSize || !allowedTypes.includes(file.type)) {
                    showFileStatus(statusLabel, !allowedTypes.includes(file.type) ?
                        'Only JPG, PNG, and PDF files are allowed' : 'File size exceeds 2MB limit', 'error');
                    upload.value = '';
                    actionsDiv.style.display = 'none';
                    return;
                }

                showFileStatus(statusLabel, `File uploaded: ${file.name} (${(file.size / 1024).toFixed(1)} KB)`, 'success');
                actionsDiv.style.display = 'flex';

                let existingPreview = wrapper.querySelector('.upload-success');
                if (!existingPreview) {
                    const previewDiv = document.createElement('div');
                    previewDiv.classList.add('upload-success');
                    previewDiv.innerHTML = `
                        <i class="fas fa-check-circle text-success"></i>
                        <div>
                            <strong>${file.name}</strong><br>
                            <small>${(file.size / 1024).toFixed(1)} KB - Ready</small>
                        </div>
                    `;
                    wrapper.appendChild(previewDiv);
                } else {
                    existingPreview.querySelector('strong').textContent = file.name;
                    existingPreview.querySelector('small').textContent = `${(file.size / 1024).toFixed(1)} KB - Ready`;
                }

                previewBtn.onclick = () => window.open(URL.createObjectURL(file), '_blank');
                deleteBtn.onclick = () => {
                    upload.value = '';
                    actionsDiv.style.display = 'none';
                    if (statusLabel) statusLabel.style.display = 'none';
                    const existingPreview = wrapper.querySelector('.upload-success');
                    if (existingPreview) existingPreview.remove();
                };
            }

            function showFileStatus(label, message, type) {
                if (label) {
                    label.textContent = message;
                    label.className = `file-status ${type}`;
                    label.style.display = 'block';
                }
            }
        });
    </script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>

    <script>

        var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";
        var geoserver_ip_ows = "https://ukforestgis.in/geoserver/sbl/ows";
        var format = 'image/png';
        const esriSatellite = new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                attributions: 'Tiles © Esri'
            })
        });

        const esriLabels = new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
                attributions: 'Labels © Esri'
            })
        });

        const map = new ol.Map({
            target: 'map',
            layers: [esriSatellite, esriLabels],
            view: new ol.View({
                center: ol.proj.fromLonLat([79.2593, 30.4068]), // Coordinates
                zoom: 7,
                maxZoom: 18
            })

        });
        var range_layer;
        function getrange(val) {
            map.removeLayer(range_layer);
            map.removeOverlay(range_layer);

            var kid = val.value;
            range_layer = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        layers: 'uk_sfd:tbl_range_master',
                        CQL_FILTER: 'id=' + "\'" + kid + "\'",
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });

            map.addOverlay(range_layer);
            map.addLayer(range_layer);
        }

        var clickedCoords = null;
        var markerSource = new ol.source.Vector();
        var markerLayer = new ol.layer.Vector({
            source: markerSource
        });
        map.addLayer(markerLayer);
        map.on('click', function (evt) {
            markerSource.clear();
            var coordinate = ol.proj.toLonLat(evt.coordinate);
            var lon = coordinate[0].toFixed(6);
            var lat = coordinate[1].toFixed(6);
            document.getElementById('<%= txtLatitude.ClientID %>').value = lat;
            document.getElementById('<%= txtLongitude.ClientID %>').value = lon;
            var marker = new ol.Feature({
                geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(lon), parseFloat(lat)]))
            });

            marker.setStyle(new ol.style.Style({
                image: new ol.style.Icon({
                    anchor: [0.5, 1],
                    src: '../GIS/img/location.png',
                    scale: 0.03
                })
            }));

            markerSource.addFeature(marker);
        });

    </script>

    <script type="text/javascript">
        var map;
        var markerSource;
        var markerLayer;

        function initializeMap() {
            var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";

            const esriSatellite = new ol.layer.Tile({
                source: new ol.source.XYZ({
                    url: 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                    attributions: 'Tiles © Esri'
                })
            });

            const esriLabels = new ol.layer.Tile({
                source: new ol.source.XYZ({
                    url: 'https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
                    attributions: 'Labels © Esri'
                })
            });

            map = new ol.Map({
                target: 'map',
                layers: [esriSatellite, esriLabels],
                view: new ol.View({
                    center: ol.proj.fromLonLat([79.2593, 30.4068]),
                    zoom: 7,
                    maxZoom: 18
                })
            });

            markerSource = new ol.source.Vector();
            markerLayer = new ol.layer.Vector({
                source: markerSource
            });
            map.addLayer(markerLayer);

            map.on('click', function (evt) {
                markerSource.clear();
                var coordinate = ol.proj.toLonLat(evt.coordinate);
                var lon = coordinate[0].toFixed(6);
                var lat = coordinate[1].toFixed(6);

                document.getElementById('<%= txtLatitude.ClientID %>').value = lat;
                document.getElementById('<%= txtLongitude.ClientID %>').value = lon;

                var marker = new ol.Feature({
                    geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(lon), parseFloat(lat)]))
                });

                marker.setStyle(new ol.style.Style({
                    image: new ol.style.Icon({
                        anchor: [0.5, 1],
                        src: '../GIS/img/location.png',
                        scale: 0.03
                    })
                }));

                markerSource.addFeature(marker);
            });
        }

        document.addEventListener("DOMContentLoaded", function () {
            initializeMap();
        });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            initializeMap();
        });
    </script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />


    <script type="text/javascript">
        var cropFieldCounter = 0;
        document.addEventListener('change', function (e) {
            if (e.target.classList.contains('crop-name') &&
                document.getElementById('<%= hfCropNames.ClientID %>')) {
                updateHiddenFields();
            }
        });

        document.addEventListener('input', function (e) {
            if (e.target.classList.contains('crop-area') &&
                document.getElementById('<%= hfCropNames.ClientID %>')) {
                updateHiddenFields();
            }
        });

        function addCropField() {
            if (!document.getElementById('<%= dynamicCropFields.ClientID %>')) return; // Exit if panel not visible
            cropFieldCounter++;
            var container = document.getElementById('<%= dynamicCropFields.ClientID %>');
            var newRow = document.createElement('div');
            newRow.className = 'crop-row';
            newRow.style.display = 'flex';
            newRow.style.gap = '20px';
            newRow.style.marginBottom = '10px';
            newRow.innerHTML = `
            <div style="flex: 3;">
              
                <select class="form-control crop-name" id="ddl_crop_${cropFieldCounter}">
                    <option value="">Select</option>
                    <option value="Rice">Rice (धान)</option>
                    <option value="Wheat">Wheat (गेहूँ)</option>
                    <option value="Maize">Maize (मक्का)</option>
                    <option value="Barley">Barley (जौ)</option>
                    <option value="BarnyardMillet">Barnyard Millet (झंगोरा)</option>
                    <option value="FingerMillet">Finger Millet (मडुवा)</option>
                    <option value="Kodo">Kodo Millet (कोदो)</option>
                    <option value="Lentil">Lentil (मसूर)</option>
                    <option value="Gram">Gram (चना)</option>
                    <option value="KidneyBeans">Kidney Beans (राजमा)</option>
                    <option value="Horsegram">Horsegram (गहत)</option>
                    <option value="BlackGram">Black Gram (उड़द)</option>
                    <option value="Mustard">Mustard (सरसों)</option>
                    <option value="Sesame">Sesame (तिल)</option>
                    <option value="Potato">Potato (आलू)</option>
                    <option value="Ginger">Ginger (अदरक)</option>
                    <option value="Turmeric">Turmeric (हल्दी)</option>
                    <option value="Sugarcane">Sugarcane (गन्ना)</option>
                    <option value="Apple">Apple (सेब)</option>
                    <option value="Litchi">Litchi (लीची)</option>
                    <option value="Orange">Orange (संतरा)</option>
                    <option value="Tomato">Tomato (टमाटर)</option>
                    <option value="Onion">Onion (प्याज)</option>
                    <option value="GreenVegetables">Green Vegetables (हरी सब्जियाँ)</option>
                </select>
            </div>
            <div style="flex: 3;">
              
                <input type="text" class="form-control crop-area" id="txt_area_${cropFieldCounter}" placeholder="Enter crop area in hectares" />
            </div>
            <button type="button" class="btn btn-danger" onclick="removeCropField(this)">&#8211;</button>

        `;
            container.appendChild(newRow);
            updateHiddenFields();
        }

        function removeCropField(button) {
            button.parentElement.remove();
            updateHiddenFields();
        }

        function updateHiddenFields() {
            var hfNames = document.getElementById('<%= hfCropNames.ClientID %>');
            var hfAreas = document.getElementById('<%= hfCropAreas.ClientID %>');
            if (!hfNames || !hfAreas) return; // Exit if hidden fields not present (panel not visible)

            var cropNames = [];
            var cropAreas = [];
            var cropSelects = document.getElementsByClassName('crop-name');
            var areaInputs = document.getElementsByClassName('crop-area');

            for (var i = 0; i < cropSelects.length; i++) {
                if (cropSelects[i].value) {
                    cropNames.push(cropSelects[i].value);
                }
            }
            for (var i = 0; i < areaInputs.length; i++) {
                if (areaInputs[i].value) {
                    cropAreas.push(areaInputs[i].value);
                }
            }

            hfNames.value = cropNames.join(',');
            hfAreas.value = cropAreas.join(',');
        }

        document.addEventListener('DOMContentLoaded', function () {
            if (document.getElementById('<%= hfCropNames.ClientID %>')) {
                updateHiddenFields();
            }
        });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function () {
                if (document.getElementById('<%= hfCropNames.ClientID %>')) {
                    updateHiddenFields();
                }
            });
        }
    </script>

    <script type="text/javascript">
        var cattleFieldCounter = 0;

        document.addEventListener('change', function (e) {
            if ((e.target.classList.contains('cattle-species') || e.target.classList.contains('cattle-age')) &&
                document.getElementById('<%= hfCattleSpecies.ClientID %>')) {
                updateCattleHiddenFields();
            }
        });

        function addCattleField() {
            if (!document.getElementById('<%= dynamicCattleFields.ClientID %>')) return; // Exit if panel not visible
            cattleFieldCounter++;
            var container = document.getElementById('<%= dynamicCattleFields.ClientID %>');
            var newRow = document.createElement('div');
            newRow.className = 'cattle-row';
            newRow.style.display = 'flex';
            newRow.style.gap = '20px';
            newRow.style.marginBottom = '10px';
            newRow.style.alignItems = 'flex-end';
            newRow.innerHTML = `
            <div style="flex: 4;">
               
                <select class="form-control cattle-species" id="ddl_species_${cattleFieldCounter}">
                    <option value="">Select Species</option>
                    <option value="Cattle">Cattle (गाय/बैल)</option>
                    <option value="Buffalo">Buffalo (भैंस)</option>
                    <option value="Goat">Goat (बकरी)</option>
                    <option value="Sheep">Sheep (भेड़)</option>
                    <option value="Horse">Horse (घोड़ा)</option>
                    <option value="Mule">Mule (खच्चर)</option>
                    <option value="Donkey">Donkey (गधा)</option>
                    <option value="Pig">Pig (सुअर)</option>
                    <option value="Poultry">Poultry (मुर्गी)</option>
                </select>
            </div>
            <div style="flex: 4;">
               
                <select class="form-control cattle-age" id="ddl_age_${cattleFieldCounter}">
                    <option value="">Select Age (in Years)</option>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                    <option value="16">16</option>
                    <option value="17">17</option>
                    <option value="18">18</option>
                    <option value="19">19</option>
                    <option value="20">20</option>
                </select>
            </div>
           <button type="button" class="btn btn-danger" onclick="removeCattleField(this)">&#8722;</button>

        `;
            container.appendChild(newRow);
            updateCattleHiddenFields();
        }

        function removeCattleField(button) {
            button.parentElement.remove();
            updateCattleHiddenFields();
        }

        function updateCattleHiddenFields() {
            var hfSpecies = document.getElementById('<%= hfCattleSpecies.ClientID %>');
            var hfAges = document.getElementById('<%= hfCattleAges.ClientID %>');
            if (!hfSpecies || !hfAges) return; // Exit if hidden fields not present (panel not visible)

            var cattleSpecies = [];
            var cattleAges = [];
            var speciesSelects = document.getElementsByClassName('cattle-species');
            var ageSelects = document.getElementsByClassName('cattle-age');

            for (var i = 0; i < speciesSelects.length; i++) {
                if (speciesSelects[i].value) {
                    cattleSpecies.push(speciesSelects[i].value);
                }
            }
            for (var i = 0; i < ageSelects.length; i++) {
                if (ageSelects[i].value) {
                    cattleAges.push(ageSelects[i].value);
                }
            }

            hfSpecies.value = cattleSpecies.join(',');
            hfAges.value = cattleAges.join(',');
        }

        // Initial update after page load - only if panel exists
        document.addEventListener('DOMContentLoaded', function () {
            if (document.getElementById('<%= hfCattleSpecies.ClientID %>')) {
                updateCattleHiddenFields();
            }
        });

        // Handle UpdatePanel postbacks
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function () {
                if (document.getElementById('<%= hfCattleSpecies.ClientID %>')) {
                    updateCattleHiddenFields();
                }
            });
        }
    </script>

    <script type="text/javascript">
        function allowOnlyNumbers(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode < 48 || charCode > 57) {
                return false; // block non-numeric
            }
            return true;
        }
    </script>

    <script type="text/javascript">
        function allowOnlyNumbers(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false; // block non-numeric
            }
            return true;
        }

        function allowDecimal(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;

            // allow digits and one dot (.)
            if (charCode != 46 && (charCode < 48 || charCode > 57)) {
                return false;
            }

            // prevent multiple dots
            if (charCode == 46 && evt.target.value.indexOf('.') !== -1) {
                return false;
            }

            return true;
        }
    </script>

    <script type="text/javascript">
        window.onload = function () {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("<%= txtDateIncident.ClientID %>").setAttribute("max", today);
        };
    </script>


    <script>
        document.addEventListener("DOMContentLoaded", function () {

            document.querySelectorAll(".file-upload-wrapper").forEach(function (wrapper) {
                var fileInput = wrapper.querySelector("input[type='file']");
                var fileInfo = wrapper.querySelector(".file-info");
                var removeBtn = wrapper.querySelector(".remove-file-btn");

                // create remove button if not exists
                if (!removeBtn) {
                    removeBtn = document.createElement("span");
                    removeBtn.classList.add("remove-file-btn");
                    removeBtn.innerHTML = "×";
                    wrapper.appendChild(removeBtn);
                }

                // hide remove button initially
                removeBtn.style.display = "none";

                // handle file selection
                fileInput.addEventListener("change", function () {
                    if (fileInput.files.length > 0) {
                        removeBtn.style.display = "block";
                        if (fileInfo) {
                            fileInfo.textContent = `${fileInput.files[0].name} (${Math.round(fileInput.files[0].size / 1024)} KB)`;
                        }
                    } else {
                        removeBtn.style.display = "none";
                        if (fileInfo) fileInfo.textContent = "Max size: 2MB | Formats: JPG, PNG, PDF";
                    }
                });

                // handle remove click
                removeBtn.addEventListener("click", function () {
                    // clear input
                    fileInput.value = "";
                    // reset info
                    if (fileInfo) fileInfo.textContent = "Max size: 2MB | Formats: JPG, PNG, PDF";
                    // hide remove btn
                    removeBtn.style.display = "none";
                });
            });
        });
    </script>


</asp:Content>

