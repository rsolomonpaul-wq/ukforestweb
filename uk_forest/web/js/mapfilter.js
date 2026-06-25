var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";

var geoserver_ip_ows = "https://ukforestgis.in/geoserver/uk_sfd/ows";

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






var source1 = new ol.source.Vector();
 

var view = new ol.View({
    center: ol.proj.fromLonLat([80.2322, 29.9965]), // Dehradun
    zoom: 8,
    minZoom: 7,
    maxZoom: 14,
});

// Stadia Satellite Layer
const stadiaSatellite = new ol.layer.Tile({
    source: new ol.source.XYZ({
        url: 'https://tiles.stadiamaps.com/tiles/alidade_satellite/{z}/{x}/{y}.jpg',
        attributions: [
            '&copy; CNES, Distribution Airbus DS, © Airbus DS, © PlanetObserver (Contains Copernicus Data) | ',
            '&copy; <a href="https://www.stadiamaps.com/" target="_blank">Stadia Maps</a>',
            '&copy; <a href="https://openmaptiles.org/" target="_blank">OpenMapTiles</a>',
            '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        ]
    }),
    visible: false
});

// Stadia OSM Bright Layer (Default Visible)
const stadiaBright = new ol.layer.Tile({
    source: new ol.source.XYZ({
        url: 'https://tile.jawg.io/jawg-sunny/{z}/{x}/{y}.png?access-token=YzlrSlTat3RcFyPky1MtLseicz8tIThPqtfcA9n2L8xNLwPgaMB7Y7hxVlpmp2Qx',
        attributions: [
            '&copy; <a href="https://jawg.io" target="_blank"><b>Jawg</b>Maps</a>',
            '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        ]
    }),
    visible: true
});




const jawgLayer = new ol.layer.Tile({
    source: new ol.source.XYZ({
        url: 'https://tile.jawg.io/jawg-sunny/{z}/{x}/{y}.png?access-token=YOUR_ACCESS_TOKEN',
        crossOrigin: 'anonymous',
        attributions: [
            '&copy; <a href="https://jawg.io" target="_blank"><b>Jawg</b>Maps</a>',
            '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        ]
    })
});

// Jawg Terrain Layer
const jawgTerrain = new ol.layer.Tile({
    source: new ol.source.XYZ({
        url: 'https://tile.jawg.io/jawg-terrain/{z}/{x}/{y}.png?access-token=6z6PwyLO02fgUDWkp2qHwTD8nH6nj86xyi0CxDC8YrKyaaWuvpt5i0osdicSXChQ',
        crossOrigin: 'anonymous',
        attributions: [
            '<a href="https://jawg.io" title="Tiles Courtesy of Jawg Maps" target="_blank">&copy; <b>Jawg</b>Maps</a>',
            '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        ]
    }),
    visible: false
});

//const esriLayer = new ol.layer.Tile({
//    source: new ol.source.XYZ({
//        url: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
//        crossOrigin: 'anonymous',
//        attributions: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community',
//        maxZoom: 19
//    }), visible: false
//});
const esriLayer = new ol.layer.Tile({
    title: 'Google Hybrid',
    visible: false,
    source: new ol.source.XYZ({
        url: 'http://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}'
    })
})
const nullmap = new ol.layer.Tile({
    source: new ol.source.XYZ({
         
    }), visible: false
});

const osm = new ol.layer.Tile({
    title: 'OpenStreetMap',
    visible: true,
    source: new ol.source.OSM()
})

const mapfilter = new ol.Map({
    target: 'mapfilter',
    controls: ol.control.defaults().extend([
        new ol.control.FullScreen(),
        new ol.control.ScaleLine()
    ]),
    //layers: [stadiaBright, esriLayer,// stadiaSatellite,
    //    jawgTerrain, nullmap],
    layers: [osm, esriLayer],
    view: view
});

// Layer Switcher
const layersMap = {
    bright: stadiaBright,
    /* satellite: stadiaSatellite,*/esriLayer: esriLayer,
    jawg: jawgTerrain,
    nulls:nullmap
};

document.getElementById('layer-select').addEventListener('change', function () {
    const selected = this.value;
    for (let key in layersMap) {
        layersMap[key].setVisible(key === selected);
    }
});


window.onload = function () {
    initializeSwitchListeners();
    mapfilter.addOverlay(zones);
    mapfilter.addLayer(zones);


}
var district_layer = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_2021',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});







//////////////////////////
const layerName = 'uk_sfd:uk_density_recode_color_final';
const wmsUrl = 'https://ukforestgis.in/geoserver/uk_sfd/wms';
var currentWmsLayer;

//const visiblePixelValues = new Set(['3', '4', '5', '6']); // default ON

function createSLD(visibleValues) {
    const colorMap = {
        3: '#FFCA28',
        4: '#81C784',
        5: '#03AD0C',
        6: '#2E7D32'
    };

    const entries = [];
    [3, 4, 5, 6].forEach(i => {
        const opacity = visibleValues.has(i.toString()) ? 1 : 0;
        entries.push(`<ColorMapEntry color="${colorMap[i]}" quantity="${i}" opacity="${opacity}"/>`);
    });

    return `<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld"
  xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>${layerName}</Name>
    <UserStyle>
      <Title>Custom RGB Raster Style</Title>
      <FeatureTypeStyle>
        <Rule>
          <RasterSymbolizer>
            <ColorMap type="values">
              ${entries.join('\n')}
            </ColorMap>
          </RasterSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>`;
}

function createWmsLayer(visibleValues) {
    const sldBody = createSLD(visibleValues);
    return new ol.layer.Image({
        source: new ol.source.ImageWMS({
            url: wmsUrl,
            params: {
                'LAYERS': layerName,
                'TILED': true,
                'INFO_FORMAT': 'application/json',
                'SLD_BODY': sldBody
            },
            serverType: 'geoserver',
            crossOrigin: 'anonymous'
        }),
        opacity: 1 // fixed opacity
    });
}

var colorMap;
var entries;
var opacity;
var sldBody;
var visiblePixelValues;
function updateLayer() {
    
    mapfilter.removeLayer(heatmapLayer);
    mapfilter.removeOverlay(heatmapLayer);

    colorMap = {
        3: '#FFCA28',
        4: '#81C784',
        5: '#03AD0C',
        6: '#2E7D32'
    };

    entries = [];
    [3, 4, 5, 6].forEach(i => {
        opacity = visiblePixelValues.has(i.toString()) ? 1 : 0;
        entries.push(`<ColorMapEntry color="${colorMap[i]}" quantity="${i}" opacity="${opacity}"/>`);
    });

    sldBody = `<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld"
  xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>${layerName}</Name>
    <UserStyle>
      <Title>Custom RGB Raster Style</Title>
      <FeatureTypeStyle>
        <Rule>
          <RasterSymbolizer>
            <ColorMap type="values">
              ${entries.join('\n')}
            </ColorMap>
          </RasterSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>`;






    heatmapLayer = new ol.layer.Image({
        source: new ol.source.ImageWMS({
            url: wmsUrl,
            params: {
                'LAYERS': layerName,
                'TILED': true,
                'INFO_FORMAT': 'application/json',
                'SLD_BODY': sldBody
            },
            serverType: 'geoserver',
            crossOrigin: 'anonymous'
        }),
        opacity: 1 // fixed opacity
    });


    mapfilter.addLayer(heatmapLayer);
    mapfilter.addOverlay(heatmapLayer);
}

// Initial render

// Toggle behavior
//////////////////////////

var heatmapLayer = null;
var boundrayfilter = null;
var layername;
 

function sldBodyhighlight(layername) {
    return `<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
 xmlns="http://www.opengis.net/sld"
 xmlns:ogc="http://www.opengis.net/ogc"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/sld
 http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
 <NamedLayer>
   <Name>uk_sfd:${layername}</Name>
   <UserStyle>
     <Title>Red Boundary Style</Title>
     <FeatureTypeStyle>
       <Rule>
         <LineSymbolizer>
           <Stroke>
             <CssParameter name="stroke">#FF0000</CssParameter>
             <CssParameter name="stroke-width">2</CssParameter>
           </Stroke>
         </LineSymbolizer>
       </Rule>
     </FeatureTypeStyle>
   </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>`;

}

var testlayer;

function applyfilter() {
    var year = document.getElementById("ddlyear").value;
    var zone = document.getElementById("ddlzone").value;
    var circle = document.getElementById("ddlcircle").value;
    var division = document.getElementById("ddldivision").value;
    var range = document.getElementById("ddlrange").value;
    var beat = document.getElementById("ddlbeat").value;
    var action = document.getElementById("ddlaction").value;
    document.getElementById("toggleBtn").style.display = "none";

   // document.getElementById("treecoverloss").checked = false;
    document.getElementById("infoPanel").style.display = "none";
    //var treecvrls = document.getElementById("treecoverloss");
    //callTreeCoverLoss(treecvrls);
    var filterParts = [];

    //if (year) filterParts.push("year = " + year);
    if (zone != "All") {
        //filterParts.push("CQL_FILTER");
        filterParts.push("zone = '" + zone + "'");
    }
    if (circle != "All") {
        filterParts.push("circle = '" + circle + "'");
    }
    if (division != "All") {
        filterParts.push("division = '" + division + "'");
    } if (range != "All") {
        filterParts.push("range = '" + range + "'");
    }
    if (beat != "All") {
        filterParts.push("beat = '" + beat + "'");
    }
    //if (action) filterParts.push("action = '" + action + "'");

    mapfilter.removeLayer(heatmapLayer);
    //mapfilter.removeOverlay(heatmapLayer);
    mapfilter.removeLayer(boundrayfilter);
    mapfilter.removeOverlay(boundrayfilter);

    var cqlFilter = filterParts.join(" AND ");
    //console.log(cqlFilter);
    var findboundarylayerfilter = cqlFilter.split('AND');
    findboundarylayerfilter = findboundarylayerfilter[findboundarylayerfilter.length - 1];
    findboundarylayerfilter = findboundarylayerfilter.trim();
    var findboundarylayer = findboundarylayerfilter.split('=');
    findboundarylayer = findboundarylayer[0];
    findboundarylayer = findboundarylayer.trim();
    //alert(findboundarylayer);
    var filterstyle = filterboundarystyle(findboundarylayer);
    if (action == "Fire Alerts") {
        document.getElementById("legendfirepoint").style.display = "block";
        document.getElementById("toggleBtn").style.display = "block";
        document.getElementById("legendforestarea").style.display = "none";
        document.getElementById("legendforestdensity").style.display = "none";
        document.getElementById("legenddegradation").style.display = "none";
        
 


        if (cqlFilter == "") {
            heatmapLayer = new ol.layer.Heatmap({
                source: new ol.source.Vector({
                    url: `https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:${year}&outputFormat=application/json`,
                    format: new ol.format.GeoJSON()
                }),
                blur: 2,
                radius: 1,
                weight: function (feature) {
                    return feature.get('intensity') || 1;
                }
            });
            heatmapLayer.setGradient([
                '#E6521F', // soft orange
                '#E6521F', // very light orange (low intensity)

                '#E6521F', // medium orange
                '#E6521F', // rich orange
                '#E6521F'  // dark orange (high intensity)
            ]);

             

            layername = "tbl_" + findboundarylayer + "_master";

            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        layers: 'uk_sfd:' + layername,

                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });




        } else {
            heatmapLayer = new ol.layer.Heatmap({
                source: new ol.source.Vector({
                    url: `https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:${year}&outputFormat=application/json&CQL_FILTER=${encodeURIComponent(cqlFilter)}`,
                    format: new ol.format.GeoJSON()
                }),
                blur: 2,
                radius: 1,
                weight: function (feature) {
                    return feature.get('intensity') || 1;
                }
            });
            heatmapLayer.setGradient([
                '#E6521F', // soft orange
                '#E6521F', // very light orange (low intensity)

                '#E6521F', // medium orange
                '#E6521F', // rich orange
                '#E6521F'  // dark orange (high intensity)
            ]);

            layername = "tbl_" + findboundarylayer + "_master";

            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        // 'SLD_BODY': filterstyle,
                        layers: 'uk_sfd:' + layername,
                        CQL_FILTER: findboundarylayerfilter,
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });
        }


    } else if (action == "Forest Density") {


        document.getElementById("legendfirepoint").style.display = "none";
        document.getElementById("legendforestarea").style.display = "none";
        document.getElementById("legendforestdensity").style.display = "block";
        document.getElementById("legenddegradation").style.display = "none";
        //document.getElementById("treecoverloss").checked = true;
        //var treecvrls = document.getElementById("treecoverloss");
        //callTreeCoverLoss(treecvrls);
        var linegrapg = document.getElementById("mydivbar");
        linegrapg.style.display = "none";
        var bargraph = document.getElementById("chartpie1");
        bargraph.style.display = "none";
        var sldBody = updatelayer();
        heatmapLayer = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                ratio: 1,
                url: geoserver_ip,
                params: {
                    'FORMAT': format,
                    tiled: true,
                    STYLES: '',
                    'SLD_BODY': sldBody,
                    layers: 'uk_sfd:uk_density_recode_color_final',

                    transition: 0
                }, serverType: 'geoserver',
                crossOrigin: 'anonymous'

            })
        });

        if (findboundarylayer != "") {
            layername = "tbl_" + findboundarylayer + "_master";

            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        // 'SLD_BODY': filterstyle,
                        layers: 'uk_sfd:' + layername,
                        CQL_FILTER: findboundarylayerfilter,
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });
        } else {
            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        layers: 'uk_sfd:' + layername,
                        //CQL_FILTER: findboundarylayerfilter,
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });
        }


    }
    else if (action == "Forest Area") {
        document.getElementById("legendfirepoint").style.display = "none";
        document.getElementById("legendforestarea").style.display = "block";
        document.getElementById("legendforestdensity").style.display = "none";
        document.getElementById("legenddegradation").style.display = "none";
        var linegrapg = document.getElementById("mydivbar");
        linegrapg.style.display = "none";
        var bargraph = document.getElementById("chartpie1");
        bargraph.style.display = "none";
        heatmapLayer = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                ratio: 1,
                url: geoserver_ip,
                params: {
                    'FORMAT': format,
                    tiled: true,
                    STYLES: '',
                    layers: 'uk_sfd:tbl_forest_data_final',
                    CQL_FILTER: 'name=\'Reserve Forest\'',
                    transition: 0
                }, serverType: 'geoserver',
                crossOrigin: 'anonymous'

            })
        });
        testlayer = heatmapLayer;
        if (findboundarylayer != "") {
            layername = "tbl_" + findboundarylayer + "_master";

            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        // 'SLD_BODY': filterstyle,
                        layers: 'uk_sfd:' + layername,
                        CQL_FILTER: findboundarylayerfilter,
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });
        } else {
            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        // 'SLD_BODY': filterstyle,
                        layers: 'uk_sfd:' + layername,
                        //CQL_FILTER: findboundarylayerfilter,
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });
        }


    } else if (action == "Land Degradation") {
        document.getElementById("legendfirepoint").style.display = "none";
        document.getElementById("legendforestarea").style.display = "none";
        document.getElementById("legendforestdensity").style.display = "none";
        document.getElementById("legenddegradation").style.display = "block";
        var linegrapg = document.getElementById("mydivbar");
        linegrapg.style.display = "none";
        var bargraph = document.getElementById("chartpie1");
        bargraph.style.display = "none";

        var sldde = updatelayerslddegradation();
        console.log(sldde);
        heatmapLayer = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                url: wmsUrl,
                params: {
                    'LAYERS': 'uk_sfd:land_degadation_sac',
                    'TILED': true,
                    'INFO_FORMAT': 'application/json',
                    'SLD_BODY':''
                },
                serverType: 'geoserver',
                crossOrigin: 'anonymous'
            }),
            opacity: 1
        });

        if (findboundarylayer != "") {
            layername = "tbl_" + findboundarylayer + "_master";

            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        // 'SLD_BODY': filterstyle,
                        layers: 'uk_sfd:' + layername,
                        CQL_FILTER: findboundarylayerfilter,
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });
        } else {
            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        layers: 'uk_sfd:' + layername,
                        //CQL_FILTER: findboundarylayerfilter,
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });
        }


    }



    mapfilter.addLayer(heatmapLayer);
    //mapfilter.addOverlay(heatmapLayer);
    mapfilter.addLayer(boundrayfilter);
    mapfilter.addOverlay(boundrayfilter);

    makeTableSortable("grd_area");

}
function filterboundarystyle(property) {
    var layername = "uk_sfd:tbl_" + property + "_master";
    return `<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
    xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
    xmlns="http://www.opengis.net/sld"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <NamedLayer>
    <Name>${layername}</Name>

    <UserStyle>
      <Name>${layername}-style</Name>
      <Title>${layername} Styled</Title>
      <Abstract>Custom inline SLD style</Abstract>

      <FeatureTypeStyle>
        <Rule>
          <PolygonSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#ff00a9</CssParameter>
              <CssParameter name="stroke-width">1</CssParameter>
              <CssParameter name="stroke-opacity">1</CssParameter>
            </Stroke>
          </PolygonSymbolizer>

          <TextSymbolizer>
            <Label>
              <ogc:PropertyName>${property}</ogc:PropertyName>
            </Label>
            <Font>
              <CssParameter name="font-family">Verdana</CssParameter>
              <CssParameter name="font-size">14</CssParameter>
              <CssParameter name="font-style">normal</CssParameter>
              <CssParameter name="font-weight">bold</CssParameter>
            </Font>
            <Fill>
              <CssParameter name="fill">#003366</CssParameter>
            </Fill>
            <Halo>
              <Radius>2</Radius>
              <Fill>
                <CssParameter name="fill">#ffffff</CssParameter>
              </Fill>
            </Halo>

            <VendorOption name="conflictResolution">true</VendorOption>
            <VendorOption name="priority">1000</VendorOption>
            <VendorOption name="spaceAround">2</VendorOption>
            <VendorOption name="labelAllGroup">true</VendorOption>
          </TextSymbolizer>

        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>`;
}
 
