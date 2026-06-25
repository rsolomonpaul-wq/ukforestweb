var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";
var sentinel2fcckey = "f78e28ba-2615-43b9-8532-9c68247a3c7b";
var sentinel2ncckey = "f78e28ba-2615-43b9-8532-9c68247a3c7b";

// ==================== FSI API Configuration ====================
const FSI_API_BASE = "https://fsiforestfire.gov.in/api/v1/firepoints/filter";
const FSI_STATE = "UTTARAKHAND";

// ==================== MAP 1: Fire Monitoring Dashboard ====================
const map = new ol.Map({
    target: 'map',
    layers: [new ol.layer.Tile({ source: new ol.source.OSM() })],
    view: new ol.View({ center: ol.proj.fromLonLat([78.25, 30.25]), zoom: 8.5 })
});

// ==================== MAP 2: Fire Realtime Dashboard ====================
const map1 = new ol.Map({
    target: 'map1',
    layers: [new ol.layer.Tile({ source: new ol.source.OSM() })],
    view: new ol.View({ center: ol.proj.fromLonLat([78.25, 30.25]), zoom: 8.5 })
});

// ==================== MAP 1 Variables ====================
let currentFilteredLayer = null;
let infoOverlay;
let sentinelLayer1;
let cliplayer;
let fireDamageChartins;
let fireDamageChartInstance = null;

// ==================== MAP 2 Variables ====================
let currentFilteredLayer1 = null;
let infoOverlay1;

// ==================== Common Variables ====================
var filter = "";
let layersss = "tbl_plant_species";
let vectorLayer1 = null, vectorLayer2 = null;
let maskLayer1 = null, maskLayer2 = null;
let uploadedFeatures = null;
let isuploaded = false;
let uploadedVectorLayer = null;

// ==================== Realtime Pie Chart ====================
let realtimeAlertChart = null;

// Cache for FSI API data (avoid repeated calls)
let cachedFsiData = null;
let cachedFsiParams = null;

document.addEventListener('DOMContentLoaded', function () {
    setTimeout(function () {
        if (typeof map !== 'undefined') map.updateSize();
        if (typeof map1 !== 'undefined' && document.getElementById('map1')) map1.updateSize();
    }, 500);
});

// ==================== REALTIME TRIGGER ====================
async function triggerRealtimeLoad() {
    const loadingEl = document.getElementById('pieChartLoading');
    const noDataEl = document.getElementById('pieNoData');
    const canvas = document.getElementById('realtimeAlertPieChart');
    if (loadingEl) loadingEl.style.display = 'flex';
    if (noDataEl) noDataEl.style.display = 'none';
    if (canvas) canvas.style.display = 'none';
    console.log('triggerRealtimeLoad: waiting for server-side FSI data...');
}

/**
 * Called by CS ScriptManager with pre-fetched FSI data (server-side, no CORS).
 */
//function renderFsiFromServer(fsiData, circleFilter, divisionFilter, rangeFilter) {
//    console.log(`renderFsiFromServer: ${fsiData.length} records, circle=${circleFilter}, div=${divisionFilter}, range=${rangeFilter}`);

//    window._lastFsiData = fsiData;
//    window._lastFsiFilters = { circle: circleFilter, division: divisionFilter, range: rangeFilter };

//    loadRealtimePieChart(fsiData);
//    plotRealtimeOnMap(fsiData);
//}


function renderFsiFromServer(fsiData, circleFilter, divisionFilter, rangeFilter) {
    // ── FSI API Error Toast Check ──────────────────────────────────────────
    var errFlag = document.getElementById('<%= hdnFsiApiError.ClientID %>');
    if (errFlag && errFlag.value === '1') {
        showFsiApiErrorToast();
        errFlag.value = ''; // reset so it doesn't show again on tab switch
    }
    // ───────────────────────────────────────────────────────────────────────

    console.log(`renderFsiFromServer: ${fsiData.length} records, circle=${circleFilter}, div=${divisionFilter}, range=${rangeFilter}`);

    window._lastFsiData = fsiData;
    window._lastFsiFilters = { circle: circleFilter, division: divisionFilter, range: rangeFilter };

    loadRealtimePieChart(fsiData);
    plotRealtimeOnMap(fsiData);
}

// ==================== FSI API Error Toast ====================
function showFsiApiErrorToast() {
    var toast = document.getElementById('fsiApiErrorToast');
    if (!toast) return;
    toast.style.display = 'block';
    setTimeout(function () {
        toast.style.display = 'none';
    }, 6000);
}

// ==================== FSI API FETCH ====================
async function fetchFsiData(startDate, endDate) {
    try {
        const url = `${FSI_API_BASE}?state=${FSI_STATE}&startDate=${startDate}&endDate=${endDate}`;
        console.log("Fetching FSI data:", url);
        const response = await fetch(url);
        if (!response.ok) throw new Error(`FSI API error: ${response.status}`);
        const json = await response.json();
        if (json.success && Array.isArray(json.data)) {
            console.log(`FSI API: ${json.data.length} records fetched`);
            return json.data;
        } else {
            console.warn("FSI API returned no data or unexpected format");
            return [];
        }
    } catch (err) {
        console.error("FSI API fetch failed:", err);
        return [];
    }
}




//async function fetchFsiData(startDate, endDate) {
//    try {
        
//        const url = `${FSI_API_BASE}?state=${FSI_STATE}&startDate=${startDate}&endDate=${endDate}`;
//        console.log("Fetching FSI data:", url);

//        const response = await fetch(url);
//        if (!response.ok) throw new Error(`FSI API error: ${response.status}`);

//        const json = await response.json();

//        if (json.success && Array.isArray(json.data)) {

//            // ✅ Store full raw data
//            alldatafsi = json.data;

//            console.log(`FSI API: ${json.data.length} records fetched`);
//            console.log("FSI Full Data:", alldatafsi);

//            return json.data;
//        } else {
//            console.warn("FSI API returned no data or unexpected format");
//            alldatafsi = [];
//            return [];
//        }

//    } catch (err) {
//        console.error("FSI API fetch failed:", err);
//        alldatafsi = [];
//        return [];
//    }
//}
// ==================== HIERARCHY CONFIG ====================
function getRtValue(rtId, fallbackAspId) {
    return getDropdownValue(fallbackAspId);
}

//function getHierarchyConfig() {
//    const filters = window._lastFsiFilters || {};
//    const circle = filters.circle || getRtValue('rtCircle', 'ContentPlaceHolder1_ddlcircle');
//    const divisionVal = filters.division || getRtValue('rtDivision', 'ContentPlaceHolder1_division');
//    const rangeVal = filters.range || getRtValue('rtRange', 'ContentPlaceHolder1_range');

//    if (circle === 'All') {
//        return {
//            groupBy: 'circle',
//            title: 'Fire Alerts by Circle',
//            filterFn: () => true,
//            // Get all circle names from the circle dropdown
//            allPossibleValues: getAllDropdownOptions('ContentPlaceHolder1_ddlcircle')
//        };
//    } else if (divisionVal === 'All') {
//        return {
//            groupBy: 'division',
//            title: `Fire Alerts by Division (${circle})`,
//            filterFn: (d) => fuzzyMatch(d.circle, circle),
//            // Get all division names from the division dropdown
//            allPossibleValues: getAllDropdownOptions('ContentPlaceHolder1_division')
//        };
//    } else if (rangeVal === 'All') {
//        return {
//            groupBy: 'range',
//            title: `Fire Alerts by Range (${divisionVal})`,
//            filterFn: (d) => fuzzyMatch(d.circle, circle) && fuzzyMatch(d.division, divisionVal),
//            // Get all range names from the range dropdown
//            allPossibleValues: getAllDropdownOptions('ContentPlaceHolder1_range')
//        };
//    } else {
//        return {
//            groupBy: 'beat',
//            title: `Fire Alerts by Beat (${rangeVal})`,
//            filterFn: (d) =>
//                fuzzyMatch(d.circle, circle) &&
//                fuzzyMatch(d.division, divisionVal) &&
//                fuzzyMatch(d.range, rangeVal),
//            allPossibleValues: [] // Beat has no dropdown — show only those with data
//        };
//    }
//}

