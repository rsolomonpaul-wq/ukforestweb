using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class AddApplicantDetails : System.Web.UI.Page
    {
        private readonly string baseUrl = ConfigurationManager.AppSettings["BaseUrl"];
        string apiUrl = ConfigurationManager.AppSettings["api_path"];
        string token_sess;
        HttpClient client = new HttpClient();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string applicantname = Session["UserId"].ToString();
                    lblapplicantid.Text = applicantname;
                    BankRecordsDetails();
                    ApplicantDetails();
                }
            }
            catch (Exception ex)
            {

            }
        }

        void ApplicantDetails()
        {
            try
            {
                string applicantname = Session["UserId"].ToString();
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    var response = client.GetAsync(apiUrl + "TblApplicantRegistrations/GetTblApplicantRegistration_byApplicantId?applicant_id=" + applicantname).GetAwaiter().GetResult();

                    if (response.StatusCode == HttpStatusCode.OK) // 200 - Record exists
                    {
                        var jsonResponse = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                        dynamic applicantData = JsonConvert.DeserializeObject(jsonResponse);

                        lblapplicantname.Text = applicantData["name"]?.ToString() ?? "NA";
                        lblapplicantmobileno.Text = applicantData["mobileNo"]?.ToString() ?? "NA";

                        string gender = applicantData["gender"]?.ToString();
                        string address = applicantData["address"]?.ToString();
                        string aadharNo = applicantData["aadharNo"]?.ToString();

                        bool hasGender = !string.IsNullOrEmpty(gender);
                        bool hasAddress = !string.IsNullOrEmpty(address);
                        bool hasAadharNo = !string.IsNullOrEmpty(aadharNo);

                        GenderRadioButtonList.SelectedValue = hasGender ? gender : "Male";
                        GenderRadioButtonList.Enabled = !hasGender;

                        txtAddress.Text = hasAddress ? address : "";
                        txtAddress.Enabled = !hasAddress;

                        txtaadharno.Text = hasAadharNo ? aadharNo : "";
                        txtaadharno.Enabled = !hasAadharNo;

                        // Enable submit button only if any field is missing
                        btn_submit_basic_details.Enabled = !hasGender || !hasAddress || !hasAadharNo;

                        // Handle Aadhar document - Updated to match BankRecordsDetails pattern
                        string aadharDocPath = applicantData["aadharDoc"]?.ToString();
                        if (!string.IsNullOrEmpty(aadharDocPath))
                        {
                            fileaadhardocss.Visible = false;
                            lnk_aadhar.Visible = true;
                            // Build full URL → BaseUrl + aadharDocPath
                            lnk_aadhar.NavigateUrl = baseUrl.TrimEnd('/') + "/" + aadharDocPath.TrimStart('/');
                            // Optional: nicer link text (file name only)
                            lnk_aadhar.Text = System.IO.Path.GetFileName(aadharDocPath);
                        }
                        else
                        {
                            fileaadhardocss.Visible = true;
                            lnk_aadhar.Visible = false;
                        }
                    }
                    else if (response.StatusCode == HttpStatusCode.Created) // 201 - No record exists
                    {
                        // Clear fields
                        GenderRadioButtonList.SelectedValue = "Male";
                        txtAddress.Text = "";
                        txtaadharno.Text = "";

                        // Enable all controls for new record
                        GenderRadioButtonList.Enabled = true;
                        txtAddress.Enabled = true;
                        txtaadharno.Enabled = true;
                        btn_submit_basic_details.Enabled = true;

                        // Show FileUpload and hide View link
                        fileaadhardocss.Visible = true;
                        lnk_aadhar.Visible = false;
                    }
                    else
                    {
                        // Handle other status codes
                        fileaadhardocss.Visible = true;
                        lnk_aadhar.Visible = false;

                        // Enable all controls by default for other cases
                        GenderRadioButtonList.Enabled = true;
                        txtAddress.Enabled = true;
                        txtaadharno.Enabled = true;
                        btn_submit_basic_details.Enabled = true;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                fileaadhardocss.Visible = true;
                lnk_aadhar.Visible = false;

                // Enable all controls in case of error
                GenderRadioButtonList.Enabled = true;
                txtAddress.Enabled = true;
                txtaadharno.Enabled = true;
                btn_submit_basic_details.Enabled = true;
            }
        }

        void BankRecordsDetails()
        {
            try
            {
                string applicantname = Session["UserId"].ToString();
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    var response = client.GetAsync(apiUrl + "TblApplicantBankDetails/GetTblApplicantBankDetail_byApplicantId?applicant_id=" + applicantname).GetAwaiter().GetResult();

                    if (response.StatusCode == HttpStatusCode.OK) // 200 - Record exists
                    {
                        var jsonResponse = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                        dynamic bankDetails = JsonConvert.DeserializeObject(jsonResponse);

                        txtbankname.Text = bankDetails.bankName;
                        txtifsc.Text = bankDetails.ifscCode;
                        txtaccountno.Text = bankDetails.accountNo;
                        txtaccountholdername.Text = bankDetails.accountHolderName;

                        // Disable controls
                        txtbankname.Enabled = false;
                        txtifsc.Enabled = false;
                        txtaccountno.Enabled = false;
                        txtaccountholdername.Enabled = false;
                        btn_submit_bank_details.Enabled = false;

                        // Hide FileUpload and show View Image link
                        txtfileupload.Visible = false;
                        lnk_show.Visible = true;

                        lblconfirm_accountno.Visible = false;
                        txtconfirm_accountno.Visible = false;

                        // Build full URL → BaseUrl + bankDocPath
                        string imagePath = (string)bankDetails.bankDocPath;
                        lnk_show.NavigateUrl = baseUrl.TrimEnd('/') + "/" + imagePath.TrimStart('/');

                        // Optional: nicer link text (file name only)
                        lnk_show.Text = System.IO.Path.GetFileName(imagePath);
                    }
                    else if (response.StatusCode == HttpStatusCode.Created) // 201 - No record exists
                    {
                        // Clear fields
                        txtbankname.Text = "";
                        txtifsc.Text = "";
                        txtaccountno.Text = "";
                        txtconfirm_accountno.Text = "";
                        txtaccountholdername.Text = "";

                        // Enable controls
                        txtbankname.Enabled = true;
                        txtifsc.Enabled = true;
                        txtaccountno.Enabled = true;
                        txtconfirm_accountno.Enabled = true;
                        txtaccountholdername.Enabled = true;
                        btn_submit_bank_details.Enabled = true;

                        // Show FileUpload and hide View Image link
                        txtfileupload.Visible = true;
                        lnk_show.Visible = false;
                    }
                    else
                    {
                        // Handle other status codes
                        txtfileupload.Visible = true;
                        lnk_show.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                txtfileupload.Visible = true;
                lnk_show.Visible = false;
            }
        }



        protected void btn_submit_bank_details_Click(object sender, EventArgs e)
        {
            try
            {
                if (txtaccountno.Text != txtconfirm_accountno.Text)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Account No. mismatched!.');", true);
                    return;
                }

                string BankName = txtbankname.Text;
                string IfscCode = txtifsc.Text;
                string AccountHolderName = txtaccountholdername.Text;
                string AccountNo = txtaccountno.Text;
                string applicantname = Session["UserId"].ToString();
                string fileName_bankdoc = txtfileupload.FileName;
                Stream fileStream_bankdoc = txtfileupload.PostedFile.InputStream;

                string result = AddApplicantBankDetails(BankName, IfscCode, AccountHolderName, AccountNo, applicantname, fileName_bankdoc, fileStream_bankdoc);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Bank details saved successfully!.');", true);
                BankRecordsDetails();
            }
            catch (Exception ex)
            {

            }
        }

        public string AddApplicantBankDetails(string BankName, string IfscCode, string AccountHolderName, string AccountNo, string ApplicantId, string fileName_bankdoc, Stream fileStream_bankdoc)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    using (var form = new MultipartFormDataContent())
                    {
                        form.Add(new StringContent(BankName), "BankName");
                        form.Add(new StringContent(IfscCode), "IfscCode");
                        form.Add(new StringContent(AccountHolderName), "AccountHolderName");
                        form.Add(new StringContent(AccountNo), "AccountNo");
                        form.Add(new StringContent(ApplicantId), "ApplicantId");

                        if (fileStream_bankdoc != null)
                        {
                            var fileContent = new StreamContent(fileStream_bankdoc);

                            fileContent.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("form-data")
                            {
                                Name = "BankDoc",
                                FileName = fileName_bankdoc
                            };

                            fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
                            form.Add(fileContent);
                        }

                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                        var url = $"{apiUrl}TblApplicantBankDetails/PostTblApplicantBankDetail";

                        var response = client.PostAsync(url, form).Result;

                        if (response.IsSuccessStatusCode)
                        {
                            return response.Content.ReadAsStringAsync().Result;
                        }
                        else
                        {
                            return $"Error: {response.ReasonPhrase}";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return $"Error: {ex.Message}";
            }
        }

        protected void btn_submit_basic_details_Click(object sender, EventArgs e)
        {
            try
            {
                string Gender = GenderRadioButtonList.SelectedValue;
                string Address = txtAddress.Text;
                string AadharNo = txtaadharno.Text;
                string ApplicantId = Session["UserId"].ToString();
                string fileName_applicantaadhardoc = fileaadhardocss.FileName;
                Stream fileStream_applicantaadhardoc = fileaadhardocss.PostedFile.InputStream;

                string result = UpdateApplicantprofileDetails(ApplicantId, Gender, Address, AadharNo, fileName_applicantaadhardoc, fileStream_applicantaadhardoc);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Applicant details saved successfully!.');", true);
                ApplicantDetails();
            }
            catch (Exception ex)
            {

            }
        }


        public string UpdateApplicantprofileDetails(string ApplicantId, string Gender, string Address, string AadharNo, string fileName_applicantaadhardoc, Stream fileStream_applicantaadhardoc)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    using (var form = new MultipartFormDataContent())
                    {
                        form.Add(new StringContent(ApplicantId), "ApplicantId");
                        form.Add(new StringContent(Gender), "Gender");
                        form.Add(new StringContent(Address), "Address");
                        form.Add(new StringContent(AadharNo), "AadharNo");

                        if (fileStream_applicantaadhardoc != null)
                        {
                            var fileContent = new StreamContent(fileStream_applicantaadhardoc);

                            fileContent.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("form-data")
                            {
                                Name = "aadharDoc",
                                FileName = fileName_applicantaadhardoc
                            };

                            fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
                            form.Add(fileContent);
                        }

                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                        var url = $"{apiUrl}TblApplicantRegistrations/PutTblApplicantRegistration";
                        var response = client.PostAsync(url, form).Result;

                        if (response.IsSuccessStatusCode)
                        {
                            return response.Content.ReadAsStringAsync().Result;
                        }
                        else
                        {
                            return $"Error: {response.ReasonPhrase}";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return $"Error: {ex.Message}";
            }
        }

        //protected void btn_show_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        string BaseUrl = ConfigurationManager.AppSettings["BaseUrl"];
        //        string imagePath = btn_show.PostBackUrl;

        //        if (!string.IsNullOrEmpty(imagePath))
        //        {
        //            string fullUrl = BaseUrl.TrimEnd('/') + "/" + imagePath.TrimStart('/');

        //            Page.ClientScript.RegisterStartupScript(this.GetType(), "OpenWindow", $"window.open('{fullUrl}','_blank');", true);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        // Optionally log error
        //    }
        //}



    }
}