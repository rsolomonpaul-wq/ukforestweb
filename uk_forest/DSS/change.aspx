<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="change.aspx.cs" Inherits="uk_forest.DSS.change" ClientIDMode="Static" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

 <%-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@6.15.1/ol.css">
  <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>

  <style>
    body { margin: 0; }
    #map { width: 100%; height: 100vh; }
    .layer-switcher {
      position: absolute;
    top: 75px;
    right: 25px;
    background: white;
    padding: 15px;
    z-index: 1000;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
    font-family: sans-serif;
    }
    .layer-switcher label {
      display: block;
      margin: 5px 0;
    }
    #swipediv {
   position: absolute;
    right: 24px;
    width: 300px;
    z-index: 1001;
    top: 35px;
    display: none;
    background: white;
    padding: 10px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
    }
      .datalayers {
             display: block;
             position: absolute;
             z-index: 1;
             left: 25px;
             background-color: white;
             top: 72px;
             width:250px;
             padding: 5px;
         }

             .datalayers ul {
                 list-style-type: none;
             }
  </style>--%>

    <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@6.15.1/ol.css">
  <style>
       canvas.ol-unselectable {
             height: calc(100vh - 100px) !important;
         }
    html, body, #map {
      width: 100%;
      height: 100%;
      margin: 0;
    }
    #controls {
      position: absolute;
      top: 35px;
      left: 10px;
      z-index: 1000;
      background: rgba(255,255,255,0.95);
      padding: 10px;
      border-radius: 5px;
    }
    .dateRow {
      display: none;
      margin-top: 5px;
    }
    #ndviBox {
      display: none;
      margin-top: 10px;
    }
    .page-content.my-5 {
    margin-top: 70px !important;
}
   
  </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="controls">
    <label>Left Layer:
      <select id="leftLayer">
     
           <option value="">Select</option>
        <option value="sentinel">Sentinel</option>
      </select>
    </label><br>
    <div class="dateRow" id="leftDateRow">
      <label>Date: <input type="date" id="date1"></label>
    </div>

    <label>Right Layer:
      <select id="rightLayer">
      
        <option value="">Select</option>
        <option value="sentinel">Sentinel</option>
      </select>
    </label><br>
    <div class="dateRow" id="rightDateRow">
      <label>Date: <input type="date" id="date2"></label>
    </div>

    <div id="ndviBox">
      <label><input type="checkbox" id="showNDVI" checked> Show NDVI</label><br>
    </div><br>

   
    <label><input type="checkbox" id="showWMSzone"> Zone</label>
          <img id="legendzone" style="display:none" src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_zone_master&Format=image/gif&scale=800000&Transparent=true" />
        <br> 
    <label><input type="checkbox" id="showWMScircle"> Circle</label>
         <img id="legendcircle" style="display:none" src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_circle_master&Format=image/gif&scale=800000&Transparent=true" />
        <br> 
         <label><input type="checkbox" id="showWMS"> Division</label>
        <img id="legenddivision" style="display:none" src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_division_master&Format=image/gif&scale=800000&Transparent=true" />
        <br> 
    <label><input type="checkbox" id="showWMSplantation"> plantat</label>
         <img id="legendplantation" style="display:none" src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_plantation_area&Format=image/gif&scale=800000&Transparent=true" />
        <br> 
    
    <button type="button" onclick="loadComparisonLayers()">Compare Layers</button><br><br>
    <input type="range" id="swipe" min="0" max="100" value="50" style="display:none">
  </div>

  <div id="map" style="margin-top:15px"></div>

  <script>
      let layer1, layer2;

      const map = new ol.Map({
          target: 'map',
          view: new ol.View({
              center: ol.proj.fromLonLat([79.0193, 30.0668]),
              zoom: 8
          }),
          layers: []
      });

      const osmSource1 = new ol.source.OSM();
      const osmLayer1 = new ol.layer.Tile({
          source: osmSource1
      });
      map.addLayer(osmLayer1);
      
      const geoWMSLayer = new ol.layer.Tile({
          source: new ol.source.TileWMS({
              url: 'https://ukforestgis.in/geoserver/uk_sfd/wms',
              params: {
                  'LAYERS': 'uk_sfd:tbl_division_master',
                  'TILED': true,
                  'VERSION': '1.1.0',
                  'FORMAT': 'image/png',
                  'SRS': 'EPSG:4326'
              },
              serverType: 'geoserver',
              crossOrigin: 'anonymous'
          })
      });
      const geoWMSLayerzone = new ol.layer.Tile({
          source: new ol.source.TileWMS({
              url: 'https://ukforestgis.in/geoserver/uk_sfd/wms',
              params: {
                  'LAYERS': 'uk_sfd:tbl_zone_master',
                  'TILED': true,
                  'VERSION': '1.1.0',
                  'FORMAT': 'image/png',
                  'SRS': 'EPSG:4326'
              },
              serverType: 'geoserver',
              crossOrigin: 'anonymous'
          })
      });
      const geoWMSLayercircle = new ol.layer.Tile({
          source: new ol.source.TileWMS({
              url: 'https://ukforestgis.in/geoserver/uk_sfd/wms',
              params: {
                  'LAYERS': 'uk_sfd:tbl_circle_master',
                  'TILED': true,
                  'VERSION': '1.1.0',
                  'FORMAT': 'image/png',
                  'SRS': 'EPSG:4326'
              },
              serverType: 'geoserver',
              crossOrigin: 'anonymous'
          })
      });
      const geoWMSLayerplantation = new ol.layer.Tile({
          source: new ol.source.TileWMS({
              url: 'https://ukforestgis.in/geoserver/uk_sfd/wms',
              params: {
                  'LAYERS': 'uk_sfd:tbl_plantation_area',
                  'TILED': true,
                  'VERSION': '1.1.0',
                  'FORMAT': 'image/png',
                  'SRS': 'EPSG:4326'
              },
              serverType: 'geoserver',
              crossOrigin: 'anonymous'
          })
      });

      
      document.getElementById('showWMS').checked = true;
      document.getElementById("legenddivision").style.display = "block";
      map.addLayer(geoWMSLayer);
      map.addOverlay(geoWMSLayer);


      
      document.getElementById('showWMS').addEventListener('change', function () {
          var legend = document.getElementById("legenddivision");
          if (this.checked) {
              map.addLayer(geoWMSLayer);
              map.addOverlay(geoWMSLayer);
              legend.style.display = "block";
          } else {
              map.removeLayer(geoWMSLayer);
              map.removeOverlay(geoWMSLayer);
              legend.style.display = "none";
          }
         
      });
      document.getElementById('showWMSzone').addEventListener('change', function () {
          var legend = document.getElementById("legendzone");
          if (this.checked) {
              map.addLayer(geoWMSLayerzone);
              map.addOverlay(geoWMSLayerzone);
              legend.style.display = "block";
          } else {
              map.removeLayer(geoWMSLayerzone);
              map.removeOverlay(geoWMSLayerzone);
              legend.style.display = "none";
          }
      });
      document.getElementById('showWMScircle').addEventListener('change', function () {
          var legend = document.getElementById("legendcircle");
          if (this.checked) {
              map.addLayer(geoWMSLayercircle);
              map.addOverlay(geoWMSLayercircle);
              legend.style.display = "block";
          } else {
              map.removeLayer(geoWMSLayercircle);
              map.removeOverlay(geoWMSLayercircle);
              legend.style.display = "none";
          }
      });
      document.getElementById('showWMSplantation').addEventListener('change', function () {
          var legend = document.getElementById("legendplantation");
          if (this.checked) {
              map.addLayer(geoWMSLayerplantation);
              map.addOverlay(geoWMSLayerplantation);
              legend.style.display = "block";
          } else {
              map.removeLayer(geoWMSLayerplantation);
              map.removeOverlay(geoWMSLayerplantation);
              legend.style.display = "none";
          }
      });

      const osmSource = new ol.source.OSM();
      const satelliteSource = new ol.source.XYZ({
          url: 'https://{a-c}.tile.opentopomap.org/{z}/{x}/{y}.png',
          attributions: '© OpenTopoMap'
      });

      function createLayer(type, date, enableNDVI) {
          if (type === 'osm') {
              return new ol.layer.Tile({ source: osmSource });
          } else if (type === 'satellite') {
              return new ol.layer.Tile({ source: satelliteSource });
          } else if (type === 'sentinel') {
              const sentinelSource = new ol.source.TileWMS({
                  url: 'https://services.sentinel-hub.com/ogc/wms/de50544e-49c1-4b62-8e48-c3da40ab036b',
                  params: {
                      layers: '2_FALSE_COLOR',
                      time: date,
                      preset: '2_FALSE_COLOR',
                      maxcc: 50
                  },
                  crossOrigin: 'anonymous'
              });

              if (enableNDVI) {
                  const ndviRaster = new ol.source.Raster({
                      sources: [sentinelSource],
                      operation: function (pixels) {
                          const pixel = pixels[0];
                          const nir = pixel[0] / 255;
                          const red = pixel[1] / 255;
                          const ndvi = (nir - red) / (nir + red);
                          if (ndvi >= 0.67) return [20, 90, 33, 255];
                          else if (ndvi >= 0.46) return [50, 255, 90, 255];
                          else if (ndvi >= 0.30) return [221, 137, 50, 255];
                          else return [255, 0, 0, 255];
                      }
                  });
                  return new ol.layer.Image({ source: ndviRaster });
              } else {
                  return new ol.layer.Tile({ source: sentinelSource });
              }
          }
      }

      function loadComparisonLayers() {
          const left = document.getElementById('leftLayer').value;
          const swip = document.getElementById('swipe').style.display="block";
          const right = document.getElementById('rightLayer').value;
          const date1 = document.getElementById('date1').value;
          const date2 = document.getElementById('date2').value;
          const enableNDVI = left === 'sentinel' && right === 'sentinel' && document.getElementById('showNDVI').checked;

          if (left === 'sentinel' && !date1) {
              alert('Please select a date for the left Sentinel layer.');
              return;
          }
          if (right === 'sentinel' && !date2) {
              alert('Please select a date for the right Sentinel layer.');
              return;
          }
 
          if (layer1) map.removeLayer(layer1);
          if (layer2) map.removeLayer(layer2);

          layer1 = createLayer(left, date1, enableNDVI);
          layer2 = createLayer(right, date2, enableNDVI);

          map.addLayer(layer1);
          map.addLayer(layer2);

          layer2.on('precompose', precomposeSwipe);
          layer2.on('postcompose', postcomposeSwipe);
          map.render();
      }

      function precomposeSwipe(event) {
          const swipe = document.getElementById('swipe').value;
          const ctx = event.context;
          const width = ctx.canvas.width * (swipe / 100);
          ctx.save();
          ctx.beginPath();
          ctx.rect(width, 0, ctx.canvas.width - width, ctx.canvas.height);
          ctx.clip();
      }

      function postcomposeSwipe(event) {
          event.context.restore();
      }

      document.getElementById('swipe').addEventListener('input', () => map.render());

      function toggleControls() {
          const left = document.getElementById('leftLayer').value;
          const right = document.getElementById('rightLayer').value;

          document.getElementById('leftDateRow').style.display = (left === 'sentinel') ? 'block' : 'none';
          document.getElementById('rightDateRow').style.display = (right === 'sentinel') ? 'block' : 'none';

          const bothSentinel = left === 'sentinel' && right === 'sentinel';
          document.getElementById('ndviBox').style.display = bothSentinel ? 'block' : 'none';
      }

      document.getElementById('leftLayer').addEventListener('change', toggleControls);
      document.getElementById('rightLayer').addEventListener('change', toggleControls);
      document.getElementById('showNDVI').addEventListener('change', () => {
          const left = document.getElementById('leftLayer').value;
          const right = document.getElementById('rightLayer').value;
          if (left === 'sentinel' && right === 'sentinel') {
              loadComparisonLayers();
          }
      });

      toggleControls();  
  </script>
 <%-- <asp:ScriptManager runat="server"></asp:ScriptManager>
 
