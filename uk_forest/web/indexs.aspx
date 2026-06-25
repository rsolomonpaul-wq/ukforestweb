<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="indexs.aspx.cs" Inherits="uk_forest.web.indexs" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>FMIS</title>
    <!-- App favicon -->
    <link rel="shortcut icon" href="../admin/assets/images/favicon.png" />
    <%--<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous" />--%>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" />
    <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css" />
    <%--<script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>--%>
   

    <link href="https://fonts.googleapis.com/css2?family=Host+Grotesk:ital,wght@0,300..800;1,300..800&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="./admin/assets/css/icons.min.css" />
    <link rel="stylesheet" href="css/style.css" />

         <style>
        body {
            font-family: "Host Grotesk", sans-serif !important;
            overflow: hidden !important;
        }

        .signup-button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #28a745 0%, #5cb85c 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 8px rgba(40,167,69,0.2);
        }

            .signup-button:hover {
                /* Add hover effects if desired */
            }

        .front-box .iconPic.iconBorder {
            width: 60px;
            height: 60px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            position: relative;
            border: 2px solid transparent;
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
            background: rgb(0 0 0 / 82%);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: #fff;
            color: #000;
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

        .loginPopupBox .modal-content: {
            position: relative;
        }

        .loginPopupBox .modal-content .close {
            position: absolute;
            top: -20px;
            right: -20px;
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
            text-align: center;
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
            background-color: #fff;
            color: #000;
        }

        .loginPopupBox .modal-content input {
            display: inline-block;
            width: 100%;
            height: 44px;
            border: 1px solid lightgray;
            box-shadow: 0px 3px 3px #d3d3d378;
            background-color: #fff;
            color: #000;
        }

        .loginPopupBox .loginBtn12 {
            margin: 0 auto;
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

        #map {
            position: relative;
        }

        canvas#forestChart {
            height: 460px !important;
            width: 460px !important;
            display: block;
            box-sizing: border-box;
        }

        canvas#forestChart2 {
            height: 460px !important;
            width: 460px !important;
            display: block;
            box-sizing: border-box;
        }

        canvas#forestChart3 {
            height: 460px !important;
            width: 460px !important;
            display: block;
            box-sizing: border-box;
        }

        table tr, th, td {
            border: 1px solid #d1caca !important;
            padding: 10px;
        }

        .plot-container.plotly {
            overflow: hidden;
        }

        table {
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
        }

            .ol-zoom.ol-unselectable.ol-control button {
                height: 35px !important;
                width: 35px !important;
                background-color: white !important;
                color: #000;
                border: 1px solid #b3b3b3;
            }

        .ol-full-screen.ol-unselectable.ol-control {
            top: 5px;
            display: none;
        }

            .ol-full-screen.ol-unselectable.ol-control button {
                height: 35px !important;
                width: 35px !important;
                background-color: white !important;
                color: #000;
                border: 1px solid #b3b3b3;
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
    <style>
        .mapsContents {
            position: absolute;
            top: 0;
            background: #ffffff;
            right: 0px;
            z-index: 1;
            height: calc(100vh - 200px);
            margin: 2px;
        }

        /*.table-content {
              position: absolute;
              z-index: 1;
              bottom: 2px;
              left: 2px;
              background-color: white;
              padding: 5px;
          }*/

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
    </style>
    <style>
        #areatable div {
            width: 100%;
            border-radius: 8px;
        }

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
            height: 30px !important;
            align-items: center;
            display: flex !important;
            background-color: #206da5;
            color: #fff !important;
            margin-top: 25px;
            font-size: 16px !important;
            padding: 0 10px !important;
            border-radius: 3px;
        }

        .arrow {
            display: inline-block;
            margin-left: 8px;
            transition: transform 0.3s ease;
            transform: rotate(90deg);
        }

        .rotate {
            transform: rotate(0deg);
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
                display: none
            }

        #filter-container.hidden {
            max-height: 0;
            opacity: 0;
            display: none
        }

        #layerlegends.hidden {
            max-height: 0;
            opacity: 0;
            display: none
        }

        #chart-container.hidden {
            max-height: 0;
            opacity: 0;
            display: none
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
            width: 50%;
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
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 9px;
            color: #2d2d2d;
        }

            .portal-header h2 {
                font-size: 30px;
                font-weight: 700;
                padding: 0 15px;
                margin-bottom: 0;
            }

            .portal-header .highlight {
                color: #ffffff;
                font-weight: 900;
                background-color: green;
                padding: 0px 5px;
            }


        .navbar {
            background-color: #e4f3ff;
            overflow: hidden;
            padding: 0 !important;
            justify-content: center !important;
        }

            .navbar a {
                display: inline-block;
                color: #373737;
                text-align: center;
                padding: 10px 20px;
                font-size: 16px;
                border-right: 1px solid #d9eaf9;
                font-size: 20px;
                font-weight: 400;
            }

                .navbar a:hover {
                    background-color: #ddd;
                }

                .navbar a.active {
                    background-color: #4CAF50; /* Highlighted green */
                    color: white;
                }
    </style>
    <style>
        .toggle-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .switch {
            position: relative;
            display: inline-block;
            width: 32px;
            height: 22px;
        }

            .switch input {
                opacity: 0;
                width: 3rem;
                height: 1.5rem;
            }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
            height: 18px;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 14px;
                width: 14px;
                left: 2px;
                bottom: 2px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
            }

        .switch input:checked + .slider {
            background-color: #2196F3;
            height: 18px;
        }


            .switch input:checked + .slider:before {
                transform: translateX(14px);
            }

        #controls_degradation {
            position: absolute;
            top: 10px;
            left: 10px;
            background: white;
            padding: 10px;
            z-index: 1000;
            border: 1px solid #ccc;
            max-height: 90%;
            overflow-y: auto;
        }

        .switch-group_degradation {
            margin-top: 10px;
        }

        .switch-label_degradation {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }

        .switch_degradation {
            position: relative;
            display: inline-block;
            width: 32px;
            height: 18px;
            margin-right: 10px;
        }

            .switch_degradation input {
                opacity: 0;
                width: 0;
                height: 0;
            }

        .slider_degradation {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.4s;
            border-radius: 34px;
        }

            .slider_degradation:before {
                position: absolute;
                content: "";
                height: 14px;
                width: 14px;
                left: 2px;
                bottom: 2px;
                background-color: white;
                transition: 0.4s;
                border-radius: 50%;
            }

        .switch_degradation input:checked + .slider_degradation {
            background-color: #2196F3;
        }

            .switch_degradation input:checked + .slider_degradation:before {
                transform: translateX(14px);
            }

        .color-name_degradation {
            font-size: 14px;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .form-check-input.custom-switch {
            width: 32px;
            height: 18px;
        }

            .form-check-input.custom-switch:checked {
                background-color: #0d6efd;
            }

        .form-check-label {
            font-size: 1.1rem;
            margin-left: 0.5rem;
        }

        ul {
            list-style: none;
            padding-left: 0;
        }

        li {
            margin-bottom: 10px;
        }

        input {
            border: 1px solid #959595;
        }

        .switch-group {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            gap: 2px;
        }

        table tr th {
            background-color: #00ffdc;
            white-space: nowrap !important;
        }

        tr:first-child th {
            position: sticky;
            top: -5px;
            background: #163245;
            z-index: 2;
            color: #ffffff;
            font-weight: 400;
        }

        .firecompchart {
            position: fixed;
            z-index: 1;
            bottom: 0px;
            left: 10.8%;
            width: 52%;
            background-color: white;
            padding: 5px;
            display: block;
            height: 250px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        #chart-containerchart {
            width: 100%;
            height: 270px;
        }

            #chart-containerchart canvas {
                display: block;
                width: 100%;
                height: 100%;
            }

        .table-container {
            width: 100%;
            overflow: auto;
        }

        .layerForestBox {
            position: absolute;
            z-index: 1;
            bottom: 0;
            left: 0px;
            background-color: #ffffff9e;
            margin: 2px;
            padding: 10px 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            font-size: 14px;
            box-sizing: border-box;
            overflow: auto;
            width: 13.5%;
        }

        span.highlyDeg {
            font-size: 1.1rem;
            margin-left: 0.5rem;
        }

        .legendContents h6 {
            margin-bottom: 0;
            padding: 3px 0;
            font-size: 1rem;
            font-weight: normal;
        }

        .legendColor {
            width: 15px;
            height: 14px;
            display: inline-block;
        }

            .legendColor.color_1 {
                background-color: #ffc928;
            }

            .legendColor.color_2 {
                background-color: #18c784;
            }

            .legendColor.color_3 {
                background-color: #03ad0c;
            }

            .legendColor.color_4 {
                background-color: #2f7d32;
            }

            .legendColor.color_5 {
                background-color: #fe0000;
            }


            /*======= Land Degradation colors ======== */

            .legendColor.landColor1 {
                background-color: #ffff01;
            }

            .legendColor.landColor2 {
                background-color: #00ff01;
            }

            .legendColor.landColor3 {
                background-color: #01ffff;
            }

            .legendColor.landColor4 {
                background-color: #b88246;
            }

            .legendColor.landColor5 {
                background-color: #b32d45;
            }

            .legendColor.landColor6 {
                background-color: #fe0000;
            }

            .legendColor.landColor7 {
                background-color: #0000fe;
            }


        /*======== Table heading title ==========*/

        .tableHeadingTitle h4 {
            margin-top: 10px;
            font-size: 20px;
            position: relative;
            letter-spacing: 0.2px;
        }
        /*.tableHeadingTitle h4::before{
    position:absolute;
    bottom:5px;;
    left:135px;
    width:40px;
    height:1px;
    background-color:#206da5;
    content:'';
}
.tableHeadingTitle h4::after{
    position:absolute;
    bottom:9px;;
    left:145px;
    width:40px;
    height:1px; 
    background-color:#006f2e;
    content:'';
}*/
        select#layer-select {
            word-wrap: normal;
            width: 100%;
            border-radius: 3px;
            border: 0;
            font-size: 15px;
        }





        .topChartBox {
            overflow: hidden;
            width: 100% !important;
        }

        #barChart {
            width: 100% !important;
            height: 100% !important;
        }

        div#areatable {
            height: 47vh !important;
        }

        .table-container {
            overflow: auto;
            height: 80% !important;
        }


        /*===== Responsive Design ========*/

        @media(min-width:1401px){
            .portal-header {
                font-size: 26px;
            }

            .logo img {
                width: 200px;
            }

            .l_1 img {
                width: 130px;
            }

            .l_2 img {
                width: 170px;
            }

            .layerForestBox {
                height: 220px;
            }

            .dropdown-header {
                margin-top: 5px !important;
            }
        }



        @media (min-width:1201px) and (max-width:1366px) {
            .navbar a {
                padding: 8px 20px;
                font-size: 16px;
            }

            .portal-header {
                font-size: 20px;
            }

                .portal-header h2 {
                    font-size: 24px;
                    font-weight: 800;
                }

            .logo img {
                width: 210px;
            }

            .l_1 img {
                width: 140px;
            }

            .l_2 img {
                width: 190px;
            }

            .recap4NDCLogo {
                width: 55px !important;
            }

            .layerForestBox {
                height: 178px;
            }

            .dropdown-header {
                margin-top: 3px !important;
            }

            .legendContents h6 {
                font-size: 16px;
            }

            .dropdown-header {
                height: 40px;
            }

            table tr th {
                font-size: 14px;
            }

            table td {
                border: 1px solid #ccc;
                padding: 5px;
                text-align: left;
                font-size: 12px;
            }

            #mapfilter {
                height: calc(100vh - 132px) !important;
            }

            .mapsContents {
                height: calc(100vh - 132px);
            }

            .topChartBox {
                overflow: hidden;
                width: 100% !important;
                height: 30vh !important;
            }

            #barChart {
                width: 100% !important;
                height: 100% !important;
            }

            div#areatable {
                height: 36vh !important;
            }
        }




        @media(min-width:992px) and (max-width:1200px) {
            .navbar a {
                padding: 8px 16px;
                font-size: 16px;
            }

            .portal-header {
                font-size: 20px;
            }

            .logo img {
                width: 210px;
            }

            .l_1 img {
                width: 140px;
            }

            .l_2 img {
                width: 190px;
            }

            .recap4NDCLogo {
                width: 55px !important;
            }

            .layerForestBox {
                height: 220px;
            }
        }
    </style>

    <style>
        table {
            text-transform: capitalize !important;
            cursor: pointer;
        }

        td {
            text-transform: capitalize !important;
        }

        th, td {
            border: 1px solid #ccc;
        }

        th {
            font-weight: bold;
            background-color: #222; /* Dark header background */
            color: white; /* White text in header */
            cursor: pointer;
            position: relative;
            user-select: none;
        }

            th:hover {
                background-color: #444; /* Slightly lighter on hover */
            }

            /* Always show sorting arrows (up/down gray arrows) */
            th::after {
                content: '';
                position: absolute;
                right: 10px;
                border: 6px solid transparent;
                top: 50%;
                transform: translateY(-50%);
                border-top-color: white;
                border-bottom-color: white;
                opacity: 0.7;
            }

            /* Show white arrow depending on sort direction */
            th.sort-asc::after {
                border-top-color: transparent;
                border-bottom-color: white;
                opacity: 1;
            }

            th.sort-desc::after {
                border-top-color: white;
                border-bottom-color: transparent;
                opacity: 1;
            }
        /*
    tr:nth-child(even) td {
      background-color: #f9f9f9;
    }*/
    </style>
    <style>
        .bottom-panel {
            position: absolute;
            bottom: 0;
            left: 43%;
            height: 350px;
            transform: translate(-50%, 100%);
            width: 775px;
            max-height: 350px;
            background-color: rgba(255, 255, 255, 0.95);
            border-top: 2px solid #ccc;
            box-shadow: 0 -2px 6px rgba(0,0,0,0.2);
            overflow: hidden;
            transition: transform 0.4s ease-in-out;
            z-index: 1000;
            padding: 15px;
            box-sizing: border-box;
            border-radius: 8px 8px 0 0;
        }

            .bottom-panel.show {
                transform: translate(-50%, 0%);
            }

        /* Arrow Toggle Button */
        .toggle-btn {
            position: absolute;
            bottom: 10px;
            left: 43%;
            transform: translateX(-50%);
            z-index: 1001;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 6px 10px;
            border-radius: 50%;
            font-size: 18px;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
            width: 36px;
            height: 36px;
            text-align: center;
            line-height: 24px;
        }

        .toggle-btn:hover {
            background-color: #0056b3;
        }

        #myChart {
            height: 100% !important;
            width: 100% !important;
        }

        .layerForestBoxtest {
            height: 50px !important;
            /*transition: height .1s linear .1s;*/
        }

        footer.FooterColumn1 {
            padding:0;
            text-align: center;
            background-color: #ffffff;
            color: #000000;
        }
        footer.FooterColumn1 .footerContt {
            display: flex;
            align-items: center;
            justify-content:space-between;
            padding:0 30px;
        }
        footer.FooterColumn1 .f_logo1 img {
            width: 225px;
        }
        footer.FooterColumn1 .f_logo2 img {
            width: 225px;
        }
        footer.FooterColumn1 .f_logo3 img {
            width: 225px;
        }
        hr {
  margin: 0;
}
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager runat="server"></asp:ScriptManager>
            <header id="header">
                <div class="container-fluid m-0">
                    <div class="headAssets">
                        <div class="logo">
                            <a href="indexs.aspx">
                                <img src="../images/uttrakhand_logo.jpg" alt="logo picture" /></a>
                        </div>
                        <div class="portal-header">
                            <div class="icon" aria-hidden="true"></div>
                            <h2>Forest Management Information System</h2>
                        </div>
                        <div class="ministryLogo">
                            <div class="l_1">
                                <a href="https://moef.gov.in/" target="_blank">
                                    <img src="../images/Ministry-of-Environment.jpg" alt="picture" /></a>
                            </div>
                            <!-- <div class="l_2">
                                <a href="https://www.giz.de/de/html/index.html" target="_blank">
                                    <img src="../images/gizLogo.png" alt="giz logo" /></a>
                            </div> -->
                            <div class="l_2">
                                <a href="#!" target="_blank">
                                    <img src="../images/recap4NDC.png" class="recap4NDCLogo" style="width: 50px; padding: 5px 0;" alt="recap4NDC" /></a>
                            </div>
                        </div>
                    </div>
                </div>
            </header>



            <div class="navbar">
                <%-- <a href="#">Login</a>--%>
                <div>
                    <a href="https://forest.uk.gov.in/fmis">Home</a>
                    <a href="aboutus.aspx">About</a>
                    <a href="modules.aspx">Decision Support System</a>

                    <!-- Registration Link -->

                    <%--<a href="javascript:void(0);" onclick="window.location.href='../Forest/applicantlogin.aspx'">Login (HWC)
                    </a>--%>

                    <a href="javascript:void(0);" onclick="window.location.href='../Forest/applicantlogin.aspx'">Applicant Login (HWC)
                    </a>



                </div>
            </div>


            <section>
                <div class="container-fluid mt-0 mb-0">
                    <div class="row">

                        <div id="mapfilter" style="height: calc(100vh - 200px); width: calc(100% - 5px); position: relative; padding: 0; top: -5px">
                            <div style="position: absolute; z-index: 1; display: flex; background-color: #206da5; padding: 3px; color: #fff; width: 13.5%">
                                <div style="white-space: nowrap">
                                    <asp:Label Text="Backdrop :" runat="server" />
                                </div>
                                <div style="width:100%">
                                    <select id="layer-select">
                                        <option value="bright" selected>Open Street Map  </option>
                                        <option value="esriLayer">Satellite</option>
                                      <%--  <option value="jawg">Terrain</option>--%>
                                      <%--  <option value="nulls">Null</option>--%>
                                    </select>
                                </div>
                            </div>

                            <%-- <div style="font-weight: bold; font-size: 16px; margin-bottom: 0; cursor: pointer; display: flex; justify-content: space-between; align-items: center;" onclick="togglefilter()">
                                          Filter 
       
                                          <span class="arrow" id="arrowfilter" style="transition: transform 0.3s;">&#9654;</span>
                                      </div>--%>
                            <div class="layerForestBox" id="layersdiv">
                                <div style="font-weight: bold; font-size: 16px; margin-bottom: 0; cursor: pointer; display: flex; justify-content: space-between; align-items: center;" onclick="togglelayers()">
                                    <asp:Label Text="Layers" runat="server" />
                                    <span class="arrow" id="arrowlayers" style="transition: transform 0.3s;">&#9654;</span>
                                </div>
                                <div id="layerlegends">
                                    <div id="legendfirepoint" style="display: none;">
                                        <span>Fire Alerts (Source : <span title="Forest Survey of India">FSI</span>)</span>
                                        <span style="display: inline-block; width: 15px; height: 15px; background-color: #E6521F; border-radius: 50%; margin-right: 8px; vertical-align: middle; box-shadow: 0 0 5px #e6e600;"></span>
                                    </div>
                                    <div id="legendforestarea" style="display: none;">
                                        <div>
                                            <span>Forest Area (Source : <span title="State Forest Department">SFD</span>)</span>
                                        </div>

                                        <div style="display: flex; justify-content: center; align-items: center;">

                                            <div id="controlsforestarea">
                                                <div class="switch-group">

                                                    <%--<label class="switch">
                                                              <input type="checkbox" name="resurved forest" checked="checked"  onclick="bindresurvedforest(this)"/>
                                                              <span class="slider"></span>
                                                          </label>--%>
                                                    <%--
                                                          <label class="switch">
                                                              <input type="checkbox" name="open forest"  onclick="bindnonforest(this)"/>
                                                              <span class="slider"></span>
                                                          </label>
                                                    --%>
                                                </div>

                                            </div>
                                            <div>
                                                <%-- <img src="img/icons/density.jpg"/>--%>
                                            </div>
                                        </div>

                                    </div>
                                    <div id="legendforestdensity" style="display: none;">
                                        <div><span style="font-size: 15px; margin-bottom: 5px; display: inline-block;">Forest Density (Source : <span title="Forest Survey of India">FSI</span>)</span></div>
                                        <div style="display: flex; gap: 5px; align-items: center;">

                                            <div id="controls">
                                                <div class="switch-group">

                                                    <label class="switch">
                                                        <input type="checkbox" name="scrub" data-value="3" checked />
                                                        <span class="slider"></span>
                                                    </label>

                                                    <label class="switch">
                                                        <input type="checkbox" name="open forest" data-value="4" checked />
                                                        <span class="slider"></span>
                                                    </label>

                                                    <label class="switch">
                                                        <input type="checkbox" name="moderately dense" data-value="5" checked />
                                                        <span class="slider"></span>
                                                    </label>

                                                    <label class="switch">
                                                        <input type="checkbox" name="very dense" data-value="6" checked />
                                                        <span class="slider"></span>
                                                    </label>

                                                </div>

                                            </div>
                                            <div class="legendContents">
                                                <h6>Scrub : <span class="legendColor color_1"></span></h6>
                                                <h6 title="Open Forest">OF :  <span class="legendColor color_2"></span></h6>
                                                <h6 title="Moderately Dense Forest">MDF :  <span class="legendColor color_3"></span></h6>
                                                <h6 title="Very Dense Forest">VDF : <span class="legendColor color_4"></span></h6>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="legenddegradation" style="display: none; display: flex; justify-content: center; align-items: center;">
                                        <%-- <span style="display: inline-block; width: 12px; height: 12px; background-color: #ffaa00; margin-right: 5px; border: 1px solid #ccc;"></span>
                                          Land Degradation--%>
                                        <div><span style="font-size: 15px; margin-bottom: 5px; display: inline-block;">Land Degradation (Source : <span title="Space Applications Centre">SAC</span>)</span></div>
                                        <div style="display: flex; justify-content: left; align-items: center;">
                                            <div class="switch-group_degradation">

                                                <label class="switch-label_degradation">
                                                    <label class="switch_degradation">
                                                        <input type="checkbox" data-value="1" checked onchange="initializeSwitchListeners()" />
                                                        <span class="slider_degradation"></span>
                                                    </label>
                                                    <%-- <span class="color-name_degradation">Sv2</span>--%>
                                                </label>

                                                <label class="switch-label_degradation">
                                                    <label class="switch_degradation">
                                                        <input type="checkbox" data-value="2" checked onchange="initializeSwitchListeners()" />
                                                        <span class="slider_degradation"></span>
                                                    </label>
                                                    <%--  <span class="color-name_degradation">Fv1</span>--%>
                                                </label>

                                                <label class="switch-label_degradation">
                                                    <label class="switch_degradation">
                                                        <input type="checkbox" data-value="3" checked onchange="initializeSwitchListeners()" />
                                                        <span class="slider_degradation"></span>
                                                    </label>
                                                    <%-- <span class="color-name_degradation">Dw1</span>--%>
                                                </label>

                                                <label class="switch-label_degradation">
                                                    <label class="switch_degradation">
                                                        <input type="checkbox" data-value="5" checked onchange="initializeSwitchListeners()" />
                                                        <span class="slider_degradation"></span>
                                                    </label>
                                                    <%--  <span class="color-name_degradation">Sv1</span>--%>
                                                </label>

                                                <label class="switch-label_degradation">
                                                    <label class="switch_degradation">
                                                        <input type="checkbox" data-value="6" checked onchange="initializeSwitchListeners()" />
                                                        <span class="slider_degradation"></span>
                                                    </label>
                                                    <%-- <span class="color-name_degradation">Lf2</span>--%>
                                                </label>

                                                <label class="switch-label_degradation">
                                                    <label class="switch_degradation">
                                                        <input type="checkbox" data-value="7" checked onchange="initializeSwitchListeners()" />
                                                        <span class="slider_degradation"></span>
                                                    </label>
                                                    <%-- <span class="color-name_degradation">S</span>--%>
                                                </label>

                                                <label class="switch-label_degradation">
                                                    <label class="switch_degradation">
                                                        <input type="checkbox" data-value="8" checked onchange="initializeSwitchListeners()" />
                                                        <span class="slider_degradation"></span>
                                                    </label>
                                                    <%--  <span class="color-name_degradation">W</span>--%>
                                                </label>

                                            </div>
                                            <div class="legendContents">
                                                <h6 title="Agriculture unirrigated, water erosion, Low">Dw1 : <span class="legendColor landColor1"></span></h6>
                                                <h6 title="Forest, vegetation degradation, Low">Fv1 :  <span class="legendColor landColor2"></span></h6>
                                                <h6 title="Periglacial, frost shattering, High">Lf2 :  <span class="legendColor landColor3"></span></h6>
                                                <h6 title="Settlement">S : <span class="legendColor landColor4"></span></h6>
                                                <h6 title="Land with scrub, vegetation degradation, Low">Sv1 : <span class="legendColor landColor5"></span></h6>
                                                <h6 title="Land with scrub, vegetation degradation, High">Sv2 : <span class="legendColor landColor6"></span></h6>
                                                <h6 title="Water body/ Drainage">W : <span class="legendColor landColor7"></span></h6>
                                            </div>
                                        </div>
                                    </div>
                                    <hr />
                                    <div style="padding: 10px 0px">
                                        <ul>

                                            <li style="display: flex; margin-bottom: 0;">
                                                <div>
                                                    <label class="switch">
                                                        <input id="treecoverloss" type="checkbox" name="very dense" onchange="callTreeCoverLoss(this)" />
                                                        <span class="slider"></span>
                                                    </label>
                                                </div>
                                                 
                                                <span class="highlyDeg" title="Highly Degraded Area">Sv2: (Source : <span title="Space Applications Centre">SAC</span>) <span class="legendColor color_5"></span></span>
                                                
                                            </li>
                                             <hr />

                                            <li class="form-check form-switch">
                                                <input class="form-check-input custom-switch" type="checkbox" id="zone" onclick="sfdzone(this)" checked="checked" />
                                                <label class="form-check-label" for="zone">Zone</label>
                                                <span id="div_zone" style="display: none"></span>
                                            </li>
                                            <li class="form-check form-switch">
                                                <input class="form-check-input custom-switch" type="checkbox" id="circle" onclick="sfdcircle(this)" />
                                                <label class="form-check-label" for="circle">Circle</label>
                                                <span id="div_circle" style="display: none"></span>
                                            </li>
                                            <li class="form-check form-switch">
                                                <input class="form-check-input custom-switch" type="checkbox" id="division" onclick="sfddivision(this)" />
                                                <label class="form-check-label" for="division">Division</label>
                                                <span id="div_division" style="display: none"></span>
                                            </li>
                                            <li class="form-check form-switch">
                                                <input class="form-check-input custom-switch" type="checkbox" id="range" onclick="range_fun(this)" />
                                                <label class="form-check-label" for="range">Range</label>
                                                <span id="div_range" style="display: none"></span>
                                            </li>

                                            <li class="form-check form-switch">
                                                <input class="form-check-input custom-switch" type="checkbox" id="beat" onclick="beat_fun(this)" />
                                                <label class="form-check-label" for="beat">Beat</label>
                                                <span id="div_beat" style="display: none"></span>
                                            </li>
                                            <li class="form-check form-switch">
                                                <span id="div_density" style="display: none"></span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>





                            <asp:UpdatePanel runat="server">
                                <ContentTemplate>



                                    <div style="position: absolute; z-index: 1; background-color: #ffffff9e; padding: 10px; width: 13.5%; max-width: 350px; margin: 30px 0 0 3px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">


                                        <div style="font-weight: bold; font-size: 16px; margin-bottom: 0; cursor: pointer; display: flex; justify-content: space-between; align-items: center;" onclick="togglefilter()">
                                            Filter 
       
                                          <span class="arrow" id="arrowfilter" style="transition: transform 0.3s;">&#9654;</span>
                                        </div>

                                        <div id="filter-container" style="display: block;">
                                            <!-- Row 1 -->

                                            <div style="display: flex; gap: 10px; margin-bottom: 5px;">
                                                <div style="flex: 1;">
                                                    <label style="display: block; font-size: 13px; margin-bottom: 3px;">Year</label>
                                                    <asp:DropDownList runat="server" ID="ddlyear" OnSelectedIndexChanged="ddlyear_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                                </div>
                                                <div style="flex: 1;">
                                                    <label style="display: block; font-size: 13px; margin-bottom: 3px;">Zone</label>
                                                    <asp:DropDownList runat="server" ID="ddlzone" OnSelectedIndexChanged="ddlzone_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                                </div>
                                            </div>

                                            <!-- Row 2 -->
                                            <div style="display: flex; gap: 10px; margin-bottom: 5px;">
                                                <div style="flex: 1;">
                                                    <label style="display: block; font-size: 13px; margin-bottom: 3px;">Circles</label>
                                                    <asp:DropDownList runat="server" ID="ddlcircle" OnSelectedIndexChanged="ddlcircle_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                                </div>
                                                <div style="flex: 1;">
                                                    <label style="display: block; font-size: 13px; margin-bottom: 3px;">Division</label>
                                                    <asp:DropDownList runat="server" ID="ddldivision" OnSelectedIndexChanged="ddldivision_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                                </div>
                                            </div>



                                            <!-- Row 3 -->
                                            <div style="display: flex; gap: 10px; margin-bottom: 5px;">

                                                <div style="flex: 1;">
                                                    <label style="display: block; font-size: 13px; margin-bottom: 3px;">Range</label>
                                                    <asp:DropDownList runat="server" ID="ddlrange" OnSelectedIndexChanged="ddlrange_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                                </div>

                                                <div style="flex: 1;">
                                                    <label style="display: block; font-size: 13px; margin-bottom: 3px;">Beat</label>
                                                    <asp:DropDownList runat="server" ID="ddlbeat" OnSelectedIndexChanged="ddlbeat_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
                                                </div>

                                            </div>


                                            <%--Row 4--%>

                                            <div style="display: flex; gap: 10px; margin-bottom: 5px;">
                                                <div style="flex: 1;">
                                                    <label style="display: block; font-size: 13px; margin-bottom: 3px;">Action</label>
                                                    <asp:DropDownList runat="server" ID="ddlaction" OnSelectedIndexChanged="ddlaction_CallingDataMethods" AutoPostBack="true" onchange="applyfilter()" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;">
                                                        <asp:ListItem>Forest Density</asp:ListItem>
                                                        <asp:ListItem>Fire Alerts</asp:ListItem>
                                                        <asp:ListItem>Forest Area</asp:ListItem>

                                                        <asp:ListItem>Land Degradation</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="position: absolute; z-index: 2; right: 16px; top: 3px; width: auto; max-width: 90%; padding: 7px 15px; background-color: #ffffff; cursor: pointer; margin: 0px; font-size: 15px; display: flex; align-items: center; gap: 6px; border: none;">
                                        <asp:Button runat="server" ID="btndownloadexcel" Style="display: none" OnClick="btndownloadexcel_Click" />
                                        <span style="font-weight: 900;" title="Download excel" onclick="downloadexcel('grd_area', 'inventory_data')">&#128190;</span>
                                        <span style="font-weight: bold;">:</span>
                                        <span onclick="downloadChartAsJPG()" style="font-weight: 900;" title="Download Graph">&#11015;</span>
                                         <span style="font-weight: bold;">:</span>
                                        <span onclick="downloadMapAsJPG()" style="font-weight: 900;" title="Download Map">⬇️</span>
                                        <span style="font-weight: bold;">:</span>
                                        <span onclick="callexpend()" title="Expend">&#11034;</span>
                                        <span style="font-weight: bold;">:</span>
                                        <span class="arrow" id="arrowchart" style="transition: transform 0.3s;" onclick="togglechart()" title="Toggle">&#9654;</span>
                                    </div>

                                    <div id="chart-container" class="mapsContents" style="width: 36.5%; padding: 10px 7px; background-color: #ffffff9e; border: 1px solid #ddd; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.08); max-width: 100%; overflow-x: hidden;">

                                        <div style="display: flex; flex-direction: column; gap: 20px;">

                                            <!-- Pie Chart -->
                                            <div id="chartpie1" style="display: none; width: 100%; min-height: 300px; border: 1px solid #eee; border-radius: 8px; padding: 10px; background-color: black"></div>
                                            <div class="topChartBox">
                                                <canvas id="barChart"></canvas>
                                            </div>
                                            <!-- Bar Chart -->
                                            <div id="mydivbar" style="width: 100%; min-height: 300px; border: 1px solid #eee; border-radius: 8px; padding: 10px; display: none"></div>

                                        </div>
                                        <div class="tableHeadingTitle">
                                            <h4><span id="mastertabletitle"></span>:</h4>
                                        </div>
                                        <div class="table-content" runat="server" id="areatable" style="display: none; width: 100%; bottom: 0px !important">
                                            <div class="table-container">
                                                <asp:GridView runat="server" ID="grd_area" AutoGenerateColumns="true"></asp:GridView>
                                            </div>

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
                                                    <span><b>Sv2</b> :  Land with scrub, vegetation degradation, High</span><br />
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
                                                <span>All numeric values(in table) are in Sq Km</span>
                                            </div>



                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <div>

                                <div class="bottom-panel" id="infoPanel">
                                    <div>
                                        <div style="width: 100%; position: absolute; bottom: 0px; padding: 0px 10px;">
                                            <canvas id="myChart"></canvas>
                                        </div>

                                    </div>

                                </div>
                                <button id="toggleBtn" type="button" class="toggle-btn" style="display: none;">▼</button>
                            </div>
                        </div>

                    </div>





                    <!-- Modal Popup -->
                    <div id="registrationModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); z-index: 9999; backdrop-filter: blur(5px);">
                        <div style="position: relative; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 380px; background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%); border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); overflow: hidden; animation: modalFadeIn 0.4s ease-out;">
                            <!-- Close Button -->
                            <button type="button" onclick="hideModal()" style="position: absolute; top: 12px; right: 12px; background: none; border: none; font-size: 25px; color: #000; cursor: pointer; font-weight: bold;">&times;</button>

                            <!-- Header -->
                            <div style="background: linear-gradient(135deg, #007bff 0%, #00a8ff 100%); padding: 20px; text-align: center;">
                                <h3 style="margin: 0; color: white; font-weight: 600; font-size: 1.5rem;">Applicant Registration</h3>
                            </div>

                            <!-- Toggle Buttons with active indicator -->
                            <div style="display: flex; border-bottom: 1px solid #e0e0e0; position: relative;">
                                <button
                                    type="button"
                                    id="btnLoginTab"
                                    style="flex: 1; padding: 15px; background: white; color: #007bff; border: none; font-weight: 600; cursor: pointer; border-bottom: 3px solid #007bff;">
                                    Login
                                </button>
                                <div style="width: 1px; background: #e0e0e0; margin: 8px 0;"></div>
                                <button
                                    type="button"
                                    id="btnSignupTab"
                                    style="flex: 1; padding: 15px; background: white; color: #666; border: none; font-weight: 600; cursor: pointer; border-bottom: 3px solid transparent;">
                                    Sign Up
                                </button>
                            </div>

                            <!-- Login Section -->
                            <div id="loginSection" style="padding: 25px;">
                                <div style="margin-bottom: 20px;">
                                    <asp:Label ID="lbl_login_mobile" runat="server" Text="Mobile Number" Style="display: block; margin-bottom: 5px; color: #495057; font-weight: 500;"></asp:Label>
                                    <asp:TextBox ID="txt_login_mobile" runat="server" placeholder="Enter 10-digit number" MaxLength="10" Style="width: 100%; padding: 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 1rem; transition: border-color 0.3s;"></asp:TextBox>
                                </div>

                                <div style="margin-bottom: 25px;">
                                    <asp:Label ID="lbl_login_password" runat="server" Text="Password" Style="display: block; margin-bottom: 5px; color: #495057; font-weight: 500;"></asp:Label>
                                    <asp:TextBox ID="txt_login_password" runat="server" TextMode="Password" placeholder="Enter your password" Style="width: 100%; padding: 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 1rem;"></asp:TextBox>
                                </div>

                                <asp:Button ID="btnClientLogin" runat="server" Text="Submit" CssClass="btn btn-success rounded" Style="width: 100%; padding: 12px; background: linear-gradient(135deg, #007bff 0%, #00a8ff 100%); color: white; border: none; border-radius: 6px; font-weight: 600; font-size: 1rem; cursor: pointer; transition: all 0.3s; box-shadow: 0 4px 8px rgba(0,120,255,0.2);" OnClick="btnClientLogin_Click" />
                            </div>

                            <!-- Signup Section -->
                            <div id="signupSection" style="display: none; padding: 25px;">
                                <div style="margin-bottom: 20px;">
                                    <asp:Label ID="lbl_signup_name" runat="server" Text="Full Name" Style="display: block; margin-bottom: 5px; color: #495057; font-weight: 500;"></asp:Label>
                                    <asp:TextBox ID="txt_name" runat="server" placeholder="Enter your name" Style="width: 100%; padding: 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 1rem;"></asp:TextBox>
                                </div>

                                <div style="margin-bottom: 25px;">
                                    <asp:Label ID="lbl_signup_mobile" runat="server" Text="Mobile Number" Style="display: block; margin-bottom: 5px; color: #495057; font-weight: 500;"></asp:Label>
                                    <asp:TextBox ID="txt_mobile_number" runat="server" placeholder="Enter 10-digit number" MaxLength="10" Style="width: 100%; padding: 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 1rem;"></asp:TextBox>
                                </div>

                                <asp:Button ID="btnClientSignup" runat="server" Text="Create Account" OnClick="btnClientSignup_Click" CssClass="signup-button" />

                                <div style="text-align: center; margin-top: 20px; font-size: 0.9rem; color: #6c757d;">
                                    By registering, you agree to our <a href="#" style="color: #007bff; text-decoration: none;">Terms</a> and <a href="#" style="color: #007bff; text-decoration: none;">Privacy Policy</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Overlay Background -->
                    <div id="modalOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9998;"></div>


                   


                </div>
            </section>

            <footer class="FooterColumn1">
                <div class="footerContt">
                    <div class="f_logo1"><a href="#!"><img src="../admin/assets/images/federal_logo.jpg" alt="footer logo" /></a></div>
                    <div class="f_logo2"><a href="#!"><img src="../admin/assets/images/iki_logo.jpg" alt="giz logo" /></a></div>
                    <div class="f_logo3"><a href="#!"><img src="../admin/assets/images/giz_logo.jpg" /></a></div>
                </div>  
            </footer>
            <%--  <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>           --%>


            <%--          <script type="text/javascript">
              function storeinfo() {
                  //alert('1');
                  debugger;
                  const Username = document.getElementById('<%= txtUsername.ClientID %>').value;
            const useragent = navigator.userAgent;
            var apiBaseUrl = '<%= System.Configuration.ConfigurationManager.AppSettings["api_path"] %>';

                  var apiUrl = apiBaseUrl + 'TblUserActivities/PostTblUserActivity';

                  const activityData = {
                      UserId: Username,
                      UserAgent: useragent
                  };

                  fetch(apiUrl, {
                      method: 'POST',
                      headers: {
                          'Content-Type': 'application/json'
                      },
                      body: JSON.stringify(activityData)
                  }).then(response => {
                      if (!response.ok) {
                          console.error("Failed to store user activity");
                      } else {
                          console.log("User activity stored successfully.");
                      }
                  }).catch(error => {
                      console.error("Error in storeinfo:", error);
                  });

                  return true; // Allow button click to proceed
              }
          </script>--%>

            <script>
      //document.addEventListener('DOMContentLoaded', function () {
      //    const modal = document.getElementById("loginModal");
      //    const closeBtn = modal.querySelector(".close");
      //    const flipLinks = document.querySelectorAll(".flip-box a");

      //    // Show modal on flip box link click
      //    flipLinks.forEach(link => {
      //        link.addEventListener("click", function (e) {
      //            e.preventDefault();
      //            modal.style.display = "flex";  // Show the modal
      //            modal.classList.add("show");  // Add the 'show' class to trigger visibility (based on CSS)
      //        });
      //    });

      //    // Close modal logic
      //    closeBtn.addEventListener("click", () => {
      //        modal.style.display = "none"; // Hide the modal when close button is clicked
      //        modal.classList.remove("show"); // Optionally remove the 'show' class to hide
      //    });

      //    // Close modal if clicking outside of the modal content
      //    window.addEventListener("click", (e) => {
      //        if (e.target === modal) {
      //            modal.style.display = "none"; // Hide the modal if the user clicks outside
      //            modal.classList.remove("show"); // Optionally remove the 'show' class to hide
      //        }
      //    });
      //});
            </script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
             <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
            <script src="https://cdn.sheetjs.com/xlsx-0.20.1/package/dist/xlsx.full.min.js"></script>

            <%--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>--%>
            <%--	<script src='https://cdn.plot.ly/plotly-3.0.1.min.js'></script>--%>
            <%--  <script src="js/script.js"></script>--%>
            <script src="../GIS/js/jquery.min.js"></script>
            <script src="js/mapfilter.js"></script>
            <%--  <script src="js/modules.js"></script>--%>




            <script>

