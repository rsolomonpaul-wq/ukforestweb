var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";
var sentinel2fcckey = "f78e28ba-2615-43b9-8532-9c68247a3c7b";
var sentinel2ncckey = "f78e28ba-2615-43b9-8532-9c68247a3c7b";

// ==================== MAP 1: Fire Monitoring Dashboard ====================
const map = new ol.Map({
    target: 'map',  // Make sure you have a <div id="map"></div> in your HTML
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

// ==================== Variables ====================
let currentFilteredLayer = null;

// ==================== Build WFS URL ====================
function buildWFSUrl(zone , circle,division, range, fire_status, land_cover, protected_area) {
    const baseUrl = "https://ukforestgis.in/geoserver/uk_sfd/ows";
    const params = new URLSearchParams({
        service: "WFS",
        version: "1.0.0",
        request: "GetFeature",
        typeName: "uk_sfd:vw_patrolling_with_geom",
        outputFormat: "application/json",
        srsName: "EPSG:3857"
    });

    let filters = [];
    //if (zone && zone !== "All") filters.push(`zone='${zone}'`);
    //if (circle && circle !== "All") filters.push(`circle='${circle}'`);
    if (division && division !== "All") filters.push(`division='${division}'`);
    if (range && range !== "All") filters.push(`range_name='${range}'`);
    if (fire_status && fire_status !== "All") filters.push(`fire_status='${fire_status}'`);
    if (land_cover && land_cover !== "All") filters.push(`land_cover='${land_cover}'`);
    if (protected_area && protected_area !== "All") filters.push(`protected_area='${protected_area}'`);

    if (filters.length > 0) {
        params.set("CQL_FILTER", filters.join(" AND "));
    }
    console.log(filters[filters.length - 1]);
    //showBoundary(filters[filters.length - 1]);
    return `${baseUrl}?${params.toString()}`;
}
var boundaryLayer = null;
function showBoundary(str) {

    // Example input: "range = 'Maniknath'"

    let parts = str.split('=');

    let column = parts[0].trim();          // range
    let value = parts[1].trim();

    // remove quotes if present
    value = value.replace(/^'|'$/g, "").trim();

    // rename column if needed
    let col = column === "range" ? "range" : column;

    let filter = col + "='" + value + "'";
    console.log("filter:", filter);
    var boundaryURL =
        "https://ukforestgis.in/geoserver/uk_sfd/ows?" +
        "service=WFS&version=1.0.0&request=GetFeature" +
        "&typeName=uk_sfd:tbl_" + column + "_master" +
        "&outputFormat=application/json" +
        "&CQL_FILTER=" + encodeURIComponent(filter);

    console.log("Boundary URL:", boundaryURL);

    if (boundaryLayer) {
        map1.removeLayer(boundaryLayer);
    }

    var vectorSource = new ol.source.Vector();

    boundaryLayer = new ol.layer.Vector({
        source: vectorSource,
        style: new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: "#000000",
                width: 2
            }),
            fill: new ol.style.Fill({
                color: "rgba(0,0,0,0.05)"
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
}
applyfilter();
// ==================== Apply Filter Function ====================
function applyfilter() {
    const zone = document.getElementById("ContentPlaceHolder1_ddlzone").value;
    const circle = document.getElementById("ContentPlaceHolder1_ddlcircle").value;
   

    const division = document.getElementById("ContentPlaceHolder1_division").value;
    const range = document.getElementById("ContentPlaceHolder1_range").value;

    const fire_status_control = document.getElementsByName("ContentPlaceHolder1_rdofirestatus");
    const land_cover_control = document.getElementsByName("ContentPlaceHolder1_rdoforesttype");
    const protected_area_control = document.getElementsByName("ContentPlaceHolder1_chkprotectedarea");

   

    let fire_status = "All";
    let land_cover = "All";
    let protected_area = "All";

    for (let i = 0; i < fire_status_control.length; i++) {
        if (fire_status_control[i].checked) {
            fire_status = fire_status_control[i].value;
            break;
        }
    }

    for (let i = 0; i < land_cover_control.length; i++) {
        if (land_cover_control[i].checked) {
            land_cover = land_cover_control[i].value;
            break;
        }
    }

    for (let i = 0; i < protected_area_control.length; i++) {
        if (protected_area_control[i].checked) {
            protected_area = protected_area_control[i].value;
            break;
        }
    }



    const url = buildWFSUrl(zone,circle,division, range, fire_status, land_cover, protected_area);
    console.log("Requesting WFS URL:", url);

    if (!currentFilteredLayer) {
        const vectorSource = new ol.source.Vector();

        currentFilteredLayer = new ol.layer.Vector({
            source: vectorSource,
            style: function (feature) {
                const geometryType = feature.getGeometry().getType();

                if (geometryType === 'Point' || geometryType === 'MultiPoint') {
                    return new ol.style.Style({
                        image: new ol.style.Icon({
                            anchor: [0.5, 1],
                            src: 'https://cdn-icons-png.flaticon.com/512/684/684908.png',
                            scale: 0.05
                        })
                    });
                } else if (geometryType === 'Polygon' || geometryType === 'MultiPolygon') {
                    return new ol.style.Style({
                        stroke: new ol.style.Stroke({
                            color: 'rgba(0, 128, 0, 0.8)',
                            width: 2
                        }),
                        fill: new ol.style.Fill({
                            color: 'rgba(0, 128, 0, 0.3)'
                        })
                    });
                } else if (geometryType === 'LineString' || geometryType === 'MultiLineString') {
                    return new ol.style.Style({
                        stroke: new ol.style.Stroke({
                            color: 'blue',
                            width: 2
                        })
                    });
                }

                // fallback style
                return new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: '#000', width: 1 }),
                    fill: new ol.style.Fill({ color: '#ccc' })
                });
            }
        });

        map.addLayer(currentFilteredLayer);
    }

    const vectorSource = currentFilteredLayer.getSource();
    vectorSource.clear();

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("WFS fetch failed: " + response.statusText);
            return response.json();
        })
        .then(data => {
            console.log("WFS Data Received:", data);

            if (!data.features || data.features.length === 0) {
                alert("No features found for selected filters.");
                return;
            }

            const features = new ol.format.GeoJSON().readFeatures(data, {
                featureProjection: map.getView().getProjection()
            });

            vectorSource.addFeatures(features);

            if (features.length > 0) {
                const extent = vectorSource.getExtent();
                map.getView().fit(extent, { duration: 1000, padding: [20, 20, 20, 20] });
            }
        })
        .catch(error => {
            console.error("Error loading WFS features:", error);
            alert("Failed to load features. Check console for details.");
        });
}
const container = document.getElementById('popup');
const content = document.getElementById('popup-content');
const closer = document.getElementById('popup-closer');

