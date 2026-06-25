<%@ Page Language="C#" Async="true" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="EditeVictimInsidentList.aspx.cs" Inherits="uk_forest.Forest.EditeVictimInsidentList" %>




<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css" />
    <style>
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

        .container.divtab {
            border: 2px solid #43a047;
            padding: 0 0 61px 0;
        }

        @media (min-width: 1200px) {
            .container {
                max-width: 1580px;
            }
        }

        .tab-content-wrapper {
            margin-top: 12px;
            background: #fcfcfc;
            border-radius: 8px;
            max-width: 1557px;
            margin-left: auto;
            margin-right: auto;
            padding: 20px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            padding: 10px;
            background: #8080800a;
            border-left: 1px solid gray;
            border-radius: 6px;
        }

        label {
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <div class="grid_item">
        <div class="container divtab">
            <div class="tab-content-wrapper">
                <asp:UpdatePanel ID="up1" runat="server">
                    <ContentTemplate>
                        <div class="form-container">
                            <div class="position-relative mb-3" style="display: flex; align-items: center; justify-content: center;">
                                <h2 class="font-weight-bold text-success mb-0 text-center" style="flex: 1;">Victim Incident Details</h2>
                                <span class="applicant-id font-weight-bold" style="position: absolute; right: 0;">Applicant ID:
                                    <asp:Label ID="Label6" runat="server"></asp:Label>
                                </span>
                            </div>
                            <hr />
                            <fieldset class="radio-group" style="border: 2px solid #23a510; padding: 15px; border-radius: 8px; margin-top: 20px;">
                                <legend style="font-weight: bold; color: #333; margin-bottom: 10px; text-align: center; width: auto; margin-left: auto; margin-right: auto;">
                                    <asp:Label ID="lblClaimType" runat="server" Text="Type of Claim Category"></asp:Label>
                                </legend>
                                <div class="d-flex flex-wrap justify-content-center" style="gap: 20px;">
                                    <asp:RadioButtonList ID="rblClaimType" runat="server" RepeatDirection="Horizontal" CssClass="claim-radio-list" RepeatLayout="Flow" OnSelectedIndexChanged="rblClaimType_SelectedIndexChanged" AutoPostBack="true">
                                        <asp:ListItem Text="Human Death / Injury" Value="Human" />
                                        <asp:ListItem Text="Crop Damage" Value="Crop" />
                                        <asp:ListItem Text="Cattle Kill" Value="Cattle" />
                                        <asp:ListItem Text="Property Damage" Value="House" />
                                    </asp:RadioButtonList>
                                </div>
                            </fieldset>
                            <h4 class="mt-2 text-success text-center">Victim Personal Details</h4>
                            <div class="form-row" id="humandeath" runat="server" visible="false">
                                <div style="flex: 4; margin-right: 10px;">
                                    <asp:Label ID="Label2" runat="server" Text="Full Name" AssociatedControlID="txtFullName" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" Placeholder="Enter Full Name"></asp:TextBox>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="lblFatherName" runat="server" Text="Father Name" AssociatedControlID="txtFatherName" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txtFatherName" runat="server" CssClass="form-control" Placeholder="Enter Father Name"></asp:TextBox>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="Label1" runat="server" Text="Gender" AssociatedControlID="rblGender" CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Vertical" RepeatLayout="Flow" CssClass="gender-radio-list">
                                        <asp:ListItem Text="Male" Value="Male" />
                                        <asp:ListItem Text="Female" Value="Female" />
                                        <asp:ListItem Text="Other" Value="Other" />
                                    </asp:RadioButtonList>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="lblAge" runat="server" Text="Age" AssociatedControlID="txtAge" CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:TextBox ID="txtAge" runat="server" CssClass="form-control" Placeholder="Enter Age" MaxLength="3" onkeypress="return allowOnlyNumbers(event)"></asp:TextBox>
                                </div>
                                <div class="form-row">
                                    <div style="flex: 2">
                                        <asp:Label ID="lblAadhar" runat="server" Text="Aadhaar No." AssociatedControlID="txtAadhar"></asp:Label>
                                        <asp:TextBox ID="txtAadhar" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvAadhar" runat="server" ControlToValidate="txtAadhar" ErrorMessage="Aadhaar no. is required" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                    <div style="flex: 2; position: relative;">
                                        <asp:Label ID="lblAadharFile" runat="server" Text="Upload Aadhaar File" AssociatedControlID="fuAadhar"></asp:Label>
                                        <asp:FileUpload ID="fuAadhar" runat="server" CssClass="form-control" />
                                        <asp:LinkButton ID="btnPreview" runat="server" Text="Preview" OnClientClick="return false;" CssClass="btn btn-link mt-2" Style="display: none;"></asp:LinkButton>
                                    </div>
                                </div>
                            </div>


                            <div class="form-row" id="cropdamage" runat="server" visible="false">
                                <div style="flex: 4; margin-right: 10px;">
                                    <asp:Label ID="Label3" runat="server" Text="Farmer Name" AssociatedControlID="TextBox1" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" Placeholder="Enter Farmer Full Name"></asp:TextBox>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="Label4" runat="server" Text="Father Name" AssociatedControlID="TextBox2" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" Placeholder="Enter Father Name"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row" id="cattlekill" runat="server" visible="false">
                                <div style="flex: 4; margin-right: 10px;">
                                    <asp:Label ID="Label8" runat="server" Text="Cattle Owner Name" AssociatedControlID="txt_cattle_owner" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_cattle_owner" runat="server" CssClass="form-control" Placeholder="Enter Full Name"></asp:TextBox>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="Label9" runat="server" Text="Father Name" AssociatedControlID="txt_cattle_father_name" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_cattle_father_name" runat="server" CssClass="form-control" Placeholder="Enter Father Name"></asp:TextBox>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="Label10" runat="server" Text="Species Type" AssociatedControlID="ddl_cattle_species" CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddl_cattle_species" runat="server" CssClass="form-control">
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
                                    </asp:DropDownList>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="Label11" runat="server" Text="Age of dead Cattle" AssociatedControlID="ddl_cattle_age" CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddl_cattle_age" runat="server" CssClass="form-control">
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
                            <div class="form-row" id="housedamage" runat="server" visible="false">
                                <div style="flex: 4; margin-right: 10px;">
                                    <asp:Label ID="Label12" runat="server" Text="House Owner Name" AssociatedControlID="txt_house_owner_name" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_house_owner_name" runat="server" CssClass="form-control" Placeholder="Enter Full Name"></asp:TextBox>
                                </div>
                                <div style="flex: 4;">
                                    <asp:Label ID="Label13" runat="server" Text="Father Name" AssociatedControlID="txt_house_father_name" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_house_father_name" runat="server" CssClass="form-control" Placeholder="Enter Father Name"></asp:TextBox>
                                </div>
                            </div>

                            <h4 class="mt-2 text-success text-center">Incident Details</h4>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="form-row">
                                        <div style="flex: 4;">
                                            <asp:Label ID="lblDistrict3" runat="server" Text="District" CssClass="form-label d-block mb-2"></asp:Label>
                                            <asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlDistrict_SelectedIndexChanged">
                                                <asp:ListItem Text="Select District" Value="0" />
                                            </asp:DropDownList>
                                        </div>
                                        <div style="flex: 4;">
                                            <asp:Label ID="lblTehsil3" runat="server" Text="Tehsil" CssClass="form-label d-block mb-2"></asp:Label>
                                            <asp:DropDownList ID="ddlTehsil" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlTehsil_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                        <div style="flex: 4;">
                                            <asp:Label ID="lblVillage3" runat="server" Text="Village" CssClass="form-label d-block mb-2"></asp:Label>
                                            <asp:DropDownList ID="ddlVillage" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlVillage_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="form-row mt-3">
                                        <div style="flex: 4;">
                                            <asp:Label ID="lblDivision3" runat="server" Text="Division" CssClass="form-label d-block mb-2"></asp:Label>
                                            <asp:DropDownList ID="ddlDivision" ReadOnly runat="server" CssClass="form-control"></asp:DropDownList>
                                        </div>
                                        <div style="flex: 4;">
                                            <asp:Label ID="lblRange3" runat="server" Text="Range" CssClass="form-label d-block mb-2"></asp:Label>
                                            <asp:DropDownList ID="ddlRange3" ReadOnly runat="server" CssClass="form-control"></asp:DropDownList>
                                        </div>
                                        <div style="flex: 4;">
                                            <asp:Label ID="lblIncidentBy" runat="server" Text="Incident Occurred By (Animal)" AssociatedControlID="ddlIncidentBy" CssClass="form-label d-block mb-2"></asp:Label>
                                            <asp:DropDownList ID="ddlIncidentBy" runat="server" CssClass="form-control" />

                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <div class="form-row mt-4">
                                <div style="flex: 3; margin-right: 10px;">
                                    <asp:Label ID="lblDateIncident" runat="server" Text="Date of Incident" AssociatedControlID="txtDateIncident" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txtDateIncident" runat="server" CssClass="form-control" TextMode="Date" required="required"></asp:TextBox>
                                </div>
                                <div style="flex: 3;">
                                    <asp:Label ID="lblTimeIncident" runat="server" Text="Time of Incident" AssociatedControlID="txtTimeIncident" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txtTimeIncident" runat="server" CssClass="form-control" TextMode="Time" required="required"></asp:TextBox>
                                </div>
                                <div style="flex: 3;" id="yes_no" runat="server" visible="false">
                                    <asp:Label ID="Label16" runat="server" Text="Whether Owner was Present at the time" AssociatedControlID="ddl_yes_no" CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddl_yes_no" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="Select" Value="" />
                                        <asp:ListItem Text="Yes" Value="1" />
                                        <asp:ListItem Text="No" Value="2" />
                                    </asp:DropDownList>
                                </div>
                                <div style="flex: 3;" id="cropdamagedname" runat="server" visible="false">
                                    <asp:Label ID="Label5" runat="server" Text="Crop Damage Name" AssociatedControlID="ddl_damage_crop" CssClass="form-label d-block mb-2"></asp:Label>
                                    <asp:DropDownList ID="ddl_damage_crop" runat="server" CssClass="form-control">
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
                                <div style="flex: 3;" id="croparea" runat="server" visible="false">
                                    <asp:Label ID="Label7" runat="server" Text="Area (in Ha)" AssociatedControlID="txt_crop_area" CssClass="form-label"></asp:Label>
                                    <asp:TextBox ID="txt_crop_area" runat="server" CssClass="form-control" Placeholder="Enter crop area in hectares"></asp:TextBox>
                                </div>
                                <div style="flex: 3;" id="incidentplace" runat="server" visible="false">
                                    <asp:Label ID="Label14" runat="server" Text="Incident Place" AssociatedControlID="ddl_incidentplace" CssClass="form-label d-block mb-2"></asp:Label>
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
                            <h4 class="mt-2">Incident Summary</h4>
                            <div class="form-row mt-2">
                                <div style="flex: 1;">
                                    <asp:Label ID="lblIncidentLocation" runat="server" Text="Incident Location on Map" CssClass="form-label"></asp:Label>
                                    <div class="d-flex" style="gap: 10px; margin-top: 5px;">
                                        <asp:TextBox ID="txtLongitude" runat="server" CssClass="form-control small-input" placeholder="Longitude"></asp:TextBox>
                                        <asp:TextBox ID="txtLatitude" runat="server" CssClass="form-control small-input" placeholder="Latitude"></asp:TextBox>
                                    </div>
                                </div>
                            </div>


                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="btn_submit_victim_incident" />
                        <asp:AsyncPostBackTrigger ControlID="ddlDistrict" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlTehsil" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlVillage" EventName="SelectedIndexChanged" />

                    </Triggers>
                </asp:UpdatePanel>


                <div class="row">
                    <!-- Left side : Incident Summary -->
                    <div class="col-md-6">
                        <asp:Label ID="lblIncidentSummary" runat="server"
                            Text="Incident Summary"
                            AssociatedControlID="txtIncidentSummary"
                            CssClass="form-label"></asp:Label>

                        <asp:TextBox ID="txtIncidentSummary" runat="server"
                            CssClass="form-control full-width"
                            TextMode="MultiLine" Rows="10"
                            placeholder="Describe the incident in detail">
                        </asp:TextBox>
                    </div>

                    <!-- Right side : Map -->
                    <div class="col-md-6">
                        <script src="../GIS/js/jquery.min.js"></script>
                        <div class="form-group">
                            <label class="form-label">
                                NOTE : Find your location and click on the map to get 'Latitude' and 'Longitude' automatically.
                            </label>
                            <div id="map" style="width: 100%; height: 310px; border: 1px solid #ccc;"></div>
                        </div>
                    </div>

                </div>






                <!-- File Upload Section (Outside UpdatePanel) -->
                <div class="info-text">
                    <asp:Label ID="lblUploadInfo" runat="server" CssClass="info-text" Text="Upload Documents (Document size should not be more than 2 MB)"></asp:Label>
                </div>








                <div class="form-row mt-5" id="humandocuments" runat="server" visible="false">
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Incident Photograph</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="incidentphotograph" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= incidentphotograph.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label18" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Applicant Application Form</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="applicantapplication" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= applicantapplication.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="lblEndorsementStatus" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Gram Panchayat Certificate</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="grampanchayatform" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= grampanchayatform.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label15" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Applicant Endorsement Application</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="EndorsementApp" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= EndorsementApp.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label17" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="form-row mt-5" id="cropdamagedocument" runat="server" visible="false">
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Incident Photograph</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="cropdamage_incidentphotograph" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= cropdamage_incidentphotograph.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label19" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Applicant Application Form</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="cropdamage_applicantform" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= cropdamage_applicantform.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label20" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Lekhpal/Patwari Certificate</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="cropdamage_lekhpal" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= cropdamage_lekhpal.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label21" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="flex: 1;">
                        <div class="upload-item">
                            <label class="upload-label">Applicant Endorsement Application</label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="cropdamage_applicantendorsemet" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= cropdamage_applicantendorsemet.ClientID %>" class="file-upload-label">
                                    <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                                </label>
                                <small class="file-info">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label22" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                </div>
                <!-- Submit Button -->
                <div class="form-row" style="justify-content: center;">
                    <asp:Button ID="btn_submit_victim_incident" runat="server" Text="Submit" CssClass="submit-btn" OnClick="btn_submit_victim_incident_Click" />
                </div>
            </div>
        </div>
    </div>
    <!-- Preview Modal -->
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

    const statusLabels = {
        '<%= incidentphotograph.ClientID %>': '<%= Label18.ClientID %>',
        '<%= applicantapplication.ClientID %>': '<%= lblEndorsementStatus.ClientID %>',
        '<%= grampanchayatform.ClientID %>': '<%= Label15.ClientID %>',
        '<%= EndorsementApp.ClientID %>': '<%= Label17.ClientID %>',
        '<%= cropdamage_incidentphotograph.ClientID %>': '<%= Label19.ClientID %>',
        '<%= cropdamage_applicantform.ClientID %>': '<%= Label20.ClientID %>',
        '<%= cropdamage_lekhpal.ClientID %>': '<%= Label21.ClientID %>',
        '<%= cropdamage_applicantendorsemet.ClientID %>': '<%= Label22.ClientID %>'
    };

    fileUploads.forEach(uploadId => {
        const upload = document.getElementById(uploadId);
        if (!upload) return; // Skip if element doesn't exist

        const wrapper = upload.closest('.file-upload-wrapper');
        if (!wrapper) return;

        const statusLabelId = statusLabels[uploadId];
        const statusLabel = statusLabelId ? document.getElementById(statusLabelId) : null;

        // File selection
        upload.addEventListener('change', function (e) {
            const file = e.target.files[0];
            if (file) handleFile(file, upload, statusLabel, wrapper);
        });

        // Drag & Drop
        wrapper.addEventListener('dragover', e => { e.preventDefault(); wrapper.classList.add('dragover'); });
        wrapper.addEventListener('dragleave', e => { e.preventDefault(); wrapper.classList.remove('dragover'); });
        wrapper.addEventListener('drop', e => {
            e.preventDefault();
            wrapper.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                upload.files = files;
                handleFile(files[0], upload, statusLabel, wrapper);
            }
        });
    });

    function handleFile(file, upload, statusLabel, wrapper) {
        const maxSize = 2 * 1024 * 1024; // 2MB
        const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf'];

        if (file.size > maxSize || !allowedTypes.includes(file.type)) {
            showFileStatus(statusLabel, !allowedTypes.includes(file.type) ?
                'Only JPG, PNG, and PDF files are allowed' : 'File size exceeds 2MB limit', 'error');
            upload.value = '';
            return;
        }

        showFileStatus(statusLabel, `File uploaded: ${file.name} (${(file.size / 1024).toFixed(1)} KB)`, 'success');
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

        //window.onload = function () {

        //    map.addOverlay(district_layer);
        //    map.addLayer(district_layer);


        //}
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

            // Click event for map
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

        // Initialize map when page loads
        document.addEventListener("DOMContentLoaded", function () {
            initializeMap();
        });

        // Reinitialize map after ASP.NET AJAX postbacks
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            initializeMap();
        });
    </script>



    <%-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer">--%>



    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

</asp:Content>

