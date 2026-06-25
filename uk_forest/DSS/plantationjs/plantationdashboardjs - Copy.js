var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";
var sentinel2fcckey = "f78e28ba-2615-43b9-8532-9c68247a3c7b";
var sentinel2ncckey = "f78e28ba-2615-43b9-8532-9c68247a3c7b";

// ==================== PLANTATION API CONFIG ====================
const PLANTATION_API_URL = "https://api.uttarakhandforestmis.in/plantations";
const PLANTATION_API_KEY = "CF9toR4XiUCIylP9A0ljsaYoBuarqqAvPejP3UrmTgBtoWocJi4Ff3Uxxq9OYc5thSrbBIOwZzhsye7KWC44UHwf0SufIpc6bqgIyb8epI1teYYVlloUYMpPjwBKsX2fipFsHAFYx09p6gxYzbDc4DzTC2XGq9K96UeokYMVeUyf9QIi3HPR5G9j4Hv2a2rVXhSJ";

// Cache
let _plantationApiData = null;
let _plantationApiLoading = false;
let _plantationApiDataLoaded = false;
var vectorSource;
// ==================== MAP ====================
const map = new ol.Map({
    target: 'map',
    layers: [new ol.layer.Tile({ source: new ol.source.OSM() })],
    view: new ol.View({ center: ol.proj.fromLonLat([78.25, 30.25]), zoom: 7 })
});

let currentFilteredLayer = null;
bindcurrentdate();

function bindcurrentdate() {
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('date').value = today;
}

let infoOverlay;
let mapClickListener;

// ==================== FUZZY MATCH ====================
function fuzzyMatch(apiValue, filterValue) {
    if (!filterValue || filterValue === 'All') return true;
    if (!apiValue) return false;
    const a = apiValue.trim().toUpperCase();
    const f = filterValue.trim().toUpperCase();
    return a === f || a.includes(f) || f.includes(a);
}


async function fetchPlantationApiData() {
    debugLog('fetchPlantationApiData called', `already loaded: ${_plantationApiData !== null}`);

    if (_plantationApiData !== null) {
        debugLog('Returning cached data', `records: ${_plantationApiData.length}`);
        return _plantationApiData;
    }
    if (_plantationApiLoading) {
        debugLog('Already loading, waiting...');
        await new Promise(resolve => {
            const check = setInterval(() => {
                if (!_plantationApiLoading) { clearInterval(check); resolve(); }
            }, 100);
        });
        return _plantationApiData;
    }

    _plantationApiLoading = true;
    debugLog('Fetching from API...', PLANTATION_API_URL);

    try {
        const response = await fetch(PLANTATION_API_URL, {
            method: 'GET',
            headers: {
                'Authorization': PLANTATION_API_KEY,
                'Content-Type': 'application/json'
            }
        });

        debugLog('API Response status', response.status);

        if (!response.ok) throw new Error(`API error: ${response.status}`);

        const data = await response.json();
        debugLog('API Raw data received', `type: ${typeof data}, isArray: ${Array.isArray(data)}, length: ${Array.isArray(data) ? data.length : 'N/A'}`);
        let apiresponsedata = JSON.stringify(data[0] || {});
        debugLog('First record sample', JSON.stringify(data[0] || {}));

        _plantationApiData = Array.isArray(data) ? data : [];
        _plantationApiDataLoaded = true;
        showPlantationOnMap(apiresponsedata);
        console.log("----------------------------" + apiresponsedata);
        debugLog('API Load SUCCESS', `Total records: ${_plantationApiData.length}`);

    } catch (err) {
        debugLog('API FETCH FAILED ❌', err.message);
        console.error('Full error:', err);
        _plantationApiData = [];
        _plantationApiDataLoaded = false;
        showApiErrorToast('Plantation API not responding. Charts may show limited data.');
    } finally {
        _plantationApiLoading = false;
    }
    return _plantationApiData;
}
function showPlantationOnMap(data) {

    console.log("Incoming data:", data);
    console.log("Type:", typeof data);

    // ✅ Step 1: Handle string safely
    if (typeof data === "string") {
        try {
            data = JSON.parse(data);
        } catch (e) {
            console.error("❌ Invalid JSON string:", data);
            return;
        }
    }

    // ✅ Step 2: Handle null / invalid types
    if (!data || typeof data !== "object") {
        console.error("❌ Data is not a valid object:", data);
        return;
    }

    // ✅ Step 3: Extract lat/lon safely (handles different key names)
    const lat = parseFloat(
        data.latitude || data.lat || data.y || null
    );

    const lon = parseFloat(
        data.longitude || data.lng || data.lon || data.x || null
    );

    if (isNaN(lat) || isNaN(lon)) {
        console.error("❌ Invalid or missing latitude/longitude:", data);
        return;
    }

    console.log("✅ Using Coordinates:", lat, lon);

    // ✅ Convert coordinates
    const coords = ol.proj.fromLonLat([lon, lat]);

    // ✅ Create marker
    const marker = new ol.Feature({
        geometry: new ol.geom.Point(coords),
        data: data
    });

    // ✅ Style
    marker.setStyle(new ol.style.Style({
        image: new ol.style.Icon({
            src: "https://cdn-icons-png.flaticon.com/512/684/684908.png",
            scale: 0.05
        })
    }));

    // ✅ Clear old + add new
    vectorSource.clear();
    vectorSource.addFeature(marker);

    // ✅ Center map
    //map.getView().setCenter(coords);
    //map.getView().setZoom(13);
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

// ==================== ERROR TOAST ====================
function showApiErrorToast(message) {
    let toast = document.getElementById('plantationApiErrorToast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'plantationApiErrorToast';
        toast.style.cssText = `
            display:none; position:fixed; top:20px; right:20px; z-index:9999;
            background:#fff3cd; border:1px solid #ffc107; border-left:5px solid #dc3545;
            border-radius:8px; padding:14px 18px; min-width:320px; max-width:420px;
            box-shadow:0 4px 12px rgba(0,0,0,0.15); font-size:14px;
        `;
        toast.innerHTML = `
            <div style="display:flex;align-items:flex-start;gap:10px;">
                <span style="font-size:20px;">⚠️</span>
                <div style="flex:1;">
                    <strong style="color:#dc3545;display:block;margin-bottom:4px;">API Not Responding</strong>
                    <span id="plantationApiErrorMsg" style="color:#555;"></span>
                </div>
                <button onclick="this.closest('#plantationApiErrorToast').style.display='none';"
                    style="background:none;border:none;font-size:18px;cursor:pointer;color:#888;padding:0;line-height:1;">✖</button>
            </div>`;
        document.body.appendChild(toast);
    }
    document.getElementById('plantationApiErrorMsg').textContent = message || 'API not responding.';
    toast.style.display = 'block';
    setTimeout(() => { toast.style.display = 'none'; }, 6000);
}

// ==================== GET CURRENT FILTERS ====================

function getCurrentFilters() {
    return {
        division: document.getElementById('division') ? document.getElementById('division').value : 'All',
        range: document.getElementById('range') ? document.getElementById('range').value : 'All',
        plantation: document.getElementById('ddlplantation') ? document.getElementById('ddlplantation').value : 'All',
    };
}

// ==================== FILTER API DATA ====================
function filterApiData(data, selectedYears) {
    const f = getCurrentFilters();
    return data.filter(item => {
        if (f.division && f.division !== 'All') {
            if (!fuzzyMatch(item.division_name, f.division)) return false;
        }
        if (f.range && f.range !== 'All') {
            if (!fuzzyMatch(item.range_name_eng, f.range)) return false;
        }
        if (f.plantation && f.plantation !== 'All') {
            if (!fuzzyMatch(item.plantation_name, f.plantation)) return false;
        }
        if (selectedYears && selectedYears.length > 0) {
            if (!selectedYears.includes(String(item.plantation_year))) return false;
        }
        return true;
    });
}

async function populatePlantationSiteDropdown() {
    const ddl = document.getElementById('ddlplantation');
    if (!ddl) return;

    const data = await fetchPlantationApiData();
    const f = getCurrentFilters();

    const filtered = data.filter(item => {
        if (f.division && f.division !== 'All') {
            if (!fuzzyMatch(item.division_name, f.division)) return false;
        }
        if (f.range && f.range !== 'All') {
            if (!fuzzyMatch(item.range_name_eng, f.range)) return false;
        }
        return true;
    });

    const uniqueSites = [...new Set(filtered.map(d => d.plantation_name).filter(Boolean))].sort();
    console.log('Plantation sites from API:', uniqueSites);

    const currentVal = ddl.value;
    ddl.innerHTML = '<option value="All">All</option>';
    uniqueSites.forEach(name => {
        const opt = document.createElement('option');
        opt.value = name;
        opt.textContent = name;
        ddl.appendChild(opt);
    });

    if (currentVal && [...ddl.options].some(o => o.value === currentVal)) {
        ddl.value = currentVal;
    }
}

async function populatePlantationYearDropdown() {
    const container = document.getElementById('dropdownPanel');
    if (!container) return;

    const data = await fetchPlantationApiData();

    const uniqueYears = [...new Set(data.map(d => d.plantation_year).filter(Boolean))]
        .sort()
        .reverse();

    console.log('Plantation years from API:', uniqueYears);

    const chkdatelist = document.getElementById('chkdatelist');
    if (chkdatelist) {
        chkdatelist.innerHTML = ''; 

        uniqueYears.forEach(year => {
            const label = document.createElement('label');
            label.innerHTML = `<input type="checkbox" value="${year}"> ${year}`;
            chkdatelist.appendChild(label);
        });
    }

    let apiYearDiv = document.getElementById('apiYearDropdownList');
    if (apiYearDiv) apiYearDiv.innerHTML = '';
}



function getSelectedYears() {
    const checkboxes = document.querySelectorAll('#chkdatelist input[type="checkbox"]');
    const selected = [];
    checkboxes.forEach(cb => { if (cb.checked) selected.push(cb.value); });
    return selected;
}


let chrt_doughnutChart;
function renderTargetAchievedChart(data) {
    const canvas = document.getElementById('doughnutChart');
    if (!canvas) return;

    const totalTarget = data.reduce((sum, d) => sum + (parseFloat(d.area_total) || 0), 0);
    const totalActual = data.reduce((sum, d) => sum + (parseFloat(d.area_actual) || 0), 0);

    if (totalTarget === 0 && totalActual === 0) { showNoDataImage('doughnutChart'); return; }

    canvas.style.display = '';
    const existingImg = canvas.parentElement && canvas.parentElement.querySelector('.no-data-image');
    if (existingImg) existingImg.remove();

    const ctx = canvas.getContext('2d');
    if (chrt_doughnutChart) chrt_doughnutChart.destroy();

    chrt_doughnutChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Target Plantation (ha)', 'Achieved Plantation (ha)'],
            datasets: [{
                data: [parseFloat(totalTarget.toFixed(2)), parseFloat(totalActual.toFixed(2))],
                backgroundColor: ['#2196F3', '#4CAF50'],
                borderWidth: 1, borderColor: '#fff', hoverOffset: 30
            }]
        },
        options: {
            responsive: true, cutout: '65%',
            plugins: {
                title: {
                    display: true,
                    text: 'Target Plantation vs Achieved Plantation',
                    font: { size: 14, weight: 'bold' }, color: '#333',
                    padding: { top: 10, bottom: 20 }
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            const total = totalTarget + totalActual;
                            const value = context.parsed;
                            const pct = total > 0 ? ((value / total) * 100).toFixed(2) : '0.00';
                            return `${context.label}: ${Number(value).toLocaleString()} ha (${pct}%)`;
                        }
                    }
                },
                legend: { position: 'bottom', labels: { font: { size: 12, weight: '600' }, color: '#333' } }
            }
        }
    });
}

