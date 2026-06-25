<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="ndviAnalysis.aspx.cs" Inherits="uk_forest.DSS.ndviAnalysis" ClientIDMode="Static" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css" />
     <link href="css/datepicker.css" rel="stylesheet" />
     <style>
            .page-container {
                padding: 0;
            }
             canvas.ol-unselectable {
                 height: calc(100vh - 100px) !important;
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
            .infoPopupBox img.closebtns{
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
            border:1px solid black;
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
             padding: 5px;
             width:250px;
             max-height: 300px;
            overflow: auto;
         }
        .datalayers ul li{
            list-style-type: none;
        }



    </style> 
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div > 
                    <div class="map-style-flood" id="map" style="margin-top:12px">
                          <div id="mouse-position"></div>
                         <asp:HiddenField runat="server" ID="mylayerswitcher" />
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
                        <div style="display:block" class="datalayers">
                            <ul>
                                <li >
                                            <asp:CheckBox ID="zone" runat="server" onclick='sfdzone(this);' Text="SFD Zone Boundaries" class="nav-item" />

                                            <span id='div_zone' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_zone_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="circle" runat="server" onclick='sfdcircle(this);' Text="SFD Circle Boundaries" class="nav-item" />

                                            <span id='div_circle' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_circle_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="division" runat="server" onclick='sfddivision(this);' Text="SFD Division Boundaries" class="nav-item" />

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
                           

                           <%-- <ul id="s23">
                                <asp:CheckBox ID="cd_CropGrowthChange" runat="server" onclick='CropGrowthChange(this);' Text="Crop Growth Change" class="nav-item" />
                                <div id='div_CropGrowthChange' style='display: none'>
                                </div>
                            </ul>--%>

                          <%--  <ul id="s24">
                                <asp:CheckBox ID="cd_Weed" runat="server" onclick='Weed(this);' Text="Weed" class="nav-item" />
                                <div id='div_Weed' style='display: none'>
                                    <img src="../images/layer_image/weed.png" style="width: 100%;" />
                                </div>
                            </ul>--%>

                        </div>
      
                           <asp:HiddenField ID="hfAllDates" runat="server" value="2024-03-23,2024-04-02" />





                        <div>
                               <div id="inptrangetimeseries" style="position: absolute; bottom: 0em; z-index: 1; margin: 25px; display: none">

                            <asp:TextBox ID="txtDateRange1" runat="server" type="range" min="0" max="" step="1" value="0" oninput="updateDateValue()" Style="width: 300px;" />
                            <%--<asp:TextBox ID="txtDateRange1" runat="server" type="range" min="0" max="" step="1" value="0" oninput="updateDateValue()" OnTextChanged="rangeinput_TextChanged" AutoPostBack="true" />--%>
                            <p id="rangeSelecetedDate" style="background-color: yellow; padding: 5px"></p>

                        </div>
                             <input type="text" id="time" name="time" onchange="setDateVariable()" />
                        </div>

 
                        

                    </div> 

                </div>
    <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>
  
    <script src="../GIS/js/jquery.min.js"></script>
    <script src="js/datepicker.js"></script>
    <script src="js/ndvianalysis.js"></script>
</asp:Content>
