<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="incidentlist_return.aspx.cs" Inherits="uk_forest.Forest.incidentlist_return" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


    <style>
        .file-upload-wrapper{
            position: relative;
            display: inline-block;
        }
        .remove-file-btn{
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
        .btn-disabled{
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
        .file-upload-wrapper:hover .file-upload-label{
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

                    <fieldset class="radio-group" style="border: 2px solid #23a510; padding: 15px; border-radius: 8px;">
                        <legend style="font-weight: 500; float: inherit; padding: 2px 10px; color: #fff; border-radius: 5px; background-color: #13460c; margin-bottom: 10px; text-align: center; width: auto; margin-left: auto; margin-right: auto; font-size: 18px;">
                            <asp:Label ID="lblClaimType" runat="server" Text="Claim Category "></asp:Label>
                        </legend>
                        <div class="d-flex flex-wrap justify-content-center" style="gap: 20px;">
                            <asp:RadioButtonList ID="rblClaimType" runat="server" RepeatDirection="Horizontal" CssClass="claim-radio-list" RepeatLayout="Flow" OnSelectedIndexChanged="rblClaimType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Text="All" Value="0" Selected="True" />
                                <asp:ListItem Text="Human Death / Injury" Value="Human" />
                                <asp:ListItem Text="Crop Damage" Value="Crop" />
                                <asp:ListItem Text="Cattle Kill" Value="Cattle" />
                                <asp:ListItem Text="Property Damage" Value="House" />
                            </asp:RadioButtonList>
                        </div>
                        <%--</fieldset>--%>

                        <%--<fieldset class="radio-group" style="border: 2px solid #23a510; padding: 15px; border-radius: 10px;">--%>
                        <%-- <legend style="font-weight: bold; color: #333; margin-bottom: 10px; text-align: center; width: auto; margin-left: auto; margin-right: auto;">
                            <asp:Label ID="lblClaimType" runat="server" Text="Select Claim Category"></asp:Label>
                        </legend>

                        <div class="d-flex flex-wrap justify-content-center" style="gap: 20px;">
                            <asp:RadioButtonList ID="rblClaimType" runat="server" RepeatDirection="Horizontal" CssClass="claim-radio-list" RepeatLayout="Flow" OnSelectedIndexChanged="rblClaimType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Text="Human Death / Injury" Value="Human" />
                                <asp:ListItem Text="Crop Damage" Value="Crop" />
                                <asp:ListItem Text="Cattle Kill" Value="Cattle" />
                                <asp:ListItem Text="Property Damage" Value="House" />
                            </asp:RadioButtonList>
                        </div>--%>

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
                                        <%-- <div class="col-md-4 d-grid">--%>
                                        <div class="col-md-4" style="position: relative;">
                                            <asp:Button ID="btnSearch" runat="server"
                                                Text="🔍 Search"
                                                CssClass="btn btn-success btn-lg fw-bold tooltip-btn"
                                                OnClick="btnSearch_Click"
                                                Style="background: linear-gradient(135deg, #28a745, #20c997); border: none; border-radius: 8px; box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3); transition: all 0.3s ease;"
                                                onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 12px rgba(40, 167, 69, 0.4)';"
                                                onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 8px rgba(40, 167, 69, 0.3)';"
                                                ToolTip="Click to search for claims quickly!" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </fieldset>

                    <%--  <fieldset class="radio-group" style="border: 2px solid #23a510; padding: 15px; border-radius: 10px;">
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
                                                Text="🔍 Search Claims"
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
                    </fieldset>--%>




                    <div class="form-row mt-4">
                        <div class="table-responsive">
                            <asp:HiddenField ID="hdnSelectedIncidentId" runat="server" />
                            <asp:Label ID="lbl_msg_alert" runat="server" CssClass="alert alert-danger p-2 mb-0" Visible="false"></asp:Label>

                            <asp:GridView ID="gv_incident_list" runat="server" AutoGenerateColumns="false" OnRowDataBound="gv_incident_list_RowDataBound" CssClass="incident-table" AllowPaging="true" PageSize="10" DataKeyNames="incidentId" EmptyDataText="No incidents found!" OnPageIndexChanging="gv_incident_list_PageIndexChanging">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Incident Id">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_incidentId" runat="server" Text='<%# Eval("incidentId") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Claim Category">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_claimCategory" runat="server" Text='<%# Eval("claimCategory") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    
                                    <asp:TemplateField HeaderText="Victim ID / पीड़ित की आईडी" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_victimId" runat="server" Text='<%# Eval("victimId") ?? "NA" %>'></asp:Label>
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

                                    <asp:TemplateField HeaderText="Incident Time">
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

                                    <asp:TemplateField HeaderText="View">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkView" runat="server"
                                                OnClick="lnkView_Click"
                                                ToolTip="Click to view complete incident details" Style="display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; text-decoration: none; color: #26ad54; font-weight: 600; font-size: 25px; cursor: pointer; transition: all 0.3s ease;">
                                                     <i class="fas fa-eye"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>




                                    <asp:TemplateField HeaderText="Edit Documents / दस्तावेज़ संपादित करें">     
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkediteDocument" runat="server"
                                                Text="Edit Documents"
                                                OnClick="lnkediteDocument_Click"
                                                title="Click here to edit your documents"
                                                Style="display:inline-block; padding: 10px 20px; border-radius: 25px; text-decoration: none; color: white; font-weight: 600; font-size: 14px; border: 1px solid #007bff; background: linear-gradient(135deg,#007bff 0%,#0056b3 100%); cursor: pointer; transition: all 0.3s ease; text-align: center; min-width: 120px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>



                               <%--     <asp:TemplateField HeaderText="Payment">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkpayment" runat="server"
                                                Text="Initiate Payment"
                                                OnClick="lnkpayment_Click"
                                                Style="display: inline-block; padding: 10px 20px; border-radius: 25px; text-decoration: none; color: white; font-weight: 600; font-size: 14px; border: 1px solid #007bff; background: linear-gradient(135deg,#007bff 0%,#0056b3 100%); cursor: pointer; transition: all 0.3s ease; text-align: center; min-width: 140px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                </Columns>
                                <PagerStyle CssClass="pagination-grid" />
                            </asp:GridView>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div>
        <div id="chartdiv" style="width: 100%; height: 400px;"></div>
    </div>

    <asp:Panel ID="pnlIncidentDetails" runat="server" Visible="false" Style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 9999; display: flex; align-items: center; justify-content: center;">
        <div style="background: white; border-radius: 8px; width: 90%; max-width: 900px; max-height: 90%; overflow-y: auto; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">
            <div style="background: #4a5568; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-radius: 8px 8px 0 0;">
                <h4 style="margin: 0; font-weight: 600; font-size: 18px;">View Incident Details</h4>
                <button type="button" onclick="hideIncidentPopup()" style="background: none; border: none; color: white; font-size: 18px; cursor: pointer; padding: 5px;">✖</button>
            </div>

            <div style="padding: 20px;">
                <asp:Repeater ID="rptMainIncident" runat="server">
                    <ItemTemplate>
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Applicant & Beneficiary Information
                            </h5>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Applicant ID:</span>
                                    <span style="color: #2d3748;"><%# Eval("applicantId") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Applicant Name:</span>
                                    <span style="color: #2d3748;"><%# Eval("applicantName") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Mobile No:</span>
                                    <span style="color: #2d3748;"><%# Eval("mobileNo") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Applicant Aadhar:</span>
                                    <span style="color: #2d3748;"><%# Eval("applicantAadharNo") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhar Document:</span>
                                    <span style="color: #2d3748;">
                                        <%# !string.IsNullOrEmpty(Eval("applicantAadharDoc")?.ToString()) ? 
                                        $"<a href='{BaseUrl}{Eval("applicantAadharDoc")}' target='_blank' style='color: #3182ce; text-decoration: none;'>View Document</a>" : 
                                        "N/A" %>
                                    </span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Bank Name:</span>
                                    <span style="color: #2d3748;"><%# Eval("bankName") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Account Number:</span>
                                    <span style="color: #2d3748;"><%# Eval("accNumber") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Account Holder:</span>
                                    <span style="color: #2d3748;"><%# Eval("accHolderName") %></span>
                                </div>
                            </div>
                        </div>

                        <!-- Victim Information -->
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Victim Information
                            </h5>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Victim ID:</span>
                                    <span style="color: #2d3748;"><%# Eval("victimId") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Full Name:</span>
                                    <span style="color: #2d3748;"><%# Eval("victimName") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Age:</span>
                                    <span style="color: #2d3748;"><%# Eval("victimAge") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Gender:</span>
                                    <span style="color: #2d3748;"><%# Eval("victimGender") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhar No:</span>
                                    <span style="color: #2d3748;"><%# string.IsNullOrEmpty(Eval("victimAadharNo")?.ToString()) ? "N/A" : Eval("victimAadharNo") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhar Document:</span>
                                    <span style="color: #2d3748;">
                                        <%# !string.IsNullOrEmpty(Eval("victimAadharDoc")?.ToString()) ? 
                                        $"<a href='{BaseUrl}{Eval("victimAadharDoc")}' target='_blank' style='color: #3182ce; text-decoration: none;'>View Document</a>" : 
                                        "N/A" %>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Incident Information -->
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Incident Information
                            </h5>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident ID:</span>
                                    <span style="color: #2d3748;"><%# Eval("incidentId") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident Date:</span>
                                    <span style="color: #2d3748;"><%# Convert.ToDateTime(Eval("incidentDate")).ToString("dd-MM-yyyy") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident Time:</span>
                                    <span style="color: #2d3748;"><%# Eval("incidentTime") %></span>
                                </div>
                                <%--   <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident Place:</span>
                                    <span style="color: #2d3748;"><%# Eval("incidentPlace") ?? "Not Specified" %></span>
                                </div>--%>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Animal Name:</span>
                                    <span style="color: #2d3748;"><%# Eval("animalName") %> (<%# Eval("localName") %>)</span>
                                </div>
                                <%--<div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Conflict Category:</span>
                                    <span style="color: #2d3748;"><%# Eval("conflictCategory") %></span>
                                </div>--%>

                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Claim Category:</span>
                                    <span style="color: #2d3748;"><%# Eval("claimCategory") %></span>
                                </div>

                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Coordinates:</span>
                                    <span style="color: #2d3748;">
                                        <%# Eval("latitude") %>, <%# Eval("longitude") %>
                                        <a href='https://maps.google.com/?q=<%# Eval("latitude") %>,<%# Eval("longitude") %>'
                                            target="_blank"
                                            style="color: #3182ce; margin-left: 5px; text-decoration: none;">📍</a>
                                    </span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Status:</span>
                                    <span style="background: #fed7aa; color: #9a3412; padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 600;">
                                        <%# Eval("status") %>
                                    </span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Range Name:</span>
                                    <span style="color: #2d3748;"><%# Eval("rangeName") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Remark:</span>
                                    <span style="color: #2d3748;"><%# Eval("remark") %></span>
                                </div>
                            </div>
                        </div>

                        <!-- Incident Summary -->
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Incident Summary
                            </h5>
                            <div style="background: white; padding: 12px; border-radius: 4px; border: 1px solid #e2e8f0; line-height: 1.5; color: #2d3748;">
                                <%# Eval("incidentSummary") %>
                            </div>
                        </div>

                    </ItemTemplate>
                </asp:Repeater>

                <!-- Documents Section -->
                <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                    <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Attachments
                    </h5>

                    <asp:Repeater ID="rptDocuments" runat="server">
                        <HeaderTemplate>
                            <div style="display: grid; gap: 12px;">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div style="background: white; padding: 12px; border-radius: 6px; border: 1px solid #e2e8f0; display: flex; align-items: center; transition: all 0.2s ease;">
                                <div style="width: 40px; height: 40px; background: #3182ce; border-radius: 6px; display: flex; align-items: center; justify-content: center; margin-right: 12px;">
                                    <span style="color: white; font-size: 16px;">📄</span>
                                </div>
                                <div style="flex: 1;">
                                    <div style="font-weight: 600; color: #2d3748; margin-bottom: 2px;">
                                        Document Name:
                                    </div>
                                    <div style="color: #4a5568; font-size: 14px;">
                                        <%# Eval("DocumentName") %>
                                    </div>
                                </div>
                                <div>
                                    <a href='<%# Eval("DocumentPath") %>'
                                        download='<%# Eval("DocumentName") %>'
                                        style="color: #3182ce; text-decoration: none; font-weight: 500; padding: 6px 12px; border: 1px solid #3182ce; border-radius: 4px; font-size: 14px; transition: all 0.2s ease;">Download File
                                    </a>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </asp:Panel>




    <asp:Panel ID="paneldocumentrecommendation" runat="server" Visible="false" Style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
        <div style="background: #fff; padding: 20px; border-radius: 10px; max-width: 900px; width: 90%; max-height: 90%; overflow-y: auto; box-shadow: 0 5px 15px rgba(0,0,0,0.3);">
            <h3 style="margin-top: 0; margin-bottom: 20px; text-align: center; font-weight: 600; color: #333; position: relative;">Recommendation Submission
            <asp:LinkButton ID="btnHeaderClose" runat="server" CssClass="close-btn" ToolTip="Close this popup"
                OnClientClick="hiderecommendationPopup(); return false;">&times;</asp:LinkButton>
            </h3>

            <!-- Status Badge -->
            <div style="padding: 20px 30px 0; background: rgba(255,255,255,0.95);">
                <div style="display: inline-flex; align-items: center; gap: 10px; background: linear-gradient(135deg, #3182ce, #38a169); color: white; padding: 12px 20px; border-radius: 50px; font-weight: 600; font-size: 14px; box-shadow: 0 4px 15px rgba(72,187,120,0.3);">
                    <i class="fas fa-info-circle" style="font-size: 16px;"></i>
                    <span>Incident Status:</span>
                    <asp:Label ID="lblincidentstatusrecommendation" runat="server" Style="color: White; font-weight: bold; margin-left: 5px;"></asp:Label>
                </div>

                <div style="display: inline-flex; align-items: center; gap: 10px; background: linear-gradient(135deg, #3182ce, #38a169); color: white; padding: 12px 20px; border-radius: 50px; font-weight: 600; font-size: 14px; box-shadow: 0 4px 15px rgba(72,187,120,0.3);">
                    <i class="fas fa-info-circle" style="font-size: 16px;"></i>
                    <span>Incident Id:</span>
                    <asp:Label ID="lblincidentrecommendation" runat="server" Style="color: White; font-weight: bold; margin-left: 5px;"></asp:Label>
                </div>
            </div>


            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px;">
                <div runat="server" id="div_document_ro" style="max-width: 100%; width: 855px;">
                    <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                        <label style="font-weight: 600;">Najri Naksha (Incident Location Map)</label>
                        <div class="file-upload-wrapper">

                            <asp:HiddenField ID="hfRoleId" runat="server"
                                Value='<%= Session["RoleId"] != null ? Session["RoleId"].ToString() : "0" %>' />

                            <asp:FileUpload ID="NajriNaksha" runat="server" CssClass="file-upload form-control" accept=".jpg,.jpeg,.png,.pdf" />
                            <label for="<%= NajriNaksha.ClientID %>" class="file-upload-label">
                                <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                            </label>
                            <small class="file-info">Max size: 10MB | Formats: JPG, PNG, PDF</small>
                        </div>
                        <asp:Label ID="Label18" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                    </div>

                    <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                        <label style="font-weight: 600;">Forester Inspection Report</label>
                        <div class="file-upload-wrapper">
                            <asp:FileUpload ID="ForesterInspectionReport" runat="server" CssClass="file-upload form-control" accept=".jpg,.jpeg,.png,.pdf" />
                            <label for="<%= ForesterInspectionReport.ClientID %>" class="file-upload-label">
                                <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                            </label>
                            <small class="file-info">Max size: 10MB | Formats: JPG, PNG, PDF</small>
                        </div>
                        <asp:Label ID="lblEndorsementStatus" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                    </div>

                    <!-- Photographs -->
                    <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                        <label style="font-weight: 600;">Photographs &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp               </label>
                        <div class="file-upload-wrapper">
                            <asp:FileUpload ID="Photographs" runat="server" CssClass="file-upload form-control" accept=".jpg,.jpeg,.png,.pdf" />
                            <label for="<%= Photographs.ClientID %>" class="file-upload-label">
                                <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                            </label>
                            <small class="file-info">Max size: 10MB | Formats: JPG, PNG, PDF</small>
                        </div>
                        <asp:Label ID="Label15" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                    </div>

                    <!-- Additional Documents -->
                    <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                        <label style="font-weight: 600;">Additional Documents</label>
                        <div class="file-upload-wrapper">
                            <asp:FileUpload ID="AdditionalDocuments" runat="server" CssClass="file-upload form-control" accept=".jpg,.jpeg,.png,.pdf" />
                            <label for="<%= AdditionalDocuments.ClientID %>" class="file-upload-label">
                                <i class="fas fa-cloud-upload-alt"></i>Upload Document Here
                            </label>
                            <small class="file-info">Max size: 10MB | Formats: JPG, PNG, PDF</small>
                        </div>
                        <asp:Label ID="Label17" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                    </div>
                </div>

                <!-- Remarks -->
                <div style="grid-column: 1 / -1; background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 15px;">
                    <label style="font-weight: 600; display: block; margin-bottom: 8px;">Recommendation/Remarks</label>
                    <asp:TextBox ID="txtRecommendationRemarks" runat="server"
                        TextMode="MultiLine" Rows="4" CssClass="form-control" MaxLength="1000"
                        Style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; resize: vertical;">
                    </asp:TextBox>

                    <div style="text-align: center; margin-top: 20px;">
                        <asp:LinkButton ID="lnkGenerateNotesheet" runat="server" Text="Generate Recommendation Sheet" CssClass="btn-link"
                            ToolTip="Click here to generate recommendation sheet"
                            Style="text-decoration: none; padding: 8px 20px; border-radius: 5px; color: #3800ff; display: inline-block; margin-top: 10px;"
                            OnClientClick="generatePDF(); return false;">
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Upload Generated Notesheet -->
                <div style="grid-column: 1 / -1; background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 15px;">
                    <label style="font-weight: 600; display: block; margin-bottom: 8px;">Upload Generated Recommendation Sheet</label>
                    <div class="file-upload-wrapper">
                        <asp:FileUpload ID="GeneratedNotesheetUpload" runat="server" CssClass="file-upload" accept=".pdf" />
                        <label for="<%= GeneratedNotesheetUpload.ClientID %>" class="file-upload-label">
                            <i class="fas fa-cloud-upload-alt"></i>Upload Notesheet Here
                        </label>
                        <small class="file-info">Max size: 10MB | Format: PDF only</small>
                    </div>
                    <asp:Label ID="lblGeneratedNotesheetStatus" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                </div>

                <!-- Dropdown & Amount -->
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="row mb-12" style="background: #f8f9fa; padding: 15px;" runat="server" id="damage_ddl_div">
                            <div class="col-lg-12">
                                <label style="font-weight: 600;">Damage Type</label>
                                <asp:DropDownList ID="ddl_damage_type" runat="server" CssClass="form-control"
                                    OnSelectedIndexChanged="ddl_damage_type_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>

                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddl_damage_type" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>

            <!-- Footer Buttons -->
            <div style="text-align: center; margin-top: 20px;">
                <asp:Button ID="btn_submit_recommendation" runat="server" Text="Submit" CssClass="btn btn-secondary" Style="background: #6c757d; border: none; color: white; padding: 8px 15px; border-radius: 5px;" OnClick="btn_submit_recommendation_Click" OnClientClick="return validateFiles();" />
            </div>
        </div>
    </asp:Panel>




    <asp:Panel ID="panelVerifyDocument" runat="server"
        Style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.7); z-index: 1050; backdrop-filter: blur(4px);">

        <!-- Modern Container -->
        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 95%; max-width: 1400px; height: 90vh; background-color: white; border-radius: 20px; box-shadow: 0 25px 50px rgba(0,0,0,0.3); overflow: hidden;">

            <!-- Header Section -->
            <div style="background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); padding: 25px 30px; border-bottom: 1px solid rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 100;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <div style="width: 50px; height: 50px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 12px; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 15px rgba(102,126,234,0.3);">
                            <i class="fas fa-file-alt" style="color: white; font-size: 22px;"></i>
                        </div>
                        <div>
                            <h3 style="margin: 0; font-size: 24px; font-weight: 700; color: #2d3748; background: linear-gradient(135deg, #667eea, #764ba2); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Document Verification
                            </h3>
                            <p style="margin: 5px 0 0 0; color: #718096; font-size: 14px; font-weight: 500;">
                                Review and verify incident documents
                            </p>
                        </div>
                    </div>

            
                </div>
            </div>

            <!-- Status Badges -->
            <div style="padding: 20px 30px 0; background: rgba(255,255,255,0.95); display: flex; gap: 15px;">
                <div style="display: inline-flex; align-items: center; gap: 10px; background: linear-gradient(135deg, #3182ce, #38a169); color: white; padding: 12px 20px; border-radius: 50px; font-weight: 600; font-size: 14px; box-shadow: 0 4px 15px rgba(72,187,120,0.3);">
                    <i class="fas fa-info-circle" style="font-size: 16px;"></i>
                    <span>Incident Status:</span>
                    <asp:Label ID="lblIncidentStatus" runat="server" Style="color: White; font-weight: bold; margin-left: 5px;"></asp:Label>
                </div>

                <div style="display: inline-flex; align-items: center; gap: 10px; background: linear-gradient(135deg, #3182ce, #38a169); color: white; padding: 12px 20px; border-radius: 50px; font-weight: 600; font-size: 14px; box-shadow: 0 4px 15px rgba(49,130,206,0.3);">
                    <i class="fas fa-hashtag" style="font-size: 16px;"></i>
                    <span>Incident Id:</span>
                    <asp:Label ID="lblIncidentId" runat="server" Style="color: White; font-weight: bold; margin-left: 5px;"></asp:Label>
                </div>
            </div>

            <!-- Repeater Container -->
            <div style="padding: 30px; background: rgba(255,255,255,0.95); height: 100%; overflow-y: auto; max-height: 651px;">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(380px, 1fr)); gap: 25px; max-width: 100%;">
                    <asp:Repeater ID="Repeater2" runat="server" OnItemDataBound="Repeater2_ItemDataBound">
                        <ItemTemplate>
                            <!-- Modern Document Card -->
                            <div style="background: white; border-radius: 16px; padding: 25px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); border: 1px solid rgba(0,0,0,0.05); transition: all 0.3s ease; position: relative; overflow: hidden;"
                                onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 15px 35px rgba(0,0,0,0.15)';"
                                onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 8px 25px rgba(0,0,0,0.08)';">

                                <!-- Card Header -->
                                <div style="background: linear-gradient(135deg, rgba(102,126,234,0.1), rgba(118,75,162,0.1)); border-radius: 12px; padding: 15px; margin-bottom: 20px;">
                                    <h4 style="margin: 0; font-size: 16px; font-weight: 700; color: #2d3748; text-align: center; line-height: 1.4;">
                                        <i class="fas fa-file" style="color: #667eea; margin-right: 8px;"></i>
                                        <%# Eval("documentName") %>
                                    </h4>
                                </div>

                                <!-- Hidden Fields -->
                                <asp:HiddenField ID="hfDocumentId" runat="server" Value='<%# Eval("documentId") %>' />
                                <asp:HiddenField ID="hfIncidentId" runat="server" Value='<%# Eval("incidentId") %>' />

                                <!-- Document Preview Section -->
                                <div style="margin-bottom: 20px; text-align: center; position: relative;">
                                    <!-- Image Preview -->
                                    <asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("FullUrl") %>'
                                        Style="width: 100%; max-width: 280px; height: 200px; object-fit: cover; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); transition: all 0.3s ease;"
                                        Visible='<%# IsImageFile(Eval("FilePath")?.ToString()) %>'
                                        onmouseover="this.style.transform='scale(1.02)';"
                                        onmouseout="this.style.transform='scale(1)';" />

                                    <!-- PDF Preview -->
                                    <asp:PlaceHolder ID="phPdf" runat="server" Visible='<%# IsPdfFile(Eval("FilePath")?.ToString()) %>'>
                                        <div style="margin-top: 10px; text-align: center;">
                                            <iframe
                                                src='<%# Eval("FullUrl") %>'
                                                style="width: 100%; max-width: 500px; height: 400px; border: 1px solid #ccc; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);"
                                                title="PDF Preview"></iframe>
                                            <p style="margin-top: 10px; color: #718096; font-size: 14px;">
                                                If the PDF doesn't load,
                                            <a href='<%# Eval("FullUrl") %>' target="_blank"
                                                style="color: #3182ce; font-weight: 600; text-decoration: none;">click here to open
                                            </a>.
                                            </p>
                                        </div>
                                    </asp:PlaceHolder>

                                    <!-- Other File Types -->
                                    <asp:HyperLink ID="hlDownload" runat="server"
                                        NavigateUrl='<%# Eval("FullUrl") %>'
                                        Style="display: block; background: linear-gradient(135deg, #e2e8f0, #cbd5e0); border-radius: 12px; padding: 40px 20px; margin: 10px 0; text-decoration: none; transition: all 0.3s ease;"
                                        Visible='<%# !IsImageFile(Eval("FilePath")?.ToString()) && !IsPdfFile(Eval("FilePath")?.ToString()) %>'
                                        onmouseover="this.style.background='linear-gradient(135deg, #cbd5e0, #a0aec0)';"
                                        onmouseout="this.style.background='linear-gradient(135deg, #e2e8f0, #cbd5e0)';">
                                    <i class="fas fa-file-download" style="font-size: 36px; color: #667eea; margin-bottom: 10px;"></i>
                                    <p style="margin: 0; color: #4a5568; font-weight: 600;">Download File</p>
                                    </asp:HyperLink>
                                </div>

                                <!-- Status Label -->
                                <div style="text-align: center; margin-bottom: 20px;">
                                    <asp:Label ID="lblDocStatus" runat="server" Text='<%# Eval("status") %>'></asp:Label>
                                </div>

                                <!-- Action Buttons -->
                                <div style="display: flex; gap: 12px; margin-bottom: 20px; justify-content: center; flex-wrap: wrap;">
                                    <asp:TextBox runat="server" ID="txt_reason" CssClass="form-control" placeholder="Enter reason for return" Visible="false" TextMode="MultiLine"></asp:TextBox>
                                    <asp:Button ID="btnApprove" runat="server" Text="✓ Approve"
                                        CssClass="btn btn-success" OnClick="btnApprove_Click"
                                        Style="background: linear-gradient(135deg, #48bb78, #38a169); border: none; color: white; padding: 12px 20px; border-radius: 25px; font-weight: 600; font-size: 14px; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(72,187,120,0.3); min-width: 110px;"
                                        onmouseover="this.style.transform='translateY(-2px)';"
                                        onmouseout="this.style.transform='translateY(0)';" />

                                    <asp:Button ID="btnReject" runat="server" Text="✕ Return"
                                        CssClass="btn btn-danger" OnClick="btnReject_Click"
                                        Style="background: linear-gradient(135deg, #f56565, #e53e3e); border: none; color: white; padding: 12px 20px; border-radius: 25px; font-weight: 600; font-size: 14px; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(245,101,101,0.3); min-width: 110px;"
                                        onmouseover="this.style.transform='translateY(-2px)';"
                                        onmouseout="this.style.transform='translateY(0)';" />






                                    <!-- NEW: Submit & Reset (initially hidden) -->
                                    <asp:Button ID="btnReturnSubmit" runat="server" Text="Submit"
                                        Visible="false" CssClass="btn btn-primary" OnClick="btnReturnSubmit_Click"
                                        Style="padding: 12px 20px; border-radius: 25px; font-weight: 600; min-width: 110px;" />

                                    <asp:Button ID="btnReset" runat="server" Text="Reset"
                                        Visible="false" CssClass="btn btn-secondary" OnClick="btnReset_Click"
                                        Style="padding: 12px 20px; border-radius: 25px; font-weight: 600; min-width: 110px;" />







                                    <asp:HyperLink ID="hlDownloadIcon" runat="server"
                                        NavigateUrl='<%# Eval("FullUrl") %>' Target="_blank" ToolTip="Download Document"
                                        Style="display: flex; align-items: center; justify-content: center; width: 45px; height: 45px; background: linear-gradient(135deg, #667eea, #764ba2); color: white; border-radius: 50%; text-decoration: none; font-size: 18px; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(102,126,234,0.3);"
                                        onmouseover="this.style.transform='translateY(-2px) scale(1.05)';"
                                        onmouseout="this.style.transform='translateY(0) scale(1)';">
                                    <i class="fas fa-download"></i>
                                    </asp:HyperLink>
                                </div>

                                <!-- Checkbox -->
                                <%-- <div style="text-align: center; padding-top: 15px;">
                                <asp:CheckBox ID="chkSelectDocument" runat="server"
                                    Text="  Verify this document"
                                    CssClass="docCheckbox"
                                    Style="font-weight: 600; color: #4a5568; cursor: pointer;
                                           display: inline-flex; align-items: center; gap: 8px;" />
                            </div>--%>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </asp:Panel>


        <asp:Panel ID="PanelPayment" runat="server" Visible="false" Style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 9999; display: flex; align-items: center; justify-content: center;">
        <div style="background: white; border-radius: 8px; width: 90%; max-width: 900px; max-height: 90%; overflow-y: auto; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">
            <div style="background: #4a5568; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-radius: 8px 8px 0 0;">
                <h4 style="margin: 0; font-weight: 600; font-size: 18px;">Incident Payment Details</h4>
                <button type="button" onclick="hidepnlPanelPayment()" style="background: none; border: none; color: white; font-size: 18px; cursor: pointer; padding: 5px;">✖</button>
            </div>

            <div style="padding: 20px;">
                <div style="grid-column: 1 / -1; background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 15px;">
                    <label style="font-weight: 600; display: block; margin-bottom: 8px;">Recommendation/Remarks</label>
                    <asp:TextBox ID="txtremarkpayment" runat="server"
                        TextMode="MultiLine" Rows="4" CssClass="form-control"
                        Style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; resize: vertical;">
                    </asp:TextBox>

                    <div style="text-align: center; margin-top: 20px;">
                        <asp:LinkButton ID="lnkGenerateNotesheetpayment" runat="server" Text="Generate Notesheet" CssClass="btn-link"
                            ToolTip="Click here to generate notesheet"
                            Style="text-decoration: none; padding: 8px 20px; border-radius: 5px; color: #3800ff; display: inline-block; margin-top: 10px;"
                            OnClientClick="generatePDF(); return false;">
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Upload Generated Notesheet -->
                <div style="grid-column: 1 / -1; background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 15px;">
                    <label style="font-weight: 600; display: block; margin-bottom: 8px;">Upload Generated Notesheet</label>
                    <div class="file-upload-wrapper">
                        <asp:FileUpload ID="GeneratedNotesheetUploadPayment" runat="server" CssClass="file-upload" accept=".pdf" />
                        <label for="<%= GeneratedNotesheetUpload.ClientID %>" class="file-upload-label">
                            <i class="fas fa-cloud-upload-alt"></i>Upload Notesheet Here
                        </label>
                        <small class="file-info">Max size: 10MB | Format: PDF only</small>
                    </div>
                    <asp:Label ID="Label1" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                </div>
            </div>

        </div>
    </asp:Panel>





        <asp:Panel ID="Paneleditdocument" runat="server" Style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 9999; align-items: center; justify-content: center;">
        <div style="background: white; border-radius: 8px; width: 90%; max-width: 900px; max-height: 90%; overflow-y: auto; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">

            <!-- Header -->
            <div style="background: #4a5568; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-radius: 8px 8px 0 0;">
                <h4 style="margin: 0; font-weight: 600;">View Incident Details</h4>
                <button type="button" onclick="hidePopupEditDocument()" style="background: none; border: none; color: white; font-size: 18px; cursor: pointer; padding: 5px;">✖</button>
            </div>

            <!-- Content -->
            <div style="padding: 20px;">
                <asp:Repeater ID="RepeaterEditDocuments" runat="server" OnItemDataBound="rptIncidentDetails_ItemDataBound">
                    <ItemTemplate>

                        <!-- Applicant & Bank Information Section -->
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Applicant & Beneficiary Information </h5>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Applicant ID:</span> <span style="color: #2d3748;"><%# Eval("applicantId") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Name:</span> <span style="color: #2d3748;"><%# Eval("applicantName") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhaar No.:</span> <span style="color: #2d3748;"><%# Eval("applicantAadharNo") %></span> </div>
                                <div style="display: flex;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhaar Document:</span>
                                    <asp:HyperLink ID="HyperLink3" runat="server" Text='<%# Eval("applicantAadharDoc") == DBNull.Value || string.IsNullOrEmpty(Eval("applicantAadharDoc").ToString()) ? "N/A" : "View Document" %>' NavigateUrl='<%# Eval("applicantAadharDoc") == DBNull.Value || string.IsNullOrEmpty(Eval("applicantAadharDoc").ToString()) ? "#" : HostUrl + Eval("applicantAadharDoc") %>' Target="_blank" Style="color: #3182ce; text-decoration: none;" />
                                </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Bank Name:</span> <span style="color: #2d3748;"><%# Eval("bankName") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Account No.:</span> <span style="color: #2d3748;"><%# Eval("accNumber") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Account Holder Name:</span> <span style="color: #2d3748;"><%# Eval("accHolderName") %></span> </div>
                                <div style="display: flex;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Bank Document:</span>
                                    <asp:HyperLink ID="HyperLink2" runat="server" Text='<%# Eval("bankDoc") == DBNull.Value || string.IsNullOrEmpty(Eval("bankDoc").ToString()) ? "N/A" : "View Document" %>' NavigateUrl='<%# Eval("bankDoc") == DBNull.Value || string.IsNullOrEmpty(Eval("bankDoc").ToString()) ? "#" : HostUrl + Eval("bankDoc") %>' Target="_blank" Style="color: #3182ce; text-decoration: none;" />
                                </div>
                            </div>
                        </div>

                        <!-- Victim Information Section -->
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Victim Information </h5>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Name:</span> <span style="color: #2d3748;"><%# Eval("victimName") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Age:</span> <span style="color: #2d3748;"><%# Eval("victimAge") == DBNull.Value ? "-" : Eval("victimAge") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Gender:</span> <span style="color: #2d3748;"><%# Eval("victimGender") %></span> </div>
                               
                                <div style="display: flex;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhaar No.:</span>
                                    <span style="color: #2d3748;"><%# string.IsNullOrEmpty(Eval("victimAadharNo")?.ToString()) ? "N/A" : Eval("victimAadharNo") %></span>
                                </div>
                                <div style="display: flex;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhaar Document:</span>
                                    <span style="color: #2d3748;">
                                        <%# Eval("victimAadharDoc") == DBNull.Value || string.IsNullOrEmpty(Eval("victimAadharDoc")?.ToString()) ? "N/A" : "<a href='" + HostUrl + Eval("victimAadharDoc") + "' target='_blank' style='color: #3182ce; text-decoration: none;'>View Document</a>" %>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Incident Information Section -->
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Incident Information </h5>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <asp:HiddenField ID="hfIncidentId" runat="server" Value='<%# Eval("incidentId") %>' />

                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident ID:</span> <span style="color: #2d3748;"><%# Eval("incidentId") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident Date:</span> <span style="color: #2d3748;"><%# FormatDate(Eval("incidentDate")) %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident Time:</span> <span style="color: #2d3748;"><%# Eval("incidentTime") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Caused By:</span> <span style="color: #2d3748;"><%# Eval("animalName") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Coordinates:</span> <span style="color: #2d3748;"><%# Eval("latitude") == DBNull.Value ? "-" : Eval("latitude") %>, <%# Eval("longitude") == DBNull.Value ? "-" : Eval("longitude") %> <a href='https://maps.google.com/?q=<%# Eval("latitude") %>,<%# Eval("longitude") %>' target="_blank" style="color: #3182ce; margin-left: 5px; text-decoration: none;">📍</a> </span></div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Status:</span> <span style="background: #fed7aa; color: #9a3412; padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 600;"><%# Eval("status") %> </span></div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Range:</span> <span 
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Claim Category:</span> <span style="color: #2d3748;"><%# Eval("claimCategory") %></span> </div>
                            </div>
                        </div>
                            </div>
                        <!-- Incident Summary Section -->
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Incident Summary </h5>
                            <div style="background: white; padding: 12px; border-radius: 4px; border: 1px solid #e2e8f0; line-height: 1.5; color: #2d3748;"><%# Eval("incidentSummary") %> </div>
                        </div>

                        <!-- Attachments Section -->
                            <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                                <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Attachments </h5>
                                <asp:Repeater ID="rptDocuments" runat="server">
                                    <ItemTemplate>
                                        <div style="background: #fff; padding: 16px; margin-bottom: 16px; border-radius: 8px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">

                                            <!-- First Row -->
                                            <div style="display: grid; grid-template-columns: 1fr auto; align-items: center; margin-bottom: 12px;">
                                                <div style="display: flex; align-items: center; gap: 8px;">
                                                    <asp:Label runat="server" ID="hfdocumentid" Text='<%# Eval("DocumentId") %>' Visible="false"/>
                                                    <span style="font-weight: 600; color: #2d3748; font-size: 16px;">
                                                        <asp:Label runat="server" ID="lbldocumentName" Text='<%# Eval("documentName") %>'/>
                                                    </span>

                                                    <%-- Status Badge with Green Tick GIF --%>
                                                <%--    <span style='<%# Eval("status")?.ToString() == "Verified"
        ? "display:inline-flex; align-items:center; gap:6px; background:#C6F6D5; color:#2F855A; padding:2px 8px; border-radius:12px; font-size:13px; font-weight:500;": "display:inline-flex; align-items:center; gap:6px; background:#FED7D7; color:#C53030; padding:2px 8px; border-radius:12px; font-size:13px; font-weight:500;" %>'>

                                                        <%# Eval("status")?.ToString() == "Verified"
        ? "<img src='../images/Green%20tick.gif' style=\"width:33px; height:33px; vertical-align:middle;\" /> Verified"
        : "<img src='../images/error.gif' style=\"width:25px; height:25px; vertical-align:middle;\" /> Not Verified" %>
                                                    </span>--%>
                                                </div>

                                               <asp:HyperLink ID="hlFilePath" runat="server"
    NavigateUrl='<%# Eval("FullUrl") %>' 
    Target="_blank"
    ToolTip='<%# string.IsNullOrEmpty(Eval("documentPath")?.ToString()) 
                ? "No file available" 
                : "Click to download file" %>'
    Text='<%# string.IsNullOrEmpty(Eval("documentPath")?.ToString()) 
            ? "<i class=\"fas fa-download\" style=\"margin-right:6px;\"></i> N/A" 
            : "<i class=\"fas fa-download\" style=\"margin-right:6px;\"></i> Download File" %>'
    Style="color: #3182ce; text-decoration: none; font-weight: 500; display: inline-flex; align-items: center;" />


                                            </div>


                                            <!-- Second Row -->
                                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; align-items: start;">

                                                <!-- Left Side: Document Preview -->
                                                <asp:PlaceHolder ID="phPreview" runat="server">
                                                    <asp:Image ID="imgThumbnail" runat="server"
                                                        Visible='<%# IsImageFile(Eval("documentPath")?.ToString()) %>'
                                                        ImageUrl='<%# Eval("FullUrl") %>'
                                                        Style="width: 100%; max-width: 200px; height: auto; border: 2px solid #e2e8f0; border-radius: 8px;" />

                                                    <asp:HyperLink ID="hlPdfPreview" runat="server"
                                                        Visible='<%# IsPdfFile(Eval("documentPath")?.ToString()) %>'
                                                        NavigateUrl='<%# Eval("FullUrl") %>'
                                                        Target="_blank" Text="View PDF"
                                                        Style="display: inline-block; color: #e53e3e; font-weight: 500; margin-top: 8px;" />
                                                </asp:PlaceHolder>

                                                <!-- Right Side: Remarks + Controls -->
                                                <div>
                                                    <div style='<%# string.IsNullOrEmpty(Eval("comments")?.ToString()) 
    ? "background: #f7fafc; padding: 12px; border-radius: 6px; border: 1px solid #e2e8f0; color: #3182ce;": "background: #fff5f5; padding: 12px; border-radius: 6px; border: 1px solid #feb2b2; color: red; font-weight: 500;" %>'>
                                                        Remarks: <%# Eval("comments") %>
                                                    </div>


                                                    <asp:Panel ID="pnlReupload" runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("comments")?.ToString()) %>' Style="margin-top: 12px; text-align: center;">
                                                        <asp:Label runat="server" ID="lblfileupload" Text="Re-Upload File" Style="display: block; margin-bottom: 6px; color: #2d3748; font-weight: 500;" />
                                                        <asp:FileUpload runat="server" ID="filereupload" CssClass="form-control" Style="margin-bottom: 8px; max-width: 250px; display: inline-block;" />
                                                        <asp:Button runat="server" ID="btn_re_upload" Text="Re-Upload" CssClass="btn btn-success rounded" Style="padding: 6px 14px;" OnClick="btn_re_upload_Click"/>
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlReturnToApplicant" runat="server"  style="text-align:center; margin-top:20px;">
    <asp:Button
    ID="btnReturnToApplicant"
    runat="server"
    Text="Return"
    CssClass="btn btn-danger"
    CommandArgument='<%# Eval("incidentId") %>'
    OnClick="btnReturnToApplicant_Click" />
