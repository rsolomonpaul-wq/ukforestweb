<%@ Page  Title="" Language="C#" AutoEventWireup="true" CodeBehind="modules.aspx.cs" Inherits="uk_forest.web.modules" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RECAP4NDC</title>
    <!-- App favicon -->
    <link rel="shortcut icon" href="../admin/assets/images/favicon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp">
    <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css" />
    <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>
    <link rel="stylesheet" href="./admin/assets/css/icons.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .front-box .iconPic.iconBorder {
            width: 60px;
            height: 60px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            position: relative;
            border:2px solid transparent;
            background: #ffffff;
            background-clip: padding-box;
            border-radius: 10px;
        }
        .front-box .iconPic.iconBorder::after {
            content: '';
            position: absolute;
            top: -2px;
            bottom: -2px;
            left: -2px;
            right: -2px;
            background: linear-gradient(to bottom right, #22c1c3, #fdbb2d);
            z-index: -1;
            border-radius: 10px;
        }

        .modal {
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background:rgb(0 0 0 / 82%);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: #fff;
            color:#000;
            padding: 20px;
            width: 400px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            z-index: 10000; /* Ensure it stays above the modal background */
        }

        .close {
            float: right;
            font-size: 24px;
            cursor: pointer;
        }
        .loginPopupBox .modal-content:{
            position:relative;
        }
        .loginPopupBox .modal-content .close {
            position:absolute;
            top:-20px;
            right:-20px;
            background-color: #0c65e7;
            width: 40px;
            height: 40px;
            line-height: 37px;
            text-align: center;
            color: #ffffff;
            font-size: 30px;
            border-radius: 50px;
            font-weight: 400;
        }
        .loginPopupBox .modal-content h2 {
            font-weight: 600;
            text-align:center;
        }
        .loginPopupBox .modal-content .f_group {
            display: inline-block;
            margin-bottom: 20px;
        }
        .loginPopupBox .modal-content .f_group label {
            font-size: 16px;
            padding-bottom: 3px;
            margin-left: 2px;
        }
        .loginPopupBox .modal-content select {
            display: inline-block;
            width: 100%;
            height: 44px;
            border: 1px solid lightgray;
            box-shadow: 0px 3px 3px #d3d3d378;
            background-color:#fff;
            color:#000;
        }
        .loginPopupBox .modal-content input{
            display: inline-block;
            width: 100%;
            height: 44px;
            border: 1px solid lightgray;
            box-shadow: 0px 3px 3px #d3d3d378;
            background-color:#fff;
            color:#000;
        }
        .loginPopupBox .loginBtn12{
            margin:0 auto;
        }
        .loginPopupBox .loginBtn12 input#btnLogin {
            width: 130px;
            font-size: 18px;
            background-color: #0c65e7;
            color: #fff;
            margin: 0 auto;
            box-shadow: none;
            border: none;
        }
        div#layersDataid {
            width: 300px;
        }
        span.nav-item label {
            margin-left: 10px;
        }
          .infoPopupBox {
                position: fixed;
                top: 50%;
                left: 15%;
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
            #map{
                position:relative;
            }
        canvas#forestChart {
            height: 460px !important;
            width: 460px  !important;
            display: block;
            box-sizing: border-box;
        }canvas#forestChart2 {
            height: 460px !important;
            width: 460px  !important;
            display: block;
            box-sizing: border-box;
        }canvas#forestChart3 {
            height: 460px !important;
            width: 460px  !important;
            display: block;
            box-sizing: border-box;
        }
        table tr, th, td {
            border: 1px solid #d1caca;
            padding: 10px;
        }
        .plot-container.plotly {
            overflow: hidden;
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
        .ol-zoom.ol-unselectable.ol-control {
            top: 5px !important;
            display: flex;
        } .ol-zoom.ol-unselectable.ol-control button{
           height:35px !important;
           width:35px !important;
           background-color:white !important;
           color:#000;
           border:1px solid #b3b3b3;
        }
        .ol-full-screen.ol-unselectable.ol-control {
            top: 5px;
        } .ol-full-screen.ol-unselectable.ol-control button{
           height:35px !important;
           width:35px !important;
           background-color:white !important;
           color:#000;
           border:1px solid #b3b3b3;
        }
        .ol-scale-line-inner {
            width: 94px;
            padding: 5px;
            background-color: white;
            color: black;
        }
        .ol-attribution.ol-unselectable.ol-control.ol-collapsed {
            display: none;
        }
        .layersDataHead {
            border-bottom: 1px solid #bbbbbb;
            display: flex;
            align-items: center;
            color: white;
            background-color: #818181;
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
   /* content: '\25B6';*/ /* ▶ Right arrow */
      position: absolute;
      right: 20px;
      transition: transform 0.3s ease;
    }

    .accordion-button.active::after {
      transform: rotate(0deg); /* ▼ Down arrow */
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
  </head>
  <body>
      
      <form id="form2" runat="server">
          
          <asp:ScriptManager runat="server" ></asp:ScriptManager>
    <header id="header">
        <div class="container-fluid">
           <div class="headAssets">
                <div class="logo">
                    <a href="index.aspx"><img src="../images/uttrakhand_logo.jpg" alt="logo picture"></a>
                </div>
                <div class="ministryLogo">
                    <div class="l_1">
                        <a href="https://moef.gov.in/" target="_blank"><img src="../images/Ministry-of-Environment.jpg" alt="picture"></a>
                    </div>
                    <div class="l_2">
                        <a href="https://www.giz.de/de/html/index.html" target="_blank"><img src="../images/gizLogo.png" alt="giz logo picture"></a>
                    </div>
                </div>
           </div>
        </div>
    </header>

    <!-- modules-->
     <!-- banner section -->
     <section class="modules section-services">
        <div class="container-fluid">
             <div class="row">
                <div class="col-lg-3 col-md-3 col-sm-12 col-12">
                    <div class="sideBarAssets">
                            <!-- <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1767557.6243518726!2d77.98928082152143!3d30.086711017743053!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3909dcc202279c09%3A0x7c43b63689cc005!2sUttarakhand!5e0!3m2!1sen!2sin!4v1743761057506!5m2!1sen!2sin" width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe> -->
                            <div id="map">

                            
                                 <div id="div" class="infoPopupBox">
            <img src="../GIS/img/close.png" class="closebtns" style="float: right; width: 22px" title="Close" alt="X" onclick="closeclick();" />
            <div id="infodiv">
            </div>
        </div>
                                  <div class="mapFeatureData">
                            <div class="layersData" id="layersDataid" style="display: none;">
                                <div class="layersDataHead" style="border-bottom:1px solid #bbbbbb">
                                    <div style="text-align: center; width: 95%;padding:0">
                                        <h3 style="font-weight: 700; font-size: 25px; margin-top: 5px;">Layers</h3>
                                    </div>
                                    <div id="divcloselayersDataid" style="width: 10%; text-align: center;">
                                        <span style="padding: 4px; background-color: red;cursor: pointer;" onclick="fun_layer()">X</span>
                                    </div>
                                </div>
                                                              
  <div class="accordion">

    <!-- Group 1 -->
    <div class="accordion-item">
      <button type="button" class="accordion-button" onclick="toggleAccordion(this)">State Administrative Boundary</button>
      <div class="accordion-content">
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

                                       
              </ul>
          </div>
      </div>
    </div>

    <!-- Group 2 -->
    <div class="accordion-item">
      <button type="button" class="accordion-button" onclick="toggleAccordion(this)">Forest Administrative Boundary</button>
      <div class="accordion-content open">
          <div style="padding:10px">
              <ul>
                <li >
                                            <asp:CheckBox ID="zone" runat="server" onclick='sfdzone(this);' Text="Zone " class="nav-item" />

                                            <span id='div_zone' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_zone_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="circle" runat="server" onclick='sfdcircle(this);' Text="Circle " class="nav-item" />

                                            <span id='div_circle' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_circle_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="division" runat="server" onclick='sfddivision(this);' Text="Division " class="nav-item" />

                                            <span id='div_division' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_division_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li><li >
                                            <asp:CheckBox ID="range" runat="server" onclick='range_fun(this);' Text="Range" class="nav-item" />

                                            <span id='div_range' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_range_areas&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                        
                                       
              </ul>

          </div>
      </div>
    </div>

    <!-- Group 3 -->
    <div class="accordion-item">
      <button type="button" class="accordion-button" onclick="toggleAccordion(this)">Forest Area Info</button>
      <div class="accordion-content open">
          <div style="padding:10px">
              <ul>
                           <li >
                                            <asp:CheckBox ID="cd_forest" runat="server" onclick='forest_fun(this);' Text="Forest Area" class="nav-item" />

                                            <span id='div_forest' style='display: none'>
                                                <img src="http://180.151.15.18:9007/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_forest_data_final&Format=image/gif&scale=800000&Transparent=true" />
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

































                                 
                            </div>

                        </div>
                                <style>
                                    .iconsrow1 {
                                        position: absolute;
                                        z-index: 1;
                                        left: 87px;
                                        height: 40px;
                                        display: none;
                                        width: calc(100% - 150px);
                                        justify-content: space-between;
                                        align-items: center;
                                        top:8px
                                    }
                                    div#mapfeatures div img {
                                        height: 35px;
                                        width: 35px;
                                        border:1px solid #b3b3b3;
                                    }


                                    .iconsrow2 {
                                        position: relative;
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
                                            border-radius: 0;
                                        }

                                    .iconsrow3 {
                                        flex-direction: row;
                                        display: flex;
                                        position: relative;
                                        z-index: 1;
                                        bottom: 70px;
                                        right: 10px;
                                        gap: 5px;
                                    }

                                        .iconsrow3 img {
                                            height: 40px;
                                            width: 40px;
                                            padding: 7px;
                                            background-color: white;
                                            border-radius: 0;
                                        }

                                    .iconsrow2 .left-icons, .iconsrow2 .right-icons {
                                        display: flex;
                                        flex-direction: column;
                                        gap: 5px;
                                    }

                                    .iconsrow1 div img {
                                        height: 40px;
                                        background-color: white;
                                        padding: 7px;
                                        border: 1px solid #e7e7e7;
                                        border-radius: 0;
                                    }

                                    .mapFeatureData {
                                        position: absolute;
                                        z-index: 1;
                                        background-color: white;
                                        left: 10px;
                                        top: 60px;
                                        height: 430px;
                                        max-height: 430px !important;
                                        overflow: auto;
                                    }

                                    @media (min-width: 1000px) {
                                         .iconsrow1 {
                                            display:flex;
                                        }
                                    }       
                                     .iconenable {
            background: #c932ff !important;
            background-color: #5d9500 !important;
        }

                                </style>
                        <div class="iconsrow1 gettitle" id="mapfeatures" style="display:none">
                            <div class="left-icons">
                                
                              
                                <img class="tool-btn" src="../GIS/img/map_icons/hand.png" title="Pen" alt="Start/Stop Toggle" id="toggleImage" />
                               
                                <img class="tool-btn" src="../GIS/img/map_icons/info.png" title="Information" id="info" onclick="setselectedinfo();" /> 
                                <img src="../GIS/img/map_icons/layer.png" title="Layers" id="imgidlayer" onclick="fun_layer()" />
                            </div>
                            <div class="right-icons">
                              
                              <%--  <img src="img/map_icons/scalability.png" title="Scalability" />--%>
                            </div>
                        </div>

                     <%--   <div class="iconsrow2 gettitle">
                            <div class="left-icons">
                                 
                                <img class="tool-btn" src="../GIS/img/map_icons/clear_all.png" id="clearAllBtn" title="Clear All"  />
                                <img class="tool-btn" src="../GIS/img/map_icons/measure.png" id="measureLine"  title="Measure Line"  />
                                <img class="tool-btn" src="../GIS/img/map_icons/major_area.png" id="measureArea"  title="Measure Area" />
                                <img class="tool-btn" src="../GIS/img/map_icons/data-searching.png" id="querybuilder" title="Query Builder" />
                                <img class="tool-btn" src="../GIS/img/map_icons/buffer.png" title="Buffer" />
                                <img class="tool-btn" src="../GIS/img/map_icons/overlay-analysis.png" title="Overley Analysis" />
                                <img class="tool-btn" src="../GIS/img/map_icons/draw-features.png" title="Draw Feature" />
                                <img class="tool-btn" src="../GIS/img/map_icons/redo.png" title="Redo" id="redoBtn" />
                                <img class="tool-btn" src="../GIS/img/map_icons/undo.png" id="undoBtn" title="Undo"  />
                            </div>

                        </div>
                        <div class="iconsrow3 gettitle">
                            <div class="right-icons" style="flex-direction: row;">
                                <img class="tool-btn" src="../GIS/img/map_icons/export.png" title="Export"id="download-btn" />
                                <img class="tool-btn" src="../GIS/img/map_icons/printer.png" title="Print" />
                            </div>
                        </div>--%>











                            </div>




                        







                         

















                           <%-- <script>
                                // bind open layer map @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

                                var map = new ol.Map({
                                    target: 'map',
                                    controls: ol.control.defaults().extend([
                                        new ol.control.FullScreen(),
                                        new ol.control.ScaleLine()
                                    ]),
                                    layers: [
                                        new ol.layer.Tile({
                                            source: new ol.source.OSM()forest
                                        })
                                    ],
                                    view: new ol.View({
                                        center: ol.proj.fromLonLat([79.0193, 30.0668]), // Longitude, Latitude
                                        zoom: 8
                                    })
                                });
                            </script>--%>
                    </div>
                </div>
                <div class="col-lg-9 col-md-9 col-sm-12 col-12">
                    <div class="row">
                        <div class="flip-container">
                            <div class="clearfix">
                                <div class="flip-box alternative">
                                    <div class="object">
                                            <div class="front">
                                                <div class="flip-content">
                                                    <div class="front-box box1">
                                                            <div class="iconPic iconBorder"><img src="../images/modules/color-icon/dss.png" alt=""></div>
                                                            <h3>Decision Support System (DSS)</h3>
                                                             <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                                <span class="material-icons-sharp">
                                                                east</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        <div class="back flip-back1">
                                            <div class="back-opacity">
                                                <div class="flip-content">
                                                    <div class="back-box box2">
                                                       <a href="../Forest/dashboard.aspx">
                                                        <ul class="flip_List">
                                                            <li>GIS Map Viewer</li>
                                                            <li>User Management</li>
                                                            <li>Data Feed Management</li>
                                                            <li>Reports & Statistics</li>
                                                        </ul>
                                                         <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                            <span class="material-icons-sharp">
                                                            east</span></a>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                                <div class="flank"></div>
                                        </div>
                                    </div>
                                </div><!-- /.flip-box -->
                        
                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box2">
                                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/sfm.png" alt=""></div>
                                                <h3>Scientific Forest Management</h3>
                                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                    <span class="material-icons-sharp">
                                                    east</span></a>
                                            </div>
                                        </div>
                                    </div>
                                        <div class="back flip-back2">
                                            <div class="back-opacity">
                                                <div class="flip-content">
                                                    <div class="back-box box2">
                                                    <a href="../Forest/dashboard.aspx"> 
                                                        <ul class="flip_List">
                                                            <li>Forest Fire Management</li>
                                                            <li>Forest Asset Management</li>
                                                            <li>Reports & Statistics</li>
                                                        </ul>
                                                       <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                        <span class="material-icons-sharp">
                                                        east</span></a>
                                                    </a>
                                                    </div>
                                                </div>
                                            </div>
                                        <div class="flank"></div>
                                        </div>
                                    </div>
                                </div><!-- /.flip-box -->
                        
                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box3">
                                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/pm_icon.png" alt=""></div>
                                                <h3>Patrolling & Monitoring</h3>
                                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                    <span class="material-icons-sharp">
                                                    east</span></a>
                                            </div>
                                        </div>
                                    </div>
                                        <div class="back flip-back3">
                                            <div class="back-opacity">
                                                <div class="flip-content">
                                                    <div class="back-box box3">
                                                     <a href="../Forest/dashboard.aspx">
                                                        <ul class="flip_List">
                                                            <li>Team Patrolling Monitoring</li>
                                                            <li>Incidence Reporting </li>
                                                            <li>Forest Offence Reporting</li>
                                                            <li>Forest Inspections</li>
                                                            <li>Reports & Statistics</li>
                                                        </ul>
                                                       <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                        <span class="material-icons-sharp">
                                                        east</span></a>
                                                    </a>
                                                    </div>
                                                </div>
                                            </div>
                                        <div class="flank"></div>
                                        </div>
                                    </div>
                                </div><!-- /.flip-box -->
                        
                                <div class="flip-box alternative me-0">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/HWC.png" alt=""></div>
                                                <h3>Human Wildlife Conflict</h3>
                                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                    <span class="material-icons-sharp">
                                                    east</span></a>
                                            </div>
                                        </div>
                                    </div>
                                        <div class="back flip-back4">
                                            <div class="back-opacity">
                                                <div class="flip-content">
                                                    <div class="back-box box4">
                                                        <a href="../Forest/dashboard.aspx">
                                                        <ul class="flip_List">
                                                            <li>Human & Wildlife Conflict Reporting</li>
                                                            <li>Online Citizen Compensation</li>
                                                            <li>Online DBT Facility</li>
                                                            <li>Reports & Statistics</li>
                                                        </ul>
                                                    <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                        <span class="material-icons-sharp">
                                                        east</span></a>
                                                    </a>
                                                    </div>
                                                </div>
                                            </div>
                                        <div class="flank"></div>
                                        </div>
                                    </div>
                                </div><!-- /.flip-box -->

                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/sp_icon.png" alt=""></div>
                                                <h3>Schemes & Programs</h3>
                                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                    <span class="material-icons-sharp">
                                                    east</span></a>
                                            </div>
                                        </div>
                                    </div>
                                        <div class="back flip-back4">
                                            <div class="back-opacity">
                                                <div class="flip-content">
                                                    <div class="back-box box4">
                                                        <a href="../Forest/dashboard.aspx">
                                                        <ul class="flip_List">
                                                            <li>Scheme Specific Data Sheet</li>
                                                            <li>Dynamic Feeding of Data Sheet</li>
                                                            <li>Map Visualization of Schemes</li>
                                                            <li>Monitoring and Reporting</li>
                                                        </ul>
                                                    <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                        <span class="material-icons-sharp">
                                                        east</span></a>
                                                    </a>
                                                    </div>
                                                </div>
                                            </div>
                                        <div class="flank"></div>
                                        </div>
                                    </div>
                                </div><!-- /.flip-box -->


                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/vl_icon.png" alt=""></div>
                                                <h3>Vigilance and Legal</h3>
                                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                    <span class="material-icons-sharp">
                                                    east</span></a>
                                            </div>
                                        </div>
                                    </div>
                                        <div class="back flip-back4">
                                            <div class="back-opacity">
                                                <div class="flip-content">
                                                    <div class="back-box box4">
                                                        <a href="../Forest/dashboard.aspx">
                                                        <ul class="flip_List">
                                                            <li>Monitoring and Tracking of Legal Cases</li>
                                                            <li>Cataloging and Document Management System</li>
                                                            <li>Reports & Statistics</li>
                                                        </ul>
                                                    <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                        <span class="material-icons-sharp">
                                                        east</span></a>
                                                    </a>
                                                    </div>
                                                </div>
                                            </div>
                                        <div class="flank"></div>
                                        </div>
                                    </div>
                                </div><!-- /.flip-box -->


                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/Rm_icon.png" alt=""></div>
                                                <h3>Reports & MIS</h3>
                                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                    <span class="material-icons-sharp">
                                                    east</span></a>
                                            </div>
                                        </div>
                                    </div>
                                        <div class="back flip-back4">
                                            <div class="back-opacity">
                                                <div class="flip-content">
                                                    <div class="back-box box4">
                                                        <a href="../Forest/dashboard.aspx">
                                                        <ul class="flip_List">
                                                            <li>Custom Report Generation</li>
                                                            <li>Alert Dessimination</li>
                                                            <li>Import/Export</li>
                                                            <li>Reports & Statistics</li>
                                                        </ul>
                                                    <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                        <span class="material-icons-sharp">
                                                        east</span></a>
                                                    </a>
                                                    </div>
                                                </div>
                                            </div>
                                        <div class="flank"></div>
                                        </div>
                                    </div>
                                </div><!-- /.flip-box -->


                                <div class="flip-box alternative me-0">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/tw_icon.png" alt=""></div>
                                                <h3>Training & Workshops</h3>
                                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                    <span class="material-icons-sharp">
                                                    east</span></a>
                                            </div>
                                        </div>
                                    </div>
                                        <div class="back flip-back4">
                                            <div class="back-opacity">
                                                <div class="flip-content">
                                                    <div class="back-box box4">
                                                        <a href="../Forest/dashboard.aspx">
                                                        <ul class="flip_List">
                                                            <li>Training manuals</li>
                                                            <li>User Manuals</li>
                                                        </ul>
                                                    <a href="../Forest/dashboard.aspx" class="clickBtn">
                                                        <span class="material-icons-sharp">
                                                        east</span></a>
                                                    </a>
                                                    </div>
                                                </div>
                                            </div>
                                        <div class="flank"></div>
                                        </div>
                                    </div>
                                </div><!-- /.flip-box -->

                            </div>
                        </div>



                     </div> 
                </div>


                    <!-- Login Modal -->
                <div id="form1" class="loginPopupBox" runat="server">
                    <div id="loginModal" class="modal" style="display: none;">
                        <div class="modal-content">
                            <span class="close">&times;</span>
                            <h2>Login</h2>

                            <div class="f_group">
                                <label for="ddlRole">Select Role:</label><br />
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                                    <asp:ListItem Text="-- Select Role --" Value="" />
                                </asp:DropDownList>
                            </div>

                            <div class="f_group">
                                <label for="txtUsername">UserId:</label><br />
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
                            </div>

                            <div class="f_group">
                                <label for="txtPassword">Password:</label><br />
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />
                            </div>
                            
                            <div class="loginBtn12">
                            <asp:Button ID="btnLogin" runat="server" CssClass="loginBtn btn btn-primary" Text="Login" OnClick="btnLogin_Click"/>
                            </div>
                        </div>
                    </div>
               

                <!-- /.Login Modal -->


             </div>
        </div>
     </section>

<!-- ===== filter section desing ====== -->
          <asp:UpdatePanel runat="server">
              <ContentTemplate>

             
<section class="filterSection">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="filterContent">
                   <div class="GroupList">
                     <label for="">Year</label>
                      <%--  <select name="" id="">
                            <option value="">2020</option>
                            <option value="">2021</option>
                            <option value="">2022</option>
                            <option value="">2023</option>
                            <option value="">2024</option>
                        </select>--%>
                       <asp:DropDownList runat="server" ID="ddlyear" OnSelectedIndexChanged="ddlyear_SelectedIndexChanged" AutoPostBack="true">
                           
                       </asp:DropDownList>
                   </div>
                   <div class="GroupList">
                    <label for="">Zone</label>
                      
                       <asp:DropDownList runat="server" ID="ddlzone" OnSelectedIndexChanged="ddlzone_SelectedIndexChanged"  AutoPostBack="true">
                           
                       </asp:DropDownList>
                  </div>
                  <div class="GroupList">
                    <label for="">Circles</label>
                     <%--  <select name="" id="">
                           <option value="">North Kumaun</option>
                           <option value="">South Kumaun</option>
                           <option value="">Western</option>
                       </select>--%>
                       <asp:DropDownList runat="server" ID="ddlcircle" OnSelectedIndexChanged="ddlcircle_SelectedIndexChanged" AutoPostBack="true">
                          
                       </asp:DropDownList>
                  </div>
                   <div class="GroupList">
                    <label for="">Division</label>
                      <%-- <select name="" id="">
                           <option value="">Almora Forest Division</option>
                           <option value="">Bageshwar  Forest Division</option>
                           <option value="">Champawat Forest Division</option>
                           <option value="">CS Almora Forest Division</option>
                           <option value="">Pithoragarh Forest Division</option>
                       </select>--%>
                        <asp:DropDownList runat="server" ID="ddldivision" OnSelectedIndexChanged="ddldivision_SelectedIndexChanged" AutoPostBack="true">
                          
                       </asp:DropDownList>
                  </div>
                  <div class="GroupList">
                    <label for="">Action</label>
                     <%--  <select name="" id="">
                           <option value="">Forest Fire</option>
                           <option value="">Human Wildlife Conflict</option>
                           <option value="">Livestock Pressur</option>
                       </select>--%>
                       <asp:DropDownList runat="server" ID="ddlaction" OnSelectedIndexChanged="ddlaction_CallingDataMethods" AutoPostBack="true" onchange="applyfilter()">
                           
                           <asp:ListItem>Fire Points</asp:ListItem>
                           <asp:ListItem>Forest Area</asp:ListItem>
                           <asp:ListItem>Forest Density</asp:ListItem>
                            
                       </asp:DropDownList>
                  </div>
                </div>
            </div>




        </div>
    </div>
</section>
                   </ContentTemplate>
          </asp:UpdatePanel>
                  

                     
          <section class="chartColumns">
              <div class="container-fluid">
                  <div class="row">
                      <style>
                          .mapsContents {
                              position: absolute;
                              background: #ffffff40;
                              bottom: 0px;
                              right: 0px;
                              height: 100%;
                              width: 35%;
                              padding: 10px;
                              z-index:1;
                          }
                          .table-content{
                              position: absolute;
                              z-index: 1;
                              bottom: 2px;
                              left: 2px;
                              background-color: white;
                          }
                      </style>
                        <div id="mapfilter" style="height:600px;position: relative;padding:0" >
                              <asp:UpdatePanel runat="server">
                              <ContentTemplate>
                            <div class="table-content">
                                <asp:GridView runat="server" ID="grd_area" AutoGenerateColumns="true"></asp:GridView>
                            </div>
                                  </ContentTemplate></asp:UpdatePanel>
                            <div class="mapsContents">
                                <div>
                                     <div id="chartpie1" style="display:none" ></div>
                                   
                                      <div id="mydivbar" style="width:700px;height:580px;"></div>


                                </div>
                                
                            </div>
                          </div>

                  </div>
                
            
          </section>
              <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>           

  <script>
      document.addEventListener('DOMContentLoaded', function () {
          const modal = document.getElementById("loginModal");
          const closeBtn = modal.querySelector(".close");
          const flipLinks = document.querySelectorAll(".flip-box a");

          // Show modal on flip box link click
          flipLinks.forEach(link => {
              link.addEventListener("click", function (e) {
                  e.preventDefault();
                  modal.style.display = "flex";  // Show the modal
                  modal.classList.add("show");  // Add the 'show' class to trigger visibility (based on CSS)
              });
          });

          // Close modal logic
          closeBtn.addEventListener("click", () => {
              modal.style.display = "none"; // Hide the modal when close button is clicked
              modal.classList.remove("show"); // Optionally remove the 'show' class to hide
          });

          // Close modal if clicking outside of the modal content
          window.addEventListener("click", (e) => {
              if (e.target === modal) {
                  modal.style.display = "none"; // Hide the modal if the user clicks outside
                  modal.classList.remove("show"); // Optionally remove the 'show' class to hide
              }
          });
      });
  </script>
          
   
          <script>
              /*let asdf = document.getElementsByClassName("ol-full-screen-false");
              let addC = document.getElementsByClassName("iconsrow1");
             
              asdf.addEventListener("click", function () {
                  alert("jdlsjfla");
              })
               */

          </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
          	<script src='https://cdn.plot.ly/plotly-3.0.1.min.js'></script>
  <%--  <script src="js/script.js"></script>--%>
          <script src="../GIS/js/jquery.min.js"></script>
           <script src="js/mapfilter.js"></script>
      <script src="js/modules.js"></script>
         

 
          
  <script>
     


  </script>
               
            
  <script>
      const labels = ['One', 'Two', 'Three', 'Four'];

      const gharwal = [6.54048, 765.491904, 2166.476544, 986.958144];
      const kumau = [334.812672, 3259.11744, 5719.04064, 2064.415104];
      const windlife = [72.173952, 2502.807552, 4851.165888, 1987.458048];

      const totals = gharwal.map((_, i) => gharwal[i] + kumau[i] + windlife[i]);

      const formatHover = (value, total) => {
          const percent = (value / total * 100).toFixed(1);
          return `${value.toFixed(2)} (${percent}%)`;
      };

      const hoverGharwal = gharwal.map((v, i) => formatHover(v, totals[i]));
      const hoverKumau = kumau.map((v, i) => formatHover(v, totals[i]));
      const hoverWindlife = windlife.map((v, i) => formatHover(v, totals[i]));

      const trace1 = {
          x: labels,
          y: gharwal,
          name: 'Gharwal',
          type: 'bar',
          text: gharwal.map(v => v.toFixed(2)),
          textposition: 'outside',
          customdata: hoverGharwal,
          marker: { color: 'rgba(255, 99, 132, 0.6)' },
          hovertemplate: '%{customdata}<extra></extra>'
      };

      const trace2 = {
          x: labels,
          y: kumau,
          name: 'Kumau',
          type: 'bar',
          text: kumau.map(v => v.toFixed(2)),
          textposition: 'outside',
          customdata: hoverKumau,
          marker: { color: 'rgba(54, 162, 235, 0.6)' },
          hovertemplate: '%{customdata}<extra></extra>'
      };

      const trace3 = {
          x: labels,
          y: windlife,
          name: 'Windlife',
          type: 'bar',
          text: windlife.map(v => v.toFixed(2)),
          textposition: 'outside',
          customdata: hoverWindlife,
          marker: { color: 'rgba(75, 192, 192, 0.6)' },
          hovertemplate: '%{customdata}<extra></extra>'
      };

      const data = [trace1, trace2, trace3];

      var layout = {
          height: 600,
          paper_bgcolor: 'rgba(0,0,0,0)',   // Transparent outer background
          plot_bgcolor: 'rgba(0,0,0,0)',    // Transparent plot area
          legend: {
              orientation: 'h',
              y: 1.1,
              x: 0.5,
              xanchor: 'center',
              font: {
                  family: 'Arial Black',
                  size: 14,
                  color: 'white'          // Legend text color white
              }
          },
          xaxis: {
              tickfont: {
                  color: 'white'          // X-axis labels in white
              }
          },
          yaxis: {
              tickfont: {
                  color: 'white'          // Y-axis labels in white
              }
          },
          margin: { t: 60 }
      };

      Plotly.newPlot('mydivbar', data, layout);
  </script>
        </form>
  </body>
</html>

