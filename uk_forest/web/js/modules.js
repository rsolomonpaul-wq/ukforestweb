
var geoserver_ip = "http://180.151.15.18:9007/geoserver/uk_sfd/wms?";
var geoserver_ip_ows = "http://180.151.15.18:9007/geoserver/sbl/ows";

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
var overlay = new ol.Overlay(({
    element: container,
    autoPan: true,
    autoPanAnimation: {
        duration: 250
    }
}));


// Get all elements with the class 'ol-full-screen-false'



var containerEdit = document.getElementById('myModel3');
var contentEdit = document.getElementById('editableGridid');
var closerEdit = document.getElementById('popup-closer-edit');

// Update the TIME parameter dynamically



window.onload = function () {

    lastselectedlayer = [];
    lastselectedlayername = [];
    lastselectedlayer_vector = [];

    map.addOverlay(forest_layer);
    map.addLayer(forest_layer);
    layerobject.push(forest_layer);
    lastselectedlayer.push("tbl_forest_data_final");
    lastselectedlayername.push("Forest Boundary");
    lastselectedlayer_vector.push("tbl_forest_data_final");

    //map.addOverlay(district_layer);
    //map.addLayer(district_layer);
    //layerobject.push(district_layer);
    //lastselectedlayer.push("tbl_uk_districts");
    //lastselectedlayername.push("District Boundary");
    //lastselectedlayer_vector.push("tbl_uk_districts");

    //map.addOverlay(zones);
    //map.addLayer(zones);
    //layerobject.push(zones);
    //lastselectedlayer.push("tbl_zone_master");
    //lastselectedlayername.push("Zone Boundary");
    //lastselectedlayer_vector.push("tbl_zone_master");


    //map.addOverlay(circles);
    //map.addLayer(circles);
    //layerobject.push(circles);
    //lastselectedlayer.push("tbl_circle_master");
    //lastselectedlayername.push("Circle Boundary");
    //lastselectedlayer_vector.push("tbl_circle_master");

    map.addOverlay(divisions);
    map.addLayer(divisions);
    layerobject.push(divisions);
    lastselectedlayer.push("tbl_division_master");
    lastselectedlayername.push("Division Boundary");
    lastselectedlayer_vector.push("tbl_division_master");

     //document.getElementById("cd_district").checked = true;
     //document.getElementById("zone").checked = true;
     //document.getElementById("circle").checked = true;
    document.getElementById("division").checked = true;
    document.getElementById("cd_forest").checked = true;


    //document.getElementById("div_district").style.display = "block";
    //document.getElementById("div_zone").style.display = "block";
    //document.getElementById("div_circle").style.display = "block";
    document.getElementById("div_division").style.display = "block";
    document.getElementById("div_forest").style.display = "block";
    //jQuery('#div_country').css('display', 'block');
    //var div_country = document.getElementById("cd_country");
    //div_country.checked = true;



}

var count = 0;
var timlapse;
var time_range;
//if (count == 0) {

//    ////--------------------------------for sentinel and Ortho Image----------------------------------
//    var cTime = new Date();
//    var syear = cTime.getFullYear();
//    var smonth = cTime.getMonth() + 1;
//    if (smonth < 10) {
//        smonth = "0" + smonth;
//    }
//    var sday = cTime.getDate();
//    if (sday < 10) {
//        sday = "0" + sday;
//    }

//    var sto_date = syear + "-" + smonth + "-" + sday;
//    var sfrom_date = new Date(sto_date);
//    sfrom_date.setDate(sfrom_date.getDate() - 14);
//    timlapse = sfrom_date.toISOString().slice(0, 10) + "/" + sto_date;
//    time_range = syear + '-' + smonth + '-01T00:00:00.000Z';

//}

//function setDateVariable() {
//    count = 0;
//    // Get the date input value
//    selectedDate = document.getElementById("time").value;
//    var year = selectedDate.split("-")[0]; // First part is the year (YYYY)
//    var month = selectedDate.split("-")[1]; // Second part is the month (MM)
//    var day = selectedDate.split("-")[2]; // Second part is the day (DD)
//    time_range = year + '-' + month + '-' + day + 'T00:00:00.000Z';


//    const wmsSource = CropGrowth_layer.getSource();
//    wmsSource.updateParams({ 'time': time_range });

//    const wmsSource_CropHealth_layer = CropHealth_layer.getSource();
//    wmsSource_CropHealth_layer.updateParams({ 'time': time_range });

//    const wmsSource_CropHarvesting_layer = CropHarvesting_layer.getSource();
//    wmsSource_CropHarvesting_layer.updateParams({ 'time': time_range });

//    const wmsSource_VegetationMoisture_layer = VegetationMoisture_layer.getSource();
//    wmsSource_VegetationMoisture_layer.updateParams({ 'time': time_range });

//    const wmsSource_NitrogenContent_layer = NitrogenContent_layer.getSource();
//    wmsSource_NitrogenContent_layer.updateParams({ 'time': time_range });

//    const wmsSource_SoilMoisture_layer = SoilMoisture_layer.getSource();
//    wmsSource_SoilMoisture_layer.updateParams({ 'time': time_range });

//    const wmsSource_base = layers['basemap_ortho'].getSource();
//    wmsSource_base.updateParams({ 'time': time_range });



//    /*   var cTime = new Date();*/

//    var cTime = new Date(selectedDate);
//    var syear = cTime.getFullYear();
//    var smonth = cTime.getMonth() + 1;
//    if (smonth < 10) {
//        smonth = "0" + smonth;
//    }
//    var sday = cTime.getDate();
//    if (sday < 10) {
//        sday = "0" + sday;
//    }

//    var sto_date = syear + "-" + smonth + "-" + sday;
//    var sfrom_date = new Date(sto_date);
//    sfrom_date.setDate(sfrom_date.getDate() - 14);
//    timlapse = sfrom_date.toISOString().slice(0, 10) + "/" + sto_date;

//    const wmsSource_sentinal1 = layers['sentinal1'].getSource();
//    wmsSource_sentinal1.updateParams({ 'time': timlapse });

//    const wmsSource_sentinal2 = layers['sentinal2'].getSource();
//    wmsSource_sentinal2.updateParams({ 'time': timlapse });

//    sentinel_layer.getSource().updateParams({ 'time': timlapse });

//    if (selectedLayerId == 'sentinal2')
//        zoomInOutOnce();
//}
//function zoomInOutOnce() {
//    var view = map.getView();
//    var currentZoom = view.getZoom();

//    // Zoom in (increase zoom level)
//    view.setZoom(currentZoom + 0.2);
//    console.log('Zoomed In to', currentZoom + 1);

//    // After 10 seconds, zoom out (decrease zoom level)
//    setTimeout(function () {
//        view.setZoom(currentZoom);
//        console.log('Zoomed Out to', currentZoom);
//    }, 2000); // 10 seconds delay
//}

// Call the function to zoom in and then zoom out after 10 seconds





var layers = {
    'osm': new ol.layer.Tile({
        title: 'OpenStreetMap',
        visible: true,
        source: new ol.source.OSM()
    }),
    'hybrid': new ol.layer.Tile({
        title: 'Google Hybrid',
        visible: false,
        source: new ol.source.XYZ({
            url: 'http://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}'
        })
    }),
    'satellite': new ol.layer.Tile({
        title: 'Google Satellite',
        visible: false,
        source: new ol.source.XYZ({
            url: 'http://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}'
        })
    }),
    'terrain': new ol.layer.Tile({
        title: 'Google Terrain',
        visible: false,
        source: new ol.source.XYZ({
            url: 'http://mt0.google.com/vt/lyrs=t&hl=en&x={x}&y={y}&z={z}'
        })
    }),
    'roadmap': new ol.layer.Tile({
        title: 'Google Roadmap',
        visible: false,
        source: new ol.source.XYZ({
            url: 'http://mt0.google.com/vt/lyrs=r&hl=en&x={x}&y={y}&z={z}'
        })
    }),
    'Planet': new ol.layer.Tile({
        title: 'Planet',
        visible: false,
        source: new ol.source.XYZ({
            url: 'https://tiles.planet.com/basemaps/v1/planet-tiles/global_quarterly_2018q2_mosaic/gmap/{z}/{x}/{y}.png?api_key=56af6cee0fe14ca8b049c6ed15e93b16'
        })
    }),
    'sentinal1': new ol.layer.Tile({
        visible: false,
        name: 'sentinal-1',
        source: new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/09aed6ae-a461-40c6-941a-a765f8bc4c03',
            params: { "maxcc": 50, "minZoom": 6, "maxZoom": 16, "preset": "SENTINE1", "layers": "SENTINE1", "time": timlapse },
            serverType: 'geoserver',
            crossOrigin: 'anonymous',
            transition: 0
        })
    }),
    'sentinal2': new ol.layer.Tile({
        visible: false,
        name: 'sentinal-2',
        source: new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/967ab5c7-7ef9-4b2f-874b-a1e7f3d05097',
            params: { "maxcc": 50, "minZoom": 6, "maxZoom": 16, "preset": "2_FALSE_COLOR", "layers": "2_FALSE_COLOR", "time": timlapse },
            serverType: 'geoserver',
            crossOrigin: 'anonymous',
            transition: 0
        })
    })
    ,
    'basemap_ortho': new ol.layer.Tile({
        type: 'base',
        visible: false,
        source: new ol.source.TileWMS({
            url: geoserver_ip,
            params: {
                'FORMAT': format,
                'VERSION': '1.3.0',
                tiled: true,
                STYLES: '',
                // LAYERS: 'nrdc:Apple_farm_Image'
                //himcha image
                LAYERS: 'nrdc:row_image'
                //sultanpur
            },
            serverType: 'geoserver',
            //Set initial time
            time: time_range,


        })
    })
};

var selectedLayerId;

// Handle layer switcher changes

//document.querySelectorAll('.layer-switcher div label input[type="radio"]').forEach(function (radio) {
//    radio.addEventListener('change', function () {
//        var selectedLayerId = this.value;
//        Object.keys(layers).forEach(function (layerId) {
//            layers[layerId].setVisible(layerId === selectedLayerId);
//        });
//    });
//});
let lastCheckedRadio = null;

document.querySelectorAll('.layer-switcher div label input[type="radio"]').forEach(function (radio) {
    radio.addEventListener('click', function (e) {
        if (this === lastCheckedRadio) {
            this.checked = false;
            lastCheckedRadio = null;

            // Hide all layers
            Object.keys(layers).forEach(function (layerId) {
                layers[layerId].setVisible(false);
            });
        } else {
            lastCheckedRadio = this;

            // Show selected layer only
            var selectedLayerId = this.value;
            Object.keys(layers).forEach(function (layerId) {
                layers[layerId].setVisible(layerId === selectedLayerId);
            });
        }
    });
});

/*document.getElementsByName("osm").checked = true;*/


//document.querySelectorAll('.layer-switcher div label input[type="radio"]').forEach(function (radio) {
//    radio.addEventListener('change', function () {
//        selectedLayerId = this.id;
//        Object.keys(layers).forEach(function (layerId) {
//            layers[layerId].setVisible(layerId === selectedLayerId);
//        });
//    });
//});


//let currentLayer; // define this in a higher scope

//document.querySelectorAll('.layer-switcher1 div input[type="radio"]').forEach(function (radio) {
//    radio.addEventListener('change', function () {
//        var selectedLayer = this.value;

//        if (currentLayer) {
//            map.removeLayer(currentLayer);
//            map.removeO(currentLayer);
//        }

//        currentLayer = layers[selectedLayer];

//        if (currentLayer) {
//            map.addLayer(currentLayer);
//            map.addOverlay(currentLayer);
//        } else {
//            console.error("Layer not found:", selectedLayer);
//        }
//    });
//});









var isMapActive = false;
var interactions = ol.interaction.defaults();

var map = new ol.Map({
    target: 'map',
    controls: ol.control.defaults().extend([
        new ol.control.FullScreen(),
        new ol.control.ScaleLine()
    ]),
    layers: Object.values(layers),
    view: new ol.View({
        
        center: ol.proj.fromLonLat([79.0193, 30.0668]),
        zoom: 7,
        minZoom: 3,
        maxZoom:18



    }),
    
});

document.addEventListener("DOMContentLoaded", function () {
    var asdfasf = document.getElementsByClassName("ol-full-screen-false");
    for (var i = 0; i < asdfasf.length; i++) {
        asdfasf[i].addEventListener('click', function () {


            const mapElemente = document.getElementById("map");

            // Get the size and position of the element
            const recte = mapElemente.getBoundingClientRect();

            // Access the width and height
            const widthe = recte.width;
            let myView;
            if (widthe < 500) {
                document.getElementById("mapfeatures").style.display = "block";
                myView = new ol.View({
                    center: ol.proj.fromLonLat([79.0193, 30.0668])
                    , zoom: 8.8
                });
                map.setView(myView);

            } else {
                document.getElementById("mapfeatures").style.display = "none";
                document.getElementById("layersDataid").style.display = "none";
                myView = new ol.View({
                    center: ol.proj.fromLonLat([79.0193, 30.0668])
                    , zoom: 7
                });
                map.setView(myView);
            }


        });
    }
});



const mousePositionControl = new ol.control.MousePosition({
    coordinateFormat: function (coord) {
        return `Lat: ${coord[1].toFixed(4)}, Lon: ${coord[0].toFixed(4)}`;
    },
    projection: 'EPSG:4326',
    className: 'custom-mouse-position', // not used here, but required
    target: document.getElementById('mouse-position'),
    undefinedHTML: 'Mouse: Out of bounds'
});

// Add control to the map
map.addControl(mousePositionControl);





/*================================Client Query==============================*/
//var query_layername = "";
//var filtertype = "";         // Type of filter to apply
//var filterValues = {
//    state_code: "",               // State code to filter
//    district_code: "",            // District code to filter
//    tehsil_code: "",              // Tehsil code to filter
//    village_code: ""              // Village code to filter
//};
//function clientQuery(query_layername, query_filtertype, query_filterValues) {

//    document.getElementById('cd_country').checked = false;
//    removeAllLayers();

//    // Construct GeoServer URL

//    filtertype = query_filtertype

//    var filterConditions = [];
//    var cqlFilter = null;

//    // Dynamically build the CQL_FILTER based on the passed filterValues object
//    if (filtertype != "NA") {
//        if (query_filterValues.state_code) {
//            filterConditions.push(`state_code='${query_filterValues.state_code}'`);
//        }
//        if (query_filterValues.district_code) {
//            filterConditions.push(`district_code='${query_filterValues.district_code}'`);
//        }
//        if (query_filterValues.tehsil_code) {
//            filterConditions.push(`tehsil_code='${query_filterValues.tehsil_code}'`);
//        }
//        if (query_filterValues.village_code) {
//            filterConditions.push(`village_code='${query_filterValues.village_code}'`);
//        }

//        // Join the conditions using AND, if there are any conditions
//        //cqlFilter = filterConditions.length > 0 ? "CQL_FILTER=" + filterConditions.join(" AND ") : "";
//        cqlFilter = filterConditions.length > 0 ? filterConditions.join(" AND ") : "";

//        filterValues = {
//            state_code: query_filterValues.state_code,               // State code to filter
//            district_code: query_filterValues.district_code,            // District code to filter
//            tehsil_code: query_filterValues.tehsil_code,              // Tehsil code to filter
//            village_code: query_filterValues.village_code              // Village code to filter
//        };
//    }


//    // Create the layer using OpenLayers with the dynamic CQL filter
//    var selectedLayer = new ol.layer.Image({
//        source: new ol.source.ImageWMS({
//            url: geoserver_ip,
//            params: {
//                'FORMAT': 'image/png',
//                'STYLES': '',
//                'layers': 'sbl:' + query_layername,
//                'CQL_FILTER': cqlFilter, // Correct filter format
//                'TILED': 'false' // Disables tiling and caching
//            }
//        }),
//        opacity: 1.0 // Ensure full opacity
//    });

//    // Add the layer to the map
//    map.addLayer(selectedLayer);
//    map.addOverlay(selectedLayer);



//    layerobject.push(selectedLayer);
//    lastselectedlayer_vector.push(query_layername);
//    lastselectedlayer.push(query_layername);
//    lastselectedlayername.push(query_layername);




//}


function removeAllLayers() {
    map.getLayers().forEach(function (layer) {
        if (!(layer instanceof ol.layer.Tile)) {
            map.removeLayer(layer);
        }
    });
    map.getOverlays().clear();
    lastselectedlayer = [];
    lastselectedlayername = [];
    lastselectedlayer_vector = [];
}
function ClearAllLayers() {
    map.getLayers().forEach(function (layer) {
        if (!(layer instanceof ol.layer.Tile)) {
            map.removeLayer(layer);
        }
    });
    map.getOverlays().clear();
    lastselectedlayer = [];
    lastselectedlayername = [];
    lastselectedlayer_vector = [];
    filtertype = "NA";
    filterValues = {
        state_code: "",
        district_code: "",
        tehsil_code: "",
        village_code: ""
    };
}





/*================================Client Query==============================*/

/*================================Country==============================*/
function country(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_country').css('display', 'block');
        map.addLayer(country_layer);
        layerobject.push(country_layer);
        map.addOverlay(country_layer);
        lastselectedlayer.push("tbl_country_boundary");
        lastselectedlayername.push("Country Boundary");
        lastselectedlayer_vector.push("tbl_country_boundary");
        //country_zoom();

    }
    else {
        jQuery('#div_country').css('display', 'none');
        map.removeLayer(country_layer);
        layerobject.pop(country_layer);
        map.removeOverlay(country_layer);
        lastselectedlayer.pop("tbl_country_boundary");
        lastselectedlayername.pop("Country Boundary");
        lastselectedlayer_vector.pop("tbl_country_boundary");

    }
}
var country_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_country_boundary',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});


/*================================State==============================*/

function state(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_state').css('display', 'block');
        map.addLayer(state_layer);
        layerobject.push(state_layer);
        map.addOverlay(state_layer);
        lastselectedlayer.push("tbl_uk_state_boundary");
        lastselectedlayername.push("state Boundary");
        lastselectedlayer_vector.push("tbl_uk_state_boundary");
        //state_zoom();

    }
    else {
        jQuery('#div_state').css('display', 'none');
        map.removeLayer(state_layer);
        layerobject.pop(state_layer);
        map.removeOverlay(state_layer);
        lastselectedlayer.pop("tbl_uk_state_boundary");
        lastselectedlayername.pop("state Boundary");
        lastselectedlayer_vector.pop("tbl_uk_state_boundary");

    }
}
var state_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_state_boundary',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});


/*================================District==============================*/

function district(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_district').css('display', 'block');
        map.addLayer(district_layer);
        layerobject.push(district_layer);
        map.addOverlay(district_layer);
        lastselectedlayer.push("tbl_uk_districts");
        lastselectedlayername.push("district Boundary");
        lastselectedlayer_vector.push("tbl_uk_districts");
        //district_zoom();

    }
    else {
        jQuery('#div_district').css('display', 'none');
        map.removeLayer(district_layer);
        layerobject.pop(district_layer);
        map.removeOverlay(district_layer);
        lastselectedlayer.pop("tbl_uk_districts");
        lastselectedlayername.pop("district Boundary");
        lastselectedlayer_vector.pop("tbl_uk_districts");

    }
}
var district_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_districts',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});


/*================================Tehsil==============================*/

