/*const { Doc } = require("codemirror");*/

var geoserver_ip = "http://180.151.15.18:9007/geoserver/uk_sfd/wms?";
var geoserver_ip_ows = "http://180.151.15.18:9007/geoserver/sbl/ows";
var sentinel2fcckey = document.getElementById("sentinel2fcckey").value;
var sentinel2ncckey = document.getElementById("sentinel2ncckey").value;
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
var container, content, closer;
var overlay = new ol.Overlay(({
    element: container,
    autoPan: true,
    autoPanAnimation: {
        duration: 250
    }
}));

 


 

window.onload = function () {
    
    lastselectedlayer = [];
    lastselectedlayername = [];
    lastselectedlayer_vector = [];
    map.addOverlay(divisions);
    map.addLayer(divisions);
    layerobject.push(divisions);


    lastselectedlayer.push("tbl_division_master");
    lastselectedlayername.push("Divisions Boundary");
    lastselectedlayer_vector.push("tbl_division_master");
    
    jQuery('#div_division').css('display', 'block');
    var div_country = document.getElementById("division");
    div_country.checked = true;
}

var count = 0;
var timlapse;
var time_range;



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
    'none': new ol.layer.Tile({
        title: 'None',
        visible: false,
        source: new ol.source.XYZ({
            url: ''
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
    'sentinel1': new ol.layer.Tile({
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
    'sentinel2fcc': new ol.layer.Tile({
        visible: false,
        name: 'sentinal-2',
        source: new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
           // url: 'https://services.sentinel-hub.com/ogc/wms/5909508b-6a9b-4832-becb-406e0689e132',
            params: { "maxcc": 50, "minZoom": 6, "maxZoom": 16, "preset": "2_FALSE_COLOR", "layers": "2_FALSE_COLOR", "time": timlapse },
            serverType: 'geoserver',
            crossOrigin: 'anonymous',
            transition: 0
        })
    })
    ,
    'sentinel2ncc': new ol.layer.Tile({
        visible: false,
        name: 'sentinal-2',
        source: new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2ncckey,
           // url: 'https://services.sentinel-hub.com/ogc/wms/a52df360-16d7-4601-8f95-3a5205ab3889',
            params: { "maxcc": 50, "minZoom": 6, "maxZoom": 16, "preset": "TRUE_COLOR", "layers": "TRUE_COLOR", "time": timlapse },
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
            console.log(selectedLayerId);
            if (selectedLayerId == "sentinel2fcc" || selectedLayerId == "sentinel2ncc") {
                document.getElementById("time").style.display = "block";
            } else {
                document.getElementById("time").style.display = "none";
            }
            Object.keys(layers).forEach(function (layerId) {
                layers[layerId].setVisible(layerId === selectedLayerId);
            });
        }
    });
});
 





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
        zoom: 8,
        minZoom: 3,
        maxZoom: 18



    }),
    
});

