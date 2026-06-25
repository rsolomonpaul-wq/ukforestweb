using System;
using System.Configuration;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace uk_forest.Forest
{
    public partial class ForestGuardAsign : System.Web.UI.Page
    {
        private static readonly HttpClient client = new HttpClient();
        string _apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected async void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                await BindForestGuardsAsync();
            }
        }

        private async Task BindForestGuardsAsync()
        {
            try
            {
                string userId = Session["UserId"].ToString();
                if (string.IsNullOrEmpty(userId))
                {
                    ddlForestGuard.Items.Clear();
                    ddlForestGuard.Items.Add(new ListItem("Error: User ID not found in session", ""));
                    ddlForestGuard.Items.Add(new ListItem("Add New Guard", "0"));
                    return;
                }

                // string apiUrl = $"http://203.122.5.18:9008/uk_forest_api/api/TblForestGuardMasters/Get_TblForestGuardMasters_by_RO?ro_id={HttpUtility.UrlEncode(userId)}";
                string apiUrl = $"{_apiUrl}TblForestGuardMasters/Get_TblForestGuardMasters_by_RO?ro_id={HttpUtility.UrlEncode(userId)}";

                HttpResponseMessage response = await client.GetAsync(apiUrl);
                if (response.IsSuccessStatusCode)
                {
                    string json = await response.Content.ReadAsStringAsync();
                    JArray guards = JArray.Parse(json);

                    ddlForestGuard.Items.Clear();
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
                    ddlForestGuard.Items.Clear();
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
                //string apiUrl = $"http://203.122.5.18:9008/uk_forest_api/api/TblForestGuardMasters/Get_TblForestGuardMasters_by_Forest_Guard_Id?forest_guard_id={HttpUtility.UrlEncode(selectedValue)}";

                string apiUrl = $"{_apiUrl}TblForestGuardMasters/Get_TblForestGuardMasters_by_Forest_Guard_Id?forest_guard_id={HttpUtility.UrlEncode(selectedValue)}";
                HttpResponseMessage response = await client.GetAsync(apiUrl);
                if (response.IsSuccessStatusCode)
                {
                    string json = await response.Content.ReadAsStringAsync();
                    JObject guard = JObject.Parse(json);

                    string mobileNo = guard["mobileNo"]?.ToString();
                    string emailId = guard["emailId"]?.ToString();
                    string forestId = guard["forestGuardId"]?.ToString();

                    txtMobileNumber.Text = mobileNo ?? string.Empty;
                    txtEmail.Text = emailId ?? string.Empty;
                    hdidforest.Value = forestId ?? string.Empty;
                }
                else
                {
                    txtMobileNumber.Text = "Error loading data";
                    txtEmail.Text = "Error loading data";
                }
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
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Please save the new guard first.');", true);
                            return;
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Please select a valid forest guard.');", true);
                        return;
                    }
                }

                string roUserId = Session["UserId"].ToString();
                if (string.IsNullOrEmpty(roUserId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('User ID not found in session.');", true);
                    return;
                }

                string priority = ddlPriority.SelectedValue;
                if (string.IsNullOrEmpty(priority))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Please select a priority.');", true);
                    return;
                }

                string incidentId = Session["incidentId"].ToString();
                if (string.IsNullOrEmpty(incidentId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Incident ID is required.');", true);
                    return;
                }

                var formData = new MultipartFormDataContent();
                formData.Add(new StringContent("0"), "Sno");
                formData.Add(new StringContent(""), "InvestigationId");
                formData.Add(new StringContent(incidentId), "IncidentId");
                formData.Add(new StringContent(forestGuardId), "ForestGuardId");
                formData.Add(new StringContent(roUserId), "RoUserId");
                formData.Add(new StringContent(priority), "Priority");

                string apiUrl = _apiUrl + "TblIncidentInvestigationByForestGuards/PostTblIncidentInvestigationByForestGuards";
                HttpResponseMessage response = await client.PostAsync(apiUrl, formData);

                if (response.IsSuccessStatusCode)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Assignment submitted successfully.');", true);
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
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", $"alert('Error submitting assignment: API returned {response.StatusCode}. Details: {errorDetails}');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", $"alert('Exception: {ex.Message}');", true);
            }
        }

        protected async void btnAsign_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddlForestGuard.SelectedValue != "0")
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Please select \"Add New Guard\" to add and assign a new guard.');", true);
                    return;
                }

                string name = txtNewGuardName.Text;
                if (string.IsNullOrEmpty(name))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Please enter a guard name.');", true);
                    return;
                }

                string mobileNo = txtMobileNumber.Text;
                if (string.IsNullOrEmpty(mobileNo))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Please enter a mobile number.');", true);
                    return;
                }

                string emailId = txtEmail.Text;
                if (string.IsNullOrEmpty(emailId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Please enter an email address.');", true);
                    return;
                }



                string roUserId = Session["UserId"].ToString();
                if (string.IsNullOrEmpty(roUserId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('User ID not found in session.');", true);
                    return;
                }

                string priority = ddlPriority.SelectedValue;
                if (string.IsNullOrEmpty(priority))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Please select a priority.');", true);
                    return;
                }

                string incidentId = Session["incidentId"].ToString();
                if (string.IsNullOrEmpty(incidentId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Incident ID is required.');", true);
                    return;
                }

                var guardFormData = new MultipartFormDataContent();
                guardFormData.Add(new StringContent("0"), "Sno");
                guardFormData.Add(new StringContent(""), "ForestGuardId");
                guardFormData.Add(new StringContent(name), "Name");
                guardFormData.Add(new StringContent(mobileNo), "MobileNo");
                guardFormData.Add(new StringContent(emailId), "EmailId");
                guardFormData.Add(new StringContent(roUserId), "RoUserId");

                string createGuardUrl = _apiUrl + "TblForestGuardMasters/PostTblForestGuardMasters";
                HttpResponseMessage createResponse = await client.PostAsync(createGuardUrl, guardFormData);

                if (!createResponse.IsSuccessStatusCode)
                {
                    string errorDetails = await createResponse.Content.ReadAsStringAsync();
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", $"alert('Error creating guard: API returned {createResponse.StatusCode}. Details: {errorDetails}');", true);
                    return;
                }

                string createJson = await createResponse.Content.ReadAsStringAsync();
                JObject createResult = JObject.Parse(createJson);
                string forestGuardId = createResult["forestGuardId"]?.ToString();
                if (string.IsNullOrEmpty(forestGuardId))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('Error: Forest Guard ID not returned by API.');", true);
                    return;
                }

                var assignFormData = new MultipartFormDataContent();
                assignFormData.Add(new StringContent("0"), "Sno");
                assignFormData.Add(new StringContent(""), "InvestigationId");
                assignFormData.Add(new StringContent(incidentId), "IncidentId");
                assignFormData.Add(new StringContent(forestGuardId), "ForestGuardId");
                assignFormData.Add(new StringContent(roUserId), "RoUserId");
                assignFormData.Add(new StringContent(priority), "Priority");

                string assignUrl = _apiUrl + "TblIncidentInvestigationByForestGuards/PostTblIncidentInvestigationByForestGuards";
                HttpResponseMessage assignResponse = await client.PostAsync(assignUrl, assignFormData);

                if (assignResponse.IsSuccessStatusCode)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('New guard created and assigned successfully.');", true);
                    ddlForestGuard.SelectedValue = "";
                    txtNewGuardName.Text = string.Empty;
                    txtMobileNumber.Text = string.Empty;
                    txtEmail.Text = string.Empty;
                    hdidforest.Value = string.Empty;
                    ddlPriority.SelectedValue = "";

                    await BindForestGuardsAsync();
                }
                else
                {
                    string errorDetails = await assignResponse.Content.ReadAsStringAsync();
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", $"alert('Error assigning guard: API returned {assignResponse.StatusCode}. Details: {errorDetails}');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", $"alert('Exception: {ex.Message}');", true);
            }
        }
    }
}