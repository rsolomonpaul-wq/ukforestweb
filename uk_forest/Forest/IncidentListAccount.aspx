<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="IncidentListAccount.aspx.cs" Inherits="uk_forest.Forest.IncidentListAccount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        /* 🔹 Ensure SweetAlert shows above the panel and repeater */
        .swal2-container {
            z-index: 999999 !important; /* Above your panel's 9999 */
            position: fixed !important;
        }

        .swal2-popup-highest {
            z-index: 1000000 !important;
            position: relative;
        }
    </style>

    <style>
        /* Payment Modal specific styling */
        .payment-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 10001 !important;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .payment-modal-content {
            background: white;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            padding: 20px;
            position: relative;
            z-index: 10002 !important;
            box-shadow: 0 8px 25px rgba(0,0,0,0.4);
        }


        .btn-disabled {
            opacity: 0.5;
            pointer-events: none;
            cursor: not-allowed;
        }

        .btn-enabled {
            opacity: 1;
            pointer-events: auto;
            cursor: pointer;
        }

        .payment-btn:hover:not(.btn-disabled) {
            opacity: 0.85;
            cursor: pointer;
        }

        /* Container full width */
        .container.divtab {
            border: 2px solid #43a047;
            padding: 0 0px 61px 0;
            width: 100%;
            max-width: 100% !important;
        }

        @media (min-width: 1200px) {
            .container {
                max-width: 100% !important;
            }
        }

        .tab-content-wrapper {
            margin-top: 12px;
            background: #fcfcfc;
            border-radius: 8px;
            width: 100%;
            max-width: 100% !important;
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
            width: 100%;
        }

            .form-row.mt-4 {
                border: 2px solid #23a510;
                padding: 15px;
                border-radius: 11px;
                width: 100%;
            }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .incident-table {
            width: 100% !important;
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

        .page-heading {
            font-size: 1.8rem;
            font-weight: 600;
            color: #23a510;
            text-align: center;
            margin-bottom: 25px;
            margin-top: 10px;
            text-transform: uppercase;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="grid_item" style="width: 100%;">
        <div class="container divtab">
            <div class="tab-content-wrapper">
                <h2 class="page-heading">Incident List</h2>

                <div class="form-container">
                    <div class="form-row mt-4">
                        <div class="table-responsive">
                            <asp:HiddenField ID="hdnSelectedIncidentId" runat="server" />
                            <asp:Label ID="lbl_msg_alert" runat="server" CssClass="alert alert-danger p-2 mb-0" Visible="false"></asp:Label>

                            <asp:GridView ID="gv_incident_list" runat="server"
                                AutoGenerateColumns="false"
                                CssClass="incident-table"
                                AllowPaging="true"
                                PageSize="50"
                                DataKeyNames="incidentId"
                                EmptyDataText="No incidents found!"
                                OnPageIndexChanging="gv_incident_list_PageIndexChanging">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Incident Id">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_incidentId" runat="server" Text='<%# Eval("incidentId") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="applicant Id" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_applicantId" runat="server" Text='<%# Eval("applicantId") %>'></asp:Label>
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
                                            <asp:Label ID="lbl_Status" runat="server" Text='<%# Eval("status") ?? "NA" %>' ForeColor="Red"></asp:Label>
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
                                </Columns>
                                <PagerStyle CssClass="pagination-grid" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Incident Details Panel -->
    <asp:Panel ID="pnlIncidentDetails" runat="server" Visible="false"
        Style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 9999; display: flex; align-items: center; justify-content: center;">
        <div style="background: white; border-radius: 8px; width: 90%; max-width: 900px; max-height: 90%; overflow-y: auto; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">

            <div style="background: #4a5568; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-radius: 8px 8px 0 0;">
                <h4 style="margin: 0; font-weight: 600; font-size: 18px;">View Incident Details</h4>
                <button type="button" onclick="hideIncidentPopup()"
                    style="background: none; border: none; color: white; font-size: 18px; cursor: pointer; padding: 5px;">
                    ✖</button>
            </div>

            <div style="padding: 20px;">
                <asp:Repeater ID="rptMainIncident" runat="server">
                    <ItemTemplate>
                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Applicant & Beneficiary Information</h5>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <asp:HiddenField ID="hfBeneficiaryId" runat="server" Value='<%# Eval("beneficiaryId") %>' />
                                <asp:HiddenField ID="hfamount" runat="server" Value='<%# Eval("totalAmount") %>' />

                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px;">Account Holder:</span>
                                    <span style="color: #2d3748;"><%# Eval("accHolderName") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px;">Account Number:</span>
                                    <span style="color: #2d3748;"><%# Eval("accNumber") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px;">Bank Name:</span>
                                    <span style="color: #2d3748;"><%# Eval("bankName") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px;">IFSC Code:</span>
                                    <span style="color: #2d3748;"><%# Eval("ifscCode") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px;">Aadhar No:</span>
                                    <span style="color: #2d3748;"><%# Eval("aadharNo") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px;">PAN No:</span>
                                    <span style="color: #2d3748;"><%# Eval("panNo") %></span>
                                </div>
                            </div>

                            <div style="margin-top: 20px; text-align: center;">
                                <span style="font-weight: 600; color: #4a5568;">Beneficiary Bank Document:</span><br />
                                <img src='<%# Eval("fullImagePath") %>' alt="Bank Document"
                                    style="margin-top: 10px; width: 300px; border-radius: 8px; border: 1px solid #ccc; display: inline-block;" />
                            </div>

                            <hr style="margin: 25px auto; width: 80%; border: 1px solid #cbd5e0;" />

                            <div style="text-align: center; margin-top: 15px;">
                                <asp:Button ID="btnApprove" runat="server" Text="Approve / Bank Verify Details" OnClick="btnApprove_Click" CssClass="btn btn-success" Style="background-color: #38a169; color: white; border: none; padding: 8px 18px; border-radius: 5px; margin-right: 12px; cursor: pointer;" />

                                <asp:Button ID="btnInsufficient" runat="server" Text="Insufficient Details" OnClick="btnInsufficient_Click" CssClass="btn btn-danger" Style="background-color: #e53e3e; color: white; border: none; padding: 8px 18px; border-radius: 5px; cursor: pointer;" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>


            <div style="padding: 20px; border-left: 4px solid #3182ce; background: #f7fafc; margin-bottom: 20px; border-radius: 0 6px 6px 0; margin-left: 20px; text-align: center;">
                <h4 class="text-success fw-bold">
                    <span style="font-weight: 600; color: #4a5568; min-width: 130px;">Compensation Amount : </span>
                    <span id="lblCompensationAmount" runat="server" style="color: #2d3748;"><%# Eval("compensation_amount") %></span>
                </h4>
            </div>

            <div style="padding: 20px; border-left: 4px solid #3182ce; background: #f7fafc; margin-bottom: 20px; border-radius: 0 6px 6px 0; margin-left: 20px; text-align: center;">
                <h4 class="text-success fw-bold">DFO Approved Documents</h4>

                <asp:LinkButton ID="lnkViewNotesheet" runat="server"
                    Text="Click here to view the uploaded notesheet"
                    Style="display: inline-block; margin-top: 8px; color: #0d6efd; text-decoration: underline; cursor: pointer; font-weight: 500;" />

                <br />

                <!-- Payment Proceed Button -->
                <asp:Button ID="btnPaymentProceed" runat="server" Text="Proceed Payment" OnClick="btnPaymentProceed_Click" CssClass="btn btn-success payment-btn" Style="margin-top: 15px; font-weight: 600; padding: 8px 25px; border-radius: 6px; display: inline-block;"/>
            </div>
        </div>
    </asp:Panel>

    <script>
        function showIncidentPopup() {
            var panel = document.getElementById('<%= pnlIncidentDetails.ClientID %>');
            if (panel) {
                panel.style.display = "flex";
                // Ensure incident modal has correct z-index
                panel.style.zIndex = "9999";
            }

           <%-- var btn = document.getElementById('<%= btnPaymentProceed.ClientID %>');
            if (btn) {
                btn.classList.remove('btn-enabled');
                btn.classList.add('btn-disabled');
            }--%>
        }

        function hideIncidentPopup() {
            var panel = document.getElementById('<%= pnlIncidentDetails.ClientID %>');
            if (panel) panel.style.display = "none";

            // Also hide payment modal if open
            hidePaymentModal();

            <%--var btn = document.getElementById('<%= btnPaymentProceed.ClientID %>');
            if (btn) {
                btn.classList.remove('btn-enabled');
                btn.classList.add('btn-disabled');
            }--%>
        }

        function showPaymentModal() {
            // Ensure incident details panel stays visible
            var incidentPanel = document.getElementById('<%= pnlIncidentDetails.ClientID %>');
            if (incidentPanel) {
                incidentPanel.style.display = "flex";
                incidentPanel.style.zIndex = "9999";
            }

            // Show payment modal on top
            var paymentPanel = document.getElementById('<%= pnlPaymentModal.ClientID %>');
            if (paymentPanel) {
                paymentPanel.style.display = "flex";
                paymentPanel.style.zIndex = "10001";
            }
        }

        function hidePaymentModal() {
            var paymentPanel = document.getElementById('<%= pnlPaymentModal.ClientID %>');
            if (paymentPanel) {
                paymentPanel.style.display = "none";
            }
            // Incident details panel will remain open
        }

        // Prevent background scroll when modals are open
        function disableScroll() {
            document.body.style.overflow = 'hidden';
        }

        function enableScroll() {
            document.body.style.overflow = 'auto';
        }

        // Call these functions when modals open/close
        window.addEventListener('load', function () {
            var incidentPanel = document.getElementById('<%= pnlIncidentDetails.ClientID %>');
            var paymentPanel = document.getElementById('<%= pnlPaymentModal.ClientID %>');

            if (incidentPanel && incidentPanel.style.display === 'flex') {
                disableScroll();
            }
        });
    </script>



    <asp:Panel ID="pnlPaymentModal" runat="server" Visible="false" CssClass="payment-modal-overlay">
        <div class="payment-modal-content">
            <button type="button" onclick="hidePaymentModal()"
                style="position: absolute; top: 10px; right: 10px; background: none; border: none; font-size: 20px; cursor: pointer; color: #666;">
                ✖
            </button>

            <h4 style="text-align: center; margin-bottom: 20px; color: #2d3748; font-weight: 600;">Payment Gateway</h4>

            <div style="margin-bottom: 20px;">
                <asp:Label ID="label1" runat="server">Select Payment Gateway</asp:Label>
                <asp:DropDownList ID="ddl_payment" runat="server" CssClass="form-control"
                    Style="width: 100%; padding: 10px; border: 2px solid #e2e8f0; border-radius: 6px; font-size: 14px;">
                    <asp:ListItem Text="Billdesk" Value="Billdesk"></asp:ListItem>
                    <asp:ListItem Text="Razor pay" Value="RazorPay"></asp:ListItem>
                    <asp:ListItem Text="CCAVENUE" Value="CCAVENUE"></asp:ListItem>
                    <asp:ListItem Text="PAYU MONEY" Value="PayUMoney"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div style="text-align: center;">
                <asp:Button ID="btnPayConfirm" runat="server" Text="Pay Now"
                    CssClass="btn btn-success"
                    OnClick="btnPaymentConfirm_Click"
                    Style="background-color: #38a169; color: white; border: none; padding: 10px 25px; border-radius: 6px; cursor: pointer; font-weight: 600;" />
            </div>
        </div>
    </asp:Panel>



</asp:Content>
