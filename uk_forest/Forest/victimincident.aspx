<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="victimincident.aspx.cs" Inherits="uk_forest.Forest.victimincident" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            flatpickr("#<%= txtTimeIncident.ClientID %>", {
                enableTime: true,
                noCalendar: true,
                dateFormat: "h:i K", // 12-hour format with AM/PM
                time_24hr: false
            });
        });
    </script>


    <%--<style>
.file-upload-wrapper {
    position: relative;
    display: inline-block;
}
.file-upload-wrapper input[type="file"] {
    opacity: 0; /* hide default file input */
    position: absolute;
    width: 100%;
    height: 100%;
    cursor: pointer;
}
.file-upload-label {
    display: inline-block;
    padding: 8px 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
    background: #f1f1f1;
    cursor: pointer;
}
.file-info {
    display: block;
    margin-top: 5px;
    font-size: 12px;
}

.remove-file-btn {
    position: absolute;
    right: 10px;
    top: 5px;
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
</style>--%>


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
        .uploadFileContt .info-text {
            font-size: 18px;
            color: #000000;
            margin-top: 42px;
            white-space: normal; /* allow wrapping */
            word-wrap: break-word; /* long words wrap */
            display: block; /* ensures multiline behaviour */
        }
        .custom-ddl{
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background: url("data:image/svg+xml;utf8,<svg fill='gray' height='18' viewBox='0 0 24 24' width='18' xmlns='http://www.w3.org/2000/svg'><path d='M7 10l5 5 5-5z'/></svg>") no-repeat right 12px center;
            background-color: #fff;
            padding-right: 35px !important;
            cursor: pointer;
            border: 1px solid #ced4da;
            height: 38px;
            border-radius:5px;
        }
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
        .upload-label {
            font-weight: 600;
            color: #23a510;
            margin-bottom: 12px;
            display: block;
            font-size: 0.95rem;
            height: 75px;
        }

        .file-upload-wrapper {
            position: relative;
            top: 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            border: 2px dashed #adb5bd;
            border-radius: 8px;
            background: #f8f9fa;
            transition: all 0.3s ease;
            cursor: pointer;
            width: 100%;
            max-width: 700px;
            height: 180px;
            padding-left: 10px;
            padding-right: 10px;
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
            height:320px;
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
            background: #e8f5e9;
            border-left: 1px solid gray;
            border-radius: 6px;
        }
        label {
            font-weight: 500;
            display: block;
            margin-bottom: 3px;
            float: left;
            font-size:16px;
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
            /*            position: absolute;*/
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

            .ncidentContentAssets {
                margin-top: 35px;
            }



            h4#ContentPlaceHolder1_headingtext {
                font-size: 24px;
                color: #4caf50 !important;
                font-weight: 600;
            }
            #ContentPlaceHolder1_div_radiobutton h4.mt-2.text-success.text-center {
                font-size: 24px;
                color: #4caf50 !important;
                font-weight: 600;
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

        <div class="step-item">
            <div class="circle">②</div>
            <div class="label">Beneficiary Details / लाभार्थी विवरण</div>
        </div>
        <div class="arrow">→</div>

        <div class="step-item active">
            <div class="circle">③</div>
            <div class="label">Victim Incident Details / घटना का विवरण</div>
        </div>
        <div class="arrow">→</div>

        <div class="step-item">
            <div class="circle">④</div>
            <div class="label">Victim Incident List / पीड़ित घटना सूची</div>
        </div>
    </div>


    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <div class="grid_item">
        <div class="container divtab">
            <div class="tab-content-wrapper">
                <div class="form-container">
                    <div class="position-relative mb-3" style="display: flex; align-items: center; justify-content: center;">
                        <h2 class="font-weight-bold titleHeading mb-0 text-center" style="flex: 1;">Victim Incident Details / घटना का विवरण</h2>
                        <span class="applicant-id font-weight-bold form-title">Applicant ID / आवेदक आईडी:
                               <asp:Label ID="Label6" runat="server"></asp:Label>
                        </span>
                    </div>
                    <%--<asp:UpdatePanel ID="up1" runat="server">
                        <ContentTemplate>--%>
                    <fieldset class="radio-group" style="border:1px solid #b1c7ad; padding: 15px; border-radius: 8px; margin-top: 30px;">
                        <legend style="font-weight: 500; float: inherit; padding:2px 10px; color: #fff; border-radius: 5px; background-color: #13460c; margin-bottom: 10px; text-align: center; width: auto; margin-left: auto; margin-right: auto; font-size: 18px;">
                            <asp:Label ID="lblClaimType" runat="server" Text="Claim Category / दावा श्रेणी"></asp:Label>
                        </legend>
                        <div class="d-flex flex-wrap justify-content-center" style="gap: 20px;">
                            <asp:RadioButtonList ID="rblClaimType" runat="server" RepeatDirection="Horizontal" CssClass="claim-radio-list" RepeatLayout="Flow" OnSelectedIndexChanged="rblClaimType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Text="Human Death / Injury / मानव मृत्यु / घायल" Value="Human" />
                                <asp:ListItem Text="Crop Damage / फसल क्षति" Value="Crop" />
                                <asp:ListItem Text="Cattle Kill / मवेशी मारना" Value="Cattle" />
                                <asp:ListItem Text="Property Damage / संपत्ति का नुकसान" Value="House" />
                            </asp:RadioButtonList>
                        </div>
                    </fieldset>
                    <%-- </ContentTemplate>
                    </asp:UpdatePanel>--%>



                    <h4 class="mt-2 text-success text-center" runat="server" id="headingtext">Victim Personal Details / पीड़ित का व्यक्तिगत विवरण</h4>
                    <div id="div_image" runat="server" visible="false">
                        <img src="../images/form-div.png" style="opacity: 0.4; width:100%;" />
                    </div>
                    <div id="div_radiobutton" runat="server" visible="false">
                        <div class="form-row">
                            <div style="flex: 4; margin-right: 10px;" id="div_radiobutton1" runat="server" visible="false">
                                <asp:Label ID="Label2" runat="server" Text="Full Name / पूरा नाम" AssociatedControlID="txtFullName" CssClass="form-label"></asp:Label>
                                <asp:TextBox
                                    ID="txtFullName"
                                    runat="server"
                                    CssClass="form-control"
                                    Placeholder="Enter Full Name"
                                    oninput="formatAndValidateName(this)">
                                </asp:TextBox>
                            </div>
                            <div style="flex: 4;" id="div_radiobutton2" runat="server" visible="false">
                                <asp:Label ID="lblFatherName" runat="server" Text="Father Name / पिता का नाम" AssociatedControlID="txtFatherName" CssClass="form-label"></asp:Label>
                                <asp:TextBox
                                    ID="txtFatherName"
                                    runat="server"
                                    CssClass="form-control"
                                    Placeholder="Enter Father Name"
                                    oninput="formatAndValidateName(this)">
                                </asp:TextBox>
                            </div>
                            <div style="flex: 4;" id="div_radiobutton3" runat="server" visible="false">
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

                        <div class="my-2 mb-2" style="display: flex; align-items: center; gap: 6px;" runat="server" id="chkbox" visible="false">
                            <asp:CheckBox ID="chkaadhar" runat="server" OnCheckedChanged="chkaadhar_CheckedChanged" AutoPostBack="true" />
                            <p style="margin: 0; font-weight: bold;">Are the victim and the applicant the same?</p>
                        </div>

                        <div class="form-row" id="humandeath" runat="server" visible="false">
                            <div style="flex: 4;">
                                <asp:Label ID="lblAge" runat="server" Text="Age / आयु" AssociatedControlID="txtAge" CssClass="form-label d-block mb-2"></asp:Label>
                                <asp:TextBox ID="txtAge" runat="server" CssClass="form-control"
                                    Placeholder="Enter Age" MaxLength="3" onkeypress="return allowDecimal(event)"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="revAge" runat="server"
                                    ControlToValidate="txtAge"
                                    ValidationExpression="^\d+(\.\d+)?$"
                                    ErrorMessage="Only numbers or decimals allowed"  
                                    CssClass="text-danger" Display="Dynamic" />
                            </div>
                           
                                <div style="flex: 4">
                                    <asp:Label ID="lblAadhar" runat="server" Text="Aadhaar No. / आधार नंबर" AssociatedControlID="txtAadhar" CssClass="mb-2"></asp:Label>
                                    <asp:TextBox ID="txtAadhar" runat="server" CssClass="form-control" MaxLength="12" onkeypress="return allowOnlyNumbers(event)"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="revAadhar" runat="server"
                                        ControlToValidate="txtAadhar"
                                        ValidationExpression="^\d{12}$"
                                        ErrorMessage="Enter valid 12-digit Aadhaar number"
                                        CssClass="text-danger" Display="Dynamic" />
                                </div>

                                <div style="flex: 4; position: relative;">
                                    <asp:Label ID="lblAadharFile" runat="server" Text="Upload Aadhaar File / आधार फ़ाइल अपलोड करें" AssociatedControlID="fuAadhar" CssClass="mb-2"></asp:Label>
                                    <asp:FileUpload ID="fuAadhar" runat="server" CssClass="form-control" />
                                    <asp:LinkButton ID="btnPreview" runat="server" Text="Preview" OnClientClick="return false;" CssClass="btn btn-link mt-2" Style="display: none;"></asp:LinkButton>
                                    <div class="mt-2 d-flex align-items-center gap-3">
                                        <asp:LinkButton
                                            ID="LinkButton1"
                                            runat="server" Visible="false"
                                            Text="Preview"
                                            OnClientClick="return false;"
                                            CssClass="btn btn-link mt-2 d-flex align-items-center gap-1"
                                            Style="display: none;">
            <i class="bi bi-eye"></i> View Aadhar
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            
                        </div>

                        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <div class="form-row" id="cropdamage" runat="server" visible="false">
                                    <div style="flex: 4; margin-right: 10px;">
                                        <asp:Label ID="Label3" runat="server" Text="Farmer Name / किसान का नाम" AssociatedControlID="TextBox1" CssClass="form-label"></asp:Label>
                                        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" Placeholder="Enter Farmer Full Name" oninput="formatAndValidateName(this)"></asp:TextBox>
                                    </div>
                                    <div style="flex: 4;">
                                        <asp:Label ID="Label4" runat="server" Text="Father Name / पिता का नाम" AssociatedControlID="TextBox2" CssClass="form-label"></asp:Label>
                                        <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" Placeholder="Enter Father Name" oninput="formatAndValidateName(this)"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="form-row" id="cattlekill" runat="server" visible="false">
                                    <div style="margin-right: 10px;">
                                        <div>
                                            <asp:Label ID="Label8" runat="server" Text="Cattle Owner Name / मवेशी मालिक का नाम" AssociatedControlID="txt_cattle_owner" CssClass="form-label"></asp:Label>
                                        <asp:TextBox ID="txt_cattle_owner" runat="server" CssClass="form-control" Placeholder="Enter Full Name" oninput="formatAndValidateName(this)"></asp:TextBox>
                                        </div>
                                        <div>
                                            <asp:Label ID="Label9" runat="server" Text="Father Name / पिता का नाम" AssociatedControlID="txt_cattle_father_name" CssClass="form-label"></asp:Label>
                                        <asp:TextBox ID="txt_cattle_father_name" runat="server" CssClass="form-control" Placeholder="Enter Father Name" oninput="formatAndValidateName(this)"></asp:TextBox>
                                        </div>
                                    </div>
                                    <asp:Panel ID="pnlCattleDetails" runat="server" CssClass="cattle-details-container">
                                        <div class="cattle-row" style="display: flex; gap: 20px; margin-bottom: 10px;">
                                            <div style="flex: 4;">
                                                <asp:Label ID="Label10" runat="server" Text="Species Type / प्रजाति प्रकार" AssociatedControlID="ddl_cattle_species" CssClass="form-label d-block mb-2"></asp:Label>
                                                <asp:DropDownList ID="ddl_cattle_species" runat="server" CssClass="form-control cattle-species">
                                                    <asp:ListItem Text="Select Species" Value="" />
                                                    <asp:ListItem Text="Cattle (गाय/बैल)" Value="Cattle" />
                                                    <asp:ListItem Text="Buffalo (भैंस)" Value="Buffalo" />
                                                    <asp:ListItem Text="Goat (बकरी)" Value="Goat" />
                                                    <asp:ListItem Text="Sheep (भेड़)" Value="Sheep" />
                                                    <asp:ListItem Text="Horse (घोड़ा)" Value="Horse" />
                                                    <asp:ListItem Text="Mule (खच्चर)" Value="Mule" />
                                                    <asp:ListItem Text="Donkey (गधा)" Value="Donkey" />
                                                    <asp:ListItem Text="Pig (सुअर)" Value="Pig" />
                                                    <asp:ListItem Text="Poultry (मुर्गी)" Value="Poultry" />

                                                    <asp:ListItem Text="Camel (ऊंट)" Value="Camel" />
                                                    <asp:ListItem Text="Bull (साँड़)" Value="Bull" />
                                                    <asp:ListItem Text="Piglet (मुर्गी)" Value="Piglet" />
                                                    <asp:ListItem Text="Calf/Heifer (बछड़ा/बछिया)" Value="Calf" />

                                                </asp:DropDownList>
                                            </div>
                                            <div style="flex: 4;">
                                                <asp:Label ID="Label11" runat="server" Text="Age of dead Cattle / मृत मवेशियों की आयु" AssociatedControlID="ddl_cattle_age" CssClass="form-label d-block mb-2"></asp:Label>
                                                <asp:DropDownList ID="ddl_cattle_age" runat="server" CssClass="form-control cattle-age">
                                                    <asp:ListItem Text="Select Age (in Years)" Value="" />
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
                                        <asp:Button ID="btnAddCattle" runat="server" Text="&#43;" CssClass="btn btn-primary" OnClientClick="addCattleField(); return false;" />

                                        <asp:HiddenField ID="hfCattleSpecies" runat="server" />
                                        <asp:HiddenField ID="hfCattleAges" runat="server" />
                                    </asp:Panel>
                                </div>

                                <div class="form-row" id="housedamage" runat="server" visible="false">
                                    <div style="flex: 4; margin-right: 10px;">
                                        <asp:Label ID="Label12" runat="server" Text="House Owner Name / घर के मालिक का नाम" AssociatedControlID="txt_house_owner_name" CssClass="form-label"></asp:Label>
                                        <asp:TextBox ID="txt_house_owner_name" runat="server" CssClass="form-control" Placeholder="Enter Full Name" oninput="formatAndValidateName(this)"></asp:TextBox>
                                    </div>
                                    <div style="flex: 4;">
                                        <asp:Label ID="Label13" runat="server" Text="Father Name / पिता का नाम" AssociatedControlID="txt_house_father_name" CssClass="form-label"></asp:Label>
                                        <asp:TextBox ID="txt_house_father_name" runat="server" CssClass="form-control" Placeholder="Enter Father Name" oninput="formatAndValidateName(this)"></asp:TextBox>
                                    </div>
                                </div>

                            </ContentTemplate>
                        </asp:UpdatePanel>


                        <h4 class="mt-2 text-success text-center">Incident Details / घटना विवरण</h4>
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <div class="form-row">
                                    <div style="flex: 4;">
                                        <asp:Label ID="lblDistrict3" runat="server" Text="District / ज़िला" CssClass="form-label d-block mb-2"></asp:Label>
                                        <asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-control custom-ddl" AutoPostBack="true" OnSelectedIndexChanged="ddlDistrict_SelectedIndexChanged">
                                            <asp:ListItem Text="Select District" Value="0" />
                                        </asp:DropDownList>
                                    </div>
                                    <div style="flex: 4;">
                                        <asp:Label ID="lblTehsil3" runat="server" Text="Tehsil / तहसील" CssClass="form-label d-block mb-2"></asp:Label>
                                        <asp:DropDownList ID="ddlTehsil" runat="server" CssClass="form-control custom-ddl" AutoPostBack="true" OnSelectedIndexChanged="ddlTehsil_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                    <div style="flex: 4;">
                                        <asp:Label ID="lblVillage3" runat="server" Text="Village / गाँव" CssClass="form-label d-block mb-2"></asp:Label>
                                        <asp:DropDownList ID="ddlVillage" runat="server" CssClass="form-control custom-ddl" AutoPostBack="true" OnSelectedIndexChanged="ddlVillage_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-row mt-3">
                                    <div style="flex: 4;">
                                        <asp:Label ID="lblDivision3" runat="server" Text="Division / विभाजन" CssClass="form-label d-block mb-2"></asp:Label>
                                        <asp:DropDownList ID="ddlDivision" ReadOnly runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <div style="flex: 4;">
                                        <asp:Label ID="lblRange3" runat="server" Text="Range / श्रेणी" CssClass="form-label d-block mb-2"></asp:Label>
                                        <asp:DropDownList ID="ddlRange3" ReadOnly runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <div style="flex: 4;">
                                        <asp:Label ID="lblIncidentBy" runat="server" Text="Incident Occurred By (Animal) / घटना (पशु) द्वारा घटित हुई" AssociatedControlID="ddlIncidentBy" CssClass="form-label d-block mb-2"></asp:Label>

                                        <asp:DropDownList ID="ddlIncidentBy" runat="server" CssClass="form-control custom-ddl" />

                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                        <div class="form-row mt-4">
                            <div style="flex: 3; margin-right: 10px;">
                                <asp:Label ID="lblDateIncident" runat="server" Text="Date of Incident / घटना की तिथि" AssociatedControlID="txtDateIncident" CssClass="form-label"></asp:Label>
                                <asp:TextBox ID="txtDateIncident" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                            <div style="flex: 3;">
                                <asp:Label ID="lblTimeIncident" runat="server" Text="Time of Incident / घटना का समय" AssociatedControlID="txtTimeIncident" CssClass="form-label"></asp:Label>
                                <asp:TextBox
                                    ID="txtTimeIncident"
                                    runat="server"
                                    CssClass="form-control"
                                    TextMode="SingleLine"
                                    placeholder="hh:mm AM/PM">
                                </asp:TextBox>
                            </div>

                            <div style="flex: 3;" id="yes_no" runat="server" visible="false">
                                <asp:Label ID="Label16" runat="server" Text="Whether Owner was Present at the time / क्या मालिक उस समय मौजूद था" AssociatedControlID="ddl_yes_no" CssClass="form-label d-block mb-2"></asp:Label>
                                <asp:DropDownList ID="ddl_yes_no" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Select" Value="" />
                                    <asp:ListItem Text="Yes" Value="1" />
                                    <asp:ListItem Text="No" Value="2" />
                                </asp:DropDownList>
                            </div>
                            <asp:Panel ID="pnlCropDetails" runat="server" CssClass="crop-details-container">
                                <div class="crop-row" style="display: flex; gap: 20px; margin-bottom: 10px;">

                                    <div style="flex: 3;" id="cropdamagedname" visible="false" runat="server">
                                        <asp:Label ID="Label5" runat="server" Text="Damaged Crop Name / क्षतिग्रस्त फसल का नाम" AssociatedControlID="ddl_damage_crop" CssClass="form-label d-block mb-2"></asp:Label>
                                        <span style="color: red;"></span>
                                        <asp:DropDownList ID="ddl_damage_crop" runat="server" CssClass="form-control custom-ddl crop-name">
                                            <asp:ListItem Text="Select" Value="" />
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
                                        <asp:Label ID="Label7" runat="server" Text="Area (in Hac.) / क्षेत्र (हेक्टेयर में)" AssociatedControlID="txt_crop_area" CssClass="form-label"></asp:Label>
                                        <asp:TextBox ID="txt_crop_area" runat="server" CssClass="form-control crop-area" MaxLength="4"
                                            Placeholder="Enter crop area in hectares" onkeypress="return allowDecimal(event)"></asp:TextBox>
                                        <%-- <asp:RegularExpressionValidator ID="revCropArea" runat="server"
                                        ControlToValidate="txt_crop_area"
                                        ValidationExpression="^\d+(\.\d+)?$"
                                        ErrorMessage="Enter valid decimal value"
                                        CssClass="text-danger" Display="Dynamic" />--%>
                                        <asp:RegularExpressionValidator
                                            ID="revCropArea"
                                            runat="server"
                                            ControlToValidate="txt_crop_area"
                                            ValidationExpression="^\d+(\.\d+)?(-\d+(\.\d+)?)?$"
                                            ErrorMessage="Enter a valid value (e.g., 15 or 15-16 or 15.5-16.25)"
                                            CssClass="text-danger"
                                            Display="Dynamic" />
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
                                    <asp:ListItem Text="Select Place" Value="" />
                                    <asp:ListItem Text="Agricultural Field (खेत)" Value="Field" />
                                    <asp:ListItem Text="Village (गाँव)" Value="Village" />
                                    <asp:ListItem Text="Forest Area (जंगल)" Value="Forest" />
                                    <asp:ListItem Text="Road / Highway (सड़क)" Value="Road" />
                                    <asp:ListItem Text="Water Source / River Bank (नदी किनारा)" Value="WaterSource" />
                                    <asp:ListItem Text="House / Cattle Shed (घर / गोठ)" Value="House" />
                                    <asp:ListItem Text="Near Protected Area (संरक्षित क्षेत्र)" Value="ProtectedArea" />
                                </asp:DropDownList>
                            </div>
                        </div>


                        <h4 class="mt-2">Incident Summary / घटना सारांश</h4>
                        <div class="form-row mt-2">
                            <div style="flex: 1;">
                                <asp:Label ID="lblIncidentLocation" runat="server" Text="Incident Location on Map / मानचित्र पर घटना का स्थान" CssClass="form-label"></asp:Label>
                                <div class="d-flex" style="gap: 10px; margin-top: 5px;">
                                    <asp:TextBox
                                        ID="txtLongitude"
                                        runat="server"
                                        CssClass="form-control small-input"
                                        placeholder="Longitude / देशान्तर"
                                        oninput="validateNumeric(this)">
                                    </asp:TextBox>

                                    <asp:TextBox
                                        ID="txtLatitude"
                                        runat="server"
                                        CssClass="form-control small-input"
                                        placeholder="Latitude / अक्षांश"
                                        oninput="validateNumeric(this)">
                                    </asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="row ncidentContentAssets">
                            <%--        <div class="col-md-6">
                                <asp:Label ID="lblIncidentSummary" runat="server"
                                    Text="Incident Summary / घटना सारांश  "
                                    AssociatedControlID="txtIncidentSummary"
                                    CssClass="form-label" Style="height: 35px"></asp:Label>


                                  <asp:TextBox ID="txtIncidentSummary" runat="server"
                                    CssClass="form-control full-width"
                                    TextMode="MultiLine" Rows="10"
                                    MaxLength="500"
                                    placeholder="Describe the incident in detail">
                                </asp:TextBox>


                            </div>--%>





                            <div class="col-md-6">
                                <!-- Label -->
                                <asp:Label ID="lblIncidentSummary" runat="server"
                                    Text="Incident Summary / घटना सारांश"
                                    AssociatedControlID="txtIncidentSummary"
                                    CssClass="form-label mb-2"
                                    Style="height: 35px; display: block;"></asp:Label>
                            <%--    style="display:flex; justify-content:space-between; align-items:center;--%>
                                <!-- Word Count Meter -->
                                <div id="wordCount" style="color: #007bff; font-weight: 500; margin-bottom: 8px; text-align: center;">
                                    Maximum Words: 0 / 500 words
                                </div>

                                <!-- Textbox -->
                                <asp:TextBox ID="txtIncidentSummary" runat="server"
                                    CssClass="form-control full-width"
                                    TextMode="MultiLine"
                                    Rows="10"
                                    placeholder="Describe the incident in detail">
                                </asp:TextBox>
                            </div>




                            <!-- Right side : Map -->
                            <div class="col-md-6">
                                <script src="../GIS/js/jquery.min.js"></script>
                                <div class="form-group">
                                    <label class="form-label" style="color:#000;">
                                        NOTE : Find your location and click on the map to get 'Latitude' and 'Longitude' automatically. / नोट: अपना स्थान ढूंढें और 'अक्षांश' और 'देशांतर' स्वचालित रूप से प्राप्त करने के लिए मानचित्र पर क्लिक करें।
                                    </label>
                                    <div id="map" style="width: 100%; height: 243px;"></div>
                                </div>
                            </div>
                        </div>




                        <div class="row uploadFileContt" style="margin-top: 10px">
                            <asp:Label ID="Label18" runat="server" CssClass="info-text" Text="Upload Documents (Document size should not be more than 10 MB) / दस्तावेज़ अपलोड करें (दस्तावेज़ का आकार 10 एमबी से अधिक नहीं होना चाहिए)"></asp:Label>
                        </div>





                        <%--                        <div class="info-text">
                            <asp:Label ID="lblUploadInfo" runat="server" CssClass="info-text" Text="Upload Documents (Document size should not be more than 10 MB) / दस्तावेज़ अपलोड करें (दस्तावेज़ का आकार 10 एमबी से अधिक नहीं होना चाहिए)"></asp:Label>
                        </div>--%>

                        <div class="form-row mt-2" id="humandocuments" runat="server" visible="false">
                            <div style="flex: 1;">
                                <div class="upload-item">
                                    <label class="upload-label">Incident Photograph / घटना फोटो</label>
                                    <div class="file-upload-wrapper">
                                        <asp:FileUpload ID="incidentphotograph" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                        <label for="<%= incidentphotograph.ClientID %>" class="file-upload-label">
                                            <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                                        </label>
                                        <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                                    </div>
                                    <%--<asp:Label ID="Label18" runat="server" CssClass="file-status" Visible="false"></asp:Label>--%>
                                </div>
                            </div>
                            <div style="flex: 1;">
                                <div class="upload-item">
                                    <label class="upload-label">Applicant Application Form / आवेदक आवेदन पत्र</label>
                                    <div class="file-upload-wrapper">
                                        <asp:FileUpload ID="applicantapplication" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                        <label for="<%= applicantapplication.ClientID %>" class="file-upload-label">
                                            <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / दस्तावेज़ यहां अपलोड करें
                                        </label>
                                        <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                                    </div>
                                    <asp:Label ID="lblEndorsementStatus" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                                </div>
                            </div>
                            <div style="flex: 1;">
                                <div class="upload-item">
                                    <label class="upload-label">Gram Panchayat Certificate / ग्राम पंचायत प्रमाण पत्र</label>
                                    <div class="file-upload-wrapper">
                                        <asp:FileUpload ID="grampanchayatform" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                        <label for="<%= grampanchayatform.ClientID %>" class="file-upload-label">
                                            <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / दस्तावेज़ यहां अपलोड करें
                                        </label>
                                        <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                                    </div>
                                    <asp:Label ID="Label15" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                                </div>
                            </div>
                            <div style="flex: 1;">
                                <div class="upload-item">
                                    <label class="upload-label">Applicant Endorsement Application / आवेदक समर्थन आवेदन</label>
                                    <div class="file-upload-wrapper">
                                        <asp:FileUpload ID="EndorsementApp" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                        <label for="<%= EndorsementApp.ClientID %>" class="file-upload-label">
                                            <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / दस्तावेज़ यहां अपलोड करें
                                        </label>
                                        <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                                    </div>
                                    <asp:Label ID="Label17" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <div class="form-row mt-2" id="cropdamagedocument" runat="server" visible="false">
                            <div style="flex: 1;">
                                <div class="upload-item">
                                    <label class="upload-label">Incident Photograph / घटना फोटो</label>
                                    <div class="file-upload-wrapper">
                                        <asp:FileUpload ID="cropdamage_incidentphotograph" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                        <label for="<%= cropdamage_incidentphotograph.ClientID %>" class="file-upload-label">
                                            <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / दस्तावेज़ यहां अपलोड करें
                                        </label>
                                        <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                                    </div>
                                    <asp:Label ID="Label19" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                                </div>
                            </div>
                            <div style="flex: 1;">
                                <div class="upload-item">
                                    <label class="upload-label">Applicant Application Form / आवेदक आवेदन पत्र</label>
                                    <div class="file-upload-wrapper">
                                        <asp:FileUpload ID="cropdamage_applicantform" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                        <label for="<%= cropdamage_applicantform.ClientID %>" class="file-upload-label">
                                            <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / दस्तावेज़ यहां अपलोड करें
                                        </label>
                                        <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                                    </div>
                                    <asp:Label ID="Label20" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                                </div>
                            </div>
                            <div style="flex: 1;">
                                <div class="upload-item">
                                    <label class="upload-label">Lekhpal/Patwari Certificate / लेखपाल/पटवारी प्रमाणपत्र</label>
                                    <div class="file-upload-wrapper">
                                        <asp:FileUpload ID="cropdamage_lekhpal" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                        <label for="<%= cropdamage_lekhpal.ClientID %>" class="file-upload-label">
                                            <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / दस्तावेज़ यहां अपलोड करें
                                        </label>
                                        <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                                    </div>
                                    <asp:Label ID="Label21" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                                </div>
                            </div>
                            <div style="flex: 1;">
                                <div class="upload-item">
                                    <label class="upload-label">Applicant Endorsement Application / आवेदक समर्थन आवेदन</label>
                                    <div class="file-upload-wrapper">
                                        <asp:FileUpload ID="cropdamage_applicantendorsemet" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                        <label for="<%= cropdamage_applicantendorsemet.ClientID %>" class="file-upload-label">
                                            <i class="fas fa-cloud-upload-alt"></i>Upload Document Here / दस्तावेज़ यहां अपलोड करें
                                        </label>
                                        <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                                    </div>
                                    <asp:Label ID="Label22" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <div class="form-row" style="justify-content: center;">
                            <asp:Button
                                ID="btn_submit_victim_incident"
                                runat="server"
                                Text="Submit"
                                CssClass="submit-btn"
                                OnClick="btn_submit_victim_incident_Click"
                                ValidationGroup="a"
                                OnClientClick="return validateFiles();" />
                        </div>

                    </div>
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

     <%--       const statusLabels = {
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
            //    if (!upload) return;

            //    const wrapper = upload.closest('.file-upload-wrapper');
            //    if (!wrapper) return;

            //    const statusLabelId = statusLabels[uploadId];
            //    const statusLabel = statusLabelId ? document.getElementById(statusLabelId) : null;

            //    let actionsDiv = wrapper.querySelector('.file-actions');
            //    if (!actionsDiv) {
            //        actionsDiv = document.createElement('div');
            //        actionsDiv.classList.add('file-actions');
            //        actionsDiv.style.display = 'none';
            //        actionsDiv.style.marginTop = '10px';
            //        wrapper.appendChild(actionsDiv);
            //    }

            //    upload.addEventListener('change', function (e) {
            //        const file = e.target.files[0];
            //        if (file) handleFile(file, upload, statusLabel, wrapper, actionsDiv);
            //    });

            //    wrapper.addEventListener('dragover', e => { e.preventDefault(); wrapper.classList.add('dragover'); });
            //    wrapper.addEventListener('dragleave', e => { e.preventDefault(); wrapper.classList.remove('dragover'); });
            //    wrapper.addEventListener('drop', e => {
            //        e.preventDefault();
            //        wrapper.classList.remove('dragover');
            //        const files = e.dataTransfer.files;
            //        if (files.length > 0) {
            //            upload.files = files;
            //            handleFile(files[0], upload, statusLabel, wrapper, actionsDiv);
            //        }
            //    });
            //});

            function handleFile(file, upload, statusLabel, wrapper, actionsDiv) {
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
                actionsDiv.style.display = 'block';

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

        //function allowDecimal(evt) {
        //    var charCode = (evt.which) ? evt.which : evt.keyCode;

        //    if (charCode != 46 && (charCode < 48 || charCode > 57)) {
        //        return false;
        //    }
        //    if (charCode == 46 && evt.target.value.indexOf('.') !== -1) {
        //        return false;
        //    }

        //    return true;
        //}



        function allowDecimal(evt) {
            const charCode = (evt.which) ? evt.which : evt.keyCode;
            const input = evt.target.value;

            // Allow: backspace, tab, delete, arrows
            if (charCode === 8 || charCode === 9 || charCode === 46 || (charCode >= 37 && charCode <= 40)) {
                return true;
            }

            // Allow digits
            if (charCode >= 48 && charCode <= 57) {
                return true;
            }

            // Allow one dot per number part (before or after hyphen)
            if (charCode === 46) {
                const parts = input.split('-');
                if (parts.length === 1 && parts[0].indexOf('.') === -1) return true;
                if (parts.length === 2 && parts[1].indexOf('.') === -1) return true;
            }

            // Allow only one hyphen
            if (charCode === 45 && input.indexOf('-') === -1 && input.length > 0) {
                return true;
            }

            return false;
        }


    </script>

    <script type="text/javascript">
        window.onload = function () {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("<%= txtDateIncident.ClientID %>").setAttribute("max", today);
        };
    </script>



    <script>
        function formatAndValidateName(input) {
            // Sirf letters aur space allow kare
            let value = input.value.replace(/[^a-zA-Z\s]/g, '');

            // Words ko split kare aur first letter capitalize kare
            value = value.split(' ').map(word => {
                if (word.length > 0) {
                    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
                } else {
                    return '';
                }
            }).join(' ');

            input.value = value;
        }

        function validateNumeric(input) {
            let value = input.value;

            value = value.replace(/[^0-9.]/g, '');

            let parts = value.split('.');
            if (parts.length > 2) {
                value = parts[0] + '.' + parts.slice(1).join('');
            }

            input.value = value;
        }
    </script>



    <script type="text/javascript">
        function validateFiles() {

            // Remove previous error borders
            document.querySelectorAll(".error-border").forEach(el => el.classList.remove("error-border"));

            var claimType = document.querySelector("input[name='<%= rblClaimType.UniqueID %>']:checked");
            if (!claimType) {
                Swal.fire("Validation Error", "Please select Claim Type.", "error");
                return false;
            }

            var selectedClaim = claimType.value;
            let errors = [];

            // 🔥 DROPDOWN VALIDATION
            var ddlIncidentBy = document.getElementById('<%= ddlIncidentBy.ClientID %>');
            var incidentBy = ddlIncidentBy.value;

            if (incidentBy === "" || incidentBy === "0") {
                errors.push("Please select Incident By.");
                ddlIncidentBy.classList.add("error-border");
            }

            var ddl = document.getElementById('<%= ddlDistrict.ClientID %>');
            if (ddl.value === "" || ddl.value === "0") {
                errors.push("Please select District.");
                ddl.classList.add("error-border");
            }

            // Tehsil
            var ddlTehsil = document.getElementById('<%= ddlTehsil.ClientID %>');
            if (ddlTehsil.value === "" || ddlTehsil.value === "0") {
                errors.push("Please select Tehsil.");
                ddlTehsil.classList.add("error-border");
            }

            // Village
            var ddlVillage = document.getElementById('<%= ddlVillage.ClientID %>');
            if (ddlVillage.value === "" || ddlVillage.value === "0") {
                errors.push("Please select Village.");
                ddlVillage.classList.add("error-border");
            }

            // Division
            var ddlDivision = document.getElementById('<%= ddlDivision.ClientID %>');
            if (ddlDivision.value === "" || ddlDivision.value === "0") {
                errors.push("Please select Division.");
                ddlDivision.classList.add("error-border");
            }

            // Range
            var ddlRange = document.getElementById('<%= ddlRange3.ClientID %>');
            if (ddlRange.value === "" || ddlRange.value === "0") {
                errors.push("Please select Range.");
                ddlRange.classList.add("error-border");
            }

            // 📅 Date of Incident
            var dateIncident = document.getElementById('<%= txtDateIncident.ClientID %>');
            if (!dateIncident.value.trim()) {
                errors.push("Please select Date of Incident.");
                dateIncident.classList.add("error-border");
            }

            // ⏰ Time of Incident
            var timeIncident = document.getElementById('<%= txtTimeIncident.ClientID %>');
            var timeValue = timeIncident.value.trim();

            if (!timeValue) {
                errors.push("Please enter Time of Incident.");
                timeIncident.classList.add("error-border");
            } else {
                // Time Format Validation (hh:mm AM/PM)
                var timeRegex = /^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM)$/i;
                if (!timeRegex.test(timeValue)) {
                    errors.push("Please enter valid Time (hh:mm AM/PM).");
                    timeIncident.classList.add("error-border");
                }
            }


            if (selectedClaim === "Human") {

                // AGE
                var age = document.getElementById('<%= txtAge.ClientID %>');
                if (!age.value.trim()) {
                    errors.push("Please enter Age.");
                    age.classList.add("error-border");
                }

                // AADHAAR NUMBER
                var aadhar = document.getElementById('<%= txtAadhar.ClientID %>');
                var aadharValue = aadhar.value.trim();

                if (aadharValue.length !== 12 || !/^\d{12}$/.test(aadharValue)) {
                    errors.push("Enter Aadhaar number.");
                    aadhar.classList.add("error-border");
                }

                // AADHAAR FILE
                var aadharFile = document.getElementById('<%= fuAadhar.ClientID %>');
                if (!aadharFile.value) {
                    errors.push("Please upload Aadhaar File.");
                    aadharFile.classList.add("error-border");
                }

                // 🔥 NEW — FULL NAME
                var fullName = document.getElementById('<%= txtFullName.ClientID %>');
                if (!fullName.value.trim()) {
                    errors.push("Please enter Full Name.");
                    fullName.classList.add("error-border");
                }

                // 🔥 NEW — FATHER NAME
                var fatherName = document.getElementById('<%= txtFatherName.ClientID %>');
                if (!fatherName.value.trim()) {
                    errors.push("Please enter Father Name.");
                    fatherName.classList.add("error-border");
                }

                // 🔥 NEW — GENDER
                var genderList = document.querySelector("input[name='<%= rblGender.UniqueID %>']:checked");
                if (!genderList) {
                    errors.push("Please select Gender.");
                    document.getElementById('<%= rblGender.ClientID %>').classList.add("error-border");
                }
            }
            if (selectedClaim === "Human" || selectedClaim === "Cattle" || selectedClaim === "House") {

                var incident = document.getElementById('<%= incidentphotograph.ClientID %>');
                var application = document.getElementById('<%= applicantapplication.ClientID %>');
                var gpForm = document.getElementById('<%= grampanchayatform.ClientID %>');
                var endorse = document.getElementById('<%= EndorsementApp.ClientID %>');

                if (!incident.value) { errors.push("Please upload Incident Photograph."); incident.classList.add("error-border"); }
                if (!application.value) { errors.push("Please upload Applicant Application Form."); application.classList.add("error-border"); }
                if (!gpForm.value) { errors.push("Please upload Gram Panchayat Certificate."); gpForm.classList.add("error-border"); }
                if (!endorse.value) { errors.push("Please upload Applicant Endorsement Application."); endorse.classList.add("error-border"); }
            }
            else if (selectedClaim === "Cattle") {

                // Owner Name
                var owner = document.getElementById('<%= txt_cattle_owner.ClientID %>');
                if (!owner.value.trim()) {
                    errors.push("Please enter Cattle Owner Name.");
                    owner.classList.add("error-border");
                }

                // Father Name
                var cattleFather = document.getElementById('<%= txt_cattle_father_name.ClientID %>');
                if (!cattleFather.value.trim()) {
                    errors.push("Please enter Father Name.");
                    cattleFather.classList.add("error-border");
                }

                // Species Type
                var species = document.getElementById('<%= ddl_cattle_species.ClientID %>');
                if (species.value === "" || species.value === "0") {
                    errors.push("Please select Species Type.");
                    species.classList.add("error-border");
                }

                // Age of Cattle
                var cattleAge = document.getElementById('<%= ddl_cattle_age.ClientID %>');
                if (cattleAge.value === "" || cattleAge.value === "0") {
                    errors.push("Please select Cattle Age.");
                    cattleAge.classList.add("error-border");
                }


                // 🟩 Owner Present (Yes/No)
                var yesNo = document.getElementById('<%= ddl_yes_no.ClientID %>');
                if (yesNo.value === "" || yesNo.value === "0") {
                    errors.push("Please select whether the owner was present at that time.");
                    yesNo.classList.add("error-border");
                }

                // 🟩 Incident Place
                var incidentPlace = document.getElementById('<%= ddl_incidentplace.ClientID %>');
                if (incidentPlace.value === "" || incidentPlace.value === "0") {
                    errors.push("Please select Incident Place.");
                    incidentPlace.classList.add("error-border");
                }


                // 🔥 If you want dynamic multiple species/ages, check hidden fields too
                var hfSpecies = document.getElementById('<%= hfCattleSpecies.ClientID %>');
                var hfAges = document.getElementById('<%= hfCattleAges.ClientID %>');

                // If dynamic fields are visible & empty
                if (hfSpecies.value.trim() === "" || hfAges.value.trim() === "") {
                    errors.push("Please add at least one Cattle entry.");
                    document.querySelector(".dynamic-cattle-fields")?.classList.add("error-border");
                }
            }
            else if (selectedClaim === "House") {
                var houseOwner = document.getElementById('<%= txt_house_owner_name.ClientID %>');
                if (!houseOwner.value.trim()) {
                    errors.push("Please enter House Owner Name.");
                    houseOwner.classList.add("error-border");
                }

                var houseFather = document.getElementById('<%= txt_house_father_name.ClientID %>');
                if (!houseFather.value.trim()) {
                    errors.push("Please enter Father Name.");
                    houseFather.classList.add("error-border");
                }
            }
            else if (selectedClaim === "Crop") {

                var farmerName = document.getElementById('<%= TextBox1.ClientID %>');
                if (!farmerName.value.trim()) {
                    errors.push("Please enter Farmer Name.");
                    farmerName.classList.add("error-border");
                }

                var cropFather = document.getElementById('<%= TextBox2.ClientID %>');
                if (!cropFather.value.trim()) {
                    errors.push("Please enter Farmer's Father Name.");
                    cropFather.classList.add("error-border");
                }

                var ddl_damage_crop = document.getElementById('<%= ddl_damage_crop.ClientID %>');
                if (ddl_damage_crop.value === "" || ddl_damage_crop.value === "0") {
                    errors.push("Please select Crop.");
                    ddl_damage_crop.classList.add("error-border");
                }

                var c_incident = document.getElementById('<%= cropdamage_incidentphotograph.ClientID %>');
                var c_appform = document.getElementById('<%= cropdamage_applicantform.ClientID %>');
                var c_lekhpal = document.getElementById('<%= cropdamage_lekhpal.ClientID %>');
                var c_endorse = document.getElementById('<%= cropdamage_applicantendorsemet.ClientID %>');

                if (!c_incident.value) { errors.push("Please upload Crop Incident Photograph."); c_incident.classList.add("error-border"); }
                if (!c_appform.value) { errors.push("Please upload Applicant Application Form."); c_appform.classList.add("error-border"); }
                if (!c_lekhpal.value) { errors.push("Please upload Lekhpal/Patwari Certificate."); c_lekhpal.classList.add("error-border"); }
                if (!c_endorse.value) { errors.push("Please upload Applicant Endorsement Application."); c_endorse.classList.add("error-border"); }
            }

            if (errors.length > 0) {
                Swal.fire("Validation Error", errors.join("<br/>"), "error");
                return false;
            }
            return true;
        }
    </script>


    <style>
        .error-border {
            border: 1px solid red !important;
        }
    </style>

    <%-- <script>
        document.addEventListener("DOMContentLoaded", function () {

            document.querySelectorAll(".file-upload-wrapper").forEach(function (wrapper) {
                var fileInput = wrapper.querySelector("input[type='file']");
                var fileInfo = wrapper.querySelector(".file-info");
                var removeBtn = wrapper.querySelector(".remove-file-btn");

                // Create remove button if not present
                if (!removeBtn) {
                    removeBtn = document.createElement("span");
                    removeBtn.innerHTML = "×";
                    removeBtn.classList.add("remove-file-btn");
                    wrapper.appendChild(removeBtn);
                }

                // Initially hide remove button
                removeBtn.style.display = "none";

                // Show remove button and update file info when file selected
                fileInput.addEventListener("change", function () {
                    if (fileInput.files.length > 0) {
                        removeBtn.style.display = "block";
                        if (fileInfo) {
                            fileInfo.innerHTML = `<strong>${fileInput.files[0].name}</strong><br>${Math.round(fileInput.files[0].size / 1024)} KB - Ready`;
                        }
                    } else {
                        removeBtn.style.display = "none";
                        if (fileInfo) fileInfo.textContent = "Max size: 2MB | Formats: JPG, PNG, PDF";
                    }
                });

                // Remove file on clicking cross
                removeBtn.addEventListener("click", function () {
                    // Clear the input
                    fileInput.value = "";

                    // Reset UI
                    removeBtn.style.display = "none";
                    if (fileInfo) fileInfo.textContent = "Max size: 2MB | Formats: JPG, PNG, PDF";
                });
            });
        });
    </script>--%>


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


    <%--<script>
        debugger;
        document.addEventListener("DOMContentLoaded", function () {

            // For each file upload wrapper
            document.querySelectorAll(".file-upload-wrapper").forEach(function (wrapper) {
                var fileInput = wrapper.querySelector("input[type='file']");
                var statusLabel = wrapper.parentElement.querySelector(".file-status");

                // Create cross button if not exists
                var removeBtn = wrapper.querySelector(".remove-file-btn");
                if (!removeBtn) {
                    removeBtn = document.createElement("span");
                    removeBtn.classList.add("remove-file-btn");
                    removeBtn.innerHTML = "×";
                    removeBtn.style.display = "none"; // hide initially
                    wrapper.appendChild(removeBtn);
                }

                // File input change event
                fileInput.addEventListener("change", function () {
                    if (fileInput.files.length > 0) {
                        removeBtn.style.display = "block"; // show cross button
                        if (statusLabel) {
                            statusLabel.style.display = "inline"; // show label
                            statusLabel.textContent = fileInput.files[0].name; // show file name
                        }
                    } else {
                        removeBtn.style.display = "none";
                        if (statusLabel) {
                            statusLabel.style.display = "none";
                            statusLabel.textContent = "";
                        }
                    }
                });

                // Cross button click
                removeBtn.addEventListener("click", function () {
                    fileInput.value = ""; // clear file
                    removeBtn.style.display = "none"; // hide cross button
                    if (statusLabel) {
                        statusLabel.textContent = ""; // clear label
                        statusLabel.style.display = "none"; // hide label
                    }
                });
            });

        });
    </script>--%>


    <script type="text/javascript">
        const txtIncidentSummary = document.getElementById('<%= txtIncidentSummary.ClientID %>');
        const wordCount = document.getElementById('wordCount');
        const maxWords = 500;

        txtIncidentSummary.addEventListener('input', () => {
            let words = txtIncidentSummary.value.trim().split(/\s+/);
            if (words[0] === "") words = [];

            // Limit to maxWords
            if (words.length > maxWords) {
                txtIncidentSummary.value = words.slice(0, maxWords).join(" ");
                words = words.slice(0, maxWords);
            }

            //wordCount.textContent = `${words.length} / ${maxWords} words`;
            wordCount.textContent = `Maximum Words: ${words.length} / ${maxWords} words`;
        });
    </script>



</asp:Content>
