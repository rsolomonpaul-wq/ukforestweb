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
 


 



//var count = 0;
//var timlapse;
//var time_range;



//var layers = {
//    'osm': new ol.layer.Tile({
//        title: 'OpenStreetMap',
//        visible: true,
//        source: new ol.source.OSM()
//    }),
//    'hybrid': new ol.layer.Tile({
//        title: 'Google Hybrid',
//        visible: false,
//        source: new ol.source.XYZ({
//            url: 'http://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}'
//        })
//    }),
//    'none': new ol.layer.Tile({
//        title: 'None',
//        visible: false,
//        source: new ol.source.XYZ({
//            url: ''
//        })
//    }),
//    'satellite': new ol.layer.Tile({
//        title: 'Google Satellite',
//        visible: false,
//        source: new ol.source.XYZ({
//            url: 'http://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}'
//        })
//    }),
//    'terrain': new ol.layer.Tile({
//        title: 'Google Terrain',
//        visible: false,
//        source: new ol.source.XYZ({
//            url: 'http://mt0.google.com/vt/lyrs=t&hl=en&x={x}&y={y}&z={z}'
//        })
//    }),
//    'roadmap': new ol.layer.Tile({
//        title: 'Google Roadmap',
//        visible: false,
//        source: new ol.source.XYZ({
//            url: 'http://mt0.google.com/vt/lyrs=r&hl=en&x={x}&y={y}&z={z}'
//        })
//    }),
//    'Planet': new ol.layer.Tile({
//        title: 'Planet',
//        visible: false,
//        source: new ol.source.XYZ({
//            url: 'https://tiles.planet.com/basemaps/v1/planet-tiles/global_quarterly_2018q2_mosaic/gmap/{z}/{x}/{y}.png?api_key=56af6cee0fe14ca8b049c6ed15e93b16'
//        })
//    }),
//    'sentinel1': new ol.layer.Tile({
//        visible: false,
//        name: 'sentinal-1',
//        source: new ol.source.TileWMS({
//            url: 'https://services.sentinel-hub.com/ogc/wms/09aed6ae-a461-40c6-941a-a765f8bc4c03',
//            params: { "maxcc": 50, "minZoom": 6, "maxZoom": 16, "preset": "SENTINE1", "layers": "SENTINE1", "time": timlapse },
//            serverType: 'geoserver',
//            crossOrigin: 'anonymous',
//            transition: 0
//        })
//    }),
//    'sentinel2fcc': new ol.layer.Tile({
//        visible: false,
//        name: 'sentinal-2',
//        source: new ol.source.TileWMS({
//            url: 'https://services.sentinel-hub.com/ogc/wms/5909508b-6a9b-4832-becb-406e0689e132',
//            params: { "maxcc": 50, "minZoom": 6, "maxZoom": 16, "preset": "2_FALSE_COLOR", "layers": "2_FALSE_COLOR", "time": timlapse },
//            serverType: 'geoserver',
//            crossOrigin: 'anonymous',
//            transition: 0
//        })
//    })
//    ,
//    'sentinel2ncc': new ol.layer.Tile({
//        visible: false,
//        name: 'sentinal-2',
//        source: new ol.source.TileWMS({
//            url: 'https://services.sentinel-hub.com/ogc/wms/25c39243-2e48-441d-b34c-c9628cbeade6',
//            params: { "maxcc": 50, "minZoom": 6, "maxZoom": 16, "preset": "TRUE_COLOR", "layers": "TRUE_COLOR", "time": timlapse },
//            serverType: 'geoserver',
//            crossOrigin: 'anonymous',
//            transition: 0
//        })
//    })
//    ,
//    'basemap_ortho': new ol.layer.Tile({
//        type: 'base',
//        visible: false,
//        source: new ol.source.TileWMS({
//            url: geoserver_ip,
//            params: {
//                'FORMAT': format,
//                'VERSION': '1.3.0',
//                tiled: true,
//                STYLES: '',
//                // LAYERS: 'nrdc:Apple_farm_Image'
//                //himcha image
//                LAYERS: 'nrdc:row_image'
//                //sultanpur
//            },
//            serverType: 'geoserver',
//            //Set initial time
//            time: time_range,


//        })
//    })

//};

//var selectedLayerId;
 
//let lastCheckedRadio = null;

//document.querySelectorAll('.layer-switcher div label input[type="radio"]').forEach(function (radio) {
//    radio.addEventListener('click', function (e) {
//        if (this === lastCheckedRadio) {
//            this.checked = false;
//            lastCheckedRadio = null;

