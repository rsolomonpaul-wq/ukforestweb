<%@ Page Title="" Language="C#" MasterPageFile="gis_master.Master" AutoEventWireup="true" CodeBehind="map.aspx.cs" Inherits="uk_forest.GIS.map" ClientIDMode="Static" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css" />
    <script src="https://code.jquery.com/jquery-2.2.0.min.js" type="text/javascript"></script>
    <link href="css/limsMap.css" rel="stylesheet" />
    <style>
        #map {
            height: 100vh;
            width: 100%;
        }

        .tooltip {
            position: absolute;
            background-color: white;
            padding: 5px;
            border-radius: 3px;
            pointer-events: none;
        }

        .tooltip-measure {
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
        }

        .tooltip-static {
           /* background-color: rgba(0, 0, 0, 0.7);
            color: #fff;
            border: 1px solid white;*/
           background-color: rgba(0, 123, 255, 0.8); /* Bootstrap blue */
    color: #fff;
    border: 1px solid #fff;
    padding: 2px 6px;
    border-radius: 3px;
    font-size: 12px;
        }

        .tool-container {
            position: absolute;
            top: 10px;
            left: 10px;
            z-index: 1000;
            display: flex;
            gap: 10px;
            background: rgba(255, 255, 255, 0.9);
            padding: 5px;
            border-radius: 5px;
        }

        .tool-btn {
            width: 40px;
            height: 40px;
            cursor: pointer;
            border: 2px solid transparent;
            border-radius: 5px;
        }

        .tool-btn.active {
            background-color: green;
            border-color: white;
        }

        .clear-btn {
            padding: 5px 10px;
            cursor: pointer;
            font-size: 14px;
            border-radius: 5px;
            border: 1px solid #ccc;
            background-color: #fff;
        }

        .popup {
            position: absolute;
            top: 60px;
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

        .tooltip-measure {
    background-color: white;
    border: 1px solid black;
    padding: 2px 5px;
    border-radius: 3px;
    white-space: nowrap;
    font-size: 12px;
    position: absolute;
}
.tooltip-static {
    background-color: #ffcc33;
}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="tool-container" style="position: absolute;
    z-index: 11111;">
        <img src="https://img.icons8.com/ios-filled/50/ruler.png" id="measureLine" class="tool-btn" title="Measure Line" />
        <button id="clearAllBtn" class="clear-btn">Clear All</button>
    </div>

    <div id="map"></div>
    <div id="popup" class="popup hidden"> </div>
    
    <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>
<script src="js/testgis.js"></script>
    <script>
       
    </script>
</asp:Content>
