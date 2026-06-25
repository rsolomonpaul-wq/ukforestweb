<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="analysis.aspx.cs" Inherits="uk_forest.DSS.analysis" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol/ol.css">

  <style>
    .page-content {
          margin-top: 1px !important;
          position: relative !important;
          top: 35px !important;
          padding: 0 !important;
      }
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      width: 100%;
    }
    #map-container{
      display: flex;
      width:100%;
      height:calc(100% - 180px);
      gap:2px;
    }
    #map1, #map2 {
      height: 100%;
    }
    #bottom-panel {
        display: flex;
        height: 215px;
        background: #f1f1f173;
        border-top: 1px solid #ccc;
        position: fixed;
        right:0;
        bottom: -214px;
        width: calc(100% - 290px); 
        /*width: 100%;*/
        font-family: sans-serif;
        z-index:5;
        transition:all 0.4s ease-in-out;
    }
    .SlideUpDownBtn {
        display: none;
        position: absolute;
        bottom: 213px;
        right: 0;
        padding: 8px;
        border: 0;
        background-color: #063062;
        color: #fff;
        letter-spacing: 0.5px;
        cursor: context-menu;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
    }
    .SlideUpDownBtn img{
        width:30px;
        filter:invert(1);
    }
    .addBottomPanelClass{
        bottom:0 !important;
    }
    .customAddClass{
        bottom:165px;
    }
    #controls{
      width: 20%;
      padding: 10px;
      border-right: 1px solid #ccc;
      box-sizing: border-box;
      overflow-y:auto;
    }
    #controls label{
      display: block;
      margin: 10px 0;
    }
    #options{
      flex: 1;
      padding: 10px;
    }
    .panel-content {
      display: none;
    }
    .panel-content.active {
      display: block;
    }
    .window-section{
      display: flex;
      justify-content: space-between;
      gap: 30px;
    }
    .window {
      flex: 1;
    }
    .date-picker,
    input[type="range"] {
      width: 100%;
      margin-top: 5px;
    }
    .ticks {
      display: flex;
      justify-content: space-between;
      font-size: 12px;
    }
    #map1.swipe-mode {
      width: 100% !important;
    }
  /*  canvas {
    height: 100vh !important;
}*/
    .mapclass{
        height:800px !important;
    }
    .inputtype{
        width: 200px;
    height: 30px;
    border: 1px solid #b3b3b3;
    padding: 5px;
    }
      .page-content.my-5 .page-container{
          padding:0;
      }


      
    .legend {
      background: linear-gradient(to bottom right, #ffffff, #f9f9f9);
    border: 1px solid #ddd;
        padding: 10px 10px;
    font-size: 13px;
    width: 250px;
    border-radius: 5px;
    /* box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12); */
    transition: box-shadow 0.3s ease;
    }

    .legend:hover {
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.18);
    }

   
    .legend-item {
      display: flex;
      align-items: center;
      margin-bottom: 10px;
    }

    .legend-color {
        
      width: 15px;
    height: 15px;
    margin-right: 8px;
    border-radius: 4px;
    border: 1px solid #999;
    flex-shrink: 0;
    }

    /* NDVI Colors */
    .ndvi-dense     { background: rgba(20, 90, 33, 1); }
    .ndvi-moderate  { background: rgba(50, 255, 90, 1); }
    .ndvi-low       { background: rgba(221, 137, 50, 1); }
    .ndvi-verylow   { background: rgba(255, 0, 0, 1); }

    .legend-label {
      color: #333;
    }

    .legend-label strong {
      color: #000;
    }


    .switch-group{
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        gap: 2px;
      }
      #dual-ticks1 span, #dual-ticks2 span,#single-ticks span{
          background-color: #36955f;
          color: black;
          padding: 3px;
          border: 1px solid white;
      }
      #map1, #map2 {
      flex: 1;
      position: relative;
      border: 1px solid #7c7c7c;
    }
    .ghost-cursor {
      position: absolute;
      pointer-events: none;
      transform: translate(-50%, -50%);
      font-size: 24px;
      font-weight: bold;
      color: #FC0FC0;
      display: none;
      z-index: 999;
    }
    #options .row select{
        width:100%;
        border:1px solid #d5d1d1;
        padding:2px;
        border-radius:5px;
        height:0px;
    }
  </style>

    <style>
        ul#indexForm{
            display: flex;
            padding: 0;
        }
        ul#indexForm li{
            display:flex;
        }
        .legend {
            padding: 10px;
            background: #fff;
            border: 1px solid #ccc;
            width: fit-content;
        }
        .legend-item {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }
        .legend-color {
            width: 20px;
            height: 20px;
            margin-right: 10px;
        }
        /* SAVI color classes */
        .savi-dense {
            background-color: #228B22; /* forest green */
        }
        .savi-sparse {
            background-color: #D2B48C; /* tan */
        }

        .savi-none {
            background-color: #0000FF; /* blue */
        }

        .legend {
            padding: 10px;
            background: #fff;
            border: 1px solid #ccc;
            width: fit-content;
        }

        .legend-item {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }

        .legend-color {
            width: 20px;
            height: 20px;
            margin-right: 10px;
        }

        /* EVI color classes */
        .evi-dense {
            background-color: #006400; /* dark green */
        }

        .evi-moderate {
            background-color: #228B22; /* forest green */
        }

        .evi-sparse {
            background-color: #D2B48C; /* tan */
        }

        .evi-none {
            background-color: #0000FF; /* blue */
        }

        .legend {
            padding: 10px;
            background: #fff;
            border: 1px solid #ccc;
            width: fit-content;
        }

        .legend-item {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }

        .legend-color {
            width: 20px;
            height: 20px;
            margin-right: 10px;
        }

        /* NDWI color classes */
        .ndwi-water {
            background-color: #0000FF; /* blue */
        }

        .ndwi-moist {
            background-color: #00FF00; /* green */
        }

        .ndwi-dry {
            background-color: orange; /* dark gray */
        }
        ul#indexForm li {
            padding: 0px 15px !important;
        }
            ul#indexForm li label {
                padding-left: 5px;
            }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }
        
    .controls {
      position: absolute;
      top: 10px;
      left: 10px;
      background: rgba(255, 255, 255, 0.9);
      padding: 10px;
      border-radius: 5px;
      z-index: 1000;
    }

    .tooltip {
      position: absolute;
      background: white;
      border: 1px solid #ccc;
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 12px;
      white-space: nowrap;
    }

    .tooltip-static {
      background-color: #f0f0f0;
      border: 1px solid #aaa;
    }
    </style>
    <style>
   .tool-btn {
  cursor: pointer;
  opacity: 0.8;
  height: 25px;
  margin-right: 6px;
  transition: opacity 0.2s ease, border 0.2s ease, box-shadow 0.2s ease;
  box-sizing: border-box;
  display: inline-block;
  border: none; /* Reset default border */
  background: none; /* Prevent default background interference */
}