function getHierarchyConfig() {
    const filters = window._lastFsiFilters || {};
    const circle = filters.circle || getRtValue('rtCircle', 'ContentPlaceHolder1_ddlcircle');
    const divisionVal = filters.division || getRtValue('rtDivision', 'ContentPlaceHolder1_division');
    const rangeVal = filters.range || getRtValue('rtRange', 'ContentPlaceHolder1_range');

    if (circle === 'All') {
        return {
            groupBy: 'circle',
            title: 'Fire Alerts by Circle',
            filterFn: () => true,
            allPossibleValues: getAllDropdownOptions('ContentPlaceHolder1_ddlcircle')
        };
    } else if (divisionVal === 'All') {
        return {
            groupBy: 'division',
            title: `Fire Alerts by Circle (${circle})`,
            filterFn: (d) => fuzzyMatch(d.circle, circle),
            allPossibleValues: getAllDropdownOptions('ContentPlaceHolder1_division')
        };
    } else if (rangeVal === 'All') {
        return {
            groupBy: 'range',
            title: `Fire Alerts by Division (${divisionVal})`,
            filterFn: (d) => fuzzyMatch(d.circle, circle) && fuzzyMatch(d.division, divisionVal),
            allPossibleValues: getAllDropdownOptions('ContentPlaceHolder1_range')
        };
    } else {
        return {
            groupBy: 'beat',
            title: `Fire Alerts by Range (${rangeVal})`,
            filterFn: (d) =>
                fuzzyMatch(d.circle, circle) &&
                fuzzyMatch(d.division, divisionVal) &&
                fuzzyMatch(d.range, rangeVal),
            allPossibleValues: []
        };
    }
}

/**
 * Get all option values from a dropdown (excluding "All")
 */
function getAllDropdownOptions(dropdownId) {
    const el = document.getElementById(dropdownId);
    if (!el) return [];
    const options = [];
    for (let i = 0; i < el.options.length; i++) {
        const val = el.options[i].value;
        if (val && val !== 'All') {
            options.push(el.options[i].text || val);
        }
    }
    return options;
}

function normalizeStr(s) {
    return (s || '').toString().trim().toUpperCase();
}

function fuzzyMatch(apiVal, filterVal) {
    if (!filterVal || filterVal === 'All') return true;
    const a = normalizeStr(apiVal);
    const f = normalizeStr(filterVal);
    return a === f || a.includes(f) || f.includes(a);
}

function getDropdownValue(id) {
    const el = document.getElementById(id);
    return el ? el.value : 'All';
}

/**
 * Group data array by a field.
 * Also merges in allPossibleValues so that items with 0 count are included.
 * Returns: { labels, counts, hasData[] }
 *   hasData[i] = true if that label has at least 1 fire record
 */
function groupByFieldWithZeros(data, field, allPossibleValues) {
    // Build count map from actual data
    const countMap = {};
    data.forEach(d => {
        const key = (d[field] || 'Unknown').toString().trim();
        countMap[key] = (countMap[key] || 0) + 1;
    });

    // Start with items that have data (sorted descending)
    const withData = Object.entries(countMap).sort((a, b) => b[1] - a[1]);

    // Build set of normalized keys already present in data
    const includedNormalized = new Set(withData.map(e => normalizeStr(e[0])));

    // Add ONLY dropdown items that are NOT already represented in data
    // Use fuzzy match so "KIRTINAGAR RANGE" from API matches "Kirtinagar" from dropdown
    const zeroItems = [];
    allPossibleValues.forEach(val => {
        const normVal = normalizeStr(val);
        const alreadyIncluded = [...includedNormalized].some(existing =>
            existing === normVal || existing.includes(normVal) || normVal.includes(existing)
        );
        if (!alreadyIncluded) {
            zeroItems.push([val, 0]);
        }
    });

    // Combine: data items first (colored), then missing items alphabetically (grey)
    zeroItems.sort((a, b) => a[0].localeCompare(b[0]));
    const allEntries = [...withData, ...zeroItems];

    return {
        labels: allEntries.map(e => e[0]),
        counts: allEntries.map(e => e[1]),
        hasData: allEntries.map(e => e[1] > 0)
    };
}

// ==================== MAIN PIE CHART FUNCTION ====================

async function loadRealtimePieChart(preloadedData) {
    const canvas = document.getElementById('realtimeAlertPieChart');
    const loadingEl = document.getElementById('pieChartLoading');
    const noDataEl = document.getElementById('pieNoData');
    const titleEl = document.getElementById('pieChartTitle');

    if (!canvas) return;

    canvas.style.display = 'none';
    if (noDataEl) noDataEl.style.display = 'none';
    if (loadingEl) loadingEl.style.display = 'flex';

    let allData;
    if (preloadedData) {
        allData = preloadedData;
    } else {
        const sEl = document.getElementById('ContentPlaceHolder1_txtRealtimeStartDate')
            || document.querySelector("input[id$='txtRealtimeStartDate']");
        const eEl = document.getElementById('ContentPlaceHolder1_txtRealtimeEndDate')
            || document.querySelector("input[id$='txtRealtimeEndDate']");
        const startDate = sEl ? sEl.value : new Date(new Date().getFullYear(), 1, 1).toISOString().split('T')[0];
        const endDate = eEl ? eEl.value : new Date().toISOString().split('T')[0];
        allData = await fetchFsiData(startDate, endDate);
    }

    const config = getHierarchyConfig();
    if (titleEl) titleEl.textContent = config.title;

    // Apply geographic filter
    const filtered = allData.filter(config.filterFn);

    // Group — includes zeros from dropdown
    const grouped = groupByFieldWithZeros(filtered, config.groupBy, config.allPossibleValues);

    if (loadingEl) loadingEl.style.display = 'none';

    const total = grouped.counts.reduce((a, b) => a + b, 0);

    // Destroy existing chart
    if (realtimeAlertChart) { realtimeAlertChart.destroy(); realtimeAlertChart = null; }

    // If absolutely nothing (no data, no dropdown options either) — show no-data message
    if (grouped.labels.length === 0) {
        canvas.style.display = 'none';
        if (noDataEl) noDataEl.style.display = 'flex';
        return;
    }

    canvas.style.display = 'block';

    // Color palette — only for items WITH data; no-data items get grey
    const colorPalette = [
        '#e74c3c', '#3498db', '#2ecc71', '#f39c12', '#9b59b6',
        '#1abc9c', '#e67e22', '#34495e', '#e91e63', '#00bcd4',
        '#8bc34a', '#ff5722', '#607d8b', '#795548', '#ff9800'
    ];
    const ZERO_COLOR = '#cccccc'; // Grey for 0% items

    // Assign colors: items with data get palette colors, zero items get grey
    let colorIndex = 0;
    const backgroundColors = grouped.hasData.map(has => {
        if (has) return colorPalette[colorIndex++ % colorPalette.length];
        return ZERO_COLOR;
    });

    const ctx = canvas.getContext('2d');

    realtimeAlertChart = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: grouped.labels,
            datasets: [{
                data: grouped.counts,
                backgroundColor: backgroundColors,
                borderColor: '#ffffff',
                borderWidth: 2,
                hoverOffset: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 8,
                        font: { size: 11 },
                        usePointStyle: true,
                        pointStyle: 'circle',
                        boxWidth: 10,
                        generateLabels: function (chart) {
                            const data = chart.data;
                            const dataset = data.datasets[0];
                            return data.labels.map((label, i) => {
                                const count = dataset.data[i];
                                const hasData = grouped.hasData[i];
                                const pct = total > 0 ? ((count / total) * 100).toFixed(1) : '0.0';

                                return {
                                    // Label text: name + percentage
                                    text: `${label} (${pct}%)`,

                                    // Color dot: colored if has data, grey if zero
                                    fillStyle: hasData ? dataset.backgroundColor[i] : ZERO_COLOR,
                                    strokeStyle: hasData ? '#fff' : '#aaa',

                                    lineWidth: 1,
                                    hidden: false,
                                    index: i,

                                    // Style zero-data items differently in legend
                                    fontColor: hasData ? '#333' : '#999'
                                };
                            });
                        }
                    }
                },
                title: { display: false },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            const val = context.parsed;
                            const pct = total > 0 ? ((val / total) * 100).toFixed(1) : '0.0';
                            return `Count: ${val} (${pct}%)`;
                        }
                    }
                }
            },
            animation: { animateRotate: true, animateScale: true }
        }
    });

    console.log(`Pie chart: ${grouped.labels.length} groups (${grouped.hasData.filter(Boolean).length} with data, ${grouped.hasData.filter(x => !x).length} zero), total=${total}`);
}