</asp:Panel>

            </div>
        </div>
    </asp:Panel>


    
    <script type="text/javascript"> 
        function showPopupEditDocument() {
            document.getElementById('<%= Paneleditdocument.ClientID %>').style.display = "flex";
        }

        function hidePopupEditDocument() {
            document.getElementById('<%= Paneleditdocument.ClientID %>').style.display = "none";
        }

    </script>


    <script>
        document.getElementById('<%= lnkGenerateNotesheet.ClientID %>').addEventListener('click', function (event) {
            // Get textarea content
            const content = document.getElementById('<%= txtRecommendationRemarks.ClientID %>').value;

            if (!content) {
                alert("Please enter some remarks before generating the PDF.");
                event.preventDefault();
                return false;
            }

            // Create jsPDF instance
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF({
                orientation: 'portrait',
                unit: 'mm',
                format: 'a4',
                compress: true
            });

            // Colors
            const primaryColor = [41, 128, 185];  // Blue
            const secondaryColor = [52, 73, 94];  // Dark gray

            // Page dimensions
            const pageWidth = doc.internal.pageSize.width;
            const pageHeight = doc.internal.pageSize.height;
            const margin = 20;

            // Header
            doc.setFillColor(...primaryColor);
            doc.rect(0, 0, pageWidth, 35, 'F');

            // Title
            doc.setTextColor(255, 255, 255);
            doc.setFontSize(20);
            doc.setFont("helvetica", "bold");
            doc.text("RECOMMENDATION NOTESHEET", pageWidth / 2, 15, { align: "center" });

            // Subtitle
            doc.setFontSize(10);
            doc.setFont("helvetica", "normal");
            doc.text("Regional Office Documentation", pageWidth / 2, 25, { align: "center" });

            // Document info
            doc.setTextColor(...secondaryColor);
            doc.setFontSize(9);
            const now = new Date();
            const dateStr = now.toLocaleDateString('en-IN');
            const timeStr = now.toLocaleTimeString('en-IN');

            // Right aligned
            doc.text(`Generated: ${dateStr} at ${timeStr}`, pageWidth - margin, 45, { align: "right" });
            doc.text("Document ID: RO-NOTE-" + now.getTime().toString().slice(-6), pageWidth - margin, 50, { align: "right" });

            // Left aligned
            doc.text("Department: Regional Office", margin, 45);
            doc.text("Classification: Official", margin, 50);

            // Decorative line
            doc.setDrawColor(...primaryColor);
            doc.setLineWidth(0.5);
            doc.line(margin, 55, pageWidth - margin, 55);

            // Content Header
            doc.setTextColor(...secondaryColor);
            doc.setFontSize(14);
            doc.setFont("helvetica", "bold");
            doc.text("RECOMMENDATION DETAILS", margin, 70);

            // Content box
            doc.setDrawColor(200, 200, 200);
            doc.setLineWidth(0.3);
            doc.roundedRect(margin, 75, pageWidth - (2 * margin), pageHeight - 140, 2, 2, 'S');

            // Content text
            doc.setTextColor(0, 0, 0);
            doc.setFontSize(11);
            doc.setFont("helvetica", "normal");
            const contentWidth = pageWidth - (2 * margin) - 10;
            const splitText = doc.splitTextToSize(content, contentWidth);

            let currentY = 85;
            const lineHeight = 5;
            splitText.forEach(line => {
                if (currentY > pageHeight - 60) {
                    doc.addPage();
                    currentY = 20;
                }
                doc.text(line, margin + 5, currentY);
                currentY += lineHeight;
            });

            // Signature section
            const signatureY = Math.max(currentY + 20, pageHeight - 50);
            doc.setDrawColor(...secondaryColor);
            doc.setLineWidth(0.3);
            doc.line(pageWidth - margin - 60, signatureY, pageWidth - margin, signatureY);

            doc.setFontSize(9);
            doc.setTextColor(100, 100, 100);
            doc.text("Authorized Signature", pageWidth - margin - 30, signatureY + 5, { align: "center" });
            doc.text("Date: ___________", pageWidth - margin - 30, signatureY + 12, { align: "center" });

            // Footer
            doc.setFillColor(240, 240, 240);
            doc.rect(0, pageHeight - 15, pageWidth, 15, 'F');

            doc.setTextColor(100, 100, 100);
            doc.setFontSize(8);
            doc.text("This document is system generated and contains confidential information.", pageWidth / 2, pageHeight - 8, { align: "center" });
            doc.text("Page 1", pageWidth - margin, pageHeight - 3, { align: "right" });

            // Dynamic filename: Notesheet_<RoleName>_<IncidentID>_<YYYYMMDD>_<HHMMSS>
            const roleName = '<%= Session["RoleName"]?.ToString() %>';
            const incidentId = '<%= lblincidentrecommendation.Text %>'; // Incident ID from label

            const year = now.getFullYear();
            const month = (now.getMonth() + 1).toString().padStart(2, '0');
            const day = now.getDate().toString().padStart(2, '0');
            const dateStrFile = `${year}${month}${day}`;

            const hours = now.getHours().toString().padStart(2, '0');
            const minutes = now.getMinutes().toString().padStart(2, '0');
            const seconds = now.getSeconds().toString().padStart(2, '0');
            const timeStrFile = `${hours}${minutes}${seconds}`;

            doc.save(`Notesheet_${roleName}_${incidentId}_${dateStrFile}_${timeStrFile}.pdf`);

            event.preventDefault();
            return false;
        });
    </script>





    <style>
        /* Ensure SweetAlert popup is on top of any panel/grid */
        .swal-popup-high {
            z-index: 9999999 !important;
        }
    </style>

    <script type="text/javascript">
        window.onload = function () {
            var today = new Date();
            var month = (today.getMonth() + 1).toString().padStart(2, '0');
            var day = today.getDate().toString().padStart(2, '0');
            var year = today.getFullYear();
            var maxDate = year + '-' + month + '-' + day;
            document.getElementById('<%= txtFromDate.ClientID %>').setAttribute('max', maxDate);
            document.getElementById('<%= txtToDate.ClientID %>').setAttribute('max', maxDate);
        }
    </script>


    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const fileUploads = [
        '<%= NajriNaksha.ClientID %>',
        '<%= ForesterInspectionReport.ClientID %>',
        '<%= Photographs.ClientID %>',
        '<%= AdditionalDocuments.ClientID %>',
        '<%= GeneratedNotesheetUploadPayment.ClientID %>', // ✅ Added Payment Notesheet
        '<%= GeneratedNotesheetUpload.ClientID %>'
            ];

