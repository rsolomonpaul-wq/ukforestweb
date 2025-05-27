
var geoserver_ip = "http://180.151.15.18:9007/geoserver/uk_sfd/wms?";

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
var overlay = new ol.Overlay(({
    element: container,
    autoPan: true,
    autoPanAnimation: {
        duration: 250
    }
}));

//}
var count = 0;
var timlapse;
var time_range;
if (count == 0) {

    ////--------------------------------for sentinel and Ortho Image----------------------------------
    var cTime = new Date();
    var syear = cTime.getFullYear();
    var smonth = cTime.getMonth() + 1;
    if (smonth < 10) {
        smonth = "0" + smonth;
    }
    var sday = cTime.getDate();
    if (sday < 10) {
        sday = "0" + sday;
    }

    var sto_date = syear + "-" + smonth + "-" + sday;
    var sfrom_date = new Date(sto_date);
    sfrom_date.setDate(sfrom_date.getDate() - 14);
    timlapse = sfrom_date.toISOString().slice(0, 10) + "/" + sto_date;
    time_range = syear + '-' + smonth + '-01T00:00:00.000Z';

}

function setDateVariable() {
    count = 0;
    // Get the date input value
    selectedDate = document.getElementById("time").value;
    var year = selectedDate.split("-")[0]; // First part is the year (YYYY)
    var month = selectedDate.split("-")[1]; // Second part is the month (MM)
    var day = selectedDate.split("-")[2]; // Second part is the day (DD)
    time_range = year + '-' + month + '-' + day + 'T00:00:00.000Z';


    const wmsSource = CropGrowth_layer.getSource();
    wmsSource.updateParams({ 'time': time_range });

    const wmsSource_CropHealth_layer = CropHealth_layer.getSource();
    wmsSource_CropHealth_layer.updateParams({ 'time': time_range });

    const wmsSource_CropHarvesting_layer = CropHarvesting_layer.getSource();
    wmsSource_CropHarvesting_layer.updateParams({ 'time': time_range });

    const wmsSource_VegetationMoisture_layer = VegetationMoisture_layer.getSource();
    wmsSource_VegetationMoisture_layer.updateParams({ 'time': time_range });

    const wmsSource_NitrogenContent_layer = NitrogenContent_layer.getSource();
    wmsSource_NitrogenContent_layer.updateParams({ 'time': time_range });

    const wmsSource_SoilMoisture_layer = SoilMoisture_layer.getSource();
    wmsSource_SoilMoisture_layer.updateParams({ 'time': time_range });

    const wmsSource_base = layers['basemap_ortho'].getSource();
    wmsSource_base.updateParams({ 'time': time_range });



    /*   var cTime = new Date();*/

    var cTime = new Date(selectedDate);
    var syear = cTime.getFullYear();
    var smonth = cTime.getMonth() + 1;
    if (smonth < 10) {
        smonth = "0" + smonth;
    }
    var sday = cTime.getDate();
    if (sday < 10) {
        sday = "0" + sday;
    }

    var sto_date = syear + "-" + smonth + "-" + sday;
    var sfrom_date = new Date(sto_date);
    sfrom_date.setDate(sfrom_date.getDate() - 14);
    timlapse = sfrom_date.toISOString().slice(0, 10) + "/" + sto_date;

    const wmsSource_sentinal1 = layers['sentinel1'].getSource();
    wmsSource_sentinal1.updateParams({ 'time': timlapse });

    const wmsSource_sentinal2 = layers['sentinel2fcc'].getSource();
    wmsSource_sentinal2.updateParams({ 'time': timlapse });

    sentinel_layer.getSource().updateParams({ 'time': timlapse });

    if (selectedLayerId == "sentinel2fcc")
        zoomInOutOnce();
}


var layers = {
    'osm': new ol.layer.Tile({
        title: 'OpenStreetMap',
        visible: true,
        source: new ol.source.OSM()
    })
};

var map = new ol.Map({
    target: 'map',
    layers: Object.values(layers),
    view: new ol.View({
     
        center: ol.proj.fromLonLat([79.0193, 30.0668]),
        zoom: 8,
        minZoom: 3,
        maxZoom: 18


    })
});

