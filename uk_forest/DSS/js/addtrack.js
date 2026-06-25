const rasterLayer = new ol.layer.Tile({
    source: new ol.source.OSM()
});

const vectorSource = new ol.source.Vector();
const vectorLayer = new ol.layer.Vector({
    source: vectorSource,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: 'red',
            width: 3
        })
    })
});

const map = new ol.Map({
    target: 'map',
    layers: [rasterLayer, vectorLayer],
    view: new ol.View({
        center: ol.proj.fromLonLat([79.2593, 29.9968]),
        zoom: 8.2
    })
});

let drawInteraction = null;
let isDrawingEnabled = false;
let currentLineCoords = [];

const drawBtn = document.getElementById("drawBtn");
const coordBox = document.getElementById("coordBox");

function enableDrawing(enable) {
    if (enable) {
        // Remove previous interaction if exists
        if (drawInteraction) map.removeInteraction(drawInteraction);

        // Start new draw interaction
        drawInteraction = new ol.interaction.Draw({
            source: vectorSource,
            type: 'LineString'
        });

        map.addInteraction(drawInteraction);

        currentLineCoords = [];

        drawInteraction.on("drawstart", () => {
            console.log("Drawing started...");
        });

        drawInteraction.on("drawend", (evt) => {
            console.log("Line finished.");

            // Get all coordinates in lon lat
            const coords = evt.feature.getGeometry().getCoordinates();
            const lonLatCoords = coords.map(c => {
                const ll = ol.proj.toLonLat(c);
                return `${ll[0].toFixed(6)} ${ll[1].toFixed(6)}`;
            });

            currentLineCoords = lonLatCoords;

            const finalString = currentLineCoords.join(", ");

            console.log("ALL COORDS:", finalString);
            coordBox.innerText = finalString;
            document.getElementById("ContentPlaceHolder1_cordStr").value = finalString
            document.getElementById("ContentPlaceHolder1_btnsavetrack").style.display = 'block';// Disable drawing automatically after one line
            document.getElementById("ContentPlaceHolder1_txttrackName").style.display = 'block';// Disable drawing automatically after one line
            document.getElementById("ContentPlaceHolder1_txtremark").style.display = 'block';// Disable drawing automatically after one line
            isDrawingEnabled = false;
            drawBtn.classList.remove("active");
            drawBtn.textContent = "Enable Draw Line";
            document.getElementById("ContentPlaceHolder1_fuKML").value = "";
            map.removeInteraction(drawInteraction);
            drawInteraction = null;
        });

    } else {
        if (drawInteraction) {
            map.removeInteraction(drawInteraction);
            drawInteraction = null;
        }
    }
}

drawBtn.addEventListener("click", () => {
    if (!isDrawingEnabled) {


        vectorSource.clear();
        currentLineCoords = [];
        coordBox.innerText = "";
        console.clear();
        console.log("Cleared.");
        document.getElementById("ContentPlaceHolder1_cordStr").value = "";
        document.getElementById("ContentPlaceHolder1_btnsavetrack").style.display = 'none';
        document.getElementById("ContentPlaceHolder1_txttrackName").style.display = 'none';// Disable drawing automatically after one line
        document.getElementById("ContentPlaceHolder1_txtremark").style.display = 'none';// Disable drawing automatically after one line

        isDrawingEnabled = true;
        drawBtn.classList.add("active");
        drawBtn.textContent = "Disable Draw Line";
        enableDrawing(true);
    } else {
        // If clicked again while drawing, disable drawing
        isDrawingEnabled = false;
        drawBtn.classList.remove("active");
        drawBtn.textContent = "Enable Draw Line";
        enableDrawing(false);
    }
});

//document.getElementById("clearBtn").addEventListener("click", () => {
//    vectorSource.clear();
//    currentLineCoords = [];
//    coordBox.innerText = "";
//    console.clear();
//    console.log("Cleared.");
//    document.getElementById("ContentPlaceHolder1_cordStr").value = "";
//    document.getElementById("ContentPlaceHolder1_btnsavetrack").style.display = 'none';
//    document.getElementById("ContentPlaceHolder1_txttrackName").style.display = 'none';// Disable drawing automatically after one line
//    document.getElementById("ContentPlaceHolder1_txtremark").style.display = 'none';// Disable drawing automatically after one line
//});


