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
    public partial class add_incident_document : System.Web.UI.Page
    {
        private const string ViewStateKey = "DocumentTable";
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CheckBankDetailStatus();
                CreateInitialTable();
            }
        }

        private void CheckBankDetailStatus()
        {
            // Check in database if bank details already saved
            bool bankDetailExists = CheckIfBankDetailExistsFromDB();

            if (bankDetailExists)
            {
                btnBankSubmit.Visible = false; 
            }
            else
            {
                btnBankSubmit.Visible = true;
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

        private bool CheckIfBankDetailExistsFromDB()
        {
            // 🔄 MOCK: Replace with DB query
            // Return true if record exists
            return false; // Assume not yet saved
            //return true; // Assume saved
        }

        private void CreateInitialTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("DocumentType");

            for (int i = 0; i < 3; i++)
                dt.Rows.Add("");

            ViewState[ViewStateKey] = dt;
            BindGrid();
        }

        private void BindGrid()
        {
            gvUpload.DataSource = ViewState[ViewStateKey] as DataTable;
            gvUpload.DataBind();
        }

        protected void lnkAddRow_Click(object sender, EventArgs e)
        {
            DataTable dt = ViewState[ViewStateKey] as DataTable;

            for (int i = 0; i < gvUpload.Rows.Count; i++)
            {
                TextBox txtDocType = gvUpload.Rows[i].FindControl("txtDocType") as TextBox;
                dt.Rows[i]["DocumentType"] = txtDocType.Text;
            }

            dt.Rows.Add("");
            ViewState[ViewStateKey] = dt;
            BindGrid();
        }

        protected void gvUpload_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteRow")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                DataTable dt = ViewState[ViewStateKey] as DataTable;

                for (int i = 0; i < gvUpload.Rows.Count; i++)
                {
                    TextBox txtDocType = gvUpload.Rows[i].FindControl("txtDocType") as TextBox;
                    dt.Rows[i]["DocumentType"] = txtDocType.Text;
                }

                dt.Rows.RemoveAt(index);
                ViewState[ViewStateKey] = dt;
                BindGrid();
            }
        }

        protected void btnUploadSubmit_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < gvUpload.Rows.Count; i++)
            {
                GridViewRow row = gvUpload.Rows[i];
                TextBox txtDocType = row.FindControl("txtDocType") as TextBox;
                FileUpload fuDocument = row.FindControl("fuDocument") as FileUpload;

                string docType = txtDocType.Text;

                if (fuDocument.HasFile)
                {
                    string fileName = System.IO.Path.GetFileName(fuDocument.FileName);
                    string savePath = Server.MapPath("~/Uploads/" + fileName);
                    fuDocument.SaveAs(savePath);

                    // Optionally save to DB
                }
            }

            // Show confirmation
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

       
    }
}