// ==================== CHART 2: SPECIES DIVERSITY — scheme_name use karo ====================
let chrt_donutChartdiversity;
function renderSpeciesDiversityChart(data) {
    const canvas = document.getElementById('donutChartdiversity');
    if (!canvas) return;

    const schemeMap = {};
    data.forEach(d => {
        const key = d.scheme_name || 'Unknown';
        schemeMap[key] = (schemeMap[key] || 0) + (parseFloat(d.area_actual) || 0);
    });

    const entries = Object.entries(schemeMap).sort((a, b) => b[1] - a[1]).slice(0, 10);
    if (entries.length === 0) { showNoDataImage('donutChartdiversity'); return; }

    canvas.style.display = '';
    const existingImg = canvas.parentElement && canvas.parentElement.querySelector('.no-data-image');
    if (existingImg) existingImg.remove();

    const labels = entries.map(e => e[0]);
    const values = entries.map(e => parseFloat(e[1].toFixed(2)));
    const backgroundColors = [
        "#9c27b0", "#f44336", "#00bcd4", "#ffeb3b", "#795548",
        "#e91e63", "#3f51b5", "#2196f3", "#ff9800", "#8bc34a"
    ];

    const ctx = canvas.getContext('2d');
    if (chrt_donutChartdiversity) chrt_donutChartdiversity.destroy();

    chrt_donutChartdiversity = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels,
            datasets: [{
                data: values,
                backgroundColor: backgroundColors,
                borderColor: '#fff', borderWidth: 2, hoverOffset: 25
            }]
        },
        options: {
            responsive: true, cutout: '60%',
            plugins: {
                title: {
                    display: true, text: 'Species Diversity (by Scheme)',
                    font: { size: 14, weight: 'bold' }, color: '#333',
                    padding: { top: 10, bottom: 20 }
                },
                legend: {
                    position: 'bottom',
                    labels: {
                        font: { size: 11, weight: '600' }, color: '#333',
                        boxWidth: 16, padding: 10,
                        generateLabels: function (chart) {
                            const dataset = chart.data.datasets[0];
                            const total = dataset.data.reduce((a, b) => a + b, 0);
                            return chart.data.labels.map((label, i) => {
                                const value = dataset.data[i];
                                const pct = total > 0 ? ((value / total) * 100).toFixed(1) : '0.0';
                                return {
                                    text: `${label} (${pct}%)`,
                                    fillStyle: dataset.backgroundColor[i],
                                    strokeStyle: '#fff', lineWidth: 2, hidden: false, index: i
                                };
                            });
                        }
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const pct = total > 0 ? ((context.parsed / total) * 100).toFixed(2) : '0.00';
                            return `${context.label}: ${context.parsed.toLocaleString()} ha (${pct}%)`;
                        }
                    }
                }
            }
        }
    });
}

// ==================== CHART 3: YEARLY PLANTATION PROFILE ====================
let chrt_comparisionChart;
function renderYearlyPlantationChart(data) {
    const canvas = document.getElementById('comparisionChart');
    if (!canvas) return;

    const yearMap = {};
    data.forEach(d => {
        const yr = d.plantation_year || 'Unknown';
        if (!yearMap[yr]) yearMap[yr] = { count: 0, target: 0, actual: 0 };
        yearMap[yr].count += 1;
        yearMap[yr].target += parseFloat(d.area_total) || 0;
        yearMap[yr].actual += parseFloat(d.area_actual) || 0;
    });

    const years = Object.keys(yearMap).sort();
    if (years.length === 0) { showNoDataImage('comparisionChart'); return; }

    canvas.style.display = '';
    const existingImg = canvas.parentElement && canvas.parentElement.querySelector('.no-data-image');
    if (existingImg) existingImg.remove();

    const targetArr = years.map(y => parseFloat(yearMap[y].target.toFixed(2)));
    const actualArr = years.map(y => parseFloat(yearMap[y].actual.toFixed(2)));
    const countArr = years.map(y => yearMap[y].count);

    const ctx = canvas.getContext('2d');
    if (chrt_comparisionChart) chrt_comparisionChart.destroy();

    chrt_comparisionChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: years,
            datasets: [
                {
                    label: 'Target Plantation',
                    data: targetArr,
                    backgroundColor: '#2196F3'
                },
                {
                    label: 'Achieved Plantation',
                    data: actualArr,
                    backgroundColor: '#4CAF50'
                },
                {
                    label: 'No of Plantation',
                    data: countArr,
                    backgroundColor: '#fc96F3'
                }
            ]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: 'Yearly Plantation Profile',
                    font: { size: 18 }
                },
                legend: { position: 'bottom' },
                tooltip: { mode: 'index', intersect: false }
            },
            interaction: {
                mode: 'nearest',
                axis: 'x',
                intersect: false
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: { display: true, text: 'Count (in thousand)' }
                },
                x: {
                    title: { display: true, text: 'Year' }
                }
            }
        }
    });
}

// ==================== CHART 4: REGION-WISE PLANTATION INSIGHTS ====================
let chrt_chartplantationandnursery;
function renderRegionWiseChart(data) {
    const canvas = document.getElementById('chartplantationandnursery');
    if (!canvas) return;

    const f = getCurrentFilters();
    let groupField, groupLabel;

    if (f.plantation && f.plantation !== 'All') {
        groupField = 'range_name_eng'; groupLabel = 'Range';
    } else if (f.range && f.range !== 'All') {
        groupField = 'plantation_name'; groupLabel = 'Plantation Site';
    } else if (f.division && f.division !== 'All') {
        groupField = 'range_name_eng'; groupLabel = 'Range';
    } else {
        groupField = 'division_name'; groupLabel = 'Division';
    }

    const regionMap = {};
    data.forEach(d => {
        const key = d[groupField] || 'Unknown';
        if (!regionMap[key]) regionMap[key] = { count: 0, target: 0, actual: 0 };
        regionMap[key].count += 1;
        regionMap[key].target += parseFloat(d.area_total) || 0;
        regionMap[key].actual += parseFloat(d.area_actual) || 0;
    });

    const regions = Object.keys(regionMap).sort();
    if (regions.length === 0) { showNoDataImage('chartplantationandnursery'); return; }

    canvas.style.display = '';
    const existingImg = canvas.parentElement && canvas.parentElement.querySelector('.no-data-image');
    if (existingImg) existingImg.remove();

    const targetArr = regions.map(r => parseFloat(regionMap[r].target.toFixed(2)));
    const actualArr = regions.map(r => parseFloat(regionMap[r].actual.toFixed(2)));
    const countArr = regions.map(r => regionMap[r].count);

    const ctx = canvas.getContext('2d');
    if (chrt_chartplantationandnursery) chrt_chartplantationandnursery.destroy();

    chrt_chartplantationandnursery = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: regions,
            datasets: [
                {
                    label: 'Target Plantation',
                    data: targetArr,
                    backgroundColor: '#2196F3'
                },
                {
                    label: 'Achieved Plantation',
                    data: actualArr,
                    backgroundColor: '#4CAF50'
                },
                {
                    label: 'No of Plantation(in Thousand)',
                    data: countArr,
                    backgroundColor: '#fc96F3'
                }
            ]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: 'Region-wise Plantation Insights',
                    font: { size: 14 }
                },
                legend: { position: 'bottom' },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                    footerFontStyle: 'bold'
                }
            },
            interaction: {
                mode: 'nearest',
                axis: 'x',
                intersect: false
            },
            scales: {
                x: {
                    title: { display: true, text: 'Region' }
                },
                y: {
                    beginAtZero: true,
                    title: { display: true, text: 'Values (Area in Ha / Count)' }
                }
            }
        }
    });
}



async function renderApiCharts() {
    debugLog('renderApiCharts called');
    debugLog('window._plantationApiData exists?', !!(window._plantationApiData));
    debugLog('_plantationApiData exists?', !!(_plantationApiData));

    if (window._plantationApiData && window._plantationApiData.length > 0) {
        _plantationApiData = window._plantationApiData;
        _plantationApiDataLoaded = true;
        debugLog('Using window._plantationApiData', `records: ${_plantationApiData.length}`);
    } else {
        debugLog('Fetching fresh API data...');
        await fetchPlantationApiData();
    }

    debugLog('_plantationApiDataLoaded', _plantationApiDataLoaded);
    debugLog('_plantationApiData length', _plantationApiData ? _plantationApiData.length : 'null');

    if (!_plantationApiData || _plantationApiData.length === 0) {
        debugLog('NO API DATA ❌ - charts will not render from API');
        return;
    }

    const selectedYears = getSelectedYears();
    debugLog('Selected years', selectedYears);

    const filtered = filterApiData(_plantationApiData, selectedYears);
    const filteredNoYear = filterApiData(_plantationApiData, []);

    debugLog('Filtered data length', filtered.length);
    debugLog('FilteredNoYear length', filteredNoYear.length);

    debugLog('Calling renderTargetAchievedChart...');
    renderTargetAchievedChart(filtered);

    debugLog('Calling renderSpeciesDiversityChart...');
    renderSpeciesDiversityChart(filtered);

    debugLog('Calling renderYearlyPlantationChart...');
    renderYearlyPlantationChart(filteredNoYear);

    debugLog('Calling renderRegionWiseChart...');
    renderRegionWiseChart(filtered);

    debugLog('All charts render calls done ✅');
}


