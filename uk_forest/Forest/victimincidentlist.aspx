<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="victimincidentlist.aspx.cs" Inherits="uk_forest.Forest.victimincidentlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
                color: #fff;
                padding: 12px 15px;
                text-align: left;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.85rem;
                border: 1px #000 solid;
                background-color:rgb(4 96 134);
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
            font-weight:500 !important;
        }

        @media (max-width: 768px) {
            .col-md-4 {
                margin-bottom: 1rem;
            }
        }

        .popup-panel {
            display: none; /* initially hidden */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* backdrop */
            z-index: 9999;
            justify-content: center;
            align-items: center;
            display: flex;
        }

        .popup-content {
            background: #fff;
            padding: 20px;
            width: 50%;
            max-width: 600px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
            animation: popupScale 0.3s ease;
        }

        .popup-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: 10px;
        }

        .popup-close {
            background: transparent;
            border: none;
            font-size: 1.2rem;
            cursor: pointer;
            color: #333;
        }

        .popup-body {
            font-size: 1rem;
            color: #444;
        }

        @keyframes popupScale {
            from {
                transform: scale(0.8);
                opacity: 0;
            }

            to {
                transform: scale(1);
                opacity: 1;
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

        .form-title {
            background-color: #2b4764;
            display: inline-block;
            padding: 9px 30px 11px 30px;
            float: right;
            margin-right: -12px;
            /*position: absolute;*/
            top: 10px;
            right: 5px;
            font-size: 1rem;
            color: #fff;
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

        <div class="step-item">
            <div class="circle">③</div>
            <div class="label">Add Victim Incident / घटना का विवरण</div>
        </div>
        <div class="arrow">→</div>

        <div class="step-item active">
            <div class="circle">④</div>
            <div class="label">Victim Incident List/ पीड़ित घटना सूची</div>
        </div>
    </div>

    <div class="grid_item">
        <div class="container divtab">
            <div class="tab-content-wrapper">
                <div class="form-container">

                    <%-- <fieldset class="radio-group" style="border: 2px solid #23a510; padding: 15px; border-radius: 10px;">
                        <legend style="font-weight: bold; color: #333; margin-bottom: 10px; text-align: center; width: auto; margin-left: auto; margin-right: auto;">
                            <asp:Label ID="lblClaimType" runat="server" Text="Select Claim Category"></asp:Label>
                        </legend>

                        <div class="d-flex flex-wrap justify-content-center" style="gap: 20px;">
                            <asp:RadioButtonList ID="rblClaimType" runat="server" RepeatDirection="Horizontal" CssClass="claim-radio-list" RepeatLayout="Flow" OnSelectedIndexChanged="rblClaimType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Text="Human Death / Injury" Value="HumanDeath" />
                                <asp:ListItem Text="Crop Field Damage" Value="CropField" />
                                <asp:ListItem Text="Cattle Kill / Injury" Value="CattleKill" />
                                <asp:ListItem Text="House Damage" Value="HouseDamage" />
                            </asp:RadioButtonList>
                        </div>
                    </fieldset>--%>
                    <div class="position-relative mb-3" style="display: flex; align-items: center; justify-content: center;">
                        <h2 class="font-weight-bold titleHeading mb-0 text-center" style="flex: 1;">Victim Incident Details / घटना का विवरण</h2>
                        <span class="applicant-id font-weight-bold form-title">Applicant ID / आवेदक आईडी:
                                    <asp:Label ID="lblapplicantid" runat="server"></asp:Label>
                        </span>
                    </div>

                    <fieldset class="radio-group" style="border: 2px solid #23a510; padding: 15px; border-radius: 8px; margin-top: 30px;">
                        <legend style="font-weight: 500; float: inherit; padding: 2px 10px; color: #fff; border-radius: 5px; background-color: #13460c; margin-bottom: 10px; text-align: center; width: auto; margin-left: auto; margin-right: auto; font-size: 18px;">
                            <asp:Label ID="lblClaimType" runat="server" Text="Claim Category / दावा श्रेणी"></asp:Label>
                        </legend>
                        <div class="d-flex flex-wrap justify-content-center" style="gap: 20px;">
                            <asp:RadioButtonList ID="rblClaimType" runat="server" RepeatDirection="Horizontal" CssClass="claim-radio-list" RepeatLayout="Flow" OnSelectedIndexChanged="rblClaimType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Text="All / सभी" Value="0" Selected="True" />
                                <asp:ListItem Text="Human Death / Injury / मानव मृत्यु / घायल" Value="Human" />
                                <asp:ListItem Text="Crop Damage / फसल क्षति" Value="Crop" />
                                <asp:ListItem Text="Cattle Kill / मवेशी मारना" Value="Cattle" />
                                <asp:ListItem Text="Property Damage / संपत्ति का नुकसान" Value="House" />
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
                                            <label for="txtFromDate" class="form-label fw-semibold text-dark">From Date / की तिथि से</label>
                                            <asp:TextBox ID="txtFromDate" runat="server"
                                                TextMode="Date"
                                                CssClass="form-control border-success"
                                                Style="border-width: 1.5px;">
                                            </asp:TextBox>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="txtToDate" class="form-label fw-semibold text-dark">To Date / तिथि तक</label>
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


                    <div class="form-row mt-4">
                        <div class="table-responsive">
                            <asp:Label ID="lbl_msg_alert" runat="server" CssClass="alert alert-danger p-2 mb-0" Visible="false"></asp:Label>
                            <asp:HiddenField ID="hdnVictimId" runat="server" />
                            <asp:HiddenField ID="hdnIncidentId" runat="server" />
                            <asp:Label ID="label9" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="label10" runat="server" Visible="false"></asp:Label>



                            <%--                              <asp:GridView ID="gvApplicantInfo" runat="server" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True" EmptyDataText="No applicant information available." CssClass="table table-bordered table-striped table-hover" GridLines="None" Width="100%" OnPageIndexChanging="gvApplicantInfo_PageIndexChanging" AllowPaging="True" PageSize="10">--%>


                            <asp:GridView ID="gv_incident_list" runat="server" AutoGenerateColumns="false" CssClass="incident-table table-responsive" AllowPaging="true" PageSize="50" DataKeyNames="incidentId" EmptyDataText="No incidents found!" OnPageIndexChanging="gv_incident_list_PageIndexChanging" Width="100%" OnRowDataBound="gv_incident_list_RowDataBound">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No. / क्र.सं.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Incident ID / घटना का आईडी">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_incidentId" runat="server" Text='<%# Eval("incidentId") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Victim ID / पीड़ित की आईडी" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_victimId" runat="server" Text='<%# Eval("victimId") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Victim Name / पीड़ित का नाम">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_fullName" runat="server" Text='<%# Eval("fullName") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Father Name / पिता का नाम">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_fatherName" runat="server" Text='<%# Eval("fatherName") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%--    <asp:TemplateField HeaderText="Gender">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_gender" runat="server" Text='<%# Eval("gender") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Age">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_age" runat="server" Text='<%# Eval("age") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Aadhar No">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_aadharNo" runat="server" Text='<%# Eval("aadharNo") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>

                                    <%--   <asp:TemplateField HeaderText="Mobile No">
                <ItemTemplate>
                    <asp:Label ID="lbl_mobileNo" runat="server" Text='<%# Eval("mobileNo") ?? "NA" %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>--%>



                                    <asp:TemplateField HeaderText="Incident Date / घटना दिनांक">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_incidentDate" runat="server" Text='<%# Eval("incidentDate") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Incident Time / घटना का समय">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_incidentTime" runat="server" Text='<%# Eval("incidentTime") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Animal Caused By / जानवर के कारण">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_animalName" runat="server" Text='<%# Eval("animalName") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Status / स्थिति">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_status" runat="server" Text='<%# Eval("status") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%--    <asp:TemplateField HeaderText="Remark">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_remark" runat="server" Text='<%# Eval("remark") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>

                                    <asp:TemplateField HeaderText="Claim Category / दावा श्रेणी">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_claimcategory" runat="server" Text='<%# Eval("claimCategory") ?? "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>



                                    <%--                                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="150px" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddl_status_approved" runat="server" CssClass="ddl-with-icon form-control-sm" AutoPostBack="true" OnSelectedIndexChanged="ddl_status_approved_SelectedIndexChanged">
                                                <asp:ListItem Value="" Text="Action"></asp:ListItem>
                                                <asp:ListItem Value="View" Text="View Details"></asp:ListItem>
                                                <asp:ListItem Value="UploadDocuments" Text="Upload Documents"></asp:ListItem>
                                                <asp:ListItem Value="Edite" Text="Edit document"></asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>



                                    <%--     <asp:TemplateField HeaderText="View Details">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkAssignFG" runat="server"
                                                Text="View Details"
                                                OnClick="lnkView_Click"
                                                Style="display: inline-block; padding: 10px 20px; border-radius: 25px; text-decoration: none; color: white; font-weight: 600; font-size: 14px; border: 1px solid #007bff; background: linear-gradient(135deg,#007bff 0%,#0056b3 100%); cursor: pointer; transition: all 0.3s ease; text-align: center; min-width: 120px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>


                                    <asp:TemplateField HeaderText="View / देखना">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkView" runat="server"
                                                OnClick="lnkView_Click"
                                                ToolTip="Click to view complete incident details" Style="display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; text-decoration: none; color: #26ad54; font-weight: 600; font-size: 25px; cursor: pointer; transition: all 0.3s ease;">
                                                     <i class="fas fa-eye"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Upload Documents / दस्तावेज़ अपलोड करें">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkuploaddocument" runat="server"
                                                Text="Upload Documents"
                                                OnClick="lnkuploaddocument_Click"
                                                title="Click here to upload your documents"
                                                Style="display: inline-block; padding: 10px 20px; border-radius: 25px; text-decoration: none; color: white; font-weight: 600; font-size: 14px; border: 1px solid #007bff; background: linear-gradient(135deg,#007bff 0%,#0056b3 100%); cursor: pointer; transition: all 0.3s ease; text-align: center; min-width: 120px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
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

                                </Columns>
                                <PagerStyle CssClass="pagination-grid" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <asp:Panel ID="pnlInfo" runat="server" Style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 9999; align-items: center; justify-content: center;">

        <div style="background: white; border-radius: 8px; width:750px; max-height: 90%; overflow-y: auto; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">
            <!-- Header -->
            <div style="background: #4a5568; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-radius: 8px 8px 0 0;position:fixed; width:735px;">
                <h4 style="margin: 0; font-weight: 600;">View Incident Details</h4>
                <button type="button" onclick="hidePopupinfo()" style="background: none; border: none; color: white; font-size: 18px; cursor: pointer; padding: 5px;">✖</button>
            </div>
            <!-- Content -->
            <div style="padding: 20px; margin-top:65px;">
                <asp:Repeater ID="rptIncidentDetails" runat="server" OnItemDataBound="rptIncidentDetails_ItemDataBound">
                    <ItemTemplate>
                        <!-- Applicant & Bank Information Section -->
                        <div style="border-left:4px solid #3182ce; background:#f7fafc; padding:15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Applicant & Beneficiary Information </h5>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Applicant ID:</span> <span style="color: #2d3748;"><%# Eval("applicantId") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Name:</span> <span style="color: #2d3748;"><%# Eval("applicantName") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhaar No.:</span> <span style="color: #2d3748;"><%# Eval("applicantAadharNo") %></span> </div>
                                <div style="display: flex;">
                                    <span style="font-weight: 600; color:#4a5568; min-width: 130px; margin-right: 10px;">Aadhaar Document:</span>
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
                                <%--  <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhar No:</span> <span style="color: #2d3748;"><%# Eval("victimAadharNo") %></span> </div>--%>

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





                                <%--    <div style="display: flex;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhar No:</span>
                                    <span style="color: #2d3748;">
                                        <%# string.IsNullOrEmpty(Eval("victimAadharNo")?.ToString()) ? "N/A" : Eval("victimAadharNo") %>
                                    </span>
                                </div>

                                <div style="display: flex;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Aadhar Document:</span>
                                    <asp:HyperLink ID="hlAadharDoc" runat="server" Text='<%# Eval("victimAadharDoc") == DBNull.Value || string.IsNullOrEmpty(Eval("victimAadharDoc").ToString()) ? "Not Available" : "View Document" %>' NavigateUrl='<%# Eval("victimAadharDoc") == DBNull.Value || string.IsNullOrEmpty(Eval("aadharDoc").ToString()) ? "#" : HostUrl + Eval("victimAadharDoc") %>' Target="_blank" Style="color: #3182ce; text-decoration: none;" />
                                </div>--%>
                            </div>
                        </div>
                        <!-- Incident Information Section -->
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Incident Information </h5>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident ID:</span> <span style="color: #2d3748;"><%# Eval("incidentId") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident Date:</span> <span style="color: #2d3748;"><%# FormatDate(Eval("incidentDate")) %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Incident Time:</span> <span style="color: #2d3748;"><%# Eval("incidentTime") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Caused By:</span> <span style="color: #2d3748;"><%# Eval("animalName") %></span> </div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Coordinates:</span> <span style="color: #2d3748;"><%# Eval("latitude") == DBNull.Value ? "-" : Eval("latitude") %>, <%# Eval("longitude") == DBNull.Value ? "-" : Eval("longitude") %> <a href='https://maps.google.com/?q=<%# Eval("latitude") %>,<%# Eval("longitude") %>' target="_blank" style="color: #3182ce; margin-left: 5px; text-decoration: none;">📍</a> </span></div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Status:</span> <span style="background: #fed7aa; color: #9a3412; padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 600;"><%# Eval("status") %> </span></div>
                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Range:</span> <span style="color: #2d3748;"><%# Eval("rangeName") %></span> </div>
                                <%--   <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Human Loss:</span> <span style="color: #2d3748;"><%# Eval("humanLoss") %></span> </div>--%>

                                <div style="display: flex;"><span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Claim Category:</span> <span style="color: #2d3748;"><%# Eval("claimCategory") %></span> </div>



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
                                    <div style="background: white; padding: 12px; margin-bottom: 12px; border-radius: 6px; border: 1px solid #e2e8f0;">
                                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 10px;">
                                            <div style="display: flex;"><span style="color: #2d3748;"><%# Eval("documentName") %></span> </div>
                                            <div style="display: flex;">
                                                <span style="font-weight: 600; color: #4a5568; min-width: 120px; margin-right: 10px;">File:</span>
                                                <asp:HyperLink ID="hlFilePath" runat="server" Text='<%# string.IsNullOrEmpty(Eval("documentPath")?.ToString()) ? "N/A" : "Download File" %>' NavigateUrl='<%# Eval("FullUrl") %>' Target="_blank" Style="color: #3182ce; text-decoration: none;" />
                                            </div>
                                        </div>
                                        <%-- Image preview --%>
                                        <asp:PlaceHolder ID="phPreview" runat="server">
                                            <!-- Show Image if file is image -->
                                            <asp:Image
                                                ID="imgThumbnail"
                                                runat="server"
                                                Visible='<%# IsImageFile(Eval("documentPath")?.ToString()) %>'
                                                ImageUrl='<%# Eval("FullUrl") %>'
                                                Style="width: 80px; height: 80px; object-fit: cover; border: 2px solid #e2e8f0; border-radius: 6px; margin-top: 8px;" />

                                            <!-- Show PDF Link if file is PDF -->
                                            <asp:HyperLink
                                                ID="hlPdfPreview"
                                                runat="server"
                                                Visible='<%# IsPdfFile(Eval("documentPath")?.ToString()) %>'
                                                NavigateUrl='<%# Eval("FullUrl") %>'
                                                Target="_blank"
                                                Text="View PDF"
                                                Style="display: block; color: #e53e3e; margin-top: 8px; font-weight: 500;" />
                                        </asp:PlaceHolder>


                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>



    </asp:Panel>



    <asp:Panel ID="PanelDocument" runat="server" Visible="false" CssClass="popup-panel" Style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 9999; overflow-y: auto; padding: 10px;">
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
                            <asp:Label ID="Label18" runat="server" CssClass="file-status" Visible="false"></asp:Label>
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
                            <asp:Label ID="lblEndorsementStatus" runat="server" CssClass="file-status" Visible="false"></asp:Label>
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
                            <asp:Label ID="Label15" runat="server" CssClass="file-status" Visible="false"></asp:Label>
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
                            <asp:Label ID="Label17" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <!-- Center Button -->
                    <div style="text-align: center; margin-top: 15px;">
                        <asp:Button ID="btnHumanDocumentsSave" runat="server" OnClick="btnHumanDocumentsSave_Click" Text="Save Remaining Documents" CssClass="btn btn-success" Style="padding: 8px 20px; border-radius: 6px; font-weight: 500; font-size: 1rem; cursor: pointer;" />
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
                            <asp:Label ID="Label2" runat="server" CssClass="file-status" Visible="false"></asp:Label>
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
                            <asp:Label ID="Label3" runat="server" CssClass="file-status" Visible="false"></asp:Label>
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
                            <asp:Label ID="Label5" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <!-- Center Button -->
                    <div style="text-align: center; margin-top: 15px;">
                        <asp:Button ID="btnCattleDocumentsSave" runat="server" Text="Save Cattle Documents" CssClass="btn btn-success" Style="padding: 8px 20px; border-radius: 6px; font-weight: 500; font-size: 1rem; cursor: pointer;" OnClick="btnCattleDocumentsSave_Click" />
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
                            <asp:Label ID="Label6" runat="server" CssClass="file-status" Visible="false"></asp:Label>
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
                            <asp:Label ID="Label7" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="text-align: center; margin-top: 15px;">
                        <asp:Button ID="btn_add_crop_damage_dcoument" runat="server" Text="Save Crop Documents" CssClass="btn btn-success" Style="padding: 8px 20px; border-radius: 6px; font-weight: 500; font-size: 1rem; cursor: pointer;" OnClick="btn_add_crop_damage_dcoument_Click" />
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
                            <asp:Label ID="Label4" runat="server" CssClass="file-status" Visible="false"></asp:Label>
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
                            <asp:Label ID="Label8" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div style="text-align: center; margin-top: 15px;">
                        <asp:Button ID="btn_add_damegehouse_document" runat="server" Text="Save Property Documents" CssClass="btn btn-success" Style="padding: 8px 20px; border-radius: 6px; font-weight: 500; font-size: 1rem; cursor: pointer;" OnClick="btn_add_damegehouse_document_Click" />
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <%--  <script type="text/javascript">
        function showPopup() {
            document.getElementById('<%= pnlInfo.ClientID %>').style.display = "flex";
            document.getElementById('<%= PanelDocument.ClientID %>').style.display = "none"; // hide other panel
        }

        function showPanelDocument() {
            document.getElementById('<%= PanelDocument.ClientID %>').style.display = "flex";
            document.getElementById('<%= pnlInfo.ClientID %>').style.display = "none"; // hide other panel
        }

        function hidePopup1() {
            document.getElementById('<%= pnlInfo.ClientID %>').style.display = "none";
        }

        function hidePopup() {
            document.getElementById('<%= PanelDocument.ClientID %>').style.display = "none";
        }
    </script>--%>


    <script type="text/javascript"> function showPopup() { document.getElementById('<%= pnlInfo.ClientID %>').style.display = "flex"; } function hidePopupinfo() { document.getElementById('<%= pnlInfo.ClientID %>').style.display = "none"; } </script>
    <script type="text/javascript"> function showPanelDocument() { document.getElementById('<%= PanelDocument.ClientID %>').style.display = "flex"; } function hidePopup() { document.getElementById('<%= PanelDocument.ClientID %>').style.display = "none"; } </script>




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
        '<%= MedicalCertificate.ClientID %>',
        '<%= DeathCertificate.ClientID %>',
        '<%= LegalHeirCertificate.ClientID %>',
        '<%= AdditionalPhotographs.ClientID %>',
        '<%= VeterinaryOfficer.ClientID %>',
        '<%= Panchnama.ClientID %>',
        '<%= cattleAdditionalPhotographs.ClientID %>',
        '<%= khatakhatoni.ClientID %>',
        '<%= khatakhatoniAdditionalPhotographs.ClientID %>',
        '<%= khatakhatoniHousepropertyAdditionalPhotographs.ClientID %>',
        '<%= khatakhatoniHouseAdditionalPhotographs.ClientID %>'
            ];

       <%--     const statusLabels = {
        '<%= MedicalCertificate.ClientID %>': '<%= Label18.ClientID %>',
        '<%= DeathCertificate.ClientID %>': '<%= lblEndorsementStatus.ClientID %>',
        '<%= LegalHeirCertificate.ClientID %>': '<%= Label15.ClientID %>',
        '<%= AdditionalPhotographs.ClientID %>': '<%= Label17.ClientID %>',
        '<%= VeterinaryOfficer.ClientID %>': '<%= Label2.ClientID %>',
        '<%= Panchnama.ClientID %>': '<%= Label3.ClientID %>',
        '<%= cattleAdditionalPhotographs.ClientID %>': '<%= Label5.ClientID %>',
        '<%= khatakhatoni.ClientID %>': '<%= Label6.ClientID %>',
        '<%= khatakhatoniAdditionalPhotographs.ClientID %>': '<%= Label7.ClientID %>',
        '<%= khatakhatoniHousepropertyAdditionalPhotographs.ClientID %>': '<%= Label4.ClientID %>',
        '<%= khatakhatoniHouseAdditionalPhotographs.ClientID %>': '<%= Label8.ClientID %>'
            };--%>

            //fileUploads.forEach(uploadId => {
            //    const upload = document.getElementById(uploadId);
            //    const statusLabelId = statusLabels[uploadId];
            //    const statusLabel = statusLabelId ? document.getElementById(statusLabelId) : null;
            //    if (!upload) return;

            //    const wrapper = upload.closest('.file-upload-wrapper');

            //    upload.addEventListener('change', function (e) {
            //        const file = e.target.files[0];
            //        if (file) handleFile(file, statusLabel, wrapper);
            //    });

            //    wrapper.addEventListener('dragover', e => {
            //        e.preventDefault();
            //        wrapper.classList.add('dragover');
            //    });
            //    wrapper.addEventListener('dragleave', e => {
            //        e.preventDefault();
            //        wrapper.classList.remove('dragover');
            //    });
            //    wrapper.addEventListener('drop', e => {
            //        e.preventDefault();
            //        wrapper.classList.remove('dragover');
            //        const files = e.dataTransfer.files;
            //        if (files.length > 0) {
            //            upload.files = files;
            //            handleFile(files[0], statusLabel, wrapper);
            //        }
            //    });
            //});

            function handleFile(file, statusLabel, wrapper) {
                const maxSize = 2 * 1024 * 1024;
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf'];

                if (file.size > maxSize || !allowedTypes.includes(file.type)) {
                    showFileStatus(statusLabel,
                        !allowedTypes.includes(file.type)
                            ? 'Only JPG, PNG, and PDF files are allowed'
                            : 'File size exceeds 2MB limit', 'error');
                    return;
                }

                showFileStatus(statusLabel, `File uploaded: ${file.name} (${(file.size / 1024).toFixed(1)} KB)`, 'success');

                // Show inline file info (like before) without buttons
                let existingPreview = wrapper.querySelector('.upload-success');
                if (!existingPreview) {
                    const previewDiv = document.createElement('div');
                    previewDiv.classList.add('upload-success');
                    previewDiv.style.display = 'flex';
                    previewDiv.style.alignItems = 'center';
                    previewDiv.style.gap = '8px';
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






























































    <style>
.swal2-container {
    z-index: 9999999 !important;
}
</style>











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
            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript"> 
        function showPopupEditDocument()
        {
            document.getElementById('<%= Paneleditdocument.ClientID %>').style.display = "flex";
        }

        function hidePopupEditDocument()
        {
            document.getElementById('<%= Paneleditdocument.ClientID %>').style.display = "none";
        }

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
