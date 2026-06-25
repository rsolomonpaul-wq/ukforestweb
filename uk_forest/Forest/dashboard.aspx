<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="uk_forest.Forest.dashboard" ClientIDMode="Static" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    
    <script>
        window.addEventListener("load", function () {
            debugger;
            const startTime = new Date();

            const data = {
                page_url: window.location.href,    // Current page URL
                page_title: document.title, // Current page title
                visit_time: startTime
            };

            var apiBaseUrl = '<%= System.Configuration.ConfigurationManager.AppSettings["api_path"] %>';

             var apiUrl = apiBaseUrl + 'TblPageVisits/PostTblPageVisit';

             function sendPageVisitData() {
                 const timeSpent = Math.floor((Date.now() - startTime) / 1000);

                 data.time_spent_seconds = timeSpent;

                 fetch(apiUrl, {
                     method: "POST",
                     headers: {
                         "Content-Type": "application/json"
                     },
                     body: JSON.stringify(data)
                 }).then(response => {
                     if (!response.ok) {
                         console.error("Failed to store page visit info.");
                     }
                 }).catch(error => {
                     console.error("Error:", error);
                 });
             }

             window.addEventListener("beforeunload", sendPageVisitData);
         });
    </script>

    <style>
     /*   .page-container {
  display: none;
}*/
    </style>
     <style>
         div#searchModal {
    display: none !important;
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
    top: 45px !important;
}
        div h3{
            padding:10px 10px;
            background-color:forestgreen;
            margin-top:10px;
            color:white;
        }
        .page-container table th {
    background-color: #d1d11e;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="height:750px;overflow:hidden;margin-top: 15px;">
         <div id="map" >


       <%-- <div id="div" class="infoPopupBox">
            <img src="../GIS/img/close.png" class="closebtns" style="float: right; width: 22px" title="Close" alt="X" onclick="closeclick();" />
            <div id="infodiv">
            </div>
        </div>--%>
        <div class="mapFeatureData">
            <div class="layersData" id="layersDataid" style="display: none;">
                <div class="layersDataHead" style="border-bottom: 1px solid #bbbbbb">
                    <div style="text-align: center; width: 95%; padding: 0">
                        <h3 style="font-weight: 700; font-size: 25px; margin-top: 5px;">Layers</h3>
                    </div>
                    <div id="divcloselayersDataid">
                    </div>
                </div>
                <div>
                    <ul>
                        

                        <li>
                            <asp:CheckBox ID="cd_district" runat="server" onclick='district(this);' Text="SFD District Boundaries" class="nav-item" />

                            <span id='div_district' style='display: none'>
                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_uk_districts&Format=image/gif&scale=800000&Transparent=true" />
                            </span>
                        </li>

                      
                        <li>
                            <asp:CheckBox ID="zone" runat="server" onclick='sfdzone(this);' Text="SFD Zone Boundaries" class="nav-item" />

                            <span id='div_zone' style='display: none'>
                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_zone_master&Format=image/gif&scale=800000&Transparent=true" />
                            </span>
                        </li>
                        <li>
                            <asp:CheckBox ID="circle" runat="server" onclick='sfdcircle(this);' Text="SFD Circle Boundaries" class="nav-item" />

                            <span id='div_circle' style='display: none'>
                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_circle_master&Format=image/gif&scale=800000&Transparent=true" />
                            </span>
                        </li>
                        <li>
                            <asp:CheckBox ID="division" runat="server" onclick='sfddivision(this);' Text="SFD Division Boundaries" class="nav-item" />

                            <span id='div_division' style='display: none'>
                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_division_master&Format=image/gif&scale=800000&Transparent=true" />
                            </span>
                        </li>


 
                        <li>
                            <asp:CheckBox ID="cd_forest" runat="server" onclick='forest_fun(this);' Text="Forest Area" class="nav-item" />

                            <span id='div_forest' style='display: none'>
                                <img src="https://ukforestgis.in/geoserver/uk_sfd/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=uk_sfd:tbl_forest_data_final&Format=image/gif&scale=800000&Transparent=true" />
                            </span>
                        </li>
                         
                    </ul>
                </div>

            </div>

        </div>
        <style>
            .iconsrow1 {
                position: absolute;
                z-index: 1;
                left: 97px;
                height: 40px;
                display: none;
                width: calc(100% - 150px);
                justify-content: space-between;
                align-items: center;
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
                right: 50px;
                top: 40px;
                border: 1px solid #c7c7c7;
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
      <%--  <div class="iconsrow1 gettitle" id="mapfeatures">
            <div class="left-icons">


                <img class="tool-btn" src="../GIS/img/map_icons/hand.png" title="Pen" alt="Start/Stop Toggle" id="toggleImage" />

                <img class="tool-btn" src="../GIS/img/map_icons/info.png" title="Information" id="info" onclick="setselectedinfo();" />
                <img src="../GIS/img/map_icons/layer.png" title="Layers" id="imgidlayer" onclick="fun_layer()" />
            </div>
            <div class="right-icons">
            </div>
        </div>--%>







    </div>

    </div>
   
    <div style="display:block !important">
        <h3>Administrative Zone</h3>
        <asp:GridView runat="server" ID="grd_zone" AutoGenerateColumns="false">
            <Columns>
                <asp:TemplateField HeaderText="S No">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Zone">
                    <ItemTemplate>
                        <%# Eval("zone") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="RF (Sq Km)">
                    <ItemTemplate>
                        <%# Eval("rf_area_sq_km", "{0:F2}") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="NF (Sq Km)">
                    <ItemTemplate>
                        <%# Eval("nf_area_sq_km", "{0:F2}") %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
      <div style="display:block !important">
          <h3>Administrative Circle</h3>
          <div style="height: 300px !important;
    max-height: 300px !important;
    overflow-y: auto !important;width:100% !important">
        <asp:GridView runat="server" ID="grd_circle" AutoGenerateColumns="false">
             <Columns>
                <asp:TemplateField HeaderText="S No">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                  <asp:TemplateField HeaderText="Circle">
                    <ItemTemplate>
                        <%# Eval("circle") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Zone">
                    <ItemTemplate>
                        <%# Eval("zone") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="RF (Sq Km)">
                    <ItemTemplate>
                        <%# Eval("rf_area_sq_km", "{0:F2}") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="NF (Sq Km)">
                    <ItemTemplate>
                        <%# Eval("nf_area_sq_km", "{0:F2}") %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
              </div>
    </div>
      <div >
          <h3>Administrative Division</h3>
          <div style="height: 300px !important;
    max-height: 300px !important;
    overflow-y: auto !important;width:100% !important">

         
        <asp:GridView runat="server" ID="grd_division" AutoGenerateColumns="false" >

            <Columns>
                <asp:TemplateField HeaderText="S No">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                 <asp:TemplateField HeaderText="Division">
                    <ItemTemplate>
                        <%# Eval("division") %>
                    </ItemTemplate>
                </asp:TemplateField>
                  <asp:TemplateField HeaderText="Circle">
                    <ItemTemplate>
                        <%# Eval("circle") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Zone">
                    <ItemTemplate>
                        <%# Eval("zone") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="RF (Sq Km)">
                    <ItemTemplate>
                        <%# Eval("rf_area_sq_km", "{0:F2}") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="NF (Sq Km)">
                    <ItemTemplate>
                        <%# Eval("nf_area_sq_km", "{0:F2}") %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
               </div>
    </div>
                    <div class="page-title-head d-flex align-items-sm-center flex-sm-row flex-column gap-2" style="display:none !important">
                        <div class="flex-grow-1">
                            <h4 class="fs-18 fw-semibold mb-0">Dashboard</h4>
                        </div>

                        <div class="text-end">
                            <ol class="breadcrumb m-0 py-0">
                                <li class="breadcrumb-item"><a href="javascript: void(0);">Modules</a></li>

                                <li class="breadcrumb-item"><a href="javascript: void(0);">Dashboard</a></li>
                            </ol>
                        </div>
                    </div>

                    <div class="row" style="display:none">
                        <div class="col-xxl-12">
                            <div class="row">
                                <div class="col-xl-3">
                                    <div class="card">
                                        <div class="d-flex card-header justify-content-between align-items-center">
                                            <h4 class="header-title">Total Balance</h4>
                                            <div class="dropdown">
                                                <a href="#" class="dropdown-toggle bg-light-subtle rounded drop-arrow-none card-drop" data-bs-toggle="dropdown" aria-expanded="false">
                                                    <i class="ti ti-dots-vertical"></i>
                                                </a>
                                                <div class="dropdown-menu dropdown-menu-end">
                                                    <!-- item-->
                                                    <a href="javascript:void(0);" class="dropdown-item">Sales Report</a>
                                                    <!-- item-->
                                                    <a href="javascript:void(0);" class="dropdown-item">Export Report</a>
                                                    <!-- item-->
                                                    <a href="javascript:void(0);" class="dropdown-item">Profit</a>
                                                    <!-- item-->
                                                    <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card-body pt-0">
                                            <h2 class="fw-bold">$92,652.36 <a href="#!" class="text-muted"><i class="ti ti-eye"></i></a></h2>

                                            <div class="row g-2 mt-2 pt-1">
                                                <div class="col">
                                                    <a href="#!" class="btn btn-primary w-100"><i class="ti ti-coin me-1"></i>Transfer</a>
                                                </div>
                                                <div class="col">
                                                    <a href="#!" class="btn btn-info w-100"><i class="ti ti-coin me-1"></i>Request</a>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- end card-body -->
                                    </div>
                                    <!-- end card -->
                                </div>
                                <!-- end col -->

                                <div class="col-xl-3">
                                    <div class="card">
                                        <div class="card-body">

                                            <div class="row justify-content-between">
                                                <div class="col-sm-5">
                                                    <iconify-icon icon="solar:money-bag-bold-duotone" class="fs-36 text-muted"></iconify-icon>
                                                    <h3 class="mb-0 fw-bold mt-2 mb-1">$105.3k</h3>
                                                    <p class="text-muted">Total Income</p>
                                                    <span class="badge fs-12 badge-soft-danger"><i class="ti ti-arrow-badge-down"></i>0.93%</span>
                                                </div>
                                                <!-- end col -->

                                                <div class="col-sm-7 text-end d-flex flex-column">
                                                    <a href="javascript:void(0);" class="link-reset text-decoration-underline link-offset-2 fw-medium pb-2">View Details
                                                    </a>
                                                    <div class="text-end mt-auto">
                                                        <div id="revenue-chart" data-colors="#6ac75a"></div>
                                                    </div>
                                                </div>
                                                <!-- end col -->
                                            </div>

                                        </div>
                                        <!-- end card-body -->
                                    </div>
                                    <!-- end card -->
                                </div>
                                <!-- end col -->

                                <div class="col-xl-3">
                                    <div class="card">
                                        <div class="card-body">

                                            <div class="row justify-content-between">
                                                <div class="col-sm-5">
                                                    <iconify-icon icon="solar:hand-money-bold-duotone" class="fs-36 text-muted"></iconify-icon>
                                                    <h3 class="mb-0 fw-bold mt-2 mb-1">$78.3k</h3>
                                                    <p class="text-muted">Total Expense</p>
                                                    <span class="badge fs-12 badge-soft-success"><i class="ti ti-arrow-badge-up"></i>8.72%</span>
                                                </div>
                                                <!-- end col -->

                                                <div class="col-sm-7 text-end d-flex flex-column">
                                                    <a href="javascript:void(0);" class="link-reset text-decoration-underline link-offset-2 fw-medium pb-2">View Details
                                                    </a>
                                                    <div class="text-end mt-auto">
                                                        <div id="expenses-chart" data-colors="#465dff"></div>
                                                    </div>
                                                </div>
                                                <!-- end col -->
                                            </div>
                                        </div>
                                        <!-- end card-body -->
                                    </div>
                                    <!-- end card -->
                                </div>
                                <!-- end col -->

                                <div class="col-xl-3">
                                    <div class="card">
                                        <div class="card-body">

                                            <div class="row justify-content-between">
                                                <div class="col-sm-5">
                                                    <iconify-icon icon="solar:hand-money-bold-duotone" class="fs-36 text-muted"></iconify-icon>
                                                    <h3 class="mb-0 fw-bold mt-2 mb-1">$78.3k</h3>
                                                    <p class="text-muted">Total Expense</p>
                                                    <span class="badge fs-12 badge-soft-success"><i class="ti ti-arrow-badge-up"></i>8.72%</span>
                                                </div>
                                                <!-- end col -->

                                                <div class="col-sm-7 text-end d-flex flex-column">
                                                    <a href="javascript:void(0);" class="link-reset text-decoration-underline link-offset-2 fw-medium pb-2">View Details
                                                    </a>
                                                    <div class="text-end mt-auto">
                                                        <div id="expenses-chart" data-colors="#465dff"></div>
                                                    </div>
                                                </div>
                                                <!-- end col -->
                                            </div>
                                        </div>
                                        <!-- end card-body -->
                                    </div>
                                    <!-- end card -->
                                </div>
                                <!-- end col -->

                                <div class="col-xl-3">
                                    <div class="card">
                                        <div class="card-body">

                                            <div class="row justify-content-between">
                                                <div class="col-sm-5">
                                                    <iconify-icon icon="solar:hand-money-bold-duotone" class="fs-36 text-muted"></iconify-icon>
                                                    <h3 class="mb-0 fw-bold mt-2 mb-1">$78.3k</h3>
                                                    <p class="text-muted">Total Expense</p>
                                                    <span class="badge fs-12 badge-soft-success"><i class="ti ti-arrow-badge-up"></i>8.72%</span>
                                                </div>
                                                <!-- end col -->

                                                <div class="col-sm-7 text-end d-flex flex-column">
                                                    <a href="javascript:void(0);" class="link-reset text-decoration-underline link-offset-2 fw-medium pb-2">View Details
                                                    </a>
                                                    <div class="text-end mt-auto">
                                                        <div id="expenses-chart" data-colors="#465dff"></div>
                                                    </div>
                                                </div>
                                                <!-- end col -->
                                            </div>
                                        </div>
                                        <!-- end card-body -->
                                    </div>
                                    <!-- end card -->
                                </div>
                                <!-- end col -->

                                <div class="col-xl-3">
                                    <div class="card">
                                        <div class="card-body">

                                            <div class="row justify-content-between">
                                                <div class="col-sm-5">
                                                    <iconify-icon icon="solar:hand-money-bold-duotone" class="fs-36 text-muted"></iconify-icon>
                                                    <h3 class="mb-0 fw-bold mt-2 mb-1">$78.3k</h3>
                                                    <p class="text-muted">Total Expense</p>
                                                    <span class="badge fs-12 badge-soft-success"><i class="ti ti-arrow-badge-up"></i>8.72%</span>
                                                </div>
                                                <!-- end col -->

                                                <div class="col-sm-7 text-end d-flex flex-column">
                                                    <a href="javascript:void(0);" class="link-reset text-decoration-underline link-offset-2 fw-medium pb-2">View Details
                                                    </a>
                                                    <div class="text-end mt-auto">
                                                        <div id="expenses-chart" data-colors="#465dff"></div>
                                                    </div>
                                                </div>
                                                <!-- end col -->
                                            </div>
                                        </div>
                                        <!-- end card-body -->
                                    </div>
                                    <!-- end card -->
                                </div>
                                <!-- end col -->

                                <div class="col-xl-3">
                                    <div class="card">
                                        <div class="card-body">

                                            <div class="row justify-content-between">
                                                <div class="col-sm-5">
                                                    <iconify-icon icon="solar:hand-money-bold-duotone" class="fs-36 text-muted"></iconify-icon>
                                                    <h3 class="mb-0 fw-bold mt-2 mb-1">$78.3k</h3>
                                                    <p class="text-muted">Total Expense</p>
                                                    <span class="badge fs-12 badge-soft-success"><i class="ti ti-arrow-badge-up"></i>8.72%</span>
                                                </div>
                                                <!-- end col -->

                                                <div class="col-sm-7 text-end d-flex flex-column">
                                                    <a href="javascript:void(0);" class="link-reset text-decoration-underline link-offset-2 fw-medium pb-2">View Details
                                                    </a>
                                                    <div class="text-end mt-auto">
                                                        <div id="expenses-chart" data-colors="#465dff"></div>
                                                    </div>
                                                </div>
                                                <!-- end col -->
                                            </div>
                                        </div>
                                        <!-- end card-body -->
                                    </div>
                                    <!-- end card -->
                                </div>
                                <!-- end col -->

                                <div class="col-xl-3">
                                    <div class="card">
                                        <div class="card-body">

                                            <div class="row justify-content-between">
                                                <div class="col-sm-5">
                                                    <iconify-icon icon="solar:hand-money-bold-duotone" class="fs-36 text-muted"></iconify-icon>
                                                    <h3 class="mb-0 fw-bold mt-2 mb-1">$78.3k</h3>
                                                    <p class="text-muted">Total Expense</p>
                                                    <span class="badge fs-12 badge-soft-success"><i class="ti ti-arrow-badge-up"></i>8.72%</span>
                                                </div>
                                                <!-- end col -->

                                                <div class="col-sm-7 text-end d-flex flex-column">
                                                    <a href="javascript:void(0);" class="link-reset text-decoration-underline link-offset-2 fw-medium pb-2">View Details
                                                    </a>
                                                    <div class="text-end mt-auto">
                                                        <div id="expenses-chart" data-colors="#465dff"></div>
                                                    </div>
                                                </div>
                                                <!-- end col -->
                                            </div>
                                        </div>
                                        <!-- end card-body -->
                                    </div>
                                    <!-- end card -->
                                </div>
                                <!-- end col -->
                            </div>
                            <!-- end row -->

                            <div class="row">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="card-header d-flex flex-wrap align-items-center gap-2">
                                            <h4 class="header-title me-auto mb-0">Overview</h4>

                                            <a href="javascript: void(0);" class="btn btn-soft-primary">Export <i class="ti ti-file-export ms-1"></i>
                                            </a>

                                            <div>
                                                <div class="input-group">
                                                    <input type="text" class="form-control" data-provider="flatpickr" data-deafult-date="Jun to Aug" data-date-format="M Y" data-range-date="true">
                                                    <span class="input-group-text bg-primary border-primary text-white">
                                                        <i class="ti ti-calendar fs-15"></i>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card-body p-0">
                                            <div class="bg-light bg-opacity-50">
                                                <div class="row text-center">
                                                    <div class="col-md col-6">
                                                        <p class="text-muted mt-3 mb-1">Revenue</p>
                                                        <h4 class="mb-3">
                                                            <span class="ti ti-square-rounded-arrow-down text-success me-1"></span>
                                                            <span class="fw-semibold">$29.5k</span>
                                                        </h4>
                                                    </div>
                                                    <div class="col-md col-6">
                                                        <p class="text-muted mt-3 mb-1">Expenses</p>
                                                        <h4 class="mb-3">
                                                            <span class="ti ti-square-rounded-arrow-up text-danger me-1"></span>
                                                            <span class="fw-semibold">$15.07k</span>
                                                        </h4>
                                                    </div>
                                                    <div class="col-md col-6">
                                                        <p class="text-muted mt-3 mb-1">Investment</p>
                                                        <h4 class="mb-3">
                                                            <span class="ti ti-chart-infographic me-1"></span>
                                                            <span class="fw-semibold">$3.6k</span>
                                                        </h4>
                                                    </div>
                                                    <div class="col-md col-6">
                                                        <p class="text-muted mt-3 mb-1">Savings</p>
                                                        <h4 class="mb-3">
                                                            <span class="ti ti-pig me-1"></span>
                                                            <span class="fw-semibold">$6.9k</span>
                                                        </h4>
                                                    </div>
                                                </div>
                                            </div>

                                            <div dir="ltr" class="p-2">
                                                <div id="balance-overview" class="apex-charts" data-colors="#465dff,#6ac75a,#f9c45c"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- end col -->
                    </div>
                    <!-- end row -->

               
                <!-- container -->

                <!-- Footer Start -->
                <footer class="footer">
                    <div class="page-container">
                        <div class="row">
                            <div class="col-md-12 text-center">
                                <script>document.write(new Date().getFullYear())</script>
                                © Created - By  <span class="fw-bold text-decoration-underline text-uppercase text-reset fs-12"><a href="https://excelgeomatics.com/" style="color: #077f39;" target="_blank">Excel Geomatices Pvt.Ltd</a></span>
                            </div>
                        </div>
                    </div>
                </footer>
                <!-- end Footer -->
    <script src="../GIS/js/ol.js"></script>
      <script src="../GIS/js/jquery.min.js"></script>
    <script src="../web/js/dashboad_temp.js"></script>
</asp:Content>