function tehsil(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_tehsil').css('display', 'block');
        map.addLayer(tehsil_layer);
        layerobject.push(tehsil_layer);
        map.addOverlay(tehsil_layer);
        lastselectedlayer.push("tbl_uk_village_tehsil_recap4ndc_discticts");
        lastselectedlayername.push("tehsil Boundary");
        lastselectedlayer_vector.push("tbl_uk_village_tehsil_recap4ndc_discticts");
        //tehsil_zoom();
    }
    else {
        jQuery('#div_tehsil').css('display', 'none');
        map.removeLayer(tehsil_layer);
        layerobject.pop(tehsil_layer);
        map.removeOverlay(tehsil_layer);
        lastselectedlayer.pop("tbl_uk_village_tehsil_recap4ndc_discticts");
        lastselectedlayername.pop("tehsil Boundary");
        lastselectedlayer_vector.pop("tbl_uk_village_tehsil_recap4ndc_discticts");
    }
}
var tehsil_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_village_tehsil_recap4ndc_discticts',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});



/*================================Village==============================*/


function forest_fun(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_forest').css('display', 'block');
        map.addLayer(forest_layer);
        layerobject.push(forest_layer);
        map.addOverlay(forest_layer);
        lastselectedlayer.push("tbl_forest_data_final");
        lastselectedlayername.push("Forest Data");
        lastselectedlayer_vector.push("tbl_forest_data_final");
        //village_zoom();
    }
    else {
        jQuery('#div_forest').css('display', 'none');
        map.removeLayer(forest_layer);
        layerobject.pop(forest_layer);
        map.removeOverlay(forest_layer);
        lastselectedlayer.pop("tbl_forest_data_final");
        lastselectedlayername.pop("Forest Data");
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
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});



function forestfireprone(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_forest_fire_prone').css('display', 'block');
        map.addLayer(forestfireprone_layer);
        layerobject.push(forestfireprone_layer);
        map.addOverlay(forestfireprone_layer);
        lastselectedlayer.push("tbl_uk_forest_fire_prone_fsi_data");
        lastselectedlayername.push("Forest Fire Prone (2013-2023)");
        lastselectedlayer_vector.push("tbl_uk_forest_fire_prone_fsi_data");
        //village_zoom();
    }
    else {
        jQuery('#div_forest_fire_prone').css('display', 'none');
        map.removeLayer(forestfireprone_layer);
        layerobject.pop(forestfireprone_layer);
        map.removeOverlay(forestfireprone_layer);
        lastselectedlayer.pop("tbl_uk_forest_fire_prone_fsi_data");
        lastselectedlayername.pop("Forest Fire Prone (2013-2023)");
        lastselectedlayer_vector.pop("tbl_uk_forest_fire_prone_fsi_data");
    }
}

var forestfireprone_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_forest_fire_prone_fsi_data',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});


function forestCapopy(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_forest_canopy').css('display', 'block');
        map.addLayer(forest_canopy);
        layerobject.push(forest_canopy);
        map.addOverlay(forest_canopy);
        lastselectedlayer.push("tbl_uk_fsi_fcd2021");
        lastselectedlayername.push("Forest Canopy Cover 2021");
        lastselectedlayer_vector.push("tbl_uk_fsi_fcd2021");
        //village_zoom();
    }
    else {
        jQuery('#div_forest_canopy').css('display', 'none');
        map.removeLayer(forest_canopy);
        layerobject.pop(forest_canopy);
        map.removeOverlay(forest_canopy);
        lastselectedlayer.pop("tbl_uk_fsi_fcd2021");
        lastselectedlayername.pop("Forest Canopy Cover 2021");
        lastselectedlayer_vector.pop("tbl_uk_fsi_fcd2021");
    }
}

var forest_canopy = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_fsi_fcd2021',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});

function landdegradation(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_land_degradation').css('display', 'block');
        map.addLayer(land_degradation);
        layerobject.push(land_degradation);
        map.addOverlay(land_degradation);
        lastselectedlayer.push("tbl_uk_clip_reproj_uttarakhand_land_degradation_status_2018_19_");
        lastselectedlayername.push("Land Degradation (2018-19)");
        lastselectedlayer_vector.push("tbl_uk_clip_reproj_uttarakhand_land_degradation_status_2018_19_");
        //village_zoom();
    }
    else {
        jQuery('#div_land_degradation').css('display', 'none');
        map.removeLayer(land_degradation);
        layerobject.pop(land_degradation);
        map.removeOverlay(land_degradation);
        lastselectedlayer.pop("tbl_uk_clip_reproj_uttarakhand_land_degradation_status_2018_19_");
        lastselectedlayername.pop("Land Degradation (2018-19)");
        lastselectedlayer_vector.pop("tbl_uk_clip_reproj_uttarakhand_land_degradation_status_2018_19_");
    }
}

var land_degradation = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_clip_reproj_uttarakhand_land_degradation_status_2018_19_',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});


/////////////////////////////////////////////////////////////////////////
function populationdensity(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_population_density').css('display', 'block');
        map.addLayer(population_density);
        layerobject.push(population_density);
        map.addOverlay(population_density);
        lastselectedlayer.push("tbl_uk_population_status_y2011");
        lastselectedlayername.push("Population Density (2011)");
        lastselectedlayer_vector.push("tbl_uk_population_status_y2011");
        //village_zoom();
    }
    else {
        jQuery('#div_population_density').css('display', 'none');
        map.removeLayer(population_density);
        layerobject.pop(population_density);
        map.removeOverlay(population_density);
        lastselectedlayer.pop("tbl_uk_population_status_y2011");
        lastselectedlayername.pop("Population Density (2011)");
        lastselectedlayer_vector.pop("tbl_uk_population_status_y2011");
    }
}

var population_density = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_population_status_y2011',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function livestockpressure(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_livestock_pressure').css('display', 'block');
        map.addLayer(livestock_pressure);
        layerobject.push(livestock_pressure);
        map.addOverlay(livestock_pressure);
        lastselectedlayer.push("tbl_uk_livestock_pressure");
        lastselectedlayername.push("Livestock Pressure (2019)");
        lastselectedlayer_vector.push("tbl_uk_livestock_pressure");
        //village_zoom();
    }
    else {
        jQuery('#div_livestock_pressure').css('display', 'none');
        map.removeLayer(livestock_pressure);
        layerobject.pop(livestock_pressure);
        map.removeOverlay(livestock_pressure);
        lastselectedlayer.pop("tbl_uk_livestock_pressure");
        lastselectedlayername.pop("Livestock Pressure (2019)");
        lastselectedlayer_vector.pop("tbl_uk_livestock_pressure");
    }
}

var livestock_pressure = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_livestock_pressure',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function lpgconnection(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_lpg_connection').css('display', 'block');
        map.addLayer(lpg_connection);
        layerobject.push(lpg_connection);
        map.addOverlay(lpg_connection);
        lastselectedlayer.push("tbl_uk_lpg_connections");
        lastselectedlayername.push("LPG connection (2024)");
        lastselectedlayer_vector.push("tbl_uk_lpg_connections");
        //village_zoom();
    }
    else {
        jQuery('#div_lpg_connection').css('display', 'none');
        map.removeLayer(lpg_connection);
        layerobject.pop(lpg_connection);
        map.removeOverlay(lpg_connection);
        lastselectedlayer.pop("tbl_uk_lpg_connections");
        lastselectedlayername.pop("LPG connection (2024)");
        lastselectedlayer_vector.pop("tbl_uk_lpg_connections");
    }
}

var lpg_connection = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_lpg_connections',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function microwatershedboundary(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_micro_watershed_boundary').css('display', 'block');
        map.addLayer(micro_watershed_boundary);
        layerobject.push(micro_watershed_boundary);
        map.addOverlay(micro_watershed_boundary);
        lastselectedlayer.push("tbl_uk_clip_mws_reprj");
        lastselectedlayername.push("Micro Watershed Boundary");
        lastselectedlayer_vector.push("tbl_uk_clip_mws_reprj");
        //village_zoom();
    }
    else {
        jQuery('#div_micro_watershed_boundary').css('display', 'none');
        map.removeLayer(micro_watershed_boundary);
        layerobject.pop(micro_watershed_boundary);
        map.removeOverlay(micro_watershed_boundary);
        lastselectedlayer.pop("tbl_uk_clip_mws_reprj");
        lastselectedlayername.pop("Micro Watershed Boundary");
        lastselectedlayer_vector.pop("tbl_uk_clip_mws_reprj");
    }
}

var micro_watershed_boundary = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_clip_mws_reprj',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function rivers_fn(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_rivers').css('display', 'block');
        map.addLayer(rivers);
        layerobject.push(rivers);
        map.addOverlay(rivers);
        lastselectedlayer.push("tbl_uk_drainage");
        lastselectedlayername.push("Rivers");
        lastselectedlayer_vector.push("tbl_uk_drainage");
        //village_zoom();
    }
    else {
        jQuery('#div_rivers').css('display', 'none');
        map.removeLayer(rivers);
        layerobject.pop(rivers);
        map.removeOverlay(rivers);
        lastselectedlayer.pop("tbl_uk_drainage");
        lastselectedlayername.pop("Rivers");
        lastselectedlayer_vector.pop("tbl_uk_drainage");
    }
}

var rivers = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_drainage',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function greenindiamission(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_green_india_mission').css('display', 'block');
        map.addLayer(green_india_mission);
        layerobject.push(green_india_mission);
        map.addOverlay(green_india_mission);
        lastselectedlayer.push("tbl_uk_utm43_gim_intersect_division_mws");
        lastselectedlayername.push("Land Degradation (2018-19)");
        lastselectedlayer_vector.push("tbl_uk_utm43_gim_intersect_division_mws");
        //village_zoom();
    }
    else {
        jQuery('#div_green_india_mission').css('display', 'none');
        map.removeLayer(green_india_mission);
        layerobject.pop(green_india_mission);
        map.removeOverlay(green_india_mission);
        lastselectedlayer.pop("tbl_uk_utm43_gim_intersect_division_mws");
        lastselectedlayername.pop("Green India Mission");
        lastselectedlayer_vector.pop("tbl_uk_utm43_gim_intersect_division_mws");
    }
}

var green_india_mission = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_utm43_gim_intersect_division_mws',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function fieldvalidationpoints(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_field_validation_points').css('display', 'block');
        map.addLayer(field_validation_points);
        layerobject.push(field_validation_points);
        map.addOverlay(field_validation_points);
        lastselectedlayer.push("tbl_uk_field_validation_pts_june_july2024");
        lastselectedlayername.push("Field Validation Points");
        lastselectedlayer_vector.push("tbl_uk_field_validation_pts_june_july2024");
        //village_zoom();
    }
    else {
        jQuery('#div_field_validation_points').css('display', 'none');
        map.removeLayer(field_validation_points);
        layerobject.pop(field_validation_points);
        map.removeOverlay(field_validation_points);
        lastselectedlayer.pop("tbl_uk_field_validation_pts_june_july2024");
        lastselectedlayername.pop("Field Validation Points");
        lastselectedlayer_vector.pop("tbl_uk_field_validation_pts_june_july2024");
    }
}

var field_validation_points = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_field_validation_pts_june_july2024',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function longlistlandscape(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_longlist_landscape').css('display', 'block');
        map.addLayer(longlist_landscape);
        layerobject.push(longlist_landscape);
        map.addOverlay(longlist_landscape);
        lastselectedlayer.push("tbl_uk_7ls_new");
        lastselectedlayername.push("Longlist Landscape Boundary");
        lastselectedlayer_vector.push("tbl_uk_7ls_new");
        //village_zoom();
    }
    else {
        jQuery('#div_longlist_landscape').css('display', 'none');
        map.removeLayer(longlist_landscape);
        layerobject.pop(longlist_landscape);
        map.removeOverlay(longlist_landscape);
        lastselectedlayer.pop("tbl_uk_7ls_new");
        lastselectedlayername.pop("Longlist Landscape Boundary");
        lastselectedlayer_vector.pop("tbl_uk_7ls_new");
    }
}

var longlist_landscape = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_7ls_new',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function shortlistlandscape1(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_shortlist_landscape1').css('display', 'block');
        map.addLayer(shortlist_landscape1);
        layerobject.push(shortlist_landscape1);
        map.addOverlay(shortlist_landscape1);
        lastselectedlayer.push("tbl_uk_ls_1");
        lastselectedlayername.push("Shortlist Landscape boundary- LS1");
        lastselectedlayer_vector.push("tbl_uk_ls_1");
        //village_zoom();
    }
    else {
        jQuery('#div_shortlist_landscape1').css('display', 'none');
        map.removeLayer(shortlist_landscape1);
        layerobject.pop(shortlist_landscape1);
        map.removeOverlay(shortlist_landscape1);
        lastselectedlayer.pop("tbl_uk_ls_1");
        lastselectedlayername.pop("Shortlist Landscape boundary- LS1");
        lastselectedlayer_vector.pop("tbl_uk_ls_1");
    }
}

var shortlist_landscape1 = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_ls_1',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function shortlistlandscape2(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_shortlist_landscape2').css('display', 'block');
        map.addLayer(shortlist_landscape2);
        layerobject.push(shortlist_landscape2);
        map.addOverlay(shortlist_landscape2);
        lastselectedlayer.push("tbl_uk_ls_2");
        lastselectedlayername.push("Shortlist Landscape boundary- LS2");
        lastselectedlayer_vector.push("tbl_uk_ls_2");
        //village_zoom();
    }
    else {
        jQuery('#div_shortlist_landscape2').css('display', 'none');
        map.removeLayer(shortlist_landscape2);
        layerobject.pop(shortlist_landscape2);
        map.removeOverlay(shortlist_landscape2);
        lastselectedlayer.pop("tbl_uk_ls_2");
        lastselectedlayername.pop("Shortlist Landscape boundary- LS2");
        lastselectedlayer_vector.pop("tbl_uk_ls_2");
    }
}

var shortlist_landscape2 = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_ls_2',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});


function humanwildlifeconflict(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_human_wildlife_conflict').css('display', 'block');
        map.addLayer(human_wildlife_conflict);
        layerobject.push(human_wildlife_conflict);
        map.addOverlay(human_wildlife_conflict);
        lastselectedlayer.push("tbl_uk_all_human_wildlife_conflict_info");
        lastselectedlayername.push("Human Wildlife Conflict");
        lastselectedlayer_vector.push("tbl_uk_all_human_wildlife_conflict_info");
        //village_zoom();
    }
    else {
        jQuery('#div_human_wildlife_conflict').css('display', 'none');
        map.removeLayer(human_wildlife_conflict);
        layerobject.pop(human_wildlife_conflict);
        map.removeOverlay(human_wildlife_conflict);
        lastselectedlayer.pop("tbl_uk_all_human_wildlife_conflict_info");
        lastselectedlayername.pop("Human Wildlife Conflict");
        lastselectedlayer_vector.pop("tbl_uk_all_human_wildlife_conflict_info");
    }
}

var human_wildlife_conflict = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_all_human_wildlife_conflict_info',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function areaatlandscape1(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_area_at_landscape1').css('display', 'block');
        map.addLayer(area_at_landscape1);
        layerobject.push(area_at_landscape1);
        map.addOverlay(area_at_landscape1);
        lastselectedlayer.push("tbl_uk_intervention_l_1");
        lastselectedlayername.push("Intervention (degraded) area at landscape 1");
        lastselectedlayer_vector.push("tbl_uk_intervention_l_1");
        //village_zoom();
    }
    else {
        jQuery('#div_area_at_landscape1').css('display', 'none');
        map.removeLayer(area_at_landscape1);
        layerobject.pop(area_at_landscape1);
        map.removeOverlay(area_at_landscape1);
        lastselectedlayer.pop("tbl_uk_intervention_l_1");
        lastselectedlayername.pop("Intervention (degraded) area at landscape 1");
        lastselectedlayer_vector.pop("tbl_uk_intervention_l_1");
    }
}

var area_at_landscape1 = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_intervention_l_1',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function areaatlandscape2(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_area_at_landscape2').css('display', 'block');
        map.addLayer(area_at_landscape2);
        layerobject.push(area_at_landscape2);
        map.addOverlay(area_at_landscape2);
        lastselectedlayer.push("tbl_uk_intervention_l_2");
        lastselectedlayername.push("Intervention (degraded) area at landscape 2");
        lastselectedlayer_vector.push("tbl_uk_intervention_l_2");
        //village_zoom();
    }
    else {
        jQuery('#div_area_at_landscape2').css('display', 'none');
        map.removeLayer(area_at_landscape2);
        layerobject.pop(area_at_landscape2);
        map.removeOverlay(area_at_landscape2);
        lastselectedlayer.pop("tbl_uk_intervention_l_2");
        lastselectedlayername.pop("Intervention (degraded) area at landscape 2");
        lastselectedlayer_vector.pop("tbl_uk_intervention_l_2");
    }
}

var area_at_landscape2 = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_intervention_l_2',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function interventionarea(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_intervention_area').css('display', 'block');
        map.addLayer(intervention_area);
        layerobject.push(intervention_area);
        map.addOverlay(intervention_area);
        lastselectedlayer.push("tbl_uk_interventionareastats_fcd_lulc_dld_sac");
        lastselectedlayername.push("Intervention area stats (LULC, FCD and SAC degradation)");
        lastselectedlayer_vector.push("tbl_uk_interventionareastats_fcd_lulc_dld_sac");
        //village_zoom();
    }
    else {
        jQuery('#div_intervention_area').css('display', 'none');
        map.removeLayer(intervention_area);
        layerobject.pop(intervention_area);
        map.removeOverlay(intervention_area);
        lastselectedlayer.pop("tbl_uk_interventionareastats_fcd_lulc_dld_sac");
        lastselectedlayername.pop("Intervention area stats (LULC, FCD and SAC degradation)");
        lastselectedlayer_vector.pop("tbl_uk_interventionareastats_fcd_lulc_dld_sac");
    }
}

var intervention_area = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_interventionareastats_fcd_lulc_dld_sac',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});
function forestfirepoints(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_forest_fire_points').css('display', 'block');
        map.addLayer(forest_fire_points);
        layerobject.push(forest_fire_points);
        map.addOverlay(forest_fire_points);
        lastselectedlayer.push("tbl_uk_forest_fire_point");
        lastselectedlayername.push("Forest Fire Points");
        lastselectedlayer_vector.push("tbl_uk_forest_fire_point");
        //village_zoom();
    }
    else {
        jQuery('#div_forest_fire_points').css('display', 'none');
        map.removeLayer(forest_fire_points);
        layerobject.pop(forest_fire_points);
        map.removeOverlay(forest_fire_points);
        lastselectedlayer.pop("tbl_uk_forest_fire_point");
        lastselectedlayername.pop("Forest Fire Points");
        lastselectedlayer_vector.pop("tbl_uk_forest_fire_point");
    }
}

var forest_fire_points = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_uk_forest_fire_point',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

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