function sfdzone(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_zone').css('display', 'block');
        map.addLayer(zones);
        layerobject.push(zones);
        map.addOverlay(zones);
        lastselectedlayer.push("tbl_zone_master");
        lastselectedlayername.push("SFD Zone Boundaries");
        lastselectedlayer_vector.push("tbl_zone_master");
        //village_zoom();
    }
    else {
        jQuery('#div_zone').css('display', 'none');
        map.removeLayer(zones);
        layerobject.pop(zones);
        map.removeOverlay(zones);
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



var map, geojson, layer_name, layerSwitcher, featureOverlay;
var container, content, closer;


/*===========================================AOI Bind============================================*/
var sentinel_layer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
        url: "https://services.sentinel-hub.com/ogc/wms/13d5aaea-1d0e-4581-9288-a463ce586119",
        //url: "https://services.sentinel-hub.com/ogc/wms/9b4d93bf-b7e5-4588-9394-cf70951aed63",
        params: { "maxcc": 85, "minZoom": 6, "maxZoom": 16, "preset": "2_FALSE_COLOR", "layers": "2_FALSE_COLOR", "time": timlapse },
        //params: { "maxcc": 85, "minZoom": 6, "maxZoom": 16, "preset": "2_FALSE_COLOR", "layers": "2_FALSE_COLOR" ,"time":'2024-09-27/2024-12-10' },
        serverType: 'geoserver',
        crossOrigin: 'anonymous',
        transition: 0

    })
});

var style_raster = new ol.style.Style({
    fill: new ol.style.Fill({
        color: [0, 0, 0, 1]
    })
});

function createGeoServerLayer(lastselectedlayer, filter) {
    // Construct GeoServer URL
    //console.log(lastselectedlayer);
    var geoServerURL = null;
    if (filter == null) {
        geoServerURL = "http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:" + lastselectedlayer + "&outputFormat=application/json";
    }
    else {
        geoServerURL = "http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:" + lastselectedlayer + "&outputFormat=application/json&CQL_FILTER=" + filter;
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


/*================================Crop Growth Calculation (LAI)==============================*/

/*==========Ortho Image NDVI =======*/
var CropGrowth_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            //layers: 'nrdc:Apple_NDVI',
            layers: 'nrdc:Crop_Growth',
            transition: 0,
            time: time_range

        }
    })
});

/*===========Sentinel NDVI======*/

var LAI_raster = new ol.source.Raster({
    sources: [sentinel_layer.getSource()],
    style: style_raster,
    operation: function (pixels, data) {
        var pixel = pixels[0];
        var value = sentinel_lai(pixel);
        //  summarize(value, data.counts);
        if (value <= 0.2599) {
            pixel[0] = 221;
            pixel[1] = 221;
            pixel[2] = 221;
            pixel[3] = 255;
        }

        else if (value >= 0.26 && value <= 0.4999) { //pre
            pixel[0] = 254;
            pixel[1] = 227;
            pixel[2] = 80;
            pixel[3] = 255;
        }

        else if (value >= 0.50 && value <= 1.5999) { //eme
            pixel[0] = 223;
            pixel[1] = 254;
            pixel[2] = 177;
            pixel[3] = 255;
        }
        else if (value >= 1.60 && value <= 3.999) { //vege
            pixel[0] = 53;
            pixel[1] = 254;
            pixel[2] = 104;
            pixel[3] = 255;
        }
        else if (value >= 4.0) { //repro
            pixel[0] = 22;
            pixel[1] = 191;
            pixel[2] = 30;
            pixel[3] = 255;
        }

        else {
            pixel[3] = 0;
        }
        return pixel;
    },
    lib: {
        sentinel_lai: sentinel_lai,
    }

});
LAI_raster.set('threshold', 0.1);

function sentinel_lai(pixel) {

    var nir = pixel[0] / 255;
    var r = pixel[1] / 255;
    var g = pixel[2] / 255;
    var b = pixel[3] / 255;
    var G = 2.5;
    var C1 = 2.4;
    var C2 = 7.5;
    var L = 1.0;

    var evi = (G * ((nir - r) / (nir + C1 * r + L)));
    var lai = (3.618 * evi - 0.118); // LAI = (3.618*EVI - 0.118);

    return lai;


};

var LAILayer = new ol.layer.Image({
    title: 'NDVI1',
    source: LAI_raster
});