<div class="layer-switcher">
  <label>Layer 1 Type:
    <select id="layer1Type" onchange="toggleDateInput(1)">
      <option value="osm">OSM</option>
      <option value="satellite">Google Satellite</option>
      <option value="roadmap">Google Roadmap</option>
      <option value="hybrid">Google Hybrid</option>
      <option value="terrain">Google Terrain</option>
      <option value="planet">Planet</option>
      <option value="sentinel2fcc">Sentinel-2</option>
    </select>
  </label>
  <label id="labelDate1" style="display:none;">Date 1:
    <input type="date" id="date1">
  </label>

  <label>Layer 2 Type:
    <select id="layer2Type" onchange="toggleDateInput(2)">
      <option value="osm">OSM</option>
      <option value="satellite">Google Satellite</option>
      <option value="roadmap">Google Roadmap</option>
      <option value="hybrid">Google Hybrid</option>
      <option value="terrain">Google Terrain</option>
      <option value="planet">Planet</option>
      <option value="sentinel2fcc">Sentinel-2</option>
    </select>
  </label>
  <label id="labelDate2" style="display:none;">Date 2:
    <input type="date" id="date2">
  </label>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
             <button type="button" onclick="loadSwipeLayers()">Swipe Layers</button>
        </ContentTemplate>
    </asp:UpdatePanel>
 