function sfdcircle(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_circle').css('display', 'block');
        map.addLayer(circles);
        layerobject.push(circles);
        map.addOverlay(circles);
        lastselectedlayer.push("tbl_circle_master");
        lastselectedlayername.push("SFD Circle Boundaries");
        lastselectedlayer_vector.push("tbl_circle_master");
        //village_zoom();
    }
    else {
        jQuery('#div_circle').css('display', 'none');
        map.removeLayer(circles);
        layerobject.pop(circles);
        map.removeOverlay(circles);
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
        jQuery('#div_division').css('display', 'block');
        map.addLayer(divisions);
        layerobject.push(divisions);
        map.addOverlay(divisions);
        lastselectedlayer.push("tbl_division_master");
        lastselectedlayername.push("SFD Division Boundaries");
        lastselectedlayer_vector.push("tbl_division_master");
        //village_zoom();
    }
    else {
        jQuery('#div_division').css('display', 'none');
        map.removeLayer(divisions);
        layerobject.pop(divisions);
        map.removeOverlay(divisions);
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



function range_fun(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_range').css('display', 'block');
        map.addLayer(ranges);
        layerobject.push(ranges);
        map.addOverlay(ranges);
        lastselectedlayer.push("tbl_range_areas");
        lastselectedlayername.push("Range");
        lastselectedlayer_vector.push("tbl_range_areas");
        //village_zoom();
    }
    else {
        jQuery('#div_range').css('display', 'none');
        map.removeLayer(ranges);
        layerobject.pop(ranges);
        map.removeOverlay(ranges);
        lastselectedlayer.pop("tbl_range_areas");
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
            layers: 'uk_sfd:tbl_range_areas',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});


/*================================Land Details==============================*/

//function LandDetails(checkbox) {

//    if (checkbox.checked) {
//        jQuery('#div_LandDetails').css('display', 'block');
//        map.addLayer(LandDetails_layer);
//        layerobject.push(LandDetails_layer);
//        map.addOverlay(LandDetails_layer);
//        lastselectedlayer.push("view_farmer_details");
//        lastselectedlayername.push("Land Details");
//        //LandDetails_zoom();
//    }
//    else {
//        jQuery('#div_LandDetails').css('display', 'none');
//        map.removeLayer(LandDetails_layer);
//        layerobject.pop(LandDetails_layer);
//        map.removeOverlay(LandDetails_layer);
//        lastselectedlayer.pop("view_farmer_details");
//        lastselectedlayername.pop("Land Details");
//    }
//}
//var LandDetails_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            //layers: 'nrdc:view_farmer_details',
//            //layers: 'nrdc:tbl_apple_land',
//            layers: 'nrdc:sultanpur_up_sample',
//            transition: 0
//        }
//    })
//});

//function apple_plant(checkbox) {

//    if (checkbox.checked) {
//        jQuery('#div_apple_plant').css('display', 'block');
//        map.addLayer(apple_plant_layer);
//        layerobject.push(apple_plant_layer);
//        map.addOverlay(apple_plant_layer);
//        lastselectedlayer.push("tbl_apple_plant");
//        lastselectedlayername.push("Apple Plants");
//        //LandDetails_zoom();
//    }
//    else {
//        jQuery('#div_apple_plant').css('display', 'none');
//        map.removeLayer(apple_plant_layer);
//        layerobject.pop(apple_plant_layer);
//        map.removeOverlay(apple_plant_layer);
//        lastselectedlayer.pop("tbl_apple_plant");
//        lastselectedlayername.pop("Apple Plants");
//    }
//}
//var apple_plant_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            layers: 'nrdc:tbl_apple_plant',
//            transition: 0
//        }
//    })
//});



/////------------------------------------Layer Zoom----------------------------------------------


function country_zoom() {
    //map.getView().fit(countryExtents, map.getSize());
    //map.getView().setZoom(4);
    myView = new ol.View({
        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
    });
    map.setView(myView);
}

//function state_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function district_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function tehsil_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function village_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function LandDetails_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function CropGrowth_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function CropHealth_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function CropHarvesting_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function VegetationMoisture_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function NitrogenContent_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function SoilMoisture_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function CropHealthChange_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function CropGrowthChange_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}

//function Weed_zoom() {
//    myView = new ol.View({
//        center: ol.proj.transform([24.050785278571425, -2.135673349472742], "EPSG:4326", "EPSG:3857"), zoom: 5
//    });
//    map.setView(myView);
//}



//************************************************************  top icon click    *******************************************

//function reload() {
//    location.reload();
//}

//function fit_to_map() {
//    map.setView(
//        new ol.View({
//            center: ol.proj.fromLonLat([86.65087, 24.51577]),
//            extent: map.getView().calculateExtent(map.getSize()),
//            zoom: 8
//        })
//    );
//}

//function previous() {

//    undoInteraction.undo();
//}

//function next() {

//    undoInteraction.redo();
//}

//var checkpan = "0";
//function selectpan() {
//    jQuery('#pan').toggleClass('iconenable');
//    if (checkpan == 0) {
//        jQuery('#map').css('cursor', 'grabbing');
//        checkpan = "1";
//    }
//    else if (checkpan == 1) {
//        jQuery('#map').css('cursor', 'default');
//        checkpan = "0";
//    }
//}

//************************************************************  INFO    *******************************************
var infoselected = "0";
function setselectedinfo() {

    if (pdetailsselected == "0") {
        if (buffersselected == "0") {
            jQuery('#info').toggleClass('iconenable');
            if (infoselected == 0) {
                infoselected = "1";
                map.on('singleclick', featureInfo_2);
            } else {
                map.un('singleclick', featureInfo_2);
                infoselected = "0";
            }
        }
        else {

            alert("Buffer Area is already selected , first unselect after that click.")
        }
    }
    else {
        alert("Edit Property Details Control is already selected , first unselect after that click.")
    }
}
var rowWiseArray_1 = [];
var featureInfo_2 = function (evt) {

    if (infoselected == 1) {
        var _CustomObject = new ol.layer.Image();
        for (i = 0; i < lastselectedlayer.length; i++) {
            fetch_layername = lastselectedlayer[i];
            console.log(lastselectedlayer[i]);
            if (lastselectedlayer[i] == lastselectedlayer[i]) {
                var _CustomObject = new ol.layer.Image({
                    source: new ol.source.ImageWMS({
                        ratio: 1,
                        url: geoserver_ip,
                        serverType: 'geoserver',
                        crossOrigin: 'anonymous',
                        params: {
                            'FORMAT': format,
                            tiled: true,
                            STYLES: '',
                            LAYERS: 'nrdc:' + lastselectedlayer[i],
                            transition: 0,
                        }
                    })
                });
            }
        }
        var view = map.getView();
        var viewResolution = view.getResolution();
        var source;
        if (_CustomObject.get('visible')) {
            source = _CustomObject.getSource();
        } else {
        }
        try {
            var counter = "";;
            console.log('counter=', counter);
            url = source.getGetFeatureInfoUrl(evt.coordinate, viewResolution, view.getProjection(), { 'INFO_FORMAT': 'text/html', 'FEATURE_COUNT': parseInt(counter) });
        } catch (e) {
        }
        if (url) {
            console.log(url);
            var _coordinate = evt.coordinate;
            overlay.setPosition(evt.coordinate);
            fetch(url)
                .then(response => response.text())
                .then(contents => showpopupinfo(contents, _coordinate, fetch_layername));
        }

    }
    else {
        var coord = ol.proj.toLonLat(evt.coordinate);
        var _coordinate = evt.coordinate;
    }
}
function capitalize_Words(str) {
    str = String(str);
    return str.replace(/(?:_| |\b)(\w)/g, function ($1) { return $1.toUpperCase().replace('_', ' '); });
}
function showpopupinfo(result, _coordinate, fetch_layername) {

    var globalCollectionArray = [];
    var headerColumns = [];
    jQuery(result).find('tr').each(function (indexno) {
        if (indexno == 0) {
            jQuery(this).find('th').each(function () {
                headerColumns.push(jQuery(this).text());
            });
        } else {
            var rowWiseArray = [];
            jQuery(this).find('td').each(function (index) {
                var headingstring = headerColumns[index];
                //if (!headingstring.includes('fid') && !headingstring.includes('id') && !headingstring.includes('dr')) {
                if (true) {
                    //CREATING JSON OBJECT
                    var CustomObject = { column: headerColumns[index], value: jQuery(this).text() };
                    rowWiseArray.push(CustomObject)
                }
            });
            globalCollectionArray.push({ row: rowWiseArray });
        }
    });
    var makeCustomHTML = '<div class=\'info-table-heading\'><span>' + lastselectedlayername[Number(lastselectedlayername.length) - 1] + '</span></div>';
    makeCustomHTML += ' <div style=\'overflow-y: auto; max-height: 250px;\'>';
    for (var i in globalCollectionArray) {
        makeCustomHTML += '<div class=\'layer-info-popup\'><table >';
        for (var j in globalCollectionArray[i].row) {
            var capt = capitalize_Words(globalCollectionArray[i].row[j].column);
            var val = capitalize_Words(globalCollectionArray[i].row[j].value)
            var re = /^[-+]?[0-9]+\.[0-9]+jQuery/;
            if (val.match(re)) {
                dval = parseFloat(val).toFixed(2);
                makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>' + capt + '</b></td><td class=\'tdpadding\' > ' + dval + '</td></tr>';
            }
            else {
                makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>' + capt + '</b></td><td class=\'tdpadding\' > ' + capitalize_Words(globalCollectionArray[i].row[j].value) + '</td></tr>';
            }
        }
        makeCustomHTML += '</table></div>';
    }
    makeCustomHTML += '</div>';
    if (Number(globalCollectionArray.length) > 0) {
        document.getElementById("infodiv").innerHTML = makeCustomHTML;
        overlay.setPosition(_coordinate);
        jQuery('#div').css({
            position: 'absolute',
            display: 'block'
        });

    } else {
        document.getElementById("infodiv").innerHTML = 'No record found ....';
        overlay.setPosition(_coordinate);
        jQuery('#div').css({
            position: 'absolute',
            display: 'block'
        });
    }
}
function closeclick() {
    jQuery('#div').css('display', 'none');
}
//************************************************************  INFO END   *******************************************
///-------------------Layer Swipe Start---------------------------------------

//function swipetool() {
//    jQuery('#layerswipe').toggleClass('iconenable');
//    if (jQuery('#swipediv').is(':visible')) {
//        jQuery('#swipediv').hide();

//    } else {
//        jQuery('#swipediv').show();

//    }

//}



///-------------------Layer Swipe End---------------------------------------

/////--------------------------------Attribute Update Start ------------------------------------------------///
var pdetailsselected = "0";
function personeldetailsinfo() {
    if (infoselected == "0") {
        if (buffersselected == "0") {
            jQuery('#pdetails').toggleClass('iconenable');
            if (pdetailsselected == 0) {
                pdetailsselected = "1";
                map.on('singleclick', featureInfo_3);
            } else {
                map.un('singleclick', featureInfo_3);
                pdetailsselected = "0";
            }
        }
        else {

            alert("Buffer Area is already selected , first unselect after that click.")
        }
    }
    else {

        alert("Information Control is already selected , first unselect after that click.")
    }

}
var coord_marker;
var pdetails_popups = function (evt) {

    var ltlg = ol.proj.toLonLat(evt.coordinate);
    var lon = (ltlg[0]).toFixed(5);
    var lat = (ltlg[1]).toFixed(5);
    document.getElementById('HiddenField1').value = lat;
    document.getElementById('HiddenField2').value = lon;


    coord_marker = evt.coordinate;

    var buildingstblnm = lastselectedlayer[lastselectedlayer.length - 1];
    // if (buildingstblnm == "village_boundary" ) {
    add_marker('add');
    document.getElementById('tblnam').value = buildingstblnm;
    jQuery('#myModal3').css('display', 'block');
    jQuery('#myModal3').css('opacity', '1');
    jQuery('#btnattribute').trigger('click');

    //}
    //else {
    //    document.getElementById('tblnam').value = "NA";
    //    jQuery('#myModal3').css('display', 'none');
    //    alert('First Check Polygon Layers after that click on map.')

    //}


}

function clg() {
    var mymodelpop = document.getElementById("myModal3");
    mymodelpop.css.display = "none";
    //jQuery('#myModal3').css('display', 'none');
    //add_marker('remove');
}


function add_marker(type) {

    const feature = new ol.Feature(new ol.geom.Point(coord_marker));
    var pinLayer = new ol.layer.Vector({
        source: new ol.source.Vector({
            features: [feature]
        }),
        style: new ol.style.Style({
            image: new ol.style.Icon({
                src: '..\images\marker.jpg'

            })
        })
    });

    if (type == 'add') {
        map.addLayer(pinLayer);
    }
    else {
        map.removeLayer(pinLayer);
        coord_marker = null;
    }
}
//*************************************************** Attribute Update End *****************************************

/////-------------------------------- Buffer Update Start------------------------------------------------///

var buffersselected = "0";
//function bufferdetailsinfo() {
//    if (infoselected == "0") {
//        if (pdetailsselected == "0") {
//            jQuery('#bdetails').toggleClass('iconenable');
//            if (buffersselected == 0) {
//                buffersselected = "1";
//                map.on('singleclick', buffer_popups);
//            } else {
//                map.un('singleclick', buffer_popups);
//                buffersselected = "0";
//            }
//        }
//        else {
//            alert("Edit Property Details Control is already selected , first unselect after that click.")
//        }
//    }
//    else {

//        alert("Information Control is already selected , first unselect after that click.")
//    }

//}
//var buffer_popups = function (evt) {

//    var ltlg = ol.proj.toLonLat(evt.coordinate);
//    var lon = (ltlg[0]).toFixed(5);
//    var lat = (ltlg[1]).toFixed(5);
//    document.getElementById('txtlat1').value = lat;
//    document.getElementById('txtlong1').value = lon;

//    var buildingstblnm = lastselectedlayer[lastselectedlayer.length - 1];
//    if (buildingstblnm == "village_boundary") {
//        document.getElementById('tblnam_buffer').value = buildingstblnm;
//        jQuery('#myModal4').css('display', 'block');
//        jQuery('#myModal4').css('opacity', '1');

//    }
//    else {
//        document.getElementById('tblnam_buffer').value = "NA";
//        jQuery('#myModal4').css('display', 'none');
//        alert('First Check Building Layers after that click on building.')

//    }


//}
//function clg1() {
//    jQuery('#myModal4').css('display', 'none');
//}
/////-------------------------------- Buffer Update Start------------------------------------------------///

////////////////////////////////////////// Download Polygon----------------------------------------------
//var cord_buffer;
//var download_ply = "0";
//function download_ploygon() {
//    if (download_ply == "0") {

//        var numFeatures = vector.getSource().getFeatures().length;
//        if (numFeatures != 0) {
//            if (numFeatures == 1) {
//                jQuery('#download').toggleClass('iconenable');
//                jQuery('#myModal5').css('display', 'block');
//                jQuery('#myModal5').css('opacity', '1');
//                download_ply = "1";
//                print_ploygon();
//            } else {
//                alert('Polygon is More one, Please only one Polygon at time')
//            }
//        }
//        else {
//            alert('First Create Polygon on Map')
//        }
//    }
//    else {
//        download_ply = "0";
//        jQuery('#download').toggleClass('iconenable');
//        jQuery('#myModal5').css('display', 'none');
//        vector.getSource().clear()
//    }
//}

//function clg2() {

//    download_ply = "0";
//    jQuery('#download').toggleClass('iconenable');
//    jQuery('#myModal5').css('display', 'none');
//    vector.getSource().clear()
//    jQuery("#typeDrow").val("Select").change();
//    // jQuery('#ImageButton1').hide();
//    jQuery('#ImageButton2').hide();
//}
//function clg3() {

//    vector.getSource().clear()
//    jQuery("#typeDrow").val("Select").change();
//    //jQuery('#ImageButton1').hide();
//    jQuery('#ImageButton2').hide();
//}
//function clear_ploygon() {

//    vector.getSource().clear()
//}
//function print_ploygon() {
//    var cc;
//    var features = vector.getSource().getFeatures();
//    features.forEach(function (feature) {
//        cc = feature.getGeometry().getCoordinates();
//    });
//    for (var i = 0; i < cc.length; i++) {
//        var cube = cc[i];
//        for (var j = 0; j < cube.length; j++) {
//            if (Math.abs(cc[i][j][0]) > 180 || Math.abs(cc[i][j][1]) > 180) {
//                var x = cc[i][j][0];
//                var y = cc[i][j][1];
//                x = (x * 180) / 20037508.34;
//                y = (y * 180) / 20037508.34;
//                y = (Math.atan(Math.pow(Math.E, y * (Math.PI / 180))) * 360) / Math.PI - 90;
//                if (j == 0)
//                    cord_buffer = x + ' ' + y;
//                else
//                    cord_buffer = cord_buffer + ',' + x + ' ' + y;;
//            }
//        }
//    }
//    document.getElementById('hdf_strlatlong').value = cord_buffer;
//    //console.log(cord_buffer);
//    //console.log(cc);
//}



//*************************************************** Paid, Un-Paid Filter Data *****************************************






/////-------------------------Query Builder---------------------------------


//var areasel = [];
//var select = null;  // ref to currently selected interaction
//var selectSingleClick = new ol.interaction.Select();
//var selectClick = new ol.interaction.Select({
//    condition: ol.events.condition.click
//});
//// select interaction working on "pointermove"
//var selectPointerMove = new ol.interaction.Select({
//    condition: ol.events.condition.pointerMove
//});
//var selectAltClick = new ol.interaction.Select({
//    condition: function (mapBrowserEvent) {
//        return ol.events.condition.click(mapBrowserEvent) &&
//            ol.events.condition.altKeyOnly(mapBrowserEvent);
//    }
//});



//*************************************************** map control End *****************************************
//***********************************************************************  Query Builder ****************************************

//var map, geojson, layer_name, layerSwitcher, featureOverlay;
var container, content, closer;


//function addRowHandlers() {
//    var table2 = jQuery('#table_data');
//    var table = document.getElementById("table");
//    var rows = table.getElementsByTagName("tr");
//    //var rows = document.getElementById("table").rows;
//    //var heads = table.getElementsByTagName('th');
//    //var col_no;
//    //for (var i = 0; i < heads.length; i++) {
//    //    // Take each cell
//    //    var head = heads[i];
//    //    //alert(head.innerHTML);
//    //    if (head.innerHTML == 'id') {
//    //        col_no = i + 1;
//    //        //alert(col_no);
//    //    }
//    //}
//    //for (i = 0; i < rows.length; i++) {
//    //    rows[i].onclick = function () {
//    //        return function () {
//    //            featureOverlay.getSource().clear();

//    //            jQuery(function () {
//    //                jQuery("#table td").each(function () {
//    //                    jQuery(this).parent("tr").css("background-color", "white");
//    //                });
//    //            });
//    //            var cell = this.cells[col_no - 1];
//    //            var id = cell.innerHTML;
//    //            jQuery(document).ready(function () {
//    //                jQuery("#table td:nth-child(" + col_no + ")").each(function () {
//    //                    if (jQuery(this).text() == id) {
//    //                        jQuery(this).parent("tr").css("background-color", "grey");
//    //                    }
//    //                });
//    //            });
//    //            var features = geojson.getSource().getFeatures();
//    //            //alert(features.length);
//    //            for (i = 0; i < features.length; i++) {
//    //                if (features[i].getId() == id) {
//    //                    featureOverlay.getSource().addFeature(features[i]);
//    //                    featureOverlay.getSource().on('addfeature', function () {
//    //                        map.getView().fit(
//    //                            featureOverlay.getSource().getExtent(),
//    //                            {
//    //                                duration: 1590,
//    //                                size: map.getSize(),
//    //                                zoom: 1
//    //                            }
//    //                        );
//    //                    });
//    //                }
//    //            }
//    //            //alert("id:" + id);
//    //        };
//    //    }(rows[i]);
//    //}
//}
//function highlight(evt) {
//    featureOverlay.getSource().clear();
//    var feature = map.forEachFeatureAtPixel(evt.pixel,
//        function (feature, layer) {
//            return feature;
//        });
//    if (feature) {





