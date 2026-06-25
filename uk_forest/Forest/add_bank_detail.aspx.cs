using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class add_bank_detail : System.Web.UI.Page
    {
        private const string ViewStateKey = "DocumentTable";
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
               
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

      
        public string add_bankDetails(string applicant_id,string holder, string account, string ifsc, string updated_by)
        {
            try
            {
                if (string.IsNullOrEmpty(updated_by))
                {
                    throw new ArgumentNullException(nameof(updated_by), "Updated by cannot be null or empty.");
                }

                var data = new
                {
                    ApplicantId = applicant_id,
                    BankAccHolderName = holder,
                    BankAccNo = account,
                    BankIfscCode = ifsc,
                    UpdatedBy = Session["RoleId"].ToString()
                };

                string applicantId = "APPPL-0001";
                var json = JsonConvert.SerializeObject(data);
                var dataContent = new StringContent(json, Encoding.UTF8, "application/json");
                //client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblApplicantRegistrations/PutTblApplicantRegistration?id={applicantId}";
                var response = client.PostAsync(url, dataContent).Result;

                if (response.IsSuccessStatusCode)
                {
                    string Message = "Bank document Updated Successfully.";
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('{Message}');", true);
                }

                string result = response.Content.ReadAsStringAsync().Result;
                return result;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error updating role: {ex.Message}");
                return "An error occurred while updating the role.";
            }
        }
        //protected void btnBankSubmit_Click(object sender, EventArgs e)
        
        //    ClearControls();
        //    // grid_name_roles();


        //    // 🔄 Save to database
        //    // SaveBankDetails(holder, account, ifsc);

        //    // Hide submit button after save
        //    btnBankSubmit.Visible = false;
        //}


        protected void btnBankSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string id = "APPL-0001";
                add_bankDetails(id, txtAccountHolder.Text.Trim(), txtAccountNo.Text.Trim(), txtIFSC.Text.Trim(), Session["UserId"]?.ToString());
                btnBankSubmit.Visible = false;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error during bank details update: {ex.Message}");
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script type='text/javascript'>alert('An unexpected error occurred. Please try again later.');</script>");
            }
        }

        protected void btn_reset_Click(object sender, EventArgs e)
        {
            try
            {
                ClearControls();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}