const pixelValuesde = ['1', '2', '3', '5', '6', '7', '8'];
const visiblePixelValuesde = new Set(pixelValuesde);

function initializeSwitchListeners() {

    document.querySelectorAll('.switch_degradation input[type="checkbox"]').forEach(cb => {
        cb.addEventListener('change', () => {
            const val = cb.getAttribute('data-value');
            if (cb.checked) {
                visiblePixelValuesde.add(val);
            } else {
                visiblePixelValuesde.delete(val);
            }
            updatelayerslddegradation();
            applyfilter();
        });
    });
}

function updatelayerslddegradation() {
   


    const colorMap = {
        1: '#ffff00',
        2: '#03c003',
        3: '#00ffff',
        5: '#BB9A3E',
        6: '#B22D44',
        7: '#ff0000',
        8: '#0b3df6'

 
    };
    if (currentWmsLayer) {
        map.removeLayer(currentWmsLayer);
    }

    const entries = Object.entries(colorMap).map(([key, color]) => {
        const opacity = visiblePixelValuesde.has(key) ? 1 : 0;
        return `<ColorMapEntry color="${color}" quantity="${key}" opacity="${opacity}"/>`;
    });

    return `<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld"
  xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>uk_sfd:land_degadation_sac</Name>
    <UserStyle>
      <Title>Custom Raster Style</Title>
      <FeatureTypeStyle>
        <Rule>
          <RasterSymbolizer>
            <ColorMap type="values">
              ${entries.join('\n')}
            </ColorMap>
          </RasterSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>`;


}