//        var geometry = feature.getGeometry();
//        var coord = geometry.getCoordinates();
//        var coordinate = evt.coordinate;
//        jQuery(function () {
//            jQuery("#table td").each(function () {
//                jQuery(this).parent("tr").css("background-color", "white");
//            });
//        });




//        featureOverlay.getSource().addFeature(feature);






//    }
//    var table = document.getElementById('table');
//    var cells = table.getElementsByTagName('td');
//    var rows = document.getElementById("table").rows;
//    var heads = table.getElementsByTagName('th');
//    var col_no;
//    for (var i = 0; i < heads.length; i++) {
//        // Take each cell
//        var head = heads[i];
//        //alert(head.innerHTML);
//        if (head.innerHTML == 'id') {
//            col_no = i + 1;
//            //alert(col_no);
//        }
//    }
//    var row_no = findRowNumber(col_no, feature.getId());
//    //alert(row_no);
//    var rows = document.querySelectorAll('#table tr');
//    rows[row_no].scrollIntoView({
//        behavior: 'smooth',
//        block: 'center'
//    });
//    jQuery(document).ready(function () {
//        jQuery("#table td:nth-child(" + col_no + ")").each(function () {
//            if (jQuery(this).text() == feature.getId()) {
//                jQuery(this).parent("tr").css("background-color", "grey");
//            }
//        });
//    });
//};


//*********************************************************************** End  Query Builder ****************************************



//************************************************************  top icon click End    *******************************************

//**************************************  measure draw  *********************************
const wgs84Sphere = new ol.Sphere(6378137);
let source = new ol.source.Vector();

const measureVectorLayer = new ol.layer.Vector({
    source: source,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: '#ffcc33',
            width: 2
        }),
        image: new ol.style.Circle({
            radius: 5,
            fill: new ol.style.Fill({ color: '#ffcc33' })
        })
    })
});
map.addLayer(measureVectorLayer);

// ========================== Global Variables ========================== //
let draw, sketch, measureTooltipElement, measureTooltip;
let measureTooltips = [];
 
let undoStack = [];
let redoStack = [];

// ========================== Measure Interaction ========================== //
function addMeasureInteraction(type) {
    if (draw) map.removeInteraction(draw);

    draw = new ol.interaction.Draw({
        source: source,
        type: type,
        style: new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: '#ff0000',
                width: 2,
                lineDash: [10, 10]
            }),
            image: new ol.style.Circle({
                radius: 5,
                fill: new ol.style.Fill({ color: '#ff0000' })
            }),
            fill: new ol.style.Fill({
                color: 'rgba(255, 0, 0, 0.1)'
            })
        })
    });

    map.addInteraction(draw);

    draw.on('drawstart', function (evt) {
        sketch = evt.feature;
        createMeasureTooltip();

        const geom = sketch.getGeometry();
        geom.on('change', function (evt) {
            const geom = evt.target;
            const output = (geom instanceof ol.geom.Polygon)
                ? formatArea(geom)
                : formatLength(geom);
            measureTooltipElement.innerHTML = output;
            measureTooltip.setPosition(geom.getLastCoordinate());
        });
    });

    draw.on('drawend', function (evt) {
        measureTooltipElement.className = 'tooltip tooltip-measure tooltip-static';
        measureTooltip.setOffset([0, -7]);

        evt.feature.setStyle(new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: '#00008b',
                width: 2
            }),
            fill: new ol.style.Fill({
                color: 'rgba(0, 0, 139, 0.1)'
            }),
            image: new ol.style.Circle({
                radius: 5,
                fill: new ol.style.Fill({ color: '#00008b' })
            })
        }));

        undoStack.push({ feature: evt.feature, tooltip: measureTooltip });
        redoStack = [];

        sketch = null;
        measureTooltipElement = null;
        measureTooltip = null;
    });
}

// ========================== Tooltip Creation ========================== //
function createMeasureTooltip() {
    if (measureTooltipElement) {
        measureTooltipElement.parentNode.removeChild(measureTooltipElement);
    }

    measureTooltipElement = document.createElement('div');
    measureTooltipElement.className = 'tooltip tooltip-measure';
    measureTooltip = new ol.Overlay({
        element: measureTooltipElement,
        offset: [0, -15],
        positioning: 'bottom-center'
    });
    map.addOverlay(measureTooltip);
    measureTooltips.push(measureTooltip);
}

// ========================== Format Length ========================== //
function formatLength(line) {
    let length = 0;
    const coordinates = line.getCoordinates();
    const sourceProj = map.getView().getProjection();
    for (let i = 0; i < coordinates.length - 1; ++i) {
        const c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
        const c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326');
        length += wgs84Sphere.haversineDistance(c1, c2);
    }
    return length > 100
        ? (Math.round(length / 1000 * 100) / 100) + ' km'
        : (Math.round(length * 100) / 100) + ' m';
}

function formatArea(polygon) {
    const sourceProj = map.getView().getProjection();
    const geom = polygon.clone().transform(sourceProj, 'EPSG:4326');
    const coordinates = geom.getLinearRing(0).getCoordinates();
    const area = Math.abs(wgs84Sphere.geodesicArea(coordinates));
    return area > 10000
        ? (Math.round(area / 1000000 * 100) / 100) + ' km²'
        : (Math.round(area * 100) / 100) + ' m²';
}


function undoLastFeature() {
    if (undoStack.length > 0) {
        const { feature, tooltip } = undoStack.pop();
        source.removeFeature(feature);
        map.removeOverlay(tooltip);
        redoStack.push({ feature, tooltip });
    }
}

function redoLastFeature() {
    if (redoStack.length > 0) {
        const { feature, tooltip } = redoStack.pop();
        source.addFeature(feature);
        map.addOverlay(tooltip);
        undoStack.push({ feature, tooltip });
    }
}
// ========================== Clear Measure ========================== //
function clearAll() {
    source.clear();
    measureTooltips.forEach(tip => map.removeOverlay(tip));
    measureTooltips = [];
    undoStack = [];
    redoStack = [];

    const popup = document.getElementById('popup');
    popup.classList.remove('hidden');
    popup.textContent = 'All features cleared!';
    setTimeout(() => popup.classList.add('hidden'), 1200);
}
// ========================== Button Events ========================== //
let activeTool = null;
const toolButtons = {
    measureLine: 'LineString',
    measureArea: 'Polygon'
};

//Object.entries(toolButtons).forEach(([id, type]) => {
//    const button = document.getElementById(id);

//    button.addEventListener('click', function () {
//        if (activeTool === id) {
//            // Deactivate if same tool is clicked again
//            if (draw) map.removeInteraction(draw);
//            draw = null;
//            activeTool = null;
//            document.querySelectorAll('.tool-btn').forEach(btn => btn.classList.remove('active'));
//        } else {
//            // Activate new tool
//            document.querySelectorAll('.tool-btn').forEach(btn => btn.classList.remove('active'));
//            this.classList.add('active');
//            activeTool = id;
//            addMeasureInteraction(type);
//        }
//    });
//});

//document.getElementById('clearAllBtn').addEventListener('click', clearAll);
//document.getElementById('undoBtn').addEventListener('click', undoLastFeature);
//document.getElementById('redoBtn').addEventListener('click', redoLastFeature);





//var wgs84Sphere = new ol.Sphere(6378137);
//var map, source, draw, sketch, helpTooltip, measureTooltip, measureTooltipElement, helpTooltipElement;
//var undoStack = [];
//var redoStack = [];
//var lastMeasuredFeature = null;
//var measureTooltips = [];


//function clearInteractions() {
//    if (draw) map.removeInteraction(draw);
//    draw = null;
//}

//function handleToolActivation() {
//    clearInteractions();
//    const activeTool = document.querySelector('.tool-btn.active');
//    if (!activeTool) return;

//    const id = activeTool.id;
//    if (id === 'measureLine') {
//        addMeasureInteraction('LineString');
//    } else if (id === 'measureArea') {
//        addMeasureInteraction('Polygon');
//    } else if (id === 'drawPolygon') {
//        addDrawInteraction('Polygon');
//    } else if (id === 'drawCircle') {
//        addDrawInteraction('Circle');
//    } else if (id === 'drawLine') {
//        addDrawInteraction('LineString');
//    }
//}

//function addDrawInteraction(type) {
//    draw = new ol.interaction.Draw({ source: source, type: type });
//    map.addInteraction(draw);
//    draw.on('drawend', function (evt) {
//        undoStack.push(evt.feature);
//        redoStack = [];
//        lastMeasuredFeature = evt.feature;
//    });
//}

//function addMeasureInteraction(type) {
//    draw = new ol.interaction.Draw({
//        source: source,
//        type: type,
//        style: new ol.style.Style({
//            fill: new ol.style.Fill({ color: 'rgba(255, 255, 255, 0.2)' }),
//            stroke: new ol.style.Stroke({ color: '#e21d1d', lineDash: [10, 10], width: 2 }),
//            image: new ol.style.Circle({
//                radius: 5,
//                stroke: new ol.style.Stroke({ color: 'rgba(0, 0, 0, 0.7)' }),
//                fill: new ol.style.Fill({ color: 'rgba(255, 255, 255, 0.2)' })
//            })
//        })
//    });

//    map.addInteraction(draw);
//    createMeasureTooltip();
//    createHelpTooltip();

//    draw.on('drawstart', function (evt) {
//        sketch = evt.feature;
//        sketch.getGeometry().on('change', function (evt) {
//            var geom = evt.target;
//            var output = geom instanceof ol.geom.Polygon ? formatArea(geom) : formatLength(geom);
//            measureTooltipElement.innerHTML = output;
//            measureTooltip.setPosition(geom.getLastCoordinate());
//        });
//    });

//    draw.on('drawend', function (evt) {
//        undoStack.push(sketch);
//        redoStack = [];
//        lastMeasuredFeature = sketch;
//        measureTooltipElement.className = 'tooltip tooltip-static';
//        measureTooltip.setOffset([0, -7]);
//        sketch = null;
//        measureTooltipElement = null;
//        createMeasureTooltip();
//    });
//}

//function createHelpTooltip() {
//    if (helpTooltipElement) helpTooltipElement.parentNode.removeChild(helpTooltipElement);
//    helpTooltipElement = document.createElement('div');
//    helpTooltipElement.className = 'tooltip hidden';
//    helpTooltip = new ol.Overlay({
//        element: helpTooltipElement,
//        offset: [15, 0],
//        positioning: 'center-left'
//    });
//    map.addOverlay(helpTooltip);
//}

//function createMeasureTooltip() {
//    if (measureTooltipElement) measureTooltipElement.parentNode.removeChild(measureTooltipElement);
//    measureTooltipElement = document.createElement('div');
//    measureTooltipElement.className = 'tooltip tooltip-measure';
//    measureTooltip = new ol.Overlay({
//        element: measureTooltipElement,
//        offset: [0, -15],
//        positioning: 'bottom-center'
//    });
//    map.addOverlay(measureTooltip);
//    measureTooltips.push(measureTooltip);
//}

//function formatLength(line) {
//    var length = 0;
//    var coordinates = line.getCoordinates();
//    var sourceProj = map.getView().getProjection();
//    for (var i = 0; i < coordinates.length - 1; ++i) {
//        var c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
//        var c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326');
//        length += wgs84Sphere.haversineDistance(c1, c2);
//    }
//    return length > 100
//        ? (Math.round(length / 1000 * 100) / 100) + ' km'
//        : (Math.round(length * 100) / 100) + ' m';
//}

//function formatArea(polygon) {
//    var sourceProj = map.getView().getProjection();
//    var geom = polygon.clone().transform(sourceProj, 'EPSG:4326');
//    var coordinates = geom.getLinearRing(0).getCoordinates();
//    var area = Math.abs(wgs84Sphere.geodesicArea(coordinates));
//    return area > 10000
//        ? (Math.round(area / 1000000 * 100) / 100) + ' km²'
//        : (Math.round(area * 100) / 100) + ' m²';
//}

//function undo() {
//    var feature = undoStack.pop();
//    if (feature) {
//        source.removeFeature(feature);
//        redoStack.push(feature);
//    }
//}

//function redo() {
//    var feature = redoStack.pop();
//    if (feature) {
//        source.addFeature(feature);
//        undoStack.push(feature);
//    }
//}
//function clearAll() {
//    let result = '';
//    if (lastMeasuredFeature) {
//        const geom = lastMeasuredFeature.getGeometry();
//        result = geom instanceof ol.geom.LineString
//            ? 'Cleared: ' + formatLength(geom)
//            : geom instanceof ol.geom.Polygon
//                ? 'Cleared: ' + formatArea(geom)
//                : 'Last shape cleared.';
//    } else {
//        result = 'No measurement to clear.';
//    }

//    source.clear();
//    undoStack = [];
//    redoStack = [];
//    lastMeasuredFeature = null;

//    measureTooltips.forEach(tip => map.removeOverlay(tip));
//    measureTooltips = [];

//    const popup = document.getElementById('popup');
//    popup.textContent = result;
//    popup.classList.remove('hidden');
//    setTimeout(() => popup.classList.add('hidden'), 1000);

//    // ✅ Unselect all tool buttons
//    document.querySelectorAll('.tool-btn').forEach(btn => btn.classList.remove('active'));
//    clearInteractions(); // Remove any current interaction
//}

//// Init map and bind events
 

//// Handle tool image button clicks
//document.querySelectorAll('.tool-btn').forEach(img => {
//    img.addEventListener('click', () => {
//        const isActive = img.classList.contains('active');
//        document.querySelectorAll('.tool-btn').forEach(i => i.classList.remove('active'));
//        if (!isActive) img.classList.add('active');
//        handleToolActivation();
//    });
//});

//document.getElementById('undoBtn').addEventListener('click', undo);
//document.getElementById('redoBtn').addEventListener('click', redo);
////document.getElementById('clearAllBtn').addEventListener('click', clearAll);





















//var source = new ol.source.Vector();
//var styleFunction = function (feature) {
//    var geometry = feature.getGeometry();
//    var styles = [
//        new ol.style.Style({
//            stroke: new ol.style.Stroke({
//                color: '#1d2be2',
//                width: 2
//            })
//        })
//    ];
//    return styles;
//};
//var vector = new ol.layer.Vector({
//    name: 'vectordraw',
//    source: source,
//    style: styleFunction
//});
//var coord = null;
//var wgs84Sphere = new ol.Sphere(6378137);
//var getlat = function (evt) {

//    coord = evt.coordinate;
//    w_latitute = latitute = coord[1];
//    w_longitute = longitute = coord[0];
//    var lt = document.getElementById('lt');
//    lt.value = latitute;
//    var lg = document.getElementById('lg');
//    lg.value = longitute;
//}
//function typeDraw() {

//    map.un('click', getlat);
//    var value_measure = jQuery('#measure option:selected').val();
//    var value_draw = jQuery('#typeDrow option:selected').val();
//    if (value_measure == 'Select' && value_draw == 'Select') {
//        jQuery('.UndoRedoCls').hide();
//    } else {
//        jQuery('.UndoRedoCls').show();
//    }
//    map.removeInteraction(draw);
//    DrawaddInteraction();
//}
//function DrawaddInteraction() {

//    var value_draw = jQuery('#typeDrow option:selected').val();
//    if (value_draw !== 'None' && value_draw !== 'Select') {
//        draw = new ol.interaction.Draw({
//            source: source,
//            type: /** @type {ol.geom.GeometryType} */ (value_draw)
//        });
//        map.addInteraction(draw);
//        map.addLayer(vector);
//    }
//}
//var draw;
//function measureLine() {
//    map.un('click', getlat);
//    var typeSelect = document.getElementById('measure').value;
//    var value_measure = jQuery('#measure option:selected').val();
//    var value_draw = jQuery('#typeDrow option:selected').val();
//    if (value_measure == 'Select' && value_draw == 'Select') {
//        jQuery('.UndoRedoCls').hide();
//    } else {
//        jQuery('.UndoRedoCls').show();
//    }
//    map.removeInteraction(draw);
//    addInteraction();
//    map.on('pointermove', pointerMoveHandler);
//    map.getViewport().addEventListener('mouseout', function () {
//        helpTooltipElement.classList.add('hidden');
//    });
//}
//var sketch;
//var helpTooltip;
//var measureTooltipElement;
//var measureTooltip;
//var continuePolygonMsg = 'Click to continue drawing the polygon';
//var continueLineMsg = 'Click to continue drawing the line';
//var pointerMoveHandler = function (evt) {
//    if (evt.dragging) {
//        return;
//    }
//    var helpMsg = 'Click to start drawing';
//    if (sketch) {
//        var geom = (sketch.getGeometry());
//        if (geom instanceof ol.geom.Polygon) {
//            helpMsg = continuePolygonMsg;
//        } else if (geom instanceof ol.geom.LineString) {
//            helpMsg = continueLineMsg;
//        }
//    }
//};
//var formatLength = function (line) {
//    var length;
//    if (true) {
//        var coordinates = line.getCoordinates();
//        length = 0;
//        var sourceProj = map.getView().getProjection();
//        for (var i = 0, ii = coordinates.length - 1; i < ii; ++i) {
//            var c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
//            var c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326');
//            length += wgs84Sphere.haversineDistance(c1, c2);
//        }
//    } else {
//        length = Math.round(line.getLength() * 100) / 100;
//    }
//    var output;
//    if (length > 100) {
//        output = (Math.round(length / 1000 * 100) / 100) +
//            ' ' + 'km';
//    } else {
//        output = (Math.round(length * 100) / 100) +
//            ' ' + 'm';
//    }
//    return output;
//};
//var formatArea = function (polygon) {
//    var area;
//    if (true) {
//        var sourceProj = map.getView().getProjection();
//        var geom = /** @type {ol.geom.Polygon} */(polygon.clone().transform(
//            sourceProj, 'EPSG:4326'));
//        var coordinates = geom.getLinearRing(0).getCoordinates();
//        area = Math.abs(wgs84Sphere.geodesicArea(coordinates));
//    } else {
//        area = polygon.getArea();
//    }
//    var output;
//    if (area > 10000) {
//        output = (Math.round(area / 1000000 * 100) / 100) +
//            ' ' + 'km<sup>2</sup>';
//    } else {
//        output = (Math.round(area * 100) / 100) +
//            ' ' + 'm<sup>2</sup>';
//    }
//    return output;
//};
//function addInteraction() {