const overlay = new ol.Overlay({
    element: container,
    autoPan: true,
    autoPanAnimation: { duration: 250 }
});
map.addOverlay(overlay);

closer.onclick = function () {
    overlay.setPosition(undefined);
    closer.blur();
    return false;
};
map.on('singleclick', function (evt) {
    overlay.setPosition(undefined); // Close previous popup

    map.forEachFeatureAtPixel(evt.pixel, function (feature) {
        const properties = feature.getProperties();
        delete properties.geometry; // Remove geometry from popup

        let html = "<table style='border-collapse: collapse;'>";

        for (let key in properties) {
            html += `
                <tr>
                    <td style='border:1px solid #ccc;padding:4px;font-weight:bold;'>${key}</td>
                    <td style='border:1px solid #ccc;padding:4px;'>${properties[key]}</td>
                </tr>
            `;
        }

        html += "</table>";

        content.innerHTML = html;
        overlay.setPosition(evt.coordinate); // show popup at clicked location
        return true; // stop after first feature
    });
});

var chartplantationandnurseryinst;
function showNoDataImage(canvasId) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) return;

    const container = canvas.parentElement;
    if (!container) return;

    // Set a consistent height to match typical chart size
    container.style.minHeight = '300px'; // Adjust this value if needed to match your chart's typical height
    container.style.position = 'relative';

    // Hide the canvas
    canvas.style.display = 'none';

    // Remove any existing no-data image
    const existingImg = container.querySelector('.no-data-image');
    if (existingImg) {
        existingImg.remove();
    }

    // Create and append image
    const img = document.createElement('img');
    img.src = '../images/notfound.jpg'; // Replace with your actual image path in the image folder
    img.alt = 'No Data Available';
    img.className = 'no-data-image';
    img.style.position = 'absolute';
    img.style.top = '0';
    img.style.left = '0';
    img.style.width = '100%';
    img.style.height = '100%';
    img.style.objectFit = 'contain';
    img.style.display = 'block';
    container.appendChild(img);
}


