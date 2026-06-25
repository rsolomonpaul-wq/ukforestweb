using System;
using System.Configuration;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Net.Http.Headers;
using uk_forest.datalayer;

namespace uk_forest.Forest
{
    public partial class BudgetDetails : System.Web.UI.Page
    {
        private readonly string _apiUrl = ConfigurationSettings.AppSettings["api_path"];
        private readonly HttpClient client = new HttpClient();
        string token_sess;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    if (Session["UserId"] != null)
                    {
                        Int32 id = Convert.ToInt32(Session["DivisionId"]);
                        BindBudgetDetailsGrid(); // Bind grid on initial load
                        BindBudgetDetailsGrid(id);
                    }
                    else
                    {
                        ShowMessage("Error: DFO ID not found in session.", "alert-danger");
                        btnSubmit.Enabled = false; // Disable submit if no DfoId
                    }
                }
            }
            catch(Exception ex)
            {

            }
        }


        void BindBudgetDetailsGrid(Int32 id)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    string url = _apiUrl + $"TblDivisionMasters/GetTblDivisionMaster?id={id}";
                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<dynamic>(EmpResponse);

                        lblDfoId.Text = data["division"].ToString();
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



        //private void BindYear()
        //{
        //    try
        //    {
        //        ddlYear.Items.Clear();

        //        int currentYear = DateTime.Now.Year;
        //        int nextYear = currentYear + 1;

        //        ddlYear.Items.Add(new ListItem("Select Year", ""));
        //        ddlYear.Items.Add(new ListItem(currentYear.ToString(), currentYear.ToString()));
        //        ddlYear.Items.Add(new ListItem(nextYear.ToString(), nextYear.ToString()));

        //        ddlYear.SelectedValue = currentYear.ToString();
        //    }
        //    catch (Exception ex)
        //    {
        //        ShowMessage("Error while binding year: " + ex.Message, "alert-danger");
        //        ddlYear.Enabled = false;
        //    }
        //}



        //protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        BindMonths();
        //        UpdateAmountPlaceholder();
        //    }
        //    catch (Exception ex)
        //    {
        //        ShowMessage("Error while updating placeholder: " + ex.Message, "alert-danger");
        //    }
        //}

        //protected void ddlMonth_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        UpdateAmountPlaceholder();
        //    }
        //    catch (Exception ex)
        //    {
        //        ShowMessage("Error while updating placeholder: " + ex.Message, "alert-danger");
        //    }
        //}

        //private void BindMonths()
        //{
        //    try
        //    {
        //        if (ddlMonth == null)
        //            throw new Exception("Month dropdown not initialized.");

        //        ddlMonth.Items.Clear();

        //        // Safety check: if no year selected
        //        if (string.IsNullOrEmpty(ddlYear.SelectedValue))
        //        {
        //            ddlMonth.Items.Insert(0, new ListItem("Select Month", ""));
        //            ddlMonth.Enabled = false;
        //            return;
        //        }

        //        int selectedYear = int.Parse(ddlYear.SelectedValue);
        //        int currentYear = DateTime.Now.Year;
        //        int currentMonth = DateTime.Now.Month;

        //        ddlMonth.Enabled = true;

        //        // Always add default item
        //        ddlMonth.Items.Add(new ListItem("Select Month", ""));

        //        // If selected year is current year → show from current month onwards
        //        int startMonth = (selectedYear == currentYear) ? currentMonth : 1;

        //        for (int i = startMonth; i <= 12; i++)
        //        {
        //            string monthName = new DateTime(selectedYear, i, 1).ToString("MMMM");
        //            ddlMonth.Items.Add(new ListItem(monthName, monthName));
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ShowMessage("Error while binding months: " + ex.Message, "alert-danger");
        //        ddlMonth.Enabled = false;
        //    }
        //}


        private void UpdateAmountPlaceholder()
        {
            try
            {
                //string month = ddlMonth.SelectedValue;
                //string year = ddlYear.SelectedValue;

                //if (!string.IsNullOrEmpty(month) && !string.IsNullOrEmpty(year))
                //{
                //    txtAmount.Attributes["placeholder"] = $"Enter Amount for {month} {year}";
                //}
                //else if (!string.IsNullOrEmpty(year))
                //{
                //    txtAmount.Attributes["placeholder"] = $"Enter Amount for selected month of {year}";
                //}
                //else
                //{
                //    txtAmount.Attributes["placeholder"] = "Enter Amount";
                //}
            }
            catch (Exception ex)
            {
                ShowMessage("Error while setting placeholder: " + ex.Message, "alert-danger");
            }
        }

        //protected async void btnSubmit_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        string amountText = txtAmount.Text.Trim();
        //        DateTime budgetReleasingDate = Convert.ToDateTime(txtReleaseDate.Text);


        //        if (string.IsNullOrEmpty(amountText) || !decimal.TryParse(amountText, out decimal amount))
        //        {
        //            ScriptManager.RegisterStartupScript(this, GetType(), "swalAmount",
        //                "Swal.fire({ icon: 'warning', title: 'Missing Amount', text: 'Please enter a valid Amount.', confirmButtonColor: '#f0ad4e' });", true);
        //            return;
        //        }

        //        if (Page.IsValid && Session["UserId"] != null && Session["RoleId"] != null)
        //        {
        //            var budgetDetail = new TblBudgetdetail
        //            {
        //                DivisionId = Session["DivisionId"].ToString(),
        //                CreatedBy = Session["UserId"].ToString(),
        //                Amount = amount,
        //                budgetReleasingDate = budgetReleasingDate
        //            };

        //            string apiUrl = $"{_apiUrl}TblBudgetdetails/PostTblBudgetdetail";
        //            var json = JsonConvert.SerializeObject(budgetDetail);
        //            var content = new StringContent(json, Encoding.UTF8, "application/json");
        //            var response = await client.PostAsync(apiUrl, content);

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseData = await response.Content.ReadAsStringAsync();
        //                var result = JsonConvert.DeserializeObject<dynamic>(responseData);

        //                ScriptManager.RegisterStartupScript(this, GetType(), "swalSuccess", $"Swal.fire({{ icon: 'success', title: 'Success!', text: '{result.Message}', confirmButtonColor: '#3085d6' }});", true);

        //                ClearForm();
        //                BindBudgetDetailsGrid();
        //            }
        //            else
        //            {
        //                var errorResponse = await response.Content.ReadAsStringAsync();
        //                ScriptManager.RegisterStartupScript(this, GetType(), "swalError",
        //                    $"Swal.fire({{ icon: 'error', title: 'Error', text: '{errorResponse}', confirmButtonColor: '#d33' }});", true);
        //            }
        //        }
        //        else
        //        {

        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}




        protected async void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string amountText = txtAmount.Text.Trim();
                DateTime budgetReleasingDate = Convert.ToDateTime(txtReleaseDate.Text);


                if (string.IsNullOrEmpty(amountText) || !decimal.TryParse(amountText, out decimal amount))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "swalAmount",
                        "Swal.fire({ icon: 'warning', title: 'Missing Amount', text: 'Please enter a valid Amount.', confirmButtonColor: '#f0ad4e' });", true);
                    return;
                }

                if (Page.IsValid && Session["UserId"] != null && Session["RoleId"] != null)
                {
                    var budgetDetail = new TblBudgetdetail
                    {
                        DivisionId = Session["DivisionId"].ToString(),
                        CreatedBy = Session["UserId"].ToString(),
                        Amount = amount,
                        budgetReleasingDate = budgetReleasingDate
                    };

                    string apiUrl = $"{_apiUrl}TblBudgetdetails/PostTblBudgetdetail";
                    var json = JsonConvert.SerializeObject(budgetDetail);
                    var content = new StringContent(json, Encoding.UTF8, "application/json");
                    var response = await client.PostAsync(apiUrl, content);

                    if (response.IsSuccessStatusCode)
                    {
                        var responseData = await response.Content.ReadAsStringAsync();
                        var result = JsonConvert.DeserializeObject<dynamic>(responseData);

                        string successMessage = result?.message != null ? result.message.ToString() : "Success!";

                        successMessage = successMessage.Replace("'", "\\'");

                        ScriptManager.RegisterStartupScript(this, GetType(), "swalSuccess",
                            $"Swal.fire({{ icon: 'success', title: 'Success!', text: '{successMessage}', confirmButtonColor: '#3085d6' }});",
                            true);

                        ClearForm();
                        BindBudgetDetailsGrid();
                    }
                    else
                    {
                        var errorResponse = await response.Content.ReadAsStringAsync();

                        string errorMessage = "";

                        try
                        {
                            // JSON ko proper object me convert karna
                            var errorObj = JsonConvert.DeserializeObject<dynamic>(errorResponse);

                            // Message extract karna
                            errorMessage = errorObj?.message != null
                                ? errorObj.message.ToString()
                                : errorResponse;
                        }
                        catch
                        {
                            // Agar JSON parse naa ho, to raw text show kare
                            errorMessage = errorResponse;
                        }

                        // JavaScript safe
                        errorMessage = errorMessage.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");

                        // Swal call
                        ScriptManager.RegisterStartupScript(
                            this,
                            this.GetType(),
                            "swalError",
                            $"Swal.fire({{ icon: 'error', title: 'Error!', text: '{errorMessage}', confirmButtonColor: '#d33' }});",
                            true
                        );
                    }
                }
                else
                {

                }
            }
            catch (Exception ex)
            {

            }
        }


        protected void BindBudgetDetailsGrid()
        {
            try
            {
                if (Session["UserId"] != null)
                {
                    string division_id = Session["DivisionId"].ToString();
                    string apiUrl = $"{_apiUrl}TblBudgetdetails/GetBudgetSummary?division_id={division_id}";

                    using (HttpClient client = new HttpClient())
                    {
                        var response = client.GetAsync(apiUrl).Result; // synchronous call

                        if (response.IsSuccessStatusCode)
                        {
                            var json = response.Content.ReadAsStringAsync().Result; // synchronous read
                            var budgetDetails = JsonConvert.DeserializeObject<List<TblBudgetdetail>>(json);

                            gvBudgetDetails.DataSource = budgetDetails;
                            gvBudgetDetails.DataBind();
                        }
                        else
                        {
                            ShowMessage("Error: Failed to fetch budget details.", "alert-danger");
                            gvBudgetDetails.DataSource = null;
                            gvBudgetDetails.DataBind();
                        }
                    }
                }
                else
                {
                    ShowMessage("Error: DFO ID not found in session.", "alert-danger");
                    gvBudgetDetails.DataSource = null;
                    gvBudgetDetails.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error: {ex.Message}", "alert-danger");
                gvBudgetDetails.DataSource = null;
                gvBudgetDetails.DataBind();
            }
        }


        private void ShowMessage(string message, string cssClass)
        {
          //  pnlMessage.Visible = true;
        //    pnlMessage.CssClass = $"alert {cssClass}";
          //  lblMessage.Text = message;
        }

        private void ClearForm()
        {
            //ddlMonth.SelectedIndex = 0;
            //ddlYear.SelectedIndex = 0;
            txtAmount.Text = "";
        }

        public class TblBudgetdetail
        {
            public int BudgetId { get; set; }
            public string DivisionId { get; set; }
            public string RoleId { get; set; }
            public string Month { get; set; }
            public string Year { get; set; }
            public decimal? Amount { get; set; }
            public bool? IsActive { get; set; }
            public string CreatedBy { get; set; }
            public DateTime? CreatedDate { get; set; }
            public string UpdatedBy { get; set; }
            public DateTime? UpdatedDate { get; set; }

            public DateTime? budgetReleasingDate { get; set; }
        }
    }
}