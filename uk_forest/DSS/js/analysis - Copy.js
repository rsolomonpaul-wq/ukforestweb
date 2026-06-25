

var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";
//var sentinel2fcckey = "db40fc95-957e-4bdb-b62f-5770724febe8";
//var sentinel2ncckey = "de33a4ff-705e-4a5c-a163-a29bf59d8848";

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
            url: "https://services.sentinel-hub.com/ogc/wms/" + sentinel2fcckey,
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


    cliplayer = new ol.layer.Image({
        source: new ol.source.ImageVector({
            source: vectorSource,
            style: style_vector
        })
    });



    return cliplayer;
}


window.onload = function () {

    map1.addLayer(zones);
    map1.addOverlay(zones);

    layerobject.push(zones);

    document.getElementById("zonecheck").checked = true;

    lastselectedlayer.push("tbl_division_master");
    lastselectedlayername.push("Divisions Boundary");
    lastselectedlayer_vector.push("tbl_division_master");

}

const sharedView = new ol.View({
    center: ol.proj.fromLonLat([79.2593, 29.4068]),
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
            //layers: 'uk_sfd:tbl_2024',
            CQL_FILTER: "name='Reserve Forest'",
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'
    })
});

function firepoints(checkbox) {

    if (checkbox.checked) {

        map1.addLayer(forestfire_layer);
        map2.addLayer(forestfire_layer);
        map1.addOverlay(forestfire_layer);
        map2.addOverlay(forestfire_layer);
        layerobject.push(forestfire_layer);


    }
    else {

        map1.removeLayer(forestfire_layer);
        map2.removeLayer(forestfire_layer);
        layerobject.pop(forestfire_layer);
        map1.removeOverlay(forestfire_layer);
        map2.removeOverlay(forestfire_layer);

    }
}
var forestfire_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            //layers: 'uk_sfd:tbl_fire_polygon',
            layers: 'uk_sfd:uk_density_recode_color_final',

            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'
    })
});

function slop_fun(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_slope').css('display', 'block');

        layerobject.push(sloplayer);
        map1.addLayer(sloplayer);
        map2.addLayer(sloplayer);
        //map1.addOverlay(sloplayer);
        //map2.addOverlay(sloplayer);
        lastselectedlayer.push("Slop");
        lastselectedlayername.push("Slop");
        lastselectedlayer_vector.push("Slope_Geo");
        //village_zoom();
    }
    else {
        jQuery('#div_slope').css('display', 'none');

        layerobject.pop(sloplayer);
        map1.removeLayer(sloplayer);
        map2.removeLayer(sloplayer);
        //map1.removeOverlay(sloplayer);
        //map2.removeOverlay(sloplayer);
        lastselectedlayer.pop("Slop");
        lastselectedlayername.pop("Slop");
        lastselectedlayer_vector.pop("Slope_Geo");
    }
}

var sloplayer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:Slope_Geo',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});



function dtm_fun(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_dtm').css('display', 'block');

        layerobject.push(dtmlayer);
        map1.addLayer(dtmlayer);
        map2.addLayer(dtmlayer);
        //map1.addOverlay(dtmlayer);
        //map2.addOverlay(dtmlayer);
        lastselectedlayer.push("Uttaranchal_SRTM_GEO");
        lastselectedlayername.push("Uttaranchal_SRTM_GEO");
        lastselectedlayer_vector.push("Uttaranchal_SRTM_GEO");
        //village_zoom();
    }
    else {
        jQuery('#div_dtm').css('display', 'none');

        layerobject.pop(dtmlayer);
        map1.removeLayer(dtmlayer);
        map2.removeLayer(dtmlayer);
        //map1.removeOverlay(dtmlayer);
        //map2.removeOverlay(dtmlayer);
        lastselectedlayer.pop("Uttaranchal_SRTM_GEO");
        lastselectedlayername.pop("Uttaranchal_SRTM_GEO");
        lastselectedlayer_vector.pop("Uttaranchal_SRTM_GEO");
    }
}

var dtmlayer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:Uttaranchal_SRTM_GEO',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});



let sentinelLayer1, sentinelLayer2;
var ndviLayer1, ndviLayer2;
var swipeLayer1, swipeLayer2, swipeNDVILayer1, swipeNDVILayer2;
let showNDVI = false;
let singleDates = [];
let dualDates1 = [], dualDates2 = [];


let rasterListenerAdded = false;

