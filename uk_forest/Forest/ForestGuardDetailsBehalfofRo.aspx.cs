using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace uk_forest.Forest
{
    public partial class ForestGuardDetailsBehalfofRo : System.Web.UI.Page
    {
        private readonly HttpClient client = new HttpClient();
        private readonly string apiUrl = ConfigurationSettings.AppSettings["api_path"];

        protected async void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set RO ID from session
                string roId = Session["UserId"]?.ToString();
                if (!string.IsNullOrEmpty(roId))
                {
                    lblRO.Text = $"RO ID: {roId}";
                    await LoadForestGuardDropdown(roId);
                }
                else
                {
                    lblRO.Text = "RO ID: Not Set";
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('RO ID not found in session');", true);
                }

                //// Initialize empty grid with correct structure to show header
                //gvIncidentAssignments.DataSource = new List<IncidentAssignment>();
                //gvIncidentAssignments.DataBind();


                string forestGuardId = ddlForestGuard.SelectedValue;
                if (string.IsNullOrEmpty(forestGuardId))
                {
                    gvIncidentAssignments.DataSource = new List<IncidentAssignment>();
                    gvIncidentAssignments.DataBind();
                    return;
                }

                var response = await client.GetAsync($"{apiUrl}TblForestGuardMasters/Get_TblForestGuardMastersForest_Guard_Id?forest_guard_id={forestGuardId}");
                if (response.IsSuccessStatusCode)
                {
                    var jsonData = await response.Content.ReadAsStringAsync();
                    var incidentAssignments = JsonConvert.DeserializeObject<List<IncidentAssignment>>(jsonData);
                    gvIncidentAssignments.DataSource = incidentAssignments;
                    gvIncidentAssignments.DataBind();
                }
                else
                {
                    gvIncidentAssignments.DataSource = new List<IncidentAssignment>();
                    gvIncidentAssignments.DataBind();
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('Error loading Incident Assignment data');", true);
                }

            }
        }

        private async Task LoadForestGuardDropdown(string roId)
        {
            try
            {
                var response = await client.GetAsync($"{apiUrl}TblForestGuardMasters/Get_TblForestGuardMasters_by_RO?ro_id={roId}");
                if (response.IsSuccessStatusCode)
                {
                    var jsonData = await response.Content.ReadAsStringAsync();
                    var forestGuards = JsonConvert.DeserializeObject<List<ForestGuard>>(jsonData);
                    ddlForestGuard.Items.Clear();
                    ddlForestGuard.Items.Add(new ListItem("Select Forest Guard", "0"));
                    foreach (var guard in forestGuards)
                    {
                        ddlForestGuard.Items.Add(new ListItem(guard.Name, guard.ForestGuardId));
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('Error loading Forest Guard list');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", $"alert('An error occurred: {ex.Message}');", true);
            }
        }

        protected async void ddlForestGuard_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string forestGuardId = ddlForestGuard.SelectedValue;
                if (string.IsNullOrEmpty(forestGuardId))
                {
                    gvIncidentAssignments.DataSource = new List<IncidentAssignment>();
                    gvIncidentAssignments.DataBind();
                    return;
                }

                var response = await client.GetAsync($"{apiUrl}TblForestGuardMasters/Get_TblForestGuardMastersForest_Guard_Id?forest_guard_id={forestGuardId}");
                if (response.IsSuccessStatusCode)
                {
                    var jsonData = await response.Content.ReadAsStringAsync();
                    var incidentAssignments = JsonConvert.DeserializeObject<List<IncidentAssignment>>(jsonData);
                    gvIncidentAssignments.DataSource = incidentAssignments;
                    gvIncidentAssignments.DataBind();
                }
                else
                {
                    gvIncidentAssignments.DataSource = new List<IncidentAssignment>();
                    gvIncidentAssignments.DataBind();
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('Error loading Incident Assignment data');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", $"alert('An error occurred: {ex.Message}');", true);
                gvIncidentAssignments.DataSource = new List<IncidentAssignment>();
                gvIncidentAssignments.DataBind();
            }
        }

        // Class to deserialize forest guard data for dropdown
        private class ForestGuard
        {
            public string ForestGuardId { get; set; }
            public string Name { get; set; }
        }

        // Class to deserialize incident assignment data for GridView
        private class IncidentAssignment
        {
            public int Sno { get; set; }
            public string InvestigationId { get; set; }
            public string IncidentId { get; set; }
            public string ForestGuardId { get; set; }
            public string ForestGuardName { get; set; }
            public string ForestGuardMobile { get; set; }
            public string ForestGuardEmail { get; set; }
            public string RoUserId { get; set; }
            public string RoName { get; set; }
            public string RoMobile { get; set; }
            public string RoEmail { get; set; }
            public string Priority { get; set; }
            public string CreatedBy { get; set; }
            public DateTime? CreatedDate { get; set; }
            public string UpdatedBy { get; set; }
            public DateTime? UpdatedDate { get; set; }
            public bool? IsActive { get; set; }
        }
    }
}