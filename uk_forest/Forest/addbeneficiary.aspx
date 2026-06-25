<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="addbeneficiary.aspx.cs" Inherits="uk_forest.Forest.addbeneficiary" %>

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
        @media (max-width:1280px){
            .btn-edit{
                margin-bottom:5px;
            }
        }

        @media (min-width: 1200px) {
            .container {
                max-width: 1580px;
            }
        }

        .tab-content-wrapper {
            margin-top: 12px;
            background: #fff;
            border-radius: 5px;
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
            background: #e8f5e9;
            border-radius: 6px;
            margin-bottom: 35px !important;
            width: 100%;
        }

        label {
            font-weight: 500;
            display: block;
            margin-bottom: 3px;
            float: left;
            font-size: 16px;
            color: #222;
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
            background-color: #12450b;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            margin-bottom: 25px;
            transition: background-color 0.3s ease, opacity 0.3s ease;
        }

        .submitNowBtn {
            border-bottom: 1px solid #dddddd9e;
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

        .btn-edit {
            background-color: #12450b;
            color: white;
            border: none;
            padding: 5px 10px;
            margin-right: 5px;
            border-radius: 3px;
            cursor: pointer;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="step-flow">

        <div class="step-item">
            <div class="circle">①</div>
            <div class="label">Applicant Details / आवेदक का विवरण</div>
        </div>
        <div class="arrow">→</div>

        <div class="step-item active">
            <div class="circle">②</div>
            <div class="label">Beneficiary Details / लाभार्थी विवरण</div>
        </div>
        <div class="arrow">→</div>

        <div class="step-item">
            <div class="circle">③</div>
            <div class="label">Victim Incident Details / घटना का विवरण</div>
        </div>
        <div class="arrow">→</div>

        <div class="step-item">
            <div class="circle">④</div>
            <div class="label">Victim Incident List / पीड़ित घटना सूची</div>
        </div>
    </div>

    <div class="grid_item text-center">
        <div class="container divtab">
            <div class="tab-content-wrapper">
                <div class="form-container">
                    <h3 class="font-weight-bold titleHeading">Add Beneficiary Details / लाभार्थी विवरण जोड़ें</h3>

                    <!-- First Row: Bank Details -->
                    <div class="form-row my-4">


                        <%--    <div style="flex: 1">
                            <asp:Label ID="lblBankName" runat="server" Text="Bank Name" AssociatedControlID="txtBankName"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvBankName" runat="server"
                                    ControlToValidate="txtBankName"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txtBankName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>--%>


                        <div style="flex: 1">
                            <asp:Label ID="lblBankName" runat="server" Text="Bank Name / बैंक का नाम" AssociatedControlID="ddlBanks"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvBankName" runat="server"
                                    ControlToValidate="ddlBanks"
                                    InitialValue=""
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:DropDownList ID="ddlBanks" runat="server" CssClass="form-control">
                                <asp:ListItem Value="0">Select Bank</asp:ListItem>

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



                        <div style="flex: 1">
                            <asp:Label ID="lblFullName" runat="server" Text="Bank Account Holder Name / बैंक खाता धारक का नाम" AssociatedControlID="txtFullName"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                                    ControlToValidate="txtFullName"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"
                                onkeyup="toTitleCase(this)" onkeypress="return onlyAlphabets(event)">
                            </asp:TextBox>

                        </div>

                        <div style="flex: 1">
                            <asp:Label ID="lblAccountNumber" runat="server" Text="बैंक खाता संख्या" AssociatedControlID="txtAccountNumber"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvAccountNumber" runat="server"
                                    ControlToValidate="txtAccountNumber"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txtAccountNumber" runat="server" CssClass="form-control" MaxLength="18" onkeypress="return isNumberKey(event)"></asp:TextBox>
                        </div>


                    </div>

                    <!-- Second Row: IFSC and PAN -->
                    <div class="form-row my-4">
                        <div style="flex: 1">
                            <asp:Label ID="lblIFSC" runat="server" Text="IFSC Code / आईएफएससी कोड" AssociatedControlID="txtIFSC"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvIFSC" runat="server"
                                    ControlToValidate="txtIFSC"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txtIFSC" runat="server" CssClass="form-control"
                                onkeypress="return isAlphaNumeric(event)"
                                onkeyup="toUpperCaseText(this)">
                            </asp:TextBox>
                        </div>

                        <div style="flex: 1">
                            <asp:Label ID="lblPanNumber" runat="server" Text="PAN No. (Optional) / पैन नंबर (वैकल्पिक)" AssociatedControlID="txtPanNumber"></asp:Label>

                            <!-- Optional, so no validator needed -->
                            <asp:TextBox ID="txtPanNumber" runat="server" CssClass="form-control"
                                MaxLength="10" onkeyup="toUpperCaseText(this)"
                                onkeypress="return validatePAN(event, this)">
                            </asp:TextBox>
                        </div>
                    </div>

                    <div style="display: flex; align-items: center; gap: 6px;">
                        <asp:CheckBox ID="chkaadhar" runat="server" OnCheckedChanged="chkaadhar_CheckedChanged" AutoPostBack="true"/>
                        <p style="margin: 0;">Are the beneficiary and the applicant the same?</p>
                    </div>




                    <!-- Third Row: Aadhar -->
                    <div class="form-row my-4">
                        <div style="flex: 2">
                            <asp:Label ID="lblAadhar" runat="server" Text="Aadhaar No. / आधार नंबर" AssociatedControlID="txtAadhar"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvAadhar" runat="server"
                                    ControlToValidate="txtAadhar"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txtAadhar" runat="server" CssClass="form-control" MaxLength="12" onkeypress="return isNumberKey(event)"></asp:TextBox>
                        </div>

                        <div style="flex: 2; position: relative;">
                            <asp:Label ID="lblAadharFile" runat="server" Text="Upload Aadhaar File / आधार फ़ाइल अपलोड करें" AssociatedControlID="filebeneficiary"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvAadharFile" runat="server"
                                    ControlToValidate="filebeneficiary"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:FileUpload
                                ID="filebeneficiary"
                                runat="server"
                                CssClass="form-control"
                                accept=".jpg,.jpeg,.png,.pdf" />

                            <div class="mt-2 d-flex align-items-center gap-3">
                                <asp:LinkButton
                                    ID="btnPreview"
                                    runat="server"
                                    Text="Preview"
                                    OnClientClick="return false;"
                                    CssClass="btn btn-link mt-2 d-flex align-items-center gap-1"
                                    Style="display: none;">
            <i class="bi bi-eye"></i> Preview / पूर्व दर्शन
                                </asp:LinkButton>

                                <asp:LinkButton
                                    ID="LinkButton1" Visible="false"
                                    runat="server"
                                    Text="Preview"
                                    OnClientClick="return false;"
                                    CssClass="btn btn-link mt-2 d-flex align-items-center gap-1"
                                    Style="display: none;">
            <i class="bi bi-eye"></i> View Aadhaar 
                                </asp:LinkButton>

                                <asp:Label
                                    ID="lblFileSizeWarning"
                                    runat="server"
                                    Text="File size exceeds 10MB! Please upload a smaller file."
                                    CssClass="text-danger fw-bold"
                                    Style="display: none;">
                                </asp:Label>
                            </div>
                        </div>
                    </div>


                    <div class="submitNowBtn">
                        <asp:Button
                            runat="server"
                            ID="btn_submit_beneficiary_details"
                            OnClick="btn_submit_beneficiary_details_Click"
                            CssClass="submit-btn"
                            Text="Submit"
                            ValidationGroup="a"
                            title="Click to submit beneficiary details" />
                    </div>

                    <asp:HiddenField ID="hfId" runat="server" />
                    <asp:HiddenField ID="hfBeneficiaryId" runat="server" />

                </div>



                <div class="grid-container">
                    <h4 class="font-weight-bold titleHeading mb-4">Beneficiary Details / लाभार्थी विवरण</h4>
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CssClass="table table-striped"
                        OnRowCommand="GridView1_RowCommand" OnRowDeleting="GridView1_RowDeleting"
                        DataKeyNames="beneficiaryId">
                        <Columns>

                            <asp:TemplateField HeaderText="S.No. / क्र.सं.">
                                <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Bank Name / बैंक का नाम">
                                <ItemTemplate>
                                    <%# Eval("bankName") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Account No. / खाता नंबर">
                                <ItemTemplate>
                                    <%# Eval("accNumber") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="IFSC Code / आईएफएससी कोड">
                                <ItemTemplate>
                                    <%# Eval("ifscCode") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Account Holder Name / खाता धारक का नाम">
                                <ItemTemplate>
                                    <%# Eval("accHolderName") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Aadhaar No. / आधार नंबर">
                                <ItemTemplate>
                                    <%# Eval("aadharNo") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="PAN No. / पैन नंबर" Visible="false">
                                <ItemTemplate>
                                    <%# Eval("panNo") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Aadhaar Doc. / आधार दस्तावेज़">
                                <ItemTemplate>
                                    <asp:LinkButton
                                        ID="lnkBankDoc"
                                        runat="server"
                                        Text="View Aadhaar"
                                        Style="font-weight: bold; color: #007BFF; background-color: #F0F8FF; padding: 3px 6px; border-radius: 4px;"
                                        title="Click to view bank document"
                                        OnClientClick='<%# "showDocumentPopup(\"" + Eval("BeneficiaryImage") + "\", \"Bank Document\"); return false;" %>'>
                                    </asp:LinkButton>


                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action / कार्रवाई">
                                <ItemTemplate>
                                    <asp:Button
                                        ID="btnEdit"
                                        runat="server"
                                        Text="Edit"
                                        CommandName="EditBeneficiary"
                                        CommandArgument='<%# Eval("beneficiaryId") %>'
                                        CssClass="btn-edit"
                                        title="Click to edit this beneficiary" />

                                    <asp:Button
                                        ID="btnDelete"
                                        runat="server"
                                        Text="Delete"
                                        CommandName="Delete"
                                        CssClass="btn-delete"
                                        OnClientClick="return confirm('Are you sure you want to delete this beneficiary?');"
                                        title="Click to delete this beneficiary" />

                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- Preview Modal -->
    <div id="previewModal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 15px; border-radius: 10px; box-shadow: 0 5px 20px rgba(0,0,0,0.4); z-index: 1000; width: 400px; height: 400px; text-align: center;">
        <span id="closeModal"
            style="cursor: pointer; position: absolute; top: 8px; right: 12px; font-weight: bold; font-size: 20px;">&times;</span>
        <img id="previewImage" src="#" style="width: 100%; height: 100%; object-fit: contain; display: none; border-radius: 6px;" />
        <iframe id="previewPDF" style="width: 100%; height: 100%; display: none; border: none; border-radius: 6px;"></iframe>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script type="text/javascript">
        function showDocumentPopup(fileUrl, title) {
            console.log("File URL:", fileUrl);

            if (!fileUrl || fileUrl === '#' || fileUrl.trim() === '') {
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

            // Normalize backslashes
            fileUrl = fileUrl.replace(/\\/g, "/");

            const isImage = /\.(jpg|jpeg|png|gif)$/i.test(fileUrl);
            const isPdf = /\.pdf$/i.test(fileUrl);

            if (isImage) {
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
                window.open(fileUrl, '_blank');
            }
        }
    </script>


    <script type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode < 48 || charCode > 57) {
                return false; // Only numbers allowed
            }
            return true;
        }
    </script>

    <script type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            // allow only 0–9
            if (charCode < 48 || charCode > 57) {
                return false;
            }
            return true;
        }
    </script>




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
</asp:Content>