function createSentinelLayer(date) {
    document.getElementById("key-switcher").style.display = "block";

    const checkndvi = document.getElementById("ndvi-toggle");
    const checkcbi = document.getElementById("ndvi-toggle1");
    const selectedindicies = document.querySelector('input[name="index"]:checked');

    const selected = document.querySelector('input[name="sentinel-type"]:checked').value;
    const mode = document.querySelector('input[name="mode"]:checked').value;

    const layerName = selected === 'fcc' ? '2_FALSE_COLOR' : '1_TRUE_COLOR';
    const key = selected === 'fcc' ? sentinel2fcckey : sentinel2ncckey;

    // Default true color source
    const trueColorSource = new ol.source.TileWMS({
        url: 'https://services.sentinel-hub.com/ogc/wms/' + key,
        params: {
            layers: layerName,
            time: date,
            preset: layerName,
            maxcc: 50
        },
        crossOrigin: 'anonymous'
    });

    // =================== NDVI PROCESSING ===================
    if (checkndvi.checked) {
        if (mode === "dual") {
            document.getElementById("ndvilengend").style.display = "block";
            document.getElementById("ndvilengendmap2").style.display = "block";
        } else {
            document.getElementById("ndvilengend").style.display = "block";
        }

        const falseColorSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: '2_FALSE_COLOR',
                time: date,
                preset: '2_FALSE_COLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        const rasterSource = new ol.source.Raster({
            sources: [falseColorSource],
            operation: function (pixels, data) {
                if (!data.counts) {
                    data.counts = { Dense: 0, Moderate: 0, Low: 0, Other: 0 };
                }
                const pixel = pixels[0];
                const nir = pixel[0] / 255;
                const red = pixel[1] / 255;
                const ndvi = (nir - red) / (nir + red);

                if (ndvi >= 0.60) {
                    data.counts.Dense++;
                    return [20, 90, 33, 255];
                } else if (ndvi >= 0.40) {
                    data.counts.Moderate++;
                    return [50, 255, 90, 255];
                } else if (ndvi >= 0.20) {
                    data.counts.Low++;
                    return [221, 137, 50, 255];
                } else {
                    data.counts.Other++;
                    return [255, 0, 0, 255];
                }
            }
        });

        if (!rasterListenerAdded) {
            rasterSource.on('afteroperations', function (event) {
                if (event.data && event.data.counts) {
                    const counts = event.data.counts;
                    const total = counts.Dense + counts.Moderate + counts.Low + counts.Other;

                    if (total > 0) {
                        const percentages = {
                            Dense: ((counts.Dense / total) * 100).toFixed(2),
                            Moderate: ((counts.Moderate / total) * 100).toFixed(2),
                            Low: ((counts.Low / total) * 100).toFixed(2),
                            Other: ((counts.Other / total) * 100).toFixed(2)
                        };

                        console.log("NDVI Counts:", counts);
                        console.log("NDVI Percentages (%):", percentages);
                        updateNdviStatsTable(percentages);
                    } else {
                        console.log("No pixels counted yet.");
                    }
                }
            });
            rasterListenerAdded = true;
        }

        return new ol.layer.Image({ source: rasterSource });
    }

    // =================== CBI PROCESSING ===================
    else if (checkcbi.checked) {
        if (mode === "dual") {
            document.getElementById("ndvilengend").style.display = "block";
            document.getElementById("ndvilengendmap2").style.display = "block";
        } else {
            document.getElementById("ndvilengend").style.display = "block";
        }

        const falseColorSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: '2_FALSE_COLOR',
                time: date,
                preset: '2_FALSE_COLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        const rasterSource = new ol.source.Raster({
            sources: [falseColorSource],
            operation: function (pixels) {
                const pixel = pixels[0];
                const nir = pixel[1] / 255;
                const r = pixel[1] / 255;
                const g = pixel[2] / 255;
                const nbr = (nir - (r + g)) / (nir + (r + g));

                if (nbr < -0.62) {
                    return [255, 0, 0, 255]; // High burn
                } else if (nbr < -0.2) {
                    return [255, 165, 0, 255]; // Moderate burn
                } else if (nbr < 0.4) {
                    return [255, 255, 0, 255]; // Low burn
                } else {
                    return [0, 255, 0, 255]; // Unburned
                }
            }
        });

        return new ol.layer.Image({ source: rasterSource });
    }

    // =================== DEFAULT: TRUE COLOR ONLY ===================
    else {
        document.getElementById("ndvilengend").style.display = "none";
        document.getElementById("ndvilengendmap2").style.display = "none";

        return new ol.layer.Tile({ source: trueColorSource });
    }
}



function updateNdviStatsTable(percentages) {
    const tbody = document.querySelector("#ndvi-stats-table tbody");
    tbody.innerHTML = "";

    for (const [category, value] of Object.entries(percentages)) {
        const row = document.createElement("tr");

        const catCell = document.createElement("td");
        catCell.textContent = category;

        const valCell = document.createElement("td");
        valCell.textContent = value;

        row.appendChild(catCell);
        row.appendChild(valCell);
        tbody.appendChild(row);
    }
}


//let rasterListenerAdded = false;
//function createSentinelLayer(date) {
//    document.getElementById("key-switcher").style.display = "block";
//    const checkndvi = document.getElementById("ndvi-toggle");
//    const checkcbi = document.getElementById("ndvi-toggle1");
//    const selected = document.querySelector('input[name="sentinel-type"]:checked').value;
//    const mode = document.querySelector('input[name="mode"]:checked').value;

//    const layerName = selected === 'fcc' ? '2_FALSE_COLOR' : '1_TRUE_COLOR';
//    const key = selected === 'fcc' ? sentinel2fcckey : sentinel2ncckey;

//    // 1_TRUE_COLOR layer for display
//    const trueColorSource = new ol.source.TileWMS({
//        url: 'https://services.sentinel-hub.com/ogc/wms/' + key,
//        params: {
//            layers: layerName,
//            time: date,
//            preset: layerName,
//            maxcc: 50
//        },
//        crossOrigin: 'anonymous'
//    });

//    if (checkndvi.checked) {
//        alert("sfsdf");
//        if (mode == "dual") {
//            document.getElementById("ndvilengend").style.display = "block";
//            document.getElementById("ndvilengendmap2").style.display = "block";
//        } else {
//            document.getElementById("ndvilengend").style.display = "block";
            
//        }
        

//        // Separate FALSE_COLOR source for NDVI processing
//        const falseColorSource = new ol.source.TileWMS({
//            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
//            params: {
//                layers: '2_FALSE_COLOR',
//                time: date,
//                preset: '2_FALSE_COLOR',
//                maxcc: 50
//            },
//            crossOrigin: 'anonymous'
//        });

//        return new ol.layer.Image({
//            source: new ol.source.Raster({
//                sources: [falseColorSource],
//                operation: function (pixels, data) {
//                    if (!data.counts) {
//                        data.counts = { Dense: 0, Moderate: 0, Low: 0, Other: 0 };
//                    }
//                    const pixel = pixels[0];
//                    const nir = pixel[0] / 255; // Update these indexes if bands are different
//                    const red = pixel[1] / 255;
//                    const ndvi = (nir - red) / (nir + red);
//                    if (ndvi >= 0.60) {
//                        data.counts.Dense++;
//                        return [20, 90, 33, 255];
//                    } else if (ndvi >= 0.40) {
//                        data.counts.Moderate++;
//                        return [50, 255, 90, 255];
//                    } else if (ndvi >= 0.20) {
//                        data.counts.Low++;
//                        return [221, 137, 50, 255];
//                    } else {
//                        data.counts.Other++;
//                        return [255, 0, 0, 255];
//                    }
//                    //if (ndvi >= 0.60) return [20, 90, 33, 255];
//                    //else if (ndvi >= 0.40) return [50, 255, 90, 255];
//                    //else if (ndvi >= 0.20) return [221, 137, 50, 255];
//                    //else return [255, 0, 0, 255];
//                }
//            })
             
//        });
//        if (!rasterListenerAdded) {
//            rasterSource.on('afteroperations', function (event) {
//                if (event.data && event.data.counts) {
//                    const counts = event.data.counts;
//                    const total = counts.Dense + counts.Moderate + counts.Low + counts.Other;

