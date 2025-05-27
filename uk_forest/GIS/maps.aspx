<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="maps.aspx.cs" Inherits="uk_forest.GIS.maps" ClientIDMode="Static" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
      <title></title>
  <%--  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous"/>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />--%>
     <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css" />
     

   <%-- <script src="https://code.jquery.com/jquery-2.2.0.min.js" type="text/javascript"></script>
    <link href="css/main.css" rel="stylesheet" />--%>
     <link href="css/limsMap.css" rel="stylesheet" />
    <style>
                    .page-container {
                padding: 0;
            }
                    
                    .ol-zoom.ol-unselectable.ol-control button {
  height: 38px;
  width: 38px;
  border-radius: 0px;
  background-color: white !important;
  color: black !important;
  border: 1px solid #e7e7e7 !important;
}
            .infoPopupBox {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background-color: #fff;
                padding: 5px;
                z-index: 5;
                display: none;
                cursor: move;
                max-width: 360px;
            }

            #infodiv .info-table-heading {
                background-color: #107a49;
                color: #fff;
                text-align: center;
                padding: 5px 0;
                font-size: 18px;
            }

            .infoPopupBox img.closebtns {
                position: relative;
                top: 7px;
                right: 5px;
                border-radius: 5px;
            }
            .page-content.my-5 {
                padding: 0px;
            }






        .layer-switcher {
            position: absolute;
            background: white;
            border: 1px solid black;
            border-radius: 4px;
            left: 12px;
            top: 90px;
            height: 38px;
            width: 38px;
            overflow: hidden;
        }

            .layer-switcher:hover {
                position: absolute;
                background: white;
                padding: 5px;
                border: 1px solid black;
                border-radius: 4px;
                right: 5px;
                top: 90px;
                height: 210px !important;
                width: 200px !important;
                transition: .4s;
            }

                 .layer-switcher:hover .layerswitcherimg {
                    display: none !important;
                }

        #imglayericon {
            height: 30px;
            padding: 0;
            margin-top: -3px;
            margin-left: -3px;
        }

        .layer-switcher label {
            display: block;
            margin: 5px 0;
        }

        .layer-switcher div div {
            display: flex;
        }

            .layer-switcher div div label {
                margin-left: 5px;
            }
    </style> 
    <style>
        .queryTable1toggle {
            position: fixed;
            bottom: 0;
            background-color: #ffffff00;
            bottom: 2px;
            transition: .3s;
        }

        .icon {
            padding: 5px !important;
            margin-right: 0px;
             
            filter: invert(1);
            border: 2px solid #000;
            border-radius: 5px;
            box-shadow: 0px 0px 3px #d3d3d361;
            width: 40px !important;
            height: 38px;
            position: relative;
            top: 3px;
            display: inline-block;
        }

        .iconenable {
            background: #c932ff !important;
            background-color: #5d9500 !important;
        }

        .addBtnClass {
            position: fixed !important;
            bottom: 180px !important;
        }

        #ReportViewer1 {
            border: 1px solid black;
        }

            #ReportViewer1 table, tr, td {
                border: none;
            }

        ReportViewer1_ctl09 {
            width: 720px;
        }

        #myModel3 {
            display: block;
            position: absolute;
            z-index: 11;
            background-color: white;
            top: 25%;
            display: none;
            right: 40px;
        }

            #myModel3 .modal-header {
                display: block;
                min-width: 300px;
            }

        #tbleditable {
            min-width: 300px;
        }

        .text-center {
            padding: 5px;
            background-color: #bbbbbb;
            width: 100%;
            align-items: center;
        }

        .close {
            padding: 3px;
            border-radius: 50%;
            height: 25px;
            background-color: white;
            border: wheat;
            width: 25px;
        }

        .loader {
            display: grid;
            justify-content: center;
        }

        input#btnSearch {
            background-color: #107a49;
            border: 1px solid #107a49;
        }

        button#convertBtn {
            background-color: #107a49;
            border-radius: 5px;
            margin: 0 auto;
            text-align: center;
            width: 80px;
            height: 40px;
            color: #fff;
            border: none;
            outline: none;
            position: relative;
            left: 50%;
            transform: translate(-50%, -50%);
            margin-top: 25px;
        }

        #time {
            display: inline-block;
            width: 155px;
            height: 35px;
            border-radius: 5px;
            border: 0;
        }

        #measure {
            padding: 7px 5px;
            border-radius: 5px;
            border: 0;
            background-color: #fff;
        }

        #typeDrow {
            padding: 7px 5px;
            background-color: #fff;
            border: 0;
            border-radius: 5px;
        }

        .subMenuColor1 img {
            padding-left: 20px !important;
        }

        .ForecasteColumnPopup {
            width: auto !important;
        }

            .ForecasteColumnPopup #divweatherforecaste_data {
                padding: 0;
            }

                .ForecasteColumnPopup #divweatherforecaste_data #moveable {
                    margin: 0 !important;
                }

        #div_map_pressure {
            position: fixed;
            bottom: 100px;
            z-index: 12000;
            right: 50px;
            display: none;
        }

            #div_map_pressure img {
                width: 100%;
            }

        #div_map_precipitation {
            position: fixed;
            bottom: 100px;
            z-index: 12000;
            right: 50px;
            display: none;
        }

            #div_map_precipitation img {
                width: 100%;
            }

        #div_map_wind_speed {
            position: fixed;
            bottom: 100px;
            z-index: 12000;
            right: 50px;
            display: none;
        }

            #div_map_wind_speed img {
                width: 100%;
            }

        #div_map_temperature {
            position: fixed;
            bottom: 100px;
            z-index: 12000;
            right: 50px;
            display: none;
        }

            #div_map_temperature img {
                width: 100%;
            }

        .customListItems select {
            display: block;
            width: 100%;
            padding: 8px 16px;
            border-bottom: 1px solid #d4d4d4 !important;
            border: 0;
        }
        .customListItems .swipeBtn1 {
            padding: 6px;
            border: 0;
            outline: none;
            background-color: #141c56;
            color: #fff;
            border-radius: 5px;
            margin-top: 15px;
            margin-left: 10px;
            margin-right: 10px;
        }
        .customListItems .clearBtn1 {
            padding: 6px;
            border: 0;
            outline: none;
            background-color:#107a48;
            color: #fff;
            border-radius: 5px;
        }
        .layer-info-popup table {
            min-width: 200px;
        }
    
    </style> 
    <style>
        #map {
            width: 100%;
            height: calc(100vh - 65px);
            border: 2px solid white;
        }

        .layerswitcher {
            position: absolute;
            z-index: 1;
            padding: 7px;
            top: 115px;
            cursor: pointer; 
        }
 

            

     
        .layerswitcher:hover + .layer-switcher {
            position: absolute;
            z-index: 1;
            display: flex; /* Initially hidden */
            flex-direction: column;
            background-color: white;
            padding: 10px;
            border: 1px solid black;
            top: 120px;
        }

        .layerswitcher img {
            height: 28px;
        }

        .mapFeature {
            position: absolute;
            z-index: 1;
            right: 0;
            padding: 5px;
            
        }

            .mapFeature div img {
                height: 35px;
                background-color: white;
            }

        .layersData {
            position: fixed;
            z-index: 10;
            right: 58px;
            background-color: white;
            border: 1px solid black;
            width: 385px;
            max-width: 400px;
            height: 550px;
            top: 132px;
            overflow: auto;
        }

            .layersData .layersDataHead {
            border-bottom: 1px solid #bbbbbb;
            display: flex;
            align-items: center;
            color: white;
            background-color: #818181;
        }

                .layersData .layersDataHead #divcloselayersDataid {
                    cursor: pointer;
                }

            
                .layersData div ul {
                    list-style-type: none;
                    padding: 0;
                }

                    .layersData div ul li label {
                        padding: 0px 10px;
                    }

        .mapFeature ul {
            list-style-type: none
        }

            .mapFeature ul li {
                margin: 5px 0px;
            }

                .mapFeature ul li img {
                    height: 50px;
                }

        .selected {
            
        }
    </style>
    <style>
        .ol-zoom.ol-unselectable.ol-control {
            display: flex;
            gap: 3px;
            top:18px;
        }
        .ol-full-screen.ol-unselectable.ol-control {
            top: 18px;
        }

            .ol-zoom.ol-unselectable.ol-control button {
                height: 38px;
                width: 38px;
                border-radius: 0px;
            }
        .ol-full-screen-false,.ol-full-screen-true {
            height: 38px !important;
            width: 38px !important;
            color: black !important;
            background-color: white !important;
            border: 1px solid #eee6e6 !important;
            top:18px;
        }
        .ol-full-screen-true {
  height: 38px !important;
  width: 38px !important;
  color: black !important;
  background-color: white !important;
}
        .iconsrow1 {
            position: relative;
            z-index: 1;
            left: 97px;
            height: 40px;
            top: 60px;
            display: flex;
            width: calc(100% - 150px);
            justify-content: space-between;
            align-items: center;
        }
        .iconsrow2 {
            position: absolute;
            z-index: 1;
            right: 10px;
            top: 200px;
            display: flex;
            height: calc(100% - 195px);
            justify-content: space-between;
            gap: 5px;
            flex-direction: column;
        }
            .iconsrow2 img {
                background-color: white;
                height: 40px;
                width: 40px;
                padding: 7px;
                border-radius:0;
            }

            .iconsrow3 {
                flex-direction: row;
                display: flex;
                position: absolute;
                z-index: 1;
                bottom: 70px;
                
                right: 10px;
                 
                gap: 5px;
            }
            .iconsrow3 img{
                height:40px;
                width:40px;
                padding:7px;
                background-color: white;
                border-radius:0;
            }
        .iconsrow2 .left-icons,.iconsrow2 .right-icons{
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

            .iconsrow1 div img {
                height: 40px;
                background-color: white;
                padding: 7px;
                border: 1px solid #e7e7e7;
                border-radius:0;
            }
             .iconenable {
            color:#01C1C9 !important;

        }
             table tr td{
                 border:1px solid #ededed;
             }


              .grabbable {
      cursor: grab;
      cursor: -webkit-grab;
    }
    .grabbing {
      cursor: grabbing !important;
      cursor: -webkit-grabbing !important;
    }
    </style>
    <style>
        .tooltip {
      position: absolute;
      background-color: white;
      padding: 5px;
      border-radius: 3px;
      pointer-events: none;
    }

    .tooltip-measure {
      background-color: red;
      color: white;
    }

    .hidden {
      display: none;
    }

    .controls {
      position: absolute;
      left: 10px;
      z-index: 10;
      background-color: rgba(255, 255, 255, 0.9);
      padding: 5px;
      border-radius: 5px;
    }

    .controls:nth-child(1) { top: 10px; }
    .controls:nth-child(2) { top: 70px; }
    .controls:nth-child(3) { top: 140px; }

    .popup {
      position: absolute;
      top: 150px;
      left: 50%;
      transform: translateX(-50%);
      background-color: rgba(0, 0, 0, 0.85);
      color: white;
      padding: 10px 20px;
      border-radius: 5px;
      z-index: 1000;
      font-size: 14px;
      transition: opacity 0.3s ease;
    }

    .popup.hidden {
      display: none;
    }

    .tool-btn {
      width: 40px;
      height: 40px;
      margin-right: 5px;
      cursor: pointer;
      border: 2px solid transparent;
      border-radius: 5px;
      transition: background-color 0.3s;
    }

    .tool-btn.active {
      background-color: green;
      border-color: white;
    }

    #map .mapFeatureData {
      margin-top: -40px;
    }

        .querybuilderdiv {
            position: absolute;
            z-index: 1;
            right: 60px;
            top: 20%;
            background-color: white;
            padding: 0px;
            width: 250px;
            display:none;
        }
        .querybuilderheader {
            text-align: center;
            padding: 3px;
            border: 1px solid #edefed;
        }
        .row {
            display: flex !important;
            justify-content: center !important;
            align-items: center !important;
            padding: 5px !important;
        } .row select {
            width:90%;height: 25px;
        }.row button {
            width:90%;height: 25px;
        }
        #mouse-position {
            position: absolute;
            background: rgba(255, 255, 255, 0.9);
            padding: 8px 12px;
            border: 1px solid #ccc;
            font-family: Arial, sans-serif;
            font-size: 14px;
            z-index: 1000;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            bottom: 10px;
            right: 3px;
        }
        body {
            height: 96vh;
        }

        .ol-scale-line-inner {
            color: #717171;
            text-align: center;
            background-color: white;
            height: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .layerswitcherimg {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 38px;
        }
    </style>
    
                                <style>
                                    
    .accordion {
      border: 1px solid #ccc;
      border-radius: 5px;
      overflow: hidden;
    }

    .accordion-item {
      border-bottom: 1px solid #ccc;
    }

    .accordion-button {
      background-color: #f1f1f1;
      color: #333;
      padding: 15px;
      width: 100%;
      text-align: left;
      border: none;
      outline: none;
      cursor: pointer;
      font-size: 16px;
      position: relative;
      transition: background-color 0.1s;
    }

    .accordion-button:hover {
      background-color: #ddd;
    }
.accordion-button::after {
  content: '+'; /* Plus sign when collapsed */
  position: absolute;
  right: 20px;
  font-size: 20px;
  transition: transform 0.3s ease;
}

.accordion-button.active::after {
  content: '−'; /* Minus sign when expanded */
}


    .accordion-button.active {
      background-color: #e0e0e0;
       
    }

    .accordion-content {
      max-height: 0;
      overflow: hidden;
      transition: max-height 0.4s ease-in-out;
      background-color: white;
    }

    .accordion-content.open {
     
      max-height: 1000px; /* Large enough value to ensure the content opens smoothly */
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    th, td {
      border: 1px solid #ccc;
      padding: 8px;
      text-align: left;
    }

    th {
      background-color: #f5f5f5;
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
     

        <asp:ScriptManager runat="server"></asp:ScriptManager>
 
        <div> 
            <div > 
                <div > 
                    <div class="map-style-flood" id="map">
                          <div id="mouse-position"></div>
                         <asp:HiddenField runat="server" ID="mylayerswitcher" />
                        <div class="layer-switcher" style="z-index: 11; background-color: white !important;">
                            <div class="layerswitcherimg" id="layer">
                                 
                                <asp:Image runat="server" ID="imglayericon" ImageUrl="img/layerswitcher.png" />
                            </div>
                            <div>

                                
<%--                                  <label>
                                    <input type="radio" name="layer" value="basemap_ortho" />
                                   Bumba ortho
                                </label>

                                  <label>
                                    <input type="radio" name="layer" value="risala_ortho" />
                                   Risala ortho
                                </label>--%>

                                <label>
                                    <input type="radio" name="layer" value="osm" checked  />
                                    OpenStreetMap
                                </label>

                                <label>
                                    <input type="radio" name="layer" value="hybrid" />
                                    Google Hybrid
                                </label>
                                <label>
                                    <input type="radio" name="layer" value="satellite" />
                                    Google Satellite
                                </label>
                                <label>
                                    <input type="radio" name="layer" value="roadmap" />
                                    Google Roadmap
                                </label>  
                                <label>
                                    <input type="radio" name="layer" value="none" />
                                    Remove Image
                                </label>
                                <label>
                                    <input type="radio" name="layer" value="sentinel1" />
                                    Sentinel-1
                                </label>
                              <label>
                                    <input type="radio" name="layer" value="sentinel2fcc" />
                                    Sentinel-2 FCC
                                </label>

                                 <label>
                                    <input type="radio" name="layer" value="sentinel2ncc" />
                                    Sentinel-2 NCC
                                </label>


                            </div>
 
                        </div>
      









                        <asp:UpdatePanel runat="server" ID="upd">
                            <ContentTemplate>



                                <div class="querybuilderdiv" id="querybuilderdivid" runat="server">
                                    <div class="querybuilderheader">
                                        <h3>Query Builder</h3>

                                    </div>
                                    <div>
                                        <div class="row">
                                            <asp:DropDownList class="ddlstyle" runat="server" ID="ddllayer" AutoPostBack="true" OnSelectedIndexChanged="ddllayer_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                        <div class="row">
                                            <asp:DropDownList class="ddlstyle" runat="server" ID="ddlattrubutename" AutoPostBack="true" OnSelectedIndexChanged="ddlattrubutename_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                        <div class="row">
                                            <asp:DropDownList class="ddlstyle" runat="server" ID="ddlattributevalue"></asp:DropDownList>
                                        </div>
                                        <div class="row">
                                            <button onclick="clientQuery()">Search</button>
                                        </div>

                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <div class="mapFeatureData">
                            <div class="layersData" id="layersDataid" style="display: none;">

                                                                <div class="layersDataHead">
                                    <div style="text-align: center; width: 95%;padding:0">
                                        <h3 style="font-weight: 700; font-size: 25px; margin-top: 5px;">Layers</h3>
                                    </div>
                                  
                                                                     <div id="divcloselayersDataid" style="width: 10%; text-align: center;">
                                        <span style="padding: 4px; background-color: red;cursor: pointer;" onclick="fun_layer()">X</span>
                                    </div>
                                </div>

                                
  <div class="0">

    <!-- Group 1 -->
    <div class="accordion-item">
      <button type="button" class="accordion-button" onclick="toggleAccordion(this)">Administrative Units</button>
      <div class="accordion-content open">
          <div style="padding:10px">
              <ul>
                  <li>
                                            <asp:CheckBox ID="cd_state" runat="server" onclick='state(this);' Text="State Boundary" class="nav-item" />

                                            <span id='div_state' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_state_boundary&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>

                                        <li>
                                            <asp:CheckBox ID="cd_district" runat="server" onclick='district(this);' Text="District Boundary" class="nav-item" />

                                            <span id='div_district' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_districts&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>

                                        <li >
                                            <asp:CheckBox ID="cd_tehsil" runat="server" onclick='tehsil(this);' Text="Tehsil & Village Boundary" class="nav-item" />

                                            <span id='div_tehsil' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_village_tehsil_recap4ndc_discticts&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>   <li >
                                            <asp:CheckBox ID="zone" runat="server" onclick='sfdzone(this);' Text="Zone Boundary" class="nav-item" />

                                            <span id='div_zone' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_zone_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="circle" runat="server" onclick='sfdcircle(this);' Text="Circle Boundary" class="nav-item" />

                                            <span id='div_circle' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_circle_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="division" runat="server" onclick='sfddivision(this);' Text="Division Boundary" class="nav-item" />

                                            <span id='div_division' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_division_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li><li >
                                            <asp:CheckBox ID="range" runat="server" onclick='range_fun(this);' Text="Range" class="nav-item" />

                                            <span id='div_range' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_range_areas&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                        
                                         <li >
                                            <asp:CheckBox ID="block" runat="server" onclick='block_fun(this);' Text="Blocks" class="nav-item" />

                                            <span id='div_block' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_block_areas&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
              </ul>
          </div>
      </div>
    </div>

    <!-- Group 2 -->
    <div class="accordion-item">
      <button type="button" class="accordion-button" onclick="toggleAccordion(this)">Reference Info</button>
      <div class="accordion-content">
          <div style="padding:10px">
              <ul>
                   <li >
                                            <asp:CheckBox ID="railwaystation" runat="server" onclick='railwaystation_fun(this);' Text="Railway Station" class="nav-item" />

                                            <span id='div_railwaystation' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_railway_station&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         
                                        
                                        
                                        
                                        <%--SADFASDF--%>
                                         <li >
                                            <asp:CheckBox ID="majorcity" runat="server" onclick='majorcity_fun(this);' Text="Major City" class="nav-item" />

                                            <span id='div_majorcity' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_major_city&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                          <li >
                                            <asp:CheckBox ID="roads" runat="server" onclick='roads_fun(this);' Text="Roads" class="nav-item" />

                                            <span id='div_road' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_road&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>  
                                        <li>
                                            <asp:CheckBox ID="railways" runat="server" onclick='railways_fun(this);' Text="Railway Lines" class="nav-item" />

                                            <span id='div_railways' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_railway_line&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>   
                                        <li>
                                            <asp:CheckBox ID="waterbody" runat="server" onclick='waterbody_fun(this);' Text="Water Body" class="nav-item" />

                                            <span id='div_waterbody' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_water_body&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>  <li>
                                            <asp:CheckBox ID="rivers" runat="server" onclick='rivers_fn(this);' Text="Drainage" class="nav-item" />

                                            <span id='div_rivers' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_drainage&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>   <li>
                                            <asp:CheckBox ID="population_density" runat="server" onclick='populationdensity(this);' Text="Population Density" class="nav-item" />

                                            <span id='div_population_density' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_population_status_y2011&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>  <li>
                                            <asp:CheckBox ID="micro_watershed_boundary" runat="server" onclick='microwatershedboundary(this);' Text="Micro Watershed Boundary" class="nav-item" />

                                            <span id='div_micro_watershed_boundary' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_clip_mws_reprj&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 



                   <li >
                                            <asp:CheckBox ID="Aspect" runat="server" onclick='Aspect_Geofn(this);' Text="Aspects" class="nav-item" />

                                            <span id='div_Aspects' style='display: none'>
                                                <%--<img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:Aspect_Geo&Format=image/gif&scale=800000&Transparent=true" />--%>
                                                <img src="../DSS/img/Aspect.PNG" />
                                            </span>
                                        </li>

                                   <li >
                                            <asp:CheckBox ID="slope" runat="server" onclick='slopefn(this);' Text="Slope" class="nav-item" />

                                            <span id='div_slope' style='display: none'>
                                                <%--<img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:Aspect_Geo&Format=image/gif&scale=800000&Transparent=true" />--%>
                                                <img src="../DSS/img/Slope.PNG" />
                                            </span>
                                        </li>
                                   <li >
                                            <asp:CheckBox ID="srtm" runat="server" onclick='srtmfun(this);' Text="DTM" class="nav-item" />

                                            <span id='div_srtm' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:Uttaranchal_SRTM_GEO&Format=image/gif&scale=800000&Transparent=true" />
                                               
                                            </span>
                                        </li>

                                 
              </ul>

          </div>
      </div>
    </div>

    <!-- Group 3 -->
    <div class="accordion-item">
      <button type="button" class="accordion-button" onclick="toggleAccordion(this)">Forest Data</button>
      <div class="accordion-content">
          <div style="padding:10px">
              <ul>
                       <li >
                                            <asp:CheckBox ID="cd_village" runat="server" onclick='village(this);' Text="Forest Area" class="nav-item" />

                                            <span id='div_village' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_uk_forest_data&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>  



                    <li >
                                            <asp:CheckBox ID="plantation" runat="server" onclick='funplantation(this);' Text="Plantation" class="nav-item" />

                                            <span id='div_plantation' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_plantation_area&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>  


                                        <li>
                                            <asp:CheckBox ID="forest_canopy" runat="server" onclick='forestCapopy(this);' Text="Forest Canopy Cover" class="nav-item" />

                                            <span id='div_forest_canopy' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_fsi_fcd2021&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>   


                    <li>
                                            <asp:CheckBox ID="CheckBox1" runat="server" onclick='forestDensity(this);' Text="Forest Density" class="nav-item" />

                                            <span id='div_forest_density' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_fsi_fcd2021&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>   
              </ul>
          </div>
      </div>
    </div>

      
    <!-- Group 3 -->
    <div class="accordion-item">
      <button type="button" class="accordion-button" onclick="toggleAccordion(this)">Forest Fire Info</button>
      <div class="accordion-content">
          <div style="padding:10px">
              <ul>
                  <li>
                                            <asp:CheckBox ID="forest_fire_prone" runat="server" onclick='forestfireprone(this);' Text="Forest Fire Prone" class="nav-item" />

                                            <span id='div_forest_fire_prone' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_forest_fire_prone_fsi_data&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                  <li>
                      <div class="accordion-item">
                          <button type="button" class="accordion-button" onclick="toggleAccordion(this)">Forest Fire Incident Location</button>
                          <div class="accordion-content">
                              <div style="padding: 10px">
                                  <ul>
                                      <li>
                                            <asp:CheckBox ID="tbl_2024" runat="server" onclick='forestfirepoints2024(this);' Text="2024" class="nav-item" />

                                            <span id='div_fire_points2024' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_2024&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                       <li>
                                            <asp:CheckBox ID="tbl_2023" runat="server" onclick='forestfirepoints2023(this);' Text="2023" class="nav-item" />

                                            <span id='div_fire_points2023' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_2023&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                       <li>
                                            <asp:CheckBox ID="tbl_2022" runat="server" onclick='forestfirepoints2022(this);' Text="2022" class="nav-item" />

                                            <span id='div_fire_points2022' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_2022&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                       <li>
                                            <asp:CheckBox ID="tbl_2021" runat="server" onclick='forestfirepoints2021(this);' Text="2021" class="nav-item" />

                                            <span id='div_fire_points2021' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_2021&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                       <li>
                                            <asp:CheckBox ID="tbl_2020" runat="server" onclick='forestfirepoints2020(this);' Text="2020" class="nav-item" />

                                            <span id='div_fire_points2020' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_2020&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                       <li>
                                            <asp:CheckBox ID="tbl_2019" runat="server" onclick='forestfirepoints2019(this);' Text="2019" class="nav-item" />

                                            <span id='div_fire_points2019' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_2019&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                  </ul>
                              </div>
                          </div>
                      </div>
                  </li>

              </ul>
          </div>
      </div>
    </div>
      
    <!-- Group 4 -->
    <div class="accordion-item">
      <button type="button" class="accordion-button" onclick="toggleAccordion(this)">Other</button>
      <div class="accordion-content">
          <div style="padding: 10px">
              <ul>


                                       
                                        <li>
                                            <asp:CheckBox ID="land_degradation" runat="server" onclick='landdegradation(this);' Text="Land Degradation (2018-19)" class="nav-item" />

                                            <span id='div_land_degradation' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_clip_reproj_uttarakhand_land_degradation_status_2018_19_&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                      
                                       
                                        <li>
                                            <asp:CheckBox ID="livestock_pressure" runat="server" onclick='livestockpressure(this);' Text="Livestock Pressure (2019)" class="nav-item" />

                                            <span id='div_livestock_pressure' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_livestock_pressure&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                        <li>
                                            <asp:CheckBox ID="lpg_connection" runat="server" onclick='lpgconnection(this);' Text="LPG Connection (2024)" class="nav-item" />

                                            <span id='div_lpg_connection' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_lpg_connections&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                       
                                        <li>
                                            <asp:CheckBox ID="green_india_mission" runat="server" onclick='greenindiamission(this);' Text="Green India Mission" class="nav-item" />

                                            <span id='div_green_india_mission' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_utm43_gim_intersect_division_mws&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                        <li>
                                            <asp:CheckBox ID="field_validation_points" runat="server" onclick='fieldvalidationpoints(this);' Text="Field Validation Points" class="nav-item" />

                                            <span id='div_field_validation_points' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_field_validation_pts_june_july2024&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                        <li>
                                            <asp:CheckBox ID="human_wildlife_conflict" runat="server" onclick='humanwildlifeconflict(this);' Text="Human Wildlife Conflict data" class="nav-item" />

                                            <span id='div_human_wildlife_conflict' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_all_human_wildlife_conflict_info&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                          <li>
                                            <asp:CheckBox ID="intervention_area" runat="server" onclick='interventionarea(this);' Text="Intervention area stats (LULC, FCD and SAC degradation)" class="nav-item" />

                                            <span id='div_intervention_area' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_interventionareastats_fcd_lulc_dld_sac&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
              </ul>
          </div>
      </div>
    </div>

  </div>
                               
                                
  <script>
      function toggleAccordion(button) {
          const content = button.nextElementSibling;
          const isOpen = content.classList.contains('open');

          // Toggle current section only
          if (isOpen) {
              content.classList.remove('open');
              button.classList.remove('active');
          } else {
              content.classList.add('open');
              button.classList.add('active');
          }
      }

  </script>









                                <div> 
                                    <ul> 
                                        <li style='display: none'>
                                            <asp:CheckBox ID="cd_country" runat="server" onclick='country(this);' Text="Country" class="nav-item" />

                                            <span id='div_country' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_country_boundary&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>

                                       
                                        <%--SADFASDF--%>
                                      
                                         <%--SADFASDF--%>
                                        
                                  















                                  
                                      <%--  <li>
                                            <asp:CheckBox ID="longlist_landscape" runat="server" onclick='longlistlandscape(this);' Text="Longlist Landscape Boundary" class="nav-item" />

                                            <span id='div_longlist_landscape' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_7ls_new&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                        <li>
                                            <asp:CheckBox ID="shortlist_landscape1" runat="server" onclick='shortlistlandscape1(this);' Text="Shortlist Landscape boundary- LS1" class="nav-item" />

                                            <span id='div_shortlist_landscape1' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_ls_1&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                        <li>
                                            <asp:CheckBox ID="shortlist_landscape2" runat="server" onclick='shortlistlandscape2(this);' Text="Shortlist Landscape boundary- LS2" class="nav-item" />

                                            <span id='div_shortlist_landscape2' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_ls_2&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> --%>


                                       <%-- <li>
                                            <asp:CheckBox ID="area_at_landscape1" runat="server" onclick='areaatlandscape1(this);' Text="Intervention (degraded) area at landscape 1" class="nav-item" />

                                            <span id='div_area_at_landscape1' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_intervention_l_1&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 
                                        <li>
                                            <asp:CheckBox ID="area_at_landscape2" runat="server" onclick='areaatlandscape2(this);' Text="Intervention (degraded) area at landscape 2" class="nav-item" />

                                            <span id='div_area_at_landscape2' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_intervention_l_2&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> --%>
                                      
                                       
                                    </ul>
                                </div>

                            </div>

                        </div>

                        <div class="iconsrow1 gettitle">
                            <div class="left-icons">
                                <%--<img class="tool-btn" src="img/map_icons/find.png" title="Find" />--%>
                                <img class="tool-btn" src="img/map_icons/hand.png" title="Pen" alt="Start/Stop Toggle" id="toggleImage" />
                                <%--<img class="tool-btn" src="img/map_icons/check.png" title="Check" />--%>
                                <img class="tool-btn" src="img/map_icons/info.png" title="Information" id="info" onclick="setselectedinfo();" />
                            </div>
                            <div class="right-icons">
                                <img src="img/map_icons/layer.png" title="Layers" id="imgidlayer" onclick="fun_layer()" />
                              <%--  <img src="img/map_icons/scalability.png" title="Scalability" />--%>
                            </div>
                        </div>

                        <div class="iconsrow2 gettitle">
                            <div class="left-icons">
                                 <%--<button id="clearAllBtn" class="clear-btn">Clear All</button>--%>
                                <img class="tool-btn" src="img/map_icons/clear_all.png" id="clearAllBtn" title="Clear All"  />
                                <img class="tool-btn" src="img/map_icons/measure.png" id="measureLine"  title="Measure Line"  />
                                <img class="tool-btn" src="img/map_icons/major_area.png" id="measureArea"  title="Measure Area" />
                                <img class="tool-btn" src="img/map_icons/data-searching.png" id="querybuilder" title="Query Builder" />
                                <img class="tool-btn" src="img/map_icons/buffer.png" title="Buffer" />
                                <img class="tool-btn" src="img/map_icons/overlay-analysis.png" title="Overley Analysis" />
                                <img class="tool-btn" src="img/map_icons/draw-features.png" title="Draw Feature" />
                                <img class="tool-btn" src="img/map_icons/redo.png" title="Redo" id="redoBtn" />
                                <img class="tool-btn" src="img/map_icons/undo.png" id="undoBtn" title="Undo"  />
                            </div>

                        </div>
                        <div class="iconsrow3 gettitle">
                            <div class="right-icons" style="flex-direction: row;">
                                <img class="tool-btn" src="img/map_icons/export.png" title="Export"id="download-btn" />
                                <img class="tool-btn" src="img/map_icons/printer.png" title="Print" />
                            </div>
                        </div>

                    </div> 

                </div>
                        </div> 
        </div>
         <div id="div" class="infoPopupBox">
            <img src="img/close.png" class="closebtns" style="float: right; width: 22px" title="Close" alt="X" onclick="closeclick();" />
            <div id="infodiv">
            </div>
        </div>
       
      
        <asp:HiddenField runat="server" ID="hfCheckForLayer" />
       
        <asp:HiddenField runat="server" ID="httest" />
         <script src="js/ol.js"></script>
         <script src="js/jquery.min.js"></script>
        <script src="js/gismap.js"></script>
   
</asp:Content>