//    var value_measure = jQuery('#measure option:selected').val();
//    if (value_measure != 'Select') {
//        var type = (value_measure == 'area' ? 'Polygon' : 'LineString');
//        draw = new ol.interaction.Draw({
//            source: source,
//            type: /** @type {ol.geom.GeometryType} */ (type),
//            style: new ol.style.Style({
//                fill: new ol.style.Fill({
//                    color: 'rgba(255, 255, 255, 0.2)'
//                }),
//                stroke: new ol.style.Stroke({
//                    color: '#e21d1d',//'rgba(0, 0, 0, 0.5)',
//                    lineDash: [10, 10],
//                    width: 2
//                }),
//                image: new ol.style.Circle({
//                    radius: 5,
//                    stroke: new ol.style.Stroke({
//                        color: 'rgba(0, 0, 0, 0.7)'
//                    }),
//                    fill: new ol.style.Fill({
//                        color: 'rgba(255, 255, 255, 0.2)'
//                    })
//                })
//            })
//        });
//        map.addInteraction(draw);
//        createMeasureTooltip();
//        createHelpTooltip();
//        var listener;
//        draw.on('drawstart',
//            function (evt) {
//                sketch = evt.feature;
//                var tooltipCoord = evt.coordinate;
//                listener = sketch.getGeometry().on('change', function (evt) {
//                    var geom = evt.target;
//                    var output;
//                    if (geom instanceof ol.geom.Polygon) {
//                        output = formatArea(geom);
//                        tooltipCoord = geom.getInteriorPoint().getCoordinates();
//                    } else if (geom instanceof ol.geom.LineString) {
//                        output = formatLength(geom);
//                        tooltipCoord = geom.getLastCoordinate();
//                    }
//                    measureTooltipElement.innerHTML = output;
//                    measureTooltip.setPosition(tooltipCoord);
//                });
//            }, this);
//        draw.on('drawend',
//            function () {
//                measureTooltipElement.className = 'tooltip tooltip-static';
//                measureTooltip.setOffset([0, -7]);
//                sketch = null;
//                measureTooltipElement = null;
//                createMeasureTooltip();
//                ol.Observable.unByKey(listener);
//            }, this);
//    }
//}
//var helpTooltipElement;
//function createHelpTooltip() {
//    if (helpTooltipElement) {
//        helpTooltipElement.parentNode.removeChild(helpTooltipElement);
//    }
//    helpTooltipElement = document.createElement('div');
//    helpTooltipElement.className = 'tooltip hidden';
//    helpTooltip = new ol.Overlay({
//        element: helpTooltipElement,
//        offset: [15, 0],
//        positioning: 'center-left'
//    });
//    map.addOverlay(helpTooltip);
//}
//function createMeasureTooltip() {
//    if (measureTooltipElement) {
//        measureTooltipElement.parentNode.removeChild(measureTooltipElement);
//    }
//    measureTooltipElement = document.createElement('div');
//    measureTooltipElement.className = 'tooltip tooltip-measure';
//    measureTooltip = new ol.Overlay({
//        element: measureTooltipElement,
//        offset: [0, -15],
//        positioning: 'bottom-center'
//    });
//    map.addOverlay(measureTooltip);
//    map.addLayer(vector);
//}
//var undoInteraction = new ol.interaction.UndoRedo();
//var mapExtents = map.getView().calculateExtent(map.getSize());

//map.addInteraction(undoInteraction);
//undoInteraction.on('undo', function (e) {
//    if (e.action.type === 'addfeature') {
//        jQuery('.ol-overlay-container').find('.tooltip-static').hide();
//    }
//});
//undoInteraction.on('redo', function (e) {

//    if (e.action.type === 'addfeature') {
//        jQuery('.ol-overlay-container').find('.tooltip-static').show();
//    }countrycountry
//});




//**************************************  measure draw  End *********************************



//*********************************************  table div show hide & export Table   *****************************************

var sohideselected = "0";
var div = document.getElementById('table_data');
var imgids = document.getElementById('shimg');
function showhide() {
    jQuery('#button').toggleClass('showhideheight');

    if (sohideselected == 0) {
        div.style.display = 'none';
        imgids.style.transform = 'rotate(-90deg)';
        sohideselected = "1";

    } else {
        div.style.display = 'block';
        imgids.style.transform = 'rotate(90deg)';
        sohideselected = "0";
    }
}



var pfiltersohideselected = "0";
var div2 = document.getElementById('griddiv');
var imgids2 = document.getElementById('shimg2');
function fshowhide() {
    jQuery('#pfilterbutton').toggleClass('showhideheight');

    if (pfiltersohideselected == 0) {
        div2.style.display = 'none';
        imgids2.style.transform = 'rotate(-90deg)';
        pfiltersohideselected = "1";

    } else {
        div2.style.display = 'block';
        imgids2.style.transform = 'rotate(90deg)';
        pfiltersohideselected = "0";
    }
}



///------------------------------------------- Query Builder-----------------------------------

//var url;
//function popQueruyBuilder() {

//    var itm = document.getElementById("QueryBuilderpop");
//    itm.classList.toggle("popdisplay");
//}
//function hidequeryBuilder() {
//    document.getElementById("QueryBuilderpop").classList.remove("popdisplay");
//    document.getElementById("QueryBuilderpop").removeAttribute("style");
//    document.getElementById("queryTableid").style.display = "none";
//    document.getElementById("btntoggle").style.display = "none";
//    ClearAllLayers();

//}
//function clearControl() {
//    document.getElementById("queryTableid").style.display = "none";
//    document.getElementById("btntoggle").style.display = "none";


//    let exp = document.getElementById("btnexport");
//    exp.setAttribute("style", "display:none")
//}


//function funQueryData() {
//    var ele = document.getElementById("queryTableid");
//    var elebtn = document.getElementById("btntoggle");
//    ele.classList.toggle("queryTabledisplay");
//    elebtn.classList.toggle("queryTable1toggle");

//}
//var newSelectedParcelInfo;
//var operator;
//var val;
//var lbl;




//jQuery(document).ready(function () {
//    function getColumnIndex(headerName) {
//        var index = -1;
//        jQuery('#queryData tbody tr').first().find('th, td').each(function (i) {
//            if (jQuery(this).text() === headerName) {
//                index = i;
//            }
//        });
//        return index;
//    }
//    var kidColumnIndex = getColumnIndex('kid');
//    jQuery('#queryData tbody').on('click', 'tr', function () {
//        jQuery('tr').removeClass('filterselectedrow');
//        jQuery(this).addClass('filterselectedrow');
//        var $row = jQuery(this);
//        var kid = $row.find('td').eq(kidColumnIndex).text();


//        map.removeLayer(newSelectedParcelInfo);
//        map.removeOverlay(newSelectedParcelInfo);
//        newSelectedParcelInfo = new ol.layer.Image({
//            source: new ol.source.ImageWMS({
//                ratio: 1,
//                url: geoserver_ip,
//                params: {
//                    'FORMAT': format,
//                    tiled: true,
//                    STYLES: '',
//                    LAYERS: 'nrdc:cadastral_deoghar_parcel_boundary',
//                    CQL_FILTER: 'id=' + "\'" + kid + "\'",
//                    transition: 0
//                }

//            })
//        });


//        map.addLayer(newSelectedParcelInfo);
//        map.addOverlay(newSelectedParcelInfo);

//    });
//});

////update parcel start ==================================================================================================================================
//var editselected = 1;

//function updateParceldata() {
//    if (jQuery('#updatedata').hasClass('i_select') && editselected == 1) {
//        editselected = 0;
//        map.on('singleclick', featureInfo_3);
//        // map.on('pointermove', featureInfo_1);
//        map.on('click', getlat);
//        // jQuery('#infoli').removeClass('i_select').find('img').attr('src', 'images/prop5.png');
//        jQuery('#updatedata').removeClass('i_select').find('img').css({ opacity: 1 });

//        map.on('click', getlat);

//    } else {
//        map.on('singleclick', featureInfo_3);
//        //map.un('pointermove', featureInfo_1);
//        map.un('click', getlat);
//        editselected = 1;
//        //jQuery('#infoli').addClass('i_select').find('img').attr('src', 'images/prop5-1.png');
//        jQuery('#updatedata').addClass('i_select').find('img').css({ opacity: 0.5 });

//        map.un('click', getlat);
//    }
//}
//var featureInfo_3 = function (evt) {
//    var ltlg = ol.proj.toLonLat(evt.coordinate);
//    var lon = (ltlg[0]).toFixed(5);
//    var lat = (ltlg[1]).toFixed(5);
//    document.getElementById('HiddenField1').value = lat;
//    document.getElementById('HiddenField2').value = lon;


//    coord_marker = evt.coordinate;

//    var buildingstblnm = lastselectedlayer[lastselectedlayer.length - 1];
//    if (buildingstblnm != "") {
//        add_marker('add');
//        document.getElementById('tblnam').value = buildingstblnm;
//        jQuery('#myModal3').css('display', 'block');
//        jQuery('#myModal3').css('opacity', '1');
//        jQuery('#btnattribute').trigger('click');

//    }
//    else {
//        document.getElementById('tblnam').value = "NA";
//        jQuery('#myModal3').css('display', 'none');
//        alert('First Check Polygon Layers after that click on map.')

//    }

//    if (editselected == 1) {

//        var _CustomObject = new ol.layer.Image();
//        var number_array = Number(lastselectedlayer.length);
//        for (i = 0; i < lastselectedlayer.length; i++) {
//            fetch_layername = lastselectedlayer[i];
//            var _CustomObject = new ol.layer.Image({

//                source: new ol.source.ImageWMS({
//                    ratio: 1,
//                    url: geoserver_ip,
//                    params: {
//                        'FORMAT': format,
//                        tiled: true,
//                        STYLES: '',
//                        LAYERS: 'nrdc:' + lastselectedlayer[i],
//                        transition: 0,

//                    }
//                })
//            });


//        }

//        var view = map.getView();
//        var viewResolution = view.getResolution();

//        var source;
//        if (_CustomObject.get('visible')) {
//            source = _CustomObject.getSource();
//        } else {
//        }
//        try {

//            url = source.getGetFeatureInfoUrl(evt.coordinate, viewResolution, view.getProjection(), { 'INFO_FORMAT': 'text/html', 'FEATURE_COUNT': 500 });
//        } catch (e) {

//        }

//        if (url) {

//            var _coordinate = evt.coordinate;
//            contentEdit.innerHTML = "<div class=\'loader\'><img style='height:100px;width:100px' src='../images/loader1.gif'></img><span style='text-align:center;font-size:15px;padding-left:5px'>Please Wait...</span></div";

//            overlay.setPosition(evt.coordinate);

//            console.log(url);
//            fetch(url) // https://cors-anywhere.herokuapp.com/https://example.com
//                .then(response => response.text())
//                .then(contents => showpopupinfo_1(contents, _coordinate, fetch_layername))

//            var coord = ol.proj.toLonLat(evt.coordinate);
//            var lon = (coord[0]).toFixed(2);
//            var lat = (coord[1]).toFixed(2);

//            coord1 = lon + ',' + lat;

//        }
//    }

//}
//var newSelectedParcel;
//function showpopupinfo_1(result, _coordinate, fetch_layername) {
//    var infoDt = document.getElementById("infoDt");
//    if (lastselectedlayer.length < 1) {
//        alert("Initial layer not selected");
//    }



//    var globalCollectionArray = [];
//    var headerColumns = [];
//    var dtm = infoDt.innerHTML;
//    var dtmm = dtm.split(" ");

//    var arr1 = dtmm[0].split("-");
//    var fina = arr1[0] + '/' + arr1[1] + '/' + arr1[2] + ' ' + dtmm[1] + ' ' + dtmm[2];
//    //var fina = dtmm[0].replaceAll("-","/")+' '+dtmm[1]+' '+dtmm[2];
//    //var fina = dtmm[0].substring(1)+'/'+dtmm[1].substring(1)+'/'+dtmm[2].substring(2) +" 12:00 Am";
//    //var fina = infoDt.innerHTML;;

//    //var parcelid = document.getElementById('parcelid');
//    jQuery(result).find('tr').each(function (indexno) {

//        if (indexno == 0) {

//            jQuery(this).find('th').each(function () {
//                headerColumns.push(jQuery(this).text());
//            });

//        } else {

//            var rowWiseArray = [];


//            jQuery(this).find('td').each(function (index) {

//                var headingstring = headerColumns[index];

//                //parcelid.innerHTML = headingstring.id;
//                if (!headingstring.includes('fid')) {

//                    var CustomObject = { column: headerColumns[index], value: jQuery(this).text() };
//                    rowWiseArray.push(CustomObject)
//                }
//            });

//            globalCollectionArray.push({ row: rowWiseArray });
//        }

//    });




//    var makeCustomHTML = '<div class=\'edit-table-heading\' style="background-color: #113d6a;color:#ffffff;text-align: center;"><span>' + fetch_layername + '</span></div>';
//    makeCustomHTML += ' <div style=\'overflow-y: auto; max-height: 200px;\'>';

//    for (var i in globalCollectionArray) {

//        makeCustomHTML += '<div class=\'layer-edit-popup\'><table id=\'tbleditable\'>';

//        for (var j in globalCollectionArray[i].row) {

//            var capt = (globalCollectionArray[i].row[j].column);
//            var setid = capt;
//            var val = (globalCollectionArray[i].row[j].value)


//            var re = /^[-+]?[0-9]+\.[0-9]+$/;
//            if (val.match(re)) {

//                dval = parseFloat(val).toFixed(2);


//                if (fetch_layername != 'Rainfall Catchment') {

//                    makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>' + capt + '</b></td><td class=\'tdpadding\' >&nbsp&nbsp:&nbsp&nbsp</td><td class=\'tdpadding\' > ' + dval + '</td></tr>';


//                }
//                else {

//                    if (val === fina) {

//                        makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>Date</b></td><td class=\'tdpadding\' >&nbsp&nbsp:&nbsp&nbsp</td><td class=\'tdpadding\' > ' + dval + '</td></tr>';
//                        makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>Name</b></td><td class=\'tdpadding\' >&nbsp&nbsp:&nbsp&nbsp</td><td class=\'tdpadding\' > ' + dval + '</td></tr>';
//                        makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>Value(mm)</b></td><td class=\'tdpadding\' >&nbsp&nbsp:&nbsp&nbsp</td><td class=\'tdpadding\' > ' + dval + '</td></tr>'

//                    }
//                }
//            }
//            else {
//                if (fetch_layername != 'Rainfall Catchment') {
//                    if (capt == "kid") {
//                        makeCustomHTML += '<tr><td class=\'tdpadding\'><b>' + capt + '</b></td><td class=\'tdpadding\' >&nbsp&nbsp:&nbsp&nbsp</td><td class=\'\' id=\'selectedParcelId\'> ' + (globalCollectionArray[i].row[j].value) + '</td></tr>';
//                    } else {
//                        makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>' + capt + '</b></td><td class=\'tdpadding\' >&nbsp&nbsp:&nbsp&nbsp</td><td class=\'editable\' id=\'' + setid + '\'> ' + (globalCollectionArray[i].row[j].value) + '</td></tr>';
//                    }


//                }
//                else {

//                    if (val === fina) {


//                        makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>Date</b></td><td class=\'tdpadding\' >&nbsp&nbsp:&nbsp&nbsp</td><td class=\'tdpadding\' > ' + (globalCollectionArray[i].row[0].value) + '</td></tr>';
//                        makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>Name</b></td><td class=\'tdpadding\' >&nbsp&nbsp:&nbsp&nbsp</td><td class=\'tdpadding\' > ' + (globalCollectionArray[i].row[1].value) + '</td></tr>';
//                        makeCustomHTML += '<tr><td class=\'tdpadding\' ><b>Value(mm)</b></td><td class=\'tdpadding\' >&nbsp&nbsp:&nbsp&nbsp</td><td class=\'tdpadding\' > ' + (globalCollectionArray[i].row[2].value) + '</td></tr>';
//                        //break;


//                    }
//                }
//            }
//        }

//        makeCustomHTML += '</table></div>';
//    }

//    makeCustomHTML += '</div>';
//    var selectedParcelId;
//    let idValue;


//    if (Number(globalCollectionArray.length) > 0) {
//        $("#myModel3").css("display", "block");

//        contentEdit.innerHTML = makeCustomHTML;

//        // contentEdit.innerHTML = "Data for update";
//        overlay.setPosition(_coordinate);
//        let latitute = _coordinate[1];
//        let longitute = _coordinate[0];
//        //document.getElementById('hf_letForCenter').Value = latitute;
//        //document.getElementById('hf_longForCenter').Value = longitute;
//        document.getElementById('txtlt').value = _coordinate[1];
//        document.getElementById('txtlg').value = _coordinate[0];

//        //var cityextent = [86.632800, 24.503953, 86.668452, 24.527984];
//        //var cityextent = [longitute - 0.001101234, latitute - 0.001101234, longitute + 0.001101234, latitute + 0.001101234];
//        // map.getView().fit(cityextent, map.getSize());

//        selectedParcelId = document.getElementById('selectedParcelId');
//        idValue = document.getElementById("parcelid");
//        if (selectedParcelId.innerHTML == "") {
//            idValue.value = "0";
//        } else {

//            idValue.value = selectedParcelId.innerHTML;
//            document.getElementById("parcelidforupdate").value = idValue.value;
//            document.getElementById("parcelidlayer").value = fetch_layername;

//            console.log(document.getElementById("parcelidforupdate").value);
//        }

//        //var txt = document.getElementById("btnTest");
//        //txt.click();



//        map.removeLayer(newSelectedParcel);
//        map.removeOverlay(newSelectedParcel);

//        newSelectedParcel = new ol.layer.Image({
//            source: new ol.source.ImageWMS({
//                ratio: 1,
//                url: geoserver_ip,
//                params: {
//                    crossOrigin: 'anonymous',
//                    'FORMAT': format,
//                    tiled: true,
//                    STYLES: '',
//                    LAYERS: 'nrdc:cadastral_deoghar_parcel_boundary',
//                    CQL_FILTER: 'id=' + "\'" + idValue.value + "\'",
//                    transition: 0
//                }

//            })
//        });


//        // if (flag != idValue.value) {
//        map.addLayer(newSelectedParcel);
//        map.addOverlay(newSelectedParcel);



//        // }





//    }
//}
////update parcel end


////document.getElementById('convertBtn').addEventListener('click', function (event) {
////    // Get all table cells with the class 'editable'
////    event.preventDefault();
////    var cells = document.querySelectorAll('#tbleditable .editable');

////    // Iterate through each cell
////    cells.forEach(function (cell) {
////        // Check if the cell already contains an input to avoid duplication
////        if (cell.querySelector('input') === null) {
////            // Create a new input field
////            var input = document.createElement('input');
////            input.type = 'text'; // You can adjust the input type if needed
////            input.value = cell.innerHTML; // Set the initial value of the input field

////            // Set the ID and runat="server" attribute
////            input.id = cell.id; // Use a sanitized version of the label text as the ID
////            input.setAttribute('runat', 'server'); // Add runat="server" attribute

////            // Clear the cell and append the new input field
////            cell.removeAttribute('id');
////            cell.innerHTML = '';
////            cell.appendChild(input);
////        }
////    });
////});


///*===========================================AOI Bind============================================*/
//var sentinel_layer = new ol.layer.Tile({
//    source: new ol.source.TileWMS({
//        url: "https://services.sentinel-hub.com/ogc/wms/882ce149-eff6-4c7e-9cb3-cd575e0c80af",
//        //url: "https://services.sentinel-hub.com/ogc/wms/9b4d93bf-b7e5-4588-9394-cf70951aed63",
//        params: { "maxcc": 85, "minZoom": 6, "maxZoom": 16, "preset": "2_FALSE_COLOR", "layers": "2_FALSE_COLOR", "time": timlapse },
//        //params: { "maxcc": 85, "minZoom": 6, "maxZoom": 16, "preset": "2_FALSE_COLOR", "layers": "2_FALSE_COLOR" ,"time":'2024-09-27/2024-12-10' },
//        serverType: 'geoserver',
//        crossOrigin: 'anonymous',
//        transition: 0

//    })
//});

////var geoServerURL = "http://180.151.15.18:9007/geoserver/sbl/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=sbl:" + lastselectedlayer[Number(lastselectedlayer.length) - 1] + "&outputFormat=application/json";
////console.log(geoServerURL);
////var vectorSource = new ol.source.Vector({
////    url: geoServerURL, // Fetch GeoJSON from GeoServer
////    format: new ol.format.GeoJSON()
////});
////var style_vector = new ol.style.Style({
////    fill: new ol.style.Fill({
////        color: 'black'
////    })
////});