function CropGrowth(checkbox) {
    selectedLayerId = document.getElementById("layerswid").value;
    if (checkbox.checked) {
        if (selectedLayerId == "sentinel2fcc")
            map.addLayer(LAILayer);
        else if (selectedLayerId == 'basemap_ortho')
            map.addLayer(CropGrowth_layer);
        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], lastselectedlayer_vector_filter[0]);
        cliplayer.on('postcompose', function (e) {
            e.context.globalCompositeOperation = 'source-over';
        });
        cliplayer.on('precompose', function (e) {
            e.context.globalCompositeOperation = 'destination-in';
        });

        jQuery('#div_CropGrowth').css('display', 'block');

        map.addLayer(cliplayer);
        layerobject.push(cliplayer);
        map.addOverlay(cliplayer);
        lastselectedlayer.push("Crop_Growth");
        lastselectedlayername.push("Crop Growth");


    }
    else {
        jQuery('#div_CropGrowth').css('display', 'none');
        if (selectedLayerId == "sentinel2fcc")
            map.removeLayer(LAILayer);
        else if (selectedLayerId == 'basemap_ortho')
            map.removeLayer(CropGrowth_layer);
        map.removeLayer(cliplayer);
        layerobject.pop(cliplayer);
        map.removeOverlay(cliplayer);
        lastselectedlayer.pop("Apple_NDVI");
        lastselectedlayername.pop("Crop Growth");
    }
}

/*================================Crop Health Calculation (NDVI)==============================*/

/*==========Ortho Image NDVI =======*/
var CropHealth_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            //layers: 'nrdc:Apple_NDVI',
            layers: 'nrdc:Crop_Health',
            transition: 0,
            time: time_range
            //time: '2024-10-01T00:00:00.000Z'

        }
    })
});

/*===========Sentinel NDVI======*/

var ndvi_raster = new ol.source.Raster({
    sources: [sentinel_layer.getSource()],
    style: style_raster,
    operation: function (pixels, data) {
        var pixel = pixels[0];
        var value = sentinel_ndvi(pixel);
      
        if (value >= 0.67) {
            pixel[0] = 20;
            pixel[1] = 90;
            pixel[2] = 33;
            pixel[3] = 255;
        } else if (value >= 0.46 && value < 0.67) {
            pixel[0] = 50;
            pixel[1] = 255;
            pixel[2] = 90;
            pixel[3] = 255;
        } else if (value >= 0.30 && value < 0.46) {
            pixel[0] = 221;
            pixel[1] = 137;
            pixel[2] = 50;
            pixel[3] = 255;
        } else if (value < 0.30) {
            pixel[0] = 255;
            pixel[1] = 0;
            pixel[2] = 0;
            pixel[3] = 255;
        } else {
            pixel[3] = 0;
        }
        return pixel;
    },
    lib: {
        sentinel_ndvi: sentinel_ndvi,
    }

});
ndvi_raster.set('threshold', 0.1);

function sentinel_ndvi(pixel) {
    var nir = pixel[0] / 255;
    var r = pixel[1] / 255;
    var g = pixel[2] / 255;
    //  var b = pixel[3] / 255;
    return (nir - r) / (nir + r);
};

var NDVILayer = new ol.layer.Image({
    title: 'NDVI1',
    source: ndvi_raster
});

function CropHealth(checkbox) {
    selectedLayerId = document.getElementById('layer1Type').value
    //document.getElementById("layerswid").value;
    if (checkbox.checked) {
        console.log("Selected Date:", time_range);
        if (selectedLayerId == "sentinel2fcc") {

            map.addLayer(NDVILayer);
        }
        else if (selectedLayerId == 'basemap_ortho')
            map.addLayer(CropHealth_layer);
        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], lastselectedlayer_vector_filter[0]);
        cliplayer.on('postcompose', function (e) {
            e.context.globalCompositeOperation = 'source-over';
        });
        cliplayer.on('precompose', function (e) {
            e.context.globalCompositeOperation = 'destination-in';
        });

        jQuery('#div_CropHealth').css('display', 'block');

        console.log(cliplayer);
        map.addLayer(cliplayer);
        layerobject.push(cliplayer);
        map.addOverlay(cliplayer);
        lastselectedlayer.push("Crop_Health");
        lastselectedlayername.push("Crop Health");
    }
    else {
        jQuery('#div_CropHealth').css('display', 'none');
        if (selectedLayerId == "sentinel2fcc")
            map.removeLayer(NDVILayer);
        else if (selectedLayerId == 'basemap_ortho')
            map.removeLayer(CropHealth_layer);
        map.removeLayer(cliplayer);
        layerobject.pop(cliplayer);
        map.removeOverlay(cliplayer);
        lastselectedlayer.pop("Apple_NDVI");
        lastselectedlayername.pop("Crop Health");
    }

}

