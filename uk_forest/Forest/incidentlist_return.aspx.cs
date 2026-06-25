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
    public partial class incidentlist_return : System.Web.UI.Page
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
                    DateTime today = DateTime.Today;
                    DateTime startDate = today.AddYears(-1).AddDays(1); // 1 year ago + 1 day
                    txtFromDate.Text = startDate.ToString("yyyy-MM-dd"); // 2024-11-18
                    txtToDate.Text = today.ToString("yyyy-MM-dd");

                    string userId = Session["UserId"]?.ToString();
                    Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                    string status = "Application Submission";

                    ViewState["ApplicantId"] = userId;

                    //if (roleId != 10)
                    //{
                    //    gv_incident_list.Columns[11].Visible = false;  // index adjust karna ho sakta hai
                    //}

                    if (roleId == 10) // RO
                    {
                        status = "Document Returned by SDO";
                    }
                    else if (roleId == 9) //SDO
                    {
                        status = "Document Returned by DFO";
                    }
                    else if (roleId == 8) //DFO
                    {
                        status = "";
                    }
                    else
                    {
                        status = "Document Returned by Range Officer";
                    }

                    string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

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
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Application Submission";

                if (roleId != 10)
                {
                    gv_incident_list.Columns[11].Visible = false;
                }

                if (roleId == 10) // RO
                {
                    status = "Document Returned by SDO";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Returned by DFO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "";
                }
                else
                {
                    status = "Document Returned by Range Officer";
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
                    status = "Document Returned by SDO";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Returned by DFO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "";
                }
                else
                {
                    status = "Document Returned by Range Officer";
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

                //string url = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId_return?incidentId={incident_Id}";
                string url = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId_return_new?incidentId={incident_Id}";

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
                //string baseUrl = "http://203.122.5.18:9008/uk_forest_web/";

                string baseUrl = "https://ukforestgis.in/";

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
                    status = "Document Returned by SDO";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Returned by DFO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "";
                }
                else
                {
                    status = "Document Returned by Range Officer";
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
                        status = "Document Returned by SDO";
                    }
                    else if (roleId == 9) //SDO
                    {
                        status = "Document Returned by DFO";
                    }
                    else if (roleId == 8) //DFO
                    {
                        status = "";
                    }
                    else
                    {
                        status = "Document Returned by Range Officer";
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
                        status = "Document Returned by SDO";
                    }
                    else if (roleId == 9) //SDO
                    {
                        status = "Document Returned by DFO";
                    }
                    else if (roleId == 8) //DFO
                    {
                        status = "";
                    }
                    else
                    {
                        status = "Document Returned by Range Officer";
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
        private void ProcessDocumentReturn(RepeaterItem item)
        {
            try
            {
                TextBox txtReason = (TextBox)item.FindControl("txt_reason");
                if (txtReason == null) return;

                // Ensure reason is provided
                if (string.IsNullOrWhiteSpace(txtReason.Text))
                {
                    // show message - reason required
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

                // Call your existing function to approve/return the doc (keeps behavior same)
                ApproveDocument(incidentId, documentId, userId, roleId, status, userId, Comments);

                bool allDocsVerified = AreAllDocumentsVerified(incidentId);

                string roleName1 = Session["RoleName"]?.ToString() ?? "";
                string action = "Document Returned by " + roleName1;
                string remarks = $"Uploaded documents for Incident ID: {incidentId}";
                string roleId1 = Session["roleid"]?.ToString() ?? "";
                string createdBy = Session["Userid"]?.ToString() ?? "";

                // Call API to fetch last status and post progress log if needed
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

                        if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("document returned by"))
                        {
                            // already has document returned by => do nothing for action
                        }
                        else
                        {
                            ApiResult result = ApiHelper.PostIncidentProgressLog(this, incidentId, roleId1, roleName1, action, createdBy, remarks);
                        }
                    }
                }

                UpdateApplicantStatus(incidentId, Incidentstatus, Session["UserId"]?.ToString(), 0);

                if (roleId == 10) // RO
                {
                    status = "Document Returned by SDO";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Returned by DFO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "";
                }
                else
                {
                    status = "Document Returned by Range Officer";
                }

                // claim_category existence: keep same logic as original
                string claim_category = string.IsNullOrEmpty(rblClaimType.SelectedValue) ? "0" : rblClaimType.SelectedValue;

                // Refresh user grid - keep your existing call
                BindUserGrid(userId, roleId, status, claim_category, txtFromDate.Text, txtToDate.Text);

                // Show success alert
                string successScript = @"
                Swal.fire({
                    title: 'Document Returned!',
                    text: 'The document has been returned successfully.',
                    icon: 'error',
                    showConfirmButton: true,
                    confirmButtonText: 'OK',
                    background: '#f0f9ff',
                    color: '#1a202c',
                    iconColor: '#dc3545',
                    showClass: { popup: 'animate__animated animate__fadeInDown' },
                    hideClass: { popup: 'animate__animated animate__fadeOutUp' }
                });";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "rejectAlert", successScript, true);

                // Re-bind popup documents (same as original)
                //string baseUrl = "http://203.122.5.18:9008/uk_forest_web/"; // keep as original

                string baseUrl = "https://ukforestgis.in/"; // keep as original

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

                // If you need to show the popup again
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
            }
            catch (Exception ex)
            {
                // log or show friendly message
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

                string Status = string.Empty;

                if (!string.IsNullOrEmpty(ClaimCategory) && (ClaimCategory.Contains("Human") || ClaimCategory.Contains("Cattle")))
                {
                    if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("remaining"))
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
                    status = "Document Returned by SDO";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Returned by DFO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "";
                }
                else
                {
                    status = "Document Returned by Range Officer";
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

        protected void lnkediteDocument_Click(object sender, EventArgs e)
        {
            try
            {
                //pnlInfo.Visible = true;
                //PanelDocument.Visible = false;

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

                        if (roleId == "10")
                            Status = "Application Re-Submission by Range Officer";
                        else if(roleId == "9")
                            Status = "Application Re-Submission by SDO";
                        else if (roleId == "8")
                            Status = "Application Re-Submission by DFO";
                        else if (roleId == "11")
                            Status = "Application Re-Submission by Applicant";




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
                var url = apiUrl + "TblDocumentDetails/PutTblDocumentDetail";

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

        public string ReuploadDocument(string IncidentId, string UploadedByUserId, Int32 UploadedByRoleId, string DocumentName, string FileName, Stream FileStream, string CreatedBy)
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

        //protected void rptIncidentDetails_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    try
        //    {
        //        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //        {
        //            Repeater rptDocuments = (Repeater)e.Item.FindControl("rptDocuments");

        //            if (ViewState["documents"] != null)
        //            {
        //                string documentsJson = ViewState["documents"].ToString();
        //                JArray documents = JArray.Parse(documentsJson);

        //                DataTable dtDocuments = new DataTable();
        //                dtDocuments.Columns.Add("DocumentId");
        //                dtDocuments.Columns.Add("RoleId");
        //                dtDocuments.Columns.Add("UserId");
        //                dtDocuments.Columns.Add("documentPath");
        //                dtDocuments.Columns.Add("FullUrl"); // New column for full URL
        //                dtDocuments.Columns.Add("documentName");
        //                dtDocuments.Columns.Add("comments");
        //                dtDocuments.Columns.Add("status");

        //                string baseUrl = ConfigurationManager.AppSettings["BaseUrl"];

        //                foreach (JToken doc in documents)
        //                {
        //                    DataRow row = dtDocuments.NewRow();
        //                    row["DocumentId"] = doc["documentId"]?.ToString();
        //                    row["RoleId"] = doc["roleId"]?.ToString();
        //                    row["UserId"] = doc["userId"]?.ToString();
        //                    row["documentPath"] = doc["documentPath"]?.ToString();
        //                    row["documentName"] = doc["documentName"]?.ToString();
        //                    row["FullUrl"] = baseUrl + doc["documentPath"]?.ToString();
        //                    row["comments"] = doc["comments"]?.ToString();
        //                    row["status"] = doc["status"]?.ToString();
        //                    dtDocuments.Rows.Add(row);

        //                }

        //                rptDocuments.DataSource = dtDocuments;
        //                rptDocuments.DataBind();
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        // Log the error if needed
        //    }
        //}



        protected void rptIncidentDetails_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater rptDocuments = e.Item.FindControl("rptDocuments") as Repeater;




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




                if (rptDocuments == null) return;

                bool applicantDocPending = false;

                foreach (RepeaterItem docItem in rptDocuments.Items)
                {
                    HiddenField hfUploadedByRole =
                        docItem.FindControl("hfUploadedByRole") as HiddenField;

                    Label lblComments =
                        docItem.FindControl("lblComments") as Label;

                    if (hfUploadedByRole != null && lblComments != null)
                    {
                        // Applicant role assumed = 11
                        if (hfUploadedByRole.Value == "11" &&
                            !string.IsNullOrEmpty(lblComments.Text))
                        {
                            applicantDocPending = true;
                            break;
                        }
                    }
                }

                Panel pnlReturn =
                    e.Item.FindControl("pnlReturnToApplicant") as Panel;

                if (pnlReturn != null)
                {
                    pnlReturn.Visible = applicantDocPending;
                }
            }
        }




        protected void btnReturnToApplicant_Click(object sender, EventArgs e)
        {
            Button btn = sender as Button;
            string incidentId = btn.CommandArgument;
            incidentId = "INCD-0020";

            if (string.IsNullOrEmpty(incidentId))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "alert",
                    "alert('Incident ID not found');", true);
                return;
            }


            string userId = Session["UserId"].ToString();
            int roleId = Convert.ToInt32(Session["RoleId"]);
            string roleName = Session["RoleName"].ToString();

            string action = "Document Returned by " + roleName;
            string remarks = "Document Returned. Please re-upload.";

            UpdateApplicantStatus(
                incidentId,
                action,
                userId,
                0
            );

            ApiHelper.PostIncidentProgressLog(
                this,
                incidentId,
                roleId.ToString(),
                roleName,
                action,
                userId,
                remarks
            );

            //BindRepeaterEdit(incidentId);

            //string successScript = @"
            //            Swal.fire({
            //                title: 'Document Returned!',
            //                text: 'Document Returned for re-upload.',
            //                icon: 'warning',
            //                showConfirmButton: true,
            //                confirmButtonText: 'OK',
            //                background: '#f0f9ff',
            //                color: '#1a202c',
            //                iconColor: '#38a169',
            //                showClass: { popup: 'animate__animated animate__fadeInDown' },
            //                hideClass: { popup: 'animate__animated animate__fadeOutUp' }
            //            });";

            //ScriptManager.RegisterStartupScript(this, this.GetType(), "verifyAlert", successScript, true);



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



        }



    }
}