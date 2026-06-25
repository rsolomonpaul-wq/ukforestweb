<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/wildlife.Master" AutoEventWireup="true" CodeBehind="VictimIncidentForm.aspx.cs" Inherits="uk_forest.Forest.VictimIncidentForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Victim & Incident Detail</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css" />
    <style>
        .form-section {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .form-header {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
        }

        .radio-list label {
            margin-right: 15px;
        }

        .btn-submit {
            background-color: #3498db;
            border-color: #3498db;
            padding: 8px 25px;
            font-weight: 600;
        }

            .btn-submit:hover {
                background-color: #2980b9;
                border-color: #2980b9;
            }

        .btn-add {
            background-color: #2ecc71;
            border-color: #2ecc71;
            padding: 5px 15px;
            font-weight: 600;
        }

            .btn-add:hover {
                background-color: #27ae60;
                border-color: #27ae60;
            }

             #map {
    width: 100%;
    height: 400px; /* Or 100vh or whatever height you want */
  }
             .ol-collapsed{
                 display:none !important; 
             }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="form-section">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3 class="form-header m-0">Victim & Incident Detail</h3>
                <asp:LinkButton ID="lnkViewDetails" runat="server" CssClass="btn btn-outline-primary" OnClick="lnkViewDetails_Click">
        <i class="fas fa-eye"></i> View Details
                </asp:LinkButton>
            </div>

            <div class="row mb-3">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Human Loss:</label>
                        <asp:RadioButtonList ID="rblHumanLoss" runat="server" RepeatDirection="Horizontal" CssClass="radio-list">
                            <asp:ListItem Text="Injured" Value="Injured" />
                            <asp:ListItem Text="Deceased" Value="Deceased" />
                        </asp:RadioButtonList>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Division:</label>
                        <div class="custom-dropdown">
                            <asp:DropDownList ID="ddlDivision" runat="server"
                                CssClass="form-control"
                                OnSelectedIndexChanged="ddlDivision_SelectedIndexChanged"
                                AutoPostBack="true" />
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Range:</label>
                        <div class="custom-dropdown">
                            <asp:DropDownList ID="ddlRange" runat="server" CssClass="form-control" onchange="getrange(this)"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Incident Date:</label>
                        <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Incident Time:</label>
                        <asp:TextBox ID="txtTime" runat="server" TextMode="Time" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Incident Place:</label>
                        <asp:TextBox ID="txtPlace" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Animal Type:</label>
                        <asp:DropDownList ID="ddlAnimalType" runat="server" CssClass="form-control" />
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Victim Name:</label>
                        <asp:TextBox ID="txtVictimName" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Victim Gender:</label>
                        <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal" CssClass="radio-list">
                            <asp:ListItem Text="Male" Value="Male" />
                            <asp:ListItem Text="Female" Value="Female" />
                        </asp:RadioButtonList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Victim Age:</label>
                        <asp:TextBox ID="txtVictimAge" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Victim Aadhar:</label>
                        <asp:TextBox ID="txtVictimAadhar" runat="server" CssClass="form-control" />
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Victim Aadhar Document:</label>
                        <asp:FileUpload ID="fuAadharDoc" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Person Activity:</label>
                        <asp:TextBox ID="txtActivity" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Latitude:</label>
                        <asp:TextBox ID="txtLat" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label">Longitude:</label>
                        <asp:TextBox ID="txtLong" runat="server" CssClass="form-control" />
                    </div>
                </div>
            </div>

          <%--  <div class="row mb-3">
                <div class="col-md-12">
                    <div class="form-group">
                        <label class="form-label">Incident Summary:</label>
                        <asp:TextBox ID="txtSummary" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" />
                    </div>
                </div>
            </div>--%>
               <div class="row mb-3">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="form-label">Incident Summary:</label>
                        <asp:TextBox ID="txtSummary" runat="server" TextMode="MultiLine" Rows="15" CssClass="form-control" />
                    </div>
                  
                </div>
                
                <div class="col-md-6">
                    <script src="../GIS/js/jquery.min.js"></script>
  
                    <div class="form-group">
                        <div id="mapdiv" style="display: block;">
                             <label class="form-label">NOTE : Find your location and click on map to get 'Latitude' and 'Longitude' automatic. </label>
                        <div id="map" style="width: 100%; height: 310px;"></div>
                             
                         </div>
                        </div>
                         
                    
                    </div>
                </div>
        </div>

        <div class="form-section">
            <h4 class="form-header">Upload Documents</h4>
            <asp:UpdatePanel ID="upDocuments" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

                    <asp:GridView ID="gvDocuments" runat="server" AutoGenerateColumns="False"
                        OnRowCommand="gvDocuments_RowCommand"
                        OnRowDataBound="gvDocuments_RowDataBound"
                        CssClass="table table-bordered table-striped" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="SNo" HeaderText="S.No" ItemStyle-Width="50px" />
                            <asp:TemplateField HeaderText="Document Type">
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlDocType" runat="server" CssClass="form-control" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Upload Document">
                                <ItemTemplate>
                                    <asp:FileUpload ID="fuDoc" runat="server" CssClass="form-control" />
                                    <asp:Literal ID="litFileDisplay" runat="server"
                                        Text='<%# GetFileDisplay(Eval("FileName")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action" ItemStyle-Width="100px">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CommandName="DeleteRow"
                                        CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-danger btn-sm" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <asp:LinkButton ID="lnkAddRow" runat="server" Text="Add Row" OnClick="lnkAddRow_Click"
                        CssClass="btn btn-add" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <div class="text-center mt-4">
            <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" CssClass="btn btn-submit" />
        </div>
    </div>

    <script type="text/javascript">
        function pageLoad() {
            // Handle delete button clicks with AJAX
            $('[id*=lnkDelete]').click(function () {
                // You can add confirmation dialog here if needed
                // return confirm('Are you sure you want to delete this document?');
                return true;
            });
        }

        // Prevent form submission on Enter key in textboxes
        $(document).ready(function () {
            $("input[type=text]").keypress(function (e) {
                if (e.which == 13) {
                    e.preventDefault();
                }
            });
        });
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('<%= txtDate.ClientID %>').max = today;

            document.getElementById('<%= txtDate.ClientID %>').addEventListener('change', function () {
                if (this.value > today) {
                    alert('Future dates are not allowed');
                    this.value = today; // Reset to today
                }
            });
        });
    </script>


      <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <script>


        var geoserver_ip = "https://ukforestgis.in/geoserver/uk_sfd/wms?";
        var geoserver_ip_ows = "https://ukforestgis.in/geoserver/sbl/ows";
        var format = 'image/png';
        const esriSatellite = new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                attributions: 'Tiles © Esri'
            })
        });

        const esriLabels = new ol.layer.Tile({
            source: new ol.source.XYZ({
                url: 'https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
                attributions: 'Labels © Esri'
            })
        });

        const map = new ol.Map({
            target: 'map',
            layers: [esriSatellite, esriLabels],
            view: new ol.View({
                center: ol.proj.fromLonLat([79.2593, 30.4068]), // Coordinates
                zoom: 7,
                maxZoom: 18
            })

        });

        window.onload = function () {

            map.addOverlay(district_layer);
            map.addLayer(district_layer);


        }
        var range_layer;
        function getrange(val) {

            map.removeLayer(range_layer);
            map.removeOverlay(range_layer);




            var kid = val.value;
            range_layer = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    url: geoserver_ip,
                    params: {
                        'FORMAT': format,
                        tiled: true,
                        STYLES: 'filter_highlight',
                        layers: 'uk_sfd:tbl_range_master',
                        CQL_FILTER: 'id=' + "\'" + kid + "\'",
                        transition: 0
                    }, serverType: 'geoserver',
                    crossOrigin: 'anonymous'

                })
            });

            map.addOverlay(range_layer);
            map.addLayer(range_layer);
        }








        var clickedCoords = null;
        var markerSource = new ol.source.Vector();
        var markerLayer = new ol.layer.Vector({
            source: markerSource
        });
        map.addLayer(markerLayer);
        map.on('click', function (evt) {
            markerSource.clear();
            var coordinate = ol.proj.toLonLat(evt.coordinate);
            var lon = coordinate[0].toFixed(6);
            var lat = coordinate[1].toFixed(6);
            document.getElementById('<%= txtLat.ClientID %>').value = lat;
            document.getElementById('<%= txtLong.ClientID %>').value = lon;
            var marker = new ol.Feature({
                geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(lon), parseFloat(lat)]))
            });

            marker.setStyle(new ol.style.Style({
                image: new ol.style.Icon({
                    anchor: [0.5, 1],
                    src: '../GIS/img/location.png',
                    scale: 0.03
                })
            }));

            markerSource.addFeature(marker);
        });

    </script>
</asp:Content>