//                    if (total > 0) {
//                        const percentages = {
//                            Dense: ((counts.Dense / total) * 100).toFixed(2),
//                            Moderate: ((counts.Moderate / total) * 100).toFixed(2),
//                            Low: ((counts.Low / total) * 100).toFixed(2),
//                            Other: ((counts.Other / total) * 100).toFixed(2)
//                        };

//                        console.log("NDVI Counts:", counts);
//                        console.log("NDVI Percentages (%):", percentages);
//                        updateNdviStatsTable(percentages);
//                    } else {
//                        console.log("No pixels counted yet.");
//                    }
//                }
//            });
//            rasterListenerAdded = true;
//        }
//    } else if (checkcbi.checked) {
//        if (mode == "dual") {
//            document.getElementById("ndvilengend").style.display = "block";
//            document.getElementById("ndvilengendmap2").style.display = "block";
//        } else {
//            document.getElementById("ndvilengend").style.display = "block";

//        }

//        // Separate FALSE_COLOR source for NDVI processing
//        const falseColorSource = new ol.source.TileWMS({
//            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
//            params: {
//                layers: '2_FALSE_COLOR',
//                time: date,
//                preset: '2_FALSE_COLOR',
//                maxcc: 50
//            },
//            crossOrigin: 'anonymous'
//        });

//        return new ol.layer.Image({
//            source: new ol.source.Raster({
//                sources: [falseColorSource],
//                operation: function (pixels) {
//                    const pixel = pixels[0];
//                    const nir = pixel[1] / 255;
//                    const r = pixel[1] / 255; // Update these indexes if bands are different
//                    const g = pixel[2] / 255;
//                    const nbr = (nir - (r + g)) / (nir + (r + g));

//                    //if (nbr < -0.75) {
//                    //    return [255, 0, 0, 255];        // High burn (red)
//                    //} else if (nbr < - 0.4) {
//                    //    return [255, 165, 0, 255];      // Moderate burn (orange)
//                    //} else if (nbr < -0.) {
//                    //    return [255, 255, 0, 255];      // Low burn (yellow)
//                    //} else {
//                    //    return [0, 255, 0, 255];        // Unburned (green)
//                    //}
//                    console.log(nbr);
//                    if (nbr < -0.62) {
//                        return [255, 0, 0, 255];        // High burn (red)
//                    } else if (nbr < -0.2) {
//                        return [255, 165, 0, 255];      // Moderate burn (orange)
//                    } else if (nbr < 0.4) {
//                        return [255, 255, 0, 255];      // Low burn (yellow)
//                    } else {
//                        return [0, 255, 0, 255];        // Unburned (green)
//                    }

//                }
//            })
//        });
//    }
//    else {
//        document.getElementById("ndvilengend").style.display = "none";
//        document.getElementById("ndvilengendmap2").style.display = "none";

//        // Just show 1_TRUE_COLOR layer
//        return new ol.layer.Tile({ source: trueColorSource });
//    }
//}

function createNDVILayer(date) {
    return createSentinelLayer(date, 'NDVI');
}

function toggleNDVI() {
    showNDVI = document.getElementById('ndvi-toggle').checked;
    refreshLayers();
}

function changeMode(mode) {

    document.getElementById("ndvilengend").style.display = "none";
    document.getElementById("ndvilengendmap2").style.display = "none";
    document.getElementById("ndvi-toggle").checked = false;


    document.getElementById("key-switcher").style.display = "none";
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
        map1.addOverlay(zones);
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
        map1.addOverlay(zones);

        map2.addLayer(zones);
        map2.addOverlay(zones);

        document.getElementById('zonecheck').checked = true;
        document.getElementById('circlecheck').checked = false;
        document.getElementById('divisioncheck').checked = false;

    } else if (mode === 'swipe') {
        document.getElementById('map1').style.width = '100%';
        document.getElementById('map2').style.width = '0%';
        document.getElementById('map2').style.display = 'none';
        map1.updateSize();
        map1.addLayer(zones);
        map1.addOverlay(zones);
        document.getElementById('zonecheck').checked = true;
        document.getElementById('circlecheck').checked = false;
        document.getElementById('divisioncheck').checked = false;
        generateSwipeDates();
    }
}

