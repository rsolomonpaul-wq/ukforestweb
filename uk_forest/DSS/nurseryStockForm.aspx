<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="nurseryStockForm.aspx.cs" Inherits="uk_forest.DSS.nurseryStockForm" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style>
    body {
      background: #fff;
      font-family: 'Inter', Arial, sans-serif;
      margin: 0;
      padding: 0;
    }
    .main-container {
       
      padding: 0 10px;
       
    }
    .header {
      display: flex;
      align-items: center;
      margin-bottom: 34px;
    }
    .logo-icon {
      font-size: 28px;
      color: #6aa84f;
      margin-right: 12px;
      margin-top: 2px;
    }
    .title {
      font-size: 2rem;
      font-weight: 600;
      color: #232323;
      margin-bottom: 0;
    }
    .form-card {
      background: #fafafa;
      border-radius: 24px;
      padding: 40px;
      box-shadow: 0 2px 16px rgba(150,150,150,0.4);
      max-width: 100%;
      margin-bottom: 24px;
    }
    .form-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 0 52px;
      justify-content: space-between;
      row-gap: 28px;
    }
    .form-group {
      flex: 1 1 270px;
      display: flex;
      flex-direction: column;
    }
    label {
      font-size: 1rem;
      color: #222;
      font-weight: 500;
      margin-bottom: 7px;
    }
    select, input[type="text"], input[type="number"] {
      background: #f8f7f7;
      border: none;
      height: 44px;
      border-radius: 7px;
      font-size: 1rem;
      padding: 0 12px;
      margin-bottom: 0;
      transition: box-shadow 0.1s;
      box-shadow: 0 2px 8px rgba(160,160,160,0.3);
    }
    select:focus, input:focus {
      outline: none;
      box-shadow: 0 0 0 2px #8bc34a34;
    }
    .form-actions {
      display: flex;
      justify-content: flex-end;
      margin-top: 28px;
    }
    button {
      background: #65b32e;
      color: #fff;
      font-size: 1.15rem;
      font-weight: 500;
      border: none;
      padding: 0 38px;
      height: 44px;
      border-radius: 6px;
      cursor: pointer;
      transition: background 0.2s;
    }
    button:hover {
      background: #538820;
    }
    .nursery-table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      margin-bottom: 36px;
      box-shadow: 0 2px 8px rgba(160,160,160,0.07);
      border-radius: 14px;
      overflow: hidden;
    }
    .nursery-table th, .nursery-table td {
      border: 1px solid #e4e4e4;
      padding: 8px 10px;
      font-size: 1rem;
      text-align: center;
    }
    .nursery-table th {
      background: #f8f7f7;
      font-weight: 600;
      letter-spacing: 0.03em;
    }
    .nursery-table tbody tr:nth-child(even) {
      background: #fafafa;
    }
    @media (max-width: 1024px) {
      .form-grid {
        flex-direction: column;
        gap: 18px 0;
      }
      .form-group {
        width: 100%;
      }
      .form-card {
        padding: 22px 12px;
      }
    }
    @media (max-width: 700px) {
      .main-container { padding: 0; }
      .form-card { border-radius: 10px; padding: 12px; }
      .header .title { font-size: 1.4rem; }
      .form-group { margin-bottom: 10px; }
      .form-actions { margin-top: 17px; }
      .nursery-table th, .nursery-table td { padding: 4px; font-size: 11px; }
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="main-container">
                <div style="box-shadow: 0 2px 8px rgba(160,160,160,0.8);padding: 30px;
  border-radius: 15px;height: 89vh;">
                     <div class="header">
                    <span class="logo-icon">🌱</span>
                    <h1 class="title">Nursery Stock Management</h1>
                </div>
                <form class="form-card" id="nurseryForm" autocomplete="off">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="month">Select Month</label>
                            <select id="month" ClientIDMode="Static" required>
                                <option value="">Select</option>
                                <option>January</option>
                                <option>February</option>
                                <option>March</option>
                                <option>April</option>
                                <option>May</option>
                                <option>June</option>
                                <option>July</option>
                                <option>August</option>
                                <option>September</option>
                                <option>October</option>
                                <option>November</option>
                                <option>December</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="division">Division Name</label>
                            <select id="division" ClientIDMode="Static" required>
                                <option value="">Select</option>
                                <option>Dehradun</option>
                                <option>Nainital</option>
                                <option>Almora</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="range">Range Name</label>
                            <select id="range" ClientIDMode="Static" required>
                                <option value="">Select</option>
                                <option>Kalsi</option>
                                <option>Chilla</option>
                                <option>Rajaji</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="nursery">Nursery Name</label>
                            <select id="nursery" ClientIDMode="Static" required>
                                <option value="">Select</option>
                                <option>Central Nursery</option>
                                <option>East Nursery</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="project">Project Name</label>
                            <select id="project" ClientIDMode="Static" required>
                                <option value="">Select</option>
                                <option>Reforestation</option>
                                <option>Biodiversity</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="speciesGroup">Species Group</label>
                            <select id="speciesGroup" ClientIDMode="Static" required>
                                <option value="">Select</option>
                                <option>Deciduous</option>
                                <option>Evergreen</option>
                                <option>Conifer</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="speciesName">Species Name</label>
                            <select id="speciesName" ClientIDMode="Static" required>
                                <option value="">Select</option>
                                <option>Teak</option>
                                <option>Oak</option>
                                <option>Pine</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="available">Available Saplings</label>
                            <input type="number" min="0" id="available" ClientIDMode="Static" required />
                        </div>
                        <div class="form-group">
                            <label for="stockIssue">Stock Issue</label>
                            <input type="number" min="0" id="stockIssue" ClientIDMode="Static" required />
                        </div>
                        <div class="form-group">
                            <label for="balanceStock">Balance Stock</label>
                            <input type="number" min="0" id="balanceStock" ClientIDMode="Static" required />
                        </div>
                        <div class="form-group">
                            <label for="capacity">Nursery Capacity (ha)</label>
                            <input type="number" min="0" step="0.01" id="capacity" ClientIDMode="Static" required />
                        </div>
                        <div class="form-group">
                            <label for="utilization">Capacity Utilization (%)</label>
                            <input type="number" min="0" max="100" id="utilization" ClientIDMode="Static" required />
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="button" id="submitBtn">Submit</button>
                    </div>
                </form>

                    <div  style="box-shadow: 0 2px 8px rgba(160,160,160,0.3);padding: 30px;
  border-radius: 15px;margin-top:20px">
                        <table class="nursery-table" id="nurseryTable" ClientIDMode="Static">
                    <thead>
                        <tr>
                            <th>Month</th>
                            <th>Division Name</th>
                            <th>Range Name</th>
                            <th>Nursery Name</th>
                            <th>Project Name</th>
                            <th>Species Group</th>
                            <th>Species Name</th>
                            <th>Available Saplings</th>
                            <th>Stock Issue</th>
                            <th>Balance Stock</th>
                            <th>Nursery Capacity (ha)</th>
                            <th>Capacity Utilization (%)</th>
                        </tr>
                    </thead>
                    <tbody id="nurseryTableBody" ClientIDMode="Static">
                      <!-- Rows added dynamically -->
                    </tbody>
                </table>
                    </div>
                        
                </div>

            
            </div>
            <script type="text/javascript">
                (function () {
                    var form = document.getElementById('nurseryForm');
                    var tableBody = document.getElementById('nurseryTableBody');
                    var submitBtn = document.getElementById('submitBtn');

                    if (submitBtn && tableBody && !submitBtn.dataset.jsAttached) {
                        submitBtn.addEventListener('click', function () {
                            const getVal = id => document.getElementById(id).value;
                            const rowData = [
                                getVal('month'),
                                getVal('division'),
                                getVal('range'),
                                getVal('nursery'),
                                getVal('project'),
                                getVal('speciesGroup'),
                                getVal('speciesName'),
                                getVal('available'),
                                getVal('stockIssue'),
                                getVal('balanceStock'),
                                getVal('capacity'),
                                getVal('utilization')
                            ];

                            // Basic validation
                            if (rowData.some(val => val === '')) {
                                alert("Please fill in all fields.");
                                return;
                            }

                            var tr = document.createElement('tr');
                            rowData.forEach(function (val) {
                                var td = document.createElement('td');
                                td.textContent = val;
                                tr.appendChild(td);
                            });
                            tableBody.appendChild(tr);
                            form.reset();
                        });

                        submitBtn.dataset.jsAttached = "1";
                    }

                    if (typeof Sys !== "undefined" && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(arguments.callee);
                    }
                })();

            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
