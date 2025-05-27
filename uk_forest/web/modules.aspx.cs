using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.web
{
    public partial class modules : System.Web.UI.Page
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
                    bind_role();

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
                string q = "select distinct circle from tbl_circle_master where zone ='"+ddlzone.SelectedValue+"' order by circle asc";
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
                else {
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
        void bind_role()
        {
            HttpResponseMessage Res;
            DataTable dt;

            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/api"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    Res = client.GetAsync(apiUrl + string.Format("TblRolesMasters/GetTblRolesMasters")).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));
                        ddlRole.Items.Clear();
                        ddlRole.DataSource = dt;
                        ddlRole.DataValueField = "RoleId";
                        ddlRole.DataTextField = "RoleName";
                        ddlRole.DataBind();
                        ddlRole.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Role", "0"));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddlRole.SelectedValue == "0")
                {
                    string script = $"alert('Please Select Role');";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
                    return;
                }
                if (txtUsername.Text == "" && txtPassword.Text != "")
                {
                    string script = $"alert('Please Provide username');";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
                    return;
                }
                else if (txtUsername.Text != "" && txtPassword.Text == "")
                {
                    string script = $"alert('Please Provide password');";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
                    return;
                }
                else if (txtUsername.Text == "" && txtPassword.Text == "")
                {
                    string script = $"alert('Please Provide Username and password');";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
                    return;
                }

                if (ddlRole.SelectedValue == "1" || ddlRole.SelectedValue == "2" || ddlRole.SelectedValue == "3" || ddlRole.SelectedValue == "4" || ddlRole.SelectedValue == "5" || ddlRole.SelectedValue == "6" || ddlRole.SelectedValue == "7" || ddlRole.SelectedValue == "8")
                {
                    //var t = user_login(Convert.ToInt32(ddlRole.SelectedValue), txtUsername.Text, txtPassword.Text);
                    var t = user_login_2(Convert.ToInt32(ddlRole.SelectedValue), txtUsername.Text, txtPassword.Text);
                }
                else
                {

                }


                if (Session["UserId"] != null)
                {
                    if (Convert.ToInt32(Session["RoleId"].ToString()) == 1 || Convert.ToInt32(Session["RoleId"].ToString()) == 2)
                    {
                        Response.Redirect("../Forest/Dashboard.aspx", false);
                    }
                    else if (Convert.ToInt32(Session["RoleId"].ToString()) == 3)
                    {
                        Response.Redirect("../Forest/Dashboard.aspx", false);
                    }
                    else if (Convert.ToInt32(Session["RoleId"].ToString()) == 4)
                    {
                        Response.Redirect("../Forest/Dashboard.aspx", false);
                    }
                    else if (Convert.ToInt32(Session["RoleId"].ToString()) == 5)
                    {
                        Response.Redirect("../Forest/Dashboard.aspx", false);
                    }
                    else if (Convert.ToInt32(Session["RoleId"].ToString()) == 6)
                    {
                        Response.Redirect("../Forest/Dashboard.aspx", false);
                    }
                    else if (Convert.ToInt32(Session["RoleId"].ToString()) == 7)
                    {
                        Response.Redirect("../Forest/Dashboard.aspx", false);
                    }
                    else if (Convert.ToInt32(Session["RoleId"].ToString()) == 8)
                    {
                        Response.Redirect("../Forest/Dashboard.aspx", false);
                    }
                    else
                    {
                        string script = $"alert('UserId and password are incorrect');";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
                        return;
                    }
                }
                else
                {
                    string script = $"alert('UserId and password are incorrect');";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", script, true);
                    return;
                }



            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

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
            }catch(Exception ex)
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
                
                //string filterstrparameter = "";
                

                if (!string.IsNullOrEmpty(zone) && zone != "All")
                {
                    filterstrwithclose += $"where ";
                    filterstrwithclose += $"zone='{ddlzone.SelectedValue}' AND ";
                    filterstrwithoutclose += $",zone,";
                    //filterstrparameter += $",zone,";
                }
                if (!string.IsNullOrEmpty(circle) && circle != "All")
                {
                    filterstrwithclose += $"circle='{ddlcircle.SelectedValue}' AND ";
                    filterstrwithoutclose += $"circle,";
                    //filterstrparameter += $"circle,";
                }
                if (!string.IsNullOrEmpty(division) && division != "All")
                {
                    filterstrwithclose += $"division='{ddldivision.SelectedValue}' AND ";
                    filterstrwithoutclose += $"division,";
                    //filterstrparameter += $"division,";
                }

                // Remove trailing " AND " if it exists
                if (filterstrwithclose.EndsWith(" AND "))
                {
                    filterstrwithclose = filterstrwithclose.Substring(0, filterstrwithclose.Length - 5);
                    filterstrwithoutclose = filterstrwithoutclose.Substring(0, filterstrwithoutclose.Length - 1);
                    //filterstrparameter = filterstrparameter.Substring(0, filterstrparameter.Length - 1);
                }

                
                if (ddlaction.SelectedItem.Text == "Fire Points")
                {
                    ddlyear.Attributes.Remove("disabled");
                    q1 = "select count(division) as num,month from " + ddlyear.SelectedValue + "  " + filterstrwithclose + " group by month ORDER BY  CASE month WHEN 'Jan' THEN 1 WHEN 'Feb' THEN 2  WHEN 'Mar' THEN 3    WHEN 'Apr' THEN 4 WHEN 'May' THEN 5 WHEN 'Jun' THEN 6 WHEN 'Jul' THEN 7 WHEN 'Aug' THEN 8 WHEN 'Sep' THEN 9 WHEN 'Oct' THEN 10 WHEN 'Nov' THEN 11 WHEN 'Dec' THEN 12 END ASC; ";

                    if (filterstrwithclose == "")
                    {
                        //findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        //if (findboundarylayerfilter.Length > 0)
                        //{
                        //    lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();
                        //    q2 = "select " + lastFilter + " as \"Admin Unit\" , round(rf_area_sq_km,2) as \"RF Area (Sq Km)\",round(nf_area_sq_km,2) as \"NF Area (Sq Km)\"  from tbl_zone_master";
                        //}
                        //else
                        //{

                        //    q2 = "select zone as \"Admin Unit\", round(rf_area_sq_km,2) as \"RF Area (Sq Km)\",round(nf_area_sq_km,2) as \"NF Area (Sq Km)\" from tbl_zone_master";
                        //}

                    }
                    else
                    {
                        // string filterstrwithoutclose = "division='Sales' AND region='East'"; // Example input

                        //findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        //lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();

                        //string layer = "tbl_" + lastFilter + "_master";
                        //q2 = "select " + lastFilter + " as \"Admin Unit\" , round(rf_area_sq_km,2) as \"RF Area (Sq Km)\",round(nf_area_sq_km,2) as \"NF Area (Sq Km)\"   from " + layer + " " + filterstrwithclose + "";
                    }
                }
                else if (ddlaction.SelectedItem.Text == "Forest Area")
                {
                    ddlyear.SelectedValue = "tbl_2021";
                    ddlyear.Attributes.Add("disabled", "disabled");
                    q1 = "select count(division) as num,month from " + ddlyear.SelectedValue + "  " + filterstrwithclose + " group by month ORDER BY  CASE month WHEN 'Jan' THEN 1 WHEN 'Feb' THEN 2  WHEN 'Mar' THEN 3    WHEN 'Apr' THEN 4 WHEN 'May' THEN 5 WHEN 'Jun' THEN 6 WHEN 'Jul' THEN 7 WHEN 'Aug' THEN 8 WHEN 'Sep' THEN 9 WHEN 'Oct' THEN 10 WHEN 'Nov' THEN 11 WHEN 'Dec' THEN 12 END ASC; ";

                    if (filterstrwithclose == "")
                    {
                        findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        if (findboundarylayerfilter.Length > 0)
                        {
                            lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();
                            q2 = "select " + lastFilter + " as \"Admin Unit\" , round(rf_area_sq_km,2) as \"RF Area (Sq Km)\",round(nf_area_sq_km,2) as \"NF Area (Sq Km)\"  from tbl_zone_master";
                        }
                        else
                        {

                            q2 = "select zone as \"Admin Unit\", round(rf_area_sq_km,2) as \"RF Area (Sq Km)\",round(nf_area_sq_km,2) as \"NF Area (Sq Km)\" from tbl_zone_master";
                        }

                    }
                    else
                    {
                        // string filterstrwithoutclose = "division='Sales' AND region='East'"; // Example input

                        findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();

                        string layer = "tbl_" + lastFilter + "_master";
                        q2 = "select " + lastFilter + " as \"Admin Unit\" , round(rf_area_sq_km,2) as \"RF Area (Sq Km)\",round(nf_area_sq_km,2) as \"NF Area (Sq Km)\"   from " + layer + " " + filterstrwithclose + "";
                    }
                }
                else if (ddlaction.SelectedItem.Text == "Forest Density")
                {
                     
                    ddlyear.SelectedValue = "tbl_2021";
                    ddlyear.Attributes.Add("disabled", "disabled");
                    if (filterstrwithclose == "")
                    {
                        findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        if (findboundarylayerfilter.Length > 0)
                        {
                            lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();
                            q2 = "select  " + lastFilter + " as \"Admin Unit\" , round(scrub,2) as \"Scurb\",round(open_forest,2) as \"Open Forest\",round(moderately_dense_forest,2) as \"Moderately Dense Forest\",round(very_dense,2) as \"Very Dense Forest\"  from tbl_zone_master  order by " + lastFilter + " asc ";
                        }
                        else
                        {

                            q2 = "select zone as \"Admin Unit\" , round(scrub,2) as \"Scurb\",round(open_forest,2) as \"Open Forest\",round(moderately_dense_forest,2) as \"Moderately Dense Forest\",round(very_dense,2) as \"Very Dense Forest\"  from tbl_zone_master order by zone asc ";
                        }

                    }
                    else
                    {
                        // string filterstrwithoutclose = "division='Sales' AND region='East'"; // Example input

                        findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();

                        string layer = "tbl_" + lastFilter + "_master";
                        q2 = "select " + lastFilter + " as \"Admin Unit\", round(scrub,2) as \"Scurb\",round(open_forest,2) as \"Open Forest\",round(moderately_dense_forest,2) as \"Moderately Dense Forest\",round(very_dense,2) as \"Very Dense Forest\"   from " + layer + " " + filterstrwithclose + " order by " + lastFilter + " asc";
                    }
                }

                //string q = "select gid,  month, source, latdeg, longdeg, state, blksectnrd, beat, forest_blk, comprtntn, zone, circle, division, range, block from " + ddlyear.SelectedValue+ " where   zone='" + ddlzone.SelectedValue + "' and circle='" + ddlcircle.SelectedValue + "' and division='" + ddldivision.SelectedValue + "'";
                DataTable dt = connectDB.executeGetData(q1);
                    DataTable dt2 = connectDB.executeGetData(q2);
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
                        //areaboundary += Convert.ToDecimal(dt2.Rows[i]["rf_sqkm"]).ToString("F2") + " ";
                        //areaboundary += Convert.ToDecimal(dt2.Rows[i]["nf_sqkm"]).ToString("F2") + " ";

                    }



                    }

                
                string script1 = "applyfilter();";
                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script1, true);
                string script = $"myJsFunction('{lbls}', '{valus}','{areaboundary}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "callFunction", script, true);

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

        protected void ddlyear_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddlzone();
            }catch(Exception ex)
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






        public async Task<JObject> user_login(Int32 RoleId, string UserId, string Password)
        {
            try
            {
                var data = new
                {
                    RoleId = RoleId,
                    UserId = UserId,
                    Password = Password,
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                //var url = apiUrl + "TblUserRegistrations/UserLogin";
                string url = (RoleId == 1 || RoleId == 2)
            ? apiUrl + "TblUserMasters/UserLogin"
            : apiUrl + "TblUserRegistrations/UserLogin";
                HttpClient client = new HttpClient();
                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;

                if (response.IsSuccessStatusCode)
                {
                    var resultContent = await response.Content.ReadAsStringAsync();
                    var userData = JsonConvert.DeserializeObject<JObject>(resultContent);

                    if (userData != null && userData["isActive"] != null && Convert.ToBoolean(userData["isActive"].ToString()))
                    {
                        Session["UserId"] = userData["userId"]?.ToString();
                        Session["Password"] = userData["password"]?.ToString();
                        Session["RoleId"] = userData["roleId"];
                        Session["token"] = userData["token"]?.ToString();
                    }
                    else
                    {
                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "btn", "<script type = 'text/javascript'>alert('This User is not Active');</script>");
                    }
                }
                else
                {
                    Session["token"] = null;
                    Session["UserId"] = null;
                }
                return new JObject { { "StatusCode", (int)response.StatusCode } };
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<JObject> user_login_1(Int32 RoleId, string UserId, string Password)
        {
            try
            {
                var data = new
                {
                    RoleId = RoleId,
                    EmailId = UserId,
                    Password = Password,
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                //var url = apiUrl + "TblUserRegistrations/UserLogin";
                string url = (RoleId == 1 || RoleId == 2)
            ? apiUrl + "TblUserMasters/UserLogin"
            : apiUrl + "TblUserRegistrations/UserLogin_1";
                HttpClient client = new HttpClient();
                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;

                if (response.IsSuccessStatusCode)
                {
                    var resultContent = await response.Content.ReadAsStringAsync();
                    var userData = JsonConvert.DeserializeObject<JObject>(resultContent);

                    if (userData != null && userData["isActive"] != null && Convert.ToBoolean(userData["isActive"].ToString()))
                    {
                        Session["UserId"] = userData["userId"]?.ToString();
                        Session["Password"] = userData["password"]?.ToString();
                        Session["RoleId"] = userData["roleId"];
                        Session["token"] = userData["token"]?.ToString();
                    }
                    else
                    {
                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "btn", "<script type = 'text/javascript'>alert('This User is not Active');</script>");
                    }
                }
                else
                {
                    Session["token"] = null;
                    Session["UserId"] = null;
                }
                return new JObject { { "StatusCode", (int)response.StatusCode } };
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<JObject> user_login_2(Int32 RoleId, string UserId, string Password)
        {
            try
            {
                object data;

                // Conditional assignment of the request body
                if (RoleId == 1 || RoleId == 2)
                {
                    data = new
                    {
                        RoleId = RoleId,
                        UserId = UserId,
                        Password = Password,
                    };
                }
                else
                {
                    data = new
                    {
                        RoleId = RoleId,
                        EmailId = UserId,
                        Password = Password,
                    };
                }

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");

                // Set the correct URL based on RoleId
                string url = (RoleId == 1 || RoleId == 2)
                    ? apiUrl + "TblUserMasters/UserLogin"
                    : apiUrl + "TblUserRegistrations/UserLogin_1";

                HttpClient client = new HttpClient();
                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                    var resultContent = await response.Content.ReadAsStringAsync();
                    var userData = JsonConvert.DeserializeObject<JObject>(resultContent);

                    if (userData != null && userData["isActive"] != null && Convert.ToBoolean(userData["isActive"].ToString()))
                    {
                        Session["UserId"] = userData["userId"]?.ToString();
                        Session["Password"] = userData["password"]?.ToString();
                        Session["RoleId"] = userData["roleId"];
                        Session["token"] = userData["token"]?.ToString();
                    }
                    else
                    {
                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "btn", "<script type = 'text/javascript'>alert('This User is not Active');</script>");
                    }
                }
                else
                {
                    Session["token"] = null;
                    Session["UserId"] = null;
                }

                return new JObject { { "StatusCode", (int)response.StatusCode } };

                //using (HttpClient client = new HttpClient())
                //{
                //    var response = await client.PostAsync(url, data1);

                //    if (response.IsSuccessStatusCode)
                //    {
                //        var resultContent = await response.Content.ReadAsStringAsync();
                //        var userData = JsonConvert.DeserializeObject<JObject>(resultContent);

                //        if (userData != null && userData["isActive"] != null && Convert.ToBoolean(userData["isActive"].ToString()))
                //        {
                //            Session["UserId"] = userData["UserId"]?.ToString();
                //            Session["Password"] = userData["password"]?.ToString();
                //            Session["RoleId"] = userData["roleId"];
                //            Session["token"] = userData["token"]?.ToString();
                //        }
                //        else
                //        {
                //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "btn", "<script type='text/javascript'>alert('This User is not Active');</script>");
                //        }
                //    }
                //    else
                //    {
                //        Session["token"] = null;
                //        Session["UserId"] = null;
                //    }

                //    return new JObject { { "StatusCode", (int)response.StatusCode } };
                //}
            }
            catch (Exception ex)
            {
                throw; // Avoid using 'throw ex;' to preserve stack trace
            }
        }


    }
}