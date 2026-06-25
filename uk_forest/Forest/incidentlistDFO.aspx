<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Forest/masterpage.Master"  CodeBehind="incidentlistDFO.aspx.cs" Inherits="uk_forest.Forest.incidentlistDFO" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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

                    <fieldset class="radio-group" style="border: 2px solid #23a510; padding: 15px; border-radius: 10px;">
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
                            <asp:Label ID="lbl_msg_alert" runat="server" CssClass="alert alert-danger p-2 mb-0" Visible="false"></asp:Label>
                            <asp:GridView ID="gv_incident_list" runat="server" AutoGenerateColumns="false" CssClass="incident-table" AllowPaging="true" PageSize="50" DataKeyNames="IncidentId" EmptyDataText="No incidents found!" OnPageIndexChanging="gv_incident_list_PageIndexChanging">
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

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_Status" runat="server"
                                                Text='<%# Eval("Status") != null ? Eval("Status") : "NA" %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="150px" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddl_status_approved" runat="server" CssClass="ddl-with-icon form-control-sm" AutoPostBack="true" OnSelectedIndexChanged="ddl_status_approved_SelectedIndexChanged">
                                                <asp:ListItem Value="" Text="Action"></asp:ListItem>
                                                <asp:ListItem Value="View" Text="View Details"></asp:ListItem>
                                                <asp:ListItem Value="Verify_Document" Text="Verify Documents"></asp:ListItem>
                                                <asp:ListItem Value="Approve" Text="Approve"></asp:ListItem>
                                            </asp:DropDownList>
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

    <asp:Panel ID="pnlInfo" runat="server" Visible="false" CssClass="panel panel-info mt-3 mb-2">
        <div class="panel-heading fw-semibold">Details</div>
        <div class="panel-body">
            <asp:Label ID="lblDetail" runat="server" CssClass="details-label"></asp:Label>
            <!-- Add more display controls as needed -->
        </div>
    </asp:Panel>



   

  
   
</asp:Content>
