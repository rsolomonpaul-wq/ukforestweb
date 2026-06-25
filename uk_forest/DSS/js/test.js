var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";
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


var style_raster = new ol.style.Style({
    fill: new ol.style.Fill({
        color: [0, 0, 0, 1]
    })
});

var sentinel_layer;
function callsentinel() {
    const mode = document.querySelector('input[name="mode"]:checked').value;
    if (mode === 'dual') {
        var dt2 = document.getElementById("dual-range2").value;
        date = dt2;
    }
    sentinel_layer = new ol.layer.Tile({
        source: new ol.source.TileWMS({
            url: "https://services.sentinel-hub.com/ogc/wms/514e719b-3d56-429e-bdc8-55b90d20d343",
            //url: "https://services.sentinel-hub.com/ogc/wms/9b4d93bf-b7e5-4588-9394-cf70951aed63",
            params: { "maxcc": 85, "minZoom": 6, "maxZoom": 16, "preset": "2_FALSE_COLOR", "layers": "2_FALSE_COLOR", "time": date },

            serverType: 'geoserver',
            crossOrigin: 'anonymous',
            transition: 0

        })
    });
}

function createGeoServerLayer(lastselectedlayer, filter) {

    var geoServerURL = null;
    if (filter == null) {
        geoServerURL = "https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:" + lastselectedlayer + "&outputFormat=application/json";
    }
    else {
        geoServerURL = "https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:" + lastselectedlayer + "&outputFormat=application/json&CQL_FILTER=" + filter;
        console.log(geoServerURL);
    }

    var vectorSource = new ol.source.Vector({
        url: geoServerURL, // Fetch GeoJSON from GeoServer
        format: new ol.format.GeoJSON()
    });

    var style_vector = new ol.style.Style({
        fill: new ol.style.Fill({
            color: 'black'
        })
    });


    var cliplayer = new ol.layer.Image({
        source: new ol.source.ImageVector({
            source: vectorSource,
            style: style_vector
        })
    });



    return cliplayer;
}


var LAILayer;
function callLai() {


    var enableNDVI = document.getElementById("ndvi-toggle").checked;

    if (enableNDVI) {
        const ndviRaster = new ol.source.Raster({
            sources: [sentinelSource],
            operation: function (pixels) {
                const pixel = pixels[0];
                const nir = pixel[0] / 255;
                const red = pixel[1] / 255;
                const ndvi = (nir - red) / (nir + red);
                if (ndvi >= 0.67) return [20, 90, 33, 255];
                else if (ndvi >= 0.46) return [50, 255, 90, 255];
                else if (ndvi >= 0.30) return [221, 137, 50, 255];
                else return [255, 0, 0, 255];
            }
        });
        return new ol.layer.Image({ source: ndviRaster });
    } else {
        return new ol.layer.Tile({ source: sentinelSource });
    }






}
var cliplayer;
function CropGrowth(checkbox) {
    selectedLayerId = "sentinel2fcc";
    if (checkbox.checked) {
        if (selectedLayerId == "sentinel2fcc") {

            refreshLayers();
            callLai();
            map1.addLayer(LAILayer);
            map2.addLayer(LAILayer);
            const mode = document.querySelector('input[name="mode"]:checked').value;
            if (mode === 'dual') {
                refreshLayers();
                callLai();
                //map1.addLayer(LAILayer);
                map2.addLayer(LAILayer);
            }

        }
        else if (selectedLayerId == 'basemap_ortho') {
            map1.addLayer(CropGrowth_layer);
            map1.addLayer(CropGrowth_layer);
        }

        cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], lastselectedlayer_vector_filter[0]);
        cliplayer.on('postcompose', function (e) {
            e.context.globalCompositeOperation = 'source-over';
        });
        cliplayer.on('precompose', function (e) {
            e.context.globalCompositeOperation = 'destination-in';
        });

        jQuery('#div_CropGrowth').css('display', 'block');

        map1.addLayer(cliplayer);
        map2.addLayer(cliplayer);
        layerobject.push(cliplayer);
        //map1.addOverlay(cliplayer);
        //map2.addOverlay(cliplayer);
        lastselectedlayer.push("Crop_Growth");
        lastselectedlayername.push("Crop Growth");


    }
    else {
        //jQuery('#div_CropGrowth').css('display', 'none');
        if (selectedLayerId == "sentinel2fcc") {
            map1.removeLayer(LAILayer);
            map2.removeLayer(LAILayer);
        }

        else if (selectedLayerId == 'basemap_ortho') {
            map2.removeLayer(CropGrowth_layer);
            map1.removeLayer(CropGrowth_layer);
        }

        map1.removeLayer(cliplayer);
        map2.removeLayer(cliplayer);
        layerobject.pop(cliplayer);
        map1.removeOverlay(cliplayer);
        map2.removeOverlay(cliplayer);
        lastselectedlayer.pop("Apple_NDVI");
        lastselectedlayername.pop("Crop Growth");
    }
}
window.onload = function () {

    map1.addLayer(zones);
    // map1.addOverlay(zones);

    layerobject.push(zones);

    document.getElementById("zonecheck").checked = true;

    lastselectedlayer.push("tbl_division_master");
    lastselectedlayername.push("Divisions Boundary");
    lastselectedlayer_vector.push("tbl_division_master");

}