// ==================== MAP 1 Functions ====================
var boundaryURLreturn;
function buildWFSUrl(zone, circle, division, range, fire_status, land_cover, protected_area) {
    //const baseUrl = "https://ukforestgis.in/geoserver/uk_sfd/ows";
    var baseUrl = "http://117.239.115.148/dailyfirereport/api/gizapi.php";
    //const params = new URLSearchParams({
    //    service: "WFS", version: "1.0.0", request: "GetFeature",
    //    typeName: "uk_sfd:tbl_fire_data", outputFormat: "application/json"
    //});

    let filters = [];
    if (zone !== "All") filters.push(`zone='${zone}'`);
    if (circle !== "All") filters.push(`circle='${circle}'`);
    if (division !== "All") filters.push(`division='${division}'`);
    if (range !== "All") filters.push(`range='${range}'`);
    if (fire_status != "All") filters.push(`fire_status = '${fire_status}'`);
    if (land_cover != "All") filters.push(`land_cover = '${land_cover}'`);
    if (protected_area != "All") filters.push(`protected_area = '${protected_area}'`);

    if (filters.length > 0) {
        //params.set("CQL_FILTER", filters.join(" AND "));
        boundaryURLreturn = showBoundary(filters[filters.length - 1]);
        baseUrl = baseUrl + '&&&' + boundaryURLreturn;
    }


   
    return `${baseUrl}`;
}

var boundaryLayer = null;
function showBoundary(str) {

    // Example input: "range = 'Maniknath'"
   // alert(str);
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
        map.removeLayer(boundaryLayer);
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

    map1.addLayer(boundaryLayer);
    map.addLayer(boundaryLayer);

    fetch(boundaryURL)
        .then(r => {
            if (!r.ok) throw new Error("Network error");
            return r.json();
        })
        .then(data => {

            const features = new ol.format.GeoJSON().readFeatures(data, {
                dataProjection: "EPSG:4326",
                featureProjection: map1.getView().getProjection()
            });

            vectorSource.clear();
            vectorSource.addFeatures(features);

            if (features.length > 0) {
                map1.getView().fit(vectorSource.getExtent(), {
                    padding: [30, 30, 30, 30],
                    duration: 1000
                });
                map.getView().fit(vectorSource.getExtent(), {
                    padding: [30, 30, 30, 30],
                    duration: 1000
                });
            }

        })
        .catch(err => console.error("Boundary load error:", err));
    return boundaryURL;
}
let alldata=[];
//function applyfilter() {
//    const zone = document.getElementById("ContentPlaceHolder1_ddlzone").value;
//    const circle = document.getElementById("ContentPlaceHolder1_ddlcircle").value;
//    const division = document.getElementById("ContentPlaceHolder1_division").value;
//    const range = document.getElementById("ContentPlaceHolder1_range").value;
//    const fire_status_control = document.getElementById("ContentPlaceHolder1_rdofirestatus");
//    const land_cover_control = document.getElementById("ContentPlaceHolder1_rdoforesttype");
//    const protected_area_control = document.getElementById("ContentPlaceHolder1_chkprotectedarea");

//    let fire_status = "All", land_cover = "All", protected_area = "All";

//    if (fire_status_control) {
//        for (let i = 0; i < fire_status_control.length; i++) {
//            if (fire_status_control[i].checked) { fire_status = fire_status_control[i].value; break; }
//        }
//    }
//    if (land_cover_control) {
//        for (let i = 0; i < land_cover_control.length; i++) {
//            if (land_cover_control[i].checked) { land_cover = land_cover_control[i].value; break; }
//        }
//    }
//    if (protected_area_control) {
//        for (let i = 0; i < protected_area_control.length; i++) {
//            if (protected_area_control[i].checked) { protected_area = protected_area_control[i].value; break; }
//        }
//    }

//    var url = buildWFSUrl(zone, circle, division, range, fire_status, land_cover, protected_area);
//    var urlforboundaryclip;
//    //const url = "";
//    console.log("url " + url);
//    if (url.split("&&&").length > 1) {
//        urlforboundaryclip= url.split("&&&")[1];
//    }
//    url = url.split("&&&")[0];
//    if (!currentFilteredLayer) {
//        const vectorSource = new ol.source.Vector();
//        currentFilteredLayer = new ol.layer.Vector({
//            source: vectorSource,
//            style: new ol.style.Style({
//                image: new ol.style.Icon({ anchor: [0.5, 1], src: 'https://cdn-icons-png.flaticon.com/512/684/684908.png', scale: 0.025 })
//            })
//        });
//        map.addLayer(currentFilteredLayer);
//    }

//    const vectorSource = currentFilteredLayer.getSource();
//    vectorSource.clear();

//    fetch(url)
//        .then(r => {
//            if (!r.ok) throw new Error("Network error");
//            return r.json();
//        })
//        .then(data => {

//            // ✅ Store full raw data
//            alldata = data.data;
           
//            const features = [];

//            data.data.forEach(item => {

//                // Skip if no coordinates
//                if (!item.lat_degree || !item.long_degree) return;

//                // Convert DMS → Decimal
//                function dmsToDecimal(deg, min, sec) {
//                    deg = parseFloat(deg) || 0;
//                    min = parseFloat(min) || 0;
//                    sec = parseFloat(sec) || 0;
//                    return deg + (min / 60) + (sec / 3600);
//                }

//                let lat = dmsToDecimal(item.lat_degree, item.lat_minutes, item.lat_seconds);
//                let lon = dmsToDecimal(item.long_degree, item.long_minutes, item.long_seconds);

//                // Create map feature
//                let feature = new ol.Feature({
//                    geometry: new ol.geom.Point(
//                        ol.proj.fromLonLat([lon, lat])
//                    ),
//                    name: item.division?.name || "Unknown",
//                    zone: item.zone?.title || "Unknown",
//                    fullData: item // optional: attach full object
//                });

//                features.push(feature);
//            });

//            // Add features to map
//            vectorSource.clear();
//            vectorSource.addFeatures(features);