</script>

            <script type="text/javascript">
                function showLogin() {
                    document.getElementById('loginSection').style.display = 'block';
                    document.getElementById('signupSection').style.display = 'none';
                    document.getElementById('btnLoginTab').style.color = '#007bff';
                    document.getElementById('btnLoginTab').style.borderBottom = '3px solid #007bff';
                    document.getElementById('btnSignupTab').style.color = '#666';
                    document.getElementById('btnSignupTab').style.borderBottom = '3px solid transparent';
                    return false;
                }

                function showSignup() {
                    document.getElementById('loginSection').style.display = 'none';
                    document.getElementById('signupSection').style.display = 'block';
                    document.getElementById('btnLoginTab').style.color = '#666';
                    document.getElementById('btnLoginTab').style.borderBottom = '3px solid transparent';
                    document.getElementById('btnSignupTab').style.color = '#007bff';
                    document.getElementById('btnSignupTab').style.borderBottom = '3px solid #007bff';
                    return false;
                }

                function hideModal() {
                    document.getElementById('registrationModal').style.display = 'none';
                    return false;
                }

                // Initialize with Login tab active
                showLogin();

                document.getElementById('btnLoginTab').addEventListener('click', function (e) {
                    e.preventDefault();
                    showLogin();
                });

                document.getElementById('btnSignupTab').addEventListener('click', function (e) {
                    e.preventDefault();
                    showSignup();
                });
            </script>

            <%--<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>--%>
            <asp:Button ID="btn_login" runat="server" Text="Login" Style="display: none;" />
            <asp:Button ID="btn_signup" runat="server" Text="Register" Style="display: none;" />
            <script src="../GIS/js/jquery.min.js"></script>
            <script src="js/mapfilter.js"></script>

            <script type="text/javascript">
                function showModal() {
                    document.getElementById("registrationModal").style.display = "block";
                    document.getElementById("modalOverlay").style.display = "block";
                }

                function hideModal() {
                    document.getElementById("registrationModal").style.display = "none";
                    document.getElementById("modalOverlay").style.display = "none";
                }
            </script>

            <script>
                // Run only when DOM is fully loaded
                document.addEventListener('DOMContentLoaded', function () {
                    const btn = document.getElementById('barChart');
                    btn.removeAttribute('style');


                });

                document.addEventListener('DOMContentLoaded', function () {

                    const btn1 = document.getElementById('myChart');
                    btn1.removeAttribute('style');

                });
            </script>
        </div>
    </form>
</body>
</html>
