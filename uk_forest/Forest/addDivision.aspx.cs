using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class addDivision : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = System.Configuration.ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session["token"] == null)
                {
                    //Response.Redirect("~/Index.aspx");
                }
                else
                {
                    token_sess = Session["token"].ToString();
                }
                if (!Page.IsPostBack)
                {
                    bind_zone_name();
                    //ddl_circle_list.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0"));
                    bind_circle_name(Convert.ToInt32(ddl_zone_list.SelectedValue));
                    grid_name_division(Convert.ToInt32(ddl_zone_list.SelectedValue), Convert.ToInt32(ddl_circle_list.SelectedValue));
                    //bind_circle_name(Convert.ToInt32(ddl_zone_list.SelectedValue));
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("An error occurred: " + ex.Message);
            }
        }
        private void ClearControls()
        {
            foreach (Control control in this.Page.Controls)
            {
                ClearControl(control);
            }
        }

        private void ClearControl(Control control)
        {
            if (control is TextBox)
            {
                ((TextBox)control).Text = string.Empty;
            }
            else if (control is DropDownList)
            {
                ((DropDownList)control).SelectedIndex = 0;
            }
            else if (control is CheckBox)
            {
                ((CheckBox)control).Checked = false;
            }
            else if (control.HasControls())
            {
                foreach (Control childControl in control.Controls)
                {
                    ClearControl(childControl);
                }
            }
        }


        void bind_zone_name()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblZoneMasters/GetTblZoneMasters")).Result;
                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddl_zone_list.Items.Clear();
                        ddl_zone_list.DataSource = dt;
                        ddl_zone_list.DataValueField = "zoneId";
                        ddl_zone_list.DataTextField = "zoneName";
                        ddl_zone_list.DataBind();
                        ddl_zone_list.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                    }
                }
            }
            catch (Exception ex)
            {
                //throw ex;
            }
        }

        void bind_circle_name(int zone_id)
        {
            try
            {
                HttpResponseMessage Res;

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    //HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblCircleMasters/GetTblCircleMasterByZoneId?zone_id=" + zone_id)).Result;

                    Res = client.GetAsync(apiUrl + ("TblCircleMasters/GetTblCircleMasterByZoneId?zone_id=" + zone_id)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        if (Convert.ToInt32(Res.StatusCode) == 201)
                        {
                            ddl_circle_list.Items.Clear();
                            ddl_circle_list.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0"));
                        }
                        else
                        {
                            var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                            DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                            ddl_circle_list.Items.Clear();
                            ddl_circle_list.DataSource = dt;
                            ddl_circle_list.DataValueField = "circleId";
                            ddl_circle_list.DataTextField = "circleName";
                            ddl_circle_list.DataBind();
                            ddl_circle_list.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle exception or log it as needed
                Console.WriteLine("Error: " + ex.Message);
            }
        }


        public string add_division(string zone_id, string circle_id, string division_name, string created_by)
        {
            try
            {
                HttpClient client = new HttpClient();

                var data = new
                {
                    ZoneId = zone_id,
                    CircleId = circle_id,
                    DivisionName = division_name,
                    CreatedBy = "Admin",
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblDivisionMasters/PostTblDivisionMaster";
                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                    //ClearControls();
                    //grid_sub_module(ddl_module_list.SelectedValue);
                }
                string result = response.Content.ReadAsStringAsync().Result;
                return result;
            }
            catch (Exception ex)
            {
                return "Not Found";
                //throw ex;
            }
        }
        protected void btn_add_division_Click(object sender, EventArgs e)
        {
            try
            {
                string result = add_division(ddl_zone_list.SelectedValue, ddl_circle_list.SelectedValue, txt_division_name.Text, Session["UserId"]?.ToString());
                txt_division_name.Text = "";

                var resultObj = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(result);
                string message = resultObj.message;

                if (!string.IsNullOrEmpty(message))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{message}');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Failed to add Division. Please try again.');", true);
                }
                ClearControls();
                grid_name_division(Convert.ToInt32(ddl_zone_list.SelectedValue), Convert.ToInt32(ddl_circle_list.SelectedValue));

            }
            catch (Exception ex)
            {
                //throw ex;
            }
        }

        protected void btn_reset_Click(object sender, EventArgs e)
        {
            try
            {
                ClearControls();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void ddl_zone_list_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bind_circle_name(Convert.ToInt32(ddl_zone_list.SelectedValue));
                grid_name_division(Convert.ToInt32(ddl_zone_list.SelectedValue), Convert.ToInt32(ddl_circle_list.SelectedValue));
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddl_circle_list_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                grid_name_division(Convert.ToInt32(ddl_zone_list.SelectedValue), Convert.ToInt32(ddl_circle_list.SelectedValue));
            }
            catch (Exception ex)
            {

            }
        }

        void grid_name_division(Int32 zoneId, Int32 circleId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + ("TblDivisionMasters/GetTblDivisionMasterBycircleId?zone_id=" + zoneId + "&circle_id?=" + circleId)).Result;
                    if (Res.IsSuccessStatusCode)
                    {
                        var ResponseMessage = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(ResponseMessage, typeof(DataTable));
                        grid_division_names.DataSource = dt;
                        grid_division_names.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void grid_division_names_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grid_division_names.PageIndex = e.NewPageIndex;
            this.grid_name_division(Convert.ToInt32(ddl_zone_list.SelectedValue), Convert.ToInt32(ddl_circle_list.SelectedValue));
        }
    }
}