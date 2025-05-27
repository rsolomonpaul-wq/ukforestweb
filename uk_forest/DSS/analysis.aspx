<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="analysis.aspx.cs" Inherits="uk_forest.DSS.analysis" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">
  <style>
      .page-content {
          margin-top: 1px !important;
          position: relative !important;
          top: 65px !important;
          padding: 0 !important;
      }
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      width: 100%;
    }
    #map-container {
      display: flex;
      width: 100%;
      height: calc(100% - 180px);
    }
    #map1, #map2 {
      height: 100%;
    }
    #bottom-panel {
    display: flex;
    height: 215px;
    background: #f1f1f1;
    border-top: 1px solid #ccc;
    bottom: 0;
    position: absolute;
    width: 99%;
    font-family: sans-serif;
}
    #controls {
      width: 20%;
      padding: 10px;
      border-right: 1px solid #ccc;
      box-sizing: border-box;
    }
    #controls label {
      display: block;
      margin: 10px 0;
    }
    #options {
      flex: 1;
      padding: 10px;
    }
    .panel-content {
      display: none;
    }
    .panel-content.active {
      display: block;
    }
    .window-section {
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
    canvas {
    height: 100vh !important;
}
    .mapclass{
        height:800px !important;
    }
    .inputtype{
        width: 200px;
    height: 30px;
    border: 1px solid #b3b3b3;
    padding: 5px;
    }
      
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div id="map-container">
    <div id="map1" style="width: 100%;height: 100vh;"></div>
    <div id="map2" style="width: 0%; display: none;height:100vh"></div>
  </div>

  <div id="bottom-panel" style="box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;">
    <div id="controls">
      <label><input type="radio"  name="mode" value="single" checked onchange="changeMode('single')"> Single Window</label>
      <label><input type="radio" name="mode" value="dual" onchange="changeMode('dual')"> Dual Window</label>
      <label><input type="radio" name="mode" value="swipe" onchange="changeMode('swipe')"> Swipe Window</label>
      <hr>
        Indicies Analysis
      <label><input type="checkbox" id="ndvi-toggle" onchange="refreshLayers()"> NDVI </label> 
        <label><input type="checkbox" id="ndvi-toggle1" onchange="CropGrowth(this)"> Burn Index</label>
    </div>

    <div id="options">
      <!-- Single -->
      <div id="single" class="panel-content active">
        <label>Select Date:</label>
        <input type="date"  id="single-date" class="date-picker inputtype" onchange="generateSingleDates()">
        <input type="range" id="single-range" min="0" max="9" value="0" oninput="updateSingleLayer(this.value)">
        <div class="ticks" id="single-ticks"></div>
      </div>

      <!-- Dual -->
      <div id="dual" class="panel-content">
        <div class="window-section">
          <div class="window">
            <label>Date - Window 1:</label>
            <input type="date" id="dual-date1" class="date-picker inputtype" onchange="generateDualDates(1)">
            <input type="range" id="dual-range1" min="0" max="9" value="0" oninput="updateDualLayer(1, this.value)">
            <div class="ticks" id="dual-ticks1"></div>
          </div>
          <div class="window">
            <label>Date - Window 2:</label>
            <input type="date" id="dual-date2" class="date-picker inputtype" onchange="generateDualDates(2)">
            <input type="range" id="dual-range2" min="0" max="9" value="0" oninput="updateDualLayer(2, this.value)">
            <div class="ticks" id="dual-ticks2"></div>
          </div>
        </div>
      </div>

      <!-- Swipe -->
      <div id="swipe" class="panel-content">
        <div class="window-section">
          <div class="window">
            <label>Date -:</label>
            <input type="date" id="swipe-date1" class="date-picker inputtype" onchange="generateSwipeDates()">
          </div>
          <div class="window">
            <label>Date -:</label>
            <input type="date" id="swipe-date2" class="date-picker inputtype" onchange="generateSwipeDates()">
          </div>
        </div>
        <input type="range" id="swipe-slider" min="0" max="1" step="0.01" value="0.5" oninput="updateSwipeSlider()" />
      </div>
    </div>
    <div style="width: 15%;border: 1px solid #bfbfbf;padding:5px">
        <input type="checkbox" name="" id="zonecheck" onchange="sfdzone(this)" checked>Zone <br>
        <input type="checkbox" name="" id="circlecheck"   onchange="sfdcircle(this)" >Circle <br>
        <input type="checkbox" name="" id="divisioncheck"  onchange="sfddivision(this)" >Division <br> 
        <input type="checkbox" name="" id="plantationcheck"  onchange="sfdplantation(this)" >Plantation <br>
    </div>
  </div>

 <%--<script src="https://cdn.jsdelivr.net/npm/ol@v10.5.0/dist/ol.js"></script>--%>

     <%--<script src="../GIS/js/ol.js"></script>--%>
      <%--<script src="https://openlayers.org/en/v5.3.0/build/ol.js"></script>--%>
    <%--<script src="js/ol.js"></script>--%>
     <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <script src="../GIS/js/jquery.min.js"></script>
     <script src="js/analysis.js"></script>
  <script>
   

    
     
  </script>
   
</asp:Content>