//var style_raster = new ol.style.Style({
//    fill: new ol.style.Fill({
//        color: [0, 0, 0, 1]
//    })
//});
////var cliplayer = new ol.layer.Image({
////    source: new ol.source.ImageVector({
////        source: vectorSource,
////        style: style_vector
////    })
////});


//function createGeoServerLayer(lastselectedlayer, filtertype, filterValues) {
//    // Construct GeoServer URL

//    var geoServerURL = null;

//    // Dynamically build the CQL_FILTER based on the passed filterValues array
//    var filterConditions = [];
//    var cqlFilter = null;

//    if (filtertype != "NA") {
//        // Iterate over the filterValues object and create filter conditions dynamically
//        if (filterValues.state_code) {
//            filterConditions.push(`state_code='${filterValues.state_code}'`);
//        }
//        if (filterValues.district_code) {
//            filterConditions.push(`district_code='${filterValues.district_code}'`);
//        }
//        if (filterValues.tehsil_code) {
//            filterConditions.push(`tehsil_code='${filterValues.tehsil_code}'`);
//        }
//        if (filterValues.village_code) {
//            filterConditions.push(`village_code='${filterValues.village_code}'`);
//        }

//        // Join the conditions using AND, if there are any conditions
//        cqlFilter = filterConditions.length > 0 ? "CQL_FILTER=" + filterConditions.join(" AND ") : "";

//    }
//    // Handle different filtertypes
//    if (filtertype == "NA") {
//        geoServerURL = `http://180.151.15.18:9007/geoserver/sbl/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=sbl:${lastselectedlayer}&outputFormat=application/json`;
//    }
//    else if (filtertype == "query") {
//        geoServerURL = `http://180.151.15.18:9007/geoserver/sbl/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=sbl:${lastselectedlayer}&outputFormat=application/json&${cqlFilter}`;
//    }


//    var vectorSource = new ol.source.Vector({
//        url: geoServerURL, // Fetch GeoJSON from GeoServer
//        format: new ol.format.GeoJSON()
//    });

//    var style_vector = new ol.style.Style({
//        fill: new ol.style.Fill({
//            color: 'black'
//        })
//    });


//    var cliplayer = new ol.layer.Image({
//        source: new ol.source.ImageVector({
//            source: vectorSource,
//            style: style_vector
//        })
//    });
//    return cliplayer;
//}


///*================================Crop Growth Calculation (LAI)==============================*/

///*==========Ortho Image NDVI =======*/
//var CropGrowth_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            //layers: 'nrdc:Apple_NDVI',
//            layers: 'nrdc:Crop_Growth',
//            transition: 0,
//            time: time_range

//        }
//    })
//});

///*===========Sentinel NDVI======*/

////code will remove 
//var asdfue = 0;
//// Initialize parameters globally

////var LAI_raster = new ol.source.Raster({
////    sources: [sentinel_layer.getSource()],
////    style: style_raster,
////    operation: function (pixels, data) {
////        // Use 'this' to refer to 'LAI_raster' and 'this.para'
////        var pixel = pixels[0];
////        var value = sentinel_lai(pixel);

////        console.log("one_: " + this.one_); // Access 'one_' through 'this.para'
////        return pixel;
////    },
////    lib: {
////        sentinel_lai: sentinel_lai,  // Ensure sentinel_lai is accessible
////    }
////});

//// Declare 'param' and make sure it's a string
//var one1 = 0;
//var one2 = 0;
//var one3 = 0;
//var one4 = 0;
//var one5 = 0;
//var one6 = 0;

//// Create the Raster source
//var LAI_raster = new ol.source.Raster({
//    sources: [sentinel_layer.getSource()],
//    style: style_raster,
//    operation: function (pixels, data) {


//        var pixel = pixels[0];
//        var value = sentinel_lai(pixel);

//        if (value <= 0.2599) {
//            one1 = one1 + 1;

//            console.log('one1 sentinel_lai operation:' + one1);

//            pixel[0] = 221;
//            pixel[1] = 221;
//            pixel[2] = 221;
//            pixel[3] = 255;
//        } else if (value >= 0.26 && value <= 0.4999) {
//            one2 = one2 + 1
//            pixel[0] = 254;
//            pixel[1] = 227;
//            pixel[2] = 80;
//            pixel[3] = 255;
//        } else if (value >= 0.50 && value <= 1.5999) {
//            one3 = one3 + 1
//            pixel[0] = 223;
//            pixel[1] = 254;
//            pixel[2] = 177;
//            pixel[3] = 255;
//        } else if (value >= 1.60 && value <= 3.999) {
//            one4 = one4 + 1
//            pixel[0] = 53;
//            pixel[1] = 254;
//            pixel[2] = 104;
//            pixel[3] = 255;
//        } else if (value >= 4.0) {
//            one5 = one5 + 1
//            pixel[0] = 22;
//            pixel[1] = 191;
//            pixel[2] = 30;
//            pixel[3] = 255;
//        } else {
//            one6 = one6 + 1
//            pixel[3] = 0;  // Set pixel transparency to 0
//        }

//        return pixel;

//    },
//    lib: {
//        sentinel_lai: sentinel_lai,
//        one1: one1,  // Pass 'param' as part of the lib object
//        one2: one2,
//        one3: one3,
//        one4: one4,
//        one5: one5,
//        one6: one6

//    }
//});



//// Set additional options if necessary
//LAI_raster.set('threshold', 0.1);

//function sentinel_lai(pixel) {
//    var nir = pixel[0] / 255;
//    var r = pixel[1] / 255;
//    var g = pixel[2] / 255;
//    var b = pixel[3] / 255;
//    var G = 2.5;
//    var C1 = 2.4;
//    var C2 = 7.5;
//    var L = 1.0;

//    var evi = (G * ((nir - r) / (nir + C1 * r + L)));
//    var lai = (3.618 * evi - 0.118); // LAI = (3.618*EVI - 0.118);
//    return lai;
//    //console.log('one2 inside operation:', one2);
//    //console.log('one3 inside operation:', one3);
//    //console.log('one4 inside operation:', one4);
//    //console.log('one5 inside operation:', one5);
//    //console.log('one6 inside operation:', one6);

//    //console.log('one1 sentinel_lai operation:' + countpixel);

//};


////code will remove 



////var LAI_raster = new ol.source.Raster({
////    sources: [sentinel_layer.getSource()],
////    style: style_raster,
////    operation: function (pixels, data) {
////        var pixel = pixels[0];
////        var value = sentinel_lai(pixel);
////        var one_ = 0; var two_ = 0; var three_ = 0; var four_ = 0; var five_ = 0; var six_ = 0;
////        //console.log("pixels ----: " + value);
////        //console.log("pixel ----------- : " + value);
////        //  summarize(value, data.counts);
////        if (value <= 0.2599) {
////            one_ += 1;
////            console.log("one_ : " + one_);
////            pixel[0] = 221;
////            pixel[1] = 221;
////            pixel[2] = 221;
////            pixel[3] = 255;
////        }

////        else if (value >= 0.26 && value <= 0.4999) { //pre
////            two_ += 1;
////            pixel[0] = 254;
////            pixel[1] = 227;
////            pixel[2] = 80;
////            pixel[3] = 255;
////        }

////        else if (value >= 0.50 && value <= 1.5999) { //eme
////            three_ += 1;
////            pixel[0] = 223;
////            pixel[1] = 254;
////            pixel[2] = 177;
////            pixel[3] = 255;
////        }
////        else if (value >= 1.60 && value <= 3.999) { //vege
////            four_ += 1;
////            pixel[0] = 53;
////            pixel[1] = 254;
////            pixel[2] = 104;
////            pixel[3] = 255;
////        }
////        else if (value >= 4.0) { //repro
////            five_ += 1;
////            pixel[0] = 22;
////            pixel[1] = 191;
////            pixel[2] = 30;
////            pixel[3] = 255;
////        }

////        else {
////            six_ += 1;
////            pixel[3] = 0;
////        }
////        return pixel;
////    },
////    lib: {
////        sentinel_lai: sentinel_lai,
////    }

////});
////LAI_raster.set('threshold', 0.1);

////function sentinel_lai(pixel) {

////    var nir = pixel[0] / 255;
////    var r = pixel[1] / 255;
////    var g = pixel[2] / 255;
////    var b = pixel[3] / 255;
////    var G = 2.5;
////    var C1 = 2.4;
////    var C2 = 7.5;
////    var L = 1.0;

////    var evi = (G * ((nir - r) / (nir + C1 * r + L)));
////    var lai = (3.618 * evi - 0.118); // LAI = (3.618*EVI - 0.118);

////    return lai;


////};

//var LAILayer = new ol.layer.Image({
//    title: 'NDVI1',
//    source: LAI_raster
//});


//function myFunctionadas() {

//}

//function CropGrowth(checkbox) {

//    if (checkbox.checked) {
//        if (selectedLayerId == 'sentinal2') {
//            map.addLayer(LAILayer);
//            console.log(one1);
//        }
//        else if (selectedLayerId == 'basemap_ortho')
//            map.addLayer(CropGrowth_layer);
//        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], filtertype, filterValues);
//        cliplayer.on('postcompose', function (e) {
//            e.context.globalCompositeOperation = 'source-over';
//        });
//        cliplayer.on('precompose', function (e) {
//            e.context.globalCompositeOperation = 'destination-in';
//        });

//        jQuery('#div_CropGrowth').css('display', 'block');



//        map.addLayer(cliplayer);
//        layerobject.push(cliplayer);
//        map.addOverlay(cliplayer);
//        lastselectedlayer.push("Crop_Growth");
//        lastselectedlayername.push("Crop Growth");

//        //setTimeout(myFunctionadas, 10000);
//        // console.log('one1 CropGrowth operation:', countpixel);
//    }
//    else {
//        jQuery('#div_CropGrowth').css('display', 'none');
//        if (selectedLayerId == 'sentinal2')
//            map.removeLayer(LAILayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.removeLayer(CropGrowth_layer);
//        map.removeLayer(cliplayer);
//        layerobject.pop(cliplayer);
//        map.removeOverlay(cliplayer);
//        lastselectedlayer.pop("Apple_NDVI");
//        lastselectedlayername.pop("Crop Growth");
//    }
//    //console.log("one_ : " + one_);
//    //console.log("two_ : " + two_);
//    //console.log("three_ : " + three_);
//    //console.log("four_ : " + four_);
//    //console.log("five_ : " + five_);
//    //console.log("six_ : " + six_);
//}

///*================================Crop Health Calculation (NDVI)==============================*/

///*==========Ortho Image NDVI =======*/
//var CropHealth_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            //layers: 'nrdc:Apple_NDVI',
//            layers: 'nrdc:Crop_Health',
//            transition: 0,
//            time: time_range
//            //time: '2024-10-01T00:00:00.000Z'

//        }
//    })
//});

///*===========Sentinel NDVI======*/

//var ndvi_raster = new ol.source.Raster({
//    sources: [sentinel_layer.getSource()],
//    style: style_raster,
//    operation: function (pixels, data) {
//        var pixel = pixels[0];
//        var value = sentinel_ndvi(pixel);
//        //  summarize(value, data.counts);
//        if (value <= 0.2499) {
//            pixel[0] = 192;
//            pixel[1] = 192;
//            pixel[2] = 192;
//            pixel[3] = 255;
//        }

//        else if (value >= 0.25 && value <= 0.3499) {
//            pixel[0] = 255;
//            pixel[1] = 0;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }


//        else if (value >= 0.35 && value <= 0.4999) {


//            pixel[0] = 255;
//            pixel[1] = 159;
//            pixel[2] = 159;
//            pixel[3] = 255;
//        }

//        else if (value >= 0.50 && value <= 0.5999) {
//            pixel[0] = 150;
//            pixel[1] = 237;
//            pixel[2] = 150;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.60 && value <= 0.6999) {
//            pixel[0] = 0;
//            pixel[1] = 223;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.70 && value <= 1.0) {
//            pixel[0] = 0;
//            pixel[1] = 106;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }
//        else {
//            pixel[3] = 0;
//        }
//        return pixel;
//    },
//    lib: {
//        sentinel_ndvi: sentinel_ndvi,
//    }

//});
//ndvi_raster.set('threshold', 0.1);

//function sentinel_ndvi(pixel) {
//    var nir = pixel[0] / 255;
//    var r = pixel[1] / 255;
//    var g = pixel[2] / 255;
//    //  var b = pixel[3] / 255;
//    return (nir - r) / (nir + r);
//};

//var NDVILayer = new ol.layer.Image({
//    title: 'NDVI1',
//    source: ndvi_raster
//});

//function CropHealth(checkbox) {

//    if (checkbox.checked) {
//        console.log("Selected Date:", time_range);
//        if (selectedLayerId == 'sentinal2')
//            map.addLayer(NDVILayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.addLayer(CropHealth_layer);
//        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], filtertype, filterValues);
//        cliplayer.on('postcompose', function (e) {
//            e.context.globalCompositeOperation = 'source-over';
//        });
//        cliplayer.on('precompose', function (e) {
//            e.context.globalCompositeOperation = 'destination-in';
//        });

//        jQuery('#div_CropHealth').css('display', 'block');

//        console.log(cliplayer);
//        map.addLayer(cliplayer);
//        layerobject.push(cliplayer);
//        map.addOverlay(cliplayer);
//        lastselectedlayer.push("Crop_Health");
//        lastselectedlayername.push("Crop Health");
//    }
//    else {
//        jQuery('#div_CropHealth').css('display', 'none');
//        if (selectedLayerId == 'sentinal2')
//            map.removeLayer(NDVILayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.removeLayer(CropHealth_layer);
//        map.removeLayer(cliplayer);
//        layerobject.pop(cliplayer);
//        map.removeOverlay(cliplayer);
//        lastselectedlayer.pop("Apple_NDVI");
//        lastselectedlayername.pop("Crop Health");
//    }

//}


///*================================Crop Harvesting Calculation ==============================*/

///*==========Ortho Image Harvesting =======*/
//var CropHarvesting_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            //layers: 'nrdc:Apple_NDVI',
//            layers: 'nrdc:Crop_Harvesting',
//            transition: 0,
//            time: time_range
//        }
//    })
//});

///*===========Sentinel Harvesting======*/

//var CropHarvesting_raster = new ol.source.Raster({
//    sources: [sentinel_layer.getSource()],
//    style: style_raster,
//    operation: function (pixels, data) {
//        var pixel = pixels[0];
//        var value = sentinel_CropHarvesting(pixel);
//        //  summarize(value, data.counts);
//        if (value <= -0.10) { // water
//            pixel[0] = 0;
//            pixel[1] = 128;
//            pixel[2] = 255;
//            pixel[3] = 255;
//        }

//        //if (value <= 0.1749) {
//        //    pixel[0] = 192;
//        //    pixel[1] = 192;
//        //    pixel[2] = 192;
//        //    pixel[3] = 255;
//        //}


//        else if (value >= -0.010 && value <= 0.039) { // cloud
//            pixel[0] = 150;
//            pixel[1] = 23;
//            pixel[2] = 153;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.040 && value <= 0.06499) { // shadow
//            pixel[0] = 11;
//            pixel[1] = 244;
//            pixel[2] = 239;
//            pixel[3] = 255;
//        }

//        else if (value >= 0.065 && value <= 0.179) { //fallow land
//            pixel[0] = 192;
//            pixel[1] = 192;
//            pixel[2] = 192;
//            pixel[3] = 255;
//        }

//        else if (value >= 0.18 && value <= 0.3499) { // priority 1
//            pixel[0] = 255;
//            pixel[1] = 0;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }


//        //else if (value >= 0.1750 && value <= 0.3499) { // priority 1
//        //    pixel[0] = 255;
//        //    pixel[1] = 0;
//        //    pixel[2] = 0;
//        //    pixel[3] = 255;
//        //}


//        else if (value >= 0.35 && value <= 0.4999) {


//            pixel[0] = 255;
//            pixel[1] = 159;
//            pixel[2] = 159;
//            pixel[3] = 255;
//        }

//        else if (value >= 0.50 && value <= 0.5999) {
//            pixel[0] = 150;
//            pixel[1] = 237;
//            pixel[2] = 150;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.60 && value <= 0.6999) {
//            pixel[0] = 0;
//            pixel[1] = 223;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.70 && value <= 1.0) {
//            pixel[0] = 0;
//            pixel[1] = 106;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }
//        else {
//            pixel[3] = 0;
//        }
//        return pixel;
//    },
//    lib: {
//        sentinel_CropHarvesting: sentinel_CropHarvesting,
//    }

//});
//CropHarvesting_raster.set('threshold', 0.1);

//function sentinel_CropHarvesting(pixel) {
//    var nir = pixel[0] / 255;
//    var r = pixel[1] / 255;
//    var g = pixel[2] / 255;
//    //  var b = pixel[3] / 255;
//    return (nir - r) / (nir + r);
//};

//var CropHarvestingLayer = new ol.layer.Image({
//    title: 'NDVI1',
//    source: CropHarvesting_raster
//});

//function CropHarvesting(checkbox) {

//    if (checkbox.checked) {

//        if (selectedLayerId == 'sentinal2')
//            map.addLayer(CropHarvestingLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.addLayer(CropHarvesting_layer);
//        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], filtertype, filterValues);
//        cliplayer.on('postcompose', function (e) {
//            e.context.globalCompositeOperation = 'source-over';
//        });
//        cliplayer.on('precompose', function (e) {
//            e.context.globalCompositeOperation = 'destination-in';
//        });

//        jQuery('#div_CropHarvesting').css('display', 'block');
//        map.addLayer(cliplayer);
//        layerobject.push(cliplayer);
//        map.addOverlay(cliplayer);
//        lastselectedlayer.push("Crop_Harvesting");
//        lastselectedlayername.push("Crop Harvesting");
//    }
//    else {
//        jQuery('#div_CropHarvesting').css('display', 'none');
//        if (selectedLayerId == 'sentinal2')
//            map.removeLayer(CropHarvestingLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.removeLayer(CropHarvesting_layer);
//        map.removeLayer(cliplayer);
//        layerobject.pop(cliplayer);
//        map.removeOverlay(cliplayer);
//        //lastselectedlayer.pop("");
//        lastselectedlayername.pop("Crop Harvesting");
//    }

//}


///*================================Crop VegetationMoisture Calculation ==============================*/

///*==========Ortho Image VegetationMoisture =======*/
//var VegetationMoisture_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            //layers: 'nrdc:Apple_NDVI',
//            layers: 'nrdc:Vegetation_Moisture',
//            transition: 0,
//            time: time_range
//        }
//    })
//});

///*===========Sentinel VegetationMoisture======*/

//var VegetationMoisture_raster = new ol.source.Raster({
//    sources: [sentinel_layer.getSource()],
//    style: style_raster,
//    operation: function (pixels, data) {
//        var pixel = pixels[0];
//        var value = sentinel_VegetationMoisture(pixel);
//        //  summarize(value, data.counts);

//        if (value < -0.5499) { //e mois

//            pixel[0] = 31;
//            pixel[1] = 152;
//            pixel[2] = 101;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.55 && value < -0.4499) { //v good m
//            pixel[0] = 92;
//            pixel[1] = 222;
//            pixel[2] = 167;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.45 && value < -0.2999) {// normal m
//            pixel[0] = 239;
//            pixel[1] = 232;
//            pixel[2] = 86;
//            pixel[3] = 255;
//        }



//        else if (value >= -0.30 && value < -0.1499) { // dry land



//            pixel[0] = 241;
//            pixel[1] = 39;
//            pixel[2] = 166;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.15 && value < -0.05) {// builtup




