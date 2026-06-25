<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="firedashboard.aspx.cs" Inherits="uk_forest.DSS.firedashboard"  Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

     <script src="https://cdn.jsdelivr.net/npm/xlsx/dist/xlsx.full.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css" />
    <style>
        body { background-color: #f8f9fa; overflow-x: hidden; }
        .filter-row { background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); margin-bottom: 20px; }
        .btn-success { background-color: #28a745; border-color: #28a745; }
        .map-container { background-color: #e9ecef; height: 410px; border-radius: 8px; overflow: hidden; position: relative; }
        .undermap { background-color: #ffffff; padding:10px; border-radius: 8px; margin-bottom: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); border:1px solid #068e618a !important; }
        .undermap h5 { margin-bottom: 5px; font-size: 18px; font-weight: 700; }
        .undermap h3 { color: #dc3545; font-size: 18px; font-weight:700; }
        a { text-decoration: none; }
        table { white-space: nowrap; }

        /* ===== ORIGINAL FILTER GRID (7 cols: zone, circle, div, range, startDate, endDate, search) ===== */
        .topfilter {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            justify-content: center;
            grid-gap: 20px;
            align-items: center;
            transition: all 0.3s ease;
        }
        .topfilter select { width:100%; height:35px; background-color:white; border:1px solid #d2c6c6; border-radius:5px; }
        .topfilter input { width:100%; height:35px; border:1px solid #d2c6c6; border-radius:5px; padding:0 10px; box-sizing:border-box; }

        /* ===== REALTIME FILTER GRID (5 cols: zone, circle, div, range, search — no dates) ===== */
        .topfilter-realtime {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            justify-content: center;
            grid-gap: 25px;
            align-items: center;
            transition: all 0.3s ease;
        }
        .topfilter-realtime select { width:100%; height:35px; background-color:white; border:1px solid #d2c6c6; border-radius:5px; box-sizing:border-box; }

        /* Date filter label style */
        .filter-label-top { font-weight:600; font-size:15px; display:block; margin-bottom:3px; }

        /* Popup */
        .ol-popup { position:absolute; background-color:white; padding:10px 10px 5px; border:1px solid #ccc; bottom:12px; left:-50px; min-width:220px; font-size:13px; box-shadow:0 1px 4px rgba(0,0,0,0.3); border-radius:8px; }
        .ol-popup:after,.ol-popup:before { top:100%; border:solid transparent; content:" "; height:0; width:0; position:absolute; pointer-events:none; }
        .ol-popup:after { border-top-color:white; border-width:10px; left:48px; margin-left:-10px; }
        .ol-popup:before { border-top-color:#ccc; border-width:11px; left:48px; margin-left:-11px; }
        .popup-closer { position:absolute; top:5px; right:8px; cursor:pointer; font-weight:bold; font-size:14px; color:#666; }
        .popup-closer:hover { color:red; }
        .map-legend { position:absolute; bottom:20px; left:20px; background:rgba(255,255,255,0.9); padding:10px 15px; border:1px solid #ccc; border-radius:8px; font-size:13px; box-shadow:0 1px 4px rgba(0,0,0,0.3); z-index:1000; }
        .map-legend h4 { margin:0 0 5px; font-size:14px; }
        .legend-icon { display:inline-block; width:12px; height:12px; margin-right:8px; vertical-align:middle; border:1px solid #333; border-radius:50%; }
        .legend-icon.red { background-color:red; }
        .legend-icon.orange { background-color:orange; }
        .legend-icon.green { background-color:green; }
        .legend-icon.blue { background-color:blue; border-radius:0; }

        /* Tabs */
        .dashboard-tabs { margin-top:20px; margin-bottom:0; background-color:#ffffff; border-radius:8px 8px 0 0; box-shadow:0 2px 6px rgba(0,0,0,0.05); }
        .dashboard-tabs .nav-tabs { border-bottom:1px solid #25b76b3d; padding:10px 20px 0 20px; }
        .dashboard-tabs .nav-link { color:#6c757d; font-weight:600; font-size:16px; padding:14px 28px; border:none; border-radius:8px 8px 0 0; background:transparent; margin-right:5px; transition:all 0.3s ease; }
        .dashboard-tabs .nav-link:hover { background-color:rgba(40,167,69,0.1); color:#28a745; }
        .dashboard-tabs .nav-link.active { color:#ffffff; background:linear-gradient(135deg,#28a745 0%,#20c997 100%); box-shadow:0 4px 10px rgba(40,167,69,0.3); }

        /* Tab content */
        .tab-content { background-color:#ffffff; border-radius:0 0 8px 8px; box-shadow:0 2px 6px rgba(0,0,0,0.05); padding:20px; }
        .tab-pane { display:none; }
        .tab-pane.show,.tab-pane.active { display:block; }

        /* Realtime date filter bar — shown only in realtime tab */
        .realtime-date-bar {
            display: none;
            background: #fff;
            padding: 12px 20px;
            border-bottom: 1px solid #e0e0e0;
            align-items: flex-end;
            gap: 16px;
        }
        .realtime-date-bar.show { display: flex; }
        .realtime-date-bar label { font-weight:600; font-size:14px; display:block; margin-bottom:3px; color:#333; }
        .realtime-date-bar input[type="date"] { height:35px; border:1px solid #d2c6c6; border-radius:5px; padding:0 8px; font-size:13px; box-sizing:border-box; }

        /* Pie card */
        .rt-pie-card { background:white;  border-radius:8px; padding:10px; box-shadow:0 2px 6px rgba(0,0,0,0.05); height:410px; display:flex; flex-direction:column; }
        .rt-pie-title { font-size:13px; font-weight:700; color:#2c6e49; margin-bottom:4px; text-align:center; flex-shrink:0; }
        .rt-pie-loading { display:flex; align-items:center; justify-content:center; flex:1; color:#6c757d; font-size:13px; }
        .rt-pie-nodata { display:none; flex:1; align-items:center; justify-content:center; color:#999; font-size:13px; text-align:center; padding:20px; }

        /* Chart column */
        .chartColumn { width:100%; display:flex; }
        .chartColumn .col.d-flex { margin-bottom:8px; height:122px; }
        .chartColumn .col.d-flex:last-child { margin-bottom:0 !important; }
        span.civilContent { font-size:14px; }
        .chartColumn .col-lg-3 { height:380px; }
        .chartColumn .col-lg-6 { height:380px; }

        /* Map1 */
        #map1 { width:100%; height:410px; position:relative; }
        #popup-realtime { position:absolute; background-color:white; padding:10px 10px 5px; border:1px solid #ccc; bottom:12px; left:-50px; min-width:220px; font-size:13px; box-shadow:0 1px 4px rgba(0,0,0,0.3); border-radius:8px; }
        #popup-realtime:after,#popup-realtime:before { top:100%; border:solid transparent; content:" "; height:0; width:0; position:absolute; pointer-events:none; }
        #popup-realtime:after { border-top-color:white; border-width:10px; left:48px; margin-left:-10px; }
        #popup-realtime:before { border-top-color:#ccc; border-width:11px; left:48px; margin-left:-11px; }
        #popup-closer-realtime { position:absolute; top:5px; right:8px; cursor:pointer; font-weight:bold; font-size:14px; color:#666; }
        #popup-closer-realtime:hover { color:red; }
        #legend-realtime { position:absolute; bottom:20px; left:20px; background:rgba(255,255,255,0.9); padding:10px 15px; border:1px solid #ccc; border-radius:8px; font-size:13px; box-shadow:0 1px 4px rgba(0,0,0,0.3); z-index:1000; }
        #legend-realtime h4 { margin:0 0 5px; font-size:14px; }

        /* Grids */
        #grid_data,#grid_data_fsi { font-family:Arial,sans-serif; border-collapse:collapse; width:100%; }
        #grid_data tr:nth-child(even),#grid_data_fsi tr:nth-child(even) { background-color:#f2f2f2; }
        #grid_data tr:hover,#grid_data_fsi tr:hover { background-color:#ddd; }
        #grid_data th,#grid_data_fsi th { padding-top:12px; padding-bottom:12px; text-align:left; background-color:#04AA6D; color:white; }
        th,td { padding: 5px 20px;
  border-bottom: 1px solid #bcbcbc;
  text-align: left;
  font-size: 14px;
  border-left: 1px solid #bcbcbc;}

        /* Date validation error */
        .date-error { color:red; font-size:12px; margin-top:3px; display:none; }

        /* Spinner */
        .spinner-border-sm { width:16px; height:16px; }
    </style>
    <style>
        .loader-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.45);
    z-index: 99999;
    display: flex;
    justify-content: center;
    align-items: center;
}

.loader-box {
    background: #fff;
    padding: 20px 30px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 5px 20px rgba(0,0,0,.2);
}

.spinner {
    width: 45px;
    height: 45px;
    border: 4px solid #e5e5e5;
    border-top: 4px solid #28a745;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin: auto;
}

.loader-text {
    margin-top: 12px;
    font-weight: 600;
    color: #333;
}

@keyframes spin {
    100% {
        transform: rotate(360deg);
    }
}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

    <div id="loaderOverlay" class="loader-overlay" style="display:none;">
    <div class="loader-box">
        <div class="spinner"></div>
        <div class="loader-text">Loading Map Data...</div>
    </div>
</div>


    <div class="container-fluid px-4">
        <asp:Label ID="LabelInContent" runat="server" Text="Fire Monitoring Dashboard" Visible="false" />
        <asp:HiddenField ID="hdnActiveTab" runat="server" Value="monitoring" />

        <%-- Dedicated UpdatePanel for FSI data — always updates so JS gets fresh JSON --%>
        <asp:UpdatePanel ID="upFsiData" runat="server" UpdateMode="Always">
            <ContentTemplate>
                <asp:HiddenField ID="hdnFsiData" runat="server" Value="" />
                <%-- NEW: flag set by server when FSI API fails --%>
                <asp:HiddenField ID="hdnFsiApiError" runat="server" Value="" />
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- ===== SINGLE FILTER ROW ===== -->
        <asp:UpdatePanel runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="filter-row mt-4">
                    <form id="filterForm">
                        <div class="topfilter" id="filterNormal">
                            <div>
                                <asp:Label Text="Zone" CssClass="filter-label-top" runat="server" />
                                <asp:DropDownList runat="server" ID="ddlzone" class="form-select1"
                                    OnSelectedIndexChanged="ddlzone_SelectedIndexChanged" AutoPostBack="true" />
                            </div>
                            <div>
                                <asp:Label Text="Circle" CssClass="filter-label-top" runat="server" />
                                <asp:DropDownList runat="server" ID="ddlcircle" class="form-select1"
                                    OnSelectedIndexChanged="ddlcircle_SelectedIndexChanged" AutoPostBack="true" />
                            </div>
                            <div>
                                <label class="filter-label-top">Division</label>
                                <asp:DropDownList runat="server" ID="division" class="form-select1"
                                    OnSelectedIndexChanged="division_SelectedIndexChanged" AutoPostBack="true" />
                            </div>
                            <div>
                                <label class="filter-label-top">Range</label>
                                <asp:DropDownList runat="server" ID="range" class="form-select1"
                                    OnSelectedIndexChanged="range_SelectedIndexChanged" AutoPostBack="true" />
                            </div>
                            <div>
                                <label class="filter-label-top">Start Date</label>
                                <%-- min is fixed 01-Feb, max is set dynamically by JS to today --%>
                                <asp:TextBox runat="server" type="date" ID="txtStartDate"
                                    min="2026-02-01" />
                            </div>
                            <div>
                                <label class="filter-label-top">End Date</label>
                                <%-- min is fixed 01-Feb, max is set dynamically by JS to today --%>
                                <asp:TextBox runat="server" type="date" ID="txtEndDate"
                                    min="2026-02-01" />
                                <div id="dateError" style="color:red;font-size:12px;display:none;">
                                    End date cannot be before start date.
                                </div>
                                <div id="futureDateError" style="color:red;font-size:12px;display:none;">
                                    Date cannot be a future date.
                                </div>
                            </div>
                            <div>
                                <asp:Button ID="btnsearch" Text="Search" runat="server" OnClick="btnsearch_Click"
                                    class="btn btn-success w-100" style="margin-top:18px;"
                                    OnClientClick="return validateDates();" />
                            </div>
                        </div>
                    </form>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- ===== TABS ===== -->
        <div class="dashboard-tabs">
            <ul class="nav nav-tabs" id="dashboardTabs" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active" id="monitoring-tab" data-bs-toggle="tab" data-bs-target="#monitoring"
                        type="button" role="tab" onclick="setActiveTab('monitoring'); switchToMonitoring();">
                        Fire Incident Monitoring Dashboard
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" id="realtime-tab" data-bs-toggle="tab" data-bs-target="#realtime"
                        type="button" role="tab" onclick="setActiveTab('realtime'); switchToRealtime();">
                        Fire Realtime Monitoring Dashboard
                    </button>
                </li>
               
            </ul>
        </div>

        <!-- Hidden controls (server-side, not visible) -->
        <div style="display:none; visibility:hidden; height:0; overflow:hidden; position:absolute;">
            <asp:CheckBox runat="server" ID="chkNotForestFire" AutoPostBack="true" OnCheckedChanged="AlertFilter_CheckedChanged" />
            <asp:CheckBox runat="server" ID="chkActiveAlerts" AutoPostBack="true" OnCheckedChanged="AlertFilter_CheckedChanged" />
            <asp:CheckBox runat="server" ID="chkBeingHeld" AutoPostBack="true" OnCheckedChanged="AlertFilter_CheckedChanged" />
            <asp:CheckBox runat="server" ID="chkClosedAlerts" AutoPostBack="true" OnCheckedChanged="AlertFilter_CheckedChanged" />
            <asp:Label ID="lblAvgResponseTime" runat="server" Text="0" />
            <%-- Hidden realtime date inputs — keep for server-side binding --%>
            <asp:TextBox runat="server" ID="txtRealtimeStartDate" TextMode="Date" />
            <asp:TextBox runat="server" ID="txtRealtimeEndDate" TextMode="Date" />
            <asp:Button ID="btnRealtimeSearch" runat="server" Text="Search"
                OnClick="btnRealtimeSearch_Click" />
        </div>

        <!-- ===== TAB CONTENT ===== -->
        <div class="tab-content" id="dashboardTabContent">

            <!-- MONITORING TAB -->
            <div class="tab-pane fade show active" id="monitoring" role="tabpanel">
                 <div>
                      <span onclick="downloadMapAsJPG()" style="font-weight: 900;" title="Download Map">⬇️</span> 
                 </div>
                <div class="row mb-2">
                    <div class="col-md-12">
                        <div class="map-container" id="map">
                            <div id="legend" class="map-legend" style="display:none;">
                                <h4>Legend</h4>
                                <div><span class="legend-icon red"></span>Fire (Pending)</div>
                                <div><span class="legend-icon orange"></span>Fire (In Process)</div>
                                <div><span class="legend-icon green"></span>Fire (Solved)</div>
                            </div>
                            <div id="popup" class="ol-popup">
                                <div class="popup-closer" id="popup-closer">✖</div>
                                <div id="popup-content"></div>
                            </div>
                        </div>
                       <%-- <asp:UpdatePanel runat="server" UpdateMode="Conditional">
                            <ContentTemplate>--%>
                                <div class="row chartColumn mt-3">
                                    <div class="col-lg-3">
                                        <div class="col d-flex">
                                            <div class="undermap flex-fill text-center d-flex flex-column justify-content-center align-items-center border rounded shadow-sm">
                                                <asp:UpdatePanel runat="server">
          <ContentTemplate>

    
                                                <h5>Total Incidents</h5>
                                                <h3><asp:Label ID="lblTotalIncident" runat="server" Text="0" /></h3>
                    </ContentTemplate>
      </asp:UpdatePanel>
                                            </div>
                                        </div>
                                        <div class="col d-flex">
                                            <div class="undermap flex-fill text-center d-flex flex-column justify-content-center align-items-center border rounded shadow-sm">
                                                <asp:UpdatePanel runat="server">
              <ContentTemplate>

                                                <h5>Total Affected Area</h5>
                                                <h3>
                                                    <asp:Label ID="lblCivilForest" runat="server" Text="0" /> Ha /
                                                    <asp:Label ID="lblReservedForest" runat="server" Text="0" /> Ha
                                                </h3>
                                                <span class="civilContent">Civil Forest / Reserved Forest</span>
                  
              </ContentTemplate>
          </asp:UpdatePanel>
                                            </div>
                                        </div>
                                        <div class="col d-flex mb-3">
                                            <div class="undermap flex-fill text-center d-flex flex-column justify-content-center align-items-center border rounded shadow-sm">
                                                <h5>Today's Incidents</h5>
                                                <h3>0</h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3" style="box-shadow:0 1px 4px rgba(0,0,0,0.3);background:white;">
                                        <canvas id="fireDamageChart"></canvas>
                                    </div>
                                    <div class="col-lg-6" style="box-shadow:0 1px 4px rgba(0,0,0,0.3);">
                                        <canvas id="chartplantationandnursery" style="width:100% !important;"></canvas>
                                    </div>
                                </div>
                           <%-- </ContentTemplate>
                        </asp:UpdatePanel>--%>
                    </div>
                </div>
            </div>

            <!-- REALTIME TAB -->
            <div class="tab-pane fade" id="realtime" role="tabpanel">
                <div class="row mb-2">
                    <!-- Left: Pie Chart from FSI API -->
                    <div class="col-md-4">
                        <div class="rt-pie-card">
                            <div class="rt-pie-title" id="pieChartTitle">Fire Alerts by Circle</div>
                            <div id="pieChartLoading" class="rt-pie-loading">
                                <div class="spinner-border spinner-border-sm text-success me-2" role="status"></div>
                                Loading FSI data...
                            </div>
                            <canvas id="realtimeAlertPieChart" style="display:none; flex:1;"></canvas>
                            <div id="pieNoData" class="rt-pie-nodata">No data found for selected filters</div>
                        </div>
                    </div>
                    <!-- Right: Map -->
                    <div class="col-md-8">
                        <div class="map-container" id="map1">
                            <div id="legend-realtime" class="map-legend" style="display:none;">
                                <h4>Legend</h4>
                                <div><span class="legend-icon red"></span>SNPP/VIIRS</div>
                                <div><span class="legend-icon orange"></span>MODIS</div>
                                <div><span class="legend-icon green"></span>Other</div>
                            </div>
                            <div id="popup-realtime" class="ol-popup">
                                <div id="popup-closer-realtime" class="popup-closer">✖</div>
                                <div id="popup-content-realtime"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Monitoring Grid -->
    <div id="firemonitoring">
        <div style="text-align: right;
  padding: 15px 10px;">
              <button type="button" onclick="downloadExcel()" style="background-color: green;
  border: 1px solid green;
  padding: 5px;
  border-radius: 4px;
  color: white;">Download Excel</button>
        </div>
       
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <div class="row" style="overflow: auto;">
                    <asp:GridView runat="server" ID="grid_data" AutoGenerateColumns="false" AllowPaging="True"
                        PageSize="10" OnPageIndexChanging="GridView1_PageIndexChanging">
                        <Columns>

                            <asp:TemplateField HeaderText="S No">
                                <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                            </asp:TemplateField>

                              <asp:TemplateField HeaderText="Zone">
                                <ItemTemplate><%# Eval("zone") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Circle">
                                <ItemTemplate><%# Eval("circle") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Division">
                                <ItemTemplate><%# Eval("division") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Fire Date">
                                <ItemTemplate><%# Eval("firedate", "{0:yyyy-MM-dd}") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Incident No (RF)">
                                <ItemTemplate><%# Eval("incidentnoinrf") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Affected RF Area (Ha)">
                                <ItemTemplate><%# Eval("affectedrfareaha") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Incident No (Civil Soyam)">
                                <ItemTemplate><%# Eval("incidentnooincivilsoyam") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Affected Civil Soyam">
                                <ItemTemplate><%# Eval("affectedcivilsoyam") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Plantation Affected Area">
                                <ItemTemplate><%# Eval("plantationaffectedarea") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Leesaghao Affected">
                                <ItemTemplate><%# Eval("leesaghaoaffected") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Person Wounded">
                                <ItemTemplate><%# Eval("personwounded") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Person Dead">
                                <ItemTemplate><%# Eval("persondead") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Animal Wounded">
                                <ItemTemplate><%# Eval("animalwounded") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Animal Dead">
                                <ItemTemplate><%# Eval("animaldead") %></ItemTemplate>
                            </asp:TemplateField>

                        <%--    <asp:TemplateField HeaderText="Latitude Degree">
                                <ItemTemplate><%# Eval("lat_degree") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Latitude Minutes">
                                <ItemTemplate><%# Eval("lat_minutes") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Latitude Seconds">
                                <ItemTemplate><%# Eval("lat_seconds") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Longitude Degree">
                                <ItemTemplate><%# Eval("long_degree") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Longitude Minutes">
                                <ItemTemplate><%# Eval("long_minutes") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Longitude Seconds">
                                <ItemTemplate><%# Eval("long_seconds") %></ItemTemplate>
                            </asp:TemplateField>--%>

                          

                        </Columns>
                    </asp:GridView>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

        <!-- Realtime FSI Grid -->
        <div id="firemonitoringfsi" style="display:none;">
             <div style="text-align: right;
  padding: 15px 10px;">
              <button type="button" onclick="downloadExcelfsi()" style="background-color: green;
  border: 1px solid green;
  padding: 5px;
  border-radius: 4px;
  color: white;">Download Excel</button>
        </div>
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="row" style="overflow:auto;">
                        <asp:GridView runat="server" ID="grid_data_fsi" AutoGenerateColumns="False" AllowPaging="True"
                            PageSize="10" OnPageIndexChanging="grid_data_fsi_PageIndexChanging">
                            <Columns>
                                <asp:TemplateField HeaderText="S No"><ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Fire Date"><ItemTemplate><%# Eval("fire_Date") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Fire Time"><ItemTemplate><%# Eval("fire_Time") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Source Type"><ItemTemplate><%# Eval("source_Type") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="District"><ItemTemplate><%# Eval("district") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Circle"><ItemTemplate><%# Eval("circle") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Division"><ItemTemplate><%# Eval("division") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Range Name"><ItemTemplate><%# Eval("range") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Block"><ItemTemplate><%# Eval("block") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Beat"><ItemTemplate><%# Eval("beat") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="RFA/PFA"><ItemTemplate><%# Eval("rfA_PFA") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Compartment No."><ItemTemplate><%# Eval("compartment_No") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Latitude"><ItemTemplate><%# Eval("lat") %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Longitude"><ItemTemplate><%# Eval("long") %></ItemTemplate></asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

    </div>

    <!-- FSI API Error Toast -->
<div id="fsiApiErrorToast" style="
    display:none;
    position:fixed;
    top:20px;
    right:20px;
    z-index:9999;
    background:#fff3cd;
    border:1px solid #ffc107;
    border-left:5px solid #dc3545;
    border-radius:8px;
    padding:14px 18px;
    min-width:320px;
    max-width:420px;
    box-shadow:0 4px 12px rgba(0,0,0,0.15);
    font-size:14px;
    animation: slideInRight 0.3s ease;">
    <div style="display:flex;align-items:flex-start;gap:10px;">
        <span style="font-size:20px;">⚠️</span>
        <div style="flex:1;">
            <strong style="color:#dc3545;display:block;margin-bottom:4px;">
                FSI API Not Responding
            </strong>
            <span style="color:#555;">
                Live fire data from FSI server is currently unavailable. 
                Showing data from local database instead.
            </span>
        </div>
        <button onclick="document.getElementById('fsiApiErrorToast').style.display='none';"
            style="background:none;border:none;font-size:18px;cursor:pointer;color:#888;
                   padding:0;line-height:1;margin-left:4px;">✖</button>
    </div>
</div>

<style>
@keyframes slideInRight {
    from { transform: translateX(100px); opacity: 0; }
    to   { transform: translateX(0);    opacity: 1; }
}
</style>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="plantationjs/firedashboard.js"></script>

    <script>
        // =====================================================================
        // DATE CONFIG
        // DATE_MIN  : fixed — 01-Feb of current year
        // DATE_MAX  : dynamic — today's date (no future dates allowed)
        // =====================================================================
        const DATE_MIN = '<%= new DateTime(DateTime.Today.Year, 2, 1).ToString("yyyy-MM-dd") %>';

        // Today's date computed in JavaScript (used for max constraint)
        function getTodayStr() {
            const t = new Date();
            const y = t.getFullYear();
            const m = String(t.getMonth() + 1).padStart(2, '0');
            const d = String(t.getDate()).padStart(2, '0');
            return y + '-' + m + '-' + d;
        }
        const DATE_MAX = getTodayStr(); // Today — no future dates allowed

        // =====================================================================
        // Date Validation — called on Search button click
        // =====================================================================
        let activeTab = 'monitoring';

        document.addEventListener('DOMContentLoaded', function () {

            const tabs = document.querySelectorAll('#dashboardTabs button');

            tabs.forEach(tab => {
                tab.addEventListener('shown.bs.tab', function (event) {
                    activeTab = event.target.id; // monitoring-tab or realtime-tab
                });
            });
        });
        validateDates();
        function validateDates() {

            const sEl = document.getElementById('<%= txtStartDate.ClientID %>');
            const eEl = document.getElementById('<%= txtEndDate.ClientID %>');
            const errEl = document.getElementById('dateError');
            const futureErrEl = document.getElementById('futureDateError');

            // ✅ If Monitoring tab is active → DO NOT block anything
            if (document.getElementById('monitoring-tab')?.classList.contains('active')) {
                return true;
            }

            // ❗ Only apply validation if Realtime tab is active
            if (document.getElementById('realtime-tab')?.classList.contains('active')) {

                if (sEl.value < DATE_MIN) sEl.value = DATE_MIN;

                if (sEl.value > DATE_MAX) {
                    sEl.value = DATE_MAX;
                    if (futureErrEl) {
                        futureErrEl.style.display = 'block';
                        setTimeout(() => futureErrEl.style.display = 'none', 3000);
                    }
                }

                if (eEl.value < DATE_MIN) eEl.value = DATE_MIN;

                if (eEl.value > DATE_MAX) {
                    eEl.value = DATE_MAX;
                    if (futureErrEl) {
                        futureErrEl.style.display = 'block';
                        setTimeout(() => futureErrEl.style.display = 'none', 3000);
                    }
                }

                if (eEl.value && sEl.value && eEl.value < sEl.value) {
                    eEl.value = sEl.value;

                    if (errEl) {
                        errEl.style.display = 'block';
                        setTimeout(() => errEl.style.display = 'none', 3000);
                    }

                    return false;
                }

                if (errEl) errEl.style.display = 'none';
                if (futureErrEl) futureErrEl.style.display = 'none';
            }

            return true;
        }



       <%-- function validateDates() {
            const sEl = document.getElementById('<%= txtStartDate.ClientID %>');
            const eEl = document.getElementById('<%= txtEndDate.ClientID %>');
            const errEl = document.getElementById('dateError');
            const futureErrEl = document.getElementById('futureDateError');

            // Clamp start date
            if (sEl.value < DATE_MIN) sEl.value = DATE_MIN;
            if (sEl.value > DATE_MAX) {
                sEl.value = DATE_MAX;
                if (futureErrEl) { futureErrEl.style.display = 'block'; setTimeout(() => futureErrEl.style.display = 'none', 3000); }
            }

            // Clamp end date
            if (eEl.value < DATE_MIN) eEl.value = DATE_MIN;
            if (eEl.value > DATE_MAX) {
                eEl.value = DATE_MAX; // Force to today if future date entered
                if (futureErrEl) { futureErrEl.style.display = 'block'; setTimeout(() => futureErrEl.style.display = 'none', 3000); }
            }

            // End date cannot be before start date
            if (eEl.value && sEl.value && eEl.value < sEl.value) {
                eEl.value = sEl.value;
                if (errEl) { errEl.style.display = 'block'; setTimeout(() => errEl.style.display = 'none', 3000); }
                return false;
            }

            if (errEl) errEl.style.display = 'none';
            if (futureErrEl) futureErrEl.style.display = 'none';
            return true;
        }--%>

        // =====================================================================
        // Setup date input constraints (min/max attributes + change listeners)
        // =====================================================================
        function setupDateListeners() {
            const sEl = document.getElementById('<%= txtStartDate.ClientID %>');
            const eEl = document.getElementById('<%= txtEndDate.ClientID %>');
            if (!sEl || !eEl) return;

            const today = getTodayStr();

            // Set browser min/max — max is always TODAY (prevents calendar showing future dates)
            sEl.min = DATE_MIN;
            sEl.max = today;
            eEl.min = DATE_MIN;
            eEl.max = today; // <-- KEY CHANGE: max is today, not a hardcoded future date

            sEl.addEventListener('change', function () {
                const t = getTodayStr();
                if (this.value < DATE_MIN) this.value = DATE_MIN;
                if (this.value > t) {
                    this.value = t; // Cannot pick future date
                    const futureErrEl = document.getElementById('futureDateError');
                    if (futureErrEl) { futureErrEl.style.display = 'block'; setTimeout(() => futureErrEl.style.display = 'none', 3000); }
                }
                eEl.min = this.value; // end date min = new start date
                if (eEl.value && eEl.value < this.value) eEl.value = this.value;
            });

            eEl.addEventListener('change', function () {
                const t = getTodayStr();
                if (this.value < DATE_MIN) this.value = DATE_MIN;
                if (this.value > t) {
                    this.value = t; // Cannot pick future date
                    const futureErrEl = document.getElementById('futureDateError');
                    if (futureErrEl) { futureErrEl.style.display = 'block'; setTimeout(() => futureErrEl.style.display = 'none', 3000); }
                    return;
                }
                if (sEl.value && this.value < sEl.value) {
                    this.value = sEl.value;
                    const errEl = document.getElementById('dateError');
                    if (errEl) { errEl.style.display = 'block'; setTimeout(() => errEl.style.display = 'none', 3000); }
                }
            });
        }

        // ===== Hidden field =====
        function setActiveTab(tab) {
            document.getElementById('<%= hdnActiveTab.ClientID %>').value = tab;
        }
        function getActiveTab() {
            return document.getElementById('<%= hdnActiveTab.ClientID %>').value;
        }

        // ===== Tab Switch =====
        function switchToMonitoring() {
            document.getElementById('firemonitoring').style.display = 'block';
            document.getElementById('firemonitoringfsi').style.display = 'none';
            document.getElementById('monitoring').classList.add('show', 'active');
            document.getElementById('realtime').classList.remove('show', 'active');
            document.getElementById('monitoring-tab').classList.add('active');
            document.getElementById('realtime-tab').classList.remove('active');
            setTimeout(() => {
                if (typeof map !== 'undefined') map.updateSize();
                if (typeof applyfilter === 'function') applyfilter();
            }, 150);
        }

        var _realtimePostbackDone = false;

        function switchToRealtime() {
            document.getElementById('firemonitoring').style.display = 'none';
            document.getElementById('firemonitoringfsi').style.display = 'block';
            document.getElementById('monitoring').classList.remove('show', 'active');
            document.getElementById('realtime').classList.add('show', 'active');
            document.getElementById('monitoring-tab').classList.remove('active');
            document.getElementById('realtime-tab').classList.add('active');

            setTimeout(() => {
                if (typeof map1 !== 'undefined') map1.updateSize();

                if (window._lastFsiData && window._lastFsiData.length > 0) {
                    const f = window._lastFsiFilters || { circle: 'All', division: 'All', range: 'All' };
                    if (typeof renderFsiFromServer === 'function')
                        renderFsiFromServer(window._lastFsiData, f.circle, f.division, f.range);
                } else if (!_realtimePostbackDone) {
                    _realtimePostbackDone = true;
                    const btn = document.getElementById('<%= btnsearch.ClientID %>');
                    if (btn) btn.click();
                }
            }, 300);
        }

        function applyTabView() {
            if (getActiveTab() === 'realtime') switchToRealtime();
            else switchToMonitoring();
        }

        // ===== Init =====
        document.addEventListener('DOMContentLoaded', function () {
            setupDateListeners();
            applyTabView();
            document.getElementById('monitoring-tab')?.addEventListener('click', () => {
                _realtimePostbackDone = false;
                setActiveTab('monitoring');
                switchToMonitoring();
            });
            document.getElementById('realtime-tab')?.addEventListener('click', () => {
                _realtimePostbackDone = false;
                window._lastFsiData = null;
                setActiveTab('realtime');
                switchToRealtime();
            });
        });

        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                setupDateListeners(); // Re-apply max=today after every postback
                const tab = getActiveTab();
                if (tab === 'monitoring') {
                    document.getElementById('firemonitoring').style.display = 'block';
                    document.getElementById('firemonitoringfsi').style.display = 'none';
                    if (typeof applyfilter === 'function') setTimeout(() => applyfilter(), 200);
                } else {
                    document.getElementById('firemonitoring').style.display = 'none';
                    document.getElementById('firemonitoringfsi').style.display = 'block';
                    document.getElementById('monitoring').classList.remove('show', 'active');
                    document.getElementById('realtime').classList.add('show', 'active');
                    document.getElementById('monitoring-tab').classList.remove('active');
                    document.getElementById('realtime-tab').classList.add('active');
                    if (typeof map1 !== 'undefined') setTimeout(() => map1.updateSize(), 200);
                }
            });
        }

        const toggleBtn = document.querySelector('.dropdown-toggle');
        const menu = document.querySelector('.dropdown-menu');
        if (toggleBtn && menu) toggleBtn.addEventListener('click', () => menu.classList.toggle('show'));
    </script>
</asp:Content>