let layerobject11 = [];

function toggleDateInput(layerNumber) {
    const type = document.getElementById(`layer${layerNumber}Type`).value;
    const label = document.getElementById(`labelDate${layerNumber}`);
    label.style.display = (type === 'sentinel2fcc') ? 'block' : 'none';
}

function createLayer(type, date = null) {
    switch (type) {
        case 'osm':
            return new ol.layer.Tile({
                source: new ol.source.OSM()
            });
        case 'satellite':
            return new ol.layer.Tile({
                source: new ol.source.XYZ({
                    url: 'http://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}'
                })
            });
        case 'roadmap':
            return new ol.layer.Tile({
                source: new ol.source.XYZ({
                    url: 'http://mt0.google.com/vt/lyrs=r&hl=en&x={x}&y={y}&z={z}'
                })
            });
        case 'hybrid':
            return new ol.layer.Tile({
                source: new ol.source.XYZ({
                    url: 'http://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}'
                })
            });
        case 'terrain':
            return new ol.layer.Tile({
                source: new ol.source.XYZ({
                    url: 'http://mt0.google.com/vt/lyrs=t&hl=en&x={x}&y={y}&z={z}'
                })
            });
        case 'planet':
            return new ol.layer.Tile({
                source: new ol.source.XYZ({
                    url: 'https://tiles.planet.com/basemaps/v1/planet-tiles/global_quarterly_2018q2_mosaic/gmap/{z}/{x}/{y}.png?api_key=56af6cee0fe14ca8b049c6ed15e93b16'
                })
            });
        case 'sentinel2fcc':
            return new ol.layer.Tile({
                source: new ol.source.TileWMS({
                    url: 'https://services.sentinel-hub.com/ogc/wms/13d5aaea-1d0e-4581-9288-a463ce586119',
                    params: {
                        layers: '2_FALSE_COLOR',
                        time: date,
                        preset: '2_FALSE_COLOR',
                        maxcc: 50
                    },
                    crossOrigin: 'anonymous'
                })
            });
        default:
            return null;
    }
}

function loadSwipeLayers() {
    const type1 = document.getElementById('layer1Type').value;
    const type2 = document.getElementById('layer2Type').value;
    const date1 = document.getElementById('date1').value;
    const date2 = document.getElementById('date2').value;

    if (type1 === 'sentinel2fcc' && !date1) {
        document.getElementById("layerswid").value = type1;
        alert('Please select a date for Sentinel-2 Layer 1.');
        return;
    }
    if (type2 === 'sentinel2fcc' && !date2) {
        alert('Please select a date for Sentinel-2 Layer 2.');
        return;
    }
    if (type1 === 'sentinel2fcc' && type2 === 'sentinel2fcc' && date1 === date2) {
        alert('Please choose two different Sentinel-2 dates.');
        return;
    }

    const layer1 = createLayer(type1, date1);
    const layer2 = createLayer(type2, date2);

    map.getLayers().clear();
    map.addLayer(layer1);
    map.addLayer(layer2);

    layerobject11 = [layer1, layer2];

    document.getElementById('swipediv').style.display = 'block';

    layer2.un('precompose', precomposeSwipe);
    layer2.un('postcompose', postcomposeSwipe);

    layer2.on('precompose', precomposeSwipe);
    layer2.on('postcompose', postcomposeSwipe);
    map.render();
}

function precomposeSwipe(event) {
    const swipe = document.getElementById('swipe').value;
    const ctx = event.context;
    const width = ctx.canvas.width * (swipe / 100);
    ctx.save();
    ctx.beginPath();
    ctx.rect(width, 0, ctx.canvas.width - width, ctx.canvas.height);
    ctx.clip();
}

function postcomposeSwipe(event) {
    event.context.restore();
}

document.getElementById('swipe').addEventListener('input', function () {
    if (layerobject11.length === 2) {
        map.render();
    }
});