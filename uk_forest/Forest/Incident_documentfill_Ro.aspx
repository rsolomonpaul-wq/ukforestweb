<%@ Page Language="C#" Async="true" AutoEventWireup="true" MasterPageFile="~/Forest/forestmaster.Master" CodeBehind="Incident_documentfill_Ro.aspx.cs" Inherits="uk_forest.Forest.Incident_documentfill_Ro" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

   <script type="text/javascript">
       function showPanelDocument(incidentId, claimCategory) {
           // Set the incident ID in the hidden field
           document.getElementById('<%= hdnSelectedIncidentId.ClientID %>').value = incidentId;

           // Update the Incident ID label in the popup
           document.getElementById('<%= labelIncidentID.ClientID %>').innerText = "Incident ID: " + incidentId;

           // Update the Claim Category label in the popup
           document.getElementById('<%= labelClaimCategory.ClientID %>').innerText = "Claim Category: " + claimCategory;

           // Hide all document sections
           document.getElementById('<%= humandocuments.ClientID %>').style.display = 'none';
           document.getElementById('<%= cattledocument.ClientID %>').style.display = 'none';
           document.getElementById('<%= cropdamagedocuments.ClientID %>').style.display = 'none';
           document.getElementById('<%= housedamagedocument.ClientID %>').style.display = 'none';

           // Show the relevant document section based on claimCategory
           switch (claimCategory) {
               case "Human":
                   document.getElementById('<%= humandocuments.ClientID %>').style.display = 'flex';
                    break;
                case "Cattle":
                    document.getElementById('<%= cattledocument.ClientID %>').style.display = 'flex';
                    break;
                case "CropField":
                    document.getElementById('<%= cropdamagedocuments.ClientID %>').style.display = 'flex';
                    break;
                case "House":
                    document.getElementById('<%= housedamagedocument.ClientID %>').style.display = 'flex';
                   break;
               default:
                   console.log("Unknown claim category: " + claimCategory);
                   break;
           }

           // Show the panel
           document.getElementById('<%= PanelDocument.ClientID %>').style.display = "flex";
       }

       function hidePopup() {
           document.getElementById('<%= PanelDocument.ClientID %>').style.display = "none";
       }
    </script>
    <style>
        .btn-disabled {
            pointer-events: none; /* prevent clicking */
            opacity: 0.5; /* make it look faded */
            background: linear-gradient(135deg,#cccccc 0%,#999999 100%);
            color: #fff !important;
            border: 1px solid #999999;
            cursor: not-allowed;
        }

        /* Overlay panel */
        .popup-panel {
            display: none; /* hidden by default */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            /*height: 100%;*/
            background-color: rgba(0,0,0,0.6);
            justify-content: center;
            align-items: center;
            z-index: 99999;
            overflow-y: auto;
            padding: 20px;
        }

        /* Popup container */
        .popup-content {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            width: 90%;
            max-width: 700px;
            animation: fadeIn 0.3s ease-out;
            padding: 25px 30px;
        }

        /* Header */
        .popup-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .popup-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #333;
        }

        .popup-close {
            background: transparent;
            border: none;
            font-size: 1.3rem;
            cursor: pointer;
            color: #888;
            transition: color 0.2s;
        }

            .popup-close:hover {
                color: #ff4d4d;
            }

        /* Sections */
        .section-title {
            font-size: 1.2rem;
            font-weight: 500;
            margin-bottom: 12px;
            color: #555;
            border-bottom: 1px solid #eee;
            padding-bottom: 4px;
        }

        /* Incident Details */
        .details-container .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 10px;
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.2s;
        }

            .details-container .detail-row:hover {
                background: #f9f9f9;
            }

        .field-name {
            font-weight: 500;
            color: #333;
        }

        .field-value {
            color: #555;
        }

        /* Documents */
        .documents-container {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .document-row {
            display: flex;
            align-items: center;
            padding: 6px 10px;
            border-radius: 6px;
            transition: background 0.2s;
        }

            .document-row:hover {
                background-color: #f5f5f5;
            }

        .document-icon {
            font-size: 1.2rem;
            margin-right: 10px;
            color: #007bff;
        }

        .document-link {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

            .document-link:hover {
                color: #0056b3;
                text-decoration: underline;
            }

        /* Base button styling */

        .close-btn {
            position: absolute;
            right: 10px;
            top: -5px;
            font-size: 26px;
            font-weight: bold;
            color: #666;
            text-decoration: none;
            cursor: pointer;
        }

            .close-btn:hover {
                color: #ff0000;
            }


        .container.divtab {
            border: 2px solid #43a047;
            padding: 0 0px 61px 0;
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
                background-color: #006400; /* dark green on hover */
            }

        .form-row.mt-4 {
            border: 2px solid #23a510;
            padding: 15px;
            border-radius: 11px;
        }

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

        .incident-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

            .incident-table th {
                color: black;
                padding: 12px 15px;
                text-align: left;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.85rem;
                border: 1px #000 solid;
            }

            .incident-table td {
                padding: 10px 15px;
                border-bottom: 1px solid #e0e0e0;
                vertical-align: middle;
            }

            .incident-table tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .incident-table tr:hover {
                background-color: #f1f5fd;
                transition: background 0.3s ease;
            }

        .form-control:focus {
            border-color: #23a510;
            box-shadow: 0 0 0 0.2rem rgba(35, 165, 16, 0.25);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(40, 167, 69, 0.4);
        }

        .form-label {
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .col-md-4 {
                margin-bottom: 1rem;
            }
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
            width: 100%; /* fixed width hata ke responsive */
            max-width: 700px; /* optional max width */
            margin: 0 auto; /* center align */
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
            pointer-events: none; /* click is handled by invisible input */
        }

        .file-upload-wrapper:hover .file-upload-label {
            color: #23a510;
        }


        .file-upload-label i {
            font-size: 2rem;
            color: #adb5bd;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="grid_item">
        <div class="container divtab">
            <div class="tab-content-wrapper">
                <div class="form-container">
                    <fieldset class="radio-group" style="border: 2px solid #23a510; padding: 15px; border-radius: 10px;">
                        <legend style="font-weight: bold; color: #333; margin-bottom: 10px; text-align: center; width: auto; margin-left: auto; margin-right: auto;">
                            <asp:Label ID="lblClaimType" runat="server" Text="Select Claim Category"></asp:Label>
                        </legend>

                        <div class="d-flex flex-wrap justify-content-center" style="gap: 20px;">
                            <asp:RadioButtonList ID="rblClaimType" runat="server" RepeatDirection="Horizontal" CssClass="claim-radio-list" RepeatLayout="Flow" OnSelectedIndexChanged="rblClaimType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Text="Human Death / Injury" Value="Human" />
                                <asp:ListItem Text="Crop Damage" Value="CropField" />
                                <asp:ListItem Text="Cattle Kill" Value="Cattle" />
                                <asp:ListItem Text="Property Damage" Value="House" />
                            </asp:RadioButtonList>
                        </div>

                        <div class="mt-4 border-top pt-3" style="border-top: 1px solid #dee2e6 !important;">
                            <div class="row justify-content-center">
                                <div class="col-md-8">
                                    <div class="row align-items-end g-3">
                                        <div class="col-md-4">
                                            <label for="txtFromDate" class="form-label fw-semibold text-dark">From Date</label>
                                            <asp:TextBox ID="txtFromDate" runat="server"
                                                TextMode="Date"
                                                CssClass="form-control border-success"
                                                Style="border-width: 1.5px;">
                                            </asp:TextBox>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="txtToDate" class="form-label fw-semibold text-dark">To Date</label>
                                            <asp:TextBox ID="txtToDate" runat="server"
                                                TextMode="Date"
                                                CssClass="form-control border-success"
                                                Style="border-width: 1.5px;">
                                            </asp:TextBox>
                                        </div>
                                        <div class="col-md-4 d-grid">
                                            <asp:Button ID="btnSearch" runat="server"
                                                Text="🔍 Search"
                                                ToolTip="Click here to search for claims"
                                                CssClass="btn btn-success btn-lg fw-bold"
                                                OnClick="btnSearch_Click"
                                                Style="background: linear-gradient(135deg, #28a745, #20c997); border: none; border-radius: 8px; box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3); transition: all 0.3s ease;"
                                                onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 12px rgba(40, 167, 69, 0.4)';"
                                                onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 8px rgba(40, 167, 69, 0.3)';" />
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </fieldset>


                    <div class="form-row mt-4">
                        <div class="table-responsive">
                              <asp:HiddenField ID="hdnVictimId" runat="server" />
                            <asp:HiddenField ID="hdnIncidentId" runat="server" />
                            <asp:Label ID="label13" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="label14" runat="server" Visible="false"></asp:Label>
                            <asp:HiddenField ID="hdnSelectedIncidentId" runat="server" />
                            <asp:Label ID="lbl_msg_alert" runat="server" CssClass="alert alert-danger p-2 mb-0" Visible="false"></asp:Label>
                            <asp:GridView ID="gv_incident_list" runat="server" AutoGenerateColumns="false" OnRowDataBound="gv_incident_list_RowDataBound" CssClass="incident-table" AllowPaging="true" PageSize="50" DataKeyNames="incidentId" EmptyDataText="No incidents found!" OnPageIndexChanging="gv_incident_list_PageIndexChanging">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Incident Id">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_incidentId" runat="server" Text='<%# Eval("incidentId") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Victim ID">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_victimId" runat="server" Text='<%# Eval("victimId") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Claim Category">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_claimCategory" runat="server" Text='<%# Eval("claimCategory") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Victim Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_name" runat="server" Text='<%# Eval("fullName") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Applicant Id" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_ApplicantId" runat="server" Text='<%# Eval("applicantId") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Incident Date">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_incidentDate" runat="server" Text='<%# Eval("incidentDate","{0:yyyy-MM-dd}") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Incident Time (24 Hrs.)">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_incidentTime" runat="server" Text='<%# Eval("incidentTime") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Caused By">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_killed_by" runat="server" Text='<%# Eval("animalName") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_Status" runat="server" Text='<%# Eval("status") ?? "NA" %>' ForeColor="Red">
                                            </asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                   
                                   <asp:TemplateField HeaderText="Upload Documents">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkuploaddocument" runat="server"
                                                Text="Upload Documents"
                                                OnClick="lnkuploaddocument_Click"
                                                Style="display: inline-block; padding: 10px 20px; border-radius: 25px; text-decoration: none; color: white; font-weight: 600; font-size: 14px; border: 1px solid #007bff; background: linear-gradient(135deg,#007bff 0%,#0056b3 100%); cursor: pointer; transition: all 0.3s ease; text-align: center; min-width: 120px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>

                                <PagerStyle CssClass="pagination-grid" />
                            </asp:GridView>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script type="text/javascript"> function showPanelDocument() { document.getElementById('<%= PanelDocument.ClientID %>').style.display = "flex"; } function hidePopup() { document.getElementById('<%= PanelDocument.ClientID %>').style.display = "none"; } </script>
    
     <asp:Panel ID="PanelDocument" runat="server" CssClass="popup-panel" Style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: none; justify-content: center; align-items: center; z-index: 9999; overflow-y: auto; padding: 10px;">
        <div class="popup-content" style="background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.3); width: 100%; max-width: 600px; margin: auto; padding: 15px; display: flex; flex-direction: column;">
            <!-- Header -->
            <div class="popup-header" style="display: flex; justify-content: space-between; align-items: center; padding: 10px 15px; background-color: #f8f9fa; border-radius: 8px 8px 0 0;">
                <span class="popup-title" style="font-weight: bold; font-size: 1.1rem; color: #333;">Documents Details</span>
                <button type="button" class="popup-close" onclick="hidePopup()" style="background: none; border: none; font-size: 1.3rem; cursor: pointer; color: #555;" onmouseover="this.style.color='#d9534f';" onmouseout="this.style.color='#555';">✖</button>
            </div>
            <hr style="margin: 8px 0; border: 0; border-top: 1px solid #ddd;" />
            <!-- Body -->
            <div class="popup-body" style="max-height: 70vh; overflow-y: auto; padding: 5px 10px;">
                <asp:Label ID="Label1" runat="server" CssClass="details-label"></asp:Label>
                <!-- Labels for Claim Category & Incident ID -->
                <div class="popup-labels" style="display: flex; justify-content: space-between; padding: 5px 15px; background-color: #f1f1f1;">
                    <asp:Label ID="labelClaimCategory" runat="server" Text="Claim Category: -" CssClass="claim-info" Style="font-weight: 500; color: #555;"></asp:Label>
                    <asp:Label ID="labelIncidentID" runat="server" Text="Incident ID: -" CssClass="claim-info" Style="font-weight: 500; color: #555;"></asp:Label>
                </div>
                <!--Human Documents -->
                <div class="form-row mt-5" id="humandocuments" runat="server" style="display: flex; flex-direction: column; gap: 15px;" visible="false">
                    <!-- Medical Certificate/Post-mortem -->
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Medical Certificate/Post-mortem Report</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="MedicalCertificate" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= MedicalCertificate.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label2" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <!-- Death Certificate -->
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Death Certificate</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="DeathCertificate" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= DeathCertificate.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label3" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <!-- Legal Heir Certificate -->
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Legal Heir Certificate</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="LegalHeirCertificate" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= LegalHeirCertificate.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label4" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <!-- Additional Photographs -->
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Additional Photographs</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="AdditionalPhotographs" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= AdditionalPhotographs.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label5" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <!-- Center Button -->
                    <div style="text-align: center; margin-top: 15px;">
                        <asp:Button ID="btnHumanDocumentsSave" runat="server" OnClick="btnHumanDocumentsSave_Click" Text="Save Human Documents" CssClass="btn btn-success" Style="padding: 8px 20px; border-radius: 6px; font-weight: 500; font-size: 1rem; cursor: pointer;" />
                    </div>
                </div>



                <!--cattle Documents -->
                <div class="form-row mt-5" id="cattledocument" runat="server" style="display: flex; flex-direction: column; gap: 15px;" visible="false">
                    <!-- Veterinary Officer -->
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Veterinary Officer's medical/Death certificate</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="VeterinaryOfficer" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= VeterinaryOfficer.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label6" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <!-- Panchnama -->
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Panchnama</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="Panchnama" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= Panchnama.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label7" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <!-- Additional Photographs -->
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Additional Photographs</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="cattleAdditionalPhotographs" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= cattleAdditionalPhotographs.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label8" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <!-- Center Button -->
                    <div style="text-align: center; margin-top: 15px;">
                        <asp:Button ID="btnCattleDocumentsSave" runat="server" OnClick="btnCattleDocumentsSave_Click1" Text="Save cattle Documents" CssClass="btn btn-success" Style="padding: 8px 20px; border-radius: 6px; font-weight: 500; font-size: 1rem; cursor: pointer;" />
                    </div>
                </div>
                <!--Crop Damage Documents -->
                <div class="form-row mt-5" id="cropdamagedocuments" runat="server" style="display: flex; flex-direction: column; gap: 15px;" visible="false">
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Khata Khatoni</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="khatakhatoni" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= khatakhatoni.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label9" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Additional Photographs</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="khatakhatoniAdditionalPhotographs" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= khatakhatoniAdditionalPhotographs.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label10" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="text-align: center; margin-top: 15px;">
                        <asp:Button ID="btn_add_crop_damage_dcoument" runat="server" Text="Save Crop Damage" OnClick="btn_add_crop_damage_dcoument_Click" CssClass="btn btn-success" Style="padding: 8px 20px; border-radius: 6px; font-weight: 500; font-size: 1rem; cursor: pointer;" />
                    </div>
                </div>
                <!--House Damage Documents -->
                <div class="form-row mt-5" id="housedamagedocument" runat="server" style="display: flex; flex-direction: column; gap: 15px;" visible="false">
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Khata Khatoni / Property Documents</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="khatakhatoniHousepropertyAdditionalPhotographs" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= khatakhatoniHousepropertyAdditionalPhotographs.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label11" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="width: 100%;">
                        <div class="upload-item">
                            <label class="upload-label" style="font-weight: 500; margin-bottom: 5px;">Additional Photographs</label>
                            <div class="file-upload-wrapper" style="display: flex; flex-direction: column;">
                                <asp:FileUpload ID="khatakhatoniHouseAdditionalPhotographs" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png,.pdf" />
                                <label for="<%= khatakhatoniHouseAdditionalPhotographs.ClientID %>" class="file-upload-label" style="margin-top: 5px; cursor: pointer; color: #0d6efd; font-size: 0.9rem;"><i class="fas fa-cloud-upload-alt"></i>Upload Document Here </label>
                                <small class="file-info" style="color: #6c757d; font-size: 0.8rem;">Max size: 2MB | Formats: JPG, PNG, PDF</small>
                            </div>
                            <asp:Label ID="Label12" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="text-align: center; margin-top: 15px;">
                        <asp:Button ID="btn_add_damegehouse_document" runat="server" OnClick="btn_add_damegehouse_document_Click" Text="Save House Damage Documents" CssClass="btn btn-success" Style="padding: 8px 20px; border-radius: 6px; font-weight: 500; font-size: 1rem; cursor: pointer;" />
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>

