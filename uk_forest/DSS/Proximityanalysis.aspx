<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="Proximityanalysis.aspx.cs" Inherits="uk_forest.DSS.topographyProfile" ClientIDMode="Static" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   <link rel="stylesheet" href="https://unpkg.com/ol@v3.20.1/ol.css" />
  <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>
  <script src="https://unpkg.com/jsts@1.6.2/dist/jsts.min.js"></script>
  <style>
      #map {
          width: 100%;
          height: calc(100vh - 100px) !important;
      }

      canvas.ol-unselectable {
          height: calc(100vh - 100px) !important;
      }

      .page-content.my-5 .page-container {
          margin: 0;
          padding: 0;
      }
      .page-content.my-5 {
          margin:0px !important
}
    .ol-popup {
      position: fixed !important;
    background-color: white;
    padding: 10px;
    border: 1px solid black;
    top: 85px;
    left: 290px;
    min-width: 200px;
    z-index: 9999;
    }

    .popup-content {
      font-size: 14px;
    }

    .popup-title {
      font-weight: bold;
      margin-bottom: 10px;
    }

    .popup-attributes {
      font-size: 12px;
    }

    #popup-content {
      max-height: 680px;
      overflow: auto;
      height: 675px;
    }

    #layer-controls {
      padding: 10px;
      background: #f2f2f2;
      border-bottom: 1px solid #ccc;
    }
    div#layer-controls {
        position: absolute;
    z-index: 1;
    right: 12px;
    padding: 11px;
    width: 250px;
    top: 40px;
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
  <div class="mainhead">
    <div id="popup" class="ol-popup">
      <div class="popup-title"></div>
      <div id="popup-content" class="popup-content"></div>
    </div>
    <br>
    <div id="map">
        <div id="layer-controls">
            <strong>Toggle Layers:</strong><br>
           <label><input type="checkbox" data-layer="Roads" checked> Roads</label><br>
    <label><input type="checkbox" data-layer="Divisions" checked> Divisions</label><br>
    <label><input type="checkbox" data-layer="Water Body" checked> Water Body</label><br>
    <label><input type="checkbox" data-layer="Fire Points" checked> Fire Points</label><br>
    <label><input type="checkbox" data-layer="Major City" checked> Major City</label><br>
    <label><input type="checkbox" data-layer="Plantation" checked> Plantation</label><br>
    <%--<label><input type="checkbox" data-layer="Fire Points" checked> Fire Points</label><br>--%>
    <label><input type="checkbox" data-layer="Railway Line" checked> Railway line</label><br>
    <label><input type="checkbox" data-layer="Railway Station" checked> Railway Station</label>
          </div>

    </div>
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
            ol.geom.Point,
            ol.geom.LineString,
            ol.geom.LinearRing,
            ol.geom.Polygon,
            ol.geom.MultiPoint,
            ol.geom.MultiLineString,
            ol.geom.MultiPolygon
        );

        const drawSource = new ol.source.Vector();
        const drawLayer = new ol.layer.Vector({ source: drawSource });
        map.addLayer(drawLayer);

        const wfsLayers = [
            {
                name: "Roads",
                source: new ol.source.Vector({
                    format: new ol.format.GeoJSON(),
                    url: 'http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_uk_road&outputFormat=application/json',
                    strategy: ol.loadingstrategy.all
                }),
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: 'black', width: 1 }),
                    fill: new ol.style.Fill({ color: 'rgba(0, 255, 0, 0.1)' })
                })
            },
            {
                name: "Railway Line",
                source: new ol.source.Vector({
                    format: new ol.format.GeoJSON(),
                    url: 'http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_uk_railway_line&outputFormat=application/json',
                    strategy: ol.loadingstrategy.all
                }),
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: 'red', width: 1 }),
                    fill: new ol.style.Fill({ color: 'rgba(0, 255, 0, 0.1)' })
                })
            }, {
                name: "Railway Station",
                source: new ol.source.Vector({
                    format: new ol.format.GeoJSON(),
                    url: 'http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_railway_station&outputFormat=application/json',
                    strategy: ol.loadingstrategy.all
                }),
                style: new ol.style.Style({
                    image: new ol.style.Circle({
                        radius: 5,
                        fill: new ol.style.Fill({ color: 'blue' }),
                        stroke: new ol.style.Stroke({ color: 'darkred', width: 1 })
                    })
                })
            },
            {
                name: "Divisions",
                source: new ol.source.Vector({
                    format: new ol.format.GeoJSON(),
                    url: 'http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_division_master&outputFormat=application/json',
                    strategy: ol.loadingstrategy.all
                }),
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: '#FF5733', width: 1 }),
                    fill: new ol.style.Fill({ color: 'rgba(0, 0, 255, 0.1)' })
                })
            },
            {
                name: "Water Body",
                source: new ol.source.Vector({
                    format: new ol.format.GeoJSON(),
                    url: 'http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_uk_water_body&outputFormat=application/json',
                    strategy: ol.loadingstrategy.all
                }),
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: 'blue', width: 1 }),
                    fill: new ol.style.Fill({ color: 'rgb(135, 206, 235)' })
                })
            },
            {
                name: "Plantation",
                source: new ol.source.Vector({
                    format: new ol.format.GeoJSON(),
                    url: 'http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_plantation_area&outputFormat=application/json',
                    strategy: ol.loadingstrategy.all
                }),
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: '#082405', width: 1 }),
                    fill: new ol.style.Fill({ color: '#1fa811' })
                })
            },
            {
                name: "Fire Points",
                source: new ol.source.Vector({
                    format: new ol.format.GeoJSON(),
                    url: 'http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_2022&outputFormat=application/json',
                    strategy: ol.loadingstrategy.all
                }),
                style: new ol.style.Style({
                    image: new ol.style.Circle({
                        radius: 5,
                        fill: new ol.style.Fill({ color: 'yellow' }),
                        stroke: new ol.style.Stroke({ color: 'darkred', width: 1 })
                    })
                })
            },
            {
                name: "Major City",
                source: new ol.source.Vector({
                    format: new ol.format.GeoJSON(),
                    url: 'http://180.151.15.18:9007/geoserver/uk_sfd/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=uk_sfd:tbl_major_city&outputFormat=application/json',
                    strategy: ol.loadingstrategy.all
                }),
                style: new ol.style.Style({
                    image: new ol.style.Circle({
                        radius: 5,
                        fill: new ol.style.Fill({ color: 'red' }),
                        stroke: new ol.style.Stroke({ color: 'white', width: 1 })
                    })
                })
            }
        ];

        wfsLayers.forEach(layer => {
            const vectorLayer = new ol.layer.Vector({
                source: layer.source,
                style: layer.style
            });
            layer.vectorLayer = vectorLayer;
            map.addLayer(vectorLayer);
        });

        // Toggle visibility
        document.querySelectorAll('#layer-controls input[type="checkbox"]').forEach(checkbox => {
            checkbox.addEventListener('change', function () {
                const layerName = this.getAttribute('data-layer');
                const layerObj = wfsLayers.find(l => l.name === layerName);
                if (layerObj && layerObj.vectorLayer) {
                    layerObj.vectorLayer.setVisible(this.checked);
                }
            });
        });

        const popup = new ol.Overlay({
            element: document.getElementById('popup'),
            positioning: 'bottom-center',
            stopEvent: false
        });
        map.addOverlay(popup);

        // Compute destination point from center
        function destinationPoint(lonLat, distanceMeters, bearingDegrees) {
            const R = 6371000;
            const [lon1, lat1] = [lonLat[0] * Math.PI / 180, lonLat[1] * Math.PI / 180];
            const bearing = bearingDegrees * Math.PI / 180;
            const lat2 = Math.asin(Math.sin(lat1) * Math.cos(distanceMeters / R) +
                Math.cos(lat1) * Math.sin(distanceMeters / R) * Math.cos(bearing));
            const lon2 = lon1 + Math.atan2(
                Math.sin(bearing) * Math.sin(distanceMeters / R) * Math.cos(lat1),
                Math.cos(distanceMeters / R) - Math.sin(lat1) * Math.sin(lat2)
            );
            return [lon2 * 180 / Math.PI, lat2 * 180 / Math.PI];
        }

        map.on('click', function (evt) {
            const radiusKm = prompt('Enter radius in kilometers:');
            const radius = parseFloat(radiusKm) * 1000;

            if (isNaN(radius) || radius <= 0) {
                alert('Please enter a valid radius in kilometers.');
                return;
            }

            drawSource.clear();

            const centerLonLat = ol.proj.toLonLat(evt.coordinate);
            const circlePolygon = ol.geom.Polygon.circular(
                new ol.Sphere(6371008.8),
                centerLonLat,
                radius,
                64
            ).transform('EPSG:4326', 'EPSG:3857');

            const circleFeature = new ol.Feature({ geometry: circlePolygon });
            circleFeature.setStyle(new ol.style.Style({
                stroke: new ol.style.Stroke({ color: 'red', width: 2 }),
                fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.2)' })
            }));
            drawSource.addFeature(circleFeature);

            // Add center marker
            const centerFeature = new ol.Feature({ geometry: new ol.geom.Point(evt.coordinate) });
            centerFeature.setStyle(new ol.style.Style({
                image: new ol.style.Circle({
                    radius: 3,
                    fill: new ol.style.Fill({ color: 'black' }),
                    stroke: new ol.style.Stroke({ color: 'white', width: 1 })
                })
            }));
            drawSource.addFeature(centerFeature);

            // Add radius label
            const labelLonLat = destinationPoint(centerLonLat, radius, 90);
            const labelCoord = ol.proj.fromLonLat(labelLonLat);
            const radiusLabel = new ol.Feature({ geometry: new ol.geom.Point(labelCoord) });
            radiusLabel.setStyle(new ol.style.Style({
                text: new ol.style.Text({
                    text: `Radius: ${radiusKm} km`,
                    font: 'bold 14px Arial',
                    fill: new ol.style.Fill({ color: 'black' }),
                    stroke: new ol.style.Stroke({ color: 'white', width: 3 }),
                    offsetY: -10
                })
            }));
            drawSource.addFeature(radiusLabel);

            // Intersect logic
            const jstsCircle = jstsParser.read(circlePolygon);
            let popupContent = `<strong>Intersected Features Summary</strong><br><br>`;
            let foundAny = false;

            wfsLayers.forEach(layer => {
                if (!layer.vectorLayer.getVisible()) return;
                const features = layer.source.getFeatures();
                const intersectedFeatures = [];

                features.forEach(f => {
                    f.setStyle(layer.style);
                    const jstsGeom = jstsParser.read(f.getGeometry());
                    if (jstsGeom.intersects(jstsCircle)) {
                        foundAny = true;
                        intersectedFeatures.push(f);
                        f.setStyle(new ol.style.Style({
                            stroke: new ol.style.Stroke({ color: 'red', width: 2 }),
                            fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.4)' }),
                            image: new ol.style.Circle({
                                radius: 6,
                                fill: new ol.style.Fill({ color: 'red' }),
                                stroke: new ol.style.Stroke({ color: 'darkred', width: 1 })
                            })
                        }));
                    }
                });

                if (intersectedFeatures.length > 0) {
                    popupContent += `<div><strong>${layer.name} (${intersectedFeatures.length})</strong></div>`;
                    intersectedFeatures.forEach((f, idx) => {
                        const props = f.getProperties();
                        popupContent += `<div class="popup-attributes" style="margin-left: 10px;"><em>Feature ${idx + 1}</em><br>`;
                        Object.keys(props).forEach(k => {
                            if (k !== 'geometry') {
                                popupContent += `<span>${k}: ${props[k]}</span><br>`;
                            }
                        });
                        popupContent += `</div><br>`;
                    });
                } else {
                    popupContent += `<div><strong>${layer.name}:</strong> No intersected features</div><br>`;
                }
            });

            if (foundAny) {
                document.getElementById('popup-content').innerHTML = popupContent;
                popup.setPosition(evt.coordinate);
            } else {
                document.getElementById('popup-content').innerHTML = "";
                alert('No features intersect the circle.');
            }
        });
    </script>
</asp:Content>