var visiblePixelValues = new Set(['3', '4', '5', '6']);
document.querySelectorAll('.switch-group .switch input[type="checkbox"]').forEach(cb => {
    cb.addEventListener('change', () => {
        const val = cb.getAttribute('data-value');
        if (cb.checked) {
            visiblePixelValues.add(val);
        } else {
            visiblePixelValues.delete(val);
        }
        updatelayer();
        applyfilter();

    });
});


function updatelayer() {
    // const visiblePixelValues = new Set(['3', '4', '5', '6']); // default ON




    if (currentWmsLayer) {
        map.removeLayer(currentWmsLayer);
    }

    const colorMap = {
        3: '#FFCA28',
        4: '#81C784',
        5: '#03AD0C',
        6: '#2E7D32'
    };

    const entries = [3, 4, 5, 6].map(i => {
        const opacity = visiblePixelValues.has(i.toString()) ? 1 : 0;
        return `<ColorMapEntry color="${colorMap[i]}" quantity="${i}" opacity="${opacity}"/>`;
    });

    return `<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld"
  xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>${layerName}</Name>
    <UserStyle>
      <Title>Custom RGB Raster Style</Title>
      <FeatureTypeStyle>
        <Rule>
          <RasterSymbolizer>
            <ColorMap type="values">
              ${entries.join('\n')}
            </ColorMap>
          </RasterSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>`;




}

 


