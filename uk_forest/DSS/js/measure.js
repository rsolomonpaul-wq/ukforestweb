////// ========================== Global Variables ========================== //
////let tooltipEl, tooltip;
////let undoStack = [], redoStack = [], measureTooltips = [];
////let draw, sketch, measureTooltipElement, measureTooltip;

////const wgs84Sphere = new ol.Sphere(6378137);
////const source = new ol.source.Vector();

////// ========================== Measurement Layer ========================== //
////const measureVectorLayer = new ol.layer.Vector({
////    source: source,
////    style: new ol.style.Style({
////        stroke: new ol.style.Stroke({
////            color: '#ffcc33',
////            width: 2
////        }),
////        image: new ol.style.Circle({
////            radius: 5,
////            fill: new ol.style.Fill({ color: '#ffcc33' })
////        })
////    })
////});
////map1.addLayer(measureVectorLayer);

////// ========================== Measure Interaction ========================== //
////function addMeasureInteraction(type) {
////    if (draw) map1.removeInteraction(draw);

////    draw = new ol.interaction.Draw({
////        source: source,
////        type: type,
////        style: new ol.style.Style({
////            stroke: new ol.style.Stroke({
////                color: '#ff0000',
////                width: 2,
////                lineDash: [10, 10]
////            }),
////            image: new ol.style.Circle({
////                radius: 5,
////                fill: new ol.style.Fill({ color: '#ff0000' })
////            }),
////            fill: new ol.style.Fill({
////                color: 'rgba(255, 0, 0, 0.1)'
////            })
////        })
////    });

////    map1.addInteraction(draw);

////    draw.on('drawstart', function (evt) {
////        sketch = evt.feature;
////        createMeasureTooltip();

////        const geom = sketch.getGeometry();
////        geom.on('change', function (evt) {
////            const geometry = evt.target;
////            let output, position;

////            if (geometry instanceof ol.geom.Polygon) {
////                output = formatArea(geometry);
////                position = geometry.getInteriorPoint().getCoordinates();
////            } else if (geometry instanceof ol.geom.LineString) {
////                output = formatLength(geometry);
////                position = geometry.getLastCoordinate();
////            }

////            measureTooltipElement.innerHTML = output;
////            measureTooltip.setPosition(position);
////        });
////    });

////    draw.on('drawend', function (evt) {
////        measureTooltipElement.className = 'tooltip tooltip-measure tooltip-static';
////        measureTooltip.setOffset([0, -7]);

////        evt.feature.setStyle(new ol.style.Style({
////            stroke: new ol.style.Stroke({
////                color: '#00008b',
////                width: 2
////            }),
////            fill: new ol.style.Fill({
////                color: 'rgba(0, 0, 139, 0.1)'
////            }),
////            image: new ol.style.Circle({
////                radius: 5,
////                fill: new ol.style.Fill({ color: '#00008b' })
////            })
////        }));

////        undoStack.push({ feature: evt.feature, tooltip: measureTooltip });
////        redoStack = [];

////        sketch = null;
////        measureTooltipElement = null;
////        measureTooltip = null;
////    });
////}

////// ========================== Tooltip Creation ========================== //
////function createMeasureTooltip() {
////    if (measureTooltipElement) {
////        measureTooltipElement.parentNode?.removeChild(measureTooltipElement);
////    }

////    measureTooltipElement = document.createElement('div');
////    measureTooltipElement.className = 'tooltip tooltip-measure';

////    measureTooltip = new ol.Overlay({
////        element: measureTooltipElement,
////        offset: [0, -15],
////        positioning: 'bottom-center'
////    });

////    map1.addOverlay(measureTooltip);
////    measureTooltips.push(measureTooltip);
////}

////// ========================== Format Length & Area ========================== //
////function formatLength(line) {
////    let length = 0;
////    const coordinates = line.getCoordinates();
////    const sourceProj = map1.getView().getProjection();

////    for (let i = 0; i < coordinates.length - 1; ++i) {
////        const c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
////        const c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326');
////        length += wgs84Sphere.haversineDistance(c1, c2);
////    }

////    return length > 100
////        ? (Math.round(length / 1000 * 100) / 100) + ' km'
////        : (Math.round(length * 100) / 100) + ' m';
////}

