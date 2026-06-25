using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.Json;

namespace uk_forest.Forest
{
    public partial class applicantlogin : System.Web.UI.Page
    {
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        private const int OTP_EXPIRY_MINUTES = 5;
        private const string OTP_SESSION_KEY = "UserOTP";
        private const string MOBILE_SESSION_KEY = "UserMobile";
        private const string OTP_TIMESTAMP_KEY = "OTPTimeStamp";
        HttpClient client = new HttpClient();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnVerifyOTP_Click(object sender, EventArgs e)
        {
            try
            {
                string mobileNumber = txtLoginMobile.Text.Trim();


                if (string.IsNullOrEmpty(mobileNumber) || mobileNumber.Length != 10)
                {
                    return;
                }

                string otp = txtOtpCode.Text;
                var t = user_login_2(11, mobileNumber, otp);


            }
            catch (Exception ex)
            {
                // ShowLoginError($"An error occurred: {ex.Message}");

            }
        }

        public async Task<JObject> user_login_2(Int32 RoleId, string mobileno, string otp)
        {
            try
            {
                object data;
                if (RoleId == 1 || RoleId == 2)
                {
                    data = new
                    {
                        RoleId = RoleId,
                        mobileNo = mobileno,
                        otp = otp,
                    };
                }
                else if (RoleId == 11)
                {
                    data = new
                    {
                        RoleId = RoleId,
                        mobileNo = mobileno,
                        otp = otp,
                    };
                }
                else
                {
                    data = new
                    {
                        RoleId = RoleId,
                        mobileNo = mobileno,
                        otp = otp,
                    };
                }

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                string url = (RoleId == 1 || RoleId == 2) ? apiUrl + "TblApplicantMasters/login" :
                   (RoleId == 11 ? apiUrl + "TblApplicantMasters/login" :
                   apiUrl + "TblApplicantMasters/login");

                HttpClient client = new HttpClient();
                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                    var resultContent = await response.Content.ReadAsStringAsync();
                    var userData = JsonConvert.DeserializeObject<JObject>(resultContent);

                    if (Convert.ToBoolean(userData["isactive"]) == true)
                    {
                        if (RoleId == 11)
                        {
                            Session["UserId"] = userData["applicantId"]?.ToString();
                        }
                        else
                        {
                            Session["UserId"] = userData["userId"]?.ToString();
                        }
                        Session["RoleId"] = userData["roleId"];
                        Session["token"] = userData["token"]?.ToString();
                        Session["EmailId"] = userData["emailId"]?.ToString();
                        Session["Name"] = userData["name"]?.ToString();
                        Session["gender"] = userData["gender"]?.ToString();
                        Session["mobileNo"] = userData["mobileNo"]?.ToString();

                        HttpContext.Current.Response.Redirect("~/Forest/ApplicantDashboard.aspx", false);
                    }
                    else
                    {
                        string script = @"
                    Swal.fire({
                        title: '',
                        text: 'This User is not Active',
                        icon: 'warning',
                        showConfirmButton: true,
                        confirmButtonText: 'OK',
                        background: '#f0f9ff',
                        color: '#1a202c',
                        iconColor: '#f6ad55',
                        showClass: { popup: 'animate__animated animate__fadeInDown' },
                        hideClass: { popup: 'animate__animated animate__fadeOutUp' }
                    });";
                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alertMessage", script, true);
                    }
                }
                else
                {
                    string script = @"
                Swal.fire({
                    title: '',
                    text: 'Login Failed. Please try again.',
                    icon: 'error',
                    showConfirmButton: true,
                    confirmButtonText: 'OK',
                    background: '#f0f9ff',
                    color: '#1a202c',
                    iconColor: '#e53e3e',
                    showClass: { popup: 'animate__animated animate__fadeInDown' },
                    hideClass: { popup: 'animate__animated animate__fadeOutUp' }
                });";
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alertMessage", script, true);

                    Session["token"] = null;
                    Session["UserId"] = null;
                }

                return new JObject { { "StatusCode", (int)response.StatusCode } };
            }
            catch (Exception)
            {
                string script = @"
            Swal.fire({
                title: 'Error',
                text: 'Something went wrong. Please try again later.',
                icon: 'error',
                showConfirmButton: true,
                confirmButtonText: 'OK',
                background: '#f0f9ff',
                color: '#1a202c',
                iconColor: '#e53e3e'
            });";
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alertMessage", script, true);

                throw; // stack trace preserve
            }
        }