</div>

 <div id="swipediv">
  <input id="swipe" type="range" min="0" max="100" value="50" style="width: 100%;">
</div>
    <asp:HiddenField runat="server" ID="hfAllDates" value="01-01-2025,02-01-2025"/>
 
<div id="map">
          <div style="display:block" class="datalayers">
                            <ul>
                                <li >
                                            <asp:CheckBox ID="zone" runat="server" onclick='sfdzone(this);' Text="SFD Zone Boundaries" class="nav-item" />

                                            <span id='div_zone' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_zone_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                       



                                        
                            </ul>
                            <div  id="divstatus" style="display:block">
                                <div>
                                     <h4 style="margin-left: 15px;">Status</h4>
                                </div>
                                <div>
                                      <ul>
                        <li>
                             <asp:HiddenField runat="server" ID="layerswid" />
                        </li>
                            <li style="display:none">
                               <asp:CheckBox ID="cd_CropGrowth" runat="server" onclick='CropGrowth(this);' Text=" Growth" class="nav-item" />

                                <span id='div_CropGrowth' style='display: none'>
                                    <img src="img/ndvi.png" style="width: 65%;" />
                                </span>
                            </li>

                             <li>
                               <asp:CheckBox ID="cd_CropHealth" runat="server" onclick='CropHealth(this);' Text=" NDVI Analysis" class="nav-item" />
                                <span id='div_CropHealth' style='display: none'>
                                     <img src="img/health.png" style="width: 65%;" />
                                </span>
                            </li>

                            

                           

                            <li   style="display:none">
                                <asp:CheckBox ID="cd_CropHarvesting" runat="server" onclick='CropHarvesting(this);' Text="  Harvesting" class="nav-item" />
                                <span id='div_CropHarvesting' style='display: none'>
                                    <img src="img/harvesting.png" style="width: 65%;" />
                                </span>
                            </li>

                            <li id="s19" style="display:none" >
                                <asp:CheckBox ID="cd_VegetationMoisture" runat="server" onclick='VegetationMoisture(this);' Text="Vegetation Moisture" class="nav-item" />
                                <span id='div_VegetationMoisture' style='display: none'>
                                    <img src="img/vegetation-moisture.png" style="width: 65%;" />
                                </span>
                            </li>

                            <li id="s20"  style="display:none">
                                <asp:CheckBox ID="cd_NitrogenContent" runat="server" onclick='NitrogenContent(this);' Text="Nitrogen Content" class="nav-item" />
                                <span id='div_NitrogenContent' style='display: none'>
                                    <img src="img/NitrogenContent.png" style="width: 65%;" />
                                </span>
                            </li>

                            <li id="s21"  style="display:none">
                                <asp:CheckBox ID="cd_SoilMoisture" runat="server" onclick='SoilMoisture(this);' Text="Soil Moisture" class="nav-item" />
                                <span id='div_SoilMoisture' style='display: none'>
                                    <img src="img/SoilMoisture.png" style="width: 65%;" />
                                </span>
                            </li>

                            <li id="s22"  style="display:none">
                                <asp:CheckBox ID="cd_EnhancedVegetation" runat="server" onclick='EnhancedVegetation(this);' Text="Enhanced Vegetation" class="nav-item" />
                                <span id='div_EnhancedVegetation' style='display: none'>
                                    <img src="img/EnhancedVegetation.png" style="width: 65%;" />
                                    
                                </span>
                            </li>
                    </ul>
                          
                                </div>
                            </div>
                           

                        </div>

</div>

    <script src="../GIS/js/ol.js"></script>
    <script src="../GIS/js/jquery.min.js"></script>
    <script src="js/ndvi2.js"></script>
<script>


</script>--%>

</asp:Content>