var myChartInstance;
function myJsFunction(a, b) {

    var lbls = a.split(',');
    var vals = b.split(',');
    console.log(lbls);
    console.log(vals);
    const ctx = document.getElementById('myChart').getContext('2d');

    // Destroy previous chart if it exists
    if (myChartInstance) {
        myChartInstance.destroy();
    }

    myChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: lbls,
            datasets: [{
                label: 'Fire Points',
                data: vals,
                borderColor: 'rgba(75, 192, 192, 1)',
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderWidth: 2,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top'
                },
                title: {
                    display: true,
                    text: 'Yearly Fire Points'
                }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

}

function isNumeric(value) {
    return !isNaN(value) && !isNaN(parseFloat(value));
}


function applyFlatColorsForThreeOrLess(table, columncount) {
    const firstColumn = { bg: "linear-gradient(to bottom, #333, #111)", text: "#fff" }; // fixed 1st column

    let restColumnColors = [];

    if (columncount === 3) {
        restColumnColors = [
            { bg: "linear-gradient(to bottom right, #122b01, #21411a)", text: "#fff" },
            { bg: "linear-gradient(to bottom right, #fcf259, #fcf259)", text: "#000" }
        ];
    } else if (columncount > 3 && columncount < 6) {
        restColumnColors = [
            { bg: "linear-gradient(to bottom right, #f03030, #f18c8c)", text: "#000" },
            { bg: "linear-gradient(to bottom right, #fcf259, #fcf259)", text: "#000" },
            { bg: "linear-gradient(to bottom right, #a5f591, #1eff00)", text: "#000" },
            { bg: "linear-gradient(to bottom right, #122b01, #21411a)", text: "#fff" }
        ];
    } else if (columncount > 6) {
        restColumnColors = [
            { bg: "linear-gradient(to bottom right, #fcf259, #fdf796)", text: "#000" },
            { bg: "linear-gradient(to bottom right, #4b7f00, #9fff14)", text: "#000" },
            { bg: "linear-gradient(to bottom right, #f9fff1, #f9fff1)", text: "#000" },
            { bg: "linear-gradient(to bottom right, #FF0000, #ff5151)", text: "#000" },
            { bg: "linear-gradient(to bottom right, #B32E45, #d55d72)", text: "#fff" },
            { bg: "linear-gradient(to bottom right, #B88247, #cca57b)", text: "#000" },
            { bg: "linear-gradient(to bottom right, #0000FF, #6a6aff)", text: "#fff" },
            { bg: "linear-gradient(to bottom right, #fcf259, #fcf259)", text: "#000" }
        ];
    }

    const headers = table.querySelectorAll("tr th");
    const columnCount = headers.length;

    for (let i = 0; i < columnCount; i++) {
        const color = i === 0 ? firstColumn : restColumnColors[(i - 1) % restColumnColors.length];

        // Apply to header
        table.querySelectorAll(`tr th:nth-child(${i + 1})`).forEach(th => {
            th.style.background = color.bg;
            th.style.color = color.text;
        });

        // Apply to each column cell
        table.querySelectorAll(`tbody td:nth-child(${i + 1})`).forEach(td => {
            td.style.background = color.bg;
            td.style.color = color.text;
        });
    }
}




function roundNumericCells(table) {
    table.querySelectorAll("tbody td").forEach(td => {
        const val = td.innerText.trim();
        if (isNumeric(val)) {
            td.innerText = parseFloat(val).toFixed(2);
        }
    });
}
function callcolortable() {
    const table = document.getElementById("grd_area");
    var action = document.getElementById("ddlaction").value;
    if (action != "Fire Alerts") {
        const columnCount = table.querySelectorAll("tr th").length;

        roundNumericCells(table);

        // Apply flat colors only if 3 or fewer columns
        if (columnCount != 0) {
            applyFlatColorsForThreeOrLess(table, columnCount);
        }
    }

}
var chartinstance = null;


function bindchartup() {
    if (chartinstance) {
        chartinstance.destroy();
    }
  
    const range = document.getElementById("ddlrange");
    const table = document.getElementById("grd_area");
    var action = document.getElementById("ddlaction").value;
    const rows = Array.from(table.querySelectorAll("tbody tr"));

    // Extract header from the first row (fix: select th and td)
    const headerCells = Array.from(rows[0].querySelectorAll("th, td"));
    const headers = headerCells.map(td => td.textContent.trim());

    const dataRows = rows.slice(1);
    var labels;
    if (action == "Fire Alerts" && range.value != "All") {
         
        labels = dataRows.map(row =>
            (row.cells[3].textContent.trim() + ' (' + row.cells[5].textContent.trim()).toLowerCase() + ')'
            );
       
        
    } else {
        if (range.value != "All") {
            labels = dataRows.map(row => toCapitalized(row.cells[4].textContent.trim().toLowerCase()));
        } else {
            labels = dataRows.map(row => toCapitalized(row.cells[3].textContent.trim().toLowerCase()));
        }
        
    }
   
    

    const datasets = [];

    
    var barColors;
    var lblchart;
    var charttitle;
    var tabletitle;


    if (action == "Forest Density") {
        barColors = ['#FFCA28', '#81C784', '#03AD0C', '#2E7D32'];//density;
        lblchart = "Total area (sq km)";
        charttitle = "Range wise forest density";
        tabletitle = "Range wise area (sq km) statistics";
    } else if (action == "Forest Area") {
        barColors = ['#59981A', '#FFCF50']; //area
        lblchart = "Total area (sq km)";
        charttitle = "Range wise forest area";
        tabletitle = "Range wise area (sq km) statistics";
    } else if (action == "Fire Alerts") {
        barColors = ['#fdb475']; //fire
        lblchart = "Total Count";
        charttitle = "Range wise forest fire alerts";
        tabletitle = "Range wise fire alerts (Count) statistics";
    }else if (action == "Land Degradation") {
        barColors = ['#ffff00', '#03c003', '#00ffff', '#BB9A3E', '#B22D44', '#ff0000', '#0b3df6']; //degradation
        lblchart = "Total area (sq km)";
        charttitle = "Range wise forest land degradation";
        tabletitle = "Range wise area (sq km) statistics";
    } else {
        `hsl(${(datasets.length * 60) % 360}, 70%, 60%)`;
        lblchart = "Total area (sq km)";
        charttitle = "Total area (sq km)";
        tabletitle = "Range wise area (sq km) statistics";
    }

    for (let colIndex = 1; colIndex < headers.length; colIndex++) {
        const columnLabel = headers[colIndex];

        const values = dataRows.map(row => {
            const cellValue = row.cells[colIndex].textContent.trim();
            const num = parseFloat(cellValue);
            return isNaN(num) ? null : num;
        });

        if (values.some(v => v !== null)) {
            datasets.push({
                label: columnLabel,
                data: values.map(v => v ?? 0),
                backgroundColor: barColors[colIndex - 4]
            });
        }
    }
    document.getElementById("mastertabletitle").innerHTML = tabletitle;
   
    chartinstance= new Chart(document.getElementById("barChart"), {
        type: 'bar',
        data: {
            labels: labels,
            datasets: datasets
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    stacked: false,
                    
                    ticks: {
                        color: 'black'   // X axis labels color
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: lblchart,
                        color: 'black'
                    },
                    ticks: {
                        color: 'black'
                    }
                }



            },
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        color: 'black'    // Legend text color
                    }
                },
                title: {
                    display: true,
                    text: charttitle,
                    color: 'black'       // Title text color (optional)
                }
            }
        }

    });
}

