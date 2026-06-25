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
using System.Net;
using System.Web.Script.Serialization;

namespace uk_forest.Forest
{
    public partial class changePassword : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string UserId = Session["UserId"]?.ToString();
                token_sess = Session["token"]?.ToString();
                Int32 role = Convert.ToInt32(Session["RoleId"]);

                //if ((Session["token"] == null))
                if ((Session["UserId"] == null))
                {
                    Response.Redirect("~/index.aspx");
                }
                //if (!IsPostBack)
                //{
                //    txt_Existing_Pass.Attributes["value"] = txt_Existing_Pass.Text;
                //    var abc = txt_Existing_Pass.Attributes["value"];
                //}
            }
            catch (Exception ex)
            {

            }
        }

        protected void btn_submit_Click(object sender, EventArgs e)
        {
            try
            {
                DateTime UpdatedDate = System.DateTime.Now;
                string existingPassword = txt_Existing_Pass.Text;
                string newPassword = txt_new_pass.Text;
                string confirmPassword = txt_cPass.Text;
                string Updated_By = "";
                string user_id = "";

                Int32 role = Convert.ToInt32(Session["RoleId"]);

                //if (role == 1)
                //{
                //    Updated_By = Session["UserId"].ToString();
                //}
                //else
                //if (role >= 1 && role <= 8)
                if (role >= 1 && role <= 10)
                {
                    Updated_By = Session["UserId"].ToString();
                    user_id = Session["UserId"].ToString();

                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                        //HttpResponseMessage Res = client.GetAsync(apiUrl + $"TblUserRegistrations/GetTblUserRegistration?id={user_id}").Result;

                        string url = (role != 1 )
    ? $"{apiUrl}TblUserRegistrations/GetTblUserRegistration?id={user_id}"
    : $"{apiUrl}TblUserMasters/GetTblUserMaster?id={user_id}";

                        HttpResponseMessage Res = client.GetAsync(url).Result;

                        if (Res.IsSuccessStatusCode)
                        {
                            var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                            dynamic userData = JsonConvert.DeserializeObject(EmpResponse);

                            if (userData != null && userData.userId != null)
                            {
                                string pwd = userData.password;

                                if (pwd != existingPassword)
                                {
                                    lblMsg.Text = "Please enter correct existing password.";
                                    lblMsg.ForeColor = System.Drawing.Color.Red;
                                    return;
                                }

                                if (newPassword == pwd)
                                {
                                    lblMsg.Text = "New password cannot be the same as the existing password.";
                                    lblMsg.ForeColor = System.Drawing.Color.Red;
                                    return;
                                }

                                if (newPassword != confirmPassword)
                                {
                                    lblMsg.Text = "Both New Password and Confirm Password fields should be the same.";
                                    lblMsg.ForeColor = System.Drawing.Color.Red;
                                    return;
                                }

                                // --- Apply Strong Password Validations ---
                                if (!IsStrongPassword(newPassword))
                                {
                                    lblMsg.Text = "Password doesn't meet the requirements listed on the right.";
                                    lblMsg.ForeColor = System.Drawing.Color.Red;
                                    return;
                                }

                                // If all validations pass
                                user_change_password();
                                //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Password changed successfully.');", true);
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "alertRedirect", "alert('Password changed successfully. Please log in again.'); window.location='/web/modules.aspx';", true);
                            }
                            else
                            {
                                lblMsg.Text = "No user records found.";
                                lblMsg.ForeColor = System.Drawing.Color.Red;
                            }
                        }
                        else
                        {
                            lblMsg.Text = "Failed to retrieve user data from the API.";
                            lblMsg.ForeColor = System.Drawing.Color.Red;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private bool IsStrongPassword(string password)
        {
            if (password.Length < 8)
                return false;

            if (!password.Any(char.IsUpper))
                return false;

            if (!password.Any(char.IsLower))
                return false;

            if (!password.Any(char.IsDigit))
                return false;

            if (!password.Any(ch => !char.IsLetterOrDigit(ch)))
                return false;

            return true;
        }

        public string user_change_password()
        {
            try
            {
                var data = new
                {
                    
                Password = txt_new_pass.Text,
                    UserId = Session["UserId"].ToString(),
                   
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                int roleId = Convert.ToInt32(Session["RoleId"]);
                //client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = (roleId != 1 )
    ? $"{apiUrl}TblUserRegistrations/PutTbUserRegistration"
    : $"{apiUrl}TblUserMasters/PutTbUserMasters";


                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                    //ClearControls();
                    string result = response.Content.ReadAsStringAsync().Result;
                    return result;
                }

                string error = response.Content.ReadAsStringAsync().Result;
                Console.WriteLine("Error Response: " + error);
                return "Error: " + error;
            }
            catch (Exception ex)
            {
                return "NOT FOUND!";
            }
        }

        //protected void txt_Existing_Pass_TextChanged(object sender, EventArgs e)
        //{
        //    string enteredPassword = txt_Existing_Pass.Text;

        //    // Simulated stored password (in real life, fetch from DB)
        //    string storedPassword = "1";

        //    if (enteredPassword == storedPassword)
        //    {

        //        lbl_Message.ForeColor = System.Drawing.Color.Green;
        //        lbl_Message.Text = "Password matched!";
        //    }
        //    else
        //    {
        //        lbl_Message.ForeColor = System.Drawing.Color.Red;
        //        lbl_Message.Text = "Incorrect existing password.";
        //    }
        //}

        //public class ReCaptchaResult
        //{
        //    public bool Success { get; set; }
        //    public List<string> ErrorCodes { get; set; }
        //}

        //// Function to validate the reCAPTCHA response
        //private bool ValidateCaptcha(string token)
        //{
        //    string secretKey = "6Ld5OSkrAAAAALJyNKlb5zNgRtQXLk_rXWlzZ-TH"; // Replace with your actual secret key from Google

        //    // Build the verification URL
        //    var url = $"https://www.google.com/recaptcha/api/siteverify?secret={secretKey}&response={token}";

        //    // Send request to Google's reCAPTCHA API
        //    using (var client = new WebClient())
        //    {
        //        string jsonResult = client.DownloadString(url);
        //        var serializer = new JavaScriptSerializer();
        //        var result = serializer.Deserialize<ReCaptchaResult>(jsonResult);
        //        return result.Success; // Returns true if the CAPTCHA was validated successfully
        //    }
        //}

        // Button click handler
        //protected void btnSubmit_Click(object sender, EventArgs e)
        //{
        //    string captchaResponse = Request.Form["g-recaptcha-response"]; // Capture the CAPTCHA response token

        //    // Validate CAPTCHA
        //    if (ValidateCaptcha(captchaResponse))
        //    {
        //        // CAPTCHA passed — proceed with form submission
        //        // You can add any logic here if needed, like redirecting the user or showing a success message
        //        Response.Write("CAPTCHA passed! Form submission successful.");
        //    }
        //    else
        //    {
        //        // CAPTCHA failed — inform the user
        //        Response.Write("CAPTCHA failed. Please try again.");
        //    }
        //}
    }
}