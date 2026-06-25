<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="incident_approval_detail.aspx.cs" Inherits="uk_forest.Forest.incident_approval_detail" ClientIDMode="Static" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
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

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
            color: white;
            border-radius: 10px 10px 0 0 !important;
            padding: 15px 20px;
        }

            .card-header h3 {
                margin: 0;
                font-weight: 700;
                letter-spacing: 1px;
            }

        .ddl-with-icon {
            border: 1px solid #ced4da;
            border-radius: 4px;
            padding: 6px 12px;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

            .ddl-with-icon:hover {
                border-color: #80bdff;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }

        .popup-panel {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 10px;
            padding: 20px;
            z-index: 1050;
            width: 90%;
            max-width: 1000px;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 5px 30px rgba(0, 0, 0, 0.3);
            animation: fadeIn 0.3s ease;
        }

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1040;
        }

        .btn-close-popup {
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 6px 12px;
            float: right;
            margin-bottom: 15px;
        }

            .btn-close-popup:hover {
                background: #c0392b;
            }

        .popup-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background: linear-gradient(135deg, #2c3e50 0%, #4a6491 100%);
            color: white;
            border-radius: 8px 8px 0 0;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .popup-title {
            margin: 0;
            font-size: 1.25rem;
            font-weight: 600;
        }

        .close-btn {
            background: none;
            border: none;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
            padding: 0 10px;
        }

        .popup-content {
            padding: 20px;
        }

        .detail-section {
            margin-bottom: 20px;
        }

        .section-header {
            padding: 8px 12px;
            background-color: #f8f9fa;
            border-left: 4px solid #3498db;
            margin-bottom: 15px;
        }

            .section-header h5 {
                margin: 0;
                font-size: 1rem;
                color: #2c3e50;
            }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 12px;
        }

        .detail-row {
            display: flex;
            margin-bottom: 8px;
        }

        .detail-label {
            font-weight: 600;
            color: #555;
            min-width: 150px;
            padding-right: 10px;
        }

        .detail-value {
            flex: 1;
            color: #333;
        }

        .summary-box {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            border-left: 3px solid #3498db;
            margin-bottom: 15px;
        }

        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }

        .document-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
        }

            .document-link:hover {
                text-decoration: underline;
            }

        .map-link {
            color: #e74c3c;
            margin-left: 8px;
        }

        .table-hyperlink {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
        }

            .table-hyperlink:hover {
                text-decoration: underline;
                color: #2874a6;
            }

        @media (max-width: 768px) {
            .popup-panel {
                width: 95%;
                padding: 15px;
            }

            .detail-grid {
                grid-template-columns: 1fr;
            }

            .detail-row {
                flex-direction: column;
            }

            .detail-label {
                margin-bottom: 4px;
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translate(-50%, -40%);
            }

            to {
                opacity: 1;
                transform: translate(-50%, -50%);
            }
        }

        .document-checkbox {
            margin-left: 5px;
        }

            .document-checkbox input[type="checkbox"] {
                margin-right: 5px;
            }

        .img-border-black {
            border: 1px solid #000 !important;
        }

        label {
            margin-left: 10px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePannel1" runat="server">
        <ContentTemplate>
            <div class="card mb-4">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3><i class="fas fa-list-alt mr-2"></i>Incident List</h3>
                        <asp:Label ID="lbl_msg_alert" runat="server" CssClass="alert alert-danger p-2 mb-0" Visible="false"></asp:Label>
                    </div>
                </div>

                <div class="card-body">
                    <div class="form-group">
                        <label class="font-weight-bold mb-2">Approval Status:</label>
                        <asp:RadioButtonList ID="rblApprovalStatus" runat="server" AutoPostBack="true"
                            RepeatDirection="Horizontal" RepeatLayout="Flow"
                            CssClass="d-flex gap-4 flex-wrap"
                            OnSelectedIndexChanged="rblApprovalStatus_SelectedIndexChanged">
                            <asp:ListItem Text="Pending" Value="Pending" Selected="True" />
                            <asp:ListItem Text="Approved by RO" Value="ApprovedByRO" />
                            <asp:ListItem Text="Approved by SDO" Value="ApprovedBySDO" />
                            <asp:ListItem Text="Approved by DFO" Value="ApprovedByDFO" />
                        </asp:RadioButtonList>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive p-3">
                        <asp:GridView ID="gv_incident_list" runat="server" AutoGenerateColumns="false"
                            CssClass="incident-table" AllowPaging="true" PageSize="50" DataKeyNames="IncidentId"
                            EmptyDataText="No incidents found!" OnPageIndexChanging="gv_incident_list_PageIndexChanging">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Victim Incident Id">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_incidentId" runat="server" Text='<%# Eval("IncidentId") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_name" runat="server"
                                            Text='<%# Eval("Name") != null ? Eval("Name") : "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Victim Profile Id" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_victimProfileId" runat="server"
                                            Text='<%# Eval("VictimProfileId") != null ? Eval("VictimProfileId") : "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Applicant Id" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_ApplicantId" runat="server"
                                            Text='<%# Eval("ApplicantId") != null ? Eval("ApplicantId") : "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Incident Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_incidentDate" runat="server"
                                            Text='<%# Eval("IncidentDate") != null ? Eval("IncidentDate") : "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Incident Time">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_incidentTime" runat="server"
                                            Text='<%# Eval("IncidentTime") != null ? Eval("IncidentTime") : "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Incident Place">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_incident_place" runat="server"
                                            Text='<%# Eval("IncidentPlace") != null ? Eval("IncidentPlace") : "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Caused By">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_killed_by" runat="server"
                                            Text='<%# Eval("AnimalName") != null ? Eval("AnimalName") : "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Activity">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_activity" runat="server"
                                            Text='<%# Eval("Activity") != null ? Eval("Activity") : "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Human Loss">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_human_loss" runat="server"
                                            Text='<%# Eval("HumanLoss") != null ? Eval("HumanLoss") : "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Action" ItemStyle-Width="150px" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddl_status_approved" runat="server"
                                            CssClass="ddl-with-icon form-control-sm"
                                            AutoPostBack="true"
                                            OnSelectedIndexChanged="ddl_status_approved_SelectedIndexChanged">
                                            <asp:ListItem Value="" Text="-- Action --"></asp:ListItem>
                                            <asp:ListItem Value="View" Text="View Details"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagination-grid" />
                        </asp:GridView>
                    </div>
                </div>
            </div>



            <!-- Popup Panel (Modernized) -->
            <asp:Panel ID="pnlPopup" runat="server" CssClass="popup-panel">
                <div class="popup-header">
                    <h4 class="popup-title">
                        <i class="fas fa-info-circle mr-2"></i>View Incident Details
                    </h4>
                    <asp:Button ID="btnClosePopup" runat="server" Text="×" CssClass="close-btn" OnClick="btnClosePopup_Click" />
                </div>

                <div class="popup-content">
                    <asp:Repeater ID="rptIncidentDetails" runat="server" OnItemDataBound="rptIncidentDetails_ItemDataBound">
                        <ItemTemplate>
                            <div class="detail-section">
                                <div class="section-header">
                                    <h5><i class="fas fa-user-circle mr-2"></i>Victim Information</h5>
                                </div>
                                <div class="detail-grid">
                                    <div class="detail-row">
                                        <div class="detail-label">Victim Profile ID:</div>
                                        <div class="detail-value"><%# Eval("victimProfileId") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Name:</div>
                                        <div class="detail-value"><%# Eval("name") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Age:</div>
                                        <div class="detail-value"><%# Eval("age") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Gender:</div>
                                        <div class="detail-value"><%# Eval("gender") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Aadhar No:</div>
                                        <div class="detail-value"><%# Eval("aadharNo") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Aadhar Document:</div>
                                        <div class="detail-value">
                                            <asp:HyperLink ID="hlAadharDoc" runat="server"
                                                Text='<%# string.IsNullOrEmpty(Eval("aadharDoc")?.ToString()) ? "N/A" : "View Document" %>'
                                                NavigateUrl='<%# !string.IsNullOrEmpty(Eval("aadharDoc")?.ToString()) ? HostUrl + Eval("aadharDoc") : "#" %>'
                                                Target="_blank"
                                                CssClass="document-link" />
                                        </div>
                                    </div>
                                </div>

                                <div class="section-header mt-4">
                                    <h5><i class="fas fa-exclamation-triangle mr-2"></i>Incident Information</h5>
                                </div>
                                <div class="detail-grid">
                                    <div class="detail-row">
                                        <div class="detail-label">Incident ID:</div>
                                        <div class="detail-value"><%# Eval("incidentId") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Applicant ID:</div>
                                        <div class="detail-value"><%# Eval("applicantId") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Applicant Name:</div>
                                        <div class="detail-value"><%# Eval("applicantName") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Incident Date:</div>
                                        <div class="detail-value"><%# Convert.ToDateTime(Eval("incidentDate")).ToString("dd-MM-yyyy") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Incident Time:</div>
                                        <div class="detail-value"><%# Eval("incidentTime") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Incident Place:</div>
                                        <div class="detail-value"><%# Eval("incidentPlace") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Caused By:</div>
                                        <div class="detail-value"><%# Eval("animalName") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Activity:</div>
                                        <div class="detail-value"><%# Eval("activity") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Coordinates:</div>
                                        <div class="detail-value">
                                            <%# Eval("latitude") %>, <%# Eval("longitude") %>
                                            <a href='https://maps.google.com/?q=<%# Eval("latitude") %>,<%# Eval("longitude") %>'
                                                target="_blank" class="map-link" title="View on map">
                                                <i class="fas fa-map-marker-alt"></i>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Status:</div>
                                        <div class="detail-value status-badge <%# GetStatusClass(Eval("status").ToString()) %>">
                                            <%# Eval("status") %>
                                        </div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Range:</div>
                                        <div class="detail-value"><%# Eval("rangeName") %></div>
                                    </div>

                                    <div class="detail-row">
                                        <div class="detail-label">Human Loss:</div>
                                        <div class="detail-value"><%# Eval("humanLoss") %></div>
                                    </div>
                                </div>

                                <div class="section-header mt-4">
                                    <h5><i class="fas fa-file-alt mr-2"></i>Incident Summary</h5>
                                </div>
                                <div class="summary-box">
                                    <%# Eval("incidentSummary") %>
                                </div>

                                <div class="section-header mt-4">
                                    <h5><i class="fas fa-paperclip mr-2"></i>Attachments</h5>
                                </div>
                                <asp:Repeater ID="rptDocuments" runat="server">
                                    <ItemTemplate>
                                        <div class="attachments-grid" style="margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                                            <div class="detail-row">
                                                <div class="detail-label">Document Name:</div>
                                                <div class="detail-value"><%# Eval("documentName") %></div>
                                            </div>
                                            <div class="detail-row">
                                                <div class="detail-label">File:</div>
                                                <div class="detail-value">
                                                    <asp:HyperLink ID="hlFilePath" runat="server"
                                                        Text='<%# string.IsNullOrEmpty(Eval("FilePath")?.ToString()) ? "N/A" : "Download File" %>'
                                                        NavigateUrl='<%# Eval("FullUrl") %>'
                                                        Target="_blank"
                                                        CssClass="document-link" />
                                                    <br />

                                                    <asp:Image ID="imgThumbnail" runat="server" Visible='<%# IsImageFile(Eval("FilePath")?.ToString()) %>' ImageUrl='<%# Eval("FullUrl") %>' Width="100px" Height="100px" Style="margin-top: 5px; border: 1px solid #ddd; padding: 2px;" />
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:Panel>
       

        </ContentTemplate>
        
    </asp:UpdatePanel>



       <asp:Panel ID="Panel1" runat="server" CssClass="popup-panel">
                <div class="popup-header">
                    <h4 class="popup-title">
                        <i class="fas fa-info-circle mr-2"></i>View Incident Details
                    </h4>
                    <asp:Button ID="Button1" runat="server" Text="×" CssClass="close-btn" OnClick="btnClosePopup_Click" />
                </div>

                <div class="popup-content">
                    <asp:Repeater ID="Repeater1" runat="server" OnItemDataBound="rptIncidentDetails_ItemDataBound">
                        <ItemTemplate>
                            <div class="detail-section">
                                <div class="section-header">
                                    <h5><i class="fas fa-user-circle mr-2"></i>Victim Information</h5>
                                </div>
                                <div class="detail-grid">
                                    <div class="detail-row">
                                        <div class="detail-label">Victim Profile ID:</div>
                                        <div class="detail-value"><%# Eval("victimProfileId") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Name:</div>
                                        <div class="detail-value"><%# Eval("name") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Age:</div>
                                        <div class="detail-value"><%# Eval("age") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Gender:</div>
                                        <div class="detail-value"><%# Eval("gender") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Aadhar No:</div>
                                        <div class="detail-value"><%# Eval("aadharNo") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Aadhar Document:</div>
                                        <div class="detail-value">
                                            <asp:HyperLink ID="hlAadharDoc" runat="server"
                                                Text='<%# string.IsNullOrEmpty(Eval("aadharDoc")?.ToString()) ? "N/A" : "View Document" %>'
                                                NavigateUrl='<%# !string.IsNullOrEmpty(Eval("aadharDoc")?.ToString()) ? HostUrl + Eval("aadharDoc") : "#" %>'
                                                Target="_blank"
                                                CssClass="document-link" />
                                        </div>
                                    </div>
                                </div>

                                <div class="section-header mt-4">
                                    <h5><i class="fas fa-exclamation-triangle mr-2"></i>Incident Information</h5>
                                </div>
                                <div class="detail-grid">
                                    <div class="detail-row">
                                        <div class="detail-label">Incident ID:</div>
                                        <div class="detail-value"><%# Eval("incidentId") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Applicant ID:</div>
                                        <div class="detail-value"><%# Eval("applicantId") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Applicant Name:</div>
                                        <div class="detail-value"><%# Eval("applicantName") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Incident Date:</div>
                                        <div class="detail-value"><%# Convert.ToDateTime(Eval("incidentDate")).ToString("dd-MM-yyyy") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Incident Time:</div>
                                        <div class="detail-value"><%# Eval("incidentTime") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Incident Place:</div>
                                        <div class="detail-value"><%# Eval("incidentPlace") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Caused By:</div>
                                        <div class="detail-value"><%# Eval("animalName") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Activity:</div>
                                        <div class="detail-value"><%# Eval("activity") %></div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Coordinates:</div>
                                        <div class="detail-value">
                                            <%# Eval("latitude") %>, <%# Eval("longitude") %>
                                            <a href='https://maps.google.com/?q=<%# Eval("latitude") %>,<%# Eval("longitude") %>'
                                                target="_blank" class="map-link" title="View on map">
                                                <i class="fas fa-map-marker-alt"></i>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Status:</div>
                                        <div class="detail-value status-badge <%# GetStatusClass(Eval("status").ToString()) %>">
                                            <%# Eval("status") %>
                                        </div>
                                    </div>
                                    <div class="detail-row">
                                        <div class="detail-label">Range:</div>
                                        <div class="detail-value"><%# Eval("rangeName") %></div>
                                    </div>

                                    <div class="detail-row">
                                        <div class="detail-label">Human Loss:</div>
                                        <div class="detail-value"><%# Eval("humanLoss") %></div>
                                    </div>
                                </div>

                                <div class="section-header mt-4">
                                    <h5><i class="fas fa-file-alt mr-2"></i>Incident Summary</h5>
                                </div>
                                <div class="summary-box">
                                    <%# Eval("incidentSummary") %>
                                </div>

                                <div class="section-header mt-4">
                                    <h5><i class="fas fa-paperclip mr-2"></i>Attachments</h5>
                                </div>
                                <asp:Repeater ID="rptDocuments" runat="server">
                                    <ItemTemplate>
                                        <div class="attachments-grid" style="margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                                            <div class="detail-row">
                                                <div class="detail-label">Document Name:</div>
                                                <div class="detail-value"><%# Eval("documentName") %></div>
                                            </div>
                                            <div class="detail-row">
                                                <div class="detail-label">File:</div>
                                                <div class="detail-value">
                                                    <asp:HyperLink ID="hlFilePath" runat="server"
                                                        Text='<%# string.IsNullOrEmpty(Eval("FilePath")?.ToString()) ? "N/A" : "Download File" %>'
                                                        NavigateUrl='<%# Eval("FullUrl") %>'
                                                        Target="_blank"
                                                        CssClass="document-link" />
                                                    <br />

                                                    <asp:Image ID="imgThumbnail" runat="server" Visible='<%# IsImageFile(Eval("FilePath")?.ToString()) %>' ImageUrl='<%# Eval("FullUrl") %>' Width="100px" Height="100px" Style="margin-top: 5px; border: 1px solid #ddd; padding: 2px;" />
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnlOverlay" runat="server" CssClass="overlay"></asp:Panel>




    <style>
        /* Success Animation */
        .success-animation {
            margin: 0 auto;
            width: 80px;
            height: 80px;
        }

        .checkmark {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: block;
            stroke-width: 4;
            stroke: #4bb543;
            stroke-miterlimit: 10;
            animation: fill 0.4s ease-in-out 0.4s forwards, scale 0.3s ease-in-out 0.9s both;
        }

        .checkmark__circle {
            stroke-dasharray: 166;
            stroke-dashoffset: 166;
            stroke-width: 4;
            stroke-miterlimit: 10;
            stroke: #4bb543;
            fill: none;
            animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
        }

        .checkmark__check {
            transform-origin: 50% 50%;
            stroke-dasharray: 48;
            stroke-dashoffset: 48;
            animation: stroke 0.3s cubic-bezier(0.65, 0, 0.45, 1) 0.8s forwards;
        }

        @keyframes stroke {
            100% {
                stroke-dashoffset: 0;
            }
        }

        @keyframes scale {
            0%, 100% {
                transform: none;
            }

            50% {
                transform: scale3d(1.1, 1.1, 1);
            }
        }

        @keyframes fill {
            100% {
                box-shadow: inset 0 0 0 100px rgba(75, 181, 67, 0.1);
            }
        }

        /* Success Message Styling */
        .text-success {
            color: #28a745 !important;
            font-weight: 600;
        }

        .success-message {
            font-size: 1.2rem;
            margin-top: 15px;
        }
    </style>

    <script>
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            // Allow: 0-9, Backspace, Delete, Tab, Arrow keys
            if (charCode > 31 && (charCode < 48 || charCode > 57) && charCode !== 46) {
                evt.preventDefault();
                return false;
            }
            return true;
        }
    </script>

      <script type="text/javascript">
          function showPopup() {
              document.getElementById('<%= pnlPopup.ClientID %>').style.display = 'block';
            document.getElementById('<%= pnlOverlay.ClientID %>').style.display = 'block';
        }

        function hidePopup() {
            document.getElementById('<%= pnlPopup.ClientID %>').style.display = 'none';
            document.getElementById('<%= pnlOverlay.ClientID %>').style.display = 'none';
          }
      </script>

</asp:Content>
