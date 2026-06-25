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
using static uk_forest.ApiHelper;
using JsonSerializer = System.Text.Json.JsonSerializer;

namespace uk_forest.Forest
{
    public partial class victimincidentlist : System.Web.UI.Page
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
                    //DateTime today = DateTime.Today;
                    //DateTime firstDayOfYear = new DateTime(today.Year, 1, 1);

                    //txtFromDate.Text = firstDayOfYear.ToString("yyyy-MM-dd");
                    //txtToDate.Text = today.ToString("yyyy-MM-dd");

                    DateTime today = DateTime.Today;
                    DateTime startDate = today.AddYears(-1).AddDays(1); // 1 year ago + 1 day
                    txtFromDate.Text = startDate.ToString("yyyy-MM-dd"); // 2024-11-18
                    txtToDate.Text = today.ToString("yyyy-MM-dd");


                    rblClaimType.SelectedValue = "HumanDeath";

                    string applicantId = Session["UserId"].ToString();

                    lblapplicantid.Text = applicantId;
                    ViewState["ApplicantId"] = applicantId;
                    //BindUserGrid(applicantId);
                    string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;
                    BindUserGrid(applicantId, claim_category, txtFromDate.Text, txtToDate.Text);
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void btnClosePopup_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HidePopup", "hidePopup();", true);
        }

        protected void rblClaimType_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                switch (rblClaimType.SelectedValue)
                {
                    case "HumanDeath":
                        break;
                    case "CropField":
                        break;
                    case "CattleKill":
                        break;
                    case "HouseDamage":
                        break;
                }

                string applicantId = Session["UserId"].ToString();
                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;
                BindUserGrid(applicantId, claim_category, txtFromDate.Text, txtToDate.Text);

            }
            catch (Exception ex)
            {

            }
        }

        private void BindUserGrid(string applicantId, string claimCategory, string fromdate, string todate)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = client.GetAsync($"{_apiUrl}TblIncidentDetails/GetTblIncidentDetail_byApplicantId_claim_date?applicant_id={applicantId}&claim_category={claimCategory}&fromdate={fromdate}&todate={todate}").Result;

                    if (response.IsSuccessStatusCode)
                    {
                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            string result = response.Content.ReadAsStringAsync().Result;
                            DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                            if (dt != null && dt.Rows.Count > 0)
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
                    else
                    {
                        ShowNoRecordsMessage();
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


        protected void gv_incident_list_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    Label lblStatus = (Label)e.Row.FindControl("lbl_status");
                    if (lblStatus != null)
                    {
                        string status = lblStatus.Text.Trim().ToLower();

                        if (status.Contains("returned"))
                        {
                            lblStatus.ForeColor = System.Drawing.Color.Red;
                            lblStatus.Font.Bold = true;
                        }
                        else if (status.Contains("approved"))
                        {
                            lblStatus.ForeColor = System.Drawing.Color.Green;
                            lblStatus.Font.Bold = true;
                        }
                        else if (status.Contains("verified"))
                        {
                            lblStatus.ForeColor = System.Drawing.Color.Green;
                            lblStatus.Font.Bold = true;
                        }
                        else if (status.Equals("Application Re-Submission", StringComparison.OrdinalIgnoreCase))
                        {
                            lblStatus.ForeColor = System.Drawing.Color.Orange;
                            lblStatus.Font.Bold = true;
                        }

                        else if (status.Equals("Payment processed successfully", StringComparison.OrdinalIgnoreCase))
                        {
                            lblStatus.ForeColor = System.Drawing.Color.Green;
                            lblStatus.Font.Bold = true;
                        }
                        else
                        {
                            lblStatus.ForeColor = System.Drawing.Color.Black;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Optionally log exception
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

            }
            catch (Exception ex)
            {

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;
                BindUserGrid(Session["UserId"]?.ToString() ?? "", claim_category, txtFromDate.Text, txtToDate.Text);
            }
            catch (Exception ex)
            {

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


        protected bool IsImageFile(string filePath)
        {
            if (string.IsNullOrEmpty(filePath))
                return false;

            string extension = System.IO.Path.GetExtension(filePath)?.ToLower();
            return extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".gif" || extension == ".webp";
        }




        private string GetDataForPopup(string incident_Id)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                var url = _apiUrl + "TblIncidentDetails/GetIncidentDetailsByIncidentId_return?incidentId=" + incident_Id;
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


        private void FetchAndDisplayIncidentDetails(string incidentId)
        {
            try
            {
                using (WebClient client = new WebClient())
                {
                    // API URL
                    string apiUrl = $"http://203.122.5.18:9008/uk_forest_api/api/TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={incidentId}";
                    string jsonResponse = client.DownloadString(apiUrl); // Synchronous call
                    JObject jsonData = JObject.Parse(jsonResponse);

                    // Base URL for documents (adjust this to your actual base URL)
                    //string baseDocumentUrl = "http://203.122.5.18:9008/uk_forest_web/"; // Example base URL, modify as needed
                    string baseDocumentUrl = "https://ukforestgis.in/"; // Example base URL, modify as needed
                                                                                       

                    // Format the data into sections
                    string displayText = "<div class='section'><h3>Victim Details</h3>" +
                                        $"<p><b>Victim ID:</b> {jsonData["victimId"]}</p>" +
                                        $"<p><b>Full Name:</b> {jsonData["fullName"]}</p>" +
                                        $"<p><b>Age:</b> {jsonData["age"]}</p>" +
                                        $"<p><b>Gender:</b> {jsonData["gender"]}</p>" +
                                        $"<p><b>Aadhar No:</b> {jsonData["aadharNo"]}</p>" +
                                        $"<p><b>Aadhar Document:</b> <a href='{baseDocumentUrl}{jsonData["aadharDoc"].ToString().Replace("\\", "/")}' target='_blank'>View Aadhar</a></p></div>" +

                                        "<div class='section'><h3>Incident Details</h3>" +
                                        $"<p><b>Incident ID:</b> {jsonData["incidentId"]}</p>" +
                                        $"<p><b>Incident Date:</b> {jsonData["incidentDate"]}</p>" +
                                        $"<p><b>Incident Time:</b> {jsonData["incidentTime"]}</p>" +
                                        $"<p><b>Incident Place:</b> {(jsonData["incidentPlace"]?.ToString() ?? "N/A")}</p>" +
                                        $"<p><b>Animal ID:</b> {jsonData["animalId"]}</p>" +
                                        $"<p><b>Animal Name:</b> {jsonData["animalName"]}</p>" +
                                        $"<p><b>Local Name:</b> {jsonData["localName"]}</p>" +
                                        $"<p><b>Latitude:</b> {jsonData["latitude"]}</p>" +
                                        $"<p><b>Longitude:</b> {jsonData["longitude"]}</p>" +
                                        $"<p><b>Status:</b> {jsonData["status"]}</p>" +
                                        $"<p><b>Range ID:</b> {jsonData["rangeId"]}</p>" +
                                        $"<p><b>Range Name:</b> {jsonData["rangeName"]}</p>" +
                                        $"<p><b>Incident Summary:</b> {jsonData["incidentSummary"]?.ToString().Replace("\r\n", "<br/>")}</p>" +
                                        $"<p><b>Conflict Category:</b> {jsonData["conflictCategory"]}</p>" +
                                        $"<p><b>Remark:</b> {jsonData["remark"]}</p></div>" +

                                        "<div class='section'><h3>Applicant Details</h3>" +
                                        $"<p><b>Applicant ID:</b> {jsonData["applicantId"]}</p>" +
                                        $"<p><b>Applicant Name:</b> {jsonData["applicantName"]}</p>" +
                                        $"<p><b>Mobile No:</b> {jsonData["mobileNo"]}</p>" +
                                        $"<p><b>Applicant Aadhar No:</b> {jsonData["applicantAadharNo"]}</p>" +
                                        $"<p><b>Applicant Aadhar Document:</b> <a href='{baseDocumentUrl}{jsonData["applicantAadharDoc"].ToString().Replace("\\", "/")}' target='_blank'>View Applicant Aadhar</a></p></div>" +

                                        "<div class='section'><h3>Bank Details</h3>" +
                                        $"<p><b>Beneficiary ID:</b> {jsonData["beneficiaryId"]}</p>" +
                                        $"<p><b>Bank Name:</b> {jsonData["bankName"]}</p>" +
                                        $"<p><b>Account Number:</b> {jsonData["accNumber"]}</p>" +
                                        $"<p><b>Account Holder Name:</b> {jsonData["accHolderName"]}</p>" +
                                        $"<p><b>Bank Document:</b> <a href='{baseDocumentUrl}{jsonData["bankDoc"].ToString().Replace("\\", "/")}' target='_blank'>View Bank Document</a></p></div>" +

                                        "<div class='section'><h3>Documents</h3>";
                    JArray documents = (JArray)jsonData["documents"];
                    if (documents != null && documents.Count > 0)
                    {
                        displayText += "<ul>";
                        foreach (JObject doc in documents)
                        {
                            string docPath = doc["documentPath"].ToString().Replace("\\", "/");
                            // Check if the document is an image (jpg, png, etc.) for embedding
                            bool isImage = docPath.EndsWith(".jpg", StringComparison.OrdinalIgnoreCase) ||
                                           docPath.EndsWith(".png", StringComparison.OrdinalIgnoreCase) ||
                                           docPath.EndsWith(".jpeg", StringComparison.OrdinalIgnoreCase);
                            string docDisplay = isImage
                                ? $"<img src='{baseDocumentUrl}{docPath}' alt='{doc["documentName"]}' style='max-width:200px; display:block; margin-top:5px;' />"
                                : $"<a href='{baseDocumentUrl}{docPath}' target='_blank'>View Document</a>";

                            displayText += $"<li><b>Document ID:</b> {doc["documentId"]}<br/>" +
                                           $"<b>Document Name:</b> {doc["documentName"]}<br/>" +
                                           $"<b>Document Type:</b> {(doc["documentType"]?.ToString() ?? "N/A")}<br/>" +
                                           $"<b>Document:</b> {docDisplay}<br/>" +
                                           $"<b>Uploaded By Role ID:</b> {doc["uploadedByRoleId"]}<br/>" +
                                           $"<b>User ID:</b> {doc["userId"]}</li><br/>";
                        }
                        displayText += "</ul>";
                    }
                    else
                    {
                        displayText += "<p>No documents available.</p>";
                    }
                    displayText += "</div>";

                    // Set the label text and show the panel
                    pnlInfo.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPopup();", true);
                }
            }
            catch (Exception ex)
            {
                pnlInfo.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPopup();", true);
            }
        }
        //protected void ddl_status_approved_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        DropDownList ddl = (DropDownList)sender;
        //        GridViewRow row = (GridViewRow)ddl.NamingContainer;

        //        // Retrieve incidentId and victimId from the GridView row
        //        Label lbl_incidentId = row.FindControl("lbl_incidentId") as Label;
        //        string incidentId = lbl_incidentId != null ? lbl_incidentId.Text.Trim() : string.Empty;

        //        Label lbl_victimId = row.FindControl("lbl_victimId") as Label;
        //        string victimId = lbl_victimId != null ? lbl_victimId.Text.Trim() : string.Empty;

        //        Label lblClaimCategory = row.FindControl("lbl_claimcategory") as Label;
        //        string claimCategory = lblClaimCategory != null ? lblClaimCategory.Text.Trim() : string.Empty;

        //        string selectedAction = ddl.SelectedValue;

        //        if (selectedAction == "View")
        //        {
        //            PanelDocument.Visible = false;
        //            string jsonData = GetDataForPopup(incidentId);

        //            if (!string.IsNullOrEmpty(jsonData))
        //            {
        //                JObject jsonObject = JObject.Parse(jsonData);

        //                DataTable mainDt = new DataTable();
        //                mainDt.Columns.Add("victimProfileId", typeof(string));
        //                mainDt.Columns.Add("name", typeof(string));
        //                mainDt.Columns.Add("gender", typeof(string));
        //                mainDt.Columns.Add("aadharNo", typeof(string));
        //                mainDt.Columns.Add("aadharDoc", typeof(string));
        //                mainDt.Columns.Add("incidentId", typeof(string));
        //                mainDt.Columns.Add("applicantId", typeof(string));
        //                mainDt.Columns.Add("incidentPlace", typeof(string));
        //                mainDt.Columns.Add("activity", typeof(string));
        //                mainDt.Columns.Add("status", typeof(string));
        //                mainDt.Columns.Add("incidentSummary", typeof(string));
        //                mainDt.Columns.Add("humanLoss", typeof(string));
        //                mainDt.Columns.Add("animalName", typeof(string));
        //                mainDt.Columns.Add("rangeName", typeof(string));
        //                mainDt.Columns.Add("applicantName", typeof(string));
        //                mainDt.Columns.Add("bankId", typeof(string));
        //                mainDt.Columns.Add("bankName", typeof(string));
        //                mainDt.Columns.Add("accNumber", typeof(string));
        //                mainDt.Columns.Add("accHolderName", typeof(string));
        //                mainDt.Columns.Add("bankDoc", typeof(string));
        //                mainDt.Columns.Add("applicantAadharNo", typeof(string));
        //                mainDt.Columns.Add("applicantAadharDoc", typeof(string));
        //                //mainDt.Columns.Add("age", typeof(int));
        //                mainDt.Columns.Add("latitude", typeof(decimal));
        //                mainDt.Columns.Add("longitude", typeof(decimal));
        //                mainDt.Columns.Add("incidentDate", typeof(DateTime));
        //                mainDt.Columns.Add("incidentTime", typeof(string));

        //                mainDt.Columns.Add("victimName", typeof(string));
        //                mainDt.Columns.Add("victimAge", typeof(int));
        //                mainDt.Columns.Add("victimGender", typeof(string));
        //                mainDt.Columns.Add("victimAadharNo", typeof(string));
        //                mainDt.Columns.Add("victimAadharDoc", typeof(string));

        //                DataRow rowx = mainDt.NewRow();

        //                foreach (DataColumn col in mainDt.Columns)
        //                {
        //                    JToken token = jsonObject[col.ColumnName];

        //                    if (token == null || token.Type == JTokenType.Null)
        //                    {
        //                        rowx[col.ColumnName] = DBNull.Value;
        //                    }
        //                    else
        //                    {
        //                        Type targetType = col.DataType;

        //                        if (targetType == typeof(int))
        //                            rowx[col.ColumnName] = token.ToObject<int>();
        //                        else if (targetType == typeof(decimal))
        //                            rowx[col.ColumnName] = token.ToObject<decimal>();
        //                        else if (targetType == typeof(DateTime))
        //                            rowx[col.ColumnName] = token.ToObject<DateTime>();
        //                        else if (targetType == typeof(bool))
        //                            rowx[col.ColumnName] = token.ToObject<bool>();
        //                        else
        //                            rowx[col.ColumnName] = token.ToString();
        //                    }
        //                }

        //                mainDt.Rows.Add(rowx);

        //                // Store documents for nested Repeater
        //                ViewState["documents"] = jsonObject["documents"]?.ToString() ?? "";

        //                rptIncidentDetails.DataSource = mainDt;
        //                rptIncidentDetails.DataBind();


        //                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopup();", true);
        //            }
        //            if (claimCategory == "Human")
        //            {
        //                GetDataForPopup(incidentId);
        //                pnlInfo.Visible = true;
        //                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPopup();", true);
        //            }
        //            else if (claimCategory == "Crop")
        //            {
        //                pnlInfo.Visible = true;
        //                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showCropPopup();", true);
        //            }
        //            else
        //            {
        //                pnlInfo.Visible = false;
        //            }
        //        }
        //        else if (selectedAction == "UploadDocuments")
        //        {
        //            pnlInfo.Visible = false;
        //            // Store victimId in hidden field
        //            hdnVictimId.Value = victimId;

        //            if (claimCategory == "Human")
        //            {
        //                labelClaimCategory.Text = claimCategory;
        //                labelIncidentID.Text = incidentId;
        //                PanelDocument.Visible = true;
        //                humandocuments.Visible = true;
        //                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
        //            }
        //            else if (claimCategory == "Crop")
        //            {
        //                labelClaimCategory.Text = claimCategory;
        //                labelIncidentID.Text = incidentId;
        //                PanelDocument.Visible = true;
        //                cropdamagedocuments.Visible = true;
        //                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
        //            }
        //            else if (claimCategory == "Cattle")
        //            {
        //                labelClaimCategory.Text = claimCategory;
        //                labelIncidentID.Text = incidentId;
        //                PanelDocument.Visible = true;
        //                cattledocument.Visible = true;
        //                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
        //            }
        //            else if (claimCategory == "House")
        //            {
        //                labelClaimCategory.Text = claimCategory;
        //                labelIncidentID.Text = incidentId;
        //                PanelDocument.Visible = true;
        //                housedamagedocument.Visible = true;
        //                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
        //            }
        //            else
        //            {
        //                PanelDocument.Visible = false;
        //            }
        //        }
        //        else if (selectedAction == "Edite")
        //        {
        //            string applicantId = Session["UserId"].ToString();
        //            Response.Redirect("EditeVictimInsidentList.aspx?incidentId=" + applicantId, false);
        //            Context.ApplicationInstance.CompleteRequest();
        //        }
        //        else
        //        {
        //            pnlInfo.Visible = false;
        //            PanelDocument.Visible = false;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        lbl_msg_alert.Visible = true;
        //        lbl_msg_alert.Text = $"Error: {ex.Message}";
        //        lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
        //    }
        //}
   
        protected bool IsPdfFile(string filePath)
        {
            if (string.IsNullOrEmpty(filePath)) return false;
            string ext = System.IO.Path.GetExtension(filePath).ToLower();
            return ext == ".pdf";
        }


        protected string FormatDate(object dateObj)
        {
            if (dateObj == null || dateObj == DBNull.Value || string.IsNullOrEmpty(dateObj.ToString()))
                return "-";
            return Convert.ToDateTime(dateObj).ToString("dd-MM-yyyy");
        }

        protected void rptIncidentDetails_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    Repeater rptDocuments = (Repeater)e.Item.FindControl("rptDocuments");

                    if (ViewState["documents"] != null)
                    {
                        string documentsJson = ViewState["documents"].ToString();
                        JArray documents = JArray.Parse(documentsJson);

                        DataTable dtDocuments = new DataTable();
                        dtDocuments.Columns.Add("DocumentId");
                        dtDocuments.Columns.Add("RoleId");
                        dtDocuments.Columns.Add("UserId");
                        dtDocuments.Columns.Add("documentPath");
                        dtDocuments.Columns.Add("FullUrl"); // New column for full URL
                        dtDocuments.Columns.Add("documentName");
                        dtDocuments.Columns.Add("comments");
                        dtDocuments.Columns.Add("status");


                        string baseUrl = ConfigurationManager.AppSettings["BaseUrl"];

                        foreach (JToken doc in documents)
                        {
                            DataRow row = dtDocuments.NewRow();
                            row["DocumentId"] = doc["documentId"]?.ToString();
                            row["RoleId"] = doc["roleId"]?.ToString();
                            row["UserId"] = doc["userId"]?.ToString();
                            row["documentPath"] = doc["documentPath"]?.ToString();
                            row["documentName"] = doc["documentName"]?.ToString();
                            row["FullUrl"] = baseUrl + doc["documentPath"]?.ToString();
                            row["comments"] = doc["comments"]?.ToString();
                            row["status"] = doc["status"]?.ToString();
                            dtDocuments.Rows.Add(row);

                        }

                        rptDocuments.DataSource = dtDocuments;
                        rptDocuments.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the error if needed
            }
        }



        protected void btnHumanDocumentsSave_Click(object sender, EventArgs e)
        {
            try
            {
                string victimId = hdnVictimId.Value;
                string incidentId = labelIncidentID.Text;

                if (string.IsNullOrEmpty(incidentId))
                {
                    ShowSwal("error", "Missing Information", "Incident ID is missing.");
                    return;
                }

                if (string.IsNullOrEmpty(victimId))
                {
                    ShowSwal("error", "Missing Information", "Victim ID is missing.");
                    return;
                }

                using (var client = new HttpClient())
                {
                    string createdby = Session["Name"]?.ToString() ?? "";
                    string apiUrl = _apiUrl + "TblDocumentDetails/PostTblDocumentDetail";
                    var fileUploads = new List<(FileUpload, string, string)>
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
                                ShowSwal("warning", "File Too Large", $"{documentName} file exceeds 2 MB limit.");
                                continue;
                            }

                            using (var formData = new MultipartFormDataContent())
                            {
                                formData.Add(new StringContent("0"), "sno");
                                formData.Add(new StringContent(incidentId), "incidentId");
                                formData.Add(new StringContent(createdby), "CreatedBy");
                                formData.Add(new StringContent(roleId), "UploadedByRoleId");
                                formData.Add(new StringContent(userId), "UploadedByUserId");
                                formData.Add(new StringContent("0"), "documentId");
                                formData.Add(new StringContent(documentName), "documentName");
                                formData.Add(new StringContent(fileName), "fileName");
                                formData.Add(new StringContent(""), "filePath");
                                formData.Add(new StringContent(victimId), "victimId");

                                var fileBytes = new byte[file.ContentLength];
                                file.InputStream.Read(fileBytes, 0, file.ContentLength);
                                var fileContent = new ByteArrayContent(fileBytes);
                                fileContent.Headers.ContentType = System.Net.Http.Headers.MediaTypeHeaderValue.Parse(file.ContentType);
                                formData.Add(fileContent, "fileDoc", file.FileName);

                                var response = client.PostAsync(apiUrl, formData).GetAwaiter().GetResult();
                                string result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                                if (!response.IsSuccessStatusCode)
                                {
                                    ShowSwal("error", "Upload Failed", $"Error saving {documentName}: {result}");
                                }
                            }
                        }
                    }

                    humandocuments.Visible = false;
                    PanelDocument.Visible = false;

                    ShowSwal("success", "Success", "All human documents uploaded successfully.");
                }
            }
            catch (Exception ex)
            {
                ShowSwal("error", "Exception", $"Error: {ex.Message}");
            }
        }

       
        // ✅ Common method for SweetAlert popup
        private void ShowSwal(string icon, string title, string message)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "swal", $@"
        Swal.fire({{
            icon: '{icon}',
            title: '{title}',
            text: '{message.Replace("'", "")}',
            confirmButtonText: 'OK'
        }});
    ", true);
        }



        protected void lnkuploaddocument_Click(object sender, EventArgs e)
        {
            try
            {

                pnlInfo.Visible = false;
                PanelDocument.Visible = true;
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                // Retrieve incidentId and victimId from the GridView row
                Label lbl_incidentId = row.FindControl("lbl_incidentId") as Label;
                string incidentId = lbl_incidentId != null ? lbl_incidentId.Text.Trim() : string.Empty;

                Label lbl_victimId = row.FindControl("lbl_victimId") as Label;
                string victimId = lbl_victimId != null ? lbl_victimId.Text.Trim() : string.Empty;

                Label lblClaimCategory = row.FindControl("lbl_claimcategory") as Label;
                string claimCategory = lblClaimCategory != null ? lblClaimCategory.Text.Trim() : string.Empty;

                if (claimCategory == "Human Death / Injury")
                    claimCategory = "Human";
                else if (claimCategory == "Cattle Kill")
                    claimCategory = "Cattle";
                else if (claimCategory == "Crop Damage")
                    claimCategory = "Crop";
                else if (claimCategory == "Property Damage")
                    claimCategory = "House";

                // Store victimId in hidden field
                hdnVictimId.Value = victimId;

                if (claimCategory == "Human")
                {
                    labelClaimCategory.Text = claimCategory;
                    labelIncidentID.Text = incidentId;
                    PanelDocument.Visible = true;
                    humandocuments.Visible = true;
                    cropdamagedocuments.Visible = false;
                    cattledocument.Visible = false;
                    housedamagedocument.Visible = false;

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
                }
                else if (claimCategory == "Crop")
                {
                    labelClaimCategory.Text = claimCategory;
                    labelIncidentID.Text = incidentId;
                    PanelDocument.Visible = true;
                    humandocuments.Visible = false;
                    cropdamagedocuments.Visible = true;
                    cattledocument.Visible = false;
                    housedamagedocument.Visible = false;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
                }
                else if (claimCategory == "Cattle")
                {
                    labelClaimCategory.Text = claimCategory;
                    labelIncidentID.Text = incidentId;
                    PanelDocument.Visible = true;
                    humandocuments.Visible = false;
                    cropdamagedocuments.Visible = false;
                    cattledocument.Visible = true;
                    housedamagedocument.Visible = false;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "showPanelDocument();", true);
                }
                else if (claimCategory == "House")
                {
                    labelClaimCategory.Text = claimCategory;
                    labelIncidentID.Text = incidentId;
                    PanelDocument.Visible = true;
                    humandocuments.Visible = false;
                    cropdamagedocuments.Visible = false;
                    cattledocument.Visible = false;
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

        protected void lnkediteDocument_Click(object sender, EventArgs e)
        {
            try
            {
                pnlInfo.Visible = true;
                PanelDocument.Visible = false;

                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                Label lbl_incidentId = row.FindControl("lbl_incidentId") as Label;
                string incidentId = lbl_incidentId != null ? lbl_incidentId.Text.Trim() : string.Empty;

                Label lbl_victimId = row.FindControl("lbl_victimId") as Label;
                string victimId = lbl_victimId != null ? lbl_victimId.Text.Trim() : string.Empty;

                Label lblClaimCategory = row.FindControl("lbl_claimcategory") as Label;
                string claimCategory = lblClaimCategory != null ? lblClaimCategory.Text.Trim() : string.Empty;
                BindRepeaterEdit(incidentId);
            }
            catch (Exception ex)
            {
                lbl_msg_alert.Visible = true;
                lbl_msg_alert.Text = $"Error: {ex.Message}";
                lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
            }
        }



        protected void BindRepeaterEdit(string incidentId)
        {
            try
            {
                string jsonData = GetDataForPopup(incidentId);

                if (!string.IsNullOrEmpty(jsonData))
                {
                    JObject jsonObject = JObject.Parse(jsonData);

                    DataTable mainDt = new DataTable();

                    mainDt.Columns.Add("victimProfileId", typeof(string));
                    mainDt.Columns.Add("name", typeof(string));
                    mainDt.Columns.Add("gender", typeof(string));
                    mainDt.Columns.Add("aadharNo", typeof(string));
                    mainDt.Columns.Add("aadharDoc", typeof(string));
                    mainDt.Columns.Add("incidentId", typeof(string));
                    mainDt.Columns.Add("applicantId", typeof(string));
                    mainDt.Columns.Add("incidentPlace", typeof(string));
                    mainDt.Columns.Add("activity", typeof(string));
                    mainDt.Columns.Add("status", typeof(string));
                    mainDt.Columns.Add("incidentSummary", typeof(string));
                    mainDt.Columns.Add("humanLoss", typeof(string));
                    mainDt.Columns.Add("animalName", typeof(string));
                    mainDt.Columns.Add("rangeName", typeof(string));
                    mainDt.Columns.Add("applicantName", typeof(string));
                    mainDt.Columns.Add("bankId", typeof(string));
                    mainDt.Columns.Add("bankName", typeof(string));
                    mainDt.Columns.Add("accNumber", typeof(string));
                    mainDt.Columns.Add("accHolderName", typeof(string));
                    mainDt.Columns.Add("bankDoc", typeof(string));
                    mainDt.Columns.Add("applicantAadharNo", typeof(string));
                    mainDt.Columns.Add("applicantAadharDoc", typeof(string));
                    //mainDt.Columns.Add("age", typeof(int));
                    mainDt.Columns.Add("latitude", typeof(decimal));
                    mainDt.Columns.Add("longitude", typeof(decimal));
                    mainDt.Columns.Add("incidentDate", typeof(DateTime));
                    mainDt.Columns.Add("incidentTime", typeof(string));
                    mainDt.Columns.Add("claimCategory", typeof(string));

                    mainDt.Columns.Add("victimName", typeof(string));
                    mainDt.Columns.Add("victimAge", typeof(int));
                    mainDt.Columns.Add("victimGender", typeof(string));
                    mainDt.Columns.Add("victimAadharNo", typeof(string));
                    mainDt.Columns.Add("victimAadharDoc", typeof(string));

                    DataRow rowx = mainDt.NewRow();

                    foreach (DataColumn col in mainDt.Columns)
                    {
                        JToken token = jsonObject[col.ColumnName];

                        if (token == null || token.Type == JTokenType.Null)
                        {
                            rowx[col.ColumnName] = DBNull.Value;
                        }
                        else
                        {
                            Type targetType = col.DataType;

                            if (targetType == typeof(int))
                                rowx[col.ColumnName] = token.ToObject<int>();
                            else if (targetType == typeof(decimal))
                                rowx[col.ColumnName] = token.ToObject<decimal>();
                            else if (targetType == typeof(DateTime))
                                rowx[col.ColumnName] = token.ToObject<DateTime>();
                            else if (targetType == typeof(bool))
                                rowx[col.ColumnName] = token.ToObject<bool>();
                            else
                                rowx[col.ColumnName] = token.ToString();
                        }
                    }

                    mainDt.Rows.Add(rowx);

                    // Store documents for nested Repeater
                    ViewState["documents"] = jsonObject["documents"]?.ToString() ?? "";

                    RepeaterEditDocuments.DataSource = mainDt;
                    RepeaterEditDocuments.DataBind();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupEditDocument();", true);
                }
            }
            catch(Exception ex)
            {

            }
        }

        protected void lnkView_Click(object sender, EventArgs e)
        {
            try
            {
                pnlInfo.Visible = true;
                PanelDocument.Visible = false;
                
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                Label lbl_incidentId = row.FindControl("lbl_incidentId") as Label;
                string incidentId = lbl_incidentId != null ? lbl_incidentId.Text.Trim() : string.Empty;

                Label lbl_victimId = row.FindControl("lbl_victimId") as Label;
                string victimId = lbl_victimId != null ? lbl_victimId.Text.Trim() : string.Empty;

                Label lblClaimCategory = row.FindControl("lbl_claimcategory") as Label;
                string claimCategory = lblClaimCategory != null ? lblClaimCategory.Text.Trim() : string.Empty;
                string jsonData = GetDataForPopup(incidentId);

                if (!string.IsNullOrEmpty(jsonData))
                {
                    JObject jsonObject = JObject.Parse(jsonData);

                    DataTable mainDt = new DataTable();

                    mainDt.Columns.Add("victimProfileId", typeof(string));
                    mainDt.Columns.Add("name", typeof(string));
                    mainDt.Columns.Add("gender", typeof(string));
                    mainDt.Columns.Add("aadharNo", typeof(string));
                    mainDt.Columns.Add("aadharDoc", typeof(string));
                    mainDt.Columns.Add("incidentId", typeof(string));
                    mainDt.Columns.Add("applicantId", typeof(string));
                    mainDt.Columns.Add("incidentPlace", typeof(string));
                    mainDt.Columns.Add("activity", typeof(string));
                    mainDt.Columns.Add("status", typeof(string));
                    mainDt.Columns.Add("incidentSummary", typeof(string));
                    mainDt.Columns.Add("humanLoss", typeof(string));
                    mainDt.Columns.Add("animalName", typeof(string));
                    mainDt.Columns.Add("rangeName", typeof(string));
                    mainDt.Columns.Add("applicantName", typeof(string));
                    mainDt.Columns.Add("bankId", typeof(string));
                    mainDt.Columns.Add("bankName", typeof(string));
                    mainDt.Columns.Add("accNumber", typeof(string));
                    mainDt.Columns.Add("accHolderName", typeof(string));
                    mainDt.Columns.Add("bankDoc", typeof(string));
                    mainDt.Columns.Add("applicantAadharNo", typeof(string));
                    mainDt.Columns.Add("applicantAadharDoc", typeof(string));
                    //mainDt.Columns.Add("age", typeof(int));
                    mainDt.Columns.Add("latitude", typeof(decimal));
                    mainDt.Columns.Add("longitude", typeof(decimal));
                    mainDt.Columns.Add("incidentDate", typeof(DateTime));
                    mainDt.Columns.Add("incidentTime", typeof(string));
                    mainDt.Columns.Add("claimCategory", typeof(string));

                    mainDt.Columns.Add("victimName", typeof(string));
                    mainDt.Columns.Add("victimAge", typeof(int));
                    mainDt.Columns.Add("victimGender", typeof(string));
                    mainDt.Columns.Add("victimAadharNo", typeof(string));
                    mainDt.Columns.Add("victimAadharDoc", typeof(string));

                    DataRow rowx = mainDt.NewRow();

                    foreach (DataColumn col in mainDt.Columns)
                    {
                        JToken token = jsonObject[col.ColumnName];

                        if (token == null || token.Type == JTokenType.Null)
                        {
                            rowx[col.ColumnName] = DBNull.Value;
                        }
                        else
                        {
                            Type targetType = col.DataType;

                            if (targetType == typeof(int))
                                rowx[col.ColumnName] = token.ToObject<int>();
                            else if (targetType == typeof(decimal))
                                rowx[col.ColumnName] = token.ToObject<decimal>();
                            else if (targetType == typeof(DateTime))
                                rowx[col.ColumnName] = token.ToObject<DateTime>();
                            else if (targetType == typeof(bool))
                                rowx[col.ColumnName] = token.ToObject<bool>();
                            else
                                rowx[col.ColumnName] = token.ToString();
                        }
                    }

                    mainDt.Rows.Add(rowx);

                    // Store documents for nested Repeater
                    ViewState["documents"] = jsonObject["documents"]?.ToString() ?? "";

                    rptIncidentDetails.DataSource = mainDt;
                    rptIncidentDetails.DataBind();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopup();", true);
                }
            }
            catch (Exception ex)
            {
                lbl_msg_alert.Visible = true;
                lbl_msg_alert.Text = $"Error: {ex.Message}";
                lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
            }
        }


        protected void btnCattleDocumentsSave_Click(object sender, EventArgs e)
        {
            try
            {
                string incidentId = labelIncidentID.Text;

                if (string.IsNullOrEmpty(incidentId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Error: Incident ID is missing.');", true);
                    return;
                }

                using (var client = new HttpClient())
                {
                    string createdby = Session["Name"]?.ToString() ?? "";
                    string apiUrl = _apiUrl + "TblDocumentDetails/PostTblDocumentDetail";
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
                                formData.Add(new StringContent("0"), "sno");
                                formData.Add(new StringContent(incidentId), "incidentId");
                                formData.Add(new StringContent(createdby), "CreatedBy");
                                formData.Add(new StringContent(roleId), "UploadedByRoleId");
                                formData.Add(new StringContent(userId), "UploadedByUserId");
                                formData.Add(new StringContent("0"), "documentId");
                                formData.Add(new StringContent(documentName), "documentName");
                                formData.Add(new StringContent(fileName), "fileName");
                                formData.Add(new StringContent(""), "filePath");

                                var fileBytes = new byte[file.ContentLength];
                                file.InputStream.Read(fileBytes, 0, file.ContentLength);
                                var fileContent = new ByteArrayContent(fileBytes);
                                fileContent.Headers.ContentType = System.Net.Http.Headers.MediaTypeHeaderValue.Parse(file.ContentType);
                                formData.Add(fileContent, "fileDoc", file.FileName);

                                StringBuilder formDataLog = new StringBuilder($"Document {documentName} Form Data Payload:\n");

                                foreach (var content in formData)
                                {
                                    var contentValue = content.Headers.ContentDisposition.FileName != null ? "[File]" : content.ReadAsStringAsync().GetAwaiter().GetResult();
                                    formDataLog.AppendLine($"{content.Headers.ContentDisposition.Name}: {contentValue}");
                                }

                                System.Diagnostics.Debug.WriteLine(formDataLog.ToString());

                                var response = client.PostAsync(apiUrl, formData).GetAwaiter().GetResult();
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
                    string apiUrl = _apiUrl + "TblDocumentDetails/PostTblDocumentDetail";
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
                                var response = client.PostAsync(apiUrl, formData).GetAwaiter().GetResult();
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
                    string apiUrl = _apiUrl + "TblDocumentDetails/PostTblDocumentDetail";
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
                                var response = client.PostAsync(apiUrl, formData).GetAwaiter().GetResult();
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

        protected void btn_re_upload_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                RepeaterItem item = (RepeaterItem)btn.NamingContainer;
                RepeaterItem parentIncidentItem = (RepeaterItem)item.NamingContainer.NamingContainer;

                HiddenField hfIncidentId = (HiddenField)parentIncidentItem.FindControl("hfIncidentId");
                FileUpload filereupload = (FileUpload)item.FindControl("filereupload");
                Label documentid = (Label)item.FindControl("hfdocumentid");
                string updatedBy = Session["UserId"].ToString();
                string UploadedByUserId = Session["UserId"]?.ToString();
                Int32 UploadedByRoleId = Convert.ToInt32(Session["RoleId"]);

                if (filereupload.HasFile)
                {
                    if (documentid != null && hfIncidentId != null)
                    {
                        Label docName = (Label)item.FindControl("lbldocumentName");

                        string FileName = filereupload.FileName;
                        Stream fileStream = filereupload.PostedFile.InputStream;

                        string documentId = documentid.Text;
                        string incidentId = hfIncidentId.Value;

                        string DocumentDetails = UpdateDocumentDetails(documentId, updatedBy);

                        string result1 = ReuploadDocument(incidentId, UploadedByUserId, UploadedByRoleId, docName.Text, FileName, fileStream, updatedBy);
                        
                        string roleId = Session["roleid"].ToString();
                        string roleName = Session["UserId"]?.ToString();
                        string roleName1 = roleName;

                        string Status = "Application Re-Submission";
                        UpdateApplicantStatus(incidentId, Status, Session["UserId"]?.ToString(), 0);
                        ApiResult result = ApiHelper.PostIncidentProgressLog(this, incidentId, roleId, roleName1, Status, Session["UserId"]?.ToString(), Status);
                        BindRepeaterEdit(incidentId);

                        string successScript = @"
                        Swal.fire({
                            title: 'Document uploaded!',
                            text: 'The document has been uploaded successfully.',
                            icon: 'success',
                            showConfirmButton: true,
                            confirmButtonText: 'OK',
                            background: '#f0f9ff',
                            color: '#1a202c',
                            iconColor: '#38a169',
                            showClass: { popup: 'animate__animated animate__fadeInDown' },
                            hideClass: { popup: 'animate__animated animate__fadeOutUp' },
                            didOpen: (popup) => {
                                popup.style.zIndex = 9999999;  // 🔥 Panel se upar show karega
                            }
                        });
                        ";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessAlert", successScript, true);



                        //ScriptManager.RegisterStartupScript(this, this.GetType(), "verifyAlert", successScript, true);

                        Paneleditdocument.Style["display"] = "flex";
                    }
                }
            }
            catch (Exception ex)
            {
               
            }
        }




        public string UpdateApplicantStatus(string IncidentId, string Status, string UpdatedBy, int damage_type_id)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    using (var form = new MultipartFormDataContent())
                    {
                        form.Add(new StringContent(IncidentId), "IncidentId");
                        form.Add(new StringContent(Status ?? ""), "Status");
                        form.Add(new StringContent(UpdatedBy.ToString()), "UpdatedBy");
                        form.Add(new StringContent(damage_type_id.ToString()), "DamageTypeId");

                        var url = $"{_apiUrl}TblIncidentDetails/PutTblIncidentDetails";
                        var response = client.PostAsync(url, form).Result;

                        if (response.IsSuccessStatusCode)
                        {

                        }

                        string result = response.Content.ReadAsStringAsync().Result;
                        return result;
                    }
                }

            }
            catch (Exception ex)
            {
                return "Not Found";
            }
        }


        public string ReuploadDocument(string IncidentId, string UploadedByUserId, Int32 UploadedByRoleId, string DocumentName,  string FileName, Stream FileStream, string CreatedBy)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    using (var form = new MultipartFormDataContent())
                    {
                        form.Add(new StringContent(IncidentId), "IncidentId");
                        form.Add(new StringContent(UploadedByUserId ?? ""), "UploadedByUserId");
                        form.Add(new StringContent(UploadedByRoleId.ToString()), "UploadedByRoleId");
                        form.Add(new StringContent(DocumentName ?? ""), "DocumentName");
                        form.Add(new StringContent(CreatedBy ?? ""), "CreatedBy");

                        if (FileStream != null && !string.IsNullOrEmpty(FileName))
                        {
                            var fileContent = new StreamContent(FileStream);
                            fileContent.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("form-data")
                            {
                                Name = "\"fileDoc\"",
                                FileName = "\"" + FileName + "\""
                            };
                            fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");

                            form.Add(fileContent);
                        }

                        var url = $"{_apiUrl}TblDocumentDetails/PostTblDocumentDetail";
                        var response = client.PostAsync(url, form).Result;

                        return response.Content.ReadAsStringAsync().Result;
                    }
                }
            }
            catch (Exception ex)
            {
                return "Not Found";
            }
        }


        public string UpdateDocumentDetails(string documentId, string updatedBy)
        {
            try
            {
                var data = new
                {
                    documentId = documentId,
                    updatedBy = updatedBy,
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = _apiUrl + "TblDocumentDetails/PutTblDocumentDetail";

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

    }
}