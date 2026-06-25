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
    public partial class incident_approval_detail : System.Web.UI.Page
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

                    //BindUserGrid(user_id);
                    //BindUserGrid(role_id, user_id, status);

                    string selectedValue = rblApprovalStatus.SelectedItem.Text;
                    BindUserGrid(role_id, user_id, selectedValue);
                }
            }
            catch (Exception ex)
            {

            }
        }

     

        protected void rblApprovalStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            string user_id = Session["UserId"].ToString();
            int role_id = Convert.ToInt32(Session["RoleId"]);
            string selectedValue = rblApprovalStatus.SelectedItem.Text;
            BindUserGrid(role_id, user_id, selectedValue);
            switch (selectedValue)
            {
                //case "Pending":
                //    lblStatusMessage.Text = "Current status: Pending.";
                //    break;

                //case "ApprovedByRO":
                //    lblStatusMessage.Text = "Approved by Range Officer.";
                //    break;

                //case "ApprovedBySDO":
                //    lblStatusMessage.Text = "Approved by Sub-Divisional Officer.";
                //    break;

                //case "ApprovedByDFO":
                //    lblStatusMessage.Text = "Approved by Divisional Forest Officer.";
                //    break;
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

   
    }

}