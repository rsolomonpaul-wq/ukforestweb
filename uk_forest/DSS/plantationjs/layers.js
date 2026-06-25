var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";
var sentinel2fcckey = document.getElementById("sentinel2fcckey").value;
var sentinel2ncckey = document.getElementById("sentinel2ncckey").value;
var format = 'image/png';
var lastselectedlayer = [];
var lastselectedlayername = [];
var lastselectedlayer_vector = [];
var lastselectedlayer_vector_filter = [];
var gcount = 0;
var lcount = 0;
var zcount = 0;
var layerobject = [];
var type;
var baselayer = 0;
var cliplayer;
var filter = "";

var checkrunningtime = 0;
var container;
var overlay = new ol.Overlay(({
    element: container,
    autoPan: true,
    autoPanAnimation: {
        duration: 250
    }
}));

function sfdzone(checkbox) {
    if (checkbox.checked) {
        map1.addLayer(zones);
        map2.addLayer(zones);
        layerobject.push(zones);
        map1.addOverlay(zones);
        map2.addOverlay(zones);
        lastselectedlayer.push("tbl_zone_master");
        lastselectedlayername.push("SFD Zone Boundaries");
        lastselectedlayer_vector.push("tbl_zone_master");
    }
    else {
        map1.removeLayer(zones);
        map2.removeLayer(zones);
        layerobject.pop(zones);
        map1.removeOverlay(zones);
        map2.removeOverlay(zones);
        lastselectedlayer.pop("tbl_zone_master");
        lastselectedlayername.pop("SFD Zone Boundaries");
        lastselectedlayer_vector.pop("tbl_zone_master");
    }
}

var zones = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:view_plantation_polygon',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'
    })
});

window.addEventListener('load', function () {
    map.addLayer(vectorLayerplantation);
    map.addOverlay(vectorLayerplantation);
    map.addLayer(highlightLayer); // ✅ Add highlight layer here
    lastselectedlayer.push("view_plantation_polygon");
    lastselectedlayername.push("Plantation")
});

var vectorSourceplantation = new ol.source.Vector({
    format: new ol.format.GeoJSON(),
    url: 'https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd%3Aview_plantation_polygon&outputFormat=application%2Fjson',
    strategy: ol.loadingstrategy.all
});

// 🌿 Main Vector Layer
var vectorLayerplantation = new ol.layer.Vector({
    source: vectorSourceplantation,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({ color: 'green', width: 2 }),
        fill: new ol.style.Fill({ color: 'rgba(0, 255, 0, 0.3)' })
    })
});

// ⭐ Highlight Vector Source + Layer (separate)
var highlightSource = new ol.source.Vector();
var highlightLayer = new ol.layer.Vector({
    source: highlightSource,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({ color: '#FF00FF', width: 5 }),
        fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.1)' })
    })
});

map.on('click', function (evt) {
    var featureFound = false;

    map.forEachFeatureAtPixel(evt.pixel, function (feature) {
        if (!featureFound) {
            featureFound = true;

            // 🧹 Clear previous highlight
            highlightSource.clear();

            // ✨ Clone & add to highlight layer
            var clone = feature.clone();
            highlightSource.addFeature(clone);

            // 📌 Get coordinates
            var coords = getPolygonCoordinates(feature);
            if (coords) {
                console.log('Polygon Coordinates:', coords);
               // alert('Polygon Coordinates:\n' + coords.map(c => `[${c[0]}, ${c[1]}]`).join(',\n'));
                var polygon = coords.map(c => `[${c[0]}, ${c[1]}]`).join(',\n');
               // alert(polygon);
                const startDate = "2022-01-01";
                const endDate = "2025-09-15";
                fetchNdviForPolygon(startDate, endDate, coords);
            }

            return true;
        }
    });

    if (!featureFound) {
        highlightSource.clear(); // remove highlight if clicking outside features
    }
});

function getPolygonCoordinates(feature) {
    var geom = feature.getGeometry();
    var type = geom.getType();
    var coords;

    if (type === 'Polygon') {
        coords = geom.getCoordinates()[0];
    } else if (type === 'MultiPolygon') {
        coords = geom.getCoordinates()[0][0];
    } else {
        return null;
    }

    return coords.map(function (coord) {
        var lonLat = ol.proj.transform(coord, 'EPSG:3857', 'EPSG:4326');
        return [parseFloat(lonLat[0].toFixed(6)), parseFloat(lonLat[1].toFixed(6))];
    });
}

