<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="aboutus.aspx.cs" Inherits="uk_forest.web.aboutus" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="https://fonts.googleapis.com/css2?family=Host+Grotesk:ital,wght@0,300..800;1,300..800&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet" />
    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }
        body {
              font-family: "Host Grotesk", sans-serif !important;
              overflow: hidden !important;
            }
        #header {
            width: 100%;
            background-color: #fff;
            box-shadow:0px 3px 10px #a7a7a71c;
        }

        .headAssets {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .container-fluid {
            margin: 0 30px;
            width: calc(100% - 60px);
        }

        .logo img {
            width: 200px;
        }

        .ministryLogo {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
        }

        .l_1 img {
            width: 130px;
        }

        .l_2 img {
            width: 170px;
        }
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
          letter-spacing: 1px;
         text-transform: uppercase;
        }
        .aboutSection {
          background-color: #fff;
  box-shadow: 0px 0px 5px #d3d3d396;
  padding: 30px;
  margin: 30px 40px 70px 30px;
  overflow-y: auto;
  height: 500px;
  text-align: justify;
        }
         .aboutSection p{
             margin-bottom:20px;
             font-size:16px;
         }


         footer.FooterColumn1 {
              padding: 0;
              text-align: center;
              background-color: #ffffff;
              color: #000000;
              position: fixed;
              bottom: 0;
              width: 100%;
              border-top: 1px solid #eee;
              z-index:1200;
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

          .navbar {
            background-color: #e4f3ff;
            overflow: hidden;
            padding: 0 !important;
            justify-content: center !important;
            display:flex;
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
                 text-decoration: none;
            }

                .navbar a:hover {
                    background-color: #ddd;
                }

                .navbar a.active {
                    background-color: #4CAF50; /* Highlighted green */
                    color: white;
                }
    </style>
</head>
<body>
    <form id="form1" runat="server">
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

        <!-- ======== About Section ========-->

        <section class="aboutSection">
            <div class="aboutCol1">
                <p>Restore, Conserve and Protect Forest and Tree Cover for NDC Implementation in India (RECAP4NDC) is an Indo-German development cooperation project that the Deutsche Gesellschaft für Internationale Zusammenarbeit (GIZ) GmbH implements on behalf of the Federal Ministry for the Environment, Climate Action, Nature Conservation and Nuclear Safety (BMUKN) under the International Climate Initiative (IKI) of the German Federal Government. The project was launched in July 2023 by the Union Minister for Environment, Forest and Climate Change, Shri. Bhupender Yadav and Ms. Steffi Lemke, former German Federal Minister for the Environment, Nature Conservation, Nuclear Safety and Consumer Protection at the Environment, Climate and Sustainability Working Group (ECSWG) meeting under G20 in Chennai.</p>

                <p><b>Objective of RECAP4NDC:</b> Stakeholders at national, regional and local levels have derived ecological, socio-economic, governance, and climate change related benefits from Forest Landscape Restoration (FLR). </p>

                <p>RECAP4NDC contributes to the Joint Declaration of Intent (JDI) on FLR signed between the Indian and the German Governments in May 2022. This JDI aims to deepen cooperation on Bonn Challenge through FLR and pilot new models in forestry and trees outside forests. It also aims to strengthen cooperation to restore and protect India’s forests as an important measure to reduce poverty; preserve and restore biodiversity and healthy ecosystems; improve resilience and ecosystem services like water availability; and attenuate the impacts of climate change. The project is being implemented in Uttarakhand as well as Maharashtra, Gujarat, and Delhi NCR.</p>

                <p>The political and implementation partners of the project are the Ministry of Environment, Forest and Climate Change (MoEF&CC) and the State Forest Departments (SFD) respectively, along with other line departments such as Agriculture, Horticulture and Rural Development which are crucial for agroforestry, development of value-chains and upscaling of FLR. The partners will support, oversee, coordinate and guide the implementation of project. The activities of the project will be carried out by a group of six consortium partners i.e., the International Union for Conservation of Nature (IUCN), the Indian Council of Forestry Research and Education (ICFRE), the Forest Survey of India (FSI), The Energy and Resources Institute (TERI), the International Centre for Integrated Mountain Development (ICIMOD) and GIZ being the lead partner of the project.</p>

                <p><b>To know more:</b> <a href="#!"> Restore, Conserve and Protect Forest and Tree Cover for NDC Implementation in India | Internationale Klimaschutzinitiative (IKI)</a></p>
                <p><a href="#!"> Restore Conserve and Protect Forest and Tree Cover for NDC Implementation in India (RECAP4NDC) | GIZ</a></p>
                <p><b>RECAP4NDC LinkedIn Page: </b> <a href="#!"> (27) RECAP4NDC: Overview | LinkedIn</a></p>

            </div>   
        </section>


            <footer class="FooterColumn1">
                <div class="footerContt">
                    <div class="f_logo1"><a href="#!"><img src="../admin/assets/images/federal_logo.jpg" alt="footer logo" /></a></div>
                    <div class="f_logo2"><a href="#!"><img src="../admin/assets/images/iki_logo.jpg" alt="giz logo" /></a></div>
                    <div class="f_logo3"><a href="#!"><img src="../admin/assets/images/giz_logo.jpg" /></a></div>
                </div>  
            </footer>

    </form>
</body>
</html>
