using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class ApplicantDashboard : System.Web.UI.Page
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
                    string applicant_id = Session["UserId"].ToString();
                    BindCardsData(applicant_id);
                    BindRepeaterdata(applicant_id);
                }
            }
            catch (Exception ex)
            {

            }
        }

        //protected void btnAdd_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        Response.Redirect("victimincident.aspx", false);
        //        Context.ApplicationInstance.CompleteRequest(); // graceful exit
        //    }
        //    catch (Exception ex)
        //    {
        //        // Optional: Log the exception if needed
        //    }
        //}




        //protected async void btnAdd_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        string applicantId = Session["UserId"].ToString();// get dynamically if needed
        //       // string apiUrl = $"http://203.122.5.18:9008/uk_forest_api/api/TblApplicantMasters/GetTblApplicant_byApplicantId?applicant_id={applicantId}";
        //        string requestUrl = apiUrl + "TblApplicantMasters/GetTblApplicant_byApplicantId?applicant_id=" + applicantId;

        //        using (HttpClient client = new HttpClient())
        //        {
        //            HttpResponseMessage response = await client.GetAsync(requestUrl);
        //            if (response.IsSuccessStatusCode)
        //            {
        //                string jsonResponse = await response.Content.ReadAsStringAsync();

        //                // ✅ Parse JSON directly
        //                JObject json = JObject.Parse(jsonResponse);

        //                string address = (string)json["address"];
        //                string pincode = (string)json["pincode"];
        //                string district = (string)json["district"];

        //                // ✅ Check if any field has data
        //                if (!string.IsNullOrEmpty(address) ||
        //                    !string.IsNullOrEmpty(pincode) ||
        //                    !string.IsNullOrEmpty(district))
        //                {
        //                    Response.Redirect("victimincident.aspx", false);
        //                    Context.ApplicationInstance.CompleteRequest();
        //                }
        //                else
        //                {
        //                    Response.Redirect("applicant_details.aspx", false);
        //                    Context.ApplicationInstance.CompleteRequest();
        //                }
        //            }
        //            else
        //            {
        //                // API not successful → redirect to applicant details
        //                Response.Redirect("applicant_details.aspx", false);
        //                Context.ApplicationInstance.CompleteRequest();
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        // Optional: log or show error
        //    }
        //}




        //protected async void btnAdd_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        string applicantId = Session["UserId"].ToString();// get dynamically if needed
        //                                                          // string apiUrl = $"http://203.122.5.18:9008/uk_forest_api/api/TblApplicantMasters/GetTblApplicant_byApplicantId?applicant_id={applicantId}";
        //        string requestUrl = apiUrl + "TblApplicantMasters/GetTblApplicant_byApplicantId?applicant_id=" + applicantId;

        //        using (HttpClient client = new HttpClient())
        //        {
        //            HttpResponseMessage response = await client.GetAsync(requestUrl);
        //            if (response.IsSuccessStatusCode)
        //            {
        //                string jsonResponse = await response.Content.ReadAsStringAsync();

        //                // ✅ Parse JSON directly
        //                JObject json = JObject.Parse(jsonResponse);

        //                string address = (string)json["address"];
        //                string pincode = (string)json["pincode"];
        //                string district = (string)json["district"];

        //                // ✅ Check if any field has data
        //                if (!string.IsNullOrEmpty(address) ||
        //                    !string.IsNullOrEmpty(pincode) ||
        //                    !string.IsNullOrEmpty(district))
        //                {
        //                    Response.Redirect("victimincident.aspx", false);
        //                    Context.ApplicationInstance.CompleteRequest();
        //                }
        //                else
        //                {
        //                    Response.Redirect("applicant_details.aspx", false);
        //                    Context.ApplicationInstance.CompleteRequest();
        //                }
        //            }
        //            else
        //            {
        //                // API not successful → redirect to applicant details
        //                Response.Redirect("applicant_details.aspx", false);
        //                Context.ApplicationInstance.CompleteRequest();
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        // Optional: log or show error
        //    }
        //}





        protected async void btnAdd_Click(object sender, EventArgs e)
        {
            try
            {
                string applicantId = Session["UserId"].ToString();
                using (HttpClient client = new HttpClient())
                {
                    // ✅ Step 1: Check applicant details
                    string applicantApiUrl = apiUrl + "TblApplicantMasters/GetTblApplicant_byApplicantId?applicant_id=" + applicantId;
                    HttpResponseMessage applicantResponse = await client.GetAsync(applicantApiUrl);

                    if (applicantResponse.IsSuccessStatusCode)
                    {
                        string applicantJson = await applicantResponse.Content.ReadAsStringAsync();
                        JObject applicantData = JObject.Parse(applicantJson);

                        string address = (string)applicantData["address"];
                        string pincode = (string)applicantData["pincode"];
                        string district = (string)applicantData["district"];

                        // ✅ Step 2: If applicant details are missing → redirect to applicant_details.aspx
                        if (string.IsNullOrEmpty(address) && string.IsNullOrEmpty(pincode) && string.IsNullOrEmpty(district))
                        {
                            Response.Redirect("applicant_details.aspx", false);
                            Context.ApplicationInstance.CompleteRequest();
                            return;
                        }

                        // ✅ Step 3: Check beneficiary details
                        string beneficiaryApiUrl = apiUrl + "TblBeneficiaryMasters/GetTblApplicantBeneficiaryDetail_byApplicantId?applicant_id=" + applicantId;
                        HttpResponseMessage beneficiaryResponse = await client.GetAsync(beneficiaryApiUrl);

                        if (beneficiaryResponse.IsSuccessStatusCode)
                        {
                            string beneficiaryJson = await beneficiaryResponse.Content.ReadAsStringAsync();
                            var beneficiaryList = JsonConvert.DeserializeObject<List<JObject>>(beneficiaryJson);

                            // ✅ Step 4: If beneficiary record exists → go to victimincident.aspx
                            if (beneficiaryList != null && beneficiaryList.Count > 0)
                            {
                                Response.Redirect("victimincident.aspx", false);
                                Context.ApplicationInstance.CompleteRequest();
                                return;
                            }
                            else
                            {
                                // ✅ No beneficiary record → go to beneficiary page
                                Response.Redirect("addbeneficiary.aspx", false);
                                Context.ApplicationInstance.CompleteRequest();
                                return;
                            }
                        }
                        else
                        {
                            // API failed → redirect to beneficiary page
                            Response.Redirect("beneficiary_details.aspx", false);
                            Context.ApplicationInstance.CompleteRequest();
                            return;
                        }
                    }
                    else
                    {
                        // Applicant not found → redirect to applicant page
                        Response.Redirect("applicant_details.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                }
            }
            catch (Exception ex)
            {
                // You can log the exception if needed
                Response.Redirect("applicant_details.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }




        void BindCardsData(string applicant_id)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    // API endpoint
                    string requestUrl = apiUrl + "IncidentProgressLogs/GetIncidentStatusSummaryByApplicant?applicant_id=" + applicant_id;
                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        var responseMessage = response.Content.ReadAsStringAsync().Result;

                        // Parse as JObject since your API returns a single JSON object, not an array
                        JObject data = JObject.Parse(responseMessage);

                        // Safely bind values to labels
                        lblTotalCases.Text = data["totalCases"]?.ToString() ?? "0";
                        lblPendingCases.Text = data["paidCases"]?.ToString() ?? "0";
                        lblReturnedCases.Text = data["returnedCases"]?.ToString() ?? "0";
                        lblActiveCases.Text = data["activeCases"]?.ToString() ?? "0";
                    }
                    else
                    {
                        // Default values if API fails
                        lblTotalCases.Text = "0";
                        lblPendingCases.Text = "0";
                        lblReturnedCases.Text = "0";
                        lblActiveCases.Text = "0";
                    }
                }
            }
            catch (Exception ex)
            {
                // Optional: log this instead of throwing directly
                lblTotalCases.Text = "Error";
                lblPendingCases.Text = "Error";
                lblReturnedCases.Text = "Error";
                lblActiveCases.Text = "Error";
            }
        }


        void BindRepeaterdata(string applicant_id)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    string requestUrl = apiUrl + "IncidentProgressLogs/GetIncidentDetailsByApplicant?applicant_id=" + applicant_id;
                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        var responseMessage = response.Content.ReadAsStringAsync().Result;

                        // Deserialize JSON array to DataTable
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(responseMessage, typeof(DataTable));

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            rptCases.DataSource = dt;
                            rptCases.DataBind();
                            lblmsg.Visible = false;
                        }
                        else
                        {
                            rptCases.DataSource = null;
                            rptCases.DataBind();

                            lblmsg.Visible = true;
                            lblmsg.ForeColor = System.Drawing.Color.Red;
                            //lblmsg.Text = "No record found";
                            lblmsg.Text = "No records found. Please click 'Add Incident' to create a new case.";
                        }
                    }
                    else
                    {
                        // Handle API failure
                        rptCases.DataSource = null;
                        rptCases.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                // Optionally log or display the exception
            }
        }

        protected void rptCases_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    Label lblStatus = (Label)e.Item.FindControl("lblStatus");
                    if (lblStatus != null && !string.IsNullOrEmpty(lblStatus.Text))
                    {
                        string statusText = lblStatus.Text.Trim().ToLower();
                        //lblStatus.Font.Bold = true;

                        switch (statusText)
                        {
                            case var s when s.Contains("submission"):
                                lblStatus.ForeColor = System.Drawing.Color.Orange;
                                break;
                            case var s when s.Contains("returned"):
                                lblStatus.ForeColor = System.Drawing.Color.Red;
                                break;
                            case var s when s.Contains("approved"):
                                lblStatus.ForeColor = System.Drawing.Color.Green;
                                break;
                            case var s when s.Contains("verified"):
                                lblStatus.ForeColor = System.Drawing.Color.Green;
                                break;
                            default:
                                //lblStatus.ForeColor = System.Drawing.Color.Black;
                                lblStatus.Font.Bold = false;
                                break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in ItemDataBound: " + ex.Message);
            }
        }


    }
}