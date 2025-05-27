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
    public partial class addUser : System.Web.UI.Page
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
                    grid_name_user();
                    //grid_name_roles();
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

        public string add_User_name(string name, string gender, string mobile_number, string email_id, string address, string pincode, string panNumber, string aadharNumber, string username, string password, string CreatedBy)
        {
            try
            {
                var data = new
                {
                    Name = name,
                    // RoleId = role_id,
                    Gender = gender,
                    MobileNo = mobile_number,
                    EmailId = email_id,
                    Address = address,
                    Pincode = pincode,
                    PanNo = panNumber,
                    AadharNo = aadharNumber,
                    Username = username,
                    Password = password,
                    CreatedBy = "Admin",
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblUserMasters/PostTblUserMaster";

                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                    grid_name_user();
                    //ClearControls();

                }
                string result = response.Content.ReadAsStringAsync().Result;
                return result;
            }
            catch (Exception ex)
            {
                return "Not Found";
            }
        }
        protected void btn_add_user_Click(object sender, EventArgs e)
        {
            try
            {
                string result = add_User_name(txt_user_name.Text, ddl_gender.SelectedValue, txt_mobile_number.Text, txt_email_id.Text, txt_address.Text, txt_pincode.Text, txt_pan_number.Text, txt_aadhar_number.Text, txt_username.Text, txt_password.Text, Session["RoleId"]?.ToString());
                var resultObj = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(result);
                string message = resultObj.message;

                if (!string.IsNullOrEmpty(message))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{message}');", true);

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Failed to add User. Please try again.');", true);
                }
                ClearControls();
                // grid_name_roles();

            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error during User addition: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('An unexpected error occurred. Please try again.');", true);
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

        void grid_name_user()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblUserMasters/GetTblUserMasters")).Result;
                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));
                        grid_user_names.DataSource = dt;
                        grid_user_names.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }
        protected void grid_user_names_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                grid_user_names.PageIndex = e.NewPageIndex;
                this.grid_name_user();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}