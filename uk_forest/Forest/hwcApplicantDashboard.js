
var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";
var geoserver_ip_ows = "https://ukforestgis.in/geoserver/sbl/ows";

var format = 'image/png';
var lastselectedlayer = [];
var lastselectedlayername = [];
var lastselectedlayer_vector = [];
var gcount = 0;
var lcount = 0;
var zcount = 0;
var layerobject = [];
var type;
var baselayer = 0;


var map = new ol.Map({
    target: 'map',
    layers: [
        new ol.layer.Tile({
            source: new ol.source.OSM()
        })
    ],
    view: new ol.View({
        center: ol.proj.fromLonLat([79.2593, 29.9068]),
        zoom: 8,
        minZoom: 7,
        maxZoom: 18
    })
});

//let totals = document.getElementById("totalcase").value;
//let actives = document.getElementById("activecase").value;
//let pendings = document.getElementById("pendingcase").value;
//let inproces = document.getElementById("inprocesscase").value;
//let solveds = document.getElementById("solvedcase").value;
//function animateCount(id, target, duration = 1500) {
//    const el = document.getElementById(id);
//    let start = 0;
//    let startTime = null;

//    function step(timestamp) {
//        if (!startTime) startTime = timestamp;
//        const progress = timestamp - startTime;
//        const progressRatio = Math.min(progress / duration, 1);
//        el.textContent = Math.floor(progressRatio * target);
//        if (progress < duration) {
//            requestAnimationFrame(step);
//        } else {
//            el.textContent = target;
//        }
//    }
//    requestAnimationFrame(step);
//}

//const data = {
//    total: totals,
//    active: actives,
//    pending: pendings,
//    inprocess: inproces,
//    solved: solveds
//};

//animateCount('totalCases', data.total);
//animateCount('activeCases', data.active);
//animateCount('pendingCases', data.pending);
//animateCount('inprocessCases', data.inprocess);
//animateCount('solvedCases', data.solved);

function animateCases(total, active, pending, inprocess, solved) {
    function animateCount(id, target, duration = 1500) {
        const el = document.getElementById(id);
        if (!el) return;
        let start = 0;
        let startTime = null;

        function step(timestamp) {
            if (!startTime) startTime = timestamp;
            const progress = timestamp - startTime;
            const progressRatio = Math.min(progress / duration, 1);
            el.textContent = Math.floor(progressRatio * target);
            if (progress < duration) {
                requestAnimationFrame(step);
            } else {
                el.textContent = target;
            }
        }
        requestAnimationFrame(step);
    }

    animateCount('totalCases', total);
    animateCount('activeCases', active);
    animateCount('pendingCases', pending);
    animateCount('inprocessCases', inprocess);
    animateCount('solvedCases', solved);
}


let caseBarChart = null;

function chartanimal(animalnames, animaloccurance) {
    // Split strings by commas
    var lbl = animalnames.split(',');
    var values = animaloccurance.split(',').map(Number);  // convert strings to numbers

    const data = {
        labels: lbl,
        datasets: [{
            label: 'Cases by Animal',
            data: values,
            backgroundColor: 'rgba(75, 192, 192, 0.6)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 1
        }]
    };

    const config = {
        type: 'bar',
        data: data,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: true,
                    text: 'Animal-wise Human-Wildlife Conflict Cases'
                },
                legend: {
                    display: false
                },
                tooltip: {
                    enabled: true
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Animal Name'
                    },
                    ticks: {
                        autoSkip: false,
                        maxRotation: 90,
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Number of Cases'
                    }
                }
            }
        }
    };

    // Destroy previous chart if it exists
    if (caseBarChart) {
        caseBarChart.destroy();
    }

    // Create new chart and store the instance
    const ctx = document.getElementById('caseLineChartbar').getContext('2d');
    caseBarChart = new Chart(ctx, config);
}

function closeincidentreport() {
    document.getElementById("popup").style.display = "none";
}

// Global variable to hold chart instance
let caseRangeChart = null;

function chartrange(lblrange, valrange) {
    const lblrange1 = lblrange.split(',');
    const valrange1 = valrange.split(',').map(Number);

    const data = {
        labels: lblrange1,
        datasets: [{
            label: 'Cases by Animal',
            data: valrange1,
            backgroundColor: 'rgba(75, 192, 192, 0.6)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 1
        }]
    };

    const config = {
        type: 'bar',
        data: data,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: true,
                    text: 'Range-wise Human-Wildlife Conflict Cases'
                },
                legend: {
                    display: false
                },
                tooltip: {
                    enabled: true
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Range Name'
                    },
                    ticks: {
                        autoSkip: false,
                        maxRotation: 90,
                        minRotation: 45
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Number of Cases'
                    }
                }
            }
        }
    };

    // Destroy previous chart if it exists
    if (caseRangeChart) {
        caseRangeChart.destroy();
    }

    // Create and store new chart
    const ctx = document.getElementById('caseLineChart').getContext('2d');
    caseRangeChart = new Chart(ctx, config);
}

var layerfiltermap;
var vectorLayer;

