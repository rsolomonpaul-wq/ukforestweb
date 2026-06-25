<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="assetDashboard.aspx.cs" Inherits="uk_forest.DSS.assetDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
  <!-- Bootstrap 5 CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

  <!-- OpenLayers -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.css" />

  <style>
    body {
      background-color: #f8f9fa;
      overflow-x: hidden;
    }

    .filter-header {
      font-size: 28px;
      font-weight: bold;
      color: #2c6e49;
      margin-top: 30px;
      margin-bottom: 20px;
    }

    .filter-row {
      background-color: #ffffff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
    }

    .btn-success {
      background-color: #28a745;
      border-color: #28a745;
    }

    .map-container {
      background-color: #e9ecef;
      height: 400px;
      border-radius: 8px;
      overflow: hidden;
      position: relative;
    }

    .filters-box {
      background-color: #ffffff;
      padding: 20px;
      border-radius: 8px;
      height: 100%;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
    }

    .filters-box h5 {
      margin-bottom: 15px;
      color: #343a40;
    }

    .section-divider {
      margin-top: 15px;
      margin-bottom: 10px;
      border-bottom: 1px solid #dee2e6;
      padding-bottom: 5px;
      font-weight: bold;
    }

    .custom-bg {
      background-color: #ffffff;
      padding: 15px;
      border-radius: 8px;
      text-align: center;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
    }

    .custom-bg h4 {
      font-size: 20px;
      margin-bottom: 5px;
    }

    .undermap {
      background-color: #ffffff;
      padding: 15px;
      border-radius: 8px;
      margin-bottom: 15px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
    }

    .undermap h5 {
      margin-bottom: 5px;
    }

    .undermap h3 {
      color: #dc3545;
    }

    .form-check-inline {
      margin-right: 20px;
    }

    .radio {
      margin-right: 10px;
    }
  </style>
  <style>
    .table-wrap {

      background: #fff;
      border: 1px solid #ddd;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    thead {
      background: #f3f3f3;
    }

    th,
    td {
      padding: 12px 15px;
      border-bottom: 1px solid #eee;
      text-align: center;
      font-size: 14px;
    }

    th {
      font-weight: bold;
      text-align: left;
    }

    tbody tr:nth-child(even) {
      background: #fafafa;
    }

    .table-footer {
      padding: 12px 15px;
      background: #f3f3f3;
      text-align: right;
    }

    .pagination {
      display: inline-block;
    }

    .pagination button {
      background: #fff;
      border: 1px solid #ccc;
      padding: 6px 12px;
      margin: 0 2px;
      border-radius: 4px;
      cursor: pointer;
    }

    .pagination button:disabled {
      background: #eee;
      cursor: not-allowed;
    }
  </style>

  <style>
    .ol-popup {
      position: absolute;
      background-color: white;
      padding: 10px 10px 5px;
      border: 1px solid #ccc;
      bottom: 12px;
      left: -50px;
      min-width: 220px;
      font-size: 13px;
      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);
      border-radius: 8px;
    }

    .ol-popup:after,
    .ol-popup:before {
      top: 100%;
      border: solid transparent;
      content: " ";
      height: 0;
      width: 0;
      position: absolute;
      pointer-events: none;
    }

    .ol-popup:after {
      border-top-color: white;
      border-width: 10px;
      left: 48px;
      margin-left: -10px;
    }

    .ol-popup:before {
      border-top-color: #ccc;
      border-width: 11px;
      left: 48px;
      margin-left: -11px;
    }

    .popup-closer {
      position: absolute;
      top: 5px;
      right: 8px;
      cursor: pointer;
      font-weight: bold;
      font-size: 14px;
      color: #666;
    }

    .popup-closer:hover {
      color: red;
    }

    .map-legend {
      position: absolute;
      bottom: 20px;
      left: 20px;
      background: rgba(255, 255, 255, 0.9);
      padding: 10px 15px;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 13px;
      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);
      z-index: 1000;
    }

    .map-legend h4 {
      margin: 0 0 5px;
      font-size: 14px;
    }

    .legend-icon {
      display: inline-block;
      width: 12px;
      height: 12px;
      margin-right: 8px;
      vertical-align: middle;
      border: 1px solid #333;
      border-radius: 50%;
    }

    .legend-icon.red {
      background-color: red;
    }

    .legend-icon.orange {
      background-color: orange;
    }

    .legend-icon.green {
      background-color: green;
    }

    .legend-icon.blue {
      background-color: blue;
      border-radius: 0;
      /* square */
    }
    .chart-row{
      height: 20em;
                     
                    align-items: center;
    }
    canvas{
          margin: 0 auto;
    }
    a{
        text-decoration:none !important;
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <asp:Label ID="LabelInContent" runat="server" Text="Assets Tracking & Management Dashboard" Visible="false" />
  <div class="container-fluid px-4">
     

    <!-- Row 1: Filter Bar -->
    <div class="filter-row mb-2">
      <form id="filterForm">
        <div class="row g-3 align-items-end">
          <div class="col-md-2">
            <label for="division" class="form-label">Division</label>
            <select id="division" class="form-select" required>
              <option selected disabled>All Division</option>
              <option value="Dehradun">Dehradun</option>
              <option value="Haridwar">Haridwar</option>
              <option value="Nainital">Nainital</option>
            </select>
          </div>

          <div class="col-md-2">
            <label for="range" class="form-label">Range</label>
            <select id="range" class="form-select" required>
              <option selected disabled>All Range</option>
              <option value="Chilla">Chilla</option>
              <option value="Rajaji">Rajaji</option>
              <option value="Kalsi">Kalsi</option>
            </select>
          </div>

          <div class="col-md-2">
            <label for="startDate" class="form-label">Start Date</label>
            <input type="date" id="startDate" class="form-control" required>
          </div>

          <div class="col-md-2">
            <label for="endDate" class="form-label">End Date</label>
            <input type="date" id="endDate" class="form-control" required>
          </div>
          <div class="col-md-2">
            <label for="asset" class="form-label">Asset Type</label>
            <select id="asset" class="form-select" required>
              <option selected disabled>All Asset</option>
              <option value="Forest Rest Houses">Forest Rest Houses</option>
              <option value="Fire Watch Towers">Fire Watch Towers</option>
              <option value="Nurseries">Nurseries</option>
            </select>
          </div>
          <div class="col-md-2">
            <button type="submit" class="btn btn-success w-100">Search</button>
          </div>
        </div>
      </form>
    </div>

    <div class="row g-3 mb-2">
      <!-- Each box gets 20% width (5 boxes in one row) -->

      <div class="col d-flex">
        <div
          class="undermap flex-fill text-center d-flex flex-column justify-content-center align-items-center p-4 border rounded shadow-sm">
          <h4>Total Assets</h4>
          <h3>1250</h3>
          <span>Total Registered Assets</span>
          <span style="color: green;">↑ 5% since last month</span>
        </div>
      </div>

      <div class="col d-flex">
        <div
          class="undermap flex-fill text-center d-flex flex-column justify-content-center align-items-center p-4 border rounded shadow-sm">
          <h4>Active Nurseries</h4>
          <h3>45</h3>
          <span>Currently Operating Nurseries</span>
          <span style="color: rgb(201, 201, 201);">- No Change</span>
        </div>
      </div>

      <div class="col d-flex">
        <div
          class="undermap flex-fill text-center d-flex flex-column justify-content-center align-items-center p-4 border rounded shadow-sm">
          <h4>Occupied Rest Houses</h4>
          <h3>12 / 20</h3>
          <span>Rest House Occupied Today</span>
          <span style="color: rgb(204, 18, 18);">↓ 20% since last month</span>
        </div>
      </div>

      <div class="col d-flex">
        <div
          class="undermap flex-fill text-center d-flex flex-column justify-content-center align-items-center p-4 border rounded shadow-sm">
          <h4>Pending Maintenance</h4>
          <h3>8</h3>
          <span>Urgent Maintenance Required</span>
          <span style="color: green;">↑ 2 since yesterday</span>
        </div>
      </div>

    </div>

    <!-- Row 2: Map and Filters -->
    <div class="row g-2 mb-2">
      <!-- Map (60%) -->
      <div class="col-md-12">
        <div class="map-container" id="map" style="box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);">
          <div id="legend" class="map-legend">
            <h4>Legend</h4>
            <div><span class="legend-icon red"></span> Forest HQ</div>
            <div><span class="legend-icon green"></span> Crew Station</div>
            <div><span class="legend-icon blue"></span> Forest Guard Office</div>
          </div>

          <div id="popup" class="ol-popup">
            <div class="popup-closer" id="popup-closer">✖</div>
            <div id="popup-content"></div>
          </div>
        </div>
      </div>
    </div>
    <div id="chartcont" style="display: flex;
    gap: 30px;
    margin-bottom: 26px;
    height: 410px;">
      <!-- Asset Distribution Chart -->
      <div  style="text-align: center;display: flex;justify-content: center;width: 50%;box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);">
       
        <div style="width: 100%;height: 350px;">
           <h2 class="mb-3">Asset Distribution</h2>
          <canvas id="assetChart" style="width: 100%; height: 400px !important;"></canvas>
        </div>
      
      </div>

      <!-- Nursery Sapling Stock Chart -->
      <div class="" style="text-align: center;display: flex;justify-content: center;width: 50%;box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);">
       
         <div style="width: 100%;height: 350px;">
           <h2 class="mb-3">Nursery Sapling Stock (Last 6 Months)</h2>
         <canvas id="saplingChart" style="width: 100%; height: 400px;"></canvas>
        </div>
       
      </div>
    </div>



  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/4.6.5/ol.js"></script>
  <script>
    const iconUrls = {
      hq: 'https://maps.google.com/mapfiles/ms/icons/red-dot.png',
      crew: 'https://maps.google.com/mapfiles/ms/icons/green-dot.png',
      guard: 'https://maps.google.com/mapfiles/ms/icons/blue-dot.png'
    };

    // Sample data with full structure
    const stationData = [
      {
        type: 'hq',
        name: 'Forest HQ 1',
        lon: 78.7,
        lat: 30.1,
        zone: 'Zone A',
        circle: 'Circle X',
        division: 'Division 1',
        range: 'Range Alpha',
            beat: 'Beat 12',
            area: '500 sqm',
            condition: 'Fair',
            occupancy: '15'
      },
      {
        type: 'hq',
        name: 'Forest HQ 2',
        lon: 78.9,
        lat: 30.4,
        zone: 'Zone B',
        circle: 'Circle Y',
        division: 'Division 2',
        range: 'Range Beta',
          beat: 'Beat 3',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'crew',
        name: 'Crew Station 1',
        lon: 78.6,
        lat: 30.2,
        zone: 'Zone C',
        circle: 'Circle Z',
        division: 'Division 3',
        range: 'Range Gamma',
          beat: 'Beat 7',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'crew',
        name: 'Crew Station 2',
        lon: 78.8,
        lat: 30.05,
        zone: 'Zone D',
        circle: 'Circle W',
        division: 'Division 4',
        range: 'Range Delta',
          beat: 'Beat 9',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'crew',
        name: 'Crew Station 3',
        lon: 79.0,
        lat: 30.3,
        zone: 'Zone E',
        circle: 'Circle V',
        division: 'Division 5',
        range: 'Range Epsilon',
          beat: 'Beat 2',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'guard',
        name: 'Guard Office 1',
        lon: 78.55,
        lat: 30.25,
        zone: 'Zone F',
        circle: 'Circle U',
        division: 'Division 6',
        range: 'Range Zeta',
          beat: 'Beat 10',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'guard',
        name: 'Guard Office 2',
        lon: 78.95,
        lat: 30.15,
        zone: 'Zone G',
        circle: 'Circle T',
        division: 'Division 7',
        range: 'Range Eta',
          beat: 'Beat 4',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
        // adsfkkdfj
      },
      {
        type: 'hq',
        name: 'Forest HQ 1',
        lon: 78.54255,
        lat: 30.54255,
        zone: 'Zone A',
        circle: 'Circle X',
        division: 'Division 1',
        range: 'Range Alpha',
          beat: 'Beat 12',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'hq',
        name: 'Forest HQ 2',
        lon: 78.9832856,
        lat: 30.9832856,
        zone: 'Zone B',
        circle: 'Circle Y',
        division: 'Division 2',
        range: 'Range Beta',
          beat: 'Beat 3',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'crew',
        name: 'Crew Station 1',
        lon: 78.68222,
        lat: 30.68222,
        zone: 'Zone C',
        circle: 'Circle Z',
        division: 'Division 3',
        range: 'Range Gamma',
          beat: 'Beat 7',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'crew',
        name: 'Crew Station 2',
        lon: 78.8235448,
        lat: 30.8235448,
        zone: 'Zone D',
        circle: 'Circle W',
        division: 'Division 4',
        range: 'Range Delta',
          beat: 'Beat 9',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'crew',
        name: 'Crew Station 3',
        lon: 79.302415,
        lat: 30.302415,
        zone: 'Zone E',
        circle: 'Circle V',
        division: 'Division 5',
        range: 'Range Epsilon',
          beat: 'Beat 2',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'guard',
        name: 'Guard Office 1',
        lon: 78.521965,
        lat: 30.521965,
        zone: 'Zone F',
        circle: 'Circle U',
        division: 'Division 6',
        range: 'Range Zeta',
          beat: 'Beat 10',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      },
      {
        type: 'guard',
        name: 'Guard Office 2',
        lon: 78.93245,
        lat: 30.93245,
        zone: 'Zone G',
        circle: 'Circle T',
        division: 'Division 7',
        range: 'Range Eta',
          beat: 'Beat 4',
          area: '500 sqm',
          condition: 'Fair',
          occupancy: '15'
      }
    ];

    // Convert data to features
    const features = stationData.map(data => {
      const feature = new ol.Feature({
        geometry: new ol.geom.Point(ol.proj.fromLonLat([data.lon, data.lat])),
        data: data
      });

      feature.setStyle(new ol.style.Style({
        image: new ol.style.Icon({
          src: iconUrls[data.type],
          scale: 1
        })
      }));

      return feature;
    });

    const vectorLayer = new ol.layer.Vector({
      source: new ol.source.Vector({ features: features })
    });

    const map = new ol.Map({
      target: 'map',
      layers: [
        new ol.layer.Tile({ source: new ol.source.OSM() }),
        vectorLayer
      ],
      view: new ol.View({
        center: ol.proj.fromLonLat([78.9, 30.2]),
        zoom: 8
      })
    });

    // Popup functionality
    const popupEl = document.getElementById('popup');
    const popupContent = document.getElementById('popup-content');
    const popupCloser = document.getElementById('popup-closer');

    const popup = new ol.Overlay({
      element: popupEl,
      positioning: 'bottom-center',
      stopEvent: true,
      offset: [0, -15]
    });
    map.addOverlay(popup);

    popupCloser.onclick = function () {
      popup.setPosition(undefined);
      popupCloser.blur();
      return false;
    };

    map.on('singleclick', function (evt) {
      const features = map.getFeaturesAtPixel(evt.pixel);
      if (features.length > 0) {
        const feature = features[0];
        const data = feature.get('data');
        const lonLat = ol.proj.toLonLat(feature.getGeometry().getCoordinates());
        let content = `
          <b>Name:</b> ${data.name}<br>
          <b>Type:</b> ${data.type.toUpperCase()}<br>
          <b>Zone:</b> ${data.zone}<br>
          <b>Circle:</b> ${data.circle}<br>
          <b>Division:</b> ${data.division}<br>
          <b>Range:</b> ${data.range}<br>
          <b>Beat:</b> ${data.beat}<br>
          <b>Area:</b> ${data.area}<br>
          <b>Condition:</b> ${data.condition}<br>
          <b>Occupancy:</b> ${data.occupancy}<br>
          
        `;
        popupContent.innerHTML = content;
        popup.setPosition(evt.coordinate);
      } else {
        popup.setPosition(undefined);
      }
    });
  </script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script>
    const ctx = document.getElementById('assetChart').getContext('2d');
    const assetChart = new Chart(ctx, {
      type: 'pie',
      data: {
        labels: ['Crew Stations', 'Forest Rest Houses', 'Infrastructure', 'Nurseries', 'Other'],
        datasets: [{
          data: [15, 10, 40, 30, 5],
          backgroundColor: [
            '#f97316', // Orange
            '#38bdf8', // Light Blue
            '#3b82f6', // Blue
            '#22c55e', // Green
            '#6b7280'  // Gray
          ],
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: 'bottom',
          },
          tooltip: {
            callbacks: {
              label: function (context) {
                return context.label + ': ' + context.parsed + '%';
              }
            }
          }
        }
      }
    });
  </script>

  <script>
    const ctx1 = document.getElementById('saplingChart').getContext('2d');

    new Chart(ctx1, {
      type: 'line',
      data: {
        labels: ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
        datasets: [{
          label: 'Sapling Stock',
          data: [20000, 35000, 30000, 50000, 70000, 90000],
          borderColor: '#00b26f',
          backgroundColor: 'rgba(0, 178, 111, 0.1)',
          fill: false,
          tension: 0.3,
          pointBackgroundColor: '#fff',
          pointBorderColor: '#00b26f',
          pointRadius: 5,
          pointHoverRadius: 7,
        }]
      },
      options: {
        plugins: { legend: { display: false } },
        scales: {
          y: {
            beginAtZero: true,
            max: 100000,
            ticks: {
              stepSize: 25000
            }
          }
        }
      }
    });
  </script>
    <script>
        const toggleBtn = document.querySelector('.dropdown-toggle');
        const menu = document.querySelector('.dropdown-menu');

        toggleBtn.addEventListener('click', () => {
            menu.classList.toggle('show'); // add/remove "show" class
        });
    </script>
</asp:Content>
