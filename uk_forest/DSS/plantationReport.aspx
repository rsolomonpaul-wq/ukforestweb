<%@ Page Title="Plantation Report" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="plantationReport.aspx.cs" Inherits="uk_forest.DSS.plantationReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .page-title {
            color: #495057;
            font-size: 24px;
            font-weight: bold;
            margin: 0;
        }
        .export-btn {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .export-btn:hover {
            background-color: #218838;
        }
      /*  .filter-section {
            background-color: #f8f9fa;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            border: 1px solid #dee2e6;
        }
        .filter-row {
            display: flex;
            align-items: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }
        .filter-item {
            display: flex;
            flex-direction: column;
            min-width: 160px;
        }
        .filter-item label {
            font-weight: bold;
            margin-bottom: 5px;
            color: #495057;
            font-size: 13px;
        }
        .filter-item select {
            padding: 8px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
            height: 38px;
        }
        .filter-buttons {
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }
        .btn-search {
            background-color: #007bff;
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            height: 38px;
        }
        .btn-search:hover {
            background-color: #0056b3;
        }
        .btn-reset {
            background-color: #6c757d;
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            height: 38px;
        }
        .btn-reset:hover {
            background-color: #5a6268;
        }*/

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
        .report-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 12px;
        }
        .report-table th, .report-table td {
            border: 1px solid #000;
            padding: 8px;
            text-align: center;
            vertical-align: middle;
        }
        .report-table th {
            background-color: #e9ecef;
            font-weight: bold;
            color: #495057;
        }
        .main-header {
            background-color: #d4edda;
            font-weight: bold;
        }
        .sub-header {
            background-color: #fff3cd;
            font-size: 11px;
        }
        .total-row {
            font-weight: bold;
            background-color: #f8f9fa;
        }
        .hidden {
            display: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
          <asp:Label ID="LabelInContent" runat="server" Text="Plantation Report" Visible="false" />
       <%-- <h1 class="page-title">वृक्षारोपण रिपोर्ट (Plantation Report)</h1>--%>
        <button id="btnExport" class="export-btn" onclick="exportToExcel(); return false;">
            Export to Excel
        </button>
    </div>

    <!-- Filter Section -->
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
                <asp:DropDownList ID="ddlRange" runat="server" AutoPostBack="false">
                </asp:DropDownList>
            </div>
    <%--        <div class="filter-item">
                <label for="<%=ddlYear.ClientID%>">वर्ष / Year:</label>
                <asp:DropDownList ID="ddlYear" runat="server">
                    <asp:ListItem Value="">All Years</asp:ListItem>
                    <asp:ListItem Value="2025" Selected="True">2025</asp:ListItem>
                    <asp:ListItem Value="2024">2024</asp:ListItem>
                    <asp:ListItem Value="2023">2023</asp:ListItem>
                    <asp:ListItem Value="2022">2022</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="filter-buttons">
                <button type="button" class="btn-search" onclick="filterData(); return false;">Search</button>
                <button type="button" class="btn-reset" onclick="resetFilters(); return false;">Reset</button>
            </div>--%>
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

    <!-- Report Table -->
    <div style="overflow-x: auto;">
        <table id="reportTable" class="report-table">
            <thead>
                <tr class="main-header">
                    <th rowspan="2">क्र.सं.</th>
                    <th rowspan="2">जोन</th>
                    <th rowspan="2">सर्कल</th>
                    <th rowspan="2">डिवीजन</th>
                    <th rowspan="2">रेंज</th>
                    <th rowspan="2">वर्ष</th>
                    <th colspan="2">विभागीय/कृत्रिम वृक्षारोपण – लक्ष्य (हे.)</th>
                    <th colspan="2">वृहद वृक्षारोपण – लक्ष्य (हे.)</th>
                    <th colspan="2">वृहद वृक्षारोपण – उपलब्धि (लाख)</th>
                    <th colspan="2">विभागीय वृक्षारोपण की प्रगति-लक्ष्य (हे.)</th>
                    <th colspan="2">विभागीय वृक्षारोपण की प्रगति- उपलब्धि (लाख)</th>
                    <th rowspan="2">Total Achievement</th>
                </tr>
                <tr class="sub-header">
                    <th>हैक्टर</th>
                    <th>पौध संख्या (लाख में)</th>
                    <th>हैक्टर</th>
                    <th>पौध संख्या (लाख में)</th>
                    <th>हैक्टर</th>
                    <th>पौध संख्या (लाख में)</th>
                    <th>हैक्टर</th>
                    <th>पौध संख्या (लाख में)</th>
                    <th>हैक्टर</th>
                    <th>पौध संख्या (लाख में)</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                <!-- Data will be populated by JavaScript -->
            </tbody>
            <tfoot id="tableFoot">
                <!-- Total row will be populated by JavaScript -->
            </tfoot>
        </table>
    </div>

    <script type="text/javascript">
        // Static data for the plantation report with zone, circle, division, range, and year
        const plantationData = [
            { srNo: 1, zone: "उत्तराखंड पूर्व", circle: "नैनीताल सर्कल", division: "DFO Nainital", range: "नैनीताल", year: 2025, depArtTargetHa: 120, depArtTargetPlants: 2.8, largeTargetHa: 180, largeTargetPlants: 4.2, largeAchieveHa: 165, largeAchievePlants: 3.8, depProgTargetHa: 95, depProgTargetPlants: 2.2, depProgAchieveHa: 110, depProgAchievePlants: 2.5, totalAchievement: 470 },
            { srNo: 2, zone: "उत्तराखंड पूर्व", circle: "नैनीताल सर्कल", division: "DFO Nainital", range: "भीमताल", year: 2025, depArtTargetHa: 100, depArtTargetPlants: 2.3, largeTargetHa: 150, largeTargetPlants: 3.5, largeAchieveHa: 140, largeAchievePlants: 3.2, depProgTargetHa: 80, depProgTargetPlants: 1.9, depProgAchieveHa: 92, depProgAchievePlants: 2.1, totalAchievement: 382 },
            { srNo: 3, zone: "उत्तराखंड पूर्व", circle: "अल्मोड़ा सर्कल", division: "DFO Almora", range: "अल्मोड़ा", year: 2025, depArtTargetHa: 90, depArtTargetPlants: 2.1, largeTargetHa: 140, largeTargetPlants: 3.3, largeAchieveHa: 130, largeAchievePlants: 3.0, depProgTargetHa: 75, depProgTargetPlants: 1.8, depProgAchieveHa: 85, depProgAchievePlants: 2.0, totalAchievement: 360 },
            { srNo: 4, zone: "उत्तराखंड पूर्व", circle: "अल्मोड़ा सर्कल", division: "DFO Almora", range: "द्वाराहाट", year: 2024, depArtTargetHa: 85, depArtTargetPlants: 2.0, largeTargetHa: 130, largeTargetPlants: 3.0, largeAchieveHa: 120, largeAchievePlants: 2.8, depProgTargetHa: 70, depProgTargetPlants: 1.6, depProgAchieveHa: 80, depProgAchievePlants: 1.9, totalAchievement: 340 },
            { srNo: 5, zone: "उत्तराखंड पश्चिम", circle: "देहरादून सर्कल", division: "DFO Dehradun", range: "देहरादून", year: 2025, depArtTargetHa: 200, depArtTargetPlants: 4.6, largeTargetHa: 250, largeTargetPlants: 5.8, largeAchieveHa: 230, largeAchievePlants: 5.3, depProgTargetHa: 170, depProgTargetPlants: 3.9, depProgAchieveHa: 185, depProgAchievePlants: 4.3, totalAchievement: 785 },
            { srNo: 6, zone: "उत्तराखंड पश्चिम", circle: "देहरादून सर्कल", division: "DFO Mussoorie", range: "मसूरी", year: 2025, depArtTargetHa: 110, depArtTargetPlants: 2.5, largeTargetHa: 160, largeTargetPlants: 3.7, largeAchieveHa: 145, largeAchievePlants: 3.4, depProgTargetHa: 95, depProgTargetPlants: 2.2, depProgAchieveHa: 105, depProgAchievePlants: 2.4, totalAchievement: 455 },
            { srNo: 7, zone: "उत्तराखंड पश्चिम", circle: "हरिद्वार सर्कल", division: "DFO Haridwar", range: "हरिद्वार", year: 2025, depArtTargetHa: 150, depArtTargetPlants: 3.4, largeTargetHa: 190, largeTargetPlants: 4.4, largeAchieveHa: 175, largeAchievePlants: 4.0, depProgTargetHa: 120, depProgTargetPlants: 2.8, depProgAchieveHa: 135, depProgAchievePlants: 3.1, totalAchievement: 580 },
            { srNo: 8, zone: "उत्तराखंड पश्चिम", circle: "हरिद्वार सर्कल", division: "DFO Haridwar", range: "रुड़की", year: 2024, depArtTargetHa: 130, depArtTargetPlants: 3.0, largeTargetHa: 170, largeTargetPlants: 3.9, largeAchieveHa: 155, largeAchievePlants: 3.6, depProgTargetHa: 100, depProgTargetPlants: 2.3, depProgAchieveHa: 115, depProgAchievePlants: 2.7, totalAchievement: 500 },
            { srNo: 9, zone: "उत्तराखंड उत्तर", circle: "चमोली सर्कल", division: "DFO Chamoli", range: "चमोली", year: 2025, depArtTargetHa: 90, depArtTargetPlants: 2.1, largeTargetHa: 130, largeTargetPlants: 3.0, largeAchieveHa: 115, largeAchievePlants: 2.7, depProgTargetHa: 75, depProgTargetPlants: 1.7, depProgAchieveHa: 85, depProgAchievePlants: 2.0, totalAchievement: 365 },
            { srNo: 10, zone: "उत्तराखंड उत्तर", circle: "चमोली सर्कल", division: "DFO Badrinath", range: "जोशीमठ", year: 2025, depArtTargetHa: 80, depArtTargetPlants: 1.9, largeTargetHa: 120, largeTargetPlants: 2.8, largeAchieveHa: 105, largeAchievePlants: 2.4, depProgTargetHa: 65, depProgTargetPlants: 1.5, depProgAchieveHa: 75, depProgAchievePlants: 1.7, totalAchievement: 325 },
            { srNo: 11, zone: "उत्तराखंड उत्तर", circle: "उत्तरकाशी सर्कल", division: "DFO Uttarkashi", range: "उत्तरकाशी", year: 2025, depArtTargetHa: 110, depArtTargetPlants: 2.5, largeTargetHa: 160, largeTargetPlants: 3.7, largeAchieveHa: 145, largeAchievePlants: 3.4, depProgTargetHa: 100, depProgTargetPlants: 2.3, depProgAchieveHa: 115, depProgAchievePlants: 2.7, totalAchievement: 470 },
            { srNo: 12, zone: "उत्तराखंड उत्तर", circle: "उत्तरकाशी सर्कल", division: "DFO Purola", range: "पुरोला", year: 2024, depArtTargetHa: 95, depArtTargetPlants: 2.2, largeTargetHa: 140, largeTargetPlants: 3.2, largeAchieveHa: 125, largeAchievePlants: 2.9, depProgTargetHa: 85, depProgTargetPlants: 2.0, depProgAchieveHa: 95, depProgAchievePlants: 2.2, totalAchievement: 400 },
            { srNo: 13, zone: "उत्तराखंड दक्षिण", circle: "पिथौरागढ़ सर्कल", division: "DFO Pithoragarh", range: "पिथौरागढ़", year: 2025, depArtTargetHa: 80, depArtTargetPlants: 1.8, largeTargetHa: 120, largeTargetPlants: 2.8, largeAchieveHa: 105, largeAchievePlants: 2.4, depProgTargetHa: 65, depProgTargetPlants: 1.5, depProgAchieveHa: 75, depProgAchievePlants: 1.7, totalAchievement: 305 },
            { srNo: 14, zone: "उत्तराखंड दक्षिण", circle: "पिथौरागढ़ सर्कल", division: "DFO Pithoragarh", range: "मुनस्यारी", year: 2025, depArtTargetHa: 70, depArtTargetPlants: 1.6, largeTargetHa: 100, largeTargetPlants: 2.3, largeAchieveHa: 90, largeAchievePlants: 2.1, depProgTargetHa: 60, depProgTargetPlants: 1.4, depProgAchieveHa: 68, depProgAchievePlants: 1.6, totalAchievement: 288 },
            { srNo: 15, zone: "उत्तराखंड दक्षिण", circle: "बागेश्वर सर्कल", division: "DFO Bageshwar", range: "बागेश्वर", year: 2025, depArtTargetHa: 75, depArtTargetPlants: 1.7, largeTargetHa: 110, largeTargetPlants: 2.5, largeAchieveHa: 95, largeAchievePlants: 2.2, depProgTargetHa: 65, depProgTargetPlants: 1.5, depProgAchieveHa: 72, depProgAchievePlants: 1.7, totalAchievement: 300 },
            { srNo: 16, zone: "उत्तराखंड दक्षिण", circle: "बागेश्वर सर्कल", division: "DFO Bageshwar", range: "कपकोट", year: 2023, depArtTargetHa: 65, depArtTargetPlants: 1.5, largeTargetHa: 95, largeTargetPlants: 2.2, largeAchieveHa: 80, largeAchievePlants: 1.8, depProgTargetHa: 55, depProgTargetPlants: 1.3, depProgAchieveHa: 62, depProgAchievePlants: 1.4, totalAchievement: 260 }
        ];

        let filteredData = [...plantationData];

        // Initialize page
        (function () {
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initializePage);
            } else {
                initializePage();
            }
        })();

        function initializePage() {
            populateTable(plantationData);
            calculateTotals(plantationData);
        }

        // Populate table with data
        function populateTable(data) {
            const tbody = document.getElementById('tableBody');
            tbody.innerHTML = '';

            if (!data.length) {
                tbody.innerHTML = '<tr><td colspan="17" style="text-align: center; padding: 20px;">कोई डेटा उपलब्ध नहीं है / No Data Available</td></tr>';
                return;
            }

            data.forEach(item => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${item.srNo}</td>
                    <td>${item.zone}</td>
                    <td>${item.circle}</td>
                    <td>${item.division}</td>
                    <td>${item.range}</td>
                    <td>${item.year}</td>
                    <td>${item.depArtTargetHa}</td>
                    <td>${item.depArtTargetPlants}</td>
                    <td>${item.largeTargetHa}</td>
                    <td>${item.largeTargetPlants}</td>
                    <td>${item.largeAchieveHa}</td>
                    <td>${item.largeAchievePlants}</td>
                    <td>${item.depProgTargetHa}</td>
                    <td>${item.depProgTargetPlants}</td>
                    <td>${item.depProgAchieveHa}</td>
                    <td>${item.depProgAchievePlants}</td>
                    <td>${item.totalAchievement}</td>
                `;
                tbody.appendChild(row);
            });
        }

        // Calculate and display totals
        function calculateTotals(data) {
            const tfoot = document.getElementById('tableFoot');

            if (!data.length) {
                tfoot.innerHTML = '';
                return;
            }

            const totals = data.reduce((acc, item) => {
                acc.depArtTargetHa += item.depArtTargetHa;
                acc.depArtTargetPlants += item.depArtTargetPlants;
                acc.largeTargetHa += item.largeTargetHa;
                acc.largeTargetPlants += item.largeTargetPlants;
                acc.largeAchieveHa += item.largeAchieveHa;
                acc.largeAchievePlants += item.largeAchievePlants;
                acc.depProgTargetHa += item.depProgTargetHa;
                acc.depProgTargetPlants += item.depProgTargetPlants;
                acc.depProgAchieveHa += item.depProgAchieveHa;
                acc.depProgAchievePlants += item.depProgAchievePlants;
                acc.totalAchievement += item.totalAchievement;
                return acc;
            }, {
                depArtTargetHa: 0,
                depArtTargetPlants: 0,
                largeTargetHa: 0,
                largeTargetPlants: 0,
                largeAchieveHa: 0,
                largeAchievePlants: 0,
                depProgTargetHa: 0,
                depProgTargetPlants: 0,
                depProgAchieveHa: 0,
                depProgAchievePlants: 0,
                totalAchievement: 0
            });

            tfoot.innerHTML = `
                <tr class="total-row">
                    <td colspan="6"><strong>Total / कुल योग</strong></td>
                    <td><strong>${totals.depArtTargetHa}</strong></td>
                    <td><strong>${totals.depArtTargetPlants.toFixed(1)}</strong></td>
                    <td><strong>${totals.largeTargetHa}</strong></td>
                    <td><strong>${totals.largeTargetPlants.toFixed(1)}</strong></td>
                    <td><strong>${totals.largeAchieveHa}</strong></td>
                    <td><strong>${totals.largeAchievePlants.toFixed(1)}</strong></td>
                    <td><strong>${totals.depProgTargetHa}</strong></td>
                    <td><strong>${totals.depProgTargetPlants.toFixed(1)}</strong></td>
                    <td><strong>${totals.depProgAchieveHa}</strong></td>
                    <td><strong>${totals.depProgAchievePlants.toFixed(1)}</strong></td>
                    <td><strong>${totals.totalAchievement}</strong></td>
                </tr>
            `;
        }

        // Filter data based on selected filters
        function filterData() {
            const zoneDropdown = document.getElementById('<%=ddlZone.ClientID%>');
            const circleDropdown = document.getElementById('<%=ddlCircle.ClientID%>');
            const divisionDropdown = document.getElementById('<%=ddlDivision.ClientID%>');
            const rangeDropdown = document.getElementById('<%=ddlRange.ClientID%>');
            const yearDropdown = document.getElementById('<%=ddlYear.ClientID%>');
            
            const selectedZone = zoneDropdown.options[zoneDropdown.selectedIndex].text;
            const selectedCircle = circleDropdown.options[circleDropdown.selectedIndex].text;
            const selectedDivision = divisionDropdown.options[divisionDropdown.selectedIndex].text;
            const selectedRange = rangeDropdown.options[rangeDropdown.selectedIndex].text;
            const selectedYear = yearDropdown.value;

            filteredData = plantationData.filter(item => {
                const zoneMatch = selectedZone === 'All Zones' || selectedZone === '' || item.zone === selectedZone;
                const circleMatch = selectedCircle === 'All Circles' || selectedCircle === '' || item.circle === selectedCircle;
                const divisionMatch = selectedDivision === 'All Divisions' || selectedDivision === '' || item.division === selectedDivision;
                const rangeMatch = selectedRange === 'All Ranges' || selectedRange === '' || item.range === selectedRange;
                const yearMatch = !selectedYear || item.year.toString() === selectedYear;
                
                return zoneMatch && circleMatch && divisionMatch && rangeMatch && yearMatch;
            });

            populateTable(filteredData);
            calculateTotals(filteredData);

            return false;
        }

        // Reset all filters
        function resetFilters() {
            document.getElementById('<%=ddlZone.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlCircle.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlDivision.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlRange.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlYear.ClientID%>').selectedIndex = 0;

            filteredData = [...plantationData];
            populateTable(filteredData);
            calculateTotals(filteredData);

            return false;
        }

        // Export to Excel function
        function exportToExcel() {
            if (typeof XLSX === 'undefined') {
                alert('Excel export library not loaded. Please refresh the page.');
                return false;
            }

            const table = document.getElementById('reportTable');
            const wb = XLSX.utils.table_to_book(table);
            const filename = 'Plantation_Report_' + new Date().toISOString().split('T')[0] + '.xlsx';
            XLSX.writeFile(wb, filename);
            return false;
        }
    </script>

    <!-- Add XLSX library for Excel export -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
</asp:Content>