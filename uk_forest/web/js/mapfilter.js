
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
 





var source1 = new ol.source.Vector();
const mapfilter = new ol.Map({
    target: 'mapfilter',
    layers: [
        new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}.png?api_key=8d560c7b-e982-42f5-8dab-23bf9595e03c',
                attributions: [
                    '&copy; <a href="https://www.stadiamaps.com/" target="_blank">Stadia Maps</a>',
                    '&copy; <a href="https://openmaptiles.org/" target="_blank">OpenMapTiles</a>',
                    '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a> contributors'
                ],
                minZoom: 0,
                maxZoom: 20
            })
        })
    ],
    view: new ol.View({
        center: ol.proj.fromLonLat([80.0193, 30.0668]),
        zoom: 8,
        minZoom: 3,
        maxZoom: 18
    })
});


window.onload = function () {

    //mapfilter.addOverlay(district_layer);
    //mapfilter.addLayer(district_layer);
   
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
var heatmapLayer;
var boundrayfilter;
var layername;
function applyfilter() {
    var year = document.getElementById("ddlyear").value;
    var zone = document.getElementById("ddlzone").value;
    var circle = document.getElementById("ddlcircle").value;
    var division = document.getElementById("ddldivision").value;
    var action = document.getElementById("ddlaction").value;

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
    }
    //if (action) filterParts.push("action = '" + action + "'");
   
    mapfilter.removeLayer(heatmapLayer);
    mapfilter.removeOverlay(heatmapLayer);
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
    if (action == "Fire Points") {
        var linegrapg = document.getElementById("mydivbar");
        linegrapg.style.display = "none";
        var bargraph = document.getElementById("chartpie1");
        bargraph.style.display = "block";
       
       
        if (cqlFilter == "") {
            heatmapLayer = new ol.layer.Heatmap({
                source: new ol.source.Vector({
                    url: `http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:${year}&outputFormat=application/json`,
                    format: new ol.format.GeoJSON()
                }),
                blur: 5,
                radius: 2,
                weight: function (feature) {
                    return feature.get('intensity') || 1;
                }
            });
            heatmapLayer.setGradient([
                '#fff5e6', // very light orange (low intensity)
                '#ffd699', // soft orange
                '#ffa64d', // medium orange
                '#ff8000', // rich orange
                '#ffff00'  // dark orange (high intensity)
            ]);

            layername = "tbl_" + findboundarylayer + "_master";

            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: '',
                        layers: 'uk_sfd:' + layername,

                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });




        } else {
            heatmapLayer = new ol.layer.Heatmap({
                source: new ol.source.Vector({
                    url: `http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:${year}&outputFormat=application/json&CQL_FILTER=${encodeURIComponent(cqlFilter)}`,
                    format: new ol.format.GeoJSON()
                }),
                blur: 5,
                radius: 2,
                weight: function (feature) {
                    return feature.get('intensity') || 1;
                }
            });
            heatmapLayer.setGradient([
                '#fff5e6', // very light orange (low intensity)
                '#ffd699', // soft orange
                '#ffa64d', // medium orange
                '#ff8000', // rich orange
                '#ffff00'  // dark orange (high intensity)
            ]);

            layername = "tbl_" + findboundarylayer + "_master";

            boundrayfilter = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: '',
                        layers: 'uk_sfd:' + layername,
                        CQL_FILTER: findboundarylayerfilter,
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });
        }


    } else if (action == "Forest Density") {
        var linegrapg = document.getElementById("mydivbar");
        linegrapg.style.display = "block";
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
                    layers: 'uk_sfd:uttarakhand_forest_Density_2021_FSI',

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
                        STYLES: '',
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
                        STYLES: '',
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
        var linegrapg = document.getElementById("mydivbar");
        linegrapg.style.display = "block";
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
                        STYLES: '',
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
                        STYLES: '',
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
    mapfilter.addOverlay(heatmapLayer);

    mapfilter.addLayer(boundrayfilter);
    mapfilter.addOverlay(boundrayfilter);

}
//const heatmapLayer = new ol.layer.Heatmap({
//    source: new ol.source.Vector({
//        url: 'http://180.151.15.18:9007/geoserver/uk_sfd/wms?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_2021&outputFormat=application/json',
//        format: new ol.format.GeoJSON()
//    }),
//    blur: 5,
//    radius: 2,
//    weight: function (feature) {
//        return feature.get('intensity') || 1; // Adjust attribute name
//    }
//});



