<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="timeSeriesAnalysis.aspx.cs" Inherits="uk_forest.DSS.timeSeriesAnalysis" ClientIDMode="Static" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css" />
     <style>
                   

                    
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
           







        .layer-switcher {
            position: relative;
            background: white;
            border: 1px solid black;
            border-radius: 4px;
            left: 12px;
            top: 130px;
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
         div#mouse-position {
             position: absolute;
             z-index: 1;
             bottom: 2px;
             right: 10px;
         }

         input#time {
             position: absolute;
             right: 10px;
             z-index: 1;
         }
          .datalayers {
             display: block;
             position: absolute;
             z-index: 1;
             right: 10px;
             background-color: white;
             top: 72px;
             width:250px;
             padding: 5px;
         }

             .datalayers ul {
                 list-style-type: none;
             }
         .iconsrow1 {
             position: relative;
             z-index: 1;
             left: 80px;
             height: 34px;
             top: 42px;
             display: flex;
             width: calc(100% - 150px);
             justify-content: space-between;
             align-items: center;
         }
             .iconsrow1 div img {
                 height: 32px;
                 background-color: #d7d7d7;
                 color: white;
                 padding: 7px;
                 border: 1px solid #000000;
                 border-radius: 0;
             }
             .iconenable {
            color:#01C1C9 !important;

        }
             table{
                     width: 100%;
             }
                 table tr, td, th {
                     border: 1px solid #adadad;
                     padding: 3px;
                 }

         .page-content.my-5 .page-container {
             margin-top: 0px;
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
         .ol-zoom.ol-unselectable.ol-control {
             display: flex !important;
             gap:3px;
         } .ol-zoom.ol-unselectable.ol-control button {
             height: 30px !important;
             width: 30px !important;
             background-color: #d7d7d7;
                 color: #000000; border: 1px solid #000000;
         }


           
    #dateRange {
        width: 90%;
        margin-top: 20px;
    }

    .labels {
      display: flex;
      justify-content: space-between;
      margin-top: 10px;
    }

    .labels span {
      font-size: 12px;
      text-align: center;
      color:black;
      margin-left: 75px;
          background-color: white;
      width: 10%; /* 10 items */
      transform: translateX(-50%);
    }

    .selected-date {
      margin-top: 15px;
      font-weight: bold;
    }

    #sliderSection {
      display: none;
          position: absolute;
    z-index: 1;
    bottom: 40px;
    width: 100%;
        text-align: center;
    }
         
         .maindiv {
             border: 1px solid red;
             margin-top: 40px;
             display: flex;
             gap: 5px;
         }
         .page-content{
             margin-top:85px !important;
             padding:0;
         }
      
    </style> 
    
    <link href="css/datepicker.css" rel="stylesheet" />
       <script src="js/datepicker.js"></script>
     
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <style>
        .newtop {
            /*margin-top: 10px;
            border: 1px solid red;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 92vh;*/
        }
    </style>
    <%-- <div class="newtop">sdfsd</div>--%>
     <%--    <div id="map2parent" style="width:50%;border:1px solid pink;height: 100%;overflow: hidden;">
             <div id="map2" style="height:100%"></div>
         </div>
         <div  id="map1parent"  style="width:50%;border:1px solid green;height: 100%;overflow: hidden;">
             <button type="button" onclick="callsplit()" style="margin-top: 36px;">Split</button>--%>
              <div class="map-style-flood" id="map" style="height:91vh">
                         
                        <div class="layer-switcher" style="z-index: 11; background-color: white !important;">
                            <div class="layerswitcherimg" id="layer" style="text-align: center; margin: 5px auto;">
                                
                                <asp:Image runat="server" ID="imglayericon" ImageUrl="../GIS/img/layerswitcher.png" />
                            </div>
                            <div>
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
       <div id="mouse-position"></div>
                         <asp:HiddenField runat="server" ID="mylayerswitcher" />
                           <asp:HiddenField ID="hfAllDates" runat="server" value="2024-03-23,2024-04-02" />


                  <div class="iconsrow1 gettitle" style="position: relative; z-index: 11111;display:none">
                            <div class="left-icons">
                                
                                <img class="tool-btn" src="../GIS/img/map_icons/info.png" title="Information" id="info" onclick="setselectedinfo();" />
                            </div>
                            <div class="right-icons">
                            
                            </div>
                        </div>
                         <div id="div" class="infoPopupBox">
            <img src="../GIS/img/close.png" class="closebtns" style="float: right; width: 22px" title="Close" alt="X" onclick="closeclick();" />
            <div id="infodiv">
                
            </div>
        </div>


                        <div>
                               <div id="inptrangetimeseries" style="position: absolute; bottom: 0em; z-index: 1; margin: 25px; display: none">

                            <asp:TextBox ID="txtDateRange1" runat="server" type="range" min="0" max="" step="1" value="0" oninput="updateDateValue()" Style="width: 300px;" />
                            <%--<asp:TextBox ID="txtDateRange1" runat="server" type="range" min="0" max="" step="1" value="0" oninput="updateDateValue()" OnTextChanged="rangeinput_TextChanged" AutoPostBack="true" />--%>
                            <p id="rangeSelecetedDate" style="background-color: yellow; padding: 5px"></p>

                        </div>
                             <input type="text" id="time" name="time" />
                        </div>

 <div id="sliderSection">
    <input type="range" id="dateRange" min="0" max="9" value="0" step="1">
    <div class="labels" id="dateLabels"></div>
    
  </div>
                        
                          <div style="display:block" class="datalayers">
                     <div style="border-bottom: 2px solid #d5d5d5; text-align: center;">
                         <h3>Layers</h3>

                     </div>
                     <div style="padding: 10px 0;">                            <ul>
                                <li >
                                            <asp:CheckBox ID="zone" runat="server" onclick='sfdzone(this);' Text=" Zone Boundaries" class="nav-item" />

                                            <span id='div_zone' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_zone_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="circle" runat="server" onclick='sfdcircle(this);' Text="Circle Boundaries" class="nav-item" />

                                            <span id='div_circle' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_circle_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="division" runat="server" onclick='sfddivision(this);' Text=" Division Boundaries" class="nav-item" />

                                            <span id='div_division' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_division_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>


                                 <li >
                                            <asp:CheckBox ID="cd_LandDetails" runat="server" onclick='LandDetails(this);' Text="Plantation AOI" class="nav-item" />

                                            <span id='div_LandDetails' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_plantation_area&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                  <li>
                                            <asp:CheckBox ID="forest_fire_points" runat="server" onclick='forestfirepoints(this);' Text="Forest Fire Points" class="nav-item" />

                                            <span id='div_forest_fire_points' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_forest_fire_point&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li> 



                                        
                            </ul>
                             <ul >
                        <li id="m_8" runat="server"><a href="#!"><i class="fa-solid fa-user"></i> <em class="fa fa-angle-down"></em></a>
                        <%--    <ul >
                               
                                <div id='div_LandDetails' style='display: none'>
                                    <img src="https://ukforestgis.in/geoserver/nrdc/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=nrdc:view_farmer_details&Format=image/gif&scale=800000&Transparent=true" />
                                </div>
                            </ul>--%>
                         <%--   <ul id="s151">
                                <asp:CheckBox ID="cb_apple_plant" runat="server" onclick='apple_plant(this);' Text="Thailand Image 2" class="nav-item" />
                                <div id='div_apple_plant' style='display: none'>
                                    <img src="https://ukforestgis.in/geoserver/nrdc/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=nrdc:view_farmer_details&Format=image/gif&scale=800000&Transparent=true" />
                                </div>
                            </ul>--%>
                        </li>
                    </ul>
                            <asp:HiddenField runat="server" ID="layerswid" />

                            <ul id="s16" runat="server" visible="false">
                                <asp:CheckBox ID="cd_CropGrowth" runat="server" onclick='CropGrowth(this);' Text=" Growth" class="nav-item" style="    margin-left: 34px;"/>
                                <div id='div_CropGrowth' style='display: none'>
                                    <img src="../images/layer_image/ndvi.png" style="width: 100%;" />
                                </div>
                            </ul>

                            <ul id="s17"  runat="server" visible="false">
                                <asp:CheckBox ID="cd_CropHealth" runat="server" onclick='CropHealth(this);' Text=" Health" class="nav-item" />
                                <div id='div_CropHealth' style='display: none'>
                                    <img src="../images/layer_image/health.png" style="width: 100%;" />
                                </div>
                            </ul>

                            <ul id="s18" runat="server" visible="false">
                                <asp:CheckBox ID="cd_CropHarvesting" runat="server" onclick='CropHarvesting(this);' Text="  Harvesting" class="nav-item" />
                                <div id='div_CropHarvesting' style='display: none'>
                                    <img src="../images/layer_image/harvesting.png" style="width: 100%;" />
                                </div>
                            </ul>

                            <ul id="s19" runat="server" visible="false">
                                <asp:CheckBox ID="cd_VegetationMoisture" runat="server" onclick='VegetationMoisture(this);' Text="Vegetation Moisture" class="nav-item" />
                                <div id='div_VegetationMoisture' style='display: none'>
                                    <img src="../images/layer_image/vegetation-moisture.png" style="width: 100%;" />
                                </div>
                            </ul>

                            <ul id="s20" runat="server" visible="false">
                                <asp:CheckBox ID="cd_NitrogenContent" runat="server" onclick='NitrogenContent(this);' Text="Nitrogen Content" class="nav-item" />
                                <div id='div_NitrogenContent' style='display: none'>
                                    <img src="../images/layer_image/NitrogenContent.png" style="width: 100%;" />
                                </div>
                            </ul>

                            <ul id="s21" runat="server" visible="false">
                                <asp:CheckBox ID="cd_SoilMoisture" runat="server" onclick='SoilMoisture(this);' Text="Soil Moisture" class="nav-item" />
                                <div id='div_SoilMoisture' style='display: none'>
                                    <img src="../images/layer_image/SoilMoisture.png" style="width: 100%;" />
                                </div>
                            </ul>

                            <ul id="s22" runat="server" visible="false">
                                <asp:CheckBox ID="cd_EnhancedVegetation" runat="server" onclick='EnhancedVegetation(this);' Text="Enhanced Vegetation" class="nav-item" />
                                <div id='div_EnhancedVegetation' style='display: none'>
                                    <img src="../images/layer_image/EnhancedVegetation.png" style="width: 100%;" />
                                </div>
                            </ul>

                           <%-- <ul id="s23">
                                <asp:CheckBox ID="cd_CropGrowthChange" runat="server" onclick='CropGrowthChange(this);' Text="Crop Growth Change" class="nav-item" />
                                <div id='div_CropGrowthChange' style='display: none'>
                                </div>
                            </ul>--%>

                            <ul id="s24" runat="server" visible="false">
                                <asp:CheckBox ID="cd_Weed" runat="server" onclick='Weed(this);' Text="Weed" class="nav-item" />
                                <div id='div_Weed' style='display: none'>
                                    <img src="../images/layer_image/weed.png" style="width: 100%;" />
                                </div>
                            </ul>
                      </div>
                        </div>
                    </div>
         <%--</div>--%>
    <%-- </div>--%>
    <%-- <div style="margin-top: 40px;" class="maindiv"> 
         

                </div>--%>
    <script src="../GIS/js/ol.js"></script>
  
    <script src="../GIS/js/jquery.min.js"></script>
    <script src="js/timeseriesanalysis.js"></script>
</asp:Content>
