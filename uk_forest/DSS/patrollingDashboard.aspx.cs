using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Npgsql;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
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
    public partial class patrollingDashboard : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        dbquery connectDB = new dbquery();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    if (Session["UserId"].ToString() != "")
                    {
                        string role = Session["RoleId"].ToString();
                        string userid = Session["UserId"].ToString();
                        string password = Session["Password"].ToString();
                        //bindddlzone();

                        getuser(role, userid, password);
                        //bindchartfiest();
                        bindddltypeofpatrolling();
                        BindYearsToDropdown();   // NEW: Year dropdown — current year down to 6 years back
                        // Month is now handled client-side via checkboxes (hdnSelectedMonths hidden field)
                        // BindShortMonthsToDropdown(); // No longer needed — replaced by checkbox multi-select

                    }

                }
            }
            catch (Exception ex)
            {

            }
        }

        // ============================================================
        // SEARCH BUTTON CLICK (NEW)
        // ============================================================
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            try
            {
                bindchartfiest();
                calljs();
            }
            catch (Exception ex)
            {

            }
        }

        // ============================================================
        // BIND YEAR DROPDOWN (NEW)
        // Populates: current year down to 6 years ago (e.g. 2026-2020)
        // ============================================================
        private void BindYearsToDropdown()
        {
            try
            {
                ddlyear.Items.Clear();
                ddlyear.Items.Add(new ListItem("All", "All"));

                int currentYear = DateTime.Now.Year;
                for (int y = currentYear; y >= currentYear - 6; y--)
                {
                    ddlyear.Items.Add(new ListItem(y.ToString(), y.ToString()));
                }
            }
            catch (Exception ex)
            {

            }
        }

        // ============================================================
        // HELPER: Build Year filter using tracking_date (NEW)
        // Returns e.g. "EXTRACT(YEAR FROM tracking_date) = 2025"
        // or null if "All" selected
        // ============================================================
        private string GetYearFilter()
        {
            string selectedYear = ddlyear.SelectedValue;
            if (string.IsNullOrEmpty(selectedYear) || selectedYear == "All")
                return null;

            return $"EXTRACT(YEAR FROM tracking_date) = {selectedYear}";
        }

        // ============================================================
        // HELPER: Build Month filter using tracking_date (NEW)
        // hdnSelectedMonths.Value = "All"  OR  "3,4,5"  (comma-separated)
        // Returns e.g. "EXTRACT(MONTH FROM tracking_date) IN (3,4,5)"
        // or null if "All" selected
        // ============================================================
        private string GetMonthFilter()
        {
            string selectedMonths = hdnSelectedMonths.Value;

            if (string.IsNullOrEmpty(selectedMonths) || selectedMonths.Trim() == "All")
                return null;

            // Keep only valid numeric values (safety check)
            var validMonths = selectedMonths
                .Split(',')
                .Where(m => int.TryParse(m.Trim(), out int n) && n >= 1 && n <= 12)
                .Select(m => m.Trim())
                .ToList();

            if (validMonths.Count == 0)
                return null;

            return $"EXTRACT(MONTH FROM tracking_date) IN ({string.Join(",", validMonths)})";
        }


        //protected void btnUpload_Click(object sender, EventArgs e)
        //{
        //    if (FileUpload1.HasFile)
        //    {
        //        try
        //        {
        //            // Read uploaded file content
        //            string kmlContent = null;
        //            using (StreamReader reader = new StreamReader(FileUpload1.PostedFile.InputStream))
        //            {
        //                kmlContent = reader.ReadToEnd();
        //            }

        //            // Extract the geometry portion from KML (simplified)
        //            string geometryKml = ExtractGeometryFromKml(kmlContent);

        //            if (string.IsNullOrEmpty(geometryKml))
        //            {
        //                //StatusLabel.Text = "Could not extract geometry from KML.";
        //                return;
        //            }

        //            // Insert into Postgres
        //            InsertKmlGeometry("Uploaded Shape", geometryKml);

        //            //StatusLabel.Text = "KML geometry uploaded and inserted successfully!";
        //        }
        //        catch (Exception ex)
        //        {
        //            //StatusLabel.Text = "Error: " + ex.Message;
        //        }
        //    }
        //    else
        //    {
        //        //StatusLabel.Text = "Please select a KML file.";
        //    }
        //}

        private string ExtractGeometryFromKml(string kml)
        {
            // This is a very simplified extraction of the first geometry element from the KML
            // In real usage, you should use a proper XML parser or KML library

            // Example: extract <Polygon> ... </Polygon> or <Point> ... </Point> etc.
            var match = Regex.Match(kml, @"<((Polygon)|(Point)|(LineString)).*?>.*?</\1>", RegexOptions.Singleline);
            if (match.Success)
            {
                return match.Value;
            }
            return null;
        }

        private void InsertKmlGeometry(string name, string geometryKml)
        {
            // Your connection string to PostgreSQL
            string connString = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;

            using (var conn = new NpgsqlConnection(connString))
            {
                conn.Open();

                string sql = @"
                INSERT INTO my_kml_shapes (name, geom)
                VALUES (@name, ST_SetSRID(ST_GeomFromKML(@kml), 4326))
            ";

                using (var cmd = new NpgsqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("name", name);
                    cmd.Parameters.AddWithValue("kml", geometryKml);
                    cmd.ExecuteNonQuery();
                }
            }
        }


        // BindShortMonthsToDropdown is no longer used — Month is now a client-side checkbox multi-select.
        // Original method kept below for reference.
        //private void BindShortMonthsToDropdown()
        //{
        //    ddlmonth.Items.Clear(); // Clear existing items

        //    ddlmonth.Items.Add(new ListItem("All", "All")); // Optional default

        //    for (int month = 1; month <= 12; month++)
        //    {
        //        // Get abbreviated month name
        //        string shortMonthName = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(month);

        //        // Add to dropdown: Text = "Jan", Value = "1"
        //        ddlmonth.Items.Add(new ListItem(shortMonthName, month.ToString()));
        //    }
        //}

        public static string ConvertSnakeCaseToTitleCase(string snakeCase)
        {
            if (string.IsNullOrWhiteSpace(snakeCase))
                return string.Empty;

            // Split the string by underscores
            string[] words = snakeCase.Split('_');

            // Capitalize the first letter of each word
            for (int i = 0; i < words.Length; i++)
            {
                if (words[i].Length > 0)
                {
                    words[i] = char.ToUpper(words[i][0]) + words[i].Substring(1);
                }
            }

            // Join with space and return
            return string.Join(" ", words);
        }

        public string LabelText
        {
            get { return LabelInContent.Text; }
        }
        protected void bindchartfiest()
        {
            try
            {
                string zone = ddlzone.SelectedValue;
                string circle = ddlcircle.SelectedValue;
                string divisions = division.SelectedValue;
                string ranges = range.SelectedValue;

                string fire_status = "";
                string land_cover = "";
                string protected_area = "";
                //string startdate = startDate.Text;
                //string enddate = endDate.Text;
                List<string> selectedDates = new List<string>();

                //foreach (ListItem item in chkdatelist.Items)
                //{
                //    if (item.Selected)
                //    {
                //        selectedDates.Add(item.Value);  // or item.Text if you want the display text
                //    }
                //}

                // Example: Join into a string to display or use
                // string dates = string.Join(", ", selectedDates);
                List<string> filters = new List<string>();

                //if (zone != "All")
                //{
                //    filters.Add($"zone = '{zone}'");
                //}

                //if (circle != "All")
                //{
                //    filters.Add($"circle = '{circle}'");
                //}

                if (divisions != "All")
                {
                    filters.Add($"division = '{divisions}'");
                }

                if (ranges != "All")
                {
                    filters.Add($"range_name = '{ranges}'");
                }
                if (fire_status != "")
                {
                    filters.Add($"fire_status = '{fire_status}'");
                }
                if (land_cover != "")
                {
                    filters.Add($"land_cover = '{land_cover}'");
                }
                if (protected_area != "")
                {
                    filters.Add($"protected_area = '{protected_area}'");
                }

                // ---- Animal Sighting filter (animal_sighting_type column) ----
                // "None" = no filter (show all), only filter when Active or Passive selected
                string animalSighting = rdofirestatus.SelectedValue;
                if (!string.IsNullOrEmpty(animalSighting) && animalSighting != "None" && animalSighting != "none")
                {
                    filters.Add($"animal_sighting_type = '{animalSighting}'");
                }

                //if (fire_status != "")
                //{
                //    filters.Add($"fire_status <= '{enddate}'");
                //}

                // ---- Year filter (NEW) — uses tracking_date column ----
                string yearFilter = GetYearFilter();
                if (yearFilter != null)
                    filters.Add(yearFilter);

                // ---- Month filter (NEW) — uses tracking_date column ----
                string monthFilter = GetMonthFilter();
                if (monthFilter != null)
                    filters.Add(monthFilter);

                string lbls = "";
                string vals = "";
                string lbls2 = "";
                string vals2 = "";
                string sums2 = "";

                string strplantationyear = "";
                string strplantationcount = "";
                string strplantationsitearea = "";
                string strplantationcovered = "";

                //double nur_approx = Convert.ToDouble(areaapproximately.SelectedValue);

                //nur_approx = nur_approx * 1000;
                string query1 = "";
                string whereClause = filters.Count > 0
                    ? "WHERE " + string.Join(" AND ", filters)
                    : string.Empty;

                // string query2 = "SELECT ROUND(SUM(affected_area)::numeric, 2) AS affected_area FROM tbl_fire_data ";
                // string query3 = "SELECT gid,  zone, circle, division, range, incident_id, fire_status, land_cover,  protected_area, affected_area, plant_loss,  human_death, human_injured, animal_death, animal_injured, block_name, fire_time, extinguish_time from tbl_fire_data ";
                string query4 = "";
                string query6 = "select count(*),patrolling_type from tbl_patrolling_input p ";
                //string query5 = "SELECT SUM(human_death::integer) AS total_human_deaths,SUM(human_injured::integer) AS total_human_injured,SUM(animal_death::integer) AS total_animal_deaths,SUM(animal_injured::integer) AS total_animal_injured,SUM(plant_loss::integer) AS plant_loss FROM tbl_fire_data ";
                string userType = "";
                if (Session["userid"].ToString() != "")
                {
                    string userid = Session["userid"].ToString();
                    string[] parts = userid.Split('-');
                    userType = parts[0];
                    string userId = parts.Length > 1 ? parts[1] : "";


                    if (userType == "RO")
                    {
                        //query4 = "SELECT range, COUNT(*) AS fire_count,ROUND(SUM(affected_area::numeric), 2) AS total_affected_area FROM tbl_fire_data  ";
                        query1 = "select sum(total_distance_km), beat from tbl_patrolling_input ";
                    }
                    else if (userType == "DFO")
                    {
                        //query4 = "SELECT range, COUNT(*) AS fire_count,ROUND(SUM(affected_area::numeric), 2) AS total_affected_area FROM tbl_fire_data  ";
                        query1 = "select sum(total_distance_km), range_name from tbl_patrolling_input  ";
                    }
                    else if (userType == "CCF")
                    {
                        //query4 = "SELECT division, Sum(no_of_plantation) / 1000 as no_of_plantation,  SUM(plantation_site_area) AS total_plantation_area,  SUM(covered_area) AS total_covered_area FROM tbl_plant_species  ";
                        query1 = "select sum(total_distance_km), division from tbl_patrolling_input ";
                    }
                    else
                    {
                        // query4 = "SELECT range, COUNT(*) AS fire_count,ROUND(SUM(affected_area::numeric), 2) AS total_affected_area FROM tbl_fire_data  ";
                        query1 = "select sum(total_distance_km), zone from tbl_patrolling_input  ";
                    }
                }



                if (filters.Count > 0)
                {
                    query1 += whereClause;
                    //query2 += whereClause;
                    //query3 += whereClause;
                    //query5 += whereClause;
                    query4 += whereClause;
                    query6 += whereClause;
                }

                //query1 += " GROUP BY fire_status;";
                query6 += " group by patrolling_type;";
                //query2 += "";
                //query3 += " GROUP BY plantation_year order by plantation_year";

                if (userType == "RO")
                {
                    query4 += " group by range ";
                    query1 += " GROUP BY beat  ";
                }
                else if (userType == "DFO")
                {
                    query4 += " group by range ";
                    query1 += " GROUP BY range_name ";
                }
                else
                {
                    query4 += " GROUP BY range ";
                    query1 += " GROUP BY zone  ";
                }

                DataTable dt = connectDB.executeGetData(query1);
                //DataTable dt2 = connectDB.executeGetData(query2);
                //DataTable dt3 = connectDB.executeGetData(query3);
                //DataTable dt5 = connectDB.executeGetData(query5);
                //DataTable dt4 = connectDB.executeGetData(query4);
                DataTable dt6 = connectDB.executeGetData(query6);
                // Define variables
                string regionNames = "";
                string totalDistances = "";
                //string regionAreas = "";
                //string peValues = "";

                List<string> regionList = new List<string>();
                List<string> totalDistanceList = new List<string>();
                //List<string> regionAreaList = new List<string>();
                //List<string> peList = new List<string>();

                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        // Dynamically pick column values by index (0-3)
                        string region = row[0]?.ToString() ?? "";
                        string distance = row[1]?.ToString() ?? "";
                        //string area = row[2]?.ToString() ?? "";
                        //string pe = row[3]?.ToString() ?? "";

                        // Add to lists
                        regionList.Add(region);
                        totalDistanceList.Add(distance);
                        //regionAreaList.Add(area);
                        //peList.Add(pe);
                    }

                    // Join into comma-separated strings
                    regionNames = string.Join(",", regionList);
                    totalDistances = string.Join(",", totalDistanceList);
                    //regionAreas = string.Join(",", regionAreaList);
                    //peValues = string.Join(",", peList);
                }
                string patscript1 = $"callregionchart('{regionNames}', '{totalDistances}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), patscript1, true);

                //if (dt2 != null && dt2.Rows.Count > 0)
                //{
                //    foreach (DataRow row in dt2.Rows)
                //    {
                //        string status = row["affected_area"].ToString().Trim().ToLower();
                //        lblaffectedarea.Text = status;


                //    }
                //}
                //if (dt3 != null && dt3.Rows.Count > 0)
                //{
                //    grid_data.DataSource = dt3;
                //    grid_data.DataBind();

                //}
                List<string> lbls5 = new List<string>();
                List<string> vals5 = new List<string>();
                //if (dt5 != null && dt5.Rows.Count > 0)
                //{
                //    DataRow row = dt5.Rows[0]; // Only one row in aggregate result

                //    foreach (DataColumn col in dt5.Columns)
                //    {
                //        lbls5.Add(col.ColumnName);               // Add column name to labels
                //        vals5.Add(row[col].ToString());          // Add corresponding value
                //    }
                //}

                lbls = string.Join(",", lbls5);
                vals = string.Join(",", vals5);

                List<string> ranges1 = new List<string>();
                List<int> counts = new List<int>();
                List<double> areas = new List<double>();

                //if (dt4 != null && dt4.Rows.Count > 0)
                //{
                //    foreach (DataRow row in dt4.Rows)
                //    {
                //        string range = row[0].ToString(); // First column
                //        int count = row[1] != DBNull.Value ? Convert.ToInt32(row[1]) : 0; // Second column

                //        ranges1.Add(range);
                //        counts.Add(count);
                //    }
                //}
                //if (dt4 != null && dt4.Rows.Count > 0)
                //{
                //    foreach (DataRow row in dt4.Rows)
                //    {
                //        string range1 = row[0].ToString(); // First column: Range
                //        int count = row[1] != DBNull.Value ? Convert.ToInt32(row[1]) : 0; // Second column: Count
                //        double area = row[2] != DBNull.Value ? Convert.ToDouble(row[2]) : 0.0; // Third column: Area

                //        ranges1.Add(range1);
                //        counts.Add(count);
                //        areas.Add(area); // You need to declare 'areas' list beforehand
                //    }
                //}
                string partrollingtype = "";
                string partrollingtypecount = "";
                List<string> partrollingtypelist = new List<string>();
                List<string> partrollingtypecountlist = new List<string>();

                if (dt6 != null && dt6.Rows.Count > 0)
                {
                    foreach (DataRow row in dt6.Rows)
                    {
                        // Assuming the DataTable has columns "count" and "patrolling_type"
                        string type = row["patrolling_type"].ToString();
                        string count = row["count"].ToString();

                        partrollingtypelist.Add(type);
                        partrollingtypecountlist.Add(count);
                    }

                    // Join the list items into comma-separated strings
                    partrollingtype = string.Join(",", partrollingtypelist);
                    partrollingtypecount = string.Join(",", partrollingtypecountlist);
                }


                string patscript = $"callpattypechart('{partrollingtype}', '{partrollingtypecount}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), patscript, true);
                lbls2 = string.Join(",", ranges1);
                vals2 = string.Join(",", counts);
                sums2 = string.Join(",", areas);
                //    strplantationsitearea = string.Join(",", plantationsitearea);
                //    strplantationcovered = string.Join(",", plantationcovered);


                //string script3 = $"callpiechart('{lbls}', '{vals}');";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script3, true);

                //string script4 = $"callregionfunction('{lbls2}', '{vals2}','{sums2}');";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script4, true);
                //string scriptcrew = $"loadCrewStations();";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), scriptcrew, true);

                //string scriptWatchTowers = $"loadWatchTowers();";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), scriptWatchTowers, true);
                //    //grd_querythree.DataSource = dt3;
                //    //grd_querythree.DataBind();
                //}


                //string str_plantation_area = "";
                //string str_covered_area = "";
                //string str_accordingly = "";
                //string str_no_of_plantation = "";
                ////string str_nurserycapacity = "";
                ////string str_nurserystock = "";

                //List<string> plantation_area = new List<string>();
                //List<string> covered_area = new List<string>();
                //List<string> accordingly = new List<string>();
                //List<string> no_of_plantation = new List<string>();

                //if (dt4 != null && dt4.Rows.Count > 0)
                //{



                //    foreach (DataRow col in dt4.Rows)
                //    {

                //        accordingly.Add(col[0].ToString());
                //        no_of_plantation.Add(col[1].ToString());
                //        plantation_area.Add(col[2].ToString());
                //        covered_area.Add(col[3].ToString());
                //    }


                //    str_plantation_area = string.Join(",", plantation_area);
                //    str_covered_area = string.Join(",", covered_area);
                //    str_accordingly = string.Join(",", accordingly);
                //    str_no_of_plantation = string.Join(",", no_of_plantation);



                //    string script4 = $"bindchartsubbrust('{str_accordingly}', '{str_plantation_area}','{str_no_of_plantation}','{str_covered_area}');";
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script4, true);
                //    //grd_queryfour.DataSource = dt4;
                //    //grd_queryfour.DataBind();

                //}
            }
            catch (Exception ex)
            {

            }
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
                    query = "SELECT ur.*,zm.zone,cm.circle,dm.division,rm.range FROM tbl_user_registration ur LEFT JOIN tbl_zone_master zm ON ur.zone_id = zm.id LEFT JOIN tbl_circle_master cm ON ur.circle_id = cm.id LEFT JOIN tbl_division_master dm ON ur.division_id = dm.id LEFT JOIN tbl_range_master rm ON ur.range_id = rm.id WHERE  ur.role_id = '" + role + "' AND ur.user_id = '" + userid + "'  AND ur.password = '" + password + "';";
                    userlevel(query, userid);
                }
                bindchartfiest();
            }
            catch (Exception ex)
            {

            }
        }

        protected void adminlevel(string q, string userid)
        {
            try
            {

                // (Optional) use the provided query for further logic
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    bindddlzone();
                    bindchartfiest();
                    calljs();


                }
            }
            catch (Exception ex)
            {
                // Log exception (don't ignore it in production)
                Console.WriteLine("Error in userlevel: " + ex.Message);
            }
        }
        protected void userlevel(string q, string userid)
        {
            try
            {

                // (Optional) use the provided query for further logic
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    bindddlzone();
                    if (dt.Rows[0]["zone"].ToString() != "")
                    {

                        ddlzone.SelectedValue = dt.Rows[0]["zone"].ToString();
                    }
                    bindddlcircle();
                    if (dt.Rows[0]["circle"].ToString() != "")
                    {

                        ddlcircle.SelectedValue = dt.Rows[0]["circle"].ToString();
                    }
                    bindddldivision();
                    if (dt.Rows[0]["division"].ToString() != "")
                    {

                        division.SelectedValue = dt.Rows[0]["division"].ToString();
                    }
                    //if (dt.Rows[0]["range"].ToString() != "")
                    //{
                    //    bindddldivision();
                    //    division.SelectedValue = dt.Rows[0]["division"].ToString();
                    //}

                    bindddlrange();
                    if (dt.Rows[0]["range"].ToString() != "")
                    {

                        range.SelectedValue = dt.Rows[0]["range"].ToString();
                    }

                    //ddlzone.SelectedValue = dt.Rows[0]["zone"].ToString();
                    string[] parts = userid.Split('-');
                    string userType = parts[0];
                    string userId = parts.Length > 1 ? parts[1] : "";

                    if (userType == "RO")
                    {

                        range.Enabled = false;
                        division.Enabled = false;
                        ddlcircle.Enabled = false;
                        ddlzone.Enabled = false;

                    }
                    else if (userType == "DFO")
                    {
                        division.Enabled = false;
                        ddlcircle.Enabled = false;
                        ddlzone.Enabled = false;

                    }
                    else if (userType == "SDO")
                    {
                    }
                    else if (userType == "CCF")
                    {
                        ddlzone.Enabled = false;
                    }
                    else if (userType == "PCCF")
                    {
                    }
                    else if (userType == "CF")
                    {
                        ddlcircle.Enabled = false;
                        ddlzone.Enabled = false;
                    }
                    else
                    {
                        Console.WriteLine("Unknown user type: " + userType);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log exception (don't ignore it in production)
                Console.WriteLine("Error in userlevel: " + ex.Message);
            }
        }

        private void calljs()
        {
            try
            {
                string script1 = "applyfilter();";
                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script1, true);
                //ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), "applyFilter();", true);
            }
            catch (Exception ex)
            {

            }
        }
        protected void ddlcircle_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddldivision();
                bindchartfiest();
                calljs();


            }
            catch (Exception ex)
            {

            }
        }
        protected void ddlzone_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddlcircle();
                bindchartfiest();
                calljs();

            }
            catch (Exception ex)
            {

            }
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
                ddlcircle.Items.Clear();
                division.Items.Clear();
                range.Items.Clear();
                //ddlplantation.Items.Clear();
                ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                division.Items.Insert(0, new ListItem("All", "All"));
                range.Items.Insert(0, new ListItem("All", "All"));
                // ddlplantation.Items.Insert(0, new ListItem("All", "All"));


                //binddataaccrodingfilter();
            }
            catch (Exception ex)
            {

            }
        }

        protected void bindddltypeofpatrolling()
        {
            try
            {
                string q = "select distinct patrolling_type from tbl_patrolling_input order by patrolling_type asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddltypeofpatrolling.Items.Clear();
                    ddltypeofpatrolling.DataSource = dt;
                    ddltypeofpatrolling.DataValueField = "patrolling_type";
                    ddltypeofpatrolling.DataTextField = "patrolling_type";
                    ddltypeofpatrolling.DataBind();
                }
                ddltypeofpatrolling.Items.Insert(0, new ListItem("All", "All"));

            }
            catch (Exception ex)
            {

            }
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
                    ddlcircle.DataSource = dt;
                    ddlcircle.DataValueField = "circle";
                    ddlcircle.DataTextField = "circle";
                    ddlcircle.DataBind();
                    ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                    division.Items.Clear();
                    division.Items.Insert(0, new ListItem("All", "All"));
                    range.Items.Clear();
                    range.Items.Insert(0, new ListItem("All", "All"));
                    //ddlplantation.Items.Clear();
                    //ddlplantation.Items.Insert(0, new ListItem("All", "All"));

                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    ddlcircle.Items.Clear();
                    division.Items.Clear();
                    ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                    division.Items.Insert(0, new ListItem("All", "All"));
                    range.Items.Clear();
                    range.Items.Insert(0, new ListItem("All", "All"));
                    //ddlplantation.Items.Clear();
                    //ddlplantation.Items.Insert(0, new ListItem("All", "All"));


                }
                //binddataaccrodingfilter();
                // Optional: Add default item


            }
            catch (Exception ex)
            {

            }
        }

        protected void division_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindddlrange();
            bindchartfiest();
            calljs();

        }

        protected void range_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindchartfiest();
            calljs();
        }

        protected void bindddldivision()
        {
            try
            {
                string q = "select distinct division from tbl_division_master where circle='" + ddlcircle.SelectedValue + "'  order by division asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    division.Items.Clear();
                    division.DataSource = dt;
                    division.DataValueField = "division";
                    division.DataTextField = "division";
                    division.DataBind();
                    division.Items.Insert(0, new ListItem("All", "All"));
                    range.Items.Clear();
                    range.Items.Insert(0, new ListItem("All", "All"));

                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    //ddlcircle.Items.Insert(0, new ListItem("All", "All"));

                    division.Items.Clear();
                    division.Items.Insert(0, new ListItem("All", "All"));
                    range.Items.Clear();
                    range.Items.Insert(0, new ListItem("All", "All"));

                }
                // binddataaccrodingfilter();
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
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
                    range.DataSource = dt;
                    range.DataValueField = "range";
                    range.DataTextField = "range";
                    range.DataBind();
                    range.Items.Insert(0, new ListItem("All", "All"));


                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    //ddlcircle.Items.Insert(0, new ListItem("All", "All"));

                    range.Items.Clear();
                    range.Items.Insert(0, new ListItem("All", "All"));

                }
                //binddataaccrodingfilter();
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }

        protected void rdofirestatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindchartfiest();
                calljs();
            }
            catch (Exception ex)
            {

            }
        }

        protected void Unnamed_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindchartfiest();
            }
            catch (Exception ex)
            {

            }
        }

        protected void rdoforesttype_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindchartfiest();
            }
            catch (Exception ex)
            {

            }
        }

        protected void chkprotectedarea_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindchartfiest();
            }
            catch (Exception ex)
            {

            }
        }

        protected void btnnewform_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect("../DSS/patrollingInputForm.aspx");
            }
            catch (Exception ex)
            {

            }
        }
    }
}