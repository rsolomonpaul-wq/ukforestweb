using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest
{
    public partial class profile : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string userId = Session["UserId"].ToString();
                if (!IsPostBack)
                {
                    user_details(userId);
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void user_details(string id)
        {
            try
            {
                Int32 role = Convert.ToInt32(Session["RoleId"]);
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    //string url = apiUrl + string.Format("TblUserRegistrations/GetTblUserRegistration?id=" + id);

                    //string url = (role != 1)
                    //? $"{apiUrl}TblUserRegistrations/GetTblUserRegistration?id={id}"
                    //: $"{apiUrl}TblUserMasters/GetTblUserMaster?id={id}";

                    string url = "";

                    if (role == 11)
                    {
                        url = $"{apiUrl}TblApplicantMasters/GetApplicant/{id}";
                    }
                    else if (role == 1)
                    {
                        url = $"{apiUrl}TblUserMasters/GetTblUserMaster?id={id}";
                    }
                    else
                    {
                        url = $"{apiUrl}TblUserRegistrations/GetTblUserRegistration?id={id}";
                    }


                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        var data = JsonConvert.DeserializeObject<Dictionary<string, object>>(EmpResponse);

                        if (data != null && data.Count > 0)
                        {
                            if (role == 11)
                            {
                                txtId.Text = data.ContainsKey("applicantId") ? data["applicantId"]?.ToString() : "";
                            }
                            else
                            {
                                txtId.Text = data.ContainsKey("userId") ? data["userId"]?.ToString() : "";
                            }
                               
                            txtName.Text = data.ContainsKey("name") ? data["name"]?.ToString() : "";
                            txt_email_id.Text = data.ContainsKey("emailId") ? data["emailId"]?.ToString() : "";
                            txt_phone_no.Text = data.ContainsKey("mobileNo") ? data["mobileNo"]?.ToString() : "";
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, GetType(), "alert", "alert('No user data found.');", true);
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "alert", $"alert('Error: {Res.ReasonPhrase}');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error in user_details: {ex.Message}");
                ScriptManager.RegisterClientScriptBlock(this, GetType(), "alert", $"alert('An error occurred: {ex.Message}');", true);
            }
        }

        protected void btnback_Click(object sender, EventArgs e)
        {
            try
            {
                if(Convert.ToInt32(Session["RoleId"]) == 11)
                {
                    Response.Redirect("ApplicantDashboard.aspx");
                }
                else
                {
                    Response.Redirect("dashboard.aspx");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}