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
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static uk_forest.ApiHelper;

namespace uk_forest.Forest
{
    public partial class incidentlistRO : System.Web.UI.Page
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
                    // Register hidden button for async postback
                    ScriptManager.GetCurrent(this).RegisterAsyncPostBackControl(btnRefreshGrid);

                    DateTime today = DateTime.Today;
                    DateTime startDate = today.AddYears(-1).AddDays(1); // 1 year ago + 1 day
                    txtFromDate.Text = startDate.ToString("yyyy-MM-dd"); // 2024-11-18
                    txtToDate.Text = today.ToString("yyyy-MM-dd");

                    string userId = Session["UserId"]?.ToString();
                    Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                    string status = "Application Submission";

                    ViewState["ApplicantId"] = userId;

                    if (roleId != 10)
                    {
                        gv_incident_list.Columns[11].Visible = false;  // index adjust karna ho sakta hai
                    }

                    if (roleId == 10) // RO
                    {
                        status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                    }
                    else if (roleId == 9) //SDO
                    {
                        status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO, Application Re-Submission by Range Officer";
                    }
                    else if (roleId == 8) //DFO
                    {
                        status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO, Application Re-Submission by SDO";
                    }
                    else
                    {
                        status = "All";
                    }

                    string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

                    BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);
                    BindForestGuards();
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
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Application Submission";

                if (roleId != 10)
                {
                    gv_incident_list.Columns[11].Visible = false;
                }

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
                }
                else
                {
                    status = "All";
                }

                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

                BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);
            }
            catch (Exception ex)
            {

            }
        }


        private void BindUserGrid(string userId, Int32 roleId, string status, string claimCategory, string fromdate, string todate)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetails_for_approval_authority_claim_date" + $"?userId={userId}&status={status}&role_id={roleId}&claim_category={claimCategory}&fromdate={fromdate}&todate={todate}";
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
                string status = "Application Submission";

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
                }
                else
                {
                    status = "All";
                }

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
                case "Application Submission": return "status-Application Submission";
                case "approved": return "status-approved";
                case "rejected": return "status-rejected";
                default: return "";
            }
        }


        void DamageTypeDropdown(string damage_category)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("DamageTypeMasters/GetDamageTypeMaster_byDamageCategoryandLoss?damage_category=" + damage_category)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        // Add a new column that combines type and remark
                        dt.Columns.Add("DisplayText", typeof(string), "type + ' - ' + remark");

                        ddl_damage_type.Items.Clear();
                        ddl_damage_type.DataSource = dt;
                        ddl_damage_type.DataValueField = "damageTypeId";
                        ddl_damage_type.DataTextField = "DisplayText";
                        ddl_damage_type.DataBind();
                        //ddl_damage_type.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Damage Type", "0"));
                    }
                }
            }
            catch (Exception ex)
            {
                // Consider logging the exception
            }
        }

        void DamageTypeDropdown_byId(int damage_type_id)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("DamageTypeMasters/GetDamageTypeMaster_byDamageTypeId?damage_type_id=" + damage_type_id)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        // Add a new column that combines type and remark
                        dt.Columns.Add("DisplayText", typeof(string), "type + ' - ' + remark");

                        ddl_damage_type.Items.Clear();
                        ddl_damage_type.DataSource = dt;
                        ddl_damage_type.DataValueField = "damageTypeId";
                        ddl_damage_type.DataTextField = "DisplayText";
                        ddl_damage_type.DataBind();
                        //ddl_damage_type.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Damage Type", "0"));
                    }
                }
            }
            catch (Exception ex)
            {
                // Consider logging the exception
            }
        }

        public string HostUrl => ConfigurationManager.AppSettings["BaseUrl"];

        protected void ddl_status_approved_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                DropDownList ddl = (DropDownList)sender;
                GridViewRow row = (GridViewRow)ddl.NamingContainer;
                string baseUrl = "http://203.122.5.18:9008/uk_forest_web/";
                string selectedAction = ddl.SelectedValue;
                Label lbl_claimCategory = (Label)gv_incident_list.FindControl("lbl_claimCategory");
                string claimCategory = lbl_claimCategory?.Text;

                if (selectedAction == "View")
                {
                    string incidentId = gv_incident_list.DataKeys[row.RowIndex].Value.ToString();
                    BindRepeater(incidentId);
                    pnlIncidentDetails.Visible = true;
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowPopup", "showIncidentPopup();", true);
                }
                else if (selectedAction == "Verify_Document")
                {
                    string incidentId = gv_incident_list.DataKeys[row.RowIndex].Value.ToString();
                    string jsonData = GetDataForPopupDocumentVerify(incidentId);

                    if (!string.IsNullOrEmpty(jsonData))
                    {
                        JObject incidentDetails = JObject.Parse(jsonData);
                        JArray docsArray = (JArray)incidentDetails["documents"];

                        foreach (JObject doc in docsArray)
                        {
                            string path = doc["documentPath"]?.ToString().Replace("\\", "/");
                            doc["FullUrl"] = $"{baseUrl}{path}";
                            doc["FilePath"] = path;
                            doc["documentId"] = doc["documentId"]?.ToString() ?? string.Empty;
                            doc["incidentId"] = incidentId;
                        }

                        Repeater2.DataSource = docsArray;
                        Repeater2.DataBind();

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
                    }
                }
                else if (selectedAction == "Recommendation")
                {
                    string incidentId = gv_incident_list.DataKeys[row.RowIndex].Value.ToString();
                    Session["incidentId"] = incidentId;

                    paneldocumentrecommendation.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showrecommendationPopup();", true);
                }
            }
            catch (Exception ex)
            {

            }
        }

        void BindAmount()
        {
            try
            {
                Int32 damage_type_id = Convert.ToInt32(ddl_damage_type.SelectedValue);
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    HttpResponseMessage Res = client.GetAsync(apiUrl + $"DamageTypeMasters/GetDamageTypeMaster_byDamageTypeId?damage_type_id={damage_type_id}").Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            decimal totalAmount = Convert.ToDecimal(dt.Rows[0]["totalAmount"]);
                            //txt_amount.Text = totalAmount.ToString("0.00");

                            decimal percentage = 0;
                            string claimCategory = string.Empty;

                            // ✅ Search through GridView rows to find the label
                            foreach (GridViewRow row in gv_incident_list.Rows)
                            {
                                if (row.RowType == DataControlRowType.DataRow)
                                {
                                    Label lbl_claimCategory = (Label)row.FindControl("lbl_claimCategory");
                                    if (lbl_claimCategory != null)
                                    {
                                        claimCategory = lbl_claimCategory.Text;
                                        break; // Exit loop once found
                                    }
                                }
                            }

                            // Apply percentage based on claimCategory
                            if (claimCategory.Equals("Human", StringComparison.OrdinalIgnoreCase))
                            {
                                percentage = 0.30m; // 30%
                            }
                            else if (claimCategory.Equals("Cattle", StringComparison.OrdinalIgnoreCase))
                            {
                                percentage = 0.20m; // 20%
                            }

                            decimal payableAmount = totalAmount * percentage;
                        }
                        else
                        {

                        }
                    }
                    else
                    {

                    }
                }
            }
            catch
            {

            }
        }



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

        private void BindRepeater(string incidentId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={incidentId}";

                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;
                        JObject obj = JObject.Parse(json);

                        // Create a DataTable with single row for main incident data
                        DataTable dtMain = new DataTable();

                        // Add columns for all fields
                        foreach (var prop in obj.Properties())
                        {
                            if (prop.Name.Equals("documents", StringComparison.OrdinalIgnoreCase))
                                continue;
                            dtMain.Columns.Add(prop.Name);
                        }

                        // Add single row with all data
                        DataRow mainRow = dtMain.NewRow();
                        foreach (var prop in obj.Properties())
                        {
                            if (prop.Name.Equals("documents", StringComparison.OrdinalIgnoreCase))
                                continue;
                            mainRow[prop.Name] = prop.Value?.ToString() ?? "";
                        }
                        dtMain.Rows.Add(mainRow);

                        rptMainIncident.DataSource = dtMain;
                        rptMainIncident.DataBind();

                        // Bind documents
                        if (obj["documents"] != null && obj["documents"].HasValues)
                        {
                            DataTable dtDocs = new DataTable();
                            dtDocs.Columns.Add("DocumentName");
                            dtDocs.Columns.Add("DocumentPath");

                            foreach (var doc in obj["documents"])
                            {
                                DataRow row = dtDocs.NewRow();
                                row["DocumentName"] = doc["documentName"]?.ToString();

                                string path = doc["documentPath"]?.ToString() ?? "";
                                row["DocumentPath"] = BaseUrl + path.Replace("\\", "/");

                                dtDocs.Rows.Add(row);
                            }

                            rptDocuments.DataSource = dtDocs;
                            rptDocuments.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle error
                rptMainIncident.DataSource = null;
                rptMainIncident.DataBind();
                rptDocuments.DataSource = null;
                rptDocuments.DataBind();
            }
        }

        // Call this method to show incident details
        public void ShowIncidentDetails(string incidentId)
        {
            BindRepeater(incidentId);
        }


        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Application Submission";

                if (roleId != 10)
                {
                    gv_incident_list.Columns[11].Visible = false;  // index adjust karna ho sakta hai
                }

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
                }
                else
                {
                    status = "All";
                }

                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

                BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);
            }
            catch (Exception ex)
            {

            }
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                RepeaterItem item = (RepeaterItem)btn.NamingContainer;

                HiddenField hfDocumentId = (HiddenField)item.FindControl("hfDocumentId");
                HiddenField hfIncidentId = (HiddenField)item.FindControl("hfIncidentId");

                string documentId = hfDocumentId?.Value;
                string incidentId = hfIncidentId?.Value;
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Verified";
                string xx = "";

                ApproveDocument(incidentId, documentId, userId, roleId, status, userId, "");

                bool allDocsVerified = AreAllDocumentsVerified(incidentId);

                if (!allDocsVerified)
                {
                    if (roleId == 10) // RO
                    {
                        status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                    }
                    else if (roleId == 9) //SDO
                    {
                        status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
                    }
                    else if (roleId == 8) //DFO
                    {
                        status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
                    }
                    else
                    {
                        status = "All";
                    }

                    string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

                    BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

                    panelVerifyDocument.Style["display"] = "flex";
                    string successScript = @"
                        Swal.fire({
                            title: 'Document Verified!',
                            text: 'The document has been verified successfully.',
                            icon: 'success',
                            showConfirmButton: true,
                            confirmButtonText: 'OK',
                            background: '#f0f9ff',
                            color: '#1a202c',
                            iconColor: '#38a169',
                            showClass: { popup: 'animate__animated animate__fadeInDown' },
                            hideClass: { popup: 'animate__animated animate__fadeOutUp' }
                        });";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "verifyAlert", successScript, true);

                    //string baseUrl = "http://203.122.5.18:9008/uk_forest_web/";

                    string baseUrl = "https://ukforestgis.in/";

                    string jsonData = GetDataForPopupDocumentVerify(incidentId);

                    if (!string.IsNullOrEmpty(jsonData))
                    {
                        JObject incidentDetails = JObject.Parse(jsonData);

                        string incidentStatus = incidentDetails["status"]?.ToString();

                        if (string.IsNullOrEmpty(incidentStatus))
                        {
                            lblIncidentStatus.Text = "N/A";
                            lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentStatus.Font.Bold = true;

                            lblIncidentId.Text = "N/A";
                            lblIncidentId.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentId.Font.Bold = true;
                        }
                        else if (incidentStatus.Equals("Application Submission", StringComparison.OrdinalIgnoreCase))
                        {
                            lblIncidentStatus.Text = incidentStatus;
                            lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentStatus.Font.Bold = true;

                            lblIncidentId.Text = incidentId;
                            lblIncidentId.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentId.Font.Bold = true;
                        }
                        else
                        {
                            lblIncidentStatus.Text = incidentStatus;
                            lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentStatus.Font.Bold = true;

                            lblIncidentId.Text = incidentId;
                            lblIncidentId.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentId.Font.Bold = true;
                        }

                        JArray docsArray = (JArray)incidentDetails["documents"];
                        foreach (JObject doc in docsArray)
                        {
                            string path = doc["documentPath"]?.ToString().Replace("\\", "/");
                            doc["FullUrl"] = $"{baseUrl}{path}";
                            doc["FilePath"] = path;
                            doc["documentId"] = doc["documentId"]?.ToString() ?? string.Empty;
                            doc["incidentId"] = incidentId;
                        }

                        Repeater2.DataSource = docsArray;
                        Repeater2.DataBind();
                    }
                }
                else
                {
                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={incidentId}";

                        HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                        if (response.IsSuccessStatusCode)
                        {
                            string json = response.Content.ReadAsStringAsync().Result;
                            JObject obj = JObject.Parse(json);

                            string laststatus = obj["status"]?.ToString();

                            if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("advance payment processed successfully") || laststatus.ToLower().Contains("final"))
                            {
                                xx = "Remaining Document Verified by ";
                            }
                            else
                            {
                                xx = "Document Verified by ";
                            }
                        }
                    }

                    string Incidentstatus = xx + Session["RoleName"].ToString();
                    UpdateApplicantStatus(incidentId, Incidentstatus, Session["UserId"]?.ToString(), 0);

                    string roleName1 = Session["RoleName"].ToString();
                    string action = "Document verified by " + roleName1;
                    string remarks = $"Document verified for Incident ID: {incidentId}";
                    string RoleID = Session["roleid"].ToString();
                    string createdBy = Session["Userid"].ToString();

                    ApiResult result = ApiHelper.PostIncidentProgressLog(this, incidentId, RoleID, roleName1, Incidentstatus, createdBy, remarks);

                    if (roleId == 10) // RO
                    {
                        status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                    }
                    else if (roleId == 9) //SDO
                    {
                        status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
                    }
                    else if (roleId == 8) //DFO
                    {
                        status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
                    }
                    else
                    {
                        status = "All";
                    }

                    string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

                    BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

                    panelVerifyDocument.Style["display"] = "flex";

                    // ✅ Show success alert
                    string successScript = @"
            Swal.fire({
                title: 'Document Verified!',
                text: 'The document has been verified successfully.',
                icon: 'success',
                showConfirmButton: true,
                confirmButtonText: 'OK',
                background: '#f0f9ff',
                color: '#1a202c',
                iconColor: '#38a169',
                showClass: { popup: 'animate__animated animate__fadeInDown' },
                hideClass: { popup: 'animate__animated animate__fadeOutUp' }
            });";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "verifyAlert", successScript, true);

                    //string baseUrl = "http://203.122.5.18:9008/uk_forest_web/";

                    string baseUrl = "https://ukforestgis.in/";

                    string jsonData = GetDataForPopupDocumentVerify(incidentId);

                    if (!string.IsNullOrEmpty(jsonData))
                    {
                        JObject incidentDetails = JObject.Parse(jsonData);

                        string incidentStatus = incidentDetails["status"]?.ToString();

                        if (string.IsNullOrEmpty(incidentStatus))
                        {
                            lblIncidentStatus.Text = "N/A";
                            lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentStatus.Font.Bold = true;

                            lblIncidentId.Text = "N/A";
                            lblIncidentId.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentId.Font.Bold = true;
                        }
                        else if (incidentStatus.Equals("Application Submission", StringComparison.OrdinalIgnoreCase))
                        {
                            lblIncidentStatus.Text = incidentStatus;
                            lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentStatus.Font.Bold = true;

                            lblIncidentId.Text = incidentId;
                            lblIncidentId.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentId.Font.Bold = true;
                        }
                        else
                        {
                            lblIncidentStatus.Text = incidentStatus;
                            lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentStatus.Font.Bold = true;

                            lblIncidentId.Text = incidentId;
                            lblIncidentId.ForeColor = System.Drawing.Color.Blue;
                            lblIncidentId.Font.Bold = true;
                        }

                        JArray docsArray = (JArray)incidentDetails["documents"];
                        foreach (JObject doc in docsArray)
                        {
                            string path = doc["documentPath"]?.ToString().Replace("\\", "/");
                            doc["FullUrl"] = $"{baseUrl}{path}";
                            doc["FilePath"] = path;
                            doc["documentId"] = doc["documentId"]?.ToString() ?? string.Empty;
                            doc["incidentId"] = incidentId;
                        }

                        Repeater2.DataSource = docsArray;
                        Repeater2.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }


        //protected void btnReject_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        Button btn = (Button)sender;
        //        RepeaterItem item = (RepeaterItem)btn.NamingContainer;

        //        TextBox txtReason = (TextBox)item.FindControl("txt_reason");

        //        if (txtReason.Text != "")
        //        {
        //            HiddenField hfDocumentId = (HiddenField)item.FindControl("hfDocumentId");
        //            HiddenField hfIncidentId = (HiddenField)item.FindControl("hfIncidentId");

        //            string documentId = hfDocumentId?.Value;
        //            string incidentId = hfIncidentId?.Value;
        //            string userId = Session["UserId"]?.ToString();
        //            Int32 roleId = Convert.ToInt32(Session["RoleId"]);
        //            string status = "Returned";
        //            string Incidentstatus = "Document Returned by " + Session["RoleName"]?.ToString();
        //            string Comments = txtReason.Text;
        //            ApproveDocument(incidentId, documentId, userId, roleId, status, userId, Comments);

        //            bool allDocsVerified = AreAllDocumentsVerified(incidentId);

        //            string roleName1 = Session["RoleName"].ToString();
        //            string action = "Document Returned by " + roleName1;
        //            string remarks = $"Uploaded documents for Incident ID: {incidentId}";
        //            string roleId1 = Session["roleid"].ToString();
        //            string createdBy = Session["Userid"].ToString();

        //            using (var client = new HttpClient())
        //            {
        //                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //                string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={incidentId}";

        //                HttpResponseMessage response = client.GetAsync(requestUrl).Result;

        //                if (response.IsSuccessStatusCode)
        //                {
        //                    string json = response.Content.ReadAsStringAsync().Result;
        //                    JObject obj = JObject.Parse(json);

        //                    string laststatus = obj["status"]?.ToString();

        //                    if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("document returned by"))
        //                    {
        //                        action = action;
        //                    }
        //                    else
        //                    {
        //                        ApiResult result = ApiHelper.PostIncidentProgressLog(this, incidentId, roleId1, roleName1, action, createdBy, remarks);
        //                    }
        //                }
        //            }

        //            UpdateApplicantStatus(incidentId, Incidentstatus, Session["UserId"]?.ToString(), 0);

        //            if (roleId == 10) // RO
        //            {
        //                status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
        //            }
        //            else if (roleId == 9) //SDO
        //            {
        //                status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
        //            }
        //            else if (roleId == 8) //DFO
        //            {
        //                status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
        //            }
        //            else
        //            {
        //                status = "All";
        //            }

        //            string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

        //            BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

        //            panelVerifyDocument.Style["display"] = "flex";

        //            string successScript = @"
        //    Swal.fire({
        //        title: 'Document Returned!',
        //        text: 'The document has been returned successfully.',
        //        icon: 'error',
        //        showConfirmButton: true,
        //        confirmButtonText: 'OK',
        //        background: '#f0f9ff',
        //        color: '#1a202c',
        //        iconColor: '#dc3545',
        //        showClass: { popup: 'animate__animated animate__fadeInDown' },
        //        hideClass: { popup: 'animate__animated animate__fadeOutUp' }
        //    });";

        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "rejectAlert", successScript, true);

        //            string baseUrl = "http://203.122.5.18:9008/uk_forest_web/";
        //            string jsonData = GetDataForPopupDocumentVerify(incidentId);

        //            if (!string.IsNullOrEmpty(jsonData))
        //            {
        //                JObject incidentDetails = JObject.Parse(jsonData);

        //                string incidentStatus = incidentDetails["status"]?.ToString();

        //                if (string.IsNullOrEmpty(incidentStatus))
        //                {
        //                    lblIncidentStatus.Text = "N/A";
        //                    lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
        //                    lblIncidentStatus.Font.Bold = true;

        //                    lblIncidentId.Text = "N/A";
        //                    lblIncidentId.ForeColor = System.Drawing.Color.Blue;
        //                    lblIncidentId.Font.Bold = true;
        //                }
        //                else if (incidentStatus.Equals("Application Submission", StringComparison.OrdinalIgnoreCase))
        //                {
        //                    lblIncidentStatus.Text = incidentStatus;
        //                    lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
        //                    lblIncidentStatus.Font.Bold = true;

        //                    lblIncidentId.Text = incidentId;
        //                    lblIncidentId.ForeColor = System.Drawing.Color.Blue;
        //                    lblIncidentId.Font.Bold = true;
        //                }
        //                else
        //                {
        //                    lblIncidentStatus.Text = incidentStatus;
        //                    lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
        //                    lblIncidentStatus.Font.Bold = true;

        //                    lblIncidentId.Text = incidentId;
        //                    lblIncidentId.ForeColor = System.Drawing.Color.Blue;
        //                    lblIncidentId.Font.Bold = true;
        //                }

        //                JArray docsArray = (JArray)incidentDetails["documents"];
        //                foreach (JObject doc in docsArray)
        //                {
        //                    string path = doc["documentPath"]?.ToString().Replace("\\", "/");
        //                    doc["FullUrl"] = $"{baseUrl}{path}";
        //                    doc["FilePath"] = path;
        //                    doc["documentId"] = doc["documentId"]?.ToString() ?? string.Empty;
        //                    doc["incidentId"] = incidentId;
        //                }

        //                Repeater2.DataSource = docsArray;
        //                Repeater2.DataBind();
        //            }
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
        //        }

        //        if (txtReason != null)
        //        {
        //            txtReason.Visible = true;
        //            txtReason.Focus();
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
        //            return;
        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}


        protected void btnReject_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                RepeaterItem item = (RepeaterItem)btn.NamingContainer;

                // Show reason textbox and swap buttons
                TextBox txtReason = (TextBox)item.FindControl("txt_reason");
                if (txtReason != null)
                {
                    txtReason.Visible = true;
                    txtReason.Text = ""; // clear if you want
                    txtReason.Focus();
                }

                // Hide original buttons
                Button btnApprove = (Button)item.FindControl("btnApprove");
                Button btnReject = (Button)item.FindControl("btnReject");
                if (btnApprove != null) btnApprove.Visible = false;
                if (btnReject != null) btnReject.Visible = false;

                // Show new buttons
                Button btnReturnSubmit = (Button)item.FindControl("btnReturnSubmit");
                Button btnReset = (Button)item.FindControl("btnReset");
                if (btnReturnSubmit != null) btnReturnSubmit.Visible = true;
                if (btnReset != null) btnReset.Visible = true;

                // Keep popup visible (if you used popup to show details)
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
            }
            catch (Exception ex)
            {
                // Log the exception
            }
        }

        protected void btnReturnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                RepeaterItem item = (RepeaterItem)btn.NamingContainer;

                // Call shared processing logic
                ProcessDocumentReturn(item);

                // After processing, you may want to reset the UI for that item (or keep it hidden)
                // Here we reset UI to original state:
                TextBox txtReason = (TextBox)item.FindControl("txt_reason");
                if (txtReason != null)
                {
                    txtReason.Text = "";
                    txtReason.Visible = false;
                }

                Button btnApprove = (Button)item.FindControl("btnApprove");
                Button btnReject = (Button)item.FindControl("btnReject");
                Button btnReturnSubmit = (Button)item.FindControl("btnReturnSubmit");
                Button btnReset = (Button)item.FindControl("btnReset");

                if (btnApprove != null) btnApprove.Visible = true;
                if (btnReject != null) btnReject.Visible = true;
                if (btnReturnSubmit != null) btnReturnSubmit.Visible = false;
                if (btnReset != null) btnReset.Visible = false;
            }
            catch (Exception ex)
            {
                // Log
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                RepeaterItem item = (RepeaterItem)btn.NamingContainer;

                // Reset controls in that item
                TextBox txtReason = (TextBox)item.FindControl("txt_reason");
                if (txtReason != null)
                {
                    txtReason.Text = "";
                    txtReason.Visible = false;
                }

                Button btnApprove = (Button)item.FindControl("btnApprove");
                Button btnReject = (Button)item.FindControl("btnReject");
                Button btnReturnSubmit = (Button)item.FindControl("btnReturnSubmit");
                Button btnResetBtn = (Button)item.FindControl("btnReset");

                if (btnApprove != null) btnApprove.Visible = true;
                if (btnReject != null) btnReject.Visible = true;
                if (btnReturnSubmit != null) btnReturnSubmit.Visible = false;
                if (btnResetBtn != null) btnResetBtn.Visible = false;

                // Keep popup visible
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
            }
            catch (Exception ex)
            {
                // Log
            }
        }

        // Shared processing logic (moved from your original btnReject_Click)
        //private void ProcessDocumentReturn(RepeaterItem item)
        //{
        //    try
        //    {
        //        TextBox txtReason = (TextBox)item.FindControl("txt_reason");
        //        if (txtReason == null) return;

        //        // Ensure reason is provided
        //        if (string.IsNullOrWhiteSpace(txtReason.Text))
        //        {
        //            // show message - reason required
        //            string script = @"Swal.fire({ title: 'Reason required', text: 'Please enter a reason before submitting.', icon: 'warning' });";
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "reasonAlert", script, true);
        //            return;
        //        }

        //        HiddenField hfDocumentId = (HiddenField)item.FindControl("hfDocumentId");
        //        HiddenField hfIncidentId = (HiddenField)item.FindControl("hfIncidentId");

        //        string documentId = hfDocumentId?.Value;
        //        string incidentId = hfIncidentId?.Value;
        //        string userId = Session["UserId"]?.ToString();
        //        Int32 roleId = Convert.ToInt32(Session["RoleId"] ?? 0);
        //        string status = "Returned";
        //        string Incidentstatus = "Document Returned by " + Session["RoleName"]?.ToString();
        //        string Comments = txtReason.Text;

        //        // Call your existing function to approve/return the doc (keeps behavior same)
        //        ApproveDocument(incidentId, documentId, userId, roleId, status, userId, Comments);

        //        bool allDocsVerified = AreAllDocumentsVerified(incidentId);

        //        string roleName1 = Session["RoleName"]?.ToString() ?? "";
        //        string action = "Document Returned by " + roleName1;
        //        string remarks = $"Uploaded documents for Incident ID: {incidentId}";
        //        string roleId1 = Session["roleid"]?.ToString() ?? "";
        //        string createdBy = Session["Userid"]?.ToString() ?? "";

        //        // Call API to fetch last status and post progress log if needed
        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={incidentId}";

        //            HttpResponseMessage response = client.GetAsync(requestUrl).Result;

        //            if (response.IsSuccessStatusCode)
        //            {
        //                string json = response.Content.ReadAsStringAsync().Result;
        //                JObject obj = JObject.Parse(json);

        //                string laststatus = obj["status"]?.ToString();

        //                if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("document returned by"))
        //                {
        //                    // already has document returned by => do nothing for action
        //                }
        //                else
        //                {
        //                    ApiResult result = ApiHelper.PostIncidentProgressLog(this, incidentId, roleId1, roleName1, action, createdBy, remarks);
        //                }
        //            }
        //        }

        //        UpdateApplicantStatus(incidentId, Incidentstatus, Session["UserId"]?.ToString(), 0);

        //        // Adjust the status text used for filtering (same logic as original)
        //        if (roleId == 10) // RO
        //        {
        //            status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
        //        }
        //        else if (roleId == 9) //SDO
        //        {
        //            status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
        //        }
        //        else if (roleId == 8) //DFO
        //        {
        //            status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
        //        }
        //        else
        //        {
        //            status = "All";
        //        }

        //        // claim_category existence: keep same logic as original
        //        string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

        //        // Refresh user grid - keep your existing call
        //        BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

        //        // Show success alert
        //        string successScript = @"
        //        Swal.fire({
        //            title: 'Document Returned!',
        //            text: 'The document has been returned successfully.',
        //            icon: 'error',
        //            showConfirmButton: true,
        //            confirmButtonText: 'OK',
        //            background: '#f0f9ff',
        //            color: '#1a202c',
        //            iconColor: '#dc3545',
        //            showClass: { popup: 'animate__animated animate__fadeInDown' },
        //            hideClass: { popup: 'animate__animated animate__fadeOutUp' }
        //        });";

        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "rejectAlert", successScript, true);

        //        // Re-bind popup documents (same as original)
        //        string baseUrl = "http://203.122.5.18:9008/uk_forest_web/"; // keep as original
        //        string jsonData = GetDataForPopupDocumentVerify(incidentId);

        //        if (!string.IsNullOrEmpty(jsonData))
        //        {
        //            JObject incidentDetails = JObject.Parse(jsonData);

        //            string incidentStatus = incidentDetails["status"]?.ToString();

        //            if (string.IsNullOrEmpty(incidentStatus))
        //            {
        //                lblIncidentStatus.Text = "N/A";
        //                lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
        //                lblIncidentStatus.Font.Bold = true;

        //                lblIncidentId.Text = "N/A";
        //                lblIncidentId.ForeColor = System.Drawing.Color.Blue;
        //                lblIncidentId.Font.Bold = true;
        //            }
        //            else if (incidentStatus.Equals("Application Submission", StringComparison.OrdinalIgnoreCase))
        //            {
        //                lblIncidentStatus.Text = incidentStatus;
        //                lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
        //                lblIncidentStatus.Font.Bold = true;

        //                lblIncidentId.Text = incidentId;
        //                lblIncidentId.ForeColor = System.Drawing.Color.Blue;
        //                lblIncidentId.Font.Bold = true;
        //            }
        //            else
        //            {
        //                lblIncidentStatus.Text = incidentStatus;
        //                lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
        //                lblIncidentStatus.Font.Bold = true;

        //                lblIncidentId.Text = incidentId;
        //                lblIncidentId.ForeColor = System.Drawing.Color.Blue;
        //                lblIncidentId.Font.Bold = true;
        //            }

        //            JArray docsArray = (JArray)incidentDetails["documents"];
        //            foreach (JObject doc in docsArray)
        //            {
        //                string path = doc["documentPath"]?.ToString().Replace("\\", "/");
        //                doc["FullUrl"] = $"{baseUrl}{path}";
        //                doc["FilePath"] = path;
        //                doc["documentId"] = doc["documentId"]?.ToString() ?? string.Empty;
        //                doc["incidentId"] = incidentId;
        //            }

        //            Repeater2.DataSource = docsArray;
        //            Repeater2.DataBind();
        //        }

        //        // If you need to show the popup again
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
        //    }
        //    catch (Exception ex)
        //    {
        //        // log or show friendly message
        //    }
        //}



        private void ProcessDocumentReturn(RepeaterItem item)
        {
            try
            {
                TextBox txtReason = (TextBox)item.FindControl("txt_reason");
                if (txtReason == null) return;

                // Ensure reason is provided
                if (string.IsNullOrWhiteSpace(txtReason.Text))
                {
                    string script = @"Swal.fire({ title: 'Reason required', text: 'Please enter a reason before submitting.', icon: 'warning' });";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "reasonAlert", script, true);
                    return;
                }

                HiddenField hfDocumentId = (HiddenField)item.FindControl("hfDocumentId");
                HiddenField hfIncidentId = (HiddenField)item.FindControl("hfIncidentId");

                string documentId = hfDocumentId?.Value;
                string incidentId = hfIncidentId?.Value;
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"] ?? 0);

                string status = "Returned";
                string Incidentstatus = "Document Returned by " + Session["RoleName"]?.ToString();
                string Comments = txtReason.Text;

                // 🔒 STEP-2 FIX : Detect payment phase BEFORE return
                string paymentPhase = GetPaymentPhase(incidentId);

                // Freeze advance actions if FINAL phase already started
                if (paymentPhase == "FINAL")
                {
                    Session["DisableAdvanceActions"] = true;
                }
                else
                {
                    Session["DisableAdvanceActions"] = false;
                }

                // Return document (existing behaviour)
                ApproveDocument(incidentId, documentId, userId, roleId, status, userId, Comments);

                bool allDocsVerified = AreAllDocumentsVerified(incidentId);

                string roleName1 = Session["RoleName"]?.ToString() ?? "";
                string action = "Document Returned by " + roleName1;
                string remarks = $"Uploaded documents for Incident ID: {incidentId}";
                string roleId1 = Session["roleid"]?.ToString() ?? "";
                string createdBy = Session["Userid"]?.ToString() ?? "";

                // Log status only if last status was not already RETURN
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={incidentId}";

                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;
                        JObject obj = JObject.Parse(json);

                        string laststatus = obj["status"]?.ToString();

                        if (string.IsNullOrEmpty(laststatus) ||
                            !laststatus.ToLower().Contains("document returned by"))
                        {
                            ApiHelper.PostIncidentProgressLog(
                                this,
                                incidentId,
                                roleId1,
                                roleName1,
                                action,
                                createdBy,
                                remarks
                            );
                        }
                    }
                }

                UpdateApplicantStatus(incidentId, Incidentstatus, userId, 0);

                // 🔒 STEP-2 FIX : Status filter must respect FINAL phase
                if (roleId == 10) // RO
                {
                    status = (paymentPhase == "FINAL")
                        ? "Final Payment Recommended by Range Officer, Document Returned by Range Officer"
                        : "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                }
                else if (roleId == 9) // SDO
                {
                    status = (paymentPhase == "FINAL")
                        ? "Final Payment Recommended by Range Officer, Document Returned by SDO"
                        : "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Document Returned by SDO";
                }
                else if (roleId == 8) // DFO
                {
                    status = (paymentPhase == "FINAL")
                        ? "Final Payment Recommended by SDO, Document Returned by DFO"
                        : "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Document Returned by DFO";
                }
                else
                {
                    status = "All";
                }

                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

                BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

                string successScript = @"
        Swal.fire({
            title: 'Document Returned!',
            text: 'The document has been returned successfully.',
            icon: 'error',
            showConfirmButton: true,
            confirmButtonText: 'OK'
        });";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "rejectAlert", successScript, true);

                // Rebind popup documents (unchanged)
                //string baseUrl = "http://203.122.5.18:9008/uk_forest_web/";

                string baseUrl = "https://ukforestgis.in/";

                string jsonData = GetDataForPopupDocumentVerify(incidentId);

                if (!string.IsNullOrEmpty(jsonData))
                {
                    JObject incidentDetails = JObject.Parse(jsonData);

                    lblIncidentStatus.Text = incidentDetails["status"]?.ToString() ?? "N/A";
                    lblIncidentId.Text = incidentId;

                    JArray docsArray = (JArray)incidentDetails["documents"];
                    foreach (JObject doc in docsArray)
                    {
                        string path = doc["documentPath"]?.ToString().Replace("\\", "/");
                        doc["FullUrl"] = $"{baseUrl}{path}";
                        doc["FilePath"] = path;
                        doc["documentId"] = doc["documentId"]?.ToString() ?? "";
                        doc["incidentId"] = incidentId;
                    }

                    Repeater2.DataSource = docsArray;
                    Repeater2.DataBind();
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
            }
            catch (Exception ex)
            {
                // log
            }
        }


        public string ApproveDocument(string incidentId, string documentId, string userId, Int32 roleId, string status, string CreatedBy, string Comments)
        {
            try
            {
                var data = new
                {
                    IncidentId = incidentId,
                    DocumentId = documentId,
                    ApprovedByUserId = userId,
                    ApprovedByRoleId = roleId,
                    status = status,
                    CreatedBy = CreatedBy,
                    Comments = Comments
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblDocumentApprovals/PostTblDocumentApproval";

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

        protected void gv_incident_list_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    Label lbl_incidentId = (Label)e.Row.FindControl("lbl_incidentId");
                    LinkButton lnkRecommendation = (LinkButton)e.Row.FindControl("lnl_recommendation");
                    LinkButton lnkDocuments = (LinkButton)e.Row.FindControl("lnkDocuments");
                    LinkButton lnkPayment = (LinkButton)e.Row.FindControl("lnkPayment"); // Payment button
                    LinkButton lnkAssignFG = (LinkButton)e.Row.FindControl("lnkAssignFG"); // Payment button

                    if (lbl_incidentId != null)
                    {
                        string incidentId = lbl_incidentId.Text;
                        bool allDocsVerified = AreAllDocumentsVerified(incidentId);

                        if (lnkRecommendation != null)
                        {
                            lnkRecommendation.Enabled = allDocsVerified;
                            lnkRecommendation.CssClass = allDocsVerified ? "btn btn-primary" : "btn btn-disabled";
                        }
                        if (lnkDocuments != null)
                        {
                            if (allDocsVerified)
                            {
                                lnkDocuments.Text = "Verified";
                                lnkDocuments.Style["background"] = "linear-gradient(135deg,#28a745 0%,#218838 100%)"; // green
                                lnkDocuments.Style["border"] = "1px solid #218838";
                                lnkDocuments.Style["color"] = "white";
                            }
                            else
                            {
                                lnkDocuments.Text = "Verify";
                                lnkDocuments.Style["background"] = "linear-gradient(135deg,#007bff 0%,#0056b3 100%)"; // blue
                                lnkDocuments.Style["border"] = "1px solid #007bff";
                                lnkDocuments.Style["color"] = "white";
                                lnkDocuments.Enabled = true;
                            }
                        }
                        if (lnkPayment != null)
                        {
                            if (allDocsVerified)
                            {
                                // Active style
                                lnkPayment.Enabled = true;
                                lnkPayment.CssClass = "btn btn-success"; // green
                                lnkPayment.Style["opacity"] = "1";
                                lnkPayment.Style["cursor"] = "pointer";
                                lnkPayment.ToolTip = "Click to make payment"; // normal tooltip
                                lnkPayment.OnClientClick = ""; // ensure click works
                            }
                            else
                            {
                                // Inactive style: visible but not clickable
                                lnkPayment.Enabled = false;            // disables click
                                lnkPayment.CssClass = "btn btn-secondary"; // grey dull
                                lnkPayment.Style["opacity"] = "0.6";
                                lnkPayment.Style["cursor"] = "not-allowed";
                                lnkPayment.OnClientClick = "return false;"; // extra safety
                                lnkPayment.ToolTip = "Payment can be made only after verifying all associated documents.";
                            }
                        }

                        if (lnkAssignFG != null)
                        {
                            bool check = CheckAssign(incidentId);

                            if (check)
                            {
                                lnkAssignFG.Text = "Assigned";
                                lnkAssignFG.Enabled = false;
                                lnkAssignFG.Style["opacity"] = "0.6";
                                lnkAssignFG.Style["cursor"] = "not-allowed";
                            }
                            else
                            {
                                lnkAssignFG.Text = "Assign";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Optional: log the exception
            }
        }

        private bool CheckAssign(string incidentId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{apiUrl}TblIncidentInvestigationByForestGuards/CheckExistenceByIncidentId?incidentId={incidentId}";
                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var jsonObj = Newtonsoft.Json.Linq.JObject.Parse(result);
                        bool exists = jsonObj["exists"]?.Value<bool>() ?? false;

                        return exists;
                    }
                }
            }
            catch (Exception ex)
            {
                // You can log the exception here if needed
            }
            return false;
        }

        private List<Document> GetDocumentsFromApi(string incidentId)
        {
            try
            {
                string jsonResponse = GetDataForPopupDocumentVerify(incidentId);
                var jsonObj = JObject.Parse(jsonResponse);

                var documents = jsonObj["documents"].ToObject<List<Document>>();

                bool allTrue = documents.All(d => d.overallStatus);
                bool anyFalse = documents.Any(d => !d.overallStatus);

                if (allTrue)
                {
                    Console.WriteLine("✅ All documents have OverallStatus = true.");
                }
                else if (anyFalse)
                {
                    Console.WriteLine("⚠️ At least one document has OverallStatus = false.");
                }

                return documents;
            }
            catch (Exception ex)
            {
                return new List<Document>();
            }
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

        protected void ddl_damage_type_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                BindAmount();
            }
            catch (Exception ex)
            {

            }
        }

        //protected void btn_submit_recommendation_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        string UploadedByUserId = Session["UserId"]?.ToString();
        //        Int32 UploadedByRoleId = Convert.ToInt32(Session["RoleId"]);
        //        string Remarks = txtRecommendationRemarks.Text;
        //        string CreatedBy = Session["Name"].ToString();
        //        string IncidentId = Session["incidentId"].ToString();
        //        string ClaimCategory = Session["ClaimCategory"].ToString();

        //        bool anyFileUploaded = false;

        //        // Get roleId from session
        //        int roleId = Convert.ToInt32(Session["RoleId"]);
        //        string RoleName = Session["RoleName"].ToString();

        //        // Define the conditional label for Generated Notesheet
        //        string generatedNotesheetLabel = "Generated Notesheet";
        //        if (roleId == 8)
        //        {
        //            generatedNotesheetLabel = "Generated Notesheet by " + RoleName;
        //        }
        //        else if (roleId == 9)
        //        {
        //            generatedNotesheetLabel = "Generated Notesheet by " + RoleName;
        //        }
        //        else if (roleId == 10)
        //        {
        //            generatedNotesheetLabel = "Generated Notesheet by " + RoleName;
        //        }

        //        var fileUploadsWithLabels = new List<(FileUpload File, string DocName)>
        //{
        //    (NajriNaksha, "Najri Naksha"),
        //    (ForesterInspectionReport, "Forester Inspection Report"),
        //    (Photographs, "Photographs"),
        //    (AdditionalDocuments, "Additional Documents"),
        //    (GeneratedNotesheetUpload, generatedNotesheetLabel)
        //};


        //        foreach (var item in fileUploadsWithLabels)
        //        {
        //            var fileUpload = item.File;
        //            string docName = item.DocName;

        //            if (fileUpload.HasFile)
        //            {
        //                string FileName = fileUpload.FileName;
        //                Stream fileStream = fileUpload.PostedFile.InputStream;

        //                string result = AddRecommendationDocument(
        //                    IncidentId,
        //                    UploadedByUserId,
        //                    UploadedByRoleId,
        //                    docName,
        //                    Remarks,
        //                    FileName,
        //                    fileStream,
        //                    CreatedBy
        //                );

        //                if (!string.IsNullOrEmpty(result) && result != "Not Found")
        //                {
        //                    anyFileUploaded = true;
        //                }
        //            }
        //        }

        //        string yy = "";
        //        string laststatus = "";
        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={IncidentId}";

        //            HttpResponseMessage response = client.GetAsync(requestUrl).Result;

        //            if (response.IsSuccessStatusCode)
        //            {
        //                string json = response.Content.ReadAsStringAsync().Result;
        //                JObject obj = JObject.Parse(json);

        //                laststatus = obj["status"]?.ToString();
        //            }
        //        }

        //        string Status = string.Empty;

        //        if (!string.IsNullOrEmpty(ClaimCategory) && (ClaimCategory.Contains("Human") || ClaimCategory.Contains("Cattle")))
        //        {
        //            if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("remaining"))
        //            {
        //                Status = "Final Payment Recommended by " + Session["RoleName"];
        //            }
        //            else
        //            {
        //                Status = "Advance Payment Recommended by " + Session["RoleName"];
        //            }
        //        }
        //        else
        //        {
        //            Status = "Payment Recommended by " + Session["RoleName"];
        //        }

        //        int damage_type = 0;

        //        if (roleId == 10)
        //        {
        //            damage_type = Convert.ToInt32(ddl_damage_type.SelectedValue);
        //        }

        //        UpdateApplicantStatus_DamageTypeId(IncidentId, Status, Session["UserId"]?.ToString(), damage_type);

        //        string roleName1 = Session["RoleName"].ToString();
        //        string action = Status;
        //        string remarks = $"Advance Payment Recommended for Incident ID: {IncidentId}";
        //        string createdBy = Session["Userid"].ToString();

        //        ApiResult result1 = ApiHelper.PostIncidentProgressLog(this, IncidentId, roleId.ToString(), roleName1, Status, createdBy, remarks);

        //        string userId = Session["UserId"]?.ToString();
        //        string status = "";

        //        if (roleId != 10)
        //        {
        //            gv_incident_list.Columns[11].Visible = false;
        //        }

        //        if (roleId == 10) // RO
        //        {
        //            status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
        //        }
        //        else if (roleId == 9) //SDO
        //        {
        //            status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
        //        }
        //        else if (roleId == 8) //DFO
        //        {
        //            status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
        //        }
        //        else
        //        {
        //            status = "All";
        //        }

        //        string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

        //        BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

        //        string script = @"Swal.fire({
        //    title: 'Recommended Successfully!',
        //    text: 'Recommended and forwarded successfully.',
        //    icon: 'success',
        //    showConfirmButton: true,
        //    confirmButtonText: 'OK',
        //    background: '#f0f9ff',
        //    color: '#1a202c',
        //    iconColor: '#38a169',
        //    showClass: { popup: 'animate__animated animate__fadeInDown' },
        //    hideClass: { popup: 'animate__animated animate__fadeOutUp' }
        //});";

        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "verifyAlert", script, true);
        //    }
        //    catch (Exception ex)
        //    {
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('Error: {ex.Message}');", true);
        //    }
        //}



        protected void btn_submit_recommendation_Click(object sender, EventArgs e)
        {
            try
            {
                string UploadedByUserId = Session["UserId"]?.ToString();
                Int32 UploadedByRoleId = Convert.ToInt32(Session["RoleId"]);
                string Remarks = txtRecommendationRemarks.Text;
                string CreatedBy = Session["Name"].ToString();
                string IncidentId = Session["incidentId"].ToString();
                string ClaimCategory = Session["ClaimCategory"].ToString();

                bool anyFileUploaded = false;

                // Get roleId from session
                int roleId = Convert.ToInt32(Session["RoleId"]);
                string RoleName = Session["RoleName"].ToString();




                //string IncidentId = Session["incidentId"].ToString();
                //int roleId = Convert.ToInt32(Session["RoleId"]);

                // 🔒 STEP-3 FIX: Detect payment phase
                string paymentPhase = GetPaymentPhase(IncidentId);

                // ❌ Advance not allowed once FINAL started
                //if (paymentPhase == "FINAL")
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "blockAdvance",
                //    "Swal.fire('Not Allowed','Advance payment phase is already closed. Please proceed with Final payment only.','warning');", true);
                //    return;
                //}




                // Define the conditional label for Generated Notesheet
                string generatedNotesheetLabel = "Generated Notesheet";
                if (roleId == 8)
                {
                    generatedNotesheetLabel = "Generated Notesheet by " + RoleName;
                }
                else if (roleId == 9)
                {
                    generatedNotesheetLabel = "Generated Notesheet by " + RoleName;
                }
                else if (roleId == 10)
                {
                    generatedNotesheetLabel = "Generated Notesheet by " + RoleName;
                }

                var fileUploadsWithLabels = new List<(FileUpload File, string DocName)>
        {
            (NajriNaksha, "Najri Naksha"),
            (ForesterInspectionReport, "Forester Inspection Report"),
            (Photographs, "Photographs"),
            (AdditionalDocuments, "Additional Documents"),
            (GeneratedNotesheetUpload, generatedNotesheetLabel)
        };


                foreach (var item in fileUploadsWithLabels)
                {
                    var fileUpload = item.File;
                    string docName = item.DocName;

                    if (fileUpload.HasFile)
                    {
                        string FileName = fileUpload.FileName;
                        Stream fileStream = fileUpload.PostedFile.InputStream;

                        string result = AddRecommendationDocument(
                            IncidentId,
                            UploadedByUserId,
                            UploadedByRoleId,
                            docName,
                            Remarks,
                            FileName,
                            fileStream,
                            CreatedBy
                        );

                        if (!string.IsNullOrEmpty(result) && result != "Not Found")
                        {
                            anyFileUploaded = true;
                        }
                    }
                }

                string yy = "";
                string laststatus = "";
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={IncidentId}";

                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;
                        JObject obj = JObject.Parse(json);

                        laststatus = obj["status"]?.ToString();
                    }
                }

                //string Status = string.Empty;

                //if (!string.IsNullOrEmpty(ClaimCategory) && (ClaimCategory.Contains("Human") || ClaimCategory.Contains("Cattle")))
                //{
                //    if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("remaining"))
                //    {
                //        Status = "Final Payment Recommended by " + Session["RoleName"];
                //    }
                //    else
                //    {
                //        Status = "Advance Payment Recommended by " + Session["RoleName"];
                //    }
                //}
                //else
                //{
                //    Status = "Payment Recommended by " + Session["RoleName"];
                //}




                string Status = string.Empty;

                if (!string.IsNullOrEmpty(ClaimCategory) &&
                   (ClaimCategory.Contains("Human") || ClaimCategory.Contains("Cattle")))
                {
                    //if (paymentPhase == "FINAL")
                    //{
                    //    Status = "Final Payment Recommended by " + Session["RoleName"];
                    //}
                    //else
                    //{
                    //    Status = "Advance Payment Recommended by " + Session["RoleName"];
                    //}

                    if (paymentPhase == "ADVANCE_DONE")
                    {
                        Status = "Final Payment Recommended by " + Session["RoleName"];
                    }
                    else if(paymentPhase == "FINAL")
                    {
                        Status = "Final Payment Recommended by " + Session["RoleName"];
                    }
                    else
                    {
                        Status = "Advance Payment Recommended by " + Session["RoleName"];
                    }


                }
                else
                {
                    Status = "Payment Recommended by " + Session["RoleName"];
                }




                int damage_type = 0;

                if (roleId == 10)
                {
                    damage_type = Convert.ToInt32(ddl_damage_type.SelectedValue);
                }

                UpdateApplicantStatus_DamageTypeId(IncidentId, Status, Session["UserId"]?.ToString(), damage_type);

                string roleName1 = Session["RoleName"].ToString();
                string action = Status;
                string remarks = $"Advance Payment Recommended for Incident ID: {IncidentId}";
                string createdBy = Session["Userid"].ToString();

                ApiResult result1 = ApiHelper.PostIncidentProgressLog(this, IncidentId, roleId.ToString(), roleName1, Status, createdBy, remarks);

                string userId = Session["UserId"]?.ToString();
                string status = "";

                if (roleId != 10)
                {
                    gv_incident_list.Columns[11].Visible = false;
                }

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
                }
                else
                {
                    status = "All";
                }

                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

                BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

                string script = @"Swal.fire({
            title: 'Recommended Successfully!',
            text: 'Recommended and forwarded successfully.',
            icon: 'success',
            showConfirmButton: true,
            confirmButtonText: 'OK',
            background: '#f0f9ff',
            color: '#1a202c',
            iconColor: '#38a169',
            showClass: { popup: 'animate__animated animate__fadeInDown' },
            hideClass: { popup: 'animate__animated animate__fadeOutUp' }
        });";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "verifyAlert", script, true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('Error: {ex.Message}');", true);
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

                        var url = $"{apiUrl}TblIncidentDetails/PutTblIncidentDetails";
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

        public string UpdateApplicantStatus_DamageTypeId(string IncidentId, string Status, string UpdatedBy, int damage_type_id)
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

                        var url = $"{apiUrl}TblIncidentDetails/PutTblIncidentDetails";
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

        public string AddRecommendationDocument(string IncidentId, string UploadedByUserId, Int32 UploadedByRoleId, string DocumentName, string Remarks, string FileName, Stream FileStream, string CreatedBy)
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
                        form.Add(new StringContent(Remarks ?? ""), "Remarks");
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

                        var url = $"{apiUrl}TblDocumentDetails/PostTblDocumentDetail";
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

        protected void lnkDocuments_Click(object sender, EventArgs e)
        {
            try
            {
                pnlAssignFG.Visible = false;
                pnlIncidentDetails.Visible = false;
                paneldocumentrecommendation.Visible = false;
                PanelPayment.Visible = false;

                LinkButton lnk = (LinkButton)sender;
                GridViewRow row = (GridViewRow)lnk.NamingContainer;
                //string baseUrl = "http://203.122.5.18:9008/uk_forest_web/";

                string baseUrl = "https://ukforestgis.in/";

                string incidentId = gv_incident_list.DataKeys[row.RowIndex].Value.ToString();
                string jsonData = GetDataForPopupDocumentVerify(incidentId);

                if (!string.IsNullOrEmpty(jsonData))
                {
                    JObject incidentDetails = JObject.Parse(jsonData);

                    string incidentStatus = incidentDetails["status"]?.ToString();

                    if (string.IsNullOrEmpty(incidentStatus))
                    {
                        lblIncidentStatus.Text = "N/A";
                        lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
                        lblIncidentStatus.Font.Bold = true;

                        lblIncidentId.Text = "N/A";
                        lblIncidentId.ForeColor = System.Drawing.Color.Blue;
                        lblIncidentId.Font.Bold = true;

                    }
                    else if (incidentStatus.Equals("Application Submission", StringComparison.OrdinalIgnoreCase))
                    {
                        lblIncidentStatus.Text = incidentStatus;
                        lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
                        lblIncidentStatus.Font.Bold = true;

                        lblIncidentId.Text = incidentId;
                        lblIncidentId.ForeColor = System.Drawing.Color.Blue;
                        lblIncidentId.Font.Bold = true;
                    }
                    else
                    {
                        lblIncidentStatus.Text = incidentStatus;
                        lblIncidentStatus.ForeColor = System.Drawing.Color.Blue;
                        lblIncidentStatus.Font.Bold = true;

                        lblIncidentId.Text = incidentId;
                        lblIncidentId.ForeColor = System.Drawing.Color.Blue;
                        lblIncidentId.Font.Bold = true;
                    }

                    JArray docsArray = (JArray)incidentDetails["documents"];
                    foreach (JObject doc in docsArray)
                    {
                        string path = doc["documentPath"]?.ToString().Replace("\\", "/");
                        doc["FullUrl"] = $"{baseUrl}{path}";
                        doc["FilePath"] = path;
                        doc["documentId"] = doc["documentId"]?.ToString() ?? string.Empty;
                        doc["incidentId"] = incidentId;
                    }

                    Repeater2.DataSource = docsArray;
                    Repeater2.DataBind();

                    panelVerifyDocument.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void lnl_recommendation_Click(object sender, EventArgs e)
        {
            try
            {
                pnlIncidentDetails.Visible = false;
                panelVerifyDocument.Visible = false;
                PanelPayment.Visible = false;
                pnlAssignFG.Visible = false;


                LinkButton lnk = (LinkButton)sender;
                GridViewRow row = (GridViewRow)lnk.NamingContainer;
                string incidentId = gv_incident_list.DataKeys[row.RowIndex].Value.ToString();
                string jsonData = GetDataForPopupDocumentVerify(incidentId);

                JObject obj = JObject.Parse(jsonData);
                //int damageTypeId = obj["damageTypeId"] != null ? (int)obj["damageTypeId"] : 0;


                int damageTypeId = 0;

                if (obj["damageTypeId"] != null && obj["damageTypeId"].Type != JTokenType.Null)
                {
                    damageTypeId = (int)obj["damageTypeId"];
                }
                else
                {
                    damageTypeId = 0; // default when null or missing
                }

                Label claimCategory = (Label)row.FindControl("lbl_claimCategory");
                string category = claimCategory.Text.Trim();

                if (category == "Human Death / Injury")
                    category = "Human";
                else if (category == "Cattle Kill")
                    category = "Cattle";
                else if (category == "Crop Damage")
                    category = "Crop";
                else if (category == "Property Damage")
                    category = "House";

                Session["incidentId"] = incidentId;
                Session["ClaimCategory"] = category;

                if (!string.IsNullOrEmpty(jsonData))
                {
                    JObject incidentDetails = JObject.Parse(jsonData);

                    string incidentStatus = incidentDetails["status"]?.ToString();

                    if (string.IsNullOrEmpty(incidentStatus))
                    {
                        lblincidentstatusrecommendation.Text = "N/A";
                        lblincidentstatusrecommendation.ForeColor = System.Drawing.Color.Blue;
                        lblincidentstatusrecommendation.Font.Bold = true;

                        lblincidentrecommendation.Text = "N/A";
                        lblincidentrecommendation.ForeColor = System.Drawing.Color.Blue;
                        lblincidentrecommendation.Font.Bold = true;

                    }
                    else if (incidentStatus.Equals("Application Submission", StringComparison.OrdinalIgnoreCase))
                    {
                        lblincidentstatusrecommendation.Text = incidentStatus;
                        lblincidentstatusrecommendation.ForeColor = System.Drawing.Color.Blue;
                        lblincidentstatusrecommendation.Font.Bold = true;

                        lblincidentrecommendation.Text = incidentId;
                        lblincidentrecommendation.ForeColor = System.Drawing.Color.Blue;
                        lblincidentrecommendation.Font.Bold = true;
                    }
                    else
                    {
                        lblincidentstatusrecommendation.Text = incidentStatus;
                        lblincidentstatusrecommendation.ForeColor = System.Drawing.Color.Blue;
                        lblincidentstatusrecommendation.Font.Bold = true;

                        lblincidentrecommendation.Text = incidentId;
                        lblincidentrecommendation.ForeColor = System.Drawing.Color.Blue;
                        lblincidentrecommendation.Font.Bold = true;
                    }

                    paneldocumentrecommendation.Visible = true;

                    Int32 roleid = Convert.ToInt32(Session["RoleId"]);

                    if (roleid == 10)
                    {
                        div_document_ro.Visible = true;
                    }
                    else
                    {
                        damage_ddl_div.Visible = false;
                        div_document_ro.Visible = false;
                    }

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showrecommendationPopup();", true);

                    if (damageTypeId != 0)
                    {
                        DamageTypeDropdown_byId(damageTypeId);
                    }
                    else
                    {
                        DamageTypeDropdown(category);
                    }
                }
            }
            catch (Exception ex)
            {
                // log error
            }
        }

        protected void Repeater2_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    JObject doc = (JObject)e.Item.DataItem;
                    bool overallStatus = doc["overallStatus"] != null && doc["overallStatus"].ToObject<bool>();

                    Button btnApprove = (Button)e.Item.FindControl("btnApprove");
                    Button btnReject = (Button)e.Item.FindControl("btnReject");
                    Label lblDocStatus = (Label)e.Item.FindControl("lblDocStatus");

                    if (overallStatus) // ✅ overallStatus true → hide all buttons and checkbox
                    {
                        if (btnApprove != null) btnApprove.Visible = false;
                        if (btnReject != null) btnReject.Visible = false;

                        if (lblDocStatus != null)
                        {
                            lblDocStatus.Style["background"] = "green";
                            lblDocStatus.Style["color"] = "white";
                        }

                        lblDocStatus.Style["display"] = "inline-block";
                        lblDocStatus.Style["padding"] = "8px 16px";
                        lblDocStatus.Style["border-radius"] = "20px";
                        lblDocStatus.Style["font-size"] = "12px";
                        lblDocStatus.Style["font-weight"] = "700";
                        lblDocStatus.Style["text-transform"] = "uppercase";
                        lblDocStatus.Style["letter-spacing"] = "0.5px";
                    }
                    else
                    {
                        if (btnApprove != null)
                        {
                            btnApprove.Visible = true;
                        }
                        if (btnReject != null)
                        {
                            btnReject.Visible = true;
                        }

                        if (lblDocStatus != null)
                        {
                            string status = lblDocStatus.Text.Trim().ToLower();

                            switch (status)
                            {
                                case string s when s.Contains("verified"):
                                    lblDocStatus.Style["background"] = "green";
                                    lblDocStatus.Style["color"] = "white";
                                    break;

                                case string s when s.Contains("returned"):
                                    lblDocStatus.Style["background"] = "red";
                                    lblDocStatus.Style["color"] = "white";

                                    if (btnApprove != null) btnApprove.Visible = false;
                                    if (btnReject != null) btnReject.Visible = false;
                                    //if (chkSelectDocument != null) chkSelectDocument.Visible = false;
                                    break;

                                case string s when s.Contains("Application Submission"):
                                    lblDocStatus.Style["background"] = "orange";
                                    lblDocStatus.Style["color"] = "white";
                                    break;

                                default:
                                    lblDocStatus.Style["background"] = "linear-gradient(135deg, #fed7aa, #fbb6ce)";
                                    lblDocStatus.Style["color"] = "#744210";
                                    break;
                            }

                            lblDocStatus.Style["display"] = "inline-block";
                            lblDocStatus.Style["padding"] = "8px 16px";
                            lblDocStatus.Style["border-radius"] = "20px";
                            lblDocStatus.Style["font-size"] = "12px";
                            lblDocStatus.Style["font-weight"] = "700";
                            lblDocStatus.Style["text-transform"] = "uppercase";
                            lblDocStatus.Style["letter-spacing"] = "0.5px";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // log error if needed
            }
        }

        protected void lnkView_Click(object sender, EventArgs e)
        {
            try
            {
                pnlAssignFG.Visible = false;
                panelVerifyDocument.Visible = false;
                paneldocumentrecommendation.Visible = false;
                PanelPayment.Visible = false;

                LinkButton ddl = (LinkButton)sender;
                GridViewRow row = (GridViewRow)ddl.NamingContainer;
                string incidentId = gv_incident_list.DataKeys[row.RowIndex].Value.ToString();
                BindRepeater(incidentId);
                pnlIncidentDetails.Visible = true;
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowPopup", "showIncidentPopup();", true);
            }
            catch (Exception ex)
            {

            }
        }

        protected void lnkAssignFG_Click(object sender, EventArgs e)
        {
            try
            {
                pnlAssignFG.Visible = true;
                panelVerifyDocument.Visible = false;
                paneldocumentrecommendation.Visible = false;
                PanelPayment.Visible = false;
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                string incidentId = gv_incident_list.DataKeys[row.RowIndex].Value.ToString();
                HiddenField hfDocId = (HiddenField)row.FindControl("hfDocumentId");

                if (hfDocId != null)
                {
                    hdidforest.Value = hfDocId.Value; // store document ID
                }

                Session["incidentId"] = incidentId;

                pnlAssignFG.Style["display"] = "block";
            }
            catch (Exception ex)
            {
                // log error
            }
        }

        private void BindForestGuards()
        {
            try
            {
                string userId = Session["UserId"]?.ToString();
                if (string.IsNullOrEmpty(userId))
                {
                    ddlForestGuard.Items.Clear();
                    ddlForestGuard.Items.Add(new ListItem("Error: User ID not found in session", ""));
                    ddlForestGuard.Items.Add(new ListItem("Add New Guard", "0"));
                    return;
                }

                string apiUrl1 = $"{apiUrl}TblForestGuardMasters/Get_TblForestGuardMasters_by_RO?ro_id={HttpUtility.UrlEncode(userId)}";

                HttpResponseMessage response = client.GetAsync(apiUrl1).Result;

                ddlForestGuard.Items.Clear();

                if (response.IsSuccessStatusCode)
                {
                    string json = response.Content.ReadAsStringAsync().Result;

                    JToken token = JToken.Parse(json);
                    JArray guards;

                    // Handle both cases — if API returns array or object with "data"
                    if (token.Type == JTokenType.Array)
                    {
                        guards = (JArray)token;
                    }
                    else if (token["data"] != null && token["data"].Type == JTokenType.Array)
                    {
                        guards = (JArray)token["data"];
                    }
                    else
                    {
                        ddlForestGuard.Items.Add(new ListItem("No Guard found", ""));
                        ddlForestGuard.Items.Add(new ListItem("Add New Guard", "0"));
                        return;
                    }

                    ddlForestGuard.Items.Add(new ListItem("Select Forest Guard", ""));

                    foreach (var g in guards)
                    {
                        string id = g["forestGuardId"]?.ToString();
                        string name = g["name"]?.ToString();

                        if (!string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(name))
                        {
                            ddlForestGuard.Items.Add(new ListItem(name, id));
                        }
                    }

                    ddlForestGuard.Items.Add(new ListItem("Add New Guard", "0"));
                }
                else
                {
                    ddlForestGuard.Items.Add(new ListItem($"Error: API returned {response.StatusCode}", ""));
                    ddlForestGuard.Items.Add(new ListItem("Add New Guard", "0"));
                }
            }
            catch (Exception ex)
            {
                ddlForestGuard.Items.Clear();
                ddlForestGuard.Items.Add(new ListItem($"Exception: {ex.Message}", ""));
                ddlForestGuard.Items.Add(new ListItem("Add New Guard", "0"));
            }
        }

        protected async void ddlForestGuard_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string selectedValue = ddlForestGuard.SelectedValue;
                bool isNewGuard = (selectedValue == "0");

                pnlNewGuardSection.Visible = isNewGuard;
                btnSubmit.Visible = !isNewGuard;
                btnAsign.Visible = isNewGuard;

                txtMobileNumber.Text = string.Empty;
                txtEmail.Text = string.Empty;
                hdidforest.Value = string.Empty;

                if (!isNewGuard && !string.IsNullOrEmpty(selectedValue))
                {
                    string apiUrl1 = $"{apiUrl}TblForestGuardMasters/Get_TblForestGuardMasters_by_Forest_Guard_Id?forest_guard_id={HttpUtility.UrlEncode(selectedValue)}";
                    HttpResponseMessage response = await client.GetAsync(apiUrl1);
                    if (response.IsSuccessStatusCode)
                    {
                        string json = await response.Content.ReadAsStringAsync();
                        JArray guardArray = JArray.Parse(json);

                        if (guardArray.Count > 0)
                        {
                            JObject guard = (JObject)guardArray[0];

                            string mobileNo = guard["mobileNo"]?.ToString();
                            string emailId = guard["emailId"]?.ToString();
                            string forestId = guard["forestGuardId"]?.ToString();

                            txtMobileNumber.Text = mobileNo ?? string.Empty;
                            txtEmail.Text = emailId ?? string.Empty;
                            hdidforest.Value = forestId ?? string.Empty;

                            txtMobileNumber.ReadOnly = true;
                            txtEmail.ReadOnly = true;
                        }
                    }
                    else
                    {
                        txtMobileNumber.Text = "Error loading data";
                        txtEmail.Text = "Error loading data";
                    }

                }
            }
            catch (Exception ex)
            {

            }
        }

        protected async void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string forestGuardId = ddlForestGuard.SelectedValue;
                if (string.IsNullOrEmpty(forestGuardId) || forestGuardId == "0")
                {
                    if (ddlForestGuard.SelectedValue == "0" && !string.IsNullOrEmpty(txtNewGuardName.Text))
                    {
                        forestGuardId = hdidforest.Value;
                        if (string.IsNullOrEmpty(forestGuardId))
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "Swal.fire({icon:'warning', title:'Warning', text:'Please save the new guard first.'});", true);
                            return;
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "Swal.fire({icon:'warning', title:'Warning', text:'Please select a valid forest guard.'});", true);
                        return;
                    }
                }

                string roUserId = Session["UserId"]?.ToString();
                if (string.IsNullOrEmpty(roUserId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "Swal.fire({icon:'error', title:'Error', text:'User ID not found in session.'});", true);
                    return;
                }

                string priority = ddlPriority.SelectedValue;
                if (string.IsNullOrEmpty(priority))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "Swal.fire({icon:'warning', title:'Warning', text:'Please select a priority.'});", true);
                    return;
                }

                string incidentId = Session["incidentId"]?.ToString();
                if (string.IsNullOrEmpty(incidentId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "Swal.fire({icon:'error', title:'Error', text:'Incident ID is required.'});", true);
                    return;
                }

                var formData = new MultipartFormDataContent();
                formData.Add(new StringContent("0"), "Sno");
                formData.Add(new StringContent(""), "InvestigationId");
                formData.Add(new StringContent(incidentId), "IncidentId");
                formData.Add(new StringContent(forestGuardId), "ForestGuardId");
                formData.Add(new StringContent(roUserId), "RoUserId");
                formData.Add(new StringContent(priority), "Priority");

                string apiUrl1 = apiUrl + "TblIncidentInvestigationByForestGuards/PostTblIncidentInvestigationByForestGuards";
                HttpResponseMessage response = await client.PostAsync(apiUrl1, formData);

                string roleName1 = Session["RoleName"].ToString();
                string action = "Incident Assigned to Forest Guard for Funther Investigation";
                string remarks = $"Incident Assigned to Forest Guard for Funther Investigation : {incidentId}";
                string createdBy = Session["Userid"].ToString();


                Int32 roleId = Convert.ToInt32(Session["RoleId"]);

                if (response.IsSuccessStatusCode)
                {
                    UpdateApplicantStatus(incidentId, action, Session["UserId"]?.ToString(), 0);
                    ApiResult result1 = ApiHelper.PostIncidentProgressLog(this, incidentId, roleId.ToString(), roleName1, action, createdBy, remarks);

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", @"
    Swal.fire({
        icon: 'success',
        title: 'Success',
        text: 'Assignment submitted successfully.',
        confirmButtonText: 'OK',
        allowOutsideClick: false
    }).then((result) => {
        if (result.isConfirmed) {
            hidepnlAssignFG();
        }
    });
", true);
                    ddlForestGuard.SelectedValue = "";
                    txtNewGuardName.Text = string.Empty;
                    txtMobileNumber.Text = string.Empty;
                    txtEmail.Text = string.Empty;
                    hdidforest.Value = string.Empty;
                    ddlPriority.SelectedValue = "";
                }
                else
                {
                    string errorDetails = await response.Content.ReadAsStringAsync();
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", $"Swal.fire({{icon:'error', title:'Error', text:'Error submitting assignment: API returned {response.StatusCode}. Details: {errorDetails}'}});", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", $"Swal.fire({{icon:'error', title:'Exception', text:'{ex.Message}'}});", true);
            }
        }


        protected async void btnAsign_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddlForestGuard.SelectedValue != "0")
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        "Swal.fire({icon:'warning', title:'Warning', text:'Please select \"Add New Guard\" to add and assign a new guard.'});", true);
                    return;
                }

                string name = txtNewGuardName.Text;
                if (string.IsNullOrEmpty(name))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        "Swal.fire({icon:'warning', title:'Warning', text:'Please enter a guard name.'});", true);
                    return;
                }

                string mobileNo = txtMobileNumber.Text;
                if (string.IsNullOrEmpty(mobileNo))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        "Swal.fire({icon:'warning', title:'Warning', text:'Please enter a mobile number.'});", true);
                    return;
                }

                string emailId = txtEmail.Text;
                if (string.IsNullOrEmpty(emailId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        "Swal.fire({icon:'warning', title:'Warning', text:'Please enter an email address.'});", true);
                    return;
                }

                string roUserId = Session["UserId"]?.ToString();
                if (string.IsNullOrEmpty(roUserId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        "Swal.fire({icon:'error', title:'Error', text:'User ID not found in session.'});", true);
                    return;
                }

                string priority = ddlPriority.SelectedValue;
                if (string.IsNullOrEmpty(priority))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        "Swal.fire({icon:'warning', title:'Warning', text:'Please select a priority.'});", true);
                    return;
                }

                string incidentId = Session["incidentId"]?.ToString();
                if (string.IsNullOrEmpty(incidentId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        "Swal.fire({icon:'error', title:'Error', text:'Incident ID is required.'});", true);
                    return;
                }

                var guardFormData = new MultipartFormDataContent();
                guardFormData.Add(new StringContent("0"), "Sno");
                guardFormData.Add(new StringContent(""), "ForestGuardId");
                guardFormData.Add(new StringContent(name), "Name");
                guardFormData.Add(new StringContent(mobileNo), "MobileNo");
                guardFormData.Add(new StringContent(emailId), "EmailId");
                guardFormData.Add(new StringContent(roUserId), "RoUserId");

                string createGuardUrl = apiUrl + "TblForestGuardMasters/PostTblForestGuardMasters";
                HttpResponseMessage createResponse = await client.PostAsync(createGuardUrl, guardFormData);

                if (!createResponse.IsSuccessStatusCode)
                {
                    string errorDetails = await createResponse.Content.ReadAsStringAsync();
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        $"Swal.fire({{icon:'error', title:'Error', text:'Error creating guard: API returned {createResponse.StatusCode}. Details: {errorDetails}'}});", true);
                    return;
                }

                string createJson = await createResponse.Content.ReadAsStringAsync();
                JObject createResult = JObject.Parse(createJson);
                string forestGuardId = createResult["forestGuardId"]?.ToString();

                if (string.IsNullOrEmpty(forestGuardId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        "Swal.fire({icon:'error', title:'Error', text:'Error: Forest Guard ID not returned by API.'});", true);
                    return;
                }

                var assignFormData = new MultipartFormDataContent();
                assignFormData.Add(new StringContent("0"), "Sno");
                assignFormData.Add(new StringContent(""), "InvestigationId");
                assignFormData.Add(new StringContent(incidentId), "IncidentId");
                assignFormData.Add(new StringContent(forestGuardId), "ForestGuardId");
                assignFormData.Add(new StringContent(roUserId), "RoUserId");
                assignFormData.Add(new StringContent(priority), "Priority");

                string assignUrl = apiUrl + "TblIncidentInvestigationByForestGuards/PostTblIncidentInvestigationByForestGuards";
                HttpResponseMessage assignResponse = await client.PostAsync(assignUrl, assignFormData);

                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string roleName1 = Session["RoleName"].ToString();
                string action = "Incident Assigned to Forest Guard for Funther Investigation";
                string remarks = $"Incident Assigned to Forest Guard for Funther Investigation : {incidentId}";
                string createdBy = Session["Userid"].ToString();

                if (assignResponse.IsSuccessStatusCode)
                {
                    UpdateApplicantStatus(incidentId, action, Session["UserId"]?.ToString(), 0);
                    ApiResult result1 = ApiHelper.PostIncidentProgressLog(this, incidentId, roleId.ToString(), roleName1, action, createdBy, remarks);

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", @"
    Swal.fire({
        icon: 'success',
        title: 'Success',
        text: 'New guard created and assigned successfully.',
        confirmButtonText: 'OK',
        allowOutsideClick: false
    }).then((result) => {
        if (result.isConfirmed) {
            hidepnlAssignFG();
        }
    });
", true);
                    ddlForestGuard.SelectedValue = "";
                    txtNewGuardName.Text = string.Empty;
                    txtMobileNumber.Text = string.Empty;
                    txtEmail.Text = string.Empty;
                    hdidforest.Value = string.Empty;
                    ddlPriority.SelectedValue = "";

                    BindForestGuards();
                }
                else
                {
                    string errorDetails = await assignResponse.Content.ReadAsStringAsync();
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                        $"Swal.fire({{icon:'error', title:'Error', text:'Error assigning guard: API returned {assignResponse.StatusCode}. Details: {errorDetails}'}});", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert",
                    $"Swal.fire({{icon:'error', title:'Exception', text:'{ex.Message}'}});", true);
            }
        }

        protected void btnRefreshGrid_Click(object sender, EventArgs e)
        {

            pnlAssignFG.Style["display"] = "none";

            string userId = Session["UserId"]?.ToString();
            Int32 roleId = Convert.ToInt32(Session["RoleId"]);
            string status = "Application Submission";

            if (roleId == 10) // RO
            {
                status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
            }
            else if (roleId == 9) //SDO
            {
                status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
            }
            else if (roleId == 8) //DFO
            {
                status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
            }
            else
            {
                status = "All";
            }

            string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

            BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);
        }


        private void DocumentStatus()
        {
            try
            {
                string incidentId = lblIncidentId.Text;

                if (!string.IsNullOrEmpty(incidentId))
                {
                    bool allDocsVerified = AreAllDocumentsVerified(incidentId);

                    if (!allDocsVerified)
                    {
                        return;
                    }
                    else
                    {
                        string Incidentstatus = "Document Verified by " + Session["RoleName"].ToString();
                        UpdateApplicantStatus(incidentId, Incidentstatus, Session["UserId"]?.ToString(), 0);

                        string roleName1 = Session["RoleName"].ToString();
                        string action = "Document verified by " + roleName1;
                        string remarks = $"Uploaded documents for Incident ID: {incidentId}";
                        string roleId = Session["roleid"].ToString();
                        string createdBy = Session["Userid"].ToString();

                        // Call the new method
                        ApiResult result = ApiHelper.PostIncidentProgressLog(this, incidentId, roleId, roleName1, action, createdBy, remarks);

                        if (result.Success)
                        {
                            // Do something if log is saved successfully
                            // For example:
                        }
                        else
                        {
                            // Handle failure
                        }
                    }
                }

                panelVerifyDocument.Style["display"] = "none";
            }
            catch (Exception ex)
            {
                // Log error
            }
        }

        protected void lnkpayment_Click(object sender, EventArgs e)
        {
            try
            {
                pnlAssignFG.Visible = false;
                pnlIncidentDetails.Visible = false;
                paneldocumentrecommendation.Visible = false;
                panelVerifyDocument.Visible = false;

                LinkButton lnk = (LinkButton)sender;
                GridViewRow row = (GridViewRow)lnk.NamingContainer;
                string incidentId = gv_incident_list.DataKeys[row.RowIndex].Value.ToString();
                Label claimCategory = (Label)row.FindControl("lbl_claimCategory");
                string category = claimCategory.Text.Trim();

                string jsonData = GetDataForPopupDocumentVerify(incidentId);

                if (!string.IsNullOrEmpty(jsonData))
                {
                    JObject incidentDetails = JObject.Parse(jsonData);

                    string incidentStatus = incidentDetails["status"]?.ToString();

                    Session["incidentId"] = incidentId;
                    Session["ClaimCategory"] = category;
                    PanelPayment.Visible = true;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showpnlPanelPayment();", true);
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void gv_incident_list_RowCreated(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.Header || e.Row.RowType == DataControlRowType.DataRow || e.Row.RowType == DataControlRowType.Footer)
                {
                    int roleId = Convert.ToInt32(Session["RoleId"]);
                    GridView gv = (GridView)sender;

                    int paymentColumnIndex = -1;
                    int recommendationColumnIndex = -1;

                    for (int i = 0; i < gv.Columns.Count; i++)
                    {
                        if (gv.Columns[i].HeaderText == "Payment")
                        {
                            paymentColumnIndex = i;
                        }
                        if (gv.Columns[i].HeaderText == "Recommendation")
                        {
                            recommendationColumnIndex = i;
                        }
                    }

                    if (roleId == 8)
                    {
                        if (recommendationColumnIndex >= 0 && recommendationColumnIndex < e.Row.Cells.Count)
                        {
                            e.Row.Cells[recommendationColumnIndex].Visible = false;
                        }
                    }
                    else
                    {
                        if (paymentColumnIndex >= 0 && paymentColumnIndex < e.Row.Cells.Count)
                        {
                            e.Row.Cells[paymentColumnIndex].Visible = false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Optionally log error
            }
        }

        protected void Button1_Click1(object sender, EventArgs e)
        {
            try
            {
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "";
                if (roleId != 10)
                {
                    gv_incident_list.Columns[11].Visible = false;  // index adjust karna ho sakta hai
                }

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
                }
                else
                {
                    status = "All";
                }

                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;
                BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

                panelVerifyDocument.Visible = false;
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showpnlPanelPayment();", true);
            }
            catch (Exception ex)
            {

            }
        }

        //protected void btn_payment_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        string UploadedByUserId = Session["UserId"]?.ToString();
        //        Int32 UploadedByRoleId = Convert.ToInt32(Session["RoleId"]);
        //        string Remarks = txtremarkpayment.Text;
        //        string CreatedBy = Session["Name"].ToString();
        //        string IncidentId = Session["incidentId"].ToString();
        //        string ClaimCategory = Session["ClaimCategory"].ToString();

        //        bool anyFileUploaded = false;

        //        // File upload checks
        //        var fileUploadsWithLabels = new List<(FileUpload File, string DocName)>
        //        {
        //            (NajriNaksha, "Najri Naksha"),
        //            (ForesterInspectionReport, "Forester Inspection Report"),
        //            (Photographs, "Photographs"),
        //            (AdditionalDocuments, "Additional Documents"),
        //            (GeneratedNotesheetUploadPayment, "Generated Notesheet")
        //        };

        //        foreach (var item in fileUploadsWithLabels)
        //        {
        //            var fileUpload = item.File;
        //            string docName = item.DocName;

        //            if (fileUpload.HasFile)
        //            {
        //                string FileName = fileUpload.FileName;
        //                Stream fileStream = fileUpload.PostedFile.InputStream;

        //                string result = AddRecommendationDocument(
        //                    IncidentId,
        //                    UploadedByUserId,
        //                    UploadedByRoleId,
        //                    docName,
        //                    Remarks,
        //                    FileName,
        //                    fileStream,
        //                    CreatedBy
        //                );

        //                if (!string.IsNullOrEmpty(result) && result != "Not Found")
        //                {
        //                    anyFileUploaded = true;
        //                }
        //            }
        //        }

        //        string laststatus = "";

        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={IncidentId}";

        //            HttpResponseMessage response = client.GetAsync(requestUrl).Result;

        //            if (response.IsSuccessStatusCode)
        //            {
        //                string json = response.Content.ReadAsStringAsync().Result;
        //                JObject obj = JObject.Parse(json);

        //                laststatus = obj["status"]?.ToString();
        //            }
        //        }

        //        string Status = string.Empty;

        //        if (!string.IsNullOrEmpty(ClaimCategory) && (ClaimCategory.Contains("Human") || ClaimCategory.Contains("Cattle")))
        //        {
        //            if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("remaining"))
        //            {
        //                Status = "Final Payment Recommended by " + Session["RoleName"];
        //            }
        //            else
        //            {
        //                Status = "Advance Payment Recommended by " + Session["RoleName"];
        //            }
        //        }
        //        else
        //        {
        //            Status = "Payment Recommended by " + Session["RoleName"];
        //        }

        //        Int32 roleId = Convert.ToInt32(Session["RoleId"]);

        //        if (roleId == 10)
        //        {
        //            UpdateApplicantStatus_DamageTypeId(IncidentId, Status, Session["UserId"]?.ToString(), Convert.ToInt32(ddl_damage_type.SelectedValue));
        //        }
        //        else
        //        {
        //            UpdateApplicantStatus(IncidentId, Status, Session["UserId"]?.ToString(), 0);
        //        }

        //        string roleName1 = Session["RoleName"].ToString();
        //        string action = Status;
        //        string remarks = $"Advanced Recommended for Incident ID: {IncidentId}";
        //        string createdBy = Session["Userid"].ToString();

        //        ApiResult result1 = ApiHelper.PostIncidentProgressLog(this, IncidentId, roleId.ToString(), roleName1, action, createdBy, remarks);

        //        string userId = Session["UserId"]?.ToString();
        //        string status = "";

        //        if (roleId != 10)
        //        {
        //            gv_incident_list.Columns[11].Visible = false;
        //        }

        //        if (roleId == 10) // RO
        //        {
        //            status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
        //        }
        //        else if (roleId == 9) //SDO
        //        {
        //            status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
        //        }
        //        else if (roleId == 8) //DFO
        //        {
        //            status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
        //        }
        //        else
        //        {
        //            status = "All";
        //        }

        //        string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;
        //        BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

        //        // ✅ SweetAlert2 Script (Fixed)
        //        string script = anyFileUploaded
        //            ? @"Swal.fire({
        //            title: 'Payment Initiated Successfully!',
        //            text: 'Payment Initiated and forwarded to Account successfully.',
        //            icon: 'success',
        //            confirmButtonText: 'OK',
        //            background: '#f0f9ff',
        //            color: '#1a202c',
        //            iconColor: '#38a169'
        //        });"
        //            : @"Swal.fire({
        //            title: 'Document Verified!',
        //            text: 'No documents selected for upload.',
        //            icon: 'info',
        //            confirmButtonText: 'OK',
        //            background: '#f0f9ff',
        //            color: '#1a202c',
        //            iconColor: '#3182ce'
        //        });";

        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "verifyAlert", $"setTimeout(function(){{ {script} }}, 300);", true);

        //        PanelPayment.Visible = false;

        //    }
        //    catch (Exception ex)
        //    {
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('Error: {ex.Message}');", true);
        //    }
        //}




        protected void btn_payment_Click(object sender, EventArgs e)
        {
            try
            {
                string UploadedByUserId = Session["UserId"]?.ToString();
                Int32 UploadedByRoleId = Convert.ToInt32(Session["RoleId"]);
                string Remarks = txtremarkpayment.Text;
                string CreatedBy = Session["Name"].ToString();
                string IncidentId = Session["incidentId"].ToString();
                string ClaimCategory = Session["ClaimCategory"].ToString();

                bool anyFileUploaded = false;






                //string IncidentId = Session["incidentId"].ToString();
                int roleId = Convert.ToInt32(Session["RoleId"]);

                // 🔒 STEP-3 FIX
                string paymentPhase = GetPaymentPhase(IncidentId);

                //if (paymentPhase == "FINAL")
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "blockAdvance",
                //    "Swal.fire('Not Allowed','Advance payment phase is already closed. Only Final payment is allowed.','warning');", true);
                //    return;
                //}





                // File upload checks
                var fileUploadsWithLabels = new List<(FileUpload File, string DocName)>
                {
                    (NajriNaksha, "Najri Naksha"),
                    (ForesterInspectionReport, "Forester Inspection Report"),
                    (Photographs, "Photographs"),
                    (AdditionalDocuments, "Additional Documents"),
                    (GeneratedNotesheetUploadPayment, "Generated Notesheet")
                };

                foreach (var item in fileUploadsWithLabels)
                {
                    var fileUpload = item.File;
                    string docName = item.DocName;

                    if (fileUpload.HasFile)
                    {
                        string FileName = fileUpload.FileName;
                        Stream fileStream = fileUpload.PostedFile.InputStream;

                        string result = AddRecommendationDocument(
                            IncidentId,
                            UploadedByUserId,
                            UploadedByRoleId,
                            docName,
                            Remarks,
                            FileName,
                            fileStream,
                            CreatedBy
                        );

                        if (!string.IsNullOrEmpty(result) && result != "Not Found")
                        {
                            anyFileUploaded = true;
                        }
                    }
                }

                string laststatus = "";

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={IncidentId}";

                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;
                        JObject obj = JObject.Parse(json);

                        laststatus = obj["status"]?.ToString();
                    }
                }

                //string Status = string.Empty;

                //if (!string.IsNullOrEmpty(ClaimCategory) && (ClaimCategory.Contains("Human") || ClaimCategory.Contains("Cattle")))
                //{
                //    if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("remaining"))
                //    {
                //        Status = "Final Payment Recommended by " + Session["RoleName"];
                //    }
                //    else
                //    {
                //        Status = "Advance Payment Recommended by " + Session["RoleName"];
                //    }
                //}
                //else
                //{
                //    Status = "Payment Recommended by " + Session["RoleName"];
                //}





                string Status = string.Empty;

                if (!string.IsNullOrEmpty(ClaimCategory) &&
                   (ClaimCategory.Contains("Human") || ClaimCategory.Contains("Cattle")))
                {
                    if (paymentPhase == "FINAL")
                    {
                        Status = "Final Payment Recommended by " + Session["RoleName"];
                    }
                    else
                    {
                        Status = "Advance Payment Recommended by " + Session["RoleName"];
                    }
                }
                else
                {
                    Status = "Payment Recommended by " + Session["RoleName"];
                }





                //Int32 roleId = Convert.ToInt32(Session["RoleId"]);

                if (roleId == 10)
                {
                    UpdateApplicantStatus_DamageTypeId(IncidentId, Status, Session["UserId"]?.ToString(), Convert.ToInt32(ddl_damage_type.SelectedValue));
                }
                else
                {
                    UpdateApplicantStatus(IncidentId, Status, Session["UserId"]?.ToString(), 0);
                }

                string roleName1 = Session["RoleName"].ToString();
                string action = Status;
                string remarks = $"Advanced Recommended for Incident ID: {IncidentId}";
                string createdBy = Session["Userid"].ToString();

                ApiResult result1 = ApiHelper.PostIncidentProgressLog(this, IncidentId, roleId.ToString(), roleName1, action, createdBy, remarks);

                string userId = Session["UserId"]?.ToString();
                string status = "";

                if (roleId != 10)
                {
                    gv_incident_list.Columns[11].Visible = false;
                }

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Application Re-Submission, Document Verified by Range Officer, Remaining Document Verified by Range Officer, Advance Payment Recommended by DFO, Document Returned by Range Officer, Incident Assigned to Forest Guard for Funther Investigation, Advance Payment processed successfully";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Remaining Document Verified by SDO, Advance Payment Recommended by Range Officer, Final Payment Recommended by Range Officer, Payment Recommended by Range Officer, Document Returned by SDO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Remaining Document Verified by DFO, Advance Payment Recommended by SDO, Final Payment Recommended by SDO, Payment Recommended by SDO, Document Returned by DFO";
                }
                else
                {
                    status = "All";
                }

                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;
                BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

                // ✅ SweetAlert2 Script (Fixed)
                string script = anyFileUploaded
                    ? @"Swal.fire({
                    title: 'Payment Initiated Successfully!',
                    text: 'Payment Initiated and forwarded to Account successfully.',
                    icon: 'success',
                    confirmButtonText: 'OK',
                    background: '#f0f9ff',
                    color: '#1a202c',
                    iconColor: '#38a169'
                });"
                    : @"Swal.fire({
                    title: 'Document Verified!',
                    text: 'No documents selected for upload.',
                    icon: 'info',
                    confirmButtonText: 'OK',
                    background: '#f0f9ff',
                    color: '#1a202c',
                    iconColor: '#3182ce'
                });";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "verifyAlert", $"setTimeout(function(){{ {script} }}, 300);", true);

                PanelPayment.Visible = false;

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('Error: {ex.Message}');", true);
            }
        }



        private string GetPaymentPhase(string incidentId)
        {
            // Call same API you already use
            using (var client = new HttpClient())
            {
                //string url = $"{apiUrl}TblIncidentDetails/GetIncidentProgressLog?incidentId={incidentId}";
                string url = $"{apiUrl}IncidentProgressLogs/GetIncidentProgressLog?incident_id={incidentId}";
                var response = client.GetAsync(url).Result;

                if (!response.IsSuccessStatusCode)
                    return "NONE";

                var json = response.Content.ReadAsStringAsync().Result;
                JArray logs = JArray.Parse(json);

                bool advanceDone = logs.Any(x =>
                    x["action"]?.ToString().ToLower().Contains("advance payment processed successfully") == true);

                bool finalStarted = logs.Any(x =>
                    x["action"]?.ToString().ToLower().Contains("final payment recommended") == true);

                if (finalStarted)
                    return "FINAL";

                if (advanceDone)
                    return "ADVANCE_DONE";

                return "ADVANCE";
            }
        }




    }
}