.tool-btn:hover {
  opacity: 1;
}

.tool-btn.active {
  border: 2px solid #007bff; /* Visible blue border */
  border-radius: 4px;
  box-shadow: 0 0 6px rgba(0, 123, 255, 0.5); /* Optional glow effect */
  background-color: rgba(0, 123, 255, 0.1); /* Optional light background */
}


  </style>
      <style>
              .panelnew{
                 position: fixed;
  z-index: 1;
  background-color: white;
  padding: 5px 10px;
  width: calc(100% - 290px);
  display: grid;
  grid-auto-flow: column;                    
              }
              .panelnew-left {
                  display: flex;
                  align-items: center;
                  gap: 15px;
                  width: 80%;
                  
              }
               .panelnew-right {
                  display: flex;
                  align-items: center;
                  gap: 5px;
                  width: 20%;
                  justify-content: right;
              }
                .panelnew .col-lg-2 select {
                    border: 1px solid #cdcdcd;
                    border-radius: 5px;
                    padding: 2px;
                }

           /* .ol-zoom {
                top: 3.5em;
                left: .5em;
            }*/
            .row{
                margin-left:0px!important;
            }
            select{
                width:100px;
            }
             #slidingDiv {
              position:absolute;
              top: 60px;
              right: 0;
              width: 250px;
              height: 40%;
              background-color:white;
              box-shadow: -2px 0 10px rgba(0,0,0,0.3);
              transform: translateX(100%);
              transition: transform 0.4s ease;
              display: none;
              z-index: 11;
            }
            /* Panel visible state */
            #slidingDiv.show {
              transform: translateX(0);
            }
            .layerclose {
                float: right;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0;
                width: 25px;
                border-radius:50%;
                font-size:20px;
                background-color:black;
                cursor:pointer;
            }
            .tool-btn {
              cursor: pointer;
              opacity: 0.8;
              transition: opacity 0.2s ease;
              box-sizing: border-box;
            }
            .tool-btn:hover {
              opacity: 1;
            }
.tool-btn.active {
  outline: 2px solid #007bff;
  border-radius: 4px;
}
.tooltip {
  position: absolute;
  background-color: white;
  border: 1px solid #ccc;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  color: black;
  white-space: nowrap;
  pointer-events: none;
  z-index: 100;
}

.tooltip-measure {
  opacity: 0.8;
  font-weight: bold;
}

