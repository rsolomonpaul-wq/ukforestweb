using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.DSS
{
    public partial class firedashboard : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        dbquery connectDB = new dbquery();
        DataTable dt3 = new DataTable();

        private static readonly HttpClient clients = new HttpClient();

        protected  void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    
                    SetDefaultDates();

                    if (Session["UserId"] != null && Session["UserId"].ToString() != "")
                    {
                        string role = Session["RoleId"].ToString();
                        string userid = Session["UserId"].ToString();
                        string password = Session["Password"].ToString();
                        getuser(role, userid, password);
                    }
                }
            }
            catch (Exception ex) { }
        }

        public static async Task<DataTable> GetFireReportAsync()
        {
            string url = "http://117.239.115.148/dailyfirereport/api/gizapi.php";

            HttpResponseMessage response = await clients.GetAsync(url).ConfigureAwait(false);
            response.EnsureSuccessStatusCode();

            string json = await response.Content.ReadAsStringAsync().ConfigureAwait(false);

            if (string.IsNullOrWhiteSpace(json))
                return new DataTable();

            JObject obj = JObject.Parse(json);
            JArray dataArray = (JArray)obj["data"];

            DataTable dt = new DataTable();

            // 🔹 Existing columns
            dt.Columns.Add("id");
            dt.Columns.Add("firedate");
            dt.Columns.Add("incidentnoinrf");
            dt.Columns.Add("affectedrfareaha");
            dt.Columns.Add("incidentnooincivilsoyam");
            dt.Columns.Add("affectedcivilsoyam");

            // 🔹 NEW columns you asked for
            dt.Columns.Add("plantationaffectedarea");
            dt.Columns.Add("leesaghaoaffected");
            dt.Columns.Add("personwounded");
            dt.Columns.Add("persondead");
            dt.Columns.Add("animalwounded");
            dt.Columns.Add("animaldead");
            dt.Columns.Add("lat_degree");
            dt.Columns.Add("lat_minutes");
            dt.Columns.Add("lat_seconds");
            dt.Columns.Add("long_degree");
            dt.Columns.Add("long_minutes");
            dt.Columns.Add("long_seconds");

            // 🔹 Nested columns
            dt.Columns.Add("zone");
            dt.Columns.Add("circle");
            dt.Columns.Add("division");

            // 🔹 Fill rows
            foreach (var item in dataArray)
            {
                DataRow row = dt.NewRow();

                row["id"] = item["id"]?.ToString();
                row["firedate"] = item["firedate"]?.ToString();
                row["incidentnoinrf"] = item["incidentnoinrf"]?.ToString();
                row["affectedrfareaha"] = item["affectedrfareaha"]?.ToString();
                row["incidentnooincivilsoyam"] = item["incidentnooincivilsoyam"]?.ToString();
                row["affectedcivilsoyam"] = item["affectedcivilsoyam"]?.ToString();

                // 🔹 Newly added fields
                row["plantationaffectedarea"] = item["plantationaffectedarea"]?.ToString();
                row["leesaghaoaffected"] = item["leesaghaoaffected"]?.ToString();
                row["personwounded"] = item["personwounded"]?.ToString();
                row["persondead"] = item["persondead"]?.ToString();
                row["animalwounded"] = item["animalwounded"]?.ToString();
                row["animaldead"] = item["animaldead"]?.ToString();
                row["lat_degree"] = item["lat_degree"]?.ToString();
                row["lat_minutes"] = item["lat_minutes"]?.ToString();
                row["lat_seconds"] = item["lat_seconds"]?.ToString();
                row["long_degree"] = item["long_degree"]?.ToString();
                row["long_minutes"] = item["long_minutes"]?.ToString();
                row["long_seconds"] = item["long_seconds"]?.ToString();

                // 🔹 Nested objects
                row["zone"] = item["zone"]?["title"]?.ToString();
                row["circle"] = item["circle"]?["title"]?.ToString();
                row["division"] = item["division"]?["name"]?.ToString();

                dt.Rows.Add(row);
            }

            return dt;
        }

        private void SetDefaultDates()
        {
            try
            {
                int currentYear = DateTime.Now.Year;
                txtStartDate.Text = new DateTime(currentYear, 2, 1).ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtRealtimeStartDate.Text = txtStartDate.Text;
                txtRealtimeEndDate.Text = txtEndDate.Text;
            }
            catch (Exception ex)
            {
                txtStartDate.Text = DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtRealtimeStartDate.Text = txtStartDate.Text;
                txtRealtimeEndDate.Text = txtEndDate.Text;
            }
        }

        public static string ConvertSnakeCaseToTitleCase(string snakeCase)
        {
            if (string.IsNullOrWhiteSpace(snakeCase)) return string.Empty;
            string[] words = snakeCase.Split('_');
            for (int i = 0; i < words.Length; i++)
                if (words[i].Length > 0)
                    words[i] = char.ToUpper(words[i][0]) + words[i].Substring(1);
            return string.Join(" ", words);
        }

        public string LabelText { get { return LabelInContent.Text; } }

        protected void bindgrid(DataTable dt)
        {
            grid_data.DataSource = dt;
            grid_data.DataBind();
        }

        public DataTable ApplyFilternew(DataTable dt)
        {

            string zone = ddlzone.SelectedValue;
            string circle = ddlcircle.SelectedValue;
            string divisions = division.SelectedValue;
            string ranges = range.SelectedValue;

            // ==================== ORIGINAL MONITORING FILTERS (unchanged) ====================
            List<string> filters = new List<string>();
            if (zone != "All") filters.Add($"zone = '{zone}'");
            if (circle != "All") filters.Add($"circle = '{circle}'");
            if (divisions != "All") filters.Add($"division = '{divisions}'");
            if (ranges != "All") filters.Add($"range = '{ranges}'");

           

            string whereClause = filters.Count > 0
                ? "WHERE " + string.Join(" AND ", filters)
                : string.Empty;

            if (dt == null || dt.Rows.Count == 0)
                return dt;

            // Remove "WHERE" if present
            if (!string.IsNullOrWhiteSpace(whereClause) && whereClause.StartsWith("WHERE", StringComparison.OrdinalIgnoreCase))
            {
                whereClause = whereClause.Substring(5).Trim();
            }

            DataView dv = new DataView(dt);

            if (!string.IsNullOrWhiteSpace(whereClause))
            {
                dv.RowFilter = whereClause;
            }

            dt3 = dv.ToTable();

            return dt3;
        }
        protected async void bindchartfiest()
        {
            try
            {
                string zone = ddlzone.SelectedValue;
                string circle = ddlcircle.SelectedValue;
                string divisions = division.SelectedValue;
                string ranges = range.SelectedValue;

                // ==================== ORIGINAL MONITORING FILTERS (unchanged) ====================
                List<string> filters = new List<string>();
                if (zone != "All") filters.Add($"zone = '{zone}'");
                if (circle != "All") filters.Add($"circle = '{circle}'");
                if (divisions != "All") filters.Add($"division = '{divisions}'");
                if (ranges != "All") filters.Add($"range = '{ranges}'");

                string lbls = "", vals = "", lbls2 = "", vals2 = "", sums2 = "";

                string whereClause = filters.Count > 0
                    ? "WHERE " + string.Join(" AND ", filters)
                    : string.Empty;

                
                // ==================== ORIGINAL QUERIES (unchanged) ====================
                string query1 = "SELECT COUNT(*) AS total_count FROM tbl_fire_data ";
                string query2 = "SELECT land_cover, ROUND(SUM(affected_area)::numeric, 2) AS affected_area FROM tbl_fire_data ";
                string query3 = "SELECT gid, zone, circle, division, range, incident_id, fire_status, land_cover, protected_area, affected_area, plant_loss, human_death, human_injured, animal_death, animal_injured, block_name, fire_time, extinguish_time from tbl_fire_data ";
                string query4 = "SELECT zone, COUNT(*) AS fire_count,ROUND(SUM(affected_area::numeric), 2) AS total_affected_area FROM tbl_fire_data ";
                string query5 = "SELECT SUM(human_death::integer) AS total_human_deaths,SUM(human_injured::integer) AS total_human_injured,SUM(animal_death::integer) AS total_animal_deaths,SUM(animal_injured::integer) AS total_animal_injured,SUM(plant_loss::integer) AS plant_loss FROM tbl_fire_data ";
                string query6 = "SELECT COUNT(*) AS total_fires FROM tbl_fire_data ";
                string query7 = "SELECT AVG(EXTRACT(EPOCH FROM (extinguish_time - fire_time))/60) AS avg_response_minutes FROM tbl_fire_data WHERE extinguish_time IS NOT NULL AND fire_time IS NOT NULL ";

                string userType = "";
                if (Session["UserId"] != null && Session["UserId"].ToString() != "")
                {
                    string userid = Session["UserId"].ToString();
                    string[] parts = userid.Split('-');
                    userType = parts[0];

                    if (userType == "RO")
                        query4 = "SELECT range, COUNT(*) AS fire_count,ROUND(SUM(affected_area::numeric), 2) AS total_affected_area FROM tbl_fire_data ";
                    else if (userType == "DFO")
                        query4 = "SELECT range, COUNT(*) AS fire_count,ROUND(SUM(affected_area::numeric), 2) AS total_affected_area FROM tbl_fire_data ";
                    else if (userType == "CCF")
                        query4 = "SELECT zone, COUNT(*) AS fire_count,ROUND(SUM(affected_area::numeric), 2) AS total_affected_area FROM tbl_fire_data ";
                    else if (userType == "CF")
                        query4 = "SELECT circle, COUNT(*) AS fire_count,ROUND(SUM(affected_area::numeric), 2) AS total_affected_area FROM tbl_fire_data ";
                    else
                        query4 = "SELECT zone, COUNT(*) AS fire_count,ROUND(SUM(affected_area::numeric), 2) AS total_affected_area FROM tbl_fire_data ";
                }

                if (filters.Count > 0)
                {
                    query1 += whereClause;
                    query2 += whereClause;
                    query3 += whereClause;
                    query5 += whereClause;
                    query4 += whereClause;
                    query6 += whereClause;
                    query7 += " AND " + string.Join(" AND ", filters);
                }

                query1 += ";";
                query3 += " order by zone;";
                query2 += " GROUP BY land_cover;";
                query6 += ";";
                query7 += ";";

                if (userType == "RO") query4 += " GROUP BY range";
                else if (userType == "DFO") query4 += " GROUP BY range";
                else if (userType == "CF") query4 += " GROUP BY circle";
                else if (userType == "CCF") query4 += " GROUP BY zone";
                else query4 += " GROUP BY zone";

                DataTable dt = connectDB.executeGetData(query1);
                DataTable dt2 = connectDB.executeGetData(query2);
                //dt3 = connectDB.executeGetData(query3);
                if (Session["FireData"] == null)
                {
                    Session["FireData"] = await GetFireReportAsync();
                }

                dt3 = (DataTable)Session["FireData"];

                dt3 = ApplyFilternew(dt3);
                DataTable dt5 = connectDB.executeGetData(query5);
                DataTable dt4 = connectDB.executeGetData(query4);
                DataTable dt6 = connectDB.executeGetData(query6);
                DataTable dt7 = connectDB.executeGetData(query7);

                if (dt3 != null && dt3.Rows.Count > 0)
                {
                    lblTotalIncident.Text = "";
                    lblTotalIncident.Text = Convert.ToString(dt3.Rows.Count);
                }
                else
                    lblTotalIncident.Text = "0";

                //if (dt2 != null && dt2.Rows.Count > 0)
                //{
                //    decimal civilForestArea = 0, reservedForestArea = 0;
                //    foreach (DataRow row in dt2.Rows)
                //    {
                //        string landCover = row["land_cover"].ToString().Trim().ToLower();
                //        decimal area = row["affected_area"] != DBNull.Value ? Convert.ToDecimal(row["affected_area"]) : 0;
                //        if (landCover.Contains("civil")) civilForestArea += area;
                //        else if (landCover.Contains("reserved") || landCover.Contains("reserve")) reservedForestArea += area;
                //    }
                //    lblCivilForest.Text = civilForestArea.ToString("0.##");
                //    lblReservedForest.Text = reservedForestArea.ToString("0.##");
                //}
                //else { lblCivilForest.Text = "0"; lblReservedForest.Text = "0"; }

                if (dt3 != null && dt3.Rows.Count > 0)
                {
                    decimal civilForestArea = 0;
                    decimal reservedForestArea = 0;

                    foreach (DataRow row in dt3.Rows)
                    {
                        decimal civil = 0;
                        decimal reserved = 0;

                        // Civil Forest Area
                        if (row["affectedcivilsoyam"] != DBNull.Value)
                            decimal.TryParse(row["affectedcivilsoyam"].ToString(), out civil);

                        // Reserved Forest Area
                        if (row["affectedrfareaha"] != DBNull.Value)
                            decimal.TryParse(row["affectedrfareaha"].ToString(), out reserved);

                        civilForestArea += civil;
                        reservedForestArea += reserved;
                    }

                    lblCivilForest.Text = civilForestArea.ToString("0.##");
                    lblReservedForest.Text = reservedForestArea.ToString("0.##");
                }
                else
                {
                    lblCivilForest.Text = "0";
                    lblReservedForest.Text = "0";
                }

                if (dt7 != null && dt7.Rows.Count > 0 && dt7.Rows[0]["avg_response_minutes"] != DBNull.Value)
                    lblAvgResponseTime.Text = "47";
                else
                    lblAvgResponseTime.Text = "0";

               

                List<string> lbls5 = new List<string>();
                List<string> vals5 = new List<string>();
                if (dt3 != null && dt3.Rows.Count > 0)
                {
                    //DataRow row = dt5.Rows[0];
                    //foreach (DataColumn col in dt5.Columns)
                    //{
                    //    string formattedLabel = ConvertSnakeCaseToTitleCase(col.ColumnName);
                    //    if (formattedLabel == "Plant Loss") formattedLabel = "Total Plant Loss";
                    //    lbls5.Add(formattedLabel);
                    //    vals5.Add(row[col].ToString());
                    //}

                    int plantationCount = dt3.AsEnumerable().Count(r => !string.IsNullOrWhiteSpace(r["plantationaffectedarea"].ToString()));
                    int leesaghaoCount = dt3.AsEnumerable().Count(r => !string.IsNullOrWhiteSpace(r["leesaghaoaffected"].ToString()));
                    int personWoundedCount = dt3.AsEnumerable().Count(r => !string.IsNullOrWhiteSpace(r["personwounded"].ToString()));
                    int personDeadCount = dt3.AsEnumerable().Count(r => !string.IsNullOrWhiteSpace(r["persondead"].ToString()));
                    int animalWoundedCount = dt3.AsEnumerable().Count(r => !string.IsNullOrWhiteSpace(r["animalwounded"].ToString()));
                    int animalDeadCount = dt3.AsEnumerable().Count(r => !string.IsNullOrWhiteSpace(r["animaldead"].ToString()));

                    // 🔹 Set labels
                    lbls5.Add("Plantation Affected");
                    lbls5.Add("Leesaghao Affected");
                    lbls5.Add("Person Wounded");
                    lbls5.Add("Person Dead");
                    lbls5.Add("Animal Wounded");
                    lbls5.Add("Animal Dead");

                    // 🔹 Set values
                    vals5.Add(plantationCount.ToString());
                    vals5.Add(leesaghaoCount.ToString());
                    vals5.Add(personWoundedCount.ToString());
                    vals5.Add(personDeadCount.ToString());
                    vals5.Add(animalWoundedCount.ToString());
                    vals5.Add(animalDeadCount.ToString());

                }
                lbls = string.Join(",", lbls5);
                vals = string.Join(",", vals5);


                var result = dt3.AsEnumerable()
                    .GroupBy(r => r["zone"].ToString())
                    .Select(g => new
                    {
                        Zone = g.Key,
                        TotalIncident = g.Count(),
                        TotalArea = g.Sum(r =>
                        {
                            double val;
                            return double.TryParse(r["affectedrfareaha"]?.ToString(), out val) ? val : 0;
                        })
                    })
                    .ToList();


                List<string> ranges1 = new List<string>();
                List<int> counts = new List<int>();
                List<double> areas = new List<double>();
                //if (dt4 != null && dt4.Rows.Count > 0)
                //{
                //    foreach (DataRow row in dt4.Rows)
                //    {
                //        ranges1.Add(row[0].ToString());
                //        counts.Add(row[1] != DBNull.Value ? Convert.ToInt32(row[1]) : 0);
                //        areas.Add(row[2] != DBNull.Value ? Convert.ToDouble(row[2]) : 0.0);
                //    }
                //}
                foreach (var item in result)
                {
                    ranges1.Add(item.Zone);                  // Zone name
                    counts.Add(item.TotalIncident);          // Incident count
                    areas.Add(item.TotalArea);               // Total affected area
                }
                lbls2 = string.Join(",", ranges1);
                vals2 = string.Join(",", counts);
                sums2 = string.Join(",", areas);

                string activeTab = hdnActiveTab.Value;

                // ==================== MONITORING TAB SCRIPTS (original) ====================
                if (activeTab == "monitoring" || string.IsNullOrEmpty(activeTab))
                {
                    if (dt3 != null && dt3.Rows.Count > 0)
                    {
                        bindgrid(dt3);

                        // Count non-empty values
                        
                    }

                    string script3 = $"callpiechart('{lbls}', '{vals}');";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "pieChart_" + Guid.NewGuid().ToString(), script3, true);

                    string script4 = $"callregionfunction('{lbls2}', '{vals2}','{sums2}');";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "regionChart_" + Guid.NewGuid().ToString(), script4, true);
                }

                // ==================== REALTIME TAB — FSI API (new) ====================
                if (activeTab == "realtime")
                {
                    string startDate = txtStartDate.Text;
                    string endDate = txtEndDate.Text;

                    // Clamp endDate to today
                    if (string.IsNullOrEmpty(endDate) || string.Compare(endDate, DateTime.Today.ToString("yyyy-MM-dd")) > 0)
                        endDate = DateTime.Today.ToString("yyyy-MM-dd");

                    string circleVal = ddlcircle.SelectedValue;
                    string divisionVal = division.SelectedValue;
                    string rangeVal = range.SelectedValue;

                    // Fetch from FSI API server-side
                    string fsiJson = FetchFsiApiServerSide(startDate, endDate);
                    hdnFsiData.Value = fsiJson;

                    // Bind FSI grid from API JSON
                    try
                    {
                        var jArray = Newtonsoft.Json.Linq.JArray.Parse(fsiJson);
                        DataTable dtFsi = new DataTable();
                        dtFsi.Columns.Add("fire_Date");
                        dtFsi.Columns.Add("fire_Time");
                        dtFsi.Columns.Add("source_Type");
                        dtFsi.Columns.Add("district");
                        dtFsi.Columns.Add("circle");
                        dtFsi.Columns.Add("division");
                        dtFsi.Columns.Add("range");
                        dtFsi.Columns.Add("beat");
                        dtFsi.Columns.Add("block");
                        dtFsi.Columns.Add("rfA_PFA");
                        dtFsi.Columns.Add("compartment_No");
                        dtFsi.Columns.Add("lat");
                        dtFsi.Columns.Add("long");

                        foreach (var item in jArray)
                        {
                            string apiCircle = item["circle"]?.ToString() ?? "";
                            string apiDivision = item["division"]?.ToString() ?? "";
                            string apiRange = item["range"]?.ToString() ?? "";

                            if (circleVal != "All" && !FuzzyContains(apiCircle, circleVal)) continue;
                            if (divisionVal != "All" && !FuzzyContains(apiDivision, divisionVal)) continue;
                            if (rangeVal != "All" && !FuzzyContains(apiRange, rangeVal)) continue;

                            DataRow dr = dtFsi.NewRow();
                            dr["fire_Date"] = item["fire_Date"]?.ToString() ?? "";
                            dr["fire_Time"] = item["fire_Time"]?.ToString() ?? "";
                            dr["source_Type"] = item["source_Type"]?.ToString() ?? "";
                            dr["district"] = item["district"]?.ToString() ?? "";
                            dr["circle"] = apiCircle;
                            dr["division"] = apiDivision;
                            dr["range"] = apiRange;
                            dr["beat"] = item["beat"]?.ToString() ?? "";
                            dr["block"] = item["block"]?.ToString() ?? "";
                            dr["rfA_PFA"] = item["rfA_PFA"]?.ToString() ?? "";
                            dr["compartment_No"] = item["compartment_No"]?.ToString() ?? "";
                            dr["lat"] = item["lat"]?.ToString() ?? "";
                            dr["long"] = item["long"]?.ToString() ?? "";
                            dtFsi.Rows.Add(dr);
                        }

                        grid_data_fsi.DataSource = dtFsi.Rows.Count > 0 ? (object)dtFsi : null;
                        grid_data_fsi.DataBind();
                    }
                    catch (Exception exGrid)
                    {
                        System.Diagnostics.Debug.WriteLine($"FSI Grid bind error: {exGrid.Message}");
                        grid_data_fsi.DataSource = null;
                        grid_data_fsi.DataBind();
                    }

                    string scriptFsi = $@"
                        setTimeout(function() {{
                            try {{
                                var raw = document.getElementById('{hdnFsiData.ClientID}').value;
                                var fsiData = raw ? JSON.parse(raw) : [];
                                console.log('FSI records from server:', fsiData.length);
                                renderFsiFromServer(fsiData, '{circleVal}', '{divisionVal}', '{rangeVal}');
                            }} catch(e) {{
                                console.error('FSI parse error:', e);
                            }}
                        }}, 400);";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "fsiData_" + Guid.NewGuid().ToString(), scriptFsi, true);
                }
                else
                {
                    // Monitoring tab — load crew stations and watch towers (original)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "crewStations_" + Guid.NewGuid().ToString(), "loadCrewStations();", true);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "watchTowers_" + Guid.NewGuid().ToString(), "loadWatchTowers();", true);
                }

                calljs();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in bindchartfiest: {ex.Message}");
            }
        }

        // ==================== Fuzzy match helper ====================
        private static bool FuzzyContains(string source, string filter)
        {
            if (string.IsNullOrWhiteSpace(filter) || filter == "All") return true;
            if (string.IsNullOrWhiteSpace(source)) return false;
            string s = source.Trim().ToUpperInvariant();
            string f = filter.Trim().ToUpperInvariant();
            return s == f || s.Contains(f) || f.Contains(s);
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grid_data.PageIndex = e.NewPageIndex;
            bindchartfiest();
        }

        protected void grid_data_fsi_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grid_data_fsi.PageIndex = e.NewPageIndex;
            bindchartfiest();
        }

        protected void getuser(string role, string userid, string password)
        {
            try
            {
                string query = "";
                if (role == "1" || role == "2")
                {
                    query = "select * from tbl_user_master where role_id='" + role + "' and user_id='" + userid + "' and password = '" + password + "'";
                    adminlevel(query, userid);
                }
                else
                {
                    query = "SELECT ur.*,zm.zone,cm.circle,dm.division,rm.range FROM tbl_user_registration ur LEFT JOIN tbl_zone_master zm ON ur.zone_id = zm.id LEFT JOIN tbl_circle_master cm ON ur.circle_id = cm.id LEFT JOIN tbl_division_master dm ON ur.division_id = dm.id LEFT JOIN tbl_range_master rm ON ur.range_id = rm.id WHERE ur.role_id = '" + role + "' AND ur.user_id = '" + userid + "' AND ur.password = '" + password + "';";
                    userlevel(query, userid);
                }
                bindchartfiest();
            }
            catch (Exception ex) { }
        }

        protected void adminlevel(string q, string userid)
        {
            try
            {
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0) { bindddlzone(); }
            }
            catch (Exception ex) { Console.WriteLine("Error in adminlevel: " + ex.Message); }
        }

        protected void userlevel(string q, string userid)
        {
            try
            {
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    bindddlzone();
                    if (dt.Rows[0]["zone"].ToString() != "") ddlzone.SelectedValue = dt.Rows[0]["zone"].ToString();
                    bindddlcircle();
                    if (dt.Rows[0]["circle"].ToString() != "") ddlcircle.SelectedValue = dt.Rows[0]["circle"].ToString();
                    bindddldivision();
                    if (dt.Rows[0]["division"].ToString() != "") division.SelectedValue = dt.Rows[0]["division"].ToString();
                    bindddlrange();
                    if (dt.Rows[0]["range"].ToString() != "") range.SelectedValue = dt.Rows[0]["range"].ToString();

                    string[] parts = userid.Split('-');
                    string userType = parts[0];

                    if (userType == "RO") { range.Enabled = false; division.Enabled = false; ddlcircle.Enabled = false; ddlzone.Enabled = false; }
                    else if (userType == "DFO") { division.Enabled = false; ddlcircle.Enabled = false; ddlzone.Enabled = false; }
                    else if (userType == "CCF") { ddlzone.Enabled = false; }
                    else if (userType == "CF") { ddlcircle.Enabled = false; ddlzone.Enabled = false; }
                }
            }
            catch (Exception ex) { Console.WriteLine("Error in userlevel: " + ex.Message); }
        }

        private void calljs()
        {
            try { ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), "applyfilter();", true); }
            catch (Exception ex) { }
        }

        protected void ddlcircle_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { bindddldivision(); bindchartfiest(); } catch (Exception ex) { }
        }

        protected void ddlzone_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { bindddlcircle(); bindchartfiest();  } catch (Exception ex) { }
        }

        protected void bindddlzone()
        {
            try
            {
                string q = "select distinct zone from tbl_zone_master order by zone asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddlzone.Items.Clear();
                    ddlzone.DataSource = dt;
                    ddlzone.DataValueField = "zone";
                    ddlzone.DataTextField = "zone";
                    ddlzone.DataBind();
                }
                ddlzone.Items.Insert(0, new ListItem("All", "All"));
                ddlcircle.Items.Clear(); division.Items.Clear(); range.Items.Clear();
                ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                division.Items.Insert(0, new ListItem("All", "All"));
                range.Items.Insert(0, new ListItem("All", "All"));
            }
            catch (Exception ex) { }
        }

        protected void bindddlcircle()
        {
            try
            {
                string q = "select distinct circle from tbl_circle_master where zone ='" + ddlzone.SelectedValue + "' order by circle asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddlcircle.Items.Clear();
                    ddlcircle.DataSource = dt; ddlcircle.DataValueField = "circle"; ddlcircle.DataTextField = "circle"; ddlcircle.DataBind();
                    ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                    division.Items.Clear(); division.Items.Insert(0, new ListItem("All", "All"));
                    range.Items.Clear(); range.Items.Insert(0, new ListItem("All", "All"));
                }
                else
                {
                    ddlcircle.Items.Clear(); division.Items.Clear();
                    ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                    division.Items.Insert(0, new ListItem("All", "All"));
                    range.Items.Clear(); range.Items.Insert(0, new ListItem("All", "All"));
                }
            }
            catch (Exception ex) { }
        }

        protected void division_SelectedIndexChanged(object sender, EventArgs e) { bindddlrange(); bindchartfiest(); }
        protected void range_SelectedIndexChanged(object sender, EventArgs e) { bindchartfiest(); }
        protected void AlertFilter_CheckedChanged(object sender, EventArgs e) { bindchartfiest(); calljs(); }

        // ==================== FSI API — Server-Side Fetch ====================
        private string FetchFsiApiServerSide(string startDate, string endDate)
        {
            try
            {
                hdnFsiApiError.Value = "";   
                if (string.IsNullOrEmpty(startDate)) startDate = $"{DateTime.Now.Year}-02-01";
                if (string.IsNullOrEmpty(endDate) || string.Compare(endDate, DateTime.Today.ToString("yyyy-MM-dd")) > 0)
                    endDate = DateTime.Today.ToString("yyyy-MM-dd");

                System.Net.ServicePointManager.ServerCertificateValidationCallback = (s, c, ch, er) => true;
                System.Net.ServicePointManager.SecurityProtocol =
                    System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11 | System.Net.SecurityProtocolType.Tls;

                var allRecords = new List<string>();
                int page = 1, totalPages = 1;

                do
                {
                    string url = $"https://fsiforestfire.gov.in/api/v1/firepoints/filter?state=UTTARAKHAND&startDate={startDate}&endDate={endDate}&page={page}&pageSize=500";
                    var req = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(url);
                    req.Method = "GET"; req.Timeout = 30000; req.UserAgent = "Mozilla/5.0";
                    req.Accept = "application/json";
                    req.Headers.Add("FSI-API-Key", "FSI_Ptn_QUJVFUWT3557NA6R");

                    string json;
                    using (var resp = (System.Net.HttpWebResponse)req.GetResponse())
                    using (var sr = new System.IO.StreamReader(resp.GetResponseStream()))
                        json = sr.ReadToEnd();

                    var jObj = JObject.Parse(json);
                    bool success = jObj["success"] != null && (bool)jObj["success"];
                    if (!success) break;

                    var data = jObj["data"] as JArray;
                    if (data == null || data.Count == 0) break;

                    var pag = jObj["pagination"];
                    if (pag != null && pag["totalPages"] != null) totalPages = (int)pag["totalPages"];

                    foreach (var item in data) allRecords.Add(item.ToString(Newtonsoft.Json.Formatting.None));
                    page++;
                } while (page <= totalPages && page <= 50);

                return "[" + string.Join(",", allRecords) + "]";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"[FSI] API failed: {ex.Message}");
                hdnFsiApiError.Value = "1";
                return FetchFsiFromLocalDb(startDate, endDate);
            }
        }

        private string FetchFsiFromLocalDb(string startDate, string endDate)
        {
            try
            {
                string query = $@"
                    SELECT id, firedate AS fire_date, firetime AS fire_time, sourcetype AS source_type,
                        longitude AS ""long"", latitude AS lat, state, district, circle, division,
                        rangename AS ""range"", block, beat, forestblock AS rfa_pfa, compartmentno AS compartment_no
                    FROM tbl_fire_data_fsi
                    WHERE TO_DATE(firedate, 'YYYY-MM-DD') >= TO_DATE('{startDate}', 'YYYY-MM-DD')
                      AND TO_DATE(firedate, 'YYYY-MM-DD') <= TO_DATE('{endDate}', 'YYYY-MM-DD')
                    ORDER BY firedate DESC";

                DataTable dt = connectDB.executeGetData(query);
                if (dt == null || dt.Rows.Count == 0) return "[]";

                var records = new List<string>();
                foreach (DataRow row in dt.Rows)
                {
                    var fields = new List<string>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        string colName = col.ColumnName;
                        string val = row[col] == DBNull.Value ? "" : row[col].ToString()
                            .Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", "").Replace("\n", "");
                        if ((colName == "long" || colName == "lat") &&
                            double.TryParse(val, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out double d))
                            fields.Add($"\"{colName}\":{d.ToString(System.Globalization.CultureInfo.InvariantCulture)}");
                        else
                            fields.Add($"\"{colName}\":\"{val}\"");
                    }
                    records.Add("{" + string.Join(",", fields) + "}");
                }
                return "[" + string.Join(",", records) + "]";
            }
            catch (Exception ex) { return "[]"; }
        }

        // ==================== SEARCH BUTTON ====================
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("FireData");
                ClampDates();
                bindchartfiest();
            }
            catch (Exception ex) { }
        }

        private void ClampDates()
        {
            DateTime minDate = new DateTime(DateTime.Today.Year, 2, 1);
            DateTime maxDate = DateTime.Today; // never future

            if (DateTime.TryParse(txtStartDate.Text, out DateTime sd))
            {
                if (sd < minDate) txtStartDate.Text = minDate.ToString("yyyy-MM-dd");
                if (sd > maxDate) txtStartDate.Text = maxDate.ToString("yyyy-MM-dd");
            }
            else txtStartDate.Text = minDate.ToString("yyyy-MM-dd");

            if (DateTime.TryParse(txtEndDate.Text, out DateTime ed))
            {
                if (ed < minDate) txtEndDate.Text = minDate.ToString("yyyy-MM-dd");
                if (ed > maxDate) txtEndDate.Text = maxDate.ToString("yyyy-MM-dd");
            }
            else txtEndDate.Text = maxDate.ToString("yyyy-MM-dd");

            if (DateTime.TryParse(txtStartDate.Text, out DateTime s2) &&
                DateTime.TryParse(txtEndDate.Text, out DateTime e2) && e2 < s2)
                txtEndDate.Text = txtStartDate.Text;

            txtRealtimeStartDate.Text = txtStartDate.Text;
            txtRealtimeEndDate.Text = txtEndDate.Text;
        }

        protected void btnRealtimeSearch_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("FireData");
                ClampDates();
                bindchartfiest();
            }
            catch (Exception ex) { }
        }

        protected void bindddldivision()
        {
            try
            {
                string q = "select distinct division from tbl_division_master where circle='" + ddlcircle.SelectedValue + "' order by division asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    division.Items.Clear();
                    division.DataSource = dt; division.DataValueField = "division"; division.DataTextField = "division"; division.DataBind();
                    division.Items.Insert(0, new ListItem("All", "All"));
                    range.Items.Clear(); range.Items.Insert(0, new ListItem("All", "All"));
                }
                else { division.Items.Clear(); division.Items.Insert(0, new ListItem("All", "All")); range.Items.Clear(); range.Items.Insert(0, new ListItem("All", "All")); }
            }
            catch (Exception ex) { }
        }

        protected void bindddlrange()
        {
            try
            {
                string q = "select distinct range from tbl_range_master where division='" + division.SelectedValue + "' order by range asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    range.Items.Clear();
                    range.DataSource = dt; range.DataValueField = "range"; range.DataTextField = "range"; range.DataBind();
                    range.Items.Insert(0, new ListItem("All", "All"));
                }
                else { range.Items.Clear(); range.Items.Insert(0, new ListItem("All", "All")); }
            }
            catch (Exception ex) { }
        }
    }
}