////function formatArea(polygon) {
////    const sourceProj = map1.getView().getProjection();
////    const geom = polygon.clone().transform(sourceProj, 'EPSG:4326');
////    const coordinates = geom.getLinearRing(0).getCoordinates();
////    const area = Math.abs(wgs84Sphere.geodesicArea(coordinates));

////    return area > 10000
////        ? (Math.round(area / 1000000 * 100) / 100) + ' km²'
////        : (Math.round(area * 100) / 100) + ' m²';
////}

////// ========================== Undo, Redo ========================== //
////function undoLastFeature() {
////    if (undoStack.length > 0) {
////        const { feature, tooltip } = undoStack.pop();
////        source.removeFeature(feature);
////        map1.removeOverlay(tooltip);
////        redoStack.push({ feature, tooltip });
////    }
////}

////function redoLastFeature() {
////    if (redoStack.length > 0) {
////        const { feature, tooltip } = redoStack.pop();
////        source.addFeature(feature);
////        map1.addOverlay(tooltip);
////        undoStack.push({ feature, tooltip });
////    }
////}

////// ========================== Clear All ========================== //
////function clearAll() {
////    source.clear();
////    measureTooltips.forEach(tip => map1.removeOverlay(tip));
////    measureTooltips = [];
////    undoStack = [];
////    redoStack = [];
////}

////// ========================== Tool Button Events ========================== //
////let activeTool = null;

////const toolButtons = {
////    measureLine: 'LineString',
////    measureArea: 'Polygon'
////};

////Object.entries(toolButtons).forEach(([id, type]) => {
////    const button = document.getElementById(id);
////    alert(button);
////    if (!button) {
////        console.warn(`Element with id '${id}' not found.`);
////        return;
////    }

////    button.addEventListener('click', function () {
////        const isActive = activeTool === id;

////        // Remove existing interaction
////        if (draw) map1.removeInteraction(draw);
////        draw = null;

////        // Remove active class from all tool buttons
////        document.querySelectorAll('.tool-btn').forEach(btn => btn.classList.remove('active'));

////        if (!isActive) {
////            this.classList.add('active');
////            activeTool = id;
////            addMeasureInteraction(type);
////        } else {
////            activeTool = null;
////        }
////    });
////});

////// Uncomment if you have undo/redo/clear buttons
//// document.getElementById('clearAllBtn').addEventListener('click', clearAll);
//// document.getElementById('undoBtn').addEventListener('click', undoLastFeature);
//// document.getElementById('redoBtn').addEventListener('click', redoLastFeature);

const wgs84Sphere = new ol.Sphere(6378137); // ✅ OL 4.6.5 uses ol.Sphere (not ol.sphere)

//const map1 = new ol.Map({
//    target: 'map',
//    layers: [
//        new ol.layer.Tile({ source: new ol.source.OSM() })
//    ],
//    view: new ol.View({
//        center: ol.proj.fromLonLat([0, 0]),
//        zoom: 2
//    })
//});

const source11 = new ol.source.Vector();
const measureVectorLayer = new ol.layer.Vector({
    source: source11,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({ color: '#ffcc33', width: 2 }),
        image: new ol.style.Circle({ radius: 5, fill: new ol.style.Fill({ color: '#ffcc33' }) })
    })
});
map1.addLayer(measureVectorLayer);

let draw, sketch, measureTooltipElement, measureTooltip;
let undoStack = [], redoStack = [], measureTooltips = [];

function formatLength(line) {
    const coordinates = line.getCoordinates();
    const sourceProj = map1.getView().getProjection();
    let length = 0;
    for (let i = 0; i < coordinates.length - 1; ++i) {
        const c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
        const c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326');
        length += wgs84Sphere.haversineDistance(c1, c2); // ✅ Use haversineDistance in OL 4
    }
    return length > 100
        ? (Math.round(length / 1000 * 100) / 100) + ' km'
        : (Math.round(length * 100) / 100) + ' m';
}

function formatArea(polygon) {
    const sourceProj = map1.getView().getProjection();
    const geom = polygon.clone().transform(sourceProj, 'EPSG:4326');
    const coordinates = geom.getLinearRing(0).getCoordinates();
    const area = Math.abs(wgs84Sphere.geodesicArea(coordinates)); // ✅ OL 4 version
    return area > 10000
        ? (Math.round(area / 1000000 * 100) / 100) + ' km²'
        : (Math.round(area * 100) / 100) + ' m²';
}