function callpattypechart(strPatrollingTypes, strPatrollingCounts) {
    //alert(strPatrollingTypes);
   // alert(strPatrollingCounts);
    if (chartplantationandnurseryinst) {
        chartplantationandnurseryinst.destroy();
    }
    if (!strPatrollingTypes || !strPatrollingTypes || strPatrollingTypes.trim() === '' || strPatrollingCounts.trim() === '' || strPatrollingCounts.trim() === ',,,,') {
        showNoDataImage('patrollingtypechart');
        return;
    }

    const labels = strPatrollingTypes.split(',');
    const counts = strPatrollingCounts.split(',').map(Number);

    // Generate consistent random color for each label
    function getRandomColor(alpha = 0.7) {
        const r = Math.floor(Math.random() * 256);
        const g = Math.floor(Math.random() * 256);
        const b = Math.floor(Math.random() * 256);
        return `rgba(${r}, ${g}, ${b}, ${alpha})`;
    }

    const backgroundColors = labels.map(() => getRandomColor());

    const ctx = document.getElementById('patrollingtypechart').getContext('2d');

    const config = {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Patrolling Count',
                data: counts,
                backgroundColor: backgroundColors
            }]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: 'Patrolling Overview by Type',
                    font: { size: 20 }
                },
                legend: { display: false }
            }, layout: {
                padding: {
                    top: 20   // adjust this value as needed
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Count'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: 'Patrolling Type'
                    }
                }
            }
        }
    };

    chartplantationandnurseryinst = new Chart(ctx, config);
}




// The function you will call with string arrays
let chartInstance = null;

function callregionchart(regionNames, totalDistances) {
    // Parse strings into arrays
    const labels = totalDistances.split(',').map(s => s.trim());
    const totalDistance = regionNames.split(',').map(s => (s.trim()));

    console.log("Labels:", labels);
    console.log("Total Distance:", totalDistance);

    const ctx = document.getElementById("patrolChartregion").getContext("2d");

    if (chartInstance) {
        chartInstance.destroy();
    }
    if (!regionNames || !regionNames || regionNames.trim() === '' || totalDistances.trim() === '' || totalDistances.trim() === ',,,,') {
        showNoDataImage('patrolChartregion');
        return;
    }
    function getRandomColor(alpha = 0.7) {
        const r = Math.floor(Math.random() * 256);
        const g = Math.floor(Math.random() * 256);
        const b = Math.floor(Math.random() * 256);
        return `rgba(${r}, ${g}, ${b}, ${alpha})`;
    }

    const backgroundColors = labels.map(() => getRandomColor());

    chartInstance = new Chart(ctx, {
        type: "bar",
        data: {
            labels,
            datasets: [
                {
                    label: "Patrolling Effect (km)",
                    data: totalDistance,
                    type: "bar",
                    yAxisID: "y1",
                    borderColor: backgroundColors,
                    backgroundColor: backgroundColors,
                    borderWidth: 2,
                    pointRadius: 5,
                    tension: 0.3
                }
            ]

        },
        options: {
            responsive: true,
            interaction: { mode: "index", intersect: false },
            scales: {
                x: {
                    title: { display: true, text: "Regions" }
                },
                y: {
                    title: { display: true, text: "Distance / Area (km, sq.km)" },
                    beginAtZero: true
                },
                y1: {
                    position: "right",
                    title: { display: true, text: "PE (km/sq.km)" },
                    grid: { drawOnChartArea: false },
                    beginAtZero: true
                }
            },
            plugins: {
                legend: { position: "bottom" },
                tooltip: { mode: "index", intersect: false },
                title: {
                    display: true,
                    text: "Region-Wise Patrolling Effects",
                    position: "top",
                    font: { size: 18, weight: "bold" },
                    padding: { top: 20, bottom: 20 }
                }
            }
        }
    });
}
