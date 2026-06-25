<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="addtrack.aspx.cs" Inherits="uk_forest.DSS.addtrack" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">
    <style>
    html, body {
        margin: 0;
        padding: 0;
        width: 100%;
        height: 100%;
        overflow: hidden;
    }
    #map {
        width: 100%;
        height: 100%;
        position: relative;
    }
    #controls {
        position: absolute;
  top: 2px;
  right: 2px;
  z-index: 1;
  background-color: white;
  padding: 10px;
    }
    #controls input {
  margin-top: 5px;
}
    button {
        padding: 8px 12px;
        margin-right: 5px;
        border: none;
        cursor: pointer;
        font-size: 14px;
        border-radius: 5px;
    }
    #drawBtn.active {
        background-color: orange;
        color: white;
    }
    #drawBtn {
        background-color: #ddd;
    }
    #clearBtn {
        background-color: #ff4d4d;
        color: white;
    }
    #coordBox {
        position: absolute;
        bottom: 10px;
        left: 10px;
        background: rgba(255,255,255,0.9);
        padding: 10px;
        width: 450px;
        height: 120px;
        overflow-y: auto;
        border-radius: 5px;
        font-family: monospace;
        font-size: 12px;
        z-index: 1000;
    }


    #main {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background-color: rgba(0, 0, 0, 0.43);
      z-index: 9999;
    }

    /* Center the image using absolute positioning + transform */
    #main .maininner {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 200px;
      background-color: white;
  
    }
     /*#main .closediv {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 200px;
      background-color: white;
   
    }*/
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">






    <div id="filter-container" style="display: block;">
       

        <div style="display: flex; gap: 10px; margin-bottom: 5px;">
            
            <div style="flex: 1;">
                <label style="display: block; font-size: 13px; margin-bottom: 3px;">Zone</label>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="ddlzone"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="All" ValidationGroup="resetpwd" />
                <asp:DropDownList runat="server" ID="ddlzone" OnSelectedIndexChanged="ddlzone_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
            </div>
             <div style="flex: 1;">
                <label style="display: block; font-size: 13px; margin-bottom: 3px;">Circles</label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlcircle"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="All" ValidationGroup="resetpwd" />
                <asp:DropDownList runat="server" ID="ddlcircle" OnSelectedIndexChanged="ddlcircle_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
            </div>
            <div style="flex: 1;">
                <label style="display: block; font-size: 13px; margin-bottom: 3px;">Division</label>
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddldivision"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="All" ValidationGroup="resetpwd" />
                <asp:DropDownList runat="server" ID="ddldivision" OnSelectedIndexChanged="ddldivision_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
            </div>
            <div style="flex: 1;">
                <label style="display: block; font-size: 13px; margin-bottom: 3px;">Range</label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlrange"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="All" ValidationGroup="resetpwd" />
                <asp:DropDownList runat="server" ID="ddlrange" OnSelectedIndexChanged="ddlrange_SelectedIndexChanged" AutoPostBack="true" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;"></asp:DropDownList>
            </div>

            <%--<div style="flex: 1;">
                <label style="display: block; font-size: 13px; margin-bottom: 3px;">Beat</label>
                <asp:DropDownList runat="server" ID="ddlbeat" Style="width: 100%; padding: 2px; border-radius: 5px; border: 1px solid #ccc;" OnSelectedIndexChanged="ddlbeat_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
            </div>--%>
        </div>
 
        


 
    </div>





  

