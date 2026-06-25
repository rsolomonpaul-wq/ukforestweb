<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="patrollingInputForm.aspx.cs" Inherits="uk_forest.DSS.patrollingInputForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Bootstrap 5 CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f1f3f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        .form-wrapper {
            background-color: #fff;
            padding: 30px 35px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            width: 100%;
        }

        .form-section {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            background: #f8f9fa;
        }

            .form-section h5 {
                margin-bottom: 15px;
                font-size: 17px;
                font-weight: 600;
                color: #495057;
            }

        .form-label {
            font-weight: 500;
        }

        .hidden {
            display: none;
        }

        .page-content.my-5 .page-container {
            margin-top: 40px !important;
        }

        a {
            text-decoration: none;
        }
    </style>
    <style>
        #map {
            width: 100%;
            height: 280px;
        }
        #controls {
            margin: 10px 0;
        }
        #output {
            margin-top: 10px;
            border: 1px solid #ccc;
            padding: 10px;
            background-color: #f9f9f9;
            overflow-x: auto;
            display: none;
        }
        /* Styling the table */
        #output table {
            width:100%;
            border-collapse: collapse;
            font-family: Arial, sans-serif;
        }
        #output th, #output td{
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }
        #output th {
            background-color: #f0f0f0;
        }
        input#ContentPlaceHolder1_rblTrackType_0{
            margin-right: 5px;
        }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <asp:Label ID="LabelInContent" runat="server" Text="Patrolling Input Form" Visible="false" />

    <div class="form-wrapper">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div></div>
            <h3 class="mb-0 text-center flex-grow-1">Patrolling Input Form</h3>
            <div></div>
        </div>

        <asp:Panel ID="FormPanel" runat="server">

            <div class="row mb-3">
                <div class="col-md-6 mb-3">
                    <asp:Label CssClass="form-label" runat="server" Text="Division" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="ddldivision"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="All" ValidationGroup="resetpwd" />
                    <asp:DropDownList runat="server" CssClass="form-select" ID="ddldivision"
                        OnSelectedIndexChanged="ddldivision_SelectedIndexChanged" AutoPostBack="true">
                    </asp:DropDownList>
                </div>
                <div class="col-md-6">
                    <asp:Label CssClass="form-label" runat="server" Text="Range" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlrange"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="All" ValidationGroup="resetpwd" />
                    <asp:DropDownList runat="server" CssClass="form-select" ID="ddlrange"
                        OnSelectedIndexChanged="ddlrange_SelectedIndexChanged" AutoPostBack="true">
                    </asp:DropDownList>
                </div>
            </div>

            <div class="mb-3">
                <asp:Label CssClass="form-label" runat="server" Text="Beat" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlBeat"
                    ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="All" ValidationGroup="resetpwd" />
                <asp:DropDownList ID="ddlBeat" CssClass="form-select" runat="server">
                </asp:DropDownList>
            </div>

            <!-- Track Type -->
            <div>
                <div class="row">
                    <div class="col-md-6 form-section">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">Track Type</h5>
                            <a href="/DSS/addtrack" class="btn btn-success btn-sm">
                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" class="me-1" style="margin-top:-2px">
                                    <path d="M8 1a.5.5 0 0 1 .5.5v6h6a.5.5 0 0 1 0 1h-6v6a.5.5 0 0 1-1 0v-6h-6a.5.5 0 0 1 0-1h6v-6A.5.5 0 0 1 8 1z"/>
                                </svg>
                                Add Track
                            </a>
                        </div>
                        <div class="mb-3">
                            <asp:RadioButtonList ID="rblTrackType" CssClass="form-check-inline" RepeatDirection="Horizontal"
                                AutoPostBack="true" runat="server" OnSelectedIndexChanged="rblTrackType_SelectedIndexChanged">
                                <asp:ListItem Text="Defined Track" Value="Defined" Selected="True" />
                            </asp:RadioButtonList>
                        </div>

                        <asp:Panel ID="pnlDefinedTrackFields" runat="server">
                            <div class="mb-3">
                                <asp:Label CssClass="form-label" runat="server" Text="Select Track" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlDefinedTrack"
                                    ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="resetpwd" />
                                <%-- Dynamic - bound from tbl_track_master --%>
                                <asp:DropDownList ID="ddlDefinedTrack" CssClass="form-select" runat="server">
                                    <asp:ListItem Text="Select Defined Track" Value="" />
                                </asp:DropDownList>
                            </div>

                            <%-- KML Upload - visible below Select Track --%>
                            <asp:Panel ID="pnlKML" runat="server" Visible="true">
                                <div class="mb-3">
                                    <asp:Label CssClass="form-label" runat="server" Text="Upload KML" />
                                    <asp:FileUpload ID="fuKML" CssClass="form-control" runat="server" accept=".kml" />
                                </div>
                            </asp:Panel>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <asp:Label CssClass="form-label" runat="server" Text="Track Leader Name" />
                                    <asp:RequiredFieldValidator ID="rfvTrackLeader" runat="server" ControlToValidate="txtTrackLeaderName"
                                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="resetpwd" />
                                    <asp:TextBox ID="txtTrackLeaderName" CssClass="form-control" runat="server" placeholder="Enter track leader name" />
                                </div>
                                <div class="col-md-6 mb-3">
                                    <asp:Label CssClass="form-label" runat="server" Text="Tracking Date" />
                                    <asp:RequiredFieldValidator ID="rfvTracingDate" runat="server" ControlToValidate="txtTracingDate"
                                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="resetpwd" />
                                    <asp:TextBox ID="txtTracingDate" CssClass="form-control" TextMode="Date" runat="server" />
                                </div>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlTrackName" runat="server" Visible="false">
                            <div class="mb-2">
                                <asp:Label CssClass="form-label" runat="server" Text="Name" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtTrackName"
                                    ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="resetpwd" />
                                <asp:TextBox ID="txtTrackName" CssClass="form-control" runat="server" />
                            </div>
                        </asp:Panel>

                    </div>
                    <div class="col-md-6">
                        <asp:HiddenField runat="server" ID="hfjson" />
                        <div id="map"></div>
                        <div id="output"></div>
                    </div>
                </div>
            </div>

            <!-- Terrain Info -->
            <div class="form-section">
                <h5>Terrain Information</h5>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <asp:Label CssClass="form-label" runat="server" Text="Slope" />
                        <asp:DropDownList ID="ddlSlope" CssClass="form-select" runat="server">
                            <asp:ListItem Text="Plain" />
                            <asp:ListItem Text="Moderate" />
                            <asp:ListItem Text="Steep" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6">
                        <asp:Label CssClass="form-label" runat="server" Text="Land Cover" />
                        <asp:DropDownList ID="ddlLandCover" CssClass="form-select" runat="server">
                            <asp:ListItem Text="Very Dense" />
                            <asp:ListItem Text="Moderate" />
                            <asp:ListItem Text="Open" />
                            <asp:ListItem Text="Scrub" />
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <!-- Animal Sighting -->
            <div class="form-section">
                <h5>Animal Sighting</h5>
                <asp:RadioButtonList ID="rblAnimalSighting" runat="server" RepeatDirection="Horizontal"
                    AutoPostBack="true" OnSelectedIndexChanged="rblAnimalSighting_SelectedIndexChanged"
                    CssClass="form-check-inline">
                    <asp:ListItem Text="Active" Value="Active" Selected="True" />
                    <asp:ListItem Text="Passive" Value="Passive" />
                    <asp:ListItem Text="None" Value="None" />
                </asp:RadioButtonList>

                <asp:Panel ID="pnlFileUpload" runat="server" CssClass="mb-3">
                    <asp:Label CssClass="form-label" runat="server" Text="Upload Photo/Document" />
                    <asp:FileUpload ID="fuAnimalDocument" CssClass="form-control" runat="server" />
                </asp:Panel>

                <asp:Panel ID="pnlDescription" runat="server" CssClass="mb-3" Visible="false">
                    <asp:Label CssClass="form-label" runat="server" Text="Description" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtDescription"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="resetpwd" />
                    <asp:TextBox ID="txtDescription" TextMode="MultiLine" Rows="3" CssClass="form-control" runat="server" />
                </asp:Panel>

                <asp:Panel ID="pnlSpeciesType" runat="server">
                    <asp:Label CssClass="form-label" runat="server" Text="Species Type" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="ddlSpeciesType"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="Select Species" ValidationGroup="resetpwd" />
                    <asp:DropDownList ID="ddlSpeciesType" CssClass="form-select" runat="server">
                        <asp:ListItem Text="Select Species" Disabled="true" Selected="true" />
                        <asp:ListItem Text="Tiger" />
                        <asp:ListItem Text="Elephant" />
                        <asp:ListItem Text="Leopard" />
                        <asp:ListItem Text="Deer" />
                        <asp:ListItem Text="Other" />
                        <asp:ListItem Text="Not Identified" />
                    </asp:DropDownList>
                </asp:Panel>
            </div>

            <!-- Patrolling Details -->
            <div class="form-section">
                <h5>Patrolling Details</h5>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <asp:Label CssClass="form-label" runat="server" Text="Type of Patrolling" />
                        <asp:DropDownList ID="ddlPatrollingType" CssClass="form-select" runat="server">
                            <asp:ListItem Text="Foot Patrolling" Value="Foot Patrolling" />
                            <asp:ListItem Text="Vehicle Patrolling" Value="Vehicle Patrolling" />
                            <asp:ListItem Text="Boat Patrolling" Value="Boat Patrolling" />
                            <asp:ListItem Text="Elephant Patrolling" Value="Elephant Patrolling" />
                            <asp:ListItem Text="Dog Patrolling" Value="Dog Patrolling" />
                            <asp:ListItem Text="Flag March" Value="Flag March" />
                            <asp:ListItem Text="Night Patrolling" Value="Night Patrolling" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6">
                        <asp:Label CssClass="form-label" runat="server" Text="Total Distance Covered (km)" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtDistance"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="resetpwd" />
                        <asp:TextBox ID="txtDistance" CssClass="form-control" TextMode="Number" runat="server" />
                    </div>
                </div>
            </div>

            <!-- Forest Type -->
            <div class="mb-4">
                <asp:Label CssClass="form-label" runat="server" Text="Forest Type" />
                <asp:DropDownList ID="ddlForestType" CssClass="form-select" runat="server">
                    <asp:ListItem Text="Tropical" />
                    <asp:ListItem Text="Dry Deciduous" />
                    <asp:ListItem Text="Evergreen" />
                    <asp:ListItem Text="Mixed" />
                </asp:DropDownList>
            </div>

            <!-- Buttons -->
            <div class="d-flex justify-content-end gap-3">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-success"
                    OnClick="btnSubmit_Click" type="button" ValidationGroup="resetpwd" />
            </div>

        </asp:Panel>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <script>
        const map = new ol.Map({
            target: 'map',
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.OSM()
                })
            ],
            view: new ol.View({
                center: ol.proj.fromLonLat([0, 0]),
                zoom: 2
            })
        });

        let kmlLayer = null;
        let kmlFeatures = [];

        const formatCoords = (coord) => {
            const [lon, lat] = ol.proj.toLonLat(coord);
            return `${lon.toFixed(6)} ${lat.toFixed(6)}`;
        };

        const coordsEqual = (c1, c2) => {
            return c1[0] === c2[0] && c1[1] === c2[1];
        };

        const ensureClosedRing = (ring) => {
            const first = ring[0];
            const last = ring[ring.length - 1];
            if (!coordsEqual(first, last)) {
                ring.push(first.slice());
            }
            return ring;
        };

        const displayFeaturesAsJSON = () => {
            const featureArray = kmlFeatures.map((feature, index) => {
                const geometry = feature.getGeometry();
                const type = geometry.getType();
                const coords = geometry.getCoordinates();
                let formattedCoords;

                switch (type) {
                    case 'Point':
                        formattedCoords = formatCoords(coords);
                        break;
                    case 'LineString':
                        formattedCoords = coords.map(c => formatCoords(c)).join(', ');
                        break;
                    case 'Polygon':
                        const closedRing = ensureClosedRing(coords[0]);
                        formattedCoords = closedRing.map(c => formatCoords(c)).join(', ');
                        break;
                    case 'MultiLineString':
                        formattedCoords = coords.flat().map(c => formatCoords(c)).join(', ');
                        break;
                    case 'MultiPolygon':
                        formattedCoords = coords.flatMap(polygon =>
                            polygon.map(ring => ensureClosedRing(ring).map(c => formatCoords(c))).flat()
                        ).join(', ');
                        break;
                    default:
                        formattedCoords = 'Unsupported geometry';
                }

                return {
                    id: index + 1,
                    type: type,
                    coordinates: formattedCoords
                };
            });
            document.getElementById('ContentPlaceHolder1_hfjson').value = JSON.stringify(featureArray);
        };
    </script>
    <script>
        const toggleBtn = document.querySelector('.dropdown-toggle');
        const menu = document.querySelector('.dropdown-menu');

        toggleBtn.addEventListener('click', () => {
            menu.classList.toggle('show');
        });
    </script>
</asp:Content>
