<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="patrollingDashboard.aspx.cs" Inherits="uk_forest.DSS.patrollingDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Bootstrap 5 CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <!-- OpenLayers -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css" />
  <style>
    body { background-color: #f8f9fa; overflow-x: hidden; }
    .filter-header { font-size: 28px; font-weight: bold; color: #2c6e49; margin-top: 30px; margin-bottom: 20px; }
    .filter-row { background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); }
    .btn-success { background-color: #28a745; border-color: #28a745; }
    .map-container { background-color: #e9ecef; height: 410px; border-radius: 8px; overflow: hidden; position: relative; }
    .filters-box { background-color: #ffffff; padding: 70px 20px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); }
    .filters-box h5 { margin-bottom: 15px; color: #343a40; }
    .section-divider { margin-top: 15px; margin-bottom: 10px; border-bottom: 1px solid #dee2e6; padding-bottom: 5px; font-weight: 600; }
    .custom-bg { background-color: #ffffff; padding: 15px; border-radius: 8px; text-align: center; box-shadow: 0 2px 6px rgba(0,0,0,0.05); }
    .custom-bg h4 { font-size: 20px; margin-bottom: 5px; }
    .undermap { background-color: #ffffff; padding: 15px; border-radius: 8px; margin-bottom: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); }
    .undermap h5 { margin-bottom: 5px; }
    .undermap h3 { color: #dc3545; }
    .form-check-inline { margin-right: 20px; }
    .radio { margin-right: 10px; }
    .table-wrap { background: #fff; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    table { width: 100%; border-collapse: collapse; }
    thead { background: #f3f3f3; }
    th, td { padding: 5px 20px; border-bottom: 1px solid #eee; text-align: left; font-size: 14px; }
    th { font-weight: bold; text-align: left; }
    tbody tr:nth-child(even) { background: #fafafa; }
    .table-footer { padding: 12px 15px; background: #f3f3f3; text-align: right; }
    .pagination { display: inline-block; }
    .pagination button { background: #fff; border: 1px solid #ccc; padding: 6px 12px; margin: 0 2px; border-radius: 4px; cursor: pointer; }
    .pagination button:disabled { background: #eee; cursor: not-allowed; }
    .ol-popup { position: absolute; height: 200px; overflow: auto; background-color: white; padding: 10px 10px 5px; border: 1px solid #ccc; bottom: 12px; left: -50px; min-width: 220px; font-size: 13px; box-shadow: 0 1px 4px rgba(0,0,0,0.3); border-radius: 8px; }
    .ol-popup:after, .ol-popup:before { top: 100%; border: solid transparent; content: " "; height: 0; width: 0; position: absolute; pointer-events: none; }
    .ol-popup:after { border-top-color: white; border-width: 10px; left: 48px; margin-left: -10px; }
    .ol-popup:before { border-top-color: #ccc; border-width: 11px; left: 48px; margin-left: -11px; }
    .popup-closer { position: absolute; top: 5px; right: 8px; cursor: pointer; font-weight: bold; font-size: 14px; color: #666; }
    .popup-closer:hover { color: red; }
    .map-legend { position: absolute; bottom: 20px; left: 20px; background: rgba(255,255,255,0.9); padding: 10px 15px; border: 1px solid #ccc; border-radius: 8px; font-size: 13px; box-shadow: 0 1px 4px rgba(0,0,0,0.3); z-index: 1000; }
    .map-legend h4 { margin: 0 0 5px; font-size: 14px; }
    .legend-icon { display: inline-block; width: 12px; height: 12px; margin-right: 8px; vertical-align: middle; border: 1px solid #333; border-radius: 50%; }
    .legend-icon.red { background-color: red; }
    .legend-icon.orange { background-color: orange; }
    .legend-icon.green { background-color: green; }
    .legend-icon.blue { background-color: blue; border-radius: 0; }
    a { text-decoration: none; }
    table { white-space: nowrap; }
    .topfilter select { width: 100%; height: 35px; background-color: white; border: 1px solid #d2c6c6; border-radius: 5px; }
    select { width: 100%; height: 35px; background-color: white; border: 1px solid #d2c6c6; border-radius: 5px; }
    .topfilter input { width: 100%; height: 35px; border: 1px solid #d2c6c6; border-radius: 5px; padding: 0; }
    .filters-box h5 { font-weight: 700; color: #000; }
    #ContentPlaceHolder1_rdofirestatus tr td label { display: inline-block; margin-left: 5px; }

    /* ===== Month Multi-Select Dropdown ===== */
    #monthDropdownWrapper { position: relative; }
    .month-toggle-btn {
        width: 100%;
        height: 35px;
        border: 1px solid #d2c6c6;
        border-radius: 5px;
        background: white;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 10px;
        font-size: 14px;
        user-select: none;
        box-sizing: border-box;
    }
    .month-toggle-btn:hover { border-color: #999; }
    .month-checkbox-list {
        display: none;
        position: absolute;
        top: 37px;
        left: 0;
        z-index: 9999;
        background: white;
        border: 1px solid #d2c6c6;
        border-radius: 5px;
        width: 160px;
        max-height: 260px;
        overflow-y: auto;
        box-shadow: 0 4px 12px rgba(0,0,0,0.18);
        padding: 4px 0;
    }
    .month-checkbox-list label {
        display: flex;
        align-items: center;
        padding: 6px 12px;
        cursor: pointer;
        font-size: 13px;
        margin: 0;
        transition: background 0.12s;
    }
    .month-checkbox-list label:hover { background: #f0f7f0; }
    .month-checkbox-list input[type="checkbox"] { margin-right: 8px; width: 14px; height: 14px; cursor: pointer; accent-color: #28a745; }
    .month-checkbox-list hr { margin: 3px 0; border-color: #eee; }
  </style>
  <style>
    #grid_data { font-family: Arial, Helvetica, sans-serif; border-collapse: collapse; width: 100%; }
    #grid_data td, #grid_data th { border: 1px solid #ddd; padding: 8px; }
    #grid_data tr:nth-child(even) { background-color: #f2f2f2; }
    #grid_data tr:hover { background-color: #ddd; }
    #grid_data th { padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #04AA6D; color: white; }

    /* 8 columns: Zone Circle Division Range Year Month Search */
    .topfilter {
        display: grid;
        grid-template-columns: repeat(8, 1fr);
        justify-content: center;
        grid-gap: 20px;
        align-items: center;
    }
    #ContentPlaceHolder1_btnsearch { position: relative; top: 12px; }
    #fireDamageChart-Container canvas { width: 100%; }
    .chartColumn { width: 100%; display: flex; }
    #chartplantationandnursery { width: 100% !important; }
  </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

    <div class="container-fluid px-4">
        <asp:Label ID="LabelInContent" runat="server" Text="Patrolling Monitoring Dashboard" Visible="false" />

        <!-- ===== Row 1: Filter Bar ===== -->
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <div class="filter-row mb-2 mt-5">
                    <form id="filterForm">
                        <div class="topfilter">

                            <!-- Zone -->
                            <div>
                                <asp:Label Text="Zone" style="font-weight:600;font-size:15px;" runat="server" />
                                <asp:DropDownList runat="server" ID="ddlzone"
                                    OnSelectedIndexChanged="ddlzone_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>

                            <!-- Circle -->
                            <div>
                                <asp:Label Text="Circle" style="font-weight:600;font-size:15px;" runat="server" />
                                <asp:DropDownList runat="server" ID="ddlcircle"
                                    OnSelectedIndexChanged="ddlcircle_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>

                            <!-- Division -->
                            <div>
                                <label style="font-weight:600;font-size:15px;">Division</label>
                                <asp:DropDownList runat="server" ID="division"
                                    OnSelectedIndexChanged="division_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>

                            <!-- Range -->
                            <div>
                                <label style="font-weight:600;font-size:15px;">Range</label>
                                <asp:DropDownList runat="server" ID="range"
                                    OnSelectedIndexChanged="range_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>

                            <!-- Year (NEW) — single select, no multi needed -->
                            <div>
                                <label style="font-weight:600;font-size:15px;">Year</label>
                                <asp:DropDownList runat="server" ID="ddlyear">
                                </asp:DropDownList>
                            </div>

                            <!-- Month — multi-select checkboxes (NEW) -->
                            <div style="position:relative;">
                                <label style="font-weight:600;font-size:15px;">Month</label>
                                <div id="monthDropdownWrapper">
                                    <div class="month-toggle-btn" id="monthToggleBtn" onclick="toggleMonthDropdown()">
                                        <span id="monthDisplay">All Months</span>
                                        <span style="font-size:11px;color:#666;">&#9660;</span>
                                    </div>
                                    <div class="month-checkbox-list" id="monthCheckboxList">
                                        <!-- All option -->
                                        <label>
                                            <input type="checkbox" id="chkAllMonths" value="All"
                                                onchange="toggleAllMonths(this)" checked />
                                            <strong>All</strong>
                                        </label>
                                        <hr />
                                        <label><input type="checkbox" class="monthChk" value="1"  onchange="updateMonthDisplay()" /> Jan</label>
                                        <label><input type="checkbox" class="monthChk" value="2"  onchange="updateMonthDisplay()" /> Feb</label>
                                        <label><input type="checkbox" class="monthChk" value="3"  onchange="updateMonthDisplay()" /> Mar</label>
                                        <label><input type="checkbox" class="monthChk" value="4"  onchange="updateMonthDisplay()" /> Apr</label>
                                        <label><input type="checkbox" class="monthChk" value="5"  onchange="updateMonthDisplay()" /> May</label>
                                        <label><input type="checkbox" class="monthChk" value="6"  onchange="updateMonthDisplay()" /> Jun</label>
                                        <label><input type="checkbox" class="monthChk" value="7"  onchange="updateMonthDisplay()" /> Jul</label>
                                        <label><input type="checkbox" class="monthChk" value="8"  onchange="updateMonthDisplay()" /> Aug</label>
                                        <label><input type="checkbox" class="monthChk" value="9"  onchange="updateMonthDisplay()" /> Sep</label>
                                        <label><input type="checkbox" class="monthChk" value="10" onchange="updateMonthDisplay()" /> Oct</label>
                                        <label><input type="checkbox" class="monthChk" value="11" onchange="updateMonthDisplay()" /> Nov</label>
                                        <label><input type="checkbox" class="monthChk" value="12" onchange="updateMonthDisplay()" /> Dec</label>
                                    </div>
                                </div>
                                <!-- Hidden field — carries comma-separated month numbers to server -->
                                <asp:HiddenField ID="hdnSelectedMonths" runat="server" Value="All" />
                            </div>

                            <!-- Search Button -->
                            <div style="display: flex;
  width: 300px;
   
  gap: 50px;">
                            

                                <asp:Button ID="btnsearch" Text="Search" runat="server"
                                    class="btn btn-success w-100"
                                    OnClick="btnsearch_Click" />

                                  <asp:Button  CssClass="btn" style="background-color:orange;position:relative;top:12px;padding: 0 5px;" ID="btnnewform" runat="server" Text="Patrolling Input Form" OnClick="btnnewform_Click" />
                            </div>

                        </div>
                    </form>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- ===== Row 2: Map + Left Filters ===== -->
        <div class="row mb-2">

            <!-- Left Filter Panel -->
            <div class="col-md-3">
                <div class="filters-box">
                    <h5>Filter Options</h5>

                    <div class="section-divider">Types of Patrolling</div>
                    <asp:DropDownList class="form-select1" runat="server" ID="ddltypeofpatrolling">
                    </asp:DropDownList>

                    <div class="section-divider">Animal Sighting</div>
                    <asp:RadioButtonList ID="rdofirestatus" runat="server" RepeatDirection="Vertical" AutoPostBack="true" OnSelectedIndexChanged="rdofirestatus_SelectedIndexChanged">
                        <asp:ListItem Text="Active"  Value="Active" />
                        <asp:ListItem Text="Passive" Value="Passive" />
                        <asp:ListItem Text="none"    Value="None" />
                    </asp:RadioButtonList>
                </div>
            </div>

            <!-- Map -->
            <div class="col-md-9">
                <div class="map-container" id="map">
                    <div id="legend" class="map-legend" style="display:none;">
                        <h4>Legend</h4>
                        <div><span class="legend-icon red"></span>Fire (Pending)</div>
                        <div><span class="legend-icon orange"></span>Fire (In Process)</div>
                        <div><span class="legend-icon green"></span>Fire (Solved)</div>
                    </div>
                    <div id="popup" class="ol-popup">
                        <div class="popup-closer" id="popup-closer">&#10006;</div>
                        <div id="popup-content"></div>
                    </div>
                </div>

                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div class="row chartColumn" style="display:none;">
                            <div class="col-md-4">
                                <div class="row mt-1">
                                    <div class="col d-flex">
                                        <div class="undermap flex-fill text-center d-flex flex-column justify-content-center align-items-center p-4 border rounded shadow-sm">
                                            <h5>Total Fires</h5>
                                            <h3>
                                                <asp:Label ID="triggered1" runat="server" /> /
                                                <asp:Label ID="nontriggered1" runat="server" />
                                            </h3>
                                            <span>Active / In-active</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col d-flex">
                                        <div class="undermap flex-fill text-center d-flex flex-column justify-content-center align-items-center p-4 border rounded shadow-sm">
                                            <h5>Total Affected Area</h5>
                                            <h3><asp:Label ID="lblaffectedarea" runat="server" /> ha</h3>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-8" style="box-shadow: 0 1px 4px rgba(0,0,0,0.3);">
                                <canvas id="chartplantationandnursery" style="width:100% !important; height:300px !important;"></canvas>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <!-- ===== Charts Row ===== -->
        <div class="row mt-2">
            <div class="col-md-6">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div id="fireDamageChart-Container" class="mt-1"
                             style="box-shadow:0 1px 4px rgba(0,0,0,0.3);background-color:white;">
                            <canvas id="patrollingtypechart"></canvas>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="col-md-6">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div class="mt-1"
                             style="box-shadow:0 1px 4px rgba(0,0,0,0.3);background-color:white;">
                            <canvas id="patrolChartregion"></canvas>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <!-- ===== Grid Row ===== -->
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <div class="row" style="height:300px; overflow:auto; display:none;">
                    <asp:GridView runat="server" ID="grid_data"></asp:GridView>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

    </div><!-- /container-fluid -->

    <!-- Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="plantationjs/patrollingDashboard.js"></script>

    <script>
        // ===== Existing sidebar toggle =====
        var toggleBtn = document.querySelector('.dropdown-toggle');
        var menu = document.querySelector('.dropdown-menu');
        if (toggleBtn && menu) {
            toggleBtn.addEventListener('click', function () {
                menu.classList.toggle('show');
            });
        }

        // ===== Month Multi-Select Logic =====

        function toggleMonthDropdown() {
            var list = document.getElementById('monthCheckboxList');
            list.style.display = (list.style.display === 'block') ? 'none' : 'block';
        }

        // Close when clicking outside
        document.addEventListener('click', function (e) {
            var wrapper = document.getElementById('monthDropdownWrapper');
            if (wrapper && !wrapper.contains(e.target)) {
                var list = document.getElementById('monthCheckboxList');
                if (list) list.style.display = 'none';
            }
        });

        // "All" clicked → uncheck individual months
        function toggleAllMonths(chk) {
            document.querySelectorAll('.monthChk').forEach(function (b) {
                b.checked = false;
            });
            updateMonthDisplay();
        }

        // Individual month changed
        function updateMonthDisplay() {
            var checked = document.querySelectorAll('.monthChk:checked');
            var allChk = document.getElementById('chkAllMonths');
            var display = document.getElementById('monthDisplay');
            var hidden = document.getElementById('<%= hdnSelectedMonths.ClientID %>');

            var monthNames = {
                1: 'Jan', 2: 'Feb', 3: 'Mar', 4: 'Apr', 5: 'May', 6: 'Jun',
                7: 'Jul', 8: 'Aug', 9: 'Sep', 10: 'Oct', 11: 'Nov', 12: 'Dec'
            };

            if (checked.length === 0) {
                // Nothing selected → revert to All
                allChk.checked = true;
                display.innerText = 'All Months';
                if (hidden) hidden.value = 'All';
            } else {
                allChk.checked = false;
                var names = Array.from(checked).map(function (c) {
                    return monthNames[parseInt(c.value)];
                });
                var vals = Array.from(checked).map(function (c) { return c.value; });

                // Show up to 3 names, then "+N more"
                display.innerText = names.length <= 3
                    ? names.join(', ')
                    : names.slice(0, 3).join(', ') + ' +' + (names.length - 3) + ' more';

                if (hidden) hidden.value = vals.join(',');
            }
        }
    </script>
</asp:Content>
