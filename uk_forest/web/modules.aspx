<%@ Page  Title="" Language="C#" AutoEventWireup="true" CodeBehind="modules.aspx.cs" Inherits="uk_forest.web.modules" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FMIS</title>
    <!-- App favicon -->
    <link rel="shortcut icon" href="../admin/assets/images/favicon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css">
    <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css" />
    <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>

    <link href="https://fonts.googleapis.com/css2?family=Host+Grotesk:ital,wght@0,300..800;1,300..800&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="./admin/assets/css/icons.min.css">
    <link rel="stylesheet" href="css/style.css">
     <style>

        body{
              font-family:"Host Grotesk", sans-serif !important;
              overflow:hidden !important;
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
            border:2px solid transparent;
            background: #ffffff;
            background-clip: padding-box;
            border-radius: 10px;
        }
        .front-box .iconPic.iconBorder::after{
            content: '';
            position: absolute;
            top: -2px;
            bottom: -2px;
            left: -2px;
            right: -2px;
            background:linear-gradient(to bottom right, #22c1c3, #fdbb2d);
            z-index: -1;
            border-radius: 10px;
        }
        .modal {
            position:fixed;
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
            color: #000 !important;
            padding: 20px;
            width: 400px !important;
            border-radius: 8px !important;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            z-index: 10000;
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
            line-height: 41px;
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
                background-color:#107a49;
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
      <style>
          .mapsContents {
              position: absolute;
              background: #ffffff40;
              bottom: 0px;
              right: 0px;
              height: 100%;
              width: 35%;
              padding: 10px;
              z-index: 1;
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
              width: 100%;
              border-collapse: collapse;
              table-layout: fixed; /* Equal width columns */
              box-shadow: 0 0 15px rgba(255, 255, 255, 0.3);
          }

          th, td {
              padding: 12px;
              border: 1px solid #444;
              text-align: center;
              word-wrap: break-word; /* Handle long text */
          }

          th {
              background: linear-gradient(to bottom, #333, #111);
              color: #fff;
          }

              td:nth-child(2), th:nth-child(2) {
                  background: linear-gradient(to bottom right, #f03030, #f18c8c);
                  color: #000;
              }

              td:nth-child(3), th:nth-child(3) {
                  background: linear-gradient(to bottom right, #fcf259, #fcf259);
                  color: #000;
              }

              td:nth-child(4), th:nth-child(4) {
                  background: linear-gradient(to bottom right, #a5f591, #1eff00);
                  color: #000;
              }

              td:nth-child(5), th:nth-child(5) {
                  background: linear-gradient(to bottom right, #122b01, #21411a);
                  color: #fffcfc;
              }

               td:nth-child(6), th:nth-child(6) {
                  background: linear-gradient(to bottom right, #122b01, #21411a);
                  color: #fffcfc;
              }
                td:nth-child(7), th:nth-child(7) {
                  background: linear-gradient(to bottom right, #122b01, #21411a);
                  color: #fffcfc;
              }
                 td:nth-child(8), th:nth-child(8) {
                  background: linear-gradient(to bottom right, #122b01, #21411a);
                  color: #fffcfc;
              }
                  td:nth-child(9), th:nth-child(9) {
                  background: linear-gradient(to bottom right, #122b01, #21411a);
                  color: #fffcfc;
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
        <style>
    .form-check-input.custom-switch {
      width: 3rem;
      height: 1.5rem;
      border:1px solid black;
    }
    .form-check-input.custom-switch:checked{
      background-color: #0d6efd;
    }

    .form-check-label {
      font-size: 1.1rem;
      margin-left: 0.5rem;
    }

    ul{
      list-style: none;
      padding-left: 0;
    }

    li{
      margin-bottom:10px;
    }
    input{
        border: 1px solid #959595;
    }



    .portal-header h2{
        font-size: 30px;
        font-weight: 700;
        padding: 0 15px;
        margin-bottom:0;
    }




    /*====== Responsive Design =======*/
    

    @media (min-width:1367px) and (max-width:1600px){
        .section-services{
            top:55%;
        }
        #mapfilter{
            height: calc(100vh - 170px);
            width:100%;
        }
        .portal-header{
              font-size:26px;
          }
        .logo img {
            width: 250px;
        }
        .l_1 img {
            width: 160px;
        }
        .l_2 img {
            width: 210px;
        }
        .layerForestBox{
            height:220px;
        }
        .dropdown-header{
            margin-top:5px !important;
        }

 }




    @media (min-width:1201px) and (max-width:1366px){
    .logo img{
        width: 225px;
    }
    .l_1 img {
        width: 160px;
    }
    .l_2 img {
        width: 200px;
    }
    img.recap4NDCLogo {
        width: 60px !important;
    }
    .portal-header h2{
        font-size: 26px;
        font-weight: 800;  
    }
    .sideBarAssets{
        height: 470px;
        margin-top: 20px;
    }
    .flip_List li{
        margin-bottom: 4px !important;
    }
    .flip-box{
        height: 225px;
    }
    .clearfix{
        margin-top: 20px;
    }
    #mapfilter{
        height: calc(100vh - 142px);
        width:100%;
    }

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






      
  </style>
  </head>
  <body>
      
      <form id="form2" runat="server">
          
          <asp:ScriptManager runat="server" ></asp:ScriptManager>
<header id="header">
        <div class="container-fluid m-0">
           <div class="headAssets">
                <div class="logo">
                    <a href="indexs.aspx"><img src="../images/uttrakhand_logo.jpg" alt="logo picture" /></a>
                </div>
                 <div class="portal-header">
                   <div class="icon" aria-hidden="true"></div>
                     <h2>Forest Management Information System</h2>
               </div>
                <div class="ministryLogo">
                    <div class="l_1">
                        <a href="https://moef.gov.in/" target="_blank"><img src="../images/Ministry-of-Environment.jpg" alt="picture" /></a>
                    </div>
                    <!-- <div class="l_2">
                        <a href="https://www.giz.de/de/html/index.html" target="_blank"><img src="../images/gizLogo.png" alt="giz logo" /></a>
                    </div> -->
                    <div class="l_2">
                        <a href="#!" target="_blank"><img src="../images/recap4NDC.png" class="recap4NDCLogo" style="width:50px; padding:5px 0;" alt="recap4NDC" /></a>
                    </div>
                </div>
           </div>
        </div>
    </header>




    <section class="creative-fullpage--slider">
		<div class="banner-horizental">
			<div class="swiper swiper-container-h">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<div class="slider-inner" data-swiper-parallax="100">
							<img src="../images/bannerPic.jpg" alt="full_screen-image">
							<div class="swiper-content" data-swiper-parallax="2000">
                                <!-- <div class="container">
                                    <div class="bannerAssets">
                                        <h1><span>RECAP4NDC</span> Data-Driven <br>
                                            Climate Solutions.</h1>
                                            <h4>Empowering Nations to Achieve Climate Goals.</h4>
                                            <p>RECAP4NDC provides innovative solutions and expert guidance to help countries track, report, and enhance their Nationally Determined Contributions (NDCs). We empower governments and organizations to achieve climate targets with precision, transparency, and accountability.</p>
                                            <a href="modules.aspx" class="proceedBtn">Proceed <span class="material-icons-sharp">arrow_right_alt</span></a>
                                    </div>
                                </div> -->

							</div>
						</div>
					</div>

					<div class="swiper-slide">
						<div class="slider-inner" data-swiper-parallax="100">
							<img src="../images/bannerPic2.jpg" alt="full_screen-image">
							<div class="swiper-content" data-swiper-parallax="2000">
                              <!--  <div class="container">
                                    <div class="bannerAssets">
                                        <h1><span>RECAP4NDC</span> Data-Driven <br>
                                            Climate Solutions.</h1>
                                            <h4>Empowering Nations to Achieve Climate Goals.</h4>
                                            <p>RECAP4NDC provides innovative solutions and expert guidance to help countries track, report, and enhance their Nationally Determined Contributions (NDCs). We empower governments and organizations to achieve climate targets with precision, transparency, and accountability.</p>
                                            <a href="modules.aspx" class="proceedBtn">Proceed <span class="material-icons-sharp">arrow_right_alt</span></a>
                                    </div>
                                </div> -->
							</div>
						</div>
					</div>

                    <div class="swiper-slide">
						<div class="slider-inner" data-swiper-parallax="100">
							<img src="../images/bannerPic3.jpg" alt="full_screen-image">
							<div class="swiper-content" data-swiper-parallax="2000">
                                <div class="container">
                                  <!--  <div class="bannerAssets">
                                        <h1><span>RECAP4NDC</span> Data-Driven <br>
                                            Climate Solutions.</h1>
                                            <h4>Empowering Nations to Achieve Climate Goals.</h4>
                                            <p>RECAP4NDC provides innovative solutions and expert guidance to help countries track, report, and enhance their Nationally Determined Contributions (NDCs). We empower governments and organizations to achieve climate targets with precision, transparency, and accountability.</p>
                                            <a href="modules.aspx" class="proceedBtn">Proceed<span class="material-icons-sharp">arrow_right_alt</span></a>
                                    </div>
                                </div> -->
							</div>
						</div>
					</div>
					</div>
					<!-- <div class="swiper-button-wrapper creative-button--wrapper">
						<div class="swiper-button-next" tabindex="0" role="button" aria-label="Next slide">
						</div>
						<div class="swiper-button-prev" tabindex="0" role="button" aria-label="Previous slide">
						</div>
					</div> -->
				</div>
			</div>
		</section>





    <!-- modules-->
     <!-- banner section -->
     <section class="modules section-services">
        <div class="container-fluid">
             <div class="row">
                <div class="col-lg-3 col-md-3 col-sm-12 col-12">
                    <div class="sideBarAssets">
             <!-- <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1767557.6243518726!2d77.98928082152143!3d30.086711017743053!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3909dcc202279c09%3A0x7c43b63689cc005!2sUttarakhand!5e0!3m2!1sen!2sin!4v1743761057506!5m2!1sen!2sin" width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe> -->
                            <div id="map">
                                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
                               
<div style=" padding: 15px;
    position: absolute;
    z-index: 1;
    background-color: white;
    bottom: 0px;">
  <ul>
    <li class="form-check form-switch">
      <input class="form-check-input custom-switch" type="checkbox" id="zone1" onclick="sfdzone(this)">
      <label class="form-check-label" for="zone">Zone</label>
      <span id="div_zone1" style="display: none"></span>
    </li>
    <li class="form-check form-switch">
      <input class="form-check-input custom-switch" type="checkbox" id="circle1" onclick="sfdcircle(this)">
      <label class="form-check-label" for="circle">Circle</label>
      <span id="div_circle1" style="display: none"></span>
    </li>
    <li class="form-check form-switch">
      <input class="form-check-input custom-switch" type="checkbox" id="division1" onclick="sfddivision(this)" checked>
      <label class="form-check-label" for="division">Division</label>
      <span id="div_division1" style="display: none"></span>
    </li>
    <li class="form-check form-switch">
      <input class="form-check-input custom-switch" type="checkbox" id="range1" onclick="range_fun(this)">
      <label class="form-check-label" for="range">Range</label>
      <span id="div_range1" style="display: none"></span>
    </li>
  </ul>
</div>
                            
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
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_state_boundary&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>

                                        <li>
                                            <asp:CheckBox ID="cd_district" runat="server" onclick='district(this);' Text="District Boundary" class="nav-item" />

                                            <span id='div_district' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_districts&Format=image/gif&scale=800000&Transparent=true" />
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
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_zone_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="circle" runat="server" onclick='sfdcircle(this);' Text="Circle " class="nav-item" />

                                            <span id='div_circle' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_circle_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li>
                                         <li >
                                            <asp:CheckBox ID="division" runat="server" onclick='sfddivision(this);' Text="Division " class="nav-item" />

                                            <span id='div_division' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_division_master&Format=image/gif&scale=800000&Transparent=true" />
                                            </span>
                                        </li><li >
                                            <asp:CheckBox ID="range" runat="server" onclick='range_fun(this);' Text="Range" class="nav-item" />

                                            <span id='div_range' style='display: none'>
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:view_range_master&Format=image/gif&scale=800000&Transparent=true" />
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
                                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_forest_data_final&Format=image/gif&scale=800000&Transparent=true" />
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
                    <div class="row frontAllBoxArea">

                        <div class="frontBox1 col-lg-4">
                            <div class="leftCol">
                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/dss.png" alt=""></div>
                                <h3>Forest Information System Module</h3>
                            </div>
                            <div class="rightCol">
                                <ul class="rList">
                                    <li>GIS Viewer</li>
                                    <li>Change Detection Analysis</li>
                                    <li>proximity Analysis</li>
                                </ul>
                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                    <span class="material-icons-sharp">
                                    east</span></a>
                            </div>
                        </div>

                        <div class="frontBox1 col-lg-4">
                            <div class="leftCol">
                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/sfm.png" alt=""></div>
                                 <h3>Fire Management</h3>
                            </div>
                            <div class="rightCol">
                                <ul class="rList">
                                    <li>Monitoring</li>
                                    <li>Reporting</li>
                                </ul>
                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                    <span class="material-icons-sharp">
                                    east</span></a>
                            </div>
                        </div>

                        <div class="frontBox1 col-lg-4">
                            <div class="leftCol">
                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/pm_icon.png" alt=""></div>
                                 <h3>Plantation <br /> Management</h3>
                            </div>
                            <div class="rightCol">
                                <ul class="rList">
                                    <li>Monitoring</li>
                                    <li>Reporting</li>
                                </ul>
                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                    <span class="material-icons-sharp">
                                    east</span></a>
                            </div>
                        </div>

                        <div class="frontBox1 col-lg-4">
                            <div class="leftCol">
                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/NurseryPic.png" alt=""></div>
                                <h3>Nursery Management</h3>
                            </div>
                            <div class="rightCol">
                                <ul class="rList">
                                    <li>Monitoring</li>
                                    <li>Reporting</li>
                                </ul>
                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                    <span class="material-icons-sharp">
                                    east</span></a>
                            </div>
                        </div>

                        <div class="frontBox1 col-lg-4">
                            <div class="leftCol">
                               <div class="iconPic iconBorder"><img src="../images/modules/color-icon/HWC.png" alt=""></div>
                                <h3>Human Wildlife Conflict</h3>
                            </div>
                            <div class="rightCol">
                                <ul class="rList">
                                    <li>Monitoring</li>
                                    <li>Reporting</li>
                                    <li>Compensation Approval</li>
                                </ul>
                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                    <span class="material-icons-sharp">
                                    east</span></a>
                            </div>
                        </div>


                        <div class="frontBox1 col-lg-4">
                            <div class="leftCol">
                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/tw_icon.png" alt=""></div>
                                <h3>PMS</h3>
                            </div>
                            <div class="rightCol">
                                <ul class="rList">
                                    <%-- <li>Training manuals</li>
                                         <li>User Manuals</li>--%>
                                         <li>21 PMS</li>
                                </ul>
                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                    <span class="material-icons-sharp">
                                    east</span></a>
                            </div>
                        </div>


                        <div class="frontBox1 col-lg-4">
                            <div class="leftCol">
                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/sp_icon.png" alt=""></div>
                                 <h3>Patrolling</h3>
                            </div>
                            <div class="rightCol">
                                <ul class="rList">
                                    <li>Monitoring</li>
                                    <li>Reporting</li>
                                </ul>
                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                    <span class="material-icons-sharp">
                                    east</span></a>
                            </div>
                        </div>

                        <div class="frontBox1 col-lg-4">
                            <div class="leftCol">
                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/vl_icon.png" alt=""></div>
                                <h3>User Resources</h3>
                            </div>
                            <div class="rightCol">
                                <ul class="rList">
                                    <li>User Manual</li>
                                    <li>Videos</li>
                                </ul>
                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                    <span class="material-icons-sharp">
                                    east</span></a>
                            </div>
                        </div>

                         <div class="frontBox1 col-lg-4">
                            <div class="leftCol">
                                <div class="iconPic iconBorder"><img src="../images/modules/color-icon/Rm_icon.png" alt=""></div>
                                <h3>UKFD MIS Portal</h3>
                            </div>
                            <div class="rightCol">
                                <ul class="rList">
                                    <li>UKFD MIS Portal</li>
                                </ul>
                                 <a href="../Forest/dashboard.aspx" class="clickBtn">
                                    <span class="material-icons-sharp">
                                    east</span></a>
                            </div>
                        </div>



                     </div> 
                </div>



<!--- Slider design -->

        </div>
     </section>


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
                                <asp:Button ID="btnLogin" runat="server" CssClass="loginBtn btn btn-primary"
                                    Text="Login" OnClick="btnLogin_Click" OnClientClick="storeinfo()" />
                            </div>

                                                       <div class="forgot-password-container">
    <a href="javascript:void(0);" class="forgot-password-link" onclick="openForgotPasswordModal()">
        <i class="fa fa-key"></i> Forgot Password?
    </a>
</div>

                        </div>
                    </div>


                    <!-- /.Login Modal -->


             </div>


<!-- ===== filter section desing ====== -->
          <asp:UpdatePanel runat="server" style="display:none">
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
                           <asp:ListItem>Land Degradation</asp:ListItem>
                            
                       </asp:DropDownList>
                  </div>
                </div>
            </div>




        </div>
    </div>
</section>
                   </ContentTemplate>
          </asp:UpdatePanel>
                  

                     
          <section class="chartColumns" style="display:none">
              <div class="container-fluid">
                  <div class="row">
                     
                        <div id="mapfilter" style="height:600px;position: relative;padding:0" >
                              <asp:UpdatePanel runat="server">
                              <ContentTemplate>
                            <div class="table-content" runat="server" id="areatable" style="display:none">
                                <asp:GridView runat="server" ID="grd_area" AutoGenerateColumns="true" ></asp:GridView>
                                <%--<span><b>Note</b> :</span>--%>
                                <div class="dropdown-header" onclick="toggleNotes()">
                                    Note:
                                         <span class="arrow" id="arrow">&#9654;</span>
                                </div>
                             
                                <div id="note-container" class="hidden">
                                     <div style="display:none" runat="server" id="headernotaion">

                                    <span><b>Scrub</b> : (Canopy Density < 10 %)</span><br />
                                    <span><b>Open Forest</b> :  (10 % ≤ Canopy Density < 40 %)</span><br />
                                    <span><b>Moderately Dense Forest</b> :  (40 % ≤ Canopy Density < 70 %)</span><br />
                                    <span><b>Very Dense Forest</b> :  (Canopy Density ≥ 70 %)</span><br />
                                </div>
                                <div style="display:none" runat="server" id="headernotation_degradation">

                                    <span><b>Dw1</b> : Agriculture unirrigated, water erosion, Low</span><br />
                                    <span><b>Fv1</b> :  Forest, vegetation degradation, Low</span><br />
                                    <span><b>Lf2</b> :  Periglacial, frost shattering, High</span><br />
                                    <span><b>S</b> :  Settlement</span><br />
                                    <span><b>Sv1</b> :  Land with scrub, vegetation degradation, Low</span><br />
                                    <span><b>Sv2</b> :  Land with scrub, vegetation degradation, High</span><br />
                                    <span><b>W</b> : Water body/ Drainage</span><br />
                                </div>
                                     <span> All numeric values are in Sq Km</span>
                                </div>
                               
                                  
                               
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
            <footer class="FooterColumn1">
                <div class="footerContt">
                    <div class="f_logo1"><a href="#!"><img src="../admin/assets/images/federal_logo.jpg" alt="footer logo" /></a></div>
                    <div class="f_logo2"><a href="#!"><img src="../admin/assets/images/iki_logo.jpg" alt="giz logo" /></a></div>
                    <div class="f_logo3"><a href="#!"><img src="../admin/assets/images/giz_logo.jpg" /></a></div>
                </div>  
            </footer>
              <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>


          <style>

              /* Error Message */
.error-msg {
    margin-top: 14px;
    padding: 14px 18px;
    background: #fff3f3;
    border: 1px solid #f5c6cb;
    border-radius: 12px;
    color: #c0392b;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.error-msg i {
    font-size: 18px;
    flex-shrink: 0;
}

/* Success Card */
.success-card {
    text-align: center;
    padding: 40px 0 20px;
    animation: fadeIn .4s ease;
}

.success-icon {
    width: 90px;
    height: 90px;
    background: linear-gradient(135deg, #107a49, #1a9a5f);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 20px;
    box-shadow: 0 10px 30px rgba(16,122,73,.30);
}

.success-icon i {
    font-size: 40px;
    color: #fff;
}

.success-title {
    font-size: 24px;
    color: #0b5d37;
    font-weight: 700;
    margin-bottom: 12px;
}

.success-msg {
    color: #444;
    font-size: 14px;
    margin-bottom: 14px;
    line-height: 1.6;
}

.masked-email {
    display: inline-block;
    background: #eef8f2;
    border: 1px solid #c3e6cc;
    border-radius: 10px;
    padding: 10px 24px;
    font-size: 18px;
    font-weight: 700;
    color: #107a49;
    letter-spacing: 1px;
    margin-bottom: 18px;
}

.success-note {
    font-size: 13px;
    color: #777;
    line-height: 1.6;
    background: #f9f9f9;
    border-radius: 10px;
    padding: 12px 16px;
    margin-bottom: 0;
}

.success-note i {
    color: #d4a017;
    margin-right: 5px;
}

.forgot-password-container {
    display: block;
    margin: 0 auto;
    padding-top: 15px;
}



              /* =========================
   OVERLAY
========================= */

              .forgot-overlay {
                  position: fixed;
                  inset: 0;
                  background: rgba(0,0,0,0.78);
                  backdrop-filter: blur(8px);
                  display: none;
                  justify-content: center;
                  align-items: center;
                  z-index: 99999;
                  animation: fadeIn .3s ease;
              }

              @keyframes fadeIn {
                  from {
                      opacity: 0;
                  }

                  to {
                      opacity: 1;
                  }
              }

              /* =========================
   CARD
========================= */

              .forgot-card {
                  width: 550px;
                  max-width: 95%;
                  background: #fff;
                  border-radius: 30px;
                  overflow: hidden;
                  position: relative;
                  box-shadow: 0 30px 80px rgba(0,0,0,.35);
                  animation: popup .35s ease;
              }

              @keyframes popup {
                  from {
                      opacity: 0;
                      transform: translateY(30px) scale(.95);
                  }

                  to {
                      opacity: 1;
                      transform: translateY(0) scale(1);
                  }
              }

              /* =========================
   TOP STRIP
========================= */

              .top-strip {
                  height: 8px;
                  background: linear-gradient( 90deg, #107a49, #1a9a5f, #d4a017 );
              }

              /* =========================
   CLOSE BUTTON
========================= */

              .close-btn {
                        position: absolute;
                        top: 12px;
                        right: 4px;
                        width: 40px;
                        height: 40px;
                        border: none;
                        border-radius: 50px;
                        background: #107a49;
                        color: #fff;
                        font-size: 32px;
                        cursor: pointer;
                        box-shadow: 0 10px 25px rgba(16, 122, 73, .35);
                        transition: .3s;
                        z-index: 10;
                        line-height: 43px;
              }

                  .close-btn:hover {
                      background: #0b5d37;
                      transform: scale(1.08);
                  }

              /* =========================
   HEADER
========================= */

              .forgot-header {
                  text-align: center;
                  padding: 35px 50px 20px;
                  position: relative;
              }

                  .forgot-header::before {
                      content: "🌿";
                      position: absolute;
                      left: 25px;
                      top: 20px;
                      font-size: 70px;
                      opacity: .06;
                  }

              .logo-box {
                  width: 110px;
                  height: 110px;
                  margin: auto;
                  background: #eef8f2;
                  border-radius: 50%;
                  display: flex;
                  align-items: center;
                  justify-content: center;
              }

                  .logo-box img {
                      width: 80px;
                      height: auto;
                  }

              .forgot-header h5 {
                  margin-top: 20px;
                  margin-bottom: 0;
                  font-size: 30px;
                  font-weight: 700;
                  color: #0b5d37;
              }

              .forgot-header span {
                  color: #0b5d37;
                  letter-spacing: 2px;
              }

              .divider {
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  gap: 12px;
                  margin: 18px 0;
              }

                  .divider span {
                      width: 90px;
                      height: 2px;
                      background: #d4a017;
                  }

                  .divider i {
                      color: #d4a017;
                      font-size: 10px;
                  }

              .forgot-header h2 {
                  font-size: 25px;
                  color: #0b5d37;
                  font-weight: 700;
                  margin-bottom: 15px;
              }

              .forgot-header p {
                  max-width: 520px;
                  margin: auto;
                  color: #000000;
                  font-size: 14px;
                  line-height: 1.7;
              }

              /* =========================
   FORM
========================= */

              .form-section {
                  padding: 0 55px 30px;
              }

                  .form-section label {
                      margin-bottom: 12px;
                      display: block;
                      color: #0b5d37;
                      font-size: 15px;
                      font-weight: 600;
                  }

              /* =========================
   INPUT
========================= */

              .input-box {
                    display: flex;
                    align-items: center;
                    border: 1px solid #76d7aa;
                    border-radius: 50px;
                    overflow: hidden;
                    margin-bottom: 25px;
              }

                  .input-box i {
                      width: 65px;
                      text-align: center;
                      color: #107a49;
                      font-size: 24px;
                  }

                  .input-box input {
                      flex: 1;
                      border: none;
                      outline: none;
                      height: 45px;
                      font-size: 18px;
                      background: transparent;
                          padding: 15px;
                  }

              /* =========================
   BUTTON
========================= */

              .reset-btn {
                    width: 100%;
                    height: 48px;
                    border: none;
                    border-radius: 50px;
                    background: linear-gradient(135deg, #107a49, #0b5d37);
                    color: #fff;
                    font-size: 20px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: .3s;
                    letter-spacing: 0.4px;
                    box-shadow: 0 10px 30px rgba(16, 122, 73, .30);
              }

                  .reset-btn i {
                      margin-right: 10px;
                  }

                  .reset-btn:hover {
                      transform: translateY(-2px);
                  }

              /* =========================
   SECURITY BOX
========================= */

              .security-box {
                  margin-top: 28px;
                  background: #f5faf6;
                  border: 1px solid #e0f0e5;
                  border-radius: 18px;
                  padding: 22px;
                  display: flex;
                  align-items: center;
                  gap: 18px;
              }

              .security-icon {
                  width: 60px;
                  height: 60px;
                  background: #e6f7ec;
                  border-radius: 50%;
                  display: flex;
                  align-items: center;
                  justify-content: center;
              }

                  .security-icon i {
                      color: #107a49;
                      font-size: 28px;
                  }

              .security-box h6 {
                  margin: 0;
                  color: #0b5d37;
                  font-size: 18px;
                  font-weight: 700;
              }

              .security-box p {
                  margin: 6px 0 0;
                  color: #666;
                  font-size: 14px;
              }

              /* =========================
   FOREST FOOTER
========================= */

              .forest-footer {
                  height: 130px;
                  background: linear-gradient( to top, #0b5d37, #2f8f5d, transparent );
                  position: relative;
              }

                  .forest-footer::before {
                      content: "🌲 🌲 🌲 🌲 🌲 🌲 🌲 🌲 🌲 🌲";
                      position: absolute;
                      bottom: 20px;
                      left: 0;
                      width: 100%;
                      text-align: center;
                      font-size: 38px;
                      opacity: .25;
                  }

              /* =========================
   RESPONSIVE
========================= */

              @media(max-width:768px) {

                  .forgot-card {
                      width: 95%;
                  }

                  .forgot-header {
                      padding: 25px;
                  }

                      .forgot-header h5 {
                          font-size: 26px;
                      }

                      .forgot-header h2 {
                          font-size: 38px;
                      }

                      .forgot-header p {
                          font-size: 15px;
                      }

                  .form-section {
                      padding: 0 20px 20px;
                  }

                  .security-box {
                      flex-direction: column;
                      text-align: center;
                  }
              }
          </style>

       
<div id="forgotPasswordModal" class="forgot-overlay">
    <div class="forgot-card">
        <button type="button" class="close-btn" onclick="closeForgotPasswordModal()">&times;</button>
        <div class="top-strip"></div>

        <div class="forgot-header">
            <h2>Reset Password</h2>
            <p>Enter your User ID or registered email address and we'll send you a secure link to reset your password.</p>
        </div>

        <div class="form-section">

            <%-- UpdatePanel ke andar sab kuch wrap karo --%>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

                    <div id="inputSection">
                        <label>Email ID</label>
                        <div class="input-box">
                           
                            <asp:TextBox ID="txtForgotUserId" runat="server"
                                CssClass="forgot-input"
                                placeholder="Enter User ID or Email">
                            </asp:TextBox>
                        </div>

                        <asp:Button ID="btnSendResetLink" runat="server"
                            CssClass="reset-btn"
                            Text="Send Secure Reset Link"
                            OnClick="btnSendResetLink_Click" />

                        <div id="errorMsg" class="error-msg" style="display:none;">
                            <i class="fa fa-exclamation-circle"></i>
                            <span id="errorText">User ID not found. Please try again.</span>
                        </div>
                    </div>

                    <div id="successSection" style="display:none;">
                        <div class="success-card">
                          
                            <h3 class="success-title">Link Sent Successfully!</h3>
                            <p class="success-msg">
                                Password reset link has been sent to your registered email:
                            </p>
                            <div class="masked-email" id="maskedEmailDisplay"></div>
                            <p class="success-note">
                                <i class="fa fa-info-circle"></i>
                                Please check your inbox and spam folder. Link expires in <strong style="color:red">15 minutes</strong>.
                            </p>
                            <button type="button" class="reset-btn" onclick="closeForgotPasswordModal()" style="margin-top:10px;">
                                <i class="fa fa-check"></i> Got it, Close
                            </button>
                        </div>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>

        </div>
    </div>
</div>


          <script>
              function openForgotPasswordModal() {
                  // ✅ Header wapas show karo
                  document.querySelector(".forgot-header").style.display = "block";

                  // Reset to initial state
                  document.getElementById("inputSection").style.display = "block";
                  document.getElementById("successSection").style.display = "none";
                  document.getElementById("errorMsg").style.display = "none";

                  document.getElementById("forgotPasswordModal").style.display = "flex";
              }

              function closeForgotPasswordModal() {
                  document.getElementById("forgotPasswordModal").style.display = "none";
              }

              document.querySelector(".close-btn").addEventListener("click", function () {
                  closeForgotPasswordModal();
              });

              window.onclick = function (event) {
                  var modal = document.getElementById("forgotPasswordModal");
                  if (event.target == modal) {
                      closeForgotPasswordModal();
                  }
              };

              function validateForgotInput() {
                  var val = document.getElementById('<%= txtForgotUserId.ClientID %>').value.trim();
                  if (val === "") {
                      document.getElementById("errorText").innerText = "Please enter your User ID or Email.";
                      document.getElementById("errorMsg").style.display = "flex";
                      return false;
                  }
                  document.getElementById("errorMsg").style.display = "none";
                  return true;
              }

              // Called from code-behind via ScriptManager after API check
              function showResetSuccess(maskedEmail) {
                  // ✅ Header bhi hide karo
                  document.querySelector(".forgot-header").style.display = "none";

                  // Input section hide karo
                  document.getElementById("inputSection").style.display = "none";

                  // Success section show karo
                  document.getElementById("successSection").style.display = "block";
                  document.getElementById("maskedEmailDisplay").innerText = maskedEmail;
              }

              function showResetError(message) {
                  document.getElementById("errorText").innerText = message;
                  document.getElementById("errorMsg").style.display = "flex";
              }
          </script>


          <script type="text/javascript">

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
          </script>

  <script>
      document.addEventListener('DOMContentLoaded', function () {
          const modal = document.getElementById("loginModal");
          const closeBtn = modal.querySelector(".close");
          const flipLinks = document.querySelectorAll(".rightCol a");

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
          <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
  <%--  <script src="js/script.js"></script>--%>
          <script src="../GIS/js/jquery.min.js"></script>
           <%--<script src="js/mapfilter.js"></script>--%>
      <script src="js/modules.js"></script>
      <script src="js/script.js"></script>
                  
   
  
        </form>

  </body>
</html>

