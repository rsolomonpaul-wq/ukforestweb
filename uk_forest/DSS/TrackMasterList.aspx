<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TrackMasterList.aspx.cs" Inherits="uk_forest.DSS.TrackMasterList" MasterPageFile="~/Forest/forestmaster.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">
    <style>
        h2 { font-weight:700; color:#2c3e50; margin-bottom:20px; }

        .table { border-radius:8px; overflow:hidden; background:#fff; }
        .table thead { background:#34495e; color:#fff; text-align:center; }
        .table tbody tr:hover { background:#f4f6f9; transition:0.2s; }
        .table td, .table th { padding:10px 12px !important; vertical-align:middle; font-size:13px; }

        .action-btns { display:flex; gap:6px; justify-content:center; flex-wrap:wrap; }
        .btn-view   { background:#2980b9; color:#fff; border:none; border-radius:5px; padding:4px 12px; font-size:12px; cursor:pointer; }
        .btn-edit   { background:#27ae60; color:#fff; border:none; border-radius:5px; padding:4px 12px; font-size:12px; cursor:pointer; }
        .btn-remove { background:#e74c3c; color:#fff; border:none; border-radius:5px; padding:4px 12px; font-size:12px; cursor:pointer; }
        .btn-view:hover   { background:#1a6fa8; color:#fff; }
        .btn-edit:hover   { background:#1e8449; color:#fff; }
        .btn-remove:hover { background:#c0392b; color:#fff; }
        .btn-disabled { background:#bdc3c7 !important; cursor:not-allowed !important; opacity:0.6; pointer-events:none; }

        /* Actions Dropdown */
        .act-dropdown { position:relative; display:inline-block; }
        .act-toggle {
            background:#34495e; color:#fff; border:none;
            border-radius:5px; padding:5px 14px; font-size:12px;
            cursor:pointer; white-space:nowrap;
        }
        .act-toggle:hover { background:#2c3e50; }

        /* ── FIXED position so it never gets clipped by table overflow ── */
        .act-menu {
            display:none;
            position:fixed;
            background:#fff; border:1px solid #dee2e6;
            border-radius:6px; box-shadow:0 4px 12px rgba(0,0,0,0.15);
            min-width:160px; z-index:9999;
        }
        .act-menu a, .act-menu button {
            display:block; width:100%; text-align:left;
            padding:8px 14px; font-size:13px; border:none;
            background:transparent; cursor:pointer; color:#2c3e50;
            text-decoration:none; white-space:nowrap;
        }
        .act-menu a:hover, .act-menu button:hover { background:#f4f6f9; }
        .act-menu .item-disabled { color:#bdc3c7 !important; cursor:not-allowed !important; pointer-events:none; background:transparent !important; }
        .act-menu .divider { height:1px; background:#dee2e6; margin:2px 0; }

        /* Popup */
        .popupOverlay {
            display:none; width:100%; height:100vh;
            background:rgba(0,0,0,0.55);
            position:fixed; top:0; left:0; z-index:9000;
        }
        .popupBox {
            width:65%; background:#fff;
            box-shadow:0 8px 32px rgba(0,0,0,0.22);
            border-radius:8px;
            position:absolute; top:50%; left:50%;
            transform:translate(-50%,-50%);
            z-index:9100; max-height:90vh; overflow-y:auto;
        }
        .popupTitle {
            display:flex; align-items:center;
            justify-content:space-between;
            padding:13px 18px;
            background:#2c3e50; color:#fff;
            border-radius:8px 8px 0 0;
            position:sticky; top:0; z-index:10;
        }
        .popupTitle h5 { margin:0; font-weight:600; font-size:15px; }
        .popupClose {
            border:0; color:#2c3e50; width:28px; height:28px;
            border-radius:50%; font-size:15px; line-height:28px;
            background:#fff; text-align:center; cursor:pointer;
        }
        .popupBody { padding:20px 24px; }

        .info-label { font-size:11px; text-transform:uppercase; letter-spacing:.5px; color:#7f8c8d; font-weight:600; }
        .info-value { font-size:14px; color:#2c3e50; padding:4px 0 6px; display:block; border-bottom:1px dashed #dcdde1; margin-bottom:4px; min-height:26px; }

        #viewMap { width:100%; height:320px; border-radius:6px; margin-top:10px; border:1px solid #dee2e6; }

        .badge-pending  { background:#f39c12; color:#fff; padding:3px 10px; border-radius:12px; font-size:12px; }
        .badge-approved { background:#27ae60; color:#fff; padding:3px 10px; border-radius:12px; font-size:12px; }
        .badge-rejected { background:#e74c3c; color:#fff; padding:3px 10px; border-radius:12px; font-size:12px; }
        .badge-yes { background:#27ae60; color:#fff; padding:3px 10px; border-radius:12px; font-size:12px; }
        .badge-no  { background:#95a5a6; color:#fff; padding:3px 10px; border-radius:12px; font-size:12px; }

        .btn-addtrack { background:#8e44ad; color:#fff; border:none; border-radius:5px; padding:4px 12px; font-size:12px; cursor:pointer; }
        .btn-addtrack:hover { background:#7d3c98; color:#fff; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="mt-4">
        <h2>Track Master List</h2>

        <asp:GridView ID="gvTrackMaster" runat="server"
            AutoGenerateColumns="false"
            CssClass="table table-bordered table-striped"
            OnRowDataBound="gvTrackMaster_RowDataBound">
            <Columns>

                <asp:TemplateField HeaderText="S.No">
                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="trackname" HeaderText="Track Name" />
                <asp:BoundField DataField="zone"      HeaderText="Zone" />
                <asp:BoundField DataField="circle"    HeaderText="Circle" />
                <asp:BoundField DataField="division"  HeaderText="Division" />
                <asp:BoundField DataField="range"     HeaderText="Range" />
                <asp:BoundField DataField="remark"    HeaderText="Remark" />

                <asp:TemplateField HeaderText="Status" Visible="false">
                    <ItemTemplate>
                        <%# GetStatusBadge(Eval("status").ToString()) %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Patrolling Done">
                    <ItemTemplate>
                        <%# Convert.ToBoolean(Eval("has_patrolling"))
                            ? "<span class='badge-yes'>Yes</span>"
                            : "<span class='badge-no'>No</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="createdby" HeaderText="Created By" />
                <asp:BoundField DataField="createdon" HeaderText="Created Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />

                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:HiddenField ID="hfTrackId"       runat="server" Value='<%# Eval("trackid") %>' />
                        <asp:HiddenField ID="hfHasPatrolling" runat="server" Value='<%# Eval("has_patrolling") %>' />
                        <div class="act-dropdown">
                            <button type="button" class="act-toggle" onclick="toggleActMenu(event, this)">
                                Actions &#9660;
                            </button>
                            <div class="act-menu">
                                <%-- View --%>
                                <asp:LinkButton ID="btnView" runat="server"
                                    OnClick="btnView_Click"
                                    CommandArgument='<%# Eval("trackid") %>'>&#128065; View</asp:LinkButton>

                                <%-- Edit: disabled class set in RowDataBound if no patrolling --%>
                                <asp:LinkButton ID="btnEdit" runat="server"
                                    OnClick="btnEdit_Click"
                                    CommandArgument='<%# Eval("trackid") %>'>&#9998; Edit</asp:LinkButton>

                                <div class="divider"></div>

                                <%-- Add New Track --%>
                                <a href="/DSS/addtrack">&#43; Add New Track</a>

                                <div class="divider"></div>

                                <%-- Remove --%>
                                <asp:LinkButton ID="btnRemove" runat="server"
                                    OnClick="btnRemove_Click"
                                    CommandArgument='<%# Eval("trackid") %>'
                                    OnClientClick="return confirm('Are you sure you want to remove this track?');"
                                    style="color:#e74c3c;">&#128465; Remove</asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>

    <!-- ===== VIEW POPUP ===== -->
    <div runat="server" id="viewPopup" class="popupOverlay">
        <div class="popupBox">
            <div class="popupTitle">
                <h5>View Track Details</h5>
                <button type="button" class="popupClose" onclick="closePopup('ContentPlaceHolder1_viewPopup')">✕</button>
            </div>
            <div class="popupBody">
                <div class="row g-3">

                    <%-- Track Master Info --%>
                    <div class="col-12"><h6 class="text-muted mb-1" style="font-size:12px;text-transform:uppercase;letter-spacing:1px;">Track Information</h6><hr class="mt-0"></div>

                    <div class="col-md-4">
                        <span class="info-label">Track Name</span>
                        <span class="info-value"><asp:Label ID="lblViewTrackName" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Zone</span>
                        <span class="info-value"><asp:Label ID="lblViewZone" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Circle</span>
                        <span class="info-value"><asp:Label ID="lblViewCircle" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Division</span>
                        <span class="info-value"><asp:Label ID="lblViewDivision" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Range</span>
                        <span class="info-value"><asp:Label ID="lblViewRange" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Remark</span>
                        <span class="info-value"><asp:Label ID="lblViewRemark" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Status</span>
                        <span class="info-value"><asp:Label ID="lblViewStatus" runat="server" /></span>
                    </div>

                    <%-- Patrolling Info --%>
                    <div class="col-12 mt-2"><h6 class="text-muted mb-1" style="font-size:12px;text-transform:uppercase;letter-spacing:1px;">Patrolling Information</h6><hr class="mt-0"></div>

                    <div class="col-md-4">
                        <span class="info-label">Patrolling Type</span>
                        <span class="info-value"><asp:Label ID="lblViewPatrollingType" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Total Distance (km)</span>
                        <span class="info-value"><asp:Label ID="lblViewDistance" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Track Leader Name</span>
                        <span class="info-value"><asp:Label ID="lblViewLeader" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Tracking Date</span>
                        <span class="info-value"><asp:Label ID="lblViewTrackingDate" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Animal Sighting</span>
                        <span class="info-value"><asp:Label ID="lblViewAnimalSighting" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Species Type</span>
                        <span class="info-value"><asp:Label ID="lblViewSpecies" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Forest Type</span>
                        <span class="info-value"><asp:Label ID="lblViewForestType" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Slope</span>
                        <span class="info-value"><asp:Label ID="lblViewSlope" runat="server" /></span>
                    </div>
                    <div class="col-md-4">
                        <span class="info-label">Land Cover</span>
                        <span class="info-value"><asp:Label ID="lblViewLandCover" runat="server" /></span>
                    </div>

                    <div class="col-md-12">
                        <div id="viewMap"></div>
                    </div>
                </div>
                <div class="d-flex justify-content-end mt-3">
                    <button type="button" class="btn btn-secondary btn-sm"
                        onclick="closePopup('ContentPlaceHolder1_viewPopup')">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== EDIT POPUP ===== -->
    <div runat="server" id="editPopup" class="popupOverlay">
        <div class="popupBox">
            <div class="popupTitle" style="background:#27ae60;">
                <h5>Edit Patrolling Information</h5>
                <button type="button" class="popupClose" onclick="closePopup('ContentPlaceHolder1_editPopup')">✕</button>
            </div>
            <div class="popupBody">
                <p class="text-muted small mb-3">
                    <strong>Note:</strong> Only patrolling information can be edited here. Track master fields are not editable.
                </p>
                <div class="row g-3">

                    <div class="col-md-6">
                        <asp:Label CssClass="form-label fw-semibold small" runat="server" Text="Type of Patrolling" />
                        <asp:DropDownList ID="ddlEditPatrollingType" CssClass="form-select form-select-sm" runat="server">
                            <asp:ListItem Text="Foot Patrolling"     Value="Foot Patrolling" />
                            <asp:ListItem Text="Vehicle Patrolling"  Value="Vehicle Patrolling" />
                            <asp:ListItem Text="Boat Patrolling"     Value="Boat Patrolling" />
                            <asp:ListItem Text="Elephant Patrolling" Value="Elephant Patrolling" />
                            <asp:ListItem Text="Dog Patrolling"      Value="Dog Patrolling" />
                            <asp:ListItem Text="Flag March"          Value="Flag March" />
                            <asp:ListItem Text="Night Patrolling"    Value="Night Patrolling" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <asp:Label CssClass="form-label fw-semibold small" runat="server" Text="Total Distance (km)" />
                        <asp:TextBox ID="txtEditDistance" CssClass="form-control form-control-sm" TextMode="Number" runat="server" />
                    </div>

                    <div class="col-md-6">
                        <asp:Label CssClass="form-label fw-semibold small" runat="server" Text="Track Leader Name" />
                        <asp:TextBox ID="txtEditLeaderName" CssClass="form-control form-control-sm" runat="server" />
                    </div>

                    <div class="col-md-6">
                        <asp:Label CssClass="form-label fw-semibold small" runat="server" Text="Tracking Date" />
                        <asp:TextBox ID="txtEditTrackingDate" CssClass="form-control form-control-sm" TextMode="Date" runat="server" />
                    </div>

                    <div class="col-md-6">
                        <asp:Label CssClass="form-label fw-semibold small" runat="server" Text="Slope" />
                        <asp:DropDownList ID="ddlEditSlope" CssClass="form-select form-select-sm" runat="server">
                            <asp:ListItem Text="Plain" />
                            <asp:ListItem Text="Moderate" />
                            <asp:ListItem Text="Steep" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <asp:Label CssClass="form-label fw-semibold small" runat="server" Text="Land Cover" />
                        <asp:DropDownList ID="ddlEditLandCover" CssClass="form-select form-select-sm" runat="server">
                            <asp:ListItem Text="Very Dense" />
                            <asp:ListItem Text="Moderate" />
                            <asp:ListItem Text="Open" />
                            <asp:ListItem Text="Scrub" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <asp:Label CssClass="form-label fw-semibold small" runat="server" Text="Forest Type" />
                        <asp:DropDownList ID="ddlEditForestType" CssClass="form-select form-select-sm" runat="server">
                            <asp:ListItem Text="Tropical" />
                            <asp:ListItem Text="Dry Deciduous" />
                            <asp:ListItem Text="Evergreen" />
                            <asp:ListItem Text="Mixed" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <asp:Label CssClass="form-label fw-semibold small" runat="server" Text="Animal Sighting" />
                        <asp:DropDownList ID="ddlEditAnimalSighting" CssClass="form-select form-select-sm" runat="server">
                            <asp:ListItem Text="Active"  Value="Active" />
                            <asp:ListItem Text="Passive" Value="Passive" />
                            <asp:ListItem Text="None"    Value="None" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <asp:Label CssClass="form-label fw-semibold small" runat="server" Text="Species Type" />
                        <asp:DropDownList ID="ddlEditSpeciesType" CssClass="form-select form-select-sm" runat="server">
                            <asp:ListItem Text="Select Species" Value="" />
                            <asp:ListItem Text="Tiger" />
                            <asp:ListItem Text="Elephant" />
                            <asp:ListItem Text="Leopard" />
                            <asp:ListItem Text="Deer" />
                            <asp:ListItem Text="Other" />
                            <asp:ListItem Text="Not Identified" />
                        </asp:DropDownList>
                    </div>

                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <button type="button" class="btn btn-secondary btn-sm"
                        onclick="closePopup('ContentPlaceHolder1_editPopup')">Cancel</button>
                    <asp:Button ID="btnSaveEdit" runat="server" Text="Save Changes"
                        CssClass="btn btn-success btn-sm" OnClick="btnSaveEdit_Click" />
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <script>
        function openPopup(id) {
            document.getElementById(id).style.display = 'block';
        }
        function closePopup(id) {
            document.getElementById(id).style.display = 'none';
        }

        // ── Actions dropdown toggle with fixed positioning ────────────
        function toggleActMenu(event, btn) {
            event.stopPropagation();
            var menu = btn.nextElementSibling;
            var isOpen = menu.style.display === 'block';

            // Close all open menus first
            document.querySelectorAll('.act-menu').forEach(function (m) { m.style.display = 'none'; });

            if (!isOpen) {
                var rect = btn.getBoundingClientRect();
                var menuHeight = 160; // approx height of menu
                var spaceBelow = window.innerHeight - rect.bottom;

                menu.style.display = 'block';

                // Position: open upward if not enough space below
                if (spaceBelow < menuHeight) {
                    menu.style.top = (rect.top - menu.offsetHeight - 4) + 'px';
                } else {
                    menu.style.top = (rect.bottom + 4) + 'px';
                }
                menu.style.left = (rect.right - menu.offsetWidth - 2) + 'px';

                // Recalculate left after display (offsetWidth now available)
                menu.style.left = (rect.right - menu.offsetWidth - 2) + 'px';
            }
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function (e) {
            if (!e.target.closest('.act-dropdown')) {
                document.querySelectorAll('.act-menu').forEach(function (m) { m.style.display = 'none'; });
            }
        });

        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.popupOverlay').forEach(function (el) {
                el.addEventListener('click', function (e) {
                    if (e.target === el) el.style.display = 'none';
                });
            });
        });

        // ── OpenLayers View Map ───────────────────────────────────────
        var viewMap = new ol.Map({
            target: 'viewMap',
            layers: [new ol.layer.Tile({ source: new ol.source.OSM() })],
            view: new ol.View({ center: ol.proj.fromLonLat([79.2593, 29.9968]), zoom: 8 })
        });

        function addTrackOnMap(trackId) {
            var layers = viewMap.getLayers().getArray().slice();
            for (var i = 1; i < layers.length; i++) {
                viewMap.removeLayer(layers[i]);
            }

            var url = "https://ukforestgis.in/geoserver/uk_sfd/ows?" +
                "service=WFS&version=1.0.0&request=GetFeature" +
                "&typeName=uk_sfd:view_track_master" +
                "&outputFormat=application/json" +
                "&cql_filter=trackid=" + trackId;

            fetch(url)
                .then(function (r) { return r.json(); })
                .then(function (geojson) {
                    var format = new ol.format.GeoJSON();
                    var features = format.readFeatures(geojson, { featureProjection: 'EPSG:3857' });

                    function getColor(status) {
                        if (!status) return 'gray';
                        status = status.toLowerCase();
                        if (status === 'pending') return '#FF2DD1';
                        if (status === 'approved') return 'green';
                        if (status === 'rejected') return 'red';
                        return 'gray';
                    }

                    var src = new ol.source.Vector({ features: features });
                    viewMap.addLayer(new ol.layer.Vector({
                        source: src,
                        style: function (f) {
                            return new ol.style.Style({
                                stroke: new ol.style.Stroke({ color: getColor(f.get('status')), width: 3 })
                            });
                        }
                    }));

                    if (!ol.extent.isEmpty(src.getExtent())) {
                        viewMap.getView().fit(src.getExtent(), { duration: 800, padding: [50, 50, 50, 50] });
                    }
                })
                .catch(function (e) { console.error('WFS Error:', e); });
        }
    </script>

</asp:Content>
