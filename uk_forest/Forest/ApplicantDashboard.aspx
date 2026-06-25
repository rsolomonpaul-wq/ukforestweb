<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="ApplicantDashboard.aspx.cs" Inherits="uk_forest.Forest.ApplicantDashboard" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">





    <style>
        /* Existing forest card styles... */

        .icon-wrapper-paid {
    background-color: #28a745; /* green for paid */
    color: white;
    border-radius: 50%;
    width: 50px;
    height: 50px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

        .forest-card {
            background: #ffffff;
            border: 1px solid rgba(46, 111, 64, 0.1);
            border-radius: 12px;
            position: relative;
            margin-bottom: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(46, 111, 64, 0.1);
            height: 140px;
        }

            .forest-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(46, 111, 64, 0.2);
            }

        .forest-pattern {
            position: absolute;
            top: 0;
            right: 0;
            width: 80px;
            height: 80px;
            opacity: 0.03;
            background-image: radial-gradient(circle, #2E6F40 2px, transparent 2px);
            background-size: 15px 15px;
            pointer-events: none;
        }

        /* Forest Color Schemes */
        .total-cases {
            border-left: 4px solid #2E6F40;
        }

        .pending-cases {
            border-left: 4px solid #8B4513;
        }

        .active-cases {
            border-left: 4px solid #228B22;
        }

        .returned-cases {
            border-left: 4px solid #CD853F;
        }

        .card-content {
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 15px;
            height: 100%;
        }

        .icon-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }

        .icon-wrapper {
            width: 45px;
            height: 45px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            transition: all 0.3s ease;
        }

        .total-cases .icon-wrapper {
            background: linear-gradient(135deg, #2E6F40, #3E7F50);
            box-shadow: 0 3px 12px rgba(46, 111, 64, 0.3);
        }

        .pending-cases .icon-wrapper {
            background: linear-gradient(135deg, #8B4513, #A0522D);
            box-shadow: 0 3px 12px rgba(139, 69, 19, 0.3);
        }

        .active-cases .icon-wrapper {
            background: linear-gradient(135deg, #228B22, #32CD32);
            box-shadow: 0 3px 12px rgba(34, 139, 34, 0.3);
        }

        .returned-cases .icon-wrapper {
            background: linear-gradient(135deg, #F00, #C20D0D);
            box-shadow: 0 3px 12px rgba(205, 133, 63, 0.3);
        }

        .icon-wrapper i {
            font-size: 20px;
            color: white;
        }

        .forest-card:hover .icon-wrapper {
            transform: scale(1.1) rotate(5deg);
        }

        .trend-badge {
            padding: 2px 6px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 2px;
            transition: all 0.3s ease;
        }

            /* Dynamic Trend Badge Colors */
            .trend-badge.high-trend {
                background: rgba(34, 139, 34, 0.15);
                color: #228B22 !important;
                border: 1px solid rgba(34, 139, 34, 0.3);
            }

            .trend-badge.low-trend {
                background: rgba(220, 53, 69, 0.15);
                color: #dc3545 !important;
                border: 1px solid rgba(220, 53, 69, 0.3);
            }

        .content-section {
            flex: 1;
        }

        .card-title {
            font-size: 13px;
            font-weight: 600;
            color: #2E6F40;
            margin: 0 0 5px 0;
            opacity: 0.8;
        }

        .main-number {
            font-size: 26px;
            font-weight: 700;
            color: #2C3E50;
            margin: 0;
            line-height: 1.1;
        }

        .subtitle {
            font-size: 11px;
            color: #7F8C8D;
            margin: 2px 0 8px 0;
        }

        .progress-wrapper {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .mini-progress {
            flex: 1;
            height: 8px;
            background: #E8F5E8;
            border-radius: 2px;
            overflow: hidden;
            position: relative;
        }

        .progress-fill {
            height: 100%;
            border-radius: 2px;
            width: 0%;
            transition: width 1.5s ease-out, background 0.3s ease;
        }

            /* Dynamic Progress Bar Colors - High Percentage (>=35%) */
            .progress-fill.high-progress {
                background: linear-gradient(90deg, #28a745, #20c997) !important;
                box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
            }

            /* Dynamic Progress Bar Colors - Low Percentage (<35%) */
            .progress-fill.low-progress {
                background: linear-gradient(90deg, #dc3545, #e74c3c) !important;
                box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
            }

        .progress-label {
            font-size: 10px;
            font-weight: 600;
            min-width: 25px;
            transition: color 0.3s ease;
        }

            /* Dynamic Progress Label Colors */
            .progress-label.high-percentage {
                color: #28a745 !important;
            }

            .progress-label.low-percentage {
                color: #dc3545 !important;
            }

        /* Loading Animations */
        .forest-card {
            opacity: 0;
            transform: translateY(20px);
            animation: forestCardLoad 0.6s ease forwards;
        }

            .forest-card:nth-child(1) {
                animation-delay: 0.1s;
            }

            .forest-card:nth-child(2) {
                animation-delay: 0.2s;
            }

            .forest-card:nth-child(3) {
                animation-delay: 0.3s;
            }

            .forest-card:nth-child(4) {
                animation-delay: 0.4s;
            }

        @keyframes forestCardLoad {
            0% {
                opacity: 0;
                transform: translateY(20px);
            }

            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .forest-card {
                height: 120px;
                margin-bottom: 15px;
            }

            .card-content {
                padding: 15px;
                gap: 12px;
            }

            .icon-wrapper {
                width: 40px;
                height: 40px;
            }

                .icon-wrapper i {
                    font-size: 18px;
                }

            .main-number {
                font-size: 22px;
            }

            .card-title {
                font-size: 12px;
            }
        }

        .toggle-details {
            font-size: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">
        <div class="row">
            <!-- Total Cases -->
            <div class="col-xl-3 col-lg-3 col-md-6 col-sm-12 col-12">
                <div class="forest-card total-cases">
                    <div class="forest-pattern"></div>
                    <div class="card-content">
                        <div class="icon-section">
                            <div class="icon-wrapper">
                                <i class="fas fa-chart-bar"></i>
                            </div>
                        </div>
                        <div class="content-section">
                            <h5 class="card-title">Total Cases / कुल मामले</h5>
                            <h3 class="main-number">
                                <asp:Label ID="lblTotalCases" runat="server" Text="3,243"></asp:Label>
                            </h3>
                            <p class="subtitle">All registered cases / सभी दर्ज मामले</p>
                            <div class="progress-wrapper">
                                <div class="mini-progress" id="totalProgress">
                                    <div class="progress-fill"></div>
                                </div>
                                <span class="progress-label" id="totalPercentage">0%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        

            <!-- Active Cases -->
            <div class="col-xl-3 col-lg-3 col-md-6 col-sm-12 col-12">
                <div class="forest-card active-cases">
                    <div class="forest-pattern"></div>
                    <div class="card-content">
                        <div class="icon-section">
                            <div class="icon-wrapper">
                                <i class="fas fa-sync-alt"></i>
                            </div>
                        </div>
                        <div class="content-section">
                            <h5 class="card-title">Active Cases / एक्टिव केस</h5>
                            <h3 class="main-number">
                                <asp:Label ID="lblActiveCases" runat="server" Text="578"></asp:Label>
                            </h3>
                            <p class="subtitle">Currently processing / वर्तमान में प्रसंस्करण हो रहा है</p>
                            <div class="progress-wrapper">
                                <div class="mini-progress" id="activeProgress">
                                    <div class="progress-fill"></div>
                                </div>
                                <span class="progress-label" id="activePercentage">0%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Returned Cases -->
            <div class="col-xl-3 col-lg-3 col-md-6 col-sm-12 col-12">
                <div class="forest-card returned-cases">
                    <div class="forest-pattern"></div>
                    <div class="card-content">
                        <div class="icon-section">
                            <div class="icon-wrapper">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                        </div>
                        <div class="content-section">
                            <h5 class="card-title">Returned Cases / लौटाए गए मामले</h5>
                            <h3 class="main-number">
                                <asp:Label ID="lblReturnedCases" runat="server" Text="11,610"></asp:Label>
                            </h3>
                            <p class="subtitle">Requires attention / ध्यान देने की आवश्यकता है</p>
                            <div class="progress-wrapper">
                                <div class="mini-progress" id="returnedProgress">
                                    <div class="progress-fill"></div>
                                </div>
                                <span class="progress-label" id="returnedPercentage">0%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>



                <!-- Paid Cases -->
            <div class="col-xl-3 col-lg-3 col-md-6 col-sm-12 col-12">
                <div class="forest-card pending-cases">
                    <div class="forest-pattern"></div>
                    <div class="card-content">
                        <div class="icon-section">
                            <div class="icon-wrapper-paid">
                                <%--<i class="fas fa-hourglass-half"></i>--%>
                                <i class="fas fa-rupee-sign"></i>
                            </div>
                        </div>
                        <div class="content-section">
                            <h5 class="card-title">Paid Cases / भुगतान किये गये मामले</h5>
                            <h3 class="main-number">
                                <asp:Label ID="lblPendingCases" runat="server" Text="15,070"></asp:Label>
                            </h3>
                            <p class="subtitle">Closed Cases / बंद किये गये मामले</p>
                            <div class="progress-wrapper">
                                <div class="mini-progress" id="pendingProgress">
                                    <div class="progress-fill"></div>
                                </div>
                                <span class="progress-label" id="pendingPercentage">0%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>



        <div class="row">
            <div class="table-responsive">


                     <!-- Add Button (Always Visible) -->
        <div style="margin-bottom:10px; text-align:right;">
            <asp:Button
                ID="btnAdd"
                runat="server"
                Text="Add Incident / घटना जोड़ें"
                ToolTip="Click here to add a new incident / नई घटना जोड़ने के लिए यहां क्लिक करें"
                Style="background: #2ebd2e; color: white; padding: 4px 7px 5px 7px; border: none; border-radius: 35px; font-weight: bold; height: 30px; width: 200px;"
                OnClick="btnAdd_Click" />
        </div>



                <asp:Label ID="lblmsg" runat="server" Visible="false"></asp:Label>
                <asp:Repeater ID="rptCases" runat="server" OnItemDataBound="rptCases_ItemDataBound">
                    <HeaderTemplate>
                        <table class="table " style="width: 100%; border-collapse: collapse; border: 1px solid #000000b8;">
                            <thead style="background-color: #07935d; color: white;">
                                <tr>
                                    <th style="text-align: center;">
                                        
                                    </th>


                                    <!-- Icon Column -->
                                    <th style="color: white !important">S.No. / क्र.सं.</th>
                                    <th style="color: white !important">Incident ID / घटना का आईडी</th>
                                    <th style="color: white !important">Claim Category / दावा श्रेणी</th>
                                    <th style="color: white !important">Status / स्थिति</th>
                            <%--        <th style="color: white !important">Victim ID</th>--%>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>

                    <ItemTemplate>
                        <tr>
                            <td style="text-align: center;">
                                <a href="javascript:void(0);" class="toggle-details">
                                    <i class="fas fa-plus"></i>
                                </a>
                            </td>
                            <td><%# Container.ItemIndex + 1 %></td>
                            <td><%# Eval("incidentId") %></td>
                            <td><%# Eval("claimCategory") %></td>
                            <td>
                                <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("status") %>'></asp:Label>
                            </td>
                         <%--   <td><%# Eval("victimId") %></td>--%>
                        </tr>

                        <!-- Expandable Row -->
                        <tr class="details-row" style="display: none;">
                            <td colspan="6" style="background-color: #f8f9fa;">
                                <div style="border: 2px solid black; padding: 10px; overflow: auto;">
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>


                    <FooterTemplate>
                        </tbody>
        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>





        




    </div>


    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script type="text/javascript">
        var apiBaseUrl = '<%= System.Configuration.ConfigurationManager.AppSettings["api_path"] %>';

        $(document).ready(function () {
            $(".toggle-details").click(function () {
                var $icon = $(this).find("i");
                var $mainRow = $(this).closest("tr");
                var $detailsRow = $mainRow.next(".details-row");
                var $detailsDiv = $detailsRow.find("div");

                // Toggle plus/minus icon with smooth animation
                if ($detailsRow.is(":visible")) {
                    $detailsRow.slideUp(300);
                    $icon.removeClass("fa-minus").addClass("fa-plus");
                } else {
                    $detailsRow.slideDown(300);
                    $icon.removeClass("fa-plus").addClass("fa-minus");

                    var incident_id = $mainRow.find("td").eq(2).text().trim();
                    var fullUrl = apiBaseUrl + "IncidentProgressLogs/GetIncidentProgressLog?incident_id=" + incident_id;

                    // Show loading state
                    $detailsDiv.html('<div class="loading-state"><i class="fa fa-spinner fa-spin"></i> Loading progress...</div>');

                    $.ajax({
                        url: fullUrl,
                        type: "GET",
                        contentType: "application/json",
                        success: function (data) {
                            if (data && data.length > 0) {

                                // Check if only "Application Submission" exists
                                var hasOnlyApplicationSubmission = data.length === 1 &&
                                    data[0].action &&
                                    data[0].action.toLowerCase().includes('application submission');

                                // If only Application Submission, add Document Verified as inactive step
                                if (hasOnlyApplicationSubmission) {
                                    data.push({
                                        action: "Document Verified",
                                        timestamp: null,
                                        isInactive: true // Custom flag for inactive step
                                    });
                                }

                                var html = `
                        <div class="horizontal-tracker">
                            <div class="progress-steps" data-steps="${data.length}">
                                <div class="progress-line-container">
                                    <div class="progress-line-bg"></div>
                                    <div class="progress-line-fill ${hasOnlyApplicationSubmission ? 'pending-progress' : ''}"></div>
                                </div>
                    `;

                                data.forEach(function (log, index) {
                                    var isReturned = log.action && log.action.toLowerCase().includes('returned');
                                    var isInactive = log.isInactive || false;

                                    var statusClass = 'success-status';
                                    var iconClass = 'fa-check';

                                    if (isInactive) {
                                        statusClass = 'inactive-status';
                                        iconClass = 'fa-clock';
                                    } else if (isReturned) {
                                        statusClass = 'returned-status';
                                        iconClass = 'fa-times';
                                    }

                                    // Add dynamic animation delay
                                    var animationDelay = (index * 0.8) + 's'; // 0.8s per step

                                    html += `
    <div class="step-item ${isInactive ? 'inactive-step' : ''}" data-step="${index + 1}" style="animation-delay: ${animationDelay};">
        <div class="step-circle ${statusClass}">
            <i class="fa ${iconClass}"></i>
        </div>
        <div class="step-content">
            <div class="step-title ${isReturned ? 'returned-text' : ''} ${isInactive ? 'inactive-text' : ''}">${log.action}</div>
            <div class="step-meta">
                ${log.timestamp ? log.timestamp : (isInactive ? 'Pending' : '')}
            </div>
        </div>
    </div>
    `;
                                });


                                html += `
                            </div>
                        </div>
                        
                        <div class="application-details-section">
                            <div class="section-header">
                                <h4 class="section-title">
                                    <i class="fas fa-file-alt"></i>
                                    Incident Details
                                </h4>
                           
                            </div>
                            
                            <div class="details-grid" id="incident-details-${incident_id}">
                                <div class="loading-details">
                                    <i class="fas fa-spinner fa-spin"></i>
                                    Loading application details...
                                </div>
                            </div>
                            
                         
                        </div>
                        
                        <!-- Preview Side Panel -->
                        <div class="preview-side-panel" id="preview-panel-${incident_id}">
                            <div class="panel-header">
                                <h3><i class="fas fa-file-contract"></i> Document Preview</h3>
                                <button class="panel-close" onclick="closePreviewPanel('${incident_id}')">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                            <div class="panel-content" id="preview-content-${incident_id}">
                                <div class="preview-loading">
                                    <i class="fas fa-spinner fa-spin"></i>
                                    Loading preview...
                                </div>
                            </div>
                        </div>
                        
                        <style>
                        .horizontal-tracker {
                            background: #f8f9fa;
                            border-radius: 12px;
                            padding: 24px;
                            margin: 16px 0;
                            border: 1px solid #e6f3e6;
                            box-shadow: 0 2px 8px rgba(34, 139, 34, 0.1);
                        }
                        
                        .progress-steps {
                            display: flex;
                            align-items: flex-start;
                            justify-content: space-between;
                            position: relative;
                            overflow-x: auto;
                            padding: 10px 0;
                        }
                        
                        /* Progress Line Container */
                        .progress-line-container {
                            position: absolute;
                            top: 30px;
                            left: 60px; /* Fixed left position */
                            right: 60px; /* Fixed right position */
                            height: 4px;
                            z-index: 1;
                        }
                        
                        /* Set CSS variables based on step count */
                        .progress-steps[data-steps="2"] {
                            --total-steps: 2;
                        }
                        .progress-steps[data-steps="2"] .progress-line-container {
                            left: 70px;
                            right: 70px;
                        }
                        
                        .progress-steps[data-steps="3"] {
                            --total-steps: 3;
                        }
                        .progress-steps[data-steps="3"] .progress-line-container {
                            left: 70px;
                            right: 70px;
                        }
                        
                        .progress-steps[data-steps="4"] {
                            --total-steps: 4;
                        }
                        .progress-steps[data-steps="4"] .progress-line-container {
                            left: 70px;
                            right: 70px;
                        }
                        
                        .progress-steps[data-steps="5"] {
                            --total-steps: 5;
                        }
                        .progress-steps[data-steps="5"] .progress-line-container {
                            left: 70px;
                            right: 70px;
                        }
                        
                        .progress-steps[data-steps="6"] {
                            --total-steps: 6;
                        }
                        .progress-steps[data-steps="6"] .progress-line-container {
                            left: 70px;
                            right: 70px;
                        }

                        .progress-steps[data-steps="7"] {
                            --total-steps: 7;
                        }

                        .progress-steps[data-steps="7"] .progress-line-container {
                            left: 70px;
                            right: 70px;
                        }

                        .progress-steps[data-steps="8"] {
                            --total-steps: 8;
                        }

                        .progress-steps[data-steps="8"] .progress-line-container {
                            left: 70px;
                            right: 70px;
                        }

                        .progress-steps[data-steps="9"] {
                            --total-steps: 9;
                        }

                        .progress-steps[data-steps="9"] .progress-line-container {
                            left: 70px;
                            right: 70px;
                        }

                        
                        /* Background Line */
                        .progress-line-bg {
                            width: 100%;
                            height: 100%;
                            background: #e9ecef;
                            border-radius: 2px;
                        }
                        
                        /* Normal Progress Line Animation */
                        .progress-line-fill {
                            position: absolute;
                                top: 0;
                                left: 0;
                                height: 100%;
                                background: linear-gradient(90deg, #28a745, #20c997);
                                border-radius: 2px;
                                width: 0%;
                                animation: progressLineAnimation 6s ease-in-out forwards;
                                box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
                                animation-delay: 0.5s;
                        }
                        
                        /* Pending Progress Line Animation (stops at 50%) */
                        .progress-line-fill.pending-progress {
                            background: linear-gradient(90deg, #28a745, #ffc107);
                            animation: progressLineAnimationPending 6s ease-in-out forwards;
                        }
                        
                       @keyframes progressLineAnimation {
                        0% {
                            width: 0%;
                            opacity: 0.8;
                        }
                        15% {
                            opacity: 1;
                        }
                        100% {
                            width: 100%;
                            opacity: 1;
                        }
                    }
                        
                        @keyframes progressLineAnimationPending {
                            0% {
                                width: 0%;
                                opacity: 0.8;
                                background: linear-gradient(90deg, #28a745, #20c997);
                            }
                            50% {
                                background: linear-gradient(90deg, #28a745, #ffc107);
                                opacity: 1;
                            }
                            100% {
                                width: 50%;
                                background: linear-gradient(90deg, #28a745, #ffc107);
                                opacity: 1;
                            }
                        }
                        
                        .step-item {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            position: relative;
                            min-width: 120px;
                            flex: 1;
                            text-align: center;
                            opacity: 0;
                            transform: translateY(20px);
                            animation: slideUp 0.8s ease forwards;
                            z-index: 2;
                        }
                        
                        /* Inactive steps have different animation timing */
                        .step-item.inactive-step {
                            animation: slideUpInactive 0.8s ease forwards;
                        }
                        
                        .step-item:nth-child(2) { animation-delay: 1.2s; }
                        .step-item:nth-child(3) { animation-delay: 2.4s; }
                        .step-item:nth-child(4) { animation-delay: 3.6s; }
                        .step-item:nth-child(5) { animation-delay: 4.8s; }
                        .step-item:nth-child(6) { animation-delay: 6.0s; }
                        .step-item:nth-child(7) { animation-delay: 7.2s; }
                        .step-item:nth-child(8) { animation-delay: 8.4s; }
                        .step-item:nth-child(9) { animation-delay: 9.6s; }
                        
                        .step-circle {
                            width: 40px;
                            height: 40px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            position: relative;
                            z-index: 3;
                            transition: all 0.3s ease;
                            margin-bottom: 12px;
                            border: 3px solid white;
                            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
                        }
                        
                        /* Green Success Status */
                        .step-circle.success-status {
                            background: linear-gradient(135deg, #28a745, #20c997);
                        }
                        
                        .step-circle.success-status:hover {
                            transform: scale(1.1);
                            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.4);
                        }
                        
                        /* Red Returned Status */
                        .step-circle.returned-status {
                            background: linear-gradient(135deg, #dc3545, #c82333);
                            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
                        }
                        
                        .step-circle.returned-status:hover {
                            transform: scale(1.1);
                            box-shadow: 0 6px 16px rgba(220, 53, 69, 0.4);
                        }
                        
                        /* Pending Status - Orange/Yellow with glowing effect */
                        .step-circle.inactive-status {
                            background: linear-gradient(135deg, #ffc107, #ff8f00);
                            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
                            border: 2px solid #ffecb3;
                            opacity: 0.9;
                            position: relative;
                        }
                        
                        .step-circle.inactive-status:hover {
                            transform: scale(1.05);
                            opacity: 1;
                            box-shadow: 0 6px 16px rgba(255, 193, 7, 0.5);
                        }
                        
                        /* Pending glow effect */
                        .step-circle.inactive-status::before {
                            content: '';
                            position: absolute;
                            top: -3px;
                            left: -3px;
                            right: -3px;
                            bottom: -3px;
                            border-radius: 50%;
                            border: 2px solid rgba(255, 193, 7, 0.3);
                            animation: pendingGlow 3s ease-in-out infinite;
                            z-index: -1;
                        }
                        
                        @keyframes pendingGlow {
                            0%, 100% {
                                border-color: rgba(255, 193, 7, 0.3);
                                transform: scale(1);
                            }
                            50% {
                                border-color: rgba(255, 193, 7, 0.6);
                                transform: scale(1.1);
                            }
                        }
                        
                        .step-circle i {
                            color: white;
                            font-size: 16px;
                            font-weight: bold;
                        }
                        
                        /* Pending icon with pulse animation */
                        .step-circle.inactive-status i {
                            color: white;
                            font-size: 16px;
                            animation: pendingPulse 2s ease-in-out infinite;
                        }
                        
                        @keyframes pendingPulse {
                            0%, 100% {
                                opacity: 1;
                                transform: scale(1);
                            }
                            50% {
                                opacity: 0.7;
                                transform: scale(1.1);
                            }
                        }
                        
                        .step-content {
                            max-width: 140px;
                            word-wrap: break-word;
                        }
                        
                        .step-title {
                            font-size: 14px;
                            font-weight: 600;
                            color: #2d5a2d;
                            margin-bottom: 6px;
                            line-height: 1.3;
                            text-align: center;
                        }
                        
                        /* Red text for returned items */
                        .step-title.returned-text {
                            color: #721c24;
                        }
                        
                        /* Orange text for pending items */
                        .step-title.inactive-text {
                            color: #e65100;
                            opacity: 0.9;
                            font-weight: 600;
                        }
                        
                        .step-meta {
                            font-size: 12px;
                            color: #6c757d;
                            text-align: center;
                        }
                        
                        /* Pending step meta styling with warning color */
                        .inactive-step .step-meta {
                            color: #f57c00;
                            font-style: italic;
                            font-weight: 500;
                        }
                        
                        /* Application Details Section */
                        .application-details-section {
                            background: #ffffff;
                            border-radius: 12px;
                            padding: 24px;
                            margin: 20px 0 16px 0;
                            border: 1px solid #e9ecef;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                            animation: slideInUp 0.6s ease forwards;
                            animation-delay: 1s;
                            opacity: 0;
                            transform: translateY(20px);
                        }
                        
                        .section-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 24px;
                            padding-bottom: 16px;
                            border-bottom: 2px solid #f8f9fa;
                        }
                        
                        .section-title {
                            font-size: 18px;
                            font-weight: 700;
                            color: #2c3e50;
                            margin: 0;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }
                        
                        .section-title i {
                            color: #28a745;
                            font-size: 16px;
                        }
                        
                        /* Clickable Preview Badge */
                        .preview-badge {
                            background: linear-gradient(135deg, #28a745, #20c997);
                            color: white;
                            padding: 6px 16px;
                            border-radius: 20px;
                            font-size: 12px;
                            font-weight: 600;
                            display: flex;
                            align-items: center;
                            gap: 6px;
                            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
                            cursor: pointer;
                            transition: all 0.3s ease;
                        }
                        
                        .preview-badge:hover {
                            transform: translateY(-2px) scale(1.05);
                            box-shadow: 0 4px 16px rgba(40, 167, 69, 0.4);
                            background: linear-gradient(135deg, #20c997, #17a2b8);
                        }
                        
                        .preview-badge:active {
                            transform: translateY(0) scale(1);
                            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
                        }
                        
                        /* Side Panel Styles */
                        .preview-side-panel {
                            position: fixed;
                            top: 0;
                            right: -450px;
                            width: 400px;
                            height: 100vh;
                            background: #ffffff;
                            box-shadow: -5px 0 20px rgba(0, 0, 0, 0.15);
                            z-index: 1000;
                            transition: right 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
                            border-left: 3px solid #28a745;
                        }
                        
                        .preview-side-panel.active {
                            right: 0;
                        }
                        
                        .panel-header {
                            background: linear-gradient(135deg, #28a745, #20c997);
                            color: white;
                            padding: 20px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        
                        .panel-header h3 {
                            margin: 0;
                            font-size: 18px;
                            font-weight: 600;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }
                        
                        .panel-close {
                            background: rgba(255, 255, 255, 0.2);
                            border: none;
                            color: white;
                            width: 35px;
                            height: 35px;
                            border-radius: 50%;
                            cursor: pointer;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            transition: all 0.3s ease;
                        }
                        
                        .panel-close:hover {
                            background: rgba(255, 255, 255, 0.3);
                            transform: scale(1.1);
                        }
                        
                        .panel-content {
                            padding: 20px;
                            height: calc(100vh - 80px);
                            overflow-y: auto;
                        }
                        
                        .preview-loading {
                            text-align: center;
                            padding: 50px 20px;
                            color: #6c757d;
                            font-size: 16px;
                        }
                        
                        .preview-loading i {
                            margin-right: 10px;
                            color: #28a745;
                            font-size: 18px;
                        }
                        
                        /* Panel Overlay */
                        .panel-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100vw;
                            height: 100vh;
                            background: rgba(0, 0, 0, 0.5);
                            z-index: 999;
                            opacity: 0;
                            visibility: hidden;
                            transition: all 0.3s ease;
                        }
                        
                        .panel-overlay.active {
                            opacity: 1;
                            visibility: visible;
                        }
                        
                        .details-grid {
                            display: flex;
                            flex-direction: column;
                            gap: 20px;
                        }
                        
                        .detail-row {
                            display: grid;
                            grid-template-columns: repeat(3, 1fr);
                            gap: 20px;
                        }
                        
                        .detail-item {
                            display: flex;
                            flex-direction: column;
                            gap: 6px;
                        }
                        
                        .detail-item.full-width {
                            grid-column: 1 / -1;
                        }
                        
                        .detail-label {
                            font-size: 12px;
                            font-weight: 600;
                            color: #6c757d;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                        }
                        
                        .detail-value {
                            font-size: 14px;
                            font-weight: 500;
                            color: #2c3e50;
                            padding: 8px 12px;
                            background: #f8f9fa;
                            border-radius: 6px;
                            border: 1px solid #e9ecef;
                        }
                        
                        .status-badge {
                            padding: 8px 16px;
                            border-radius: 20px;
                            font-size: 12px;
                            font-weight: 600;
                            text-align: center;
                            border: none;
                        }
                        
                        .status-badge.processing {
                            background: linear-gradient(135deg, #ffc107, #ff8f00);
                            color: white;
                        }
                        
                        .status-badge.returned {
                            background: linear-gradient(135deg, #dc3545, #c82333);
                            color: white;
                        }
                        
                        .status-badge.approved {
                            background: linear-gradient(135deg, #28a745, #20c997);
                            color: white;
                        }
                        
                        .loading-details {
                            text-align: center;
                            padding: 40px;
                            color: #6c757d;
                            font-size: 14px;
                        }
                        
                        .loading-details i {
                            margin-right: 8px;
                            color: #28a745;
                            font-size: 16px;
                        }
                        
                        .action-buttons {
                            display: flex;
                            gap: 12px;
                            margin-top: 24px;
                            padding-top: 20px;
                            border-top: 1px solid #f8f9fa;
                        }
                        
                        .btn-primary, .btn-secondary {
                            padding: 10px 20px;
                            border-radius: 8px;
                            font-size: 14px;
                            font-weight: 600;
                            border: none;
                            cursor: pointer;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            transition: all 0.3s ease;
                        }
                        
                        .btn-primary {
                            background: linear-gradient(135deg, #28a745, #20c997);
                            color: white;
                            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
                        }
                        
                        .btn-primary:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 4px 16px rgba(40, 167, 69, 0.4);
                        }
                        
                        .btn-secondary {
                            background: #6c757d;
                            color: white;
                            box-shadow: 0 2px 8px rgba(108, 117, 125, 0.3);
                        }
                        
                        .btn-secondary:hover {
                            background: #5a6268;
                            transform: translateY(-2px);
                            box-shadow: 0 4px 16px rgba(108, 117, 125, 0.4);
                        }
                        
                        .loading-state {
                            text-align: center;
                            padding: 24px;
                            color: #6c757d;
                            font-size: 14px;
                        }
                        
                        .loading-state i {
                            margin-right: 8px;
                            color: #28a745;
                        }
                        
                        .error-state {
                            text-align: center;
                            padding: 24px;
                            background: #f8d7da;
                            border-radius: 8px;
                            color: #721c24;
                            font-size: 14px;
                            border-left: 4px solid #dc3545;
                        }
                        
                        .empty-state {
                            text-align: center;
                            padding: 32px;
                            color: #6c757d;
                            font-size: 14px;
                            background: #f8f9fa;
                            border-radius: 8px;
                            border: 2px dashed #dee2e6;
                        }
                        
                        .empty-state:before {
                            content: "📋";
                            display: block;
                            font-size: 32px;
                            margin-bottom: 12px;
                            opacity: 0.5;
                        }
                        
                        @keyframes slideUp {
                            to {
                                opacity: 1;
                                transform: translateY(0);
                            }
                        }
                        
                        /* Separate animation for pending steps */
                        @keyframes slideUpInactive {
                            to {
                                opacity: 0.9;
                                transform: translateY(0);
                            }
                        }
                        
                        @keyframes slideInUp {
                            to {
                                opacity: 1;
                                transform: translateY(0);
                            }
                        }
                        
                        /* Responsive Design */
                        @media (max-width: 768px) {
                            .horizontal-tracker {
                                padding: 16px;
                            }
                            
                            .progress-steps {
                                flex-direction: column;
                                align-items: stretch;
                            }
                            
                            .progress-line-container {
                                display: none;
                            }
                            
                            .step-item {
                                flex-direction: row;
                                text-align: left;
                                min-width: auto;
                                margin-bottom: 20px;
                                align-items: center;
                            }
                            
                            .step-circle {
                                width: 32px;
                                height: 32px;
                                margin-right: 16px;
                                margin-bottom: 0;
                            }
                            
                            .step-circle i {
                                font-size: 12px;
                            }
                            
                            .step-content {
                                max-width: none;
                                flex: 1;
                            }
                            
                            .step-title {
                                text-align: left;
                                font-size: 15px;
                            }
                            
                            .step-meta {
                                text-align: left;
                            }
                            
                            .application-details-section {
                                padding: 16px;
                                margin: 16px 0;
                            }
                            
                            .detail-row {
                                grid-template-columns: 1fr;
                                gap: 16px;
                            }
                            
                            .section-header {
                                flex-direction: column;
                                gap: 12px;
                                align-items: flex-start;
                            }
                            
                            .action-buttons {
                                flex-direction: column;
                            }
                            
                            .preview-side-panel {
                                width: 100vw;
                                right: -100vw;
                            }
                        }
                        
                        @media (max-width: 480px) {
                            .step-title {
                                font-size: 13px;
                            }
                            
                            .step-meta {
                                font-size: 11px;
                            }
                            
                            .section-title {
                                font-size: 16px;
                            }
                            
                            .detail-value {
                                font-size: 13px;
                            }
                        }
                        </style>
                    `;

                                $detailsDiv.html(html);

                                // Fetch incident details after progress tracker is loaded
                                setTimeout(function () {
                                    fetchIncidentDetails(incident_id);
                                }, 2000); // Wait for progress animation to complete

                                // Add click event for preview badge after DOM is ready
                                setTimeout(function () {
                                    $('.clickable-preview').off('click').on('click', function () {
                                        var incidentId = $(this).data('incident-id');
                                        openPreviewPanel(incidentId);
                                    });
                                }, 500);

                            } else {
                                $detailsDiv.html(`
                        <div class="empty-state">
                            No progress information available for Incident ID: ${incident_id}
                        </div>
                    `);
                            }
                        },
                        error: function (err) {
                            $detailsDiv.html(`
                    <div class="error-state">
                        <strong>Unable to load progress information</strong><br>
                        Please try again or contact support if the issue persists.
                    </div>
                `);
                            console.error("API Error:", err);
                        }
                    });
                }
            });

            // Add overlay to body if not exists
            if (!$('.panel-overlay').length) {
                $('body').append('<div class="panel-overlay"></div>');
            }

            // Close panel when clicking overlay
            $(document).on('click', '.panel-overlay', function () {
                var activePanel = $('.preview-side-panel.active');
                if (activePanel.length) {
                    var incidentId = activePanel.attr('id').replace('preview-panel-', '');
                    closePreviewPanel(incidentId);
                }
            });
        });

        // Preview Panel Functions
        function openPreviewPanel(incidentId) {
            // Close any existing open panels
            $('.preview-side-panel.active').removeClass('active');
            $('.panel-overlay.active').removeClass('active');

            // Open the specific panel
            var panel = $('#preview-panel-' + incidentId);
            var overlay = $('.panel-overlay');

            setTimeout(function () {
                overlay.addClass('active');
                panel.addClass('active');
            }, 50);

            // Load preview content
            loadPreviewContent(incidentId);
        }

        function closePreviewPanel(incidentId) {
            var panel = $('#preview-panel-' + incidentId);
            var overlay = $('.panel-overlay');

            panel.removeClass('active');
            overlay.removeClass('active');
        }

        function loadPreviewContent(incidentId) {
            var previewContent = $('#preview-content-' + incidentId);

            // Show loading
            previewContent.html(`
            <div class="preview-loading">
                <i class="fas fa-spinner fa-spin"></i>
                Loading preview content...
            </div>
        `);

            // Simulate preview content loading (replace with actual API call)
            setTimeout(function () {
                var mockPreviewContent = `
                <div style="padding: 20px;">
                    <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                        <h4 style="color: #28a745; margin-bottom: 15px;">
                            <i class="fas fa-file-pdf"></i> Document Preview
                        </h4>
                        <div style="background: white; padding: 15px; border-radius: 5px; margin-bottom: 10px;">
                            <strong>Application Form:</strong> application_${incidentId}.pdf
                        </div>
                        <div style="background: white; padding: 15px; border-radius: 5px; margin-bottom: 10px;">
                            <strong>Incident Photos:</strong> incident_photos_${incidentId}.zip
                        </div>
                        <div style="background: white; padding: 15px; border-radius: 5px; margin-bottom: 10px;">
                            <strong>Medical Report:</strong> medical_report_${incidentId}.pdf
                        </div>
                        <div style="background: white; padding: 15px; border-radius: 5px;">
                            <strong>Verification Document:</strong> verification_${incidentId}.pdf
                        </div>
                    </div>
                    
                    <div style="background: #e8f5e8; padding: 20px; border-radius: 8px;">
                        <h4 style="color: #2d5a2d; margin-bottom: 15px;">
                            <i class="fas fa-info-circle"></i> Quick Actions
                        </h4>
                        <button style="background: #28a745; color: white; border: none; padding: 10px 20px; border-radius: 5px; margin-right: 10px; margin-bottom: 10px; cursor: pointer;">
                            <i class="fas fa-download"></i> Download All
                        </button>
                        <button style="background: #17a2b8; color: white; border: none; padding: 10px 20px; border-radius: 5px; margin-bottom: 10px; cursor: pointer;">
                            <i class="fas fa-print"></i> Print Preview
                        </button>
                    </div>
                </div>
            `;

                previewContent.html(mockPreviewContent);
            }, 1500);
        }

    </script>



    <script>
        // Add this function outside the main ready function
        function fetchIncidentDetails(incident_id) {
            var detailsUrl = apiBaseUrl + "TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId=" + incident_id;

            $.ajax({
                url: detailsUrl,
                type: "GET",
                contentType: "application/json",
                success: function (detailsData) {
                    if (detailsData) {
                        // Helper function to determine status badge class
                        function getStatusClass(status) {
                            if (status && status.toLowerCase().includes('returned')) {
                                return 'returned';
                            } else if (status && status.toLowerCase().includes('approved')) {
                                return 'approved';
                            } else {
                                return 'processing';
                            }
                        }

                        // Helper function to format date
                        function formatDate(dateString) {
                            if (!dateString) return 'N/A';
                            var date = new Date(dateString);
                            return date.toLocaleDateString('en-GB'); // DD/MM/YYYY format
                        }

                        // Helper function to determine claim category
                        function getClaimCategory(conflictCategory) {
                            if (conflictCategory === 'Human') {
                                return 'Human Death/Injury';
                            } else if (conflictCategory === 'Crop') {
                                return 'Crop Damage';
                            } else if (conflictCategory === 'Livestock') {
                                return 'Livestock Loss';
                            } else {
                                return conflictCategory || 'Not Specified';
                            }
                        }

                        var detailsHtml = `
                    <div class="detail-row">
                        <div class="detail-item">
                            <label class="detail-label">Applicant ID</label>
                            <span class="detail-value">${detailsData.applicantId || 'N/A'}</span>
                        </div>
                        <div class="detail-item">
                            <label class="detail-label">Victim Name</label>
                            <span class="detail-value">${detailsData.victimName || 'N/A'}</span>
                        </div>
                        <div class="detail-item">
                            <label class="detail-label">Age</label>
                            <span class="detail-value">${detailsData.victimAge ? detailsData.victimAge + ' Years' : 'N/A'}</span>
                        </div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-item">
                            <label class="detail-label">Claim Category</label>
                            <span class="detail-value">${getClaimCategory(detailsData.claimCategory)}</span>
                        </div>
                        <div class="detail-item">
                            <label class="detail-label">Date of Incident</label>
                            <span class="detail-value">${formatDate(detailsData.incidentDate)}</span>
                        </div>
                        <div class="detail-item">
                            <label class="detail-label">Incident Occurred By</label>
                            <span class="detail-value">${detailsData.animalName || 'N/A'} ${detailsData.localName ? '(' + detailsData.localName + ')' : ''}</span>
                        </div>
                    </div>
                `;

                        // Update the details grid
                        $('#incident-details-' + incident_id).html(detailsHtml);

                        // Show action buttons
                        $('#action-buttons-' + incident_id).show();

                        console.log('Incident details loaded successfully for ID:', incident_id);

                    } else {
                        $('#incident-details-' + incident_id).html(`
                    <div class="error-state">
                        <strong>No details found</strong><br>
                        Unable to load application details for Incident ID: ${incident_id}
                    </div>
                `);
                    }
                },
                error: function (err) {
                    console.error('Error fetching incident details:', err);
                    $('#incident-details-' + incident_id).html(`
                <div class="error-state">
                    <strong>Failed to load details</strong><br>
                    Please try again or contact support if the issue persists.
                </div>
            `);
                }
            });
        }

    </script>


    <script>
        // Dynamic Percentage Calculation from Labels
        document.addEventListener('DOMContentLoaded', function () {

            function calculateAndUpdatePercentages() {
                try {
                    // Read values from ASP.NET labels (remove commas and convert to integers)
                    var totalCases = parseInt($('#<%=lblTotalCases.ClientID%>').text().replace(/,/g, '')) || 0;
                    var pendingCases = parseInt($('#<%=lblPendingCases.ClientID%>').text().replace(/,/g, '')) || 0;
                    var activeCases = parseInt($('#<%=lblActiveCases.ClientID%>').text().replace(/,/g, '')) || 0;
                    var returnedCases = parseInt($('#<%=lblReturnedCases.ClientID%>').text().replace(/,/g, '')) || 0;

                    // Calculate grand total of all cases
                    var grandTotal = totalCases + pendingCases + activeCases + returnedCases;

                    console.log('Data:', {
                        totalCases: totalCases,
                        pendingCases: pendingCases,
                        activeCases: activeCases,
                        returnedCases: returnedCases,
                        grandTotal: grandTotal
                    });

                    // Calculate percentages (avoid division by zero)
                    if (grandTotal > 0) {
                        var totalPercentage = Math.round((totalCases / grandTotal) * 100);
                        var pendingPercentage = Math.round((pendingCases / grandTotal) * 100);
                        var activePercentage = Math.round((activeCases / grandTotal) * 100);
                        var returnedPercentage = Math.round((returnedCases / grandTotal) * 100);

                        // Update progress bars and labels with color logic
                        setTimeout(function () {
                            // Total Cases
                            updateProgressWithColor('#totalProgress', '#totalPercentage', totalPercentage);
                            $('.total-cases .trend-value').text(totalPercentage + '%');
                            updateTrendBadgeColor('.total-cases .trend-badge', totalPercentage);

                            // Pending Cases  
                            updateProgressWithColor('#pendingProgress', '#pendingPercentage', pendingPercentage);
                            $('.pending-cases .trend-value').text(pendingPercentage + '%');
                            updateTrendBadgeColor('.pending-cases .trend-badge', pendingPercentage);

                            // Active Cases
                            updateProgressWithColor('#activeProgress', '#activePercentage', activePercentage);
                            $('.active-cases .trend-value').text(activePercentage + '%');
                            updateTrendBadgeColor('.active-cases .trend-badge', activePercentage);

                            // Returned Cases
                            updateProgressWithColor('#returnedProgress', '#returnedPercentage', returnedPercentage);
                            $('.returned-cases .trend-value').text(returnedPercentage + '%');
                            updateTrendBadgeColor('.returned-cases .trend-badge', returnedPercentage);

                        }, 800);

                        console.log('Calculated Percentages:', {
                            total: totalPercentage + '%',
                            pending: pendingPercentage + '%',
                            active: activePercentage + '%',
                            returned: returnedPercentage + '%'
                        });

                    } else {
                        console.log('Grand total is 0, cannot calculate percentages');
                        // Set all percentages to 0 if no data
                        $('.progress-fill').css('width', '0%');
                        $('.progress-label').text('0%');
                        $('.trend-value').text('0%');
                    }

                } catch (error) {
                    console.error('Error calculating percentages:', error);
                }
            }

            // Alternative calculation method (if you want percentage relative to total cases only)
            function calculateRelativeToTotal() {
                try {
                    var totalCases = parseInt($('#<%=lblTotalCases.ClientID%>').text().replace(/,/g, '')) || 0;
                    var pendingCases = parseInt($('#<%=lblPendingCases.ClientID%>').text().replace(/,/g, '')) || 0;
                    var activeCases = parseInt($('#<%=lblActiveCases.ClientID%>').text().replace(/,/g, '')) || 0;
                    var returnedCases = parseInt($('#<%=lblReturnedCases.ClientID%>').text().replace(/,/g, '')) || 0;

                    if (totalCases > 0) {
                        var pendingPercent = Math.round((pendingCases / totalCases) * 100);
                        var activePercent = Math.round((activeCases / totalCases) * 100);
                        var returnedPercent = Math.round((returnedCases / totalCases) * 100);

                        setTimeout(function () {
                            // Total is always 100% - always green
                            updateProgressWithColor('#totalProgress', '#totalPercentage', 100);
                            $('.total-cases .trend-value').text('100%');
                            updateTrendBadgeColor('.total-cases .trend-badge', 100);

                            // Others relative to total with color logic
                            updateProgressWithColor('#pendingProgress', '#pendingPercentage', pendingPercent);
                            $('.pending-cases .trend-value').text(pendingPercent + '%');
                            updateTrendBadgeColor('.pending-cases .trend-badge', pendingPercent);

                            updateProgressWithColor('#activeProgress', '#activePercentage', activePercent);
                            $('.active-cases .trend-value').text(activePercent + '%');
                            updateTrendBadgeColor('.active-cases .trend-badge', activePercent);

                            updateProgressWithColor('#returnedProgress', '#returnedPercentage', returnedPercent);
                            $('.returned-cases .trend-value').text(returnedPercent + '%');
                            updateTrendBadgeColor('.returned-cases .trend-badge', returnedPercent);
                        }, 800);
                    }
                } catch (error) {
                    console.error('Error in relative calculation:', error);
                }
            }

            // Function to update progress bar with color based on percentage
            function updateProgressWithColor(progressSelector, labelSelector, percentage) {
                var progressBar = $(progressSelector + ' .progress-fill');
                var progressLabel = $(labelSelector);

                // Set width
                progressBar.css('width', Math.min(percentage, 100) + '%');
                progressLabel.text(percentage + '%');

                // Remove existing color classes
                progressBar.removeClass('low-progress high-progress');
                progressLabel.removeClass('low-percentage high-percentage');

                // Apply color based on percentage
                if (percentage < 35) {
                    // Red color for low percentage
                    progressBar.addClass('low-progress');
                    progressLabel.addClass('low-percentage');
                } else {
                    // Green color for high percentage  
                    progressBar.addClass('high-progress');
                    progressLabel.addClass('high-percentage');
                }
            }

            // Function to update trend badge colors
            function updateTrendBadgeColor(badgeSelector, percentage) {
                var badge = $(badgeSelector);

                // Remove existing color classes
                badge.removeClass('low-trend high-trend');

                // Apply color based on percentage
                if (percentage < 35) {
                    badge.addClass('low-trend');
                } else {
                    badge.addClass('high-trend');
                }
            }

            // Choose which calculation method to use
            // Method 1: Percentage of grand total (all cases combined)
            //calculateAndUpdatePercentages();

            // Method 2: Percentage relative to total cases only
            calculateRelativeToTotal();

        });
    </script>





</asp:Content>
