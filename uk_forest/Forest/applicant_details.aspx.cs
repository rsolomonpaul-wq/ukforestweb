using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Net.Http.Headers;
using System.Web.Script.Serialization;
using System.Data;

namespace uk_forest.Forest
{
    public partial class applicant_details : System.Web.UI.Page
    {
        HttpClient client = new HttpClient();
        string _apiUrl = ConfigurationSettings.AppSettings["api_path"];
        
        protected void Page_Load(object sender, EventArgs e)
        {

            try
            {
                if (!IsPostBack)
                {
                    txtFullName.Text = Session["Name"].ToString();
                    txtMobileNumber.Text = Session["mobileNo"].ToString();
                    ddlGender.SelectedValue = Session["gender"].ToString();

                    string userId = Session["UserId"] != null ? Session["UserId"].ToString() : null;
                    InitializePage();
                    LoadDistrictsHttpClient();
                    BindApplicantData(userId);
                }
            }
            catch(Exception ex)
            {

            }
        }
        private void BindApplicantData(string applicantId)
        {
            string baseUrl = _apiUrl+"TblApplicantMasters/GetTblApplicant_byApplicantId";
            string apiUrl = $"{baseUrl}?applicant_id={applicantId}";
            //string imageBaseUrl = "http://203.122.5.18:9008/uk_forest_web/";  // base URL for aadhar doc

            string imageBaseUrl = "https://ukforestgis.in/";  // base URL for aadhar doc

            using (HttpClient client = new HttpClient())
            {
                try
                {
                    HttpResponseMessage response = client.GetAsync(apiUrl).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        string jsonResponse = response.Content.ReadAsStringAsync().Result;
                        JObject applicant = JObject.Parse(jsonResponse);

                        if (applicant != null)
                        {
                            DataTable dt = new DataTable();
                            dt.Columns.Add("ApplicantID");
                            dt.Columns.Add("FullName");
                            dt.Columns.Add("MobileNo");
                            dt.Columns.Add("AlternateMobile");
                            dt.Columns.Add("EmailID");
                            dt.Columns.Add("Gender");
                            dt.Columns.Add("AadharNo");
                            dt.Columns.Add("Address");
                            dt.Columns.Add("Pincode");
                            dt.Columns.Add("Aadhar"); // full URL

                            string aadharMasked = MaskAadhar(applicant["aadharNo"]?.ToString());
                            string aadharDocFile = applicant["aadharDoc"]?.ToString() ?? "";
                            string aadharDocUrl = "";

                            if (!string.IsNullOrEmpty(aadharDocFile))
                                aadharDocUrl = imageBaseUrl + Uri.EscapeUriString(aadharDocFile);

                            dt.Rows.Add(
                                applicant["applicantId"]?.ToString() ?? "N/A",
                                applicant["name"]?.ToString() ?? "N/A",
                                applicant["mobileNo"]?.ToString() ?? "N/A",
                                applicant["alternateMobileNo"]?.ToString() ?? "N/A",
                                applicant["emailId"]?.ToString() ?? "N/A",
                                applicant["gender"]?.ToString() ?? "N/A",
                                aadharMasked,
                                applicant["address"]?.ToString() ?? "N/A",
                                applicant["pincode"]?.ToString() ?? "N/A",
                                aadharDocUrl
                            );

                            gvApplicantInfo.DataSource = dt;
                            gvApplicantInfo.DataBind();
                        }
                    }
                    else
                    {
                        string script = $@"
                            Swal.fire({{
                                title: 'API Error',
                                text: 'Failed to fetch applicant data. Status: {response.StatusCode}',
                                icon: 'error',
                                confirmButtonText: 'OK'
                            }});";

                        ClientScript.RegisterStartupScript(this.GetType(), "apiError", script, true);
                    }
                }
                catch (Exception ex)
                {
                    string safeMessage = ex.Message.Replace("'", "\\'");
                    string script = $@"
                        Swal.fire({{
                            title: 'Exception',
                            text: '{safeMessage}',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        }});";

                    ClientScript.RegisterStartupScript(this.GetType(), "exceptionError", script, true);
                }
            }
        }