function createMeasureTooltip() {
    if (measureTooltipElement) {
        measureTooltipElement.parentNode?.removeChild(measureTooltipElement);
    }
    measureTooltipElement = document.createElement('div');
    measureTooltipElement.className = 'tooltip tooltip-measure';
    measureTooltip = new ol.Overlay({
        element: measureTooltipElement,
        offset: [0, -15],
        positioning: 'bottom-center'
    });
    map1.addOverlay(measureTooltip);
    measureTooltips.push(measureTooltip);
}

function addMeasureInteraction(type) {
    if (draw) map1.removeInteraction(draw);
    draw = new ol.interaction.Draw({
        source: source11,
        type: /** @type {ol.geom.GeometryType} */ (type),
        style: new ol.style.Style({
            stroke: new ol.style.Stroke({ color: '#ff0000', width: 2, lineDash: [10, 10] }),
            image: new ol.style.Circle({ radius: 5, fill: new ol.style.Fill({ color: '#ff0000' }) }),
            fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.1)' })
        })
    });
    map1.addInteraction(draw);

    draw.on('drawstart', function (evt) {
        sketch = evt.feature;
        createMeasureTooltip();
        const geom = sketch.getGeometry();
        geom.on('change', function (evt) {
            const geometry = evt.target;
            let output, position;
            if (geometry instanceof ol.geom.Polygon) {
                output = formatArea(geometry);
                position = geometry.getInteriorPoint().getCoordinates();
            } else if (geometry instanceof ol.geom.LineString) {
                output = formatLength(geometry);
                position = geometry.getLastCoordinate();
            }
            measureTooltipElement.innerHTML = output;
            measureTooltip.setPosition(position);
        });
    });

    draw.on('drawend', function (evt) {
        measureTooltipElement.className = 'tooltip tooltip-measure tooltip-static';
        measureTooltip.setOffset([0, -7]);
        evt.feature.setStyle(new ol.style.Style({
            stroke: new ol.style.Stroke({ color: '#00008b', width: 2 }),
            fill: new ol.style.Fill({ color: 'rgba(0, 0, 139, 0.1)' }),
            image: new ol.style.Circle({ radius: 5, fill: new ol.style.Fill({ color: '#00008b' }) })
        }));
        undoStack.push({ feature: evt.feature, tooltip: measureTooltip });
        redoStack = [];
        sketch = null;
        measureTooltipElement = null;
        measureTooltip = null;
    });
}

function undoLastFeature() {
    if (undoStack.length > 0) {
        const { feature, tooltip } = undoStack.pop();
        source11.removeFeature(feature);
        map1.removeOverlay(tooltip);
        redoStack.push({ feature, tooltip });
    }
}

function redoLastFeature() {
    if (redoStack.length > 0) {
        const { feature, tooltip } = redoStack.pop();
        source11.addFeature(feature);
        map1.addOverlay(tooltip);
        undoStack.push({ feature, tooltip });
    }
}

function clearAll() {
    source11.clear();
    measureTooltips.forEach(tip => map1.removeOverlay(tip));
    measureTooltips = [];
    undoStack = [];
    redoStack = [];
}

let activeTool = null;
const toolButtons = {
    measureLine: 'LineString',
    measureArea: 'Polygon'
};

Object.entries(toolButtons).forEach(([id, type]) => {
    const button = document.getElementById(id);
    if (!button) return;

    button.addEventListener('click', function () {
        const isActive = activeTool === id;

        // Remove any existing interaction
        if (draw) map1.removeInteraction(draw);
        draw = null;

        // Clear active class from all tool buttons
        document.querySelectorAll('.tool-btn').forEach(btn => btn.classList.remove('active'));

        if (!isActive) {
            this.classList.add('active');
            activeTool = id;

            // ✅ Show alert
           // alert(`${type === 'LineString' ? 'Measure Line' : 'Measure Area'} tool selected`);

            addMeasureInteraction(type);
        } else {
            activeTool = null;
        }
    });
});


document.getElementById('clearAllBtn').addEventListener('click', clearAll);
document.getElementById('undoBtn').addEventListener('click', undoLastFeature);
document.getElementById('redoBtn').addEventListener('click', redoLastFeature);