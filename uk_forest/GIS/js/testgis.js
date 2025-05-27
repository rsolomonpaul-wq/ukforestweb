
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



var containerEdit = document.getElementById('myModel3');
var contentEdit = document.getElementById('editableGridid');
var closerEdit = document.getElementById('popup-closer-edit');

// Update the TIME parameter dynamically



window.onload = function () {

    lastselectedlayer = [];
    lastselectedlayername = [];
    lastselectedlayer_vector = [];
    map.addOverlay(country_layer);
    map.addLayer(country_layer);
    layerobject.push(country_layer);
    lastselectedlayer.push("tbl_country_boundary");
    lastselectedlayername.push("Country Boundary");
    lastselectedlayer_vector.push("tbl_country_boundary");

    



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
            url: 'https://services.sentinel-hub.com/ogc/wms/532fdbe1-316b-4a03-9f5f-1dc89db63437',
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
document.querySelectorAll('.layer-switcher input[type="radio"]').forEach(function (radio) {
    radio.addEventListener('change', function () {
        selectedLayerId = this.id;
        Object.keys(layers).forEach(function (layerId) {
            layers[layerId].setVisible(layerId === selectedLayerId);
        });
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
    layers: [
        layers['osm'],
        layers['hybrid'],
        layers['satellite'],
        layers['terrain'],
        layers['roadmap'],
        layers['Planet'],
        layers['sentinal1'],
        layers['sentinal2'],
        layers['basemap_ortho']

    ],
    view: new ol.View({

        center: ol.proj.fromLonLat([85.0193, 25.0668]),
        zoom: 5,
        minZoom: 3,
        maxZoom: 18



    }),
    interactions: []
});

 

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
        }

    })
});


/*================================State==============================*/
 
 
var container, content, closer;

 
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

// ========================== Measure Interaction ========================== //
function addMeasureInteraction() {
    draw = new ol.interaction.Draw({
        source: source,
        type: 'LineString',
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

    map.addInteraction(draw);
    createMeasureTooltip();

    draw.on('drawstart', function (evt) {
        sketch = evt.feature;

        sketch.getGeometry().on('change', function (evt) {
            const geom = evt.target;
            const output = formatLength(geom);
            measureTooltipElement.innerHTML = output;
            measureTooltip.setPosition(geom.getLastCoordinate());
        });
    });

    draw.on('drawend', function () {
        measureTooltipElement.className = 'tooltip tooltip-static';
        measureTooltip.setOffset([0, -7]);
        sketch = null;
        measureTooltipElement = null;
        createMeasureTooltip();
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

// ========================== Clear Measure ========================== //
function clearAll() {
    source.clear();
    measureTooltips.forEach(tip => map.removeOverlay(tip));
    measureTooltips = [];

    if (draw) {
        map.removeInteraction(draw);
        draw = null;
    }

    document.getElementById('measureLine').classList.remove('active');

    const popup = document.getElementById('popup');
    if (popup) {
        popup.classList.remove('hidden');
        popup.textContent = 'All features cleared!';
        setTimeout(() => popup.classList.add('hidden'), 1200);
    }
}

// ========================== Button Events ========================== //
document.getElementById('measureLine').addEventListener('click', function () {
    this.classList.toggle('active');
    map.removeInteraction(draw);
    if (this.classList.contains('active')) {
        addMeasureInteraction();
    }
});

document.getElementById('clearAllBtn').addEventListener('click', clearAll);