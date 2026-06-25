using MailKit.Net.Smtp;        // ✅ Yeh add karo - MailKit ka SmtpClient
using MailKit.Security;
using MimeKit;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
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
                    //bindstatglance();
                    //bindunittotal();

                    //bindddlyear();
                    //bindddlzone();
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

                    //Res = client.GetAsync(apiUrl + string.Format("TblRolesMasters/GetTblRolesMasters")).Result;
                    Res = client.GetAsync(apiUrl + string.Format("TblRolesMasters/GetTblRolesMastersExcept_Applicant")).Result;

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

                //if (ddlRole.SelectedValue == "1" || ddlRole.SelectedValue == "2" || ddlRole.SelectedValue == "3" || ddlRole.SelectedValue == "4" || ddlRole.SelectedValue == "5" || ddlRole.SelectedValue == "6" || ddlRole.SelectedValue == "7" || ddlRole.SelectedValue == "8")
                if (ddlRole.SelectedValue == "1" || ddlRole.SelectedValue == "2" || ddlRole.SelectedValue == "3" || ddlRole.SelectedValue == "4" || ddlRole.SelectedValue == "5" || ddlRole.SelectedValue == "6" || ddlRole.SelectedValue == "7" || ddlRole.SelectedValue == "8" || ddlRole.SelectedValue == "9" || ddlRole.SelectedValue == "10" || ddlRole.SelectedValue == "11" || ddlRole.SelectedValue == "12")
                {
                    //var t = user_login(Convert.ToInt32(ddlRole.SelectedValue), txtUsername.Text, txtPassword.Text);
                    var t = user_login_2(Convert.ToInt32(ddlRole.SelectedValue), txtUsername.Text, txtPassword.Text);
                }
                else
                {

                }

                if (Session["UserId"] != null)
                {
                    int role = Convert.ToInt32(Session["RoleId"]);
                    if (Convert.ToInt32(Session["RoleId"].ToString()) == 1 || Convert.ToInt32(Session["RoleId"].ToString()) == 2)
                    {
                        //Response.Redirect("../DSS/analysis.aspx", false);
                        Response.Redirect("../DSS/analysis.aspx", false);
                    }
                    else if (role == 3 || role == 4 || role == 5 || role == 6 || role == 7 || role == 8 || role == 9 || role == 10)
                    {
                        if (Regex.IsMatch(Session["Password"].ToString(), @"^\d+$"))
                        {
                            // Password contains only digits
                            Response.Redirect("../Forest/changePassword.aspx", false);
                        }
                        else
                        {
                            //Response.Redirect("../DSS/analysis.aspx", false);
                            Response.Redirect("../Forest/hwcDashboard.aspx", false);
                        }
                    }
                    else if (role == 12)
                    {
                        Response.Redirect("../Forest/Account_DashBoard.aspx", false);
                    }



                    //else if (Convert.ToInt32(Session["RoleId"].ToString()) == 3)
                    //{
                    //    Response.Redirect("../Forest/Dashboard.aspx", false);
                    //}
                    //else if (Convert.ToInt32(Session["RoleId"].ToString()) == 4)
                    //{
                    //    Response.Redirect("../Forest/Dashboard.aspx", false);
                    //}
                    //else if (Convert.ToInt32(Session["RoleId"].ToString()) == 5)
                    //{
                    //    Response.Redirect("../Forest/Dashboard.aspx", false);
                    //}
                    //else if (Convert.ToInt32(Session["RoleId"].ToString()) == 6)
                    //{
                    //    Response.Redirect("../Forest/Dashboard.aspx", false);
                    //}
                    //else if (Convert.ToInt32(Session["RoleId"].ToString()) == 7)
                    //{
                    //    Response.Redirect("../Forest/Dashboard.aspx", false);
                    //}
                    //else if (Convert.ToInt32(Session["RoleId"].ToString()) == 8)
                    //{
                    //    Response.Redirect("../Forest/Dashboard.aspx", false);
                    //}
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
                    areatable.Style.Add("display", "none");
                    headernotaion.Style.Add("display", "none");
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
                    areatable.Style.Add("display", "block");
                    headernotaion.Style.Add("display", "none");
                    ddlyear.SelectedValue = "tbl_2021";
                    ddlyear.Attributes.Add("disabled", "disabled");
                    headernotation_degradation.Style.Add("display", "none");
                    headernotaion.Style.Add("display", "none");
                    q1 = "select count(division) as num,month from " + ddlyear.SelectedValue + "  " + filterstrwithclose + " group by month ORDER BY  CASE month WHEN 'Jan' THEN 1 WHEN 'Feb' THEN 2  WHEN 'Mar' THEN 3    WHEN 'Apr' THEN 4 WHEN 'May' THEN 5 WHEN 'Jun' THEN 6 WHEN 'Jul' THEN 7 WHEN 'Aug' THEN 8 WHEN 'Sep' THEN 9 WHEN 'Oct' THEN 10 WHEN 'Nov' THEN 11 WHEN 'Dec' THEN 12 END ASC; ";

                    if (filterstrwithclose == "")
                    {
                        findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        if (findboundarylayerfilter.Length > 0)
                        {
                            lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();
                            q2 = "select " + lastFilter + " as \"Admin Unit\" , round(rf_area_sq_km,2) as \"RF Area\",round(nf_area_sq_km,2) as \"NF Area\"  from tbl_zone_master order by " + lastFilter + " asc";
                        }
                        else
                        {

                            q2 = "select zone as \"Admin Unit\", round(rf_area_sq_km,2) as \"RF Area\",round(nf_area_sq_km,2) as \"NF Area\" from tbl_zone_master order by  zone asc";
                        }

                    }
                    else
                    {
                        // string filterstrwithoutclose = "division='Sales' AND region='East'"; // Example input

                        findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();

                        string layer = "tbl_" + lastFilter + "_master";
                        q2 = "select " + lastFilter + " as \"Admin Unit\" , round(rf_area_sq_km,2) as \"RF Area\",round(nf_area_sq_km,2) as \"NF Area\"   from " + layer + " " + filterstrwithclose + "  order by " + lastFilter + " asc";
                    }
                }
                else if (ddlaction.SelectedItem.Text == "Forest Density")
                {

                    ddlyear.SelectedValue = "tbl_2021";
                    ddlyear.Attributes.Add("disabled", "disabled");
                    areatable.Style.Add("display", "block");
                    headernotaion.Style.Add("display", "block");
                    headernotation_degradation.Style.Add("display", "none");
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
                else if (ddlaction.SelectedItem.Text == "Land Degradation")
                {

                    ddlyear.SelectedValue = "tbl_2019";
                    ddlyear.Attributes.Add("disabled", "disabled");
                    areatable.Style.Add("display", "block");
                    headernotaion.Style.Add("display", "none");
                    headernotation_degradation.Style.Add("display", "block");
                    if (filterstrwithclose == "")
                    {
                        findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        if (findboundarylayerfilter.Length > 0)
                        {
                            lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();
                            q2 = "select  " + lastFilter + " as \"Admin Unit\" , round(agri_unirrigated_water_erosion_low_sq_km,2) as \"Dw1\",round(forest_vegetation_degradation_low_sq_km,2) as \"Fv1\",round(periglacial_frost_shattering_high_sq_km,2) as \"Lf2\",  round(settlement_sq_km,2) as \"S\", round(scrub_vegetation_degradation_low_sq_km,2) as \"Sv1\",round(scrub_vegetation_degradation_high_sq_km,2) as \"Sv2\",round(water_body_drainage_sq_km, 2) as \"W\"  from tbl_zone_master  from tbl_zone_master  order by " + lastFilter + " asc ";
                        }
                        else
                        {

                            q2 = "select zone as \"Admin Unit\" , round(agri_unirrigated_water_erosion_low_sq_km,2) as \"Dw1\",round(forest_vegetation_degradation_low_sq_km,2) as \"Fv1\",round(periglacial_frost_shattering_high_sq_km,2) as \"Lf2\",  round(settlement_sq_km,2) as \"S\", round(scrub_vegetation_degradation_low_sq_km,2) as \"Sv1\",round(scrub_vegetation_degradation_high_sq_km,2) as \"Sv2\",round(water_body_drainage_sq_km, 2) as \"W\"   from tbl_zone_master order by zone asc ";
                        }

                    }
                    else
                    {
                        // string filterstrwithoutclose = "division='Sales' AND region='East'"; // Example input

                        findboundarylayerfilter = filterstrwithoutclose.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        lastFilter = findboundarylayerfilter[findboundarylayerfilter.Length - 1].Trim();

                        string layer = "tbl_" + lastFilter + "_master";
                        q2 = "select " + lastFilter + " as \"Admin Unit\", round(agri_unirrigated_water_erosion_low_sq_km,2) as \"Dw1\",round(forest_vegetation_degradation_low_sq_km,2) as \"Fv1\",round(periglacial_frost_shattering_high_sq_km,2) as \"Lf2\",  round(settlement_sq_km,2) as \"S\", round(scrub_vegetation_degradation_low_sq_km,2) as \"Sv1\",round(scrub_vegetation_degradation_high_sq_km,2) as \"Sv2\",round(water_body_drainage_sq_km, 2) as \"W\"    from " + layer + " " + filterstrwithclose + " order by " + lastFilter + " asc";
                    }
                }

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



                string scriptchart = $"callchart1('{names}', '{labels}','{firststring}','{secondstring}','{thirdstring}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "callchart1", scriptchart, true);

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


                string script1 = "applyfilter();";
                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script1, true);

                string script2 = "callcolortable();";
                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script2, true);
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

        //public async Task<JObject> user_login_2(Int32 RoleId, string UserId, string Password)
        //{
        //    try
        //    {
        //        object data;

        //        // Conditional assignment of the request body
        //        if (RoleId == 1 || RoleId == 2)
        //        {
        //            data = new
        //            {
        //                RoleId = RoleId,
        //                UserId = UserId,
        //                Password = Password,
        //            };
        //        }
        //        else
        //        {
        //            data = new
        //            {
        //                RoleId = RoleId,
        //                EmailId = UserId,
        //                Password = Password,
        //            };
        //        }

        //        var json = JsonConvert.SerializeObject(data);
        //        var data1 = new StringContent(json, Encoding.UTF8, "application/json");

        //        // Set the correct URL based on RoleId
        //        string url = (RoleId == 1 || RoleId == 2)
        //            ? apiUrl + "TblUserMasters/UserLogin"
        //            : apiUrl + "TblUserRegistrations/UserLogin_1";

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
        //                Session["EmailId"] = userData["emailId"]?.ToString();
        //                Session["Name"] = userData["name"]?.ToString();
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

        //        //using (HttpClient client = new HttpClient())
        //        //{
        //        //    var response = await client.PostAsync(url, data1);

        //        //    if (response.IsSuccessStatusCode)
        //        //    {
        //        //        var resultContent = await response.Content.ReadAsStringAsync();
        //        //        var userData = JsonConvert.DeserializeObject<JObject>(resultContent);

        //        //        if (userData != null && userData["isActive"] != null && Convert.ToBoolean(userData["isActive"].ToString()))
        //        //        {
        //        //            Session["UserId"] = userData["UserId"]?.ToString();
        //        //            Session["Password"] = userData["password"]?.ToString();
        //        //            Session["RoleId"] = userData["roleId"];
        //        //            Session["token"] = userData["token"]?.ToString();
        //        //        }
        //        //        else
        //        //        {
        //        //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "btn", "<script type='text/javascript'>alert('This User is not Active');</script>");
        //        //        }
        //        //    }
        //        //    else
        //        //    {
        //        //        Session["token"] = null;
        //        //        Session["UserId"] = null;
        //        //    }

        //        //    return new JObject { { "StatusCode", (int)response.StatusCode } };
        //        //}
        //    }
        //    catch (Exception ex)
        //    {
        //        throw; // Avoid using 'throw ex;' to preserve stack trace
        //    }
        //}

        public async Task<JObject> user_login_2(Int32 RoleId, string UserId, string Password)
        {
            try
            {
                object data;

                if (RoleId == 1 || RoleId == 2)
                {
                    data = new
                    {
                        RoleId = RoleId,
                        UserId = UserId,
                        Password = Password,
                    };
                }
                else if (RoleId == 11)
                {
                    data = new
                    {
                        RoleId = RoleId,
                        MobileNo = UserId,
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


                string url = (RoleId == 1 || RoleId == 2) ? apiUrl + "TblUserMasters/UserLogin" :
                   (RoleId == 11 ? apiUrl + "TblApplicantRegistrations/UserLogin" :
                   apiUrl + "TblUserRegistrations/UserLogin_1");

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
                        if (RoleId == 11)
                        {
                            Session["UserId"] = userData["applicantId"]?.ToString();
                        }
                        else
                        {
                            Session["UserId"] = userData["userId"]?.ToString();
                        }
                        //Session["UserId"] = userData["userId"]?.ToString();
                        Session["Password"] = userData["password"]?.ToString();
                        Session["RoleId"] = userData["roleId"];
                        Session["RoleName"] = userData["roleName"];
                        Session["token"] = userData["token"]?.ToString();
                        Session["EmailId"] = userData["emailId"]?.ToString();
                        Session["Name"] = userData["name"]?.ToString();
                        Session["RangeId"] = userData["rangeId"]?.ToString();
                        Session["DivisionId"] = userData["divisionId"]?.ToString();
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
                throw; // Avoid using 'throw ex;' to preserve stack trace
            }
        }

        protected void btnSendResetLink_Click(object sender, EventArgs e)
        {
            string userId = txtForgotUserId.Text.Trim();

            if (string.IsNullOrEmpty(userId))
            {
                return;
            }

            try
            {
                string Url = apiUrl + "TblUserMasters/GetForgotPassowrdUsername?userid=" + Uri.EscapeDataString(userId);

                using (HttpClient client = new HttpClient())
                {
                    HttpResponseMessage response = client.GetAsync(Url).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;
                        var user = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(json);
                        string email = user.emailId?.ToString() ?? "";
                        string Name = user.name?.ToString() ?? "";

                        if (!string.IsNullOrEmpty(email))
                        {
                            SendResetEmail(email, userId, Name);

                            string maskedEmail = MaskEmail(email);
                            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                                $"showResetSuccess('{maskedEmail}');", true);
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                                "showResetError('No email found for this User ID.');", true);
                        }
                    }
                    else if (response.StatusCode == System.Net.HttpStatusCode.NotFound)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                            "showResetError('User ID not found. Please check and try again.');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                            "showResetError('Something went wrong. Please try again later.');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log ex if needed
                ScriptManager.RegisterStartupScript(this, GetType(), "showError", "showResetError('An error occurred. Please try again.');", true);
            }
        }

        private string MaskEmail(string email)
        {
            try
            {
                int atIndex = email.IndexOf('@');
                if (atIndex <= 1) return email; // too short to mask

                string local = email.Substring(0, atIndex);
                string domain = email.Substring(atIndex);

                // ✅ Starting 2 + stars + ending 2 show karo
                if (local.Length <= 4)
                {
                    // Bahut chhota hai to sirf stars
                    return new string('*', local.Length) + domain;
                }

                string masked = local.Substring(0, 2)                        // pehle 2 chars
                              + new string('*', local.Length - 4)            // beech mein stars
                              + local.Substring(local.Length - 2, 2)         // aakhiri 2 chars
                              + domain;

                return masked;
            }
            catch
            {
                return "***@***.com";
            }
        }

        //private void SendResetEmail(string toEmail, string userId)
        //{
        //    try
        //    {
        //        string emailId = ConfigurationManager.AppSettings["email_idforgotpassword"];
        //        string appPassword = ConfigurationManager.AppSettings["email_id_passwordforgotpassword"];

        //        string resetLink = "https://ukforestgis.in/web/forgotpassword?userid="
        //                         + Uri.EscapeDataString(userId)
        //                         + "&email="
        //                         + Uri.EscapeDataString(toEmail);

        //        // MimeKit se message banao
        //        var message = new MimeMessage();
        //        message.From.Add(new MailboxAddress("Uttarakhand Forest Department", emailId));
        //        message.To.Add(new MailboxAddress("", toEmail));
        //        message.Subject = "Password Reset Link - Uttarakhand Forest Department";

        //        string htmlBody = @"
        //<div style='font-family:Arial,sans-serif; max-width:600px; margin:auto;'>
        //    <div style='height:8px; background:linear-gradient(90deg,#107a49,#1a9a5f,#d4a017);'></div>
        //    <div style='padding:30px; background:#fff;'>
        //        <h2 style='color:#0b5d37; text-align:center;'>🌿 Uttarakhand Forest Department</h2>
        //        <hr style='border:1px solid #d4a017; width:80px;'>
        //        <p style='color:#333; font-size:15px;'>Dear User,</p>
        //        <p style='color:#333; font-size:15px;'>
        //            Aapke account ke liye ek <b>Password Reset Request</b> prapt hui hai.
        //        </p>
        //        <div style='text-align:center; margin:30px 0;'>
        //            <a href='" + resetLink + @"' 
        //               style='background:linear-gradient(135deg,#107a49,#0b5d37);
        //                      color:#fff; padding:14px 35px; border-radius:10px;
        //                      text-decoration:none; font-size:16px; font-weight:bold;'>
        //                🔐 Reset My Password
        //            </a>
        //        </div>
        //        <p style='color:#555; font-size:13px;'>
        //            Ya yeh link browser mein paste karein:<br>
        //            <a href='" + resetLink + @"' style='color:#107a49;'>" + resetLink + @"</a>
        //        </p>
        //        <div style='background:#fff8e6; border-left:4px solid #d4a017; 
        //                    padding:14px; border-radius:6px; margin-top:20px;'>
        //            <p style='margin:0; color:#856404; font-size:13px;'>
        //                ⚠️ <b>Dhyan dein:</b><br>
        //                • Yeh link <b>15 minutes</b> mein expire ho jaayegi.<br>
        //                • Agar aapne request nahi ki to ignore karein.<br>
        //                • Password kisi se share na karein.
        //            </p>
        //        </div>
        //        <br>
        //        <p style='color:#333; font-size:13px;'>
        //            Thanks & Regards,<br>
        //            <b>Uttarakhand Forest Department</b>
        //        </p>
        //    </div>
        //    <div style='background:linear-gradient(135deg,#0b5d37,#1a9a5f); 
        //                padding:16px; text-align:center;'>
        //        <p style='color:#fff; font-size:12px; margin:0;'>
        //            🌲 ukforestgis.in &nbsp;|&nbsp; Automated Email — Please do not reply
        //        </p>
        //    </div>
        //</div>";

        //        var bodyBuilder = new BodyBuilder();
        //        bodyBuilder.HtmlBody = htmlBody;
        //        message.Body = bodyBuilder.ToMessageBody();

        //        // MailKit se send karo
        //        using (var smtp = new MailKit.Net.Smtp.SmtpClient())
        //        {
        //            smtp.Connect("smtp.gmail.com", 587, MailKit.Security.SecureSocketOptions.StartTls);
        //            smtp.Authenticate(emailId, appPassword);
        //            smtp.Send(message);
        //            smtp.Disconnect(true);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine("Email Error: " + ex.Message);
        //        ScriptManager.RegisterStartupScript(this, GetType(), "emailErr",
        //            $"alert('Email Error: {ex.Message.Replace("'", "").Replace("\n", " ")}');", true);
        //    }
        //}


        private void SendResetEmail(string toEmail, string userId, string Name)
        {
            string emailId;
            string appPassword;
            string url;

            try
            {
                emailId = ConfigurationManager.AppSettings["email_idforgotpassword"];
                appPassword = ConfigurationManager.AppSettings["email_id_passwordforgotpassword"];

                url = ConfigurationManager.AppSettings["Emailurl"];

                string encryptedEmail = EncryptString(toEmail);

                // ✅ Current time encrypt karke URL mein bhejo
                string currentTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                string encryptedTime = EncryptString(currentTime);

                string resetLink = url + "?em=" + Uri.EscapeDataString(encryptedEmail) + "&t=" + Uri.EscapeDataString(encryptedTime);

                // Banner image
                string bannerImagePath = Server.MapPath("../images/mailheader.png");
                string bannerBase64 = "";
                string bannerMimeType = "image/png";

                if (System.IO.File.Exists(bannerImagePath))
                {
                    byte[] imageBytes = System.IO.File.ReadAllBytes(bannerImagePath);
                    bannerBase64 = Convert.ToBase64String(imageBytes);
                }

                string bannerSrc = !string.IsNullOrEmpty(bannerBase64)
                    ? $"data:{bannerMimeType};base64,{bannerBase64}"
                    : "";

                using (MailMessage mm = new MailMessage())
                {
                    mm.From = new MailAddress(emailId, "Uttarakhand Forest Department");
                    mm.To.Add(new MailAddress(toEmail));
                    mm.Subject = "Password Reset Link - Uttarakhand Forest Department";
                    mm.IsBodyHtml = true;

                    string textBody = $@"
<!DOCTYPE html>
<html>
<body style='margin:0; padding:0; background:#f0f4f0; font-family: Arial, sans-serif;'>
<table width='100%' cellpadding='0' cellspacing='0' style='background:#f0f4f0; padding:30px 0;'>
    <tr>
        <td align='center'>
            <table width='620' cellpadding='0' cellspacing='0'
                   style='background:#ffffff; border-radius:14px;
                          overflow:hidden; box-shadow:0 4px 24px rgba(0,0,0,0.12);'>

                <!-- BODY -->
                <tr>
                    <td style='padding:35px 40px 10px;'>

                        <table cellpadding='0' cellspacing='0' style='margin-bottom:18px;'>
                            <tr>
                                <td style='vertical-align:middle;padding-right:14px;'>
                                    <div style='width:48px;height:48px;background:#eef8f2;
                                                border-radius:50%;text-align:center;line-height:48px;
                                                font-size:22px;border:1px solid #c3e6cc;'>✉️</div>
                                </td>
                                <td style='vertical-align:middle;'>
                                    <p style='margin:0;color:#111;font-size:18px;font-weight:bold;'>
                                        Dear {Name},
                                    </p>
                                </td>
                            </tr>
                        </table>

                        <p style='color:#333;font-size:15px;margin:0 0 10px;line-height:1.7;'>
                            A <b style='color:#107a49;'>Password Reset Request</b>
                            has been received for your account.
                        </p>
                        <p style='color:#333;font-size:15px;margin:0 0 25px;line-height:1.7;'>
                            Please click the button below to reset your password.
                        </p>

                        <!-- Reset Button -->
                        <table width='100%' cellpadding='0' cellspacing='0'>
                            <tr>
                                <td align='center' style='padding:5px 0 22px;'>
                                    <a href='{resetLink}'
                                       style='background:#1a6b40;color:#ffffff;
                                              padding:16px 55px;border-radius:8px;
                                              text-decoration:none;font-size:17px;
                                              font-weight:bold;display:inline-block;'>
                                        &#128272;&nbsp;&nbsp;Reset My Password
                                    </a>
                                </td>
                            </tr>
                        </table>

                        <!-- OR Divider -->
                        <table width='100%' cellpadding='0' cellspacing='0' style='margin:5px 0 18px;'>
                            <tr>
                                <td style='border-top:1px solid #ddd;width:45%;'></td>
                                <td style='text-align:center;padding:0 12px;color:#aaa;font-size:13px;white-space:nowrap;'>OR</td>
                                <td style='border-top:1px solid #ddd;width:45%;'></td>
                            </tr>
                        </table>

                        <p style='color:#444;font-size:14px;margin:0 0 6px;'>
                            Or copy and paste this link into your browser:
                        </p>
                        <p style='margin:0 0 28px;'>
                            <a href='{resetLink}' style='color:#1a6b40;font-size:13px;word-break:break-all;'>
                                {resetLink}
                            </a>
                        </p>

                        <!-- Important Notes -->
                        <div style='background:#fff8ee;border:1px solid #f0ddb0;
                                    border-radius:10px;padding:18px 22px;margin-bottom:28px;'>
                            <p style='margin:0 0 12px;color:#c47f00;font-size:14px;font-weight:bold;'>
                                <span style='display:inline-block;width:22px;height:22px;background:#e6a817;
                                             border-radius:50%;text-align:center;line-height:22px;
                                             font-size:13px;color:#fff;margin-right:8px;'>!</span>
                                Important Notes
                            </p>
                            <table cellpadding='0' cellspacing='0'>
                                <tr>
                                    <td style='padding:5px 0;'>
                                        <span style='color:#107a49;font-size:16px;'>&#10004;</span>
                                        <span style='color:#555;font-size:14px;margin-left:10px;'>
                                            This link will expire in <b>15 minutes</b>.
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style='padding:5px 0;'>
                                        <span style='color:#107a49;font-size:16px;'>&#10004;</span>
                                        <span style='color:#555;font-size:14px;margin-left:10px;'>
                                            If you did not request this, please ignore this email.
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style='padding:5px 0;'>
                                        <span style='color:#107a49;font-size:16px;'>&#10004;</span>
                                        <span style='color:#555;font-size:14px;margin-left:10px;'>
                                            Never share your password with anyone.
                                        </span>
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <hr style='border:none;border-top:1px solid #e8e8e8;margin-bottom:22px;'>

                        <!-- Footer Signature -->
                        <table width='100%' cellpadding='0' cellspacing='0' style='margin-bottom:20px;'>
                            <tr>
                                <td style='vertical-align:middle;width:55%;'>
                                    <table cellpadding='0' cellspacing='0'>
                                        <tr>
                                            <td style='vertical-align:middle;padding-right:14px;'>
                                                <div style='width:48px;height:48px;background:#0b5d37;
                                                            border-radius:50%;text-align:center;
                                                            line-height:48px;font-size:22px;'>🔒</div>
                                            </td>
                                            <td style='vertical-align:middle;'>
                                                <p style='margin:0;color:#333;font-size:14px;'>Thanks &amp; Regards,</p>
                                                <p style='margin:3px 0 0;color:#107a49;font-size:15px;font-weight:bold;'>
                                                    Uttarakhand Forest Department
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style='width:1px;background:#e0e0e0;padding:0;'></td>
                                <td style='vertical-align:middle;padding-left:22px;width:44%;'>
                                    <p style='margin:0 0 6px;color:#555;font-size:13px;'>
                                        🌐&nbsp;<a href='https://www.ukforestgis.in' style='color:#107a49;text-decoration:none;'>www.ukforestgis.in</a>
                                    </p>
                                    <p style='margin:0;color:#555;font-size:13px;'>
                                        ✉️&nbsp;<a href='mailto:support@ukforestgis.in' style='color:#107a49;text-decoration:none;'>support@ukforestgis.in</a>
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <!-- DARK FOOTER -->
                <tr>
                    <td style='background:#1a2e22;padding:20px 30px;border-radius:0 0 14px 14px;'>
                        <table cellpadding='0' cellspacing='0' width='100%'>
                            <tr>
                                <td style='vertical-align:middle;padding-right:14px;width:44px;'>
                                    <div style='width:40px;height:40px;background:#0b5d37;
                                                border:2px solid #d4a017;border-radius:50%;
                                                text-align:center;line-height:40px;font-size:18px;'>🛡️</div>
                                </td>
                                <td style='vertical-align:middle;'>
                                    <p style='margin:0;color:#ccc;font-size:12px;line-height:1.7;'>
                                        <b style='color:#fff;'>Confidentiality Notice:</b>
                                        This e-mail message is for the sole use of the intended recipient(s)
                                        and may contain confidential information.
                                        If you are not the intended recipient, please delete this email immediately.
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

            </table>
        </td>
    </tr>
</table>
</body>
</html>";

                    mm.Body = textBody;

                    using (System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587))
                    {
                        smtp.EnableSsl = true;
                        smtp.UseDefaultCredentials = false;
                        smtp.Credentials = new NetworkCredential(emailId, appPassword);
                        smtp.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
                        smtp.Timeout = 20000;
                        smtp.Send(mm);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Email Error: " + ex.Message);
                ScriptManager.RegisterStartupScript(this, GetType(), "emailErr",
                    $"console.log('Email Error: {ex.Message.Replace("'", "").Replace("\n", " ")}');", true);
            }
        }



        private static readonly string EncryptionKey = "UKForest@2026#SecretKey!@#$%^&*()"; // 32 chars

    private string EncryptString(string plainText)
    {
        try
        {
            byte[] key = SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(EncryptionKey));
            byte[] iv = new byte[16]; // 16 bytes IV (zeros)

            using (Aes aes = Aes.Create())
            {
                aes.Key = key;
                aes.IV = iv;
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;

                using (ICryptoTransform encryptor = aes.CreateEncryptor())
                {
                    byte[] plainBytes = Encoding.UTF8.GetBytes(plainText);
                    byte[] encryptedBytes = encryptor.TransformFinalBlock(plainBytes, 0, plainBytes.Length);

                    // Base64 → URL Safe banao
                    string base64 = Convert.ToBase64String(encryptedBytes);
                    string urlSafe = base64.Replace("+", "-").Replace("/", "_").Replace("=", "~");
                    return urlSafe;
                }
            }
        }
        catch
        {
            return string.Empty;
        }
    }

    private string DecryptString(string encryptedText)
    {
        try
        {
            // URL Safe → Base64 wapas karo
            string base64 = encryptedText.Replace("-", "+").Replace("_", "/").Replace("~", "=");
            byte[] encryptedBytes = Convert.FromBase64String(base64);

            byte[] key = SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(EncryptionKey));
            byte[] iv = new byte[16];

            using (Aes aes = Aes.Create())
            {
                aes.Key = key;
                aes.IV = iv;
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;

                using (ICryptoTransform decryptor = aes.CreateDecryptor())
                {
                    byte[] plainBytes = decryptor.TransformFinalBlock(encryptedBytes, 0, encryptedBytes.Length);
                    return Encoding.UTF8.GetString(plainBytes);
                }
            }
        }
        catch
        {
            return string.Empty;
        }
    }


    //private void SendResetEmail(string toEmail, string userId)
    //{
    //    try
    //    {
    //        // Reset link with email parameter
    //        string resetLink = "https://ukforestgis.in/web/forgotpassword?userid="
    //                         + Uri.EscapeDataString(userId)
    //                         + "&email="
    //                         + Uri.EscapeDataString(toEmail);

    //        var message = new MimeMessage();
    //        message.From.Add(new MailboxAddress("Uttarakhand Forest Department", "foresthec@gmail.com"));
    //        message.To.Add(new MailboxAddress("", toEmail));
    //        message.Subject = "Password Reset Link - Uttarakhand Forest Department";

    //        // HTML Email Body
    //        string htmlBody = $@"
    //<!DOCTYPE html>
    //<html>
    //<body style='margin:0; padding:0; font-family: Arial, sans-serif; background:#f4f4f4;'>
    //    <table width='100%' cellpadding='0' cellspacing='0' style='background:#f4f4f4; padding: 30px 0;'>
    //        <tr>
    //            <td align='center'>
    //                <table width='550' cellpadding='0' cellspacing='0' 
    //                       style='background:#ffffff; border-radius:16px; overflow:hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1);'>

    //                    <!-- Top Strip -->
    //                    <tr>
    //                        <td style='height:8px; background: linear-gradient(90deg, #107a49, #1a9a5f, #d4a017);'></td>
    //                    </tr>

    //                    <!-- Header -->
    //                    <tr>
    //                        <td align='center' style='padding: 35px 40px 20px;'>
    //                            <h2 style='color:#0b5d37; margin:0; font-size:22px;'>🌿 UTTARAKHAND FOREST DEPARTMENT</h2>
    //                            <p style='color:#888; font-size:13px; margin:5px 0 0; letter-spacing:2px;'>PASSWORD RESET REQUEST</p>
    //                        </td>
    //                    </tr>

    //                    <!-- Divider -->
    //                    <tr>
    //                        <td align='center' style='padding: 0 40px;'>
    //                            <hr style='border:none; border-top: 2px solid #d4a017; width:80px;'>
    //                        </td>
    //                    </tr>

    //                    <!-- Body -->
    //                    <tr>
    //                        <td style='padding: 25px 40px;'>
    //                            <p style='color:#333; font-size:15px; line-height:1.7;'>
    //                                Namaste,<br><br>
    //                                Aapke account ke liye ek <strong>password reset request</strong> 
    //                                prapt hui hai.<br>
    //                                Neeche diye gaye button par click karke apna password reset karein.
    //                            </p>

    //                            <!-- Reset Button -->
    //                            <table width='100%' cellpadding='0' cellspacing='0'>
    //                                <tr>
    //                                    <td align='center' style='padding: 20px 0;'>
    //                                        <a href='{resetLink}' 
    //                                           style='background: linear-gradient(135deg, #107a49, #0b5d37);
    //                                                  color: #ffffff;
    //                                                  text-decoration: none;
    //                                                  padding: 16px 40px;
    //                                                  border-radius: 10px;
    //                                                  font-size: 17px;
    //                                                  font-weight: bold;
    //                                                  display: inline-block;'>
    //                                            🔐 Reset My Password
    //                                        </a>
    //                                    </td>
    //                                </tr>
    //                            </table>

    //                            <!-- Link Box -->
    //                            <p style='color:#555; font-size:13px; margin-top:10px;'>
    //                                Agar button kaam na kare, to yeh link copy karke browser mein paste karein:
    //                            </p>
    //                            <div style='background:#f0f8f4; border:1px solid #c3e6cc; border-radius:8px; 
    //                                        padding:12px 16px; word-break:break-all;'>
    //                                <a href='{resetLink}' style='color:#107a49; font-size:13px;'>{resetLink}</a>
    //                            </div>

    //                            <!-- Warning -->
    //                            <div style='background:#fff8e6; border-left:4px solid #d4a017; 
    //                                        border-radius:8px; padding:14px 18px; margin-top:22px;'>
    //                                <p style='margin:0; color:#856404; font-size:13px; line-height:1.6;'>
    //                                    ⚠️ <strong>Dhyan dein:</strong><br>
    //                                    • Yeh link <strong>15 minutes</strong> mein expire ho jaayegi.<br>
    //                                    • Agar aapne yeh request nahi ki, to is email ko ignore karein.<br>
    //                                    • Apna password kisi ke saath share na karein.
    //                                </p>
    //                            </div>
    //                        </td>
    //                    </tr>

    //                    <!-- Footer -->
    //                    <tr>
    //                        <td style='background: linear-gradient(to right, #0b5d37, #1a9a5f); 
    //                                   padding: 22px 40px; text-align:center;'>
    //                            <p style='color:#ffffff; font-size:13px; margin:0; opacity:0.9;'>
    //                                🌲 Uttarakhand Forest Department &nbsp;|&nbsp; 
    //                                <a href='https://ukforestgis.in' style='color:#d4a017; text-decoration:none;'>
    //                                    ukforestgis.in
    //                                </a>
    //                            </p>
    //                            <p style='color:#ccc; font-size:11px; margin:6px 0 0;'>
    //                                Yeh ek automated email hai. Kripya reply na karein.
    //                            </p>
    //                        </td>
    //                    </tr>

    //                </table>
    //            </td>
    //        </tr>
    //    </table>
    //</body>
    //</html>";

    //        var bodyBuilder = new BodyBuilder();
    //        bodyBuilder.HtmlBody = htmlBody;
    //        message.Body = bodyBuilder.ToMessageBody();

    //        using (var smtp = new SmtpClient())
    //        {
    //            smtp.Connect("smtp.gmail.com", 587, SecureSocketOptions.StartTls);
    //            smtp.Authenticate("foresthec@gmail.com", "jbcsngibszhfilro"); // Naya App Password
    //            smtp.Send(message);
    //            smtp.Disconnect(true);
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        // Log error
    //        Console.WriteLine("Email error: " + ex.Message);
    //    }
    //}
}
}