function generateDateRange(baseDateStr) {
    const dates = [];
    const baseDate = new Date(baseDateStr);
    for (let i = 0; i < 5; i++) {
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
    if (cliplayer) map1.removeLayer(cliplayer);

    // Create and add Sentinel layer
    sentinelLayer1 = createSentinelLayer(date);
    //sentinelLayer1.setZIndex(0); // Bottom layer
    map1.addLayer(sentinelLayer1);

    // Check if NDVI is toggled
    const isNDVI = document.getElementById('ndvi-toggle').checked;
    const isCBI = document.getElementById('ndvi-toggle1').checked;
    console.log(isNDVI);
    console.log(isCBI);
    if (isNDVI || isCBI) {

        if (count == 0) {
            // alert("geoserver");
            cliplayer = createGeoServerLayer(
                lastselectedlayer_vector[lastselectedlayer_vector.length - 1],
                lastselectedlayer_vector_filter[0]
            );
        } else {
            // alert("poly sdfsfsdf");

            onMaskToggleChange();

        }

        if (cliplayer) {
            cliplayer.on('postcompose', function (e) {
                e.context.globalCompositeOperation = 'source-over';
            });

            cliplayer.on('precompose', function (e) {
                e.context.globalCompositeOperation = 'destination-in';
            });

            //jQuery('#div_CropGrowth').css('display', 'block');

            map1.addLayer(cliplayer);
        }

        layerobject.push(cliplayer);
        // lastselectedlayer.push("Crop_Growth");
        // lastselectedlayername.push("Crop Growth");
    } else {
        // jQuery('#div_CropGrowth').css('display', 'none');
        if (cliplayer) map1.removeLayer(cliplayer);
    }
}




function generateDualDates(windowNum) {

    document.getElementById("key-switcher").style.display = "block";
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
var ndviLayer1, ndviLayer2;
var vectorMaskLayer1, vectorMaskLayer2;

//function updateDualLayer(windowNum, index) {
//    alert(windowNum);
//    const dates = windowNum === 1 ? dualDates1 : dualDates2;
//    const date = dates[index];
//    if (!date) return;

//    const map = windowNum === 1 ? map1 : map2;

//    // Remove previous Sentinel and NDVI layers
//    if (windowNum === 1) {
//        if (sentinelLayer1) map.removeLayer(sentinelLayer1);
//        if (ndviLayer1) {
//            map.removeLayer(ndviLayer1);
//            ndviLayer1 = null;
//        }
//        if (vectorMaskLayer1) {
//            map.removeLayer(vectorMaskLayer1);
//            vectorMaskLayer1 = null;
//        }
//    } else {
//        if (sentinelLayer2) map.removeLayer(sentinelLayer2);
//        if (ndviLayer2) {
//            map.removeLayer(ndviLayer2);
//            ndviLayer2 = null;
//        }
//        if (vectorMaskLayer2) {
//            map.removeLayer(vectorMaskLayer2);
//            vectorMaskLayer2 = null;
//        }
//    }

//    // Create and add Sentinel layer
//    const baseLayer = createSentinelLayer(date);

//    map.addLayer(baseLayer);

//    // Store reference
//    if (windowNum === 1) {
//        sentinelLayer1 = baseLayer;
//    } else {
//        sentinelLayer2 = baseLayer;
//    }
//    var vectorMaskLayer;
//    // NDVI logic
//    const isNDVI = document.getElementById('ndvi-toggle').checked;
//    if (isNDVI) {
//        const ndviLayer = createNDVILayer(date);

//        map.addLayer(ndviLayer);

//        //if (count == 0) {
//        //    alert("geoserver");
//        //    cliplayer = createGeoServerLayer(
//        //        lastselectedlayer_vector[lastselectedlayer_vector.length - 1],
//        //        lastselectedlayer_vector_filter[0]
//        //    );
//        //} else {
//        //    alert("poly sdfsfsdf");

//        //    onMaskToggleChange();

//        //}

//        if (count == 0) {
//            alert("geoserver");
//            cliplayer = createGeoServerLayer(
//                lastselectedlayer_vector[lastselectedlayer_vector.length - 1],
//                lastselectedlayer_vector_filter[0]
//            );
//        } else {
//            alert("poly sdfsfsdf");

//            onMaskToggleChange();

//        }

//        if (vectorMaskLayer) {
//            vectorMaskLayer.on('precompose', function (e) {
//                e.context.globalCompositeOperation = 'destination-in';
//            });
//            vectorMaskLayer.on('postcompose', function (e) {
//                e.context.globalCompositeOperation = 'source-over';
//            });

//            map.addLayer(vectorMaskLayer);
//        }


//        if (windowNum === 1) {
//            ndviLayer1 = ndviLayer;
//            vectorMaskLayer1 = vectorMaskLayer;
//        } else {
//            ndviLayer2 = ndviLayer;
//            vectorMaskLayer2 = vectorMaskLayer;
//        }

//        layerobject.push(vectorMaskLayer);
//        lastselectedlayer.push("Crop_Growth");
//        lastselectedlayername.push("Crop Growth");
//    }
//}



function updateDualLayer(windowNum, index) {

    const dates = windowNum === 1 ? dualDates1 : dualDates2;
    const date = dates[index];
    if (!date) return;

    const map = windowNum === 1 ? map1 : map2;

    // Remove previous Sentinel and NDVI layers
    if (windowNum === 1) {
        if (sentinelLayer1) map.removeLayer(sentinelLayer1);
        if (ndviLayer1) {
            map.removeLayer(ndviLayer1);
            ndviLayer1 = null;
        }
        if (vectorMaskLayer1) {
            map.removeLayer(vectorMaskLayer1);
            vectorMaskLayer1 = null;
        }
    } else {
        if (sentinelLayer2) map.removeLayer(sentinelLayer2);
        if (ndviLayer2) {
            map.removeLayer(ndviLayer2);
            ndviLayer2 = null;
        }
        if (vectorMaskLayer2) {
            map.removeLayer(vectorMaskLayer2);
            vectorMaskLayer2 = null;
        }
    }

    // Create and add Sentinel layer
    const baseLayer = createSentinelLayer(date);

    map.addLayer(baseLayer);

    // Store reference
    if (windowNum === 1) {
        sentinelLayer1 = baseLayer;
    } else {
        sentinelLayer2 = baseLayer;
    }
    var vectorMaskLayer;
    // NDVI logic
    const isNDVI = document.getElementById('ndvi-toggle').checked;
    if (isNDVI) {
        const ndviLayer = createNDVILayer(date);

        map.addLayer(ndviLayer);

        if (count == 0) {
            //alert("geoserver");
            cliplayer = createGeoServerLayer(
                lastselectedlayer_vector[lastselectedlayer_vector.length - 1],
                lastselectedlayer_vector_filter[0]
            );
        } else {
            // alert("poly sdfsfsdf");

            onMaskToggleChange();

        }

        if (cliplayer) {
            cliplayer.on('postcompose', function (e) {
                e.context.globalCompositeOperation = 'source-over';
            });

            cliplayer.on('precompose', function (e) {
                e.context.globalCompositeOperation = 'destination-in';
            });

            //jQuery('#div_CropGrowth').css('display', 'block');

            map.addLayer(cliplayer);
        }


        if (windowNum === 1) {
            ndviLayer1 = ndviLayer;
            vectorMaskLayer1 = vectorMaskLayer;
        } else {
            ndviLayer2 = ndviLayer;
            vectorMaskLayer2 = vectorMaskLayer;
        }

        layerobject.push(vectorMaskLayer);
        lastselectedlayer.push("Crop_Growth");
        lastselectedlayername.push("Crop Growth");
    }
}

var swipeNDVILayer1, swipeNDVILayer2;
var swipeLayer1, swipeLayer2;
var vectorMaskLayer;

function generateSwipeDates() {
    const date1 = document.getElementById('swipe-date1').value;
    const date2 = document.getElementById('swipe-date2').value;
    if (!date1 || !date2) return;

    // Clear all layers
    map1.getLayers().clear();
    map1.addLayer(new ol.layer.Tile({ source: new ol.source.OSM() }));

    // --- Sentinel Swipe Layers ---
    swipeLayer1 = createSentinelLayer(date1);
    swipeLayer2 = createSentinelLayer(date2);

    //swipeLayer1.setZIndex(0);
    //swipeLayer2.setZIndex(0);

    swipeLayer1.on('precompose', applySwipeClipLeft);
    swipeLayer2.on('precompose', applySwipeClipRight);
    swipeLayer1.on('postcompose', clearClip);
    swipeLayer2.on('postcompose', clearClip);

    map1.addLayer(swipeLayer1);
    map1.addLayer(swipeLayer2);

    // --- NDVI + Vector Mask ---
    const isNDVI = document.getElementById('ndvi-toggle').checked;

    if (isNDVI) {
        // NDVI Layers
        swipeNDVILayer1 = createNDVILayer(date1);
        swipeNDVILayer2 = createNDVILayer(date2);

        //swipeNDVILayer1.setZIndex(1);
        //swipeNDVILayer2.setZIndex(1);

        swipeNDVILayer1.on('precompose', applySwipeClipLeft);
        swipeNDVILayer2.on('precompose', applySwipeClipRight);
        swipeNDVILayer1.on('postcompose', clearClip);
        swipeNDVILayer2.on('postcompose', clearClip);

        map1.addLayer(swipeNDVILayer1);
        map1.addLayer(swipeNDVILayer2);

        if (count == 0) {
            // alert("geoserver");
            vectorMaskLayer = createGeoServerLayer(
                lastselectedlayer_vector[lastselectedlayer_vector.length - 1],
                lastselectedlayer_vector_filter[0]
            );
        } else {
            // alert("poly sdfsfsdf");

            onMaskToggleChange();

        }

        if (vectorMaskLayer) {
            vectorMaskLayer.on('precompose', function (e) {
                e.context.globalCompositeOperation = 'destination-in';
            });
            vectorMaskLayer.on('postcompose', function (e) {
                e.context.globalCompositeOperation = 'source-over';
            });


            map1.addLayer(vectorMaskLayer);
            map1.addLayer(vectorMaskLayer);
        }


        jQuery('#div_CropGrowth').css('display', 'block');

        // Optional tracking
        layerobject.push(vectorMaskLayer);
        lastselectedlayer.push("Crop_Growth");
        lastselectedlayername.push("Crop Growth");

    } else {
        // Remove NDVI and vector layers if previously added
        if (swipeNDVILayer1) {
            map1.removeLayer(swipeNDVILayer1);
            swipeNDVILayer1 = null;
        }
        if (swipeNDVILayer2) {
            map1.removeLayer(swipeNDVILayer2);
            swipeNDVILayer2 = null;
        }
        if (vectorMaskLayer) {
            map1.removeLayer(vectorMaskLayer);
            vectorMaskLayer = null;
        }
        // jQuery('#div_CropGrowth').css('display', 'none');
    }

    // Swipe Slider Event
    document.getElementById('swipe-slider').addEventListener('input', function () {
        map1.render(); // Force re-render on slider input
    });
}


function applySwipeClipLeft(event) {
    const context = event.context;
    const width = context.canvas.width;
    const slider = document.getElementById('swipe-slider');
    const swipeValue = parseFloat(slider.value) || 0.5;
    const clipX = width * swipeValue;

    context.save();
    context.beginPath();
    context.rect(0, 0, clipX, context.canvas.height);
    context.clip();
}

function applySwipeClipRight(event) {
    const context = event.context;
    const width = context.canvas.width;
    const slider = document.getElementById('swipe-slider');
    const swipeValue = parseFloat(slider.value) || 0.5;
    const clipX = width * swipeValue;

    context.save();
    context.beginPath();
    context.rect(clipX, 0, width - clipX, context.canvas.height);
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
const uploadedLayers = [];
function uploadyourdata() {
    document.getElementById("popup_uploaddata").style.display = "block";
} function close_popup_uploaddata() {
    document.getElementById("popup_uploaddata").style.display = "none";
}


function showLoading(show) {
    document.getElementById('loading').style.display = show ? 'flex' : 'none';
}

function addVectorLayer(name, features) {
    const vectorSource = new ol.source.Vector({ features });
    const vectorLayer = new ol.layer.Vector({
        source: vectorSource,
        visible: true,
        style: new ol.style.Style({
            stroke: new ol.style.Stroke({ color: '#f20b97', width: 2 }),
            fill: new ol.style.Fill({ color: '#f6d24b0f' }),

        })
    });
    //vectorLayer.setZIndex(10); // always on top
    map1.addLayer(vectorLayer);
    map1.getView().fit(vectorSource.getExtent(), { padding: [20, 20, 20, 20] });
    //map2.addLayer(vectorLayer);
    //map2.getView().fit(vectorSource.getExtent(), { padding: [20, 20, 20, 20] });

    const layerId = 'layer_' + Date.now();
    uploadedLayers.push({ id: layerId, name, layer: vectorLayer });

    const layerItem = document.createElement('div');
    layerItem.className = 'layer-item';
    layerItem.id = layerId;

    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.checked = true;
    checkbox.addEventListener('change', () => {
        vectorLayer.setVisible(checkbox.checked);
    });

    const label = document.createElement('label');
    label.textContent = name;
    label.style.marginLeft = '5px';

    const deleteBtn = document.createElement('button');
    deleteBtn.textContent = 'Delete';
    deleteBtn.addEventListener('click', () => {
        map1.removeLayer(vectorLayer);
        document.getElementById('layerList').removeChild(layerItem);
        const index = uploadedLayers.findIndex(l => l.id === layerId);
        if (index !== -1) uploadedLayers.splice(index, 1);
    });

    const nameGroup = document.createElement('div');
    nameGroup.style.display = 'flex';
    nameGroup.style.alignItems = 'center';
    nameGroup.appendChild(checkbox);
    nameGroup.appendChild(label);

    layerItem.appendChild(nameGroup);
    layerItem.appendChild(deleteBtn);
    document.getElementById('layerList').appendChild(layerItem);
}


const uploaded = [];
let sentinelLayer = null;


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

var count = 0;

let vectorSource = new ol.source.Vector();
let polygonLayer = new ol.layer.Vector({
    source: vectorSource,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({ color: '#f20b97', width: 2 }),
        fill: new ol.style.Fill({ color: 'rgba(0, 0, 255, 0.2)' })
    })
});
map1.addLayer(polygonLayer);


let maskLayer = null;

function geojsonToOLFeature(geojson) {
    const format = new ol.format.GeoJSON();
    return format.readFeature(geojson, {
        featureProjection: map1.getView().getProjection()
    });
}

// Check ring winding order (clockwise or not)
function ringIsClockwise(coords) {
    let sum = 0;
    for (let i = 0, len = coords.length - 1; i < len; i++) {
        sum += (coords[i + 1][0] - coords[i][0]) * (coords[i + 1][1] + coords[i][1]);
    }
    return sum > 0;
}


function createMaskLayerFromFeatures(features) {
    const projection = map1.getView().getProjection();

    // Full world extent in EPSG:3857
    const extent = ol.proj.transformExtent([-180, -90, 180, 90], 'EPSG:4326', projection);

    // Define a large outer ring (must be clockwise)
    let outerRing = [
        [extent[0], extent[1]],
        [extent[0], extent[3]],
        [extent[2], extent[3]],
        [extent[2], extent[1]],
        [extent[0], extent[1]]
    ];
    if (!ringIsClockwise(outerRing)) outerRing.reverse();

    const holes = [];

    features.forEach(feature => {
        const geom = feature.getGeometry();

        if (geom instanceof ol.geom.Polygon) {
            const coords = geom.getCoordinates()[0].slice();
            if (ringIsClockwise(coords)) coords.reverse(); // Hole = counter-clockwise
            holes.push(coords);
        }

        if (geom instanceof ol.geom.MultiPolygon) {
            geom.getCoordinates().forEach(polygonCoords => {
                const coords = polygonCoords[0].slice();
                if (ringIsClockwise(coords)) coords.reverse();
                holes.push(coords);
            });
        }
    });

    // Create a polygon with outer ring and holes
    const maskGeom = new ol.geom.Polygon([outerRing, ...holes]);

    const maskFeature = new ol.Feature(maskGeom);

    const maskLayer = new ol.layer.Vector({
        source: new ol.source.Vector({ features: [maskFeature] }),
        style: new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.8)'  // White outside the holes
            }),
            stroke: null
        }),
        zIndex: 999
    });

    return maskLayer;
}