// ==================== WFS URL BUILDER ====================
function buildWFSUrl(zone,circle,division, range, plant_id, area, selectedYears) {
    const baseUrl = "https://ukforestgis.in/geoserver/uk_sfd/ows";
    const params = new URLSearchParams({
        service: "WFS", version: "1.0.0", request: "GetFeature",
        typeName: "uk_sfd:tbl_plant_species", outputFormat: "application/json"
    });

    let filters = [];
    if (zone !== "All") filters.push(`zone='${zone}'`);
    if (circle !== "All") filters.push(`circle='${circle}'`);
    if (division !== "All") filters.push(`division='${division}'`);
    if (range !== "All") filters.push(`range='${range}'`);

 

    if (plant_id !== "All") {
        filters.push(`plantation_site_name LIKE '%${encodeURIComponent(plant_id).replace(/%20/g, '%20')}%'`);
    }

    if (area !== "All") {
        const arr = area.trim().split(" ");
        if (arr.length === 2) {
            if (arr[0] === "<") filters.push(`plantation_site_area < ${arr[1]}`);
            else if (arr[0] === ">") filters.push(`plantation_site_area > ${arr[1]}`);
        } else if (arr.length >= 5) {
            filters.push(`plantation_site_area > ${arr[1]} AND plantation_site_area < ${arr[4]}`);
        }
    }

    if (Array.isArray(selectedYears) && selectedYears.length > 0) {
        filters.push(`plantation_year IN (${selectedYears.map(y => `'${y}'`).join(",")})`);
    }

    if (filters.length > 0) {
        params.set("CQL_FILTER", filters.join(" AND "));
        showBoundary(filters[filters.length - 1]);
    }

  
    console.log("WFS URL: " + `${baseUrl}?${params.toString()}`);
    return `${baseUrl}?${params.toString()}`;
}

function debugLog(step, data) {
    const style = 'background: #222; color: #bada55; padding: 2px 6px; border-radius: 3px;';
    //console.log(`%c[PLANTATION DEBUG] ${step}`, style, data || '');
}

// ==================== APPLY FILTER (Map + Charts) ====================
function applyfilter() {
    const zone = document.getElementById("ddlzone") ? document.getElementById("ddlzone").value : 'All';
    const circle = document.getElementById("ddlcircle") ? document.getElementById("ddlcircle").value : 'All';
    const division = document.getElementById("division") ? document.getElementById("division").value : 'All';
    const range = document.getElementById("range") ? document.getElementById("range").value : 'All';
    const plant_id = document.getElementById("ddlplantation") ? document.getElementById("ddlplantation").value : 'All';
    const area = document.getElementById("ddlareafilter") ? document.getElementById("ddlareafilter").value : 'All';
    const selectedYears = getSelectedYears();

    const url = buildWFSUrl(zone,circle,division, range, plant_id, area, selectedYears);

    if (!currentFilteredLayer) {
         vectorSource = new ol.source.Vector();
        currentFilteredLayer = new ol.layer.Vector({
            source: vectorSource,
            style: new ol.style.Style({
                stroke: new ol.style.Stroke({ color: 'green', width: 2 }),
                fill: new ol.style.Fill({ color: 'rgba(0, 255, 0, 0.3)' })
            })
        });
        map.addLayer(currentFilteredLayer);
    }

     vectorSource = currentFilteredLayer.getSource();
    vectorSource.clear();

    fetch(url)
        .then(r => {
            if (!r.ok) throw new Error("Network error: " + r.status);
            return r.json();
        })
        .then(data => {
            const features = new ol.format.GeoJSON().readFeatures(data, {
                featureProjection: map.getView().getProjection()
            });
           //vectorSource.addFeatures(features);
            if (features.length > 0) {
                map.getView().fit(vectorSource.getExtent(), { duration: 1000 });
                map.updateSize();
            }
        })
        .catch(err => console.error('WFS error:', err));

    // API charts refresh
    renderApiCharts();
    populatePlantationSiteDropdown();
}

async function getfeatures() {
    const division = document.getElementById("division") ? document.getElementById("division").value : 'All';
    const range = document.getElementById("range") ? document.getElementById("range").value : 'All';
    const plant_id = document.getElementById("ddlplantation") ? document.getElementById("ddlplantation").value : 'All';
    const area = document.getElementById("ddlareafilter") ? document.getElementById("ddlareafilter").value : 'All';
    const selectedYears = getSelectedYears();
    const url = buildWFSUrl(division, range, plant_id, area, selectedYears);

    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error("Network error");
        const data = await response.json();
        return new ol.format.GeoJSON().readFeatures(data, { featureProjection: map.getView().getProjection() });
    } catch (err) {
        console.error("WFS features error:", err);
        return [];
    }
}

// ==================== WEATHER ====================
const apiKey = '6b8642d4547db03dea15d468a029168b';