//            // Hide all layers
//            Object.keys(layers).forEach(function (layerId) {
//                layers[layerId].setVisible(false);
//            });
//        } else {
//            lastCheckedRadio = this;

//            // Show selected layer only
//            var selectedLayerId = this.value;
//            Object.keys(layers).forEach(function (layerId) {
//                layers[layerId].setVisible(layerId === selectedLayerId);
//                console.log(Object.values(layers));
//                layerobject.push[Object.values(layers)[8]];

//            });
//        }
//    });
//});
 





//var isMapActive = false;
//var interactions = ol.interaction.defaults();

 //var  source = new ol.source.Vector();
 //   const map = new ol.Map({
 //       target: 'map',
 //       layers: [new ol.layer.Tile({
 //           source: new ol.source.OSM() // Use OpenStreetMap layer
 //       }),
 //         ],
 //       view: new ol.View({
 //           center: ol.proj.fromLonLat([79.0193, 30.0668]),
 //           zoom: 8,
 //           minZoom: 3,
 //           maxZoom: 18
 //       })
 //   });



//const mousePositionControl = new ol.control.MousePosition({
//    coordinateFormat: function (coord) {
//        return `Lat: ${coord[1].toFixed(4)}, Lon: ${coord[0].toFixed(4)}`;
//    },
//    projection: 'EPSG:4326',
//    className: 'custom-mouse-position', // not used here, but required
//    target: document.getElementById('mouse-position'),
//    undefinedHTML: 'Mouse: Out of bounds'
//});

//// Add control to the map
//map.addControl(mousePositionControl);

//////////////////////////////////////////////////////////

//const currentDate = new Date();

//// Format the date as YYYY-MM-DD
//const formattedDate = currentDate.toISOString().split('T')[0];

//// Set the input field value to the current date
//const dateInput = document.getElementById("time");
//dateInput.value = formattedDate;



//var dateData = document.getElementById("hfAllDates").value;

//var dates = dateData.split(',');


//flatpickr("#time", {
//    dateFormat: "Y-m-d",
//    onDayCreate: function (dObj, dStr, fp, dayElem) {
//        const dateStr = dayElem.dateObj.toLocaleDateString('en-CA');
//        if (dates.includes(dateStr)) {
//            dayElem.classList.add("highlighted");
//        } else {
//            /* dayElem.classList.add("highlightedRed");*/
//        }
//    }
//});



//// Get the #time input field
//const dateInput1 = document.getElementById("time");

//// Event listener for when the date changes
//dateInput1.addEventListener('change', function () {
//    // Get the selected date
//    const selectedDate = dateInput.value;

//    // Update the time parameter for the Sentinel-2 layers
//    layers['sentinel2'].getSource().updateParams({
//        'time': selectedDate
//    });
    

//    // Optionally, you can refresh or reload the map to reflect the change.
//    // If you want to force a reload of the WMS layer:
//    layers['sentinel2'].getSource().refresh();
//});

//// Optional: For the other Sentinel layer (sentinel1), you can do the same
//// If you have multiple Sentinel layers, you can repeat the process for each layer.




//function sfdzone(checkbox) {

//    if (checkbox.checked) {
//        //jQuery('#div_zone').css('display', 'block');
//        map.addLayer(zones);
//        layerobject.push(zones);
//        map.addOverlay(zones);
//        lastselectedlayer.push("tbl_uk_zone_boundary");
//        lastselectedlayername.push("SFD Zone Boundaries");
//        lastselectedlayer_vector.push("tbl_uk_zone_boundary");
//        //village_zoom();
//    }
//    else {
//        jQuery('#div_zone').css('display', 'none');
//        map.removeLayer(zones);
//        layerobject.pop(zones);
//        map.removeOverlay(zones);
//        lastselectedlayer.pop("tbl_uk_zone_boundary");
//        lastselectedlayername.pop("SFD Zone Boundaries");
//        lastselectedlayer_vector.pop("tbl_uk_zone_boundary");
//    }
//}

//var zones = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            layers: 'uk_sfd:tbl_uk_zone_boundary',
//            transition: 0
//        }, serverType: 'geoserver',
//        crossOrigin: 'anonymous'

//    })
//});



//function sfdcircle(checkbox) {

