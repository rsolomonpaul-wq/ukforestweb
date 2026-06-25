using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.DSS
{
    public partial class wlc : System.Web.UI.Page
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
                    //bind_role();

                    // bindforestareatable();
                    bindstatglance();
                    bindunittotal();

                    bindddlyear();
                    bindddlzone();
                    // binddataaccrodingfilter();
                    // bindddlcircle();
                    //bindddldivision();
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void bindddlyear()
        {
            try
            {
                string q = "select year , layername from tbl_fire_years where active = true order by year desc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddlyear.Items.Clear();
                    ddlyear.DataSource = dt;
                    ddlyear.DataValueField = "layername";
                    ddlyear.DataTextField = "year";
                    ddlyear.DataBind();
                }
                binddataaccrodingfilter();
                // Optional: Add default item

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
                ddldivision.Items.Clear();
                ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                ddldivision.Items.Insert(0, new ListItem("All", "All"));

                binddataaccrodingfilter();
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
                    ddldivision.Items.Clear();
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    ddlcircle.Items.Clear();
                    ddldivision.Items.Clear();
                    ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                }
                binddataaccrodingfilter();
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }
        protected void bindddldivision()
        {
            try
            {
                string q = "select distinct division from tbl_division_master where  zone='" + ddlzone.SelectedValue + "' and circle='" + ddlcircle.SelectedValue + "' order by division asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddldivision.Items.Clear();
                    ddldivision.DataSource = dt;
                    ddldivision.DataValueField = "division";
                    ddldivision.DataTextField = "division";
                    ddldivision.DataBind();
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    //ddlcircle.Items.Insert(0, new ListItem("All", "All"));

                    ddldivision.Items.Clear();
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                }
                binddataaccrodingfilter();
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }
        protected void bindforestareatable()
        {
            try
            {
                string q = "SELECT department, area_type, CONCAT(SUM(total_area)::text, ' SqKm') total_area FROM tbl_forest_area GROUP BY department, area_type order by department desc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    //grd_forest_area.DataSource = dt;

                    //grd_forest_area.DataBind();
                }
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }
        protected void bindstatglance()
        {
            try
            {
                string q = "select description,units, status FROM tbl_statistics_glance";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    //grd_glance.DataSource = dt;

                    //grd_glance.DataBind();
                }
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }
        protected void bindunittotal()
        {
            try
            {
                string q = "select unitname,territorial_wildlife,functional,total from tbl_unit_total";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    //grd_unit_total.DataSource = dt;

                    //grd_unit_total.DataBind();
                }
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }
        //void bind_role()
        //{
        //    HttpResponseMessage Res;
        //    DataTable dt;

        //    try
        //    {
        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/api"));
        //            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

        //            Res = client.GetAsync(apiUrl + string.Format("TblRolesMasters/GetTblRolesMasters")).Result;

        //            if (Res.IsSuccessStatusCode)
        //            {
        //                var EmpResponse = Res.Content.ReadAsStringAsync().Result;
        //                dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));
        //                ddlRole.Items.Clear();
        //                ddlRole.DataSource = dt;
        //                ddlRole.DataValueField = "RoleId";
        //                ddlRole.DataTextField = "RoleName";
        //                ddlRole.DataBind();
        //                ddlRole.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Role", "0"));
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}


        //protected void btnLogin_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        if (ddlRole.SelectedValue == "0")
        //        {
        //            string script = $"alert('Please Select Role');";
        //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
        //            return;
        //        }
        //        if (txtUsername.Text == "" && txtPassword.Text != "")
        //        {
        //            string script = $"alert('Please Provide username');";
        //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
        //            return;
        //        }
        //        else if (txtUsername.Text != "" && txtPassword.Text == "")
        //        {
        //            string script = $"alert('Please Provide password');";
        //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
        //            return;
        //        }
        //        else if (txtUsername.Text == "" && txtPassword.Text == "")
        //        {
        //            string script = $"alert('Please Provide Username and password');";
        //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
        //            return;
        //        }

        //        if (ddlRole.SelectedValue == "1" || ddlRole.SelectedValue == "2" || ddlRole.SelectedValue == "3" || ddlRole.SelectedValue == "4" || ddlRole.SelectedValue == "5" || ddlRole.SelectedValue == "6" || ddlRole.SelectedValue == "7" || ddlRole.SelectedValue == "8")
        //        {
        //            //var t = user_login(Convert.ToInt32(ddlRole.SelectedValue), txtUsername.Text, txtPassword.Text);
        //            var t = user_login_2(Convert.ToInt32(ddlRole.SelectedValue), txtUsername.Text, txtPassword.Text);
        //        }
        //        else
        //        {

        //        }


        //        if (Session["UserId"] != null)
        //        {
        //            if (Convert.ToInt32(Session["RoleId"].ToString()) == 1 || Convert.ToInt32(Session["RoleId"].ToString()) == 2)
        //            {
        //                Response.Redirect("../Forest/Dashboard.aspx", false);
        //            }
        //            else if (Convert.ToInt32(Session["RoleId"].ToString()) == 3)
        //            {
        //                Response.Redirect("../Forest/Dashboard.aspx", false);
        //            }
        //            else if (Convert.ToInt32(Session["RoleId"].ToString()) == 4)
        //            {
        //                Response.Redirect("../Forest/Dashboard.aspx", false);
        //            }
        //            else if (Convert.ToInt32(Session["RoleId"].ToString()) == 5)
        //            {
        //                Response.Redirect("../Forest/Dashboard.aspx", false);
        //            }
        //            else if (Convert.ToInt32(Session["RoleId"].ToString()) == 6)
        //            {
        //                Response.Redirect("../Forest/Dashboard.aspx", false);
        //            }
        //            else if (Convert.ToInt32(Session["RoleId"].ToString()) == 7)
        //            {
        //                Response.Redirect("../Forest/Dashboard.aspx", false);
        //            }
        //            else if (Convert.ToInt32(Session["RoleId"].ToString()) == 8)
        //            {
        //                Response.Redirect("../Forest/Dashboard.aspx", false);
        //            }
        //            else
        //            {
        //                string script = $"alert('UserId and password are incorrect');";
        //                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
        //                return;
        //            }
        //        }
        //        else
        //        {
        //            string script = $"alert('UserId and password are incorrect');";
        //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
        //            return;
        //        }



        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

        //public async Task<JObject> user_login(Int32 RoleId, string UserId, string Password)
        //{
        //    try
        //    {
        //        var data = new
        //        {
        //            RoleId = RoleId,
        //            UserId = UserId,
        //            Password = Password,

        //        };

        //        var json = JsonConvert.SerializeObject(data);
        //        var data1 = new StringContent(json, Encoding.UTF8, "application/json");
        //        //var url = apiUrl + "TblUserRegistrations/UserLogin";
        //        string url = (RoleId == 1 || RoleId == 2)
        //    ? apiUrl + "TblUserMasters/UserLogin"
        //    : apiUrl + "TblUserRegistrations/UserLogin";
        //        HttpClient client = new HttpClient();
        //        var response1 = client.PostAsync(url, data1);
        //        response1.Wait();
        //        HttpResponseMessage response = response1.Result;

        //        if (response.IsSuccessStatusCode)
        //        {
        //            var resultContent = await response.Content.ReadAsStringAsync();
        //            var userData = JsonConvert.DeserializeObject<JObject>(resultContent);

        //            if (userData != null && userData["isActive"] != null && Convert.ToBoolean(userData["isActive"].ToString()))
        //            {
        //                Session["UserId"] = userData["userId"]?.ToString();
        //                Session["Password"] = userData["password"]?.ToString();
        //                Session["RoleId"] = userData["roleId"];
        //                Session["token"] = userData["token"]?.ToString();
        //            }
        //            else
        //            {
        //                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "btn", "<script type = 'text/javascript'>alert('This User is not Active');</script>");
        //            }
        //        }
        //        else
        //        {
        //            Session["token"] = null;
        //            Session["UserId"] = null;
        //        }
        //        return new JObject { { "StatusCode", (int)response.StatusCode } };
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

        protected void ddlzone_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddlcircle();
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
            }
            catch (Exception ex)
            {

            }
        }


        protected void ddlaction_CallingDataMethods(object sender, EventArgs e)
        {
            try
            {
                binddataaccrodingfilter();
            }
            catch (Exception ex)
            {

            }
        }

        protected void binddataaccrodingfilter()
        {
            string lbls = "";
            string valus = ""; string q2 = ""; string areaboundary = "";
            string[] findboundarylayerfilter = null;
            string lastFilter = "";
            string q1 = "";
            //grd_forest_area.DataSource = null;
            //grd_forest_area.DataBind();
            string zone = ddlzone.SelectedValue;
            string circle = ddlcircle.SelectedValue;
            string division = ddldivision.SelectedValue;
            string filterstrwithclose = "";
            string filterstrwithoutclose = "";
            grd_area.DataSource = null;
            grd_area.DataBind();
            try
            {
                // Initialize filter strings
                // Initialize filter strings
                filterstrwithclose = "";
                filterstrwithoutclose = "";
                string animalColumns = "";
                string animalFilter = "";
                string action = ddl_action.SelectedItem.Text.Trim().ToLower();
                bool isFirstCondition = true;

                // Zone filter
                if (!string.IsNullOrEmpty(zone) && zone != "All")
                {
                    filterstrwithclose += isFirstCondition ? "WHERE " : "";
                    filterstrwithclose += $"zone = '{ddlzone.SelectedValue}' AND ";
                    isFirstCondition = false;
                    filterstrwithoutclose += "zone,";
                }

                // Circle filter
                if (!string.IsNullOrEmpty(circle) && circle != "All")
                {
                    filterstrwithclose += isFirstCondition ? "WHERE " : "";
                    filterstrwithclose += $"circle = '{ddlcircle.SelectedValue}' AND ";
                    isFirstCondition = false;
                    filterstrwithoutclose += "circle,";
                }

                // Division filter
                if (!string.IsNullOrEmpty(division) && division != "All")
                {
                    filterstrwithclose += isFirstCondition ? "WHERE " : "";
                    filterstrwithclose += $"division = '{ddldivision.SelectedValue}' AND ";
                    isFirstCondition = false;
                    filterstrwithoutclose += "division,";
                }

                // Trim trailing AND and commas
                if (filterstrwithclose.EndsWith(" AND "))
                    filterstrwithclose = filterstrwithclose.Substring(0, filterstrwithclose.Length - 5);

                if (filterstrwithoutclose.EndsWith(","))
                    filterstrwithoutclose = filterstrwithoutclose.Substring(0, filterstrwithoutclose.Length - 1);

                // Handle action logic
                switch (action)
                {
                    case "leopard":
                        animalColumns = @", SUM(t_leo) AS ""Total Leopard""";
                        animalFilter = "t_leo > 0";
                        break;
                    case "elephant":
                        animalColumns = @", SUM(t_elep) AS ""Total Elephant""";
                        animalFilter = "t_elep > 0";
                        break;
                    case "tiger":
                        animalColumns = @", SUM(t_tiger) AS ""Total Tiger""";
                        animalFilter = "t_tiger > 0";
                        break;
                    case "bear":
                        animalColumns = @", SUM(t_bear) AS ""Total Bear""";
                        animalFilter = "t_bear > 0";
                        break;
                    case "snake":
                        animalColumns = @", SUM(t_snake) AS ""Total Snake""";
                        animalFilter = "t_snake > 0";
                        break;
                    default:
                        animalColumns = @",
            SUM(t_leo) AS ""Total Leopard"",
            SUM(t_elep) AS ""Total Elephant"",
            SUM(t_tiger) AS ""Total Tiger"",
            SUM(t_bear) AS ""Total Bear"",
            SUM(t_snake) AS ""Total Snake""";
                        break;
                }

                // Append animal filter if needed
                if (!string.IsNullOrEmpty(animalFilter))
                {
                    if (string.IsNullOrEmpty(filterstrwithclose))
                        filterstrwithclose = $"WHERE {animalFilter}";
                    else
                        filterstrwithclose += $" AND {animalFilter}";
                }

                // Display tables
                areatable.Style.Add("display", "block");
                headernotaion.Style.Add("display", "none");
                ddlyear.Attributes.Remove("disabled");

                // Static q1 (monthly count)
                q1 = "SELECT count(division) AS num, month FROM " + ddlyear.SelectedValue + " " + filterstrwithclose +
                     " GROUP BY month ORDER BY CASE month " +
                     "WHEN 'Jan' THEN 1 WHEN 'Feb' THEN 2 WHEN 'Mar' THEN 3 WHEN 'Apr' THEN 4 " +
                     "WHEN 'May' THEN 5 WHEN 'Jun' THEN 6 WHEN 'Jul' THEN 7 WHEN 'Aug' THEN 8 " +
                     "WHEN 'Sep' THEN 9 WHEN 'Oct' THEN 10 WHEN 'Nov' THEN 11 WHEN 'Dec' THEN 12 END ASC;";

                // Always include all 3 levels
                string selectColumns = @"
    zone AS ""Zone"",
    circle AS ""Circle"",
    division AS ""Division""";

                string groupByColumns = "zone, circle, division";
                string orderByColumns = "zone, circle, division";

                // Final query
                q2 = $@"
    SELECT 
        {selectColumns}
        {animalColumns}
    FROM 
        public.tbl_wl_conflict
    {filterstrwithclose}
    GROUP BY 
        {groupByColumns}
    ORDER BY 
        {orderByColumns};
";

                string cqlFilter = "";

                if (!string.IsNullOrEmpty(zone) && zone != "All")
                    cqlFilter += $"zone = '{ddlzone.SelectedValue}' AND ";

                if (!string.IsNullOrEmpty(circle) && circle != "All")
                    cqlFilter += $"circle = '{ddlcircle.SelectedValue}' AND ";

                if (!string.IsNullOrEmpty(division) && division != "All")
                    cqlFilter += $"division = '{ddldivision.SelectedValue}' AND ";

                switch (action)
                {
                    case "leopard":
                        cqlFilter += "t_leo > 0 AND ";
                        break;
                    case "elephant":
                        cqlFilter += "t_elep > 0 AND ";
                        break;
                    case "tiger":
                        cqlFilter += "t_tiger > 0 AND ";
                        break;
                    case "bear":
                        cqlFilter += "t_bear > 0 AND ";
                        break;
                    case "snake":
                        cqlFilter += "t_snake > 0 AND ";
                        break;
                }

                // Remove trailing ' AND '
                if (cqlFilter.EndsWith(" AND "))
                    cqlFilter = cqlFilter.Substring(0, cqlFilter.Length - 5);

                // Pass this string to the frontend using a hidden field, JS variable, or AJAX
               // hiddenCqlFilter.Value = cqlFilter;



                //string q = "select gid,  month, source, latdeg, longdeg, state, blksectnrd, beat, forest_blk, comprtntn, zone, circle, division, range, block from " + ddlyear.SelectedValue+ " where   zone='" + ddlzone.SelectedValue + "' and circle='" + ddlcircle.SelectedValue + "' and division='" + ddldivision.SelectedValue + "'";
                DataTable dt = connectDB.executeGetData(q1);
                DataTable dt2 = connectDB.executeGetData(q2);
                string labels = "";
                string names = "";

                List<string> labelList = new List<string>();
                for (int i = 1; i < dt2.Columns.Count; i++)
                {
                    labelList.Add(dt2.Columns[i].ColumnName);
                }
                labels = string.Join(", ", labelList);



                string firststring = "";
                string secondstring = "";
                string thirdstring = "";

                int rowIndex = 0;

                foreach (DataRow row in dt2.Rows)
                {
                    names += row[0].ToString() + ", ";
                    List<string> rowValues = new List<string>();
                    for (int i = 1; i < dt2.Columns.Count; i++)
                    {
                        rowValues.Add(row[i].ToString());
                    }

                    string currentRowString = "[" + string.Join(", ", rowValues) + "]";

                    if (rowIndex == 0) firststring = currentRowString;
                    else if (rowIndex == 1) secondstring = currentRowString;
                    else if (rowIndex == 2) thirdstring = currentRowString;

                    rowIndex++;
                }


                names = names.TrimEnd(',', ' ');



                string scriptchart = $"applyfilter('{cqlFilter}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "applyfilter", scriptchart, true);

                if (dt.Rows.Count > 0)
                {

                    for (var i = 0; i < dt.Rows.Count; i++)
                    {
                        lbls += dt.Rows[i]["month"].ToString() + " ";
                        valus += dt.Rows[i]["num"].ToString() + " ";
                    }
                }
                if (dt2.Rows.Count > 0)
                {
                    for (var i = 0; i < dt2.Rows.Count; i++)
                    {
                        grd_area.DataSource = dt2;
                        grd_area.DataBind();
                        // unitname += dt2.Rows[i][labels_of_area_aaray[i]].ToString() + ", ";
                    }
                }
                //unitname = removelastChar(unitname);


                //string script1 = "applyfilter();";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script1, true);

                //string script2 = "callcolortable();";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script2, true);
                //string script = $"myJsFunction('{lbls}', '{valus}','{areaboundary}');";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "callFunction", script, true);

                //            string script = $@"
                //applyfilter();
                //myJsFunction('{lbls.Trim()}', '{valus.Trim()}');";
                //            ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script, true);



                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }

        private string removelastChar(string labels_of_area)
        {
            string result = "";
            if (!string.IsNullOrEmpty(labels_of_area))
            {
                result = labels_of_area.Substring(0, labels_of_area.Length - 1);
            }
            return result;
        }


        protected void ddlyear_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddlzone();
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddldivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                binddataaccrodingfilter();
            }
            catch (Exception ex)
            {

            }

        }

        protected void ddl_action_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                binddataaccrodingfilter();
            }
            catch (Exception ex)
            {

            }
        }
    }
}