// Ring winding helper
function ringIsClockwise(coords) {
    let sum = 0;
    for (let i = 0; i < coords.length - 1; i++) {
        const [x1, y1] = coords[i];
        const [x2, y2] = coords[i + 1];
        sum += (x2 - x1) * (y2 + y1);
    }
    return sum > 0;
}


function fixCoordinates(geometry) {
    const fixCoords = coords => {
        if (typeof coords[0] === 'number') return coords.slice(0, 2);
        return coords.map(fixCoords);
    };
    return { type: geometry.type, coordinates: fixCoords(geometry.coordinates) };
}

// When mask checkbox toggles
function uploadclip(checked) {
    if (checked.checked) {
        if (maskLayer) map1.removeLayer(maskLayer);

        const features11 = new ol.format.GeoJSON().readFeatures(vectorLayer1, {
            featureProjection: map1.getView().getProjection()
        });
        maskLayer = createMaskLayerFromFeatures(features11);
        console.log(maskLayer);
        if (maskLayer) {
            map1.addLayer(maskLayer);

            map1.addOverlay(maskLayer);
            map2.addLayer(maskLayer);

            map2.addOverlay(maskLayer);
        }
    } else {
        if (maskLayer) {
            map2.removeLayer(maskLayer);
            map2.removeOverlay(maskLayer);
            map1.removeLayer(maskLayer);
            map1.removeOverlay(maskLayer);
            maskLayer = null;
        }
    }
}