async function getWeather(lat, lon) {
    const url = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}&units=metric&lang=hi`;
    try {
        const res = await fetch(url);
        if (!res.ok) throw new Error('मौसम डेटा लोड नहीं हो सका');
        return await res.json();
    } catch (err) { return { error: err.message }; }
}

async function fetchWeather(lat, lon) {
    const data = await getWeather(lat, lon);
    if (data.error) {
        document.getElementById('weatherTableContainer').innerHTML = `<p style="color:red;">Error: ${data.error}</p>`;
        return;
    }
    createTable(data);
}

function createWeatherTable(weatherData) {
    const weatherContainer = document.createElement('div');
    const table = document.createElement('table');
    table.style.cssText = 'border-collapse:collapse;width:100%;margin-top:10px;';

    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');
    ['मापदंड (Parameter)', 'मान (Value)'].forEach(text => {
        const th = document.createElement('th');
        th.textContent = text;
        th.style.cssText = 'border:1px solid #ccc;padding:6px;background:#e0f7fa;text-align:left;';
        headerRow.appendChild(th);
    });
    thead.appendChild(headerRow);
    table.appendChild(thead);

    const tbody = document.createElement('tbody');
    [
        { label: "तापमान (°C)", value: weatherData.main.temp },
        { label: "नमी (%)", value: weatherData.main.humidity },
        { label: "वायु का दबाव (hPa)", value: weatherData.main.pressure },
        { label: "हवा की गति (m/s)", value: weatherData.wind.speed },
        { label: "मौसम विवरण", value: weatherData.weather[0].description }
    ].forEach(row => {
        const tr = document.createElement('tr');
        const tdL = document.createElement('td'); tdL.textContent = row.label; tdL.style.cssText = 'border:1px solid #ccc;padding:5px;';
        const tdV = document.createElement('td'); tdV.textContent = row.value; tdV.style.cssText = 'border:1px solid #ccc;padding:5px;';
        tr.appendChild(tdL); tr.appendChild(tdV); tbody.appendChild(tr);
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
        default: throw new Error('Invalid type');
    }
}

//function showInfo(feature) {
//    const props = feature.getProperties();
//    document.getElementById("loader").style.display = "block";

//    function formatLabel(key) {
//        return key.replace(/[_-]/g, ' ').replace(/([a-z])([A-Z])/g, '$1 $2')
//            .toLowerCase().split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
//    }

//    if (infoOverlay) { map.removeOverlay(infoOverlay); infoOverlay = null; }

//    const container = document.createElement('div');
//    container.style.cssText = 'position:absolute;top:10px;left:50%;transform:translateX(-50%);background:white;padding:10px;border:1px solid black;border-radius:5px;min-width:250px;max-height:300px;overflow-y:auto;box-shadow:0 1px 4px rgba(0,0,0,0.3);z-index:1000;cursor:move;';
//    container.id = 'informationpopup';

//    const closeBtn = document.createElement('button');
//    closeBtn.innerHTML = '&#x2715;';
//    closeBtn.type = 'button';
//    closeBtn.style.cssText = 'position:absolute;top:5px;right:5px;border:none;background:transparent;font-size:16px;cursor:pointer;color:#333;';
//    closeBtn.onclick = () => { if (infoOverlay) { infoOverlay.setPosition(undefined); map.removeLayer(highlightLayer); infoOverlay = null; } };
//    container.appendChild(closeBtn);

//    const table = document.createElement('table');
//    table.id = "featureInfo";
//    table.style.cssText = 'border-collapse:collapse;width:100%;margin-top:20px;cursor:pointer;';

//    const thead = document.createElement('thead');
//    const headerRow = document.createElement('tr');
//    ['Property', 'Value'].forEach(text => {
//        const th = document.createElement('th');
//        th.textContent = text;
//        th.style.cssText = 'border:1px solid #ccc;padding:6px;background:#f0f0f0;font-weight:bold;text-align:left;';
//        headerRow.appendChild(th);
//    });
//    thead.appendChild(headerRow);
//    table.appendChild(thead);

//    const tbody = document.createElement('tbody');
//    Object.entries(props).filter(([key]) => !['geometry', 'soil', 'slope'].includes(key)).forEach(([key, val]) => {
//        const row = document.createElement('tr');
//        const keyCell = document.createElement('td');
//        keyCell.textContent = formatLabel(key);
//        keyCell.style.cssText = 'border:1px solid #ccc;padding:4px;';
//        if (['plantation_site_area', 'covered_area', 'no_of_plantation'].includes(key)) {
//            const areaparam = getSelectedAreaOption();
//            if (areaparam === "hactare") {
//                val = Number(val.toFixed(2));
//                val = val + (key === "no_of_plantation" ? " Count per ha" : " ha");
//            } else if (areaparam === "acre" || areaparam === "sqm") {
//                val = convertHectare(val, areaparam);
//                val = Number(val.toFixed(2)) + " " + areaparam;
//            }
//        }
//        const valCell = document.createElement('td');
//        valCell.textContent = val;
//        valCell.style.cssText = 'border:1px solid #ccc;padding:4px;';
//        row.appendChild(keyCell); row.appendChild(valCell); tbody.appendChild(row);
//    });
//    table.appendChild(tbody);
//    container.appendChild(table);

//    const button4 = document.createElement("button");
//    button4.textContent = "Analysis"; button4.id = "btnadded"; button4.type = "button";
//    button4.addEventListener("click", () => { window.location.href = "analysis.aspx"; });
//    container.appendChild(button4);

//    thead.querySelectorAll('th').forEach((th, index) => {
//        let asc = true;
//        th.style.cursor = 'pointer';
//        th.addEventListener('click', () => {
//            const rowsArray = Array.from(tbody.querySelectorAll('tr'));
//            rowsArray.sort((a, b) => {
//                const cellA = a.cells[index].textContent.toLowerCase();
//                const cellB = b.cells[index].textContent.toLowerCase();
//                return asc ? cellA.localeCompare(cellB) : cellB.localeCompare(cellA);
//            });
//            rowsArray.forEach(r => tbody.appendChild(r));
//            asc = !asc;
//        });
//    });

//    const geometry = feature.getGeometry();
//    const geometryType = geometry.getType();
//    let coords;
//    if (geometryType === 'MultiPolygon') {
//        coords = geometry.getCoordinates()?.[0]?.[0]?.[0];
//    }

//    if (coords && Array.isArray(coords) && coords.length === 2) {
//        const [lon, lat] = ol.proj.transform(coords, 'EPSG:3857', 'EPSG:4326');
//        getWeather(lat, lon).then(data => {
//            if (!data.error) {
//                const hr = document.createElement('hr'); hr.style.margin = '10px 0';
//                const h4 = document.createElement('h4'); h4.textContent = "🌦️ मौसम जानकारी";
//                const spn = document.createElement('span'); spn.textContent = "(Source : Open Weather Map)";
//                container.appendChild(hr); container.appendChild(h4); container.appendChild(spn);
//                container.appendChild(createWeatherTable(data));
//            }
//        });
//    }

//    infoOverlay = new ol.Overlay({ element: container, positioning: 'top-center', stopEvent: true, autoPan: false });
//    map.addOverlay(infoOverlay);
//    infoOverlay.setPosition(map.getView().getCenter());

//    let isDragging = false, startX, startY, origLeft, origTop;
//    container.addEventListener('mousedown', e => {
//        if (e.target === closeBtn) return;
//        isDragging = true; startX = e.clientX; startY = e.clientY;
//        const style = window.getComputedStyle(container);
//        origLeft = parseInt(style.left, 10); origTop = parseInt(style.top, 10);
//        document.body.style.userSelect = 'none';
//    });
//    window.addEventListener('mousemove', e => {
//        if (!isDragging) return;
//        container.style.left = (origLeft + e.clientX - startX) + 'px';
//        container.style.top = (origTop + e.clientY - startY) + 'px';
//        container.style.transform = 'none';
//    });
//    window.addEventListener('mouseup', () => { isDragging = false; document.body.style.userSelect = ''; });

//    document.getElementById("loader").style.display = "none";
//}

function showInfo(feature) {
    let props = feature.getProperties();
    console.log("Original Props:", props);

    // ✅ Flatten nested object
    if (props.data && typeof props.data === 'object') {
        props = props.data;
    } else if (
        Object.values(props).length === 1 &&
        typeof Object.values(props)[0] === 'object'
    ) {
        props = Object.values(props)[0];
    }

    document.getElementById("loader").style.display = "block";

    function formatLabel(key) {
        return key.replace(/[_-]/g, ' ')
            .replace(/([a-z])([A-Z])/g, '$1 $2')
            .toLowerCase()
            .split(' ')
            .map(w => w.charAt(0).toUpperCase() + w.slice(1))
            .join(' ');
    }

    if (infoOverlay) {
        map.removeOverlay(infoOverlay);
        infoOverlay = null;
    }

    const container = document.createElement('div');
    container.style.cssText = `
        position:absolute;
        top:10px;
        left:50%;
        transform:translateX(-50%);
        background:white;
        padding:10px;
        border:1px solid black;
        border-radius:5px;
        min-width:250px;
        max-height:300px;
        overflow-y:auto;
        box-shadow:0 1px 4px rgba(0,0,0,0.3);
        z-index:1000;
        cursor:move;
    `;

    const closeBtn = document.createElement('button');
    closeBtn.innerHTML = '✕';
    closeBtn.type = 'button';
    closeBtn.style.cssText = `
        position:absolute;
        top:5px;
        right:5px;
        border:none;
        background:transparent;
        font-size:16px;
        cursor:pointer;
    `;
    closeBtn.onclick = () => {
        if (infoOverlay) {
            infoOverlay.setPosition(undefined);
            infoOverlay = null;
        }
    };
    container.appendChild(closeBtn);

    // ✅ TABLE
    const table = document.createElement('table');
    table.style.cssText = `
        border-collapse:collapse;
        width:100%;
        margin-top:20px;
        font-size:12px;
    `;

    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');

    ['Property', 'Value'].forEach(text => {
        const th = document.createElement('th');
        th.textContent = text;
        th.style.cssText = `
            border:1px solid #ccc;
            padding:6px;
            background:#f0f0f0;
            text-align:left;
            cursor:pointer;
        `;
        headerRow.appendChild(th);
    });

    thead.appendChild(headerRow);
    table.appendChild(thead);

    const tbody = document.createElement('tbody');

    Object.entries(props)
        .filter(([key]) => !['geometry', 'soil', 'slope'].includes(key))
        .forEach(([key, val]) => {

            const row = document.createElement('tr');

            const keyCell = document.createElement('td');
            keyCell.textContent = formatLabel(key);
            keyCell.style.cssText = 'border:1px solid #ccc;padding:4px;';

            const valCell = document.createElement('td');

            if (typeof val === 'object' && val !== null) {
                valCell.textContent = JSON.stringify(val);
            } else {
                valCell.textContent = val;
            }

            valCell.style.cssText = 'border:1px solid #ccc;padding:4px;';

            row.appendChild(keyCell);
            row.appendChild(valCell);
            tbody.appendChild(row);
        });

    table.appendChild(tbody);
    container.appendChild(table);


    const button4 = document.createElement("button");
    button4.textContent = "Analysis"; button4.id = "btnadded"; button4.type = "button";
    button4.addEventListener("click", () => { window.location.href = "analysis.aspx"; });
    container.appendChild(button4);
    // ✅ WEATHER (FIXED)
    let lat = null, lon = null;

    // 🔥 1. Use API lat/lon (BEST)
    if (props.latitude && props.longitude) {
        lat = parseFloat(props.latitude);
        lon = parseFloat(props.longitude);
    }
    else {
        // 🔥 2. Fallback to geometry
        const geometry = feature.getGeometry();
        if (geometry) {
            const type = geometry.getType();

            let coords;

            if (type === 'Point') {
                coords = geometry.getCoordinates();
            } else if (type === 'Polygon') {
                coords = geometry.getCoordinates()?.[0]?.[0];
            } else if (type === 'MultiPolygon') {
                coords = geometry.getCoordinates()?.[0]?.[0]?.[0];
            }

            if (coords && coords.length === 2) {
                [lon, lat] = ol.proj.transform(coords, 'EPSG:3857', 'EPSG:4326');
            }
        }
    }

    // ✅ FINAL WEATHER CALL
    if (lat && lon) {
        console.log("Weather Lat Lon:", lat, lon);

        getWeather(lat, lon).then(data => {
            console.log("Weather Data:", data);

            if (!data.error) {
                const hr = document.createElement('hr');

                const h4 = document.createElement('h4');
                h4.textContent = "🌦️ मौसम जानकारी";

                const spn = document.createElement('span');
                spn.textContent = "(Source : Open Weather Map)";

                container.appendChild(hr);
                container.appendChild(h4);
                container.appendChild(spn);
                container.appendChild(createWeatherTable(data));
            }
        });
    }

    // ✅ OVERLAY
    infoOverlay = new ol.Overlay({
        element: container,
        positioning: 'top-center',
        stopEvent: true
    });

    map.addOverlay(infoOverlay);
    infoOverlay.setPosition(map.getView().getCenter());

    document.getElementById("loader").style.display = "none";
}

//async function showSlope(feature) {
//    document.getElementById("loader").style.display = "block";
//    document.getElementById('infoforslop').innerHTML = "";
//    const geom = feature.getGeometry();
//    await getSoilInsidePolygon(geom);
//    await getElevationValuesInsidePolygon(geom);
//    await getSlopeValuesInsidePolygon(geom);
//    document.getElementById("loader").style.display = "none";
//}

async function showSlope(feature) {
    document.getElementById("loader").style.display = "block";
    document.getElementById('infoforslop').innerHTML = "";

    const geom = feature.getGeometry();

    // ✅ Get coordinate
    const coord = getCoordinatesFromGeometry(geom);

    console.log("Coordinate (EPSG:3857):", coord);

    // ✅ Convert to lat/lon
    if (coord) {
        const [lon, lat] = ol.proj.transform(coord, 'EPSG:3857', 'EPSG:4326');
        console.log("Lat Lon:", lat, lon);
    }

    // existing logic
    await getSoilInsidePolygon(geom);
    await getElevationValuesInsidePolygon(geom);
    await getSlopeValuesInsidePolygon(geom);

    document.getElementById("loader").style.display = "none";
}

async function getSlopeValuesInsidePolygon(polygon) {
    const view = map.getView();
    const resolution = view.getResolution();
    const projection = view.getProjection();
    const extent = polygon.getExtent();
    const step = (extent[2] - extent[0]) / 30;
    const values = [];

    for (let x = extent[0]; x <= extent[2]; x += step) {
        for (let y = extent[1]; y <= extent[3]; y += step) {
            const coord = [x, y];
            if (polygon.intersectsCoordinate(coord)) {
                const url = sloplayer.getSource().getGetFeatureInfoUrl(coord, resolution, projection.getCode(), { INFO_FORMAT: 'text/plain', FEATURE_COUNT: 1 });
                if (!url) continue;
                try { const text = await fetch(url).then(r => r.text()); const val = parseRasterValue(text); if (val !== null) values.push(val); } catch (err) { console.error('GFI slope:', err); }
            }
        }
    }

    const infoEl = document.getElementById('infoforslop');
    document.getElementById('slopdivparentid').style.display = "block";
    if (values.length === 0) { infoEl.innerHTML += "<b>Slope inside polygon:</b><br>No values found.<hr/>"; return; }

    const slopeClasses = [
        { range: [0, 10], label: "Flat to Gentle (0–10°)", color: "#6BBE44" },
        { range: [10, 20], label: "Moderate (10–20°)", color: "#E5F94E" },
        { range: [20, 30], label: "Steep (20–30°)", color: "#FDC84E" },
        { range: [30, 45], label: "Very Steep (30–45°)", color: "#F57C20" },
        { range: [45, 88], label: "Extreme Cliff (45–88°)", color: "#FF0000" }
    ];

    const min = Math.min(...values).toFixed(2), max = Math.max(...values).toFixed(2);
    const avg = (values.reduce((a, b) => a + b, 0) / values.length).toFixed(2);
    const counts = slopeClasses.map(c => ({ ...c, count: values.filter(v => v >= c.range[0] && v < c.range[1]).length }));

    let html = `<b><u>Slope (degrees):</u></b><br><span class='setFontFeatureInfo'>(Source : USGS)</span><br>Min: ${min}<br>Max: ${max}<br>Mean: ${avg}<br><b>Class Distribution:</b><br>`;
    counts.forEach(c => {
        const perc = ((c.count / values.length) * 100).toFixed(1);
        html += `<div><span style="display:inline-block;width:20px;height:12px;background:${c.color};border:1px solid #333;margin-right:6px;"></span>${c.label}: (${perc}%)</div>`;
    });
    html += '<hr />';
    infoEl.innerHTML += html;
}

async function getElevationValuesInsidePolygon(feature) {
    const infoElev = document.getElementById('infoforslop');
    const geom = feature;
    const extent = geom.getExtent();
    const step = (extent[2] - extent[0]) / 30;
    const values = [];
    const view = map.getView();
    const projection = view.getProjection();
    const resolution = view.getResolution();

    for (let x = extent[0]; x <= extent[2]; x += step) {
        for (let y = extent[1]; y <= extent[3]; y += step) {
            const coord = [x, y];
            if (geom.intersectsCoordinate(coord)) {
                const url = dtmlayer.getSource().getGetFeatureInfoUrl(coord, resolution, projection.getCode(), { INFO_FORMAT: 'text/plain', FEATURE_COUNT: 1 });
                if (!url) continue;
                try { const text = await fetch(url).then(r => r.text()); const val = parseRasterValue(text); if (val !== null && !isNaN(val)) values.push(val); } catch (err) { console.error('GFI elev:', err); }
            }
        }
    }
    if (values.length === 0) { infoElev.innerHTML += "<hr /><b>Elevation:</b><br>No values found."; return; }
    document.getElementById("slopdivparentid").style.display = "block";

    const min = Math.min(...values), max = Math.max(...values), mean = values.reduce((a, b) => a + b, 0) / values.length;
    const classes = [
        { range: [-Infinity, 500], label: "Very Low (≤500m)", color: "#2b83ba" },
        { range: [500, 1000], label: "Low‐Moderate (500–1000m)", color: "#abdda4" },
        { range: [1000, 2000], label: "Moderate‐High (1000–2000m)", color: "#ffffbf" },
        { range: [2000, 3000], label: "High (2000–3000m)", color: "#fdae61" },
        { range: [3000, Infinity], label: "Very High (>3000m)", color: "#d7191c" }
    ];
    const counts = classes.map(c => ({ ...c, count: values.filter(v => v >= c.range[0] && v < c.range[1]).length }));
    let html = `<b><u>Elevation Statistics:</u></b><br><span class='setFontFeatureInfo'>(Source : USGS)</span><br>Min: ${min.toFixed(2)} m<br>Max: ${max.toFixed(2)} m<br>Mean: ${mean.toFixed(2)} m<br><b>Elevation Classes:</b><ul style="list-style:none;padding-left:0;">`;
    counts.forEach(c => { const pct = ((c.count / values.length) * 100).toFixed(1); html += `<li><span style="display:inline-block;width:16px;height:16px;background:${c.color};margin-right:6px;"></span>${c.label}: (${pct}%)</li>`; });
    html += '</ul><hr />';
    infoElev.innerHTML += html;
}

//async function getSoilInsidePolygon(polygon) {
//    const view = map.getView();
//    const resolution = view.getResolution();
//    const projection = view.getProjection();
//    const extent = polygon.getExtent();
//    const step = (extent[2] - extent[0]) / 25;
//    const values = new Set();

//    for (let x = extent[0]; x <= extent[2]; x += step) {
//        for (let y = extent[1]; y <= extent[3]; y += step) {
//            const coord = [x, y];
//            if (polygon.intersectsCoordinate(coord)) {
//                const url = soil_layer.getSource().getGetFeatureInfoUrl(coord, resolution, projection.getCode(), { INFO_FORMAT: 'text/plain', FEATURE_COUNT: 1 });
//                if (!url) continue;
//                try { const text = await fetch(url).then(r => r.text()); const val = parseRasterValue(text); if (val !== null) values.add(val); } catch (err) { console.error('GFI soil:', err); }
//            }
//        }
//    }

//    document.getElementById('slopdivparentid').style.display = "block";
//    const infoEl = document.getElementById('infoforslop');
//    if (values.size === 0) { infoEl.innerHTML = "<b>Soil type inside polygon:</b><br>No soil types found."; }
//    else {
//        infoEl.innerHTML = "<b>Soil Type:</b><br><span id='soiltypefeatureInfo'>(Source : CWE)</span><br/>" +
//            Array.from(values).sort((a, b) => a - b).map((v, i) => {
//                const label = rasterLabels[v] || v;
//                const color = rasterColors[v] || 'transparent';
//                return `${i + 1}. <span style="display:inline-block;width:14px;height:14px;background:${color};border:1px solid #333;margin-right:4px;vertical-align:middle;"></span>${label}`;
//            }).join('<br>') + "<br><hr />";
//    }
//}
async function getSoilInsidePolygon(coord) {
    const view = map.getView();
    const resolution = view.getResolution();
    const projection = view.getProjection();
    const values = new Set();

    const url = soil_layer.getSource().getGetFeatureInfoUrl(
        coord,
        resolution,
        projection.getCode(),
        {
            INFO_FORMAT: 'text/plain',
            FEATURE_COUNT: 1
        }
    );

    if (!url) return;

    try {
        const text = await fetch(url).then(r => r.text());
        const val = parseRasterValue(text);

        if (val !== null) values.add(val);

    } catch (err) {
        console.error('GFI soil (point):', err);
    }

    // ✅ SAME UI AS POLYGON
    document.getElementById('slopdivparentid').style.display = "block";
    const infoEl = document.getElementById('infoforslop');

    if (values.size === 0) {
        infoEl.innerHTML = "<b>Soil Type:</b><br>No soil types found.";
    } else {
        infoEl.innerHTML =
            "<b>Soil Type:</b><br><span id='soiltypefeatureInfo'>(Source : CWE)</span><br/>" +
            Array.from(values)
                .sort((a, b) => a - b)
                .map((v, i) => {
                    const label = rasterLabels[v] || v;
                    const color = rasterColors[v] || 'transparent';

                    return `${i + 1}. 
                        <span style="
                            display:inline-block;
                            width:14px;
                            height:14px;
                            background:${color};
                            border:1px solid #333;
                            margin-right:4px;
                            vertical-align:middle;">
                        </span>${label}`;
                })
                .join('<br>') +
            "<br><hr />";
    }
}
function showSoil(feature) { getSoilInsidePolygon(feature.getGeometry()); }
function showdtm(feature) { getElevationValuesInsidePolygon(feature.getGeometry()); }

let currentLayer = null;
let highlightLayer = null;

map.on('singleclick', function (evt) {
    //if (highlightLayer) { map.removeLayer(highlightLayer); highlightLayer = null; }
    //const feature = map.forEachFeatureAtPixel(evt.pixel, f => f);
    //if (!feature) return;

    //highlightLayer = new ol.layer.Vector({
    //    source: new ol.source.Vector({ features: [feature.clone()] }),
    //    style: new ol.style.Style({
    //        stroke: new ol.style.Stroke({ color: 'red', width: 3 }),
    //        fill: new ol.style.Fill({ color: 'rgba(255,0,0,0.2)' })
    //    })
    //});
    //map.addLayer(highlightLayer);

    //const infoChecked = document.getElementById('infoOption') && document.getElementById('infoOption').checked;
    //const slopeChecked = document.getElementById('slopeOption') && document.getElementById('slopeOption').checked;

    //if (infoChecked) showInfo(feature);
    //else if (slopeChecked) showSlope(feature);
    //else map.removeLayer(highlightLayer);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


     const feature = map.forEachFeatureAtPixel(evt.pixel, f => f);
    if (!feature) return;
    console.log("feature" + feature);

     const infoChecked = document.getElementById('infoOption') && document.getElementById('infoOption').checked;
    
    if (infoChecked) showInfo(feature);
    

});

// ==================== RASTER LAYERS ====================
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

const rasterLabels = { 1: "Loamy", 2: "Sandy", 3: "Snow", 4: "Clay" };
const rasterColors = { 1: "brown", 2: "yellow", 3: "pink", 4: "gray" };

const soil_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_ip,
        params: {
            'LAYERS': 'uk_sfd:GCS_Soil_Type_Uttaranchal', 'FORMAT': 'image/png', 'VERSION': '1.3.0',
            'SLD_BODY': `<StyledLayerDescriptor version="1.0.0"><NamedLayer><Name>uk_sfd:GCS_Soil_Type_Uttaranchal</Name><UserStyle><FeatureTypeStyle><Rule><RasterSymbolizer><ColorMap type="values"><ColorMapEntry color="#A0522D" quantity="1" label="Loamy"/><ColorMapEntry color="#C2B280" quantity="2" label="Sandy"/><ColorMapEntry color="#FFFFFF" quantity="3" label="Snow"/><ColorMapEntry color="#808080" quantity="4" label="Clay"/></ColorMap></RasterSymbolizer></Rule></FeatureTypeStyle></UserStyle></NamedLayer></StyledLayerDescriptor>`
        },
        ratio: 1, crossOrigin: 'anonymous'
    })
});

const sldBodydtm = `<?xml version="1.0" encoding="UTF-8"?><StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld"><NamedLayer><Name>uk_sfd:Uttaranchal_SRTM_GEO</Name><UserStyle><Title>Elevation Classification</Title><FeatureTypeStyle><Rule><RasterSymbolizer><ColorMap type="intervals" extended="true"><ColorMapEntry label="185.74" color="#2b83ba" quantity="185.74"/><ColorMapEntry label="2087.28" color="#abdda4" quantity="2087.28"/><ColorMapEntry label="3988.82" color="#ffffbf" quantity="3988.82"/><ColorMapEntry label="5890.37" color="#fdae61" quantity="5890.37"/><ColorMapEntry label="7791.91" color="#d7191c" quantity="7791.91"/></ColorMap></RasterSymbolizer></Rule></FeatureTypeStyle></UserStyle></NamedLayer></StyledLayerDescriptor>`;