.tooltip-static {
  background-color: #f0f0f0;
  border: 1px solid #999;
}
 #infoforslop {
       
      background: white; padding: 8px; border: 1px solid white;
      font-size: 14px; 
      overflow: auto; z-index: 1000;
    }
 table{
     white-space:nowrap;
 }
 tbody, td, tfoot, th, thead, tr {
    border-color: inherit;
    border-style: solid;
    border-width: thin;
    width: 100%;
    padding: 0px 5px;
}

  /*#loader {
      display:none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background-color: rgba(255, 255, 255, 0.9);
      z-index: 99999;
    }*/

    /* Center the image using absolute positioning + transform */
    /*#loader img {
      position:absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 200px;
    }*/

      #loader {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background-color: rgba(255, 255, 255, 0.9);
      z-index: 9999;
    }

    /* Center the image using absolute positioning + transform */
    #loader img {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 200px;
    }
     #loader h1 {
      position: absolute;
  top: 70%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 25px;
  color: black;
    }
        #loader{display: none;}
     #chartContainer {
     display:none;
      width:500px;
      bottom: 0px;
      position:absolute;
      z-index:1;
      background-color:white;
      right:5px;
    }
.ol-overlaycontainer-stopevent {
    display: none;
}


 button#btngetstat {
    display: block;
    width: 30px;
    height: 30px;
    border: 0;
    background-color: #036581;
    color: #fff;
    border-radius: 5px;
    font-size: 14px;
}

     @media(min-width:1280px){
        .rightPannelAssets {
            display: flex;
        }
     }

    @media(min-width:992px) and (max-width:1280px){
        .panelnew{
            height:65px !important;
        }
        .panelnew-right{
            align-items: flex-end;
            flex-direction: column;
        }
        .undoRedoIcon{
            display: flex;
            gap:10px;
        }
        .rightPannelAssets{
            display: flex;
        }

    }

 
        </style>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager runat="server" ID="scrm"></asp:ScriptManager>
      <asp:Label ID="LabelInContent" runat="server" Text="Analysis" Visible="false" />
      <div id="map-container">
         <div id="popup_uploaddata" style="display:none;position: absolute; z-index: 1; background-color: #31303080; width: 100%; height: calc(100vh - 85px);">
              <div id="loading">Loading...</div>
             <div id="layerList"></div>
             <div style="background-color: white; width: 30%; margin: 10% auto; height: 300px;">
                    
                 <div style="display: flex; justify-content: space-between;border-bottom:1px solid red;padding: 5px;">
                     <div style="width:95%;text-align: center;font-size: 20px;">
                         Upload Data
                     </div>
                     <div style=" background-color: red; color: white; font-weight: 800;cursor:pointer;padding: 7px;" onclick="close_popup_uploaddata()">
                         X
                     </div>
                 </div>
                 <div style="padding: 20px;text-align: center;">
                     <h3 style="margin-bottom:20px">Choose a .zip file which contains .shp and its supportive files.</h3>
                      <input type="file" id="fileInput" accept=".zip" />
                 </div>
                
                 
             </div>
         </div>
        
         
                  <div class="panelnew">
                     <%-- <div class="panelnew-left">--%>
                          <div class="firstdiv">
                              <asp:Label Text="Mode : " runat="server" />
                              <select id="screenmode" onchange="changeMode()">
                                  <option value="single">Single Window</option>
                                  <option value="dual">Dual Window</option>
                                  <option value="swipe">Swipe Window</option>
                              </select>
                          </div>
                          <asp:UpdatePanel runat="server" style="display: flex; gap: 15px;">
              <ContentTemplate>
                          <div class="seconddiv">

                              <asp:Label Text="Level : " runat="server" />
                              <asp:DropDownList runat="server" ID="ddllevel" OnSelectedIndexChanged="ddllevel_SelectedIndexChanged" AutoPostBack="true">
                                  <asp:ListItem Value="" Text="Select" />
                                  <asp:ListItem Value="zone" Text="Zone" />
                                  <asp:ListItem Value="circle" Text="Circle" />
                                  <asp:ListItem Value="division" Text="Division" />
                                  <asp:ListItem Value="range" Text="Range" />
                                  <asp:ListItem Value="beat" Text="Beat" />
                              </asp:DropDownList>

                          </div>
                          <div class="sixthdiv">
                              <asp:Label Text="Section : " runat="server" />
                              <asp:DropDownList runat="server" ID="ddlsection" OnSelectedIndexChanged="ddlsection_SelectedIndexChanged" AutoPostBack="true">
                              </asp:DropDownList>
                          </div>
                   </ContentTemplate>
          </asp:UpdatePanel>
                          <div class="thirddiv">
                              <asp:Label Text="Data : " runat="server" />
                              <select id="datatypeid" onchange="getdatatype(this)">
                                  <option value="">Select</option>
                                  <option value="sentinel2">Sentinel - 2</option>
                                  <option value="slope">Slope</option>
                                  <option value="dtm">DTM</option>
                                  <option value="soil">Soil</option>

                              </select>
                          </div>
                            <div class="fifthdiv">
                              <asp:Label Text="Date : " runat="server" />
                              <input id="single-date" type="date" value="" onchange="generateSingleDates()" disabled="disabled" />
                          </div>
                           <div class="fifthdiv" id="date2" style="display:none">
                              <asp:Label Text="Date : " runat="server" />
                              <input id="dual-date2" type="date" value="" onchange="generateSingleDates()"  disabled="disabled"/>
                          </div>
                          <div class="fouthdiv">
                              <asp:Label Text="Indicies : " runat="server" />
                              <select id="selectedIndicies" onchange="refreshLayers()" disabled="disabled">
                                  <option value="">Select</option>
                                  <option value="NDVI">NDVI (Normalized Difference Vegetation Index)</option>
                                  <option value="NDWI">NDWI (Normalized Difference Water Index)</option>
                                  <option value="EVI">EVI (Enhanced Vegetation Index)</option>
                                  <option value="SAVI">SAVI (Soil-Adjusted Vegetation Index)</option>

                              </select>
                          </div>
                   <%--   <div class="iconpanel">--%>
                          <div style="display: flex; gap: 10px;">
                              <label id="id_drawPolygonforsoil"  style="display:none"><input type="checkbox" id="drawPolygon" > Draw Polygon or upload polygon</label>
                               <label id="id_drawPolygonforslop"  style="display:none"><input type="checkbox" id="drawPolygonforslop"> Draw Polygon or upload polygon</label>
                               <label id="id_drawPolygonfordtm"  style="display:none">
                                   <span style="display:flex;">
                                       <input type="checkbox" id="drawPolygonfordtm"> Draw Polygon or upload polygon
                                   </span>
                               </label>
                              <div><button id="btngetstat" type="button" onclick="getfeatures()" title="Choose all option as given before then using this button will get then response accordingly">F</button></div>
                          </div>
                        
                    
                              <div>
                                   <img id="undoBtn" src="img/backward.png" alt="Undo" title="Undo" style="height: 25px; cursor: pointer" />
                              </div>
                              <div>
                                       <img id="redoBtn" src="img/backward.png" alt="Redo" title="Redo" style="height: 25px; cursor: pointer; -webkit-transform: scaleX(-1); transform: scaleX(-1);" />
                              </div>
                              <div>
                                     <img id="clearAllBtn" src="img/clearall.png" alt="Clear All" title="Clear All" style="height: 25px; cursor: pointer" />
                              </div>
                         
                               <div>
                                 <img id="measureLine" class="tool-btn" src="img/measureline.jpg" title="Measure Line"  style="height:25px"/>
                              </div> 
                              <div>
                                  <img class="tool-btn" src="../GIS/img/map_icons/major_area.png" id="measureArea"  title="Measure Area"  />
                              </div>
                              <div title="Export" onclick="downloadreport()">
                                  <img src="https://cdn.iconscout.com/icon/premium/png-256-thumb/download-button-icon-svg-png-download-1465259.png" alt="Download" style="height:25px"/>
                              </div>
                               <div title="Refresh" onclick="removeAllUploadedLayers()">
                                  <img src="img/reload.png" alt="Refresh" style="height:25px"/> 
                              </div> 
                               <div title="Upload" onclick="uploadyourdata()">
                            
                                  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX75e3tZM64uEybrSCaJBn2C4tYZgHxzPQmQ&s" alt="data upload" style="height:25px"/>
                              </div>
                              <div title="Layers" onclick="togglePanellayer()">
                               
                                  <img src="img/layer.png" alt="Alternate Text" style="height:20px" />
                              </div>
                     
                    <%--</div>--%>

                  </div>
             
            
          <div id="slidingDiv">
              <div style="display: flex; justify-content: space-between; background-color: #056f7a; color: white; padding: 2px;">
                  <div style="width:90%;text-align:center;font-size:20px">Layers</div>
                   <div class="layerclose" onclick="togglePanellayer()">x</div>
              </div>
              <div style="padding:5px">
                    
                      <ul style="padding:2px 10px">
                          <li class="form-check form-switch">
                              <input class="form-check-input custom-switch" type="checkbox" id="zonecheck" onclick="sfdzone(this)">
                              <label class="form-check-label" for="zone">Zone</label>
                              <span id="div_zone" style="display: none"></span>
                          </li>
                          <li class="form-check form-switch">
                              <input class="form-check-input custom-switch" type="checkbox" id="circlecheck" onclick="sfdcircle(this)">
                              <label class="form-check-label" for="circle">Circle</label>
                              <span id="div_circle" style="display: none"></span>
                          </li>
                          <li class="form-check form-switch">
                              <input class="form-check-input custom-switch" type="checkbox" id="divisioncheck" onclick="sfddivision(this)">
                              <label class="form-check-label" for="division">Division</label>
                              <span id="div_division" style="display: none"></span>
                          </li>
                          <li class="form-check form-switch">
                              <input class="form-check-input custom-switch" type="checkbox" id="plantationcheck" onclick="sfdplantation(this)">
                              <label class="form-check-label" for="range">Plantation</label>
                              <span id="div_plantation" style="display: none"></span>
                          </li>
                          <li class="form-check form-switch">
                              <input class="form-check-input custom-switch" type="checkbox" id="forestcheck" onclick="sfdforest(this)">
                              <label class="form-check-label" for="range">Forest Area</label>
                              <span id="div_forest" style="display: none"></span>
                          </li>
                       <%--   <li class="form-check form-switch">
                              <input class="form-check-input custom-switch" type="checkbox" id="slop" onclick="slop_fun(this)">
                              <label class="form-check-label" for="range">Slop</label>

                            
                          </li>--%>
                          <li class="form-check form-switch">
                              <input class="form-check-input custom-switch" type="checkbox" id="dtm" onclick="dtm_fun(this)">
                              <label class="form-check-label" for="dtm">DTM</label>

                              <span id='div_dtm' style='display: none'>

                                  <div>
                                      <div>
                                          <span style="margin-left: 15px;">All units in meter</span>
                                      </div>
                                      <div>
                                          <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&amp;VERSION=1.0.0&amp;FORMAT=image/png&amp;WIDTH=20&amp;HEIGHT=20&amp;LAYER=uk_sfd:Uttaranchal_SRTM_GEO&amp;Format=image/gif&amp;scale=800000&amp;Transparent=true">
                                      </div>

                                  </div>
                              </span>
                          </li>


                          <li class="form-check form-switch">
                              <input class="form-check-input custom-switch" type="checkbox" id="fire" onclick="firepoints(this)">
                              <label class="form-check-label" for="range">Forest Density</label>
                              <span id="div_fire" style="display: none"></span>
                          </li>

