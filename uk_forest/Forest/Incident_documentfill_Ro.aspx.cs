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
using System.Text.Json;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JsonSerializer = System.Text.Json.JsonSerializer;

namespace uk_forest.Forest
{
    public partial class Incident_documentfill_Ro : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        private static readonly HttpClient client1 = new HttpClient();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    //DateTime today = DateTime.Today;
                    //DateTime firstDayOfMonth = new DateTime(today.Year, today.Month, 1);
                    //txtFromDate.Text = firstDayOfMonth.ToString("yyyy-MM-dd");
                    //txtToDate.Text = today.ToString("yyyy-MM-dd");

                    DateTime today = DateTime.Today;
                    DateTime startDate = today.AddYears(-1).AddDays(1); // 1 year ago + 1 day
                    txtFromDate.Text = startDate.ToString("yyyy-MM-dd"); // 2024-11-18
                    txtToDate.Text = today.ToString("yyyy-MM-dd");

                    /*  rblClaimType.SelectedValue = "Human"; */// sets "Human Death / Injury" ch

                    string userId = Session["UserId"]?.ToString();
                    Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                    string status = "Pending";
                    //rblClaimType.SelectedValue = "HumanDeath";

                    ViewState["ApplicantId"] = userId;

                    if (roleId != 10)
                    {
                        gv_incident_list.Columns[11].Visible = false;  // index adjust karna ho sakta hai
                    }

                    if (roleId == 10) // RO
                    {
                        status = "Pending, Advanced Approved by DFO";
                    }
                    else if (roleId == 9) //SDO
                    {
                        status = "Advanced Approved by Range Officer, Approved by Range Officer";
                    }
                    else if (roleId == 8) //DFO
                    {
                        status = "Advanced Approved by SDO, Approved by SDO";
                    }
                    else
                    {
                        status = "All";
                    }

                    string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