const dtmlayer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_ip,
        params: { 'LAYERS': 'uk_sfd:Uttaranchal_SRTM_GEO', 'FORMAT': 'image/png', 'VERSION': '1.1.0', 'SRS': 'EPSG:4326' },
        ratio: 1, crossOrigin: 'anonymous'
    })
});

// ==================== DRAG ====================
makeDivDraggable('slopdivparentid');

function makeDivDraggable(divid) {
    const el = document.getElementById(divid);
    if (!el) return;
    let isDragging = false, offsetX = 0, offsetY = 0;
    el.addEventListener('mousedown', e => { isDragging = true; offsetX = e.clientX - el.offsetLeft; offsetY = e.clientY - el.offsetTop; document.body.style.userSelect = 'none'; });
    document.addEventListener('mousemove', e => { if (!isDragging) return; el.style.left = `${e.clientX - offsetX}px`; el.style.top = `${e.clientY - offsetY}px`; });
    document.addEventListener('mouseup', () => { isDragging = false; document.body.style.userSelect = ''; });
}

function closeslopdiv() {
    document.getElementById("slopdivparentid").style.display = "none";
    map.removeLayer(highlightLayer);
}

// ==================== FILE UPLOAD ====================
let vectorLayer1 = null, vectorLayer2 = null, maskLayer1 = null, maskLayer2 = null;
let uploadedFeatures = null, isuploaded = false;
var uploadedVectorLayer = null;