const sharedView = new ol.View({
    center: ol.proj.fromLonLat([79.0193, 30.0668]),
    zoom: 8
});

const map1 = new ol.Map({
    target: 'map1',
    layers: [new ol.layer.Tile({ source: new ol.source.OSM() })],
    view: sharedView
});

const map2 = new ol.Map({
    target: 'map2',
    layers: [new ol.layer.Tile({ source: new ol.source.OSM() })],
    //view: new ol.View({
    //    center: ol.proj.fromLonLat([79.0193, 30.0668]),
    //    zoom: 8
    //})
    view: sharedView
});

var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";

var format = 'image/png';
var lastselectedlayer = [];
var lastselectedlayername = [];
var lastselectedlayer_vector = [];
var lastselectedlayer_vector_filter = [];
var layerobject = [];


function sfdzone(checkbox) {

    if (checkbox.checked) {
        // jQuery('#div_zone').css('display', 'block');
        map1.addLayer(zones);
        map2.addLayer(zones);
        layerobject.push(zones);
        map1.addOverlay(zones);
        map2.addOverlay(zones);
        lastselectedlayer.push("tbl_zone_master");
        lastselectedlayername.push("SFD Zone Boundaries");
        lastselectedlayer_vector.push("tbl_zone_master");
        //village_zoom();
    }
    else {
        //jQuery('#div_zone').css('display', 'none');
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
            layers: 'uk_sfd:tbl_zone_master',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function sfdcircle(checkbox) {

    if (checkbox.checked) {
        //jQuery('#div_circle').css('display', 'block');
        map1.addLayer(circles);
        map2.addLayer(circles);
        layerobject.push(circles);
        map1.addOverlay(circles);
        map2.addOverlay(circles);
        lastselectedlayer.push("tbl_circle_master");
        lastselectedlayername.push("SFD Circle Boundaries");
        lastselectedlayer_vector.push("tbl_circle_master");
        //village_zoom();
    }
    else {
        //jQuery('#div_circle').css('display', 'none');
        map1.removeLayer(circles);
        map2.removeLayer(circles);
        layerobject.pop(circles);
        map1.removeOverlay(circles);
        map2.removeOverlay(circles);
        lastselectedlayer.pop("tbl_circle_master");
        lastselectedlayername.pop("SFD Circle Boundaries");
        lastselectedlayer_vector.pop("tbl_circle_master");
    }
}

var circles = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_circle_master',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function sfddivision(checkbox) {

    if (checkbox.checked) {
        //jQuery('#div_division').css('display', 'block');
        map1.addLayer(divisions);
        map2.addLayer(divisions);
        layerobject.push(divisions);
        map1.addOverlay(divisions);
        map2.addOverlay(divisions);
        lastselectedlayer.push("tbl_division_master");
        lastselectedlayername.push("sfd division boundaries");
        lastselectedlayer_vector.push("tbl_division_master");
        //village_zoom();
    }
    else {
        // jQuery('#div_division').css('display', 'none');
        map1.removeLayer(divisions);
        map2.removeLayer(divisions);
        layerobject.pop(divisions);
        map1.removeOverlay(divisions);
        map2.removeOverlay(divisions);
        lastselectedlayer.pop("tbl_division_master");
        lastselectedlayername.pop("SFD Division Boundaries");
        lastselectedlayer_vector.pop("tbl_division_master");
    }
}

var divisions = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_division_master',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});

function sfdplantation(checkbox) {

    if (checkbox.checked) {
        //jQuery('#div_LandDetails').css('display', 'block');
        map1.addLayer(plantation_layer);
        map2.addLayer(plantation_layer);
        layerobject.push(plantation_layer);
        map1.addOverlay(plantation_layer);
        map2.addOverlay(plantation_layer);
        lastselectedlayer.push("tbl_plantation_area");
        lastselectedlayername.push("Plantation");
        lastselectedlayer_vector.push("tbl_plantation_area");
        //thailandvil_zoom();
    }
    else {
        // jQuery('#div_LandDetails').css('display', 'none');
        map1.removeLayer(plantation_layer);
        map2.removeLayer(plantation_layer);
        layerobject.pop(plantation_layer);
        map1.removeOverlay(plantation_layer);
        map2.removeOverlay(plantation_layer);
        lastselectedlayer.pop("tbl_plantation_area");
        lastselectedlayername.pop("Plantation");
        lastselectedlayer_vector.pop("tbl_plantation_area");
        // country_zoom();
    }
}
var plantation_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_plantation_area',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'
    })
});