                    //BindUserGrid(userId, roleId, status);
                    BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void rblClaimType_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                switch (rblClaimType.SelectedValue)
                {
                    case "Human":
                        break;
                    case "Crop":
                        break;
                    case "Cattle":
                        break;
                    case "House":
                        break;
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected string FormatDate(object dateObj)
        {
            if (dateObj == null || dateObj == DBNull.Value || string.IsNullOrEmpty(dateObj.ToString()))
                return "-";
            return Convert.ToDateTime(dateObj).ToString("dd-MM-yyyy");
        }


        private void BindUserGrid(string userId, Int32 roleId, string status, string claimCategory, string fromdate, string todate)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    //string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetails_for_approval_authority" + $"?userId={userId}&status=Pending&role_id={roleId}";
                    string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsfor_ro" + $"?userId={userId}&status={status}&role_id={roleId}&claim_category={claimCategory}&fromdate={fromdate}&todate={todate}";
                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            string result = response.Content.ReadAsStringAsync().Result;

                            // JSON को पहले JArray में Deserialize करें
                            JArray jsonArray = JArray.Parse(result);

                            // DataTable बनाएं और केवल top-level fields add करें
                            DataTable dt = new DataTable();
                            dt.Columns.Add("victimId");
                            dt.Columns.Add("fullName");
                            dt.Columns.Add("age");
                            dt.Columns.Add("gender");
                            dt.Columns.Add("incidentId");
                            dt.Columns.Add("incidentDate");
                            dt.Columns.Add("incidentTime");
                            dt.Columns.Add("animalName");
                            dt.Columns.Add("localName");
                            dt.Columns.Add("status");
                            dt.Columns.Add("applicantName");
                            dt.Columns.Add("claimCategory");
                            dt.Columns.Add("applicantId");
                            dt.Columns.Add("incidentPlace");
                            dt.Columns.Add("incidentSummary");

                            foreach (var item in jsonArray)
                            {
                                DataRow row = dt.NewRow();
                                row["victimId"] = item["victimId"]?.ToString();
                                row["fullName"] = item["fullName"]?.ToString();
                                row["age"] = item["age"]?.ToString();
                                row["gender"] = item["gender"]?.ToString();
                                row["incidentId"] = item["incidentId"]?.ToString();
                                row["incidentDate"] = item["incidentDate"]?.ToString();
                                row["incidentTime"] = item["incidentTime"]?.ToString();
                                row["animalName"] = item["animalName"]?.ToString();
                                row["localName"] = item["localName"]?.ToString();
                                row["status"] = item["status"]?.ToString();
                                row["applicantName"] = item["applicantName"]?.ToString();
                                row["claimCategory"] = item["claimCategory"]?.ToString();
                                row["applicantId"] = item["applicantId"]?.ToString();
                                row["incidentPlace"] = item["incidentPlace"]?.ToString();
                                row["incidentSummary"] = item["incidentSummary"]?.ToString();
                                dt.Rows.Add(row);
                            }

                            if (dt.Rows.Count > 0)
                            {
                                gv_incident_list.DataSource = dt;
                                gv_incident_list.DataBind();
                                gv_incident_list.Visible = true;
                                lbl_msg_alert.Visible = false;
                            }
                            else
                            {
                                ShowNoRecordsMessage();
                            }
                        }
                        else if (response.StatusCode == HttpStatusCode.Created)
                        {
                            ShowNoRecordsMessage();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lbl_msg_alert.Visible = true;
                lbl_msg_alert.Text = $"Error: {ex.Message}";
                lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
                gv_incident_list.Visible = false;
            }
        }
        private void ShowNoRecordsMessage()
        {
            try
            {
                lbl_msg_alert.Visible = true;
                lbl_msg_alert.Text = "No Record Found...!!!";
                lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
                gv_incident_list.Visible = false;
            }
            catch (Exception ex)
            {

            }
        }


        protected void gv_incident_list_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Pending";
                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;
                BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);
            }
            catch (Exception ex)
            {

            }
        }

        private string GetDataForPopup(string incident_Id)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                var url = apiUrl + "TblVictimIncidents/GetVictimIncidentDetailsByIncidentId?incidentId=" + incident_Id;
                HttpResponseMessage response = client.GetAsync(url).Result;

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    return result;
                }
                else
                {
                    return "";
                }
            }
        }






        public string GetStatusClass(string status)
        {
            switch (status.ToLower())
            {
                case "pending": return "status-pending";
                case "approved": return "status-approved";
                case "rejected": return "status-rejected";
                default: return "";
            }
        }




        public string HostUrl => ConfigurationManager.AppSettings["BaseUrl"];






        protected bool IsPdfFile(string filePath)
        {
            if (string.IsNullOrEmpty(filePath)) return false;
            string ext = System.IO.Path.GetExtension(filePath).ToLower();
            return ext == ".pdf";
        }

        protected bool IsImageFile(string filePath)
        {
            if (string.IsNullOrEmpty(filePath)) return false;
            string ext = System.IO.Path.GetExtension(filePath).ToLower();
            return ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif";
        }

        protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    Repeater rptDocuments = (Repeater)e.Item.FindControl("Repeater2");

                    string documentsJson = ViewState["Documentss"]?.ToString();

                    if (!string.IsNullOrEmpty(documentsJson))
                    {
                        JArray documentArray = JArray.Parse(documentsJson);

                        var docs = documentArray.Select(d => new
                        {
                            sno = d["sno"]?.ToString(),
                            roleName = d["roleName"]?.ToString(),
                            documentName = d["documentName"]?.ToString(),
                            FilePath = d["filePath"]?.ToString(),
                            FullUrl = ResolveFilePath(d["filePath"]?.ToString())
                        }).ToList();

                        rptDocuments.DataSource = docs;
                        rptDocuments.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        private string ResolveFilePath(string relativePath)
        {
            if (string.IsNullOrEmpty(relativePath))
                return "";

            string baseUrl = ConfigurationManager.AppSettings["BaseUrl"];
            return baseUrl + relativePath.Replace("\\", "/");
        }

        private string GetDataForPopupDocumentVerify(string incident_Id)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                //string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={incident_Id}";

                int checkerRoleId = Convert.ToInt32(Session["RoleId"]);
                string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetails_By_IncidentId_Role?incidentId={incident_Id}&checkerRoleId={checkerRoleId}";


                HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    return result;
                }
                else
                {
                    return "";
                }
            }
        }

        //public string BaseUrl { get; set; } = "http://203.122.5.18:9008/uk_forest_web/";

        public string BaseUrl { get; set; } = "https://ukforestgis.in/";

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {

            }
            catch (Exception ex)
            {

            }
        }






        protected void gv_incident_list_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //if (e.Row.RowType == DataControlRowType.DataRow)
            //{
            //    Label lbl_incidentId = (Label)e.Row.FindControl("lbl_incidentId");
            //    LinkButton lnkRecommendation = (LinkButton)e.Row.FindControl("lnl_recommendation");
            //    LinkButton lnkDocuments = (LinkButton)e.Row.FindControl("lnkDocuments");

            //    if (lbl_incidentId != null)
            //    {
            //        string incidentId = lbl_incidentId.Text;

            //        // Check all documents
            //        bool allDocsVerified = AreAllDocumentsVerified(incidentId);

            //        // --- Update Recommendation button ---
            //        if (lnkRecommendation != null)
            //        {
            //            lnkRecommendation.Enabled = allDocsVerified;

            //            // Optional: make it visually disabled if not enabled
            //            if (allDocsVerified)
            //                lnkRecommendation.CssClass = "btn btn-primary";
            //            else
            //                lnkRecommendation.CssClass = "btn btn-disabled";
            //        }

            //        if (lnkDocuments != null)
            //        {
            //            if (allDocsVerified)
            //            {
            //                lnkDocuments.Text = "Verified";
            //                lnkDocuments.Style["background"] = "linear-gradient(135deg,#28a745 0%,#218838 100%)"; // green gradient
            //                lnkDocuments.Style["border"] = "1px solid #218838";
            //                lnkDocuments.Style["color"] = "white";
            //            }
            //            else
            //            {
            //                lnkDocuments.Text = "Verify";
            //                lnkDocuments.Style["background"] = "linear-gradient(135deg,#007bff 0%,#0056b3 100%)"; // original blue
            //                lnkDocuments.Style["border"] = "1px solid #007bff";
            //                lnkDocuments.Style["color"] = "white";
            //                lnkDocuments.Enabled = true;
            //            }
            //        }
            //    }
            //}
        }


        private List<Document> GetDocumentsFromApi(string incidentId)
        {
            string jsonResponse = GetDataForPopupDocumentVerify(incidentId);
            var jsonObj = JObject.Parse(jsonResponse); // full JSON object
            var documents = jsonObj["documents"].ToObject<List<Document>>();
            return documents;
        }


        private bool AreAllDocumentsVerified(string incidentId)
        {
            var documents = GetDocumentsFromApi(incidentId);

            // loop through each document
            foreach (var doc in documents)
            {
                if (!doc.overallStatus)
                {
                    // as soon as one document is false, return false
                    return false;
                }
            }

            // all documents were true
            return true;
        }


        public class Document
        {
            public string documentId { get; set; }
            public string documentName { get; set; }
            public string documentPath { get; set; }
            public string status { get; set; }

            // raw value from API (could be string or boolean)
            [JsonProperty("overallStatus")]
            public string overallStatusRaw { get; set; }

            [JsonIgnore]
            public bool overallStatus
            {
                get
                {
                    // safely parse true/false
                    if (bool.TryParse(overallStatusRaw, out bool result))
                        return result;

                    return false; // treat anything else as false
                }
            }
        }

























        protected void lnkuploaddocument_Click(object sender, EventArgs e)
        {
            try
            {



                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                // Retrieve incidentId and victimId from the GridView row
                Label lbl_incidentId = row.FindControl("lbl_incidentId") as Label;
                string incidentId = lbl_incidentId != null ? lbl_incidentId.Text.Trim() : string.Empty;

                Label lbl_victimId = row.FindControl("lbl_victimId") as Label;
                string victimId = lbl_victimId != null ? lbl_victimId.Text.Trim() : string.Empty;

                Label lblClaimCategory = row.FindControl("lbl_claimcategory") as Label;
                string claimCategory = lblClaimCategory != null ? lblClaimCategory.Text.Trim() : string.Empty;



                // Store victimId in hidden field
                hdnVictimId.Value = victimId;

                if (claimCategory == "Human")
                {
                    labelClaimCategory.Text = claimCategory;
                    labelIncidentID.Text = incidentId;
                    PanelDocument.Visible = true;
                    humandocuments.Visible = true;
                    cattledocument.Visible = false;
                    cropdamagedocuments.Visible = false;
                    housedamagedocument.Visible = false;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
                }
                else if (claimCategory == "Crop")
                {
                    labelClaimCategory.Text = claimCategory;
                    labelIncidentID.Text = incidentId;
                    PanelDocument.Visible = true;
                    cropdamagedocuments.Visible = true;
                    humandocuments.Visible = false;
                    housedamagedocument.Visible = false;
                    cattledocument.Visible = false;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
                }
                else if (claimCategory == "Cattle")
                {
                    labelClaimCategory.Text = claimCategory;
                    labelIncidentID.Text = incidentId;
                    PanelDocument.Visible = true;
                    cattledocument.Visible = true;
                    cropdamagedocuments.Visible = false;
                    humandocuments.Visible = false;
                    housedamagedocument.Visible = false;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
                }
                else if (claimCategory == "House")
                {
                    labelClaimCategory.Text = claimCategory;
                    labelIncidentID.Text = incidentId;
                    PanelDocument.Visible = true;
                    cattledocument.Visible = false;
                    cropdamagedocuments.Visible = false;
                    humandocuments.Visible = false;
                    housedamagedocument.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
                }
                else
                {
                    PanelDocument.Visible = false;
                }
            }
            catch (Exception ex)
            {
                lbl_msg_alert.Visible = true;
                lbl_msg_alert.Text = $"Error: {ex.Message}";
                lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
            }

        }

        protected void btnHumanDocumentsSave_Click(object sender, EventArgs e)
        {
            try
            {
                // Retrieve victimId and incidentId from hidden field and label
                string victimId = hdnVictimId.Value;
                string incidentId = labelIncidentID.Text;

                if (string.IsNullOrEmpty(incidentId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Error: Incident ID is missing.');", true);
                    return;
                }

                // Optionally validate victimId if required
                if (string.IsNullOrEmpty(victimId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Error: Victim ID is missing.');", true);
                    return;
                }

                using (var client = new HttpClient())
                {
                    string createdby = Session["Name"]?.ToString() ?? "";
                    string _apiUrl = apiUrl + "TblDocumentDetails/PostTblDocumentDetail";
                    List<(FileUpload, string, string)> fileUploads = new List<(FileUpload, string, string)>
            {
                (MedicalCertificate, "MedicalCertificate", MedicalCertificate.FileName),
                (DeathCertificate, "DeathCertificate", DeathCertificate.FileName),
                (LegalHeirCertificate, "LegalHeirCertificate", LegalHeirCertificate.FileName),
                (AdditionalPhotographs, "AdditionalPhotographs", AdditionalPhotographs.FileName)
            };

                    string roleId = Session["RoleId"]?.ToString() ?? "";
                    string userId = Session["UserId"]?.ToString() ?? "";

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
                                // Add metadata
                                formData.Add(new StringContent("0"), "sno");
                                formData.Add(new StringContent(incidentId), "incidentId");
                                formData.Add(new StringContent(createdby), "CreatedBy");
                                formData.Add(new StringContent(roleId), "UploadedByRoleId");
                                formData.Add(new StringContent(userId), "UploadedByUserId");
                                formData.Add(new StringContent("0"), "documentId");
                                formData.Add(new StringContent(documentName), "documentName");
                                formData.Add(new StringContent(fileName), "fileName");
                                formData.Add(new StringContent(""), "filePath");

                                // Add victimId if required by the API
                                formData.Add(new StringContent(victimId), "victimId");

                                // Add file
                                var fileBytes = new byte[file.ContentLength];
                                file.InputStream.Read(fileBytes, 0, file.ContentLength); // Synchronous read
                                var fileContent = new ByteArrayContent(fileBytes);
                                fileContent.Headers.ContentType = System.Net.Http.Headers.MediaTypeHeaderValue.Parse(file.ContentType);
                                formData.Add(fileContent, "fileDoc", file.FileName);

                                // Log form data for debugging
                                StringBuilder formDataLog = new StringBuilder($"Document {documentName} Form Data Payload:\n");
                                foreach (var content in formData)
                                {
                                    // Synchronous read for logging
                                    var contentValue = content.Headers.ContentDisposition.FileName != null ? "[File]" : content.ReadAsStringAsync().GetAwaiter().GetResult();
                                    formDataLog.AppendLine($"{content.Headers.ContentDisposition.Name}: {contentValue}");
                                }
                                System.Diagnostics.Debug.WriteLine(formDataLog.ToString());

                                // API call (synchronous)
                                var response = client.PostAsync(_apiUrl, formData).GetAwaiter().GetResult();
                                string result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                                System.Diagnostics.Debug.WriteLine($"PostTblDocumentDetail Response for {documentName}: StatusCode={response.StatusCode}, Content={result}");

                                if (!response.IsSuccessStatusCode)
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
                                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Error saving {documentName}: {errorMessage}');", true);

                                }
                            }
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"No file uploaded for {documentName}");
                            // Optionally, show a warning if a required document is missing
                            // ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Warning: No file uploaded for {documentName}.');", true);
                        }
                    }

                    // Hide the form after saving
                    humandocuments.Visible = false;
                    PanelDocument.Visible = false;

                    // Refresh the GridView to reflect any status updates
                    //BindUserGrid(Session["ApplicantId"]?.ToString() ?? "");
                    string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;
                    //   BindUserGrid(Session["UserId"]?.ToString() ?? "", claim_category, txtFromDate.Text, txtToDate.Text);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Exception in SaveHumanDocuments: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Exception in SaveHumanDocuments: {ex.StackTrace}");
            }
        }




        protected void btnCattleDocumentsSave_Click1(object sender, EventArgs e)
        {
            try
            {
                // Retrieve incidentId from label
                string incidentId = labelIncidentID.Text;

                if (string.IsNullOrEmpty(incidentId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Error: Incident ID is missing.');", true);
                    return;
                }

                using (var client = new HttpClient())
                {
                    string createdby = Session["Name"]?.ToString() ?? "";
                    string _apiUrl = apiUrl + "TblDocumentDetails/PostTblDocumentDetail";
                    List<(FileUpload, string, string)> fileUploads = new List<(FileUpload, string, string)>
            {
                (VeterinaryOfficer, "VeterinaryOfficer", VeterinaryOfficer.FileName),
                (Panchnama, "Panchnama", Panchnama.FileName),
                (cattleAdditionalPhotographs, "AdditionalPhotographs", cattleAdditionalPhotographs.FileName)
            };

                    string roleId = Session["RoleId"]?.ToString() ?? "";
                    string userId = Session["UserId"]?.ToString() ?? "";

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
                                // Add metadata
                                formData.Add(new StringContent("0"), "sno");
                                formData.Add(new StringContent(incidentId), "incidentId");
                                formData.Add(new StringContent(createdby), "CreatedBy");
                                formData.Add(new StringContent(roleId), "UploadedByRoleId");
                                formData.Add(new StringContent(userId), "UploadedByUserId");
                                formData.Add(new StringContent("0"), "documentId");
                                formData.Add(new StringContent(documentName), "documentName");
                                formData.Add(new StringContent(fileName), "fileName");
                                formData.Add(new StringContent(""), "filePath");

                                // Add file
                                var fileBytes = new byte[file.ContentLength];
                                file.InputStream.Read(fileBytes, 0, file.ContentLength);
                                var fileContent = new ByteArrayContent(fileBytes);
                                fileContent.Headers.ContentType = System.Net.Http.Headers.MediaTypeHeaderValue.Parse(file.ContentType);
                                formData.Add(fileContent, "fileDoc", file.FileName);

                                // Log form data for debugging
                                StringBuilder formDataLog = new StringBuilder($"Document {documentName} Form Data Payload:\n");
                                foreach (var content in formData)
                                {
                                    var contentValue = content.Headers.ContentDisposition.FileName != null ? "[File]" : content.ReadAsStringAsync().GetAwaiter().GetResult();
                                    formDataLog.AppendLine($"{content.Headers.ContentDisposition.Name}: {contentValue}");
                                }
                                System.Diagnostics.Debug.WriteLine(formDataLog.ToString());

                                // API call (synchronous)
                                var response = client.PostAsync(_apiUrl, formData).GetAwaiter().GetResult();
                                string result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                                System.Diagnostics.Debug.WriteLine($"PostTblDocumentDetail Response for {documentName}: StatusCode={response.StatusCode}, Content={result}");

                                if (!response.IsSuccessStatusCode)
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
                                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Error saving {documentName}: {errorMessage}');", true);
                                }
                            }
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"No file uploaded for {documentName}");
                        }
                    }

                    // Hide the form after saving
                    cattledocument.Visible = false;
                    PanelDocument.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Exception in SaveCattleDocuments: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Exception in SaveCattleDocuments: {ex.StackTrace}");
            }
        }

        protected void btn_add_crop_damage_dcoument_Click(object sender, EventArgs e)
        {
            try
            {
                // Retrieve incidentId from label
                string incidentId = labelIncidentID.Text;

                if (string.IsNullOrEmpty(incidentId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Error: Incident ID is missing.');", true);
                    return;
                }

                using (var client = new HttpClient())
                {
                    string createdby = Session["Name"]?.ToString() ?? "";
                    string _apiUrl = apiUrl + "TblDocumentDetails/PostTblDocumentDetail";
                    List<(FileUpload, string, string)> fileUploads = new List<(FileUpload, string, string)>
            {
                (khatakhatoni, "KhataKhatoni", khatakhatoni.FileName),
                (khatakhatoniAdditionalPhotographs, "AdditionalPhotographs", khatakhatoniAdditionalPhotographs.FileName)
            };

                    string roleId = Session["RoleId"]?.ToString() ?? "";
                    string userId = Session["UserId"]?.ToString() ?? "";

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
                                // Add metadata
                                formData.Add(new StringContent("0"), "sno");
                                formData.Add(new StringContent(incidentId), "incidentId");
                                formData.Add(new StringContent(createdby), "CreatedBy");
                                formData.Add(new StringContent(roleId), "UploadedByRoleId");
                                formData.Add(new StringContent(userId), "UploadedByUserId");
                                formData.Add(new StringContent("0"), "documentId");
                                formData.Add(new StringContent(documentName), "documentName");
                                formData.Add(new StringContent(fileName), "fileName");
                                formData.Add(new StringContent(""), "filePath");

                                // Add file
                                var fileBytes = new byte[file.ContentLength];
                                file.InputStream.Read(fileBytes, 0, file.ContentLength);
                                var fileContent = new ByteArrayContent(fileBytes);
                                fileContent.Headers.ContentType = System.Net.Http.Headers.MediaTypeHeaderValue.Parse(file.ContentType);
                                formData.Add(fileContent, "fileDoc", file.FileName);

                                // Log form data for debugging
                                StringBuilder formDataLog = new StringBuilder($"Document {documentName} Form Data Payload:\n");
                                foreach (var content in formData)
                                {
                                    var contentValue = content.Headers.ContentDisposition.FileName != null ? "[File]" : content.ReadAsStringAsync().GetAwaiter().GetResult();
                                    formDataLog.AppendLine($"{content.Headers.ContentDisposition.Name}: {contentValue}");
                                }
                                System.Diagnostics.Debug.WriteLine(formDataLog.ToString());

                                // API call (synchronous)
                                var response = client.PostAsync(_apiUrl, formData).GetAwaiter().GetResult();
                                string result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                                System.Diagnostics.Debug.WriteLine($"PostTblDocumentDetail Response for {documentName}: StatusCode={response.StatusCode}, Content={result}");

                                if (!response.IsSuccessStatusCode)
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
                                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Error saving {documentName}: {errorMessage}');", true);
                                }
                            }
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"No file uploaded for {documentName}");
                        }
                    }

                    // Hide the form after saving
                    cropdamagedocuments.Visible = false;
                    PanelDocument.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Exception in SaveCropDamageDocuments: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Exception in SaveCropDamageDocuments: {ex.StackTrace}");
            }
        }

        protected void btn_add_damegehouse_document_Click(object sender, EventArgs e)
        {
            try
            {
                // Retrieve incidentId from label
                string incidentId = labelIncidentID.Text;

                if (string.IsNullOrEmpty(incidentId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Error: Incident ID is missing.');", true);
                    return;
                }

                using (var client = new HttpClient())
                {
                    string createdby = Session["Name"]?.ToString() ?? "";
                    string _apiUrl = apiUrl + "TblDocumentDetails/PostTblDocumentDetail";
                    List<(FileUpload, string, string)> fileUploads = new List<(FileUpload, string, string)>
            {
                (khatakhatoniHousepropertyAdditionalPhotographs, "KhataKhatoniHouseProperty", khatakhatoniHousepropertyAdditionalPhotographs.FileName),
                (khatakhatoniHouseAdditionalPhotographs, "AdditionalPhotographs", khatakhatoniHouseAdditionalPhotographs.FileName)
            };

                    string roleId = Session["RoleId"]?.ToString() ?? "";
                    string userId = Session["UserId"]?.ToString() ?? "";

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
                                // Add metadata
                                formData.Add(new StringContent("0"), "sno");
                                formData.Add(new StringContent(incidentId), "incidentId");
                                formData.Add(new StringContent(createdby), "CreatedBy");
                                formData.Add(new StringContent(roleId), "UploadedByRoleId");
                                formData.Add(new StringContent(userId), "UploadedByUserId");
                                formData.Add(new StringContent("0"), "documentId");
                                formData.Add(new StringContent(documentName), "documentName");
                                formData.Add(new StringContent(fileName), "fileName");
                                formData.Add(new StringContent(""), "filePath");

                                // Add file
                                var fileBytes = new byte[file.ContentLength];
                                file.InputStream.Read(fileBytes, 0, file.ContentLength);
                                var fileContent = new ByteArrayContent(fileBytes);
                                fileContent.Headers.ContentType = System.Net.Http.Headers.MediaTypeHeaderValue.Parse(file.ContentType);
                                formData.Add(fileContent, "fileDoc", file.FileName);

                                // Log form data for debugging
                                StringBuilder formDataLog = new StringBuilder($"Document {documentName} Form Data Payload:\n");
                                foreach (var content in formData)
                                {
                                    var contentValue = content.Headers.ContentDisposition.FileName != null ? "[File]" : content.ReadAsStringAsync().GetAwaiter().GetResult();
                                    formDataLog.AppendLine($"{content.Headers.ContentDisposition.Name}: {contentValue}");
                                }
                                System.Diagnostics.Debug.WriteLine(formDataLog.ToString());

                                // API call (synchronous)
                                var response = client.PostAsync(_apiUrl, formData).GetAwaiter().GetResult();
                                string result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                                System.Diagnostics.Debug.WriteLine($"PostTblDocumentDetail Response for {documentName}: StatusCode={response.StatusCode}, Content={result}");

                                if (!response.IsSuccessStatusCode)
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
                                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Error saving {documentName}: {errorMessage}');", true);
                                }
                            }
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"No file uploaded for {documentName}");
                        }
                    }

                    // Hide the form after saving
                    housedamagedocument.Visible = false;
                    PanelDocument.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('Exception in SaveHouseDamageDocuments: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Exception in SaveHouseDamageDocuments: {ex.StackTrace}");
            }
        }
    }
}