<%--            const statusLabels = {
        '<%= NajriNaksha.ClientID %>': '<%= Label18.ClientID %>',
        '<%= ForesterInspectionReport.ClientID %>': '<%= lblEndorsementStatus.ClientID %>',
        '<%= Photographs.ClientID %>': '<%= Label15.ClientID %>',
        '<%= AdditionalDocuments.ClientID %>': '<%= Label17.ClientID %>',
        '<%= GeneratedNotesheetUpload.ClientID %>': '<%= lblGeneratedNotesheetStatus.ClientID %>',
        '<%= GeneratedNotesheetUploadPayment.ClientID %>': '<%= Label1.ClientID %>' // ✅ Payment Notesheet status
            };--%>

            //fileUploads.forEach(uploadId => {
            //    const upload = document.getElementById(uploadId);
            //    const statusLabelId = statusLabels[uploadId];
            //    const statusLabel = statusLabelId ? document.getElementById(statusLabelId) : null;
            //    if (!upload) return;

            //    const wrapper = upload.closest('.file-upload-wrapper');

            //    // File selection
            //    upload.addEventListener('change', function (e) {
            //        const file = e.target.files[0];
            //        if (file) handleFile(file, upload, statusLabel, wrapper);
            //    });

            //    // Drag & Drop
            //    wrapper.addEventListener('dragover', e => { e.preventDefault(); wrapper.classList.add('dragover'); });
            //    wrapper.addEventListener('dragleave', e => { e.preventDefault(); wrapper.classList.remove('dragover'); });
            //    wrapper.addEventListener('drop', e => {
            //        e.preventDefault();
            //        wrapper.classList.remove('dragover');
            //        const files = e.dataTransfer.files;
            //        if (files.length > 0) {
            //            upload.files = files;
            //            handleFile(files[0], upload, statusLabel, wrapper);
            //        }
            //    });
            //});

            function handleFile(file, upload, statusLabel, wrapper) {
                const maxSize = 2 * 1024 * 1024; // 2MB
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf'];

                if (file.size > maxSize || !allowedTypes.includes(file.type)) {
                    showFileStatus(statusLabel,
                        !allowedTypes.includes(file.type) ? 'Only JPG, PNG, and PDF files are allowed' : 'File size exceeds 2MB limit',
                        'error'
                    );
                    upload.value = '';
                    return;
                }

                showFileStatus(statusLabel, `File uploaded: ${file.name} (${(file.size / 1024).toFixed(1)} KB)`, 'success');

                // Optional: simple uploaded file info
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




    <script type="text/javascript">
        // 🔒 Common utility to hide element safely
        function hideElement(id) {
            var el = document.getElementById(id);
            if (el) el.style.display = "none";
        }

        function showIncidentPopup() {
            closePopupVerify();
            hiderecommendationPopup();
            var element = document.getElementById('<%= pnlIncidentDetails.ClientID %>');
            if (element) element.style.display = "flex";
        }

        function hideIncidentPopup() {
            hideElement('<%= pnlIncidentDetails.ClientID %>');
        }

        function showrecommendationPopup() {
            hideIncidentPopup();
            closePopupVerify();
            var element = document.getElementById('<%= paneldocumentrecommendation.ClientID %>');
            if (element) element.style.display = "flex";
        }

        function hiderecommendationPopup() {
            hideElement('<%= paneldocumentrecommendation.ClientID %>');
        }

        function showPopupVerify() {
            hideIncidentPopup();
            hiderecommendationPopup();
            var element = document.getElementById('<%= panelVerifyDocument.ClientID %>');
            if (element) element.style.display = "flex";
        }

        function closePopupVerify() {
            hideElement('<%= panelVerifyDocument.ClientID %>');
        }

        // 🔹 Assign FG panel
       <%-- function showpnlAssignFG() {
            document.getElementById('<%= pnlAssignFG.ClientID %>').style.display = "flex";
        }--%>
      <%--  function hidepnlAssignFG() {
            hideElement('<%= pnlAssignFG.ClientID %>');
        }--%>







        // 🔹 Payment panel
        function showpnlPanelPayment() {
            document.getElementById('<%= PanelPayment.ClientID %>').style.display = "flex";
        }
        function hidepnlPanelPayment() {
            hideElement('<%= PanelPayment.ClientID %>');
        }
    </script>




    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            const lnkGenerate = document.getElementById('<%= lnkGenerateNotesheetpayment.ClientID %>');
            console.log("Found element:", lnkGenerate); // Debugging line
            const txtRemarks = document.getElementById('<%= txtremarkpayment.ClientID %>');
            const lblIncident = document.getElementById('<%= lblincidentrecommendation.ClientID %>');

            if (!lnkGenerate) {
                console.error("lnkGenerateNotesheetpayment not found in DOM!");
                return;
            }

            lnkGenerate.addEventListener('click', function (event) {
                event.preventDefault(); // stop postback

                const content = txtRemarks.value.trim();
                if (!content) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Oops!',
                        text: 'Please enter some remarks before generating the PDF.',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#007bff',
                        customClass: { popup: 'swal-popup-high' }
                    }).then(() => {
                        txtRemarks.focus();
                    });
                    return false;
                }

                const { jsPDF } = window.jspdf;
                const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4', compress: true });

                // 🎨 Colors
                const primaryColor = [41, 128, 185];
                const secondaryColor = [52, 73, 94];

                // 📄 Page setup
                const pageWidth = doc.internal.pageSize.width;
                const pageHeight = doc.internal.pageSize.height;
                const margin = 20;

                // 🟦 Header
                doc.setFillColor(...primaryColor);
                doc.rect(0, 0, pageWidth, 35, 'F');
                doc.setTextColor(255, 255, 255);
                doc.setFontSize(20);
                doc.setFont("helvetica", "bold");
                doc.text("RECOMMENDATION NOTESHEET", pageWidth / 2, 15, { align: "center" });
                doc.setFontSize(10);
                doc.text("Regional Office Documentation", pageWidth / 2, 25, { align: "center" });

                // 📅 Document info
                doc.setTextColor(...secondaryColor);
                doc.setFontSize(9);
                const now = new Date();
                const dateStr = now.toLocaleDateString('en-IN');
                const timeStr = now.toLocaleTimeString('en-IN');
                doc.text(`Generated: ${dateStr} at ${timeStr}`, pageWidth - margin, 45, { align: "right" });
                doc.text("Document ID: RO-NOTE-" + now.getTime().toString().slice(-6), pageWidth - margin, 50, { align: "right" });
                doc.text("Department: Regional Office", margin, 45);
                doc.text("Classification: Official", margin, 50);

                doc.setDrawColor(...primaryColor);
                doc.line(margin, 55, pageWidth - margin, 55);

                // 📋 Content Header
                doc.setFontSize(14);
                doc.setFont("helvetica", "bold");
                doc.text("RECOMMENDATION DETAILS", margin, 70);

                // 📦 Content box
                doc.setDrawColor(200, 200, 200);
                doc.roundedRect(margin, 75, pageWidth - (2 * margin), pageHeight - 140, 2, 2, 'S');
                doc.setTextColor(0, 0, 0);
                doc.setFontSize(11);
                doc.setFont("helvetica", "normal");

                const contentWidth = pageWidth - (2 * margin) - 10;
                const splitText = doc.splitTextToSize(content, contentWidth);
                let currentY = 85;
                const lineHeight = 5;

                splitText.forEach(line => {
                    if (currentY > pageHeight - 60) {
                        doc.addPage();
                        currentY = 20;
                    }
                    doc.text(line, margin + 5, currentY);
                    currentY += lineHeight;
                });

                // ✍️ Signature section
                const signatureY = Math.max(currentY + 20, pageHeight - 50);
                doc.setDrawColor(...secondaryColor);
                doc.line(pageWidth - margin - 60, signatureY, pageWidth - margin, signatureY);
                doc.setFontSize(9);
                doc.setTextColor(100, 100, 100);
                doc.text("Authorized Signature", pageWidth - margin - 30, signatureY + 5, { align: "center" });
                doc.text("Date: ___________", pageWidth - margin - 30, signatureY + 12, { align: "center" });

                // ⚙️ Footer
                doc.setFillColor(240, 240, 240);
                doc.rect(0, pageHeight - 15, pageWidth, 15, 'F');
                doc.setTextColor(100, 100, 100);
                doc.setFontSize(8);
                doc.text("This document is system generated and contains confidential information.", pageWidth / 2, pageHeight - 8, { align: "center" });
                doc.text("Page 1", pageWidth - margin, pageHeight - 3, { align: "right" });

                // 💾 Dynamic filename
                const roleName = '<%= Session["RoleName"]?.ToString() %>' || "UnknownRole";
                const incidentId = lblIncident?.innerText || "UnknownIncident";
                const dateFile = now.toISOString().slice(0, 10).replace(/-/g, "");
                const timeFile = now.toTimeString().slice(0, 8).replace(/:/g, "");
                doc.save(`Notesheet_${roleName}_${incidentId}_${dateFile}_${timeFile}.pdf`);

                // ✅ Success alert
                Swal.fire({
                    icon: 'success',
                    title: 'PDF Generated!',
                    text: 'The recommendation notesheet has been successfully created.',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#28a745',
                    customClass: { popup: 'swal-popup-high' }
                });
            });
        });




    </script>




    <script type="text/javascript">
        function validateFiles() {
            debugger;

            var roleId = '<%= Session["RoleId"] != null ? Session["RoleId"].ToString() : "" %>';


            if (roleId == "10") {
                var najri = document.getElementById('<%= NajriNaksha.ClientID %>').value;
                var forester = document.getElementById('<%= ForesterInspectionReport.ClientID %>').value;
                var photos = document.getElementById('<%= Photographs.ClientID %>').value;
                var sheet = document.getElementById('<%= GeneratedNotesheetUpload.ClientID %>').value;
                var remarks = document.getElementById('<%= txtRecommendationRemarks.ClientID %>').value;
            }
            else if (roleId == "9") {
                var sheet = document.getElementById('<%= GeneratedNotesheetUpload.ClientID %>').value;
                var remarks = document.getElementById('<%= txtRecommendationRemarks.ClientID %>').value;
            }
            else if (roleId == "8") {
                var sheet = document.getElementById('<%= GeneratedNotesheetUpload.ClientID %>').value;
                var remarks = document.getElementById('<%= txtRecommendationRemarks.ClientID %>').value;
            }




            let errors = [];

            if (roleId == "10") {
                if (!najri) errors.push("Please upload Najri Naksha.");
                if (!forester) errors.push("Please upload Forester Inspection Report.");
                if (!photos) errors.push("Please upload Photographs.");
                if (!sheet) errors.push("Please upload Generated Notesheet.");
                if (!remarks) errors.push("Please enter Recommendation/Remarks.");
            } else if (roleId == "9" || roleId == "8") {
                if (!sheet) errors.push("Please upload Generated Notesheet.");
                if (!remarks) errors.push("Please enter Recommendation/Remarks.");
            }
            alert(errors.length);
            if (errors.length > 0) {
                Swal.fire("Validation Error", errors.join("<br/>"), "error");
                document.getElementById('<%= paneldocumentrecommendation.ClientID %>').style.display = 'flex';
                return false; // stop postback
            }

            return true; // continue postback
        }
    </script>

    <style>
        /* Ensure SweetAlert is always above all panels */
        .swal2-container {
            z-index: 999999 !important;
        }

        .swal2-popup {
            z-index: 9999999 !important;
        }
    </style>


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
