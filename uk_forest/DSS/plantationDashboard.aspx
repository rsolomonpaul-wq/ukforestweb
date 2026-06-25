<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="plantationDashboard.aspx.cs" Inherits="uk_forest.DSS.plantationDashboard" ClientIDMode="Static"  enableEventValidation="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />

    <!-- OpenLayers -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <link href="css/plantationCss.css" rel="stylesheet" />
    <style>
        .card-header {
            display: none !important; 
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
                                <label>Plantation</label>
                                <asp:DropDownList ID="ddlplantation" runat="server" CssClass="form-select dashboard-ddl">
                                   
                                </asp:DropDownList>
                            </div>


                              <div class="col-xl-2 col-lg-4 col-md-6">
                                <label>Plantation Year</label>
                                <asp:DropDownList ID="ddlyear" runat="server" CssClass="form-select dashboard-ddl">
                                   
                                </asp:DropDownList>
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
        <div>
            <div class="card filter-card border-0 shadow-sm mb-4">
    <div class="card-body">
        <div class="row g-4">

            <!-- Area Variant -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="custom-card">
                    <h6 class="card-heading">Area Variant</h6>

                    <div class="option-group">
                        <label>
                            <input type="radio" name="areaOption" id="hactare" checked>
                            Hectare
                        </label>

                        <label>
                            <input type="radio" name="areaOption" id="acre">
                            Acre
                        </label>

                        <label>
                            <input type="radio" name="areaOption" id="sqm">
                            Square Meter
                        </label>
                    </div>
                </div>
            </div>

            <!-- Feature Statistics -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="custom-card">
                    <h6 class="card-heading">Feature Statistics</h6>

                    <div class="option-group">
                        <label>
                            <input type="radio" name="dataOption" id="infoOption" checked>
                            Information
                        </label>

                        <label style="display:none">
                            <input type="radio" name="dataOption" id="slopeOption" disabled>
                            Features
                        </label>
                    </div>
                </div>
            </div>

            <!-- Plantation Lookup -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="custom-card">
                    <h6 class="card-heading">Plantation Site Lookup</h6>

                    <div class="cardsecond">
                        <input type="file"
                            id="fileInput"
                            accept=".zip,.kml"
                            class="form-control form-control-sm">

                        <button type="button"
                            id="removeLayerBtn"
                            class="btn btn-outline-secondary btn-sm">
                            <img src="img/reload.png" height="18">
                        </button>
                    </div>
                </div>
            </div>

            <!-- NDVI & Download -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="custom-card">
                    <h6 class="card-heading">NDVI Analysis</h6>

                   

                    <div class="d-flex justify-content-between align-items-center">
                         <input id="date"
                        type="date" style="width: 140px;"
                        class="form-control form-control-sm mb-3" onchange="getalert()">
                        <label class="mb-0">
                            <input id="chkforndvi"
                                type="checkbox"
                                onchange="callsentinel(this);">
                            NDVI
                        </label>

                        <button type="button"
                            class="btn btn-success btn-sm"
                            onclick="openPopup()">
                            <img src="img/downloadicon.png"
                                alt="download"
                                height="18">
                            
                        </button>

                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
          
        </div>

        <div>
            <div class="row g-3">

    <!-- Chart Section (30%) -->
 <div class="col-lg-4">

    <!-- First Card -->
    <div class="card shadow-sm mb-3">
        <div class="card-header">
            <h5 class="mb-0">Target Achieved Chart</h5>
        </div>
        <div class="card-body">
            <div style="height:350px;display:flex;justify-content:center;align-items:center" id="parentoftargetAchievedChart">
                <canvas id="targetAchievedChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Second Card -->
    <div class="card shadow-sm">
        <div class="card-header">
            <h5 class="mb-0">Plantation Type Chart</h5>
        </div>
        <div class="card-body">
            <div style="height:350px;" id="parentofplantationTypeChart">
                <canvas id="plantationTypeChart"></canvas>
            </div>
        </div>
    </div>

</div>

    <!-- Map Section (70%) -->
    <div class="col-lg-8">
        <div class=" h-100">
            <div class="card-header">
                <h5 class="mb-0">Map Section</h5>
            </div>
            <div class=" p-0">
                <!-- Your map goes here -->
                <div id="map" class="card-body" style="height:380px; width:100%;position: relative;">
                    <div id="ndvilengend" style="display: none;position:absolute;z-index:1;bottom:1px">

                          <div class="legend" id="legend">

                              <div class="legend-item">
                                  <div class="legend-color ndvi-dense"></div>
                                  <div class="legend-label"><strong>Dense</strong> - NDVI ≥ 0.60 </div>


                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndvi-moderate"></div>
                                  <div class="legend-label"><strong>Moderate</strong> - 0.40 ≤ NDVI &lt; 0.60</div>


                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndvi-low"></div>
                                  <div class="legend-label"><strong>Low</strong> - 0.20 ≤ NDVI &lt; 0.40</div>


                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndvi-verylow"></div>
                                  <div class="legend-label"><strong>Other</strong> - NDVI &lt; 0.20</div>


                              </div>
                          </div>

                      </div>
                </div>
                <div style="margin-top:10px">
                    <div class="row g-3">

                        <div class="col-md-6">
                            <div class="card shadow-sm h-100">
                                <div class="card-header">
                                    <h5 class="mb-0">Left Card</h5>
                                </div>
                                <div class="card-body">
                                    <div style="height: 400px;" id="parentofplantationBarChart">
                                        <canvas id="plantationBarChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card shadow-sm h-100">
                                <div class="card-header">
                                    <h5 class="mb-0">Right Card</h5>
                                </div>
                                <div class="card-body">
                                    <div style="height: 400px;"  id="parentofyearWiseChart">
                                        <canvas id="yearWiseChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
        </div>
    </div>
      <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
     <script src="https://unpkg.com/shpjs@latest/dist/shp.min.js"></script>
    <script>
        //const baseLayers = {
        //    osm: new ol.layer.Tile({
        //        visible: false,
        //        source: new ol.source.OSM()
        //    }),

        //    Sentinel: new ol.layer.Tile({
        //        visible: false,
        //        name: 'sentinal-2',
        //        source: new ol.source.TileWMS({
        //            url: 'https://services.sentinel-hub.com/ogc/wms/a9383ac8-3abd-45a5-a7c4-8173aaef4342',
        //            params: { "maxcc": 50, "minZoom": 6, "maxZoom": 16, "preset": "2_FALSE_COLOR", "layers": "2_FALSE_COLOR", "time": selecteddate },
        //            serverType: 'geoserver',
        //            crossOrigin: 'anonymous',
        //            transition: 0
        //        })
        //    })

        //};
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
    
    <script>
        var data;
        loadPlantations();
        async function loadPlantations() {

            const response = await fetch(
                "https://api.uttarakhandforestmis.in/plantations",
                {
                    headers: {
                        "Authorization": "Bearer CF9toR4XiUCIylP9A0ljsaYoBuarqqAvPejP3UrmTgBtoWocJi4Ff3Uxxq9OYc5thSrbBIOwZzhsye7KWC44UHwf0SufIpc6bqgIyb8epI1teYYVlloUYMpPjwBKsX2fipFsHAFYx09p6gxYzbDc4DzTC2XGq9K96UeokYMVeUyf9QIi3HPR5G9j4Hv2a2rVXhSJ"
                    }
                });

             data = await response.json();
            console.log(data);
            bindPlantationDropdown(data);
            bindYearDropdown(data);
            addPlantationsToMap(data);
            bindPlantationTypeChart(data);
            bindPlantationBarChart(data);
            bindYearWisePlantationChart(data);
            bindTargetVsAchievedChart(data);
            applyFilter();
        }
        const plantationSource = new ol.source.Vector();

        const plantationLayer = new ol.layer.Vector({
            source: plantationSource,
            style: function (feature) {

                if (feature.getGeometry().getType() === 'Point') {

                    return new ol.style.Style({
                        image: new ol.style.Circle({
                            radius: 7,
                            fill: new ol.style.Fill({
                                color: '#ff0000'
                            }),
                            stroke: new ol.style.Stroke({
                                color: '#fff',
                                width: 2
                            })
                        })
                    });
                }

                return new ol.style.Style({
                    stroke: new ol.style.Stroke({
                        color: '#00aa00',
                        width: 2
                    }),
                    fill: new ol.style.Fill({
                        color: 'rgba(0,170,0,0.1)'
                    })
                });
            }
        });

        map.addLayer(plantationLayer);
        function addPlantationsToMap(data) {

            plantationSource.clear();

            data.forEach(function (item) {

                const plantation = item.plantation;
                const section3 = item.section_3;

                if (!section3)
                    return;

                // CASE 1 : GEOJSON AVAILABLE
                if (
                    section3.geojson &&
                    section3.geojson.features &&
                    section3.geojson.features.length > 0
                ) {

                    const features = new ol.format.GeoJSON().readFeatures(
                        section3.geojson,
                        {
                            featureProjection: 'EPSG:3857'
                        });

                    features.forEach(function (f) {

                        f.set("plantation_name",
                            plantation.plantation_name);

                        f.set("plantation_code",
                            plantation.plantation_code);
                    });

                    plantationSource.addFeatures(features);
                }

                // CASE 2 : ONLY LAT/LONG AVAILABLE
                else if (
                    section3.latitude &&
                    section3.longitude
                ) {

                    const feature = new ol.Feature({

                        geometry: new ol.geom.Point(
                            ol.proj.fromLonLat([
                                parseFloat(section3.longitude),
                                parseFloat(section3.latitude)
                            ])
                        ),

                        plantation_name: plantation.plantation_name,
                        plantation_code: plantation.plantation_code
                    });

                    plantationSource.addFeature(feature);
                }
            });

            if (plantationSource.getFeatures().length > 0) {

                map.getView().fit(
                    plantationSource.getExtent(),
                    {
                        padding: [50, 50, 50, 50],
                        duration: 1000,
                        maxZoom: 16
                    });
            }
        }
    </script>
  


    <script>
        document.getElementById('<%= ddlzone.ClientID %>')
            .addEventListener("change", applyFilter);

        document.getElementById('<%= ddlcircle.ClientID %>')
    .addEventListener("change", applyFilter);

document.getElementById('<%= ddldivision.ClientID %>')
    .addEventListener("change", applyFilter);

        document.getElementById('<%= ddlrange.ClientID %>')
            .addEventListener("change", applyFilter);

        var filteredData = null;
         
        function applyFilter() {

           // showLoader();.

            if (!data || !Array.isArray(data)) {
                console.log("Plantation data not loaded yet.");
                return;
            }

            let zone = document.getElementById('<%= ddlzone.ClientID %>').value;
            let circle = document.getElementById('<%= ddlcircle.ClientID %>').value;
    let division = document.getElementById('<%= ddldivision.ClientID %>').value;
            let range = document.getElementById('<%= ddlrange.ClientID %>').value;

             filteredData = data.filter(function (x) {

                const p = x.plantation || {};

                return (

                    (zone === "All" ||
                        (p.chief_office_name_english || "")
                            .trim()
                            .toUpperCase() === zone.trim().toUpperCase())

                    &&

                    (circle === "All" ||
                        (p.conservator_office_name_english || "")
                            .trim()
                            .toUpperCase() === circle.trim().toUpperCase())

                    &&

                    (division === "All" ||
                        (p.division_name_english || "")
                            .trim()
                            .toUpperCase() === division.trim().toUpperCase())

                    &&

                    (range === "All" ||
                        (p.range_name_english || "")
                            .trim()
                            .toUpperCase() === range.trim().toUpperCase())

                );
            });

            var url = buildWFSUrl(zone, circle, division, range);
            console.log("Filtered Records :", filteredData.length);

            addPlantationsToMap(filteredData);
            bindPlantationTypeChart(filteredData);
            bindPlantationBarChart(filteredData);
            bindYearWisePlantationChart(filteredData);
            bindPlantationDropdown(filteredData);
            bindYearDropdown(filteredData);
            bindTargetVsAchievedChart(filteredData);
           // hideLoader();
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

        function showLoader() {
            document.getElementById("loaderOverlay").style.display = "flex";
        }

        function hideLoader() {
            document.getElementById("loaderOverlay").style.display = "none";
        }

        function bindPlantationDropdown(data) {

            const ddl =
                document.getElementById('<%= ddlplantation.ClientID %>');

            ddl.innerHTML = '';

            ddl.options.add(
                new Option('All Plantations', 'All')
            );

            const plantations = [...new Set(
                data
                    .map(x => x.plantation?.plantation_name)
                    .filter(Boolean)
            )];

            plantations.sort();

            plantations.forEach(function (item) {

                ddl.options.add(
                    new Option(item, item)
                );

            });
        }

        function bindYearDropdown(data) {

            const ddl =
                document.getElementById('<%= ddlyear.ClientID %>');

            ddl.innerHTML = '';

            ddl.options.add(
                new Option('All Years', 'All')
            );

            const years = [...new Set(
                data
                    .map(x => x.plantation?.plantation_year)
                    .filter(Boolean)
            )];

            years.sort().reverse();

            years.forEach(function (item) {

                ddl.options.add(
                    new Option(item, item)
                );

            });
        }


        function bindPlantationTypeChart(filteredData) {
            if (!filteredData || filteredData.length === 0) {

                showNoData("plantationTypeChart");
                return;
            }
            const grouped = {};

            filteredData.forEach(function (item) {

                const plantation = item.plantation || {};

                const type = plantation.plantation_type || "Unknown";

                const plants = parseFloat(
                    plantation.no_of_plants_per_hectare || 0
                );

                grouped[type] = (grouped[type] || 0) + plants;
            });

            const labels = Object.keys(grouped);
            const values = Object.values(grouped);

            const ctx = document
                .getElementById("plantationTypeChart")
                .getContext("2d");

            if (window.plantationTypeChartObj) {
                window.plantationTypeChartObj.destroy();
            }

            window.plantationTypeChartObj = new Chart(ctx, {

                type: "doughnut",

                data: {

                    labels: labels,

                    datasets: [{
                        data: values,
                        borderWidth: 1
                    }]
                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    plugins: {

                        legend: {
                            position: "bottom"
                        },

                        title: {
                            display: true,
                            text: "Plantation Type vs Plants Per Hectare"
                        },

                        tooltip: {
                            callbacks: {
                                label: function (context) {

                                    return (
                                        context.label +
                                        " : " +
                                        context.raw
                                    );
                                }
                            }
                        }
                    }
                }
            });
        }


        function bindPlantationBarChart(filteredData) {
            if (!filteredData || filteredData.length === 0) {

                showNoData("plantationBarChart");
                return;
            }
            const labels = [];
            const plants = [];
            const areaTotal = [];
            const areaActual = [];

            filteredData.forEach(function (item) {

                const p = item.plantation || {};

                labels.push(
                    p.plantation_name || "NA"
                );

                plants.push(
                    parseFloat(p.no_of_plants_per_hectare || 0)
                );

                areaTotal.push(
                    parseFloat(p.area_total || 0)
                );

                areaActual.push(
                    parseFloat(p.area_actual || 0)
                );
            });

            const ctx = document
                .getElementById("plantationBarChart")
                .getContext("2d");

            if (window.plantationBarChartObj) {
                window.plantationBarChartObj.destroy();
            }

            window.plantationBarChartObj = new Chart(ctx, {

                type: "bar",

                data: {

                    labels: labels,

                    datasets: [

                        {
                            label: "Plants / Hectare",
                            data: plants,
                            backgroundColor: "#198754"
                        },

                        {
                            label: "Area Total",
                            data: areaTotal,
                            backgroundColor: "#0d6efd"
                        },

                        {
                            label: "Area Actual",
                            data: areaActual,
                            backgroundColor: "#fd7e14"
                        }
                    ]
                },

                options: {

                    responsive: true,
                    maintainAspectRatio: false,

                    plugins: {

                        legend: {
                            position: "bottom"
                        },

                        title: {
                            display: true,
                            text: "Plantation Wise Comparison"
                        }
                    },

                    scales: {

                        x: {

                            ticks: {
                                autoSkip: false,
                                maxRotation: 90,
                                minRotation: 45
                            }
                        },

                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }

        function bindYearWisePlantationChart(filteredData) {
            if (!filteredData || filteredData.length === 0) {

                showNoData("yearWiseChart");
                return;
            }
            const yearWiseCount = {};

            filteredData.forEach(function (item) {

                const year = item?.plantation?.plantation_year;

                if (!year) return;

                yearWiseCount[year] = (yearWiseCount[year] || 0) + 1;
            });

            const labels = Object.keys(yearWiseCount).sort();
            const data = labels.map(year => yearWiseCount[year]);

            const canvas = document.getElementById("yearWiseChart");

            // Destroy old chart if exists
            if (window.yearWiseChartInstance) {
                window.yearWiseChartInstance.destroy();
            }

            window.yearWiseChartInstance = new Chart(canvas, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'No. of Plantations',
                        data: data,
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: "bottom"
                        },
                        title: {
                            display: true,
                            text: 'Year Wise Plantation Count'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                precision: 0
                            }
                        }
                    }
                }
            });
        }

    </script>
    <script>
        var ndviLayer = null;


        function getalert() {
            showLoader();
            const selecteddate =
                document.getElementById("date").value;

            if (!selecteddate) {
                alert("Please select date");
                return;
            }

            if (ndviLayer) {

                map.removeLayer(ndviLayer);
                ndviLayer = null;
            }

            ndviLayer = createSentinelLayer(selecteddate);
            document.getElementById("chkforndvi").checked = true;
            document.getElementById("ndvilengend").style.display = "block";
            map.addLayer(ndviLayer);

            console.log("NDVI Layer Added");
            hideLoader();
        }
        function callsentinel(checkbox) {
            if (checkbox.checked) {
                if (ndviLayer != null) {
                    document.getElementById("ndvilengend").style.display = "block";
                    map.addLayer(ndviLayer);
                }
            } else {
                document.getElementById("ndvilengend").style.display = "none";
                map.removeLayer(ndviLayer);
            }
        }

        function createSentinelLayer(date) {

            const falseColorSource = new ol.source.TileWMS({

                url: "https://services.sentinel-hub.com/ogc/wms/a9383ac8-3abd-45a5-a7c4-8173aaef4342",

                params: {
                    "LAYERS": "2_FALSE_COLOR",
                    "TIME": date,
                    "FORMAT": "image/png",
                    "TRANSPARENT": true,
                    "MAXCC": 50
                },

                crossOrigin: "anonymous"
            });

            const rasterSource = new ol.source.Raster({

                sources: [falseColorSource],

                threads: 0,

                operation: function (pixels) {

                    const pixel = pixels[0];

                    if (!pixel)
                        return [0, 0, 0, 0];

                    const nir = pixel[0] / 255;
                    const red = pixel[1] / 255;

                    const ndvi =
                        (nir - red) /
                        ((nir + red) || 1);

                    if (ndvi >= 0.60)
                        return [20, 90, 33, 255];

                    if (ndvi >= 0.40)
                        return [50, 255, 90, 255];

                    if (ndvi >= 0.20)
                        return [221, 137, 50, 255];

                    return [255, 0, 0, 255];
                }
            });

            const layer = new ol.layer.Image({

                source: rasterSource,
                opacity: 0.8
            });

            layer.on("precompose", function (evt) {

                const ctx = evt.context;

                if (!ctx)
                    return;

                ctx.save();

                ctx.beginPath();

                plantationSource.getFeatures()
                    .forEach(function (feature) {

                        const geometry =
                            feature.getGeometry();

                        drawGeometry(
                            geometry,
                            ctx
                        );
                    });

                ctx.clip();
            });

            layer.on("postcompose", function (evt) {

                if (evt.context) {
                    evt.context.restore();
                }
            });

            return layer;
        }


        function drawGeometry(
            geometry,
            ctx
        ) {

            if (!geometry)
                return;

            const type =
                geometry.getType();

            if (
                type === "Point" ||
                type === "MultiPoint"
            ) {
                return;
            }

            if (type === "Polygon") {

                const rings =
                    geometry.getCoordinates();

                rings.forEach(function (ring) {

                    ring.forEach(function (
                        coord,
                        index
                    ) {

                        const pixel =
                            map.getPixelFromCoordinate(
                                coord
                            );

                        if (index === 0) {

                            ctx.moveTo(
                                pixel[0],
                                pixel[1]
                            );

                        } else {

                            ctx.lineTo(
                                pixel[0],
                                pixel[1]
                            );
                        }
                    });
                });
            }

            else if (
                type === "MultiPolygon"
            ) {

                geometry.getCoordinates()
                    .forEach(function (
                        polygon
                    ) {

                        polygon.forEach(function (
                            ring
                        ) {

                            ring.forEach(function (
                                coord,
                                index
                            ) {

                                const pixel =
                                    map.getPixelFromCoordinate(
                                        coord
                                    );

                                if (index === 0) {

                                    ctx.moveTo(
                                        pixel[0],
                                        pixel[1]
                                    );

                                } else {

                                    ctx.lineTo(
                                        pixel[0],
                                        pixel[1]
                                    );
                                }
                            });
                        });
                    });
            }

            else if (
                type === "GeometryCollection"
            ) {

                geometry.getGeometries()
                    .forEach(function (
                        g
                    ) {

                        drawGeometry(
                            g,
                            ctx
                        );
                    });
            }
        }

        let uploadedLayer = null;
        document.getElementById('removeLayerBtn').addEventListener('click', function () {

            if (uploadedLayer) {
                map.removeLayer(uploadedLayer);
                uploadedLayer = null;
            }

            // Optional: clear file input
            document.getElementById('fileInput').value = '';

        });

        document.getElementById('fileInput').addEventListener('change', function (event) {

            const file = event.target.files[0];

            if (!file) {
                alert('Please select a file.');
                return;
            }

            const extension = file.name.split('.').pop().toLowerCase();

            // Remove previous uploaded layer
            if (uploadedLayer) {
                map.removeLayer(uploadedLayer);
            }

            function displayFeatures(features) {

                const vectorSource = new ol.source.Vector({
                    features: features
                });

                uploadedLayer = new ol.layer.Vector({
                    source: vectorSource,
                    style: new ol.style.Style({
                        stroke: new ol.style.Stroke({
                            color: '#ff0000',
                            width: 2
                        }),
                        fill: new ol.style.Fill({
                            color: 'rgba(255,0,0,0.1)'
                        })
                    })
                });

                map.addLayer(uploadedLayer);

                // Zoom to uploaded data
                map.getView().fit(vectorSource.getExtent(), {
                    padding: [20, 20, 20, 20],
                    maxZoom: 18
                });
            }

            // ZIP Shapefile
            if (extension === "zip") {

                const reader = new FileReader();

                reader.onload = function (e) {

                    shp(e.target.result)
                        .then(function (geojson) {

                            const features = new ol.format.GeoJSON().readFeatures(
                                geojson,
                                {
                                    featureProjection: 'EPSG:3857'
                                }
                            );

                            displayFeatures(features);
                        })
                        .catch(function (err) {
                            alert('Error reading shapefile: ' + err);
                        });
                };

                reader.readAsArrayBuffer(file);
            }

            // KML
            else if (extension === "kml") {

                const reader = new FileReader();

                reader.onload = function (e) {

                    const features = new ol.format.KML().readFeatures(
                        e.target.result,
                        {
                            featureProjection: 'EPSG:3857'
                        }
                    );

                    displayFeatures(features);
                };

                reader.readAsText(file);
            }

            else {
                alert('Please upload a .zip shapefile or a .kml file.');
            }
        });

        async function openPopup() {

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
                        title: 'Plantation Map',
                        element: document.getElementById('map')
                    },
                    {
                        title: 'Target Plantation Vs Achieve Plantation',
                        element: document.getElementById('parentoftargetAchievedChart')
                    },

                    {
                        title: 'Plantation Type Analysis',
                        element: document.getElementById('parentofplantationTypeChart')
                    },

                    {
                        title: 'Plantation Wise Analysis',
                        element: document.getElementById('parentofplantationBarChart')
                    },

                    {
                        title: 'Year Wise Analysis',
                        element: document.getElementById('parentofyearWiseChart')
                    }
                ];

                let firstPage = true;

                for (let i = 0; i < sections.length; i++) {

                    const item = sections[i];

                    await new Promise(resolve =>
                        requestAnimationFrame(resolve)
                    );

                    const canvas = await html2canvas(
                        item.element,
                        {
                            scale: 2,
                            useCORS: true,
                            backgroundColor: '#ffffff',
                            logging: false,
                            imageTimeout: 0
                        }
                    );

                    const imgData = canvas.toDataURL(
                        'image/jpeg',
                        0.85
                    );

                    if (!firstPage) {
                        pdf.addPage();
                    }

                    firstPage = false;

                    // ======================
                    // HEADER
                    // ======================

                    pdf.setFillColor(27, 67, 50);

                    pdf.rect(
                        0,
                        0,
                        297,
                        18,
                        'F'
                    );

                    pdf.setTextColor(
                        255,
                        255,
                        255
                    );

                    pdf.setFont(
                        "helvetica",
                        "bold"
                    );

                    pdf.setFontSize(18);

                    pdf.text(
                        "UTTARAKHAND FOREST DEPARTMENT",
                        10,
                        12
                    );

                    pdf.setFontSize(12);

                    pdf.text(
                        "Plantation Dashboard Report",
                        205,
                        12
                    );

                    // ======================
                    // SECTION TITLE
                    // ======================

                    pdf.setTextColor(
                        33,
                        33,
                        33
                    );

                    pdf.setFontSize(16);

                    pdf.text(
                        item.title,
                        10,
                        30
                    );

                    pdf.setDrawColor(
                        27,
                        67,
                        50
                    );

                    pdf.setLineWidth(0.5);

                    pdf.line(
                        10,
                        34,
                        285,
                        34
                    );

                    // ======================
                    // CARD BACKGROUND
                    // ======================

                    pdf.setFillColor(
                        248,
                        249,
                        250
                    );

                    pdf.roundedRect(
                        8,
                        40,
                        281,
                        155,
                        3,
                        3,
                        'F'
                    );

                    // ======================
                    // IMAGE
                    // ======================

                    const imgProps =
                        pdf.getImageProperties(
                            imgData
                        );

                    const maxWidth = 273;

                    const maxHeight = 145;

                    let imgWidth =
                        maxWidth;

                    let imgHeight =
                        (
                            imgProps.height *
                            imgWidth
                        ) /
                        imgProps.width;

                    if (
                        imgHeight >
                        maxHeight
                    ) {

                        imgHeight =
                            maxHeight;

                        imgWidth =
                            (
                                imgProps.width *
                                imgHeight
                            ) /
                            imgProps.height;
                    }

                    const x =
                        (297 - imgWidth) / 2;

                    const y =
                        45 +
                        (
                            maxHeight -
                            imgHeight
                        ) / 2;

                    pdf.addImage(
                        imgData,
                        'JPEG',
                        x,
                        y,
                        imgWidth,
                        imgHeight,
                        '',
                        'FAST'
                    );

                    // ======================
                    // FOOTER
                    // ======================

                    pdf.setFontSize(9);

                    pdf.setTextColor(100);

                    pdf.text(
                        'Generated On : ' +
                        new Date()
                            .toLocaleString(),
                        10,
                        205
                    );

                    pdf.text(
                        'Page ' +
                        (i + 1) +
                        ' of ' +
                        sections.length,
                        260,
                        205
                    );
                }

                pdf.save(
                    'Plantation_Dashboard_Report.pdf'
                );
            }
            catch (ex) {

                console.error(ex);

                alert(
                    'Error generating PDF'
                );
            }
            finally {

                hideLoader();
            }
        }

        function showNoData(canvasId) {

            const canvas =
                document.getElementById(canvasId);

            const ctx =
                canvas.getContext("2d");

            ctx.clearRect(
                0,
                0,
                canvas.width,
                canvas.height
            );

            ctx.font = "bold 24px Arial";
            ctx.fillStyle = "#999";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";

            ctx.fillText(
                "Data Not Found",
                canvas.width / 2,
                canvas.height / 2
            );
        }

        function bindTargetVsAchievedChart(filteredData){

            let totalTarget = 0;
            let totalAchieved = 0;

            filteredData.forEach(function (item) {

                const p = item.plantation || {};

                totalTarget += parseFloat(
                    p.area_total || 0
                );

                totalAchieved += parseFloat(
                    p.area_actual || 0
                );
            });

            const remaining =
                Math.max(
                    totalTarget - totalAchieved,
                    0
                );

            const achievementPercent =
                totalTarget > 0
                    ? (
                        (totalAchieved / totalTarget) * 100
                    ).toFixed(2)
                    : 0;

            const canvas =
                document.getElementById(
                    "targetAchievedChart"
                );

            const ctx =
                canvas.getContext("2d");

            if (window.targetAchievedChartObj) {
                window.targetAchievedChartObj.destroy();
            }

            if (
                !filteredData ||
                filteredData.length === 0
            ) {

                ctx.clearRect(
                    0,
                    0,
                    canvas.width,
                    canvas.height
                );

                ctx.font = "bold 24px Arial";
                ctx.fillStyle = "#999";
                ctx.textAlign = "center";

                ctx.fillText(
                    "Data Not Found",
                    canvas.width / 2,
                    canvas.height / 2
                );

                return;
            }

            window.targetAchievedChartObj =
                new Chart(ctx, {

                    type: "doughnut",

                    data: {

                        labels: [
                            "Achieved Plantation",
                            "Remaining Plantation"
                        ],

                        datasets: [{
                            data: [
                                totalAchieved,
                                remaining
                            ],
                            backgroundColor: [
                                "#198754",
                                "#dc3545"
                            ],
                            borderWidth: 2
                        }]
                    },

                    options: {

                        responsive: true,

                        maintainAspectRatio: false,

                        cutout: "70%",

                        plugins: {

                            legend: {
                                position: "bottom"
                            },

                            title: {
                                display: true,
                                text: "Target vs Achieved Plantation Area"
                            },

                            tooltip: {
                                callbacks: {
                                    label: function (context) {

                                        return (
                                            context.label +
                                            " : " +
                                            context.raw.toFixed(2) +
                                            " Ha"
                                        );
                                    }
                                }
                            }
                        }
                    },

                    plugins: [{

                        id: "centerText",

                        afterDraw(chart) {

                            const ctx =
                                chart.ctx;

                            const width =
                                chart.width;

                            const height =
                                chart.height;

                            ctx.save();

                            ctx.textAlign =
                                "center";

                            ctx.textBaseline =
                                "middle";

                            ctx.font =
                                "bold 24px Arial";

                            ctx.fillStyle =
                                "#198754";

                            ctx.fillText(
                                achievementPercent + "%",
                                width / 2,
                                height / 2 - 10
                            );

                            ctx.font =
                                "14px Arial";

                            ctx.fillStyle =
                                "#666";

                            ctx.fillText(
                                "Achieved",
                                width / 2,
                                height / 2 + 15
                            );

                            ctx.restore();
                        }
                    }]
                });
        }

    </script>
     

     <%-- <script src="plantationjs/plantationdashboardjs.js"></script>--%>
</asp:Content>
