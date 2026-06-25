using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.Forest
{
    public partial class hwcDashboard : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string _apiUrl = ConfigurationManager.AppSettings["api_path"];
        dbquery connectDB = new dbquery();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    //DateTime today = DateTime.Today;
                    //DateTime firstDayOfYear = new DateTime(today.Year, 1, 1);

                    //txtStartDate.Text = firstDayOfYear.ToString("yyyy-MM-dd");
                    //txtEndDate.Text = today.ToString("yyyy-MM-dd");

                    DateTime today = DateTime.Today;
                    DateTime startDate = today.AddYears(-1).AddDays(1); // 1 year ago + 1 day
                    txtStartDate.Text = startDate.ToString("yyyy-MM-dd"); // 2024-11-18
                    txtEndDate.Text = today.ToString("yyyy-MM-dd");


                    string userId = Session["UserId"]?.ToString();
                    Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                    string status = "Application Submission";
                    string claim_category = "0";
                    Int32 zoneId = 0;
                    Int32 circleId = 0;

                    BindDivision();                   
                    Int32 divisionId = Convert.ToInt32(ddlDivision.SelectedValue);
                    BindRange(zoneId, circleId, divisionId);

                    bindcarddata();
                    BindBudgetCardsTotal();
                    BindBudgetCardsDisbursed();
                    BindIncidentProgressSummary();
                    RemainingAmount();
                    if (roleId == 10) // RO
                    {
                        status = "Application Submission, Document Verified by Range Officer, Advanced Approved by DFO, Document Returned by Range Officer, Document Returned by SDO, Document Returned by DFO";
                    }
                    else if (roleId == 9) //SDO
                    {
                        status = "Document Verified by SDO, Advanced Approved by Range Officer, Approved by Range Officer, Document Returned by SDO, Document Returned by DFO";
                    }
                    else if (roleId == 8) //DFO
                    {
                        status = "Document Verified by DFO, Advanced Approved by SDO, Approved by SDO, Document Returned by DFO";
                        divbudgetcards.Visible = true;
                        BindBudgetDetails(Convert.ToDateTime(txtStartDate.Text), Convert.ToDateTime(txtEndDate.Text), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlRange.SelectedValue), ddlDataType.SelectedValue);
                    }
                    else
                    {
                        status = "All";
                    }

                    BindUserGrid(userId, roleId, status, claim_category, txtStartDate.Text, txtEndDate.Text);
                    BindBudgetDetails(Convert.ToDateTime(txtStartDate.Text), Convert.ToDateTime(txtEndDate.Text), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlRange.SelectedValue), ddlDataType.SelectedValue);
                }
            }
            catch(Exception ex)
            {

            }
        }


        //void BindBudgetDetails(DateTime from_date, DateTime to_date)
        //{
        //    try
        //    {
        //        string formattedFromDate = from_date.ToString("yyyy-MM-dd");
        //        string formattedToDate = to_date.ToString("yyyy-MM-dd");
        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
        //            string url = _apiUrl + $"TblBudgetdetails/GetBudgetSummary_dashboard?from_date={formattedFromDate}&to_date={formattedToDate}";
        //            HttpResponseMessage Res = client.GetAsync(url).Result;

        //            if (Res.IsSuccessStatusCode)
        //            {
        //                var EmpResponse = Res.Content.ReadAsStringAsync().Result;
        //                var data = JsonConvert.DeserializeObject<dynamic>(EmpResponse);

        //                //lbltotalBudgetAllocated.Text = data?.totalBudgetAllocated != null ? data.totalBudgetAllocated.ToString() : "0";
        //                //lblamountDisbursed.Text = data?.amountDisbursed != null ? data.amountDisbursed.ToString() : "0";
        //                //lblpendingPayments.Text = data?.pendingPayments != null ? data.pendingPayments.ToString() : "0";
        //                //lblremainingBalance.Text = data?.remainingBalance != null ? data.remainingBalance.ToString() : "0";

        //                lbltotalBudgetAllocated.Text = data?.totalBudgetAllocated != null ? "₹ " + data.totalBudgetAllocated.ToString("N2") : "₹ 0";
        //                lblamountDisbursed.Text = data?.amountDisbursed != null ? "₹ " + data.amountDisbursed.ToString("N2") : "₹ 0";
        //                lblpendingPayments.Text = data?.pendingPayments != null ? "₹ " + data.pendingPayments.ToString("N2") : "₹ 0";
        //                lblremainingBalance.Text = data?.remainingBalance != null ? "₹ " + data.remainingBalance.ToString("N2") : "₹ 0";
        //            }
        //            else
        //            {
        //                //lbltotalBudgetAllocated.Text = "0";
        //                //lblamountDisbursed.Text = "0";
        //                //lblpendingPayments.Text = "0";
        //                //lblremainingBalance.Text = "0";

        //                lbltotalBudgetAllocated.Text = "₹ 0";
        //                lblamountDisbursed.Text = "₹ 0";
        //                lblpendingPayments.Text = "₹ 0";
        //                lblremainingBalance.Text = "₹ 0";
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}

        void BindBudgetDetails(DateTime from_date, DateTime to_date, int divisionId, int subDivisionId, int rangeId, string claimCategory)
        {
            try
            {
                string formattedFromDate = from_date.ToString("yyyy-MM-dd");
                string formattedToDate = to_date.ToString("yyyy-MM-dd");
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    //string url = _apiUrl + $"TblBudgetdetails/GetBudgetSummary_dashboard?from_date={formattedFromDate}&to_date={formattedToDate}";

                    string url = _apiUrl +
                $"TblBudgetdetails/GetBudgetSummary_dashboard" +
                $"?from_date={formattedFromDate}" +
                $"&to_date={formattedToDate}" +
                $"&divisionId={divisionId}" +
                $"&subDivisionId={subDivisionId}" +
                $"&rangeId={rangeId}" +
                $"&claimCategory={claimCategory}";
                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<dynamic>(EmpResponse);

                        lbltotalBudgetAllocated.Text = data?.totalBudgetAllocated != null ? "₹ " + data.totalBudgetAllocated.ToString("N2") : "₹ 0";
                        lblamountDisbursed.Text = data?.amountDisbursed != null ? "₹ " + data.amountDisbursed.ToString("N2") : "₹ 0";
                        lblpendingPayments.Text = data?.pendingPayments != null ? "₹ " + data.pendingPayments.ToString("N2") : "₹ 0";
                        lblremainingBalance.Text = data?.remainingBalance != null ? "₹ " + data.remainingBalance.ToString("N2") : "₹ 0";
                    }
                    else
                    {
                        lbltotalBudgetAllocated.Text = "₹ 0";
                        lblamountDisbursed.Text = "₹ 0";
                        lblpendingPayments.Text = "₹ 0";
                        lblremainingBalance.Text = "₹ 0";
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }



        private void BindUserGrid(string userId, Int32 roleId, string status, string claim_category, string fromdate, string todate)
        {
            try
            {
                claim_category = ddlDataType.SelectedValue;

                Int32 division_id = Convert.ToInt32(ddlDivision.SelectedValue);
                Int32 range_id = Convert.ToInt32(ddlRange.SelectedValue);

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{_apiUrl}TblIncidentDetails/GetDashboardIncidentFullList_Filtered" + $"?userId={userId}&roleId={roleId}&claim_category={claim_category}&fromdate={fromdate}&todate={todate}&division_id={division_id}&range_id={range_id}";
                    HttpResponseMessage response = client.GetAsync(requestUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            string result = response.Content.ReadAsStringAsync().Result;

                            JArray jsonArray = JArray.Parse(result);
                            DataTable dt = new DataTable();

                            dt.Columns.Add("victimId");
                            dt.Columns.Add("victimName");
                            dt.Columns.Add("age");
                            dt.Columns.Add("gender");
                            dt.Columns.Add("incidentId");
                            dt.Columns.Add("incidentDate");
                            dt.Columns.Add("incidentTime");
                            dt.Columns.Add("incidentCausedBy");
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
                                row["victimName"] = item["victimName"]?.ToString();
                                row["age"] = item["age"]?.ToString();
                                row["gender"] = item["gender"]?.ToString();
                                row["incidentId"] = item["incidentId"]?.ToString();
                                row["incidentDate"] = item["incidentDate"]?.ToString();
                                row["incidentTime"] = item["incidentTime"]?.ToString();
                                row["incidentCausedBy"] = item["incidentCausedBy"]?.ToString();
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



        protected void gv_incident_list_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    // Find the Label control inside the row
                    Label lblStatus = e.Row.FindControl("lbl_Status") as Label;

                    if (lblStatus != null)
                    {
                        string status = lblStatus.Text?.Trim() ?? "";
                        string s = status.ToLower();

                        // 🔴 Returned or Re-Submission → Red Bold
                        if (s.Contains("returned") || s.Contains("re-submission"))
                        {
                            lblStatus.ForeColor = System.Drawing.Color.Red;
                            lblStatus.Font.Bold = true;
                        }
                        // 🟢 Processed or Verified → Green Bold
                        else if (s.Contains("processed") || s.Contains("verified"))
                        {
                            lblStatus.ForeColor = System.Drawing.Color.Green;
                            lblStatus.Font.Bold = true;
                        }
                        else if (s.Contains("submission"))
                        {
                            lblStatus.ForeColor = System.Drawing.Color.Orange;
                            lblStatus.Font.Bold = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in RowDataBound: " + ex.Message);
            }
        }




        //protected void gv_incident_list_PageIndexChanging(object sender, GridViewPageEventArgs e)
        //{
        //    try
        //    {
        //        DateTime today = DateTime.Today;
        //        DateTime firstDayOfCurrentMonth = new DateTime(today.Year, today.Month, 1);

        //        txtStartDate.Text = firstDayOfCurrentMonth.ToString("yyyy-MM-dd");
        //        txtEndDate.Text = today.ToString("yyyy-MM-dd");



        //        string userId = Session["UserId"]?.ToString();
        //        Int32 roleId = Convert.ToInt32(Session["RoleId"]);
        //        string status = "Application Submission";

        //        if (roleId == 10) // RO
        //        {
        //            status = "Application Submission, Document Verified by Range Officer, Advanced Approved by DFO, Document Returned by Range Officer, Document Returned by SDO, Document Returned by DFO";
        //        }
        //        else if (roleId == 9) //SDO
        //        {
        //            status = "Document Verified by SDO, Advanced Approved by Range Officer, Approved by Range Officer, Document Returned by SDO, Document Returned by DFO";
        //        }
        //        else if (roleId == 8) //DFO
        //        {
        //            status = "Document Verified by DFO, Advanced Approved by SDO, Approved by SDO, Document Returned by DFO";
        //            divbudgetcards.Visible = true;
        //            //BindBudgetDetails(Convert.ToDateTime(txtStartDate.Text), Convert.ToDateTime(txtEndDate.Text));

        //            BindBudgetDetails(Convert.ToDateTime(txtStartDate.Text), Convert.ToDateTime(txtEndDate.Text), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlRange.SelectedValue), ddlDataType.SelectedValue);
        //        }
        //        else
        //        {
        //            status = "All";
        //        }

        //        string claim_category = "0";
        //        BindUserGrid(userId, roleId, status, claim_category, txtStartDate.Text, txtEndDate.Text);
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}

        protected void gv_incident_list_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                // Set the new page index
                gv_incident_list.PageIndex = e.NewPageIndex;

                // Get user and role information from session
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Application Submission";
                string claim_category = ddlDataType.SelectedValue;

                // Determine status based on role
                if (roleId == 10) // RO
                {
                    status = "Application Submission, Document Verified by Range Officer, Advanced Approved by DFO, Document Returned by Range Officer, Document Returned by SDO, Document Returned by DFO";
                }
                else if (roleId == 9) // SDO
                {
                    status = "Document Verified by SDO, Advanced Approved by Range Officer, Approved by Range Officer, Document Returned by SDO, Document Returned by DFO";
                }
                else if (roleId == 8) // DFO
                {
                    status = "Document Verified by DFO, Advanced Approved by SDO, Approved by SDO, Document Returned by DFO";
                    divbudgetcards.Visible = true;

                    // Bind budget details with current filter values
                    BindBudgetDetails(
                        Convert.ToDateTime(txtStartDate.Text),
                        Convert.ToDateTime(txtEndDate.Text),
                        Convert.ToInt32(ddlDivision.SelectedValue),
                        Convert.ToInt32(ddlDivision.SelectedValue),
                        Convert.ToInt32(ddlRange.SelectedValue),
                        ddlDataType.SelectedValue
                    );
                }
                else
                {
                    status = "All";
                }

                // Rebind the grid with current filter values (don't reset dates)
                BindUserGrid(userId, roleId, status, claim_category, txtStartDate.Text, txtEndDate.Text);

                // Update incident progress summary
                BindIncidentProgressSummary();
            }
            catch (Exception ex)
            {
                // Handle exception - you can log this if needed
                System.Diagnostics.Debug.WriteLine("Error in PageIndexChanging: " + ex.Message);

                // Show error message to user if needed
                lbl_msg_alert.Visible = true;
                lbl_msg_alert.Text = "Error loading page: " + ex.Message;
                lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
            }
        }


        protected void lnkView_Click(object sender, EventArgs e)
        {
            try
            {

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


        //public string BaseUrl { get; set; } = "http://203.122.5.18:9008/uk_forest_web/";

        public string BaseUrl { get; set; } = "https://ukforestgis.in/";
        private void BindRepeater(string incidentId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    string requestUrl = $"{_apiUrl}TblIncidentDetails/GetIncidentDetailsByIncidentId?incidentId={incidentId}";

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

        void BindIncidentProgressSummary()
        {
            try
            {
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string UserId = Session["UserId"]?.ToString();
                string claim_category = ddlDataType.SelectedValue;

                Int32 division_id = Convert.ToInt32(ddlDivision.SelectedValue);
                Int32 range_id = Convert.ToInt32(ddlRange.SelectedValue);

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    string url = _apiUrl + $"TblIncidentDetails/GetDashboardSummary_Filtered?userId={UserId}&roleId={roleId}&claim_category={claim_category }&fromdate={txtStartDate.Text}&todate={txtEndDate.Text}&division_id={division_id}&range_id={range_id}";
                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<dynamic>(EmpResponse);

                        lblTotalCases.Text = data?.totalCases != null ? data.totalCases.ToString() : "0";
                        lblactivecases.Text = data?.activeCases != null ? data.activeCases.ToString() : "0";
                        lblreturnedcases.Text = data?.returnedCases != null ? data.returnedCases.ToString() : "0";
                        lblpaidcases.Text = data?.paidCases != null ? data.paidCases.ToString() : "0";
                    }
                    else
                    {
                        lblTotalCases.Text = lblactivecases.Text = lblreturnedcases.Text = lblpaidcases.Text = "0";
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }


        void BindBudgetCardsTotal()
        {
            try
            {
                string dfoId = Session["UserId"]?.ToString();

                // 🔹 Get current month and year
                string month = DateTime.Now.ToString("MMMM"); // Example: "October"
                string year = DateTime.Now.Year.ToString();   // Example: "2025"

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    // 🔹 Build API URL dynamically
                    string url = _apiUrl + $"TblBudgetDetails/GetBudgetSummary?dfoId={dfoId}&month={month}&year={year}";

                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<dynamic>(EmpResponse);

                        //lbl_total_budget.Text = data?.totalAmount != null ? data.totalAmount.ToString() : "0";
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


        void BindBudgetCardsDisbursed()
        {
            try
            {
                string dfoId = Session["UserId"]?.ToString();

                // 🔹 Get current month and year
                string month = DateTime.Now.ToString("MMMM"); // Example: "October"
                string year = DateTime.Now.Year.ToString();   // Example: "2025"

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    // 🔹 Build API URL dynamically
                    string url = _apiUrl + $"TblBudgetDetails/GetIncidentPaymentSummary?dfoId={dfoId}&month={month}&year={year}";

                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<dynamic>(EmpResponse);

                        //lbl_disbursed_budget.Text = data?.totalAmount != null ? data.totalAmount.ToString() : "0";
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


        protected void RemainingAmount()
        {
            try
            {
                decimal totalAmount = 0;
                decimal disbursedAmount = 0;

                //decimal.TryParse(lbl_total_budget.Text.Replace(",", ""), out totalAmount);
                //decimal.TryParse(lbl_disbursed_budget.Text.Replace(",", ""), out disbursedAmount);

                //decimal remainingAmount = totalAmount - disbursedAmount;

                //lblremainingbudgetamount.Text = remainingAmount.ToString();
            }
            catch (Exception ex)
            {
                // Handle exception
                // Optionally log ex.Message
            }
        }


        //private async Task BindIncidentProgressSummary()
        //{
        //    try
        //    {
        //        int roleId = Convert.ToInt32(Session["RoleId"]); 

        //        if (!DateTime.TryParse(txtStartDate.Text.Trim(), out DateTime startDate))
        //            startDate = DateTime.Today;

        //        if (!DateTime.TryParse(txtEndDate.Text.Trim(), out DateTime endDate))
        //            endDate = DateTime.Today;

        //        string rangeId = ddlRange.SelectedValue != "0" ? ddlRange.SelectedValue : null;
        //        string divisionId = ddlDivision.SelectedValue != "0" ? ddlDivision.SelectedValue : null;
        //        string category = ddlDataType.SelectedValue;

        //        string apiUrl = $"{_apiUrl}IncidentProgressLogs/GetIncidentProgressSummary" +
        //                        $"?roleId={roleId}&startDate={startDate:yyyy-MM-dd}&endDate={endDate:yyyy-MM-dd}" +
        //                        (rangeId != null ? $"&rangeId={rangeId}" : "") +
        //                        (divisionId != null ? $"&divisionId={divisionId}" : "") +
        //                        (!string.IsNullOrEmpty(category) ? $"&category={Uri.EscapeDataString(category)}" : "");

        //        using (HttpClient client = new HttpClient())
        //        {
        //            var response = await client.GetAsync(apiUrl);

        //            int totalCases = 0, activeCases = 0, pendingCases = 0, inProcessCases = 0, solvedCases = 0;

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var json = await response.Content.ReadAsStringAsync();
        //                var data = JsonConvert.DeserializeObject<ProgressSummary>(json);
        //                if (data != null)
        //                {
        //                    totalCases = data.TotalCases;
        //                    solvedCases = data.SolvedCases;
        //                    activeCases = totalCases - solvedCases;
        //                    pendingCases = data.PendingCases;
        //                    inProcessCases = data.InProgressCases;

        //                    // Bind data to server controls
        //                    lblTotalCases.Text = totalCases.ToString();
        //                    lblPendingCases.Text = pendingCases.ToString();
        //                    lblInProcessCases.Text = inProcessCases.ToString();
        //                    lblSolvedCases.Text = solvedCases.ToString();
        //                }
        //                else
        //                {
        //                    // Reset labels if data is null
        //                    ResetCaseLabels();
        //                }
        //            }
        //            else
        //            {
        //                // Reset labels if API call fails
        //                ResetCaseLabels();
        //            }
        //        }
        //    }
        //    catch
        //    {
        //        // Reset labels in case of exception
        //        ResetCaseLabels();
        //    }
        //}

        private void ResetCaseLabels()
        {
            try
            {
                lblTotalCases.Text = "0";
                lblactivecases.Text = "0";
                lblreturnedcases.Text = "0";
                lblpaidcases.Text = "0";
            }
            catch(Exception ex)
            {

            }
        }

        //private async Task BindIncidentProgressSummary()
        //{
        //    try
        //    {
        //        int roleId = 10; // Convert.ToInt32(Session["roleid_dataKey"]);

        //        if (!DateTime.TryParse(txtStartDate.Text.Trim(), out DateTime startDate))
        //            startDate = DateTime.Today;

        //        if (!DateTime.TryParse(txtEndDate.Text.Trim(), out DateTime endDate))
        //            endDate = DateTime.Today;

        //        string rangeId = ddlRange.SelectedValue != "0" ? ddlRange.SelectedValue : null;
        //        string divisionId = ddlDivision.SelectedValue != "0" ? ddlDivision.SelectedValue : null;
        //        string category = ddlDataType.SelectedValue;

        //        string apiUrl = $"{_apiUrl}IncidentProgressLogs/GetIncidentProgressSummary" +
        //                        $"?roleId={roleId}&startDate={startDate:yyyy-MM-dd}&endDate={endDate:yyyy-MM-dd}" +
        //                        (rangeId != null ? $"&rangeId={rangeId}" : "") +
        //                        (divisionId != null ? $"&divisionId={divisionId}" : "") +
        //                        (!string.IsNullOrEmpty(category) ? $"&category={Uri.EscapeDataString(category)}" : "");

        //        using (HttpClient client = new HttpClient())
        //        {
        //            var response = await client.GetAsync(apiUrl);

        //            int totalCases = 0, activeCases = 0, pendingCases = 0, inProcessCases = 0, solvedCases = 0;

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var json = await response.Content.ReadAsStringAsync();
        //                var data = JsonConvert.DeserializeObject<ProgressSummary>(json);
        //                if (data != null)
        //                {
        //                    totalCases = data.TotalCases;
        //                    solvedCases = data.SolvedCases;
        //                    activeCases = totalCases - solvedCases;
        //                    pendingCases = data.PendingCases;
        //                    inProcessCases = data.InProgressCases;

        //                    // Pass data to JavaScript for UI binding
        //                    string script = $"updateIncidentProgressUI({totalCases}, {pendingCases}, {inProcessCases}, {solvedCases});";
        //                    ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateUI", script, true);
        //                }
        //                else
        //                {
        //                    // Handle null data
        //                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ResetCaseBoxes", "resetCaseBoxes();", true);
        //                }
        //            }
        //            else
        //            {
        //                // Handle API failure
        //                ScriptManager.RegisterStartupScript(this, this.GetType(), "ResetCaseBoxes", "resetCaseBoxes();", true);
        //            }
        //        }
        //    }
        //    catch
        //    {
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "ResetCaseBoxes", "resetCaseBoxes();", true);
        //    }
        //}



        //private async Task LoadAnimalWiseData()
        //{
        //    try
        //    {
        //        string rangeId = string.Empty;
        //        if (ddlRange.SelectedValue== "0")
        //        {
        //             rangeId = null;
        //        }
        //        else
        //        {
        //            rangeId = ddlRange.SelectedValue;
        //        }
                

        //            string divisionId = string.Empty;
        //        if (ddlDivision.SelectedValue== "0")
        //        {
        //            divisionId = null;
        //        }
        //        else
        //        {
        //            divisionId = ddlDivision.SelectedValue;
        //        }
             

           
        //        string startDate = txtStartDate.Text.Trim();
        //        string endDate = txtEndDate.Text.Trim();
        //        string category = ddlDataType.SelectedValue;

        //        // 🧩 Build dynamic API URL
        //        string apiUrl = $"{_apiUrl}IncidentProgressLogs/GetAnimalWiseIncidentData" + $"?rangeId={rangeId}&?divisionId={divisionId}&startDate={startDate}&endDate={endDate}&category={Uri.EscapeDataString(category)}";

        //        using (HttpClient client = new HttpClient())
        //        {
        //            HttpResponseMessage response = await client.GetAsync(apiUrl);

        //            if (response.IsSuccessStatusCode)
        //            {
        //                string json = await response.Content.ReadAsStringAsync();
        //                var data = JsonConvert.DeserializeObject<List<AnimalWiseIncidentData>>(json);

        //                // Convert to label and value lists
        //                var labels = data.Select(x => x.AnimalName).ToList();
        //                var counts = data.Select(x => x.TotalIncidents).ToList();

        //                // Assign JSON to hidden fields
        //                hfLabels.Value = JsonConvert.SerializeObject(labels);
        //                hfCounts.Value = JsonConvert.SerializeObject(counts);
        //            }
        //            else
        //            {
        //                hfLabels.Value = "[]";
        //                hfCounts.Value = "[]";
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        hfLabels.Value = "[]";
        //        hfCounts.Value = "[]";
        //        // Optionally log error
        //    }
        //}

        void BindDivision()
        {
            try
            {
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(_apiUrl + string.Format("TblDivisionMasters/GetTblDivisionMasters_by_user_role?userId=" + userId  + "&roleId=" + roleId)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddlDivision.Items.Clear();
                        ddlDivision.DataSource = dt;
                        ddlDivision.DataValueField = "Gid";
                        ddlDivision.DataTextField = "Division";
                        ddlDivision.DataBind();

                        if(roleId == 1 || roleId == 2)
                        {
                            ddlDivision.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                        }

                        ddlRange.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddlDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                popup.Visible = false;
                Int32 zoneId = 0;
                Int32 circleId = 0;
                Int32 divisionId = Convert.ToInt32(ddlDivision.SelectedValue);
                BindRange(zoneId, circleId, divisionId);
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Application Submission";
                string claim_category = ddlDataType.SelectedValue;

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Document Verified by Range Officer, Advanced Approved by DFO, Document Returned by Range Officer, Document Returned by SDO, Document Returned by DFO";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Advanced Approved by Range Officer, Approved by Range Officer, Document Returned by SDO, Document Returned by DFO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Advanced Approved by SDO, Approved by SDO, Document Returned by DFO";
                    divbudgetcards.Visible = true;

                }
                else
                {
                    status = "All";
                }

                BindIncidentProgressSummary();
                BindUserGrid(userId, roleId, status, claim_category, txtStartDate.Text, txtEndDate.Text);
                BindBudgetDetails(Convert.ToDateTime(txtStartDate.Text), Convert.ToDateTime(txtEndDate.Text), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlRange.SelectedValue), ddlDataType.SelectedValue);
            }
            catch (Exception ex)
            {

            }
        }

        void BindRange(Int32 zoneId, Int32 circleId, Int32 divisionId)
        {
            try
            {
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                Int32 rangeId = 0;

                if (roleId == 10 ) // RO
                {
                    rangeId = Convert.ToInt32(Session["rangeId"]);
                }
                else if (roleId == 9 || roleId == 8 || roleId == 1 || roleId == 2) //SDO & DFO & ADMIN
                {
                    rangeId = 0;
                }

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    HttpResponseMessage Res = client.GetAsync(_apiUrl + string.Format("TblRangeMasters/GetRangeMasterByAll?zoneId=" + zoneId + "&circleId=" + circleId + "&divisionId=" + divisionId + "&rangeId=" + rangeId)).Result;
                    if (divisionId != 0)
                    {
                        if (Res.IsSuccessStatusCode)
                        {
                            var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                            DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                            ddlRange.Items.Clear();
                            ddlRange.DataSource = dt;
                            ddlRange.DataValueField = "rangeId";
                            ddlRange.DataTextField = "rangeName";
                            ddlRange.DataBind();

                            if (roleId == 9 || roleId == 8 || roleId == 1 || roleId == 2) //SDO & DFO & ADMIN
                            {
                                ddlRange.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                            }
                        }
                    }
                    else
                    {
                        ddlRange.Items.Clear();
                        ddlRange.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }



        void bindcarddata()
        {
            try
            {
                popup.Visible = false;
                string conflictcategory = ddlDataType.SelectedValue;
                string datefrom = Convert.ToDateTime(txtStartDate.Text).ToString("yyyy-MM-dd");
                string dateto = Convert.ToDateTime(txtEndDate.Text).ToString("yyyy-MM-dd");
                string division = ddlDivision.SelectedValue;
                string range = ddlRange.SelectedValue;
                DataTable dt = new DataTable();
                DataTable filtered_activecases = new DataTable();
                DataTable filtered_pendingcases = new DataTable();
                DataTable filtered_inprocess = new DataTable();
                DataTable filtered_solved = new DataTable();

                string animalnames = "";
                string animaloccurance = "";
                string lblrange = "";
                string valrange = "";
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    string api_url = _apiUrl + string.Format("TblVictimIncidents/GetIncidentDetailByDate?fromDate=" + datefrom + "&toDate=" + dateto + "&conflict_category=" + conflictcategory + "&division_id=" + division + "&range_id=" + range + "");
                    HttpResponseMessage Res = client.GetAsync(api_url).Result;

                    if (Res.StatusCode == HttpStatusCode.OK)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));
                        if (dt.Rows.Count > 0)
                        {
                            filtered_activecases = dt.Clone();
                            filtered_pendingcases = dt.Clone();
                            filtered_inprocess = dt.Clone();
                            filtered_solved = dt.Clone();

                            grdmastertable.DataSource = dt;
                            grdmastertable.DataBind();

                            foreach (DataRow row in dt.Select("status = 'Pending' OR status = 'Approved by RO' OR status = 'Approved by SDO'"))
                            {
                                filtered_activecases.ImportRow(row);
                            }
                            foreach (DataRow row in dt.Select("status = 'Pending'"))
                            {
                                filtered_pendingcases.ImportRow(row);
                            }
                            foreach (DataRow row in dt.Select("status = 'Approved by RO' OR status = 'Approved by SDO'"))
                            {
                                filtered_inprocess.ImportRow(row);
                            }
                            foreach (DataRow row in dt.Select("status = 'Approved by DFO'"))
                            {
                                filtered_solved.ImportRow(row);
                            }

                            totalcase.Value = Convert.ToString(dt.Rows.Count);
                            activecase.Value = Convert.ToString(filtered_activecases.Rows.Count);
                            pendingcase.Value = Convert.ToString(filtered_pendingcases.Rows.Count);
                            inprocesscase.Value = Convert.ToString(filtered_inprocess.Rows.Count);
                            solvedcase.Value = Convert.ToString(filtered_solved.Rows.Count);

                            var uniquerange = dt.AsEnumerable()
                                  .GroupBy(row => row.Field<string>("rangeName"))
                                  .Select(g => new
                                  {
                                      range = g.Key,
                                      rangecount = g.Count()
                                  });

                            int rangetot = uniquerange.Count();
                            int c = 0;

                            foreach (var item in uniquerange)
                            {
                                c++;
                                lblrange += item.range;
                                valrange += item.rangecount;

                                if (c != rangetot)
                                {
                                    lblrange += ",";
                                    valrange += ",";
                                }
                            }


                            var uniqueLocalNames = dt.AsEnumerable()
                                  .GroupBy(row => row.Field<string>("localName"))
                                  .Select(g => new
                                  {
                                      LocalName = g.Key,
                                      Count = g.Count()
                                  });

                            int total = uniqueLocalNames.Count();
                            int i = 0;

                            foreach (var item in uniqueLocalNames)
                            {
                                i++;
                                animalnames += item.LocalName;
                                animaloccurance += item.Count;

                                if (i != total)
                                {
                                    animalnames += ",";
                                    animaloccurance += ",";
                                }
                            }
                        }
                        else
                        {
                            DataTable emptydt = new DataTable();
                            grdmastertable.DataSource = emptydt;
                            grdmastertable.DataBind();
                        }



                    }
                    else
                    {
                        totalcase.Value = Convert.ToString(dt.Rows.Count);
                        activecase.Value = Convert.ToString(filtered_activecases.Rows.Count);
                        pendingcase.Value = Convert.ToString(filtered_pendingcases.Rows.Count);
                        inprocesscase.Value = Convert.ToString(filtered_inprocess.Rows.Count);
                        solvedcase.Value = Convert.ToString(filtered_solved.Rows.Count);
                        DataTable emptydt = new DataTable();
                        grdmastertable.DataSource = emptydt;
                        grdmastertable.DataBind();

                    }

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "runScript", "callmap();", true);
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "chartscript", "chartanimal();", true);
                    string script = $"chartanimal('{animalnames}', '{animaloccurance}');";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "chartscript", script, true);

                    string scriptrange = $"chartrange('{lblrange}', '{valrange}');";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "chartscript1", scriptrange, true);

                    string scriptrangecards = $"animateCases({totalcase.Value}, {activecase.Value}, {pendingcase.Value}, {inprocesscase.Value}, {solvedcase.Value});;";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "scriptrangecard", scriptrangecards, true);


                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            try
            {
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Application Submission";
                string claim_category = ddlDataType.SelectedValue;

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Document Verified by Range Officer, Advanced Approved by DFO, Document Returned by Range Officer, Document Returned by SDO, Document Returned by DFO";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Advanced Approved by Range Officer, Approved by Range Officer, Document Returned by SDO, Returned by DFO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Advanced Approved by SDO, Approved by SDO, Document Returned by DFO";
                    divbudgetcards.Visible = true;

                }
                else
                {
                    status = "All";
                }

                BindIncidentProgressSummary();
                BindUserGrid(userId, roleId, status, claim_category, txtStartDate.Text, txtEndDate.Text);
                BindBudgetDetails(Convert.ToDateTime(txtStartDate.Text), Convert.ToDateTime(txtEndDate.Text), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlRange.SelectedValue), ddlDataType.SelectedValue);
            }
            catch(Exception ex)
            {

            }
        }


        protected void btnshowCase_Click(object sender, EventArgs e)
        {
            try
            {
                popup.Visible = false;
                string incidentId = "";
                Button btn = (Button)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                incidentId = grdmastertable.DataKeys[row.RowIndex].Value.ToString();

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    string api_url = _apiUrl + $"TblVictimIncidents/GetIncidentDetailsById?incidentId={incidentId}";
                    HttpResponseMessage Res = client.GetAsync(api_url).Result;

                    if (Res.StatusCode == HttpStatusCode.OK)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        var json = JObject.Parse(EmpResponse);

                        // Show Popup


                        // Incident Info
                        lblIncidentId.Text = (string)json["incidentId"];
                        lblIncidentDate.Text = (string)json["incidentDate"];
                        lblIncidentPlace.Text = (string)json["incidentPlace"];
                        lblActivity.Text = (string)json["activity"];
                        lblStatus.Text = (string)json["status"];
                        lblLatitude.Text = json["latitude"].ToString();
                        lblLongitude.Text = json["longitude"].ToString();

                        // Victim Info
                        lblVictimName.Text = (string)json["victim"]["name"];
                        lblVictimAge.Text = json["victim"]["age"].ToString();
                        lblVictimGender.Text = (string)json["victim"]["gender"];
                        lblVictimAadhar.Text = (string)json["victim"]["aadharNo"];

                        // Applicant Info
                        lblApplicantName.Text = (string)json["applicant"]["name"];
                        lblApplicantMobile.Text = (string)json["applicant"]["mobileNo"];
                        lblApplicantAddress.Text = (string)json["applicant"]["address"];
                        lblApplicantAadhar.Text = (string)json["applicant"]["aadharNo"];

                        // Conflict Animal
                        lblAnimalName.Text = (string)json["conflictAnimal"]["animalName"];
                        lblAnimalLocalName.Text = (string)json["conflictAnimal"]["localName"];
                        lblConflictCategory.Text = (string)json["conflictAnimal"]["conflictCategory"];

                        // Location Info
                        lblRange.Text = (string)json["location"]["range"];
                        lblSubDivision.Text = (string)json["location"]["subDivision"];
                        lblDivision.Text = (string)json["location"]["division"];
                        lblCircle.Text = (string)json["location"]["circle"];
                        lblZone.Text = (string)json["location"]["zone"];

                        // Payment Info
                        var payments = json["payments"];
                        if (payments != null && payments.HasValues)
                        {
                            var adv = payments.FirstOrDefault(p => (string)p["paymentType"] == "Advance");
                            var rem = payments.FirstOrDefault(p => (string)p["paymentType"] == "Remaining");

                            if (adv != null)
                            {
                                lblAdvanceAmount.Text = adv["paymentAmount"]?.ToString();
                                lblAdvanceStatus.Text = (string)adv["paymentStatus"];
                                lblAdvanceMode.Text = (string)adv["paymentMode"];
                                lblAdvanceReference.Text = (string)adv["paymentReferenceNo"];
                                lblAdvanceDate.Text = adv["paymentDate"] != null ?
                                                      DateTime.Parse(adv["paymentDate"].ToString()).ToString("dd-MM-yyyy hh:mm tt") : "";
                                lblAdvanceRemarks.Text = (string)adv["remarks"];
                            }
                            else
                            {
                                lblAdvanceAmount.Text = "";
                                lblAdvanceStatus.Text = "";
                                lblAdvanceMode.Text = "";
                                lblAdvanceReference.Text = "";
                                lblAdvanceDate.Text = "";
                                lblAdvanceRemarks.Text = "";
                            }

                            if (rem != null)
                            {
                                lblRemainingAmount.Text = rem["paymentAmount"]?.ToString();
                                lblRemainingStatus.Text = (string)rem["paymentStatus"];
                                lblRemainingMode.Text = (string)rem["paymentMode"];
                                lblRemainingReference.Text = (string)rem["paymentReferenceNo"];
                                lblRemainingDate.Text = rem["paymentDate"] != null ?
                                                        DateTime.Parse(rem["paymentDate"].ToString()).ToString("dd-MM-yyyy hh:mm tt") : "";
                                lblRemainingRemarks.Text = (string)rem["remarks"];
                            }
                            else
                            {
                                lblRemainingAmount.Text = "";
                                lblRemainingStatus.Text = "";
                                lblRemainingMode.Text = "";
                                lblRemainingReference.Text = "";
                                lblRemainingDate.Text = "";
                                lblRemainingRemarks.Text = "";
                            }
                        }
                        else
                        {
                            lblAdvanceAmount.Text = "";
                            lblAdvanceStatus.Text = "";
                            lblAdvanceMode.Text = "";
                            lblAdvanceReference.Text = "";
                            lblAdvanceDate.Text = "";
                            lblAdvanceRemarks.Text = "";
                            lblRemainingAmount.Text = "";
                            lblRemainingStatus.Text = "";
                            lblRemainingMode.Text = "";
                            lblRemainingReference.Text = "";
                            lblRemainingDate.Text = "";
                            lblRemainingRemarks.Text = "";
                        }

                        // Document Info
                        var docs = json["documents"];
                        if (docs != null && docs.HasValues)
                        {
                            foreach (var doc in docs)
                            {
                                string docName = (string)doc["documentName"];
                                string path = (string)doc["filePath"];
                                if (docName == "Photograph")
                                {
                                    string pth = "";
                                    // lblPhotographDoc.Text = "http://203.122.5.18:9008/uk_forest_web/web/"+  path;
                                    if (path == null || path == "")
                                    {
                                        pth = "/web/img/icons/Image_not_available.png";
                                    }
                                    else
                                    {
                                        pth = path.Replace("\\", "/");
                                    }

                                    //PhotographDoc.Src = "http://203.122.5.18:9008/uk_forest_web/" + pth;

                                    PhotographDoc.Src = "https://ukforestgis.in/" + pth;
                                }
                                else if (docName == "Village Head Certificate")
                                {
                                    string pth = "";
                                    if (path == null || path == "")
                                    {
                                        pth = "/web/img/icons/Image_not_available.png";
                                    }
                                    else
                                    {
                                        pth = path.Replace("\\", "/");
                                    }
                                    //VillageHeadCert.Src = "http://203.122.5.18:9008/uk_forest_web/" + pth;

                                    VillageHeadCert.Src = "https://ukforestgis.in/" + pth;
                                }
                                else
                                {
                                    string pth = "";

                                    pth = "/web/img/icons/Image_not_available.png";

                                    //VillageHeadCert.Src = "http://203.122.5.18:9008/uk_forest_web/" + pth;
                                    //PhotographDoc.Src = "http://203.122.5.18:9008/uk_forest_web/" + pth;

                                    VillageHeadCert.Src = "https://ukforestgis.in/" + pth;
                                    PhotographDoc.Src = "https://ukforestgis.in/" + pth;
                                }
                            }
                        }

                        // Show popup


                        popup.Style.Add("display", "block");
                        popup.Visible = true;

                    }
                }
            }
            catch (Exception ex)
            {
                // Handle/log error
            }
        }

        protected void btnclosepopup_Click(object sender, EventArgs e)
        {
            popup.Visible = false;
        }
        public class AnimalWiseIncidentData
        {
            public string AnimalName { get; set; }
            public int TotalIncidents { get; set; }
        }
        public class ProgressSummary
        {
            public int RoleId { get; set; }
            public int TotalCases { get; set; }
            public int PendingCases { get; set; }
            public int InProgressCases { get; set; }
            public int SolvedCases { get; set; }
        }

        protected void ddlDataType_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Application Submission";
                string claim_category = ddlDataType.SelectedValue;

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Document Verified by Range Officer, Advanced Approved by DFO, Document Returned by Range Officer, Document Returned by SDO, Document Returned by DFO";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Advanced Approved by Range Officer, Approved by Range Officer, Document Returned by SDO, Document Returned by DFO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Advanced Approved by SDO, Approved by SDO, Document Returned by DFO";
                    divbudgetcards.Visible = true;

                }
                //else if (roleId == 1 || roleId == 1) //DFO
                //{
                //    budgetchartdiv.Visible = true;
                //    divbudgetcards.Visible = true;
                //}
                else
                {
                    status = "All";
                }

                BindIncidentProgressSummary();
                BindUserGrid(userId, roleId, status, claim_category, txtStartDate.Text, txtEndDate.Text);
                BindBudgetDetails(Convert.ToDateTime(txtStartDate.Text), Convert.ToDateTime(txtEndDate.Text), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlRange.SelectedValue), ddlDataType.SelectedValue);
            }
            catch(Exception ex)
            {

            }
        }

        protected void ddlRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string userId = Session["UserId"]?.ToString();
                Int32 roleId = Convert.ToInt32(Session["RoleId"]);
                string status = "Application Submission";
                string claim_category = ddlDataType.SelectedValue;

                if (roleId == 10) // RO
                {
                    status = "Application Submission, Document Verified by Range Officer, Advanced Approved by DFO, Document Returned by Range Officer, Document Returned by SDO, Document Returned by DFO";
                }
                else if (roleId == 9) //SDO
                {
                    status = "Document Verified by SDO, Advanced Approved by Range Officer, Approved by Range Officer, Document Returned by SDO, Document Returned by DFO";
                }
                else if (roleId == 8) //DFO
                {
                    status = "Document Verified by DFO, Advanced Approved by SDO, Approved by SDO, Document Returned by DFO";
                    divbudgetcards.Visible = true;
                }
                else
                {
                    status = "All";
                }

                BindIncidentProgressSummary();
                BindUserGrid(userId, roleId, status, claim_category, txtStartDate.Text, txtEndDate.Text);
                BindBudgetDetails(Convert.ToDateTime(txtStartDate.Text), Convert.ToDateTime(txtEndDate.Text), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlDivision.SelectedValue), Convert.ToInt32(ddlRange.SelectedValue), ddlDataType.SelectedValue);
            }
            catch (Exception ex)
            {

            }
        }
    }

}


