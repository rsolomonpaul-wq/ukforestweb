using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Dynamic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Reflection.Emit;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static uk_forest.ApiHelper;
using JsonSerializer = System.Text.Json.JsonSerializer;
using Label = System.Web.UI.WebControls.Label;

namespace uk_forest.Forest
{
    public partial class BehalfofApplicant_RO : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string _apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    Session["UploadedFile"] = null;
                    Session["UploadedFileName"] = null;

                    string userId = Session["UserId"] != null ? Session["UserId"].ToString() : null;
                  
                    rblClaimType.SelectedValue = "Human";
                    humandeath.Visible = true;
                    humandocuments.Visible = true;

                    LoadDistrictsHttpClient();
                    BindAnimal();

                    string incidentId = Request.QueryString["incidentId"];

                    if (!string.IsNullOrEmpty(incidentId))
                    {
                        LoadApplicantAndIncidentData("APP0003");
                    }
                }
                else
                {

                }
            }
            catch (Exception ex)
            {

            }
        }


        private async void LoadApplicantAndIncidentData(string applicantId)
        {
            try
            {
                string applicantApiUrl = _apiUrl + "TblApplicantMasters/GetApplicant/" + applicantId;
                string incidentApiUrl = _apiUrl + "TblIncidentDetails/GetTblIncidentDetail_byApplicantId?applicant_id=" + applicantId;

                using (HttpClient client = new HttpClient())
                {
                    // Fetch applicant data
                    HttpResponseMessage applicantResponse = await client.GetAsync(applicantApiUrl);
                    dynamic applicantData = null;
                    if (applicantResponse.IsSuccessStatusCode)
                    {
                        string applicantJson = await applicantResponse.Content.ReadAsStringAsync();
                        applicantData = JsonConvert.DeserializeObject<ExpandoObject>(applicantJson);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "apiError", "alert('Failed to load applicant data.');", true);
                        return;
                    }

                    // Fetch incident data
                    HttpResponseMessage incidentResponse = await client.GetAsync(incidentApiUrl);
                    dynamic incidentData = null;
                    string incidentId = null;
                    if (incidentResponse.IsSuccessStatusCode)
                    {
                        string incidentJson = await incidentResponse.Content.ReadAsStringAsync();
                        if (incidentJson.TrimStart().StartsWith("["))
                        {
                            var incidentList = JsonConvert.DeserializeObject<List<ExpandoObject>>(incidentJson);
                            if (incidentList != null && incidentList.Count > 0)
                            {
                                incidentData = incidentList[0];
                                incidentId = GetDynamicProperty(incidentData, "incidentId");
                            }
                            else
                            {
                                ScriptManager.RegisterStartupScript(this, GetType(), "apiError", "alert('No incident data found for this applicant.');", true);
                                return;
                            }
                        }
                        else
                        {
                            incidentData = JsonConvert.DeserializeObject<ExpandoObject>(incidentJson);
                            incidentId = GetDynamicProperty(incidentData, "incidentId");
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "apiError", "alert('Failed to load incident data.');", true);
                        return;
                    }

                    // Fetch document data
                    List<ExpandoObject> documentList = null;
                    if (!string.IsNullOrEmpty(incidentId))
                    {
                        string documentApiUrl = _apiUrl + "TblDocumentDetails/GetTblDocumentDetail_byIncidentId?incident_id=" + incidentId;
                        HttpResponseMessage documentResponse = await client.GetAsync(documentApiUrl);
                        if (documentResponse.IsSuccessStatusCode)
                        {
                            string documentJson = await documentResponse.Content.ReadAsStringAsync();
                            if (documentJson.TrimStart().StartsWith("["))
                            {
                                documentList = JsonConvert.DeserializeObject<List<ExpandoObject>>(documentJson);
                            }
                            else
                            {
                                var singleDoc = JsonConvert.DeserializeObject<ExpandoObject>(documentJson);
                                documentList = new List<ExpandoObject> { singleDoc };
                            }
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "apiError", "alert('Failed to load document data.');", true);
                        }
                    }

                  

                    // Determine claim type and show relevant section
                    string claimType = DetermineClaimType(incidentData);
                    rblClaimType.SelectedValue = claimType;
                    UpdateFormVisibility(claimType);

                    // Populate fields based on claim type
                    if (claimType == "Human")
                    {
                        txtFullName.Text = GetDynamicProperty(incidentData, "fullName") ?? GetDynamicProperty(applicantData, "name");
                        txtFatherName.Text = GetDynamicProperty(incidentData, "fatherName");
                        rblGender.SelectedValue = GetDynamicProperty(incidentData, "gender");
                        txtAge.Text = GetDynamicProperty(incidentData, "age")?.ToString();
                        txtAadhar.Text = GetDynamicProperty(incidentData, "aadharNo") ?? GetDynamicProperty(applicantData, "aadharNo");
                    }
                    else if (claimType == "Crop")
                    {
                        TextBox1.Text = GetDynamicProperty(incidentData, "farmerName") ?? GetDynamicProperty(applicantData, "name");
                        TextBox2.Text = GetDynamicProperty(incidentData, "fatherName");
                        ddl_damage_crop.SelectedValue = GetDynamicProperty(incidentData, "cropName");
                        txt_crop_area.Text = GetDynamicProperty(incidentData, "areaInHectare")?.ToString();
                    }
                    else if (claimType == "Cattle")
                    {
                        txt_cattle_owner.Text = GetDynamicProperty(incidentData, "cattleOwnerName") ?? GetDynamicProperty(applicantData, "name");
                        txt_cattle_father_name.Text = GetDynamicProperty(incidentData, "fatherName");
                        ddl_cattle_species.SelectedValue = GetDynamicProperty(incidentData, "speciesType");
                        ddl_cattle_age.SelectedValue = GetDynamicProperty(incidentData, "ageOfCattle")?.ToString();
                        ddl_yes_no.SelectedValue = GetDynamicProperty(incidentData, "ownerPresent")?.ToString();
                    }
                    else if (claimType == "House")
                    {
                        txt_house_owner_name.Text = GetDynamicProperty(incidentData, "houseOwnerName") ?? GetDynamicProperty(applicantData, "name");
                        txt_house_father_name.Text = GetDynamicProperty(incidentData, "fatherName");
                    }

                    // Populate incident details
                    ddlDistrict.SelectedValue = GetDynamicProperty(incidentData, "districtCode") ?? GetDynamicProperty(applicantData, "district");
                    ddlDistrict_SelectedIndexChanged(null, null);
                    ddlTehsil.SelectedValue = GetDynamicProperty(incidentData, "teshsilCode") ?? GetDynamicProperty(applicantData, "teshsil");
                    ddlTehsil_SelectedIndexChanged(null, null);
                    ddlVillage.SelectedValue = GetDynamicProperty(incidentData, "villageCode") ?? GetDynamicProperty(applicantData, "village");
                    ddlVillage_SelectedIndexChanged(null, null);

                    ddlDivision.SelectedValue = GetDynamicProperty(incidentData, "divisionId")?.ToString();
                    ddlRange3.SelectedValue = GetDynamicProperty(incidentData, "rangeId")?.ToString();
                    ddlIncidentBy.SelectedValue = GetDynamicProperty(incidentData, "animalId")?.ToString();
                    txtDateIncident.Text = GetDynamicProperty(incidentData, "incidentDate");
                    txtTimeIncident.Text = GetDynamicProperty(incidentData, "incidentTime");
                    ddl_incidentplace.SelectedValue = GetDynamicProperty(incidentData, "incidentPlace");
                    txtIncidentSummary.Text = GetDynamicProperty(incidentData, "incidentSummary");
                    txtLatitude.Text = GetDynamicProperty(incidentData, "lat")?.ToString();
                    txtLongitude.Text = GetDynamicProperty(incidentData, "long")?.ToString();

                    // Display documents
                    if (documentList != null && documentList.Count > 0)
                    {
                        DisplayDocuments(documentList, claimType);
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", $"alert('Error: {ex.Message}');", true);
            }
        }

        private void DisplayDocuments(List<ExpandoObject> documentList, string claimType)
        {
            // Map document types to file upload controls
            var documentMapping = new Dictionary<string, Label>(StringComparer.OrdinalIgnoreCase)
            {
                { "IncidentPhotograph", Label18 },
                { "ApplicantApplication", lblEndorsementStatus },
                { "GramPanchayatCertificate", Label15 },
                { "ApplicantEndorsement", Label17 },
                { "CropIncidentPhotograph", Label19 },
                { "CropApplicantForm", Label20 },
                { "LekhpalCertificate", Label21 },
                { "CropApplicantEndorsement", Label22 }
            };

            foreach (var doc in documentList)
            {
                string docType = GetDynamicProperty(doc, "documentType")?.ToLower();
                string docName = GetDynamicProperty(doc, "documentName") ?? "Document";
                string docPath = GetDynamicProperty(doc, "documentPath");

                if (string.IsNullOrEmpty(docType) || string.IsNullOrEmpty(docPath))
                    continue;

                // Map document type to control
                string key = MapDocumentType(docType, claimType);
                if (documentMapping.ContainsKey(key))
                {
                    var label = documentMapping[key];
                    label.Text = $"<a href='{docPath}' target='_blank'>{docName}</a>";
                    label.Visible = true;
                }
            }
        }

        private string MapDocumentType(string docType, string claimType)
        {
            if (claimType == "Human")
            {
                switch (docType?.ToLower())
                {
                    case "incidentphotograph": return "IncidentPhotograph";
                    case "applicantapplication": return "ApplicantApplication";
                    case "grampanchayatcertificate": return "GramPanchayatCertificate";
                    case "applicantendorsement": return "ApplicantEndorsement";
                    default: return docType;
                }
            }
            else if (claimType == "Crop")
            {
                switch (docType?.ToLower())
                {
                    case "incidentphotograph": return "CropIncidentPhotograph";
                    case "applicantform": return "CropApplicantForm";
                    case "lekhpalcertificate": return "LekhpalCertificate";
                    case "applicantendorsement": return "CropApplicantEndorsement";
                    default: return docType;
                }
            }
            return docType;
        }

        private string GetDynamicProperty(dynamic obj, string propertyName)
        {
            if (obj is IDictionary<string, object> dict && dict.TryGetValue(propertyName, out var value) && value != null)
            {
                return value.ToString();
            }
            return null;
        }

        private string DetermineClaimType(dynamic incidentData)
        {
            if (incidentData is IDictionary<string, object> dict)
            {
                if (dict.ContainsKey("fullName") && dict["fullName"] != null ||
                    dict.ContainsKey("gender") && dict["gender"] != null ||
                    dict.ContainsKey("age") && dict["age"] != null)
                    return "Human";
                if (dict.ContainsKey("farmerName") && dict["farmerName"] != null ||
                    dict.ContainsKey("cropName") && dict["cropName"] != null ||
                    dict.ContainsKey("areaInHectare") && dict["areaInHectare"] != null)
                    return "Crop";
                if (dict.ContainsKey("cattleOwnerName") && dict["cattleOwnerName"] != null ||
                    dict.ContainsKey("speciesType") && dict["speciesType"] != null ||
                    dict.ContainsKey("ageOfCattle") && dict["ageOfCattle"] != null)
                    return "Cattle";
                if (dict.ContainsKey("houseOwnerName") && dict["houseOwnerName"] != null)
                    return "House";
            }
            return "Human";
        }

        private void UpdateFormVisibility(string claimType)
        {
            humandeath.Visible = claimType == "Human";
            cropdamage.Visible = claimType == "Crop";
            cattlekill.Visible = claimType == "Cattle";
            housedamage.Visible = claimType == "House";
            humandocuments.Visible = claimType == "Human";
            cropdamagedocument.Visible = claimType == "Crop";
            yes_no.Visible = claimType == "Cattle";
            cropdamagedname.Visible = claimType == "Crop";
            croparea.Visible = claimType == "Crop";
            btnAddCrop.Visible = claimType == "Crop";
            incidentplace.Visible = claimType == "Cattle" || claimType == "House";
        }
        void BindAnimal()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(_apiUrl + string.Format("ConflictAnimalMasters/GetConflictAnimalMaster_byConfllictCategory?conflict_category=Human")).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddlIncidentBy.Items.Clear();
                        ddlIncidentBy.DataSource = dt;
                        ddlIncidentBy.DataValueField = "Id";
                        ddlIncidentBy.DataTextField = "animalName";
                        ddlIncidentBy.DataBind();
                        ddlIncidentBy.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Animal / पशु चुनें", "0"));
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }
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
            catch (Newtonsoft.Json.JsonException jsonEx)
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
                ddlDistrict.Items.Add(new ListItem("Select District / जिला चुनें", "0"));


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

                }
                else
                {
                    ddlDistrict.Items.Add(new ListItem("No Districts Available", "0"));
                }
            }
            catch (Exception ex)
            {
                ddlDistrict.Items.Clear();
                ddlDistrict.Items.Add(new ListItem("Error Loading Districts", "0"));
            }
        }


        protected void ddlDistrict_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                BindTehsil(Convert.ToInt32(ddlDistrict.SelectedValue));
            }
            catch (Exception ex)
            {

            }
        }

        void BindTehsil(int districtCode)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer");
                    HttpResponseMessage Res = client.GetAsync(_apiUrl + string.Format("TblTehsilMasters/GetTblTehsilMasterByDistrictCode?district_code=" + districtCode)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddlTehsil.Items.Clear();
                        ddlTehsil.DataSource = dt;
                        ddlTehsil.DataValueField = "tehsilCode";
                        ddlTehsil.DataTextField = "tehsilName";
                        ddlTehsil.DataBind();
                        ddlTehsil.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Tehsil", "0"));
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddlTehsil_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                BindVillage(Convert.ToInt32(ddlDistrict.SelectedValue), Convert.ToInt32(ddlTehsil.SelectedValue));
            }
            catch (Exception ex)
            {

            }
        }


        void BindVillage(int districtCode, int tehsilCode)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer");
                    HttpResponseMessage Res = client.GetAsync(_apiUrl + string.Format("TblVillageMasters/GetTblVillageMasterBy_District_Tehsil_Code?district_code=" + districtCode + "&tehsil_code=" + tehsilCode)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddlVillage.Items.Clear();
                        ddlVillage.DataSource = dt;
                        ddlVillage.DataValueField = "villageCode";
                        ddlVillage.DataTextField = "villageName";
                        ddlVillage.DataBind();
                        ddlVillage.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Village", "0"));
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddlVillage_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                BindDivision(Convert.ToInt32(ddlVillage.SelectedValue));

                string selectedValue = ddlVillage.SelectedValue; // village id
                                                                 //ScriptManager.RegisterStartupScript(this, this.GetType(),
                                                                 //    "callGetRange", $"getrange('{selectedValue}');", true);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "QuickResponse", "", true);

                if (ddlVillage.SelectedValue != null && ddlVillage.SelectedValue != "0")
                {
                    // Use a simpler approach without complex script registration
                    string script = $"if(window.getrange){{getrange({{value:'{ddlVillage.SelectedValue}'}});}}";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "CallGetRange", script, true);
                }

            }
            catch (Exception ex)
            {

            }
        }


        void BindDivision(int villageCode)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage Res = client.GetAsync(_apiUrl + "TblVillageMasters/GetRangeDivision_By_VillageCode?village_code=" + villageCode).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        // Parse JSON array
                        JArray arr = JArray.Parse(EmpResponse);

                        if (arr.Count > 0)
                        {
                            // ✅ Division List
                            var divisionList = arr.Select(x => new
                            {
                                DivisionId = x["divisionId"]?.ToString(),
                                DivisionName = x["divisionName"]?.ToString()
                            }).ToList();

                            ddlDivision.DataSource = divisionList;
                            ddlDivision.DataTextField = "DivisionName";
                            ddlDivision.DataValueField = "DivisionId";
                            ddlDivision.DataBind();

                            // ✅ Range List
                            var rangeList = arr.Select(x => new
                            {
                                RangeId = x["rangeId"]?.ToString(),
                                RangeName = x["rangeName"]?.ToString()
                            }).ToList();

                            ddlRange3.DataSource = rangeList;
                            ddlRange3.DataTextField = "RangeName";
                            ddlRange3.DataValueField = "RangeId";
                            ddlRange3.DataBind();

                        }
                        else
                        {
                            lblRange3.Text = "No data found";
                        }
                    }
                    else
                    {
                        lblRange3.Text = "Error fetching data";
                    }
                }
            }
            catch (Exception ex)
            {
                lblRange3.Text = "Exception: " + ex.Message;
            }
        }


        protected void rblClaimType_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                humandeath.Visible = false;
                cropdamage.Visible = false;
                cattlekill.Visible = false;
                housedamage.Visible = false;
                yes_no.Visible = false;
                cropdamagedname.Visible = false;
                croparea.Visible = false;
                btnAddCrop.Visible = false;
                incidentplace.Visible = false;
                humandocuments.Visible = false;
                cropdamagedocument.Visible = false;
                pnlCropDetails.Visible = false;
                pnlCattleDetails.Visible = false;

                switch (rblClaimType.SelectedValue)
                {
                    case "Human":
                        humandeath.Visible = true;
                        humandocuments.Visible = true;
                        break;
                    case "Crop":
                        cropdamage.Visible = true;
                        cropdamagedname.Visible = true;
                        croparea.Visible = true;
                        btnAddCrop.Visible = true;
                        cropdamagedocument.Visible = true;
                        pnlCropDetails.Visible = true;
                        break;
                    case "Cattle":
                        cattlekill.Visible = true;
                        yes_no.Visible = true;
                        incidentplace.Visible = true;
                        humandocuments.Visible = true;
                        pnlCattleDetails.Visible = true;
                        break;
                    case "House":
                        housedamage.Visible = true;
                        humandocuments.Visible = true;
                        break;
                }
            }
            catch (Exception ex)
            {

            }
        }


        protected async void btn_submit_victim_incident_Click(object sender, EventArgs e)
        {
            try
            {
                string applicant_fullname = txt_applicant_fullname.Text.Trim();
                string applicant_mobile = txt_applicant_mobile.Text.Trim();
                string applicant_email = txt_applicant_email.Text.Trim();
                string applicant_alternateno = txt_applicant_alternateno.Text.Trim();
                string applicantgender = rblapplicantgender.SelectedValue;

                string baseApiUrl = ConfigurationSettings.AppSettings["api_path"];
                string apiUrl = baseApiUrl + $"TblApplicantMasters/Check_Applicant_By_MobileNo?mobile_no={applicant_mobile}";


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
                            string message = $"Mobile number {applicant_mobile} is already used!";
                            Page.ClientScript.RegisterStartupScript(
                                this.GetType(),
                                "alert",
                                $"alert('{message}');",
                                true
                            );
                            return; // stop execution
                        }
                    }
                }


                string applicantId = InsertUserToDatabase(applicant_fullname, applicant_mobile, applicant_email, applicant_alternateno, applicantgender);

                if (string.IsNullOrEmpty(applicantId))
                {
                    string message = "Account creation failed. Please try again.";
                    Page.ClientScript.RegisterStartupScript(
                        this.GetType(),
                        "alert",
                        $"alert('{message}');",
                        true
                    );
                }

                string applicantIdRo = applicantId;
                string createdBy = Session["userId"]?.ToString();

                using (var content = new MultipartFormDataContent())
                {
                    // id from hidden
                    int id = string.IsNullOrEmpty(hfId.Value) ? 0 : int.Parse(hfId.Value);
                    content.Add(new StringContent(id.ToString()), "Id");

                    // beneficiaryId
                    string beneficiaryId = hfBeneficiaryId.Value;
                    if (string.IsNullOrEmpty(beneficiaryId))
                    {
                        beneficiaryId = Guid.NewGuid().ToString();
                    }

                    content.Add(new StringContent(beneficiaryId), "BeneficiaryId");
                    content.Add(new StringContent(applicantIdRo), "ApplicantId");
                    content.Add(new StringContent(createdBy ?? ""), "CreatedBy");
                    content.Add(new StringContent(createdBy ?? ""), "UpdatedBy");
                    content.Add(new StringContent(ddlBanks.SelectedValue.Trim()), "BankName");
                    content.Add(new StringContent(txtAccountNumber.Text.Trim()), "AccNumber");
                    content.Add(new StringContent(txtIFSC.Text.Trim()), "IfscCode");
                    content.Add(new StringContent(txtFullName.Text.Trim()), "AccHolderName");
                    content.Add(new StringContent(txtAadhar.Text.Trim()), "AadharNo");
                    content.Add(new StringContent(txtPanNumber.Text.Trim()), "PanNo");
                    content.Add(new StringContent("true"), "IsActive");

                    // File add karo agar upload hua ho
                    if (filebeneficiary.HasFile)
                    {
                        var fileStream = filebeneficiary.PostedFile.InputStream;
                        fileStream.Position = 0;
                        var fileContent = new StreamContent(fileStream);
                        fileContent.Headers.ContentType = new MediaTypeHeaderValue(filebeneficiary.PostedFile.ContentType);
                        content.Add(fileContent, "BankDoc", filebeneficiary.PostedFile.FileName);
                    }
                    else
                    {
                        content.Add(new StringContent(""), "BankDoc");
                    }

                    // API Call
                    using (var httpClient = new HttpClient())
                    {
                        string BeneficiaryapiUrl = _apiUrl + "TblBeneficiaryMasters/AddUpdateBeneficiaryMaster";
                        var response = httpClient.PostAsync(BeneficiaryapiUrl, content).Result;

                        if (response.IsSuccessStatusCode)
                        {
                            string successMessage = id > 0 ? "updated" : "submitted";


                        }
                        else
                        {
                            string errorResult = response.Content.ReadAsStringAsync().Result.Replace("'", "\\'");

                        }
                    }
                }

                string cropNames = hfCropNames.Value; // e.g., "Rice,Wheat,Maize"
                string cropAreas = hfCropAreas.Value; // e.g., "1.5,2.0,0.8"
                string cattleSpecies = hfCattleSpecies.Value; // e.g., "Cattle,Buffalo,Goat"
                string cattleAges = hfCattleAges.Value; // e.g., "2,5,1"

                if (string.IsNullOrEmpty(rblClaimType.SelectedValue))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Please select a claim category.');", true);
                    return;
                }

                string victimId = await SaveVictimMaster(applicantId);
                if (string.IsNullOrEmpty(victimId))
                {
                    return; // Error already displayed in SaveVictimMaster
                }

                string incidentId = await SaveIncidentDetails(victimId, applicantId);
                if (string.IsNullOrEmpty(incidentId))
                {
                    return; // Error already displayed in SaveIncidentDetails
                }

                await SaveIncidentDocuments(victimId, incidentId, applicantId);

                string action = "Document verified by " + Session["RoleName"].ToString();
                string Incidentstatus = "Application Submission";
                string remarks = $"Document verified for Incident ID: {incidentId}";
                string RoleID = Session["roleid"].ToString();

                ApiResult resultlog = ApiHelper.PostIncidentProgressLog(this, incidentId, RoleID, Session["RoleName"].ToString(), Incidentstatus, createdBy, remarks);

                string script = $@"
                    Swal.fire({{
                        title: 'Success',
                        html: 'All details and documents saved successfully!<br>VictimId: <strong>{victimId}</strong><br>IncidentId: <strong>{incidentId}</strong>',
                        icon: 'success',
                        confirmButtonText: 'OK'
                    }});
                ";

                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", script, true);


            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Exception in submission: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Exception in btn_submit_victim_incident_Click: {ex.StackTrace}");
            }
        }
        private string InsertUserToDatabase(string fullName, string mobile, string email, string altPhone, string gender)
        {
            try
            {
                string userId = Session["UserId"] != null ? Session["UserId"].ToString() : null;

                var data = new
                {
                    name = fullName,
                    mobileNo = mobile,
                    emailId = email,
                    password = mobile,
                    gender = gender,
                    alternateMobileNo = altPhone,
                    createdBy = userId.ToString(),
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                var url = _apiUrl + "TblApplicantMasters/Register";

                using (HttpClient client = new HttpClient())
                {
                    var response1 = client.PostAsync(url, data1).Result;

                    if (response1.IsSuccessStatusCode)
                    {
                        string result = response1.Content.ReadAsStringAsync().Result;

                        // Deserialize the response
                        dynamic obj = JsonConvert.DeserializeObject(result);

                        // return applicantId from response
                        return obj.applicantId.ToString();
                    }
                    else
                    {
                        return null; // or throw exception
                    }
                }
            }
            catch (Exception ex)
            {
                return null;  // return null if error
            }
        }

        private async Task<string> SaveVictimMaster(string applicantId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string cropNames = hfCropNames.Value; // e.g., "Rice,Wheat,Maize"
                    string cropAreas = hfCropAreas.Value; // e.g., "1.5,2.0,0.8"
                    string cattleSpecies = hfCattleSpecies.Value; // e.g., "Cattle,Buffalo,Goat"
                    string cattleAges = hfCattleAges.Value; //

                    string userId = Session["UserId"] != null ? Session["UserId"].ToString() : null;
                    string createdby = Session["Name"] != null ? Session["Name"].ToString() : null;
                    string apiUrl = _apiUrl + "TblVictimMasters/PostTblVictimMaster";
                    using (var formData = new MultipartFormDataContent())
                    {
                        // Add TblVictimMaster form fields
                        formData.Add(new StringContent("VICT-0000"), "VictimId"); // Dummy value, API will generate
                        formData.Add(new StringContent(applicantId), "ApplicantId");
                        formData.Add(new StringContent(createdby), "CreatedBy");
                        formData.Add(new StringContent(rblClaimType.SelectedValue ?? ""), "ClaimCategory");

                        // Map fields based on ClaimCategory
                        string fullName = "";
                        string fatherName = "";
                        string aadharNo = rblClaimType.SelectedValue == "Human" ? txtAadhar.Text ?? "" : "";
                        if (rblClaimType.SelectedValue == "Human")
                        {
                            fullName = txtFullName.Text;
                            fatherName = txtFatherName.Text;
                            formData.Add(new StringContent(rblGender.SelectedValue ?? ""), "Gender");
                            formData.Add(new StringContent(txtAge.Text ?? ""), "Age");
                        }
                        //else if (rblClaimType.SelectedValue == "Crop")
                        //{
                        //    fullName = TextBox1.Text;
                        //    fatherName = TextBox2.Text;
                        //    formData.Add(new StringContent(TextBox1.Text ?? ""), "FarmerName");
                        //    formData.Add(new StringContent(ddl_damage_crop.SelectedValue ?? ""), "CropName");
                        //    formData.Add(new StringContent(txt_crop_area.Text ?? ""), "AreaInHectare");
                        //}
                        else if (rblClaimType.SelectedValue == "Crop")
                        {
                            fullName = TextBox1.Text;
                            fatherName = TextBox2.Text;
                            formData.Add(new StringContent(TextBox1.Text ?? ""), "FarmerName");
                            formData.Add(new StringContent(cropNames ?? ""), "CropName");
                            formData.Add(new StringContent(cropAreas ?? ""), "AreaInHectare");
                        }
                        //else if (rblClaimType.SelectedValue == "Cattle")
                        //{
                        //    fullName = txt_cattle_owner.Text;
                        //    fatherName = txt_cattle_father_name.Text;
                        //    formData.Add(new StringContent(txt_cattle_owner.Text ?? ""), "CattleOwnerName");
                        //    formData.Add(new StringContent(ddl_cattle_species.SelectedValue ?? ""), "SpeciesType");
                        //    formData.Add(new StringContent(ddl_cattle_age.SelectedValue ?? ""), "AgeOfCattle");
                        //    string ownerPresent = ddl_yes_no.SelectedValue == "1" ? "true" : (ddl_yes_no.SelectedValue == "2" ? "false" : "");
                        //    formData.Add(new StringContent(ownerPresent), "OwnerPresent");
                        //}

                        else if (rblClaimType.SelectedValue == "Cattle")
                        {
                            fullName = txt_cattle_owner.Text;
                            fatherName = txt_cattle_father_name.Text;
                            formData.Add(new StringContent(txt_cattle_owner.Text ?? ""), "CattleOwnerName");
                            formData.Add(new StringContent(cattleSpecies ?? ""), "SpeciesType");
                            formData.Add(new StringContent(cattleAges ?? ""), "AgeOfCattle");
                            string ownerPresent = ddl_yes_no.SelectedValue == "1" ? "true" : (ddl_yes_no.SelectedValue == "2" ? "false" : "");
                            formData.Add(new StringContent(ownerPresent), "OwnerPresent");
                        }



                        else if (rblClaimType.SelectedValue == "House")
                        {
                            fullName = txt_house_owner_name.Text;
                            fatherName = txt_house_father_name.Text;
                            formData.Add(new StringContent(txt_house_owner_name.Text ?? ""), "HouseOwnerName");
                        }

                        formData.Add(new StringContent(fullName ?? ""), "FullName");
                        formData.Add(new StringContent(fatherName ?? ""), "FatherName");
                        formData.Add(new StringContent(aadharNo), "AadharNo");
                        formData.Add(new StringContent(""), "AadharDoc"); // API sets path
                        formData.Add(new StringContent(""), "MobileNo"); // Not in form, send empty

                        // Add Aadhar file (only for HumanDeath)
                        if (rblClaimType.SelectedValue == "Human" && fuAadhar.HasFile)
                        {
                            var file = fuAadhar.PostedFile;
                            if (file.ContentLength > 2 * 1024 * 1024)
                            {
                                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Error: Aadhar file size exceeds 2 MB limit.');", true);
                                return null;
                            }
                            var fileBytes = new byte[file.ContentLength];
                            await file.InputStream.ReadAsync(fileBytes, 0, file.ContentLength);
                            var fileContent = new ByteArrayContent(fileBytes);
                            fileContent.Headers.ContentType = System.Net.Http.Headers.MediaTypeHeaderValue.Parse(file.ContentType);
                            formData.Add(fileContent, "aadharDoc", file.FileName);
                        }

                        // Log form data for debugging
                        StringBuilder formDataLog = new StringBuilder("VictimMaster Form Data Payload:\n");
                        foreach (var content in formData)
                        {
                            var contentValue = content.Headers.ContentDisposition.FileName != null ? "[File]" : await content.ReadAsStringAsync();
                            formDataLog.AppendLine($"{content.Headers.ContentDisposition.Name}: {contentValue}");
                        }
                        System.Diagnostics.Debug.WriteLine(formDataLog.ToString());

                        // API call
                        var response = await client.PostAsync(apiUrl, formData);
                        string result = await response.Content.ReadAsStringAsync();
                        System.Diagnostics.Debug.WriteLine($"PostTblVictimMaster Response: StatusCode={response.StatusCode}, Content={result}");

                        if (response.IsSuccessStatusCode)
                        {
                            var jsonResult = JsonSerializer.Deserialize<JsonElement>(result);
                            if (jsonResult.TryGetProperty("victimId", out JsonElement victimIdElement))
                            {
                                string victimId = victimIdElement.GetString();
                                return victimId;
                            }
                            else
                            {
                                throw new Exception($"VictimId not found. Response was: {result}");
                            }

                        }
                        else
                        {
                            string errorMessage = "Unknown error";
                            try
                            {
                                var jsonError = JsonSerializer.Deserialize<JsonElement>(result);
                                errorMessage = jsonError.TryGetProperty("Status", out var status)
                                    ? status.GetString()
                                    : jsonError.TryGetProperty("errors", out var errors)
                                        ? errors.ToString()
                                        : jsonError.TryGetProperty("title", out var title)
                                            ? title.GetString()
                                            : result;
                            }
                            catch
                            {
                                errorMessage = result;
                            }
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Error saving VictimMaster: {errorMessage}');", true);
                            return null;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Exception in SaveVictimMaster: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Exception in SaveVictimMaster: {ex.StackTrace}");
                return null;
            }
        }

        private async Task<string> SaveIncidentDetails(string victimId, string appId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string createdby = Session["Name"] != null ? Session["Name"].ToString() : null;
                    string userId = Session["UserId"] != null ? Session["UserId"].ToString() : null;
                    string apiUrl = _apiUrl + "TblIncidentDetails/PostTblIncidentDetails";
                    using (var formData = new MultipartFormDataContent())
                    {
                        // Add TblIncidentDetail form fields
                        formData.Add(new StringContent(victimId), "VictimId");
                        formData.Add(new StringContent(appId), "ApplicantId");
                        formData.Add(new StringContent("INCD-0000"), "IncidentId");
                        formData.Add(new StringContent(createdby), "CreatedBy");
                        formData.Add(new StringContent(ddlDistrict.SelectedValue ?? ""), "DistrictCode");
                        formData.Add(new StringContent(rblClaimType.SelectedValue ?? ""), "ClaimCategory");
                        formData.Add(new StringContent(ddlTehsil.SelectedValue ?? ""), "TeshsilCode");
                        formData.Add(new StringContent(ddlVillage.SelectedValue ?? ""), "VillageCode");

                        formData.Add(new StringContent(ddlDivision.SelectedValue ?? "0"), "DivisionId");
                        formData.Add(new StringContent(ddlRange3.SelectedValue ?? "0"), "RangeId");
                        formData.Add(new StringContent(ddlIncidentBy.SelectedValue ?? "0"), "AnimalId");

                        formData.Add(new StringContent(
                            string.IsNullOrWhiteSpace(txtDateIncident.Text)
                                ? DateTime.Now.ToString("yyyy-MM-dd")
                                : Convert.ToDateTime(txtDateIncident.Text).ToString("yyyy-MM-dd")), "IncidentDate");

                        formData.Add(new StringContent(txtTimeIncident.Text ?? ""), "IncidentTime");

                        formData.Add(new StringContent(txtIncidentSummary.Text ?? ""), "IncidentSummary");
                        formData.Add(new StringContent(ddl_incidentplace.SelectedValue ?? ""), "IncidentPlace");

                        formData.Add(new StringContent(string.IsNullOrWhiteSpace(txtLongitude.Text) ? "0" : txtLongitude.Text), "Long");
                        formData.Add(new StringContent(string.IsNullOrWhiteSpace(txtLatitude.Text) ? "0" : txtLatitude.Text), "Lat");

                        formData.Add(new StringContent("true"), "IsActive");


                        // Log form data for debugging
                        StringBuilder formDataLog = new StringBuilder("IncidentDetails Form Data Payload:\n");
                        foreach (var content in formData)
                        {
                            var contentValue = await content.ReadAsStringAsync();
                            formDataLog.AppendLine($"{content.Headers.ContentDisposition.Name}: {contentValue}");
                        }
                        System.Diagnostics.Debug.WriteLine(formDataLog.ToString());

                        // API call
                        var response = await client.PostAsync(apiUrl, formData);
                        string result = await response.Content.ReadAsStringAsync();
                        System.Diagnostics.Debug.WriteLine($"PostTblIncidentDetails Response: StatusCode={response.StatusCode}, Content={result}");



                        if (response.IsSuccessStatusCode)
                        {
                            var jsonResult = JsonSerializer.Deserialize<JsonElement>(result);
                            string incidentId = jsonResult.GetProperty("incidentId").GetString();
                            return incidentId;
                        }
                        else
                        {
                            string errorMessage = "Unknown error";
                            try
                            {
                                var jsonError = JsonSerializer.Deserialize<JsonElement>(result);
                                errorMessage = jsonError.TryGetProperty("Status", out var status)
                                    ? status.GetString()
                                    : jsonError.TryGetProperty("errors", out var errors)
                                        ? errors.ToString()
                                        : jsonError.TryGetProperty("title", out var title)
                                            ? title.GetString()
                                            : result;
                            }
                            catch
                            {
                                errorMessage = result;
                            }
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Error saving IncidentDetails: {errorMessage}');", true);
                            return null;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Exception in SaveIncidentDetails: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Exception in SaveIncidentDetails: {ex.StackTrace}");
                return null;
            }
        }

        private async Task SaveIncidentDocuments(string victimId, string incidentId, string applicantId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string createdby = Session["Name"] != null ? Session["Name"].ToString() : null;
                    string apiUrl = _apiUrl + "TblDocumentDetails/PostTblDocumentDetail";

                    List<(FileUpload, string, string)> fileUploads = new List<(FileUpload, string, string)>
                    {

                        (incidentphotograph, "IncidentPhotograph", incidentphotograph.FileName),
                        (applicantapplication, "ApplicantApplication", applicantapplication.FileName),
                        (grampanchayatform, "GramPanchayatForm", grampanchayatform.FileName),
                        (EndorsementApp, "EndorsementApp", EndorsementApp.FileName),

                        // CropField documents
                        (cropdamage_incidentphotograph, "CropDamageIncidentPhotograph", cropdamage_incidentphotograph.FileName),
                        (cropdamage_applicantform, "CropDamageApplicantForm", cropdamage_applicantform.FileName),
                        (cropdamage_lekhpal, "CropDamageLekhpal", cropdamage_lekhpal.FileName),
                        (cropdamage_applicantendorsemet, "CropDamageApplicantEndorsement", cropdamage_applicantendorsemet.FileName)
                    };

                    string roleId = Session["RoleId"].ToString(); // Replace with actual roleId
                    string userId = Session["UserId"] != null ? Session["UserId"].ToString() : null;

                    foreach (var (fileUpload, documentName, fileName) in fileUploads)
                    {
                        if (fileUpload.HasFile)
                        {
                            var file = fileUpload.PostedFile;

                            if (file.ContentLength > 2 * 1024 * 1024)
                            {
                                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Error: {documentName} file size exceeds 2 MB limit.');", true);
                                continue;
                            }

                            using (var formData = new MultipartFormDataContent())
                            {
                                formData.Add(new StringContent("0"), "sno");
                                formData.Add(new StringContent(incidentId), "incidentId");
                                formData.Add(new StringContent(createdby), "CreatedBy");
                                formData.Add(new StringContent("11"), "UploadedByRoleId");
                                formData.Add(new StringContent(applicantId), "UploadedByUserId");
                                formData.Add(new StringContent("0"), "documentId");
                                formData.Add(new StringContent(documentName), "documentName");
                                formData.Add(new StringContent(fileName), "fileName");
                                formData.Add(new StringContent(""), "filePath"); // Empty or set as needed

                                var fileBytes = new byte[file.ContentLength];
                                await file.InputStream.ReadAsync(fileBytes, 0, file.ContentLength);
                                var fileContent = new ByteArrayContent(fileBytes);
                                fileContent.Headers.ContentType = System.Net.Http.Headers.MediaTypeHeaderValue.Parse(file.ContentType);
                                formData.Add(fileContent, "fileDoc", file.FileName);

                                StringBuilder formDataLog = new StringBuilder($"Document {documentName} Form Data Payload:\n");
                                foreach (var content in formData)
                                {
                                    var contentValue = content.Headers.ContentDisposition.FileName != null ? "[File]" : await content.ReadAsStringAsync();
                                    formDataLog.AppendLine($"{content.Headers.ContentDisposition.Name}: {contentValue}");
                                }
                                System.Diagnostics.Debug.WriteLine(formDataLog.ToString());

                                var response = await client.PostAsync(apiUrl, formData);
                                string result = await response.Content.ReadAsStringAsync();
                                System.Diagnostics.Debug.WriteLine($"PostTblDocumentDetail Response for {documentName}: StatusCode={response.StatusCode}, Content={result}");

                                if (!response.IsSuccessStatusCode)
                                {
                                    string errorMessage = "Unknown error";
                                    try
                                    {
                                        var jsonError = JsonSerializer.Deserialize<JsonElement>(result);
                                        errorMessage = jsonError.TryGetProperty("Status", out var status) ? status.GetString() : jsonError.TryGetProperty("errors", out var errors) ? errors.ToString() : jsonError.TryGetProperty("title", out var title) ? title.GetString() : result;
                                    }
                                    catch
                                    {
                                        errorMessage = result;
                                    }
                                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Error saving {documentName}: {errorMessage}');", true);
                                }
                            }
                        }
                        else
                        {

                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Exception in SaveIncidentDocuments: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Exception in SaveIncidentDocuments: {ex.StackTrace}");
            }
        }




    }
}