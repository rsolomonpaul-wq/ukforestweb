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
    public partial class Account_DashBoard : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string _apiUrl = ConfigurationSettings.AppSettings["api_path"];
        dbquery connectDB = new dbquery();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    DateTime today = DateTime.Today;
                    DateTime firstDayOfYear = new DateTime(today.Year, 1, 1);

                    txtFromDate.Text = firstDayOfYear.ToString("yyyy-MM-dd");
                    txtToDate.Text = today.ToString("yyyy-MM-dd");

                    BindDivision();
                    Int32 zoneId = 0;
                    Int32 circleId = 0;
                    Int32 divisionId = Convert.ToInt32(ddlDivision.SelectedValue);
                    BindRange(zoneId, circleId, divisionId);

                    BindBudgetDetails((Convert.ToDateTime(txtFromDate.Text)), Convert.ToDateTime(txtToDate.Text));
                    BindBudgetDetailsGrid(Convert.ToDateTime(txtFromDate.Text), Convert.ToDateTime(txtToDate.Text));
                }
                //if (!IsPostBack)
                //{
                //    DateTime currentDate = DateTime.Now;
                //    DateTime firstDayOfMonth = new DateTime(currentDate.Year, currentDate.Month, 1);
                //    txtFromDate.Text = firstDayOfMonth.ToString("yyyy-MM-dd");
                //    txtToDate.Text = currentDate.ToString("yyyy-MM-dd");

                //    BindBudgetDetails(firstDayOfMonth, currentDate);
                //    BindBudgetDetailsGrid(Convert.ToDateTime(txtFromDate.Text), Convert.ToDateTime(txtToDate.Text));
                //}
            }
            catch (Exception ex)
            {

            }
        }



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
                    HttpResponseMessage Res = client.GetAsync(_apiUrl + string.Format("TblDivisionMasters/GetTblDivisionMasters_by_user_role?userId=" + userId + "&roleId=" + roleId)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddlDivision.Items.Clear();
                        ddlDivision.DataSource = dt;
                        ddlDivision.DataValueField = "Gid";
                        ddlDivision.DataTextField = "Division";
                        ddlDivision.DataBind();

                        if (roleId == 1 || roleId == 2)
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
                Int32 zoneId = 0;
                Int32 circleId = 0;
                Int32 divisionId = Convert.ToInt32(ddlDivision.SelectedValue);
                BindRange(zoneId, circleId, divisionId);
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

                if (roleId == 10) // RO
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


        void BindBudgetDetails(DateTime from_date, DateTime to_date)
        {
            try
            {
                string formattedFromDate = from_date.ToString("yyyy-MM-dd");
                string formattedToDate = to_date.ToString("yyyy-MM-dd");
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    string url = _apiUrl + $"TblBudgetdetails/GetBudgetSummary_dashboard?from_date={formattedFromDate}&to_date={formattedToDate}";
                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<dynamic>(EmpResponse);

                        //lbltotalBudgetAllocated.Text = data?.totalBudgetAllocated != null ? data.totalBudgetAllocated.ToString() : "0";
                        //lblamountDisbursed.Text = data?.amountDisbursed != null ? data.amountDisbursed.ToString() : "0";
                        //lblpendingPayments.Text = data?.pendingPayments != null ? data.pendingPayments.ToString() : "0";
                        //lblremainingBalance.Text = data?.remainingBalance != null ? data.remainingBalance.ToString() : "0";

                        lbltotalBudgetAllocated.Text = data?.totalBudgetAllocated != null ? "₹ " + data.totalBudgetAllocated.ToString("N2") : "₹ 0";
                        lblamountDisbursed.Text = data?.amountDisbursed != null ? "₹ " + data.amountDisbursed.ToString("N2") : "₹ 0";
                        lblpendingPayments.Text = data?.pendingPayments != null ? "₹ " + data.pendingPayments.ToString("N2") : "₹ 0";
                        lblremainingBalance.Text = data?.remainingBalance != null ? "₹ " + data.remainingBalance.ToString("N2") : "₹ 0";


                    }
                    else
                    {
                        //lbltotalBudgetAllocated.Text = "0";
                        //lblamountDisbursed.Text = "0";
                        //lblpendingPayments.Text = "0";
                        //lblremainingBalance.Text = "0";

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

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                BindBudgetDetails(Convert.ToDateTime(txtFromDate.Text), Convert.ToDateTime(txtToDate.Text));
                BindBudgetDetailsGrid(Convert.ToDateTime(txtFromDate.Text), Convert.ToDateTime(txtToDate.Text));
            }
            catch (Exception ex)
            {

            }
        }




        void BindBudgetDetailsGrid(DateTime from_date, DateTime to_date)
        {
            try
            {
                string formattedFromDate = from_date.ToString("yyyy-MM-dd");
                string formattedToDate = to_date.ToString("yyyy-MM-dd");
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    string url = _apiUrl + $"TblBudgetdetails/GetBudgetDetail_IncidentWise?from_date={formattedFromDate}&to_date={formattedToDate}";
                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<dynamic>(EmpResponse);

                        gvIncidents.DataSource = data;
                        gvIncidents.DataBind();
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
    }

}