<div id="coordBox" style="display: none;"></div>
    <div id="map">
        <div id="controls">
            <button type="button" id="drawBtn">Enable Draw Track</button>
            <button type="button" id="clearBtn">Clear</button>
              <asp:HiddenField runat="server" ID="hfjson" />
              <asp:FileUpload ID="fuKML" CssClass="form-control" runat="server" accept=".kml" />
          
              <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txttrackName"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="resetpwd" />
            <asp:TextBox runat="server" ID="txttrackName" style="display:none" placeholder="Enter Track Name "></asp:TextBox>
             <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtremark"
                        ErrorMessage="*" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="resetpwd" />
            <asp:TextBox runat="server" ID="txtremark" style="display:none" placeholder="Enter Remark "></asp:TextBox>
              <asp:Button ID="btnsavetrack" CssClass="btn btn-success" Text="Save Track" style="display:none" runat="server" ValidationGroup="resetpwd" OnClick="btnsavetrack_Click"/>
            <asp:HiddenField ID="cordStr" runat="server"/>
        </div>
    </div>
     <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
    <script src="js/addtrack.js"></script>

    <script>
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

        const displayFeaturesAsTable = () => {
            const table = document.createElement('featuretable');
            table.innerHTML = '';

            if (kmlFeatures.length === 0) {
                const row = document.createElement('tr');
                const cell = document.createElement('td');
                cell.colSpan = 3;
                cell.textContent = 'No features loaded.';
                row.appendChild(cell);
                table.appendChild(row);
                return;
            }

            const headerRow = document.createElement('tr');
            ['Feature #', 'Geometry Type', 'Coordinates'].forEach(text => {
                const th = document.createElement('th');
                th.textContent = text;
                headerRow.appendChild(th);
            });
            table.appendChild(headerRow);

            kmlFeatures.forEach((feature, index) => {
                const geometry = feature.getGeometry();
                const type = geometry.getType();
                const coords = geometry.getCoordinates();
                let coordString = '';

                switch (type) {
                    case 'Point':
                        coordString = formatCoords(coords);
                        break;
                    case 'LineString':
                        coordString = coords.map(c => formatCoords(c)).join(', ');
                        break;
                    case 'Polygon':
                        const closedRing = ensureClosedRing(coords[0]);
                        coordString = closedRing.map(c => formatCoords(c)).join(', ');
                        break;
                    case 'MultiLineString':
                        coordString = coords.flat().map(c => formatCoords(c)).join(', ');
                        break;
                    case 'MultiPolygon':
                        coordString = coords.flatMap(polygon =>
                            polygon.map(ring => ensureClosedRing(ring).map(c => formatCoords(c))).flat()
                        ).join(', ');
                        break;
                    default:
                        coordString = 'Unsupported geometry';
                }

                const row = document.createElement('tr');
                [index + 1, type, coordString].forEach(value => {
                    const td = document.createElement('td');
                    td.textContent = value;
                    row.appendChild(td);
                });

                table.appendChild(row);
            });
        };

        const displayFeaturesAsJSON = () => {
            const jsonOutput = document.getElementById('ContentPlaceHolder1_hfjson');
            console.log(jsonOutput);  // Will log `null` if not found
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

            /* jsonOutput.textContent = JSON.stringify(featureArray, null, 2);*/
        };
        document.getElementById('ContentPlaceHolder1_fuKML').addEventListener('change', function (event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();

                reader.onload = function (e) {
                    const kmlText = e.target.result;

                    const kmlFormat = new ol.format.KML();
                    kmlFeatures = kmlFormat.readFeatures(kmlText, {
                        featureProjection: map.getView().getProjection()
                    });

                    if (kmlLayer) {
                        map.removeLayer(kmlLayer);
                    }

                    const vectorSource = new ol.source.Vector({
                        features: kmlFeatures
                    });

                    kmlLayer = new ol.layer.Vector({
                        source: vectorSource
                    });

                    map.addLayer(kmlLayer);

                    const extent = vectorSource.getExtent();
                    if (extent && !ol.extent.isEmpty(extent)) {
                        map.getView().fit(extent, { duration: 1000 });
                    }

                    displayFeaturesAsTable();
                    displayFeaturesAsJSON();
                };
                document.getElementById("ContentPlaceHolder1_btnsavetrack").style.display = 'block';// Disable drawing automatically after one line
                document.getElementById("ContentPlaceHolder1_txttrackName").style.display = 'block';// Disable drawing automatically after one line
                document.getElementById("ContentPlaceHolder1_txtremark").style.display = 'block';// Disable drawing automatically after one line
                reader.readAsText(file);
            }
        });
    </script>
</asp:Content>