<%--                          <li class="form-check form-switch">
                              <input class="form-check-input custom-switch" type="checkbox" id="soil" onclick="soilfuntion(this)">
                              <label class="form-check-label" for="range">Soil</label>
 
                              <button type="button" onclick="clearPolygons()">Clear Polygon</button>


                          </li>--%>
                      </ul>
             
              </div>
             
            
          </div>
          <div style="width:100%;display:flex;height: calc(100vh - 85px);">
             <%-- <div id="loader">
                  <img src="https://cdn.pixabay.com/animation/2023/10/08/03/19/03-19-26-213_512.gif" alt="Loading...">
              </div>--%>
               <div class="legendsection" style="position: absolute; z-index: 1; bottom: 1px;left:10px; background-color: white; padding: 2px 10px;">
                      <table id="ndvi-stats-table" border="1" style="display: none; background-color: white;">
                          <thead>
                              <tr>
                                  <th>Category</th>
                                  <th>Percentage (%)</th>
                              </tr>
                          </thead>
                          <tbody></tbody>
                      </table>
                      <div id="soilinfodivmain" style="display: none">
                           <div style="float: right;cursor:pointer;" onclick="closediv()"><span>X</span></div>
                          <div id="info">
                              <%--<span>Check the checkbox and draw a polygon to get soil type in your area</span>--%>
                          </div>

                      </div>
                      <div id="infoforslopmain" style="display: none">
                          <div style="float: right;cursor:pointer;" onclick="closediv()"><span>X</span></div>
                          <div id="infoforslop">
                                <%--<span>Draw a polygon to get slope values in your area</span>--%>
                          </div>
                        
                      </div>
                      <div id="infofordtmmain" style="display: none">
                          <div style="float: right;cursor:pointer;" onclick="closediv()"><span>X</span></div>
                          <div id="infofordtm">
                                <%--<span>Draw a polygon to get elivation values in your area</span>--%>
                          </div>

                        
                      </div>

                      <span id='div_slope' style="display: none;">

                          <div>
                              <div>
                                  <span style="margin-left: 15px;white-space:nowrap">All units in degree</span>
                              </div>
                              <div>
                                  <img src="../GIS/img/slope_legend.png" />
                              </div>

                          </div>
                      </span>

                      <%--     <div id="slopeInfo" >
                                  Enable slope tool to begin.
                              </div>--%>




                      <div id="ndvilengend" style="display: none;">

                          <div class="legend" id="legend">

                              <div class="legend-item">
                                  <div class="legend-color ndvi-dense"></div>
                                  <div class="legend-label"><strong>Dense</strong> - NDVI ≥ 0.60 </div>


                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndvi-moderate"></div>
                                  <div class="legend-label"><strong>Moderate</strong> - 0.40 ≤ NDVI &lt; 0.60</div>


                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndvi-low"></div>
                                  <div class="legend-label"><strong>Low</strong> - 0.20 ≤ NDVI &lt; 0.40</div>


                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndvi-verylow"></div>
                                  <div class="legend-label"><strong>Other</strong> - NDVI &lt; 0.20</div>


                              </div>
                          </div>

                      </div>
                      <div id="swipe" class="panel-content" style="display: none">
                          <%--  <div class="window-section">
                          <div class="window">
                              <label>Date -:</label>
                              <input type="date" id="swipe-date1" class="date-picker inputtype" onchange="generateSwipeDates()">
                          </div>
                          <div class="window">
                              <label>Date -:</label>
                              <input type="date" id="swipe-date2" class="date-picker inputtype" onchange="generateSwipeDates()">
                          </div>
                      </div>--%>
                          <input type="range" id="swipe-slider" min="0" max="1" step="0.01" value="0.5" oninput="updateSwipeSlider()" />
                      </div>
                      <div id="saviLegend" style="display:none;">
                          <div class="legend" id="legendsavi">
                              <div class="legend-item">
                                  <div class="legend-color savi-dense"></div>
                                  <div class="legend-label"><strong>Moderate to Dense</strong> - SAVI ≥ 0.30</div>
                              </div>

                              <div class="legend-item">
                                  <div class="legend-color savi-sparse"></div>
                                  <div class="legend-label"><strong>Sparse or Stressed</strong> - 0.00 ≤ SAVI &lt; 0.30</div>
                              </div>

                              <div class="legend-item">
                                  <div class="legend-color savi-none"></div>
                                  <div class="legend-label"><strong>None / Water / Errors</strong> - SAVI &lt; 0.00</div>
                              </div>
                          </div>
                      </div>
                      <div id="eviLegend" style="display: none;">
                          <div class="legend" id="evilegend">
                              <div class="legend-item">
                                  <div class="legend-color evi-dense"></div>
                                  <div class="legend-label"><strong>Dense Vegetation</strong> - EVI ≥ 0.50</div>
                              </div>

                              <div class="legend-item">
                                  <div class="legend-color evi-moderate"></div>
                                  <div class="legend-label"><strong>Moderate Vegetation</strong> - 0.20 ≤ EVI &lt; 0.50</div>
                              </div>

                              <div class="legend-item">
                                  <div class="legend-color evi-sparse"></div>
                                  <div class="legend-label"><strong>Sparse / Barren</strong> - 0.00 ≤ EVI &lt; 0.20</div>
                              </div>

                              <div class="legend-item">
                                  <div class="legend-color evi-none"></div>
                                  <div class="legend-label"><strong>None / Water / Errors</strong> - EVI &lt; 0.00</div>
                              </div>
                          </div>
                      </div>
                      <div id="ndwiLegend" style="display: none;">
                          <div class="legend" id="ndwilegend">
                              <div class="legend-item">
                                  <div class="legend-color ndwi-water"></div>
                                  <div class="legend-label"><strong>Water Bodies</strong> - NDWI ≥ 0.30</div>
                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndwi-moist"></div>
                                  <div class="legend-label"><strong>Moist Vegetation / Wetlands</strong> - 0.00 ≤ NDWI &lt; 0.30</div>
                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndwi-dry"></div>
                                  <div class="legend-label"><strong>Dry Areas / Soil / Urban</strong> - NDWI &lt; 0.00</div>
                              </div>
                          </div>
                      </div>
                  </div>

                <div id="id_legendsection2" class="legendsection2" style="position: absolute; z-index: 1; bottom: 1px;right:2px; background-color: white; padding: 2px 10px;display:none">
                      <table id="ndvi-stats-table1" border="1">
                          <thead>
                              <tr>
                                  <th>Category</th>
                                  <th>Percentage (%)</th>
                              </tr>
                          </thead>
                          <tbody></tbody>
                      </table>
                      <div id="ndvilengendmap2" style="display:none">
                          <div class="legend">
                              <div class="legend-item">
                                  <div class="legend-color ndvi-dense"></div>
                                  <div class="legend-label"><strong>Dense</strong> - NDVI ≥ 0.60 </div>


                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndvi-moderate"></div>
                                  <div class="legend-label"><strong>Moderate</strong> - 0.40 ≤ NDVI &lt; 0.60</div>


                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndvi-low"></div>
                                  <div class="legend-label"><strong>Low</strong> - 0.20 ≤ NDVI &lt; 0.40</div>


                              </div>
                              <div class="legend-item">
                                  <div class="legend-color ndvi-verylow"></div>
                                  <div class="legend-label"><strong>Other</strong> - NDVI &lt; 0.20</div>
                              </div>
                          </div>
                      </div>
                  </div>
             
                <div id="loader">
              <%--  <img src="https://cdn.pixabay.com/animation/2023/10/08/03/19/03-19-26-213_512.gif" alt="Loading..." style="width:200px" />--%>
                    <div >
     
             <img src="https://cdn.pixabay.com/animation/2023/10/08/03/19/03-19-26-213_512.gif" alt="Alternate Text" />
              <h1>We are preparing data. Please wait...</h1>
        </div>
            </div>
              <div id="map1" data-ghost="map2" style="border: 1px solid black">

                  <div id="key-switcher" style="position: fixed; z-index: 1; right: 2px; background-color: white; padding: 5px; display: none;top:125px">

                      <div id="sentinel-form" style="display: flex; flex-direction: column; padding: 10px;">
                          <label>
                              <input type="radio" name="sentinel-type" value="ncc" checked>
                              Sentinel-2 NCC</label>
                          <label>
                              <input type="radio" name="sentinel-type" value="fcc">
                              Sentinel-2 FCC</label>
                      </div>
                  </div>

                  <div id="chartContainer">
                <canvas id="ndviChart"></canvas>
            </div>
                   <div id="output" style="display:none"></div>
              </div>
              <div id="map2" data-ghost="map1" style="width: 0%; display: none; border: 1px solid black">
                
              </div>

          </div>

          <div>
            