//    if (checkbox.checked) {
//        jQuery('#div_circle').css('display', 'block');
//        map.addLayer(circles);
//        layerobject.push(circles);
//        map.addOverlay(circles);
//        lastselectedlayer.push("tbl_uk_circel_boundary");
//        lastselectedlayername.push("SFD Circle Boundaries");
//        lastselectedlayer_vector.push("tbl_uk_circel_boundary");
//        //village_zoom();
//    }
//    else {
//        jQuery('#div_circle').css('display', 'none');
//        map.removeLayer(circles);
//        layerobject.pop(circles);
//        map.removeOverlay(circles);
//        lastselectedlayer.pop("tbl_uk_circel_boundary");
//        lastselectedlayername.pop("SFD Circle Boundaries");
//        lastselectedlayer_vector.pop("tbl_uk_circel_boundary");
//    }
//}

//var circles = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            layers: 'uk_sfd:tbl_uk_circel_boundary',
//            transition: 0
//        }, serverType: 'geoserver',
//        crossOrigin: 'anonymous'

//    })
//});




//function sfddivision(checkbox) {

//    if (checkbox.checked) {
//        jQuery('#div_division').css('display', 'block');
//        map.addLayer(divisions);
//        layerobject.push(divisions);
//        map.addOverlay(divisions);
//        lastselectedlayer.push("tbl_uk_division_boundary");
//        lastselectedlayername.push("SFD Division Boundaries");
//        lastselectedlayer_vector.push("tbl_uk_division_boundary");
//        //village_zoom();
//    }
//    else {
//        jQuery('#div_division').css('display', 'none');
//        map.removeLayer(divisions);
//        layerobject.pop(divisions);
//        map.removeOverlay(divisions);
//        lastselectedlayer.pop("tbl_uk_division_boundary");
//        lastselectedlayername.pop("SFD Division Boundaries");
//        lastselectedlayer_vector.pop("tbl_uk_division_boundary");
//    }
//}

//var divisions = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            layers: 'uk_sfd:tbl_uk_division_boundary',
//            transition: 0
//        }, serverType: 'geoserver',
//        crossOrigin: 'anonymous'

//    })
//});


//function slopefn(checkbox) {

//    if (checkbox.checked) {
//        jQuery('#div_slope').css('display', 'block');
//        map.addLayer(slope_layer);
//        layerobject.push(slope_layer);
//        map.addOverlay(slope_layer);
//        lastselectedlayer.push("Slope_Geo");
//        lastselectedlayername.push("Slope_Geo");
//        lastselectedlayer_vector.push("Slope_Geo");
//        //thailandvil_zoom();
//    }
//    else {
//        jQuery('#div_slope').css('display', 'none');
//        map.removeLayer(slope_layer);
//        layerobject.pop(slope_layer);
//        map.removeOverlay(slope_layer);
//        lastselectedlayer.pop("Slope_Geo");
//        lastselectedlayername.pop("Slope_Geo");
//        lastselectedlayer_vector.pop("Slope_Geo");
//        // country_zoom();
//    }
//}
//var slope_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: 'https://ukforestgis.in/geoserver/uk_sfd/wms?',
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            //layers: 'nrdc:view_farmer_details',
//            //layers: 'nrdc:tbl_apple_land',
//            layers: 'uk_sfd:Slope_Geo',
//            transition: 0
//        }
//    })
//});

//function Aspect_Geofn(checkbox) {

//    if (checkbox.checked) {
//        jQuery('#div_Aspects').css('display', 'block');
//        map.addLayer(Aspect_Geo_layer);
//        layerobject.push(Aspect_Geo_layer);
//        map.addOverlay(Aspect_Geo_layer);
//        lastselectedlayer.push("Aspect_Geo");
//        lastselectedlayername.push("Aspect_Geo");
//        lastselectedlayer_vector.push("Aspect_Geo");
//        //thailandvil_zoom();
//    }
//    else {
//        jQuery('#div_Aspects').css('display', 'none');
//        map.removeLayer(Aspect_Geo_layer);
//        layerobject.pop(Aspect_Geo_layer);
//        map.removeOverlay(Aspect_Geo_layer);
//        lastselectedlayer.pop("Aspect_Geo");
//        lastselectedlayername.pop("Aspect_Geo");
//        lastselectedlayer_vector.pop("Aspect_Geo");
//        // country_zoom();
//    }
//}
//var Aspect_Geo_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: 'https://ukforestgis.in/geoserver/uk_sfd/wms?',
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            //layers: 'nrdc:view_farmer_details',
//            //layers: 'nrdc:tbl_apple_land',
//            layers: 'uk_sfd:Aspect_Geo',
//            transition: 0
//        }
//    })
//});