const apiKey = '3d18a4fbbc48a1675f1a3644dc5400cb';
const output = document.getElementById('output');
const loader = document.getElementById('loader');
let ndviChart = null;

async function fetchNdviForPolygon(startDate, endDate, polygonCoordinates) {
    try {
        output.innerHTML = '⏳ Creating polygon...';
        loader.style.display = 'block';

        const startTimestamp = Math.floor(new Date(startDate).getTime() / 1000);
        const endTimestamp = Math.floor(new Date(endDate).getTime() / 1000);

        const polygonData = {
            name: "Custom Area",
            geo_json: {
                type: "Feature",
                properties: {},
                geometry: {
                    type: "Polygon",
                    coordinates: [polygonCoordinates]
                }
            }
        };

        const polygonRes = await fetch(`https://api.agromonitoring.com/agro/1.0/polygons?appid=${apiKey}&duplicated=true`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(polygonData)
        });
        const polygonResult = await polygonRes.json();

        if (!polygonResult.id) throw new Error(polygonResult.message || "Polygon creation failed.");
        const polygonId = polygonResult.id;

        const ndviUrl = `https://api.agromonitoring.com/agro/1.0/ndvi/history?start=${startTimestamp}&end=${endTimestamp}&polyid=${polygonId}&appid=${apiKey}&type=s2`;
        const ndviRes = await fetch(ndviUrl);
        if (!ndviRes.ok) throw new Error(`HTTP error! status: ${ndviRes.status}`);
        const ndviData = await ndviRes.json();

        if (!Array.isArray(ndviData) || ndviData.length === 0) {
            throw new Error("No NDVI data found.");
        }

        const grouped = {};
        ndviData.forEach(item => {
            const date = new Date(item.dt * 1000);
            const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
            if (!grouped[key]) grouped[key] = [];
            grouped[key].push(item);
        });

        const monthlyMax = [];
        for (const month in grouped) {
            const maxEntry = grouped[month].reduce((a, b) => (b.data.mean > a.data.mean ? b : a));
            monthlyMax.push(maxEntry);
        }

        monthlyMax.sort((a, b) => a.dt - b.dt);

        let table = `<table>
            <thead><tr>
              <th>Month</th><th>Type</th><th>Zoom</th><th>DC</th><th>CL</th>
              <th>Mean</th><th>Median</th><th>Min</th><th>Max</th><th>Std</th>
              <th>P25</th><th>P75</th><th>Num</th>
            </tr></thead><tbody>`;

        monthlyMax.forEach(item => {
            const d = item.data;
            const date = new Date(item.dt * 1000);
            const month = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
            table += `<tr>
              <td>${month}</td><td>${item.type}</td><td>${item.zoom}</td><td>${item.dc}</td><td>${item.cl}</td>
              <td>${d.mean.toFixed(4)}</td><td>${d.median.toFixed(4)}</td><td>${d.min.toFixed(4)}</td>
              <td>${d.max.toFixed(4)}</td><td>${d.std.toFixed(4)}</td><td>${d.p25.toFixed(4)}</td>
              <td>${d.p75.toFixed(4)}</td><td>${d.num}</td>
            </tr>`;
        });

        table += '</tbody></table>';
        output.innerHTML = table;

        bindChart(monthlyMax);

    } catch (error) {
        output.innerHTML = `❌ Error: ${error.message}`;
        if (ndviChart) {
            ndviChart.destroy();
            ndviChart = null;
        }
    } finally {
        loader.style.display = 'none';
    }
}

function bindChart(monthlyData) {
    const labels = monthlyData.map(item => {
        const d = new Date(item.dt * 1000);
        return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
    });

    const maxNDVI = monthlyData.map(item => item.data.max);
    document.getElementById("chartContainer").style.display = "block";

    const ctx = document.getElementById('ndviChart').getContext('2d');
    if (ndviChart) ndviChart.destroy();

    ndviChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Max NDVI',
                data: maxNDVI,
                backgroundColor: 'rgba(54, 162, 235, 0.3)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 2,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    max: 1,
                    title: { display: true, text: 'NDVI Value' }
                },
                x: {
                    title: { display: true, text: 'Month' }
                }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: ctx => `Max NDVI: ${ctx.parsed.y.toFixed(4)}`
                    }
                },
                legend: { display: true, position: 'top' }
            }
        }
    });
}
