<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="proximty.aspx.cs" Inherits="uk_forest.DSS.proximty" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
       <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/ol@6.15.1/ol.css" rel="stylesheet" />
  <script src="https://unpkg.com/jsts@2.11.0/dist/jsts.min.js"></script>
 
    <style>
   /* body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      height: 100vh;
      display: flex;
      overflow: hidden;
    } */
   
    #map-container {
       
      width:100%;
    }

    #map {
      width: 100%;
      height: 100%;
    }

      #sidebar {
          width: 300px;
          background: linear-gradient(180deg, #ffffff, #f1f1f1);
          border-left: 1px solid #ccc;
          box-shadow: -2px 0 5px rgba(0, 0, 0, 0.05);
          padding: 20px;
          position: absolute;
          overflow-y: auto;
          z-index: 1;
          right: 1px;
              top: 2px;
      }

    h2 {
      margin-top: 0;
      color: #333;
      text-align: center;
      font-size: 22px;
    }

    .section {
      margin-bottom: 20px;
    }

    .section h3 {
      margin-bottom: 10px;
      font-size: 16px;
      color: #444;
      border-bottom: 1px solid #ccc;
      padding-bottom: 5px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      cursor: pointer;
    }

    .section h3 span.toggle-icon {
      font-size: 18px;
      color: #007bff;
    }

    .section.collapsible .section-content {
      display: none;
    }

    .section.collapsible.open .section-content {
      display: block;
    }

    label {
      display: block;
      margin-bottom: 8px;
      font-size: 14px;
      cursor: pointer;
      color: #333;
    }

    button {
      width: 100%;
      padding: 12px;
      margin-bottom: 10px;
      background: #007bff;
      border: none;
      color: white;
      font-weight: bold;
      border-radius: 6px;
      font-size: 14px;
      cursor: pointer;
      transition: background 0.3s ease;
    }

    button:hover {
      background: #0056b3;
    }

    button.clear-btn {
      background: #dc3545;
    }

    button.clear-btn:hover {
      background: #a91d2f;
    }

    .ol-popup {
      position: absolute;
      background-color: white;
      padding: 10px;
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
    }

    table {
      font-family: arial, sans-serif;
      border-collapse: collapse;
      width: 100%;
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
      position: absolute;
      z-index: 10;
    }

    #close-feature-popup {
      background: transparent;
      border: none;
      font-size: 18px;
      cursor: pointer;
      float: right;
    }
    .ol-overlay-container{
        position: inherit !important;
    }

    .page-content{
        padding:0px
    }
    .page-content.my-5 .page-container {
    margin-top: 10px;
}
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
 <div id="map-container">
    <div id="map">
      <div id="feature-info-popup" style="display:none;">
        <button id="close-feature-popup">&times;</button>
        <div id="feature-info-content"></div>
      </div>
      <div id="popup" class="ol-popup">
        <div class="popup-title">Intersected Features</div>
        <div id="popup-content" class="popup-content"></div>
      </div>
    </div>

    <div id="sidebar">
      <h2>Map Controls</h2>
      <div class="section collapsible open" id="toggle-layers-section">
        <h3 id="toggle-layers-header">Toggle Layers <span class="toggle-icon">−</span></h3>
        <div class="section-content" id="layer-controls">
          <label><input type="checkbox" data-layer="Roads" checked> Roads</label> 
          <label><input type="checkbox" data-layer="Divisions" checked> Divisions</label> 
          <label><input type="checkbox" data-layer="Water Body" checked> Water Body</label> 
          <label><input type="checkbox" data-layer="Fire Points" checked> Fire Points</label> 
          <label><input type="checkbox" data-layer="Major City" checked> Major City</label> 
          <label><input type="checkbox" data-layer="Plantation" checked> Plantation</label> 
          <label><input type="checkbox" data-layer="Railway Line" checked> Railway Line</label> 
          <label><input type="checkbox" data-layer="Railway Station" checked> Railway Station</label> 
        </div>
      </div>

      <div class="section">
        <h3>Tools</h3>
        <label><input type="checkbox" id="enable-circle"> Enable Circle Intersect Tool</label> 
         <label><input type="checkbox" id="cordinates-circle"> Enable Circle cordinated Tool</label>
        <label style="display:none"><input type="checkbox" id="enable-feature-info"> Enable Feature Info Popup</label>
      </div>

      <div class="section buttons">
        <button id="export-kml" disabled>📁 Export Selected to KML</button>
        <button id="clear-all" class="clear-btn">🧹 Clear All</button>
      </div>
    </div>
  </div>

  <!-- JavaScript -->
