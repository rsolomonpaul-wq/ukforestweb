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

// ==========================================
// 🗺️ MAP INITIALIZATION
// ==========================================
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

// ==========================================
// 📊 CHART INSTANCES
// ==========================================
let caseBarChart = null;
let caseRangeChart = null;
var layerfiltermap;
var vectorLayer;

// ==========================================
// 🔢 ANIMATE CASES FUNCTION
// ==========================================
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

// ==========================================
// 📊 ANIMAL CHART - COMPLETELY FIXED
// ==========================================
function chartanimal(animalnames, animaloccurance) {
    // ✅ CRITICAL FIX: Check if canvas exists before anything else
    var canvas = document.getElementById('caseLineChartbar');
    if (!canvas) {
        console.warn('caseLineChartbar canvas not found - chart skipped');
        return;
    }

    try {
        // Split strings by commas
        var lbl = animalnames ? animalnames.split(',') : [];
        var values = animaloccurance ? animaloccurance.split(',').map(Number) : [];

        if (lbl.length === 0 || values.length === 0) {
            console.warn('No data for animal chart');
            return;
        }

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
            caseBarChart = null;
        }

        // ✅ SAFE: Get context only after confirming canvas exists
        const ctx = canvas.getContext('2d');
        if (!ctx) {
            console.warn('Could not get 2d context for canvas');
            return;
        }

        caseBarChart = new Chart(ctx, config);
    } catch (error) {
        console.error('Error in chartanimal:', error);
    }
}

// ==========================================
// ❌ CLOSE INCIDENT REPORT
// ==========================================
function closeincidentreport() {
    var popup = document.getElementById("popup");
    if (popup) {
        popup.style.display = "none";
    }
}

// ==========================================
// 📊 RANGE CHART - FIXED
// ==========================================
function chartrange(lblrange, valrange) {
    // ✅ Check if chart canvas exists
    var canvas = document.getElementById('caseLineChart');
    if (!canvas) {
        console.warn('caseLineChart canvas not found - chart skipped');
        return;
    }

    try {
        const lblrange1 = lblrange ? lblrange.split(',') : [];
        const valrange1 = valrange ? valrange.split(',').map(Number) : [];

        if (lblrange1.length === 0 || valrange1.length === 0) {
            console.warn('No data for range chart');
            return;
        }

        const data = {
            labels: lblrange1,
            datasets: [{
                label: 'Cases by Range',
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
            caseRangeChart = null;
        }

        // Create and store new chart
        const ctx = canvas.getContext('2d');
        caseRangeChart = new Chart(ctx, config);
    } catch (error) {
        console.error('Error in chartrange:', error);
    }
}

// ==========================================
// 🗺️ CALL MAP - FIXED
// ==========================================
function callmap() {
    try {
        const conflictCategory = document.getElementById("ddlDataType");
        const dateFromInput = document.getElementById("txtStartDate");
        const dateToInput = document.getElementById("txtEndDate");
        const divisionSelect = document.getElementById("ddlDivision");
        const rangeSelect = document.getElementById("ddlRange");

        // ✅ Check if elements exist
        if (!conflictCategory || !dateFromInput || !dateToInput || !divisionSelect || !rangeSelect) {
            console.warn('Some form elements not found');
            return;
        }

        const dateFrom = new Date(dateFromInput.value).toISOString().slice(0, 10);
        const dateTo = new Date(dateToInput.value).toISOString().slice(0, 10);
        const division = divisionSelect.value;
        const range = rangeSelect.value;

        // Build CQL filter
        let filterParts = [];
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

        // ✅ Remove existing layers safely
        if (layerfiltermap) {
            map.removeLayer(layerfiltermap);
            layerfiltermap = null;
        }

        // ✅ Add range layer
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
                    },
                    serverType: 'geoserver',
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
                    },
                    serverType: 'geoserver',
                    crossOrigin: 'anonymous'
                })
            });
        }

        map.addLayer(layerfiltermap);

        // ✅ Remove existing vector layer
        if (vectorLayer) {
            map.removeLayer(vectorLayer);
            vectorLayer = null;
        }

        const encodedFilter = encodeURIComponent(cqlFilter);
        const wfsUrl = `https://ukforestgis.in/geoserver/uk_sfd/ows?` +
            `service=WFS&version=1.0.0&request=GetFeature` +
            `&typeName=uk_sfd:view_tbl_victim_incident` +
            `&outputFormat=application/json` +
            `&CQL_FILTER=${encodedFilter}`;

        // Fetch GeoJSON from WFS
        fetch(wfsUrl)
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(geojson => {
                if (!geojson.features || geojson.features.length === 0) {
                    console.warn('No data returned from server');
                    return;
                }

                // Create vector source from features
                const vectorSource = new ol.source.Vector({
                    features: new ol.format.GeoJSON().readFeatures(geojson, {
                        featureProjection: 'EPSG:3857'
                    })
                });

                // Animation config
                const duration = 2000;
                const minRadius = 4;
                const maxRadius = 12;
                let start = Date.now();

                function styleFunction(feature) {
                    const status = feature.get('status') || 'unknown';
                    var legend = document.getElementById("maplegend");

                    if (legend) {
                        legend.style.display = "block";
                    }

                    if (status.toLowerCase() === 'pending') {
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
                        return new ol.style.Style({
                            image: new ol.style.Circle({
                                radius: 6,
                                fill: new ol.style.Fill({ color: 'green' }),
                                stroke: new ol.style.Stroke({ color: 'green', width: 1 })
                            })
                        });
                    } else {
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
                    if (vectorLayer) {
                        vectorLayer.changed();
                    }
                    requestAnimationFrame(animate);
                }
                animate();

                // ✅ Tooltip setup
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
                console.error('Error loading map data:', error);
                alert("Failed to load map data.");
            });
    } catch (error) {
        console.error('Error in callmap:', error);
    }
}

// ==========================================
// 🔄 SAFE OVERRIDE FOR EXTERNAL CHART FUNCTION
// ==========================================
// This prevents errors when called from inline scripts
if (typeof chartanimal === 'function') {
    var originalChartAnimal = chartanimal;
    chartanimal = function (animalnames, animaloccurance) {
        try {
            // ✅ Check if canvas exists before calling original
            if (!document.getElementById('caseLineChartbar')) {
                console.warn('caseLineChartbar not found, skipping chart');
                return;
            }
            originalChartAnimal(animalnames, animaloccurance);
        } catch (e) {
            console.warn('Chart error:', e.message);
        }
    };
}

// ==========================================
// 🚀 DOM READY INITIALIZATION
// ==========================================
document.addEventListener('DOMContentLoaded', function () {
    // Check if map container exists
    if (!document.getElementById('map')) {
        console.warn('Map container not found');
    }

    // Check if chart containers exist
    if (!document.getElementById('caseLineChartbar')) {
        console.warn('caseLineChartbar not found');
    }

    if (!document.getElementById('caseLineChart')) {
        console.warn('caseLineChart not found');
    }

    console.log('hwcDashboard.js loaded successfully');
});

// ==========================================
// 🔧 WINDOW LOAD FALLBACK
// ==========================================
window.addEventListener('load', function () {
    // Any additional initialization after all resources loaded
    console.log('hwcDashboard.js - Window fully loaded');
});