<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="wlc.aspx.cs" Inherits="uk_forest.DSS.wlc" ClientIDMode="Static" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link rel="shortcut icon" href="../admin/assets/images/favicon.png" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" />
    <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css" />
    <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>
    <link rel="stylesheet" href="./admin/assets/css/icons.min.css" />
   
    <link href="../web/css/style.css" rel="stylesheet" />
     <%-- <style>
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
            display: none;
            
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
    </style>--%>
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
      <style>
          .mapsContents {
              position: absolute;
              background: #ffffff;
              right: 0px;
              z-index: 1;
             height: 98%;margin:2px
          }

          .table-content {
              position: absolute;
              z-index: 1;
              bottom: 2px;
              left: 2px;
              background-color: white;
              padding: 5px;
          }

              .table-content div {
                  width: 680px;
              }


          /* Column-wise background using nth-child */
          /*  td:nth-child(2), th:nth-child(2) {
      background: linear-gradient(to bottom right, #f0b27a, #e59866);
      color: #000;
    }
    td:nth-child(3), th:nth-child(3) {
      background: linear-gradient(to bottom right, #abebc6, #82e0aa);
      color: #000;
    }
    td:nth-child(4), th:nth-child(4) {
      background: linear-gradient(to bottom right, #fad7a0, #f5b041);
      color: #000;
    }
    td:nth-child(5), th:nth-child(5) {
      background: linear-gradient(to bottom right, #f5b7b1, #ec7063);
      color: #000;
    }*/
        table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
         
      </style>
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
              top: 8px
          }

          div#mapfeatures div img {
              height: 35px;
              width: 35px;
              border: 1px solid #b3b3b3;
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
                  display: flex;
              }
          }

          .iconenable {
              background: #c932ff !important;
              background-color: #5d9500 !important;
          }
      </style>
      <style>
          .dropdown-header {
              cursor: pointer;
              font-weight: bold;
              display: flex;
              align-items: center;
              user-select: none;
          }

          .arrow {
              display: inline-block;
              margin-left: 8px;
              transition: transform 0.3s ease;
          }

          .rotate {
              transform: rotate(90deg);
          }

          #note-container {
              overflow: hidden;
              max-height: 1000px;
              opacity: 1;
              transition: max-height 0.5s ease, opacity 0.5s ease;
          }

              #note-container.hidden {
                  max-height: 0;
                  opacity: 0;
                  display:none
              }

               #filter-container.hidden {
                  max-height: 0;
                  opacity: 0;
                  display:none
                   
              }
               #chart-container.hidden {
                  max-height: 0;
                  opacity: 0;
                  display:none
                   
              }
          .filter-format {
              display: flex;
              width: 100%;
              border-top: 1px solid #dddddd;
              justify-content: space-between;
              padding: 10px;
          }
          .container-fluid {
              margin: 5px 5px;
              width: calc(100% - 5px);
          }
          .filter-format div {
              width:50%;
          }
          .filter-format div select {
              width: 65%;
          }
      </style>
     <style>
    
    .portal-header {
      padding: 15px 0;
    text-align: center;
    letter-spacing: 1px;
    text-transform: uppercase;
    font-weight: 700;
    font-size: 2rem;
    user-select: none;
    display: flex
;
    justify-content: center;
    align-items: center;
    gap: 9px;
    color: #2d2d2d;
    }
    .portal-header .icon {
      font-size: 2.8rem;
      line-height: 1;
      color: #388e3c; /* forest green */
      text-shadow: 0 0 6px #66bb6a;
      user-select: none;
    }
    .portal-header .highlight {
      color: #ffffff;
    font-weight: 900;
    background-color: green;
    padding: 0px 5px;
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
         <div>
                  <asp:ScriptManager runat="server" ></asp:ScriptManager>
   
                  

                     
          <section >
              <div class="container-fluid">
                  <div class="row">
                     
                        <div id="mapfilter" style="height: calc(100vh - 125px);width: calc(100% - 5px);position: relative;padding:0" >
                              <asp:UpdatePanel runat="server">
                              <ContentTemplate>

                                  <div style="position: fixed; z-index: 11; bottom: 10px; left: 10px; background-color: white; margin: 2px; padding: 10px 15px; border: 1px solid #ccc; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); font-family: Arial, sans-serif; font-size: 14px; max-width: 90%; box-sizing: border-box;">
                                      <div style="font-weight: bold; margin-bottom: 5px;">Layers</div>

                                      <div id="legendfirepoint" style="display:none;">
                                          <span>Fire Points</span>
                                          <span style="display: inline-block; width: 15px; height: 15px; background-color: #f1e336; border-radius: 50%; margin-right: 8px; vertical-align: middle; box-shadow: 0 0 5px #e6e600;"></span>

                                      </div>
                                      <div id="legendforestarea" style="display:none;">
                                          <div>
                                               <span >Forest Area</span>
                                          </div>
                                            <img src="img/icons/forest.png" />
   
                                      </div>
                                      <div id="legendforestdensity" style="display:none;">
                                          <div> <span  >Forest Density</span></div>
                                          <div style="display: flex; justify-content: center; align-items: center;">

<%--                                              <div style="display: flex; flex-direction: column; top: 6px; position: relative;">
                                                  <input type="checkbox" name="name" value="" checked="checked" /><br />
                                                  <input type="checkbox" name="name" value="" checked="checked" /><br />
                                                  <input type="checkbox" name="name" value="" checked="checked" /><br />
                                                  <input type="checkbox" name="name" value="" checked="checked" /><br />
                                              </div>--%>
                                              <style>
    .toggle-group {
      display: flex;
      flex-direction: column;
      gap: 12px;
       
    }

    .switch {
      position: relative;
      display: inline-block;
      width: 50px;
      height: 26px;
    }

    .switch input {
      opacity: 0;
      width: 0;
      height: 0;
    }

    .slider {
      position: absolute;
      cursor: pointer;
      top: 0; left: 0; right: 0; bottom: 0;
      background-color: #ccc;
      transition: .4s;
      border-radius: 34px;
    }

    .slider:before {
      position: absolute;
      content: "";
      height: 20px;
      width: 20px;
      left: 4px;
      bottom: 3px;
      background-color: white;
      transition: .4s;
      border-radius: 50%;
    }

    .switch input:checked + .slider {
      background-color: #2196F3;
    }

    .switch input:checked + .slider:before {
      transform: translateX(24px);
    }
  </style>
                                              <div class="toggle-group">
    <label class="switch">
      <input type="checkbox" checked />
      <span class="slider"></span>
    </label>

    <label class="switch">
      <input type="checkbox" checked />
      <span class="slider"></span>
    </label>

    <label class="switch">
      <input type="checkbox" checked />
      <span class="slider"></span>
    </label>

    <label class="switch">
      <input type="checkbox" checked />
      <span class="slider"></span>
    </label>
  </div>
                                              <div>
                                                  <img src="img/icons/density.png" /></div>
                                          </div>
                                          
                                         
   
                                      </div>
                                      <div  id="legenddegradation" style="display:none;">
                                          <span style="display: inline-block; width: 12px; height: 12px; background-color: #ffaa00; margin-right: 5px; border: 1px solid #ccc;"></span>
                                          Land Degradation
   
                                      </div>
                                  </div>


                                  <div style="position: absolute; z-index: 10; background-color: #fff; padding: 15px; width: 90%; max-width: 350px; margin: 10px; border: 1px solid #ccc; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); font-family: Arial, sans-serif;">
                                      <div style="font-weight: bold; font-size: 16px; margin-bottom: 10px; cursor: pointer; display: flex; justify-content: space-between; align-items: center;" onclick="togglefilter()">
                                          Filter 
       
                                          <span class="arrow" id="arrowfilter" style="transition: transform 0.3s;">&#9654;</span>
                                      </div>

                                      <div id="filter-container" style="display: block;">
                                          <!-- Row 1 -->
                                          <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                                              <div style="flex: 1;">
                                                  <label style="display: block; font-size: 13px; margin-bottom: 3px;">Year</label>
                                                  <asp:DropDownList runat="server" ID="ddlyear" OnSelectedIndexChanged="ddlyear_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 6px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                              </div>
                                              <div style="flex: 1;">
                                                  <label style="display: block; font-size: 13px; margin-bottom: 3px;">Zone</label>
                                                  <asp:DropDownList runat="server" ID="ddlzone" OnSelectedIndexChanged="ddlzone_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 6px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                              </div>
                                          </div>

                                          <!-- Row 2 -->
                                          <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                                              <div style="flex: 1;">
                                                  <label style="display: block; font-size: 13px; margin-bottom: 3px;">Circles</label>
                                                  <asp:DropDownList runat="server" ID="ddlcircle" OnSelectedIndexChanged="ddlcircle_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 6px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                              </div>
                                              <div style="flex: 1;">
                                                  <label style="display: block; font-size: 13px; margin-bottom: 3px;">Division</label>
                                                  <asp:DropDownList runat="server" ID="ddldivision" OnSelectedIndexChanged="ddldivision_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 6px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                              </div>
                                          </div>

                                          <!-- Row 3 -->
                                          <div style="margin-bottom: 5px;">
                                              <label style="display: block; font-size: 13px; margin-bottom: 3px;">Action</label>
                                              <asp:DropDownList runat="server" ID="ddlaction" OnSelectedIndexChanged="ddlaction_CallingDataMethods" AutoPostBack="true" onchange="applyfilter()" Style="width: 100%; padding: 6px; border-radius: 5px; border: 1px solid #ccc;display:none">
                                                  <asp:ListItem>All</asp:ListItem>
                                                  <asp:ListItem>Elephant</asp:ListItem>
                                                  <asp:ListItem>Bear</asp:ListItem>
                                                  <asp:ListItem>Leopard</asp:ListItem>
                                                  <asp:ListItem>Tiger</asp:ListItem>
                                                  <asp:ListItem>Snake</asp:ListItem>
                                                
                                              </asp:DropDownList>

                                              <asp:DropDownList  runat="server" ID="ddl_action" OnSelectedIndexChanged="ddl_action_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 6px; border-radius: 5px; border: 1px solid #ccc;">
                                                     <asp:ListItem>All</asp:ListItem>
                                                  <asp:ListItem>Elephant</asp:ListItem>
                                                  <asp:ListItem>Bear</asp:ListItem>
                                                  <asp:ListItem>Leopard</asp:ListItem>
                                                  <asp:ListItem>Tiger</asp:ListItem>
                                                  <asp:ListItem>Snake</asp:ListItem>
                                              </asp:DropDownList>
                                          </div>
                                      </div>
                                  </div>





                                  <%--  <div style="position: absolute; z-index: 2; right: 0px; width: 500px; padding: 5px;background-color:white;cursor:pointer;margin-right: 2px;margin-top:2px"
                                onclick="togglechart()">
                                    Chart:
                                         <span class="arrow" id="arrowchart">&#9654;</span>
                                </div>--%>
                            <div style="position: absolute; z-index: 2; right: 10px; top: 10px; width: auto; max-width: 90%; padding: 10px 15px; background-color: #ffffff; cursor: pointer; margin: 0px; border: 1px solid #ccc; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); font-family: Arial, sans-serif; font-size: 15px; display: flex; align-items: center; gap: 6px;" onclick="togglechart()">
    <span style="font-weight: bold;">Chart:</span>
    <span class="arrow" id="arrowchart" style="transition: transform 0.3s;">&#9654;</span>
</div>

<%--                            <div class="mapsContents" id="chart-container">
                                
                                <div  >
                                    
                                     <div id="chartpie1" style="display:none" ></div>
                                   
                                      <div id="mydivbar" ></div>


                                </div>
                                
                            </div>--%>
                            <div id="chart-container" class="mapsContents" style="width: 40.5%;margin: 10px; padding: 15px; background-color: #ffffff; border: 1px solid #ddd; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.08); max-width: 100%; overflow-x: auto; font-family: Arial, sans-serif;">

                                <div style="display: flex; flex-direction: column; gap: 20px;">

                                    <!-- Pie Chart -->
                                    <div id="chartpie1" style="display: none; width: 100%; min-height: 300px; border: 1px solid #eee; border-radius: 8px; padding: 10px;background-color:black"></div>

                                    <!-- Bar Chart -->
                                    <div id="mydivbar" style="width: 100%; min-height: 300px; border: 1px solid #eee; border-radius: 8px; padding: 10px;background-color:black"></div>

                                </div>
                                <div class="table-content" runat="server" id="areatable" style="display: none; display: block; height: 550px; overflow-y: auto; border-radius: 25px; border: 1px solid red;">
                                    <asp:GridView runat="server" ID="grd_area" AutoGenerateColumns="true"></asp:GridView>
                                    <%--<span><b>Note</b> :</span>--%>
                                    <div class="dropdown-header" onclick="toggleNotes()">
                                        Note:
                                         <span class="arrow" id="arrow">&#9654;</span>
                                    </div>

                                    <div id="note-container" class="hidden">
                                        <div style="display: none" runat="server" id="headernotaion">

                                            <span><b>Scrub</b> : (Canopy Density < 10 %)</span><br />
                                            <span><b>Open Forest</b> :  (10 % ≤ Canopy Density < 40 %)</span><br />
                                            <span><b>Moderately Dense Forest</b> :  (40 % ≤ Canopy Density < 70 %)</span><br />
                                            <span><b>Very Dense Forest</b> :  (Canopy Density ≥ 70 %)</span><br />
                                        </div>
                                        <div style="display: none" runat="server" id="headernotation_degradation">

                                            <span><b>Dw1</b> : Agriculture unirrigated, water erosion, Low</span><br />
                                            <span><b>Fv1</b> :  Forest, vegetation degradation, Low</span><br />
                                            <span><b>Lf2</b> :  Periglacial, frost shattering, High</span><br />
                                            <span><b>S</b> :  Settlement</span><br />
                                            <span><b>Sv1</b> :  Land with scrub, vegetation degradation, Low</span><br />
                                            <span><b>Sv2</b> :  Land with scrub, vegetation degradation, High</span><br />
                                            <span><b>W</b> : Water body/ Drainage</span><br />
                                        </div>
                                        <span>All numeric values are in count</span>
                                    </div>



                                </div>
                            </div>
                                    </ContentTemplate></asp:UpdatePanel>
                          </div>

                  </div>
                
            
          </section>
              <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>           


          

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
          	<script src='https://cdn.plot.ly/plotly-3.0.1.min.js'></script>
  <%--  <script src="js/script.js"></script>--%>
          <script src="../GIS/js/jquery.min.js"></script>
           <script src="js/mapfilter.js"></script>
 
          
  <script>

  </script>
               
            
   
  
        </div>
</asp:Content>
