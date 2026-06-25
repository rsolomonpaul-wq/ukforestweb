using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace uk_forest.Forest
{
    public partial class BeneficiaryCheckByAcount : System.Web.UI.Page
    {
        HttpClient client = new HttpClient();
        string _apiUrl = ConfigurationSettings.AppSettings["api_path"];
      

        protected async void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Retrieve applicant_id from session
                string applicantId = "APP0001"; // Session["ApplicantId"]?.ToString();
                if (string.IsNullOrEmpty(applicantId))
                {
                    return;
                }

                // Fetch and bind data
                await FetchAndBindBeneficiaryDetails(applicantId);
            }
        }

        private async Task FetchAndBindBeneficiaryDetails(string applicantId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    // Set the base address of your API (update with your actual API URL)
                    client.BaseAddress = new Uri(_apiUrl);
                    string endpoint = $"{_apiUrl}TblBeneficiaryMasters/GetTblApplicantBeneficiaryDetail_byApplicantId?applicant_id={applicantId}";

                    // Make the GET request
                    HttpResponseMessage response = await client.GetAsync(endpoint);

                    if (response.IsSuccessStatusCode)
                    {
                        // Read and deserialize the response
                        string jsonResponse = await response.Content.ReadAsStringAsync();
                        var beneficiaryDetails = JsonConvert.DeserializeObject<List<TblBeneficiaryMaster>>(jsonResponse);

                        if (beneficiaryDetails != null && beneficiaryDetails.Count > 0)
                        {
                            // Take the first record (modify if multiple records are expected)
                            var data = beneficiaryDetails[0];

                            // Bind data to textboxes and set them to read-only
                            txtFullName.Text = data.AccHolderName;
                            txtFullName.ReadOnly = true;

                            txtAccountNumber.Text = data.AccNumber;
                            txtAccountNumber.ReadOnly = true;

                            txtBankName.Text = data.BankName;
                            txtBankName.ReadOnly = true;

                            txtIFSC.Text = data.IfscCode;
                            txtIFSC.ReadOnly = true;

                            txtPanNumber.Text = data.PanNo;
                            txtPanNumber.ReadOnly = true;

                            txtAadhar.Text = data.AadharNo;
                            txtAadhar.ReadOnly = true;

                            hfId.Value = data.Id.ToString();
                            hfBeneficiaryId.Value = data.BeneficiaryId;

                            // Handle file preview (if applicable)
                            if (!string.IsNullOrEmpty(data.BankDoc))
                            {
                                btnPreview.Text = "View Document";
                                btnPreview.Attributes["href"] = data.BankDoc; // Set the URL for the document
                                btnPreview.Style["display"] = "inline"; // Show the preview link
                            }

                            // Optionally disable the submit button
                            btn_submit_beneficiary_details.Enabled = false;
                            // Optionally hide the file upload control
                            filebeneficiary.Visible = false;
                        }
                        else
                        {
                           
                        }
                    }
                    else if (response.StatusCode == System.Net.HttpStatusCode.Created) // 201
                    {
                      
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

    // Model class for deserialization (same as provided)
    public partial class TblBeneficiaryMaster
    {
        public int Id { get; set; }
        public string BeneficiaryId { get; set; }
        public string ApplicantId { get; set; }
        public string BankName { get; set; }
        public string AccNumber { get; set; }
        public string IfscCode { get; set; }
        public string AccHolderName { get; set; }
        public string AadharNo { get; set; }
        public string PanNo { get; set; }
        public string BankDoc { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public bool? IsActive { get; set; }
       
    }



}