//            if (features.length > 0) {
//                map.updateSize();
//            }

//            // Debug
//            console.log("All Raw Data:", alldata);
//            console.log("Map Features:", features);

//        })
//        .catch(err => console.error('Error loading features:', err));
//}

function applyfilter() {
    //showLoader();
    const zone = document.getElementById("ContentPlaceHolder1_ddlzone").value;
    const circle = document.getElementById("ContentPlaceHolder1_ddlcircle").value;
    const division = document.getElementById("ContentPlaceHolder1_division").value;
    const range = document.getElementById("ContentPlaceHolder1_range").value;

    const fire_status_control = document.getElementById("ContentPlaceHolder1_rdofirestatus");
    const land_cover_control = document.getElementById("ContentPlaceHolder1_rdoforesttype");
    const protected_area_control = document.getElementById("ContentPlaceHolder1_chkprotectedarea");

    let fire_status = "All";
    let land_cover = "All";
    let protected_area = "All";

    //if (fire_status_control) {
    //    for (let i = 0; i < fire_status_control.length; i++) {
    //        if (fire_status_control[i].checked) {
    //            fire_status = fire_status_control[i].value;
    //            break;
    //        }
    //    }
    //}

    //if (land_cover_control) {
    //    for (let i = 0; i < land_cover_control.length; i++) {
    //        if (land_cover_control[i].checked) {
    //            land_cover = land_cover_control[i].value;
    //            break;
    //        }
    //    }
    //}

    //if (protected_area_control) {
    //    for (let i = 0; i < protected_area_control.length; i++) {
    //        if (protected_area_control[i].checked) {
    //            protected_area = protected_area_control[i].value;
    //            break;
    //        }
    //    }
    //}

    var url = buildWFSUrl(
        zone,
        circle,
        division,
        range,
        fire_status,
        land_cover,
        protected_area
    );

    var urlforboundaryclip = "";

    if (url.indexOf("&&&") > -1) {
        var urls = url.split("&&&");
        url = urls[0];
        urlforboundaryclip = urls[1];
    }

    console.log("Point URL:", url);
    console.log("Boundary URL:", urlforboundaryclip);

    if (!currentFilteredLayer) {

        const vectorSource = new ol.source.Vector();

        currentFilteredLayer = new ol.layer.Vector({
            source: vectorSource,
            style: new ol.style.Style({
                image: new ol.style.Icon({
                    anchor: [0.5, 1],
                    src: 'https://cdn-icons-png.flaticon.com/512/684/684908.png',
                    scale: 0.025
                })
            })
        });

        map.addLayer(currentFilteredLayer);
    }

    const vectorSource = currentFilteredLayer.getSource();
    vectorSource.clear();

    // Helper Function
    function dmsToDecimal(deg, min, sec) {
        deg = parseFloat(deg) || 0;
        min = parseFloat(min) || 0;
        sec = parseFloat(sec) || 0;
        return deg + (min / 60) + (sec / 3600);
    }

    // If no boundary URL then load all points
    if (!urlforboundaryclip) {

        fetch(url)
            .then(r => {
                if (!r.ok) throw new Error("Point data error");
                return r.json();
            })
            .then(data => {

                alldata = data.data || [];

                const features = [];

                alldata.forEach(item => {

                    if (!item.lat_degree || !item.long_degree) return;

                    let lat = dmsToDecimal(
                        item.lat_degree,
                        item.lat_minutes,
                        item.lat_seconds
                    );

                    let lon = dmsToDecimal(
                        item.long_degree,
                        item.long_minutes,
                        item.long_seconds
                    );

                    features.push(
                        new ol.Feature({
                            geometry: new ol.geom.Point(
                                ol.proj.fromLonLat([lon, lat])
                            ),
                            name: item.division?.name || "Unknown",
                            zone: item.zone?.title || "Unknown",
                            fullData: item
                        })
                    );
                });

                vectorSource.addFeatures(features);

                if (features.length > 0) {
                    map.getView().fit(vectorSource.getExtent(), {
                        padding: [20, 20, 20, 20],
                        duration: 1000
                    });
                }

                map.updateSize();
            })
            .catch(err => { console.error("Point Load Error:", err); hideLoader() });

        return;
    }

    // Load Boundary First
    fetch(urlforboundaryclip)
        .then(r => {
            if (!r.ok) throw new Error("Boundary load error");
            return r.json();
        })
        .then(boundaryData => {

            const boundaryFeatures = new ol.format.GeoJSON().readFeatures(
                boundaryData,
                {
                    dataProjection: "EPSG:4326",
                    featureProjection: map.getView().getProjection()
                }
            );

            if (!boundaryFeatures.length) {
                console.warn("No boundary found.");
                return;
            }

            // Load Point Data
            fetch(url)
                .then(r => {
                    if (!r.ok) throw new Error("Point data error");
                    return r.json();
                })
                .then(data => {

                    alldata = data.data || [];

                    const features = [];

                    alldata.forEach(item => {

                        if (!item.lat_degree || !item.long_degree) return;

                        let lat = dmsToDecimal(
                            item.lat_degree,
                            item.lat_minutes,
                            item.lat_seconds
                        );

                        let lon = dmsToDecimal(
                            item.long_degree,
                            item.long_minutes,
                            item.long_seconds
                        );

                        let pointCoord = ol.proj.fromLonLat([lon, lat]);

                        // Check point inside ANY boundary polygon
                        let isInsideBoundary = boundaryFeatures.some(boundary => {
                            return boundary
                                .getGeometry()
                                .intersectsCoordinate(pointCoord);
                        });

                        if (!isInsideBoundary) return;

                        features.push(
                            new ol.Feature({
                                geometry: new ol.geom.Point(pointCoord),
                                name: item.division?.name || "Unknown",
                                zone: item.zone?.title || "Unknown",
                                fullData: item
                            })
                        );
                    });

                    vectorSource.clear();
                    vectorSource.addFeatures(features);

                    console.log("Total Records:", alldata.length);
                    console.log("Points Inside Boundary:", features.length);

                    if (features.length > 0) {

                        map.getView().fit(vectorSource.getExtent(), {
                            padding: [20, 20, 20, 20],
                            duration: 1000
                        });
                    }
                    console.log("DONEEEEEEEEEEEEEEE");
                    hideLoader();
                    map.updateSize();
                   
                });
        })
        .catch(err => {
            hideLoader()
            console.error("Boundary Clip Error:", err);
        });

   
}


function showLoader() {
    document.getElementById("loaderOverlay").style.display = "flex";
}

function hideLoader() {
    document.getElementById("loaderOverlay").style.display = "none";
}

function loadCrewStations() {
    const baseUrl = "https://ukforestgis.in/geoserver/uk_sfd/ows";
    const zone = document.getElementById("ContentPlaceHolder1_ddlzone").value;
    const circle = document.getElementById("ContentPlaceHolder1_ddlcircle").value;
    const division = document.getElementById("ContentPlaceHolder1_division").value;
    const range = document.getElementById("ContentPlaceHolder1_range").value;

    const params = new URLSearchParams({
        service: "WFS", version: "1.0.0", request: "GetFeature",
        typeName: "uk_sfd:tbl_crewstation", outputFormat: "application/json"
    });

    let filters = [];
    if (zone !== "All") filters.push(`zone='${zone}'`);
    if (circle !== "All") filters.push(`circle='${circle}'`);
    if (division !== "All") filters.push(`division='${division}'`);
    if (range !== "All") filters.push(`range='${range}'`);
    if (filters.length > 0) params.set("CQL_FILTER", filters.join(" AND "));

    const url = `${baseUrl}?${params.toString()}`;

    if (!window.crewStationLayer) {
        const vectorSource = new ol.source.Vector();
        window.crewStationLayer = new ol.layer.Vector({
            source: vectorSource,
            style: new ol.style.Style({
                image: new ol.style.Icon({ anchor: [0.1, .1], src: 'http://203.122.5.18:9008/uk_forest_web/DSS/img/crew.png', scale: 0.1 })
            })
        });
        map.addLayer(window.crewStationLayer);
    }

    const vectorSource = window.crewStationLayer.getSource();
    vectorSource.clear();

    fetch(url)
        .then(r => { if (!r.ok) throw new Error("Network error"); return r.json(); })
        .then(data => {
            const features = new ol.format.GeoJSON().readFeatures(data, { featureProjection: map.getView().getProjection() });
            vectorSource.addFeatures(features);
            if (features.length > 0) {
                map.getView().fit(vectorSource.getExtent(), { duration: 1000, padding: [20, 20, 20, 20] });
                map.updateSize();
            }
        })
        .catch(err => console.error('Error fetching Crew Station data:', err));
}