let vectorLayer1 = null;
let vectorLayer2 = null;
let maskLayer1 = null;
let maskLayer2 = null;
let uploadedFeatures = null; // 🔁 NEW: store features globally

document.getElementById('fileInput').addEventListener('change', function (event) {
    const file = event.target.files[0];
    if (!file || !file.name.endsWith('.zip')) {
        alert('Please upload a valid .zip shapefile.');
        return;
    }

    const reader = new FileReader();
    reader.onload = function (e) {
        const arrayBuffer = e.target.result;
        shp(arrayBuffer).then(function (geojson) {
            // Remove old layers if they exist
            if (vectorLayer1) map1.removeLayer(vectorLayer1);
            if (vectorLayer2) map2.removeLayer(vectorLayer2);
            if (maskLayer1) map1.removeLayer(maskLayer1);
            if (maskLayer2) map2.removeLayer(maskLayer2);

            const features = new ol.format.GeoJSON().readFeatures(geojson, {
                featureProjection: 'EPSG:3857'
            });

            uploadedFeatures = features; // 🔁 Save for use in toggle function

            const vectorSource = new ol.source.Vector({ features });

            const vectorStyle = new ol.style.Style({
                stroke: new ol.style.Stroke({ color: '#FF2DD1', width: 2 }),
                fill: new ol.style.Fill({ color: '#FF2DD100' })
            });

            vectorLayer1 = new ol.layer.Vector({ source: vectorSource, style: vectorStyle });
            vectorLayer2 = new ol.layer.Vector({ source: vectorSource, style: vectorStyle });

            map1.addLayer(vectorLayer1);
            map1.addOverlay(vectorLayer1);
            map2.addLayer(vectorLayer2);
            map2.addOverlay(vectorLayer2);

            const extent = vectorSource.getExtent();
            map1.getView().fit(extent, { padding: [50, 50, 50, 50], maxZoom: 18 });
            map2.getView().fit(extent, { padding: [50, 50, 50, 50], maxZoom: 18 });
            document.getElementById("popup_uploaddata").style.display = "none";
            count = 1;
            //onMaskToggleChange(); // apply mask if checkbox is already checked

        }).catch(err => {
            alert('Error reading shapefile: ' + err);
        });
    };

    reader.readAsArrayBuffer(file);
});