document.getElementById("clearBtn").addEventListener("click", () => {

    // 1️⃣ Clear drawn features
    if (typeof vectorSource !== "undefined") {
        vectorSource.clear();
    }

    // 2️⃣ Clear KML layer if exists
    if (typeof kmlLayer !== "undefined" && kmlLayer !== null) {
        map.removeLayer(kmlLayer);
        kmlLayer = null;
    }

    // 3️⃣ Reset stored KML features array
    if (typeof kmlFeatures !== "undefined") {
        kmlFeatures = [];
    }

    // 4️⃣ Clear line coordinates
    if (typeof currentLineCoords !== "undefined") {
        currentLineCoords = [];
    }

    // 5️⃣ Clear coordinate box text
    coordBox.innerText = "";
    coordBox.style.display = "none";

    // 6️⃣ Clear hidden fields
    document.getElementById("ContentPlaceHolder1_cordStr").value = "";
    document.getElementById("ContentPlaceHolder1_hfjson").value = "";

    // 7️⃣ Hide UI fields
    document.getElementById("ContentPlaceHolder1_btnsavetrack").style.display = 'none';
    document.getElementById("ContentPlaceHolder1_txttrackName").style.display = 'none';
    document.getElementById("ContentPlaceHolder1_txtremark").style.display = 'none';

    // 8️⃣ Clear text fields
    document.getElementById("ContentPlaceHolder1_txttrackName").value = "";
    document.getElementById("ContentPlaceHolder1_txtremark").value = "";

    // 9️⃣ Reset KML file upload
    document.getElementById("ContentPlaceHolder1_fuKML").value = "";

    // 🔟 Remove drawing interaction (if active)
    if (typeof drawInteraction !== "undefined" && drawInteraction !== null) {
        map.removeInteraction(drawInteraction);
    }

    isDrawingEnabled = false;
    drawBtn.classList.remove("active");
    drawBtn.textContent = "Enable Draw Line";
    enableDrawing(false);
     
});



let infoOverlay;
let mapClickListener;
function buildWFSUrl(zone, circle, division, range) {
    const baseUrl = "https://ukforestgis.in/geoserver/uk_sfd/ows";

    let lastSelected = "";

    // If zone is All → always use zone layer
    if (zone === "All") {
        lastSelected = "zone";
    } else {
        // Normal priority: beat → range → division → circle → zone
         if (range && range !== "All") lastSelected = "range";
        else if (division && division !== "All") lastSelected = "division";
        else if (circle && circle !== "All") lastSelected = "circle";
        else lastSelected = "zone";  // zone selected but not All
    }

    // Build layer name
    let layer = `uk_sfd:tbl_${lastSelected}_master`;

    const params = new URLSearchParams({
        service: "WFS",
        version: "1.0.0",
        request: "GetFeature",
        typeName: layer,
        outputFormat: "application/json"
    });

    let filters = [];

    // Filters added normally
    if (zone && zone !== "All") filters.push(`zone='${zone}'`);
    if (circle && circle !== "All") filters.push(`circle='${circle}'`);
    if (division && division !== "All") filters.push(`division='${division}'`);
    if (range && range !== "All") filters.push(`range='${range}'`);
    //if (beat && beat !== "All") filters.push(`beat='${beat}'`);

    if (filters.length > 0) {
        params.set("CQL_FILTER", filters.join(" AND "));
    }

    return `${baseUrl}?${params.toString()}`;
}

var currentFilteredLayer;

function applyfilter() {
    const zone = document.getElementById("ContentPlaceHolder1_ddlzone").value;
    const circle = document.getElementById("ContentPlaceHolder1_ddlcircle").value;
    const division = document.getElementById("ContentPlaceHolder1_ddldivision").value;
    const range = document.getElementById("ContentPlaceHolder1_ddlrange").value;
   // const beat = document.getElementById("ContentPlaceHolder1_ddlbeat").value;

    // ✅ Get selected plantation years from checkbox list
    //const yearCheckboxes = document.querySelectorAll('#chkdatelist input[type="checkbox"]');
    //let selectedYears = [];

    //yearCheckboxes.forEach(cb => {
    //    if (cb.checked) {
    //        selectedYears.push(cb.value);
    //    }
    //});

    const url = buildWFSUrl(zone, circle, division, range);

    console.log("Requesting WFS: " + url);

    // ✅ If layer doesn't exist, create it once
    if (!currentFilteredLayer) {
        const vectorSource = new ol.source.Vector();
        currentFilteredLayer = new ol.layer.Vector({
            source: vectorSource,
            style: new ol.style.Style({
                stroke: new ol.style.Stroke({ color: 'green', width: 2 }),
                fill: new ol.style.Fill({ color: 'rgba(0, 255, 0, 0.01)' })
            })
        });
        map.addLayer(currentFilteredLayer);
    }

    const vectorSource = currentFilteredLayer.getSource();
    vectorSource.clear(); // Remove previous features

    // ✅ Fetch filtered GeoJSON from WFS
    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("Network response was not ok");
            return response.json();
        })
        .then(data => {
            const features = new ol.format.GeoJSON().readFeatures(data, {
                featureProjection: map.getView().getProjection()
            });

            vectorSource.addFeatures(features);
            //console.log('features ' + features);
            //console.log('features ' + features.length);
            if (features.length > 0) {
                const extent = vectorSource.getExtent();
                map.getView().fit(extent, { duration: 1000 });
                map.updateSize();
            } else {
                console.warn("No features found for selected filters.");
            }
        })
        .catch(error => {
            console.error('Error loading features:', error);
        });
}
applyfilter();