//            pixel[0] = 252;
//            pixel[1] = 205;
//            pixel[2] = 226;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.05 && value <= 0.099) { // l b
//            pixel[0] = 175;
//            pixel[1] = 240;
//            pixel[2] = 245;
//            pixel[3] = 255;
//        }


//        else if (value >= 0.10 && value <= 0.1499) { //bl
//            pixel[0] = 109;
//            pixel[1] = 188;
//            pixel[2] = 252;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.15 && value <= 1.0) { //d bl
//            pixel[0] = 0;
//            pixel[1] = 0;
//            pixel[2] = 155;
//            pixel[3] = 255;
//        }
//        else {
//            pixel[3] = 0;
//        }
//        return pixel;
//    },
//    lib: {
//        sentinel_VegetationMoisture: sentinel_VegetationMoisture,
//    }

//});
//VegetationMoisture_raster.set('threshold', 0.1);

//function sentinel_VegetationMoisture(pixel) {
//    var nir = pixel[0] / 255;
//    var r = pixel[1] / 255;
//    var g = pixel[2] / 255;
//    var b = pixel[3] / 255;
//    //return (nir - r) / (nir + r);
//    return (g - nir) / (g + nir);

//};

//var VegetationMoistureLayer = new ol.layer.Image({
//    title: 'NDVI1',
//    source: VegetationMoisture_raster
//});

//function VegetationMoisture(checkbox) {

//    if (checkbox.checked) {

//        if (selectedLayerId == 'sentinal2')
//            map.addLayer(VegetationMoistureLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.addLayer(VegetationMoisture_layer);
//        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], filtertype, filterValues);
//        cliplayer.on('postcompose', function (e) {
//            e.context.globalCompositeOperation = 'source-over';
//        });
//        cliplayer.on('precompose', function (e) {
//            e.context.globalCompositeOperation = 'destination-in';
//        });

//        jQuery('#div_VegetationMoisture').css('display', 'block');
//        map.addLayer(cliplayer);
//        layerobject.push(cliplayer);
//        map.addOverlay(cliplayer);
//        lastselectedlayer.push("Vegetation_Moisture");
//        lastselectedlayername.push("Vegetation Moisture");
//    }
//    else {
//        jQuery('#div_VegetationMoisture').css('display', 'none');
//        if (selectedLayerId == 'sentinal2')
//            map.removeLayer(VegetationMoistureLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.removeLayer(VegetationMoisture_layer);
//        map.removeLayer(cliplayer);
//        layerobject.pop(cliplayer);
//        map.removeOverlay(cliplayer);
//        //lastselectedlayer.pop("");
//        lastselectedlayername.pop("Vegetation Moistureg");
//    }

//}



///*================================Crop NitrogenContent Calculation ==============================*/

///*==========Ortho Image NitrogenContent =======*/
//var NitrogenContent_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            //layers: 'nrdc:Apple_NDVI',
//            layers: 'nrdc:Nitrogen_Content',
//            transition: 0,
//            time: time_range
//        }
//    })
//});

///*===========Sentinel NitrogenContent======*/

//var NitrogenContent_raster = new ol.source.Raster({
//    sources: [sentinel_layer.getSource()],
//    style: style_raster,
//    operation: function (pixels, data) {
//        var pixel = pixels[0];
//        var value = sentinel_NitrogenContent(pixel);
//        //  summarize(value, data.counts);
//        if (value <= 0) {
//            pixel[0] = 192;
//            pixel[1] = 192;
//            pixel[2] = 192;
//            pixel[3] = 255;
//        }

//        else if (value >= 0 && value <= 0.099) {
//            pixel[0] = 255;
//            pixel[1] = 0;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }


//        else if (value >= 0.10 && value <= 0.1999) {

//            pixel[0] = 255;
//            pixel[1] = 159;
//            pixel[2] = 159;
//            pixel[3] = 255;
//        }

//        else if (value >= 0.20 && value <= 0.2799) { //normal
//            pixel[0] = 255;
//            pixel[1] = 255;
//            pixel[2] = 127;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.28 && value <= 0.4199) { //above  normal
//            pixel[0] = 0;
//            pixel[1] = 223;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.42 && value <= 1.0) {
//            pixel[0] = 0;
//            pixel[1] = 106;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }
//        else {
//            pixel[3] = 0;
//        }
//        return pixel;
//    },
//    lib: {
//        sentinel_NitrogenContent: sentinel_NitrogenContent,
//    }

//});
//NitrogenContent_raster.set('threshold', 0.1);

//function sentinel_NitrogenContent(pixel) {
//    var nir = pixel[0] / 255;
//    var r = pixel[1] / 255;
//    var g = pixel[2] / 255;
//    var b = pixel[3] / 255;
//    return (nir - g) / (nir + g);


//};

//var NitrogenContentLayer = new ol.layer.Image({
//    title: 'NDVI1',
//    source: NitrogenContent_raster
//});

//function NitrogenContent(checkbox) {

//    if (checkbox.checked) {

//        if (selectedLayerId == 'sentinal2')
//            map.addLayer(NitrogenContentLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.addLayer(NitrogenContent_layer);
//        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], filtertype, filterValues);
//        cliplayer.on('postcompose', function (e) {
//            e.context.globalCompositeOperation = 'source-over';
//        });
//        cliplayer.on('precompose', function (e) {
//            e.context.globalCompositeOperation = 'destination-in';
//        });

//        jQuery('#div_NitrogenContent').css('display', 'block');
//        map.addLayer(cliplayer);
//        layerobject.push(cliplayer);
//        map.addOverlay(cliplayer);
//        lastselectedlayer.push("Nitrogen_Content");
//        lastselectedlayername.push("Nitrogen Content");
//    }
//    else {
//        jQuery('#div_NitrogenContent').css('display', 'none');
//        if (selectedLayerId == 'sentinal2')
//            map.removeLayer(NitrogenContentLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.removeLayer(NitrogenContent_layer);
//        map.removeLayer(cliplayer);
//        layerobject.pop(cliplayer);
//        map.removeOverlay(cliplayer);
//        //lastselectedlayer.pop("");
//        lastselectedlayername.pop("Nitrogen Content");
//    }

//}


///*================================Crop SoilMoisture Calculation ==============================*/

///*==========Ortho Image SoilMoisture =======*/
//var SoilMoisture_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            //layers: 'nrdc:Apple_NDVI',
//            layers: 'nrdc:Soil_Moisture',
//            transition: 0,
//            time: time_range
//        }
//    })
//});

///*===========Sentinel SoilMoisture======*/

//var SoilMoisture_raster = new ol.source.Raster({
//    sources: [sentinel_layer.getSource()],
//    style: style_raster,
//    operation: function (pixels, data) {
//        var pixel = pixels[0];
//        var value = sentinel_SoilMoisture(pixel);
//        //  summarize(value, data.counts);
//        if (value < -0.5499) { //e mois

//            pixel[0] = 31;
//            pixel[1] = 152;
//            pixel[2] = 101;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.55 && value < -0.4499) { //v good m
//            pixel[0] = 92;
//            pixel[1] = 222;
//            pixel[2] = 167;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.45 && value < -0.2999) {// normal m
//            pixel[0] = 239;
//            pixel[1] = 232;
//            pixel[2] = 86;
//            pixel[3] = 255;
//        }



//        else if (value >= -0.30 && value < -0.1499) { // dry land



//            pixel[0] = 241;
//            pixel[1] = 39;
//            pixel[2] = 166;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.15 && value < -0.05) {// builtup




//            pixel[0] = 252;
//            pixel[1] = 205;
//            pixel[2] = 226;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.05 && value <= 0.099) { // l b
//            pixel[0] = 175;
//            pixel[1] = 240;
//            pixel[2] = 245;
//            pixel[3] = 255;
//        }


//        else if (value >= 0.10 && value <= 0.1499) { //bl
//            pixel[0] = 109;
//            pixel[1] = 188;
//            pixel[2] = 252;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.15 && value <= 1.0) { //d bl
//            pixel[0] = 0;
//            pixel[1] = 0;
//            pixel[2] = 155;
//            pixel[3] = 255;
//        }
//        else {
//            pixel[3] = 0;
//        }
//        return pixel;
//    },
//    lib: {
//        sentinel_SoilMoisture: sentinel_SoilMoisture,
//    }

//});
//SoilMoisture_raster.set('threshold', 0.1);

//function sentinel_SoilMoisture(pixel) {
//    var nir = pixel[0] / 255;
//    var r = pixel[1] / 255;
//    var g = pixel[2] / 255;
//    var b = pixel[3] / 255;
//    //return (nir - r) / (nir + r);
//    return (g - nir) / (g + nir);


//};

//var SoilMoistureLayer = new ol.layer.Image({
//    title: 'NDVI1',
//    source: SoilMoisture_raster
//});

//function SoilMoisture(checkbox) {

//    if (checkbox.checked) {

//        if (selectedLayerId == 'sentinal2')
//            map.addLayer(SoilMoistureLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.addLayer(SoilMoisture_layer);
//        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], filtertype, filterValues);
//        cliplayer.on('postcompose', function (e) {
//            e.context.globalCompositeOperation = 'source-over';
//        });
//        cliplayer.on('precompose', function (e) {
//            e.context.globalCompositeOperation = 'destination-in';
//        });

//        jQuery('#div_SoilMoisture').css('display', 'block');
//        map.addLayer(cliplayer);
//        layerobject.push(cliplayer);
//        map.addOverlay(cliplayer);
//        lastselectedlayer.push("Soil_Moisture");
//        lastselectedlayername.push("Soil Moisture");
//    }
//    else {
//        jQuery('#div_SoilMoisture').css('display', 'none');
//        if (selectedLayerId == 'sentinal2')
//            map.removeLayer(SoilMoistureLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.removeLayer(SoilMoisture_layer);
//        map.removeLayer(cliplayer);
//        layerobject.pop(cliplayer);
//        map.removeOverlay(cliplayer);
//        //lastselectedlayer.pop("");
//        lastselectedlayername.pop("Soil Moisture");
//    }

//}



///*================================Crop EnhancedVegetation Calculation ==============================*/

///*==========Ortho Image EnhancedVegetation =======*/
//var EnhancedVegetation_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            /*layers: 'nrdc:Apple_NDVI',*/
//            transition: 0
//        }
//    })
//});

///*===========Sentinel SoilMoisture======*/

//var EnhancedVegetation_raster = new ol.source.Raster({
//    sources: [sentinel_layer.getSource()],
//    style: style_raster,
//    operation: function (pixels, data) {
//        var pixel = pixels[0];
//        var value = sentinel_EnhancedVegetation(pixel);
//        //  summarize(value, data.counts);
//        if (value <= 0.099) {
//            pixel[0] = 192;
//            pixel[1] = 192;
//            pixel[2] = 192;
//            pixel[3] = 255;
//        }

//        else if (value >= 0.1 && value <= 0.1499) {
//            pixel[0] = 255;
//            pixel[1] = 0;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }


//        else if (value >= 0.15 && value <= 0.2999) {


//            pixel[0] = 255;
//            pixel[1] = 159;
//            pixel[2] = 159;
//            pixel[3] = 255;
//        }

//        else if (value >= 0.30 && value <= 0.4999) {
//            pixel[0] = 150;
//            pixel[1] = 237;
//            pixel[2] = 150;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.50 && value <= 0.5999) {
//            pixel[0] = 0;
//            pixel[1] = 223;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }
//        else if (value >= 0.60 && value <= 1.0) {
//            pixel[0] = 0;
//            pixel[1] = 106;
//            pixel[2] = 0;
//            pixel[3] = 255;
//        }
//        else {
//            pixel[3] = 0;
//        }
//        return pixel;

//    },
//    lib: {
//        sentinel_EnhancedVegetation: sentinel_EnhancedVegetation,
//    }

//});
//EnhancedVegetation_raster.set('threshold', 0.1);

//function sentinel_EnhancedVegetation(pixel) {
//    var nir = pixel[0] / 255;
//    var r = pixel[1] / 255;
//    var g = pixel[2] / 255;
//    var b = pixel[3] / 255;

//    var G = 2.5;
//    var C1 = 6.0;
//    var C2 = 7.5;
//    var L = 1.0;
//    var value = (G * ((nir - r) / (nir + C1 * r + L)));

//    //  var value = 2.5 * (nir - r) / ((nir + 6.0 * r - 7.5 * b) + 1.0);

//    return value;



//};

//var EnhancedVegetationLayer = new ol.layer.Image({
//    title: 'NDVI1',
//    source: EnhancedVegetation_raster
//});

//function EnhancedVegetation(checkbox) {

//    if (checkbox.checked) {

//        if (selectedLayerId == 'sentinal2')
//            map.addLayer(EnhancedVegetationLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.addLayer(EnhancedVegetation_layer);
//        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], filtertype, filterValues);
//        cliplayer.on('postcompose', function (e) {
//            e.context.globalCompositeOperation = 'source-over';
//        });
//        cliplayer.on('precompose', function (e) {
//            e.context.globalCompositeOperation = 'destination-in';
//        });

//        jQuery('#div_EnhancedVegetation').css('display', 'block');
//        map.addLayer(cliplayer);
//        layerobject.push(cliplayer);
//        map.addOverlay(cliplayer);
//        //lastselectedlayer.push("");
//        lastselectedlayername.push("Enhanced Vegetation");
//    }
//    else {
//        jQuery('#div_EnhancedVegetation').css('display', 'none');
//        if (selectedLayerId == 'sentinal2')
//            map.removeLayer(EnhancedVegetationLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.removeLayer(EnhancedVegetation_layer);
//        map.removeLayer(cliplayer);
//        layerobject.pop(cliplayer);
//        map.removeOverlay(cliplayer);
//        //lastselectedlayer.pop("");
//        lastselectedlayername.pop("Enhanced Vegetation");
//    }

//}

///*================================Crop Weed Calculation ==============================*/

///*==========Ortho Image Weed =======*/
//var Weed_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            /*layers: 'nrdc:Apple_NDVI',*/
//            transition: 0
//        }
//    })
//});

///*===========Sentinel SoilMoisture======*/

//var Weed_raster = new ol.source.Raster({
//    sources: [sentinel_layer.getSource()],
//    style: style_raster,
//    operation: function (pixels, data) {
//        var pixel = pixels[0];
//        var value = sentinel_Weed(pixel);
//        //  summarize(value, data.counts);
//        if (value < -2.00) { //cloud

//            pixel[0] = 249;
//            pixel[1] = 81;
//            pixel[2] = 244;
//            pixel[3] = 255;
//        }

//        //else if (value >= -0.55 && value < -0.4499) { //disease
//        //    pixel[0] = 241;
//        //    pixel[1] = 39;
//        //    pixel[2] = 166;
//        //    pixel[3] = 255;
//        //}

//        else if (value >= -1.995 && value < -0.25) {// no weed green
//            pixel[0] = 70;
//            pixel[1] = 255;
//            pixel[2] = 70;
//            pixel[3] = 255;
//        }

//        else if (value >= -0.2511 && value < 0.15) {// weed

//            pixel[0] = 239;
//            pixel[1] = 13;
//            pixel[2] = 1;
//            pixel[3] = 255;


//        }


//        else {
//            pixel[3] = 0;
//        }
//        return pixel;
//    },
//    lib: {
//        sentinel_Weed: sentinel_Weed,
//    }

//});
//Weed_raster.set('threshold', 0.1);

//function sentinel_Weed(pixel) {
//    var nir = pixel[0] / 255;
//    var r = pixel[1] / 255;
//    var g = pixel[2] / 255;
//    var b = pixel[3] / 255;


//    var sivi = (nir - b) / (nir - r);
//    return sivi;




//};

//var WeedLayer = new ol.layer.Image({
//    title: 'NDVI1',
//    source: Weed_raster
//});

//function Weed(checkbox) {

//    if (checkbox.checked) {

//        if (selectedLayerId == 'sentinal2')
//            map.addLayer(WeedLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.addLayer(Weed_layer);
//        var cliplayer = createGeoServerLayer(lastselectedlayer_vector[lastselectedlayer_vector.length - 1], filtertype, filterValues);
//        cliplayer.on('postcompose', function (e) {
//            e.context.globalCompositeOperation = 'source-over';
//        });
//        cliplayer.on('precompose', function (e) {
//            e.context.globalCompositeOperation = 'destination-in';
//        });

//        jQuery('#div_Weed').css('display', 'block');
//        map.addLayer(cliplayer);
//        layerobject.push(cliplayer);
//        map.addOverlay(cliplayer);
//        lastselectedlayer.push("Apple_NDVI");
//        lastselectedlayername.push("Weed");
//    }
//    else {
//        jQuery('#div_Weed').css('display', 'none');
//        if (selectedLayerId == 'sentinal2')
//            map.removeLayer(WeedLayer);
//        else if (selectedLayerId == 'basemap_ortho')
//            map.removeLayer(Weed_layer);
//        map.removeLayer(cliplayer);
//        layerobject.pop(cliplayer);
//        map.removeOverlay(cliplayer);
//        lastselectedlayer.pop("Apple_NDVI");
//        lastselectedlayername.pop("Weed");
//    }

//}


/*------------------------*/


/*-------Map Icon Start-----------------*/

//function popweatherforecaste() {

//    var itm = document.getElementById("divweatherforecaste");
//    itm.classList.toggle("popdisplay");
//    getLegendDetails();

//}
//function hideweatherforecaste() {
//    document.getElementById("divweatherforecaste").classList.remove("popdisplay");
//    document.getElementById("divweatherforecaste").removeAttribute("style");
//}
//function getLegendDetails() {


//    var t = this;
//    var outer_html = '';
//    var coordinates = null;
//    var content;
//    coordinates = ol.proj.transform(map.getView().getCenter(), 'EPSG:3857', 'EPSG:4326');
//    var lng = coordinates[0];
//    var lat = coordinates[1];
//    var url = "https://api.openweathermap.org/data/2.5/forecast?lat=" +
//        lat +
//        "&lon=" +
//        lng +
//        "&units=metric&appid=664b8f290440bf70621e5e66cb4ceb45";

//    // var url = "https://api.openweathermap.org/data/2.5/forecast?lat=43.654&lon=-79.3873&appid=f8b91bb131ede97fc2a11e09d7f2af1f";

//    fetch(url)
//        .then(response => response.json())
//        .then(data => {
//            let forecast = null;
//            //var forecastsArr = myJson.list;

//            var forecastElement = '';
//            content = "<div className='container' id = 'moveable' style='font-size: 15px;margin: 0 0 10px 10px;background: #fff;width:100%; border-radius: 5px;'><table className='table' style='width: 100%;'>" +
//                '<thead style="padding: 10px 10px 10px 10px;cursor: move;font-weight: normal;font-size: 14px;border-bottom: 2px solid #e4e4e4;color: #707070;background: linear-gradient(to right, #f9f3b1 0%, #ffffff 90%, #ffffff 100%);border-radius: 5px 5px 0 0; "><tr><th colspan="6" style="color: #2196F3;font-size: 15px;height: 35px;padding: 0px 2px 4px 15px;"> Location: ' + data.city.name + '</th> </tr> <tr><th>Date</th>' +

//                '   <th>Status</th>' +
//                '    <th>Forecast</th>' +
//                ' <th>Temp</th>' +
//                ' <th>Humidity</th>' +
//                ' <th>Wind</th>' +
//                ' <th>Pressure</th>' +

//                '  </tr>' +
//                '   </thead>' +
//                ' <tbody>';

//            for (var index = 0; index < data.list.length; index += 8) {

