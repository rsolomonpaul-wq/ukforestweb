
<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master"
    AutoEventWireup="true"
    CodeBehind="nurseryDashboard.aspx.cs"
    Inherits="uk_forest.DSS.nurseryDashboard"
    Async="true" EnableEventValidation="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />

    <!-- OpenLayers -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>

    <style>
        a {
          text-decoration: none !important;
        }
        .dashboard-container {
            min-height: 100vh;
        }

        .filter-card {
            border: none;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 4px 15px rgba(0,0,0,.08);
        }

        .dashboard-ddl {
            height: 35px;
            border-radius: 8px;
            font-size: 14px;
        }

        .dashboard-card {
            border: none;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,.08);
        }

        .dashboard-card .card-header {
            background: #1b4332;
            color: #fff;
            font-weight: 600;
            padding: 12px 18px;
            font-size: 15px;
        }

        .stats-card {
            border-radius: 8px;
            color: #fff;
            padding: 22px;
            position: relative;
            overflow: hidden;
            transition: .3s;
            margin-bottom: 15px;
        }

        .stats-card:hover {
            transform: translateY(-3px);
        }

        .stats-card i {
            position: absolute;
            right: 15px;
            top: 15px;
            font-size: 34px;
            opacity: .25;
        }

        .stats-card h3 {
            margin: 0;
            font-size: 30px;
            font-weight: 700;
        }

        .stats-card span {
            font-size: 14px;
        }

        .green {
            background: linear-gradient(135deg,#198754,#157347);
        }

        .blue {
            background: linear-gradient(135deg,#0d6efd,#3d8bfd);
        }

        .orange {
            background: linear-gradient(135deg,#fd7e14,#ff9f43);
        }

        .purple {
            background: linear-gradient(135deg,#6f42c1,#8f5cf7);
        }

        #map {
            width: 100%;
            height: 550px;
        }

        .gridview table {
            width: 100% !important;
        }

        .gridview th {
            background: #1b4332;
            color: #fff;
            padding: 10px;
            white-space: nowrap;
        }

        .gridview td {
            padding: 8px;
            vertical-align: middle;
        }

        label {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 5px;
            display: block;
            color: #444;
        }

        .loader {
            text-align: center;
            padding: 15px;
        }

        .card-canvas{
            display:flex;justify-content:center;padding: 15px;
        }
        #balanceChart {
            height: 250.3px !important;
            width: 250px;
            display: block;
            box-sizing: border-box;
        }

        .gp {
            display: flex;
            width: 100%;
            gap: 15px;
            justify-content: center;
        }
        .p{
            width:40%;
        }
        .card-canvas1{
            display:block !important;
            padding: 10px;
        }
        @media(max-width:768px) {

            #map {
                height: 350px;
            }

            .stats-card {
                text-align: center;
            }
        }
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

.map-popup {

    position: absolute;

    top: 20px;
    right: 20px;

    width: 500px;
    

    background: #fff;

    border-radius: 10px;

    box-shadow: 0 8px 25px rgba(0,0,0,.25);

    z-index: 9999;

    display: none;

    overflow: hidden;
    font-size:12px;
}

.popup-header {

    background: #1b4332;

    color: #fff;

    padding: 10px 15px;

    display: flex;

    justify-content: space-between;

    align-items: center;
}

.popup-content {

    max-height: 320px;

    overflow-y: auto;

    padding: 10px;
}

.popup-content table {

    width: 100%;
}

.popup-content td {

    border: 1px solid #f2efe9;

}

.popup-content td:first-child {

    font-weight: 600;

    width: 40%;
}

@keyframes spin {
    100% {
        transform: rotate(360deg);
    }
}
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    
    <div id="loaderOverlay" class="loader-overlay" style="display:none;">
    <div class="loader-box">
        <div class="spinner"></div>
        <div class="loader-text">Please Wait...</div>
    </div>
</div>


    <div class="container-fluid dashboard-container">

        <asp:UpdatePanel ID="updDashboard" runat="server" UpdateMode="Conditional">

            <ContentTemplate>

                <!-- FILTERS -->
                <div class="card filter-card mb-3">
                    <div class="card-body">

                        <div class="row g-3">

                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <label>Zone</label>
                                <asp:DropDownList ID="ddlzone"
                                    runat="server"
                                    CssClass="form-select dashboard-ddl"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="zone_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>

                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <label>Circle</label>
                                <asp:DropDownList ID="ddlcircle"
                                    runat="server"
                                    CssClass="form-select dashboard-ddl"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="circle_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>

                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <label>Division</label>
                                <asp:DropDownList ID="ddldivision"
                                    runat="server"
                                    CssClass="form-select dashboard-ddl"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="division_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>

                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <label>Range</label>
                                <asp:DropDownList ID="ddlrange"
                                    runat="server"
                                    CssClass="form-select dashboard-ddl"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="range_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>

                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <label>Nursery Name</label>
                               <%-- <asp:DropDownList ID="ddlnursery"
                                    runat="server"
                                    CssClass="form-select dashboard-ddl"
                                   
                                    >
                                </asp:DropDownList>--%>
                                <select id="ddlnursery" class="form-select dashboard-ddl">
                                    
                                </select>
                            </div>

                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <label>Year</label>
                                <%--<asp:DropDownList ID="ddlyear"
                                    runat="server"
                                    CssClass="form-select dashboard-ddl"
                                    
                                    >
                                </asp:DropDownList>--%>
                                    <select id="ddlyear" class="form-select dashboard-ddl">
                                    
                                </select>
                            </div>

                        </div>

                    </div>
                </div>

                </ContentTemplate>

            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddlzone" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="ddlcircle" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="ddldivision" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="ddlrange" EventName="SelectedIndexChanged" />
               <%-- <asp:AsyncPostBackTrigger ControlID="ddlnursery" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="ddlyear" EventName="SelectedIndexChanged" />--%>
            </Triggers>

        </asp:UpdatePanel>

                <!-- CHARTS + MAP -->
                <div class="row">

                    <div class="col-lg-4">
                          <div class="card dashboard-card mb-3">
                            <div class="card-header">
                                Filter Options
                            </div>

                            <div class="card-canvas1" >
                                <div class="gp">
                                    <div class="p">
                                        <label>Scheme</label>
                                        <select class="form-select dashboard-ddl" id="slScheme" onchange="applyFilter()">
                                        </select>
                                    </div>
                                    <div class="p">
                                      <label>Species Category</label>
                                        <select class="form-select dashboard-ddl" id="slSpeciesCategory" onchange="applyFilter()">
                                        </select>
                                    </div>
                                </div>

                                 <div class="gp">
                                    <div class="p">
                                        <label>Species</label>
                                        <select class="form-select dashboard-ddl" id="slSpecies" onchange="applyFilter()">
                                        </select>
                                    </div>
                                    <div class="p">
                                      <label>Age</label>
                                        <select class="form-select dashboard-ddl" id="slAge" onchange="applyFilter()">
                                        </select>
                                    </div>
                                </div>

                                 <div class="gp">
                                    <div class="p">
                                        <label>Capacity (In Sapling)</label>
                                        <select class="form-select dashboard-ddl" id="slCapacity" onchange="applyFilter()">
                                        </select>
                                    </div>
                                    <div class="p">
                                        <label>Stock</label>
                                        <select class="form-select dashboard-ddl" id="slStock" onchange="applyFilter()">
                                     
                                        </select>
                                    </div>
                                </div>

                                
                            </div>
                        </div>
                        <div class="card dashboard-card mb-3">
                            <div class="card-header">
                                Stock vs Available Capacity
                            </div>

                            <div class="card-canvas" >
                                <div id="capacityChart" style="height:250px;display:none"></div>
                                  <canvas id="balanceChart" style="height:200px;width:200px"></canvas>
                            </div>
                        </div>

                        <div class="card dashboard-card">
                            <div class="card-header">
                                Species Distribution
                            </div>

                            <div class="card-canvas">
                              <canvas id="speciesChart" style="height:200px;width:200px"></canvas>
                            </div>
                        </div>

                    </div>

                    <div class="col-lg-8">

                        <div class="card dashboard-card">
                            <div class="card-header">
                                Nursery Locations
                            </div>

                            <div class="card-body p-0">
                                <button type="button" style="position: absolute;
  z-index: 1;
  right: 2px;" class="btn btn-success mb-3"
        onclick="downloadDashboardPDF()">
    <i class="fa fa-file-pdf"></i>
    Download Dashboard PDF
</button>
                                <div id="map">
                                    <div id="nurseryPopup" class="map-popup">
                                        <div class="popup-header">
                                            <span>Nursery Details</span>
                                            <button type="button" onclick="closePopup()">✖</button>
                                        </div>

                                        <div id="popupContent" class="popup-content"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="" style="display: flex; flex-direction: row; gap: 20px;">



                            <div class="card dashboard-card" style="width:50%">
                                <div class="card-header">
                                     Scheme-wise Stock
                                   
                                </div>

                                <div class="card-body p-0">
                                    <canvas id="schemeStockChart" style="height:215px !important"></canvas>
                                </div>
                            </div>

                            <div class="card dashboard-card" style="width:50%">
                                <div class="card-header">
                                    Region-wise Stock 
                                </div>

                                <div class="card-body p-0">
                                    <canvas id="divisionChart" style="height:215px !important"></canvas>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>

                <!-- GRID -->
               
          

    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script>

        var map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.OSM()
                })
            ],
            view: new ol.View({
                center: ol.proj.fromLonLat([78.25, 30.25]),
                zoom: 8.5
            })
        });
        var nurserySource = new ol.source.Vector();

        var nurseryLayer = new ol.layer.Vector({
            source: nurserySource
        });

        map.addLayer(nurseryLayer);


    </script>
    <script>
        function showLoader() {
            document.getElementById("loaderOverlay").style.display = "flex";
        }

        function hideLoader() {
            document.getElementById("loaderOverlay").style.display = "none";
        }

        let nurseryData = [];

        document.addEventListener("DOMContentLoaded", function () {
            loadNurseryData();
        });

        async function loadNurseryData() {

            try {
                showLoader();
                const response = await fetch(
                    'https://api.uttarakhandforestmis.in/nursery',
                    {
                        method: 'GET',
                        headers: {
                            'Authorization': 'Bearer CF9toR4XiUCIylP9A0ljsaYoBuarqqAvPejP3UrmTgBtoWocJi4Ff3Uxxq9OYc5thSrbBIOwZzhsye7KWC44UHwf0SufIpc6bqgIyb8epI1teYYVlloUYMpPjwBKsX2fipFsHAFYx09p6gxYzbDc4DzTC2XGq9K96UeokYMVeUyf9QIi3HPR5G9j4Hv2a2rVXhSJ',
                            'Content-Type': 'application/json'
                        }
                    });

                if (!response.ok) {
                    throw new Error('API Error : ' + response.status);
                }

                nurseryData = await response.json();

                console.log("Nursery Data:", nurseryData);

                // Example
                console.log("Total Records:", nurseryData.length);

                //// Call your functions
                bindMap(nurseryData);
                bindYearDropdown(nurseryData);
                bindNurseryDropdown(nurseryData);
                bindSpeciesChart(nurseryData);
                bindPlantBalanceChart(nurseryData);
                bindDivisionPlantChart(nurseryData);
                bindSchemeStockChart(nurseryData);
                bindFilterDropdowns(nurseryData);
                hideLoader();
            }
            catch (error) {
                console.error(error);
            }
        }

        map.on('singleclick', function (evt) {

            let clickedFeature = null;

            map.forEachFeatureAtPixel(
                evt.pixel,
                function (feature, layer) {

                    // Only allow nursery point layer
                    if (layer === nurseryLayer) {

                        clickedFeature = feature;
                        return true;
                    }

                }
            );

            // No nursery marker clicked
            if (!clickedFeature) {

                closePopup();
                return;

            }

            const nurseryData =
                clickedFeature.get('data');

            if (!nurseryData) {

                console.warn(
                    'No nursery data found on feature'
                );

                return;

            }

            console.log(
                'Clicked Nursery:',
                nurseryData
            );

            showNurseryPopup(
                nurseryData
            );

        });

        function formatColumnName(columnName) {

            return columnName
                .replace(/_english$/i, '')
                .replace(/_eng$/i, '')
                .replace(/_/g, ' ')
                .replace(/\b\w/g, function (c) {
                    return c.toUpperCase();
                });

        }

        function showNurseryPopup(data) {

            let html = '';

            html += '<table style="white-space: nowrap;" class="table table-sm">';

            Object.keys(data).forEach(function (key) {

                if (Array.isArray(data[key]))
                    return;

                if (
                    typeof data[key] === 'object' &&
                    data[key] !== null
                )
                    return;

                html += `
            <tr>
               <td>${formatColumnName(key)}</td>
                <td>${data[key] ?? ''}</td>
            </tr>
        `;
            });

            html += '</table>';

            if (
                data.species &&
                data.species.length > 0
            ) {

                html += `
            <h6 class="mt-3">
                Species Details
            </h6>

            <table class="table table-bordered table-sm">
                <thead>
                    <tr>
        `;

                Object.keys(data.species[0]).forEach(function (key) {

                    html += `<td>${formatColumnName(key)}</td>`;

                });

                html += `
                    </tr>
                </thead>
                <tbody>
        `;

                data.species.forEach(function (row) {

                    html += '<tr>';

                    Object.keys(row).forEach(function (key) {

                        html += `
                    <td>
                        ${row[key] ?? ''}
                    </td>
                `;

                    });

                    html += '</tr>';

                });

                html += `
                </tbody>
            </table>
        `;
            }

            document.getElementById(
                'popupContent'
            ).innerHTML = html;

            document.getElementById(
                'nurseryPopup'
            ).style.display = 'block';
        }
        function closePopup() {

            document.getElementById(
                'nurseryPopup'
            ).style.display = 'none';
        }



        function makePopupDraggable(elementId, headerClass) {

            const element = document.getElementById(elementId);
            const header = element.querySelector("." + headerClass);

            if (!element || !header) {
                console.error("Popup or header not found");
                return;
            }

            let offsetX = 0, offsetY = 0, isDragging = false;

            element.style.position = "absolute";

            header.style.cursor = "move";

            header.addEventListener("mousedown", (e) => {

                isDragging = true;

                offsetX = e.clientX - element.offsetLeft;
                offsetY = e.clientY - element.offsetTop;

                document.addEventListener("mousemove", move);
                document.addEventListener("mouseup", stop);

                e.preventDefault();
            });

            const move = (e) => {

                if (!isDragging) return;

                element.style.left = (e.clientX - offsetX) + "px";
                element.style.top = (e.clientY - offsetY) + "px";

            };

            const stop = () => {

                isDragging = false;

                document.removeEventListener("mousemove", move);
                document.removeEventListener("mouseup", stop);

            };

        }
        var nurseryLayer;
        var speciesChart = null;
        var balanceChart = null;
        var divisionChart = null;
        var schemeStockChart = null;

        var nurserySource;

        function bindNurseryDropdown(data) {

            const ddlNursery =
                document.getElementById('ddlnursery');

            ddlNursery.innerHTML = '';

            ddlNursery.add(new Option('All', 'All'));

            const nurseries =
                [...new Set(
                    data
                        .filter(x => x.nursery_name)
                        .map(x => x.nursery_name)
                )];

            nurseries.sort();

            nurseries.forEach(function (item) {

                ddlNursery.add(
                    new Option(item, item)
                );

            });
        }
        function bindYearDropdown(data) {

            const ddlYear =
                document.getElementById('ddlyear');

            ddlYear.innerHTML = '';

            ddlYear.add(new Option('All', 'All'));

            const years =
                [...new Set(
                    data
                        .filter(x => x.created_in_year)
                        .map(x => x.created_in_year)
                )];

            years.sort().reverse();

            years.forEach(function (item) {

                ddlYear.add(
                    new Option(item, item)
                );

            });
        }
        function bindSpeciesChart(filteredData) {
            if (!filteredData || filteredData.length === 0) {

                if (speciesChart) {
                    speciesChart.destroy();
                    speciesChart = null;
                }

                showNoData('speciesChart');
                return;
            }
            const speciesTotals = {};

            filteredData.forEach(function (nursery) {

                if (!nursery.species || nursery.species.length === 0)
                    return;

                nursery.species.forEach(function (sp) {

                    const speciesName =
                        sp.species_name_eng ||
                        sp.species_name ||
                        "Unknown";

                    const balance =
                        parseInt(sp.balance || 0);

                    if (!speciesTotals[speciesName]) {
                        speciesTotals[speciesName] = 0;
                    }

                    speciesTotals[speciesName] += balance;
                });
            });

            const labels = Object.keys(speciesTotals);

            if (labels.length === 0) {

                if (speciesChart) {
                    speciesChart.destroy();
                    speciesChart = null;
                }

                showNoData('speciesChart');
                return;
            }

            const data = Object.values(speciesTotals);

            const ctx =
                document.getElementById('speciesChart');

            if (speciesChart) {
                speciesChart.destroy();
            }

            speciesChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right'
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return context.label +
                                        ': ' +
                                        context.raw.toLocaleString();
                                }
                            }
                        }
                    }
                }
            });
        }
        function bindPlantBalanceChart(filteredData) {

            if (!filteredData || filteredData.length === 0) {

                if (balanceChart) {
                    balanceChart.destroy();
                    balanceChart = null;
                }

                showNoData('balanceChart');
                return;
            }

            let totalPlants = 0;
            let totalBalance = 0;

            filteredData.forEach(function (nursery) {

                totalPlants += parseInt(nursery.no_of_plants || 0);

                if (nursery.species && nursery.species.length > 0) {

                    nursery.species.forEach(function (sp) {

                        totalBalance += parseInt(sp.balance || 0);

                    });
                }
            });

            console.log("Plants:", totalPlants);
            console.log("Balance:", totalBalance);

            const ctx = document.getElementById('balanceChart');

            if (balanceChart) {
                balanceChart.destroy();
            }

            balanceChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: [
                        'Total Plants',
                        'Balance Plants'
                    ],
                    datasets: [{
                        data: [
                            totalPlants,
                            totalBalance
                        ],
                        backgroundColor: [
                            '#198754',
                            '#fd7e14'
                        ],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    cutout: '60%',
                    plugins: {
                        legend: {
                            position: 'bottom'
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return context.label + ': ' +
                                        context.raw.toLocaleString();
                                }
                            }
                        }
                    }
                }
            });
        }
        function bindDivisionPlantChart(filteredData) {

            if (!filteredData || filteredData.length === 0) {

                if (divisionChart) {
                    divisionChart.destroy();
                    divisionChart = null;
                }

                showNoData('divisionChart');
                return;
            }
            const divisionTotals = {};

            filteredData.forEach(function (item) {

                const division =
                    item.division_name_english || "Unknown";

                const plants =
                    parseInt(item.no_of_plants || 0);

                if (!divisionTotals[division]) {
                    divisionTotals[division] = 0;
                }

                divisionTotals[division] += plants;
            });

            const labels = Object.keys(divisionTotals);
            if (labels.length === 0) {

                if (divisionChart) {
                    divisionChart.destroy();
                    divisionChart = null;
                }

                showNoData('divisionChart');
                return;
            }
            const values = Object.values(divisionTotals);

            console.log(divisionTotals);

            const ctx =
                document.getElementById('divisionChart');

            if (divisionChart) {
                divisionChart.destroy();
            }

            divisionChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'No Of Plants',
                        data: values,
                        backgroundColor: '#198754',
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
        function bindSchemeStockChart(filteredData) {
            if (!filteredData || filteredData.length === 0) {

                if (schemeStockChart) {
                    schemeStockChart.destroy();
                    schemeStockChart = null;
                }

                showNoData('schemeStockChart');
                return;
            }
            const sectorTotals = {};

            filteredData.forEach(function (item) {

                const sector =
                    item.sector_name || "Unknown";

                const plants =
                    parseInt(item.no_of_plants || 0);

                if (!sectorTotals[sector]) {
                    sectorTotals[sector] = 0;
                }

                sectorTotals[sector] += plants;
            });

            const sorted = Object.entries(sectorTotals)
                .sort((a, b) => b[1] - a[1]);

            const labels = sorted.map(x => x[0]);
            if (labels.length === 0) {

                if (schemeStockChart) {
                    schemeStockChart.destroy();
                    schemeStockChart = null;
                }

                showNoData('schemeStockChart');
                return;
            }
            const values = sorted.map(x => x[1]);

            const ctx =
                document.getElementById('schemeStockChart');

            if (schemeStockChart) {
                schemeStockChart.destroy();
            }

            schemeStockChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Plants Stock',
                        data: values,
                        backgroundColor: '#fd7e14',
                        borderRadius: 8,
                        maxBarThickness: 45
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return context.raw.toLocaleString() + ' Plants';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
        function bindScheme(data) {

            const ddl = document.getElementById('slScheme');

            ddl.innerHTML = '';
            ddl.add(new Option('All', 'All'));

            const schemes = [...new Set(
                data
                    .filter(x => x.scheme_name)
                    .map(x => x.scheme_name)
            )];

            schemes.sort();

            schemes.forEach(x => {
                ddl.add(new Option(x, x));
            });
        }
        function bindSpeciesCategory(data) {

            const ddl = document.getElementById('slSpeciesCategory');

            ddl.innerHTML = '';
            ddl.add(new Option('All', 'All'));

            const categories = [];

            data.forEach(nursery => {

                if (nursery.species) {

                    nursery.species.forEach(sp => {

                        if (sp.species_type_eng) {
                            categories.push(sp.species_type_eng);
                        }

                    });
                }

            });

            [...new Set(categories)]
                .sort()
                .forEach(x => {

                    ddl.add(new Option(x, x));

                });
        }
        function bindSpecies(data) {

            const ddl = document.getElementById('slSpecies');

            ddl.innerHTML = '';
            ddl.add(new Option('All', 'All'));

            const species = [];

            data.forEach(nursery => {

                if (nursery.species) {

                    nursery.species.forEach(sp => {

                        if (sp.species_name_eng) {
                            species.push(sp.species_name_eng);
                        }

                    });
                }

            });

            [...new Set(species)]
                .sort()
                .forEach(x => {

                    ddl.add(new Option(x, x));

                });
        }
        function bindAge(data) {

            const ddl = document.getElementById('slAge');

            ddl.innerHTML = '';
            ddl.add(new Option('All', 'All'));

            const ages = [];

            data.forEach(nursery => {

                if (nursery.species) {

                    nursery.species.forEach(sp => {

                        if (sp.age) {
                            ages.push(sp.age);
                        }

                    });
                }

            });

            [...new Set(ages)]
                .sort((a, b) => parseInt(a) - parseInt(b))
                .forEach(x => {

                    ddl.add(new Option(x, x));

                });
        }
        function bindCapacity(data) {

            const ddl = document.getElementById('slCapacity');

            ddl.innerHTML = '';

            ddl.add(new Option('All', 'All'));
            ddl.add(new Option('0 - 1000', '0-1000'));
            ddl.add(new Option('1001 - 5000', '1001-5000'));
            ddl.add(new Option('5001 - 10000', '5001-10000'));
            ddl.add(new Option('10000+', '10000+'));
        }
        function bindStock(data) {

            const ddl = document.getElementById('slStock');

            ddl.innerHTML = '';

            ddl.add(new Option('All', 'All'));
            ddl.add(new Option('0 - 100', '0-100'));
            ddl.add(new Option('101 - 1000', '101-1000'));
            ddl.add(new Option('1001 - 5000', '1001-5000'));
            ddl.add(new Option('5000+', '5000+'));
        }
        function bindFilterDropdowns(data) {

            bindScheme(data);
            bindSpeciesCategory(data);
            bindSpecies(data);
            bindAge(data);
            bindCapacity(data);
            bindStock(data);
        }
        function bindMap(filteredData) {

            if (!nurserySource)
                return;

            nurserySource.clear();

            const features = [];

            filteredData.forEach(function (item) {

                const lat =
                    parseFloat(item.latitude || item.lat);

                const lng =
                    parseFloat(item.longitude || item.lng);

                if (
                    isNaN(lat) ||
                    isNaN(lng)
                )
                    return;

                const feature = new ol.Feature({

                    geometry: new ol.geom.Point(
                        ol.proj.fromLonLat([lng, lat])
                    ),

                    data: item

                });

                feature.setStyle(

                    new ol.style.Style({

                        image: new ol.style.Circle({

                            radius: 8,

                            fill: new ol.style.Fill({
                                color: '#198754'
                            }),

                            stroke: new ol.style.Stroke({
                                color: '#ffffff',
                                width: 2
                            })

                        })

                    })

                );

                features.push(feature);

            });

            nurserySource.addFeatures(features);

            if (features.length > 0) {

                const extent =
                    nurserySource.getExtent();

                map.getView().fit(
                    extent,
                    {
                        padding: [50, 50, 50, 50],
                        maxZoom: 14,
                        duration: 1000
                    }
                );
            }
        }
        var boundaryLayer = null;
        function showBoundary(str) {

            // Example input: "range = 'Maniknath'"
            // alert(str);
            var parts;
            var column;
            var value;
            var col;
            var filter;
            var boundaryURL;

            if (str !== undefined && str !== "") {
                console.log("str:", str);
                parts = str.split('=');

                column = parts[0].trim();          // range
                value = parts[1].trim();

                // remove quotes if present
                value = value.replace(/^'|'$/g, "").trim();

                // rename column if needed
                col = column === "range" ? "range" : column;

                filter = col + "='" + value + "'";
                boundaryURL =
                    "https://ukforestgis.in/geoserver/uk_sfd/ows?" +
                    "service=WFS&version=1.0.0&request=GetFeature" +
                    "&typeName=uk_sfd:tbl_" + column + "_master" +
                    "&outputFormat=application/json" +
                    "&CQL_FILTER=" + encodeURIComponent(filter);
            } else {
                boundaryURL =
                    "https://ukforestgis.in/geoserver/uk_sfd/ows?" +
                    "service=WFS&version=1.0.0&request=GetFeature" +
                    "&typeName=uk_sfd:tbl_zone_master" +
                    "&outputFormat=application/json";
            }




            console.log("Boundary URL:", boundaryURL);

            if (boundaryLayer) {

                map.removeLayer(boundaryLayer);
            }

            var vectorSource = new ol.source.Vector();

            boundaryLayer = new ol.layer.Vector({
                source: vectorSource,
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({
                        color: "#000000",
                        width: 2
                    })

                })
            });


            map.addLayer(boundaryLayer);

            fetch(boundaryURL)
                .then(r => {
                    if (!r.ok) throw new Error("Network error");
                    return r.json();
                })
                .then(data => {

                    const features = new ol.format.GeoJSON().readFeatures(data, {
                        dataProjection: "EPSG:4326",
                        featureProjection: map.getView().getProjection()
                    });

                    vectorSource.clear();
                    vectorSource.addFeatures(features);

                    if (features.length > 0) {

                        map.getView().fit(vectorSource.getExtent(), {
                            padding: [30, 30, 30, 30],
                            duration: 1000
                        });
                    }

                })
                .catch(err => console.error("Boundary load error:", err));
            return boundaryURL;
        }
        var boundaryURLreturn;
        function buildWFSUrl(zone, circle, division, range) {

            let filters = [];
            if (zone !== "All") filters.push(`zone='${zone}'`);
            if (circle !== "All") filters.push(`circle='${circle}'`);
            if (division !== "All") filters.push(`division='${division}'`);
            if (range !== "All") filters.push(`range='${range}'`);
            //if (filters.length == 0) {
            //    filters.push(`zone='All'`)
            //}
            showBoundary(filters[filters.length - 1]);


        }


        function applyFilter() {
            showLoader();

            let zone = document.getElementById('<%= ddlzone.ClientID %>').value;
            let circle = document.getElementById('<%= ddlcircle.ClientID %>').value;
    let division = document.getElementById('<%= ddldivision.ClientID %>').value;
            let range = document.getElementById('<%= ddlrange.ClientID %>').value;

            let scheme = document.getElementById('slScheme').value;
            let Species_Category = document.getElementById('slSpeciesCategory').value;
            let Species = document.getElementById('slSpecies').value;
            let Age = document.getElementById('slAge').value;
            let capacity = document.getElementById('slCapacity').value;
            let stock = document.getElementById('slStock').value;

            var url = buildWFSUrl(zone, circle, division, range);

            let filteredData = nurseryData.filter(function (x) {

                const totalCapacity = parseInt(x.no_of_plants || 0);

                const totalStock = (x.species || [])
                    .reduce((sum, s) => sum + parseInt(s.balance || 0), 0);

                return (zone === "All" || (x.chief_office_name_english || "").trim().toUpperCase() === zone.trim().toUpperCase()) &&
                    (circle === "All" || (x.circle_name_english || "").trim().toUpperCase() === circle.trim().toUpperCase()) &&
                    (division === "All" || (x.division_name_english || "").trim().toUpperCase() === division.trim().toUpperCase()) &&
                    (range === "All" || (x.range_name_eng || "").trim().toUpperCase() === range.trim().toUpperCase()) &&
                    (scheme === "All" || (x.scheme_name || "").trim().toUpperCase() === scheme.trim().toUpperCase()) &&
                    (Species_Category === "All" ||
                        (x.species || []).some(s => (s.species_type_eng || "").trim().toUpperCase() === Species_Category.trim().toUpperCase())) &&
                    (Species === "All" ||
                        (x.species || []).some(s => (s.species_name_eng || "").trim().toUpperCase() === Species.trim().toUpperCase())) &&
                    (Age === "All" ||
                        (x.species || []).some(s => String(s.age) === String(Age))) &&
                    (capacity === "All" || matchesRange(totalCapacity, capacity)) &&
                    (stock === "All" || matchesRange(totalStock, stock));
            });

            console.log(filteredData.length);

            bindNurseryDropdown(filteredData);
            bindYearDropdown(filteredData);
            bindSpeciesChart(filteredData);
            bindPlantBalanceChart(filteredData);
            bindDivisionPlantChart(filteredData);
            bindSchemeStockChart(filteredData);
            hideLoader();
            bindMap(filteredData);
        }

        function matchesRange(value, rangeKey) {
            if (rangeKey.endsWith('+')) {
                const min = parseInt(rangeKey);
                return value >= min;
            }
            const [min, max] = rangeKey.split('-').map(Number);
            return value >= min && value <= max;
        }

       <%-- function applyFilter() {
            showLoader();
            let zone = document.getElementById('<%= ddlzone.ClientID %>').value;

            let circle = document.getElementById('<%= ddlcircle.ClientID %>').value;

            let division = document.getElementById('<%= ddldivision.ClientID %>').value;

            let range = document.getElementById('<%= ddlrange.ClientID %>').value;

            let scheme = document.getElementById('slScheme').value;
            let Species_Category = document.getElementById('slSpeciesCategory').value;
            let Species = document.getElementById('slSpecies').value;
            let Age = document.getElementById('slAge').value;
            let capacity = document.getElementById('slCapacity').value;
            let stock = document.getElementById('slStock').value;
            var url = buildWFSUrl(
                zone,
                circle,
                division,
                range
            );
            let filteredData = nurseryData.filter(function (x) {

                return (zone === "All" || (x.chief_office_name_english || "").toUpperCase() === zone.toUpperCase()) &&
                    (circle === "All" || (x.circle_name_english || "").toUpperCase() === circle.toUpperCase()) &&
                    (division === "All" || (x.division_name_english || "").toUpperCase() === division.toUpperCase()) &&
                    (range === "All" || (x.range_name_eng || "").toUpperCase() === range.toUpperCase()) &&

                    (scheme === "All" ||
                        (x.scheme_name || "").toUpperCase() === scheme.toUpperCase())

                    &&

                    (Species_Category === "All" ||
                        (x.species || []).some(s =>
                            (s.species_type_eng || "").toUpperCase() === Species_Category.toUpperCase()
                        ))

                    &&

                    (Species === "All" ||
                        (x.species || []).some(s =>
                            (s.species_name_eng || "").toUpperCase() === Species.toUpperCase()
                        ))
                  

            });
            console.log(filteredData.length);
            bindNurseryDropdown(filteredData);
            bindYearDropdown(filteredData);
            bindSpeciesChart(filteredData);
            bindPlantBalanceChart(filteredData);
            bindDivisionPlantChart(filteredData);
            bindSchemeStockChart(filteredData);
           // bindFilterDropdowns(filteredData);
            hideLoader();
            // Optional
            bindMap(filteredData);
        }--%>

        function showNoData(canvasId) {

            const canvas = document.getElementById(canvasId);

            if (!canvas) return;

            const ctx = canvas.getContext('2d');

            ctx.clearRect(0, 0, canvas.width, canvas.height);

            ctx.font = "18px Arial";
            ctx.fillStyle = "#6c757d";
            ctx.textAlign = "center";

            ctx.fillText(
                "No Data Found",
                canvas.width / 2,
                canvas.height / 2
            );
        }

        makePopupDraggable("nurseryPopup", "popup-header");
    </script>

    <script>
        async function downloadDashboardPDF() {

            showLoader();

            try {

                const { jsPDF } = window.jspdf;

                const pdf = new jsPDF({
                    orientation: 'landscape',
                    unit: 'mm',
                    format: 'a4',
                    compress: true
                });

                const sections = [

                    {
                        title: 'Nursery Map',
                        element: document.getElementById('map')
                    },
                    {
                        title: 'Stock vs Available Capacity',
                        element: document.getElementById('balanceChart')
                    },
                    {
                        title: 'Species Distribution',
                        element: document.getElementById('speciesChart')
                    },
                    {
                        title: 'Region Wise Stock',
                        element: document.getElementById('schemeStockChart')
                    },
                    {
                        title: 'Division Wise Plants',
                        element: document.getElementById('divisionChart')
                    }

                ];

                let firstPage = true;

                for (const item of sections) {

                    const canvas = await html2canvas(
                        item.element,
                        {
                            scale: 4,                // High Resolution
                            useCORS: true,
                            backgroundColor: '#ffffff',
                            logging: false
                        });

                    const imgData =
                        canvas.toDataURL(
                            'image/jpeg',
                            1.0
                        );

                    if (!firstPage)
                        pdf.addPage();

                    firstPage = false;

                    // Professional Header
                    pdf.setFillColor(27, 67, 50);
                    pdf.rect(0, 0, 297, 18, 'F');

                    pdf.setTextColor(255, 255, 255);
                    pdf.setFont("helvetica", "bold");
                    pdf.setFontSize(18);

                    pdf.text(
                        "UTTARAKHAND FOREST DEPARTMENT",
                        10,
                        12
                    );

                    pdf.setFontSize(12);

                    pdf.text(
                        "Nursery Dashboard Report",
                        220,
                        12
                    );

                    // Section Title
                    pdf.setTextColor(33, 33, 33);

                    pdf.setFontSize(16);
                    pdf.setFont("helvetica", "bold");

                    pdf.text(
                        item.title,
                        10,
                        30
                    );

                    // Divider
                    pdf.setDrawColor(27, 67, 50);
                    pdf.setLineWidth(0.5);

                    pdf.line(
                        10,
                        34,
                        285,
                        34
                    );

                    // Card Background
                    pdf.setFillColor(248, 249, 250);

                    pdf.roundedRect(
                        8,
                        40,
                        281,
                        155,
                        3,
                        3,
                        'F'
                    );

                    // Image
                    pdf.addImage(
                        imgData,
                        'JPEG',
                        12,
                        45,
                        273,
                        145,
                        '',
                        'FAST'
                    );

                    // Footer
                    pdf.setFontSize(9);

                    pdf.setTextColor(100);

                    pdf.text(
                        "Generated On : " +
                        new Date().toLocaleString(),
                        10,
                        205
                    );

                    pdf.text(
                        "Page " + pdf.getNumberOfPages(),
                        270,
                        205
                    );
                }

                pdf.save(
                    'Nursery_Dashboard_Report.pdf'
                );

            }
            catch (ex) {

                console.error(ex);
                alert('Error generating PDF');

            }
            finally {

                hideLoader();

            }
        }
    </script>
    <script>
        const toggleBtn = document.querySelector('.dropdown-toggle');
        const menu = document.querySelector('.dropdown-menu');

        toggleBtn.addEventListener('click', () => {
            menu.classList.toggle('show'); // add/remove "show" class
        });
        if (menu.classList.contains("show")) {
            menu.classList.add("show");
        } else {
            menu.classList.remove("show");
        }
    </script>

</asp:Content>

