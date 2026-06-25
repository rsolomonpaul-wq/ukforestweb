
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
function applyfilter(filter) {
  


    mapfilter.removeLayer(heatmapLayer);
    mapfilter.removeOverlay(heatmapLayer);
    //mapfilter.removeLayer(boundrayfilter);
    //mapfilter.removeOverlay(boundrayfilter);

    if (filter == "") {
        heatmapLayer = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                ratio: 1,
                url: geoserver_ip,
                params: {
                    'FORMAT': format,
                    tiled: true,
                    STYLES: '',
                    layers: 'uk_sfd:tbl_wl_conflict',
                    //CQL_FILTER: filter,
                    transition: 0
                }, serverType: 'geoserver',
                crossOrigin: 'anonymous'

            })
        });
    } else {
        heatmapLayer = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                ratio: 1,
                url: geoserver_ip,
                params: {
                    'FORMAT': format,
                    tiled: true,
                    STYLES: '',
                    layers: 'uk_sfd:tbl_wl_conflict',
                    CQL_FILTER: filter,
                    transition: 0
                }, serverType: 'geoserver',
                crossOrigin: 'anonymous'

            })
        });
    }
       



    



    mapfilter.addLayer(heatmapLayer);
    mapfilter.addOverlay(heatmapLayer);


}
//const heatmapLayer = new ol.layer.Heatmap({
//    source: new ol.source.Vector({
//        url: 'https://ukforestgis.in/geoserver/uk_sfd/wms?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_2021&outputFormat=application/json',
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
    var action = document.getElementById("ddlaction").value;

    var layout = {
        height: 300,
        width: 600,
        paper_bgcolor: 'rgb(0,0,0)',   // Transparent outer background
        plot_bgcolor: 'rgb(0,0,0)',    // Transparent plot area

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
                text: 'Count',
                font: { size: 16, color: 'white' }
            },
            tickfont: { color: 'white', size: 14 }
        },
        margin: { t: 60 }
    };

    Plotly.newPlot('chartpie1', datanew, layout);

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
    if (action != "Fire Points") {
        const columnCount = table.querySelectorAll("tr th").length;

        roundNumericCells(table);

        // Apply flat colors only if 3 or fewer columns
        if (columnCount != 0) {
            applyFlatColorsForThreeOrLess(table, columnCount);
        }
    }

}


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

function togglechart() {
    const container = document.getElementById("chart-container");
    const arrow = document.getElementById("arrowchart");
    container.classList.toggle("hidden");
    arrow.classList.toggle("rotate");
}




