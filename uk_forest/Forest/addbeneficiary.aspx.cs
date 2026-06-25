using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace uk_forest.Forest
{
    public partial class addbeneficiary : System.Web.UI.Page
    {
        HttpClient client = new HttpClient();
        string _apiUrl = ConfigurationSettings.AppSettings["api_path"];
        string baseUrl = ConfigurationSettings.AppSettings["BaseUrl"];

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string userId = Session["UserId"] != null ? Session["UserId"].ToString() : null;
                    BindApplicantData(userId);
                    LoadBeneficiaries();
                }
            }
            catch(Exception ex)
            {

            }
        }
        protected string CleanUrl(object value)
        {
            if (value == null)
                return "#";

            string url = value.ToString().Trim();

            // Remove tabs, newlines, carriage returns, and encode spaces
            url = url.Replace("\t", "")
                     .Replace("\n", "")
                     .Replace("\r", "")
                     .Replace(" ", "%20");

            return url;
        }

        //private void LoadBeneficiaries()
        //{
        //    string applicantId = Session["UserId"]?.ToString();
        //    if (string.IsNullOrEmpty(applicantId))
        //    {
        //        return;
        //    }

        //    string apiUrl = _apiUrl + "TblBeneficiaryMasters/GetTblApplicantBeneficiaryDetail_byApplicantId?applicant_id=" + applicantId;
        //    var response = client.GetAsync(apiUrl).Result;
        //    if (response.IsSuccessStatusCode)
        //    {
        //        string json = response.Content.ReadAsStringAsync().Result;

        //        JavaScriptSerializer serializer = new JavaScriptSerializer();
        //        List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

        //        if (json.TrimStart().StartsWith("["))
        //        {
        //            // JSON is an array
        //            list = serializer.Deserialize<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();
        //        }
        //        else
        //        {
        //            // JSON is a single object
        //            Dictionary<string, object> singleItem = serializer.Deserialize<Dictionary<string, object>>(json);
        //            if (singleItem != null)
        //            {
        //                list.Add(singleItem);
        //            }
        //        }

        //        GridView1.DataSource = list;
        //        GridView1.DataBind();
        //    }

        //}






        //protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        //{
        //    string beneficiaryId = e.CommandArgument.ToString();
        //    if (e.CommandName == "EditBeneficiary")
        //    {
        //        string applicantId = Session["UserId"]?.ToString();
        //        if (string.IsNullOrEmpty(applicantId)) return;

        //        string apiUrl = _apiUrl + "TblBeneficiaryMasters/GetTblApplicantBeneficiaryDetail_byApplicantId?applicant_id=" + applicantId;
        //        var response = client.GetAsync(apiUrl).Result;
        //        if (response.IsSuccessStatusCode)
        //        {
        //            string json = response.Content.ReadAsStringAsync().Result;
        //            JavaScriptSerializer serializer = new JavaScriptSerializer();
        //            List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

        //            // Check if JSON is an array or a single object
        //            if (json.TrimStart().StartsWith("["))
        //            {
        //                // JSON is an array
        //                list = serializer.Deserialize<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();
        //            }
        //            else
        //            {
        //                // JSON is a single object
        //                Dictionary<string, object> singleItem = serializer.Deserialize<Dictionary<string, object>>(json);
        //                if (singleItem != null)
        //                {
        //                    list.Add(singleItem);
        //                }
        //            }

        //            var benDict = list.FirstOrDefault(b => b["beneficiaryId"].ToString() == beneficiaryId);
        //            if (benDict != null)
        //            {
        //                txtFullName.Text = benDict.ContainsKey("accHolderName") ? benDict["accHolderName"]?.ToString() ?? "" : "";
        //                txtAccountNumber.Text = benDict.ContainsKey("accNumber") ? benDict["accNumber"]?.ToString() ?? "" : "";
        //                txtBankName.Text = benDict.ContainsKey("bankName") ? benDict["bankName"]?.ToString() ?? "" : "";
        //                txtIFSC.Text = benDict.ContainsKey("ifscCode") ? benDict["ifscCode"]?.ToString() ?? "" : "";
        //                txtPanNumber.Text = benDict.ContainsKey("panNo") ? benDict["panNo"]?.ToString() ?? "" : "";
        //                txtAadhar.Text = benDict.ContainsKey("aadharNo") ? benDict["aadharNo"]?.ToString() ?? "" : "";
        //                hfId.Value = benDict.ContainsKey("id") ? benDict["id"]?.ToString() ?? "" : "";
        //                hfBeneficiaryId.Value = benDict["beneficiaryId"]?.ToString() ?? "";
        //                btn_submit_beneficiary_details.Text = "Update";
        //            }
        //            else
        //            {
        //                ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('Beneficiary not found.');", true);
        //            }
        //        }
        //        else
        //        {
        //            string errorResult = response.Content.ReadAsStringAsync().Result;
        //            ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('Failed to fetch beneficiary details: " + errorResult.Replace("'", "\\'") + "');", true);
        //        }
        //    }
        //    else if (e.CommandName == "Delete")
        //    {
        //        // Delete logic remains unchanged
        //        string deleteUrl = _apiUrl + "TblBeneficiaryMasters/DeleteTblBeneficiaryMaster/" + beneficiaryId;
        //        var response = client.DeleteAsync(deleteUrl).Result;
        //        if (response.IsSuccessStatusCode)
        //        {
        //            LoadBeneficiaries();
        //            ClientScript.RegisterStartupScript(this.GetType(), "success", "alert('Beneficiary deleted successfully!');", true);
        //        }
        //        else
        //        {
        //            string errorResult = response.Content.ReadAsStringAsync().Result;
        //            ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('Delete failed: " + errorResult.Replace("'", "\\'") + "');", true);
        //        }
        //    }
        //}

        //// Edit ke liye RowCommand (sirf EditBeneficiary handle karega, Delete hataya)
        //protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        //{
        //    if (e.CommandName == "EditBeneficiary")
        //    {
        //        string beneficiaryId = e.CommandArgument.ToString();
        //        string applicantId = Session["UserId"]?.ToString();
        //        if (string.IsNullOrEmpty(applicantId))
        //        {
        //            ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('Session expired. Please login again.');", true);
        //            return;
        //        }

        //        string apiUrl = _apiUrl + "TblBeneficiaryMasters/GetTblApplicantBeneficiaryDetail_byApplicantId?applicant_id=" + applicantId;
        //        var response = client.GetAsync(apiUrl).Result;
        //        if (response.IsSuccessStatusCode)
        //        {
        //            string json = response.Content.ReadAsStringAsync().Result;
        //            JavaScriptSerializer serializer = new JavaScriptSerializer();
        //            List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

        //            if (json.TrimStart().StartsWith("["))
        //            {
        //                list = serializer.Deserialize<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();
        //            }
        //            else
        //            {
        //                Dictionary<string, object> singleItem = serializer.Deserialize<Dictionary<string, object>>(json);
        //                if (singleItem != null)
        //                {
        //                    list.Add(singleItem);
        //                }
        //            }

        //            var benDict = list.FirstOrDefault(b => b["beneficiaryId"].ToString() == beneficiaryId);
        //            if (benDict != null)
        //            {
        //                txtFullName.Text = benDict.ContainsKey("accHolderName") ? benDict["accHolderName"]?.ToString() ?? "" : "";
        //                txtAccountNumber.Text = benDict.ContainsKey("accNumber") ? benDict["accNumber"]?.ToString() ?? "" : "";
        //                txtBankName.Text = benDict.ContainsKey("bankName") ? benDict["bankName"]?.ToString() ?? "" : "";
        //                txtIFSC.Text = benDict.ContainsKey("ifscCode") ? benDict["ifscCode"]?.ToString() ?? "" : "";
        //                txtPanNumber.Text = benDict.ContainsKey("panNo") ? benDict["panNo"]?.ToString() ?? "" : "";
        //                txtAadhar.Text = benDict.ContainsKey("aadharNo") ? benDict["aadharNo"]?.ToString() ?? "" : "";
        //                hfId.Value = benDict.ContainsKey("id") ? benDict["id"]?.ToString() ?? "" : "";
        //                hfBeneficiaryId.Value = benDict["beneficiaryId"]?.ToString() ?? "";
        //                btn_submit_beneficiary_details.Text = "Update";
        //            }
        //            else
        //            {
        //                ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('Beneficiary not found.');", true);
        //            }
        //        }
        //        else
        //        {
        //            string errorResult = response.Content.ReadAsStringAsync().Result;
        //            ClientScript.RegisterStartupScript(this.GetType(), "error", $"alert('Failed to fetch beneficiary details: {errorResult.Replace("'", "\\\\'")}');", true);
        //        }
        //    }
        //    // Delete ka logic yahan nahi, RowDeleting mein shift kiya
        //}

        //// Delete ke liye alag RowDeleting handler (yeh error fix karega)
        //protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        //{
        //    try
        //    {
        //        string beneficiaryId = GridView1.DataKeys[e.RowIndex].Value.ToString(); // DataKeyNames se fetch

        //        string deleteUrl = _apiUrl + "TblBeneficiaryMasters/" + beneficiaryId;
        //        var response = client.DeleteAsync(deleteUrl).Result;
        //        if (response.IsSuccessStatusCode)
        //        {
        //            LoadBeneficiaries(); // Grid refresh
        //            ClientScript.RegisterStartupScript(this.GetType(), "success", "alert('Beneficiary deleted successfully!');", true);
        //        }
        //        else
        //        {
        //            string errorResult = response.Content.ReadAsStringAsync().Result;
        //            ClientScript.RegisterStartupScript(this.GetType(), "error", $"alert('Delete failed: {errorResult.Replace("'", "\\\\'")}');", true);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ClientScript.RegisterStartupScript(this.GetType(), "error", $"alert('Delete error: {ex.Message.Replace("'", "\\\\'")}');", true);
        //    }

        //    e.Cancel = true; // Default delete ko cancel karo, API handle ho gaya
        //}


        // LoadBeneficiaries remains the same - it deserializes to camelCase keys as per JSON
        private void LoadBeneficiaries()
        {
            string applicantId = Session["UserId"]?.ToString();
            if (string.IsNullOrEmpty(applicantId))
            {
                return;
            }

            string apiUrl = _apiUrl + "TblBeneficiaryMasters/GetTblApplicantBeneficiaryDetail_byApplicantId?applicant_id=" + applicantId;
            var response = client.GetAsync(apiUrl).Result;
            if (response.IsSuccessStatusCode)
            {
                string json = response.Content.ReadAsStringAsync().Result;

                JavaScriptSerializer serializer = new JavaScriptSerializer();
                List<Dictionary<string, object>> dictList = new List<Dictionary<string, object>>();

                if (json.TrimStart().StartsWith("["))
                {
                    // JSON is an array
                    dictList = serializer.Deserialize<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();
                }
                else
                {
                    // JSON is a single object
                    Dictionary<string, object> singleItem = serializer.Deserialize<Dictionary<string, object>>(json);
                    if (singleItem != null)
                    {
                        dictList.Add(singleItem);
                    }
                }

                // Project to anonymous types with properties for proper DataBinding
                var dataSource = dictList.Select(d => new
                {
                    beneficiaryId = d.ContainsKey("beneficiaryId") ? d["beneficiaryId"]?.ToString() : "",
                    bankName = d.ContainsKey("bankName") ? d["bankName"]?.ToString() : "",
                    accNumber = d.ContainsKey("accNumber") ? d["accNumber"]?.ToString() : "",
                    ifscCode = d.ContainsKey("ifscCode") ? d["ifscCode"]?.ToString() : "",
                    accHolderName = d.ContainsKey("accHolderName") ? d["accHolderName"]?.ToString() : "",
                    aadharNo = d.ContainsKey("aadharNo") ? d["aadharNo"]?.ToString() : "",
                    panNo = d.ContainsKey("panNo") ? d["panNo"]?.ToString() : "",

                    BeneficiaryImage = d.ContainsKey("bankDoc") && !string.IsNullOrEmpty(d["bankDoc"]?.ToString())
          ? $"{baseUrl.TrimEnd('/')}/{d["bankDoc"].ToString().Replace("\\", "/").TrimStart('/')}"
          : "",

                    id = d.ContainsKey("id") ? d["id"]?.ToString() : ""
                }).ToList();


                GridView1.DataSource = dataSource;
                GridView1.DataBind();
            }
        }// RowCommand and RowDeleting as before, with camelCase keys
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditBeneficiary")
            {
                string beneficiaryId = e.CommandArgument.ToString();
                string applicantId = Session["UserId"]?.ToString();
                if (string.IsNullOrEmpty(applicantId))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('Session expired. Please login again.');", true);
                    return;
                }

                string apiUrl = _apiUrl + "TblBeneficiaryMasters/GetTblApplicantBeneficiaryDetail_byApplicantId?applicant_id=" + applicantId;
                var response = client.GetAsync(apiUrl).Result;
                if (response.IsSuccessStatusCode)
                {
                    string json = response.Content.ReadAsStringAsync().Result;
                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

                    if (json.TrimStart().StartsWith("["))
                    {
                        list = serializer.Deserialize<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();
                    }
                    else
                    {
                        Dictionary<string, object> singleItem = serializer.Deserialize<Dictionary<string, object>>(json);
                        if (singleItem != null)
                        {
                            list.Add(singleItem);
                        }
                    }

                    var benDict = list.FirstOrDefault(b => b["beneficiaryId"].ToString() == beneficiaryId);
                    if (benDict != null)
                    {
                        txtFullName.Text = benDict.ContainsKey("accHolderName") ? benDict["accHolderName"]?.ToString() ?? "" : "";
                        txtAccountNumber.Text = benDict.ContainsKey("accNumber") ? benDict["accNumber"]?.ToString() ?? "" : "";
                        //txtBankName.Text = benDict.ContainsKey("bankName") ? benDict["bankName"]?.ToString() ?? "" : "";
                        ddlBanks.SelectedValue = benDict.ContainsKey("bankName") ? benDict["bankName"]?.ToString() ?? "" : "";
                        txtIFSC.Text = benDict.ContainsKey("ifscCode") ? benDict["ifscCode"]?.ToString() ?? "" : "";
                        txtPanNumber.Text = benDict.ContainsKey("panNo") ? benDict["panNo"]?.ToString() ?? "" : "";
                        txtAadhar.Text = benDict.ContainsKey("aadharNo") ? benDict["aadharNo"]?.ToString() ?? "" : "";
                        hfId.Value = benDict.ContainsKey("id") ? benDict["id"]?.ToString() ?? "" : "";
                        hfBeneficiaryId.Value = benDict["beneficiaryId"]?.ToString() ?? "";
                        btn_submit_beneficiary_details.Text = "Update";
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('Beneficiary not found.');", true);
                    }
                }
                else
                {
                    string errorResult = response.Content.ReadAsStringAsync().Result;
                    ClientScript.RegisterStartupScript(this.GetType(), "error", $"alert('Failed to fetch beneficiary details: {errorResult.Replace("'", "\\\\'")}');", true);
                }
            }
        }

        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                string beneficiaryId = GridView1.DataKeys[e.RowIndex].Value.ToString();

                string deleteUrl = _apiUrl + "TblBeneficiaryMasters/DeleteTblBeneficiaryMaster/" + beneficiaryId;
                var response = client.DeleteAsync(deleteUrl).Result;
                if (response.IsSuccessStatusCode)
                {
                    LoadBeneficiaries();
                    ClientScript.RegisterStartupScript(this.GetType(), "success", "alert('Beneficiary deleted successfully!');", true);
                }
                else
                {
                    string errorResult = response.Content.ReadAsStringAsync().Result;
                    ClientScript.RegisterStartupScript(this.GetType(), "error", $"alert('Delete failed: {errorResult.Replace("'", "\\\\'")}');", true);
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "error", $"alert('Delete error: {ex.Message.Replace("'", "\\\\'")}');", true);
            }

            e.Cancel = true;
        }

        private void ClearForm()
        {
            txtFullName.Text = "";
            txtAccountNumber.Text = "";
            //txtBankName.Text = "";
            ddlBanks.SelectedValue = "0";
            txtIFSC.Text = "";
            txtPanNumber.Text = "";
            txtAadhar.Text = "";
            hfId.Value = "";
            hfBeneficiaryId.Value = "";
            btn_submit_beneficiary_details.Text = "Submit";
        }

        //protected void btn_submit_beneficiary_details_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        // Session से ApplicantId और Name लो
        //        string applicantId = Session["UserId"]?.ToString();
        //        string createdBy = Session["Name"]?.ToString();

        //        if (string.IsNullOrEmpty(applicantId))
        //        {
        //            string script = @"
        //Swal.fire({
        //    title: 'Session Expired',
        //    text: 'Please login again.',
        //    icon: 'warning',
        //    confirmButtonText: 'OK'
        //});";

        //            ClientScript.RegisterStartupScript(this.GetType(), "sessionError", script, true);
        //            return;
        //        }


        //        using (var content = new MultipartFormDataContent())
        //        {
        //            // id from hidden
        //            int id = string.IsNullOrEmpty(hfId.Value) ? 0 : int.Parse(hfId.Value);
        //            content.Add(new StringContent(id.ToString()), "Id");

        //            // beneficiaryId
        //            string beneficiaryId = hfBeneficiaryId.Value;
        //            if (string.IsNullOrEmpty(beneficiaryId))
        //            {
        //                beneficiaryId = Guid.NewGuid().ToString(); // API will override for inserts
        //            }
        //            content.Add(new StringContent(beneficiaryId), "BeneficiaryId");

        //            content.Add(new StringContent(applicantId), "ApplicantId");
        //            content.Add(new StringContent(createdBy ?? ""), "CreatedBy");
        //            content.Add(new StringContent(createdBy ?? ""), "UpdatedBy"); // Set UpdatedBy for updates
        //            content.Add(new StringContent(txtBankName.Text.Trim()), "BankName");
        //            content.Add(new StringContent(txtAccountNumber.Text.Trim()), "AccNumber");
        //            content.Add(new StringContent(txtIFSC.Text.Trim()), "IfscCode");
        //            content.Add(new StringContent(txtFullName.Text.Trim()), "AccHolderName");
        //            content.Add(new StringContent(txtAadhar.Text.Trim()), "AadharNo");
        //            content.Add(new StringContent(txtPanNumber.Text.Trim()), "PanNo");
        //            content.Add(new StringContent("true"), "IsActive"); // Set IsActive to true

        //            // File add karo agar upload hua ho
        //            if (filebeneficiary.HasFile)
        //            {
        //                var fileStream = filebeneficiary.PostedFile.InputStream;
        //                fileStream.Position = 0;
        //                var fileContent = new StreamContent(fileStream);
        //                fileContent.Headers.ContentType = new MediaTypeHeaderValue(filebeneficiary.PostedFile.ContentType);
        //                content.Add(fileContent, "BankDoc", filebeneficiary.PostedFile.FileName);
        //            }
        //            else
        //            {
        //                content.Add(new StringContent(""), "BankDoc");
        //            }

        //            // API Call
        //            using (var httpClient = new HttpClient())
        //            {
        //                string apiUrl = _apiUrl + "TblBeneficiaryMasters/AddUpdateBeneficiaryMaster";
        //                var response = httpClient.PostAsync(apiUrl, content).Result;

        //                if (response.IsSuccessStatusCode)
        //                {
        //                    string successMessage = id > 0 ? "updated" : "submitted";
        //                    string script = $@"
        //Swal.fire({{
        //    title: 'Success',
        //    text: 'Beneficiary details {successMessage} successfully!',
        //    icon: 'success',
        //    confirmButtonText: 'OK'
        //}});";

        //                    ClientScript.RegisterStartupScript(this.GetType(), "success", script, true);

        //                    ClearForm();
        //                    LoadBeneficiaries();
        //                }
        //                else
        //                {
        //                    string errorResult = response.Content.ReadAsStringAsync().Result.Replace("'", "\\'");
        //                    string script = $@"
        //Swal.fire({{
        //    title: 'Error',
        //    text: 'Failed: {errorResult}',
        //    icon: 'error',
        //    confirmButtonText: 'OK'
        //}});";

        //                    ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
        //                }

        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ClientScript.RegisterStartupScript(this.GetType(), "error",
        //            $"alert('Error: {ex.Message.Replace("'", "\\'")}');", true);
        //    }
        //}


        protected void btn_submit_beneficiary_details_Click(object sender, EventArgs e)
        {
            try
            {
                // Session से ApplicantId और Name लो
                string applicantId = Session["UserId"]?.ToString();
                string createdBy = Session["Name"]?.ToString();

                if (string.IsNullOrEmpty(applicantId))
                {
                    string script = @"
Swal.fire({
    title: 'Session Expired',
    text: 'Please login again.',
    icon: 'warning',
    confirmButtonText: 'OK'
});";

                    ClientScript.RegisterStartupScript(this.GetType(), "sessionError", script, true);
                    return;
                }

                using (var content = new MultipartFormDataContent())
                {
                    // id from hidden
                    int id = string.IsNullOrEmpty(hfId.Value) ? 0 : int.Parse(hfId.Value);
                    content.Add(new StringContent(id.ToString()), "Id");

                    // beneficiaryId
                    string beneficiaryId = hfBeneficiaryId.Value;
                    if (string.IsNullOrEmpty(beneficiaryId))
                    {
                        beneficiaryId = Guid.NewGuid().ToString(); // API will override for inserts
                    }
                    content.Add(new StringContent(beneficiaryId), "BeneficiaryId");

                    content.Add(new StringContent(applicantId), "ApplicantId");
                    content.Add(new StringContent(createdBy ?? ""), "CreatedBy");
                    content.Add(new StringContent(createdBy ?? ""), "UpdatedBy");
                    //content.Add(new StringContent(txtBankName.Text.Trim()), "BankName");
                    content.Add(new StringContent(ddlBanks.SelectedValue.Trim()), "BankName");
                    content.Add(new StringContent(txtAccountNumber.Text.Trim()), "AccNumber");
                    content.Add(new StringContent(txtIFSC.Text.Trim()), "IfscCode");
                    content.Add(new StringContent(txtFullName.Text.Trim()), "AccHolderName");
                    content.Add(new StringContent(txtAadhar.Text.Trim()), "AadharNo");
                    content.Add(new StringContent(txtPanNumber.Text.Trim()), "PanNo");
                    content.Add(new StringContent("true"), "IsActive");

                    // File add karo agar upload hua ho
                    if (filebeneficiary.HasFile)
                    {
                        var fileStream = filebeneficiary.PostedFile.InputStream;
                        fileStream.Position = 0;
                        var fileContent = new StreamContent(fileStream);
                        fileContent.Headers.ContentType = new MediaTypeHeaderValue(filebeneficiary.PostedFile.ContentType);
                        content.Add(fileContent, "BankDoc", filebeneficiary.PostedFile.FileName);
                    }
                    else
                    {
                        content.Add(new StringContent(""), "BankDoc");
                    }

                    // API Call
                    using (var httpClient = new HttpClient())
                    {
                        string apiUrl = _apiUrl + "TblBeneficiaryMasters/AddUpdateBeneficiaryMaster";
                        var response = httpClient.PostAsync(apiUrl, content).Result;

                        if (response.IsSuccessStatusCode)
                        {
                            string successMessage = id > 0 ? "updated" : "submitted";

                            string script = $@"
Swal.fire({{
    title: 'Success',
    text: 'Beneficiary details {successMessage} successfully!',
    icon: 'success',
    confirmButtonText: 'OK'
}}).then((result) => {{
    if (result.isConfirmed) {{
        window.location.href = 'victimincident.aspx'; // ✅ Redirect on OK
    }}
}});";

                            ClientScript.RegisterStartupScript(this.GetType(), "success", script, true);

                            ClearForm();
                            LoadBeneficiaries();
                        }
                        else
                        {
                            string errorResult = response.Content.ReadAsStringAsync().Result.Replace("'", "\\'");
                            string script = $@"
Swal.fire({{
    title: 'Error',
    text: 'Failed: {errorResult}',
    icon: 'error',
    confirmButtonText: 'OK'
}});";

                            ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "error",
                    $"alert('Error: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }



        private AadharDetails BindApplicantData(string applicantId)
        {
            string baseUrl = _apiUrl + "TblApplicantMasters/GetTblApplicant_byApplicantId";
            string apiUrl = $"{baseUrl}?applicant_id={applicantId}";
            //string imageBaseUrl = "http://203.122.5.18:9008/uk_forest_web/";

            string imageBaseUrl = "https://ukforestgis.in/";

            

            using (HttpClient client = new HttpClient())
            {
                try
                {
                    HttpResponseMessage response = client.GetAsync(apiUrl).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string jsonResponse = response.Content.ReadAsStringAsync().Result;
                        JObject applicant = JObject.Parse(jsonResponse);

                        if (applicant != null)
                        {
                            string aadharNo = applicant["aadharNo"]?.ToString() ?? "N/A";

                            string aadharDocFile = applicant["aadharDoc"]?.ToString() ?? "";
                            string aadharUrl = string.IsNullOrEmpty(aadharDocFile)
                                ? ""
                                : imageBaseUrl + Uri.EscapeUriString(aadharDocFile);

                            // ✔ Return object
                            return new AadharDetails
                            {
                                AadharNo = aadharNo,
                                AadharUrl = aadharUrl
                            };
                        }
                    }
                }
                catch (Exception ex)
                {
                }
            }

            return null;
        }


        public class AadharDetails
        {
            public string AadharNo { get; set; }
            public string AadharUrl { get; set; }
        }


        protected void chkaadhar_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                if (chkaadhar.Checked)
                {
                    string userId = Session["UserId"]?.ToString();

                    AadharDetails data = BindApplicantData(userId);

                    if (data != null)
                    {
                        btnPreview.Visible = false;
                        lblAadharFile.Visible = false;
                        filebeneficiary.Visible = false;
                        LinkButton1.Visible = true;



                        txtAadhar.Text = data.AadharNo;

                        txtAadhar.Enabled = false;

                        LinkButton1.Style.Add("display", "inline-block");
                        LinkButton1.OnClientClick = $"window.open('{data.AadharUrl}', '_blank'); return false;";
                    }
                }
                else
                {
                    txtAadhar.Enabled = true;
                    txtAadhar.Text = "";
                    btnPreview.Visible = true;
                    lblAadharFile.Visible = true;
                    filebeneficiary.Visible = true;
                    LinkButton1.Visible = false;
                }
            }
            catch (Exception ex)
            {

            }
        }


    }
}