document.getElementById('fileInput').addEventListener('change', function (event) {
    const file = event.target.files[0];
    if (!file) { alert('No file selected.'); return; }
    const fileName = file.name.toLowerCase();

    if (fileName.endsWith('.zip')) {
        const reader = new FileReader();
        reader.onload = e => {
            shp(e.target.result).then(geojson => {
                addVectorLayer(new ol.format.GeoJSON().readFeatures(geojson, { featureProjection: 'EPSG:3857' }));
            }).catch(err => { alert('Error reading shapefile: ' + err); document.getElementById('fileInput').value = ''; });
        };
        reader.readAsArrayBuffer(file);
    } else if (fileName.endsWith('.kml')) {
        const reader = new FileReader();
        reader.onload = e => { addVectorLayer(new ol.format.KML().readFeatures(e.target.result, { featureProjection: 'EPSG:3857' })); };
        reader.readAsText(file);
    } else {
        alert('Unsupported file type. Please upload a .zip or .kml file.');
    }
});

function addVectorLayer(features) {
     vectorSource = new ol.source.Vector({ features });
    uploadedVectorLayer = new ol.layer.Vector({
        source: vectorSource,
        style: new ol.style.Style({
            stroke: new ol.style.Stroke({ color: '#FF2DD1', width: 2 }),
            fill: new ol.style.Fill({ color: '#FF2DD100' })
        })
    });
    map.addLayer(uploadedVectorLayer);
    map.getView().fit(vectorSource.getExtent(), { padding: [50, 50, 50, 50], maxZoom: 18 });
    uploadedFeatures = features;
    isuploaded = true;
}

document.getElementById('removeLayerBtn').addEventListener('click', function () {
    if (vectorLayer1) { map.removeLayer(vectorLayer1); vectorLayer1 = null; }
    if (uploadedVectorLayer) { map.removeLayer(uploadedVectorLayer); uploadedVectorLayer = null; }
    if (maskLayer1) { map.removeLayer(maskLayer1); map.removeLayer(sentinelLayer1); document.getElementById("chkforndvi").checked = false; document.getElementById("date").value = ''; document.getElementById("ndvilengend").style.display = "none"; }
    document.getElementById('fileInput').value = '';
    uploadedFeatures = null; isuploaded = false; sentinelLayer1 = null;
    applyfilter();
});

function onMaskToggleChange() {
    if (!uploadedFeatures) return;
    if (maskLayer1) map.removeLayer(maskLayer1);
    maskLayer1 = createMaskLayerFromFeatures(uploadedFeatures);
    map.addLayer(maskLayer1);
}

function ringIsClockwise(coords) {
    let sum = 0;
    for (let i = 0; i < coords.length - 1; i++) {
        const [x1, y1] = coords[i], [x2, y2] = coords[i + 1];
        sum += (x2 - x1) * (y2 + y1);
    }
    return sum > 0;
}

function createMaskLayerFromFeatures(features) {
    const projection = map.getView().getProjection();
    const extent = ol.proj.transformExtent([-180, -90, 180, 90], 'EPSG:4326', projection);
    let outerRing = [[extent[0], extent[1]], [extent[0], extent[3]], [extent[2], extent[3]], [extent[2], extent[1]], [extent[0], extent[1]]];
    if (!ringIsClockwise(outerRing)) outerRing.reverse();
    const holes = [];
    features.forEach(feature => {
        const geom = feature.getGeometry();
        if (geom instanceof ol.geom.Polygon) { const coords = geom.getCoordinates()[0].slice(); if (ringIsClockwise(coords)) coords.reverse(); holes.push(coords); }
        if (geom instanceof ol.geom.MultiPolygon) { geom.getCoordinates().forEach(pc => { const coords = pc[0].slice(); if (ringIsClockwise(coords)) coords.reverse(); holes.push(coords); }); }
    });
    const maskFeature = new ol.Feature(new ol.geom.Polygon([outerRing, ...holes]));
    return new ol.layer.Vector({ source: new ol.source.Vector({ features: [maskFeature] }), style: new ol.style.Style({ fill: new ol.style.Fill({ color: 'rgba(255,255,255,1)' }), stroke: null }), zIndex: 999 });
}

// ==================== SENTINEL / NDVI ====================
let sentinelLayer1, cliplayer;
var filter = "";
let layersss = "tbl_plant_species";

function downloadndvi() {
    document.getElementById("ndvilengend").style.display = "block";
    let date = document.getElementById("date").value;
    if (!date || date.trim() === "") { alert("choose date"); return; }
    if (!sentinelLayer1) { sentinelLayer1 = createSentinelLayer(date); map.addLayer(sentinelLayer1); }
    else { sentinelLayer1.getSource().getSources()[0].updateParams({ time: date }); sentinelLayer1.getSource().changed(); }
    if (isuploaded) onMaskToggleChange();
    else { cliplayer = createGeoServerMaskLayer(layersss, filter); map.addLayer(cliplayer); }
}

function callsentinel(checkbox) {
    if (checkbox.checked) {
        document.getElementById("ndvilengend").style.display = "block";
        let date = document.getElementById("date").value;
        if (!date || date.trim() === "") { alert("choose date"); checkbox.checked = false; return; }
        if (!sentinelLayer1) { sentinelLayer1 = createSentinelLayer(date); map.addLayer(sentinelLayer1); }
        else { sentinelLayer1.getSource().getSources()[0].updateParams({ time: date }); sentinelLayer1.getSource().changed(); }
        if (isuploaded) onMaskToggleChange();
        else { cliplayer = createGeoServerMaskLayer(layersss, filter); map.addLayer(cliplayer); }
    } else {
        document.getElementById("ndvilengend").style.display = "none";
        if (sentinelLayer1) { map.removeLayer(sentinelLayer1); sentinelLayer1 = null; }
        if (cliplayer) { map.removeLayer(cliplayer); cliplayer = null; }
    }
}

function createSentinelLayer(date) {
    const falseColorSource = new ol.source.TileWMS({
        url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
        params: { layers: '2_FALSE_COLOR', time: date, preset: '2_FALSE_COLOR', maxcc: 50 },
        crossOrigin: 'anonymous'
    });
    const rasterSource = new ol.source.Raster({
        sources: [falseColorSource],
        operation: function (pixels) {
            const pixel = pixels[0];
            const nir = pixel[0] / 255, red = pixel[1] / 255;
            const ndvi = (nir - red) / (nir + red);
            if (ndvi >= 0.60) return [20, 90, 33, 255];
            if (ndvi >= 0.40) return [50, 255, 90, 255];
            if (ndvi >= 0.20) return [221, 137, 50, 255];
            return [255, 0, 0, 255];
        }
    });
    return new ol.layer.Image({ source: rasterSource });
}

function createGeoServerMaskLayer(lastselectedlayer, filter) {
    const geoServerURL = (!filter || filter.trim() === "")
        ? `https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:${lastselectedlayer}&outputFormat=application/json`
        : `https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:${lastselectedlayer}&outputFormat=application/json&CQL_FILTER=${encodeURIComponent(filter)}`;

     vectorSource = new ol.source.Vector({ url: geoServerURL, format: new ol.format.GeoJSON() });
    const maskLayer = new ol.layer.Image({
        source: new ol.source.ImageVector({ source: vectorSource, style: new ol.style.Style({ fill: new ol.style.Fill({ color: 'rgba(0,0,0,1)' }), stroke: new ol.style.Stroke({ color: 'rgba(0,0,0,0)', width: 0 }) }) })
    });
    maskLayer.on('precompose', e => { e.context.globalCompositeOperation = 'destination-in'; });
    maskLayer.on('postcompose', e => { e.context.globalCompositeOperation = 'source-over'; });
    return maskLayer;
}

function openPopup() {
    const date = document.getElementById("date").value;
    if (date) { document.getElementById("fullscreenPopup").style.display = "flex"; downloadndvi(); }
    else alert("Please select the date");
}

function closePopup() {
    document.getElementById("fullscreenPopup").style.display = "none";
    if (cliplayer) map.removeLayer(cliplayer);
    if (sentinelLayer1) map.removeLayer(sentinelLayer1);
    document.getElementById("ndvilengend").style.display = 'none';
    if (vectorLayer1) { map.removeLayer(vectorLayer1); vectorLayer1 = null; }
    if (uploadedVectorLayer) { map.removeLayer(uploadedVectorLayer); uploadedVectorLayer = null; }
    if (maskLayer1) { map.removeLayer(maskLayer1); maskLayer1 = null; }
    if (sentinelLayer1) { map.removeLayer(sentinelLayer1); sentinelLayer1 = null; }
    document.getElementById("ndvilengend").style.display = "none";
    document.getElementById("chkforndvi").checked = false;
    uploadedFeatures = null; isuploaded = false;
    if (typeof applyfilter === 'function') applyfilter();
}

