using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class add_Incident : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsPostBack)
                {
                    
                }
            }
            catch (Exception ex)
            {

                Console.WriteLine("An error occurred: " + ex.Message);
            }
        }

        private void ClearControls()
        {
            foreach (Control control in this.Page.Controls)
            {
                ClearControl(control);
            }
        }

        private void ClearControl(Control control)
        {
            if (control is TextBox)
            {
                ((TextBox)control).Text = string.Empty;
            }
            else if (control is DropDownList)
            {
                ((DropDownList)control).SelectedIndex = 0;
            }
            else if (control is CheckBox)
            {
                ((CheckBox)control).Checked = false;
            }
            else if (control.HasControls())
            {
                foreach (Control childControl in control.Controls)
                {
                    ClearControl(childControl);
                }
            }
        }


        public string add_incident(string applicantId, DateTime date, string animal_type, string human_loss, string victim_name, string gender, Int32 victim_age, DateTime incident_time, string victim_activity, string place, string latitude, string longitude, string incident_summary, string created_by)
        {
            try
            {
                var data = new
                {
                    ApplicantId = applicantId,
                    //DateOfIncident = date,
                    DateOfIncident = date.ToString("yyyy-MM-dd"),
                    AnimalType = animal_type,
                    HumanLoss = human_loss,
                    VictimName = victim_name,
                    VictimGender = gender,
                    VictimAge = victim_age,
                    //IncidentTime = incident_time,
                    IncidentTime = incident_time.ToString("hh:mm tt"),
                    PersonActivity = victim_activity,
                    IncidentPlace = place,
                    //Lat = latitude,
                    //Long = longitude,
                    Lat = Convert.ToDecimal(latitude),
                    Long = Convert.ToDecimal(longitude),
                    Remarks = incident_summary,
                    CreatedBy = created_by
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                //client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblTicketHeaders/PostTblTicketHeader";

                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                   // grid_name_user();

                }
                string result = response.Content.ReadAsStringAsync().Result;
                return result;
            }
            catch (Exception ex)
            {
                return "Not Found";
            }
        }

        protected void btn_add_incident_Click(object sender, EventArgs e)
        {
            try
            {
                //DateTime dateOfIncident;
                //DateTime timeOfIncident;
                //DateTime dateTimeOfIncident;

                //bool isDateValid = DateTime.TryParse(txtDateOfIncident.Text.Trim(), out dateOfIncident);
                //bool isTimeValid = DateTime.TryParseExact(
                //    txtTimeOfIncident.Text.Trim(),
                //    new[] { "h:mm tt", "hh:mm tt" },
                //    CultureInfo.InvariantCulture,
                //    DateTimeStyles.None,
                //    out timeOfIncident
                //);

                //if (isDateValid && isTimeValid)
                //{
                //    // Combine date and time
                //    dateTimeOfIncident = dateOfIncident.Date.Add(timeOfIncident.TimeOfDay);
                string Applicant_id = "APPL-0001";
                    string result = add_incident(Applicant_id, Convert.ToDateTime(txtDateOfIncident.Text), txtAnimal.Text, rblHumanLoss.SelectedValue, txtVictimName.Text, rblGender.SelectedValue, Convert.ToInt32(txtAge.Text), Convert.ToDateTime(txtTimeOfIncident.Text), txtActivity.Text, txtPlace.Text, txtLatitude.Text, txtLongitude.Text, txtSummary.Text, Session["RoleId"]?.ToString());
                    var resultObj = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(result);
                    string message = resultObj.message;

                    if (!string.IsNullOrEmpty(message))
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{message}');", true);

                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Failed to add Incident report. Please try again.');", true);
                    }
                    ClearControls();
                    // grid_name_roles();

                
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error during incident report addition: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('An unexpected error occurred. Please try again.');", true);
            }
        }
    }
}