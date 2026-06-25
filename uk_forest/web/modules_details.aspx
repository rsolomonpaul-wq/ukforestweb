<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FMIS</title>
    <link rel="shortcut icon" href="../admin/assets/images/favicon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp">
    <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css" />
    <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>
    <link rel="stylesheet" href="./admin/assets/css/icons.min.css">
    <link rel="stylesheet" href="css/style.css">
    
  </head>
  <body>
    
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

     <section class="modules section-services">
        <div class="container-fluid">
             <div class="row">
                <div class="col-lg-3 col-md-3 col-sm-12 col-12">
                    <div class="sideBarAssets">
                           
                            <div id="map"></div>
                            <script>

                                var map = new ol.Map({
                                    target: 'map',
                                    controls: ol.control.defaults().extend([
                                        new ol.control.FullScreen(),
                                        new ol.control.ScaleLine()
                                    ]),
                                    layers: [
                                        new ol.layer.Tile({
                                            source: new ol.source.OSM()
                                        })
                                    ],
                                    view: new ol.View({
                                        center: ol.proj.fromLonLat([79.0193, 30.0668]), // Longitude, Latitude
                                        zoom: 8
                                    })
                                });
                            </script>
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
                                                            <div class="iconPic"><img src="../images/modules/dss.png" alt=""></div>
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
                                </div>
                        
                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box2">
                                                <div class="iconPic"><img src="../images/modules/sfm.png" alt=""></div>
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
                                </div>
                        
                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box3">
                                                <div class="iconPic"><img src="../images/modules/pm_icon.png" alt=""></div>
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
                                </div>
                        
                                <div class="flip-box alternative me-0">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic"><img src="../images/modules/HWC.png" alt=""></div>
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
                                </div>

                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic"><img src="../images/modules/sp_icon.png" alt=""></div>
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
                                </div>


                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic"><img src="../images/modules/vl_icon.png" alt=""></div>
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
                                </div>


                                <div class="flip-box alternative">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic"><img src="../images/modules/Rm_icon.png" alt=""></div>
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
                                </div>


                                <div class="flip-box alternative me-0">
                                    <div class="object">
                                    <div class="front">
                                        <div class="flip-content">
                                            <div class="front-box box4">
                                                <div class="iconPic"><img src="../images/modules/tw_icon.png" alt=""></div>
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
                                </div>

                            </div>
                        </div>



                     </div> 
                </div>
             </div>
        </div>
     </section>

<section class="filterSection">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="filterContent">
                   <div class="GroupList">
                     <label for="">Year</label>
                        <select name="" id="">
                            <option value="">2020</option>
                            <option value="">2021</option>
                            <option value="">2022</option>
                            <option value="">2023</option>
                            <option value="">2024</option>
                        </select>
                   </div>
                   <div class="GroupList">
                    <label for="">Zone</label>
                       <select name="" id="">
                           <option value="">Kumaun</option>
                           <option value="">Garhwal</option>
                           <option value="">Wildlife</option>
                       </select>
                  </div>
                  <div class="GroupList">
                    <label for="">Circles</label>
                       <select name="" id="">
                           <option value="">North Kumaun</option>
                           <option value="">South Kumaun</option>
                           <option value="">Western</option>
                       </select>
                  </div>
                   <div class="GroupList">
                    <label for="">Division</label>
                       <select name="" id="">
                           <option value="">Almora Forest Division</option>
                           <option value="">Bageshwar  Forest Division</option>
                           <option value="">Champawat Forest Division</option>
                           <option value="">CS Almora Forest Division</option>
                           <option value="">Pithoragarh Forest Division</option>
                       </select>
                  </div>
                  <div class="GroupList">
                    <label for="">Content</label>
                       <select name="" id="">
                           <option value="">453534</option>
                           <option value="">453534</option>
                           <option value="">453534</option>
                           <option value="">453534</option>
                           <option value="">453534</option>
                       </select>
                  </div>
                </div>
            </div>
        </div>
    </div>
</section>


     <section class="chartColumns">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12 col-md-12 col-sm-12 col-12">
                    <div class="chartBox">
                        <img src="../images/chart-1.png" alt="chart image" class="img-fluid">
                    </div>
                </div>
            </div>
        </div>
     </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="js/script.js"></script>
  </body>
</html>

