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



namespace uk_forest.Forest
{
    public partial class incident_list_approval : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string user_id = Session["UserId"].ToString();
                    int role_id = Convert.ToInt32(Session["RoleId"]);
                    string status = "Pending";
                    if (role_id == 10)
                    {
                        status = "Pending";
                    }
                    else if (role_id == 9)
                    {
                        status = "Approved by RO";
                    }
                    else if (role_id == 8)
                    {
                        status = "Approved by SDO";
                    }

                    ViewState["user_id"] = user_id;
                    //DamageTypeDropdown();
                    //BindDocumentDropdown();
                    //BindUserGrid(user_id);
                    BindUserGrid(role_id, user_id, status);
                }
            }
            catch (Exception ex)
            {

            }
        }

        void ApplicantDetailsBank(GridViewRow gvrow)
        {
            try
            {
                if (gvrow == null) return;

                Label lblApplicantId = (Label)gvrow.FindControl("lbl_ApplicantId");
                string applicant_id = lblApplicantId?.Text;

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    var response = client.GetAsync(apiUrl + "TblApplicantBankDetails/GetTblApplicantBankDetail_byApplicantId?applicant_id=" + applicant_id).GetAwaiter().GetResult();

                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        var jsonResponse = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                        dynamic applicantData = JsonConvert.DeserializeObject(jsonResponse);
                        txt_bank_id.Text = applicantData.bankId;
                        txt_account_holder_name.Text = applicantData.accountHolderName;
                        txt_bank_name.Text = applicantData.bankName;
                        txt_ifsc_code.Text = applicantData.ifscCode;
                        txt_account_no.Text = applicantData.accountNo;
                        hf_bankId.Value = applicantData.bankId;

                        string baseUrl = ConfigurationManager.AppSettings["BaseUrl"]; // Already present
                        string bankDocPath = applicantData.bankDocPath; // This field should come from your API

                        if (!string.IsNullOrEmpty(bankDocPath))
                        {
                            img_bank_doc.ImageUrl = baseUrl + bankDocPath;
                            img_bank_doc.Visible = true;
                        }
                        else
                        {
                            img_bank_doc.ImageUrl = "~/Images/no-image.png"; // Fallback image
                            img_bank_doc.Visible = true;
                        }

                        txt_account_holder_name.Enabled = false;
                        txt_bank_name.Enabled = false;
                        txt_ifsc_code.Enabled = false;
                        txt_account_no.Enabled = false;
                    }
                    else if (response.StatusCode == HttpStatusCode.Created)
                    {
                        txt_account_holder_name.Text = "N/A";
                        txt_bank_name.Text = "N/A";
                        txt_ifsc_code.Text = "N/A";
                        txt_account_no.Text = "N/A";
                    }
                    else
                    {

                    }
                }
            }
            catch (Exception ex)
            {

            }
        }



        protected void btnVerify_Click(object sender, EventArgs e)
        {
            try
            {
                // Ensure RoleId is present in session
                if (Session["RoleId"] == null || !int.TryParse(Session["RoleId"].ToString(), out int roleId))
                {
                    // Handle missing role ID (show message or return)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('User RoleId is missing.');", true);
                    return;
                }

                List<int> selectedSnos = new List<int>();

                // Loop through outer Repeater
                foreach (RepeaterItem outerItem in Repeater1.Items)
                {
                    Repeater rptDocuments = (Repeater)outerItem.FindControl("Repeater2");
                    if (rptDocuments == null) continue;

                    // Loop through inner Repeater (documents)
                    foreach (RepeaterItem docItem in rptDocuments.Items)
                    {
                        CheckBox chk = (CheckBox)docItem.FindControl("chkSelectDocument");
                        HiddenField hfSno = (HiddenField)docItem.FindControl("hfSno");

                        if (chk != null && chk.Checked && hfSno != null && int.TryParse(hfSno.Value, out int sno))
                        {
                            selectedSnos.Add(sno);
                        }
                    }
                }

                if (selectedSnos.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Please select at least one document to verify.');", true);
                    return;
                }

                foreach (int sno in selectedSnos)
                {
                    string result = VerifyDocuments(sno, roleId);
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Documents verified successfully.');", true);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error in btnVerify_Click: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('An error occurred while verifying documents.');", true);
            }
        }
        public string VerifyDocuments(int sno, int roleId)
        {
            try
            {
                var data = new
                {
                    sno = sno,
                    roleId = roleId
                };

                var json = JsonConvert.SerializeObject(data);
                var dataContent = new StringContent(json, Encoding.UTF8, "application/json");

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                var url = apiUrl + "TblDocuments/VerifyDocumentAtApprovalStage";
                var responseTask = client.PostAsync(url, dataContent);
                responseTask.Wait();
                HttpResponseMessage response = responseTask.Result;

                if (response.IsSuccessStatusCode)
                {
                    return "Success";
                }
                else
                {
                    string error = response.Content.ReadAsStringAsync().Result;
                    Console.WriteLine($"API Error: {error}");
                    return "API Error";
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error in update_role: {ex.Message}");
                return "Error";
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

        private void BindUserGrid(int role_id, string userId, string status)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = client.GetAsync($"{apiUrl}TblVictimIncidents/GetVictimIncidentDetails?userId={userId}&status={status}&role_id={role_id}").Result;

                    if (response.IsSuccessStatusCode)
                    {
                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            string result = response.Content.ReadAsStringAsync().Result;


                            JArray array = JArray.Parse(result);

                            foreach (JObject item in array)
                            {
                                item.Remove("documents");
                            }

                            DataTable dt = JsonConvert.DeserializeObject<DataTable>(array.ToString());

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


        private void ShowNoRecordsMessage()
        {
            lbl_msg_alert.Visible = true;
            lbl_msg_alert.Text = "No Record Found...!!!";
            lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
            gv_incident_list.Visible = false;
        }



        protected void gv_incident_list_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                gv_incident_list.PageIndex = e.NewPageIndex;
                string applicantId = ViewState["ApplicantId"] != null ? ViewState["ApplicantId"].ToString() : "APPL-0001";
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        protected void ddl_status_approved_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                payment_panel.Style.Add("display", "none");

                DropDownList ddl_action = sender as DropDownList;
                if (ddl_action == null) return;

                GridViewRow gvrow = ddl_action.NamingContainer as GridViewRow;
                if (gvrow == null) return;

                string permission = ddl_action.SelectedValue;

                if (!string.IsNullOrEmpty(permission) && permission == "View")
                {
                    string incidentId = gv_incident_list.DataKeys[gvrow.RowIndex].Value.ToString();
                    string jsonData = GetDataForPopup(incidentId);

                    if (!string.IsNullOrEmpty(jsonData))
                    {
                        JObject jsonObject = JObject.Parse(jsonData);

                        DataTable mainDt = new DataTable();
                        mainDt.Columns.Add("victimProfileId");
                        mainDt.Columns.Add("name");
                        mainDt.Columns.Add("age");
                        mainDt.Columns.Add("gender");
                        mainDt.Columns.Add("aadharNo");
                        mainDt.Columns.Add("aadharDoc");
                        mainDt.Columns.Add("incidentId");
                        mainDt.Columns.Add("applicantId");
                        mainDt.Columns.Add("incidentDate");
                        mainDt.Columns.Add("incidentTime");
                        mainDt.Columns.Add("incidentPlace");
                        //mainDt.Columns.Add("killedBy");
                        mainDt.Columns.Add("activity");
                        mainDt.Columns.Add("latitude");
                        mainDt.Columns.Add("longitude");
                        mainDt.Columns.Add("status");
                        //mainDt.Columns.Add("rangeOfficerId");
                        mainDt.Columns.Add("incidentSummary");
                        mainDt.Columns.Add("humanLoss");

                        mainDt.Columns.Add("animalName");
                        mainDt.Columns.Add("rangeName");
                        mainDt.Columns.Add("applicantName");

                        mainDt.Columns.Add("bankId");
                        mainDt.Columns.Add("bankName");
                        mainDt.Columns.Add("accountNo");
                        mainDt.Columns.Add("accountHolderName");
                        mainDt.Columns.Add("bankDocPath");

                        mainDt.Columns.Add("applicantAadharNo");
                        mainDt.Columns.Add("applicantAadharDoc");



                        DataRow row = mainDt.NewRow();

                        foreach (DataColumn col in mainDt.Columns)
                        {
                            row[col.ColumnName] = jsonObject[col.ColumnName]?.ToString();
                        }

                        mainDt.Rows.Add(row);

                        ViewState["documents"] = jsonObject["documents"].ToString();

                        rptIncidentDetails.DataSource = mainDt;
                        rptIncidentDetails.DataBind();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopup();", true);
                    }
                }
                if (!string.IsNullOrEmpty(permission) && permission == "Verify_Document")
                {
                    string incidentId = gv_incident_list.DataKeys[gvrow.RowIndex].Value.ToString();
                    string jsonData = GetDataForPopupDocumentVerify(incidentId);

                    if (!string.IsNullOrEmpty(jsonData))
                    {
                        JArray docsArray = JArray.Parse(jsonData);

                        JObject incidentDetails = new JObject
                        {
                            ["documents"] = docsArray
                        };

                        var incidentList = new List<JObject> { incidentDetails };
                        ViewState["Documentss"] = incidentDetails["documents"]?.ToString();

                        Repeater1.DataSource = incidentList;
                        Repeater1.DataBind();

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
                    }
                }
                if (!string.IsNullOrEmpty(permission) && permission == "Approve")
                {
                    Int32 RoleId = Convert.ToInt32(Session["RoleId"]);

                    if (RoleId == 10)
                    {
                        string incidentId = gv_incident_list.DataKeys[gvrow.RowIndex].Value.ToString();

                        Label lblApplicantId = (Label)gvrow.FindControl("lbl_ApplicantId");
                        string applicantId = lblApplicantId != null ? lblApplicantId.Text : "NA";

                        txt_incidentid.Text = incidentId;
                        txt_applicantid.Text = applicantId;

                        Label lblHumanLoss = (Label)gvrow.FindControl("lbl_human_loss");
                        string human_loss = lblHumanLoss?.Text;

                        DamageTypeDropdown("Human", human_loss);

                        ApplicantDetailsBank(gvrow);

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopup_payment_panel();", true);
                        payment_panel.Style.Add("display", "block");
                    }
                    else if (RoleId == 9)
                    {
                        string IncidentId = gv_incident_list.DataKeys[gvrow.RowIndex].Value.ToString();
                        string Status = "Approved by SDO";
                        string UpdatedBy = Session["UserId"].ToString();

                        string incident = UpdateIncident(IncidentId, Status, UpdatedBy);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopup_approvalSuccess_panel();", true);

                        string user_id = Session["UserId"].ToString();
                        int role_id = Convert.ToInt32(Session["RoleId"]);
                        string status = "Approved by RO";

                        BindUserGrid(role_id, user_id, status);

                    }
                    else if (RoleId == 8)
                    {
                        string incidentId = gv_incident_list.DataKeys[gvrow.RowIndex].Value.ToString();

                        Label lblApplicantId = (Label)gvrow.FindControl("lbl_ApplicantId");
                        string applicantId = lblApplicantId != null ? lblApplicantId.Text : "NA";

                        txt_incidentid.Text = incidentId;
                        txt_applicantid.Text = applicantId;
                        ApplicantDetailsDFO(gvrow);

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopup_approvalSuccess_panel_dfo();", true);
                        payment_panel.Style.Add("display", "block");

                        string user_id = Session["UserId"].ToString();
                        int role_id = Convert.ToInt32(Session["RoleId"]);
                        string status = "Approved by SDO";

                        BindUserGrid(role_id, user_id, status);

                    }
                }
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

        private string GetDataForPopupDocumentVerify(string incident_Id)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                var url = apiUrl + "TblDocuments/GetDocumentsByIncidentId?incidentId=" + incident_Id;
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

        public string HostUrl => ConfigurationManager.AppSettings["BaseUrl"];

        protected void btnClosePopup_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HidePopup", "hidePopup();", true);
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
                        dtDocuments.Columns.Add("FilePath");
                        dtDocuments.Columns.Add("FullUrl"); // New column for full URL
                        dtDocuments.Columns.Add("documentName");

                        string baseUrl = ConfigurationManager.AppSettings["BaseUrl"];

                        foreach (JToken doc in documents)
                        {
                            DataRow row = dtDocuments.NewRow();
                            row["DocumentId"] = doc["documentId"]?.ToString();
                            row["RoleId"] = doc["roleId"]?.ToString();
                            row["UserId"] = doc["userId"]?.ToString();
                            row["FilePath"] = doc["filePath"]?.ToString();
                            row["documentName"] = doc["documentName"]?.ToString();
                            row["FullUrl"] = baseUrl + doc["filePath"]?.ToString();
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

        protected bool IsImageFile(string filePath)
        {
            if (string.IsNullOrEmpty(filePath))
                return false;

            string extension = System.IO.Path.GetExtension(filePath)?.ToLower();
            return extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".gif" || extension == ".webp";
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

        //void DamageTypeDropdown()
        //{
        //    try
        //    {
        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
        //            HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("DamageTypeMasters/GetDamageTypeMaster_byDamageCategory?damage_category=Human")).Result;

        //            if (Res.IsSuccessStatusCode)
        //            {
        //                var EmpResponse = Res.Content.ReadAsStringAsync().Result;
        //                DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

        //                // Add a new column that combines type and remark
        //                dt.Columns.Add("DisplayText", typeof(string), "type + ' - ' + remark");

        //                ddl_damage_type.Items.Clear();
        //                ddl_damage_type.DataSource = dt;
        //                ddl_damage_type.DataValueField = "damageTypeId";
        //                ddl_damage_type.DataTextField = "DisplayText";
        //                ddl_damage_type.DataBind();
        //                ddl_damage_type.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0"));
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        // Consider logging the exception
        //    }
        //}  

        void DamageTypeDropdown(string damage_category, string human_loss)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("DamageTypeMasters/GetDamageTypeMaster_byDamageCategoryandLoss?damage_category=" + damage_category + "&human_loss=" + human_loss)).Result;

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
                        ddl_damage_type.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0"));
                    }
                }
            }
            catch (Exception ex)
            {
                // Consider logging the exception
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
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("DamageTypeMasters/GetDamageTypeMaster_byDamageTypeId?damage_type_id=" + damage_type_id)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            decimal totalAmount = Convert.ToDecimal(dt.Rows[0]["totalAmount"]);
                            txt_amount.Text = totalAmount.ToString("0.00"); // Display full amount

                            decimal payableAmount = totalAmount * 0.30m;
                            txt_payable_amount.Text = payableAmount.ToString("0.00"); // Display 30% amount
                        }
                        else
                        {
                            txt_amount.Text = "0.00";
                            txt_payable_amount.Text = "0.00";
                        }
                    }
                    else
                    {
                        txt_amount.Text = "0.00";
                        txt_payable_amount.Text = "0.00";
                    }
                }
            }
            catch (Exception ex)
            {
                txt_amount.Text = "0.00";
                txt_payable_amount.Text = "0.00";
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

        protected void btn_payment_Click(object sender, EventArgs e)
        {
            try
            {
                Int32 DamageTypeId = Convert.ToInt32(ddl_damage_type.SelectedValue);
                string ApplicantId = txt_applicantid.Text;
                string IncidentId = txt_incidentid.Text;
                string PaymentType = ddl_payment.SelectedValue;
                decimal PaymentAmount = Convert.ToDecimal(txt_payable_amount.Text);
                string PaymentMode = ddl_payment_mode.SelectedValue;
                string PaymentStatus = ddl_payment_status.SelectedValue;
                string PaymentReferenceNo = txt_payment_reference_no.Text;
                DateTime PaymentDate = System.DateTime.Now;
                string fileName_payment = fileUpload.FileName;
                Stream fileStream_payment = fileUpload.PostedFile.InputStream;
                string Remarks = txt_remark.Text;
                string CreatedBy = Session["UserId"].ToString();

                Label lbl_bankId = (Label)FindControl("lbl_bankId");
                Int32 bankId = Convert.ToInt32(txt_bank_id.Text);

                string result = AddPaymentDetails(ApplicantId, IncidentId, PaymentType, PaymentAmount, PaymentMode, PaymentStatus, PaymentReferenceNo, PaymentDate, fileName_payment, fileStream_payment, Remarks, CreatedBy, bankId, DamageTypeId);

                string Status = "Approved by RO";
                string UpdatedBy = Session["UserId"].ToString();

                string incident = UpdateIncident(IncidentId, Status, UpdatedBy);
                payment_panel.Style.Add("display", "none");

                string user_id = Session["UserId"].ToString();
                int role_id = Convert.ToInt32(Session["RoleId"]);
                string status = "Pending";

                BindUserGrid(role_id, user_id, status);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Payment Done successfully.');", true);
            }
            catch (Exception ex)
            {

            }
        }


        //protected void btn_payment_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        Int32 DamageTypeId = Convert.ToInt32(ddl_damage_type.SelectedValue);
        //        string ApplicantId = txt_applicantid.Text;
        //        string IncidentId = txt_incidentid.Text;
        //        string PaymentType = ddl_payment.SelectedValue;
        //        decimal PaymentAmount = Convert.ToDecimal(txt_payable_amount.Text);
        //        string PaymentMode = ddl_payment_mode.SelectedValue;
        //        string PaymentStatus = ddl_payment_status.SelectedValue;
        //        string PaymentReferenceNo = txt_payment_reference_no.Text;
        //        DateTime PaymentDate = System.DateTime.Now;
        //        string fileName_payment = fileUpload.FileName;
        //        Stream fileStream_payment = fileUpload.PostedFile.InputStream;
        //        string Remarks = txt_remark.Text;
        //        string CreatedBy = Session["UserId"].ToString();

        //        Label lbl_bankId = (Label)FindControl("lbl_bankId");
        //        Int32 bankId = Convert.ToInt32(txt_bank_id.Text);


        //        Int32 roleId = Convert.ToInt32(Session["RoleId"]);
        //        string userId = Session["UserId"].ToString();

        //        Int32 documentId = Convert.ToInt32(ddlDocType.SelectedValue);
        //        HttpPostedFile docFile = FileDoc.PostedFile;

        //        string docUploadResult = UploadDocumentToApi(IncidentId, docFile, roleId, userId, documentId);

        //        // Deserialize result or check for success/failure
        //        if (docUploadResult.Contains("Success"))
        //        {
        //            string result = AddPaymentDetails(ApplicantId, IncidentId, PaymentType, PaymentAmount, PaymentMode, PaymentStatus, PaymentReferenceNo, PaymentDate, fileName_payment, fileStream_payment, Remarks, CreatedBy, bankId, DamageTypeId);

        //            string Status = "Approved by RO";
        //            string UpdatedBy = Session["UserId"].ToString();

        //            string incident = UpdateIncident(IncidentId, Status, UpdatedBy);
        //            payment_panel.Style.Add("display", "none");

        //            string user_id = Session["UserId"].ToString();
        //            int role_id = Convert.ToInt32(Session["RoleId"]);
        //            string status = "Pending";

        //            BindUserGrid(role_id, user_id, status);
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Payment Done successfully.');", true);
        //        }
        //        else
        //        {
        //            // Handle error or show message
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Document upload failed.');", true);
        //        }



        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}

        public string AddPaymentDetails(string ApplicantId, string IncidentId, string PaymentType, decimal PaymentAmount, string PaymentMode, string PaymentStatus, string PaymentReferenceNo, DateTime PaymentDate, string fileName_payment, Stream fileStream_payment, string Remarks, string CreatedBy, Int32 BankId, Int32 DamageTypeId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    using (var form = new MultipartFormDataContent())
                    {
                        form.Add(new StringContent(ApplicantId), "ApplicantId");
                        form.Add(new StringContent(IncidentId), "IncidentId");
                        form.Add(new StringContent(PaymentType), "PaymentType");
                        form.Add(new StringContent(PaymentAmount.ToString()), "PaymentAmount");
                        form.Add(new StringContent(PaymentStatus), "PaymentStatus");
                        form.Add(new StringContent(PaymentMode), "PaymentMode");
                        form.Add(new StringContent(PaymentReferenceNo), "PaymentReferenceNo");
                        form.Add(new StringContent(PaymentDate.ToString()), "PaymentDate");
                        form.Add(new StringContent(Remarks), "Remarks");
                        form.Add(new StringContent(CreatedBy), "CreatedBy");
                        form.Add(new StringContent(BankId.ToString()), "BankId");
                        form.Add(new StringContent(DamageTypeId.ToString()), "DamageTypeId");

                        if (fileStream_payment != null)
                        {
                            var fileContent = new StreamContent(fileStream_payment);

                            fileContent.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("form-data")
                            {
                                Name = "fileDoc",
                                FileName = fileName_payment
                            };

                            fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
                            form.Add(fileContent);
                        }

                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                        var url = $"{apiUrl}TblPaymentDetails/PostTblPaymentDetail";

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


        public string UpdateIncident(string IncidentId, string Status, string UpdatedBy)
        {
            try
            {
                var data = new
                {
                    IncidentId = IncidentId,
                    Status = Status,
                    UpdatedBy = UpdatedBy
                };

                var json = JsonConvert.SerializeObject(data);
                var dataContent = new StringContent(json, Encoding.UTF8, "application/json");

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                var url = apiUrl + "TblVictimIncidents/PutTblVictimIncident";
                var responseTask = client.PostAsync(url, dataContent);
                responseTask.Wait();
                HttpResponseMessage response = responseTask.Result;

                if (response.IsSuccessStatusCode)
                {
                    return "Success";
                }
                else
                {
                    string error = response.Content.ReadAsStringAsync().Result;
                    Console.WriteLine($"API Error: {error}");
                    return "API Error";
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error in update_role: {ex.Message}");
                return "Error";
            }
        }



        private string GetDataForPopupDocumentVerifyCheck(string incident_Id)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                var url = apiUrl + "TblDocuments/GetDocumentsByIncidentId?incidentId=" + incident_Id;
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

        void ApplicantDetailsDFO(GridViewRow gvrow)
        {
            try
            {
                if (gvrow == null)
                {
                    return;
                }

                Label lbl_incidentId = (Label)gvrow.FindControl("lbl_incidentId");
                string incidentId = lbl_incidentId?.Text;
                string PaymentType = "Advance";

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    var response = client.GetAsync(apiUrl + "TblPaymentDetails/GetPaymentDetailsByIncidentIdPayment?incidentId=" + incidentId + "&PaymentType=" + PaymentType).GetAwaiter().GetResult();

                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        var jsonResponse = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                        var applicantData = JsonConvert.DeserializeObject<List<dynamic>>(jsonResponse).FirstOrDefault();

                        if (applicantData != null)
                        {
                            txt_damage_type_dfo.Text = applicantData.type + " - " + applicantData.damageRemarks;
                            txt_incidentid_dfo.Text = applicantData.incidentId;
                            txt_applicantid_dfo.Text = applicantData.applicantId;
                            txt_amount_dfo.Text = applicantData.totalAmount.ToString();
                            txt_payable_amount_dfo.Text = applicantData.paymentAmount.ToString();
                            txt_damage_id.Text = applicantData.damageTypeId.ToString();
                            txt_bank_id_dfo.Text = applicantData.bankId.ToString();

                            decimal totalAmount = decimal.Parse(txt_amount_dfo.Text);
                            decimal payableAmount = decimal.Parse(txt_payable_amount_dfo.Text);
                            decimal remaining_amount = totalAmount - payableAmount;
                            txt_remaining_amount.Text = remaining_amount.ToString("N2");

                            txt_account_holder_name_dfo.Text = applicantData.accountHolderName;
                            txt_bank_name_dfo.Text = applicantData.bankName;
                            txt_ifsc_code_dfo.Text = applicantData.ifscCode;
                            txt_account_no_dfo.Text = applicantData.accountNo;

                            string baseUrl = ConfigurationManager.AppSettings["BaseUrl"];
                            string bankDocPath = applicantData.bankDocPath;

                            if (!string.IsNullOrEmpty(bankDocPath))
                            {
                                img_bank_doc_dfo.ImageUrl = baseUrl + bankDocPath;
                                img_bank_doc_dfo.Visible = true;
                            }
                            else
                            {
                                img_bank_doc_dfo.ImageUrl = "~/Images/no-image.png";
                                img_bank_doc_dfo.Visible = true;
                            }

                            txt_damage_type_dfo.Enabled = false;
                            txt_incidentid_dfo.Enabled = false;
                            txt_applicantid_dfo.Enabled = false;
                            txt_amount_dfo.Enabled = false;
                            txt_payable_amount_dfo.Enabled = false;
                            txt_account_holder_name_dfo.Enabled = false;
                            txt_bank_name_dfo.Enabled = false;
                            txt_ifsc_code_dfo.Enabled = false;
                            txt_account_no_dfo.Enabled = false;

                            txt_remaining_amount.Enabled = false;

                        }
                    }
                    else if (response.StatusCode == HttpStatusCode.Created)
                    {
                        txt_account_holder_name_dfo.Text = "N/A";
                        txt_bank_name_dfo.Text = "N/A";
                        txt_ifsc_code_dfo.Text = "N/A";
                        txt_account_no_dfo.Text = "N/A";

                        txt_account_holder_name_dfo.Enabled = false;
                        txt_bank_name_dfo.Enabled = false;
                        txt_ifsc_code_dfo.Enabled = false;
                        txt_account_no_dfo.Enabled = false;
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }



        //protected void btn_payment_sdo_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        Int32 DamageTypeId = Convert.ToInt32(txt_damage_id.Text);
        //        string ApplicantId = txt_applicantid_dfo.Text;
        //        string IncidentId = txt_incidentid_dfo.Text;
        //        string PaymentType = "Remaining";
        //        decimal PaymentAmount = Convert.ToDecimal(txt_remaining_amount.Text);
        //        string PaymentMode = ddl_payment_mode_dfo.SelectedValue;
        //        string PaymentStatus = "Complete";
        //        string PaymentReferenceNo = txt_payment_reference_no_dfo.Text;
        //        DateTime PaymentDate = System.DateTime.Now;
        //        string fileName_payment = fileUpload.FileName;
        //        Stream fileStream_payment = fileUpload.PostedFile.InputStream;
        //        string Remarks = txt_remark_dfo.Text;
        //        string CreatedBy = Session["UserId"].ToString();

        //        Int32 bankId = Convert.ToInt32(txt_bank_id_dfo.Text);



        //        Int32 roleId = Convert.ToInt32(Session["RoleId"]);
        //        string userId = Session["UserId"].ToString();

        //        Int32 documentId = Convert.ToInt32(ddlDocType.SelectedValue);
        //        HttpPostedFile docFile = FileDoc.PostedFile;

        //        string docUploadResult = UploadDocumentToApi(IncidentId, docFile, roleId, userId, documentId);
        //        //string incidentId, HttpPostedFile fileDoc, Int32 roleId, string userId, Int32 documentId

        //        // Deserialize result or check for success/failure
        //        if (docUploadResult.Contains("Success"))
        //        {

        //            string result = AddPaymentDetails(ApplicantId, IncidentId, PaymentType, PaymentAmount, PaymentMode, PaymentStatus, PaymentReferenceNo, PaymentDate, fileName_payment, fileStream_payment, Remarks, CreatedBy, bankId, DamageTypeId);

        //            string Status = "Approved by SDO";
        //            string UpdatedBy = Session["UserId"].ToString();

        //            string incident = UpdateIncident(IncidentId, Status, UpdatedBy);
        //            payment_panel.Style.Add("display", "none");

        //            string user_id = Session["UserId"].ToString();
        //            int role_id = Convert.ToInt32(Session["RoleId"]);
        //            string status = "Approved by SDO";

        //            BindUserGrid(role_id, user_id, status);
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Payment Done successfully.');", true);
        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}



        protected void btn_payment_dfo_Click(object sender, EventArgs e)
        {
            try
            {
                Int32 DamageTypeId = Convert.ToInt32(txt_damage_id.Text);
                string ApplicantId = txt_applicantid_dfo.Text;
                string IncidentId = txt_incidentid_dfo.Text;
                string PaymentType = "Remaining";
                decimal PaymentAmount = Convert.ToDecimal(txt_remaining_amount.Text);
                string PaymentMode = ddl_payment_mode_dfo.SelectedValue;
                string PaymentStatus = "Complete";
                string PaymentReferenceNo = txt_payment_reference_no_dfo.Text;
                DateTime PaymentDate = System.DateTime.Now;
                string fileName_payment = fileUpload.FileName;
                Stream fileStream_payment = fileUpload.PostedFile.InputStream;
                string Remarks = txt_remark_dfo.Text;
                string CreatedBy = Session["UserId"].ToString();

                Int32 bankId = Convert.ToInt32(txt_bank_id_dfo.Text);

                string result = AddPaymentDetails(ApplicantId, IncidentId, PaymentType, PaymentAmount, PaymentMode, PaymentStatus, PaymentReferenceNo, PaymentDate, fileName_payment, fileStream_payment, Remarks, CreatedBy, bankId, DamageTypeId);

                string Status = "Approved by DFO";
                string UpdatedBy = Session["UserId"].ToString();

                string incident = UpdateIncident(IncidentId, Status, UpdatedBy);
                payment_panel.Style.Add("display", "none");

                string user_id = Session["UserId"].ToString();
                int role_id = Convert.ToInt32(Session["RoleId"]);
                string status = "Approved by SDO";

                BindUserGrid(role_id, user_id, status);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Payment Done successfully.');", true);
            }
            catch (Exception ex)
            {

            }
        }


        //protected void btn_payment_dfo_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        Int32 DamageTypeId = Convert.ToInt32(txt_damage_id.Text);
        //        string ApplicantId = txt_applicantid_dfo.Text;
        //        string IncidentId = txt_incidentid_dfo.Text;
        //        string PaymentType = "Remaining";
        //        decimal PaymentAmount = Convert.ToDecimal(txt_remaining_amount.Text);
        //        string PaymentMode = ddl_payment_mode_dfo.SelectedValue;
        //        string PaymentStatus = "Complete";
        //        string PaymentReferenceNo = txt_payment_reference_no_dfo.Text;
        //        DateTime PaymentDate = System.DateTime.Now;
        //        string fileName_payment = fileUpload.FileName;
        //        Stream fileStream_payment = fileUpload.PostedFile.InputStream;
        //        string Remarks = txt_remark_dfo.Text;
        //        string CreatedBy = Session["UserId"].ToString();

        //        Int32 bankId = Convert.ToInt32(txt_bank_id_dfo.Text);



        //        Int32 roleId = Convert.ToInt32(Session["RoleId"]);
        //        string userId = Session["UserId"].ToString();

        //        Int32 documentId = Convert.ToInt32(ddlDocType.SelectedValue);
        //        HttpPostedFile docFile = FileDoc.PostedFile;

        //        string docUploadResult = UploadDocumentToApi(IncidentId, docFile, roleId, userId, documentId);
        //        //string incidentId, HttpPostedFile fileDoc, Int32 roleId, string userId, Int32 documentId

        //        // Deserialize result or check for success/failure
        //        if (docUploadResult.Contains("Success"))
        //        {

        //            string result = AddPaymentDetails(ApplicantId, IncidentId, PaymentType, PaymentAmount, PaymentMode, PaymentStatus, PaymentReferenceNo, PaymentDate, fileName_payment, fileStream_payment, Remarks, CreatedBy, bankId, DamageTypeId);

        //            string Status = "Approved by DFO";
        //            string UpdatedBy = Session["UserId"].ToString();

        //            string incident = UpdateIncident(IncidentId, Status, UpdatedBy);
        //            payment_panel.Style.Add("display", "none");

        //            string user_id = Session["UserId"].ToString();
        //            int role_id = Convert.ToInt32(Session["RoleId"]);
        //            string status = "Approved by SDO";

        //            BindUserGrid(role_id, user_id, status);
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Payment Done successfully.');", true);
        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}


        //private void BindDocumentDropdown()
        //{
        //    try
        //    {
        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

        //            HttpResponseMessage response = client.GetAsync(apiUrl + "TblDocumentMasters/GetTblDocumentMasters").Result;

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var jsonResponse = response.Content.ReadAsStringAsync().Result;
        //                var dt = JsonConvert.DeserializeObject<DataTable>(jsonResponse);

        //                ddlDocType.DataSource = dt;
        //                ddlDocType.DataValueField = "documentId";
        //                ddlDocType.DataTextField = "documentName";
        //                ddlDocType.DataBind();

        //                ddlDocType.Items.Insert(0, new ListItem("-- Select Document Type --", "0"));


        //                ddlDocType_dfo.DataSource = dt;
        //                ddlDocType_dfo.DataValueField = "documentId";
        //                ddlDocType_dfo.DataTextField = "documentName";
        //                ddlDocType_dfo.DataBind();

        //                ddlDocType_dfo.Items.Insert(0, new ListItem("-- Select Document Type --", "0"));
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        // Handle error
        //    }
        //}





        //public string UploadDocumentToApi(string incidentId, HttpPostedFile fileDoc, Int32 roleId, string userId, Int32 documentId)
        //{
        //    try
        //    {
        //        using (var client = new HttpClient())
        //        {
        //            var url = $"{apiUrl}TblDocuments/PostTblDocument";

        //            using (var form = new MultipartFormDataContent())
        //            {
        //                // Add file
        //                if (fileDoc != null && fileDoc.ContentLength > 0)
        //                {
        //                    byte[] fileBytes = new byte[fileDoc.ContentLength];
        //                    fileDoc.InputStream.Read(fileBytes, 0, fileDoc.ContentLength);
        //                    var fileContent = new ByteArrayContent(fileBytes);
        //                    fileContent.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("form-data")
        //                    {
        //                        Name = "\"file_doc.fileDoc\"",
        //                        FileName = "\"" + Path.GetFileName(fileDoc.FileName) + "\""
        //                    };
        //                    fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
        //                    form.Add(fileContent);
        //                }

        //                // Add form fields
        //                form.Add(new StringContent(incidentId), "incidentId");
        //                form.Add(new StringContent(roleId.ToString()), "roleId");
        //                form.Add(new StringContent(userId), "userId");
        //                form.Add(new StringContent(documentId.ToString()), "DocumentId");

        //                // Make synchronous POST call
        //                HttpResponseMessage response = client.PostAsync(apiUrl, form).Result;

        //                return response.Content.ReadAsStringAsync().Result;
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return $"{{\"Status\":\"Error\",\"Message\":\"{ex.Message}\"}}";
        //    }
        //}


        public string UploadDocumentToApi(string incidentId, HttpPostedFile fileDoc, Int32 roleId, string userId, Int32 documentId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var url = $"{apiUrl}TblDocuments/PostTblDocument";

                    using (var form = new MultipartFormDataContent())
                    {
                        // Add file with correct field name 'fileDoc'
                        if (fileDoc != null && fileDoc.ContentLength > 0)
                        {
                            byte[] fileBytes = new byte[fileDoc.ContentLength];
                            fileDoc.InputStream.Read(fileBytes, 0, fileDoc.ContentLength);
                            var fileContent = new ByteArrayContent(fileBytes);
                            fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
                            form.Add(fileContent, "file_doc.fileDoc", Path.GetFileName(fileDoc.FileName));  // This maps to photo_upload_documents.fileDoc
                        }

                        // Add TblDocument fields (must match property names in model)
                        form.Add(new StringContent(incidentId), "tblDocument.IncidentId");
                        form.Add(new StringContent(roleId.ToString()), "tblDocument.RoleId");
                        form.Add(new StringContent(userId), "tblDocument.UserId");
                        form.Add(new StringContent(documentId.ToString()), "tblDocument.DocumentId");

                        // Optional: Set timeout or headers if needed
                        client.Timeout = TimeSpan.FromMinutes(2);
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                        HttpResponseMessage response = client.PostAsync(url, form).Result;
                        return response.Content.ReadAsStringAsync().Result;
                    }
                }
            }
            catch (Exception ex)
            {
                return $"{{\"Status\":\"Error\",\"Message\":\"{ex.Message}\"}}";
            }
        }

        protected void gv_incident_list_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    DropDownList ddlStatusApproved = (DropDownList)e.Row.FindControl("ddl_status_approved");
                    //=================================RO
                    if (Session["RoleId"] != null && Convert.ToInt32(Session["RoleId"]) == 10)
                    {
                        ListItem approveItem = ddlStatusApproved.Items.FindByValue("Approve");

                        if (approveItem != null)
                        {
                            approveItem.Text = "Advance Payment Initiation";
                        }
                    }
                    //=================================DFO
                    else if (Session["RoleId"] != null && Convert.ToInt32(Session["RoleId"]) == 8)
                    {
                        ListItem approveItem = ddlStatusApproved.Items.FindByValue("Approve");

                        if (approveItem != null)
                        {
                            approveItem.Text = "Final Disbursement";
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }




    }

}