function onMaskToggleChange() {
    const checkbox = document.getElementById('ndvi-toggle');
    if (!uploadedFeatures) return;

    if (checkbox.checked) {
        if (maskLayer1) map1.removeLayer(maskLayer1);
        if (maskLayer2) map2.removeLayer(maskLayer2);
        maskLayer1 = createMaskLayerFromFeatures(uploadedFeatures, map1);
        maskLayer2 = createMaskLayerFromFeatures(uploadedFeatures, map2);
        map1.addLayer(maskLayer1);
        map2.addLayer(maskLayer2);
    } else {
        if (maskLayer1) {
            maskLayer1.un('precompose', maskPrecomposeHandler);
            maskLayer1.un('postcompose', maskPostcomposeHandler);
            map1.removeLayer(maskLayer1);
            maskLayer1 = null;
        }
        if (maskLayer2) {
            maskLayer2.un('precompose', maskPrecomposeHandler);
            maskLayer2.un('postcompose', maskPostcomposeHandler);
            map2.removeLayer(maskLayer2);
            maskLayer2 = null;
        }

        // Force full re-render to clear canvas state
        map1.renderSync();
        map2.renderSync();
    }
}

function createMaskLayerFromFeatures(features, map) {
    const projection = map.getView().getProjection();
    const extent = ol.proj.transformExtent([-180, -90, 180, 90], 'EPSG:4326', projection);

    let outerRing = [
        [extent[0], extent[1]],
        [extent[0], extent[3]],
        [extent[2], extent[3]],
        [extent[2], extent[1]],
        [extent[0], extent[1]]
    ];
    if (!ringIsClockwise(outerRing)) outerRing.reverse();

    const holes = [];

    features.forEach(feature => {
        const geom = feature.getGeometry();
        if (geom instanceof ol.geom.Polygon) {
            let coords = geom.getCoordinates()[0].slice();
            if (ringIsClockwise(coords)) coords.reverse();
            holes.push(coords);
        } else if (geom instanceof ol.geom.MultiPolygon) {
            geom.getCoordinates().forEach(polygon => {
                let coords = polygon[0].slice();
                if (ringIsClockwise(coords)) coords.reverse();
                holes.push(coords);
            });
        }
    });

    const maskPolygon = new ol.geom.Polygon([outerRing, ...holes]);
    const maskFeature = new ol.Feature(maskPolygon);

    return new ol.layer.Vector({
        source: new ol.source.Vector({ features: [maskFeature] }),
        style: new ol.style.Style({
            fill: new ol.style.Fill({ color: 'rgba(255, 255, 255, 1)' }),
            stroke: null
        }),
        zIndex: 999
    });
}

function ringIsClockwise(coords) {
    let sum = 0;
    for (let i = 0; i < coords.length - 1; i++) {
        const [x1, y1] = coords[i];
        const [x2, y2] = coords[i + 1];
        sum += (x2 - x1) * (y2 + y1);
    }
    return sum > 0;
}



function removeAllUploadedLayers() {
    //     vectorSource.clear();
    //      count = 0;
    //     if (maskLayer) {
    //         map1.removeLayer(maskLayer);
    //         maskLayer = null;
    //     }

    //     document.getElementById('maskToggle').checked = false;

    //    // map1.getView().setCenter(ol.proj.fromLonLat([79.5, 30]));
    //     map1.getView().setZoom(8);
    /*view: sharedView*/
    window.location.reload();
}


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////



var currentLayer;
document.getElementById('sentinel-form').addEventListener('change', () => {
    const selected = document.querySelector('input[name="sentinel-type"]:checked').value;
    switchSentinelLayer(selected);
});

function switchSentinelLayer(type) {
    if (currentLayer) {
        map1.removeLayer(currentLayer);
        map2.removeLayer(currentLayer);
    }

    currentLayer = createSentinelLayerswitch(type);
    map1.addLayer(currentLayer);
    map1.addOverlay(currentLayer);
    map2.addLayer(currentLayer);
    map2.addOverlay(currentLayer);
}

function createSentinelLayerswitch(type) {
    const layerName = type === 'fcc' ? '2_FALSE_COLOR' : '1_TRUE_COLOR';
    const key = type === 'fcc' ? sentinel2fcckey : sentinel2ncckey;

    var rangeInput = document.getElementById('single-range');
    console.log(rangeInput);
    console.log(singleDates);
    rangeInput = singleDates[rangeInput];
    console.log();

    return new ol.layer.Tile({
        source: new ol.source.TileWMS({
            url: `https://services.sentinel-hub.com/ogc/wms/${key}`,
            params: {
                LAYERS: layerName,
                TIME: rangeInput,
                MAXCC: 50,
                FORMAT: 'image/png',
                TRANSPARENT: true
            },
            crossOrigin: 'anonymous'
        }),
        opacity: 0.8 // Optional: blend with base layer
    });
}




// Add ghost cursor to each map
function addGhostCursor(mapId) {
    const container = document.getElementById(mapId);
    const ghost = document.createElement('div');
    ghost.className = 'ghost-cursor';
    ghost.textContent = '+';
    container.appendChild(ghost);
    return ghost;
}

const ghostOnMap1 = addGhostCursor('map1');
const ghostOnMap2 = addGhostCursor('map2');

let activeMap = null; // To track which map has the real mouse

// Utility to hide all ghost cursors
function hideGhosts() {
    ghostOnMap1.style.display = 'none';
    ghostOnMap2.style.display = 'none';
}

function syncGhostCursor(sourceMap, sourceId, targetMap, targetId, targetGhost) {
    const sourceDiv = document.getElementById(sourceId);
    const targetDiv = document.getElementById(targetId);

    sourceMap.on('pointermove', function (evt) {
        activeMap = sourceId;

        const coord = sourceMap.getCoordinateFromPixel(evt.pixel);
        if (coord) {
            const pixelOnTarget = targetMap.getPixelFromCoordinate(coord);
            if (pixelOnTarget) {
                targetGhost.style.left = pixelOnTarget[0] + 'px';
                targetGhost.style.top = pixelOnTarget[1] + 'px';

                // Show ghost only on the target map
                if (activeMap === sourceId) {
                    targetGhost.style.display = 'block';
                }
            }
        }
    });

    sourceMap.getViewport().addEventListener('mouseleave', () => {
        hideGhosts();
        activeMap = null;
    });
}

// Setup syncing in both directions
syncGhostCursor(map1, 'map1', map2, 'map2', ghostOnMap2);
syncGhostCursor(map2, 'map2', map1, 'map1', ghostOnMap1);