var map2 = new ol.Map({
    target: 'map2',
    controls: ol.control.defaults().extend([
        new ol.control.FullScreen(),
        new ol.control.ScaleLine()
    ]),
    layers: Object.values(layers),
    view: new ol.View({

        center: ol.proj.fromLonLat([79.0193, 30.0668]),
        zoom: 8,
        minZoom: 3,
        maxZoom: 18



    }),

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

////////////////////////////////////////////////////////

const currentDate = new Date();

// Format the date as YYYY-MM-DD
const formattedDate = currentDate.toISOString().split('T')[0];

// Set the input field value to the current date
const dateInput = document.getElementById("time");
dateInput.value = formattedDate;



var dateData = document.getElementById("hfAllDates").value;

var dates = dateData.split(',');


flatpickr("#time", {
    dateFormat: "Y-m-d",
    onDayCreate: function (dObj, dStr, fp, dayElem) {
        const dateStr = dayElem.dateObj.toLocaleDateString('en-CA');
        if (dates.includes(dateStr)) {
            dayElem.classList.add("highlighted");
        } else {
            /* dayElem.classList.add("highlightedRed");*/
        }
    }
});


 
const dateInput1 = document.getElementById("time"); 
dateInput1.addEventListener('change', function () {
     
    const selectedDate = dateInput.value;
     
    layers['sentinel2fcc'].getSource().updateParams({
        'time': selectedDate
    });
     
    layers['sentinel2fcc'].getSource().refresh();

    layers['sentinel2ncc'].getSource().updateParams({
        'time': selectedDate
    });

    layers['sentinel2ncc'].getSource().refresh();
});



//////// time slider /////////////////
const calendarInput = document.getElementById('time');
const sliderSection = document.getElementById('sliderSection');
const rangeInput = document.getElementById('dateRange');
const labelContainer = document.getElementById('dateLabels');


let dateList = [];
calendarInput.addEventListener('change', () => {
    const baseDate = new Date(calendarInput.value);
    if (!calendarInput.value) return;

    // Generate 10 dates with a 4-day gap each (descending)
    dateList = [];
    for (let i = 0; i < 10; i++) {
        const d = new Date(baseDate);
        d.setDate(d.getDate() - i * 4); // 4-day gap
        dateList.push(d.toISOString().split('T')[0]);
    }

    // Reverse for descending order display on slider (left = newest)
    dateList.reverse();

    // Show the slider section
   sliderSection.style.display = 'block';

    // Set slider value and selected date (start at newest date)
    rangeInput.value = 9;


    // Populate labels in descending order
    labelContainer.innerHTML = '';
    dateList.forEach((date, index) => {
        const label = document.createElement('span');
        label.textContent = date;
        label.id = `label-${index}`;
        labelContainer.appendChild(label);
    });
});

// Update selected date from slider
rangeInput.addEventListener('input', () => {
    const index = parseInt(rangeInput.value, 10);
    console.log("Selected Date:", dateList[index]);
    selectedDate = dateList[index];
    layers['sentinel2fcc'].getSource().updateParams({
        'time': selectedDate
    });

    layers['sentinel2fcc'].getSource().refresh();

    layers['sentinel2ncc'].getSource().updateParams({
        'time': selectedDate
    });

    layers['sentinel2ncc'].getSource().refresh();
});













 


function sfdzone(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_zone').css('display', 'block');
        map.addLayer(zones);
        layerobject.push(zones);
        map.addOverlay(zones);
        lastselectedlayer.push("tbl_uk_zone_boundary");
        lastselectedlayername.push("SFD Zone Boundaries");
        lastselectedlayer_vector.push("tbl_uk_zone_boundary");
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



function LandDetails(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_LandDetails').css('display', 'block');
        map.addLayer(LandDetails_layer);
        layerobject.push(LandDetails_layer);
        map.addOverlay(LandDetails_layer);
        lastselectedlayer.push("tbl_plantation_area");
        lastselectedlayername.push("Land Details");
        lastselectedlayer_vector.push("tbl_plantation_area");
        //thailandvil_zoom();
    }
    else {
        jQuery('#div_LandDetails').css('display', 'none');
        map.removeLayer(LandDetails_layer);
        layerobject.pop(LandDetails_layer);
        map.removeOverlay(LandDetails_layer);
        lastselectedlayer.pop("tbl_plantation_area");
        lastselectedlayername.pop("Thailand Data");
        lastselectedlayer_vector.pop("tbl_plantation_area");
        // country_zoom();
    }
}
var LandDetails_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: 'http://180.151.15.18:9007/geoserver/uk_sfd/wms?',
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            //layers: 'nrdc:view_farmer_details',
            //layers: 'nrdc:tbl_apple_land',
            layers: 'uk_sfd:tbl_plantation_area',
            transition: 0
        }
    })
});
var infoselected = "0";
function setselectedinfo() {

    if (infoselected == "0") {
        if (infoselected == "0") {
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

var splitcount=0
function callsplit() {
    if (splitcount == 0) {
        document.getElementById("map2parent").style.display = "none";
        document.getElementById("map1parent").style.width = "100%";
        splitcount = 1;
    } else {
        document.getElementById("map2parent").style.display = "block";
        document.getElementById("map1parent").style.width = "50%";
        splitcount = 0;
    }
    
}