function sfdforest(checkbox) {

    if (checkbox.checked) {

        map1.addLayer(forest_layer);
        map2.addLayer(forest_layer);
        map1.addOverlay(forest_layer);
        map2.addOverlay(forest_layer);
        layerobject.push(forest_layer);

        lastselectedlayer.push("tbl_forest_data_final");
        lastselectedlayername.push("Forest");
        lastselectedlayer_vector.push("tbl_forest_data_final");

    }
    else {

        map1.removeLayer(forest_layer);
        map2.removeLayer(forest_layer);
        layerobject.pop(forest_layer);
        map1.removeOverlay(forest_layer);
        map2.removeOverlay(forest_layer);
        lastselectedlayer.pop("tbl_forest_data_final");
        lastselectedlayername.pop("Forest");
        lastselectedlayer_vector.pop("tbl_forest_data_final");

    }
}
var forest_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_forest_data_final',
            CQL_FILTER: "name='Reserve Forest'",
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'
    })
});

function range_fun(checkbox) {

    if (checkbox.checked) {


        layerobject.push(ranges);
        map1.addLayer(ranges);
        map2.addLayer(ranges);
        map1.addOverlay(ranges);
        map2.addOverlay(ranges);
        lastselectedlayer.push("range_master");
        lastselectedlayername.push("Range");
        lastselectedlayer_vector.push("tbl_range_areas");
        //village_zoom();
    }
    else {
        jQuery('#div_range').css('display', 'none');

        layerobject.pop(ranges);
        map1.removeLayer(ranges);
        map2.removeLayer(ranges);
        map1.removeOverlay(ranges);
        map2.removeOverlay(ranges);
        lastselectedlayer.pop("range_master");
        lastselectedlayername.pop("Range");
        lastselectedlayer_vector.pop("tbl_range_areas");
    }
}

var ranges = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:range_master',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});



let sentinelLayer1, sentinelLayer2;
let ndviLayer1, ndviLayer2;
let swipeLayer1, swipeLayer2, swipeNDVILayer1, swipeNDVILayer2;
let showNDVI = false;
let singleDates = [];
let dualDates1 = [], dualDates2 = [];



function createSentinelLayer(date, type = '2_FALSE_COLOR') {
    var checkndvi = document.getElementById("ndvi-toggle");
    if (true) {
        const sentinelSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/514e719b-3d56-429e-bdc8-55b90d20d343',
            params: {
                layers: '2_FALSE_COLOR',
                time: date,
                preset: '2_FALSE_COLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        if (checkndvi.checked) {

            document.getElementById("ndvilengend").style.display = "block";
            return new ol.layer.Image({
                source: new ol.source.Raster({
                    sources: [sentinelSource],
                    operation: function (pixels) {
                        const pixel = pixels[0];
                        const nir = pixel[0] / 255; // Replace if using real NIR band
                        const red = pixel[1] / 255;
                        const ndvi = (nir - red) / (nir + red);
                        //if (ndvi >= 0.67) return [20, 90, 33, 255];
                        //else if (ndvi >= 0.46) return [50, 255, 90, 255];
                        //else if (ndvi >= 0.30) return [221, 137, 50, 255];
                        //else return [255, 0, 0, 255];

                        if (ndvi >= 0.60) return [20, 90, 33, 255];
                        else if (ndvi >= 0.40) return [50, 255, 90, 255];
                        else if (ndvi >= 0.20) return [221, 137, 50, 255];
                        else return [255, 0, 0, 255];
                    }
                })
            });

            return new ol.layer.Image({ source: ndviRaster });
        } else {
            document.getElementById("ndvilengend").style.display = "none";
            return new ol.layer.Tile({ source: sentinelSource });
        }
    }

}
function createNDVILayer(date) {
    return createSentinelLayer(date, 'NDVI');
}

