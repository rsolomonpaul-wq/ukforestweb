<%@ Page Title="Fire Report" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="fireReport.aspx.cs" Inherits="uk_forest.DSS.fireReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .page-title { color: #495057; font-size: 22px; font-weight: bold; margin: 0; }
        .export-btn { background-color: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .export-btn:hover { background-color: #218838; }
      /*  .filter-section { background-color: #f8f9fa; padding: 15px; margin-bottom: 20px; border-radius: 5px; border: 1px solid #dee2e6; }
        .filter-row { display: flex; align-items: center; gap: 15px; flex-wrap: wrap; }
        .filter-item { display: flex; flex-direction: column; min-width: 180px; }
        .filter-item label { font-weight: bold; margin-bottom: 5px; color: #495057; font-size: 13px; }
        .filter-item select { padding: 8px; border: 1px solid #ced4da; border-radius: 4px; font-size: 14px; }
        .btn-search { background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; margin-top: 20px; }
        .btn-search:hover { background-color: #0056b3; }
        .btn-reset { background-color: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; margin-top: 20px; margin-left: 10px; }
        .btn-reset:hover { background-color: #5a6268; }*/

.filter-section { background-color: #f8f9fa; padding: 15px; margin-bottom: 20px; border-radius: 5px; border: 1px solid #dee2e6; }
.filter-row { display: flex; align-items: flex-end; gap: 12px; flex-wrap: wrap; }
.filter-item { display: flex; flex-direction: column; min-width: 160px; }
.filter-item label { font-weight: bold; margin-bottom: 5px; color: #495057; font-size: 13px; }
.filter-item select { padding: 8px; border: 1px solid #ced4da; border-radius: 4px; font-size: 14px; height: 38px; }
.filter-buttons { display: flex; gap: 10px; align-items: flex-end; }
.btn-search { background-color: #007bff; color: white; padding: 8px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; height: 38px; }
.btn-search:hover { background-color: #0056b3; }
.btn-reset { background-color: #6c757d; color: white; padding: 8px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; height: 38px; }
.btn-reset:hover { background-color: #5a6268; }
        .report-table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 10px; }
        .report-table th, .report-table td { border: 1px solid #000; padding: 5px; text-align: center; vertical-align: middle; }
        .report-table th { background-color: #2d5016; color: white; font-weight: bold; font-size: 11px; }
        .report-table tbody tr:nth-child(even) { background-color: #f2f2f2; }
        .report-table tbody tr:hover { background-color: #e9ecef; }
        .total-row { font-weight: bold; background-color: #d4edda !important; }
        .text-right { text-align: right !important; }
        .text-left { text-align: left !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <asp:Label ID="LabelInContent" runat="server" Text="Fire Incident Report" Visible="false" />
    <div class="page-header">
        
        <button type="button" class="export-btn" onclick="return exportToExcel();">📊 Print Report / Export to Excel</button>
    </div>

    <div class="filter-section">
        <div class="filter-row">
            <div class="filter-item">
                <label for="<%=ddlZone.ClientID%>">वृत का नाम / Zone:</label>
                <asp:DropDownList ID="ddlZone" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlZone_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="filter-item">
                <label for="<%=ddlCircle.ClientID%>">सर्कल / Circle:</label>
                <asp:DropDownList ID="ddlCircle" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCircle_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="filter-item">
                <label for="<%=ddlDivision.ClientID%>">प्रभाग का नाम / Division:</label>
                <asp:DropDownList ID="ddlDivision" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDivision_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="filter-item">
                <label for="<%=ddlRange.ClientID%>">रेंज का नाम / Range:</label>
                <asp:DropDownList ID="ddlRange" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlRange_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="filter-item">
    <label for="ddlYear">वर्ष / Year:</label>
    <asp:DropDownList ID="ddlYear" runat="server">
        <asp:ListItem Value="2025">2025</asp:ListItem>
        <asp:ListItem Value="2024">2024</asp:ListItem>
        <asp:ListItem Value="2023">2023</asp:ListItem>
        <asp:ListItem Value="2022">2022</asp:ListItem>
    </asp:DropDownList>
</div>
<div class="filter-buttons">
    <button type="button" class="btn-search" onclick="return filterData();">Search</button>
    <button type="button" class="btn-reset" onclick="return resetFilters();">Reset</button>
</div>
        </div>
    </div>

    <div id="fireReport" style="overflow-x: auto;">
        <table id="fireTable" class="report-table">
            <thead>
                <tr>
                    <th>SNO</th>
                    <th>Division</th>
                    <th>Incident No. In RF</th>
                    <th>Incident No. In Civil Soyam / Van Panchayat</th>
                    <th>Total Incidents</th>
                    <th>Affected RF Area (Ha)</th>
                    <th>Affected Civil Soyam / Van Panchayat Area (Ha)</th>
                    <th>Total Affected Area (Ha)</th>
                    <th>Plantation Affected Area (Ha)</th>
                    <th>Leesa ghao Affected</th>
                    <th>Total No Affected Trees</th>
                    <th>Evaluation of Losses (In Rs.)</th>
                    <th>Persons Wounded</th>
                    <th>Persons Dead</th>
                    <th>Animals Wounded</th>
                    <th>Animals Dead</th>
                    <th>Forest</th>
                    <th>Revenue</th>
                    <th>Police</th>
                    <th>NDRF</th>
                    <th>SDRF</th>
                    <th>Home Guards</th>
                    <th>PRD</th>
                    <th>Local Persons</th>
                    <th>Use of Vehicales</th>
                    <th>Use of Tankers</th>
                </tr>
            </thead>
            <tbody id="fireTableBody"></tbody>
            <tfoot id="fireTableFoot"></tfoot>
        </table>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script type="text/javascript">
        // DUMMY DATA - Fire Incidents
        const fireIncidentData = [
            { sno: 1, division: "DFO (S.C Uttarkashi)", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 0, totalIncidents: 0, affectedRFArea: 0, affectedCivilArea: 0, totalAffectedArea: 0, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 0, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 2, division: "DFO (Tehri DAM 1)", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 0, totalIncidents: 0, affectedRFArea: 0, affectedCivilArea: 0, totalAffectedArea: 0, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 0, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 3, division: "DFO (Tehri DAM 2)", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 0, totalIncidents: 0, affectedRFArea: 0, affectedCivilArea: 0, totalAffectedArea: 0, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 5, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 4, division: "DFO (New Tehri)", zone: "गढ़वाल", circle: "", incidentRF: 4, incidentCivil: 2, totalIncidents: 6, affectedRFArea: 2.9, affectedCivilArea: 1.65, totalAffectedArea: 4.55, plantationArea: 1, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 6750, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 0, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 5, division: "DFO Nainital", zone: "कुमाऊँ", circle: "पूर्व", incidentRF: 6, incidentCivil: 0, totalIncidents: 6, affectedRFArea: 3.35, affectedCivilArea: 0, totalAffectedArea: 3.35, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 10050, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 46, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 23, vehicles: 0, tankers: 0 },
            { sno: 6, division: "DFO Nainital Soil Conservation", zone: "कुमाऊँ", circle: "पूर्व", incidentRF: 0, incidentCivil: 4, totalIncidents: 4, affectedRFArea: 0, affectedCivilArea: 7, totalAffectedArea: 7, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 8000, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 32, revenue: 1, police: 6, ndrf: 0, sdrf: 8, homeGuards: 0, prd: 0, localPersons: 58, vehicles: 0, tankers: 0 },
            { sno: 7, division: "DFO Ramnagar Soil Conservation", zone: "कुमाऊँ", circle: "", incidentRF: 0, incidentCivil: 1, totalIncidents: 1, affectedRFArea: 0, affectedCivilArea: 0.8, totalAffectedArea: 0.8, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 1600, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 1, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 2, vehicles: 0, tankers: 0 },
            { sno: 8, division: "DFO Soil Conservation Ranikhet", zone: "कुमाऊँ", circle: "", incidentRF: 0, incidentCivil: 2, totalIncidents: 2, affectedRFArea: 0, affectedCivilArea: 2, totalAffectedArea: 2, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 6000, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 4, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 1, vehicles: 0, tankers: 0 },
            { sno: 9, division: "DFO Almora", zone: "कुमाऊँ", circle: "", incidentRF: 2, incidentCivil: 0, totalIncidents: 2, affectedRFArea: 3.5, affectedCivilArea: 0, totalAffectedArea: 3.5, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 6500, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 62, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 8, vehicles: 0, tankers: 0 },
            { sno: 10, division: "DFO Civil Soyam Almora", zone: "कुमाऊँ", circle: "", incidentRF: 0, incidentCivil: 1, totalIncidents: 1, affectedRFArea: 0, affectedCivilArea: 4, totalAffectedArea: 4, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 4000, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 1, revenue: 2, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 1, vehicles: 0, tankers: 0 },
            { sno: 11, division: "DFO Bageshwar", zone: "कुमाऊँ", circle: "", incidentRF: 3, incidentCivil: 0, totalIncidents: 3, affectedRFArea: 1.2, affectedCivilArea: 0, totalAffectedArea: 1.2, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 3600, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 4, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 12, division: "DFO Pithoragarh", zone: "कुमाऊँ", circle: "", incidentRF: 9, incidentCivil: 30, totalIncidents: 39, affectedRFArea: 7.75, affectedCivilArea: 25.75, totalAffectedArea: 33.5, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 90500, personsWounded: 1, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 86, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 63, vehicles: 0, tankers: 0 },
            { sno: 13, division: "DFO Champawat", zone: "कुमाऊँ", circle: "", incidentRF: 2, incidentCivil: 5, totalIncidents: 7, affectedRFArea: 4.5, affectedCivilArea: 26.7, totalAffectedArea: 31.2, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 93600, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 22, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 2, vehicles: 0, tankers: 0 },
            { sno: 14, division: "DFO Haldwani", zone: "कुमाऊँ", circle: "", incidentRF: 1, incidentCivil: 0, totalIncidents: 1, affectedRFArea: 0.2, affectedCivilArea: 0, totalAffectedArea: 0.2, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 200, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 5, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 15, division: "DFO Tarai central", zone: "कुमाऊँ", circle: "", incidentRF: 1, incidentCivil: 0, totalIncidents: 1, affectedRFArea: 0.55, affectedCivilArea: 0, totalAffectedArea: 0.55, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 550, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 7, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 16, division: "DFO Tarai East", zone: "कुमाऊँ", circle: "", incidentRF: 6, incidentCivil: 0, totalIncidents: 6, affectedRFArea: 3.53, affectedCivilArea: 0, totalAffectedArea: 3.53, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 3780, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 58, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 17, division: "DFO Tarai West , Ramnagar", zone: "कुमाऊँ", circle: "", incidentRF: 1, incidentCivil: 0, totalIncidents: 1, affectedRFArea: 0.45, affectedCivilArea: 0, totalAffectedArea: 0.45, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 6, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 18, division: "DFO Ramnagar , Ramnagar", zone: "कुमाऊँ", circle: "", incidentRF: 18, incidentCivil: 0, totalIncidents: 18, affectedRFArea: 13.08, affectedCivilArea: 0, totalAffectedArea: 13.08, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 16830, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 171, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 8, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 19, division: "DFO Narendra Nagar", zone: "गढ़वाल", circle: "", incidentRF: 14, incidentCivil: 1, totalIncidents: 15, affectedRFArea: 25.65, affectedCivilArea: 1, totalAffectedArea: 26.65, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 68550, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 140, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 76, vehicles: 0, tankers: 0 },
            { sno: 20, division: "DFO Uttarkashi", zone: "गढ़वाल", circle: "", incidentRF: 18, incidentCivil: 2, totalIncidents: 20, affectedRFArea: 12.5, affectedCivilArea: 5.3, totalAffectedArea: 17.8, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 52500, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 134, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 21, division: "DFO Tons,Purola", zone: "गढ़वाल", circle: "", incidentRF: 1, incidentCivil: 0, totalIncidents: 1, affectedRFArea: 1.5, affectedCivilArea: 0, totalAffectedArea: 1.5, plantationArea: 0, leesaGhao: 1, affectedTrees: 0, evaluationLoss: 4500, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 12, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 22, division: "DFO Mussoorie", zone: "गढ़वाल", circle: "पश्चिम", incidentRF: 4, incidentCivil: 0, totalIncidents: 4, affectedRFArea: 7.25, affectedCivilArea: 0, totalAffectedArea: 7.25, plantationArea: 2.5, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 4750, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 33, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 12, vehicles: 0, tankers: 0 },
            { sno: 23, division: "DFO Chakrata", zone: "गढ़वाल", circle: "पश्चिम", incidentRF: 1, incidentCivil: 4, totalIncidents: 5, affectedRFArea: 1.5, affectedCivilArea: 7.3, totalAffectedArea: 8.8, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 14800, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 55, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 24, division: "DFO Upper Yamuna", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 0, totalIncidents: 0, affectedRFArea: 0, affectedCivilArea: 0, totalAffectedArea: 0, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 0, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 25, division: "DFO Dehradun", zone: "गढ़वाल", circle: "पश्चिम", incidentRF: 5, incidentCivil: 0, totalIncidents: 5, affectedRFArea: 2.22, affectedCivilArea: 0, totalAffectedArea: 2.22, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 3690, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 40, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 26, division: "DFO Soil Conservation, kalsi", zone: "गढ़वाल", circle: "", incidentRF: 5, incidentCivil: 0, totalIncidents: 5, affectedRFArea: 3.75, affectedCivilArea: 0, totalAffectedArea: 3.75, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 6000, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 15, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 27, division: "DFO Lansdowne, kotdwaar", zone: "गढ़वाल", circle: "", incidentRF: 16, incidentCivil: 0, totalIncidents: 16, affectedRFArea: 17.96, affectedCivilArea: 0, totalAffectedArea: 17.96, plantationArea: 0, leesaGhao: 5, affectedTrees: 0, evaluationLoss: 27207, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 321, revenue: 0, police: 4, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 1 },
            { sno: 28, division: "DFO Soil Conservation , Lansdowne", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 18, totalIncidents: 18, affectedRFArea: 0, affectedCivilArea: 15.55, totalAffectedArea: 15.55, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 15550, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 151, revenue: 0, police: 0, ndrf: 0, sdrf:0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 37, vehicles: 0, tankers: 0 },
            { sno: 29, division: "DFO Haridwar", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 0, totalIncidents: 0, affectedRFArea: 0, affectedCivilArea: 0, totalAffectedArea: 0, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 0, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 30, division: "DFO Garhwal", zone: "गढ़वाल", circle: "", incidentRF: 2, incidentCivil: 0, totalIncidents: 2, affectedRFArea: 1.75, affectedCivilArea: 0, totalAffectedArea: 1.75, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 5250, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 6, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 31, division: "DFO Civil Soyam Pauri", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 8, totalIncidents: 8, affectedRFArea: 0, affectedCivilArea: 7.95, totalAffectedArea: 7.95, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 19550, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 29, revenue: 0, police: 7, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 17, vehicles: 0, tankers: 0 },
            { sno: 32, division: "DFO Badrinath, Gopeshwar", zone: "गढ़वाल", circle: "", incidentRF: 10, incidentCivil: 7, totalIncidents: 17, affectedRFArea: 7, affectedCivilArea: 2.46, totalAffectedArea: 9.46, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 26980, personsWounded: 1, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 197, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 10, vehicles: 0, tankers: 0 },
            { sno: 33, division: "DFO Alaknanda Soil Conservation,Gopeshwar", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 7, totalIncidents: 7, affectedRFArea: 0, affectedCivilArea: 8.5, totalAffectedArea: 8.5, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 20500, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 34, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 42, vehicles: 0, tankers: 0 },
            { sno: 34, division: "DFO Rudraprayag , Rudraprayag", zone: "गढ़वाल", circle: "", incidentRF: 4, incidentCivil: 9, totalIncidents: 13, affectedRFArea: 4.75, affectedCivilArea: 16, totalAffectedArea: 20.75, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 62250, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 46, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 35, division: "Dy. Director (Raja ji NP)", zone: "गढ़वाल", circle: "", incidentRF: 5, incidentCivil: 0, totalIncidents: 5, affectedRFArea: 9.7, affectedCivilArea: 0, totalAffectedArea: 9.7, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 9700, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 105, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 25, vehicles: 0, tankers: 0 },
            { sno: 36, division: "Dy. Director (Kalagarh TR/ Division)", zone: "कुमाऊँ", circle: "", incidentRF: 1, incidentCivil: 0, totalIncidents: 1, affectedRFArea: 0.25, affectedCivilArea: 0, totalAffectedArea: 0.25, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 17, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 37, division: "Dy. Director (Corbett TR/ Division)", zone: "कुमाऊँ", circle: "", incidentRF: 0, incidentCivil: 0, totalIncidents: 0, affectedRFArea: 0, affectedCivilArea: 0, totalAffectedArea: 0, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 0, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 38, division: "DCF - NDNP", zone: "गढ़वाल", circle: "", incidentRF: 2, incidentCivil: 4, totalIncidents: 6, affectedRFArea: 10, affectedCivilArea: 10.5, totalAffectedArea: 20.5, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 20500, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 23, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 23, vehicles: 0, tankers: 0 },
            { sno: 39, division: "DCF - KedarNath WL Division", zone: "गढ़वाल", circle: "", incidentRF: 15, incidentCivil: 7, totalIncidents: 22, affectedRFArea: 19.4, affectedCivilArea: 2.3, totalAffectedArea: 21.7, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 30500, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 91, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 19, vehicles: 0, tankers: 0 },
            { sno: 40, division: "Deputy Director Govind Wildlife Sanctuary", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 0, totalIncidents: 0, affectedRFArea: 0, affectedCivilArea: 0, totalAffectedArea: 0, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 0, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 },
            { sno: 41, division: "Gangotri National Park", zone: "गढ़वाल", circle: "", incidentRF: 0, incidentCivil: 0, totalIncidents: 0, affectedRFArea: 0, affectedCivilArea: 0, totalAffectedArea: 0, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0, personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 0, revenue: 0, police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0 }
        ];
        
        let filteredFireData = [...fireIncidentData];

        document.addEventListener('DOMContentLoaded', function () {
            renderFireReport();
        });

        function resetFilters() {
            // Reset all dropdowns to first option
            document.getElementById('<%=ddlZone.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlCircle.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlDivision.ClientID%>').selectedIndex = 0;
    document.getElementById('<%=ddlRange.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlYear.ClientID%>').selectedIndex = 0;

            // Reset filtered data to original
            filteredFireData = [...fireIncidentData];
            renderFireReport();

            return false; // Prevent postback
        }

        function renderFireReport() {
            populateFireTable(filteredFireData);
            calculateFireTotals(filteredFireData);
        }

        function populateFireTable(data) {
            const tbody = document.getElementById('fireTableBody');
            tbody.innerHTML = '';
            
            if (!data.length) {
                tbody.innerHTML = '<tr><td colspan="26" style="text-align: center; padding: 20px;">कोई डेटा उपलब्ध नहीं है</td></tr>';
                return;
            }
            
            data.forEach(item => {
                const row = tbody.insertRow();
                row.innerHTML = `
                    <td>${item.sno}</td>
                    <td class="text-left">${item.division}</td>
                    <td class="text-right">${item.incidentRF}</td>
                    <td class="text-right">${item.incidentCivil}</td>
                    <td class="text-right">${item.totalIncidents}</td>
                    <td class="text-right">${item.affectedRFArea.toFixed(2)}</td>
                    <td class="text-right">${item.affectedCivilArea.toFixed(2)}</td>
                    <td class="text-right">${item.totalAffectedArea.toFixed(2)}</td>
                    <td class="text-right">${item.plantationArea.toFixed(2)}</td>
                    <td class="text-right">${item.leesaGhao}</td>
                    <td class="text-right">${item.affectedTrees}</td>
                    <td class="text-right">${item.evaluationLoss.toLocaleString()}</td>
                    <td class="text-right">${item.personsWounded}</td>
                    <td class="text-right">${item.personsDead}</td>
                    <td class="text-right">${item.animalsWounded}</td>
                    <td class="text-right">${item.animalsDead}</td>
                    <td class="text-right">${item.forest}</td>
                    <td class="text-right">${item.revenue}</td>
                    <td class="text-right">${item.police}</td>
                    <td class="text-right">${item.ndrf}</td>
                    <td class="text-right">${item.sdrf}</td>
                    <td class="text-right">${item.homeGuards}</td>
                    <td class="text-right">${item.prd}</td>
                    <td class="text-right">${item.localPersons}</td>
                    <td class="text-right">${item.vehicles}</td>
                    <td class="text-right">${item.tankers}</td>
                `;
            });
        }

        function calculateFireTotals(data) {
            const tfoot = document.getElementById('fireTableFoot');
            if (!data.length) { 
                tfoot.innerHTML = ''; 
                return; 
            }
            
            const totals = data.reduce((acc, item) => ({
                incidentRF: acc.incidentRF + item.incidentRF,
                incidentCivil: acc.incidentCivil + item.incidentCivil,
                totalIncidents: acc.totalIncidents + item.totalIncidents,
                affectedRFArea: acc.affectedRFArea + item.affectedRFArea,
                affectedCivilArea: acc.affectedCivilArea + item.affectedCivilArea,
                totalAffectedArea: acc.totalAffectedArea + item.totalAffectedArea,
                plantationArea: acc.plantationArea + item.plantationArea,
                leesaGhao: acc.leesaGhao + item.leesaGhao,
                affectedTrees: acc.affectedTrees + item.affectedTrees,
                evaluationLoss: acc.evaluationLoss + item.evaluationLoss,
                personsWounded: acc.personsWounded + item.personsWounded,
                personsDead: acc.personsDead + item.personsDead,
                animalsWounded: acc.animalsWounded + item.animalsWounded,
                animalsDead: acc.animalsDead + item.animalsDead,
                forest: acc.forest + item.forest,
                revenue: acc.revenue + item.revenue,
                police: acc.police + item.police,
                ndrf: acc.ndrf + item.ndrf,
                sdrf: acc.sdrf + item.sdrf,
                homeGuards: acc.homeGuards + item.homeGuards,
                prd: acc.prd + item.prd,
                localPersons: acc.localPersons + item.localPersons,
                vehicles: acc.vehicles + item.vehicles,
                tankers: acc.tankers + item.tankers
            }), {
                incidentRF: 0, incidentCivil: 0, totalIncidents: 0, affectedRFArea: 0, affectedCivilArea: 0,
                totalAffectedArea: 0, plantationArea: 0, leesaGhao: 0, affectedTrees: 0, evaluationLoss: 0,
                personsWounded: 0, personsDead: 0, animalsWounded: 0, animalsDead: 0, forest: 0, revenue: 0,
                police: 0, ndrf: 0, sdrf: 0, homeGuards: 0, prd: 0, localPersons: 0, vehicles: 0, tankers: 0
            });
            
            tfoot.innerHTML = `
                <tr class="total-row">
                    <td colspan="2"><strong>Grand Total</strong></td>
                    <td class="text-right"><strong>${totals.incidentRF}</strong></td>
                    <td class="text-right"><strong>${totals.incidentCivil}</strong></td>
                    <td class="text-right"><strong>${totals.totalIncidents}</strong></td>
                    <td class="text-right"><strong>${totals.affectedRFArea.toFixed(2)}</strong></td>
                    <td class="text-right"><strong>${totals.affectedCivilArea.toFixed(2)}</strong></td>
                    <td class="text-right"><strong>${totals.totalAffectedArea.toFixed(2)}</strong></td>
                    <td class="text-right"><strong>${totals.plantationArea.toFixed(2)}</strong></td>
                    <td class="text-right"><strong>${totals.leesaGhao}</strong></td>
                    <td class="text-right"><strong>${totals.affectedTrees}</strong></td>
                    <td class="text-right"><strong>${totals.evaluationLoss.toLocaleString()}</strong></td>
                    <td class="text-right"><strong>${totals.personsWounded}</strong></td>
                    <td class="text-right"><strong>${totals.personsDead}</strong></td>
                    <td class="text-right"><strong>${totals.animalsWounded}</strong></td>
                    <td class="text-right"><strong>${totals.animalsDead}</strong></td>
                    <td class="text-right"><strong>${totals.forest}</strong></td>
                    <td class="text-right"><strong>${totals.revenue}</strong></td>
                    <td class="text-right"><strong>${totals.police}</strong></td>
                    <td class="text-right"><strong>${totals.ndrf}</strong></td>
                    <td class="text-right"><strong>${totals.sdrf}</strong></td>
                    <td class="text-right"><strong>${totals.homeGuards}</strong></td>
                    <td class="text-right"><strong>${totals.prd}</strong></td>
                    <td class="text-right"><strong>${totals.localPersons}</strong></td>
                    <td class="text-right"><strong>${totals.vehicles}</strong></td>
                    <td class="text-right"><strong>${totals.tankers}</strong></td>
                </tr>
            `;
        }

        function filterData() {
            const z = document.getElementById('<%=ddlZone.ClientID%>').value;
            const c = document.getElementById('<%=ddlCircle.ClientID%>').value;
            const d = document.getElementById('<%=ddlDivision.ClientID%>').value;
            const r = document.getElementById('<%=ddlRange.ClientID%>').value;

            filteredFireData = fireIncidentData.filter(i =>
                (!z || i.zone === z) &&
                (!c || i.circle === c) &&
                (!d || i.division === d)
            );

            renderFireReport();
            return false;
        }

        function exportToExcel() {
            const tbl = document.getElementById('fireTable');
            const wb = XLSX.utils.table_to_book(tbl);
            XLSX.writeFile(wb, `Fire_Incident_Report_${new Date().toISOString().split('T')[0]}.xlsx`);
            return false;
        }
    </script>
</asp:Content>