var testtbl;
 

function callchart1(unitsname, lbls, first, second, third) {
     

    try {
        if (!(unitsname == null || unitsname.trim() === "")) {
            unitsname = unitsname.split(',');
        }
        if (!(lbls == null || lbls.trim() === "")) {
            lbls = lbls.split(',');
        }
        if (!(first == null || first.trim() === "")) {
            first = JSON.parse(first);
        }
        if (!(second == null || second.trim() === "")) {
            second = JSON.parse(second);
        } if (!(third == null || third.trim() === "")) {
            third = JSON.parse(third);
        }
        var action = document.getElementById("ddlaction").value;

        const labels = lbls;
        //const labels = ["Scrub", "Open Forest", "Moderately Dense Forest", "Very Dense Forest"];

        const names = unitsname;
        //const names = ["Garhwal", "Kumaun", "Wildlife"];
        //const values = vals;
        const values = [
            first,
            second,
            third
        ];
        // Assign colors dynamically or use fixed ones
        const colors = [
            'rgba(255, 99, 132, 1)',
            'rgba(54, 162, 235, 1)',
            'rgba(42,128,0, 1)'
        ];

        // Dynamically build datasets
        const allDatasets = names.map((name, i) => ({
            name: name,
            values: values[i],
            color: colors[i % colors.length]
        }));

        // Display only 1 dataset for demo
        const selectedDatasets = allDatasets.slice(0, unitsname.length); // change to .slice(0, 2) or allDatasets to see others

        // Calculate grand totals (based on all data, not selected)
        const grandTotals = labels.map((_, colIndex) =>
            allDatasets.reduce((sum, ds) => sum + ds.values[colIndex], 0)
        );



        const traces = selectedDatasets.map(ds => {
            const hoverData = ds.values.map((v, i) => {
                const percent = grandTotals[i] ? ((v / grandTotals[i]) * 100).toFixed(1) : "0.0";
                return `${v.toFixed(2)} (${percent}%)`;
            });

            const textData = ds.values.map((v, i) => {
                const percent = grandTotals[i] ? ((v / grandTotals[i]) * 100).toFixed(1) : "0.0";
                return `${percent}%`;
            });

            return {
                x: labels,
                y: ds.values.map((v, i) =>
                    grandTotals[i] ? (v / grandTotals[i]) * 100 : 0
                ),
                name: ds.name,
                type: 'bar',
                marker: { color: ds.color },
                customdata: hoverData,
                hovertemplate: '%{customdata}<extra></extra>',
                text: textData,
                textposition: 'outside',
                textfont: { color: 'white' },
                showlegend: true  // ✅ Ensures legend shows even for one dataset
            };
        });


        const layout = {
            height: 300,
            Width: 600,
            barmode: 'group',
            paper_bgcolor: 'rgba(0,0,0,0)',
            plot_bgcolor: 'rgba(0,0,0,0)',
            margin: { t: 80, l: 70, r: 30, b: 80 },
            legend: {
                orientation: 'h',
                y: -0.55,  // pushes legend below chart
                x: 0.5,
                xanchor: 'center',
                font: {
                    family: 'Arial Black',
                    size: 14,
                    color: 'white'
                }
            },
            xaxis: {
                title: {
                    text: action,
                    font: { size: 16, color: 'white' }
                },
                tickfont: { color: 'white', size: 14 }
            },
            yaxis: {
                title: {
                    text: 'Percentage (%)',
                    font: { size: 16, color: 'white' }
                },
                tickfont: { color: 'white', size: 14 }
            }
        };
        Plotly.newPlot('mydivbar', traces, layout);
    } catch (e) {
        console.log(e);
    }
}



