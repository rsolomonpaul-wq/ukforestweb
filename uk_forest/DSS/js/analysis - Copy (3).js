

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
var filter = "";

var checkrunningtime = 0;

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
            params: { "maxcc": 85, "minZoom": 6, "maxZoom": 16, "preset": "CLOUDFREEFALSECOLOR", "layers": "CLOUDFREEFALSECOLOR", "time": date },

            serverType: 'geoserver',
            crossOrigin: 'anonymous',
            transition: 0

        })
    });
}

function createGeoServerLayer(lastselectedlayer, filter) {
    //alert("called createGeoServerLayer");
    var geoServerURL = null;
    //filter = "beat ILIKE 'Kimoli'";
    if (filter == null || filter == "") {
        geoServerURL = "https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:" + lastselectedlayer + "&outputFormat=application/json";
    }
    else {
        geoServerURL = "https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:" + lastselectedlayer + "&outputFormat=application/json&CQL_FILTER=" + filter;
        // console.log(geoServerURL);
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
    vectorSource.once('change', function (e) {
        const state = vectorSource.getState();
        console.log("Vector source state:", state);

        if (state === 'ready') {
            const features = vectorSource.getFeatures();
            console.log("Features loaded:", features.length);

            if (features.length === 0) {
                alert("No features loaded from GeoServer.");
                return;
            }

            features.forEach(feature => {
                const geometry = feature.getGeometry();
                const type = geometry.getType();
                let rawCoords = geometry.getCoordinates();
                let transformedCoords = [];

                if (type === 'Polygon') {
                    rawCoords[0].forEach(coord => {
                        const [lon, lat] = ol.proj.transform(coord, 'EPSG:3857', 'EPSG:4326');
                        transformedCoords.push([+lon.toFixed(14), +lat.toFixed(14)]);
                    });
                } else if (type === 'MultiPolygon') {
                    rawCoords.forEach(polygon => {
                        polygon[0].forEach(coord => {
                            const [lon, lat] = ol.proj.transform(coord, 'EPSG:3857', 'EPSG:4326');
                            transformedCoords.push([+lon.toFixed(14), +lat.toFixed(14)]);
                        });
                    });
                }

                const prettyCoords = transformedCoords.map(c => `[${c[0]}, ${c[1]}]`).join(',\n');
                //console.log("---------------------------------------------------------------------------");
                //console.log(transformedCoords);
                const startDate = "2022-01-01";
                const endDate = "2025-09-15";
                // You can call your function here
                fetchNdviForPolygon(startDate, endDate, transformedCoords);
            });
        } else {
            alert("Vector source failed to load or is not ready. State: " + state);
        }
    });





    return cliplayer;
}

var dragPan;


const sharedView = new ol.View({
    center: ol.proj.fromLonLat([79.2593, 29.9968]),
    zoom: 8.2
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

window.onload = function () {

    map1.addLayer(zones);
    map1.addOverlay(zones);

    layerobject.push(zones);

    document.getElementById("zonecheck").checked = true;

    lastselectedlayer.push("tbl_zone_master");
    lastselectedlayername.push("Zone Boundary");
    lastselectedlayer_vector.push("tbl_zone_master");

}
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
            //CQL_FILTER: "division ILIKE 'Garhwal'",
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



function soilfuntion(checkbox) {

    if (checkbox.checked) {

        map1.addLayer(soil_layer);
        map2.addLayer(soil_layer);
        map1.addOverlay(soil_layer);
        map2.addOverlay(soil_layer);
        layerobject.push(soil_layer);


    }
    else {

        map1.removeLayer(soil_layer);
        map2.removeLayer(soil_layer);
        layerobject.pop(soil_layer);
        map1.removeOverlay(soil_layer);
        map2.removeOverlay(soil_layer);

    }
}

function clearPolygons() {
    try {
        const layers = map1.getLayers().getArray();

        //console.log("All layers on map:", layers);

        if (vectorLayerforsoil) {
            const index = layers.indexOf(vectorLayerforsoil);
            if (index !== -1) {
                map1.removeLayer(vectorLayerforsoil);
                //console.log("Removed vectorLayerforsoil.");
            } else {
                alert("Layer exists but is not on the map.");
            }
        } else {
            alert("vectorLayerforsoil is not defined.");
        }

        document.getElementById('info').innerHTML =
            "Draw a polygon or upload a shapefile to get slope values...";
    } catch (e) {
        alert("Error: " + e.message);
    }
}


//var soil_layer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            'SLD_BODY': `
//        <StyledLayerDescriptor version="1.0.0">
//          <NamedLayer>
//            <Name>uk_sfd:GCS_Soil_Type_Uttaranchal</Name>
//            <UserStyle>
//              <FeatureTypeStyle>
//                <Rule>
//                  <RasterSymbolizer>
//                    <ColorMap type="values">
//                      <ColorMapEntry color="#A52A2A" quantity="1" label="Loamy"/>
//                      <ColorMapEntry color="#FFFF00" quantity="2" label="Sandy"/>
//                      <ColorMapEntry color="#FFC0CB" quantity="3" label="Snow"/>
//                      <ColorMapEntry color="#808080" quantity="4" label="Clay"/>
//                    </ColorMap>
//                  </RasterSymbolizer>
//                </Rule>
//              </FeatureTypeStyle>
//            </UserStyle>
//          </NamedLayer>
//        </StyledLayerDescriptor>
//      `,
//            //layers: 'uk_sfd:tbl_fire_polygon',
//            layers: 'uk_sfd:GCS_Soil_Type_Uttaranchal',

//            transition: 0
//        }, serverType: 'geoserver',
//        crossOrigin: 'anonymous'
//    })
//});
const soil_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: 'https://ukforestgis.in/geoserver/uk_sfd/wms',
        params: {
            'LAYERS': 'uk_sfd:GCS_Soil_Type_Uttaranchal',
            'FORMAT': 'image/png',
            'VERSION': '1.3.0',
            'SLD_BODY': `
        <StyledLayerDescriptor version="1.0.0">
          <NamedLayer>
            <Name>uk_sfd:GCS_Soil_Type_Uttaranchal</Name>
            <UserStyle>
              <FeatureTypeStyle>
                <Rule>
                  <RasterSymbolizer>
                    <ColorMap type="values">
                      <ColorMapEntry color="#A0522D" quantity="1" label="Loamy"/>
                      <ColorMapEntry color="#C2B280" quantity="2" label="Sandy"/>
                      <ColorMapEntry color="#FFFFFF" quantity="3" label="Snow"/>
                      <ColorMapEntry color="#808080" quantity="4" label="Clay"/>
                    </ColorMap>
                  </RasterSymbolizer>
                </Rule>
              </FeatureTypeStyle>
            </UserStyle>
          </NamedLayer>
        </StyledLayerDescriptor>
      `
        },
        ratio: 1,
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

const slopeSLD = `
    <?xml version="1.0" encoding="UTF-8"?>
    <StyledLayerDescriptor version="1.0.0"
      xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
      xmlns="http://www.opengis.net/sld"
      xmlns:ogc="http://www.opengis.net/ogc"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

      <NamedLayer>
        <Name>uk_sfd:srtm_slop_GCS</Name>
        <UserStyle>
          <Title>Slope Classification</Title>
          <FeatureTypeStyle>
            <Rule>
              <RasterSymbolizer>
                <ColorMap type="intervals" extended="true">
                  <ColorMapEntry color="#6BBE44" quantity="10" label="5 - 10"/>
                  <ColorMapEntry color="#E5F94E" quantity="20" label="10 - 20"/>
                  <ColorMapEntry color="#FDC84E" quantity="30" label="20 - 30"/>
                  <ColorMapEntry color="#F57C20" quantity="45" label="30 - 45"/>
                  <ColorMapEntry color="#FF0000" quantity="88" label="45 - 88"/>
                </ColorMap>
              </RasterSymbolizer>
            </Rule>
          </FeatureTypeStyle>
        </UserStyle>
      </NamedLayer>
    </StyledLayerDescriptor>
    `;

// WMS Layer with SLD
const sloplayer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_ip,
        params: {
            'LAYERS': 'uk_sfd:srtm_slop_GCS',
            'FORMAT': 'image/png',
            'VERSION': '1.1.0',
            'SRS': 'EPSG:4326',
            'SLD_BODY': slopeSLD
            // Add 'SLD_BODY' if needed
        },
        ratio: 1,
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

//var dtmlayer = new ol.layer.Image({
//    source: new ol.source.ImageWMS({
//        ratio: 1,
//        url: geoserver_ip,
//        params: {
//            'FORMAT': format,
//            tiled: true,
//            STYLES: '',
//            layers: 'uk_sfd:Uttaranchal_SRTM_GEO',
//            transition: 0
//        }, serverType: 'geoserver',
//        crossOrigin: 'anonymous'

//    })
//});
//const sldBodydtm = `  <?xml version="1.0" encoding="UTF-8"?>
//    <StyledLayerDescriptor version="1.0.0"
//      xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
//      xmlns="http://www.opengis.net/sld"
//      xmlns:ogc="http://www.opengis.net/ogc"
//      xmlns:xlink="http://www.w3.org/1999/xlink"
//      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

//      <NamedLayer>
//        <Name>uk_sfd:Uttaranchal_SRTM_GEO</Name>
//        <UserStyle>
//          <Title>Elivation Classification</Title>
//          <FeatureTypeStyle>
//            <Rule>
//              <RasterSymbolizer>
//                <ColorMap type="intervals" extended="true">
//                  <ColorMapEntry label="185.7400" color="#2b83ba" quantity="185.74000000000001"/>
//                  <ColorMapEntry label="2087.2825" color="#abdda4" quantity="2087.2825000000003"/>
//                  <ColorMapEntry label="3988.8250" color="#ffffbf" quantity="3988.8249999999998"/>
//                  <ColorMapEntry label="5890.3675" color="#fdae61" quantity="5890.3675000000003"/>
//                  <ColorMapEntry label="7791.9100" color="#d7191c" quantity="7791.9099999999999"/>
//                </ColorMap>
//              </RasterSymbolizer>
//            </Rule>
//          </FeatureTypeStyle>
//        </UserStyle>
//      </NamedLayer>
//    </StyledLayerDescriptor>`.trim();

const sldBodydtm = `<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
  xmlns="http://www.opengis.net/sld"
  xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.opengis.net/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <NamedLayer>
    <Name>uk_sfd:Uttaranchal_SRTM_GEO</Name>
    <UserStyle>
      <Title>Elevation Classification</Title>
      <FeatureTypeStyle>
        <Rule>
          <RasterSymbolizer>
            <ColorMap type="intervals" extended="true">
              <ColorMapEntry label="Very Low (≤500m)" color="#2b83ba" quantity="500" />
              <ColorMapEntry label="Low‐Moderate (500–1000m)" color="#abdda4" quantity="1000" />
              <ColorMapEntry label="Moderate‐High (1000–2000m)" color="#ffffbf" quantity="2000" />
              <ColorMapEntry label="High (2000–3000m)" color="#fdae61" quantity="3000" />
              <ColorMapEntry label="Very High (>3000m)" color="#d7191c" quantity="4000" />
            </ColorMap>
          </RasterSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>`.trim();


const dtmlayer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        url: geoserver_ip,
        params: {
            'LAYERS': 'uk_sfd:Uttaranchal_SRTM_GEO',
            'FORMAT': 'image/png',
            'VERSION': '1.1.0',
            'SRS': 'EPSG:4326',
            'SLD_BODY': sldBodydtm
            // Add 'SLD_BODY' if needed
        },
        ratio: 1,
        crossOrigin: 'anonymous'
    })
});