function myJsFunction(a, b, areaboundary) {











    var aa = a.trim();
    var bb = b.trim();
    var areaboundary = areaboundary.trim();

    var lbls = aa.split(' ');
    var vals = bb.split(' ');
     areaboundary = areaboundary.split(' ');

    // Plain solid colors for each bar
     

    //var data = [
    //    {
    //        x: lbls,
    //        y: vals,
    //        type: 'bar',
    //        name: 'Month Wise Forest Fire',
    //        showlegend: true
             
    //    }
    //];
 

    //var layout = {
    //    paper_bgcolor: 'rgba(0,0,0,0)',   // 👉 Background outside the plotting area
    //    plot_bgcolor: 'rgba(0,0,0,0)',    // 👉 Background inside the plotting area
    //    legend: {
    //        orientation: 'h',
    //        y: 1.1,
    //        x: 0.5,
    //        xanchor: 'center',
    //        font: {
    //            family: 'Arial',
    //            size: 14,
    //            color: 'black'
    //        }
    //    },
    //    margin: {
    //        t: 60
    //    }
    //};

    //Plotly.newPlot('chartpie1', data, layout);





    var trace1 = {
        x: lbls,
        y: vals,
        type: 'scatter',
        name: 'Month Wise Forest Fire11',
        showlegend: false,
        marker: {
            color: 'orange'  // Replace with as many colors as needed
        }

    };

    var trace2 = {
        x: lbls,
        y: vals,
        type: 'bar',
        name: 'Month Wise Forest Fire',
           showlegend: true,
        marker: {
            color: '#4ED7F1'  // Replace with as many colors as needed
            //color: [  'blue', 'green', 'orange', 'purple',   'blue', 'green', 'orange', 'purple',   'blue', 'green', 'orange', 'purple']  // Replace with as many colors as needed
        }
    };

    var datanew = [trace1, trace2];


    var layout = {
        height: 600,
        paper_bgcolor: 'rgba(0,0,0,0)',   // Transparent outer background
        plot_bgcolor: 'rgba(0,0,0,0)',    // Transparent plot area
        legend: {
            orientation: 'h',
            y: 1.1,
            x: 0.5,
            xanchor: 'center',
            font: {
                family: 'Arial Black',
                size: 14,
                color: 'white'          // Legend text color white
            }
        },
        xaxis: {
            tickfont: {
                color: 'white'          // X-axis labels in white
            }
        },
        yaxis: {
            tickfont: {
                color: 'white'          // Y-axis labels in white
            }
        },
        margin: { t: 60 }
    };

    Plotly.newPlot('chartpie1', datanew, layout);















    var trace1 = {
        x: lbls,
        y: vals,
        type: 'scatter', name: '',
        showlegend: true
    };


    var data1 = [trace1];

    var layout = {
        legend: {
            orientation: 'h',       // horizontal legend
            y: 1.1,                 // position above the chart
            x: 0.5,
            xanchor: 'center',
            font: {
                family: 'Arial Black', // bold font family
                size: 14,
                color: 'black'
            }
        },
        margin: { t: 60 }          // top margin to give space for legend
    };

    Plotly.newPlot('myDivline', data1, layout);

    var trace = {
        labels: [
            '(Garhwal)',
            '(Kumaun)',
            '(Wildlife)'
        ],
        values: [
            10722.55, 9961.46,
            6189.34, 14386.13,
            11274.26, 944.15
        ],
        type: 'pie',
        textinfo: 'label+percent',
        insidetextorientation: 'radial'
    };

    var data = [trace];

    var layout = {
        legend: {
            orientation: 'h',       // 👈 horizontal (top)
            y: 1.1,                 // 👈 move slightly above chart
            x: 0.5,
            xanchor: 'center',
            font: {
                family: 'Arial',
                size: 14,
                color: 'black',
                // 👇 Bold text:
                // Plotly doesn’t support font-weight directly, so use a bold font or simulate it
            }
        },
        margin: {
            t: 60                   // leave space for legend above
        }
    };

    Plotly.newPlot('myDivpie', data, layout);
}
//////////////////////// 

//mapfilter.on('click', function () {
//    alert("map clicked");
//})

//Plotly.newPlot('chartpie2', data2);