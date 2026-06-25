<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="hwcApplicantDashboard.aspx.cs" Inherits="uk_forest.Forest.hwcApplicantDashboard" ClientIDMode="Static" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <title>Human-Wildlife Conflict Dashboard</title>

    <!-- Bootstrap & Icons -->
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />--%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css">

    




    <style>
        html,
        body {
            width: 100vw;
            min-height: 100vh;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            background: #f4f6f8;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }

        .filterrow .form-label {
            font-weight: 600;
        }

        .dashboard-container {
            padding: 5px;
        }

        .card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 6px 6px 12px #bec8d2, -6px -6px 12px #ffffff;
            padding: 0rem;
            position: relative;
            transition: all 0.3s ease-in-out;
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 10px 10px 20px #b0b9c6, -10px -10px 20px #ffffff;
        }

        .card .icon {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 2.5rem;
            color: #dee3eb;
        }

        .card-title {
            font-weight: 700;
            font-size: 1.2rem;
            color: #2f3e54;
            margin-bottom: 0.4rem;
        }

        .card-number {
            font-weight: 800;
            font-size: 2.5rem;
            color: #1a202c;
            margin-top: 0.5rem;
        }

        .bg-total {
            background: #e0f2fe;
            color: #0369a1;
        }

        .bg-active {
            background: #fef3c7;
            color: #92400e;
        }

        .bg-pending {
            background: #fee2e2;
            color: #991b1b;
        }

        .bg-solved {
            background: #dcfce7;
            color: #166534;
        }

        /* Default icon style */
        .card .icon {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 2.5rem;
            color: #dee3eb;
            transition: color 0.3s ease;
        }

        /* Highlight icon on card hover */
        .card:hover .icon {
            color: #0d6efd;
            /* Bootstrap Primary color or any color you prefer */
        }

        #map {
            width: 100%;
            height: 450px;
            /* Full height */
            position:relative;
            overflow: hidden;
            border-radius: 16px;
            box-shadow: 6px 6px 12px #bec8d2, -6px -6px 12px #ffffff;
        }

        .mastertable{
             width: 100%;
            height: 400px;
            /* Full height */
            overflow: auto;
            white-space:nowrap;
            border-radius: 16px;
            box-shadow: 6px 6px 12px #bec8d2, -6px -6px 12px #ffffff;
        }

        /* Tooltip styles */
        .ol-tooltip {
            position: absolute;
            background: rgba(0, 0, 0, 0.75);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            white-space: nowrap;
            pointer-events: none;
            font-size: 0.9rem;
            transition: opacity 0.3s ease;
            opacity: 0;
        }

        .ol-tooltip.hidden {
            opacity: 0;
            pointer-events: none;
        }

        .ol-tooltip:not(.hidden) {
            opacity: 1;
        }

        @media (max-width: 576px) {
            .card-number {
                font-size: 2rem;
            }

            .card .icon {
                font-size: 2rem;
            }
        }
        .page-container{
            padding:0 !important;
        }
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
          .sticky-header th {
        position: sticky;
        top: 0;
        background-color: #f8f8f8;
        z-index: 1;
    }

    /* Optional: Scrollable container if needed */
    .grid-container {
        max-height: 400px;
        overflow-y: auto;
    }

    .sticky-header th, .sticky-header td {
        padding: 8px;
        border: 1px solid #ccc;
        background-color: #068865;
    color: white;
    }
    .chart canvas{
        width: 100%; height: 220px !important; background: #fff; border-radius: 16px; box-shadow: 6px 6px 12px #bec8d2, -6px -6px 12px #ffffff;margin-bottom:10px;
    }
        .maplegend {
            position: absolute;
            z-index: 1;
            background-color: white;
            padding: 10px;
            bottom: 0px;
            right: 0px;
            display:none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" />
 

    




    <br />



    <div class="dashboard-container">


        <asp:HiddenField runat="server" ID="totalcase" />
        <asp:HiddenField runat="server" ID="activecase" />
        <asp:HiddenField runat="server" ID="pendingcase" />
        <asp:HiddenField runat="server" ID="inprocesscase" />
        <asp:HiddenField runat="server" ID="solvedcase" />
        <!-- Filter Row -->
          <asp:UpdatePanel runat="server" ID="UpdatePanel3">
            <ContentTemplate>
        <div class="row align-items-end mb-2 filterrow w-100">
            <div class="col-md-4 col-lg-2">
                <label for="dataType" class="form-label">Conflict Category</label>
                <asp:DropDownList ID="ddlDataType" runat="server" CssClass="form-select shadow-sm">
                    <asp:ListItem Text="Human" Value="Human" />
                    <asp:ListItem Text="Cattle" Value="Cattle" />
                    <asp:ListItem Text="Crop" Value="Crop" />
                    <asp:ListItem Text="House" Value="House" />

                </asp:DropDownList>
            </div>
            <div class="col-md-4 col-lg-2">
                <asp:Label ID="lblStartDate" runat="server" AssociatedControlID="txtStartDate" CssClass="form-label" Text="Start Date"></asp:Label>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control shadow-sm" TextMode="Date" />
            </div>
            <div class="col-md-4 col-lg-2">
                <asp:Label ID="lblEndDate" runat="server" AssociatedControlID="txtEndDate" CssClass="form-label" Text="End Date"></asp:Label>
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control shadow-sm" TextMode="Date" />
            </div>
           

            <div class="col-md-4 col-lg-2">
                <asp:Label runat="server" CssClass="form-label d-block " Text="Division"></asp:Label>
                  <asp:DropDownList ID="ddlDivision" runat="server" CssClass="form-select shadow-sm" OnSelectedIndexChanged="ddlDivision_SelectedIndexChanged"
                                AutoPostBack="true" >
                    
                </asp:DropDownList>
            </div>

            <div class="col-md-4 col-lg-2">
                <asp:Label runat="server" CssClass="form-label d-block " Text="Range"></asp:Label>
                 <asp:DropDownList ID="ddlRange" runat="server" CssClass="form-select shadow-sm">
                  

                </asp:DropDownList>
            </div>

             <div class="col-md-4 col-lg-2">
                <asp:Label runat="server" CssClass="form-label d-block invisible" Text="Search"></asp:Label>
                <asp:Button ID="btnFilter" runat="server" Text="Filter" OnClick="btnFilter_Click" CssClass="btn btn-primary w-100 shadow-sm" />
            </div>
        </div>
                   </contenttemplate>
           
        </asp:updatepanel>
         <%-- </contenttemplate>
           
        </asp:updatepanel>--%>
        <!-- Cards Grid -->
       <%-- <div class="row g-4">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card bg-total">
                    <div class="icon"><i class="bi bi-clipboard-data"></i></div>
                    <h2 class="card-title">Total Cases</h2>
                    <div class="card-number" id="totalCases">0</div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card bg-active">
                    <div class="icon"><i class="bi bi-broadcast-pin"></i></div>
                    <h2 class="card-title">Active Cases</h2>
                    <div class="card-number" id="activeCases">0</div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card bg-pending">
                    <div class="icon"><i class="bi bi-hourglass-split"></i></div>
                    <h2 class="card-title">Pending Cases</h2>
                    <div class="card-number" id="pendingCases">0</div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-lg-3">
                <div class="card bg-solved">
                    <div class="icon"><i class="bi bi-check-circle"></i></div>
                    <h2 class="card-title">Solved Cases</h2>
                    <div class="card-number" id="solvedCases">0</div>
                </div>
            </div>
        </div>--%>
     <div class="d-flex flex-nowrap justify-content-between" style="gap: 1rem;">

  <!-- Total Cases -->
  <div class="card bg-total text-white text-center" style="width: 20%;">
    <div class="icon mt-4"><i class="bi bi-clipboard-data" style="font-size: 2.5rem;"></i></div>
    <h2 class="card-title mt-2">Total Cases</h2>
    <div class="card-number display-6 mb-4" id="totalCases">0</div>
  </div>

  <!-- Active Cases -->
  <div class="card bg-active text-white text-center" style="width: 20%;">
    <div class="icon mt-4"><i class="bi bi-broadcast-pin" style="font-size: 2.5rem;"></i></div>
    <h2 class="card-title mt-2">Active Cases</h2>
    <div class="card-number display-6 mb-4" id="activeCases">0</div>
  </div>

  <!-- Pending Cases -->
  <div class="card bg-pending text-white text-center" style="width: 20%;">
    <div class="icon mt-4"><i class="bi bi-hourglass-split" style="font-size: 2.5rem;"></i></div>
    <h2 class="card-title mt-2">Pending Cases</h2>
    <div class="card-number display-6 mb-4" id="pendingCases">0</div>
  </div>

  <!-- In-Process Cases -->
  <div class="card bg-warning text-white text-center" style="width: 20%;">
    <div class="icon mt-4"><i class="bi bi-arrow-repeat" style="font-size: 2.5rem;"></i></div>
    <h2 class="card-title mt-2">In-Process Cases</h2>
    <div class="card-number display-6 mb-4" id="inprocessCases">0</div>
  </div>

  <!-- Solved Cases -->
  <div class="card bg-solved text-white text-center" style="width: 20%;">
    <div class="icon mt-4"><i class="bi bi-check-circle" style="font-size: 2.5rem;"></i></div>
    <h2 class="card-title mt-2">Solved Cases</h2>
    <div class="card-number display-6 mb-4" id="solvedCases">0</div>
  </div>

</div>


        <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
            <ContentTemplate>


        <div class="row g-2">
            <!-- Map Section -->
            <div class="col-lg-7 col-12">
                <div id="map">
                    <div id="maplegend" class="maplegend">
                        <div style="font-family: Arial, sans-serif;">
  <div style="display: flex; align-items: center; margin-bottom: 8px;">
    <span style="height: 15px; width: 15px; background-color: red; border-radius: 50%; display: inline-block; margin-right: 8px;"></span>
    <span>Pending cases</span>
  </div>
  <div style="display: flex; align-items: center; margin-bottom: 8px;">
    <span style="height: 15px; width: 15px; background-color: #ffae4f; border-radius: 50%; display: inline-block; margin-right: 8px;"></span>
    <span>In-Process cases</span>
  </div>
  <div style="display: flex; align-items: center;">
    <span style="height: 15px; width: 15px; background-color: green; border-radius: 50%; display: inline-block; margin-right: 8px;"></span>
    <span>Solved cases</span>
  </div>
</div>

                    </div>
                </div>
            </div>

            <!-- Line Chart Section -->
            <div class="col-lg-5 col-12 chart">
                <div>
                    <canvas id="caseLineChart"></canvas>
                </div>
                <div>
                    <canvas id="caseLineChartbar"></canvas>
                </div>

            </div>
        </div>  
                </ContentTemplate></asp:UpdatePanel>
                <%--<asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
            <ContentTemplate>
      --%>
                 <div class="row g-2 mt-1">
            <!-- Map Section -->
            <div class="col-lg-12 col-12">
                <div class="mastertable">
                         <asp:UpdatePanel runat="server" ID="upd">
            <ContentTemplate>
                    <asp:GridView runat="server" ID="grdmastertable" AutoGenerateColumns="False" CssClass="table table-bordered" UseAccessibleHeader="True" HeaderStyle-CssClass="sticky-header" DataKeyNames="incidentId">
                       
                            <columns>
                                <asp:TemplateField HeaderText="S.No">
                                    <itemtemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Conflict Type">
                                    <itemtemplate>
                                        <%# Eval("conflictType") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Incident ID">
                                    <itemtemplate>
                                        <%# Eval("incidentId") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Incident Date">
                                    <itemtemplate>
                                        <%# Eval("incidentDate", "{0:yyyy-MM-dd}") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Incident Place">
                                    <itemtemplate>
                                        <%# Eval("incidentPlace") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Caused By">
                                    <itemtemplate>
                                        <%# Eval("animalName") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Activity" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("activity") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Incident Summary" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("incidentSummary") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Human Loss">
                                    <itemtemplate>
                                        <%# Eval("humanLoss") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Location" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("location") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Latitude">
                                    <itemtemplate>
                                        <%# Eval("latitude") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Longitude">
                                    <itemtemplate>
                                        <%# Eval("longitude") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Status">
                                    <itemtemplate>
                                        <%# Eval("status") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Victim Profile ID" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("victimProfileId") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Victim Profile Name" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("victimProfileName") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Applicant ID" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("applicantId") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Applicant Name">
                                    <itemtemplate>
                                        <%# Eval("applicantName") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Range ID" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("rangeId") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Range Name">
                                    <itemtemplate>
                                        <%# Eval("rangeName") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Sub Division ID" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("subDivisionId") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Sub Division Name" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("subDivisionName") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Division ID" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("divisionId") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Division Name" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("divisionName") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Conflict Category" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("conflictCategory") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Animal Name" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("animalName") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Animal Name" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("localName") %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Remark" Visible="false">
                                    <itemtemplate>
                                        <%# Eval("remark") %>
                                    </itemtemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField >
                                    <itemtemplate>
                                        <asp:Button runat="server" ID="btnshowCase" OnClick="btnshowCase_Click" Text="View" />
                                       <%--<asp:Button >View</asp:Button>--%>
                                    </itemtemplate>
                                </asp:TemplateField>
                            </columns>
                        <EmptyDataTemplate>
                            <div style="text-align: center; color: red;">
                                No records found.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                
                  </contenttemplate>
           
        </asp:updatepanel>
                </div>
            </div>

            <!-- Line Chart Section -->
         

        </div>
          <asp:UpdatePanel runat="server" ID="UpdatePanel2">
            <ContentTemplate>
                <div runat="server" id="popup" visible="false" style="display:none; width: 85.5vw;
    border: 2px solid red;
    height: 100%;
    background-color: #00000082;
    position: absolute;
    top: 4px;
    z-index: 11111;
    left: 0;">
                    

                    <div   class="container p-4 border bg-white shadow-sm" style="font-family: Arial, sans-serif;font-size: 20px; line-height: 1.6;overflow: auto;
    max-height: 920px;width: 60%;">
                      <%--  <asp:Button ID="btnclosepopup" runat="server" style="cursor:pointer;padding: 5px 10px;
    border: 1px solid red;
    position: relative;
    float: right;
    background-color: red;
    color: white;
    font-weight: 700;" OnClick="btnclosepopup_Click" Text="X"/>--%>

                         <Button ID="Button1" type="button" style="cursor:pointer;padding: 5px 10px;
    border: 1px solid red;
    position: relative;
    float: right;
    background-color: red;
    color: white;
    font-weight: 700;" Text="X" onclick="closeincidentreport()">X</Button>
    <h2 class="text-center mb-4" style="font-size: 40px;
    font-weight: 700;">Incident Report</h2>

    <!-- 1. Incident Details -->
    <h4 class="border-bottom pb-2 mb-3">1. Incident Details</h4>
    <div class="row">
        <div class="col-md-6"><strong>Incident ID:</strong> <asp:Label ID="lblIncidentId" runat="server" /></div>
        <div class="col-md-6"><strong>Date:</strong> <asp:Label ID="lblIncidentDate" runat="server" /></div>
        <div class="col-md-6"><strong>Place:</strong> <asp:Label ID="lblIncidentPlace" runat="server" /></div>
        <div class="col-md-6"><strong>Activity:</strong> <asp:Label ID="lblActivity" runat="server" /></div>
        <div class="col-md-6"><strong>Status:</strong> <asp:Label ID="lblStatus" runat="server" /></div>
        <div class="col-md-6"><strong>Latitude:</strong> <asp:Label ID="lblLatitude" runat="server" /></div>
        <div class="col-md-6"><strong>Longitude:</strong> <asp:Label ID="lblLongitude" runat="server" /></div>
    </div>

    <!-- 2. Victim Details -->
    <h4 class="border-bottom pb-2 mt-4 mb-3">2. Victim Details</h4>
    <div class="row">
        <div class="col-md-6"><strong>Name:</strong> <asp:Label ID="lblVictimName" runat="server" /></div>
        <div class="col-md-6"><strong>Age:</strong> <asp:Label ID="lblVictimAge" runat="server" /></div>
        <div class="col-md-6"><strong>Gender:</strong> <asp:Label ID="lblVictimGender" runat="server" /></div>
        <div class="col-md-6"><strong>Aadhaar No:</strong> <asp:Label ID="lblVictimAadhar" runat="server" /></div>
    </div>

    <!-- 3. Applicant Details -->
    <h4 class="border-bottom pb-2 mt-4 mb-3">3. Applicant Details</h4>
    <div class="row">
        <div class="col-md-6"><strong>Name:</strong> <asp:Label ID="lblApplicantName" runat="server" /></div>
        <div class="col-md-6"><strong>Mobile:</strong> <asp:Label ID="lblApplicantMobile" runat="server" /></div>
        <div class="col-md-6"><strong>Address:</strong> <asp:Label ID="lblApplicantAddress" runat="server" /></div>
        <div class="col-md-6"><strong>Aadhaar No:</strong> <asp:Label ID="lblApplicantAadhar" runat="server" /></div>
    </div>

    <!-- 4. Conflict Animal -->
    <h4 class="border-bottom pb-2 mt-4 mb-3">4. Conflict Animal</h4>
    <div class="row">
        <div class="col-md-6"><strong>Animal:</strong> <asp:Label ID="lblAnimalName" runat="server" /></div>
        <div class="col-md-6"><strong>Local Name:</strong> <asp:Label ID="lblAnimalLocalName" runat="server" /></div>
        <div class="col-md-6"><strong>Conflict Type:</strong> <asp:Label ID="lblConflictCategory" runat="server" /></div>
    </div>

    <!-- 5. Location Info -->
    <h4 class="border-bottom pb-2 mt-4 mb-3">5. Location Information</h4>
    <div class="row">
        <div class="col-md-6"><strong>Range:</strong> <asp:Label ID="lblRange" runat="server" /></div>
        <div class="col-md-6"><strong>Sub Division:</strong> <asp:Label ID="lblSubDivision" runat="server" /></div>
        <div class="col-md-6"><strong>Division:</strong> <asp:Label ID="lblDivision" runat="server" /></div>
        <div class="col-md-6"><strong>Circle:</strong> <asp:Label ID="lblCircle" runat="server" /></div>
        <div class="col-md-6"><strong>Zone:</strong> <asp:Label ID="lblZone" runat="server" /></div>
    </div>

    <!-- 6. Payment Details -->
    <h4 class="border-bottom pb-2 mt-4 mb-3">6. Payment Details</h4>
    <div class="row">
        <%--<div class="col-md-6"><strong>Advance Payment:</strong> <asp:Label ID="lblAdvancePayment" runat="server" /></div>
        <div class="col-md-6"><strong>Remaining Payment:</strong> <asp:Label ID="lblRemainingPayment" runat="server" /></div>--%>

        <h5 style="font-size: 22px;">Advance Payment Details</h5>
<div class="row">
    <div class="col-md-6"><strong>Amount:</strong> <asp:Label ID="lblAdvanceAmount" runat="server" /></div>
    <div class="col-md-6"><strong>Status:</strong> <asp:Label ID="lblAdvanceStatus" runat="server" /></div>
    <div class="col-md-6"><strong>Mode:</strong> <asp:Label ID="lblAdvanceMode" runat="server" /></div>
    <div class="col-md-6"><strong>Reference No:</strong> <asp:Label ID="lblAdvanceReference" runat="server" /></div>
    <div class="col-md-6"><strong>Date:</strong> <asp:Label ID="lblAdvanceDate" runat="server" /></div>
    <div class="col-md-6"><strong>Remarks:</strong> <asp:Label ID="lblAdvanceRemarks" runat="server" /></div>
</div>

<!-- Remaining Payment Section -->
<h5 style="font-size: 22px;">Remaining Payment Details</h5>
<div class="row">
    <div class="col-md-6"><strong>Amount:</strong> <asp:Label ID="lblRemainingAmount" runat="server" /></div>
    <div class="col-md-6"><strong>Status:</strong> <asp:Label ID="lblRemainingStatus" runat="server" /></div>
    <div class="col-md-6"><strong>Mode:</strong> <asp:Label ID="lblRemainingMode" runat="server" /></div>
    <div class="col-md-6"><strong>Reference No:</strong> <asp:Label ID="lblRemainingReference" runat="server" /></div>
    <div class="col-md-6"><strong>Date:</strong> <asp:Label ID="lblRemainingDate" runat="server" /></div>
    <div class="col-md-6"><strong>Remarks:</strong> <asp:Label ID="lblRemainingRemarks" runat="server" /></div>
</div>
    </div>

    <!-- 7. Document Details -->
    <h4 class="border-bottom pb-2 mt-4 mb-3">7. Documents</h4>
                        <div class="row">
                            <div class="col-md-12">
                                <strong>Photograph:</strong><br />
                                <%--<asp:Label ID="lblPhotographDoc" runat="server" />--%>
                                 <div style="width: 100%;overflow:auto;text-align: center;">
                                      <img id="PhotographDoc" runat="server" src="" alt="Alternate Text" />
                                </div>
                            </div>
                            
                           
                        </div>

                          <div class="row">
                         
                            <div class="col-md-12">
                                <strong>Village Head Certificate:</strong><br />
                                <%--<asp:Label ID="lblVillageHeadCert" runat="server" />--%>
                                <div style="width: 100%;overflow:auto;text-align: center;">
                                    <img runat="server" id="VillageHeadCert" src="" alt="Alternate Text" />
                                </div>
                            </div>
                        </div>

</div>
                </div>
                 
          
           </contenttemplate>
           
        </asp:updatepanel>

        <style>
            h4 {
                background-color: #068469;
                padding: 8px;
                color: white;
                    font-size: 25px;
            }
        </style>
       


    </div>

     <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
     <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="hwcApplicantDashboard.js"></script>
    <!-- Scripts -->
    <script>

    </script>
   
    <script>

</script>
   
    
</asp:Content>

