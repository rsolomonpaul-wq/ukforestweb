using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
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
    public partial class addSubModule : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
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
                    bind_module_name();
                    grid_name_submodule();
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

        public string add_sub_module(string module_id, string sub_module_name, string created_by)
        {
            try
            {
                HttpClient client = new HttpClient();

                var data = new
                {
                    ModuleId = module_id,
                    SubModuleName = sub_module_name,
                    CreatedBy = "Admin",
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblSubModules/PostTblSubModule";
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

        void bind_module_name()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblModules/GetTblModules")).Result;
                    //Checking the response is successful or not which is sent using HttpClient
                    if (Res.IsSuccessStatusCode)
                    {
                        //Storing the response details recieved from web api
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        //Deserializing the response recieved from web api and storing into the Employee list

                        //List<string> value = JsonConvert.DeserializeObject<List<string>>(EmpResponse);
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddl_module_list.Items.Clear();
                        ddl_module_list.DataSource = dt;
                        ddl_module_list.DataValueField = "moduleId";
                        ddl_module_list.DataTextField = "moduleName";
                        ddl_module_list.DataBind();
                        ddl_module_list.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "All"));
                    }
                }
            }
            catch (Exception ex)
            {
                //throw ex;
            }
        }

        protected void btn_sub_module_Click(object sender, EventArgs e)
        {
            try
            {
                string result = add_sub_module(ddl_module_list.SelectedValue, txt_Sub_module.Text, Session["UserId"]?.ToString());
                txt_Sub_module.Text = "";
                //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "btn", "<script type = 'text/javascript'>alert('Module ajouté avec succès');</script>");

                var resultObj = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(result);
                string message = resultObj.message;

                if (!string.IsNullOrEmpty(message))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{message}');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Failed to add Sub-Module. Please try again.');", true);
                }
                ClearControls();
                grid_name_submodule();
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

        protected void ddl_module_list_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                grid_name_submodule();
            }
            catch (Exception ex)
            {

            }
        }

        void grid_name_submodule()
        {
            try
            {
                using (var clinet = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = clinet.GetAsync(apiUrl + ("TblSubModules/GetTblSubModules")).Result;
                    if (Res.IsSuccessStatusCode)
                    {
                        var ResonseMessage = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(ResonseMessage, typeof(DataTable));
                        grid_submodule_names.DataSource = dt;
                        grid_submodule_names.DataBind();

                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        protected void grid_submodule_names_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                grid_submodule_names.PageIndex = e.NewPageIndex;
                this.grid_name_submodule();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}