//                //  for (let index = 0; index < 6; index++) {
//                forecast = data.list[index];
//                var imageurl = "https://openweathermap.org/img/w/" + forecast.weather[0].icon + ".png";
//                forecastElement += '<tr key =' + forecast.dt + ' ><td >' + forecast.dt_txt.substring(0, 10) + '</td>'

//                    + '<td> <img src="' + imageurl + '" /></td>'
//                    + '<td>' + forecast.weather[0].description + '</td>'
//                    + '<td>' + parseInt(forecast.main.temp) + '<span>&#8451;</span></td>'
//                    + '<td>' + forecast.main.humidity + ' % </td>'
//                    + '<td>' + forecast.wind.speed.toFixed(0) + ' mtr/sec </td>'
//                    + '<td>' + forecast.main.pressure + ' hPa </td>'

//            }

//            outer_html += content + forecastElement;

//            outer_html += "</tbody></table></div>";
//            document.getElementById('divweatherforecaste_data').innerHTML = outer_html;
//        }
//        )
//        .catch(error => console.error('Error:', error));
//}

//var pressure = new ol.layer.Tile({
//    source: new ol.source.XYZ({
//        url: "http://tile.openweathermap.org/map/pressure_new/{z}/{x}/{y}.png?appid=664b8f290440bf70621e5e66cb4ceb45",
//        crossOrigin: 'anonymous'

//    })

//});


//var pressure_val = 0;
//function pressure_value() {
//    if (pressure_val == 0) {
//        pressure_val = 1;
//        map.addLayer(pressure);
//        jQuery('#div_map_pressure').css('display', 'block');
//    }
//    else {
//        map.removeLayer(pressure);
//        jQuery('#div_map_pressure').css('display', 'none');
//        pressure_val = 0;
//    }
//}

//var wind = new ol.layer.Tile({
//    source: new ol.source.XYZ({
//        url: "http://tile.openweathermap.org/map/wind_new/{z}/{x}/{y}.png?appid=664b8f290440bf70621e5e66cb4ceb45",
//        crossOrigin: 'anonymous'

//    })

//});


//var wind_val = 0;
//function wind_speed() {
//    if (wind_val == 0) {
//        wind_val = 1;
//        map.addLayer(wind);
//        jQuery('#div_map_wind_speed').css('display', 'block');
//    }
//    else {
//        map.removeLayer(wind);
//        jQuery('#div_map_wind_speed').css('display', 'none');
//        wind_val = 0;
//    }
//}

//var precipitation = new ol.layer.Tile({
//    source: new ol.source.XYZ({
//        url: "http://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=664b8f290440bf70621e5e66cb4ceb45",
//        crossOrigin: 'anonymous'

//    })

//});


//var precipitation_val = 0;
//function precipitation_value() {
//    if (precipitation_val == 0) {
//        precipitation_val = 1;
//        map.addLayer(precipitation);
//        jQuery('#div_map_precipitation').css('display', 'block');
//    }
//    else {
//        map.removeLayer(precipitation);
//        jQuery('#div_map_precipitation').css('display', 'none');
//        precipitation_val = 0;
//    }
//}


//var temp_v = new ol.layer.Tile({
//    source: new ol.source.XYZ({
//        //url: "http://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png?appid=664b8f290440bf70621e5e66cb4ceb455",
//        url: "http://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png?appid=d22d9a6a3ff2aa523d5917bbccc89211",
//        crossOrigin: 'anonymous'

//    })

//});


//var temp_val = 0;
//function temp_value() {
//    if (temp_val == 0) {
//        temp_val = 1;
//        map.addLayer(temp_v);
//        jQuery('#div_map_temperature').css('display', 'block');
//    }
//    else {
//        map.removeLayer(temp_v);
//        jQuery('#div_map_temperature').css('display', 'none');
//        temp_val = 0;
//    }
//}
/*-------Map Icon End-----------------*/



//function myfunSwipe() {
//    document.getElementById("divSwipe").style.display = "block";
//    var swipeFrom = document.getElementById("ddlmonthfrom");
//    var swipeTo = document.getElementById("ddlmonthto");
//    // alert(swipeFrom.value + " -- " + swipeTo.value);
//    document.getElementById("swipedatefrom").innerHTML = swipeFrom.value;
//    document.getElementById("swipedateto").innerHTML = swipeTo.value;

//    var rangeValue = document.getElementById('txtDateRange1').value;
//    var selectedDate11 = dates[rangeValue];

//    document.getElementById("rangeSelecetedDate").innerHTML = selectedDate11;
//    // document.getElementById('<%= hfSelectedDate.ClientID %>').value = selectedDate;



//    addswipelayer(swipeFrom.value, swipeTo.value);



//    //layerobject

//}
//function addswipelayer(datefrom, dateto) {
//    var dtfrm = datefrom.split(" ");
//    var dtto = dateto.split(" ");
//    dtfrm = dtfrm[0];
//    dtto = dtto[0];

//    var dtfrmday = dtfrm.split("-")[0];
//    var dtfrmmonth = dtfrm.split("-")[1];
//    var dtfrmyear = dtfrm.split("-")[2];
//    var dttoday = dtto.split("-")[0];
//    var dttomonth = dtto.split("-")[1];
//    var dttoyear = dtto.split("-")[2];
//    dtfrm = dtfrmyear + "-" + dtfrmmonth + "-" + dtfrmday;
//    dtto = dttoyear + "-" + dttomonth + "-" + dttoday;
//    dtfrm = dtfrm + 'T00:00:00.000Z';
//    dtto = dtto + 'T00:00:00.000Z';

//    var canvas1 = document.getElementById('canvas1');
//    var canvas2 = document.getElementById('canvas2');
//    var swipeRange = document.getElementById('swiperange');
//    var ctx1 = canvas1.getContext('2d');
//    var ctx2 = canvas2.getContext('2d');

//    // Load your raster images
//    var img1 = new Image();
//    var img2 = new Image();

//    //img1.src = "http://180.151.15.18:9007/geoserver/nrdc/wms?service=WMS&version=1.1.0&request=GetMap&layers=nrdc%3Arow_image&time=" + datefrom +"&bbox=557386.8163888006%2C2931084.918491676%2C567596.8163888006%2C2941404.918491676&width=759&height=768&srs=EPSG%3A32644&styles=&format=image%2Fvnd.jpeg-png";  // Image 1 URL
//    //img2.src = 'http://180.151.15.18:9007/geoserver/nrdc/wms?service=WMS&version=1.1.0&request=GetMap&layers=nrdc%3Arow_image&time=2024-03-01T00:00:00.000Z&bbox=557386.8163888006%2C2931084.918491676%2C567596.8163888006%2C2941404.918491676&width=759&height=768&srs=EPSG%3A32644&styles=&format=image%2Fvnd.jpeg-png';  // Image 2 URL


//    img1.src = "http://180.151.15.18:9007/geoserver/nrdc/wms?service=WMS&version=1.1.0&request=GetMap&layers=nrdc%3Arow_image&time=" + dtfrm + "&bbox=557386.8163888006%2C2931084.918491676%2C567596.8163888006%2C2941404.918491676&width=1500&height=768&srs=EPSG%3A32644&styles=&format=image%2Fpng";  // Image 1 URL
//    img2.src = "http://180.151.15.18:9007/geoserver/nrdc/wms?service=WMS&version=1.1.0&request=GetMap&layers=nrdc%3Arow_image&time=" + dtto + "&bbox=557386.8163888006%2C2931084.918491676%2C567596.8163888006%2C2941404.918491676&width=1500&height=768&srs=EPSG%3A32644&styles=&format=image%2Fpng";  // Image 2 URL


//    img1.onload = function () {
//        // Resize canvas to match image1 dimensions (if needed)
//        canvas1.width = img1.width;
//        canvas1.height = img1.height;
//        ctx1.drawImage(img1, 0, 0, canvas1.width, canvas1.height);
//    };

//    img2.onload = function () {
//        // Resize canvas to match image2 dimensions (if needed)
//        canvas2.width = img2.width;
//        canvas2.height = img2.height;
//        ctx2.drawImage(img2, 0, 0, canvas2.width, canvas2.height);
//        // Initially apply the swipe effect
//        updateSwipeEffect(swipeRange.value);
//    };

//    // Event listener for the range input (slider)
//    swipeRange.addEventListener('input', function () {
//        updateSwipeEffect(swipeRange.value);
//    });

//    // Function to update the swipe effect
//    function updateSwipeEffect(value) {
//        var width = canvas1.width * (value / 100);

//        // Clear the canvas2 context
//        ctx2.clearRect(0, 0, canvas2.width, canvas2.height);

//        // Clip canvas2 context based on the range value
//        ctx2.save();
//        ctx2.beginPath();
//        ctx2.rect(width, 0, canvas2.width - width, canvas2.height);
//        ctx2.clip();

//        // Draw image2 on canvas2 with the clipping applied
//        ctx2.drawImage(img2, 0, 0, canvas2.width, canvas2.height);
//        ctx2.restore();
//    }

//    // Enable high-quality rendering
//    ctx1.imageSmoothingEnabled = true;
//    ctx2.imageSmoothingEnabled = true;
//};

//function myfunClear() {
//    document.getElementById("divSwipe").style.display = "none";
//    document.getElementById("swipedatefrom").innerHTML = "";
//    document.getElementById("swipedateto").innerHTML = "";
//}

//var dateData = document.getElementById("hfAllDates").value;

//var dateDat1a = document.getElementById("txtDateRange1");

//var dates = dateData.split(',');

//dateDat1a.max = dates.length - 1;

//function updateDateValue() {

//    var rangeValue = document.getElementById('txtDateRange1').value;
//    var selectedDate11 = dates[rangeValue];
//    var selectedDate11t = dates[rangeValue];


//    var selectedDatet = selectedDate11t.split(" ");
//    selectedDatet = selectedDatet[0];
//    var datearray = selectedDatet.split("-");
//    var dayt = datearray[0];
//    var montht = datearray[1];
//    var yeart = datearray[2];

//    selectedDate11t = dayt + "-" + montht + "-" + yeart;

//    document.getElementById("rangeSelecetedDate").innerHTML = selectedDate11t;
//    // document.getElementById('<%= hfSelectedDate.ClientID %>').value = selectedDate;

//    var selectedDate = selectedDate11.split(" ");
//    selectedDate = selectedDate[0];
//    count = 0;
//    // Get the date input value
//    // selectedDate = document.getElementById("time").value;
//    //var year = selectedDate.split("-")[0]; // First part is the year (YYYY)
//    //var month = selectedDate.split("-")[1]; // Second part is the month (MM)
//    //var day = selectedDate.split("-")[2]; // Second part is the day (DD)
//    //time_range = year + '-' + month + '-01T00:00:00.000Z';


//    var day = selectedDate.split("-")[2]; // First part is the year (YYYY)
//    var month = selectedDate.split("-")[1]; // Second part is the month (MM)
//    var year = selectedDate.split("-")[0]; // Second part is the day (DD)
//    time_range = year + '-' + month + '-' + day + 'T00:00:00.000Z';

//    const wmsSource = CropGrowth_layer.getSource();
//    wmsSource.updateParams({ 'time': time_range });

//    const wmsSource_CropHealth_layer = CropHealth_layer.getSource();
//    wmsSource_CropHealth_layer.updateParams({ 'time': time_range });

//    const wmsSource_CropHarvesting_layer = CropHarvesting_layer.getSource();
//    wmsSource_CropHarvesting_layer.updateParams({ 'time': time_range });

//    const wmsSource_VegetationMoisture_layer = VegetationMoisture_layer.getSource();
//    wmsSource_VegetationMoisture_layer.updateParams({ 'time': time_range });

//    const wmsSource_NitrogenContent_layer = NitrogenContent_layer.getSource();
//    wmsSource_NitrogenContent_layer.updateParams({ 'time': time_range });

//    const wmsSource_SoilMoisture_layer = SoilMoisture_layer.getSource();
//    wmsSource_SoilMoisture_layer.updateParams({ 'time': time_range });

//    const wmsSource_base = layers['basemap_ortho'].getSource();
//    wmsSource_base.updateParams({ 'time': time_range });



//    /*   var cTime = new Date();*/

//    var cTime = new Date(selectedDate);
//    var syear = cTime.getFullYear();
//    var smonth = cTime.getMonth() + 1;
//    if (smonth < 10) {
//        smonth = "0" + smonth;
//    }
//    var sday = cTime.getDate();
//    if (sday < 10) {
//        sday = "0" + sday;
//    }

//    var sto_date = syear + "-" + smonth + "-" + sday;
//    var sfrom_date = new Date(sto_date);
//    sfrom_date.setDate(sfrom_date.getDate() - 14);
//    timlapse = sfrom_date.toISOString().slice(0, 10) + "/" + sto_date;

//    const wmsSource_sentinal1 = layers['sentinal1'].getSource();
//    wmsSource_sentinal1.updateParams({ 'time': timlapse });

//    const wmsSource_sentinal2 = layers['sentinal2'].getSource();
//    wmsSource_sentinal2.updateParams({ 'time': timlapse });

//    sentinel_layer.getSource().updateParams({ 'time': timlapse });

//    if (selectedLayerId == 'sentinal2')
//        zoomInOutOnce();
//}

//function icnTimeSeries() {
//    var itm = document.getElementById("btntimeseries");
//    var itms = document.getElementById("inptrangetimeseries");


//    if (itm.style.backgroundColor == "rgb(201, 50, 255)") {
//        itms.style.display = "none";
//        itm.style.backgroundColor = "";
//    } else {
//        itm.style.backgroundColor = "#c932ff";
//        itms.style.display = "block";
//    }



//}



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

//document.getElementById("cd_Weed").disabled = true;
//document.getElementById("cd_EnhancedVegetation").disabled = true;



function fun_layer() {
    if (document.getElementById("layersDataid").style.display == "none") {
        document.getElementById("layersDataid").style.display = "block";

    } else {
        //document.getElementById("imgidlayer").style.backgroundColor = "";

        document.getElementById("layersDataid").style.display = "none";

    }
}




///////////////////// Drag information box  /////////////////
var object = document.querySelector('.infoPopupBox'),
    initX, initY, firstX, firstY;

object.addEventListener('mousedown', function (e) {

    e.preventDefault();
    initX = this.offsetLeft;
    initY = this.offsetTop;
    firstX = e.pageX;
    firstY = e.pageY;

    this.addEventListener('mousemove', dragIt, false);

    window.addEventListener('mouseup', function () {
        object.removeEventListener('mousemove', dragIt, false);
    }, false);

}, false);

object.addEventListener('touchstart', function (e) {

    e.preventDefault();
    initX = this.offsetLeft;
    initY = this.offsetTop;
    var touch = e.touches;
    firstX = touch[0].pageX;
    firstY = touch[0].pageY;

    this.addEventListener('touchmove', swipeIt, false);

    window.addEventListener('touchend', function (e) {
        e.preventDefault();
        object.removeEventListener('touchmove', swipeIt, false);
    }, false);

}, false);

function dragIt(e) {
    this.style.left = initX + e.pageX - firstX + 'px';
    this.style.top = initY + e.pageY - firstY + 'px';
}

function swipeIt(e) {
    var contact = e.touches;
    this.style.left = initX + contact[0].pageX - firstX + 'px';
    this.style.top = initY + contact[0].pageY - firstY + 'px';
}

var mapElement = document.getElementById('map');
var toggleImage = document.getElementById('toggleImage');

// Toggle start/stop on image click
toggleImage.addEventListener('click', function () {
    isMapActive = !isMapActive;

    if (isMapActive) {
        // Enable interactions
        interactions.forEach(function (interaction) {
            map.addInteraction(interaction);
        });
        mapElement.classList.add('grabbable');
        toggleImage.src = 'img/map_icons/hand.png';
        toggleImage.style.backgroundColor = 'green';
    } else {
        // Disable interactions
        map.getInteractions().clear();
        mapElement.classList.remove('grabbable');
        toggleImage.src = 'img/map_icons/hand.png';

        toggleImage.style.backgroundColor = 'white';

    }
});

// Cursor handling for drag feel
mapElement.addEventListener('mousedown', function () {
    if (mapElement.classList.contains('grabbable')) {
        mapElement.classList.add('grabbing');
    }
});

mapElement.addEventListener('mouseup', function () {
    mapElement.classList.remove('grabbing');
});

mapElement.addEventListener('mouseleave', function () {
    mapElement.classList.remove('grabbing');
});


/////////////////////////////////////////   QUERY BUILDER   ///////////////////////////////////////////////////
//var querybuilder = document.getElementById("querybuilder");
//querybuilder.addEventListener('click', function () {

//    if (querybuilder.classList.contains('active')) {
//        querybuilder.classList.remove('active');
//        document.getElementById("querybuilderdivid").style.display = "none";

//        layerobject.pop(filteredlayer);
//        lastselectedlayer.pop(ddllayer);
//        lastselectedlayername.pop(ddllayer);
//        lastselectedlayer_vector.pop(ddllayer);
//        // Example: Add this layer to the map (assuming you have a map object)
//        map.removeLayer(filteredlayer);
//        map.removeOverlay(filteredlayer);
//    } else {
//        querybuilder.classList.add('active');
//        document.getElementById("querybuilderdivid").style.display="block";
//    }
  
    

//})
var filteredlayer;
function clientQuery() {
    var ddllayer = document.getElementById("ddllayer").value;
    //var selectedText = ddllayer.options[ddllayer.selectedIndex].text;
    //alert(selectedText);
    var ddlattrubutename = document.getElementById("ddlattrubutename").value;
    var ddlattributevalue = document.getElementById("ddlattributevalue").value;

    // Construct the CQL filter dynamically using selected attribute name and value
    var cqlFilter = ddlattrubutename + " = '" + ddlattributevalue + "'";
    map.removeLayer(filteredlayer);
    map.removeOverlay(filteredlayer);
      filteredlayer = new ol.layer.Image({
        source: new ol.source.ImageWMS({
            ratio: 1,
            url: geoserver_ip,  // this should be defined elsewhere in your script
            params: {
                'FORMAT': format,  // also should be defined elsewhere
                tiled: true,
                STYLES: '',
                layers: 'uk_sfd:' + ddllayer,
                CQL_FILTER: cqlFilter,
                transition: 0
            }, serverType: 'geoserver',
            crossOrigin: 'anonymous'
        })
    });


    layerobject.push(filteredlayer);
    lastselectedlayer.push(ddllayer);
    lastselectedlayername.push(ddllayer);
    lastselectedlayer_vector.push(ddllayer);
    // Example: Add this layer to the map (assuming you have a map object)
    map.addLayer(filteredlayer);
    map.addOverlay(filteredlayer);
}



/////////////////////////////////////////   QUERY BUILDER   ///////////////////////////////////////////////////

function downloadMapAsPNG() {
    // Get the canvas from the map's viewport
    var canvas = map.getViewport().querySelector('canvas');

    // Check if canvas exists and it's not tainted (CORS must be allowed)
    if (canvas) {
        var imgData = canvas.toDataURL('image/png'); // Export as PNG
        var link = document.createElement('a');
        link.href = imgData;
        const now = new Date();

        const fileName = `file_${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}_${String(now.getHours()).padStart(2, '0')}-${String(now.getMinutes()).padStart(2, '0')}-${String(now.getSeconds()).padStart(2, '0')}.png`;



        link.download = fileName; // Set download filename
        link.click(); // Trigger the download
    } else {
        alert('Canvas is tainted, unable to export.');
    }
}

//document.getElementById('download-btn').addEventListener('click', downloadMapAsPNG);