//function swipetool() {

//    jQuery('#layerswipe').toggleClass('iconenable');
//    if (jQuery('#swipediv').is(':visible')) {
//        jQuery('#swipediv').hide();

//    } else {
//        jQuery('#swipediv').show();

//    }

//}


//document.getElementById('swipe').addEventListener('input', function () {
//    layerobject = [Object.values(layers['sentinel2']), Object.values(layers['satellite'])];
//    //// SWIPING METHODS START
//    var swipePreCompose = function (event) {

//        var swipe = document.getElementById('swipe');

//        var ctx = event.context;
//        var width = ctx.canvas.width * (swipe.value / 100);

//        ctx.save();
//        ctx.beginPath();
//        ctx.rect(width, 0, ctx.canvas.width - width, ctx.canvas.height);
//        ctx.clip();

//    };

//    var swipePostCompose = function (event) {
//        var ctx = event.context;
//        ctx.restore();
//    };
//    //// SWIPING METHODS END

//    console.log(layerobject);

//    var lastlayerobjectLength = Number(layerobject.length);

//    if (lastlayerobjectLength == 0 || lastlayerobjectLength == 1) {
//        alert('Please select two layer');
//        return;
//    }

//    map.render();
//    var lastlayerobjectLength = Number(layerobject.length);

//    if (lastlayerobjectLength > 1) {

//        // FIRST UNSUBSCRIBING PREVIOUS ONE
//        var previousoneobject = layerobject[lastlayerobjectLength - 2];
//        previousoneobject.un('precompose', swipePreCompose);
//        previousoneobject.un('postcompose', swipePostCompose);

//        // SECOND ADD EVENTS IN CURRENT OBJECT
//        var lastcustomobject = layerobject[lastlayerobjectLength - 1];
//        lastcustomobject.on('precompose', swipePreCompose);
//        lastcustomobject.on('postcompose', swipePostCompose);

//    }
//    // SWIPE LOGIC END
//}, false);

const heatmapLayer = new ol.layer.Heatmap({
    source: new ol.source.Vector({
        url: 'https://ukforestgis.in/geoserver/uk_sfd/wms?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_2021&outputFormat=application/json',
        format: new ol.format.GeoJSON()
    }),
    blur: 10,
    radius: 5,
    weight: function (feature) {
        return feature.get('intensity') || 1; // Adjust attribute name
    }
});




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

var source = new ol.source.Vector();
const map = new ol.Map({
    target: 'map',
    layers: [new ol.layer.Tile({
        source: new ol.source.OSM() // Use OpenStreetMap layer
    }),
    ],
    view: new ol.View({
        center: ol.proj.fromLonLat([79.0193, 30.0668]),
        zoom: 8,
        minZoom: 3,
        maxZoom: 18
    })
});




let layerobjectchange = [];

function toggleDateInput(layerNumber) {
    const type = document.getElementById(`layer${layerNumber}Type`).value;
    const label = document.getElementById(`labelDate${layerNumber}`);
    label.style.display = (type === 'sentinel') ? 'block' : 'none';
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
        case 'sentinel':
            return new ol.layer.Tile({
                source: new ol.source.TileWMS({
                    url: 'https://services.sentinel-hub.com/ogc/wms/514e719b-3d56-429e-bdc8-55b90d20d343',
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

    if (type1 === 'sentinel' && !date1) {
        alert('Please select a date for Sentinel-2 Layer 1.');
        return;
    }
    if (type2 === 'sentinel' && !date2) {
        alert('Please select a date for Sentinel-2 Layer 2.');
        return;
    }
    if (type1 === 'sentinel' && type2 === 'sentinel' && date1 === date2) {
        alert('Please choose two different Sentinel-2 dates.');
        return;
    }

    const layer1 = createLayer(type1, date1);
    const layer2 = createLayer(type2, date2);

    map.getLayers().clear();
    map.addLayer(layer1);
    map.addLayer(layer2);

    layerobjectchange = [layer1, layer2];

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
    if (layerobjectchange.length === 2) {
        map.render();
    }
});





window.onload = function () {

    lastselectedlayer = [];
    lastselectedlayername = [];
    lastselectedlayer_vector = [];
    map.addLayer(divisions);
    layerobject.push(divisions);
    map.addOverlay(divisions);
    lastselectedlayer.push("tbl_uk_division_boundary");
    lastselectedlayername.push("SFD Division Boundaries");
    lastselectedlayer_vector.push("tbl_uk_division_boundary");


}