// ==================== DROPDOWN TOGGLE ====================
function toggleDropdown() {
    const panel = document.getElementById("dropdownPanel");
    if (panel) panel.style.display = (panel.style.display === "block") ? "none" : "block";
}

document.addEventListener("click", function (e) {
    const container = document.querySelector(".custom-multiselect-container");
    if (container && !container.contains(e.target)) {
        const panel = document.getElementById("dropdownPanel");
        if (panel) panel.style.display = "none";
    }
});

// ==================== UTILITY ====================
function getSelectedAreaOption() {
    const radios = document.querySelectorAll('#areacontrol label input[name="areaOption"]');
    for (let radio of radios) { if (radio.checked) return radio.id; }
    return null;
}

function getSelectedAreaOption1() {
    const radios = document.querySelectorAll('#areacontrol1 input[name="areaOption1"]');
    for (let radio of radios) { if (radio.checked) return radio.id; }
    return null;
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


function bindchartfirstinjs(lbls, vals) {
    debugLog('bindchartfirstinjs called', `_plantationApiDataLoaded: ${_plantationApiDataLoaded}, apiDataLength: ${_plantationApiData ? _plantationApiData.length : 'null'}`);

    if (_plantationApiDataLoaded && _plantationApiData && _plantationApiData.length > 0) {
        debugLog('Skipping DB fallback - API data already loaded ✅');
        return;
    }

    debugLog('Using DB FALLBACK data ⚠️', `lbls: ${lbls}, vals: ${vals}`);

    const canvas = document.getElementById('doughnutChart');
    if (!canvas) return;
    if (!lbls || !vals || lbls.trim() === '' || vals.trim() === '' || vals.trim() === '0,0') {
        showNoDataImage('doughnutChart'); return;
    }
    canvas.style.display = '';
    const valsarr = vals.split(",").map(Number);
    const ctx = canvas.getContext('2d');
    if (chrt_doughnutChart) chrt_doughnutChart.destroy();
    chrt_doughnutChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Target Plantation', 'Achieved Plantation'],
            datasets: [{ data: valsarr, backgroundColor: ['#2196F3', '#4CAF50'], borderWidth: 1, borderColor: '#fff', hoverOffset: 30 }]
        },
        options: {
            responsive: true, cutout: '65%',
            plugins: {
                title: { display: true, text: 'Target Plantation vs Achieved Plantation', font: { size: 14, weight: 'bold' } },
                legend: { position: 'bottom' }
            }
        }
    });
}

function bindchartSecondinjs(lbls2, vals2) {
    if (_plantationApiDataLoaded && _plantationApiData && _plantationApiData.length > 0) return;
    const canvas = document.getElementById('donutChartdiversity');
    if (!canvas) return;
    if (!lbls2 || !vals2 || lbls2.trim() === '') { showNoDataImage('donutChartdiversity'); return; }
    canvas.style.display = '';
    const labels = lbls2.split(","), dataValues = vals2.split(",").map(Number);
    const bgColors = ["#9c27b0", "#f44336", "#00bcd4", "#ffeb3b", "#795548", "#e91e63", "#3f51b5", "#2196f3", "#ff9800", "#8bc34a"];
    const ctx = canvas.getContext('2d');
    if (chrt_donutChartdiversity) chrt_donutChartdiversity.destroy();
    chrt_donutChartdiversity = new Chart(ctx, {
        type: 'doughnut',
        data: { labels, datasets: [{ data: dataValues, backgroundColor: bgColors, borderColor: '#fff', borderWidth: 2 }] },
        options: { responsive: true, cutout: '60%', plugins: { title: { display: true, text: 'Species Diversity', font: { size: 14 } }, legend: { position: 'bottom' } } }
    });
}

function bindchartthirdinjs(strplantationyear, strplantationcount, strplantationsitearea, strplantationcovered) {
    if (_plantationApiDataLoaded && _plantationApiData && _plantationApiData.length > 0) return;
    const canvas = document.getElementById('comparisionChart');
    if (!canvas) return;
    if (!strplantationyear || strplantationyear.trim() === '') { showNoDataImage('comparisionChart'); return; }
    canvas.style.display = '';
    const years = strplantationyear.split(",");
    const ctx = canvas.getContext('2d');
    if (chrt_comparisionChart) chrt_comparisionChart.destroy();
    chrt_comparisionChart = new Chart(ctx, {
        type: 'bar',
        data: { labels: years, datasets: [{ label: 'Target Plantation', data: strplantationsitearea.split(",").map(Number), backgroundColor: '#2196F3' }, { label: 'Achieved Plantation', data: strplantationcovered.split(",").map(Number), backgroundColor: '#4CAF50' }, { label: 'No of Plantation', data: strplantationcount.split(",").map(Number), backgroundColor: '#fc96F3' }] },
        options: { responsive: true, plugins: { title: { display: true, text: 'Yearly Plantation Profile', font: { size: 18 } }, legend: { position: 'bottom' } }, scales: { y: { beginAtZero: true }, x: { title: { display: true, text: 'Year' } } } }
    });
}

function bindchartsubbrust(locationsStr, plantationAreaStr, noOfPlantationStr, coveredAreaStr) {
    if (_plantationApiDataLoaded && _plantationApiData && _plantationApiData.length > 0) return;
    const canvas = document.getElementById('chartplantationandnursery');
    if (!canvas) return;
    if (!locationsStr || locationsStr.trim() === '') { showNoDataImage('chartplantationandnursery'); return; }
    canvas.style.display = '';
    const labels = locationsStr.split(",").map(s => s.trim());
    const ctx = canvas.getContext('2d');
    if (chrt_chartplantationandnursery) chrt_chartplantationandnursery.destroy();
    chrt_chartplantationandnursery = new Chart(ctx, {
        type: 'bar',
        data: { labels, datasets: [{ label: 'Target Plantation', data: plantationAreaStr.split(",").map(Number), backgroundColor: '#2196F3' }, { label: 'Achieved Plantation', data: coveredAreaStr.split(",").map(Number), backgroundColor: '#4CAF50' }, { label: 'No of Plantation', data: noOfPlantationStr.split(",").map(Number), backgroundColor: '#fc96F3' }] },
        options: { responsive: true, plugins: { title: { display: true, text: 'Region-wise Plantation Insights', font: { size: 18 } }, legend: { position: 'bottom' } }, scales: { x: { title: { display: true, text: 'Region' } }, y: { beginAtZero: true } } }
    });
}

// ==================== PDF REPORT ====================
function callbuffering() {
    document.getElementById("fullscreenPopup").style.display = "none";
    document.getElementById("loader").style.display = "block";

    var chkListContainer = document.getElementById('chkFeatureStats');
    var checkedItems = [];
    chkListContainer.querySelectorAll('input[type="checkbox"]').forEach(cb => {
        if (cb.checked) checkedItems.push({ text: cb.nextElementSibling ? cb.nextElementSibling.innerText.trim() : "", value: cb.value });
    });

    var ndviAttr = document.getElementById('ndviAttr');
    var checkedItemsndviAttr = [];
    ndviAttr.querySelectorAll('input[type="checkbox"]').forEach(cb => {
        if (cb.checked) checkedItemsndviAttr.push({ text: cb.nextElementSibling ? cb.nextElementSibling.innerText.trim() : "", value: cb.value });
    });

    function getSelectedRadioInfo(containerId) {
        var container = document.getElementById(containerId);
        var selectedValue = null, selectedText = null;
        container.querySelectorAll('input[type="radio"]').forEach(radio => {
            if (radio.checked) { selectedValue = radio.value; selectedText = radio.nextElementSibling ? radio.nextElementSibling.innerText.trim() : ""; }
        });
        return { value: selectedValue, text: selectedText };
    }

    downloadAllToPDF(
        getSelectedRadioInfo('rblYearlyPlantation'),
        getSelectedRadioInfo('rblSpeciesDiversity'),
        getSelectedRadioInfo('rblRegionWise'),
        getSelectedRadioInfo('rblTargetAchieved'),
        checkedItems,
        checkedItemsndviAttr
    );
}

async function getStatsInsidePolygon(polygon) {
    const view = map.getView(), resolution = view.getResolution(), projection = view.getProjection();
    const extent = polygon.getExtent(), step = (extent[2] - extent[0]) / 30;
    const slopeValues = [], elevationValues = [], soilTypes = [];

    for (let x = extent[0]; x <= extent[2]; x += step) {
        for (let y = extent[1]; y <= extent[3]; y += step) {
            const coord = [x, y];
            if (!polygon.intersectsCoordinate(coord)) continue;
            try {
                const slopeUrl = sloplayer.getSource().getGetFeatureInfoUrl(coord, resolution, projection.getCode(), { INFO_FORMAT: 'text/plain', FEATURE_COUNT: 1 });
                if (slopeUrl) { const t = await fetch(slopeUrl).then(r => r.text()); const v = parseRasterValue(t); if (v !== null) slopeValues.push(v); }
                const elevUrl = dtmlayer.getSource().getGetFeatureInfoUrl(coord, resolution, projection.getCode(), { INFO_FORMAT: 'text/plain', FEATURE_COUNT: 1 });
                if (elevUrl) { const t = await fetch(elevUrl).then(r => r.text()); const v = parseRasterValue(t); if (v !== null) elevationValues.push(v); }
                const soilUrl = soil_layer.getSource().getGetFeatureInfoUrl(coord, resolution, projection.getCode(), { INFO_FORMAT: 'text/plain', FEATURE_COUNT: 1 });
                if (soilUrl) { const t = await fetch(soilUrl).then(r => r.text()); const v = parseRasterValue(t); if (v) soilTypes.push(v); }
            } catch (err) { console.error("Raster error:", err); }
        }
    }

    const slopeStats = {};
    if (slopeValues.length) {
        slopeStats.min = Math.min(...slopeValues).toFixed(2);
        slopeStats.max = Math.max(...slopeValues).toFixed(2);
        slopeStats.avg = (slopeValues.reduce((a, b) => a + b, 0) / slopeValues.length).toFixed(2);
        const sc = [{ range: [0, 10], label: "Flat (0–10°)" }, { range: [10, 20], label: "Moderate (10–20°)" }, { range: [20, 30], label: "Steep (20–30°)" }, { range: [30, 45], label: "Very Steep (30–45°)" }, { range: [45, 88], label: "Cliff (45–88°)" }];
        slopeStats.classDistribution = sc.map(c => { const pct = ((slopeValues.filter(v => v >= c.range[0] && v < c.range[1]).length / slopeValues.length) * 100).toFixed(1); return `${c.label}: ${pct}%`; }).join('\n');
    }
    const elevationStats = {};
    if (elevationValues.length) {
        elevationStats.min = Math.min(...elevationValues).toFixed(2);
        elevationStats.max = Math.max(...elevationValues).toFixed(2);
        elevationStats.avg = (elevationValues.reduce((a, b) => a + b, 0) / elevationValues.length).toFixed(2);
        const ec = [{ range: [-Infinity, 500], label: "Very Low (≤500m)" }, { range: [500, 1000], label: "Low (500–1000m)" }, { range: [1000, 2000], label: "Moderate (1000–2000m)" }, { range: [2000, 3000], label: "High (2000–3000m)" }, { range: [3000, Infinity], label: "Very High (>3000m)" }];
        elevationStats.classDistribution = ec.map(c => { const pct = ((elevationValues.filter(v => v >= c.range[0] && v < c.range[1]).length / elevationValues.length) * 100).toFixed(1); return `${c.label}: ${pct}%`; }).join('\n');
    }
    const soilStats = {};
    if (soilTypes.length) { const tc = soilTypes.reduce((acc, v) => { acc[v] = (acc[v] || 0) + 1; return acc; }, {}); soilStats.dominantType = rasterLabels[Object.entries(tc).sort((a, b) => b[1] - a[1])[0][0]] || "Unknown"; }
    return { slope: slopeStats, elevation: elevationStats, soil: soilStats };
}

