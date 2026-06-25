<%@ Page Title="" Async="true" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="hwcDashboard.aspx.cs" Inherits="uk_forest.Forest.hwcDashboard" ClientIDMode="Static" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Human-Wildlife Conflict Dashboard</title>
    <script src="https://cdn.amcharts.com/lib/5/index.js"></script>
    <script src="https://cdn.amcharts.com/lib/5/xy.js"></script>
    <script src="https://cdn.amcharts.com/lib/5/themes/Animated.js"></script>
    <script src="https://cdn.amcharts.com/lib/5/plugins/exporting.js"></script>

    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

    <style>
        .incidenttable {
            border: 1px #80808073 solid;
            border-radius: 12px;
            box-shadow: 6px 6px 12px #bec8d2, -6px -6px 12px #fff;
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
        .total-cases { border-left: 4px solid #2E6F40; }
        .pending-cases { border-left: 4px solid #8B4513; }
        .active-cases { border-left: 4px solid #228B22; }
        .returned-cases { border-left: 4px solid #CD853F; }

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
            background: linear-gradient(135deg, #CD853F, #DEB887);
            box-shadow: 0 3px 12px rgba(205, 133, 63, 0.3);
        }

        .icon-wrapper i { font-size: 20px; color: white; }
        .forest-card:hover .icon-wrapper { transform: scale(1.1) rotate(5deg); }

        .content-section { flex: 1; }
        .card-title {
            font-size: 13px;
            font-weight: 600;
            color: #2E6F40;
            margin: 0 0 5px 0;
            opacity: 0.8;
        }
        .main-number {
            font-size: 24px;
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
            transition: color 0.3s ease;
        }
        .progress-label.high-percentage { color: #28a745 !important; }
        .progress-label.low-percentage { color: #dc3545 !important; }

        .forest-card {
            opacity: 0;
            transform: translateY(20px);
            animation: forestCardLoad 0.6s ease forwards;
        }
        .forest-card:nth-child(1) { animation-delay: 0.1s; }
        .forest-card:nth-child(2) { animation-delay: 0.2s; }
        .forest-card:nth-child(3) { animation-delay: 0.3s; }
        .forest-card:nth-child(4) { animation-delay: 0.4s; }

        @keyframes forestCardLoad {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 768px) {
            .forest-card { height: 120px; margin-bottom: 15px; }
            .card-content { padding: 15px; gap: 12px; }
            .icon-wrapper { width: 40px; height: 40px; }
            .icon-wrapper i { font-size: 18px; }
            .main-number { font-size: 22px; }
            .card-title { font-size: 12px; }
        }

        .am5-exporting-menu {
            background: #fff;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }
        .am5-exporting-menu-item {
            padding: 8px 15px;
            cursor: pointer;
            font-size: 14px;
            border-bottom: 1px solid #eee;
        }
        .am5-exporting-menu-item:last-child { border-bottom: none; }
        .am5-exporting-menu-item:hover { background-color: #f0f0f0; }
        .am5-exporting-menu-icon { margin-right: 8px; }

        h4 {
            background-color: #068469;
            padding: 8px;
            color: white;
            font-size: 25px;
        }

        html, body {
            width: 100vw;
            min-height: 100vh;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            background: #f4f6f8;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }

        .filterrow .form-label { font-weight: 600; }
        .dashboard-container { padding: 5px; }

        .card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 6px 6px 12px #bec8d2, -6px -6px 12px #ffffff;
            padding: 0rem;
            position: relative;
            transition: all 0.3s ease-in-out;
        }
        .card:hover {
            transform: translateY(-8px);
            box-shadow: 10px 10px 20px #b0b9c6, -10px -10px 20px #ffffff;
        }
        .card .icon {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 2.5rem;
            color: #dee3eb;
        }
        .card-title {
            font-weight: 700;
            font-size: 1.2rem;
            color: #2f3e54;
            margin-bottom: 0.4rem;
        }
        .card-number {
            font-weight: 800;
            font-size: 2.5rem;
            color: #1a202c;
            margin-top: 0.5rem;
        }

        #map {
            width: 100%;
            height: 450px;
            position: relative;
            overflow: hidden;
            border-radius: 16px;
            box-shadow: 6px 6px 12px #bec8d2, -6px -6px 12px #ffffff;
        }

        .mastertable {
            width: 100%;
            height: 400px;
            overflow: auto;
            white-space: nowrap;
            border-radius: 16px;
            box-shadow: 6px 6px 12px #bec8d2, -6px -6px 12px #ffffff;
        }

        .page-container { padding: 0 !important; }

        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }
        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        .sticky-header th {
            position: sticky;
            top: 0;
            background-color: #f8f8f8;
            z-index: 1;
        }
        .grid-container {
            max-height: 400px;
            overflow-y: auto;
        }
        .sticky-header th, .sticky-header td {
            padding: 8px;
            border: 1px solid #ccc;
            background-color: #068865;
            color: white;
        }

        .maplegend {
            position: absolute;
            z-index: 1;
            background-color: white;
            padding: 10px;
            bottom: 0px;
            right: 0px;
            display: none;
        }

        .progress-green { background-color: #2ecc71 !important; }
        .progress-red { background-color: #e74c3c !important; }
        .text-green { color: #2ecc71 !important; }
        .text-red { color: #e74c3c !important; }

        #incidentMap { border-radius: 10px; }
        .ol-popup {
            background-color: #fff;
            border-radius: 8px;
            border: 1px solid #ccc;
            padding: 10px 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
            min-width: 200px;
            font-family: Arial, sans-serif;
            font-size: 13px;
            line-height: 1.5;
        }


           canvas.am5-layer-30 {
            display: none;
        }
        /* Fix for GridView pagination */
        .gv_incident_list_pager, .pagination-grid {
            display: flex !important;
            justify-content: center !important;
            align-items: center !important;
            gap: 4px !important;
            padding: 10px 0 !important;
            background: #f8f9fa !important;
            border-top: 1px solid #dee2e6 !important;
        }

            .gv_incident_list_pager td, .pagination-grid td {
                border: none !important;
                padding: 2px !important;
                background: transparent !important;
            }

            .gv_incident_list_pager a, .gv_incident_list_pager span,
            .pagination-grid a, .pagination-grid span {
                display: inline-block !important;
                padding: 5px 10px !important;
                margin: 0 2px !important;
                border: 1px solid #dee2e6 !important;
                border-radius: 4px !important;
                color: #079e54 !important;
                text-decoration: none !important;
                font-size: 13px !important;
                min-width: 30px !important;
                text-align: center !important;
            }

                .gv_incident_list_pager a:hover,
                .pagination-grid a:hover {
                    background-color: #079e54 !important;
                    color: white !important;
                    border-color: #079e54 !important;
                }

            .gv_incident_list_pager span,
            .pagination-grid span {
                background-color: #079e54 !important;
                color: white !important;
                border-color: #079e54 !important;
            }
        /* Pagination Styles - Fix for distant pagination */
        .pagination-grid {
            display: flex !important;
            justify-content: center !important;
            align-items: center !important;
            gap: 5px !important;
            padding: 10px 0 !important;
            background: #f8f9fa !important;
            border-top: 1px solid #dee2e6 !important;
            margin-top: 0 !important;
        }

            .pagination-grid td {
                border: none !important;
                padding: 0 !important;
                background: transparent !important;
            }

            .pagination-grid table {
                margin: 0 auto !important;
                border-collapse: collapse !important;
            }

            .pagination-grid a,
            .pagination-grid span {
                display: inline-block !important;
                padding: 6px 12px !important;
                margin: 0 2px !important;
                border: 1px solid #dee2e6 !important;
                border-radius: 4px !important;
                color: #079e54 !important;
                text-decoration: none !important;
                font-size: 14px !important;
                min-width: 32px !important;
                text-align: center !important;
                transition: all 0.2s ease !important;
            }

                .pagination-grid a:hover {
                    background-color: #079e54 !important;
                    color: white !important;
                    border-color: #079e54 !important;
                }

            .pagination-grid span {
                background-color: #079e54 !important;
                color: white !important;
                border-color: #079e54 !important;
                cursor: default !important;
            }

            /* For disabled links */
            .pagination-grid a[disabled] {
                color: #6c757d !important;
                pointer-events: none !important;
                background: #e9ecef !important;
                border-color: #dee2e6 !important;
            }



    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="dashboard-container">
        <asp:HiddenField runat="server" ID="totalcase" />
        <asp:HiddenField runat="server" ID="activecase" />
        <asp:HiddenField runat="server" ID="pendingcase" />
        <asp:HiddenField runat="server" ID="inprocesscase" />
        <asp:HiddenField runat="server" ID="solvedcase" />

        <!-- Filter Row -->
        <div class="row align-items-end mb-2 filterrow w-100">
            <div class="col-md-4 col-lg-2">
                <label for="dataType" class="form-label">Claim Category</label>
                <asp:DropDownList ID="ddlDataType" runat="server" CssClass="form-select shadow-sm" OnSelectedIndexChanged="ddlDataType_SelectedIndexChanged" AutoPostBack="true">
                    <asp:ListItem Text="All" Value="0" />
                    <asp:ListItem Text="Human Death / Injury" Value="Human" />
                    <asp:ListItem Text="Cattle Kill" Value="Cattle" />
                    <asp:ListItem Text="Crop Damage" Value="Crop" />
                    <asp:ListItem Text="Property Damage" Value="House" />
                </asp:DropDownList>
            </div>

            <div class="col-md-4 col-lg-2">
                <asp:Label ID="lblStartDate" runat="server" AssociatedControlID="txtStartDate" CssClass="form-label" Text="Start Date"></asp:Label>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control shadow-sm" TextMode="Date" />
            </div>

            <div class="col-md-4 col-lg-2">
                <asp:Label ID="lblEndDate" runat="server" AssociatedControlID="txtEndDate" CssClass="form-label" Text="End Date"></asp:Label>
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control shadow-sm" TextMode="Date" />
            </div>

            <div class="col-md-4 col-lg-2">
                <asp:Label runat="server" CssClass="form-label d-block" Text="Division"></asp:Label>
                <asp:DropDownList ID="ddlDivision" runat="server" CssClass="form-select shadow-sm" OnSelectedIndexChanged="ddlDivision_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
            </div>

            <div class="col-md-4 col-lg-2">
                <asp:Label runat="server" CssClass="form-label d-block" Text="Range"></asp:Label>
                <asp:DropDownList ID="ddlRange" runat="server" CssClass="form-select shadow-sm" OnSelectedIndexChanged="ddlRange_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
            </div>

            <div class="col-md-4 col-lg-2">
                <asp:Label runat="server" CssClass="form-label d-block invisible" Text="Search"></asp:Label>
                <asp:Button ID="btnFilter" runat="server" Text="Search" OnClick="btnFilter_Click" CssClass="btn btn-primary w-100 shadow-sm" />
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="container-fluid ps-0">
            <div class="row">
                <div class="col-xl-3 col-lg-3">
                    <div class="forest-card total-cases">
                        <div class="forest-pattern"></div>
                        <div class="card-content">
                            <div class="icon-section">
                                <div class="icon-wrapper"><i class="fas fa-chart-bar"></i></div>
                            </div>
                            <div class="content-section">
                                <h5 class="card-title">Total Cases</h5>
                                <h3 class="main-number"><asp:Label ID="lblTotalCases" runat="server" Text=""></asp:Label></h3>
                                <p class="subtitle">All registered cases</p>
                                <div class="progress-wrapper">
                                    <div class="mini-progress" id="totalProgress"><div class="progress-fill"></div></div>
                                    <span class="progress-label" id="totalPercentage">0%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-lg-3">
                    <div class="forest-card active-cases">
                        <div class="forest-pattern"></div>
                        <div class="card-content">
                            <div class="icon-section">
                                <div class="icon-wrapper"><i class="fas fa-hourglass-half"></i></div>
                            </div>
                            <div class="content-section">
                                <h5 class="card-title">Active Cases</h5>
                                <h3 class="main-number"><asp:Label ID="lblactivecases" runat="server" Text=""></asp:Label></h3>
                                <p class="subtitle">Currently under review</p>
                                <div class="progress-wrapper">
                                    <div class="mini-progress" id="pendingProgress"><div class="progress-fill"></div></div>
                                    <span class="progress-label" id="pendingPercentage">0%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-lg-3">
                    <div class="forest-card pending-cases">
                        <div class="forest-pattern"></div>
                        <div class="card-content">
                            <div class="icon-section">
                                <div class="icon-wrapper"><i class="fas fa-sync-alt"></i></div>
                            </div>
                            <div class="content-section">
                                <h5 class="card-title">Returned Cases</h5>
                                <h3 class="main-number"><asp:Label ID="lblreturnedcases" runat="server" Text=""></asp:Label></h3>
                                <p class="subtitle">Sent back for correction</p>
                                <div class="progress-wrapper">
                                    <div class="mini-progress" id="activeProgress"><div class="progress-fill"></div></div>
                                    <span class="progress-label" id="activePercentage">0%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-lg-3">
                    <div class="forest-card returned-cases">
                        <div class="forest-pattern"></div>
                        <div class="card-content">
                            <div class="icon-section">
                                <div class="icon-wrapper"><i class="fas fa-check-circle"></i></div>
                            </div>
                            <div class="content-section">
                                <h5 class="card-title">Paid Cases</h5>
                                <h3 class="main-number"><asp:Label ID="lblpaidcases" runat="server" Text=""></asp:Label></h3>
                                <p class="subtitle">Successfully settled cases</p>
                                <div class="progress-wrapper">
                                    <div class="mini-progress" id="returnedProgress"><div class="progress-fill"></div></div>
                                    <span class="progress-label" id="returnedPercentage">0%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Budget Cards (Hidden by default) -->
        <div class="container-fluid ps-0" runat="server" id="divbudgetcards" visible="false">
            <div class="row">
                <div class="col-xl-3 col-lg-3">
                    <div class="forest-card total-cases">
                        <div class="forest-pattern"></div>
                        <div class="card-content">
                            <div class="icon-section">
                                <div class="icon-wrapper bg-success text-white"><i class="fas fa-piggy-bank"></i></div>
                            </div>
                            <div class="content-section">
                                <h5 class="card-title">Total Budget Allocated</h5>
                                <h3 class="main-number"><asp:Label ID="lbltotalBudgetAllocated" runat="server" Text=""></asp:Label></h3>
                                <p class="subtitle">Overall sanctioned fund</p>
                                <div class="progress-wrapper">
                                    <div class="mini-progress" id="totalProgressbudget"><div class="progress-fill"></div></div>
                                    <span class="progress-label" id="totalPercentagebudget">0%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-lg-3">
                    <div class="forest-card active-cases">
                        <div class="forest-pattern"></div>
                        <div class="card-content">
                            <div class="icon-section">
                                <div class="icon-wrapper bg-info text-white"><i class="fas fa-hand-holding-usd"></i></div>
                            </div>
                            <div class="content-section">
                                <h5 class="card-title">Amount Disbursed</h5>
                                <h3 class="main-number"><asp:Label ID="lblamountDisbursed" runat="server" Text=""></asp:Label></h3>
                                <p class="subtitle">Funds released so far</p>
                                <div class="progress-wrapper">
                                    <div class="mini-progress" id="pendingProgressbudget"><div class="progress-fill"></div></div>
                                    <span class="progress-label" id="pendingPercentagebudget">0%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-lg-3">
                    <div class="forest-card pending-cases">
                        <div class="forest-pattern"></div>
                        <div class="card-content">
                            <div class="icon-section">
                                <div class="icon-wrapper bg-warning text-white"><i class="fas fa-clock"></i></div>
                            </div>
                            <div class="content-section">
                                <h5 class="card-title">Pending Payments</h5>
                                <h3 class="main-number"><asp:Label ID="lblpendingPayments" runat="server" Text=""></asp:Label></h3>
                                <p class="subtitle">Payments under processing</p>
                                <div class="progress-wrapper">
                                    <div class="mini-progress" id="activeProgressbudget"><div class="progress-fill"></div></div>
                                    <span class="progress-label" id="activePercentagebudget">0%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-lg-3">
                    <div class="forest-card returned-cases">
                        <div class="forest-pattern"></div>
                        <div class="card-content">
                            <div class="icon-section">
                                <div class="icon-wrapper bg-primary text-white"><i class="fas fa-wallet"></i></div>
                            </div>
                            <div class="content-section">
                                <h5 class="card-title">Remaining Balance</h5>
                                <h3 class="main-number"><asp:Label ID="lblremainingBalance" runat="server" Text=""></asp:Label></h3>
                                <p class="subtitle">Funds available for utilization</p>
                                <div class="progress-wrapper">
                                    <div class="mini-progress" id="returnedProgressbudget"><div class="progress-fill"></div></div>
                                    <span class="progress-label" id="returnedPercentagebudget">0%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Map and Chart Row -->
        <div class="row g-2">
            <div class="col-lg-7 col-12">
                <div id="incidentMap" style="height: 455px; width: 100%;"></div>
            </div>

            <div class="col-lg-5 col-12 chart">
                <asp:HiddenField ID="hfLabels" runat="server" />
                <asp:HiddenField ID="hfCounts" runat="server" />
                <div>
                    <div id="animalchart" style="width: 100%; height: 450px; box-shadow: 6px 6px 12px #bec8d2, -6px -6px 12px #fff; border-radius: 16px;"></div>
                </div>
            </div>
        </div>

        <!-- Hidden Grid -->
        <div class="row g-2" runat="server" visible="false">
            <div class="col-lg-12 col-12">
                <div class="mastertable">
                    <asp:UpdatePanel runat="server" ID="upd">
                        <ContentTemplate>
                            <asp:GridView runat="server" ID="grdmastertable" AutoGenerateColumns="False" CssClass="table table-bordered" UseAccessibleHeader="True" HeaderStyle-CssClass="sticky-header" DataKeyNames="incidentId">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No">
                                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Conflict Type">
                                        <ItemTemplate><%# Eval("conflictType") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Incident ID">
                                        <ItemTemplate><%# Eval("incidentId") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Incident Date">
                                        <ItemTemplate><%# Eval("incidentDate", "{0:yyyy-MM-dd}") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Incident Place">
                                        <ItemTemplate><%# Eval("incidentPlace") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Caused By">
                                        <ItemTemplate><%# Eval("animalName") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Human Loss">
                                        <ItemTemplate><%# Eval("humanLoss") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Latitude">
                                        <ItemTemplate><%# Eval("latitude") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Longitude">
                                        <ItemTemplate><%# Eval("longitude") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate><%# Eval("status") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Applicant Name">
                                        <ItemTemplate><%# Eval("applicantName") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Range Name">
                                        <ItemTemplate><%# Eval("rangeName") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:Button runat="server" ID="btnshowCase" OnClick="btnshowCase_Click" Text="View" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div style="text-align: center; color: red;">No records found.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>

        <!-- Incident Details Table -->
        <div class="row">
    <div class="col-lg-12 col-md-6 col-12 mt-3 incidenttable">
        <h2 style="text-align: center; color: #28a745; font-weight: 600; margin-top: 20px;">Incident Details</h2>
        <div class="form-row mt-2 mb-3">
            <div class="table-responsive">
                <asp:UpdatePanel ID="updIncidentList" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnSelectedIncidentId" runat="server" />
                        <asp:Label ID="lbl_msg_alert" runat="server" CssClass="alert alert-danger p-2 mb-0" Visible="false"></asp:Label>

                        <asp:GridView ID="gv_incident_list" runat="server" AutoGenerateColumns="false"
                            CssClass="incident-table" AllowPaging="true" PageSize="10" DataKeyNames="incidentId"
                            EmptyDataText="No incidents found!" OnPageIndexChanging="gv_incident_list_PageIndexChanging"
                            EnableViewState="true" HeaderStyle-BackColor="#079e54" HeaderStyle-ForeColor="White" 
                            HeaderStyle-Height="45px" HeaderStyle-HorizontalAlign="Center" 
                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-CssClass="custom-header" 
                            CellPadding="10" OnRowDataBound="gv_incident_list_RowDataBound">

                            <HeaderStyle BackColor="#079e54" ForeColor="White" Font-Bold="true" HorizontalAlign="Center" VerticalAlign="Middle" Height="40px" />
                            <RowStyle CssClass="custom-row" />

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
                                <asp:TemplateField HeaderText="Victim Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_name" runat="server" Text='<%# Eval("victimName") ?? "NA" %>'></asp:Label>
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
                                        <asp:Label ID="lbl_killed_by" runat="server" Text='<%# Eval("incidentCausedBy") ?? "NA" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:Label ID="lbl_Status" runat="server" Text='<%# Eval("status") ?? "NA" %>' ForeColor="Red"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="View">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkView" runat="server" OnClick="lnkView_Click"
                                            ToolTip="Click to view complete incident details"
                                            Style="display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; text-decoration: none; color: #26ad54; font-weight: 600; font-size: 25px; cursor: pointer; transition: all 0.3s ease;">
                                            <i class="fas fa-eye"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagination-grid" HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnFilter" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="ddlDataType" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlDivision" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlRange" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</div>




        <!-- Incident Popup -->
        <asp:UpdatePanel runat="server" ID="UpdatePanel2">
            <ContentTemplate>
                <div runat="server" id="popup" visible="false" style="display: none; width: 85.5vw; border: 2px solid red; height: 100%; background-color: #00000082; position: absolute; top: 4px; z-index: 11111; left: 0;">
                    <div class="container p-4 border bg-white shadow-sm" style="font-family: Arial, sans-serif; font-size: 20px; line-height: 1.6; overflow: auto; max-height: 920px; width: 60%;">
                        <button id="Button1" type="button" style="cursor: pointer; padding: 5px 10px; border: 1px solid red; position: relative; float: right; background-color: red; color: white; font-weight: 700;" text="X" onclick="closeincidentreport()">X</button>
                        <h2 class="text-center mb-4" style="font-size: 40px; font-weight: 700;">Incident Report</h2>

                        <h4 class="border-bottom pb-2 mb-3">1. Incident Details</h4>
                        <div class="row">
                            <div class="col-md-6"><strong>Incident ID:</strong> <asp:Label ID="lblIncidentId" runat="server" /></div>
                            <div class="col-md-6"><strong>Date:</strong> <asp:Label ID="lblIncidentDate" runat="server" /></div>
                            <div class="col-md-6"><strong>Place:</strong> <asp:Label ID="lblIncidentPlace" runat="server" /></div>
                            <div class="col-md-6"><strong>Activity:</strong> <asp:Label ID="lblActivity" runat="server" /></div>
                            <div class="col-md-6"><strong>Status:</strong> <asp:Label ID="lblStatus" runat="server" /></div>
                            <div class="col-md-6"><strong>Latitude:</strong> <asp:Label ID="lblLatitude" runat="server" /></div>
                            <div class="col-md-6"><strong>Longitude:</strong> <asp:Label ID="lblLongitude" runat="server" /></div>
                        </div>

                        <h4 class="border-bottom pb-2 mt-4 mb-3">2. Victim Details</h4>
                        <div class="row">
                            <div class="col-md-6"><strong>Name:</strong> <asp:Label ID="lblVictimName" runat="server" /></div>
                            <div class="col-md-6"><strong>Age:</strong> <asp:Label ID="lblVictimAge" runat="server" /></div>
                            <div class="col-md-6"><strong>Gender:</strong> <asp:Label ID="lblVictimGender" runat="server" /></div>
                            <div class="col-md-6"><strong>Aadhaar No:</strong> <asp:Label ID="lblVictimAadhar" runat="server" /></div>
                        </div>

                        <h4 class="border-bottom pb-2 mt-4 mb-3">3. Applicant Details</h4>
                        <div class="row">
                            <div class="col-md-6"><strong>Name:</strong> <asp:Label ID="lblApplicantName" runat="server" /></div>
                            <div class="col-md-6"><strong>Mobile:</strong> <asp:Label ID="lblApplicantMobile" runat="server" /></div>
                            <div class="col-md-6"><strong>Address:</strong> <asp:Label ID="lblApplicantAddress" runat="server" /></div>
                            <div class="col-md-6"><strong>Aadhaar No:</strong> <asp:Label ID="lblApplicantAadhar" runat="server" /></div>
                        </div>

                        <h4 class="border-bottom pb-2 mt-4 mb-3">4. Conflict Animal</h4>
                        <div class="row">
                            <div class="col-md-6"><strong>Animal:</strong> <asp:Label ID="lblAnimalName" runat="server" /></div>
                            <div class="col-md-6"><strong>Local Name:</strong> <asp:Label ID="lblAnimalLocalName" runat="server" /></div>
                            <div class="col-md-6"><strong>Conflict Type:</strong> <asp:Label ID="lblConflictCategory" runat="server" /></div>
                        </div>

                        <h4 class="border-bottom pb-2 mt-4 mb-3">5. Location Information</h4>
                        <div class="row">
                            <div class="col-md-6"><strong>Range:</strong> <asp:Label ID="lblRange" runat="server" /></div>
                            <div class="col-md-6"><strong>Sub Division:</strong> <asp:Label ID="lblSubDivision" runat="server" /></div>
                            <div class="col-md-6"><strong>Division:</strong> <asp:Label ID="lblDivision" runat="server" /></div>
                            <div class="col-md-6"><strong>Circle:</strong> <asp:Label ID="lblCircle" runat="server" /></div>
                            <div class="col-md-6"><strong>Zone:</strong> <asp:Label ID="lblZone" runat="server" /></div>
                        </div>

                        <h4 class="border-bottom pb-2 mt-4 mb-3">6. Payment Details</h4>
                        <div class="row">
                            <h5 style="font-size: 22px;">Advance Payment Details</h5>
                            <div class="row">
                                <div class="col-md-6"><strong>Amount:</strong> <asp:Label ID="lblAdvanceAmount" runat="server" /></div>
                                <div class="col-md-6"><strong>Status:</strong> <asp:Label ID="lblAdvanceStatus" runat="server" /></div>
                                <div class="col-md-6"><strong>Mode:</strong> <asp:Label ID="lblAdvanceMode" runat="server" /></div>
                                <div class="col-md-6"><strong>Reference No:</strong> <asp:Label ID="lblAdvanceReference" runat="server" /></div>
                                <div class="col-md-6"><strong>Date:</strong> <asp:Label ID="lblAdvanceDate" runat="server" /></div>
                                <div class="col-md-6"><strong>Remarks:</strong> <asp:Label ID="lblAdvanceRemarks" runat="server" /></div>
                            </div>

                            <h5 style="font-size: 22px;">Remaining Payment Details</h5>
                            <div class="row">
                                <div class="col-md-6"><strong>Amount:</strong> <asp:Label ID="lblRemainingAmount" runat="server" /></div>
                                <div class="col-md-6"><strong>Status:</strong> <asp:Label ID="lblRemainingStatus" runat="server" /></div>
                                <div class="col-md-6"><strong>Mode:</strong> <asp:Label ID="lblRemainingMode" runat="server" /></div>
                                <div class="col-md-6"><strong>Reference No:</strong> <asp:Label ID="lblRemainingReference" runat="server" /></div>
                                <div class="col-md-6"><strong>Date:</strong> <asp:Label ID="lblRemainingDate" runat="server" /></div>
                                <div class="col-md-6"><strong>Remarks:</strong> <asp:Label ID="lblRemainingRemarks" runat="server" /></div>
                            </div>
                        </div>

                        <h4 class="border-bottom pb-2 mt-4 mb-3">7. Documents</h4>
                        <div class="row">
                            <div class="col-md-12">
                                <strong>Photograph:</strong><br />
                                <div style="width: 100%; overflow: auto; text-align: center;">
                                    <img id="PhotographDoc" runat="server" src="" alt="Alternate Text" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <strong>Village Head Certificate:</strong><br />
                                <div style="width: 100%; overflow: auto; text-align: center;">
                                    <img runat="server" id="VillageHeadCert" src="" alt="Alternate Text" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <!-- Incident Details Panel -->
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
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Applicant & Beneficiary Information</h5>
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
                                        <%# !string.IsNullOrEmpty(Eval("applicantAadharDoc")?.ToString()) ? $"<a href='{BaseUrl}{Eval("applicantAadharDoc")}' target='_blank' style='color: #3182ce; text-decoration: none;'>View Document</a>" : "N/A" %>
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

                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Victim Information</h5>
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
                                        <%# !string.IsNullOrEmpty(Eval("victimAadharDoc")?.ToString()) ? $"<a href='{BaseUrl}{Eval("victimAadharDoc")}' target='_blank' style='color: #3182ce; text-decoration: none;'>View Document</a>" : "N/A" %>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Incident Information</h5>
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
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Animal Name:</span>
                                    <span style="color: #2d3748;"><%# Eval("animalName") %> (<%# Eval("localName") %>)</span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Claim Category:</span>
                                    <span style="color: #2d3748;"><%# Eval("claimCategory") %></span>
                                </div>
                                <div style="display: flex; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: #4a5568; min-width: 130px; margin-right: 10px;">Coordinates:</span>
                                    <span style="color: #2d3748;">
                                        <%# Eval("latitude") %>, <%# Eval("longitude") %>
                                        <a href='https://maps.google.com/?q=<%# Eval("latitude") %>,<%# Eval("longitude") %>' target="_blank" style="color: #3182ce; margin-left: 5px; text-decoration: none;">📍</a>
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

                        <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                            <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Incident Summary</h5>
                            <div style="background: white; padding: 12px; border-radius: 4px; border: 1px solid #e2e8f0; line-height: 1.5; color: #2d3748;">
                                <%# Eval("incidentSummary") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div style="border-left: 4px solid #3182ce; background: #f7fafc; padding: 15px; margin-bottom: 20px; border-radius: 0 6px 6px 0;">
                    <h5 style="color: #2d3748; margin: 0 0 15px 0; font-weight: 600; font-size: 16px;">Attachments</h5>
                    <asp:Repeater ID="rptDocuments" runat="server">
                        <HeaderTemplate><div style="display: grid; gap: 12px;"></HeaderTemplate>
                        <ItemTemplate>
                            <div style="background: white; padding: 12px; border-radius: 6px; border: 1px solid #e2e8f0; display: flex; align-items: center; transition: all 0.2s ease;">
                                <div style="width: 40px; height: 40px; background: #3182ce; border-radius: 6px; display: flex; align-items: center; justify-content: center; margin-right: 12px;">
                                    <span style="color: white; font-size: 16px;">📄</span>
                                </div>
                                <div style="flex: 1;">
                                    <div style="font-weight: 600; color: #2d3748; margin-bottom: 2px;">Document Name:</div>
                                    <div style="color: #4a5568; font-size: 14px;"><%# Eval("DocumentName") %></div>
                                </div>
                                <div>
                                    <a href='<%# Eval("DocumentPath") %>' download='<%# Eval("DocumentName") %>' style="color: #3182ce; text-decoration: none; font-weight: 500; padding: 6px 12px; border: 1px solid #3182ce; border-radius: 4px; font-size: 14px; transition: all 0.2s ease;">Download File</a>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate></div></FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </asp:Panel>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <script src="hwcDashboard.js"></script>

    <script type="text/javascript">
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
    </script>

    <!-- Animal Chart Script - Safe Version -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var animalChartDiv = document.getElementById('animalchart');
            if (!animalChartDiv) {
                console.warn('animalchart div not found');
                return;
            }

            am5.ready(function () {
                try {
                    am5.registry.rootElements.forEach(function (root) {
                        if (root.dom && root.dom.id === "animalchart") {
                            root.dispose();
                        }
                    });

                    var root = am5.Root.new("animalchart", { useSafeResolution: true });
                    root.setThemes([am5themes_Animated.new(root)]);

                    var chart = root.container.children.push(am5xy.XYChart.new(root, {
                        panX: true, panY: true, wheelX: "panX", wheelY: "zoomX",
                        pinchZoomX: true, paddingLeft: 0, paddingRight: 1
                    }));

                    chart.children.unshift(am5.Label.new(root, {
                        text: "Animal-wise Incident Statistics",
                        fontSize: 20, fontWeight: "600", textAlign: "center",
                        x: am5.percent(50), centerX: am5.percent(50),
                        paddingTop: 10, paddingBottom: 20,
                        fill: am5.color("#333333")
                    }));

                    var exporting = am5plugins_exporting.Exporting.new(root, {
                        menu: am5plugins_exporting.ExportingMenu.new(root, {
                            align: "right", valign: "top",
                            items: [
                                { type: "format", format: "pdf", label: "📄 Export PDF" },
                                { type: "format", format: "png", label: "🖼️ Export PNG" },
                                { type: "format", format: "jpg", label: "📸 Export JPG" }
                            ]
                        }),
                        filePrefix: "Animal_Incident_Chart",
                        title: "Animal-wise Incident Statistics",
                        pdfOptions: { pageSize: "A4", pageOrientation: "landscape", pageMargins: [20, 20, 20, 20], addURL: false },
                        pngOptions: { quality: 0.9, maintainPixelRatio: true },
                        jpgOptions: { quality: 0.8, maintainPixelRatio: true }
                    });

                    var cursor = chart.set("cursor", am5xy.XYCursor.new(root, {}));
                    cursor.lineY.set("visible", false);

                    var xRenderer = am5xy.AxisRendererX.new(root, {
                        minGridDistance: 30, minorGridEnabled: true,
                        cellStartLocation: 0.1, cellEndLocation: 0.9
                    });
                    xRenderer.labels.template.setAll({
                        rotation: -90, centerY: am5.p50, centerX: am5.p100, paddingRight: 15
                    });

                    var xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
                        categoryField: "animalName", renderer: xRenderer,
                        tooltip: am5.Tooltip.new(root, {})
                    }));

                    var yRenderer = am5xy.AxisRendererY.new(root, { strokeOpacity: 0.1 });
                    var yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
                        renderer: yRenderer, min: 1, maxPrecision: 0
                    }));

                    var series = chart.series.push(am5xy.ColumnSeries.new(root, {
                        name: "Animal Incidents",
                        xAxis: xAxis, yAxis: yAxis,
                        valueYField: "incidentCount",
                        categoryXField: "animalName",
                        tooltip: am5.Tooltip.new(root, { labelText: "{categoryX}: {valueY}" }),
                        clustered: false
                    }));

                    series.columns.template.setAll({
                        cornerRadiusTL: 5, cornerRadiusTR: 5,
                        strokeOpacity: 0, width: 50
                    });

                    series.columns.template.adapters.add("fill", function (fill, target) {
                        return chart.get("colors").getIndex(series.columns.indexOf(target));
                    });

                    function loadAnimalWiseData() {
                        var userId = '<%= Session["userId"] %>';
                        var roleId = '<%= Session["roleId"] %>';
                        var rangeId = document.getElementById('<%= ddlRange.ClientID %>').value || "0";
                        var divisionId = document.getElementById('<%= ddlDivision.ClientID %>').value || "";
                        var startDate = document.getElementById('<%= txtStartDate.ClientID %>').value.trim();
                        var endDate = document.getElementById('<%= txtEndDate.ClientID %>').value.trim();
                        var category = document.getElementById('<%= ddlDataType.ClientID %>').value || "0";

                        if (rangeId === "" || rangeId === "null") rangeId = "0";
                        if (divisionId === "0") divisionId = "";

                        var apiBaseUrl = '<%= System.Configuration.ConfigurationManager.AppSettings["api_path"] %>';
                        var apiUrl = apiBaseUrl +
                            'TblIncidentDetails/GetIncidentAnimalSummary_Filtered' +
                            '?userId=' + encodeURIComponent(userId) +
                            '&roleId=' + encodeURIComponent(roleId) +
                            '&claim_category=' + encodeURIComponent(category) +
                            '&fromdate=' + encodeURIComponent(startDate) +
                            '&todate=' + encodeURIComponent(endDate) +
                            '&division_id=' + encodeURIComponent(divisionId) +
                            '&range_id=' + encodeURIComponent(rangeId);

                        fetch(apiUrl)
                            .then(res => {
                                if (!res.ok) throw new Error('HTTP error! status: ' + res.status);
                                return res.json();
                            })
                            .then(data => {
                                if (data && Array.isArray(data) && data.length > 0) {
                                    var validData = data.filter(function (item) {
                                        return item.animalName &&
                                            typeof item.incidentCount === 'number' &&
                                            !isNaN(item.incidentCount) &&
                                            item.incidentCount >= 0;
                                    });

                                    if (validData.length > 0) {
                                        try {
                                            xAxis.data.clear();
                                            series.data.clear();

                                            if (validData.length === 1) {
                                                series.columns.template.set("width", 60);
                                            } else if (validData.length <= 3) {
                                                series.columns.template.set("width", am5.percent(40));
                                            } else {
                                                series.columns.template.set("width", am5.percent(70));
                                            }

                                            xAxis.data.setAll(validData);
                                            series.data.setAll(validData);
                                            series.appear(1000);
                                            chart.appear(1000, 100);
                                        } catch (e) {
                                            console.error("Data setting error:", e);
                                        }
                                    } else {
                                        xAxis.data.setAll([]);
                                        series.data.setAll([]);
                                    }
                                } else {
                                    xAxis.data.setAll([]);
                                    series.data.setAll([]);
                                }
                            })
                            .catch(function (err) {
                                console.error("API Error:", err);
                                xAxis.data.setAll([]);
                                series.data.setAll([]);
                            });
                    }

                    loadAnimalWiseData();

                    try {
                        var rangeDropdown = document.getElementById('<%= ddlRange.ClientID %>');
                        var divisionDropdown = document.getElementById('<%= ddlDivision.ClientID %>');
                        var dataTypeDropdown = document.getElementById('<%= ddlDataType.ClientID %>');

                        if (rangeDropdown) rangeDropdown.addEventListener('change', loadAnimalWiseData);
                        if (divisionDropdown) divisionDropdown.addEventListener('change', loadAnimalWiseData);
                        if (dataTypeDropdown) dataTypeDropdown.addEventListener('change', loadAnimalWiseData);
                    } catch (e) { }

                    series.appear(1000);
                    chart.appear(1000, 100);

                    window.addEventListener('beforeunload', function () {
                        if (root) root.dispose();
                    });

                } catch (error) {
                    console.error('Animal chart initialization error:', error);
                }
            });
        });
    </script>

    <!-- Budget Chart Script - Safe Version -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var budgetChartDiv = document.getElementById('budgetchart');
            if (!budgetChartDiv) {
                console.warn('budgetchart div not found - skipping budget chart');
                return;
            }

            am5.ready(function () {
                try {
                    am5.registry.rootElements.forEach(function (root) {
                        if (root.dom && root.dom.id === "budgetchart") {
                            root.dispose();
                        }
                    });

                    var root = am5.Root.new("budgetchart", { useSafeResolution: true });
                    root.setThemes([am5themes_Animated.new(root)]);

                    var chart = root.container.children.push(am5xy.XYChart.new(root, {
                        panX: true, panY: true, wheelX: "panX", wheelY: "zoomX",
                        pinchZoomX: true, paddingLeft: 0, paddingRight: 1
                    }));

                    chart.children.unshift(am5.Label.new(root, {
                        text: "DFO Monthly Budget Chart",
                        fontSize: 20, fontWeight: "600", textAlign: "center",
                        x: am5.percent(50), centerX: am5.percent(50),
                        paddingTop: 10, paddingBottom: 20,
                        fill: am5.color("#333333")
                    }));

                    var exporting = am5plugins_exporting.Exporting.new(root, {
                        menu: am5plugins_exporting.ExportingMenu.new(root, {
                            align: "right", valign: "top",
                            items: [
                                { type: "format", format: "pdf", label: "📄 Export PDF" },
                                { type: "format", format: "png", label: "🖼️ Export PNG" },
                                { type: "format", format: "jpg", label: "📸 Export JPG" }
                            ]
                        }),
                        filePrefix: "DFO_Budget_Chart",
                        title: "DFO Monthly Budget Chart",
                        pdfOptions: { pageSize: "A4", pageOrientation: "landscape", pageMargins: [20, 20, 20, 20], addURL: false }
                    });

                    var cursor = chart.set("cursor", am5xy.XYCursor.new(root, {}));
                    cursor.lineY.set("visible", false);

                    var xRenderer = am5xy.AxisRendererX.new(root, {
                        minGridDistance: 30, minorGridEnabled: true,
                        cellStartLocation: 0.1, cellEndLocation: 0.9
                    });
                    xRenderer.labels.template.setAll({
                        rotation: -45, centerY: am5.p50, centerX: am5.p100, paddingRight: 15
                    });

                    var xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
                        categoryField: "monthYear", renderer: xRenderer,
                        tooltip: am5.Tooltip.new(root, {})
                    }));

                    var yRenderer = am5xy.AxisRendererY.new(root, { strokeOpacity: 0.1 });
                    var yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
                        renderer: yRenderer, min: 0, extraMax: 0.1
                    }));

                    var series = chart.series.push(am5xy.ColumnSeries.new(root, {
                        name: "Budget Amount",
                        xAxis: xAxis, yAxis: yAxis,
                        valueYField: "amount",
                        categoryXField: "monthYear",
                        tooltip: am5.Tooltip.new(root, { labelText: "{categoryX}: ₹{valueY}" })
                    }));

                    series.columns.template.setAll({
                        cornerRadiusTL: 5, cornerRadiusTR: 5,
                        strokeOpacity: 0, width: am5.percent(70)
                    });

                    series.columns.template.adapters.add("fill", function (fill, target) {
                        return chart.get("colors").getIndex(series.columns.indexOf(target));
                    });

                    function loadBudgetData() {
                        var apiBaseUrl = '<%= System.Configuration.ConfigurationManager.AppSettings["api_path"] %>';
                        var dfoId = '<%= Session["UserId"] %>';
                        var apiUrl = apiBaseUrl + 'TblBudgetdetails/Budgetchart?dfoid=' + dfoId;

                        fetch(apiUrl)
                            .then(function (res) {
                                if (!res.ok) throw new Error('HTTP error! status: ' + res.status);
                                return res.json();
                            })
                            .then(function (data) {
                                if (data && Array.isArray(data) && data.length > 0) {
                                    var validData = data.filter(function (item) {
                                        return item.monthYear && typeof item.amount === 'number';
                                    });

                                    if (validData.length > 0) {
                                        xAxis.data.setAll(validData);
                                        series.data.setAll(validData);
                                        series.appear(1000);
                                        chart.appear(1000, 100);
                                    }
                                }
                            })
                            .catch(function (err) {
                                console.error("Budget data loading failed:", err);
                                xAxis.data.setAll([]);
                                series.data.setAll([]);
                            });
                    }

                    loadBudgetData();

                    window.addEventListener('beforeunload', function () {
                        if (root) root.dispose();
                    });

                } catch (error) {
                    console.error('Budget chart initialization error:', error);
                }
            });
        });
    </script>

    <!-- Progress Bar Scripts -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            function calculateRelativeToTotal() {
                try {
                    var totalCases = parseInt($('#<%=lblTotalCases.ClientID%>').text().replace(/,/g, '')) || 0;
                    var activeCases = parseInt($('#<%=lblactivecases.ClientID%>').text().replace(/,/g, '')) || 0;
                    var returnedCases = parseInt($('#<%=lblreturnedcases.ClientID%>').text().replace(/,/g, '')) || 0;
                    var paidCases = parseInt($('#<%=lblpaidcases.ClientID%>').text().replace(/,/g, '')) || 0;

                    if (totalCases > 0) {
                        var activePercent = Math.round((activeCases / totalCases) * 100);
                        var returnedPercent = Math.round((returnedCases / totalCases) * 100);
                        var paidPercent = Math.round((paidCases / totalCases) * 100);

                        setTimeout(function () {
                            updateProgressWithColor('#totalProgress', '#totalPercentage', 100, 'total');
                            updateProgressWithColor('#pendingProgress', '#pendingPercentage', activePercent, 'active');
                            updateProgressWithColor('#activeProgress', '#activePercentage', returnedPercent, 'returned');
                            updateProgressWithColor('#returnedProgress', '#returnedPercentage', paidPercent, 'paid');
                        }, 800);
                    } else {
                        resetProgressBars();
                    }
                } catch (error) {
                    console.error('Error in calculateRelativeToTotal:', error);
                    resetProgressBars();
                }
            }

            function updateProgressWithColor(progressSelector, labelSelector, percentage, type) {
                var progressBar = $(progressSelector + ' .progress-fill');
                var progressLabel = $(labelSelector);

                progressBar.css({ 'transition': 'width 0.8s ease-in-out', 'width': Math.min(percentage, 100) + '%' });
                progressLabel.text(percentage + '%');

                progressBar.removeClass('progress-green progress-red');
                progressLabel.removeClass('text-green text-red');

                var colorClass = 'progress-green';
                var textColor = 'text-green';

                switch (type) {
                    case 'total':
                        colorClass = 'progress-green';
                        textColor = 'text-green';
                        break;
                    case 'active':
                        if (percentage > 60) { colorClass = 'progress-red'; textColor = 'text-red'; }
                        break;
                    case 'returned':
                        if (percentage >= 40) { colorClass = 'progress-red'; textColor = 'text-red'; }
                        break;
                    case 'paid':
                        if (percentage < 40) { colorClass = 'progress-red'; textColor = 'text-red'; }
                        break;
                }

                progressBar.addClass(colorClass);
                progressLabel.addClass(textColor);
            }

            function resetProgressBars() {
                $('.progress-fill').css({ 'width': '0%', 'transition': 'none' }).removeClass('progress-green progress-red');
                $('.progress-label').text('0%').removeClass('text-green text-red');
            }

            calculateRelativeToTotal();
        });
    </script>

    <!-- Budget Progress Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            function calculateBudgetProgress() {
                try {
                    var totalBudget = parseFloat($('#<%=lbltotalBudgetAllocated.ClientID%>').text().replace(/,/g, '')) || 0;
                    var disbursedBudget = parseFloat($('#<%=lblamountDisbursed.ClientID%>').text().replace(/,/g, '')) || 0;
                    var pendingPayments = parseFloat($('#<%=lblpendingPayments.ClientID%>').text().replace(/,/g, '')) || 0;
                    var remainingBalance = parseFloat($('#<%=lblremainingBalance.ClientID%>').text().replace(/,/g, '')) || 0;

                    if (totalBudget > 0) {
                        var disbursedPercent = Math.round((disbursedBudget / totalBudget) * 100);
                        var pendingPercent = Math.round((pendingPayments / totalBudget) * 100);
                        var remainingPercent = Math.round((remainingBalance / totalBudget) * 100);

                        setTimeout(function () {
                            updateProgress('#totalProgressbudget', '#totalPercentagebudget', 100);
                            updateProgress('#pendingProgressbudget', '#pendingPercentagebudget', disbursedPercent);
                            updateProgress('#activeProgressbudget', '#activePercentagebudget', pendingPercent);
                            updateProgress('#returnedProgressbudget', '#returnedPercentagebudget', remainingPercent);
                        }, 400);
                    } else {
                        resetBudgetBars();
                    }
                } catch (error) {
                    console.error('Error in calculateBudgetProgress:', error);
                    resetBudgetBars();
                }
            }

            function updateProgress(progressSelector, labelSelector, percentage) {
                var progressBar = $(progressSelector + ' .progress-fill');
                var progressLabel = $(labelSelector);

                progressBar.css({ 'transition': 'width 0.8s ease-in-out', 'width': Math.min(percentage, 100) + '%' });
                progressLabel.text(percentage + '%');

                progressBar.removeClass('low-progress high-progress');
                progressLabel.removeClass('low-percentage high-percentage');

                if (percentage < 35) {
                    progressBar.addClass('low-progress');
                    progressLabel.addClass('low-percentage');
                } else {
                    progressBar.addClass('high-progress');
                    progressLabel.addClass('high-percentage');
                }
            }

            function resetBudgetBars() {
                $('.progress-fill').css('width', '0%');
                $('.progress-label').text('0%');
            }

            calculateBudgetProgress();
        });
    </script>

    <!-- OpenLayers Map Script -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">
    <script src="https://cdn.jsdelivr.net/npm/ol@latest/ol.js"></script>

    <script>
        async function loadIncidentMap() {
            try {
                const userId = '<%= Session["userId"] %>';
                const roleId = '<%= Session["roleId"] %>';
                const rangeId = document.getElementById('<%= ddlRange.ClientID %>').value || "0";
                const divisionId = document.getElementById('<%= ddlDivision.ClientID %>').value || "0";
                const startDate = document.getElementById('<%= txtStartDate.ClientID %>').value.trim();
                const endDate = document.getElementById('<%= txtEndDate.ClientID %>').value.trim();
                const category = document.getElementById('<%= ddlDataType.ClientID %>').value || "0";

                const apiBaseUrl = '<%= System.Configuration.ConfigurationManager.AppSettings["api_path"] %>';
                const apiUrl = apiBaseUrl +
                    'TblIncidentDetails/GetDashboardIncidentLocationsOnMap' +
                    '?userId=' + encodeURIComponent(userId) +
                    '&roleId=' + encodeURIComponent(roleId) +
                    '&claim_category=' + encodeURIComponent(category) +
                    '&fromdate=' + encodeURIComponent(startDate) +
                    '&todate=' + encodeURIComponent(endDate) +
                    '&division_id=' + encodeURIComponent(divisionId) +
                    '&range_id=' + encodeURIComponent(rangeId === "0" || !rangeId ? "0" : rangeId);

                const response = await fetch(apiUrl);
                const result = await response.json();

                const roadLayer = new ol.layer.Tile({
                    source: new ol.source.OSM(),
                    title: "Road",
                    visible: true
                });

                const markersSource = new ol.source.Vector();
                const markerLayer = new ol.layer.Vector({ source: markersSource });

                const map = new ol.Map({
                    target: 'incidentMap',
                    layers: [roadLayer, markerLayer],
                    view: new ol.View({
                        center: ol.proj.fromLonLat([79.0193, 30.0668]),
                        zoom: 8
                    })
                });

                const popupElement = document.createElement('div');
                popupElement.className = 'ol-popup';
                const popup = new ol.Overlay({
                    element: popupElement,
                    positioning: 'bottom-center',
                    stopEvent: false,
                    offset: [0, -25]
                });
                map.addOverlay(popup);

                const extent = ol.extent.createEmpty();

                result.data.forEach(function (item) {
                    if (item.lat && item.long) {
                        var lat = parseFloat(item.lat);
                        var lon = parseFloat(item.long);

                        if (!isNaN(lat) && !isNaN(lon)) {
                            var coord = ol.proj.fromLonLat([lon, lat]);

                            var marker = new ol.Feature({
                                geometry: new ol.geom.Point(coord),
                                incident: item
                            });
                            marker.setStyle(new ol.style.Style({
                                image: new ol.style.Icon({
                                    anchor: [0.5, 1],
                                    src: 'https://cdn-icons-png.flaticon.com/512/684/684908.png',
                                    scale: 0.08
                                })
                            }));

                            if (item.incidentPlace) {
                                var label = new ol.Feature({
                                    geometry: new ol.geom.Point(ol.proj.fromLonLat([lon, lat + 0.002]))
                                });
                                label.setStyle(new ol.style.Style({
                                    text: new ol.style.Text({
                                        text: item.incidentPlace,
                                        font: 'bold 12px sans-serif',
                                        fill: new ol.style.Fill({ color: '#079e54' }),
                                        stroke: new ol.style.Stroke({ color: '#fff', width: 2 }),
                                        backgroundFill: new ol.style.Fill({ color: 'rgba(255,255,255,0.9)' }),
                                        padding: [2, 5, 2, 5]
                                    })
                                }));
                                markersSource.addFeature(label);
                            }

                            markersSource.addFeature(marker);
                            ol.extent.extend(extent, marker.getGeometry().getExtent());
                        }
                    }
                });

                if (!ol.extent.isEmpty(extent)) {
                    map.getView().fit(extent, { padding: [50, 50, 50, 50], maxZoom: 14 });
                }

                map.on('click', function (evt) {
                    var feature = map.forEachFeatureAtPixel(evt.pixel, function (f) { return f; });
                    if (feature && feature.get('incident')) {
                        var i = feature.get('incident');
                        popupElement.innerHTML =
                            '<div>' +
                            '<b style="color:#2a5934;">Incident ID:</b> ' + i.incidentId + '<br>' +
                            '<b style="color:#2a5934;">Claim Category:</b> ' + (i.claimCategory || '-') + '<br>' +
                            '<b style="color:#2a5934;">Status:</b> ' + (i.status || '-') + '<br>' +
                            '<b style="color:#2a5934;">Incident Date:</b> ' + (i.incidentDate || '-') + '<br>' +
                            '<b style="color:#2a5934;">Division:</b> ' + (i.divisionName || '-') + '<br>' +
                            '<b style="color:#2a5934;">Range:</b> ' + (i.rangeName || '-') +
                            '</div>';
                        popup.setPosition(feature.getGeometry().getCoordinates());
                    } else {
                        popup.setPosition(undefined);
                    }
                });

            } catch (error) {
                console.error("Error loading OpenLayers map:", error);
            }
        }

        document.addEventListener("DOMContentLoaded", loadIncidentMap);
    </script>

</asp:Content>