        protected void btnCreateAccount_Click(object sender, EventArgs e)
        {
            try
            {
                string fullName = txtFullName.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string email = txtEmail.Text.Trim();
                string altPhone = txtAltPhone.Text.Trim();
                string gender = string.Empty;
                if (rdbMale.Checked)
                {
                    gender = "Male";
                }
                else if (rdbFemale.Checked)
                {
                    gender = "Female";
                }
                else if (rdbOther.Checked)
                {
                    gender = "Other";
                }

                string baseApiUrl = ConfigurationSettings.AppSettings["api_path"];
                string apiUrl = baseApiUrl + $"TblApplicantMasters/Check_Applicant_By_MobileNo?mobile_no={mobile}";


                // ✅ API Call to check if mobile exists
              
                using (HttpClient client = new HttpClient())
                {
                    HttpResponseMessage response = client.GetAsync(apiUrl).Result; // ❌ sync call

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;

                        var result = System.Text.Json.JsonSerializer.Deserialize<JsonElement>(json);
                        bool exists = result.GetProperty("exists").GetBoolean();

                        if (exists)
                        {
                            string message = $"Mobile number {mobile} is already used!";
                            string script = $@"
                Swal.fire({{
                    title: 'Duplicate',
                    text: '{message}',
                    icon: 'warning',
                    showConfirmButton: true,
                    confirmButtonText: 'OK',
                    background: '#f0f9ff',
                    color: '#1a202c',
                    iconColor: '#f6ad55',
                    showClass: {{ popup: 'animate__animated animate__fadeInDown' }},
                    hideClass: {{ popup: 'animate__animated animate__fadeOutUp' }}
                }});";

                            Page.ClientScript.RegisterStartupScript(
                                this.GetType(),
                                "alertMessage",
                                script,
                                true);
                            return; // stop execution
                        }
                    }
                }

                bool success = CreateUser(fullName, mobile, email, altPhone, gender);

                if (success)
                {
                    //string message = $"Account created successfully with mobile number: {mobile} ";
                    string message = $"Your account has been created successfully. ";
                    string script = $@"
                            Swal.fire({{
                                title: 'Success',
                                text: '{message}',
                                icon: 'success',
                                showConfirmButton: true,
                                confirmButtonText: 'OK',
                                background: '#f0f9ff',
                                color: '#1a202c',
                                iconColor: '#38a169',
                                showClass: {{ popup: 'animate__animated animate__fadeInDown' }},
                                hideClass: {{ popup: 'animate__animated animate__fadeOutUp' }}
                            }});";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "successMessage", script, true);
                }
                else
                {
                    string message = "Account creation failed. Please try again.";
                    string script = $@"
                            Swal.fire({{
                                title: 'Error',
                                text: '{message}',
                                icon: 'error',
                                showConfirmButton: true,
                                confirmButtonText: 'OK',
                                background: '#f0f9ff',
                                color: '#1a202c',
                                iconColor: '#e53e3e',
                                showClass: {{ popup: 'animate__animated animate__fadeInDown' }},
                                hideClass: {{ popup: 'animate__animated animate__fadeOutUp' }}
                            }});";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "errorMessage", script, true);
                }

            }
            catch (Exception ex)
            {
                //   ShowRegisterError($"Registration failed: {ex.Message}");
                //    LogError("btnCreateAccount_Click", ex);
            }
        }
        private bool InsertUserToDatabase(string fullName, string mobile, string email, string altPhone, string gender)
        {
            try
            {

                var data = new
                {
                    name = fullName,
                    mobileNo = mobile,
                    emailId = email,
                    password = mobile,
                    gender = gender,
                    alternateMobileNo= altPhone,
                    createdBy = Session["RoleId"]?.ToString(),
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                var url = apiUrl + "TblApplicantMasters/Register";

                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {


                }
                string result = response.Content.ReadAsStringAsync().Result;

            }
            catch (Exception ex)
            {
                return false;
            }
            return true; // Placeholder
        }
        private bool CreateUser(string fullName, string mobile, string email, string altPhone, string gender)
        {
            return InsertUserToDatabase(fullName, mobile, email, altPhone, gender);
        }

    }
}
