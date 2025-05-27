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
    public partial class addZone : System.Web.UI.Page
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
                    grid_name_zone();
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

        public string add_zone(string zoneName, string created_by)
        {
            try
            {
                var data = new
                {
                    ZoneName = zoneName,
                    CreatedBy = "Zone",
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblZoneMasters/PostTblZoneMaster";

                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                    //ClearControls();
                    //grid_name_modules();
                }
                string result = response.Content.ReadAsStringAsync().Result;
                return result;
            }
            catch (Exception ex)
            {
                return "Not Found";
            }
        }
        protected void btn_add_zone_Click(object sender, EventArgs e)
        {
            try
            {
                string result = add_zone(txt_zone_name.Text, Session["UserId"]?.ToString());

                var resultObj = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(result);
                string message = resultObj.message;

                if (!string.IsNullOrEmpty(message))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{message}');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Failed to add Zone. Please try again.');", true);
                }
                ClearControls();
                grid_name_zone();
            }
            catch (Exception ex)
            {
                throw ex;
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

        void grid_name_zone()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + ("TblZoneMasters/GetTblZoneMasters")).Result;
                    if (Res.IsSuccessStatusCode)
                    {
                        var ResponseMessage = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(ResponseMessage, typeof(DataTable));
                        grid_zone_names.DataSource = dt;
                        grid_zone_names.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void grid_zone_names_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                grid_zone_names.PageIndex = e.NewPageIndex;
                this.grid_name_zone();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
    }
}