<%--     <div id="bottom-panel" style="box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;" class="addBottomPanelClass">--%>
               <div id="bottom-panel" style="box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;" class="">

              
                 
              
              
             
              <span class="SlideUpDownBtn ">
                  <span>
                      &#9654;   
                  </span>
                 <%-- <img src="img/vice-versa.png" />--%>
              </span>
              <div id="controls">
                  <label>
                      <input type="radio" name="mode" value="single" checked onchange="changeMode('single')">
                      Single Window</label>
                  <label>
                      <input type="radio" name="mode" value="dual" onchange="changeMode('dual')">
                      Dual Window</label>
                  <label>
                      <input type="radio" name="mode" value="swipe" onchange="changeMode('swipe')">
                      Swipe Window</label>
                  <hr style="margin:0;padding:0;">
                  Indicies Analysis

                  <div>


                      <ul id="indexForm">
                          <li>
                              <input type="radio" id="ndvi" name="index" value="NDVI" onchange="refreshLayers()"/>
                              <label for="ndvi" title="Normalized Difference Vegetation Index">NDVI</label>
                          </li>
                          <li>
                              <input type="radio" id="ndwi" name="index" value="NDWI" onchange="refreshLayers()"/>
                              <label for="ndwi" title="Normalized Difference Water Index">NDWI</label>
                          </li>
                          <li>
                              <input type="radio" id="evi" name="index" value="EVI" onchange="refreshLayers()"/>
                              <label for="evi" title="Enhanced Vegetation Index">EVI</label>
                          </li>
                          <li>
                              <input type="radio" id="savi" name="index" value="SAVI" onchange="refreshLayers()"/>
                              <label for="savi" title="Soil-Adjusted Vegetation Index">SAVI</label>
                          </li>
                      </ul>
                      <label style="display:none">
                          <input type="checkbox" id="ndvi-toggle" onchange="refreshLayers()">
                          NDVI
                      </label>

                      <label style="display:none">
                          <input type="checkbox" id="ndvi-toggle1" onchange="refreshLayers()">
                          Burn Index</label>
                  </div>

              </div>

              <div id="options">
                  <asp:UpdatePanel runat="server">
                      <ContentTemplate>
                           <div class="row">
                      <div class="col-lg-2">
                          <asp:Label Text="Zone" runat="server" />
                          <asp:DropDownList runat="server" ID="ddlzone" OnSelectedIndexChanged="ddlzone_SelectedIndexChanged" AutoPostBack="true">
                             
                          </asp:DropDownList>
                      </div>
                      <div class="col-lg-2">
                          <asp:Label Text="Circle" runat="server" />
                          <asp:DropDownList runat="server" ID="ddlcircle" OnSelectedIndexChanged="ddlcircle_SelectedIndexChanged" AutoPostBack="true">
                            
                          </asp:DropDownList>
                      </div>
                      <div class="col-lg-2">
                          <asp:Label Text="Division" runat="server" />
                          <asp:DropDownList runat="server" ID="ddldivision" OnSelectedIndexChanged="ddldivision_SelectedIndexChanged" AutoPostBack="true">
                            
                          </asp:DropDownList>
                      </div>
                      <div class="col-lg-2">
                          <asp:Label Text="Range" runat="server" />
                          <asp:DropDownList runat="server" ID="ddlrange" OnSelectedIndexChanged="ddlrange_SelectedIndexChanged" AutoPostBack="true">
                            
                          </asp:DropDownList>
                      </div>
                      <div class="col-lg-2">
                          <asp:Label Text="Beat" runat="server" />
                          <asp:DropDownList runat="server" ID="ddlbeat"  OnSelectedIndexChanged="ddlbeat_SelectedIndexChanged" AutoPostBack="true">
                             
                          </asp:DropDownList>
                      </div>
                  </div>
                      </ContentTemplate>
                  </asp:UpdatePanel>
                 
                  <hr />
                  <!-- Single -->
                  <div id="single" class="panel-content active">
                      <label>Select Date:</label>
                      <input type="date" id="single-date_" class="date-picker inputtype" onchange="generateSingleDates()">
                      <input type="range" id="single-range" min="0" max="4" value="0" oninput="updateSingleLayer(this.value)">
                      <div class="ticks" id="single-ticks"></div>
                  </div>

                  <!-- Dual -->
                  <div id="dual" class="panel-content">
                      <div class="window-section">
                          <div class="window">
                              <label>Date - Window 1:</label>
                              <input type="date" id="dual-date1" class="date-picker inputtype" onchange="generateDualDates(1)">
                              <input type="range" id="dual-range1" min="0" max="4" value="0" oninput="updateDualLayer(1, this.value)">
                              <div class="ticks" id="dual-ticks1"></div>
                          </div>
                          <div class="window">
                              <label>Date - Window 2:</label>
                              <input type="date" id="dual-date2_" class="date-picker inputtype" onchange="generateDualDates(2)">
                              <input type="range" id="dual-range2" min="0" max="4" value="0" oninput="updateDualLayer(2, this.value)">
                              <div class="ticks" id="dual-ticks2"></div>
                          </div>
                      </div>
                  </div>

                  <!-- Swipe -->
                 

                  <div style="bottom: 0px !important; position: absolute; padding: 10px; width: 64%;">
                      <div style="width: 100%;">
                          <button type="button" onclick="uploadyourdata()" title="Upload your area of interest as a zipped shapefile to display NDVI">Upload Data</button>
                          <button type="button" onclick="removeAllUploadedLayers()">Clear</button>
                          <button type="button" onclick="downloadreport()">Download</button>
                          <div>
