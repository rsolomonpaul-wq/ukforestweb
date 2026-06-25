<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="plantation.aspx.cs" Inherits="uk_forest.DSS.plantation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol/ol.css">
    <style>
        .page-content.my-5 .page-container {
            margin-top: 10px;
        }
        .page-content {
            padding: 0 !important;
        }
        .page-container {
            display: block;
            width: 100%;
            padding: 0px !important;
        }
        #plantation-map {
            width: 100%;
            height: calc(100vh - 84px);
            position: relative;
        }
        body {
            overflow: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .ol-zoom.ol-unselectable.ol-control {
            display: none;
        }
    </style>
    <style>
        .tool-panel {
            position: absolute;
            z-index: 1;
            background-color: white;
            padding: 5px;
            width: 100%;
            font-size: 0;
        }

        .tool-panel-left,
        .tool-panel-right {
            display: inline-block;
            width: 50%;
            font-size: 14px;
            vertical-align: top;
            border: 1px solid red;
            padding: 5px;
        }

        .tool-panel-right {
            text-align: right;
        }
        .tool-panel-right img{
            height:25px;
        }

        .iconenable {
            background: #c932ff !important;
            background-color: #5d9500 !important;
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

        .info-table-heading {
            text-align: center;
        }
    </style>
      <style>
   
    /* Semi-transparent overlay with blur effect */
    .popup-overlay {
      position: fixed;
      top: 0; left: 0;
      width: 100vw; height: 100vh;
      background: rgba(33, 50, 90, 0.35);
      backdrop-filter: blur(3px);
      z-index: 999;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.3s;
    }
    .infoPopupBox {
      position: relative;
      width: 410px;
      background: linear-gradient(135deg, #e6ecfa 0%, #fff 100%);
      border: 1.5px solid #dbe9ff;
      border-radius: 18px;
      box-shadow: 0 10px 48px 0 rgba(40, 58, 90, 0.18);
      z-index: 1;
      animation: popupFadeIn 0.7s cubic-bezier(.21,.58,.57,.98) forwards;
    }
    @keyframes popupFadeIn {
      0% { transform: scale(0.94) translateY(40px); opacity: 0; }
      100% { transform: scale(1) translateY(0); opacity: 1; }
    }
          .infoPopupBox img.closebtns {
              position: absolute;
              right: 0px;
              width: 26px;
              height: 23px;
              cursor: pointer;
              transition: transform 0.23s, filter 0.18s;
              filter: grayscale(65%) drop-shadow(0 0 3px #90a4ae);
          }
     
          .info-table-heading {
              background: linear-gradient(90deg, #3777ff 0%, #4A8CF7 100%);
              color: #fff;
              padding: 5px 5px;
              font-size: 15px;
              font-weight: 700;
              border-top-left-radius: 10px;
              border-top-right-radius: 10px;
          }
     
     
    .layer-info-popup table {
      width: 100%;
      border-collapse: separate;
       
      background: transparent;
      white-space: nowrap;
    }
    .layer-info-popup td {
     padding: 5px 6px;
      border-bottom: 1px solid #e4e9f5;
      transition: background 0.16s;
    }
    .layer-info-popup td:first-child {
      font-weight: 600;
      color: #295492;
      letter-spacing: 0.2px;
      width: 50%;
    }
    .layer-info-popup td:last-child {
      color: #526b90;
      width: 50%;
      text-align: right;
      font-weight: 500;
    }
    .layer-info-popup tr:hover {
      background-color: #ebf3ff;
    }
    .scrollable-content {
      max-height: 230px;
      overflow-y: auto;
      margin-top: 7px;
      border-radius: 6px;
      background: #f7fafd;
      box-shadow: 0 2px 10px rgba(90,150,200,0.07);
      transition: box-shadow 0.2s;
      scrollbar-width: thin;
      scrollbar-color: #4A8CF7 #f7fafd;
    }
    .scrollable-content::-webkit-scrollbar {
      width: 7px; background: #f7fafd;
    }
    .scrollable-content::-webkit-scrollbar-thumb {
      background: #90c5ff;
      border-radius: 7px;
    }
    @media (max-width: 600px) {
      .infoPopupBox {
        width: 95vw; min-width: 0; padding: 0;
      }
      .infoPopupBox > div {
        padding: 0 8vw 16px 8vw;
      }
      .info-table-heading {
        padding: 16px 8vw;
        font-size: 17px;
      }
    }

      #chartContainer {
          display:none;
      width:500px;
      bottom: 0px;
      position:absolute;
      z-index:1;
      background-color:white;
    }
       #loader {
      display: none;
      margin-top: 10px;
      text-align: center;
      position:absolute;z-index:1;

    }
       table{display:none !important}
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
        #loader{display: none;}
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
       <%-- <h1>test</h1>--%>
        
          <div id="output" style="display:none"></div>
        <div id="plantation-map">
            <div class="tool-panel">
                <div class="tool-panel-left">
                    asdf
                </div>
                <div class="tool-panel-right">
                    asdfasdfdsf
                      <img class="tool-btn" src="https://www.iconpacks.net/icons/1/free-information-icon-348-thumb.png" title="Information" id="info" onclick="setselectedinfo();"  />
                </div>
            </div>


            <div id="div" class="infoPopupBox">
                <div>
                    <img src="img/close.png" class="closebtns" style="float: right; width: 22px; top: 10px; color: white; border: 1px solid #d00; right: 15px; text-align: center; border-radius: 6px; background: #ff0663; font-weight: 700;"
                        title="Close" alt="X" onclick="closeclick();" />
                </div>
                <div id="infodiv">
                </div>
            </div>

            <div id="chartContainer">
                <canvas id="ndviChart"></canvas>
            </div>

            <div id="loader">
                <img src="https://cdn.pixabay.com/animation/2023/10/08/03/19/03-19-26-213_512.gif" alt="Loading..." style="width:200px" />
            </div>
        </div>
    </div>


    <%--section javascript--%>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
        integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
        crossorigin="anonymous"></script>
      <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const sharedView = new ol.View({
            center: ol.proj.fromLonLat([79.2593, 29.9968]),
            zoom: 8.2
        });

        const map = new ol.Map({
            target: 'plantation-map',
            layers: [new ol.layer.Tile({ source: new ol.source.OSM() })],
            view: sharedView
        });
    </script>
    <script src="plantationjs/layers.js"></script>
    <script src="plantationjs/info.js"></script>
</asp:Content>