<script>
    (function () {
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

            const style = l.point
                ? new ol.style.Style({
                    image: new ol.style.Circle({
                        radius: 5,
                        fill: new ol.style.Fill({ color: l.color }),
                        stroke: new ol.style.Stroke({ color: 'darkred', width: 1 })
                    })
                })
                : new ol.style.Style({
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

        let featureMap = {};
        let selectedFeatures = [];

        function updateExportButtonState() {
            document.getElementById('export-kml').disabled = selectedFeatures.length === 0;
        }

        function getCircleStyle(radiusKm) {
            return new ol.style.Style({
                stroke: new ol.style.Stroke({ color: 'red', width: 2 }),
                fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.1)' }),
                text: new ol.style.Text({
                    text: `Radius: ${radiusKm} km`,
                    font: 'bold 14px Arial',
                    fill: new ol.style.Fill({ color: 'black' }),
                    stroke: new ol.style.Stroke({ color: 'white', width: 3 }),
                    placement: 'point',
                    overflow: true
                })
            });
        }

        function getIntersectedFeaturesHTML(jstsCircle) {
            let content = '';

            wfsLayers.forEach(layer => {
                if (!layer.vectorLayer.getVisible()) return;
                const features = layer.source.getFeatures().filter(f => {
                    const jstsGeom = jstsParser.read(f.getGeometry());
                    return jstsGeom.intersects(jstsCircle);
                });

                if (features.length > 0) {
                    content += `<strong>${layer.name} (${features.length})</strong><br><table><thead><tr>`;
                    const keys = Object.keys(features[0].getProperties()).filter(k => k !== 'geometry');
                    keys.forEach(k => content += `<th>${k}</th>`);
                    content += `</tr></thead><tbody>`;

                    features.forEach((f, i) => {
                        const fid = layer.name + "_" + i;
                        featureMap[fid] = f;
                        content += `<tr data-fid="${fid}">`;
                        keys.forEach(k => content += `<td>${f.get(k)}</td>`);
                        content += `</tr>`;
                    });

                    content += `</tbody></table>`;
                }
            });

            return content;
        }

        function bindPopupTableEvents() {
            document.querySelectorAll('#popup-content table tbody tr').forEach(row => {
                row.addEventListener('click', (event) => {
                    const fid = row.dataset.fid;
                    const feature = featureMap[fid];

                    if (event.ctrlKey) {
                        const index = selectedFeatures.findIndex(f => f.fid === fid);
                        if (index > -1) {
                            selectedFeatures.splice(index, 1);
                            row.classList.remove('highlighted');
                        } else {
                            selectedFeatures.push({ fid, feature });
                            row.classList.add('highlighted');
                        }
                    } else {
                        selectedFeatures = [{ fid, feature }];
                        document.querySelectorAll('tr.highlighted').forEach(r => r.classList.remove('highlighted'));
                        row.classList.add('highlighted');
                    }

                    highlightSource.clear();
                    selectedFeatures.forEach(fObj => {
                        const clone = new ol.Feature({ geometry: fObj.feature.getGeometry().clone() });
                        const geomType = fObj.feature.getGeometry().getType();
                        const style = geomType === 'Point'
                            ? new ol.style.Style({
                                image: new ol.style.Circle({
                                    radius: 6,
                                    fill: new ol.style.Fill({ color: 'blue' }),
                                    stroke: new ol.style.Stroke({ color: 'red', width: 5 })
                                })
                            })
                            : new ol.style.Style({
                                stroke: new ol.style.Stroke({ color: 'blue', width: 5 }),
                                fill: new ol.style.Fill({ color: 'rgba(0, 0, 255, 0.3)' })
                            });

                        clone.setStyle(style);
                        highlightSource.addFeature(clone);
                    });

                    updateExportButtonState();
                });
            });
        }

        function drawCircleAndIntersectFeatures(centerCoord, radiusKm) {
            alert(centerCoord + " " + radiusKm);
            const radius = radiusKm * 1000;
            drawSource.clear();
            highlightSource.clear();
            selectedFeatures = [];
            updateExportButtonState();

            const circlePolygon = ol.geom.Polygon.circular(
                new ol.Sphere(6371008.8),
                ol.proj.toLonLat(centerCoord),
                radius,
                64
            ).transform('EPSG:4326', 'EPSG:3857');

            const circleFeature = new ol.Feature({ geometry: circlePolygon });
            circleFeature.setStyle(getCircleStyle(radiusKm));
            drawSource.addFeature(circleFeature);

            const jstsCircle = jstsParser.read(circlePolygon);
            const popupContent = getIntersectedFeaturesHTML(jstsCircle);

            document.getElementById('popup-content').innerHTML = popupContent || 'No features found.';
            popup.setPosition(centerCoord);
            bindPopupTableEvents();
            featureInfoOverlay.setPosition(undefined);
            featureInfoPopupEl.style.display = 'none';
        }

        map.on('click', function (evt) {
            if (document.getElementById('enable-circle').checked) {
                const radiusKm = parseFloat(prompt('Enter radius in kilometers:'));
                if (!isNaN(radiusKm) && radiusKm > 0) {
                    drawCircleAndIntersectFeatures(evt.coordinate, radiusKm);
                    document.getElementById('enable-circle').checked = false;
                } else {
                    alert('Invalid radius.');
                }
                return;
            }

            if (!document.getElementById('enable-feature-info').checked) {
                featureInfoOverlay.setPosition(undefined);
                featureInfoPopupEl.style.display = 'none';
                return;
            }

            highlightSource.clear();
            let clickedFeature = null;

            map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) {
                if (wfsLayers.some(l => l.vectorLayer === layer && l.vectorLayer.getVisible())) {
                    clickedFeature = feature;
                    return true;
                }
            });

            if (clickedFeature) {
                const clone = new ol.Feature({ geometry: clickedFeature.getGeometry().clone() });
                const geomType = clickedFeature.getGeometry().getType();
                const style = geomType === 'Point'
                    ? new ol.style.Style({
                        image: new ol.style.Circle({
                            radius: 8,
                            fill: new ol.style.Fill({ color: 'blue' }),
                            stroke: new ol.style.Stroke({ color: 'red', width: 3 })
                        })
                    })
                    : new ol.style.Style({
                        stroke: new ol.style.Stroke({ color: 'blue', width: 5 }),
                        fill: new ol.style.Fill({ color: 'rgba(0, 0, 255, 0.3)' })
                    });

                clone.setStyle(style);
                highlightSource.addFeature(clone);

                const props = clickedFeature.getProperties();
                const keys = Object.keys(props).filter(k => k !== 'geometry');
                let infoHtml = `<table><thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>`;
                keys.forEach(k => {
                    infoHtml += `<tr><td>${k}</td><td>${props[k]}</td></tr>`;
                });
                infoHtml += `</tbody></table>`;

                document.getElementById('feature-info-content').innerHTML = infoHtml;
                featureInfoPopupEl.style.display = 'block';
                featureInfoOverlay.setPosition(evt.coordinate);
            }
        });

        document.getElementById('close-feature-popup').addEventListener('click', () => {
            featureInfoOverlay.setPosition(undefined);
            featureInfoPopupEl.style.display = 'none';
            highlightSource.clear();
        });






        document.getElementById('cordinates-circle').addEventListener('change', function () {
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


                drawCircleAndIntersectFeatures(center3857, radiusKm);

                this.checked = false;


            }


        });


















        document.getElementById('export-kml').addEventListener('click', () => {
            if (selectedFeatures.length === 0) return;

            const pinkStyle = new ol.style.Style({
                stroke: new ol.style.Stroke({ color: '#ff00a9', width: 2 }),
                fill: new ol.style.Fill({ color: 'rgba(255, 105, 180, 0.1)' })
            });

            const features = selectedFeatures.map(fObj => {
                const clone = new ol.Feature({ geometry: fObj.feature.getGeometry().clone() });
                const props = fObj.feature.getProperties();
                Object.keys(props).forEach(k => {
                    if (k !== 'geometry') clone.set(k, props[k]);
                });
                clone.setStyle(pinkStyle);
                return clone;
            });

            const kmlFormat = new ol.format.KML({
                extractStyles: true,
                writeStyles: true
            });

            const kml = kmlFormat.writeFeatures(features, {
                featureProjection: 'EPSG:3857'
            });

            const blob = new Blob([kml], { type: 'application/vnd.google-earth.kml+xml' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.href = url;
            link.download = 'selected_features.kml';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(url);

            selectedFeatures = [];
            highlightSource.clear();
            document.querySelectorAll('tr.highlighted').forEach(r => r.classList.remove('highlighted'));
            updateExportButtonState();
        });

        document.getElementById('clear-all').addEventListener('click', () => {
            drawSource.clear();
            highlightSource.clear();
            selectedFeatures = [];
            updateExportButtonState();
            document.getElementById('popup-content').innerHTML = '';
            popup.setPosition(undefined);
            featureInfoOverlay.setPosition(undefined);
            featureInfoPopupEl.style.display = 'none';
            document.getElementById('enable-circle').checked = false;
            document.querySelectorAll('tr.highlighted').forEach(r => r.classList.remove('highlighted'));
        });

    })();







</script>
</asp:Content>
 