function hideNoDataImages() {
    const elements = document.querySelectorAll('.no-data-image');

    elements.forEach(el => {
        el.style.display = 'none';
    });
}

function loadWatchTowers() {
    const baseUrl = "https://ukforestgis.in/geoserver/uk_sfd/ows";
    const zone = document.getElementById("ContentPlaceHolder1_ddlzone").value;
    const circle = document.getElementById("ContentPlaceHolder1_ddlcircle").value;
    const division = document.getElementById("ContentPlaceHolder1_division").value;
    const range = document.getElementById("ContentPlaceHolder1_range").value;

    const params = new URLSearchParams({
        service: "WFS", version: "1.0.0", request: "GetFeature",
        typeName: "uk_sfd:tbl_watch_tower", outputFormat: "application/json", maxFeatures: 1000
    });

    let filters = [];
    if (zone !== "All") filters.push(`zone='${zone}'`);
    if (circle !== "All") filters.push(`circle='${circle}'`);
    if (division !== "All") filters.push(`division='${division}'`);
    if (range !== "All") filters.push(`range='${range}'`);
    if (filters.length > 0) params.set("CQL_FILTER", filters.join(" AND "));

    const url = `${baseUrl}?${params.toString()}`;

    if (!window.watchTowerLayer) {
        const vectorSource = new ol.source.Vector();
        window.watchTowerLayer = new ol.layer.Vector({
            source: vectorSource,
            style: new ol.style.Style({
                image: new ol.style.Icon({ anchor: [0.5, 1], src: 'http://203.122.5.18:9008/uk_forest_web/DSS/img/watchtower.png', scale: 0.2 })
            })
        });
        map.addLayer(window.watchTowerLayer);
    }

    const vectorSource = window.watchTowerLayer.getSource();
    vectorSource.clear();

    fetch(url)
        .then(r => { if (!r.ok) throw new Error("Network error"); return r.json(); })
        .then(data => {
            const features = new ol.format.GeoJSON().readFeatures(data, { featureProjection: map.getView().getProjection() });
            vectorSource.addFeatures(features);
            if (features.length > 0) {
                map.getView().fit(vectorSource.getExtent(), { duration: 1000, padding: [20, 20, 20, 20] });
                map.updateSize();
            }
        })
        .catch(err => console.error('Error fetching Watch Tower data:', err));
}

// ==================== WEATHER ====================
const apiKey = '6b8642d4547db03dea15d468a029168b';

