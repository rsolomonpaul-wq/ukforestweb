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