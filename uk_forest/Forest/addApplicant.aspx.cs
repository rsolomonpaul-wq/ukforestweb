using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class addApplicant : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //if (Session["token"] == null)
                //{
                //    //Response.Redirect("~/Index.aspx");
                //}
                //else
                //{
                //    token_sess = Session["token"].ToString();
                //}
                if (!Page.IsPostBack)
                {

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

        public string add_applicant(string name, string mobile_number, string CreatedBy)
        {
                try
                {
                    var data = new
                    {
                        Name = name,
                        MobileNo = mobile_number,
                        Password = mobile_number,
                        CreatedBy = CreatedBy,
                    };

                    var json = JsonConvert.SerializeObject(data);
                    var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                    //client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    var url = apiUrl + "TblApplicantRegistrations/PostTblApplicantRegistration";

                    var response1 = client.PostAsync(url, data1);
                    response1.Wait();
                    HttpResponseMessage response = response1.Result;
                    if (response.IsSuccessStatusCode)
                    {


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
                string result = add_applicant(txt_name.Text, txt_mobile_number.Text, Session["RoleId"]?.ToString());
                var resultObj = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(result);
                string message = resultObj.message;

                if (!string.IsNullOrEmpty(message))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{message}');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Failed to add Applicant. Please try again.');", true);
                }
                ClearControls();

            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error during Applicant addition: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('An unexpected error occurred. Please try again.');", true);
            }
        }
    }
}