async function downloadAllToPDF(yearlyPlantation, speciesDiversity, regionWise, targetAchieved, checkedItems, checkedItemsndviAttr) {
    const { jsPDF } = window.jspdf;
    const pdf = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
    const pageWidth = 210, pageHeight = 297, margin = 20;
    let currentY = margin;

    function drawPageBorder() { pdf.setDrawColor(0, 0, 0); pdf.setLineWidth(0.5); pdf.rect(margin / 2, margin / 2, pageWidth - margin, pageHeight - margin); }
    function addLabel(text) {
        const fs = 12, px = 5, py = 4; pdf.setFontSize(fs); pdf.setFont(undefined, 'bold');
        const lw = pageWidth - margin * 2, th = fs * 0.3528;
        if (currentY + th + py * 2 > pageHeight - margin) { pdf.addPage(); currentY = margin; drawPageBorder(); }
        pdf.setFillColor(0, 128, 0); pdf.rect(margin, currentY - py, lw, th + py * 2, 'F');
        pdf.setTextColor(255, 255, 255); pdf.text(text, margin + px, currentY + th * 0.75);
        pdf.setTextColor(0, 0, 0); pdf.setFont(undefined, 'normal'); pdf.setFontSize(10);
        currentY += th + py * 2 + 5;
    }
    function addImageAndReturnHeight(canvasId, yPos) {
        const canvas = document.getElementById(canvasId); if (!canvas) return 0;
        const imgData = canvas.toDataURL('image/png'); const imgProps = pdf.getImageProperties(imgData);
        const ar = imgProps.width / imgProps.height; let iw = pageWidth - margin * 2; let ih = iw / ar;
        if (yPos + ih > pageHeight - margin) { pdf.addPage(); yPos = margin; drawPageBorder(); }
        pdf.addImage(imgData, 'PNG', (pageWidth - iw) / 2, yPos, iw, ih); return ih + 10;
    }
    function addTableAndReturnHeight(tableId, yPos) {
        const table = document.getElementById(tableId); if (!table) return 0;
        let tableEndY = yPos;
        pdf.autoTable({ html: `#${tableId}`, startY: yPos, margin: { horizontal: 10 }, styles: { fontSize: 9, cellPadding: 2 }, didDrawPage: d => { tableEndY = d.cursor.y + 10; } });
        return tableEndY - yPos;
    }
    function addSection(chartId, tableId, chartEnabled, tableEnabled, label) {
        addLabel(label); let sy = currentY;
        if (chartEnabled) sy += addImageAndReturnHeight(chartId, sy);
        if (tableEnabled) { if (sy + 80 > pageHeight - margin) { pdf.addPage(); sy = margin; drawPageBorder(); } sy += addTableAndReturnHeight(tableId, sy); }
        currentY = sy + 5;
    }
    async function addMapToPDF(mapContainerId, yPos, label) {
        addLabel(label);
        const mapElement = document.getElementById(mapContainerId); if (!mapElement) return 0;
        try {
            const canvas = await html2canvas(mapElement); const imgData = canvas.toDataURL('image/png');
            const imgProps = pdf.getImageProperties(imgData); const ar = imgProps.width / imgProps.height;
            const iw = pageWidth - margin * 2; const ih = iw / ar;
            if (yPos + ih > pageHeight - margin) { pdf.addPage(); yPos = margin; drawPageBorder(); }
            pdf.addImage(imgData, 'PNG', (pageWidth - iw) / 2, yPos, iw, ih); return ih + 10;
        } catch (err) { console.error("Map capture error:", err); return 0; }
    }

    drawPageBorder();
    if (yearlyPlantation && yearlyPlantation.value) addSection("comparisionChart", "grd_querythree", yearlyPlantation.value.includes("JPEG"), yearlyPlantation.value.includes("Tabular"), "Yearly Plantation Profile");
    if (speciesDiversity && speciesDiversity.value) addSection("donutChartdiversity", "grd_querytwo", speciesDiversity.value.includes("JPEG"), speciesDiversity.value.includes("Tabular"), "Species Diversity");
    if (regionWise && regionWise.value) addSection("chartplantationandnursery", "grd_queryfour", regionWise.value.includes("JPEG"), regionWise.value.includes("Tabular"), "Region Wise Plantation Insights");
    if (targetAchieved && targetAchieved.value) addSection("doughnutChart", "grd_queryone", targetAchieved.value.includes("JPEG"), targetAchieved.value.includes("Tabular"), "Target Achieved");

    const featuresforreports = await getfeatures();
    for (const item of checkedItems) {
        const label = item.text ? item.text.trim().toLowerCase() : '';
        if (label === "information") {
            addLabel("Information");
            const infoTexts = await getInformationFromFeatures();
            infoTexts.forEach(infoText => {
                const splitText = pdf.splitTextToSize(infoText, pageWidth - margin * 2);
                const textHeight = splitText.length * 4.5;
                if (currentY + textHeight > pageHeight - margin) { pdf.addPage(); currentY = margin; drawPageBorder(); }
                pdf.text(splitText, margin, currentY); currentY += textHeight + 5;
            });
        } else if (label === "features") {
            addLabel("Features Statistics");
            for (let i = 0; i < featuresforreports.length; i++) {
                const stats = await getStatsInsidePolygon(featuresforreports[i].getGeometry());
                let statText = `Plantation Site ${i + 1} Statistics:\n\n`;
                if (stats.slope && stats.slope.min != null) statText += `Slope:\n- Min: ${stats.slope.min}\n- Max: ${stats.slope.max}\n- Mean: ${stats.slope.avg}\n- Distribution:\n${stats.slope.classDistribution}\n\n`;
                if (stats.elevation && stats.elevation.min != null) statText += `Elevation:\n- Min: ${stats.elevation.min}\n- Max: ${stats.elevation.max}\n- Mean: ${stats.elevation.avg}\n- Distribution:\n${stats.elevation.classDistribution}\n\n`;
                if (stats.soil && stats.soil.dominantType) statText += `Soil:\n- Dominant Type: ${stats.soil.dominantType}\n\n`;
                const splitText = pdf.splitTextToSize(statText, pageWidth - margin * 2);
                const textHeight = splitText.length * 5;
                if (currentY + textHeight > pageHeight - margin) { pdf.addPage(); currentY = margin; drawPageBorder(); }
                pdf.text(splitText, margin, currentY); currentY += textHeight + 10;
            }
        }
    }

    for (const [index] of checkedItemsndviAttr.entries()) {
        const height = await addMapToPDF('map', currentY, `NDVI Map Screenshot ${index + 1}`);
        currentY += height;
    }

    if (cliplayer) map.removeLayer(cliplayer);
    if (sentinelLayer1) map.removeLayer(sentinelLayer1);
    document.getElementById("date").value = '';
    document.getElementById("ndvilengend").style.display = 'none';
    document.getElementById("fullscreenPopup").style.display = "none";
    document.getElementById("loader").style.display = "none";
    pdf.save(`report_${new Date().toISOString().split('T')[0]}.pdf`);
}

async function getInformationFromFeatures() {
    const features = await getfeatures();
    return features.map((feature, index) => {
        const properties = { ...feature.getProperties() };
        delete properties.geometry;
        let infoText = `Plantation Site ${index + 1} - Feature Information:\n\n`;
        for (const key in properties) { if (Object.hasOwnProperty.call(properties, key)) infoText += `- ${key}: ${properties[key]}\n`; }
        return infoText;
    });
}

function getMostCommon(arr) {
    const counts = arr.reduce((acc, val) => { acc[val] = (acc[val] || 0) + 1; return acc; }, {});
    return Object.entries(counts).sort((a, b) => b[1] - a[1])[0][0];
}

function countOccurrences(arr) {
    return arr.reduce((acc, val) => { acc[val] = (acc[val] || 0) + 1; return acc; }, {});
}



document.addEventListener('DOMContentLoaded', async function () {
    debugLog('DOMContentLoaded fired');

    try {
        debugLog('Step 1: Fetching API data...');
        await fetchPlantationApiData();

        debugLog('Step 2: API fetch complete', `loaded: ${_plantationApiDataLoaded}, records: ${_plantationApiData ? _plantationApiData.length : 0}`);

        debugLog('Step 3: Populating year dropdown...');
        await populatePlantationYearDropdown();

        debugLog('Step 4: Populating site dropdown...');
        await populatePlantationSiteDropdown();

        debugLog('Step 5: Rendering API charts...');
        await renderApiCharts();

        debugLog('Step 6: All init done ✅');

    } catch (e) {
        debugLog('INIT ERROR ❌', e.message);
        console.error('Full init error:', e);
    }

    setTimeout(function () {
        if (typeof map !== 'undefined') map.updateSize();
    }, 500);
});

console.log("✅ plantationdashboardjs.js loaded — API integrated for Plantation Year, Site & Charts");