<%--                              <div id="slopeToggleContainer" style="position: absolute; top: 10px; right: 10px; z-index: 1000; background: white; padding: 10px;">
                                  <label>
                                      <input type="checkbox" id="slopeCheckbox">
                                      Slope Classification</label>
                              </div>--%>
                             
                              <div id="slopeLoadingSpinner" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 2000; display: none;">
                                  <div style="border: 6px solid #f3f3f3; border-top: 6px solid #3498db; border-radius: 50%; width: 40px; height: 40px; animation: spin 0.8s linear infinite;"></div>
                              </div>
                          </div>

                          <div>
                              <style>
                                 #controlsforsoil {
    position: absolute;
    top: -29px;
    left: 274px;
    background: white;
    padding: 6px;
    border: 1px solid #333;
    font-size: 14px;
    z-index: 2;
}

                               #info {
    
    left: 0px;
    background: white;
    padding: 8px;
    border: 1px solid black;
    font-size: 13px;
    
    max-height: 300px;
    overflow: auto;
    z-index: 1000;
}
                                
                              </style>
                              <div id="controlsforsoil">
                                
                                  <br>
                                 
                                  <br>
                                  <label>Upload Shapefile (.zip):
                                      <input type="file" id="shpUpload" accept=".zip"></label>
                              </div>
                           
                             

                          </div>


                          <div>
                              <div class="controls" style="display:none">
    <button type="button" onclick="startMeasure()">Measure Area</button>
    <button type="button" onclick="undo()">Undo</button>
    <button type="button" onclick="redo()">Redo</button>
    <button type="button" onclick="clearAll()">Clear</button>
  </div>
                              
                          </div>

                          <%-- <label><input type="checkbox" id="maskToggle" /> Show only inside polygon</label>--%>
                      </div>
                  </div>

              </div>
              <div style="width: 15%; border: 1px solid #bfbfbf; padding: 5px; overflow: auto">

                  



              </div>
          </div>
   
          </div>
         
  </div>

  




      <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>










    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <%--<script src="https://cdn.jsdelivr.net/npm/ol/dist/ol.js"></script>--%>
    <script src="https://cdn.jsdelivr.net/npm/@turf/turf@6/turf.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  
  <script src="https://unpkg.com/shpjs@latest/dist/shp.min.js"></script>
   <%--<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" 
        integrity="sha512-px1y+JJLUSj2+fFNjZzXBL+K/CE8Z+Suxr2y2kqH0NXH6+RPA7Ge8SLZl+WwOuimX+Sb4BbtzvY9zO3cPZ8zag==" 
        crossorigin="anonymous"></script>--%>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" 
        integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" 
        crossorigin="anonymous"></script>


    
     <script src="js/analysis.js"></script>
    
        <script>
            let panelData = document.querySelector("#bottom-panel");

            let addpanelBtn = document.querySelector(".SlideUpDownBtn");
                addpanelBtn.addEventListener("click", () => {
                panelData.classList.toggle("addBottomPanelClass");
                addpanelBtn.classList.toggle("customAddClass");
            })

        </script>

  <script>




</script>
   <script src="js/measure.js"></script>
</asp:Content>