function toggleNDVI() {
    showNDVI = document.getElementById('ndvi-toggle').checked;
    refreshLayers();
}

function changeMode(mode) {
    document.querySelectorAll('.panel-content').forEach(p => p.classList.remove('active'));
    document.getElementById(mode).classList.add('active');

    map1.getLayers().clear();
    map2.getLayers().clear();
    map1.addLayer(new ol.layer.Tile({ source: new ol.source.OSM() }));
    if (map2) {
        //map2.getLayers().clear();
        map2.addLayer(new ol.layer.Tile({ source: new ol.source.OSM() }));
    }

    if (mode === 'single') {
        document.getElementById('map1').style.width = '100%';
        document.getElementById('map2').style.width = '0%';
        document.getElementById('map2').style.display = 'none';
        map1.updateSize();
        map1.addLayer(zones);
        /*  map1.addOverlay(zones);*/
        document.getElementById('zonecheck').checked = true;
        document.getElementById('circlecheck').checked = false;
        document.getElementById('divisioncheck').checked = false;
    } else if (mode === 'dual') {
        document.getElementById('map1').style.width = '50%';
        document.getElementById('map2').style.width = '50%';
        document.getElementById('map2').style.display = 'block';
        map1.updateSize();
        map2.updateSize();


        map1.addLayer(zones);
        // map1.addOverlay(zones);

        map2.addLayer(zones);
        // map2.addOverlay(zones);

        document.getElementById('zonecheck').checked = true;
        document.getElementById('circlecheck').checked = false;
        document.getElementById('divisioncheck').checked = false;

    } else if (mode === 'swipe') {
        document.getElementById('map1').style.width = '100%';
        document.getElementById('map2').style.width = '0%';
        document.getElementById('map2').style.display = 'none';
        map1.updateSize();
        map1.addLayer(zones);
        //  map1.addOverlay(zones);
        document.getElementById('zonecheck').checked = true;
        document.getElementById('circlecheck').checked = false;
        document.getElementById('divisioncheck').checked = false;
        generateSwipeDates();
    }
}

function generateDateRange(baseDateStr) {
    const dates = [];
    const baseDate = new Date(baseDateStr);
    for (let i = 0; i < 10; i++) {
        const d = new Date(baseDate);
        d.setDate(d.getDate() - i * 5);
        dates.push(d.toISOString().split('T')[0]);
    }
    return dates;
}

function generateSingleDates() {
    const baseDate = document.getElementById('single-date').value;
    if (!baseDate) return;
    singleDates = generateDateRange(baseDate);
    document.getElementById('single-ticks').innerHTML = singleDates.map(d => `<span>${d}</span>`).join('');
    updateSingleLayer(0);
}

var date;


function updateSingleLayer(index) {
    date = singleDates[index];
    if (!date) return;

    // Remove existing layers
    if (sentinelLayer1) map1.removeLayer(sentinelLayer1);
    if (ndviLayer1) map1.removeLayer(ndviLayer1);

    // Create and add sentinel or NDVI layer
    sentinelLayer1 = createSentinelLayer(date);
    map1.addLayer(sentinelLayer1);

    // Check if NDVI is toggled
    const isNDVI = document.getElementById('ndvi-toggle').checked;

    if (isNDVI) {
        // Create and add vector mask layer
        cliplayer = createGeoServerLayer(
            lastselectedlayer_vector[lastselectedlayer_vector.length - 1],
            lastselectedlayer_vector_filter[0]
        );

        cliplayer.on('postcompose', function (e) {
            e.context.globalCompositeOperation = 'source-over';
        });

        cliplayer.on('precompose', function (e) {
            e.context.globalCompositeOperation = 'destination-in';
        });

        jQuery('#div_CropGrowth').css('display', 'block');

        map1.addLayer(cliplayer);
        layerobject.push(cliplayer);
        lastselectedlayer.push("Crop_Growth");
        lastselectedlayername.push("Crop Growth");
    } else {
        jQuery('#div_CropGrowth').css('display', 'none');
    }
}