        private string MaskAadhar(string aadhar)
        {
            if (string.IsNullOrEmpty(aadhar) || aadhar.Length < 12) return aadhar ?? "N/A";
            return aadhar.Substring(0, 4) + "***" + aadhar.Substring(8); // e.g., 1111****1111
        }


        #region Page Initialization

        private void InitializePage()
        {
            try
            {
                Debug.WriteLine("=== PAGE INITIALIZATION START ===");
                Debug.WriteLine($"API Path from config: {_apiUrl}");
                string userId = Session["UserId"] != null ? Session["UserId"].ToString() : null;

                // Set applicant IDs
                lblApplicantID.Text = userId;

                Debug.WriteLine($"Generated Applicant ID: {lblApplicantID.Text}");

                // Initialize dropdown states
                ddlTehsil.Enabled = false;
                ddlVillage.Enabled = false;

                // Set default values for other controls if needed
                // txtFullName.Text = "";
                // etc...

                Debug.WriteLine("=== PAGE INITIALIZATION END ===");
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"InitializePage ERROR: {ex.Message}");
            }
        }

        private string GenerateApplicantID()
        {
            Random rand = new Random();
            string timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");
            int randomNum = rand.Next(1000, 9999);
            return "HWC" + timestamp + randomNum;
        }

        #endregion

        #region District Loading

        private void LoadDistrictsHttpClient()
        {
            try
            {
                Debug.WriteLine("=== LOAD DISTRICTS START ===");
                Debug.WriteLine($"API URL: {_apiUrl}");

                // Clear existing items completely
                ddlDistrict.Items.Clear();

                // Show temporary loading
                ddlDistrict.Items.Add(new ListItem("Loading Districts...", "0"));

                var districts = GetDistrictsHttpClientStyle();

                Debug.WriteLine($"Districts received from API: {districts?.Count ?? 0}");

                // Clear loading and add default option
                ddlDistrict.Items.Clear();
                ddlDistrict.Items.Add(new ListItem("Select District", "0"));

                if (districts != null && districts.Count > 0)
                {
                    int bindCount = 0;
                    foreach (var district in districts)
                    {
                        // Extract values with multiple fallback options
                        string districtName = GetPropertyValue(district,
                            "districtName", "DistrictName", "name", "District_Name");
                        string districtCode = GetPropertyValue(district,
                            "districtCode", "DistrictCode", "id", "code", "District_Code");

                        Debug.WriteLine($"Processing district: '{districtName}' (Code: '{districtCode}')");

                        // Only add valid items
                        if (!string.IsNullOrEmpty(districtName) &&
                            !string.IsNullOrEmpty(districtCode) &&
                            districtCode != "0")
                        {
                            var item = new ListItem(districtName.Trim(), districtCode.Trim());
                            ddlDistrict.Items.Add(item);
                            bindCount++;
                            Debug.WriteLine($"SUCCESS: Added '{districtName}' (Code: {districtCode}) - Total: {bindCount}");
                        }
                        else
                        {
                            Debug.WriteLine($"SKIPPED: Invalid district data - Name: '{districtName}', Code: '{districtCode}'");
                        }
                    }

                    Debug.WriteLine($"Total districts bound: {bindCount}/{districts.Count}");
                    Debug.WriteLine($"Final dropdown items: {ddlDistrict.Items.Count}");
                }
                else
                {
                    ddlDistrict.Items.Add(new ListItem("No Districts Available", "0"));
                    Debug.WriteLine("WARNING: No valid districts found in API response");
                }

                Debug.WriteLine("=== LOAD DISTRICTS END ===");
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"LoadDistrictsHttpClient EXCEPTION: {ex.Message}");
                Debug.WriteLine($"Stack Trace: {ex.StackTrace}");

                // Clear and show error
                ddlDistrict.Items.Clear();
                ddlDistrict.Items.Add(new ListItem("Error Loading Districts", "0"));
            }
        }

        private List<JObject> GetDistrictsHttpClientStyle()
        {
            try
            {
                // Use your exact API endpoint
                var url = _apiUrl + "TblDistrictMasters/GetTblDistrictMasters";
                Debug.WriteLine($"Calling District API: {url}");

                var response = client.GetAsync(url);
                response.Wait();
                HttpResponseMessage responseMsg = response.Result;

                Debug.WriteLine($"District API Status Code: {responseMsg.StatusCode}");
                Debug.WriteLine($"District API Content-Type: {responseMsg.Content.Headers.ContentType?.MediaType}");

                if (responseMsg.IsSuccessStatusCode)
                {
                    string rawResult = responseMsg.Content.ReadAsStringAsync().Result;
                    Debug.WriteLine($"Raw Response Length: {rawResult.Length}");
                    Debug.WriteLine($"Raw Response Preview: {rawResult.Substring(0, Math.Min(300, rawResult.Length))}");

                    // Clean the JSON response
                    string cleanJson = CleanJsonResponse(rawResult);
                    Debug.WriteLine($"Cleaned JSON Preview: {cleanJson.Substring(0, Math.Min(200, cleanJson.Length))}");

                    // Parse JSON array
                    JArray jsonArray = JArray.Parse(cleanJson);
                    var districts = new List<JObject>();

                    foreach (JObject item in jsonArray)
                    {
                        districts.Add(item);
                        string name = GetPropertyValue(item, "districtName", "DistrictName");
                        string code = GetPropertyValue(item, "districtCode", "DistrictCode");
                        Debug.WriteLine($"Parsed District: '{name}' (Code: '{code}')");
                    }

                    Debug.WriteLine($"Successfully parsed {districts.Count} district objects");
                    return districts;
                }
                else
                {
                    string errorContent = responseMsg.Content.ReadAsStringAsync().Result;
                    Debug.WriteLine($"District API ERROR {responseMsg.StatusCode}: {errorContent}");
                    return new List<JObject>();
                }
            }
            catch (JsonException jsonEx)
            {
                Debug.WriteLine($"JSON PARSE ERROR: {jsonEx.Message}");
                return new List<JObject>();
            }
            catch (HttpRequestException httpEx)
            {
                Debug.WriteLine($"HTTP REQUEST ERROR: {httpEx.Message}");
                return new List<JObject>();
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"GetDistrictsHttpClientStyle GENERAL ERROR: {ex.Message}");
                Debug.WriteLine($"Inner Exception: {ex.InnerException?.Message}");
                return new List<JObject>();
            }
        }

        #endregion

        #region Tehsil Loading

        protected void ddlDistrict_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                Debug.WriteLine("=== ddlDistrict_SelectedIndexChanged START ===");
                Debug.WriteLine($"District SelectedIndex: {ddlDistrict.SelectedIndex}");
                Debug.WriteLine($"District SelectedValue: '{ddlDistrict.SelectedValue}'");
                Debug.WriteLine($"District Selected Text: '{ddlDistrict.SelectedItem?.Text}'");

                // Check if valid selection
                if (ddlDistrict.SelectedIndex <= 0 ||
                    string.IsNullOrEmpty(ddlDistrict.SelectedValue) ||
                    ddlDistrict.SelectedValue == "0")
                {
                    Debug.WriteLine("No valid district selected - clearing dependent dropdowns");
                    ClearTehsilAndVillage();
                    return;
                }

                // Parse district code
                int districtCode;
                if (!int.TryParse(ddlDistrict.SelectedValue, out districtCode))
                {
                    Debug.WriteLine($"Cannot parse district code from '{ddlDistrict.SelectedValue}'");
                    ClearTehsilAndVillage();
                    return;
                }

                Debug.WriteLine($"Valid district selected: Code = {districtCode}, Name = '{ddlDistrict.SelectedItem?.Text}'");

                // Show loading in tehsil dropdown
                ddlTehsil.Items.Clear();
                ddlTehsil.Items.Add(new ListItem("Loading Tehsils...", "0"));
                ddlTehsil.Enabled = false;

                // Load tehsils
                var tehsils = GetTehsilsHttpClientStyle(districtCode);

                Debug.WriteLine($"Tehsils received from API: {tehsils?.Count ?? 0}");

                // Clear and repopulate tehsil dropdown
                ddlTehsil.Items.Clear();
                ddlTehsil.Items.Add(new ListItem("Select Tehsil", "0"));

                if (tehsils != null && tehsils.Count > 0)
                {
                    int bindCount = 0;
                    foreach (var tehsil in tehsils)
                    {
                        string tehsilName = GetPropertyValue(tehsil,
                            "tehsilName", "TehsilName", "name");
                        string tehsilCode = GetPropertyValue(tehsil,
                            "tehsilCode", "TehsilCode", "id", "code");

                        Debug.WriteLine($"Processing tehsil: '{tehsilName}' (Code: '{tehsilCode}')");

                        if (!string.IsNullOrEmpty(tehsilName) &&
                            !string.IsNullOrEmpty(tehsilCode) &&
                            tehsilCode != "0")
                        {
                            var item = new ListItem(tehsilName.Trim(), tehsilCode.Trim());
                            ddlTehsil.Items.Add(item);
                            bindCount++;
                            Debug.WriteLine($"SUCCESS: Added '{tehsilName}' (Code: {tehsilCode})");
                        }
                        else
                        {
                            Debug.WriteLine($"SKIPPED: Invalid tehsil data - Name: '{tehsilName}', Code: '{tehsilCode}'");
                        }
                    }

                    Debug.WriteLine($"Successfully bound {bindCount} tehsils");
                    ddlTehsil.Enabled = true;
                }
                else
                {
                    ddlTehsil.Items.Add(new ListItem("No Tehsils Found", "0"));
                    ddlTehsil.Enabled = false;
                    Debug.WriteLine("No valid tehsils for this district");
                }

                // Always clear village when district changes
                ClearVillage();
                Debug.WriteLine("=== ddlDistrict_SelectedIndexChanged END ===");
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"ddlDistrict_SelectedIndexChanged EXCEPTION: {ex.Message}");
                Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
                ClearTehsilAndVillage();
            }
        }

        private List<JObject> GetTehsilsHttpClientStyle(int districtCode)
        {
            try
            {
                // **FIXED: Correct endpoint**
                var url = _apiUrl + "TblTehsilMasters/GetTblTehsilMasterByDistrictCode";
                string fullUrl = $"{url}?district_code={districtCode}";

                Debug.WriteLine($"Calling Tehsil API: {fullUrl}");

                var response = client.GetAsync(fullUrl);
                response.Wait();
                HttpResponseMessage responseMsg = response.Result;

                Debug.WriteLine($"Tehsil API Status: {responseMsg.StatusCode}");

                if (responseMsg.IsSuccessStatusCode)
                {
                    string rawResult = responseMsg.Content.ReadAsStringAsync().Result;
                    Debug.WriteLine($"Tehsil Raw Response Length: {rawResult.Length}");
                    Debug.WriteLine($"Tehsil Response Preview: {rawResult.Substring(0, Math.Min(300, rawResult.Length))}");

                    // Clean JSON response
                    string cleanJson = CleanJsonResponse(rawResult);
                    Debug.WriteLine($"Tehsil Clean JSON Preview: {cleanJson.Substring(0, Math.Min(200, cleanJson.Length))}");

                    JArray jsonArray = JArray.Parse(cleanJson);
                    var tehsils = new List<JObject>();

                    foreach (JObject item in jsonArray)
                    {
                        tehsils.Add(item);
                        string name = GetPropertyValue(item, "tehsilName", "TehsilName");
                        string code = GetPropertyValue(item, "tehsilCode", "TehsilCode");
                        Debug.WriteLine($"Parsed Tehsil: '{name}' (Code: '{code}')");
                    }

                    Debug.WriteLine($"Successfully parsed {tehsils.Count} tehsils");
                    return tehsils;
                }
                else
                {
                    string errorContent = responseMsg.Content.ReadAsStringAsync().Result;
                    Debug.WriteLine($"Tehsil API ERROR {responseMsg.StatusCode}: {errorContent}");
                    return new List<JObject>();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"GetTehsilsHttpClientStyle EXCEPTION: {ex.Message}");
                return new List<JObject>();
            }
        }

        #endregion

        #region Village Loading

        protected void ddlTehsil_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                Debug.WriteLine("=== ddlTehsil_SelectedIndexChanged START ===");
                Debug.WriteLine($"Tehsil SelectedIndex: {ddlTehsil.SelectedIndex}");
                Debug.WriteLine($"Tehsil SelectedValue: '{ddlTehsil.SelectedValue}'");

                if (ddlTehsil.SelectedIndex <= 0 ||
                    string.IsNullOrEmpty(ddlTehsil.SelectedValue) ||
                    ddlTehsil.SelectedValue == "0")
                {
                    Debug.WriteLine("No valid tehsil selected - clearing village");
                    ClearVillage();
                    return;
                }

                int districtCode, tehsilCode;

                if (!int.TryParse(ddlDistrict.SelectedValue, out districtCode))
                {
                    Debug.WriteLine($"Invalid district code: '{ddlDistrict.SelectedValue}'");
                    ClearVillage();
                    return;
                }

                if (!int.TryParse(ddlTehsil.SelectedValue, out tehsilCode))
                {
                    Debug.WriteLine($"Invalid tehsil code: '{ddlTehsil.SelectedValue}'");
                    ClearVillage();
                    return;
                }

                Debug.WriteLine($"Loading villages - District: {districtCode}, Tehsil: {tehsilCode}");

                // Show loading
                ddlVillage.Items.Clear();
                ddlVillage.Items.Add(new ListItem("Loading Villages...", "0"));
                ddlVillage.Enabled = false;

                var villages = GetVillagesHttpClientStyle(districtCode, tehsilCode);

                Debug.WriteLine($"Villages received: {villages?.Count ?? 0}");

                ddlVillage.Items.Clear();
                ddlVillage.Items.Add(new ListItem("Select Village", "0"));

                if (villages != null && villages.Count > 0)
                {
                    int bindCount = 0;
                    foreach (var village in villages)
                    {
                        string villageName = GetPropertyValue(village,
                            "villageName", "VillageName", "name");
                        string villageCode = GetPropertyValue(village,
                            "villageCode", "VillageCode", "id", "code");

                        Debug.WriteLine($"Processing village: '{villageName}' (Code: '{villageCode}')");

                        if (!string.IsNullOrEmpty(villageName) &&
                            !string.IsNullOrEmpty(villageCode) &&
                            villageCode != "0")
                        {
                            var item = new ListItem(villageName.Trim(), villageCode.Trim());
                            ddlVillage.Items.Add(item);
                            bindCount++;
                            Debug.WriteLine($"SUCCESS: Added '{villageName}' (Code: {villageCode})");
                        }
                    }

                    Debug.WriteLine($"Successfully bound {bindCount} villages");
                    ddlVillage.Enabled = true;
                }
                else
                {
                    ddlVillage.Items.Add(new ListItem("No Villages Found", "0"));
                    ddlVillage.Enabled = false;
                    Debug.WriteLine("No villages available for this tehsil");
                }

                Debug.WriteLine("=== ddlTehsil_SelectedIndexChanged END ===");
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"ddlTehsil_SelectedIndexChanged ERROR: {ex.Message}");
                ClearVillage();
            }
        }

        private List<JObject> GetVillagesHttpClientStyle(int districtCode, int tehsilCode)
        {
            try
            {
                var url = _apiUrl + "TblVillageMasters/GetTblVillageMasterBy_District_Tehsil_Code";
                string fullUrl = $"{url}?district_code={districtCode}&tehsil_code={tehsilCode}";

                Debug.WriteLine($"Calling Village API: {fullUrl}");

                var response = client.GetAsync(fullUrl);
                response.Wait();
                HttpResponseMessage responseMsg = response.Result;

                Debug.WriteLine($"Village API Status: {responseMsg.StatusCode}");

                if (responseMsg.IsSuccessStatusCode)
                {
                    string rawResult = responseMsg.Content.ReadAsStringAsync().Result;
                    Debug.WriteLine($"Village Raw Response Length: {rawResult.Length}");
                    Debug.WriteLine($"Village Response Preview: {rawResult.Substring(0, Math.Min(300, rawResult.Length))}");

                    string cleanJson = CleanJsonResponse(rawResult);
                    Debug.WriteLine($"Village Clean JSON Preview: {cleanJson.Substring(0, Math.Min(200, cleanJson.Length))}");

                    JArray jsonArray = JArray.Parse(cleanJson);
                    var villages = new List<JObject>();

                    foreach (JObject item in jsonArray)
                    {
                        villages.Add(item);
                        string name = GetPropertyValue(item, "villageName", "VillageName");
                        string code = GetPropertyValue(item, "villageCode", "VillageCode");
                        Debug.WriteLine($"Parsed Village: '{name}' (Code: '{code}')");
                    }

                    Debug.WriteLine($"Successfully parsed {villages.Count} villages");
                    return villages;
                }
                else
                {
                    string errorContent = responseMsg.Content.ReadAsStringAsync().Result;
                    Debug.WriteLine($"Village API ERROR {responseMsg.StatusCode}: {errorContent}");
                    return new List<JObject>();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"GetVillagesHttpClientStyle ERROR: {ex.Message}");
                return new List<JObject>();
            }
        }

        #endregion

        #region Utility Methods

        private string GetPropertyValue(JObject obj, params string[] propertyNames)
        {
            foreach (string propName in propertyNames)
            {
                var value = obj[propName];
                if (value != null && !string.IsNullOrEmpty(value.ToString()))
                {
                    return value.ToString().Trim();
                }
            }
            return null;
        }

        private string CleanJsonResponse(string rawJson)
        {
            try
            {
                string cleanJson = rawJson.Trim();

                // Remove any text before the first [
                int startBracket = cleanJson.IndexOf('[');
                if (startBracket > 0)
                {
                    cleanJson = cleanJson.Substring(startBracket);
                }

                // Remove any text after the last ]
                int endBracket = cleanJson.LastIndexOf(']');
                if (endBracket > 0 && endBracket < cleanJson.Length - 1)
                {
                    cleanJson = cleanJson.Substring(0, endBracket + 1);
                }

                // Ensure it starts and ends properly
                if (!cleanJson.StartsWith("[") || !cleanJson.EndsWith("]"))
                {
                    Debug.WriteLine($"WARNING: JSON not properly formatted - Start: '{cleanJson.Substring(0, 1)}', End: '{cleanJson.Substring(cleanJson.Length - 1)}'");
                }

                return cleanJson;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"CleanJsonResponse ERROR: {ex.Message}");
                return rawJson; // Return original if cleaning fails
            }
        }

        private void ClearTehsilAndVillage()
        {
            Debug.WriteLine("Clearing Tehsil and Village dropdowns");

            // Clear tehsil
            ddlTehsil.Items.Clear();
            ddlTehsil.Items.Add(new ListItem("Select District First", "0"));
            ddlTehsil.Enabled = false;

            // Clear village
            ClearVillage();
        }

        private void ClearVillage()
        {
            ddlVillage.Items.Clear();
            ddlVillage.Items.Add(new ListItem("Select Tehsil First", "0"));
            ddlVillage.Enabled = false;
            Debug.WriteLine("Village dropdown cleared and disabled");
        }

        #endregion




        protected void btnNext_Click1(object sender, EventArgs e)
        {
            try
            {
                string userId = Session["UserId"] != null ? Session["UserId"].ToString() : "";
                string createdBY = Session["Name"] != null ? Session["Name"].ToString() : "";

                using (var content = new MultipartFormDataContent())
                {
                    // ✅ Send individual fields (FromForm binding)
                    content.Add(new StringContent(userId), "ApplicantId");
                    content.Add(new StringContent(createdBY), "CreatedBy");
                    content.Add(new StringContent(txtFullName.Text.Trim()), "Name");
                    content.Add(new StringContent(ddlGender.SelectedValue.Trim()), "Gender");
                    content.Add(new StringContent(ddlDistrict.SelectedValue.Trim()), "District");
                    content.Add(new StringContent(ddlTehsil.SelectedValue.Trim()), "Teshsil");
                    content.Add(new StringContent(ddlVillage.SelectedValue.Trim()), "Village");
                    content.Add(new StringContent(txtMobileNumber.Text.Trim()), "MobileNo");
                    content.Add(new StringContent(txtAddress.Text.Trim()), "Address");
                    content.Add(new StringContent(txtAadhar.Text.Trim()), "AadharNo");
                    content.Add(new StringContent(txtPincode.Text.Trim()), "Pincode");

                    // ✅ File upload
                    if (fuAadhar.HasFile)
                    {
                        var fileStream = fuAadhar.PostedFile.InputStream;
                        var fileContent = new StreamContent(fileStream);
                        fileContent.Headers.ContentType = new MediaTypeHeaderValue(fuAadhar.PostedFile.ContentType);
                        content.Add(fileContent, "aadharDoc", fuAadhar.PostedFile.FileName);
                    }

                    // ✅ API call
                    using (var client = new HttpClient())
                    {
                        string apiUrl = _apiUrl + "TblApplicantMasters/PutTblApplicantRegistration";
                        var response = client.PostAsync(apiUrl, content).Result;

                        //                    if (response.IsSuccessStatusCode)
                        //                    {
                        //                        string result = response.Content.ReadAsStringAsync().Result;
                        //                        string script = @"
                        //Swal.fire({
                        //    title: 'Success',
                        //    text: 'Applicant details submitted successfully!',
                        //    icon: 'success',
                        //    showConfirmButton: true,
                        //    confirmButtonText: 'OK',
                        //    background: '#f0f9ff',
                        //    color: '#1a202c',
                        //    iconColor: '#38a169',
                        //    showClass: { popup: 'animate__animated animate__fadeInDown' },
                        //    hideClass: { popup: 'animate__animated animate__fadeOutUp' }
                        //});";

                        //                        ClientScript.RegisterStartupScript(this.GetType(), "successMessage", script, true);

                        //                        BindApplicantData(userId);
                        //                    }

                        if (response.IsSuccessStatusCode)
                        {
                            string result = response.Content.ReadAsStringAsync().Result;
                            string script = @"
Swal.fire({
    title: 'Success',
    text: 'Applicant details submitted successfully!',
    icon: 'success',
    showConfirmButton: true,
    confirmButtonText: 'OK',
    background: '#f0f9ff',
    color: '#1a202c',
    iconColor: '#38a169',
    showClass: { popup: 'animate__animated animate__fadeInDown' },
    hideClass: { popup: 'animate__animated animate__fadeOutUp' }
}).then((result) => {
    if (result.isConfirmed) {
        window.location.href = 'addbeneficiary.aspx'; // ✅ Change to your target page
    }
});";

                            ClientScript.RegisterStartupScript(this.GetType(), "successMessage", script, true);

                            BindApplicantData(userId);
                        }

                        else
                        {
                            string errorResult = response.Content.ReadAsStringAsync().Result;
                            string safeMessage = errorResult.Replace("'", "\\'").Replace("\r\n", " ");

                            string script = $@"
    Swal.fire({{
        title: 'Submission Failed',
        text: 'Submission failed: {safeMessage}',
        icon: 'error',
        showConfirmButton: true,
        confirmButtonText: 'OK',
        background: '#f0f9ff',
        color: '#1a202c',
        iconColor: '#e53e3e',
        showClass: {{ popup: 'animate__animated animate__fadeInDown' }},
        hideClass: {{ popup: 'animate__animated animate__fadeOutUp' }}
    }});";

                            ClientScript.RegisterStartupScript(this.GetType(), "errorMessage", script, true);

                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "error",
                    "alert('An error occurred: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }

        protected void ddlVillage_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void gvApplicantInfo_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                gvApplicantInfo.PageIndex = e.NewPageIndex;
                string userId = Session["UserId"] != null ? Session["UserId"].ToString() : null;
                BindApplicantData(userId);
            }
            catch (Exception ex)
            {

            }
        }
    }
}