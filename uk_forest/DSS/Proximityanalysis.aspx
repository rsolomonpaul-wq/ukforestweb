<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="Proximityanalysis.aspx.cs" Inherits="uk_forest.DSS.topographyProfile" ClientIDMode="Static" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link rel="stylesheet" href="https://unpkg.com/ol@v3.20.1/ol.css" />
  <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>
  <script src="https://unpkg.com/jsts@1.6.2/dist/jsts.min.js"></script>
  <style>
    #map { width: 100%; height: 90vh; position:relative}
    .ol-popup {
      position: absolute !important;
      background-color: white;
      padding: 0px;
      border: 1px solid black;
      bottom: 0px;
      left: 0px;
      min-width: 300px;
      z-index: 1;
      max-height: 35vh;
      overflow: scroll;
      width: 98vw;
    }
   .popup-title {
    font-weight: bold;
    margin-bottom: 10px;
    background-color: antiquewhite;
    padding: 10px;
}
    #layer-controls {
      padding: 10px;
      background: #f2f2f2;
      border-bottom: 1px solid #ccc;
      position: absolute;
      top: 10px;
      right: 10px;
      z-index: 1;
    }
    table {
      font-family: arial, sans-serif;
      border-collapse: collapse;
      width: 100%;
      margin: 10px 0px 20px 0px;
  }

  td, th {
      border: 1px solid #dddddd;
      text-align: left;
      padding: 15px;
  }

  tr:nth-child(even) {
      background-color: #dddddd;
  }
    thead {
      background-color: #f9f9f9;
    }
    tr.highlighted {
      background-color: rgb(96 255 67);
    }

    #feature-info-popup {
      background: white;
      border: 1px solid black;
      padding: 10px;
      min-width: 200px;
      max-height: 200px;
      overflow-y: auto;
      font-size: 12px;
      box-shadow: 2px 2px 6px rgba(0,0,0,0.3);
      border-radius: 4px;
    }
    #close-feature-popup {
      background: transparent;
      border: none;
      font-size: 18px;
      cursor: pointer;
    }
    .divstrong{
      padding: 10px;
    background-color: #73bf3a;
    }
    .divtable{
          width: 100vw;
    overflow: scroll;
    }
  </style>

    <style>
        .page-content.my-5 .page-container {
  margin-top: 10px;
  padding:0px;
}
        .ol-overlay-container {
            position: absolute !important;
            bottom: 0;
            left: 0 !important;
        }
        .page-content {
 padding:0 !important;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
   <div id="layer-controls">
    <strong>Toggle Layers:</strong><br>
    <label><input type="checkbox" data-layer="Roads" checked> Roads</label><br>
    <label><input type="checkbox" data-layer="Divisions" checked> Divisions</label><br>
    <label><input type="checkbox" data-layer="Water Body" checked> Water Body</label><br>
    <label><input type="checkbox" data-layer="Fire Points" checked> Fire Points</label><br>
    <label><input type="checkbox" data-layer="Major City" checked> Major City</label><br>
    <label><input type="checkbox" data-layer="Plantation" checked> Plantation</label><br>
    <label><input type="checkbox" data-layer="Railway Line" checked> Railway Line</label><br>
    <label><input type="checkbox" data-layer="Railway Station" checked> Railway Station</label>
  </div>

    <div style="padding: 10px; background: #f9f9f9; position: absolute; z-index: 1;">
    <label><input type="checkbox" id="enable-circle"> Enable Circle Intersect Tool</label><br>
    <label><input type="checkbox" id="enable-circle-coords"> Enable Circle by Coordinates</label><br>
    <label style="display:none"><input type="checkbox" id="enable-feature-info"> Enable Feature Info Popup</label>
  </div>

 

  <div id="map">

       <div id="popup" class="ol-popup" style="position: absolute;">
    <div class="popup-title">Intersected Features</div>
    <div id="popup-content" class="popup-content"></div>
  </div>
  </div>

  <div id="feature-info-popup" style="display:none;">
    <button id="close-feature-popup" style="float:right;">&times;</button>
    <div id="feature-info-content"></div>
  </div>

<script>
    const map = new ol.Map({
        target: 'map',
        layers: [new ol.layer.Tile({ source: new ol.source.OSM() })],
        view: new ol.View({
            center: ol.proj.fromLonLat([79.2090, 29.9139]),
            zoom: 8
        })
    });

    const jstsParser = new jsts.io.OL3Parser();
    jstsParser.inject(
        ol.geom.Point, ol.geom.LineString, ol.geom.LinearRing,
        ol.geom.Polygon, ol.geom.MultiPoint,
        ol.geom.MultiLineString, ol.geom.MultiPolygon
    );

    const drawSource = new ol.source.Vector();
    const drawLayer = new ol.layer.Vector({ source: drawSource });
    map.addLayer(drawLayer);

    const highlightSource = new ol.source.Vector();
    const highlightLayer = new ol.layer.Vector({ source: highlightSource });
    map.addLayer(highlightLayer);

    const wfsLayers = [
        { name: "Roads", sourceUrl: 'uk_sfd:tbl_uk_road', color: 'black' },
        { name: "Railway Line", sourceUrl: 'uk_sfd:tbl_uk_railway_line', color: 'red' },
        { name: "Railway Station", sourceUrl: 'uk_sfd:tbl_railway_station', point: true, color: 'blue' },
        { name: "Divisions", sourceUrl: 'uk_sfd:tbl_division_master', color: '#FF5733' },
        { name: "Water Body", sourceUrl: 'uk_sfd:tbl_uk_water_body', color: 'blue' },
        { name: "Plantation", sourceUrl: 'uk_sfd:tbl_plantation_area', color: '#1fa811' },
        { name: "Fire Points", sourceUrl: 'uk_sfd:tbl_2022', point: true, color: 'yellow' },
        { name: "Major City", sourceUrl: 'uk_sfd:tbl_major_city', point: true, color: 'red' }
    ].map(l => {
        const source = new ol.source.Vector({
            format: new ol.format.GeoJSON(),
            url: `https://ukforestgis.in/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=${l.sourceUrl}&outputFormat=application/json`,
            strategy: ol.loadingstrategy.all
        });

        const style = l.point ?
            new ol.style.Style({
                image: new ol.style.Circle({
                    radius: 5,
                    fill: new ol.style.Fill({ color: l.color }),
                    stroke: new ol.style.Stroke({ color: 'darkred', width: 1 })
                })
            }) :
            new ol.style.Style({
                stroke: new ol.style.Stroke({ color: l.color, width: 1 }),
                fill: new ol.style.Fill({ color: 'rgba(0, 255, 0, 0.1)' })
            });

        const vectorLayer = new ol.layer.Vector({ source, style });
        map.addLayer(vectorLayer);

        return { ...l, source, vectorLayer };
    });

    document.querySelectorAll('#layer-controls input[type="checkbox"]').forEach(cb => {
        cb.addEventListener('change', function () {
            const layerObj = wfsLayers.find(l => l.name === this.dataset.layer);
            if (layerObj) layerObj.vectorLayer.setVisible(this.checked);
        });
    });

    const popup = new ol.Overlay({ element: document.getElementById('popup') });
    map.addOverlay(popup);

    const featureInfoPopupEl = document.getElementById('feature-info-popup');
    const featureInfoOverlay = new ol.Overlay({
        element: featureInfoPopupEl,
        positioning: 'bottom-center',
        stopEvent: false,
        offset: [0, -10]
    });
    map.addOverlay(featureInfoOverlay);

    // Function to calculate distance in meters between two lon-lat points (haversine)
    function getDistanceMeters(lonLat1, lonLat2) {
        const R = 6371000; // Earth radius in meters
        const toRad = deg => deg * Math.PI / 180;
        const [lon1, lat1] = lonLat1;
        const [lon2, lat2] = lonLat2;
        const dLat = toRad(lat2 - lat1);
        const dLon = toRad(lon2 - lon1);
        const a = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) ** 2;
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    function drawCircleAndShowResults(centerLonLat, radiusMeters, evtCoordinate) {
        drawSource.clear();
        highlightSource.clear();

        const circlePolygon = ol.geom.Polygon.circular(
            new ol.Sphere(6371008.8), centerLonLat, radiusMeters, 64
        ).transform('EPSG:4326', 'EPSG:3857');

        const circleFeature = new ol.Feature({ geometry: circlePolygon });

        circleFeature.setStyle(new ol.style.Style({
            stroke: new ol.style.Stroke({ color: 'red', width: 2 }),
            fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.1)' }),
            text: new ol.style.Text({
                text: `Radius: ${(radiusMeters / 1000).toFixed(3)} km`,
                font: 'bold 14px Arial',
                fill: new ol.style.Fill({ color: 'black' }),
                stroke: new ol.style.Stroke({ color: 'white', width: 3 }),
                placement: 'point',
                overflow: true
            })
        }));

        drawSource.addFeature(circleFeature);

        const jstsCircle = jstsParser.read(circlePolygon);
        let popupContent = ``;
        let found = false;
        let featureMap = {};

        wfsLayers.forEach(layer => {
            if (!layer.vectorLayer.getVisible()) return;
            const features = layer.source.getFeatures().filter(f => {
                const jstsGeom = jstsParser.read(f.getGeometry());
                return jstsGeom.intersects(jstsCircle);
            });

            if (features.length > 0) {
                found = true;

                popupContent += `<div class="divstrong"><strong>${layer.name} (${features.length})</strong></div><br> <div class="divtable"><table id="${(layer.name).replace(/\s+/g, '')}"><thead><tr>`;
                const keys = Object.keys(features[0].getProperties()).filter(k => k !== 'geometry');
                keys.forEach(k => popupContent += `<th>${k}</th>`);
                popupContent += `</tr></thead><tbody>`;

                features.forEach((f, i) => {
                    const fid = layer.name + "_" + i;
                    featureMap[fid] = f;
                    popupContent += `<tr data-fid="${fid}">`;
                    keys.forEach(k => popupContent += `<td>${f.get(k)}</td>`);
                    popupContent += `</tr>`;
                });

                popupContent += `</tbody></table></div>`;
            }
        });

        document.getElementById('popup-content').innerHTML = popupContent || 'No features found.';
        popup.setPosition(evtCoordinate);

        document.querySelectorAll('#popup-content table tbody tr').forEach(row => {
            row.addEventListener('click', () => {
                document.querySelectorAll('tr.highlighted').forEach(r => r.classList.remove('highlighted'));
                row.classList.add('highlighted');
                highlightSource.clear();

                const feature = featureMap[row.dataset.fid];
                const clonedFeature = new ol.Feature({
                    geometry: feature.getGeometry().clone()
                });

                const geomType = feature.getGeometry().getType();
                let highlightStyle;

                if (geomType === 'Point') {
                    highlightStyle = new ol.style.Style({
                        image: new ol.style.Circle({
                            radius: 6,
                            fill: new ol.style.Fill({ color: 'blue' }),
                            stroke: new ol.style.Stroke({ color: 'blue', width: 5 })
                        })
                    });
                } else {
                    highlightStyle = new ol.style.Style({
                        stroke: new ol.style.Stroke({ color: 'blue', width: 5 }),
                        fill: new ol.style.Fill({ color: 'blue' })
                    });
                }

                clonedFeature.setStyle(highlightStyle);
                highlightSource.addFeature(clonedFeature);
            });
        });

        featureInfoOverlay.setPosition(undefined);
        featureInfoPopupEl.style.display = 'none';
    }

    // Event handler for map clicks
    map.on('click', function (evt) {
        // Disable if circle-by-coords enabled (handled separately)
        if (document.getElementById('enable-circle-coords').checked) return;

        if (document.getElementById('enable-circle').checked) {
            const radiusKm = prompt('Enter radius in kilometers:');
            const radius = parseFloat(radiusKm) * 1000;
            if (isNaN(radius) || radius <= 0) return alert('Invalid radius.');

            const centerLonLat = ol.proj.toLonLat(evt.coordinate);
            drawCircleAndShowResults(centerLonLat, radius, evt.coordinate);

            document.getElementById('enable-circle').checked = false;
            return;
        }

        if (!document.getElementById('enable-feature-info').checked) {
            featureInfoOverlay.setPosition(undefined);
            featureInfoPopupEl.style.display = 'none';
            return;
        }

        highlightSource.clear();

        const pixel = evt.pixel;
        let clickedFeature = null;

        map.forEachFeatureAtPixel(pixel, function (feature, layer) {
            if (wfsLayers.some(l => l.vectorLayer === layer && l.vectorLayer.getVisible())) {
                clickedFeature = feature;
                return true;
            }
        });

        if (!clickedFeature) {
            featureInfoOverlay.setPosition(undefined);
            featureInfoPopupEl.style.display = 'none';
            return;
        }

        const props = clickedFeature.getProperties();
        let content = '<table>';
        Object.entries(props).forEach(([k, v]) => {
            if (k !== 'geometry') {
                content += `<tr><th>${k}</th><td>${v}</td></tr>`;
            }
        });
        content += '</table>';

        document.getElementById('feature-info-content').innerHTML = content;
        featureInfoOverlay.setPosition(evt.coordinate);
        featureInfoPopupEl.style.display = 'block';
    });

    // Close feature info popup button
    document.getElementById('close-feature-popup').addEventListener('click', () => {
        featureInfoOverlay.setPosition(undefined);
        featureInfoPopupEl.style.display = 'none';
    });

    // Circle by coordinates checkbox handler
    document.getElementById('enable-circle-coords').addEventListener('change', function () {
        if (this.checked) {
            const input = prompt("Enter center latitude, longitude and radius in km separated by commas:\nExample:\n29.9139, 79.2090, 5");

            if (!input) {
                this.checked = false;
                return;
            }

            const parts = input.split(',').map(s => s.trim());
            if (parts.length !== 3) {
                alert('Please enter exactly three values: latitude, longitude, radius_km');
                this.checked = false;
                return;
            }

            const lat = parseFloat(parts[0]);
            const lon = parseFloat(parts[1]);
            const radiusKm = parseFloat(parts[2]);

            if (
                isNaN(lat) || lat < -90 || lat > 90 ||
                isNaN(lon) || lon < -180 || lon > 180 ||
                isNaN(radiusKm) || radiusKm <= 0
            ) {
                alert('Invalid values entered. Please enter valid lat, lon and radius.');
                this.checked = false;
                return;
            }

            const radiusMeters = radiusKm * 1000;
            const centerLonLat = [lon, lat];
            const center3857 = ol.proj.fromLonLat(centerLonLat);

            drawCircleAndShowResults(centerLonLat, radiusMeters, center3857);

            this.checked = false;
        }
    });
</script>
</asp:Content>
