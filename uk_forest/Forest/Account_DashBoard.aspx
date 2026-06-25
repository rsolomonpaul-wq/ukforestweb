<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Forest/forestmaster.Master" Async="true" CodeBehind="Account_DashBoard.aspx.cs" Inherits="uk_forest.Forest.Account_DashBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Human-Wildlife Conflict Dashboard</title>
    <script src="https://cdn.amcharts.com/lib/5/index.js"></script>
    <script src="https://cdn.amcharts.com/lib/5/percent.js"></script>
    <script src="https://cdn.amcharts.com/lib/5/themes/Animated.js"></script>
    <script src="https://cdn.amcharts.com/lib/5/plugins/exporting.js"></script>
    <script src="https://cdn.amcharts.com/lib/5/xy.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        /* 🌿 UNIVERSAL STYLES */
        #gvIncidents {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Segoe UI', sans-serif;
            font-size: 15px;
        }
        table#ContentPlaceHolder1_gvIncidents th{
            color:#fff;
        }

            #gvIncidents th {
                background-color: #13460c !important;
                text-align: center;
                padding: 15px !important;
            }

            #gvIncidents td {
                padding: 15px !important;
                text-align: center;
                vertical-align: middle !important;
                border-bottom: 1px solid #ddd;
            }

            #gvIncidents tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            #gvIncidents tr:hover {
                background-color: #f1f1f1;
                transition: 0.3s;
            }

        /* 📊 Chart containers */
        #chartdiv,
        #barChartDiv {
            width: 100%;
            height: 400px;
            margin: 0 auto;
            overflow: hidden;
        }

        .am5legend {
            justify-content: center !important;
        }

        /* 🌲 Forest Cards */
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
            display: flex;
            align-items: center;
        }

            .forest-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(46, 111, 64, 0.2);
            }

        /* 🌿 Decorative Pattern */
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

        /* 🌈 Card Variants */
        .total-cases {
            border-left: 4px solid #2E6F40;
        }

        .active-cases {
            border-left: 4px solid #228B22;
        }

        .pending-cases {
            border-left: 4px solid #8B4513;
        }

        .returned-cases {
            border-left: 4px solid #CD853F;
        }

        /* 🧩 Card Content */
        .card-content {
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 15px;
            height: 100%;
        }

        /* 🔹 Icon Section */
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
            transition: all 0.3s ease;
        }

            .icon-wrapper i {
                font-size: 20px;
                color: white;
            }

        /* 🎨 Icon Gradient Colors */
        .total-cases .icon-wrapper {
            background: linear-gradient(135deg, #2E6F40, #3E7F50);
            box-shadow: 0 3px 12px rgba(46, 111, 64, 0.3);
        }

        .active-cases .icon-wrapper {
            background: linear-gradient(135deg, #228B22, #32CD32);
            box-shadow: 0 3px 12px rgba(34, 139, 34, 0.3);
        }

        .pending-cases .icon-wrapper {
            background: linear-gradient(135deg, #8B4513, #A0522D);
            box-shadow: 0 3px 12px rgba(139, 69, 19, 0.3);
        }

        .returned-cases .icon-wrapper {
            background: linear-gradient(135deg, #CD853F, #DEB887);
            box-shadow: 0 3px 12px rgba(205, 133, 63, 0.3);
        }

        .forest-card:hover .icon-wrapper {
            transform: scale(1.1) rotate(5deg);
        }

        /* 🧾 Text Section */
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
            font-size:24px;
            font-weight:700;
            color: #2C3E50;
            margin: 0;
            line-height: 1.1;
        }
        .subtitle {
            font-size: 11px;
            color: #7F8C8D;
            margin: 2px 0 8px 0;
        }

        /* 🟩 Progress Bar */
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

            .progress-fill.high-progress {
                background: linear-gradient(90deg, #28a745, #20c997) !important;
                box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
            }

            .progress-fill.low-progress {
                background: linear-gradient(90deg, #dc3545, #e74c3c) !important;
                box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
            }

        .progress-label {
            font-size: 10px;
            font-weight: 600;
            min-width: 25px;
        }

            .progress-label.high-percentage {
                color: #28a745 !important;
            }

            .progress-label.low-percentage {
                color: #dc3545 !important;
            }

        /* 🌟 Fade Animation */
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

        /* 🧠 RESPONSIVE DESIGN */

        /* Tablets (≤992px) */
        @media (max-width: 992px) {
            .d-flex.flex-nowrap {
                flex-wrap: wrap !important;
                gap: 10px;
            }

            .col-lg-3, .col-xl-3 {
                flex: 1 1 calc(50% - 10px);
                max-width: calc(50% - 10px);
            }

            .forest-card {
                height: 130px;
            }

            #barChartDiv {
                height: 350px;
            }
        }

        /* Mobile Landscape (≤768px) */
        @media (max-width: 768px) {
            .col-lg-3, .col-xl-3 {
                flex: 1 1 100%;
                max-width: 100%;
            }

            .forest-card {
                height: auto;
                padding: 12px;
            }

            .card-content {
                flex-direction: row;
                align-items: center;
                gap: 10px;
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

            #gvIncidents {
                font-size: 13px;
            }

                #gvIncidents td, #gvIncidents th {
                    padding: 10px !important;
                }

            #chartdiv, #barChartDiv {
                height: 300px;
            }
        }

        /* Small Phones (≤480px) */
        @media (max-width: 480px) {
            .forest-card {
                flex-direction: column;
                align-items: flex-start;
                height: auto;
                text-align: left;
            }

            .card-content {
                flex-direction: column;
                align-items: flex-start;
            }

            .icon-section {
                flex-direction: row;
                gap: 10px;
            }

            .main-number {
                font-size: 20px;
            }

            .subtitle {
                font-size: 10px;
            }

            .progress-wrapper {
                width: 100%;
            }

            #chartdiv, #barChartDiv {
                height: 250px;
            }
        }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="row align-items-end mb-2 filterrow w-100">
        <div class="col-md-4 col-lg-2">
            <label for="dataType" class="form-label">Claim Category</label>
            <asp:DropDownList ID="ddlDataType" runat="server" CssClass="form-select shadow-sm">
                <asp:ListItem Text="All" Value="0" />
                <asp:ListItem Text="Human Death / Injury" Value="Human" />
                <asp:ListItem Text="Cattle Kill" Value="Cattle" />
                <asp:ListItem Text="Crop Damage" Value="Crop" />
                <asp:ListItem Text="Property Damage" Value="House" />
            </asp:DropDownList>
        </div>

        <div class="col-md-4 col-lg-2">
            <asp:Label ID="lblStartDate" runat="server" AssociatedControlID="txtFromDate" CssClass="form-label" Text="Start Date"></asp:Label>
            <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control shadow-sm" TextMode="Date" />
        </div>

        <div class="col-md-4 col-lg-2">
            <asp:Label ID="lblEndDate" runat="server" AssociatedControlID="txtToDate" CssClass="form-label" Text="End Date"></asp:Label>
            <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control shadow-sm" TextMode="Date" />
        </div>

        <div class="col-md-4 col-lg-2">
            <asp:Label runat="server" CssClass="form-label d-block " Text="Division"></asp:Label>
            <asp:DropDownList ID="ddlDivision" runat="server" CssClass="form-select shadow-sm" OnSelectedIndexChanged="ddlDivision_SelectedIndexChanged" AutoPostBack="true">
            </asp:DropDownList>
        </div>

        <div class="col-md-4 col-lg-2">
            <asp:Label runat="server" CssClass="form-label d-block " Text="Range"></asp:Label>
            <asp:DropDownList ID="ddlRange" runat="server" CssClass="form-select shadow-sm" AutoPostBack="true">
            </asp:DropDownList>
        </div>

        <div class="col-md-4 col-lg-2">
            <asp:Label runat="server" CssClass="form-label d-block invisible" Text="Search"></asp:Label>
            <asp:Button ID="btnSearch" runat="server" Text="Filter" CssClass="btn btn-success w-100" OnClick="btnSearch_Click" />
        </div>
    </div>

    <div class="d-flex flex-nowrap justify-content-between" style="gap: 5px;">

        <!-- 💰 Total Budget Allocated -->
        <div class="col-xl-3 col-lg-3">
            <div class="forest-card total-cases">
                <div class="forest-pattern"></div>
                <div class="card-content">
                    <div class="icon-section">
                        <div class="icon-wrapper bg-success text-white">
                            <i class="fas fa-piggy-bank"></i>
                        </div>
                    </div>
                    <div class="content-section">
                        <h5 class="card-title">Total Budget Allocated</h5>
                        <h3 class="main-number">
                            <asp:Label ID="lbltotalBudgetAllocated" runat="server" Text=""></asp:Label>
                        </h3>
                        <p class="subtitle">Overall sanctioned fund</p>
                        <div class="progress-wrapper">
                            <div class="mini-progress" id="totalProgressbudget">
                                <div class="progress-fill"></div>
                            </div>
                            <span class="progress-label" id="totalPercentagebudget">0%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 🟢 Amount Disbursed -->
        <div class="col-xl-3 col-lg-3">
            <div class="forest-card active-cases">
                <div class="forest-pattern"></div>
                <div class="card-content">
                    <div class="icon-section">
                        <div class="icon-wrapper bg-info text-white">
                            <i class="fas fa-hand-holding-usd"></i>
                        </div>
                    </div>
                    <div class="content-section">
                        <h5 class="card-title">Amount Disbursed</h5>
                        <h3 class="main-number">
                            <asp:Label ID="lblamountDisbursed" runat="server" Text=""></asp:Label>
                        </h3>
                        <p class="subtitle">Funds released so far</p>
                        <div class="progress-wrapper">
                            <div class="mini-progress" id="pendingProgressbudget">
                                <div class="progress-fill"></div>
                            </div>
                            <span class="progress-label" id="pendingPercentagebudget">0%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 🔵 Pending Payments -->
        <div class="col-xl-3 col-lg-3">
            <div class="forest-card pending-cases">
                <div class="forest-pattern"></div>
                <div class="card-content">
                    <div class="icon-section">
                        <div class="icon-wrapper bg-warning text-white">
                            <i class="fas fa-clock"></i>
                        </div>
                    </div>
                    <div class="content-section">
                        <h5 class="card-title">Pending Payments</h5>
                        <h3 class="main-number">
                            <asp:Label ID="lblpendingPayments" runat="server" Text=""></asp:Label>
                        </h3>
                        <p class="subtitle">Payments under processing</p>
                        <div class="progress-wrapper">
                            <div class="mini-progress" id="activeProgressbudget">
                                <div class="progress-fill"></div>
                            </div>
                            <span class="progress-label" id="activePercentagebudget">0%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 🟠 Remaining Balance -->
        <div class="col-xl-3 col-lg-3">
            <div class="forest-card returned-cases">
                <div class="forest-pattern"></div>
                <div class="card-content">
                    <div class="icon-section">
                        <div class="icon-wrapper bg-primary text-white">
                            <i class="fas fa-wallet"></i>
                        </div>
                    </div>
                    <div class="content-section">
                        <h5 class="card-title">Remaining Balance</h5>
                        <h3 class="main-number">
                            <asp:Label ID="lblremainingBalance" runat="server" Text=""></asp:Label>
                        </h3>
                        <p class="subtitle">Funds available for utilization</p>
                        <div class="progress-wrapper">
                            <div class="mini-progress" id="returnedProgressbudget">
                                <div class="progress-fill"></div>
                            </div>
                            <span class="progress-label" id="returnedPercentagebudget">0%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <div class="row">
        <div class="col-lg-4 col-md-6 col-12">
            <div id="chartdiv"></div>
        </div>

        <div class="col-lg-8 col-md-6 col-12">
            <div id="barChartDiv" style="width: 100%; height: 400px;"></div>
        </div>
    </div>

    <div class="row mt-4">
        <div class="col-lg-12 col-md-6 col-12">
            <asp:GridView ID="gvIncidents" runat="server"
                AutoGenerateColumns="False"
                CssClass="table table-bordered"
                HeaderStyle-BackColor="#07965A" HeaderStyle-ForeColor="White"
                HeaderStyle-Font-Bold="True"
                GridLines="None"
                BorderColor="#DFDFDF"
                BorderWidth="1px"
                CellPadding="15">
                <Columns>
                    <asp:TemplateField HeaderText="Incident ID">
                        <ItemTemplate>
                            <span style="font-weight: 600; color: #13460c;"><%# Eval("incidentId") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Applicant Name">
                        <ItemTemplate>
                            <span><%# Eval("applicantName") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Claim Category">
                        <ItemTemplate>
                            <span><%# Eval("claimCategory") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span style="color: #0f5132; background-color: #d1e7dd; padding: 4px 8px; border-radius: 6px;">
                                <%# Eval("status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Total Amount">
                        <ItemTemplate>
                            ₹ <%# String.Format("{0:N2}", Eval("totalAmount")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Disbursed">
                        <ItemTemplate>
                            ₹ <%# String.Format("{0:N2}", Eval("disbursedAmount")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Pending">
                        <ItemTemplate>
                            ₹ <%# String.Format("{0:N2}", Eval("pendingAmount")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Remaining Balance">
                        <ItemTemplate>
                            ₹ <%# String.Format("{0:N2}", Eval("remainingBalance")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Created Date">
                        <ItemTemplate>
                            <%# Convert.ToDateTime(Eval("createdDate")).ToString("dd MMM yyyy hh:mm tt") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>



    <script>
        $(window).on('load', function () {
            setTimeout(() => {

                function calculateBudgetProgress() {
                    try {
                        var totalBudget = parseFloat($('#<%=lbltotalBudgetAllocated.ClientID%>').text().replace(/[₹,]/g, '').trim()) || 0;
                       var disbursedBudget = parseFloat($('#<%=lblamountDisbursed.ClientID%>').text().replace(/[₹,]/g, '').trim()) || 0;
                       var pendingPayments = parseFloat($('#<%=lblpendingPayments.ClientID%>').text().replace(/[₹,]/g, '').trim()) || 0;
                       var remainingBalance = parseFloat($('#<%=lblremainingBalance.ClientID%>').text().replace(/[₹,]/g, '').trim()) || 0;

                       console.log("Values →", { totalBudget, disbursedBudget, pendingPayments, remainingBalance });

                       if (totalBudget > 0) {
                           var disbursedPercent = Math.round((disbursedBudget / totalBudget) * 100);
                           var pendingPercent = Math.round((pendingPayments / totalBudget) * 100);
                           var remainingPercent = Math.round((remainingBalance / totalBudget) * 100);

                           console.log("Percentages →", { disbursedPercent, pendingPercent, remainingPercent });

                           updateProgress('#totalProgressbudget', '#totalPercentagebudget', 100);
                           updateProgress('#pendingProgressbudget', '#pendingPercentagebudget', disbursedPercent);
                           updateProgress('#activeProgressbudget', '#activePercentagebudget', pendingPercent);
                           updateProgress('#returnedProgressbudget', '#returnedPercentagebudget', remainingPercent);
                       } else {
                           console.warn("⚠ totalBudget = 0 — resetting bars");
                           resetProgressBars();
                       }
                   } catch (error) {
                       console.error('Error in calculateBudgetProgress:', error);
                       resetProgressBars();
                   }
               }

               function updateProgress(progressSelector, labelSelector, percentage) {
                   var progressBar = $(progressSelector).find('.progress-fill');
                   var progressLabel = $(labelSelector);

                   progressBar.css({
                       'width': Math.min(percentage, 100) + '%',
                       'transition': 'width 0.8s ease-in-out'
                   });

                   progressLabel.text(percentage + '%');

                   progressBar.removeClass('low-progress high-progress');
                   if (percentage < 35) {
                       progressBar.addClass('low-progress');
                   } else {
                       progressBar.addClass('high-progress');
                   }
               }

               function resetProgressBars() {
                   $('.progress-fill').css('width', '0%');
                   $('.progress-label').text('0%');
               }

               calculateBudgetProgress();
           }, 500);
       });
    </script>


    <script>
        am5.ready(function () {
            var fromDate = document.getElementById("<%= txtFromDate.ClientID %>").value;
            var toDate = document.getElementById("<%= txtToDate.ClientID %>").value;
            var baseUrl = '<%= System.Configuration.ConfigurationManager.AppSettings["api_path"] %>';
            var apiUrl = baseUrl + "TblBudgetdetails/GetBudgetSummary_dashboard?from_date=" + fromDate + "&to_date=" + toDate;

            var root = am5.Root.new("chartdiv");
            root._logo.dispose();
            root.setThemes([am5themes_Animated.new(root)]);

            var chart = root.container.children.push(
                am5percent.PieChart.new(root, {
                    endAngle: 360,
                    innerRadius: am5.percent(40),
                    layout: root.verticalLayout
                })
            );

            chart.children.unshift(
                am5.Label.new(root, {
                    text: "Budget Summary Overview",
                    fontSize: 22,
                    fontWeight: "600",
                    textAlign: "center",
                    x: am5.percent(50),
                    centerX: am5.percent(50),
                    marginBottom: 10
                })
            );

            var series = chart.series.push(
                am5percent.PieSeries.new(root, {
                    valueField: "value",
                    categoryField: "category",
                    endAngle: 360,
                    tooltip: am5.Tooltip.new(root, {
                        labelText: "{category}: [bold]{value}[/]"
                    })
                })
            );

            series.labels.template.set("forceHidden", true);
            series.ticks.template.set("visible", false);

            fetch(apiUrl)
                .then(response => response.json())
                .then(data => {
                    if (
                        (!data.totalBudgetAllocated || data.totalBudgetAllocated === 0) &&
                        (!data.amountDisbursed || data.amountDisbursed === 0) &&
                        (!data.pendingPayments || data.pendingPayments === 0) &&
                        (!data.remainingBalance || data.remainingBalance === 0)
                    ) {
                        root.container.children.clear();
                        let messageContainer = root.container.children.push(
                            am5.Container.new(root, {
                                width: am5.percent(100),
                                height: am5.percent(100),
                                layout: root.verticalLayout,
                                centerX: am5.percent(50),
                                centerY: am5.percent(50),
                                x: am5.percent(50),
                                y: am5.percent(50)
                            })
                        );
                        messageContainer.children.push(
                            am5.Label.new(root, {
                                text: "⚠️",
                                fontSize: 48,
                                fill: am5.color(0xffb300),
                                textAlign: "center",
                                centerX: am5.percent(50)
                            })
                        );
                        messageContainer.children.push(
                            am5.Label.new(root, {
                                text: "No data found between the selected dates",
                                fontSize: 20,
                                fontWeight: "500",
                                fill: am5.color(0x555555),
                                textAlign: "center",
                                centerX: am5.percent(50)
                            })
                        );
                        return;
                    }

                    var chartData = [
                        { category: "Total Budget Allocated", value: data.totalBudgetAllocated },
                        { category: "Amount Disbursed", value: data.amountDisbursed },
                        { category: "Pending Payments", value: data.pendingPayments }
                    ];

                    series.data.setAll(chartData);

                    var legend = chart.children.push(
                        am5.Legend.new(root, {
                            centerX: am5.percent(50),
                            x: am5.percent(50),
                            layout: root.gridLayout,
                            maxColumns: 2,
                            marginTop: 10
                        })
                    );
                    legend.data.setAll(series.dataItems);

                    series.appear(1000, 100);
                })
                .catch(err => {
                    console.error("API Error:", err);
                    root.container.children.clear();
                    let errorContainer = root.container.children.push(
                        am5.Container.new(root, {
                            width: am5.percent(100),
                            height: am5.percent(100),
                            layout: root.verticalLayout,
                            centerX: am5.percent(50),
                            centerY: am5.percent(50),
                            x: am5.percent(50),
                            y: am5.percent(50)
                        })
                    );
                    errorContainer.children.push(
                        am5.Label.new(root, {
                            text: "❌",
                            fontSize: 48,
                            fill: am5.color(0xcc0000),
                            textAlign: "center",
                            centerX: am5.percent(50)
                        })
                    );
                    errorContainer.children.push(
                        am5.Label.new(root, {
                            text: "Error fetching data from the server",
                            fontSize: 18,
                            fontWeight: "500",
                            fill: am5.color(0xcc0000),
                            textAlign: "center",
                            centerX: am5.percent(50)
                        })
                    );
                });

            var exporting = am5plugins_exporting.Exporting.new(root, {
                menu: am5plugins_exporting.ExportingMenu.new(root, {}),
                filePrefix: "Budget_Summary_Chart",
                pngOptions: { quality: 1 },
                pdfOptions: { fontSize: 14, title: "Budget Summary Report" },
                jpgOptions: { quality: 1 }
            });
        });
    </script>


    <script>
        am5.ready(function () {
            var root = am5.Root.new("barChartDiv");
            root._logo.dispose();
            root.setThemes([am5themes_Animated.new(root)]);

            var fromDate = document.getElementById("<%= txtFromDate.ClientID %>").value;
            var toDate = document.getElementById("<%= txtToDate.ClientID %>").value;
            var baseUrl = '<%= System.Configuration.ConfigurationManager.AppSettings["api_path"] %>';
            var apiUrl = baseUrl + "TblBudgetdetails/GetBudgetSummary_CategoryWise?from_date=" + fromDate + "&to_date=" + toDate;

            var chart = root.container.children.push(
                am5xy.XYChart.new(root, {
                    panX: false,
                    panY: false,
                    wheelX: "panX",
                    wheelY: "zoomX",
                    layout: root.verticalLayout
                })
            );

            // X Axis - Categories
            var xAxis = chart.xAxes.push(
                am5xy.CategoryAxis.new(root, {
                    categoryField: "claimCategory",
                    renderer: am5xy.AxisRendererX.new(root, { minGridDistance: 30 }),
                    tooltip: am5.Tooltip.new(root, {})
                })
            );

            // Y Axis - Values
            var yAxis = chart.yAxes.push(
                am5xy.ValueAxis.new(root, {
                    renderer: am5xy.AxisRendererY.new(root, { minGridDistance: 30 })
                })
            );

            // Series: Disbursed (green)
            var series1 = chart.series.push(
                am5xy.ColumnSeries.new(root, {
                    name: "Disbursed",
                    xAxis: xAxis,
                    yAxis: yAxis,
                    valueYField: "disbursed",
                    categoryXField: "claimCategory",
                    clustered: true,
                    fill: am5.color(0x16a34a),
                    stroke: am5.color(0x16a34a)
                })
            );
            series1.columns.template.setAll({
                tooltipText: "{name}\n{categoryX}: [bold]{valueY}[/]",
                fill: am5.color(0x16a34a),
                stroke: am5.color(0x16a34a)
            });

            // Series: Pending (red)
            var series2 = chart.series.push(
                am5xy.ColumnSeries.new(root, {
                    name: "Pending",
                    xAxis: xAxis,
                    yAxis: yAxis,
                    valueYField: "pending",
                    categoryXField: "claimCategory",
                    clustered: true,
                    fill: am5.color(0xef4444),
                    stroke: am5.color(0xef4444)
                })
            );
            series2.columns.template.setAll({
                tooltipText: "{name}\n{categoryX}: [bold]{valueY}[/]",
                fill: am5.color(0xef4444),
                stroke: am5.color(0xef4444)
            });

            // Legend at bottom center
            var legend = chart.children.push(
                am5.Legend.new(root, {
                    centerX: am5.p50,
                    x: am5.p50
                })
            );
            legend.data.setAll([series1, series2]);

            // Fetch API data and feed to chart
            fetch(apiUrl)
                .then(response => response.json())
                .then(data => {
                    if (Array.isArray(data)) {
                        xAxis.data.setAll(data);
                        series1.data.setAll(data);
                        series2.data.setAll(data);
                    } else {
                        console.error("API returned unexpected data format", data);
                    }
                })
                .catch(error => {
                    console.error("Failed to fetch chart data", error);
                });

            chart.appear(1000, 100);
        });
    </script>




</asp:Content>

