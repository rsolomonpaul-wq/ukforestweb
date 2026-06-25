using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{

    public partial class incidentlistDFO : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DateTime today = DateTime.Today;
                DateTime firstDayOfMonth = new DateTime(today.Year, today.Month, 1);
                txtFromDate.Text = firstDayOfMonth.ToString("yyyy-MM-dd");
                txtToDate.Text = today.ToString("yyyy-MM-dd");

                rblClaimType.SelectedValue = "HumanDeath";

                string applicantId = Session["UserId"].ToString();
                ViewState["ApplicantId"] = applicantId;
                BindUserGrid(applicantId);
            }
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
            }
            catch (Exception ex)
            {

            }
        }

        private void BindUserGrid(string applicantId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = client.GetAsync($"{apiUrl}TblVictimIncidents/GetTblVictimIncident_byApplicantId?applicant_id={applicantId}").Result;

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

        protected void btnClosePopup_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HidePopup", "hidePopup();", true);
        }

        protected bool IsImageFile(string filePath)
        {
            if (string.IsNullOrEmpty(filePath))
                return false;

            string extension = System.IO.Path.GetExtension(filePath)?.ToLower();
            return extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".gif" || extension == ".webp";
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

        protected void ddl_status_approved_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                //payment_panel.Style.Add("display", "none");

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

                        //rptIncidentDetails.DataSource = mainDt;
                        //rptIncidentDetails.DataBind();
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

                        //Repeater1.DataSource = incidentList;
                        //Repeater1.DataBind();

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopupVerify();", true);
                    }
                }
                if (!string.IsNullOrEmpty(permission) && permission == "Approve")
                {
                    Int32 RoleId = Convert.ToInt32(Session["RoleId"]);

                    //if (RoleId == 10)
                    //{
                    //    string incidentId = gv_incident_list.DataKeys[gvrow.RowIndex].Value.ToString();

                    //    Label lblApplicantId = (Label)gvrow.FindControl("lbl_ApplicantId");
                    //    string applicantId = lblApplicantId != null ? lblApplicantId.Text : "NA";

                    //    txt_incidentid.Text = incidentId;
                    //    txt_applicantid.Text = applicantId;

                    //    Label lblHumanLoss = (Label)gvrow.FindControl("lbl_human_loss");
                    //    string human_loss = lblHumanLoss?.Text;

                    //    DamageTypeDropdown("Human", human_loss);

                    //    ApplicantDetailsBank(gvrow);

                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopup_payment_panel();", true);
                    //    payment_panel.Style.Add("display", "block");
                    //}
                    //else if (RoleId == 9)
                    //{
                    //    string IncidentId = gv_incident_list.DataKeys[gvrow.RowIndex].Value.ToString();
                    //    string Status = "Approved by SDO";
                    //    string UpdatedBy = Session["UserId"].ToString();

                    //    string incident = UpdateIncident(IncidentId, Status, UpdatedBy);
                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopup_approvalSuccess_panel();", true);

                    //    string user_id = Session["UserId"].ToString();
                    //    int role_id = Convert.ToInt32(Session["RoleId"]);
                    //    string status = "Approved by RO";

                    //    BindUserGrid(role_id, user_id, status);

                    //}
                    //else if (RoleId == 8)
                    //{
                    //    string incidentId = gv_incident_list.DataKeys[gvrow.RowIndex].Value.ToString();

                    //    Label lblApplicantId = (Label)gvrow.FindControl("lbl_ApplicantId");
                    //    string applicantId = lblApplicantId != null ? lblApplicantId.Text : "NA";

                    //    txt_incidentid.Text = incidentId;
                    //    txt_applicantid.Text = applicantId;
                    //    ApplicantDetailsDFO(gvrow);

                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "showPopup_approvalSuccess_panel_dfo();", true);
                    //    payment_panel.Style.Add("display", "block");

                    //    string user_id = Session["UserId"].ToString();
                    //    int role_id = Convert.ToInt32(Session["RoleId"]);
                    //    string status = "Approved by SDO";

                    //    BindUserGrid(role_id, user_id, status);

                    //}
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {

            }
            catch (Exception ex)
            {

            }
        }
    }
}