function generateDualDates(windowNum) {
    const dateInput = document.getElementById(`dual-date${windowNum}`).value;
    if (!dateInput) return;
    const dates = generateDateRange(dateInput);
    document.getElementById(`dual-ticks${windowNum}`).innerHTML = dates.map(d => `<span>${d}</span>`).join('');
    if (windowNum === 1) {
        dualDates1 = dates;
        updateDualLayer(1, 0);
    } else {
        dualDates2 = dates;
        updateDualLayer(2, 0);
    }
}

function updateDualLayer(windowNum, index) {
    const dates = windowNum === 1 ? dualDates1 : dualDates2;
    const date = dates[index];
    if (!date) return;

    const baseLayer = createSentinelLayer(date);
    const ndviLayer = showNDVI ? createNDVILayer(date) : null;

    if (windowNum === 1) {
        if (sentinelLayer1) map1.removeLayer(sentinelLayer1);
        if (ndviLayer1) map1.removeLayer(ndviLayer1);
        sentinelLayer1 = baseLayer;
        map1.addLayer(sentinelLayer1);
        if (ndviLayer) {
            ndviLayer1 = ndviLayer;
            map1.addLayer(ndviLayer1);
        }
    } else {
        if (sentinelLayer2) map2.removeLayer(sentinelLayer2);
        if (ndviLayer2) map2.removeLayer(ndviLayer2);
        sentinelLayer2 = baseLayer;
        map2.addLayer(sentinelLayer2);
        if (ndviLayer) {
            ndviLayer2 = ndviLayer;
            map2.addLayer(ndviLayer2);
        }
    }
}

function generateSwipeDates() {
    const date1 = document.getElementById('swipe-date1').value;
    const date2 = document.getElementById('swipe-date2').value;
    if (!date1 || !date2) return;

    map1.getLayers().clear();
    map1.addLayer(new ol.layer.Tile({ source: new ol.source.OSM() }));

    swipeLayer1 = createSentinelLayer(date1);
    swipeLayer2 = createSentinelLayer(date2);
    swipeLayer1.on('prerender', applySwipeClipLeft);
    swipeLayer2.on('prerender', applySwipeClipRight);
    swipeLayer1.on('postrender', clearClip);
    swipeLayer2.on('postrender', clearClip);
    map1.addLayer(swipeLayer1);
    map1.addLayer(swipeLayer2);

    if (showNDVI) {
        swipeNDVILayer1 = createNDVILayer(date1);
        swipeNDVILayer2 = createNDVILayer(date2);
        swipeNDVILayer1.on('prerender', applySwipeClipLeft);
        swipeNDVILayer2.on('prerender', applySwipeClipRight);
        swipeNDVILayer1.on('postrender', clearClip);
        swipeNDVILayer2.on('postrender', clearClip);
        map1.addLayer(swipeNDVILayer1);
        map1.addLayer(swipeNDVILayer2);
    }

    map1.render();

    document.getElementById('swipe-slider').addEventListener('input', function () {
        map1.render(); // Just re-render to apply new clip width
    });
}

function applySwipeClipLeft(event) {
    const context = event.context;
    const sliderValue = parseFloat(document.getElementById('swipe-slider').value) / 100;
    const width = context.canvas.width * sliderValue;
    context.save();
    context.beginPath();
    context.rect(0, 0, width, context.canvas.height);
    context.clip();
}

function applySwipeClipRight(event) {
    const context = event.context;
    const sliderValue = parseFloat(document.getElementById('swipe-slider').value) / 100;
    const width = context.canvas.width * sliderValue;
    context.save();
    context.beginPath();
    context.rect(width, 0, context.canvas.width - width, context.canvas.height);
    context.clip();
}

function clearClip(event) {
    const context = event.context;
    context.restore();
}
var overlayLayer;
function updateSwipeSlider() {

    map1.render();
}
function refreshLayers() {
    const mode = document.querySelector('input[name="mode"]:checked').value;
    if (mode === 'single') {
        updateSingleLayer(document.getElementById('single-range').value);
    } else if (mode === 'dual') {
        updateDualLayer(1, document.getElementById('dual-range1').value);
        updateDualLayer(2, document.getElementById('dual-range2').value);
    } else if (mode === 'swipe') {
        generateSwipeDates();
    }
}



