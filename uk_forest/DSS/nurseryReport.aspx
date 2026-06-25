<%@ Page Title="Nursery Report" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="nurseryReport.aspx.cs" Inherits="uk_forest.DSS.nurseryReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .page-title { color: #495057; font-size: 24px; font-weight: bold; margin: 0; }
        .export-btn { background-color: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .export-btn:hover { background-color: #218838; }
       /* .filter-section { background-color: #f8f9fa; padding: 15px; margin-bottom: 20px; border-radius: 5px; border: 1px solid #dee2e6; }
        .filter-row { display: flex; align-items: center; gap: 15px; flex-wrap: wrap; }
        .filter-item { display: flex; flex-direction: column; min-width: 180px; }
        .filter-item label { font-weight: bold; margin-bottom: 5px; color: #495057; }
        .filter-item select { padding: 8px; border: 1px solid #ced4da; border-radius: 4px; font-size: 14px; }*/
        .report-type-toggle { display: flex; gap: 10px; margin-bottom: 15px; }
        .toggle-btn {padding: 8px 20px; border:2px solid #007bff; background-color: white; color: #007bff; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; }
        .toggle-btn.active { background-color: #007bff; color: white; }
        .toggle-btn:hover { background-color: #e7f1ff; }
        .toggle-btn.active:hover { background-color: #0056b3; }
       /* .btn-search { background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; margin-top: 20px; }
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
        .report-table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 11px; }
        .report-table th, .report-table td { border: 1px solid #000; padding: 6px; text-align: center; vertical-align: middle; }
        .report-table th { background-color: #e9ecef; font-weight: bold; color: #495057; }
        .main-header { background-color: #d4edda; font-weight: bold; font-size: 12px; }
        .sub-header { background-color: #fff3cd; font-size: 10px; }
        .total-row { font-weight: bold; background-color: #f8f9fa; }
        .group-row { background-color: #e9ecef; font-weight: bold; }
        .hidden { display: none !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <asp:Label ID="LabelInContent" runat="server" Text="Nursery Report" Visible="false" />
    <div class="page-header">
       <%-- <h1 class="page-title">पौधालयों में उपलब्ध पौध रिपोर्ट (Nursery Plant Report)</h1>--%>
        <button type="button" class="export-btn" onclick="return exportToExcel();">📊 Export to Excel</button>
    </div>

    <div class="report-type-toggle">
        <button type="button" class="toggle-btn active" id="btnSummary" onclick="return switchReport('summary');">Summary Report / सारांश रिपोर्ट</button>
        <button type="button" class="toggle-btn" id="btnDetailed" onclick="return switchReport('detailed');">Detailed Report / विस्तृत रिपोर्ट</button>
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

    <div id="summaryReport" style="overflow-x: auto;">
        <h3 style="color: #495057; margin-bottom: 10px;">पौधालयों में उपलब्ध पौध का वृतवार/प्रभागवार/सारांश</h3>
        <table id="summaryTable" class="report-table">
            <thead>
                <tr class="main-header">
                    <th colspan="2">SUM of माह अगस्त 2025 पौधालयो में उपलब्ध पौध संख्या</th>
                    <th colspan="7">प्रजाति वर्ग</th>
                    <th rowspan="2">Grand Total</th>
                </tr>
                <tr class="sub-header">
                    <th>वृत्त का नाम</th>
                    <th>प्रभाग का नाम</th>
                    <th>1 प्रकाष्ठ/औद्योगिक</th>
                    <th>2 फलदार</th>
                    <th>3 औषधीय</th>
                    <th>4 चारा</th>
                    <th>5 जलौनी</th>
                    <th>6 पथ सुंदरीकरण</th>
                    <th>7 विविध/अन्य</th>
                </tr>
            </thead>
            <tbody id="summaryTableBody"></tbody>
            <tfoot id="summaryTableFoot"></tfoot>
        </table>
    </div>

    <div id="detailedReport" class="hidden" style="overflow-x: auto;">
        <h3 style="color: #495057; margin-bottom: 10px;">पौधालयों में उपलब्ध पौध का वृतवार/प्रभागवार/प्रजातिवार विवरण</h3>
        <table id="detailedTable" class="report-table">
            <thead>
                <tr class="main-header">
                    <th>वृत का नाम</th>
                    <th>प्रभाग का नाम</th>
                    <th>रेंज का नाम</th>
                    <th>पौधालय का नाम</th>
                    <th>योजना का नाम</th>
                    <th>प्रजाति वर्ग</th>
                    <th>प्रजाति</th>
                    <th>SUM of माह अगस्त 2025 पौधालयो में उपलब्ध पौध संख्या</th>
                </tr>
            </thead>
            <tbody id="detailedTableBody"></tbody>
            <tfoot id="detailedTableFoot"></tfoot>
        </table>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script type="text/javascript">
        let currentReport = 'summary';

        // DUMMY DATA - Your original JavaScript objects
        const nurserySummaryData = [
            { zone: "गढ़वाल", circle: "", division: "अलकनन्दा", range: "", cat1: 98552, cat2: 64701, cat3: 154520, cat4: 276996, cat5: 560, cat6: 47530, cat7: 18897, grandTotal: 661756 },
            { zone: "गढ़वाल", circle: "", division: "मंदाकिनी", range: "", cat1: 125022, cat2: 17450, cat3: 5651, cat4: 89922, cat5: 42, cat6: 6188, cat7: 6243, grandTotal: 250518 },
            { zone: "गढ़वाल", circle: "", division: "चमोली", range: "", cat1: 186960, cat2: 36903, cat3: 92195, cat4: 304756, cat5: 4400, cat6: 10547, cat7: 4739, grandTotal: 640500 },
            { zone: "गढ़वाल", circle: "", division: "रुद्रप्रयाग", range: "", cat1: 8877, cat2: 24385, cat3: 7724, cat4: 67640, cat5: 0, cat6: 2393, cat7: 4153, grandTotal: 115172 },
            { zone: "गढ़वाल", circle: "", division: "किन्नौर, फोडी", range: "", cat1: 250, cat2: 3090, cat3: 7500, cat4: 14925, cat5: 50, cat6: 0, cat7: 0, grandTotal: 25815 },
            { zone: "गढ़वाल", circle: "पश्चिम", division: "देहरादून", range: "चकराता", cat1: 145000, cat2: 52000, cat3: 98000, cat4: 185000, cat5: 3200, cat6: 35000, cat7: 12000, grandTotal: 530200 },
            { zone: "कुमाऊँ", circle: "पूर्व", division: "नैनीताल", range: "रामगढ़", cat1: 156000, cat2: 62000, cat3: 105000, cat4: 198000, cat5: 4200, cat6: 42000, cat7: 15500, grandTotal: 582700 }
        ];

        const nurseryDetailedData = [
            { zone: "गढ़वाल", division: "अलकनन्दा", range: "", nursery: "खाती", scheme: "केम्पा", speciesCategory: "3 औषधीय प्रजातियाँ", species: "तिमुर", plantCount: 0 },
            { zone: "गढ़वाल", division: "अलकनन्दा", range: "", nursery: "खाती", scheme: "केम्पा", speciesCategory: "4 चारा प्रजातियाँ", species: "भीमल", plantCount: 1000 },
            { zone: "गढ़वाल", division: "अलकनन्दा", range: "", nursery: "गैर", scheme: "विधायीय", speciesCategory: "3 औषधीय प्रजातियाँ", species: "बनतुलसी", plantCount: 200 },
            { zone: "गढ़वाल", division: "अलकनन्दा", range: "अरेड़ू सिमली", nursery: "डामाटोली", scheme: "केम्पा", speciesCategory: "1 प्रकाष्ठ/औद्योगिक प्रजातियाँ", species: "देवदार", plantCount: 0 },
            { zone: "गढ़वाल", division: "मंदाकिनी", range: "सोनप्रयाग", nursery: "सोनप्रयाग नर्सरी", scheme: "केम्पा", speciesCategory: "1 प्रकाष्ठ/औद्योगिक प्रजातियाँ", species: "चीड़", plantCount: 3500 },
            { zone: "कुमाऊँ", division: "नैनीताल", range: "रामगढ़", nursery: "रामगढ़ नर्सरी", scheme: "केम्पा", speciesCategory: "1 प्रकाष्ठ/औद्योगिक प्रजातियाँ", species: "देवदार", plantCount: 5000 }
        ];

        let filteredSummaryData = [...nurserySummaryData];
        let filteredDetailedData = [...nurseryDetailedData];

        document.addEventListener('DOMContentLoaded', function () {
            renderCurrentReport();
        });

        function switchReport(type) {
            currentReport = type;
            document.getElementById('btnSummary').classList.toggle('active', type === 'summary');
            document.getElementById('btnDetailed').classList.toggle('active', type === 'detailed');
            document.getElementById('summaryReport').classList.toggle('hidden', type !== 'summary');
            document.getElementById('detailedReport').classList.toggle('hidden', type !== 'detailed');
            renderCurrentReport();
            return false;
        }

        function resetFilters() {
            document.getElementById('<%=ddlZone.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlCircle.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlDivision.ClientID%>').selectedIndex = 0;
    document.getElementById('<%=ddlRange.ClientID%>').selectedIndex = 0;
            document.getElementById('<%=ddlYear.ClientID%>').selectedIndex = 0;

            filteredSummaryData = [...nurserySummaryData];
            filteredDetailedData = [...nurseryDetailedData];
            renderCurrentReport();

            return false;
        }

        function renderCurrentReport() {
            if (currentReport === 'summary') {
                populateSummaryTable(filteredSummaryData);
                calculateSummaryTotals(filteredSummaryData);
            } else {
                populateDetailedTable(filteredDetailedData);
                calculateDetailedTotals(filteredDetailedData);
            }
        }

        function populateSummaryTable(data) {
            const tbody = document.getElementById('summaryTableBody');
            tbody.innerHTML = '';
            if (!data.length) {
                tbody.innerHTML = '<tr><td colspan="10" style="text-align: center; padding: 20px;">कोई डेटा उपलब्ध नहीं है</td></tr>';
                return;
            }
            const grouped = {};
            data.forEach(item => {
                if (!grouped[item.zone]) grouped[item.zone] = [];
                grouped[item.zone].push(item);
            });
            Object.keys(grouped).forEach(zone => {
                grouped[zone].forEach(item => {
                    const row = tbody.insertRow();
                    row.innerHTML = `<td style="text-align: left;">${item.zone}</td><td style="text-align: left;">${item.division}</td>
                        <td style="text-align: right;">${item.cat1.toLocaleString()}</td><td style="text-align: right;">${item.cat2.toLocaleString()}</td>
                        <td style="text-align: right;">${item.cat3.toLocaleString()}</td><td style="text-align: right;">${item.cat4.toLocaleString()}</td>
                        <td style="text-align: right;">${item.cat5.toLocaleString()}</td><td style="text-align: right;">${item.cat6.toLocaleString()}</td>
                        <td style="text-align: right;">${item.cat7.toLocaleString()}</td><td style="text-align: right; font-weight: bold;">${item.grandTotal.toLocaleString()}</td>`;
                });
                const tot = grouped[zone].reduce((a, i) => ({
                    cat1: a.cat1 + i.cat1, cat2: a.cat2 + i.cat2, cat3: a.cat3 + i.cat3,
                    cat4: a.cat4 + i.cat4, cat5: a.cat5 + i.cat5, cat6: a.cat6 + i.cat6, cat7: a.cat7 + i.cat7, grandTotal: a.grandTotal + i.grandTotal
                }),
                    { cat1: 0, cat2: 0, cat3: 0, cat4: 0, cat5: 0, cat6: 0, cat7: 0, grandTotal: 0 });
                const row = tbody.insertRow();
                row.className = 'group-row';
                row.innerHTML = `<td colspan="2" style="text-align: left;">${zone} Total</td>
                    <td style="text-align: right;">${tot.cat1.toLocaleString()}</td><td style="text-align: right;">${tot.cat2.toLocaleString()}</td>
                    <td style="text-align: right;">${tot.cat3.toLocaleString()}</td><td style="text-align: right;">${tot.cat4.toLocaleString()}</td>
                    <td style="text-align: right;">${tot.cat5.toLocaleString()}</td><td style="text-align: right;">${tot.cat6.toLocaleString()}</td>
                    <td style="text-align: right;">${tot.cat7.toLocaleString()}</td><td style="text-align: right; font-weight: bold;">${tot.grandTotal.toLocaleString()}</td>`;
            });
        }

        function calculateSummaryTotals(data) {
            const tfoot = document.getElementById('summaryTableFoot');
            if (!data.length) { tfoot.innerHTML = ''; return; }
            const tot = data.reduce((a, i) => ({
                cat1: a.cat1 + i.cat1, cat2: a.cat2 + i.cat2, cat3: a.cat3 + i.cat3, cat4: a.cat4 + i.cat4,
                cat5: a.cat5 + i.cat5, cat6: a.cat6 + i.cat6,

                cat7: a.cat7 + i.cat7, grandTotal: a.grandTotal + i.grandTotal
            }),
                { cat1: 0, cat2: 0, cat3: 0, cat4: 0, cat5: 0, cat6: 0, cat7: 0, grandTotal: 0 });
            tfoot.innerHTML = `<tr class="total-row"><td colspan="2"><strong>Grand Total</strong></td>
                <td style="text-align: right;"><strong>${tot.cat1.toLocaleString()}</strong></td>
                <td style="text-align: right;"><strong>${tot.cat2.toLocaleString()}</strong></td>
                <td style="text-align: right;"><strong>${tot.cat3.toLocaleString()}</strong></td>
                <td style="text-align: right;"><strong>${tot.cat4.toLocaleString()}</strong></td>
                <td style="text-align: right;"><strong>${tot.cat5.toLocaleString()}</strong></td>
                <td style="text-align: right;"><strong>${tot.cat6.toLocaleString()}</strong></td>
                <td style="text-align: right;"><strong>${tot.cat7.toLocaleString()}</strong></td>
                <td style="text-align: right;"><strong>${tot.grandTotal.toLocaleString()}</strong></td></tr>`;
        }

        function populateDetailedTable(data) {
            const tbody = document.getElementById('detailedTableBody');
            tbody.innerHTML = '';
            if (!data.length) {
                tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; padding: 20px;">कोई डेटा उपलब्ध नहीं है</td></tr>';
                return;
            }
            data.forEach(item => {
                const row = tbody.insertRow();
                row.innerHTML = `<td style="text-align: left;">${item.zone || ''}</td><td style="text-align: left;">${item.division || ''}</td>
                    <td style="text-align: left;">${item.range || ''}</td><td style="text-align: left;">${item.nursery || ''}</td>
                    <td style="text-align: left;">${item.scheme || ''}</td><td style="text-align: left;">${item.speciesCategory || ''}</td>
                    <td style="text-align: left;">${item.species || ''}</td><td style="text-align: right;"><strong>${item.plantCount.toLocaleString()}</strong></td>`;
            });
        }

        function calculateDetailedTotals(data) {
            const tfoot = document.getElementById('detailedTableFoot');
            if (!data.length) { tfoot.innerHTML = ''; return; }
            const tot = data.reduce((a, i) => a + i.plantCount, 0);
            tfoot.innerHTML = `<tr class="total-row"><td colspan="7" style="text-align: center;"><strong>Grand Total / कुल योग</strong></td>
                <td style="text-align: right;"><strong>${tot.toLocaleString()}</strong></td></tr>`;
        }

        function filterData() {
            const z = document.getElementById('<%=ddlZone.ClientID%>').value;
            const c = document.getElementById('<%=ddlCircle.ClientID%>').value;
            const d = document.getElementById('<%=ddlDivision.ClientID%>').value;
            const r = document.getElementById('<%=ddlRange.ClientID%>').value;

            filteredSummaryData = nurserySummaryData.filter(i =>
                (!z || i.zone === z) &&
                (!c || i.circle === c) &&
                (!d || i.division === d) &&
                (!r || i.range === r)
            );

            filteredDetailedData = nurseryDetailedData.filter(i =>
                (!z || i.zone === z) &&
                (!c || i.circle === c) &&
                (!d || i.division === d) &&
                (!r || i.range === r)
            );

            renderCurrentReport();
            return false;
        }

        function exportToExcel() {
            const tbl = document.getElementById(currentReport === 'summary' ? 'summaryTable' : 'detailedTable');
            const wb = XLSX.utils.table_to_book(tbl);
            XLSX.writeFile(wb, `Nursery_${currentReport === 'summary' ? 'Summary' : 'Detailed'}_Report_${new Date().toISOString().split('T')[0]}.xlsx`);
            return false;
        }

        // This function will be called automatically when dropdowns change via AutoPostBack
        function updateCircles() {
            // Server-side AutoPostBack handles this
        }

        function updateDivisions() {
            // Server-side AutoPostBack handles this
        }

        function updateRanges() {
            // Server-side AutoPostBack handles this
        }
    </script>
</asp:Content>