let sentinelLayer1, sentinelLayer2;
var ndviLayer1, ndviLayer2;
var swipeLayer1, swipeLayer2, swipeNDVILayer1, swipeNDVILayer2;
let showNDVI = false;
let singleDates = [];
let dualDates1 = [], dualDates2 = [];


let rasterListenerAdded = false; let rasterListenerAdded1 = false;

function createSentinelLayer(date) {
    //alert("createSentinelLayer");
    //alert("createSentinelLayer for the date : "+date);
    document.getElementById("key-switcher").style.display = "block";

    //const checkndvi = document.getElementById("ndvi-toggle");
    //const checkcbi = document.getElementById("ndvi-toggle1");
    // var selectedindicies = document.querySelector('input[name="index"]:checked');
    var selectedindicies = document.getElementById("selectedIndicies");
    // alert("selectedindicies :"+selectedindicies)
    if (selectedindicies) {
        selectedindicies = selectedindicies.value;
    }

    const selected = document.querySelector('input[name="sentinel-type"]:checked').value;
    const mode = document.querySelector('input[name="mode"]:checked').value;

    const layerName = selected === 'fcc' ? 'CLOUDFREEFALSECOLOR' : '1_TRUE_COLOR';
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

    rasterListenerAdded = false;

    document.getElementById("ndvi-stats-table").style.display = "none";
    document.getElementById("ndvilengend").style.display = "none";
    document.getElementById("ndvilengendmap2").style.display = "none";
    document.getElementById("saviLegend").style.display = "none";
    document.getElementById("eviLegend").style.display = "none";
    document.getElementById("ndwiLegend").style.display = "none";

    // =================== NDVI PROCESSING ===================
    if (selectedindicies == "NDVI") {

        document.getElementById("ndvi-stats-table").style.display = "block";
        if (mode === "dual") {
            document.getElementById("ndvilengend").style.display = "block";
            document.getElementById("ndvilengendmap2").style.display = "none";
        } else {
            document.getElementById("ndvilengend").style.display = "block";
        }

        const falseColorSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: 'CLOUDFREEFALSECOLOR',
                time: date,
                preset: 'CLOUDFREEFALSECOLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        var rasterSource = new ol.source.Raster({
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
    else if (selectedindicies == "NDWI") {
        document.getElementById("ndvi-stats-table").style.display = "block";
        if (mode === "dual") {
            document.getElementById("ndwiLegend").style.display = "block";
            //document.getElementById("ndvilengendmap2").style.display = "block";
        } else {
            document.getElementById("ndwiLegend").style.display = "block";
        }

        const falseColorSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: 'CLOUDFREEFALSECOLOR',
                time: date,
                preset: 'CLOUDFREEFALSECOLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        const rasterSource = new ol.source.Raster({
            sources: [falseColorSource],
            operation: function (pixels, data) {
                if (!data.counts) {
                    data.counts = { Wetlands: 0, Moist: 0, Urban: 0 };
                }
                const pixel = pixels[0];
                const nir = pixel[1] / 255;
                const r = pixel[1] / 255;
                const g = pixel[2] / 255;
                const ndwi = (g - nir) / (g + nir);
                // const nbr = (nir - (r + g)) / (nir + (r + g));

                if (ndwi > 0.3) {
                    data.counts.Wetlands++;
                    return [0, 0, 255, 255]; // Water bodies (blue)

                } else if (ndwi >= 0) {
                    data.counts.Moist++;
                    return [0, 255, 0, 255]; // Wet soil, vegetation edges, moist areas (green)
                } else {
                    data.counts.Urban++;
                    return [255, 165, 0, 255]; // Vegetation, bare soil, urban areas (orange)
                }

            }
        });

        if (!rasterListenerAdded) {
            rasterSource.on('afteroperations', function (event) {
                if (event.data && event.data.counts) {
                    const counts = event.data.counts;
                    const total = counts.Wetlands + counts.Moist + counts.Urban;

                    if (total > 0) {
                        const percentages = {
                            Wetlands: ((counts.Wetlands / total) * 100).toFixed(2),
                            Moist: ((counts.Moist / total) * 100).toFixed(2),
                            Urban: ((counts.Urban / total) * 100).toFixed(2)
                        };

                        //console.log("NDVI Counts:", counts);
                        //console.log("NDVI Percentages (%):", percentages);
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
    else if (selectedindicies == "EVI") {
        document.getElementById("ndvi-stats-table").style.display = "block";
        if (mode === "dual") {
            document.getElementById("eviLegend").style.display = "block";
            //document.getElementById("ndvilengendmap2").style.display = "block";
        } else {
            document.getElementById("eviLegend").style.display = "block";
        }

        const falseColorSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: 'CLOUDFREEFALSECOLOR',
                time: date,
                preset: 'CLOUDFREEFALSECOLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        //const rasterSource = new ol.source.Raster({
        //    sources: [falseColorSource],
        //    operation: function (pixels) {
        //        const pixel = pixels[0];
        //        const nir = pixel[1] / 255;
        //        const r = pixel[1] / 255;
        //        const g = pixel[2] / 255;
        //       // const evi = (nir - (r + g)) / (nir + (r + g));
        //        const evi = 2.5 * ((nir + r) / ((nir + (6 * r)) - ((7.5 * b) + 1)));

        //        if (evi < 0) {
        //            return [0, 0, 255, 255]; // Water, snow, clouds (blue)
        //        } else if (evi < 0.2) {
        //            return [210, 180, 140, 255]; // Sparse/stressed vegetation, bare soil (tan)
        //        } else if (evi < 0.5) {
        //            return [34, 139, 34, 255]; // Moderate vegetation (forest green)
        //        } else {
        //            return [0, 100, 0, 255]; // Dense, healthy vegetation (dark green)
        //        }
        //    }
        //});

        const rasterSource = new ol.source.Raster({
            sources: [falseColorSource],
            operation: function (pixels, data) {
                if (!data.counts) {
                    data.counts = { Nonvegetated: 0, Barren: 0, Shrubland: 0, Vegetated: 0 };
                }
                const pixel = pixels[0];

                const nir = pixel[0] / 255;  // NIR
                const red = pixel[1] / 255;  // Red
                const blue = pixel[3] ? pixel[3] / 255 : 0.01; // Blue (fallback if not available)

                // EVI formula
                const evi = 2.5 * ((nir - red) / ((nir + 6 * red) - (7.5 * blue + 1)));

                // Classification by EVI value
                if (evi < 0) {
                    data.counts.Nonvegetated++;
                    return [0, 0, 255, 255]; // Water, snow, clouds (blue)
                } else if (evi < 0.2) {
                    data.counts.Barren++;
                    return [210, 180, 140, 255]; // Bare soil or sparse vegetation (tan)
                } else if (evi < 0.5) {
                    data.counts.Shrubland++;
                    return [34, 139, 34, 255]; // Moderate vegetation (forest green)
                } else {
                    data.counts.Vegetated++;
                    return [0, 100, 0, 255]; // Dense vegetation (dark green)
                }
            }
        });

        if (!rasterListenerAdded) {
            rasterSource.on('afteroperations', function (event) {
                if (event.data && event.data.counts) {
                    const counts = event.data.counts;
                    const total = counts.Nonvegetated + counts.Barren + counts.Shrubland + counts.Vegetated;

                    if (total > 0) {
                        const percentages = {
                            Nonvegetated: ((counts.Nonvegetated / total) * 100).toFixed(2),
                            Barren: ((counts.Barren / total) * 100).toFixed(2),
                            Shrubland: ((counts.Shrubland / total) * 100).toFixed(2),
                            Vegetated: ((counts.Vegetated / total) * 100).toFixed(2)
                        };

                        //console.log("NDVI Counts:", counts);
                        //console.log("NDVI Percentages (%):", percentages);
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
    else if (selectedindicies == "SAVI") {
        document.getElementById("ndvi-stats-table").style.display = "block";
        if (mode === "dual") {
            document.getElementById("ndvilengend").style.display = "block";
            document.getElementById("ndvilengendmap2").style.display = "none";
        } else {
            document.getElementById("saviLegend").style.display = "block";
        }

        const falseColorSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: 'CLOUDFREEFALSECOLOR',
                time: date,
                preset: 'CLOUDFREEFALSECOLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        const rasterSource = new ol.source.Raster({
            sources: [falseColorSource],
            operation: function (pixels, data) {
                if (!data.counts) {
                    data.counts = { Nonvegetated: 0, Bare_soil: 0, Vegetated: 0 };
                }
                const pixel = pixels[0];
                const nir = pixel[1] / 255;
                const red = pixel[1] / 255;

                // Assume 'nir' and 'red' are band values, and L = 0.5
                var L = 0.5;
                var savi = ((nir - red) * (1 + L)) / (nir + red + L);

                // Classification and color coding
                if (savi < 0) {
                    data.counts.Nonvegetated++;
                    return [0, 0, 255, 255]; // No vegetation / water / errors (blue)
                } else if (savi < 0.3) {
                    data.counts.Bare_soil++;
                    return [210, 180, 140, 255]; // Sparse or stressed vegetation / bare soil (tan)
                } else {
                    data.counts.Vegetated++;
                    return [34, 139, 34, 255]; // Moderate to dense vegetation (forest green)
                }

            }
        });


        if (!rasterListenerAdded) {
            rasterSource.on('afteroperations', function (event) {
                if (event.data && event.data.counts) {
                    const counts = event.data.counts;
                    const total = counts.Nonvegetated + counts.Bare_soil + counts.Vegetated;

                    if (total > 0) {
                        const percentages = {
                            Nonvegetated: ((counts.Nonvegetated / total) * 100).toFixed(2),
                            Bare_soil: ((counts.Bare_soil / total) * 100).toFixed(2),

                            Vegetated: ((counts.Vegetated / total) * 100).toFixed(2)
                        };

                        //console.log("NDVI Counts:", counts);
                        //console.log("NDVI Percentages (%):", percentages);
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
    else {
        document.getElementById("ndvi-stats-table").style.display = "none";
        document.getElementById("ndvilengend").style.display = "none";
        document.getElementById("ndvilengendmap2").style.display = "none";

        return new ol.layer.Tile({ source: trueColorSource });
    }
}

function createSentinelLayernew(date) {
    //  alert("createSentinelLayernew");
    // Show legend key switcher
    document.getElementById("key-switcher").style.display = "block";

    // Get selected index type (NDVI, NDWI, etc.)
    let selectedIndexElement = document.getElementById("selectedIndicies");
    let selectedIndex = selectedIndexElement ? selectedIndexElement.value : null;

    // Get selected Sentinel image type (true color or false color)
    const sentinelImageType = document.querySelector('input[name="sentinel-type"]:checked').value;

    // Get selected mode (single or dual)
    const displayMode = document.querySelector('#screenmode').value;

    // Determine layer and key based on image type
    const selectedLayerName = sentinelImageType === 'fcc' ? 'CLOUDFREEFALSECOLOR' : '1_TRUE_COLOR';
    const sentinelKey = sentinelImageType === 'fcc' ? sentinel2fcckey : sentinel2ncckey;

    // Default base map source (true/false color Sentinel-2 WMS)
    const baseLayerSource = new ol.source.TileWMS({
        url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinelKey,
        params: {
            layers: selectedLayerName,
            time: date,
            preset: selectedLayerName,
            maxcc: 50
        },
        crossOrigin: 'anonymous'
    });

    // Reset legend and stats
    rasterListenerAdded = false;
    document.getElementById("ndvi-stats-table").style.display = "none";
    document.getElementById("ndvilengend").style.display = "none";
    document.getElementById("saviLegend").style.display = "none";
    document.getElementById("eviLegend").style.display = "none";
    document.getElementById("ndwiLegend").style.display = "none";

    // =================== NDVI Processing ===================
    if (selectedIndex === "NDVI") {
        document.getElementById("ndvi-stats-table").style.display = "block";
        if (displayMode === "dual") {
            document.getElementById("ndvilengend").style.display = "block";
            // document.getElementById("ndvilengendmap2").style.display = "block";
        } else {
            document.getElementById("ndvilengend").style.display = "block";
        }

        const ndviSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: 'CLOUDFREEFALSECOLOR',
                time: date,
                preset: 'CLOUDFREEFALSECOLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        const ndviRasterSource = new ol.source.Raster({
            sources: [ndviSource],
            operation: function (pixels, data1) {
                if (!data1.counts) {
                    data1.counts = { Dense1: 0, Moderate1: 0, Low1: 0, Other1: 0 };
                }

                const [nirRaw, redRaw] = pixels[0];
                const nir = nirRaw / 255;
                const red = redRaw / 255;
                const ndvi = (nir - red) / (nir + red);

                if (ndvi >= 0.60) {
                    data1.counts.Dense1++;
                    return [20, 90, 33, 255]; // Dark Green
                } else if (ndvi >= 0.40) {
                    data1.counts.Moderate1++;
                    return [50, 255, 90, 255]; // Light Green
                } else if (ndvi >= 0.20) {
                    data1.counts.Low1++;
                    return [221, 137, 50, 255]; // Orange
                } else {
                    data1.counts.Other1++;
                    return [255, 0, 0, 255]; // Red
                }
            }
        });

        if (!rasterListenerAdded) {
            ndviRasterSource.on('afteroperations', function (event) {
                if (event.data?.counts) {
                    const counts = event.data.counts;
                    const total = Object.values(counts).reduce((a, b) => a + b, 0);

                    if (total > 0) {
                        const percentages = Object.fromEntries(
                            Object.entries(counts).map(([key, value]) => [key, ((value / total) * 100).toFixed(2)])
                        );
                        updateNdviStatsTablenew(percentages);
                    }
                }
            });
            rasterListenerAdded = true;
        }

        return new ol.layer.Image({ source: ndviRasterSource });
    }

    // =================== NDWI Processing ===================
    else if (selectedIndex === "NDWI") {
        document.getElementById("ndvi-stats-table").style.display = "block";
        displayMode === "dual"
            ? (document.getElementById("ndwiLegend").style.display = "block",
                document.getElementById("ndvilengendmap2").style.display = "none")
            : document.getElementById("ndwiLegend").style.display = "block";

        const ndwiSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: 'CLOUDFREEFALSECOLOR',
                time: date,
                preset: 'CLOUDFREEFALSECOLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        const ndwiRasterSource = new ol.source.Raster({
            sources: [ndwiSource],
            operation: function (pixels, data) {
                if (!data.counts) {
                    data.counts = { Wetlands1: 0, Moist1: 0, Urban1: 0 };
                }

                const [_, nirRaw, greenRaw] = pixels[0];
                const nir = nirRaw / 255;
                const green = greenRaw / 255;
                const ndwi = (green - nir) / (green + nir);

                if (ndwi > 0.3) {
                    data.counts.Wetlands1++;
                    return [0, 0, 255, 255]; // Blue
                } else if (ndwi >= 0) {
                    data.counts.Moist1++;
                    return [0, 255, 0, 255]; // Green
                } else {
                    data.counts.Urban1++;
                    return [255, 165, 0, 255]; // Orange
                }
            }
        });

        if (!rasterListenerAdded) {
            ndwiRasterSource.on('afteroperations', function (event) {
                if (event.data?.counts) {
                    const counts = event.data.counts;
                    const total = counts.Wetlands1 + counts.Moist1 + counts.Urban1;

                    if (total > 0) {
                        const percentages = {
                            Wetlands1: ((counts.Wetlands1 / total) * 100).toFixed(2),
                            Moist1: ((counts.Moist1 / total) * 100).toFixed(2),
                            Urban1: ((counts.Urban1 / total) * 100).toFixed(2)
                        };
                        updateNdviStatsTablenew(percentages);
                    }
                }
            });
            rasterListenerAdded = true;
        }

        return new ol.layer.Image({ source: ndwiRasterSource });
    }

    // =================== EVI Processing ===================
    else if (selectedIndex === "EVI") {
        document.getElementById("ndvi-stats-table").style.display = "block";
        displayMode === "dual"
            ? (document.getElementById("eviLegend").style.display = "block",
                document.getElementById("ndvilengendmap2").style.display = "none")
            : document.getElementById("eviLegend").style.display = "block";

        const eviSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: 'CLOUDFREEFALSECOLOR',
                time: date,
                preset: 'CLOUDFREEFALSECOLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        const eviRasterSource = new ol.source.Raster({
            sources: [eviSource],
            operation: function (pixels, data) {
                if (!data.counts) {
                    data.counts = { Nonvegetated1: 0, Barren1: 0, Shrubland1: 0, Vegetated1: 0 };
                }

                const pixel = pixels[0];
                const nir = pixel[0] / 255;
                const red = pixel[1] / 255;
                const blue = pixel[3] ? pixel[3] / 255 : 0.01;

                const evi = 2.5 * ((nir - red) / ((nir + 6 * red) - (7.5 * blue + 1)));

                if (evi < 0) {
                    data.counts.Nonvegetated1++;
                    return [0, 0, 255, 255];
                } else if (evi < 0.2) {
                    data.counts.Barren1++;
                    return [210, 180, 140, 255];
                } else if (evi < 0.5) {
                    data.counts.Shrubland1++;
                    return [34, 139, 34, 255];
                } else {
                    data.counts.Vegetated1++;
                    return [0, 100, 0, 255];
                }
            }
        });

        if (!rasterListenerAdded) {
            eviRasterSource.on('afteroperations', function (event) {
                if (event.data?.counts) {
                    const counts = event.data.counts;
                    const total = Object.values(counts).reduce((a, b) => a + b, 0);
                    const percentages = Object.fromEntries(
                        Object.entries(counts).map(([k, v]) => [k, ((v / total) * 100).toFixed(2)])
                    );
                    updateNdviStatsTablenew(percentages);
                }
            });
            rasterListenerAdded = true;
        }

        return new ol.layer.Image({ source: eviRasterSource });
    }

    // =================== SAVI Processing ===================
    else if (selectedIndex === "SAVI") {
        document.getElementById("ndvi-stats-table").style.display = "block";
        displayMode === "dual"
            ? (document.getElementById("saviLegend").style.display = "block",
                document.getElementById("ndvilengendmap2").style.display = "none")
            : document.getElementById("saviLegend").style.display = "block";

        const saviSource = new ol.source.TileWMS({
            url: 'https://services.sentinel-hub.com/ogc/wms/' + sentinel2fcckey,
            params: {
                layers: 'CLOUDFREEFALSECOLOR',
                time: date,
                preset: 'CLOUDFREEFALSECOLOR',
                maxcc: 50
            },
            crossOrigin: 'anonymous'
        });

        const saviRasterSource = new ol.source.Raster({
            sources: [saviSource],
            operation: function (pixels, data) {
                if (!data.counts) {
                    data.counts = { Nonvegetated1: 0, Bare_soil1: 0, Vegetated1: 0 };
                }

                const [nirRaw, redRaw] = pixels[0];
                const nir = nirRaw / 255;
                const red = redRaw / 255;
                const L = 0.5;
                const savi = ((nir - red) * (1 + L)) / (nir + red + L);

                if (savi < 0) {
                    data.counts.Nonvegetated1++;
                    return [0, 0, 255, 255];
                } else if (savi < 0.3) {
                    data.counts.Bare_soil1++;
                    return [210, 180, 140, 255];
                } else {
                    data.counts.Vegetated1++;
                    return [34, 139, 34, 255];
                }
            }
        });

        if (!rasterListenerAdded) {
            saviRasterSource.on('afteroperations', function (event) {
                if (event.data?.counts) {
                    const counts = event.data.counts;
                    const total = Object.values(counts).reduce((a, b) => a + b, 0);
                    const percentages = Object.fromEntries(
                        Object.entries(counts).map(([k, v]) => [k, ((v / total) * 100).toFixed(2)])
                    );
                    updateNdviStatsTablenew(percentages);
                }
            });
            rasterListenerAdded = true;
        }

        return new ol.layer.Image({ source: saviRasterSource });
    }

    // =================== Default True Color Layer ===================
    else {
        document.getElementById("ndvi-stats-table").style.display = "none";
        document.getElementById("ndvilengend").style.display = "none";
        document.getElementById("ndvilengendmap2").style.display = "none";

        return new ol.layer.Tile({ source: baseLayerSource });
    }
}


function updateNdviStatsTable(percentages) {

    var tbody = document.querySelector("#ndvi-stats-table tbody");

    tbody.innerHTML = "";

    for (const [category, value] of Object.entries(percentages)) {
        const row = document.createElement("tr");

        const catCell = document.createElement("td");
        catCell.textContent = category;

        const valCell = document.createElement("td");
        valCell.textContent = value;
        //console.log("value : "+value);
        row.appendChild(catCell);
        row.appendChild(valCell);
        tbody.appendChild(row);
    }


}
function updateNdviStatsTablenew(percentages) {

    var tbody = document.querySelector("#ndvi-stats-table1 tbody");

    tbody.innerHTML = "";

    for (const [category, value] of Object.entries(percentages)) {
        const row = document.createElement("tr");

        const catCell = document.createElement("td");
        catCell.textContent = category;

        const valCell = document.createElement("td");
        valCell.textContent = value;
        //console.log("value : "+value);
        row.appendChild(catCell);
        row.appendChild(valCell);
        tbody.appendChild(row);
    }


}

//function updateNdviStatsTable1(percentages) {

//    const tbody = document.querySelector("#ndvi-stats-table1 tbody");
//    tbody.innerHTML = "";

//    for (const [category, value] of Object.entries(percentages)) {
//        const row = document.createElement("tr");

//        const catCell = document.createElement("td");
//        catCell.textContent = category;

//        const valCell = document.createElement("td");
//        valCell.textContent = value;

//        row.appendChild(catCell);
//        row.appendChild(valCell);
//        tbody.appendChild(row);
//    }
//}


//let rasterListenerAdded = false;
//function createSentinelLayer(date) {
//    document.getElementById("key-switcher").style.display = "block";
//    const checkndvi = document.getElementById("ndvi-toggle");
//    const checkcbi = document.getElementById("ndvi-toggle1");
//    const selected = document.querySelector('input[name="sentinel-type"]:checked').value;
//    const mode = document.querySelector('input[name="mode"]:checked').value;

//    const layerName = selected === 'fcc' ? 'CLOUDFREEFALSECOLOR' : '1_TRUE_COLOR';
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
//                layers: 'CLOUDFREEFALSECOLOR',
//                time: date,
//                preset: 'CLOUDFREEFALSECOLOR',
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
//                layers: 'CLOUDFREEFALSECOLOR',
//                time: date,
//                preset: 'CLOUDFREEFALSECOLOR',
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



function changeMode() {
    checkrunningtime = 0;
    var mode = document.getElementById("screenmode").value;
    //alert(mode)
    document.getElementById("date2").style.display = "none"
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
        //document.getElementById('map1').style.width = '100%';
        document.getElementById('map2').style.width = '0%';
        document.getElementById('map2').style.display = 'none';
        map1.updateSize();
        map1.addLayer(zones);
        map1.addOverlay(zones);
        document.getElementById('zonecheck').checked = true;
        document.getElementById('circlecheck').checked = false;
        document.getElementById('divisioncheck').checked = false;
    } else if (mode === 'dual') {
        document.getElementById("date2").style.display = "block";
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
        document.getElementById("date2").style.display = "block";
        //document.getElementById('map1').style.width = '100%';
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
    //checkrunningtime = 0;
    //    const baseDate = document.getElementById('single-date').value;
    //    if (!baseDate) return;
    //    singleDates = generateDateRange(baseDate);
    //    document.getElementById('single-ticks').innerHTML = singleDates.map(d => `<span>${d}</span>`).join('');
    //updateSingleLayer(0);
    const mode = document.getElementById('screenmode').value;

    if (mode === 'single') {
        updateSingleLayer(document.getElementById('single-date').value);
    } else if (mode === 'dual') {
        updateDualLayer(1, document.getElementById('single-date').value);
        updateDualLayer(2, document.getElementById('dual-date2').value);
    } else if (mode === 'swipe') {
        generateSwipeDates();
    }



}

var date;


function updateSingleLayer(index) {
    //date = singleDates[index];
    date = index;
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
    //const isNDVI = document.getElementById('ndvi-toggle').checked;
    //const isCBI = document.getElementById('ndvi-toggle1').checked;
    var selectedindicies = document.getElementById("selectedIndicies");

    if (selectedindicies) {
        selectedindicies = selectedindicies.value;
    }

    //var selectedindicies = document.querySelector('input[name="index"]:checked');
    //if (selectedindicies) {
    //    selectedindicies = selectedindicies.value;
    //}


    if (selectedindicies) {

        if (count == 0) {
            // alert("geoserver");
            cliplayer = createGeoServerLayer(
                lastselectedlayer_vector[lastselectedlayer_vector.length - 1],
                filter
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
    checkrunningtime = 0;
    document.getElementById("key-switcher").style.display = "block";
    const dateInput = document.getElementById(`dual-date${windowNum}`).value;
    if (!dateInput) return;
    const dates = generateDateRange(dateInput);
    document.getElementById(`dual-ticks${windowNum}`).innerHTML = dates.map(d => `<span>${d}</span>`).join('');
    if (windowNum === 1) {
        dualDates1 = dates;
        updateDualLayer(1, document.getElementById("dual-date2").value);
    } else {
        dualDates2 = dates;
        updateDualLayer(2, document.getElementById("dual-date2").value);
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
    document.getElementById("id_legendsection2").style.display = "block";
    const dates = windowNum === 1 ? dualDates1 : dualDates2;
    //const date = dates[index];
    const date = index;


    if (!date) return;

    const map = windowNum === 1 ? map1 : map2;
    // alert("for map : " + map);
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
    var baseLayer
    //  alert(windowNum);
    if (windowNum == 1) {
        baseLayer = createSentinelLayer(date);
    } else {
        baseLayer = createSentinelLayernew(date);
    }


    map.addLayer(baseLayer);

    // Store reference
    if (windowNum === 1) {
        sentinelLayer1 = baseLayer;
    } else {
        sentinelLayer2 = baseLayer;
    }
    var vectorMaskLayer;
    // NDVI logic
    const isNDVI = document.getElementById('selectedIndicies').value;
    if (isNDVI) {
        const ndviLayer = createNDVILayer(date);

        map.addLayer(ndviLayer);


        if (count == 0) {
            //alert("geoserver");
            cliplayer = createGeoServerLayer(
                lastselectedlayer_vector[lastselectedlayer_vector.length - 1],
                filter
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
    const date1 = document.getElementById('single-date').value;
    const date2 = document.getElementById('dual-date2').value;
    // alert(date1 + " -- " + date2);
    //const date1 = document.getElementById('swipe-date1').value;
    //const date2 = document.getElementById('swipe-date2').value;
    if (!date1 || !date2) return;
    if (date1 != "" && date2 != "") {
        document.getElementById("swipe").style.display = "block";
    } else {
        document.getElementById("swipe").style.display = "none";
    }
    // Clear all layers
    map1.getLayers().clear();
    map1.addLayer(new ol.layer.Tile({ source: new ol.source.OSM() }));

    // --- Sentinel Swipe Layers ---
    swipeLayer1 = createSentinelLayer(date1);
    swipeLayer2 = createSentinelLayernew(date2);
    document.getElementById("ndvi-stats-table1").style.display = "block";
    document.getElementById("id_legendsection2").style.display = "block";

    //swipeLayer1.setZIndex(0);
    //swipeLayer2.setZIndex(0);

    swipeLayer1.on('precompose', applySwipeClipLeft);
    swipeLayer2.on('precompose', applySwipeClipRight);
    swipeLayer1.on('postcompose', clearClip);
    swipeLayer2.on('postcompose', clearClip);

    map1.addLayer(swipeLayer1);
    map1.addLayer(swipeLayer2);

    // --- NDVI + Vector Mask ---
    const isNDVI = document.getElementById('selectedIndicies').value;

    if (isNDVI != "") {
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
                filter
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
    //const mode = document.querySelector('input[name="mode"]:checked').value;

    const mode = document.getElementById('screenmode').value;

    if (mode === 'single') {
        updateSingleLayer(document.getElementById('single-range').value);
    } else if (mode === 'dual') {
        updateDualLayer(1, document.getElementById('single-date').value);
        updateDualLayer(2, document.getElementById('dual-date2').value);
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
    var vectorSource = new ol.source.Vector({ features });
    var vectorLayer = new ol.layer.Vector({
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
        // console.log(maskLayer);
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
            var datatype = document.getElementById("datatypeid").value;


            if (datatype == "slope") {
                features.forEach(function (feature) {
                    const geometry = feature.getGeometry();
                    if (geometry) {
                        getSlopeValuesInsidePolygon(geometry);
                    }
                });
            } else if (datatype == "soil") {
                features.forEach(function (feature) {
                    const geometry = feature.getGeometry();
                    if (geometry) {
                        getSoilInsidePolygon(geometry);
                    }
                });
            }
            //if (datatype == "slop") {
            //    alert(datatype);
            //    console.log(features.getGeometry())
            //    if (features.getGeometry()) {
            //        getSlopeValuesInsidePolygon(features.getGeometry());
            //    }

            //} else if (datatype == "soil") {
            //    getSoilInsidePolygon(feature.getGeometry());
            //}


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
    //const checkbox = document.getElementById('ndvi-toggle');
    const checkbox = document.getElementById('selectedIndicies').value;
    if (!uploadedFeatures) return;

    if (checkbox != "") {
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
    const startDate = "2022-01-01";
    const endDate = "2025-09-15";
    var selectedindicies = document.getElementById("selectedIndicies").value;


    features.forEach(feature => {
        const geom = feature.getGeometry();
        if (geom instanceof ol.geom.Polygon) {
            let coords = geom.getCoordinates()[0].slice();
            if (ringIsClockwise(coords)) coords.reverse();
            holes.push(coords);
            if (selectedindicies == "NDVI") {
                var latloninepsg = transformCoordsToLonLat(coords);

                fetchNdviForPolygon(startDate, endDate, latloninepsg);

            }

        } else if (geom instanceof ol.geom.MultiPolygon) {
            geom.getCoordinates().forEach(polygon => {
                let coords = polygon[0].slice();
                if (ringIsClockwise(coords)) coords.reverse();
                holes.push(coords);
                if (selectedindicies == "NDVI") {
                    var latloninepsg = transformCoordsToLonLat(coords);

                    fetchNdviForPolygon(startDate, endDate, latloninepsg);

                }
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

function transformCoordsToLonLat(coords) {
    const transformed = coords.map(coord => {
        const [lon, lat] = ol.proj.transform(coord, 'EPSG:3857', 'EPSG:4326');
        return [
            +lon.toFixed(6),
            +lat.toFixed(6)
        ];
    });

    return transformed; // return as an actual array
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
    
    window.location.reload(true);
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
    const layerName = type === 'fcc' ? 'CLOUDFREEFALSECOLOR' : '1_TRUE_COLOR';
    const key = type === 'fcc' ? sentinel2fcckey : sentinel2ncckey;

    var rangeInput = document.getElementById('single-range');
    //console.log(rangeInput.value);
    //console.log(singleDates);
    rangeInput = singleDates[rangeInput.value];
    // console.log(rangeInput);

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
    var level = document.getElementById("ContentPlaceHolder1_ddllevel").value;
    var section = document.getElementById("ContentPlaceHolder1_ddlsection").value;
    var filterParts = [];
    if (level != "Select") {
        filterParts.push("" + level + " = '" + section + "'");
    }


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

    var ddlsection = document.getElementById("ContentPlaceHolder1_ddlsection").value;
    var datatypeid = document.getElementById("datatypeid").value;

    if (
        ddlsection.trim() !== "" &&
        ddlsection.trim() !== "All" &&
        datatypeid.trim().toLowerCase() !== "" &&
        datatypeid.trim().toLowerCase() !== "sentinel2"
    ) {
        btnstat.style.display = "block";
    } else {
        btnstat.style.display = "none";
    }
}

let vectorLayer;
var testfeaturew;
async function loadFilteredFeature(layername, value) {
    const layernamebuild = "tbl_" + layername + "_master";
    lastselectedlayer_vector.pop(layernamebuild);
    if (!vectorLayer) {
        vectorLayer = new ol.layer.Vector({
            source: new ol.source.Vector(),
            style: new ol.style.Style({
                stroke: new ol.style.Stroke({
                    color: '#ff77ff',
                    width: 3
                }),
                fill: new ol.style.Fill({
                    color: 'rgba(255,0,0,0.01)'
                })
            }),
            zIndex: 1000
        });
        console.log(vectorLayer);
        lastselectedlayer_vector.pop(layernamebuild);
        map1.addLayer(vectorLayer);
        map1.addOverlay(vectorLayer);

        map2.addLayer(vectorLayer);
        map2.addOverlay(vectorLayer);
    }
    lastselectedlayer_vector.push(layernamebuild);
    filter = `${layername} ILIKE '${value}'`;
    const wfsUrl = 'https://ukforestgis.in/geoserver/uk_sfd/ows';
    const params = new URLSearchParams({
        service: 'WFS',
        version: '1.1.0',
        request: 'GetFeature',
        typeName: layernamebuild,
        outputFormat: 'application/json',
        CQL_FILTER: filter
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
            document.getElementById("btngetstat").style.display = "none";
            return;
        } else {
            var sle = document.getElementById("datatypeid").value;
            if (sle !== "") {
                document.getElementById("btngetstat").style.display = "block";
            } else {
                document.getElementById("btngetstat").style.display = "none";
            }


        }
        //features.forEach(function (feature) {
        //    const geometry = feature.getGeometry();
        //    if (geometry) {
        //        alert(geometry);
        //    }
        //});
        source.addFeatures(features);
        testfeaturew = features;
        const extent = source.getExtent();
        map1.getView().fit(extent, { duration: 1000, padding: [40, 40, 40, 40] });
        map1.getView().fit(extent, { duration: 1000, padding: [40, 40, 40, 40] });

    } catch (err) {
        console.error('Error loading WFS data:', err);
        alert('Failed to load data.');
    }
}



function getfeatures() {
    console.log(vectorLayer);
    var datatype = document.getElementById("datatypeid").value;

    console.log(datatype);
    if (datatype == "slope") {

        testfeaturew.forEach(function (feature) {
            const geometry = feature.getGeometry();
            if (geometry) {
                getSlopeValuesInsidePolygon(geometry);
            }
        });
    } else if (datatype == "soil") {

        testfeaturew.forEach(function (feature) {
            const geometry = feature.getGeometry();
            if (geometry) {
                getSoilInsidePolygon(geometry);
            }
        });
    } else if (datatype == "dtm") {

        testfeaturew.forEach(function (feature) {
            const geometry = feature.getGeometry();
            if (geometry) {
                getElevationValuesInsidePolygon(feature);
            }
        });
    } else {
        alert("Choose correct option !!!");
    }
}
//////////////////////////////////////////////////////////////////////



//document.getElementById('slopeCheckbox').addEventListener('change', function () {
//    if (this.checked) {
//        SlopeTool.enable();
//    } else {
//        SlopeTool.disable();
//    }
//});




//const SlopeTool = {
//    init(map) {
//        this.map = map;

//        this.vectorSource = new ol.source.Vector();
//        this.vectorLayer = new ol.layer.Vector({
//            source: this.vectorSource,
//            style: new ol.style.Style({
//                fill: new ol.style.Fill({ color: 'rgba(0, 0, 255, 0.3)' }),
//                stroke: new ol.style.Stroke({ color: '#0000ff', width: 2 }),
//            }),
//        });

//        this.wmsLayer = new ol.layer.Tile({
//            source: new ol.source.TileWMS({
//                url: 'https://ukforestgis.in/geoserver/uk_sfd/wms',
//                params: {
//                    'LAYERS': 'uk_sfd:Slope_Geo',
//                    'TILED': true,
//                    'VERSION': '1.1.0',
//                    'FORMAT': 'image/png',
//                    'STYLES': '',
//                    'SRS': 'EPSG:3857'
//                },
//                serverType: 'geoserver',
//                crossOrigin: 'anonymous'
//            })
//        });

//        this.draw = new ol.interaction.Draw({
//            source: this.vectorSource,
//            type: 'Polygon'
//        });

//        this.modify = new ol.interaction.Modify({ source: this.vectorSource });
//        this.select = new ol.interaction.Select({ layers: [this.vectorLayer] });

//        this.spinner = document.getElementById('slopeLoadingSpinner');
//        this.info = document.getElementById('slopeInfo');

//        this.setupEvents();
//    },

//    setupEvents() {
//        this.draw.on('drawstart', () => this.setInfo('Drawing polygon...'));
//        this.draw.on('drawend', () => this.setInfo('Polygon drawn. Click it to classify.'));

//        this.select.on('select', e => {
//            if (!e.selected.length) return;
//            const feature = e.selected[0];
//            this.showSpinner();
//            this.setInfo('Classifying slope...');
//            setTimeout(() => {
//                const html = this.classifySlope(feature);
//                this.hideSpinner();
//                this.setInfo(html);
//            }, 100);
//        });
//    },

//    enable() {
//        this.map.addLayer(this.wmsLayer);
//        this.map.addLayer(this.vectorLayer);
//        this.map.addInteraction(this.draw);
//        this.map.addInteraction(this.modify);
//        this.map.addInteraction(this.select);
//        this.setInfo('Slope classification enabled. Draw a polygon.');
//    },

//    disable() {
//        this.map.removeLayer(this.wmsLayer);
//        this.map.removeLayer(this.vectorLayer);
//        this.map.removeInteraction(this.draw);
//        this.map.removeInteraction(this.modify);
//        this.map.removeInteraction(this.select);
//        this.vectorSource.clear();
//        this.setInfo('Slope classification disabled.');
//    },

//    showSpinner() {
//        if (this.spinner) this.spinner.style.display = 'block';
//    },

//    hideSpinner() {
//        if (this.spinner) this.spinner.style.display = 'none';
//    },

//    setInfo(msg) {
//        if (this.info) this.info.innerHTML = msg;
//    },

//    classifySlope(feature) {
//        const geom = feature.getGeometry();
//        const coords = geom.getCoordinates();
//        if (!coords || coords.length === 0) return 'Invalid polygon';

//        const lonLatCoords = coords.map(ring =>
//            ring.map(coord => ol.proj.toLonLat(coord))
//        );

//        const ring = lonLatCoords[0];
//        if (
//            ring.length > 2 &&
//            (ring[0][0] !== ring[ring.length - 1][0] ||
//                ring[0][1] !== ring[ring.length - 1][1])
//        ) {
//            ring.push(ring[0]);
//        }

//        let turfPoly;
//        try {
//            turfPoly = turf.polygon([ring]);
//        } catch (e) {
//            return 'Failed to process polygon.';
//        }

//        const area = turf.area(turfPoly);
//        const spacingKm = 0.03;
//        if (area > 20000000) return 'Polygon too large. Draw a smaller one.';

//        const bbox = turf.bbox(turfPoly);
//        const grid = turf.pointGrid(bbox, spacingKm, { units: 'kilometers' });
//        const inside = grid.features.filter(pt => turf.booleanPointInPolygon(pt, turfPoly));
//        if (!inside.length) return 'No points inside polygon.';

//        const coordsGrid = inside.map(p => p.geometry.coordinates);
//        const elevations = inside.map(() => 100 + Math.random() * 300);

//        const bboxWidthKm = turf.distance(
//            turf.point([bbox[0], bbox[1]]),
//            turf.point([bbox[2], bbox[1]]),
//            { units: 'kilometers' }
//        );
//        const gridWidth = Math.round(bboxWidthKm / spacingKm) + 1;

//        const slopes = [];
//        for (let i = 0; i < coordsGrid.length; i++) {
//            const neighbors = [];
//            if ((i + 1) % gridWidth !== 0 && i + 1 < coordsGrid.length) neighbors.push(i + 1);
//            if (i + gridWidth < coordsGrid.length) neighbors.push(i + gridWidth);

//            let totalSlope = 0;
//            neighbors.forEach(j => {
//                const d = turf.distance(turf.point(coordsGrid[i]), turf.point(coordsGrid[j]), { units: 'meters' });
//                const dz = Math.abs(elevations[i] - elevations[j]);
//                const angle = Math.atan(dz / d) * (180 / Math.PI);
//                totalSlope += angle;
//            });
//            slopes[i] = neighbors.length ? totalSlope / neighbors.length : 0;
//        }

//        //const categories = {
//        //    '0–5°': 0, '5–15°': 0, '15–30°': 0, '30–45°': 0,
//        //'45–60°': 0, '60–75°': 0, '75–90°': 0
//        //};

//        //slopes.forEach(s => {
//        //  if (s < 5) categories['0–5°']++;
//        //else if (s < 15) categories['5–15°']++;
//        //else if (s < 30) categories['15–30°']++;
//        //else if (s < 45) categories['30–45°']++;
//        //else if (s < 60) categories['45–60°']++;
//        //else if (s < 75) categories['60–75°']++;
//        //else categories['75–90°']++;
//        //});
//        const categories = {
//            'Flat to Gentle (0–5°)': 0,
//            'Moderate (5–15°)': 0,
//            'Steep (15–30°)': 0,
//            'Very Steep (30–45°)': 0,
//            'Extreme/Cliff (>45°)': 0
//        };

//        slopes.forEach(s => {
//            if (s < 5) categories['Flat to Gentle (0–5°)']++;
//            else if (s < 15) categories['Moderate (5–15°)']++;
//            else if (s < 30) categories['Steep (15–30°)']++;
//            else if (s < 45) categories['Very Steep (30–45°)']++;
//            else categories['Extreme/Cliff (>45°)']++;
//        });


//        let html = `<b>Slope Classification</b><br>`;
//        html += `Pixel size: ${(spacingKm * 1000).toFixed(0)} m<br>`;
//        html += `Pixels analyzed: ${slopes.length}<ul>`;
//        for (let cat in categories) {
//            html += `<li><b>${cat}</b>: ${categories[cat]}</li>`;
//        }
//        html += '</ul>';
//        return html;
//    }
//};

//SlopeTool.init(map1);


/////////////// soil function ///////////////////////


const rasterLabels = { 1: "Loamy", 2: "Sandy", 3: "Snow", 4: "Clay" };
const rasterColors = { 1: "brown", 2: "yellow", 3: "pink", 4: "gray" };

// WMS layer with color-coded raster using SLD_BODY
//const wmsLayer = new ol.layer.Image({
//    source: new ol.source.TileWMS({
//        url: 'https://ukforestgis.in/geoserver/uk_sfd/wms',
//        params: {
//            'LAYERS': 'uk_sfd:GCS_Soil_Type_Uttaranchal',
//            'FORMAT': 'image/png',
//            'VERSION': '1.3.0',
//            'SLD_BODY': `
//    <StyledLayerDescriptor version="1.0.0">
//      <NamedLayer>
//        <Name>uk_sfd:GCS_Soil_Type_Uttaranchal</Name>
//        <UserStyle>
//          <FeatureTypeStyle>
//            <Rule>
//              <RasterSymbolizer>
//                <ColorMap type="values">
//                  <ColorMapEntry color="#A52A2A" quantity="1" label="Loamy"/>
//                  <ColorMapEntry color="#FFFF00" quantity="2" label="Sandy"/>
//                  <ColorMapEntry color="#FFC0CB" quantity="3" label="Snow"/>
//                  <ColorMapEntry color="#808080" quantity="4" label="Clay"/>
//                </ColorMap>
//              </RasterSymbolizer>
//            </Rule>
//          </FeatureTypeStyle>
//        </UserStyle>
//      </NamedLayer>
//    </StyledLayerDescriptor>
//  `
//        },
//        ratio: 1,
//        crossOrigin: 'anonymous'
//    })
//});

// Base map
//const osm = new ol.layer.Tile({ source: new ol.source.OSM() });

// Polygon vector layer
//var vectorSource = new ol.source.Vector();
//var vectorLayer = new ol.layer.Vector({
//    source: vectorSource,
//    style: new ol.style.Style({
//        stroke: new ol.style.Stroke({ color: 'red', width: 2 }),
//        fill: new ol.style.Fill({ color: 'rgba(255,0,0,0.2)' })
//    })
//});

// Map
//const map = new ol.Map({
//    target: 'map',
//    layers: [osm, wmsLayer, vectorLayer],
//    view: new ol.View({
//        center: [79.0, 29.8],
//        zoom: 10,
//        projection: 'EPSG:4326'
//    })
//});

// Helper to parse numeric raster value
function parseRasterValue(text) {
    const m = text.match(/[-+]?[0-9]*\.?[0-9]+/);
    return m ? Math.round(Number(m[0])) : null;
}

// Click to get soil type
//map1.on('singleclick', function (evt) {
//    const view = map1.getView();
//    const resolution = view.getResolution();
//    const url = wmsLayer.getSource().getFeatureInfoUrl(
//        evt.coordinate, resolution, 'EPSG:4326',
//        { INFO_FORMAT: 'text/plain', FEATURE_COUNT: 1 }
//    );
//    if (url) {
//        fetch(url).then(r => r.text()).then(text => {
//            const val = parseRasterValue(text);
//            const label = rasterLabels[val] ?? "N/A";
//            document.getElementById('info').innerHTML = `<b>Soil type:</b> ${label}`;
//        }).catch(err => {
//            document.getElementById('info').innerText = "Error: " + err;
//        });
//    }
//});

// Draw polygon to get soil types inside
var vectorLayerforsoil;
const vectorSourceforsoil = new ol.source.Vector();
vectorLayerforsoil = new ol.layer.Vector({
    source: vectorSourceforsoil,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({ color: '#ff77ff', width: 3 }),
        fill: new ol.style.Fill({ color: 'rgba(255,0,0,0.1)' })
    })
});
map1.addLayer(vectorLayerforsoil);
map1.addOverlay(vectorLayerforsoil);
let drawInteractionforsoil;
document.getElementById('drawPolygon').addEventListener('change', function () {
    if (this.checked) {
        drawInteractionforsoil = new ol.interaction.Draw({
            source: vectorSourceforslop,   // <-- ✅ saves drawn polygon
            type: 'Polygon'
        });
        map1.addInteraction(drawInteractionforsoil);

        drawInteractionforsoil.on('drawend', evt => {
            map1.removeInteraction(drawInteractionforsoil);
            this.checked = false;

            // feature is already stored in vectorSource
            const feature = evt.feature;
            getSoilInsidePolygon(feature.getGeometry());
        });
    } else if (drawInteractionforsoil) {
        map1.removeInteraction(drawInteractionforsoil);
    }
});







//document.getElementById('drawPolygon').addEventListener('change', function () {
//    if (this.checked) {
//        draw = new ol.interaction.Draw({ source: vectorSource, type: 'Polygon' });
//        map1.addInteraction(draw);
//        draw.on('drawend', function (evt) {
//            map1.removeInteraction(draw);
//            document.getElementById('drawPolygon').checked = false;
//            getSoilInsidePolygon(evt.feature.getGeometry());
//        });
//    } else {
//        if (draw) map1.removeInteraction(draw);
//    }
//});

// Get unique soil types inside polygon

async function getSoilInsidePolygon(polygon) {
    const view = map1.getView();
    const resolution = view.getResolution();
    const projection = view.getProjection(); // EPSG:4326
    const extent = polygon.getExtent();
    const step = (extent[2] - extent[0]) / 25;
    const values = new Set();

    document.getElementById('loader').style.display = 'block';
    document.getElementById('info').innerHTML = "Fetching soil types…";

    for (let x = extent[0]; x <= extent[2]; x += step) {
        for (let y = extent[1]; y <= extent[3]; y += step) {
            const coord = [x, y];
            if (polygon.intersectsCoordinate(coord)) {
                const url = soil_layer.getSource().getGetFeatureInfoUrl(
                    coord, resolution, projection.getCode(),
                    { INFO_FORMAT: 'text/plain', FEATURE_COUNT: 1 }
                );
                if (!url) continue;
                try {
                    const text = await fetch(url).then(r => r.text());
                    /* console.log(`GFI at ${coord}:`, text);*/
                    const val = parseRasterValue(text);
                    if (val !== null) values.add(val);
                } catch (err) {
                    console.error('Error querying GFI:', err);
                }
            }
        }
    }

    document.getElementById('loader').style.display = 'none';
    const infoEl = document.getElementById('info');
    if (values.size === 0) {
        infoEl.innerHTML = "<b>Soil type inside polygon:</b><br>No soil types found.";
    } else {
        infoEl.innerHTML = "<b>Soil type inside polygon:</b><br>" +
            Array.from(values).sort((a, b) => a - b).map((v, i) => {
                const label = rasterLabels[v] || v;
                const color = rasterColors[v] || 'transparent';
                return `${i + 1}. <span class="color-box" style="background:${color}"></span>${label}`;
            }).join('<br>');
    }
}
//async function getSoilInsidePolygon(polygon) {
//    const view = map1.getView();
//    const resolution = view.getResolution();
//    const projection = view.getProjection(); // should be EPSG:4326
//    const extent = polygon.getExtent();
//    const step = (extent[2] - extent[0]) / 25; // grid step for sampling
//    const values = new Set();

//    document.getElementById('loader').style.display = 'block';
//    document.getElementById('info').innerHTML = "Fetching soil types…";

//    for (let x = extent[0]; x <= extent[2]; x += step) {
//        for (let y = extent[1]; y <= extent[3]; y += step) {
//            const coord = [x, y];

//            if (polygon.intersectsCoordinate(coord)) {
//                // Use the same projection consistently
//                const url = soil_layer.getSource().getFeatureInfoUrl(
//                    coord,
//                    resolution,
//                    projection.getCode(), // 'EPSG:4326' assumed
//                    {
//                        INFO_FORMAT: 'text/plain',
//                        FEATURE_COUNT: 1
//                    }
//                );

//                if (url) {
//                    try {
//                        const response = await fetch(url);
//                        const text = await response.text();
//                        console.log("Response at", coord, ":", text);

//                        const val = parseRasterValue(text);
//                        if (val !== null && val !== undefined) {
//                            values.add(val);
//                        }
//                    } catch (err) {
//                        console.error("Error fetching GetFeatureInfo at", coord, err);
//                    }
//                }
//            }
//        }
//    }

//    document.getElementById('loader').style.display = 'none';

//    let html = "<b>Soil type inside polygon:</b><br>";
//    if (values.size === 0) {
//        html += "No soil types found.";
//    } else {
//        Array.from(values).sort((a, b) => a - b).forEach((v, i) => {
//            const label = rasterLabels[v] ?? v;
//            const color = rasterColors[v] ?? "transparent";
//            html += `${i + 1}. <span style="display:inline-block;width:20px;height:20px;background:${color};margin-right:6px;border:1px solid #000;"></span>${label}<br>`;
//        });
//    }

//    document.getElementById('info').innerHTML = html;
//}

///////////////////////////layers 
let isVisible = false;
function togglePanellayer() {
    const panel = document.getElementById('slidingDiv');

    if (!isVisible) {
        panel.style.display = 'block';
        setTimeout(() => {
            panel.classList.add('show');
        }, 10);
        isVisible = true;
    } else {
        panel.classList.remove('show');
        setTimeout(() => {
            panel.style.display = 'none';
        }, 400); // matches transition duration
        isVisible = false;
    }
}


//////////////// slop stat calculation 
function parseRasterValue(text) {
    const m = text.match(/[-+]?[0-9]*\.?[0-9]+/);
    return m ? parseFloat(m[0]) : null;
}

//let drawInteraction;
//document.getElementById('drawPolygonforslop').addEventListener('change', function () {
//    if (this.checked) {
//        drawInteraction = new ol.interaction.Draw({ source: vectorSource, type: 'Polygon' });
//        map1.addInteraction(drawInteraction);
//        drawInteraction.on('drawend', evt => {
//            map1.removeInteraction(drawInteraction);
//            this.checked = false;
//            getSlopeValuesInsidePolygon(evt.feature.getGeometry());
//        });
//    } else if (drawInteraction) {
//        map1.removeInteraction(drawInteraction);
//    }
//});
const vectorSourceforslop = new ol.source.Vector();
const vectorLayerforslop = new ol.layer.Vector({
    source: vectorSourceforslop,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({ color: '#ff77ff', width: 3 }),
        fill: new ol.style.Fill({ color: 'rgba(255,0,0,0.1)' })
    })
});
map1.addLayer(vectorLayerforslop);
map1.addOverlay(vectorLayerforslop);

let drawInteraction;
document.getElementById('drawPolygonforslop').addEventListener('change', function () {
    if (this.checked) {
        drawInteraction = new ol.interaction.Draw({
            source: vectorSourceforslop,   // <-- ✅ saves drawn polygon
            type: 'Polygon'
        });
        map1.addInteraction(drawInteraction);

        drawInteraction.on('drawend', evt => {
            map1.removeInteraction(drawInteraction);
            this.checked = false;

            // feature is already stored in vectorSource
            const feature = evt.feature;
            getSlopeValuesInsidePolygon(feature.getGeometry());
        });
    } else if (drawInteraction) {
        map1.removeInteraction(drawInteraction);
    }
});

async function getSlopeValuesInsidePolygon(polygon) {
    console.log("----------------------:::::::::::::" + polygon);
    const view = map1.getView();
    const resolution = view.getResolution();
    const projection = view.getProjection();
    const extent = polygon.getExtent();
    const step = (extent[2] - extent[0]) / 30;
    const values = [];
    // alert("called");
    document.getElementById('loader').style.display = 'block';
    document.getElementById('infoforslop').innerHTML = "Fetching slope values…";

    for (let x = extent[0]; x <= extent[2]; x += step) {
        for (let y = extent[1]; y <= extent[3]; y += step) {
            const coord = [x, y];
            if (polygon.intersectsCoordinate(coord)) {
                const url = sloplayer.getSource().getGetFeatureInfoUrl(
                    coord,
                    resolution,
                    projection.getCode(),
                    {
                        INFO_FORMAT: 'text/plain',
                        FEATURE_COUNT: 1
                    }
                );
                if (!url) continue;
                try {
                    const text = await fetch(url).then(r => r.text());
                    const val = parseRasterValue(text);
                    if (val !== null) values.push(val);
                } catch (err) {
                    console.error('GFI error:', err);
                }
            }
        }
    }

    document.getElementById('loader').style.display = 'none';
    const infoEl = document.getElementById('infoforslop');
    const slopeClasses = [
        { range: [0, 10], label: "Flat to Gentle (0–10°)", color: "#6BBE44" },
        { range: [10, 20], label: "Moderate (10–20°)", color: "#E5F94E" },
        { range: [20, 30], label: "Steep (20–30°)", color: "#FDC84E" },
        { range: [30, 45], label: "Very Steep (30–45°)", color: "#F57C20" },
        { range: [45, 88], label: "Extreme Cliff (45–88°)", color: "#FF0000" }
    ];
    if (values.length === 0) {
        infoEl.innerHTML = "<b>Slope inside polygon:</b><br>No values found.";
        return;
    }

    const min = Math.min(...values).toFixed(2);
    const max = Math.max(...values).toFixed(2);
    const avg = (values.reduce((a, b) => a + b, 0) / values.length).toFixed(2);

    const counts = slopeClasses.map(c => ({
        ...c,
        count: values.filter(v => v >= c.range[0] && v < c.range[1]).length
    }));

    let html = `
        <b>Slope Statistics (degrees):</b><br>
        Min: ${min}<br>
        Max: ${max}<br>
        Mean: ${avg}<br>
       <br>
        <b>Class Breakdown:</b><br>
      `;

    counts.forEach(c => {
        const perc = ((c.count / values.length) * 100).toFixed(1);
        html += `<div style="margin:3px 0;">
          <span style="display:inline-block;width:20px;height:12px;background:${c.color};border:1px solid #333;margin-right:6px;"></span>
          ${c.label}:(${perc}%)
        </div>`;
    });

    infoEl.innerHTML = html;
}




const vectorSourcefordtm = new ol.source.Vector();
const vectorLayerfordtm = new ol.layer.Vector({
    source: vectorSourcefordtm,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({ color: '#ff77ff', width: 3 }),
        fill: new ol.style.Fill({ color: 'rgba(255,0,0,0.1)' })
    })
});
document.getElementById('drawPolygonfordtm').addEventListener('change', function () {
    if (this.checked) {
        drawInteraction = new ol.interaction.Draw({
            source: vectorSourcefordtm,   // <-- ✅ saves drawn polygon
            type: 'Polygon'
        });
        map1.addInteraction(drawInteraction);

        drawInteraction.on('drawend', evt => {
            map1.removeInteraction(drawInteraction);
            this.checked = false;

            // feature is already stored in vectorSource
            const feature = evt.feature;
            getElevationValuesInsidePolygon(feature);
        });
    } else if (drawInteraction) {
        map1.removeInteraction(drawInteraction);
    }
});


async function getElevationValuesInsidePolygon(feature) {
    const infoElev = document.getElementById('infofordtm');
    document.getElementById('loader').style.display = 'block';
    infoElev.innerHTML = 'Fetching elevation values…';

    const geom = feature.getGeometry();
    const extent = geom.getExtent();
    const step = (extent[2] - extent[0]) / 30;

    const values = [];

    const view = map1.getView();
    const projection = view.getProjection();
    const resolution = view.getResolution();

    for (let x = extent[0]; x <= extent[2]; x += step) {
        for (let y = extent[1]; y <= extent[3]; y += step) {
            const coord = [x, y];
            if (geom.intersectsCoordinate(coord)) {
                const url = dtmlayer.getSource().getGetFeatureInfoUrl(
                    coord,
                    resolution,
                    projection.getCode(),
                    {
                        INFO_FORMAT: 'text/plain',
                        FEATURE_COUNT: 1
                    }
                );

                if (!url) continue;

                try {
                    const text = await fetch(url).then(r => r.text());
                    const val = parseRasterValue(text);  // You must define this function
                    if (val !== null && !isNaN(val)) {
                        values.push(val);
                    }
                } catch (err) {
                    console.error('GFI error:', err);
                }
            }
        }
    }

    document.getElementById('loader').style.display = 'none';
    // alert(values.length);
    if (values.length === 0) {
        return `<b>Elevation inside polygon:</b><br>No values found.`;
    }

    document.getElementById("infofordtmmain").style.display = "block";
    // Stats
    const min = Math.min(...values);
    const max = Math.max(...values);
    const mean = values.reduce((a, b) => a + b, 0) / values.length;

    const classes = [
        { range: [-Infinity, 500], label: "Very Low (≤500m)", color: "#2b83ba" },
        { range: [500, 1000], label: "Low‐Moderate (500–1000m)", color: "#abdda4" },
        { range: [1000, 2000], label: "Moderate‐High (1000–2000m)", color: "#ffffbf" },
        { range: [2000, 3000], label: "High (2000–3000m)", color: "#fdae61" },
        { range: [3000, Infinity], label: "Very High (>3000m)", color: "#d7191c" }
    ];

    const counts = classes.map(c => {
        const count = values.filter(v => v >= c.range[0] && v < c.range[1]).length;
        return { ...c, count };
    });

    let html = `<b>Elevation Statistics:</b><br>`;
    html += `Min: ${min.toFixed(2)} m<br>`;
    html += `Max: ${max.toFixed(2)} m<br>`;
    html += `Mean: ${mean.toFixed(2)} m<br>`;
    html += `<br><b>Elevation Classes Breakdown:</b><br><ul style="list-style:none; padding-left:0;">`;

    counts.forEach(c => {
        const percent = ((c.count / values.length) * 100).toFixed(1);
        html += `<li>
            <span style="display:inline-block;width:16px;height:16px;background:${c.color};margin-right:6px;"></span>
            ${c.label}: (${percent}%)
        </li>`;
    });

    html += `</ul>`;
    infoElev.innerHTML = html;


}

function parseElevationFromResponse(text) {
    // The response is plain text, try to extract the first number from it
    // Usually it's just a number or "no data"
    const match = text.match(/-?\d+(\.\d+)?/);
    if (match) {
        return parseFloat(match[0]);
    }
    return null;
}

/////////// on data select change

function getdatatype(val) {
    try {
        var btnstat = document.getElementById("btngetstat");
        var ddlsection = document.getElementById("ContentPlaceHolder1_ddlsection").value;
        var datatypeid = document.getElementById("datatypeid").value;
        checkrunningtime = 0;
        map1.removeLayer(sloplayer);
        map1.removeLayer(soil_layer);

        map1.removeLayer(sentinelLayer1);
        map1.removeOverlay(sentinelLayer1);
        map2.removeLayer(sentinelLayer1);
        map2.removeOverlay(sentinelLayer1);
        map1.removeLayer(dtmlayer);

        document.getElementById("selectedIndicies").disabled = true;
        document.getElementById("single-date").disabled = true;
        document.getElementById("dual-date2").disabled = true;
        document.getElementById("single-date").value = '';
        document.getElementById("id_drawPolygonforsoil").style.display = "none";
        document.getElementById("id_drawPolygonforslop").style.display = "none";
        document.getElementById("id_drawPolygonfordtm").style.display = "none";

        document.getElementById("infoforslopmain").style.display = "none";
        document.getElementById("infofordtmmain").style.display = "none";
        document.getElementById("key-switcher").style.display = "none";
        document.getElementById("div_slope").style.display = "none";
        btnstat.style.display = "none";
        if (val.value != "") {

            if (
                ddlsection.trim() !== "" &&
                ddlsection.trim() !== "All" &&
                datatypeid.trim().toLowerCase() !== "" &&
                datatypeid.trim().toLowerCase() !== "sentinel2"
            ) {
                btnstat.style.display = "block";
            } else {
                btnstat.style.display = "none";
            }


            if (val.value == "slope") {
                document.getElementById("id_drawPolygonforslop").style.display = "block";
                document.getElementById("infoforslopmain").style.display = "block";
                map1.addLayer(sloplayer);
                document.getElementById("div_slope").style.display = "block";

            } else if (val.value == "sentinel2") {
                document.getElementById("selectedIndicies").disabled = false;
                document.getElementById("single-date").disabled = false;
                document.getElementById("dual-date2").disabled = false;


            } else if (val.value == "soil") {
                document.getElementById("id_drawPolygonforsoil").style.display = "block";
                document.getElementById("soilinfodivmain").style.display = "block";
                map1.addLayer(soil_layer);

            } else if (val.value == "dtm") {
                document.getElementById("id_drawPolygonfordtm").style.display = "block";
                document.getElementById("drawPolygonfordtm").style.display = "block";
                document.getElementById("infofordtmmain").style.display = "block";
                map1.addLayer(dtmlayer);

            }

        } else {

        }
    } catch (e) {
        alert(e)
    }
}


//////////////////////////////////////////////////////
const modeSelect = document.getElementById('screenmode');
const optionSelect = document.getElementById('datatypeid');

const allOptions = Array.from(optionSelect.options);

modeSelect.addEventListener('change', () => {
    const mode = modeSelect.value;

    // Clear all options
    optionSelect.innerHTML = '';

    // Always add "Select" placeholder first
    const placeholder = allOptions.find(opt => opt.value === '');
    optionSelect.appendChild(placeholder.cloneNode(true));
    optionSelect.selectedIndex = 0; // Ensure placeholder is selected

    if (mode === 'single') {
        // Add all real options (1-5)
        allOptions.forEach(opt => {
            if (opt.value !== '') {
                optionSelect.appendChild(opt.cloneNode(true));
            }
        });
    } else if (mode === 'dual' || mode === 'swipe') {
        // Add only Option 2
        const option2 = allOptions.find(opt => opt.value === 'sentinel2');
        if (option2) {
            optionSelect.appendChild(option2.cloneNode(true));
        }
    }
});



function closediv() {
    document.getElementById("infoforslopmain").style.display = "none";
    document.getElementById("infofordtmmain").style.display = "none";
    document.getElementById("soilinfodivmain").style.display = "none";
}


//////////////////// NDVI time series start/////////////////////////////////////////////////////


const apiKey = '60a2d297375669833a33d2383bd628aa';
const output = document.getElementById('output');
const loader = document.getElementById('loader');
let ndviChart = null;

async function fetchNdviForPolygon(startDate, endDate, asdfsdf) {
    try {

        output.innerHTML = '⏳ Creating polygon...';
        loader.style.display = 'block';
        // alert("fetching data");
        const startTimestamp = Math.floor(new Date(startDate).getTime() / 1000);
        const endTimestamp = Math.floor(new Date(endDate).getTime() / 1000);

        const polygonData = {
            name: "Custom Area",
            geo_json: {
                type: "Feature",
                properties: {},
                geometry: {
                    type: "Polygon",
                    coordinates: [asdfsdf]
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
        //alert("Error : " + error.message );
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
    //alert("creating chart");
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


//////////////////// NDVI time series end/////////////////////////////////////////////////////