function callmap() {
    /*alert("called ------");*/

    const conflictCategory = document.getElementById("ddlDataType").value;
    const dateFrom = new Date(document.getElementById("txtStartDate").value).toISOString().slice(0, 10);
    const dateTo = new Date(document.getElementById("txtEndDate").value).toISOString().slice(0, 10);
    const division = document.getElementById("ddlDivision").value;
    const range = document.getElementById("ddlRange").value;

    // Build CQL filter
    let filterParts = [];

    //filterParts.push(`incident_date BETWEEN '${dateFrom}' AND '${dateTo}'`);

    filterParts.push(`incident_date >= '${dateFrom}' AND incident_date <= '${dateTo}'`);


    if (division !== "0") {
        filterParts.push(`division_id = '${division}'`);
    }

    if (range !== "0") {
        filterParts.push(`range_officer_id = '${range}'`);
    }

    const cqlFilter = filterParts.join(" AND ");
    const cqlFilter1 = (division !== '0' ? ` division_id = '${division}'` : '') +
        (range !== '0' ? ` AND "id" = '${range}'` : '');

    map.removeLayer(layerfiltermap);
    if (cqlFilter1 == '') {
        layerfiltermap = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                ratio: 1,
                url: geoserver_ip,
                params: {
                    'FORMAT': format,
                    tiled: true,
                    STYLES: '',
                    layers: 'uk_sfd:tbl_range_master',
                    transition: 0
                }, serverType: 'geoserver',
                crossOrigin: 'anonymous'

            })
        });
    } else {
        layerfiltermap = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                ratio: 1,
                url: geoserver_ip,
                params: {
                    'FORMAT': format,
                    tiled: true,
                    STYLES: '',
                    layers: 'uk_sfd:tbl_range_master',
                    CQL_filter: cqlFilter1,
                    transition: 0
                }, serverType: 'geoserver',
                crossOrigin: 'anonymous'

            })
        });
    }

    map.addLayer(layerfiltermap);
    map.removeLayer(vectorLayer);



    const encodedFilter = encodeURIComponent(cqlFilter);

    const wfsUrl = `https://ukforestgis.in/geoserver/uk_sfd/ows?` +
        `service=WFS&version=1.0.0&request=GetFeature` +
        `&typeName=uk_sfd:view_tbl_victim_incident` +
        `&outputFormat=application/json` +
        `&CQL_FILTER=${encodedFilter}`;

    //alert("WFS URL:\n" + wfsUrl);


    // Fetch GeoJSON from WFS
    fetch(wfsUrl)
        .then(response => response.json())
        .then(geojson => {
            //console.log("GeoJSON response:", geojson);

            if (!geojson.features || geojson.features.length === 0) {
                //alert("No data returned from server.");
                return;
            }

            // Create vector source from features
            const vectorSource = new ol.source.Vector({
                features: new ol.format.GeoJSON().readFeatures(geojson, {
                    featureProjection: 'EPSG:3857' // Use 3857 for web maps
                })
            });

            // console.log("Loaded features count:", vectorSource.getFeatures().length);

            // Animation config
            const duration = 2000;
            const minRadius = 4;
            const maxRadius = 12;
            let start = Date.now();

            function styleFunction(feature) {
                const status = feature.get('status') || 'unknown';
                var legend = document.getElementById("maplegend");

                // DEBUG: Log each status
                // console.log("Feature status:", status);

                if (status.toLowerCase() === 'pending') {
                    legend.style.display = "block";
                    const elapsed = (Date.now() - start) % duration;
                    const progress = elapsed / duration;
                    const radius = minRadius + (maxRadius - minRadius) * Math.abs(Math.sin(progress * Math.PI * 2));
                    return new ol.style.Style({
                        image: new ol.style.Circle({
                            radius: radius,
                            fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.5)' }),
                            stroke: new ol.style.Stroke({ color: 'rgba(255, 0, 0, 1)', width: 2 })
                        })
                    });
                } else if (status.toLowerCase() === 'approved by dfo') {
                    legend.style.display = "block";
                    return new ol.style.Style({
                        image: new ol.style.Circle({
                            radius: 6,
                            fill: new ol.style.Fill({ color: 'green' }),
                            stroke: new ol.style.Stroke({ color: 'green', width: 1 })
                        })
                    });

                } else {
                    legend.style.display = "block";
                    return new ol.style.Style({
                        image: new ol.style.Circle({
                            radius: 6,
                            fill: new ol.style.Fill({ color: 'yellow' }),
                            stroke: new ol.style.Stroke({ color: '#yellow', width: 1 })
                        })
                    });
                }
            }

            vectorLayer = new ol.layer.Vector({
                source: vectorSource,
                style: styleFunction
            });

            map.addLayer(vectorLayer);

            // Animate pulsing symbols
            function animate() {
                vectorLayer.changed();
                requestAnimationFrame(animate);
            }
            animate();

            const tooltip = document.createElement('div');
            tooltip.className = 'ol-tooltip hidden';
            document.body.appendChild(tooltip);

            const overlay = new ol.Overlay({
                element: tooltip,
                offset: [10, 0],
                positioning: 'bottom-left'
            });
            map.addOverlay(overlay);


            map.on('pointermove', function (evt) {
                const pixel = map.getEventPixel(evt.originalEvent);
                const feature = map.forEachFeatureAtPixel(pixel, f => f);

                if (feature) {

                    const coordinate = evt.coordinate;
                    overlay.setPosition(coordinate);
                    tooltip.innerHTML =
                        `Status: ${feature.get('status') || 'No status'}<br>` +
                        `Incident ID: ${feature.get('incident_id') || 'N/A'}`;
                    tooltip.classList.remove('hidden');
                } else {
                    tooltip.classList.add('hidden');
                }
            });

            map.getViewport().addEventListener('mouseout', () => {
                tooltip.classList.add('hidden');
            });
        })
        .catch(error => {

            alert("Failed to load map data.");
        });
}