function downloadreport() {
    var file = 'report_' + Date.now() + '.pdf';
    downloadMapAndLegendPdf({
        title: 'NDVI Report',
        fileName: file
    });
}

async function downloadMapAndLegendPdf(options = {}) {
    const title = options.title || 'Map Report';
    const fileName = options.fileName || 'map-report.pdf';

    const mapElement = document.getElementById('map1');
    const legendElement = document.getElementById('legend');

    // Hide legend before capturing map image to avoid duplication
    legendElement.style.visibility = 'hidden';

    const mapCanvas = await html2canvas(mapElement, {
        useCORS: true,
        allowTaint: false,
        scale: 2
    });

    // Restore legend visibility
    legendElement.style.visibility = 'visible';

    const mapImgData = mapCanvas.toDataURL('image/png');

    // Capture legend div separately for clean PDF legend image
    const legendCanvas = await html2canvas(legendElement, {
        scale: 2,
        backgroundColor: '#fff'
    });
    const legendImgData = legendCanvas.toDataURL('image/png');

    const { jsPDF } = window.jspdf;
    const pdf = new jsPDF({
        orientation: 'portrait',
        unit: 'pt',
        format: 'a4'
    });

    const pageWidth = pdf.internal.pageSize.getWidth();
    const pageHeight = pdf.internal.pageSize.getHeight();
    const margin = 40;

    // Title
    pdf.setFontSize(18);
    pdf.setFont('helvetica', 'bold');
    pdf.text(title, pageWidth / 2, margin, { align: 'center' });

    // Add Map Image
    const availableMapWidth = pageWidth - margin * 2;
    const mapAspect = mapCanvas.width / mapCanvas.height;
    const mapImgWidth = availableMapWidth;
    const mapImgHeight = mapImgWidth / mapAspect;
    const mapY = margin + 20;
    pdf.addImage(mapImgData, 'PNG', margin, mapY, mapImgWidth, mapImgHeight);

    // Add Legend Image below map
    const legendAspect = legendCanvas.width / legendCanvas.height;
    const legendWidth = 150; // width for legend box
    const legendHeight = legendWidth / legendAspect;
    const legendY = mapY + mapImgHeight + 20;
    pdf.setFontSize(14);
    pdf.setFont('helvetica', 'bold');
    pdf.text('Legend', margin, legendY);
    pdf.addImage(legendImgData, 'PNG', margin, legendY + 10, legendWidth, legendHeight);

    // Add Results Table below legend
    let nextY = legendY + 10 + legendHeight + 20;
    pdf.setFontSize(14);
    pdf.setFont('helvetica', 'bold');
    pdf.text('Table: Results', margin, nextY);

    pdf.autoTable({
        html: '#ndvi-stats-table',
        startY: nextY + 10,
        theme: 'grid',
        styles: {
            font: 'helvetica',
            fontSize: 10
        },
        headStyles: {
            fillColor: [41, 128, 185],
            textColor: 255,
            halign: 'center'
        },
        margin: { left: margin, right: margin }
    });

    // Footer
    const today = new Date().toLocaleDateString();
    pdf.setFontSize(10);
    pdf.setFont('helvetica', 'normal');
    pdf.text(`Generated on ${today}`, margin, pageHeight - 10);

    // Save the PDF
    pdf.save(fileName);
}


/////////////////////////////////////var boundrayfilter;

function applyfilter() {
    var zone = document.getElementById("ContentPlaceHolder1_ddlzone").value;
    var circle = document.getElementById("ContentPlaceHolder1_ddlcircle").value;
    var division = document.getElementById("ContentPlaceHolder1_ddldivision").value;
    var range = document.getElementById("ContentPlaceHolder1_ddlrange").value;
    var beat = document.getElementById("ContentPlaceHolder1_ddlbeat").value;

    var filterParts = [];

    if (zone !== "All") filterParts.push("zone = '" + zone + "'");
    if (circle !== "All") filterParts.push("circle = '" + circle + "'");
    if (division !== "All") filterParts.push("division = '" + division + "'");
    if (range !== "All") filterParts.push("range = '" + range + "'");
    if (beat !== "All") filterParts.push("beat = '" + beat + "'");

    var cqlFilter = filterParts.join(" AND ");

    // Find the last condition (e.g., beat = 'kamil')
    let findboundarylayerfilter = filterParts[filterParts.length - 1];
    let [layerKey, valueRaw] = findboundarylayerfilter.split('=');

    let layername = layerKey.trim(); // e.g. "beat"
    let dataname = valueRaw.trim().replace(/^["']?(.*?)["']?$/, "$1"); // remove quotes

    loadFilteredFeature(layername, dataname);
}

let vectorLayer;

async function loadFilteredFeature(layername, value) {
    const layernamebuild = "tbl_" + layername + "_master";

    if (!vectorLayer) {
        vectorLayer = new ol.layer.Vector({
            source: new ol.source.Vector(),
            style: new ol.style.Style({
                stroke: new ol.style.Stroke({
                    color: 'red',
                    width: 2
                }),
                fill: new ol.style.Fill({
                    color: 'rgba(255,0,0,0.1)'
                })
            })
        });
        map1.addLayer(vectorLayer);
        map1.addOverlay(vectorLayer);
    }

    const wfsUrl = 'https://ukforestgis.in/geoserver/uk_sfd/ows';
    const params = new URLSearchParams({
        service: 'WFS',
        version: '1.1.0',
        request: 'GetFeature',
        typeName: layernamebuild,
        outputFormat: 'application/json',
        CQL_FILTER: `${layername} ILIKE '${value}'`
    });

    try {
        const response = await fetch(`${wfsUrl}?${params.toString()}`);
        const data = await response.json();

        const format = new ol.format.GeoJSON();
        const features = format.readFeatures(data, {
            dataProjection: 'EPSG:4326',
            featureProjection: 'EPSG:3857'
        });

        const source = vectorLayer.getSource();
        source.clear();

        if (!features.length) {
            alert(`No features found for ${layername}: ${value}`);
            return;
        }

        source.addFeatures(features);

        const extent = source.getExtent();
        map1.getView().fit(extent, { duration: 1000, padding: [40, 40, 40, 40] });

    } catch (err) {
        console.error('Error loading WFS data:', err);
        alert('Failed to load data.');
    }
}