async function getWeather(lat, lon) {
    const url = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}&units=metric&lang=hi`;
    try {
        const res = await fetch(url);
        if (!res.ok) throw new Error('Weather data load failed');
        return await res.json();
    } catch (err) {
        return { error: err.message };
    }
}

function createWeatherTable(weatherData) {
    const weatherContainer = document.createElement('div');
    const table = document.createElement('table');
    table.style.borderCollapse = 'collapse';
    table.style.width = '100%';
    table.style.marginTop = '10px';

    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');
    ['मापदंड (Parameter)', 'मान (Value)'].forEach(text => {
        const th = document.createElement('th');
        th.textContent = text;
        th.style.border = '1px solid #ccc';
        th.style.padding = '6px';
        th.style.backgroundColor = '#e0f7fa';
        th.style.textAlign = 'left';
        headerRow.appendChild(th);
    });
    thead.appendChild(headerRow);
    table.appendChild(thead);

    const tbody = document.createElement('tbody');
    const rows = [
        { label: "तापमान (°C)", value: weatherData.main.temp },
        { label: "नमी (%)", value: weatherData.main.humidity },
        { label: "वायु का दबाव (hPa)", value: weatherData.main.pressure },
        { label: "हवा की गति (m/s)", value: weatherData.wind.speed },
        { label: "मौसम विवरण", value: weatherData.weather[0].description }
    ];

    rows.forEach(row => {
        const tr = document.createElement('tr');
        const tdLabel = document.createElement('td');
        tdLabel.textContent = row.label;
        tdLabel.style.border = '1px solid #ccc';
        tdLabel.style.padding = '5px';
        const tdValue = document.createElement('td');
        tdValue.textContent = row.value;
        tdValue.style.border = '1px solid #ccc';
        tdValue.style.padding = '5px';
        tr.appendChild(tdLabel);
        tr.appendChild(tdValue);
        tbody.appendChild(tr);
    });
    table.appendChild(tbody);
    weatherContainer.appendChild(table);
    return weatherContainer;
}

function convertHectare(value, toConvert) {
    if (typeof value !== 'number' || value < 0) throw new Error('Value must be non-negative');
    switch (toConvert.toLowerCase()) {
        case 'acre': return value * 2.4710538147;
        case 'sqm': return value * 10000;
        default: throw new Error('Invalid conversion type');
    }
}

function showInfo(lat, lon, feature) {
    const props = feature.getProperties();
    function formatLabel(key) {
        return key.replace(/[_-]/g, ' ').replace(/([a-z])([A-Z])/g, '$1 $2')
            .toLowerCase().split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
    }

    if (infoOverlay) { map.removeOverlay(infoOverlay); infoOverlay = null; }

    const container = document.createElement('div');
    container.style.cssText = 'position:absolute;top:10px;left:50%;transform:translateX(-50%);background:white;padding:10px;border:1px solid black;border-radius:5px;min-width:250px;max-height:300px;overflow-y:auto;box-shadow:0 1px 4px rgba(0,0,0,0.3);z-index:1000;cursor:move;';

    const closeBtn = document.createElement('button');
    closeBtn.innerHTML = '&#x2715;';
    closeBtn.type = 'button';
    closeBtn.style.cssText = 'position:absolute;top:5px;right:5px;border:none;background:transparent;font-size:16px;cursor:pointer;color:#333;';
    closeBtn.onclick = () => { if (infoOverlay) { infoOverlay.setPosition(undefined); infoOverlay = null; } };
    container.appendChild(closeBtn);

    const table = document.createElement('table');
    table.style.cssText = 'border-collapse:collapse;width:100%;margin-top:20px;cursor:pointer;';
    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');
    ['Property', 'Value'].forEach(text => {
        const th = document.createElement('th');
        th.textContent = text;
        th.style.cssText = 'border:1px solid #ccc;padding:6px;background:#f0f0f0;font-weight:bold;text-align:left;';
        headerRow.appendChild(th);
    });
    thead.appendChild(headerRow);
    table.appendChild(thead);

    const tbody = document.createElement('tbody');
    Object.entries(props)
        .filter(([key]) => !['geometry', 'soil', 'slope', 'gid', 'objectid', 'disc', 'discr', 'date', 'fire_status', 'fid_1', 'objectid_1', 'id', 'latitude', 'longitude'].includes(key))
        .forEach(([key, val]) => {
            const row = document.createElement('tr');
            const keyCell = document.createElement('td');
            keyCell.textContent = formatLabel(key);
            keyCell.style.cssText = 'border:1px solid #ccc;padding:4px;';

            if (['affected_area', 'covered_area'].includes(key)) {
                val = Number(parseFloat(val).toFixed(2)) + " ha";
            } else if (['plant_loss', 'human_death', 'human_injured', 'animal_death', 'animal_injured'].includes(key)) {
                val = val + " Count";
            }

            const valCell = document.createElement('td');
            valCell.textContent = val;
            valCell.style.cssText = 'border:1px solid #ccc;padding:4px;';
            row.appendChild(keyCell);
            row.appendChild(valCell);
            tbody.appendChild(row);
        });
    table.appendChild(tbody);
    container.appendChild(table);

    getWeather(lat, lon).then(data => {
        if (!data.error) {
            const hr = document.createElement('hr');
            hr.style.margin = '10px 0';
            container.appendChild(hr);
            const weatherHeading = document.createElement('h4');
            weatherHeading.textContent = "🌦️ मौसम जानकारी";
            container.appendChild(weatherHeading);
            const spn = document.createElement('span');
            spn.textContent = "(Source : Open Weather Map)";
            container.appendChild(spn);
            container.appendChild(createWeatherTable(data));
        }
    });

    infoOverlay = new ol.Overlay({ element: container, positioning: 'top-center', stopEvent: true, autoPan: false });
    map.addOverlay(infoOverlay);
    infoOverlay.setPosition(map.getView().getCenter());

    let isDragging = false, startX, startY, origLeft, origTop;
    container.addEventListener('mousedown', function (e) {
        if (e.target === closeBtn) return;
        isDragging = true; startX = e.clientX; startY = e.clientY;
        const style = window.getComputedStyle(container);
        origLeft = parseInt(style.left, 10); origTop = parseInt(style.top, 10);
        document.body.style.userSelect = 'none';
    });
    window.addEventListener('mousemove', function (e) {
        if (!isDragging) return;
        container.style.left = (origLeft + e.clientX - startX) + 'px';
        container.style.top = (origTop + e.clientY - startY) + 'px';
        container.style.transform = 'none';
    });
    window.addEventListener('mouseup', function () { isDragging = false; document.body.style.userSelect = ''; });
}

map.on('singleclick', function (evt) {
    const lonLat = ol.proj.toLonLat(evt.coordinate);
    const feature = map.forEachFeatureAtPixel(evt.pixel, feat => feat);
    if (window.highlightLayer) { map.removeLayer(window.highlightLayer); window.highlightLayer = null; }
    if (feature) showInfo(lonLat[1].toFixed(6), lonLat[0].toFixed(6), feature);
});

// ==================== CHART FUNCTIONS ====================

function callpiechart(lbl, val) {
    //alert(lbl);
    //alert(val);
    const fireDamageChart = document.getElementById('fireDamageChart');
    if (!fireDamageChart) return;
    if (!lbl || !val || lbl.trim() === '' || val.trim() === '') { showNoDataImage('fireDamageChart'); return; }
    if (fireDamageChartins) fireDamageChartins.destroy();
    const ctx = fireDamageChart.getContext('2d');
    fireDamageChartins = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: lbl.split(","),
            datasets: [{ label: 'Fire Damage Summary', data: val.split(","), backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF'], hoverOffset: 10 }]
        },
        options: { responsive: true, plugins: { legend: { position: 'bottom' }, title: { display: true, text: 'Total Fire Damage Breakdown' } } }
    });
    hideNoDataImages();
}

function callregionfunction(lbl, val, sums) {
    const canvas = document.getElementById('chartplantationandnursery');
    if (!canvas) return;
    if (!lbl || !val || !sums || lbl.trim() === '') { showNoDataImage('chartplantationandnursery'); return; }
    if (fireDamageChartInstance) fireDamageChartInstance.destroy();
    const chartCtx = canvas.getContext('2d');
    fireDamageChartInstance = new Chart(chartCtx, {
        type: 'bar',
        data: {
            labels: lbl.split(","),
            datasets: [
                { label: 'Total Incidents', data: val.split(",").map(Number), backgroundColor: '#36A2EB' },
                { label: 'Affected Area (in ha)', data: sums.split(",").map(Number), backgroundColor: '#4BC0C0' }
            ]
        },
        options: {
            responsive: true,
            scales: {
                y: { beginAtZero: true, title: { display: true, text: 'Incident Count' } },
                x: { title: { display: true, text: 'Regions' } }
            },
            plugins: {
                legend: { display: true, position: 'top' },
                title: { display: true, text: 'Region-wise Fire Incidents' },
                tooltip: { mode: 'index', intersect: false }
            }
        }
    });
    hideNoDataImages();

}

function showNoDataImage(canvasId) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) return;
    const container = canvas.parentElement;
    if (!container) return;
    container.style.minHeight = '300px';
    container.style.position = 'relative';
    canvas.style.display = 'none';
    const existingImg = container.querySelector('.no-data-image');
    if (existingImg) existingImg.remove();
    const img = document.createElement('img');
    img.src = '../images/notfound.jpg';
    img.alt = 'No Data Available';
    img.className = 'no-data-image';
    img.style.cssText = 'position:absolute;top:0;left:0;width:100%;height:100%;object-fit:contain;display:block;';
    container.appendChild(img);
}

// ==================== MAP 2: REALTIME ====================
let alldatafsi = [];
function plotRealtimeOnMap(allData) {
    const filters = window._lastFsiFilters || {};
    const circle = filters.circle || getRtValue('rtCircle', 'ContentPlaceHolder1_ddlcircle');
    const divisionVal = filters.division || getRtValue('rtDivision', 'ContentPlaceHolder1_division');
    const rangeVal = filters.range || getRtValue('rtRange', 'ContentPlaceHolder1_range');
    alldatafsi = allData;
    console.log(`plotRealtimeOnMap: ${allData.length} records, circle=${circle}, div=${divisionVal}, range=${rangeVal}`);
    //alert("fsi");
    let filteredData = allData;
    if (circle !== 'All') filteredData = filteredData.filter(d => fuzzyMatch(d.circle, circle));
    if (divisionVal !== 'All') filteredData = filteredData.filter(d => fuzzyMatch(d.division, divisionVal));
    if (rangeVal !== 'All') filteredData = filteredData.filter(d => fuzzyMatch(d.range, rangeVal));

    console.log(`Map features after filter: ${filteredData.length}`);
    _renderOnMap1(filteredData);
}

async function applyRealtimeFilter(startDate, endDate) {
    if (window._lastFsiData && window._lastFsiData.length > 0) {
        loadRealtimePieChart(window._lastFsiData);
        plotRealtimeOnMap(window._lastFsiData);
        return;
    }
    console.warn('applyRealtimeFilter: no server data cached, requesting postback...');
}

function _renderOnMap1(filteredData) {
    const features = filteredData
        .filter(d => d.lat && d.long)
        .map(d => {
            const coords = ol.proj.fromLonLat([d.long, d.lat]);
            const feature = new ol.Feature({ geometry: new ol.geom.Point(coords) });
            Object.keys(d).forEach(k => feature.set(k, d[k]));
            feature.set('source_Type', d.source_Type || '');
            return feature;
        });

    const styleFunc = (feature) => {
        const src = (feature.get('source_Type') || '').toUpperCase();
        let iconPath = 'http://203.122.5.18:9008/uk_forest_web/dss/img/red.png';
        let scale = 0.015;
        if (src.includes('SNPP') || src.includes('VIIRS')) {
            iconPath = 'http://203.122.5.18:9008/uk_forest_web/dss/img/red.png';
        } else if (src.includes('MODIS')) {
            iconPath = 'http://203.122.5.18:9008/uk_forest_web/dss/img/yellow.png'; scale = 0.028;
        } else {
            iconPath = 'http://203.122.5.18:9008/uk_forest_web/dss/img/green.png';
        }
        return new ol.style.Style({ image: new ol.style.Icon({ anchor: [0.5, 1], src: iconPath, scale }) });
    };

    if (!currentFilteredLayer1) {
        currentFilteredLayer1 = new ol.layer.Vector({ source: new ol.source.Vector(), style: styleFunc });
        map1.addLayer(currentFilteredLayer1);
    } else {
        currentFilteredLayer1.setStyle(styleFunc);
    }

    const vs = currentFilteredLayer1.getSource();
    vs.clear();
    vs.addFeatures(features);

    const legendEl = document.getElementById('legend-realtime');
    if (legendEl) legendEl.style.display = features.length > 0 ? 'block' : 'none';

    if (features.length > 0) {
        map1.getView().fit(vs.getExtent(), { duration: 1000, padding: [50, 50, 50, 50], maxZoom: 12 });
        map1.updateSize();
        console.log(`Map1: ${features.length} features plotted`);
    } else {
        map1.getView().setCenter(ol.proj.fromLonLat([78.25, 30.25]));
        map1.getView().setZoom(8.5);
        console.warn('Map1: No features match filters');
    }
}

map1.on('singleclick', function (evt) {
    const lonLat = ol.proj.toLonLat(evt.coordinate);
    const feature = map1.forEachFeatureAtPixel(evt.pixel, feat => feat);
    if (window.highlightLayer1) { map1.removeLayer(window.highlightLayer1); window.highlightLayer1 = null; }
    if (feature) showInfo_Realtime(lonLat[1].toFixed(6), lonLat[0].toFixed(6), feature);
});

function showInfo_Realtime(lat, lon, feature) {
    const props = feature.getProperties();
    function formatLabel(key) {
        return key.replace(/[_-]/g, ' ').replace(/([a-z])([A-Z])/g, '$1 $2')
            .toLowerCase().split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
    }

    if (infoOverlay1) { map1.removeOverlay(infoOverlay1); infoOverlay1 = null; }

    const container = document.createElement('div');
    container.style.cssText = 'position:absolute;top:10px;left:50%;transform:translateX(-50%);background:white;padding:10px;border:1px solid black;border-radius:5px;min-width:280px;max-height:320px;overflow-y:auto;box-shadow:0 1px 4px rgba(0,0,0,0.3);z-index:1000;cursor:move;';

    const closeBtn = document.createElement('button');
    closeBtn.innerHTML = '&#x2715;';
    closeBtn.type = 'button';
    closeBtn.style.cssText = 'position:absolute;top:5px;right:5px;border:none;background:transparent;font-size:16px;cursor:pointer;color:#333;';
    closeBtn.onclick = () => { if (infoOverlay1) { infoOverlay1.setPosition(undefined); infoOverlay1 = null; } };
    container.appendChild(closeBtn);

    const table = document.createElement('table');
    table.style.cssText = 'border-collapse:collapse;width:100%;margin-top:20px;';
    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');
    ['Property', 'Value'].forEach(text => {
        const th = document.createElement('th');
        th.textContent = text;
        th.style.cssText = 'border:1px solid #ccc;padding:6px;background:#f0f0f0;font-weight:bold;text-align:left;';
        headerRow.appendChild(th);
    });
    thead.appendChild(headerRow);
    table.appendChild(thead);

    const fieldMap = {
        'fire_Date': 'Fire Date', 'fire_Time': 'Fire Time', 'source_Type': 'Source',
        'state': 'State', 'district': 'District', 'circle': 'Circle',
        'division': 'Division', 'range': 'Range', 'block': 'Block',
        'beat': 'Beat', 'rfA_PFA': 'RFA/PFA', 'compartment_No': 'Compartment No',
        'lat': 'Latitude', 'long': 'Longitude'
    };

    const skipFields = ['geometry', 'fire_type', 'unique_ids', 'isSmsSent', 'id', 'long1', 'lat1'];

    const tbody = document.createElement('tbody');
    Object.entries(props)
        .filter(([key]) => !skipFields.includes(key))
        .forEach(([key, val]) => {
            const row = document.createElement('tr');
            const keyCell = document.createElement('td');
            keyCell.textContent = fieldMap[key] || formatLabel(key);
            keyCell.style.cssText = 'border:1px solid #ccc;padding:4px;font-weight:600;white-space:nowrap;';
            const valCell = document.createElement('td');
            valCell.textContent = val || '-';
            valCell.style.cssText = 'border:1px solid #ccc;padding:4px;';
            row.appendChild(keyCell);
            row.appendChild(valCell);
            tbody.appendChild(row);
        });

    table.appendChild(tbody);
    container.appendChild(table);

    getWeather(lat, lon).then(data => {
        if (!data.error) {
            const hr = document.createElement('hr');
            hr.style.margin = '10px 0';
            container.appendChild(hr);
            const h4 = document.createElement('h4');
            h4.textContent = "🌦️ मौसम जानकारी";
            container.appendChild(h4);
            container.appendChild(createWeatherTable(data));
        }
    });

    infoOverlay1 = new ol.Overlay({ element: container, positioning: 'top-center', stopEvent: true, autoPan: false });
    map1.addOverlay(infoOverlay1);
    infoOverlay1.setPosition(map1.getView().getCenter());

    let isDragging = false, startX, startY, origLeft, origTop;
    container.addEventListener('mousedown', function (e) {
        if (e.target === closeBtn) return;
        isDragging = true; startX = e.clientX; startY = e.clientY;
        const style = window.getComputedStyle(container);
        origLeft = parseInt(style.left, 10); origTop = parseInt(style.top, 10);
        document.body.style.userSelect = 'none';
    });
    window.addEventListener('mousemove', function (e) {
        if (!isDragging) return;
        container.style.left = (origLeft + e.clientX - startX) + 'px';
        container.style.top = (origTop + e.clientY - startY) + 'px';
        container.style.transform = 'none';
    });
    window.addEventListener('mouseup', function () { isDragging = false; document.body.style.userSelect = ''; });
}

// ==================== UTILITY ====================

function getSelectedAreaOption() {
    const radios = document.querySelectorAll('#areacontrol input[name="areaOption"]');
    for (let radio of radios) { if (radio.checked) return radio.id; }
    return null;
}

function toggleDropdown() {
    const panel = document.getElementById("dropdownPanel");
    if (panel) panel.style.display = (panel.style.display === "block") ? "none" : "block";
}

function closeslopdiv() {
    const slopdiv = document.getElementById("slopdivparentid");
    if (slopdiv) slopdiv.style.display = "none";
    if (window.highlightLayer) map.removeLayer(window.highlightLayer);
}

function makeDivDraggable(divid) {
    const el = document.getElementById(divid);
    if (!el) return;
    let isDragging = false, offsetX = 0, offsetY = 0;
    el.addEventListener('mousedown', function (e) {
        isDragging = true; offsetX = e.clientX - el.offsetLeft; offsetY = e.clientY - el.offsetTop;
        document.body.style.userSelect = 'none';
    });
    document.addEventListener('mousemove', function (e) {
        if (!isDragging) return;
        el.style.left = `${e.clientX - offsetX}px`; el.style.top = `${e.clientY - offsetY}px`;
    });
    document.addEventListener('mouseup', function () { isDragging = false; document.body.style.userSelect = ''; });
}

if (document.getElementById('slopdivparentid')) makeDivDraggable('slopdivparentid');

// ==================== SLOPE / SOIL / ELEVATION ====================
const slopeSLD = `<?xml version="1.0" encoding="UTF-8"?><StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><NamedLayer><Name>uk_sfd:srtm_slop_GCS</Name><UserStyle><Title>Slope Classification</Title><FeatureTypeStyle><Rule><RasterSymbolizer><ColorMap type="intervals" extended="true"><ColorMapEntry color="#6BBE44" quantity="10" label="5 - 10"/><ColorMapEntry color="#E5F94E" quantity="20" label="10 - 20"/><ColorMapEntry color="#FDC84E" quantity="30" label="20 - 30"/><ColorMapEntry color="#F57C20" quantity="45" label="30 - 45"/><ColorMapEntry color="#FF0000" quantity="88" label="45 - 88"/></ColorMap></RasterSymbolizer></Rule></FeatureTypeStyle></UserStyle></NamedLayer></StyledLayerDescriptor>`;

const sloplayer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_ip,
        params: { 'LAYERS': 'uk_sfd:srtm_slop_GCS', 'FORMAT': 'image/png', 'VERSION': '1.1.0', 'SRS': 'EPSG:4326', 'SLD_BODY': slopeSLD },
        ratio: 1, crossOrigin: 'anonymous'
    })
});

function parseRasterValue(text) {
    const m = text.match(/[-+]?[0-9]*\.?[0-9]+/);
    return m ? Math.round(Number(m[0])) : null;
}

// ==================== CHART HELPERS ====================

function bindchartSecondinjs(lbls2, vals2) {
    const labels = lbls2.split(",");
    const dataValues = vals2.split(",").map(Number);
    const ctx = document.getElementById('donutChartdiversity');
    if (!ctx) return;
    const colors = ["#9c27b0", "#f44336", "#00bcd4", "#ffeb3b", "#795548", "#e91e63", "#3f51b5", "#2196f3", "#ff9800", "#8bc34a"];
    new Chart(ctx.getContext('2d'), {
        type: 'doughnut',
        data: { labels, datasets: [{ data: dataValues, backgroundColor: colors, borderColor: '#fff', borderWidth: 2, hoverOffset: 25 }] },
        options: {
            responsive: true, cutout: '60%',
            plugins: { title: { display: true, text: 'Species Diversity', font: { size: 18, weight: 'bold' }, color: '#333', padding: { top: 10, bottom: 30 } }, legend: { position: 'bottom' } }
        }
    });
}

function bindchartthirdinjs(strplantationyear, strplantationcount, strplantationsitearea, strplantationcovered) {
    const years = strplantationyear.split(",").map(Number);
    const plantcount = strplantationcount.split(",").map(Number);
    const plantationArea = strplantationsitearea.split(",").map(Number);
    const coveredArea = strplantationcovered.split(",").map(Number);
    const ctx = document.getElementById('comparisionChart');
    if (!ctx) return;
    new Chart(ctx.getContext('2d'), {
        type: 'bar',
        data: {
            labels: years,
            datasets: [
                { label: 'Total Plantation Area (ha)', data: plantationArea, backgroundColor: '#4CAF50' },
                { label: 'Total Covered Area (ha)', data: coveredArea, backgroundColor: '#2196F3' },
                { label: 'No of Plantation', data: plantcount, backgroundColor: '#fc96F3' }
            ]
        },
        options: {
            responsive: true,
            plugins: { title: { display: true, text: 'Yearly Plantation Profile', font: { size: 18 } }, legend: { position: 'bottom' } },
            scales: {
                y: { beginAtZero: true, title: { display: true, text: 'Area in Hectares' } },
                x: { title: { display: true, text: 'Year' } }
            }
        }
    });
}

console.log("✅ firedashboard.js loaded with FSI API integration + zero-count legend support");



function downloadExcel() {

    if (!alldata || alldata.length === 0) {
        alert("No data available to download");
        return;
    }

    // 🔹 Convert alldata into flat JSON (important for Excel)
    let excelData = alldata.map(item => ({
        ID: item.id,
        FireDate: item.firedate,
        IncidentRF: item.incidentnoinrf,
        AffectedRFArea: item.affectedrfareaha,
        CivilSoyamIncident: item.incidentnooincivilsoyam,
        CivilSoyamArea: item.affectedcivilsoyam,
        PlantationArea: item.plantationaffectedarea,
        Leesaghao: item.leesaghaoaffected,
        PersonWounded: item.personwounded,
        PersonDead: item.persondead,
        AnimalWounded: item.animalwounded,
        AnimalDead: item.animaldead,

        // Nested objects (flattened)
        Zone: item.zone?.title || "",
        Circle: item.circle?.title || "",
        Division: item.division?.name || "",

        // Coordinates
        Lat_Degree: item.lat_degree,
        Lat_Minutes: item.lat_minutes,
        Lat_Seconds: item.lat_seconds,
        Long_Degree: item.long_degree,
        Long_Minutes: item.long_minutes,
        Long_Seconds: item.long_seconds
    }));

    // 🔹 Convert JSON → Sheet
    let worksheet = XLSX.utils.json_to_sheet(excelData);

    // 🔹 Create workbook
    let workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "All Data");

    // 🔹 File name with date & time
    let today = new Date();

    let formattedDate = today.getFullYear() + "-" +
        String(today.getMonth() + 1).padStart(2, '0') + "-" +
        String(today.getDate()).padStart(2, '0');

    let time = String(today.getHours()).padStart(2, '0') + "-" +
        String(today.getMinutes()).padStart(2, '0') + "-" +
        String(today.getSeconds()).padStart(2, '0');

    let fileName = "all_data_" + formattedDate + "_" + time + ".xlsx";

    // 🔹 Download file
    XLSX.writeFile(workbook, fileName);
}
function downloadExcelfsi() {

    if (!alldatafsi || alldatafsi.length === 0) {
        alert("No data available to download");
        return;
    }

    // 🔹 Map FSI data correctly
    let excelData = alldatafsi.map(item => ({
        ID: item.id,
        FireDate: item.fire_Date,
        FireTime: item.fire_Time,
        SourceType: item.source_Type,

        Latitude: item.lat,
        Longitude: item.long,

        Latitude_DMS: item.lat1,
        Longitude_DMS: item.long1,

        State: item.state,
        District: item.district,
        Circle: item.circle,
        Division: item.division,
        Range: item.range,
        Block: item.block,
        Beat: item.beat,

        ForestArea: item.rfA_PFA,
        CompartmentNo: item.compartment_No,

        UniqueID: item.unique_ids,
        SmsSent: item.isSmsSent ? "Yes" : "No"
    }));

    // 🔹 Convert JSON → Sheet
    let worksheet = XLSX.utils.json_to_sheet(excelData);

    // 🔹 Create workbook
    let workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "FSI Data");

    // 🔹 File name with date & time
    let today = new Date();

    let formattedDate = today.getFullYear() + "-" +
        String(today.getMonth() + 1).padStart(2, '0') + "-" +
        String(today.getDate()).padStart(2, '0');

    let time = String(today.getHours()).padStart(2, '0') + "-" +
        String(today.getMinutes()).padStart(2, '0') + "-" +
        String(today.getSeconds()).padStart(2, '0');

    let fileName = "fsi_data_" + formattedDate + "_" + time + ".xlsx";

    // 🔹 Download file
    XLSX.writeFile(workbook, fileName);
}