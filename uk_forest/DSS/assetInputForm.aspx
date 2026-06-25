<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="assetInputForm.aspx.cs" Inherits="uk_forest.DSS.assetInputForm" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <title>Asset Entry Form</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/ol@7.3.0/ol.css" rel="stylesheet" />
  <style>
    body {
      background-color: #f8f9fa;
       
    }

    .form-section {
      background: white;
      padding: 25px;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
      margin-top: 25px;
      display: none;
      overflow: hidden;
      /* clear floats */
    }

    .form-section1 {
       
      
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
      margin-top: 25px;
      position: relative;

    }

    .form-section.active {
      display: block;
    }

    .form-title {
      margin-bottom: 20px;
    }

    .map-container {
      height: 200px;
      width: 100%;
      border: 1px solid #ccc;
      border-radius: 8px;
      margin-bottom: 15px;
    }
    a{
        text-decoration:none;
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <asp:Label ID="LabelInContent" runat="server" Text="Asset Input Form" Visible="false" />
  <div class="container">
    <h2 class="mb-4">Asset Entry Form</h2>

    <div class="mb-3">
      <label for="assetCategory" class="form-label">Choose Asset Category</label>
      <select id="assetCategory" class="form-select" onchange="showSection()">
        <option value="nursery">Green Asset (Nursery)</option>
        <option value="infrastructure">Infrastructure</option>
        <option value="control">Control & Crew</option>
        <option value="support">Support Centers</option>
        <option value="resthouse">Training / Rest House</option>
      </select>
    </div>

    <form id="assetForm" onsubmit="handleSubmit(event)">

      <!-- Nursery -->
      <div class="form-section" id="nursery">
        <h4 class="form-title">Green Asset (Nursery)</h4>
        <div class="row g-3">
          <div class="row">
            <div class="col-md-4">
              <label class="form-label">Asset Name</label>
              <select class="form-select" required>
                <option value="">Select Nursery</option>
                <option value="Nursery">Nursery</option>
              </select>
            </div>

            <div class="col-md-4">
              <label class="form-label">Location</label>
              <input type="text" class="form-control" required />
            </div>

            <div class="col-md-4">
              <label class="form-label">Capacity</label>
              <input type="number" class="form-control" required />
            </div>
          </div>
          <div class="row">

            <div class="col-md-4">
              <label class="form-label">Stock Status</label>
              <input type="text" class="form-control" value="Running Low" />
            </div>

            <div class="col-md-4">
              <label class="form-label">Total Stock Available</label>
              <input type="number" class="form-control" required />
            </div>

            <div class="col-md-4">
              <label class="form-label">Species Available</label>
              <input type="text" class="form-control" required />
            </div>
          </div>


          <div class="row">

            <div class="col-md-4">
              <label class="form-label">Latitude</label>
              <input type="text" id="lat-nursery" class="form-control" placeholder="Click on map" />
            </div>

            <div class="col-md-4">
              <label class="form-label">Longitude</label>
              <input type="text" id="lng-nursery" class="form-control" placeholder="Click on map" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Map</label>
              <div id="map-nursery" class="map-container"></div>
            </div>
          </div>


        </div>


      </div>
   

  <!-- Infrastructure -->
  <div class="form-section" id="infrastructure">
    <h4 class="form-title">Infrastructure</h4>
    <div class="row g-3">

<div class="row">
  <div class="col-md-4">
    <label class="form-label">Asset Name</label>
    <select class="form-select" required>
      <option value="">Select Infrastructure</option>
      <option>Division HeadQuarter</option>
      <option>Range HeadQuarter</option>
      <option>Sub Division HeadQuarter</option>
      <option>Main Headquarter</option>
      <option>Beat HeadQuarter</option>
    </select>
  </div>

  <div class="col-md-4">
    <label class="form-label">Location</label>
    <input type="text" class="form-control" required />
  </div>

  <div class="col-md-4">
    <label class="form-label">Occupancy</label>
    <input type="number" class="form-control" required />
  </div>

</div>




    

      <div class="row">
<div class="col-md-4">
        <label class="form-label">Area (ha)</label>
        <input type="number" class="form-control" required />
      </div>

      <div class="col-md-4">
        <label class="form-label">Condition</label>
        <select class="form-select" required>
          <option value="">Select Condition</option>
          <option>Good</option>
          <option>Bad</option>
          <option>Required for Maintenance</option>
        </select>
      </div>

      <div class="col-md-4" style="margin-top: 31px;">
        <button type="button" class="btn btn-warning">Raise Request</button>
      </div>
      </div>
      
<div class="row">
 <div class="col-md-4">
        <label class="form-label">Latitude</label>
        <input type="text" id="lat-infrastructure" class="form-control" placeholder="Click on map"  />
      </div>

      <div class="col-md-4">
        <label class="form-label">Longitude</label>
        <input type="text" id="lng-infrastructure" class="form-control" placeholder="Click on map"  />
      </div>

      <div class="col-md-4">
        <label class="form-label">Map</label>
         <div id="map-infrastructure" class="map-container"></div>
      </div>
</div>
     
    </div>
  </div>

  <!-- Control & Crew -->
  <div class="form-section" id="control">
    <h4 class="form-title">Control & Crew</h4>
    <div class="row g-3">

<div class="row">

      <div class="col-md-4">
        <label class="form-label">Asset Name</label>
        <select class="form-select" required>
          <option value="">Select Control & Crew</option>
          <option>Master Control Room</option>
          <option>Resin Depot</option>
          <option>Forest Guard Chauki</option>
          <option>Barrier/Check Post</option>
          <option>Watch Towers</option>
          <option>Wireless Stations</option>
          <option>Forest Depot</option>
        </select>
      </div>

      <div class="col-md-4">
        <label class="form-label">Location</label>
        <input type="text" class="form-control" required />
      </div>

      <div class="col-md-4">
        <label class="form-label">Staff Count</label>
        <input type="number" class="form-control" required />
      </div>
</div>
<div class="row">
  
      <div class="col-md-4">
        <label class="form-label">Equipments</label>
        <input type="text" class="form-control" required />
      </div>

      <div class="col-md-4">
        <label class="form-label">Condition</label>
        <select class="form-select" required>
          <option value="">Select Condition</option>
          <option>Good</option>
          <option>Bad</option>
          <option>Under Maintenance</option>
        </select>
      </div>

      <div class="col-md-4">
        <label class="form-label">Latitude</label>
        <input type="text" id="lat-control" class="form-control" placeholder="Click on map" readonly />
      </div>
</div>
<div class="row">

 <div class="col-md-4">
        <label class="form-label">Longitude</label>
        <input type="text" id="lng-control" class="form-control" placeholder="Click on map" readonly />
      </div>

      

 <div class="col-md-4">
        <label class="form-label">Map</label>
       <div id="map-control" class="map-container"></div>
      </div>


</div>





      



     
    </div>
  </div>

  <!-- Support Centers -->
  <div class="form-section" id="support">
    <h4 class="form-title">Support Centers</h4>
    <div class="row g-3">
<div class="row">
  
      <div class="col-md-4">
        <label class="form-label">Asset Name</label>
        <select class="form-select" required>
          <option value="">Select Support Center</option>
          <option>Anti Poaching Camp</option>
          <option>Resque Centre</option>
          <option>Repeater Center</option>
        </select>
      </div>

      <div class="col-md-4">
        <label class="form-label">Location</label>
        <input type="text" class="form-control" required />
      </div>

      <div class="col-md-4">
        <label class="form-label">Staff Count</label>
        <input type="number" class="form-control" required />
      </div>
</div>
<div class="row">
  
      <div class="col-md-4">
        <label class="form-label">Availability</label>
        <input type="text" class="form-control" required />
      </div>

      <div class="col-md-4">
        <label class="form-label">Condition</label>
        <select class="form-select" required>
          <option value="">Select Condition</option>
          <option>Good</option>
          <option>Bad</option>
          <option>Under Maintenance</option>
        </select>
      </div>

      <div class="col-md-4">
        <label class="form-label">No. of Available Animals</label>
        <input type="number" class="form-control" required />
      </div>

</div>
<div class="row">
  
      <div class="col-md-4">
        <label class="form-label">Latitude</label>
        <input type="text" id="lat-support" class="form-control" placeholder="Click on map" readonly />
      </div>

      <div class="col-md-4">
        <label class="form-label">Longitude</label>
        <input type="text" id="lng-support" class="form-control" placeholder="Click on map" readonly />
      </div>

       <div class="col-md-4">
        <label class="form-label">Map</label>
         <div id="map-support" class="map-container"></div>
      </div>
</div>

     


    </div>
  </div>

  <!-- Training / Rest House -->
  <div class="form-section" id="resthouse">
    <h4 class="form-title">Training / Rest House</h4>
    <div class="row g-3">

<div class="row">
  
      <div class="col-md-4">
        <label class="form-label">Asset Name</label>
        <select class="form-select" required>
          <option value="">Select Training / Rest House</option>
          <option>Forest Rest House</option>
          <option>Staff Quarters</option>
          <option>Forest Training Center</option>
        </select>
      </div>

      <div class="col-md-4">
        <label class="form-label">Location</label>
        <input type="text" class="form-control" required />
      </div>

      <div class="col-md-4">
        <label class="form-label">Capacity</label>
        <input type="number" class="form-control" required />
      </div>

</div>
<div class="row">
  
      <div class="col-md-4">
        <label class="form-label">Current Occupancy / Staff Count</label>
        <input type="number" class="form-control" required />
      </div>

      <div class="col-md-4">
        <label class="form-label">Number of Rooms / Halls</label>
        <input type="number" class="form-control" required />
      </div>

      <div class="col-md-4">
        <label class="form-label">Area (sq. m or acres)</label>
        <input type="text" class="form-control" required />
      </div>
</div>
<div class="row">
  
      <div class="col-md-4">
        <label class="form-label">Condition</label>
        <select class="form-select" required>
          <option value="">Select Condition</option>
          <option>Good</option>
          <option>Bad</option>
          <option>Under Maintenance</option>
        </select>
      </div>

      <div class="col-md-4">
        <label class="form-label">Accessibility</label>
        <select class="form-select" required>
          <option value="">Select</option>
          <option value="road">Road</option>
          <option value="trail">Trail</option>
          <option value="helicopter">Helicopter</option>
        </select>
      </div>

      <div class="col-md-4">
        <label class="form-label">Latitude</label>
        <input type="text" id="lat-resthouse" class="form-control" placeholder="Click on map" readonly />
      </div>
</div>

<div class="row">
 <div class="col-md-4">
        <label class="form-label">Longitude</label>
        <input type="text" id="lng-resthouse" class="form-control" placeholder="Click on map" readonly />
      </div>

       <div class="col-md-4">
        <label class="form-label">Map</label>
         <div id="map-resthouse" class="map-container"></div>
      </div>
</div>


     



     
    </div>
  </div>

  <div class="form-section1">
    <button type="submit" class="btn btn-primary mt-4" style="right: 0;
    position: absolute;">Submit</button>
  </div>

  </form>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/ol@7.3.0/dist/ol.js"></script>
  <script>
    const assetCategory = document.getElementById('assetCategory');

    // Show/hide form sections based on selection
    function showSection() {
      const val = assetCategory.value;
      document.querySelectorAll('.form-section').forEach(sec => {
        if (sec.id === val) sec.classList.add('active');
        else sec.classList.remove('active');
      });
    }

    showSection(); // show default section on load

    // OpenLayers Map initialization function
    function initMap(id, latInputId, lngInputId) {
      const latInput = document.getElementById(latInputId);
      const lngInput = document.getElementById(lngInputId);

      // Default center (somewhere in India)
      const initialCenter = ol.proj.fromLonLat([78.9629, 20.5937]);

      const map = new ol.Map({
        target: id,
        layers: [
          new ol.layer.Tile({
            source: new ol.source.OSM()
          })
        ],
        view: new ol.View({
          center: initialCenter,
          zoom: 5
        })
      });

      // Marker Layer
      const markerSource = new ol.source.Vector();
      const markerLayer = new ol.layer.Vector({
        source: markerSource
      });
      map.addLayer(markerLayer);

      function addMarker(coord) {
        markerSource.clear();
        const marker = new ol.Feature({
          geometry: new ol.geom.Point(coord)
        });
        markerSource.addFeature(marker);
      }

      map.on('click', function (evt) {
        const coordinate = evt.coordinate;
        const lonLat = ol.proj.toLonLat(coordinate);

        latInput.value = lonLat[1].toFixed(6);
        lngInput.value = lonLat[0].toFixed(6);

        addMarker(coordinate);
      });

      return map;
    }

    // Initialize all maps
    const maps = {
      nursery: initMap('map-nursery', 'lat-nursery', 'lng-nursery'),
      infrastructure: initMap('map-infrastructure', 'lat-infrastructure', 'lng-infrastructure'),
      control: initMap('map-control', 'lat-control', 'lng-control'),
      support: initMap('map-support', 'lat-support', 'lng-support'),
      resthouse: initMap('map-resthouse', 'lat-resthouse', 'lng-resthouse'),
    };

    // Form submit handler (for demo, prevent default and log data)
    function handleSubmit(e) {
      e.preventDefault();
      alert("Form submitted! (Implement your backend integration here)");
    }
  </script>
</asp:Content>