function toggleNotes() {
    const container = document.getElementById("note-container");
    const arrow = document.getElementById("arrow");
    container.classList.toggle("hidden");
    arrow.classList.toggle("rotate");
}

function togglefilter() {
    const container = document.getElementById("filter-container");
    const arrow = document.getElementById("arrowfilter");
    container.classList.toggle("hidden");

    arrow.classList.toggle("rotate");
}

function togglelayers() {
    const container = document.getElementById("layerlegends");
    const arrow = document.getElementById("arrowlayers");
    const arrow1 = document.getElementById("layersdiv");
     
    container.classList.toggle("hidden");
    arrow1.classList.toggle("layerForestBoxtest");

    arrow.classList.toggle("rotate");
}

function togglechart() {
    const container = document.getElementById("chart-container");
    const arrow = document.getElementById("arrowchart");
    container.classList.toggle("hidden");
    arrow.classList.toggle("rotate");
}




function sfdzone(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_zone').css('display', 'block');
        mapfilter.addLayer(zones);
        layerobject.push(zones);
        mapfilter.addOverlay(zones);
        lastselectedlayer.push("tbl_zone_master");
        lastselectedlayername.push(" Zone ");
        lastselectedlayer_vector.push("tbl_zone_master");
        //village_zoom();
    }
    else {
        jQuery('#div_zone').css('display', 'none');
        mapfilter.removeLayer(zones);
        layerobject.pop(zones);
        mapfilter.removeOverlay(zones);
        lastselectedlayer.pop("tbl_zone_master");
        lastselectedlayername.pop(" Zone ");
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


var treecoverloss = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tree_cover_loss_gcs',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});

function callTreeCoverLoss(checkbox) {

    if (checkbox.checked) {

        mapfilter.addLayer(treecoverloss);

        mapfilter.addOverlay(treecoverloss);

    }
    else {

        mapfilter.removeLayer(treecoverloss);

        mapfilter.removeOverlay(treecoverloss);

    }
}






function sfdcircle(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_circle').css('display', 'block');
        mapfilter.addLayer(circles);
        layerobject.push(circles);
        mapfilter.addOverlay(circles);
        lastselectedlayer.push("tbl_circle_master");
        lastselectedlayername.push(" Circle ");
        lastselectedlayer_vector.push("tbl_circle_master");
        //village_zoom();
    }
    else {
        jQuery('#div_circle').css('display', 'none');
        mapfilter.removeLayer(circles);
        layerobject.pop(circles);
        mapfilter.removeOverlay(circles);
        lastselectedlayer.pop("tbl_circle_master");
        lastselectedlayername.pop(" Circle ");
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
        mapfilter.addLayer(divisions);
        layerobject.push(divisions);
        mapfilter.addOverlay(divisions);
        lastselectedlayer.push("tbl_division_master");
        lastselectedlayername.push(" Division ");
        lastselectedlayer_vector.push("tbl_division_master");
        //village_zoom();
    }
    else {
        jQuery('#div_division').css('display', 'none');
        mapfilter.removeLayer(divisions);
        layerobject.pop(divisions);
        mapfilter.removeOverlay(divisions);
        lastselectedlayer.pop("tbl_division_master");
        lastselectedlayername.pop(" Division ");
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
        mapfilter.addLayer(ranges);
        layerobject.push(ranges);
        mapfilter.addOverlay(ranges);
        lastselectedlayer.push("range_master");
        lastselectedlayername.push("Range");
        lastselectedlayer_vector.push("tbl_range_areas");
        //village_zoom();
    }
    else {
        jQuery('#div_range').css('display', 'none');
        mapfilter.removeLayer(ranges);
        layerobject.pop(ranges);
        mapfilter.removeOverlay(ranges);
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



function beat_fun(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_beat').css('display', 'block');
        mapfilter.addLayer(beat);
        layerobject.push(beat);
        mapfilter.addOverlay(beat);
        lastselectedlayer.push("tbl_beat_master");
        lastselectedlayername.push("Beat");
        lastselectedlayer_vector.push("tbl_beat_master");
        //village_zoom();
    }
    else {
        jQuery('#div_beat').css('display', 'none');
        mapfilter.removeLayer(beat);
        layerobject.pop(beat);
        mapfilter.removeOverlay(beat);
        lastselectedlayer.pop("tbl_beat_master");
        lastselectedlayername.pop("Beat");
        lastselectedlayer_vector.pop("tbl_beat_master");
    }
}

var beat = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:tbl_beat_master',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});





function density_fun(checkbox) {

    if (checkbox.checked) {
        jQuery('#div_density').css('display', 'block');
        mapfilter.addLayer(density_data);
        layerobject.push(density_data);
        // mapfilter.addOverlay(density_data);
        lastselectedlayer.push("uk_density_recode_color_final");
        lastselectedlayername.push("Forest Density");
        lastselectedlayer_vector.push("uk_density_recode_color_final");
        //village_zoom();
    }
    else {
        jQuery('#div_density').css('display', 'none');
        mapfilter.removeLayer(density_data);
        layerobject.pop(density_data);
        //mapfilter.removeOverlay(density_data);
        lastselectedlayer.pop("uk_density_recode_color_final");
        lastselectedlayername.pop("Forest Density");
        lastselectedlayer_vector.pop("uk_density_recode_color_final");
    }
}

var density_data = new ol.layer.Image({
    source: new ol.source.ImageWMS({
        ratio: 1,
        url: geoserver_ip,
        params: {
            'FORMAT': format,
            tiled: true,
            STYLES: '',
            layers: 'uk_sfd:uk_density_recode_color_final',
            transition: 0
        }, serverType: 'geoserver',
        crossOrigin: 'anonymous'

    })
});


function callexpend() {
    var container = document.getElementById("chart-container");
    var topChartBoxes = document.getElementsByClassName("topChartBox");

    // Toggle between compact and full width
    if (container.classList.contains("expanded")) {
        container.style.width = "36.5%";

        for (var i = 0; i < topChartBoxes.length; i++) {
            topChartBoxes[i].style.height = "22%";
        }

        container.classList.remove("expanded");
    } else {
        container.style.width = "100%";

        for (var i = 0; i < topChartBoxes.length; i++) {
            topChartBoxes[i].style.height = "50% !Important";
        }

        container.classList.add("expanded");
    }
}


function downloadChartAsJPG() {
    const originalCanvas = document.getElementById('barChart');
    const exportCanvas = document.createElement('canvas');
    exportCanvas.width = originalCanvas.width;
    exportCanvas.height = originalCanvas.height;

    const context = exportCanvas.getContext('2d');

    // Fill with white background
    context.fillStyle = '#ffffff';
    context.fillRect(0, 0, exportCanvas.width, exportCanvas.height);

    // Draw the original canvas on top
    context.drawImage(originalCanvas, 0, 0);

    // Export as JPG
    const link = document.createElement('a');
    link.download = 'bar-chart.jpg';
    link.href = exportCanvas.toDataURL('image/jpeg', 1.0);
    link.click();
}

function downloadMapAsJPG() {

     
        const canvas =
            document.querySelector(
                '#mapfilter canvas.ol-unselectable'
            );

        if (!canvas) {

            alert('Map canvas not found');
            return;
        }

        const link =
            document.createElement('a');

        const now =
            new Date();

        link.download =
            'Map_' +
            now.getFullYear() +
            String(now.getMonth() + 1).padStart(2, '0') +
            String(now.getDate()).padStart(2, '0') +
            '_' +
            String(now.getHours()).padStart(2, '0') +
            String(now.getMinutes()).padStart(2, '0') +
            String(now.getSeconds()).padStart(2, '0') +
            '.png';

        link.href =
            canvas.toDataURL('image/png');

        link.click();
    

    mapfilter.renderSync();
}
 
//async function downloadChartAsJPG() {
//    alert();
//    const chartCanvas = document.getElementById("barChart");
//    const tableElement = document.getElementById("grd_area");

//    if (!chartCanvas || !tableElement) {
//        alert("Chart or Table not found.");
//        return;
//    }

//    if (typeof mapfilter === "undefined" || !mapfilter) {
//        alert("Map not found.");
//        return;
//    }

//    let selecteddata = document.getElementById("ddlaction")?.value || "";
//    let title = "";

//    if (selecteddata === "Forest Density") {
//        title = "Range Wise Forest Density";
//    } else if (selecteddata === "Fire Alerts") {
//        title = "Range Wise Forest Fire Alerts";
//    } else if (selecteddata === "Forest Area") {
//        title = "Range Wise Forest Area";
//    } else if (selecteddata === "Land Degradation") {
//        title = "Range Wise Forest Land Degradation";
//    } else {
//        title = selecteddata || "Forest Report";
//    }

//    function getMapImageFromCanvas() {
//        return new Promise((resolve, reject) => {
//            mapfilter.once("rendercomplete", function () {
//                const mapCanvas = mapfilter.getViewport().querySelector("canvas");

//                if (!mapCanvas) {
//                    reject("Map canvas not found.");
//                    return;
//                }

//                try {
//                    resolve(mapCanvas.toDataURL("image/png", 1.0));
//                } catch (e) {
//                    reject("Canvas is tainted, unable to export map. Add crossOrigin: 'anonymous' to your map layer source, or use a CORS-enabled tile server.");
//                }
//            });

//            mapfilter.renderSync();
//        });
//    }

//    let mapImage = "";

//    try {
//        mapImage = await getMapImageFromCanvas();
//    } catch (e) {
//        alert(e);
//        return;
//    }

//    const chartExportCanvas = document.createElement("canvas");

//    chartExportCanvas.width = chartCanvas.width * 3;
//    chartExportCanvas.height = chartCanvas.height * 3;

//    const ctx = chartExportCanvas.getContext("2d");

//    ctx.scale(3, 3);
//    ctx.fillStyle = "#ffffff";
//    ctx.fillRect(0, 0, chartCanvas.width, chartCanvas.height);
//    ctx.drawImage(chartCanvas, 0, 0);

//    const chartImage = chartExportCanvas.toDataURL("image/png", 1.0);

//    const tableRows = [];
//    const rows = tableElement.querySelectorAll("tr");

//    rows.forEach(row => {
//        const rowData = [];

//        row.querySelectorAll("th, td").forEach(cell => {
//            rowData.push(cell.innerText.trim());
//        });

//        if (rowData.length > 0) {
//            tableRows.push(rowData);
//        }
//    });

//    const tableHead = tableRows.length > 0 ? [tableRows[0]] : [];
//    const tableBody = tableRows.length > 1 ? tableRows.slice(1) : [];

//    const { jsPDF } = window.jspdf;

//    const pdf = new jsPDF({
//        orientation: "landscape",
//        unit: "mm",
//        format: "a4"
//    });

//    const pageWidth = pdf.internal.pageSize.getWidth();
//    const pageHeight = pdf.internal.pageSize.getHeight();

//    pdf.setFontSize(18);
//    pdf.text(title, 10, 15);
//    pdf.line(10, 20, pageWidth - 10, 20);

//    pdf.setFontSize(12);
//    pdf.text("Analysis Chart", 10, 30);

//    pdf.addImage(
//        chartImage,
//        "PNG",
//        10,
//        35,
//        130,
//        80
//    );

//    pdf.text("Map View", 150, 30);

//    pdf.addImage(
//        mapImage,
//        "PNG",
//        145,
//        35,
//        130,
//        80
//    );

//    pdf.addPage();

//    pdf.setFontSize(16);
//    pdf.text("Records", 10, 15);

//    if (typeof pdf.autoTable === "function") {
//        pdf.autoTable({
//            head: tableHead,
//            body: tableBody,
//            startY: 22,
//            theme: "grid",
//            styles: {
//                fontSize: 8,
//                cellPadding: 2,
//                overflow: "linebreak"
//            },
//            headStyles: {
//                fillColor: [41, 128, 185],
//                textColor: 255
//            },
//            margin: {
//                left: 10,
//                right: 10
//            }
//        });
//    } else {
//        let y = 25;
//        pdf.setFontSize(8);

//        tableRows.forEach(row => {
//            let x = 10;

//            row.forEach(cell => {
//                pdf.text(String(cell), x, y, {
//                    maxWidth: 35
//                });

//                x += 38;
//            });

//            y += 8;

//            if (y > pageHeight - 15) {
//                pdf.addPage();
//                y = 15;
//            }
//        });
//    }

//    const totalPages = pdf.internal.getNumberOfPages();

//    for (let i = 1; i <= totalPages; i++) {
//        pdf.setPage(i);
//        pdf.setFontSize(9);
//        pdf.text(
//            "Generated On : " + new Date().toLocaleString(),
//            10,
//            pageHeight - 6
//        );
//    }

//    const now = new Date();

//    const fileName =
//        title.replace(/\s+/g, "_") +
//        "_" +
//        now.getFullYear() +
//        String(now.getMonth() + 1).padStart(2, "0") +
//        String(now.getDate()).padStart(2, "0") +
//        String(now.getHours()).padStart(2, "0") +
//        String(now.getMinutes()).padStart(2, "0") +
//        String(now.getSeconds()).padStart(2, "0") +
//        ".pdf";

//    pdf.save(fileName);
//}

function downloadexcel(tableID, filename = 'data') {
     
        const table = document.getElementById(tableID);

        // Convert HTML table to worksheet
        const worksheet = XLSX.utils.table_to_sheet(table);

        // Create a new workbook and append the worksheet
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");

        // Export the workbook to .xlsx
        XLSX.writeFile(workbook, filename + ".xlsx");
    
}

 

function makeTableSortable(tableId) {
    const table = document.getElementById(tableId);
    const tbody = table.querySelector("tbody");

    const headerRow = tbody.rows[0];
    const headers = headerRow.querySelectorAll("th");
    let sortDirection = {};

    function detectType(value) {
        return !isNaN(parseFloat(value)) && isFinite(value) ? "number" : "string";
    }

    headers.forEach((header, index) => {
        header.addEventListener("click", () => {
            const allRows = Array.from(tbody.rows);
            const dataRows = allRows.slice(1); // Skip header row

            const ascending = !sortDirection[index];

            const firstValue = dataRows[0].cells[index].textContent.trim();
            const type = detectType(firstValue);

            headers.forEach(h => h.classList.remove("sort-asc", "sort-desc"));

            dataRows.sort((a, b) => {
                const valA = a.cells[index].textContent.trim();
                const valB = b.cells[index].textContent.trim();

                if (type === "number") {
                    return ascending ? Number(valA) - Number(valB) : Number(valB) - Number(valA);
                } else {
                    return ascending ? valA.localeCompare(valB) : valB.localeCompare(valA);
                }
            });

            // Reattach header and sorted data rows
            tbody.innerHTML = '';
            tbody.appendChild(headerRow);
            dataRows.forEach(row => tbody.appendChild(row));

            sortDirection[index] = ascending;
            header.classList.add(ascending ? "sort-asc" : "sort-desc");
        });
    });

    // 👉 Add row click listener for alert (excluding header row)
    tbody.addEventListener("click", function (event) {
        const clickedRow = event.target.closest("tr");
        if (clickedRow && clickedRow !== headerRow) {

            var range = document.getElementById("ddlrange");
            var zoneCell ;
            if (range.value != 'All') {
                 zoneCell = clickedRow.cells[4];
            } else {
                 zoneCell = clickedRow.cells[3];
            }


            // index 1 = "Zone"
            if (zoneCell) {
               // alert(zoneCell.textContent.trim());
                loadFilteredFeature(zoneCell.textContent.trim())
            }
        }
    });
}



const infoPanel = document.getElementById('infoPanel');
const toggleBtn = document.getElementById('toggleBtn');
var isVisible = false;

toggleBtn.addEventListener('click', () => {
    if (isVisible) {
        // Slide out
        infoPanel.classList.remove('show');

        // Wait for transition to complete before setting display to none
        setTimeout(() => {
            if (!infoPanel.classList.contains('show')) {
                infoPanel.style.display = 'none';
            }
        }, 400); // Match the CSS transition duration
        toggleBtn.textContent = '▲';
    } else {
        // Show and slide in
        infoPanel.style.display = 'block';
        setTimeout(() => {
            infoPanel.classList.add('show');
        }, 1); // Slight delay to trigger transition
        toggleBtn.textContent = '▼';
    }

    isVisible = !isVisible;
});




function toCapitalized(str) {
    return str.toLowerCase().replace(/\b\w/g, char => char.toUpperCase());
}

document.querySelectorAll("#grd_area td").forEach(cell => {
    const original = cell.textContent.trim();
    if (isNaN(original)) {
        cell.textContent = toCapitalized(original);
    }
});



 
var vectorLayer;

async function loadFilteredFeature(rangeValue) {
    // If vectorLayer doesn't exist, create and add it
    if (!vectorLayer) {
        vectorLayer = new ol.layer.Vector({
            source: new ol.source.Vector(),
            style: new ol.style.Style({
                stroke: new ol.style.Stroke({
                    color: 'red',    // 🔴 Red boundary
                    width: 2
                }),
                fill: new ol.style.Fill({
                    color: 'rgba(255,0,0,0.1)'  // Optional: light red fill
                })
            }),
            zIndex: 1000
        });
        mapfilter.addLayer(vectorLayer);
        mapfilter.addOverlay(vectorLayer);
    }
    var range = document.getElementById("ddlrange");
    var filtercolumn = "";
    if (range.value != 'All') {
        filtercolumn = "beat";
    } else {
        filtercolumn = "range";
    }
    var createlayername = "tbl_" + filtercolumn + "_master";
    const layerName = 'uk_sfd:' + createlayername;
    const wfsUrl = 'https://ukforestgis.in/geoserver/uk_sfd/ows';

    const params = new URLSearchParams({
        service: 'WFS',
        version: '1.1.0',
        request: 'GetFeature',
        typeName: layerName,
        outputFormat: 'application/json',
        CQL_FILTER: `${filtercolumn} ILIKE '${rangeValue}'`,
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
        source.clear();  // ✅ Clear previous features

        if (features.length === 0) {
            alert('No features found for range: ' + rangeValue);
            return;
        }

        source.addFeatures(features);

        // Zoom to new features
        const extent = source.getExtent();
        const center = ol.extent.getCenter(extent);

        // Log center in EPSG:4326 (for debug/display)
        const center4326 = ol.proj.transform(center, 'EPSG:3857', 'EPSG:4326');
        console.log('Center in degrees (lon, lat):', center4326);

        // Animate to location
        mapfilter.getView().animate({
            center: center,
            zoom: 11,
            duration: 1000
        });

    } catch (err) {
        console.error('Error loading features:', err);
        alert('Failed to load data.');
    }
}



