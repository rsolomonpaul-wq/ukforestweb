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
    public partial class IncidentListAccount : System.Web.UI.Page
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
                    string userId = Session["UserId"]?.ToString();
                    Int32 roleId = Convert.ToInt32(Session["RoleId"]);

                    string status = "Advance Payment Recommended by DFO, Final Payment Recommended by DFO, Payment Recommended by DFO, Bank Verified by Account Officer for Advance Payment, Bank Verified by Account Officer for Final Payment";

                    BindUserGrid(userId, roleId, status);
                }
            }
            catch (Exception ex)
            {

            }
        }

        private void BindUserGrid(string userId, Int32 roleId, string status)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = apiUrl + "TblIncidentDetails/GetIncidentList_for_account?userId=" + userId + "&status=" + status + "&role_id=" + roleId;
                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            string result = response.Content.ReadAsStringAsync().Result;

                            JArray jsonArray = JArray.Parse(result);

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
                BindUserGrid(userId, roleId, status);
            }
            catch (Exception ex)
            {

            }
        }

        protected void lnkView_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton ddl = (LinkButton)sender;
                GridViewRow row = (GridViewRow)ddl.NamingContainer;
                string incidentId = gv_incident_list.DataKeys[row.RowIndex].Value.ToString();
                string applicantId = ((Label)row.FindControl("lbl_applicantId")).Text;
                string Status = ((Label)row.FindControl("lbl_Status")).Text;
                string claimCategory = ((Label)row.FindControl("lbl_claimCategory")).Text;

                Session["selectedclaimCategory"] = claimCategory;
                Session["selectedApplicantId"] = applicantId;
                Session["incidentId"] = incidentId;
                Session["Status"] = Status;

                BindRepeater(incidentId);
                CheckVerification(incidentId);
                pnlIncidentDetails.Visible = true;
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowPopup", "showIncidentPopup();", true);
            }
            catch (Exception ex)
            {

            }
        }


        protected void CheckVerification(string incidentId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{apiUrl}IncidentProgressLogs/CheckIfLastStatusIsBankVerified?incidentId={incidentId}";

                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;
                        JObject obj = JObject.Parse(json);

                        bool isBankVerified = obj["isBankVerified"]?.Value<bool>() ?? false;

                        // Find buttons
                        Button btnApprove = rptMainIncident.Controls[0].FindControl("btnApprove") as Button;
                        Button btnInsufficient = rptMainIncident.Controls[0].FindControl("btnInsufficient") as Button;
                        Button btnPaymentProceed = pnlIncidentDetails.FindControl("btnPaymentProceed") as Button;

                        if (isBankVerified)
                        {
                            // Disable verification buttons
                            if (btnApprove != null) btnApprove.Enabled = false;
                            if (btnInsufficient != null) btnInsufficient.Enabled = false;

                            // Enable payment button
                            if (btnPaymentProceed != null)
                            {
                                btnPaymentProceed.Enabled = true;
                                btnPaymentProceed.CssClass = "btn btn-success btn-enabled";
                            }
                        }
                        else
                        {
                            if (btnApprove != null) btnApprove.Enabled = true;
                            if (btnInsufficient != null) btnInsufficient.Enabled = true;
                            if (btnPaymentProceed != null) btnPaymentProceed.Enabled = false;
                        }
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



        //public string BaseUrl { get; set; } = "http://203.122.5.18:9008/uk_forest_web/";

        public string BaseUrl { get; set; } = "https://ukforestgis.in/";

        private void BindRepeater(string incidentId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{apiUrl}TblIncidentDetails/GetBeneficiaryDetail_byIncidentID?incidentId={incidentId}";

                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;
                        JObject obj = JObject.Parse(json);
                        DataTable dtMain = new DataTable();

                        foreach (var prop in obj.Properties())
                        {
                            if (!dtMain.Columns.Contains(prop.Name))
                            {
                                dtMain.Columns.Add(prop.Name);
                            }
                        }

                        DataRow mainRow = dtMain.NewRow();
                        foreach (var prop in obj.Properties())
                        {
                            mainRow[prop.Name] = prop.Value?.ToString();
                        }

                        if (dtMain.Columns.Contains("bankDoc"))
                        {
                            dtMain.Columns.Add("fullImagePath");
                            string bankDoc = mainRow["bankDoc"]?.ToString();
                            mainRow["fullImagePath"] = !string.IsNullOrEmpty(bankDoc) ? BaseUrl + bankDoc : "";
                        }

                        dtMain.Rows.Add(mainRow);

                        string compensation_amount = dtMain.Rows[0]["totalAmount"].ToString();
                        lblCompensationAmount.InnerText = compensation_amount;

                        rptMainIncident.DataSource = dtMain;
                        rptMainIncident.DataBind();
                    }
                    else
                    {
                        rptMainIncident.DataSource = null;
                        rptMainIncident.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                rptMainIncident.DataSource = null;
                rptMainIncident.DataBind();
            }
        }




        //protected void btnApprove_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        Button btn = (Button)sender;
        //        RepeaterItem item1 = (RepeaterItem)btn.NamingContainer;

        //        HiddenField hfBeneficiaryId = (HiddenField)item1.FindControl("hfBeneficiaryId");
        //        string beneficiaryId = hfBeneficiaryId?.Value;

        //        HiddenField hfamount = (HiddenField)item1.FindControl("hfamount");
        //        string amount = hfamount?.Value;

        //        Session["incidentamount"] = amount;

        //        // Store in Session so btnPaymentProceed can access it
        //        Session["selectedBeneficiaryId"] = beneficiaryId;

        //        string IncidentId = Session["incidentId"].ToString();
        //        string roleName1 = Session["RoleName"].ToString();
        //        string action = "Bank Verified by " + roleName1;
        //        string remarks = $"Bank Verified for Incident ID: {IncidentId}";
        //        string RoleID = Session["roleid"].ToString();
        //        string createdBy = Session["Userid"].ToString();

        //        UpdateApplicantStatus(IncidentId, action, Session["UserId"]?.ToString(), 0);

        //        ApiResult result = ApiHelper.PostIncidentProgressLog(this, IncidentId, RoleID, roleName1, action, createdBy, remarks);

        //        if (result != null)
        //        {
        //            Button btnApprove = (Button)sender;
        //            RepeaterItem item = (RepeaterItem)btnApprove.NamingContainer;

        //            Button btnInsufficient = (Button)item.FindControl("btnInsufficient");
        //            Button btnApproved = (Button)item.FindControl("btnApprove");
        //            Button btnPayment = pnlIncidentDetails.FindControl("btnPaymentProceed") as Button;

        //            if (btnInsufficient != null)
        //            {
        //                btnInsufficient.Enabled = false;
        //                btnInsufficient.CssClass = "btn btn-danger btn-disabled";
        //            }

        //            if (btnApproved != null)
        //            {
        //                btnApproved.Enabled = false;
        //                btnApproved.CssClass = "btn btn-danger btn-disabled";
        //            }

        //            if (btnPayment != null)
        //            {
        //                btnPayment.Enabled = true;
        //                btnPayment.CssClass = "btn btn-success btn-enabled"; // optional: enable styling
        //            }

        //            string alertScript = @"
        //                Swal.fire({
        //                    title: 'Success!',
        //                    text: 'Beneficiary Verified Successfully',
        //                    icon: 'success',
        //                    confirmButtonText: 'Ok',
        //                    background: '#d4edda',
        //                    color: '#155724',
        //                    iconColor: '#28a745',
        //                    backdrop: true,
        //                    showConfirmButton: true,
        //                    allowOutsideClick: false,
        //                    allowEscapeKey: false,
        //                    customClass: {
        //                        popup: 'swal2-popup-highest'
        //                    }
        //                });";

        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "BankVerifiedSuccess", alertScript, true);

        //            string userId = Session["UserId"]?.ToString();
        //            Int32 roleId = Convert.ToInt32(Session["RoleId"]);
        //            string status = "Approved by DFO, Advanced Approved by DFO, Bank Verified by Account Officer";

        //            BindUserGrid(userId, roleId, status);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        // Handle exception
        //    }
        //}



        protected void btnApprove_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                RepeaterItem item1 = (RepeaterItem)btn.NamingContainer;

                HiddenField hfBeneficiaryId = (HiddenField)item1.FindControl("hfBeneficiaryId");
                string beneficiaryId = hfBeneficiaryId?.Value;

                HiddenField hfamount = (HiddenField)item1.FindControl("hfamount");
                string amount = hfamount?.Value;

                Session["incidentamount"] = amount;

                // Store in Session so btnPaymentProceed can access it
                Session["selectedBeneficiaryId"] = beneficiaryId;

                string IncidentId = Session["incidentId"].ToString();
                string roleName1 = Session["RoleName"].ToString();
                string action = "Bank Verified by " + roleName1;
                string remarks = $"Bank Verified for Incident ID: {IncidentId}";
                string RoleID = Session["roleid"].ToString();
                string createdBy = Session["Userid"].ToString();




                //string xx = "";
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={IncidentId}";

                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;
                        JObject obj = JObject.Parse(json);

                        string laststatus = obj["status"]?.ToString();

                        if (!string.IsNullOrEmpty(laststatus) && laststatus.ToLower().Contains("advance payment recommended by dfo") || laststatus.ToLower().Contains("advance"))
                        {
                            action = action + " for Advance Payment";
                        }
                        else
                        {
                            action = action + " for Final Payment";
                        }
                    }
                }





                UpdateApplicantStatus(IncidentId, action, Session["UserId"]?.ToString(), 0);

                ApiResult result = ApiHelper.PostIncidentProgressLog(this, IncidentId, RoleID, roleName1, action, createdBy, remarks);

                if (result != null)
                {
                    Button btnApprove = (Button)sender;
                    RepeaterItem item = (RepeaterItem)btnApprove.NamingContainer;

                    Button btnInsufficient = (Button)item.FindControl("btnInsufficient");
                    Button btnApproved = (Button)item.FindControl("btnApprove");
                    Button btnPayment = pnlIncidentDetails.FindControl("btnPaymentProceed") as Button;

                    if (btnInsufficient != null)
                    {
                        btnInsufficient.Enabled = false;
                        btnInsufficient.CssClass = "btn btn-danger btn-disabled";
                    }

                    if (btnApproved != null)
                    {
                        btnApproved.Enabled = false;
                        btnApproved.CssClass = "btn btn-danger btn-disabled";
                    }

                    if (btnPayment != null)
                    {
                        btnPayment.Enabled = true;
                        btnPayment.CssClass = "btn btn-success btn-enabled"; // optional: enable styling
                    }

                    string alertScript = @"
                        Swal.fire({
                            title: 'Success!',
                            text: 'Beneficiary Verified Successfully',
                            icon: 'success',
                            confirmButtonText: 'Ok',
                            background: '#d4edda',
                            color: '#155724',
                            iconColor: '#28a745',
                            backdrop: true,
                            showConfirmButton: true,
                            allowOutsideClick: false,
                            allowEscapeKey: false,
                            customClass: {
                                popup: 'swal2-popup-highest'
                            }
                        });";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "BankVerifiedSuccess", alertScript, true);

                    string userId = Session["UserId"]?.ToString();
                    Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                    //string status = "Approved by DFO, Advanced Approved by DFO, Bank Verified by Account Officer";
                    string status = "Advance Payment Recommended by DFO, Final Payment Recommended by DFO, Payment Recommended by DFO, Bank Verified by Account Officer for Advance Payment, Bank Verified by Account Officer for Final Payment";

                    BindUserGrid(userId, roleId, status);
                }
            }
            catch (Exception ex)
            {
                // Handle exception
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


        protected void btnInsufficient_Click(object sender, EventArgs e)
        {
            try
            {
                string IncidentId = Session["incidentId"]?.ToString();
                string roleName1 = Session["RoleName"]?.ToString();
                string action = "Returned from " + roleName1;
                string remarks = $"Bank Verified for Incident ID: {IncidentId}";
                string RoleID = Session["roleid"]?.ToString();
                string createdBy = Session["Userid"]?.ToString();

                

                UpdateApplicantStatus(IncidentId, action, Session["UserId"]?.ToString(), 0);

                ApiResult result = ApiHelper.PostIncidentProgressLog(this, IncidentId, RoleID, roleName1, action, createdBy, remarks);

                if (result != null)
                {
                    // Disable Approve button inside repeater
                    Button btnInsufficient = (Button)sender;
                    RepeaterItem item = (RepeaterItem)btnInsufficient.NamingContainer;
                    Button btnApprove = (Button)item.FindControl("btnApprove");

                    if (btnApprove != null)
                    {
                        btnApprove.Enabled = false;
                        btnApprove.CssClass = "btn btn-danger btn-disabled";
                    }

                    // Disable Payment Proceed button outside repeater
                    Button btnPaymentProceed = pnlIncidentDetails.FindControl("btnPaymentProceed") as Button;
                    if (btnPaymentProceed != null)
                    {
                        btnPaymentProceed.Enabled = false;
                        btnPaymentProceed.CssClass = "btn btn-success btn-disabled"; // optional CSS
                    }

                    // Optional: show SweetAlert notification
                    string alertScript = @"
                Swal.fire({
                    title: 'Marked Insufficient',
                    text: 'This incident has been returned. Payment Proceed disabled.',
                    icon: 'warning',
                    confirmButtonText: 'Ok',
                    background: '#fff3cd',
                    color: '#856404',
                    iconColor: '#ffc107'
                });";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "InsufficientAlert", alertScript, true);

                    string userId = Session["UserId"]?.ToString();
                    Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                    //string status = "Approved by DFO, Advanced Approved by DFO, Bank Verified by Account Officer";
                    string status = "Advance Payment Recommended by DFO, Final Payment Recommended by DFO, Payment Recommended by DFO, Bank Verified by Account Officer for Advance Payment, Bank Verified by Account Officer for Final Payment";

                    BindUserGrid(userId, roleId, status);
                }
            }
            catch (Exception ex)
            {
                // Optional: show error alert
                string errorScript = $@"
            Swal.fire({{
                title: 'Error!',
                text: '{ex.Message}',
                icon: 'error',
                confirmButtonText: 'Ok',
                background: '#f8d7da',
                color: '#721c24',
                iconColor: '#dc3545'
            }});";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "InsufficientError", errorScript, true);
            }
        }


        protected void btnPaymentProceed_Click(object sender, EventArgs e)
        {
            try
            {
                string beneficiaryId = Session["selectedBeneficiaryId"]?.ToString();

                pnlPaymentModal.Visible = true;

                ScriptManager.RegisterStartupScript(this, GetType(), "ShowPaymentModal", "showPaymentModal(); disableScroll();", true);
            }
            catch (Exception ex)
            {

            }
        }

        protected void btnPaymentConfirm_Click(object sender, EventArgs e)
        {
            try
            {
                string selectedPayment = ddl_payment.SelectedValue;

                string IncidentId = Session["incidentId"].ToString();
                string roleName1 = Session["RoleName"].ToString();
                
                string remarks = $"Bank Verified for Incident ID: {IncidentId}";
                string RoleID = Session["roleid"].ToString();
                string createdBy = Session["Userid"].ToString();
                
                string ApplicantId = Session["selectedApplicantId"].ToString();
                string beneficiaryId = Session["selectedBeneficiaryId"]?.ToString();

                string claimCategory = Session["selectedclaimCategory"].ToString();
                decimal paymentAmount = Convert.ToDecimal(Session["incidentamount"]);
                string DfoStatus = Session["Status"]?.ToString() ?? "";
                string paymentType;
                string Status = "";

                if (DfoStatus.IndexOf("advance", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    paymentType = "Advance";
                    Status = "Advance Payment processed successfully";

                    if (claimCategory == "Human")
                    {
                        paymentAmount = paymentAmount * 0.30m;
                    }
                    else if (claimCategory == "Cattle")
                    {
                        paymentAmount = paymentAmount * 0.20m;
                    }
                }
                else
                {
                    paymentType = "Full Payment";
                    Status = "Payment processed successfully";

                    if (claimCategory == "Human")
                    {
                        paymentAmount = paymentAmount * 0.70m;
                    }
                    else if (claimCategory == "Cattle")
                    {
                        paymentAmount = paymentAmount * 0.80m;
                    }
                }

                string paymentStatus = "Success";
                string PaymentDetails = AddPaymentDetails(ApplicantId, IncidentId, beneficiaryId, paymentType, paymentAmount, paymentStatus, selectedPayment, createdBy);

                UpdateApplicantStatus(IncidentId, Status, Session["UserId"]?.ToString(),0);
                ApiResult result = ApiHelper.PostIncidentProgressLog(this, IncidentId, RoleID, roleName1, Status, createdBy, remarks);

                pnlPaymentModal.Visible = false;

                string alertScript = $@"
                    Swal.fire({{
                        title: 'Payment Successful!',
                        text: 'Payment via {selectedPayment} has been processed successfully.',
                        icon: 'success',
                        confirmButtonText: 'Ok',
                        background: '#d4edda',
                        color: '#155724',
                        iconColor: '#28a745',
                        backdrop: true,
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {{
                            popup: 'swal2-popup-highest'
                        }}
                    }});";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PaymentSuccess", alertScript, true);
                ScriptManager.RegisterStartupScript(this, GetType(), "HidePaymentModal", "hidePaymentModal();", true);
                pnlIncidentDetails.Visible = false;



                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                //string status = "Approved by DFO, Advanced Approved by DFO, Bank Verified by Account Officer";
                string status = "Advance Payment Recommended by DFO, Final Payment Recommended by DFO, Payment Recommended by DFO, Bank Verified by Account Officer for Advance Payment, Bank Verified by Account Officer for Final Payment";

                BindUserGrid(userId, roleId, status);


            }
            catch (Exception ex)
            {
                string errorScript = $@"
            Swal.fire({{
                title: 'Error!',
                text: '{ex.Message}',
                icon: 'error',
                confirmButtonText: 'Ok',
                background: '#f8d7da',
                color: '#721c24',
                iconColor: '#dc3545'
            }});";
                ScriptManager.RegisterStartupScript(this, GetType(), "PaymentError", errorScript, true);
            }
        }


        public string AddPaymentDetails(string applicantId, string incidentId, string beneficiaryId, string paymentType, decimal paymentAmount, string paymentStatus, string paymentMode, string createdBy)
        {
            try
            {
                var data = new
                {
                    applicantId = applicantId,
                    incidentId = incidentId,
                    beneficiaryId = beneficiaryId,
                    paymentType = paymentType,
                    paymentAmount = paymentAmount,
                    paymentStatus = paymentStatus,
                    paymentMode = paymentMode,
                    createdBy = createdBy
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblIncidentPayments/PostTblIncidentPayment";

                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                    //ClearControls();

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