using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class VictimIncidentForm : System.Web.UI.Page
    {
        private const string DOCUMENT_TABLE = "DocTable";
        string apiUrl = ConfigurationManager.AppSettings["api_path"];
        string token_sess;
        HttpClient client = new HttpClient();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    if (Session[DOCUMENT_TABLE] == null)
                    {
                        CreateDocumentTable();
                    }
                    BindGrid();
                    BindDivision();
                    BindAnimal();
                }
            }
            catch (Exception ex)
            {

            }
        }


        void BindAnimal()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("ConflictAnimalMasters/GetConflictAnimalMaster_byConfllictCategory?conflict_category=Human")).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddlAnimalType.Items.Clear();
                        ddlAnimalType.DataSource = dt;
                        ddlAnimalType.DataValueField = "Id";
                        ddlAnimalType.DataTextField = "animalName";
                        ddlAnimalType.DataBind();
                        ddlAnimalType.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0"));
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }


        //private void CreateDocumentTable()
        //{
        //    DataTable dt = new DataTable();
        //    dt.Columns.Add("SNo", typeof(int));
        //    dt.Columns.Add("DocumentType", typeof(string));
        //    dt.Columns.Add("FileName", typeof(string));  // Changed from FileUpload to FileName
        //    dt.Columns.Add("FileContent", typeof(byte[])); // To store actual file bytes

        //    // Add initial single row
        //    dt.Rows.Add(1, "", "", null);
        //    Session[DOCUMENT_TABLE] = dt;
        //}

        private void CreateDocumentTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("SNo", typeof(int));
            dt.Columns.Add("DocumentType", typeof(string));
            dt.Columns.Add("FileName", typeof(string));
            dt.Columns.Add("FileContent", typeof(byte[]));
            dt.Columns.Add("FilePath", typeof(string));  // New column for file path

            dt.Rows.Add(1, "", "", null, "");
            Session[DOCUMENT_TABLE] = dt;
        }

        private void BindGrid()
        {
            DataTable dt = Session[DOCUMENT_TABLE] as DataTable;

            // Clear any existing selections to prevent duplicates
            foreach (DataRow row in dt.Rows)
            {
                if (string.IsNullOrEmpty(row["DocumentType"].ToString()))
                {
                    row["DocumentType"] = "";
                }
            }

            gvDocuments.DataSource = dt;
            gvDocuments.DataBind();
        }

        protected void lnkAddRow_Click(object sender, EventArgs e)
        {
            DataTable dt = Session[DOCUMENT_TABLE] as DataTable;
            SaveDropdownSelections(dt); // This now saves files too
            dt.Rows.Add(dt.Rows.Count + 1, "", "", null);
            BindGrid();
            upDocuments.Update();
        }

        protected void gvDocuments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteRow")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                DataTable dt = Session[DOCUMENT_TABLE] as DataTable;

                if (dt.Rows.Count <= 1)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                        "alert('At least one document row is required.');", true);
                    return;
                }

                SaveDropdownSelections(dt); // This now saves files too
                dt.Rows.RemoveAt(index);

                // Re-number rows
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dt.Rows[i]["SNo"] = i + 1;
                }

                BindGrid();
                upDocuments.Update();
            }
        }

        private void SaveDropdownSelections(DataTable dt)
        {
            for (int i = 0; i < gvDocuments.Rows.Count; i++)
            {
                GridViewRow row = gvDocuments.Rows[i];
                DropDownList ddl = (DropDownList)row.FindControl("ddlDocType");
                FileUpload fu = (FileUpload)row.FindControl("fuDoc");

                if (ddl != null)
                {
                    dt.Rows[i]["DocumentType"] = ddl.SelectedValue;
                }

                if (fu != null && fu.HasFile)
                {
                    // Save file info
                    dt.Rows[i]["FileName"] = fu.FileName;

                    // Save file content to byte array
                    using (Stream fs = fu.PostedFile.InputStream)
                    {
                        byte[] fileBytes = new byte[fs.Length];
                        fs.Read(fileBytes, 0, (int)fs.Length);
                        dt.Rows[i]["FileContent"] = fileBytes;
                    }
                }
            }
        }



        protected void gvDocuments_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddlDocType = (DropDownList)e.Row.FindControl("ddlDocType");
                FileUpload fuDoc = (FileUpload)e.Row.FindControl("fuDoc");
                DataRowView rowView = (DataRowView)e.Row.DataItem;

                if (ddlDocType != null)
                {
                    BindDocumentDropdown(ddlDocType);
                    if (!string.IsNullOrEmpty(rowView["DocumentType"].ToString()))
                    {
                        ddlDocType.SelectedValue = rowView["DocumentType"].ToString();
                    }
                }

                if (fuDoc != null && !string.IsNullOrEmpty(rowView["FileName"].ToString()))
                {
                    // Show the file name that was previously uploaded
                    // Note: We can't repopulate the FileUpload control, but we can show the name
                    e.Row.Cells[2].Text = rowView["FileName"].ToString();
                }
            }
        }

        protected string GetFileDisplay(object fileName)
        {
            if (fileName != null && !string.IsNullOrEmpty(fileName.ToString()))
            {
                return $"<span class='file-name'>{fileName}</span>";
            }
            return "<span class='no-file'>No file selected</span>";
        }

        private void BindDocumentDropdown(DropDownList ddl)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    HttpResponseMessage response = client.GetAsync(apiUrl + "TblDocumentMasters/GetTblDocumentMasters").Result;

                    if (response.IsSuccessStatusCode)
                    {
                        var jsonResponse = response.Content.ReadAsStringAsync().Result;
                        var dt = JsonConvert.DeserializeObject<DataTable>(jsonResponse);

                        ddl.DataSource = dt;
                        ddl.DataValueField = "documentId";
                        ddl.DataTextField = "documentName";
                        ddl.DataBind();

                        ddl.Items.Insert(0, new ListItem("-- Select Document Type --", ""));
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string Name = txtVictimName.Text;
                string Age = txtVictimAge.Text;
                string Gender = rblGender.SelectedValue;
                string AadharNo = txtVictimAadhar.Text;
                string fileName_Aadhardoc = fuAadharDoc.FileName;
                Stream fileStream_Aadhardoc = fuAadharDoc.PostedFile.InputStream;

                string VictimProfile = AddVictimProfile(Name, Age, Gender, AadharNo, fileName_Aadhardoc, fileStream_Aadhardoc);

                var jsonDocument = JsonDocument.Parse(VictimProfile);

                string VictId = jsonDocument.RootElement.GetProperty("victimProfileId").GetString();

                string VictimProfileId = VictId;
                string ApplicantId = Session["UserId"].ToString();
                DateTime IncidentDate = Convert.ToDateTime(txtDate.Text);

                TimeSpan IncidentTime;

                if (!TimeSpan.TryParse(txtTime.Text, out IncidentTime))
                {
                    DateTime timeAsDateTime;
                    if (DateTime.TryParse(txtTime.Text, out timeAsDateTime))
                    {
                        IncidentTime = timeAsDateTime.TimeOfDay;
                    }
                    else
                    {
                        throw new ArgumentException("Invalid time format. Please enter time in HH:mm format.");
                    }
                }

                string IncidentPlace = txtPlace.Text;
                string KilledBy = ddlAnimalType.SelectedValue;
                string Activity = txtActivity.Text;
                decimal Lat = Convert.ToDecimal(txtLat.Text);
                decimal Long = Convert.ToDecimal(txtLong.Text);
                string Status = "Pending";
                string RangeOfficerId = ddlRange.SelectedValue;
                string IncidentSummary = txtSummary.Text;
                string HumanLoss = rblHumanLoss.SelectedValue;
                int DivisionId = Convert.ToInt32(ddlDivision.SelectedValue);
                int SubDivisionId = Convert.ToInt32(ddlDivision.SelectedValue);

                string VictimIncidentResult = AddVictimIncident(VictimProfileId, ApplicantId, IncidentDate, IncidentTime, IncidentPlace, KilledBy, Activity, Lat, Long, Status, RangeOfficerId, DivisionId, SubDivisionId, IncidentSummary, HumanLoss);

                var jsonDocument1 = JsonDocument.Parse(VictimIncidentResult);

                string VictIncId = jsonDocument1.RootElement.GetProperty("incidentId").GetString();

                DataTable dt = Session[DOCUMENT_TABLE] as DataTable;
                SaveAllSelections(dt);

                SaveDocumentsToDatabase(dt, VictIncId);


                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Details saved successfully!.');", true);
            }
            catch (Exception ex)
            {

            }
        }





        //private void SaveSingleRecord(GridViewRow row)
        //{
        //    try
        //    {
        //        // Get controls from the row
        //        DropDownList ddlDocType = (DropDownList)row.FindControl("ddlDocType");
        //        FileUpload fuDoc = (FileUpload)row.FindControl("fuDoc");

        //        // Get values
        //        int documentTypeId = Convert.ToInt32(ddlDocType.SelectedValue);
        //        string fileName = fuDoc.FileName;
        //        byte[] fileContent = null;

        //        //if (fuDoc.HasFile)
        //        //{
        //            using (Stream fs = fuDoc.PostedFile.InputStream)
        //            {
        //                fileContent = new byte[fs.Length];
        //                fs.Read(fileContent, 0, (int)fs.Length);
        //            }
        //        //}

        //        // Prepare API call data
        //        var documentData = new
        //        {
        //            DocumentTypeId = documentTypeId,
        //            FileName = fileName,
        //            FileContent = Convert.ToBase64String(fileContent),
        //            // Add other fields from your form as needed
        //            //IncidentId = GetIncidentId(), // You'll need to implement this
        //            UploadDate = DateTime.Now
        //        };

        //        // Call your API to save the document
        //        //using (var client = new HttpClient())
        //        //{
        //        //    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //        //    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

        //        //    var response = client.PostAsJsonAsync(apiUrl + "Documents/SaveDocument", documentData).Result;

        //        //    if (!response.IsSuccessStatusCode)
        //        //    {
        //        //        throw new Exception($"Failed to save document: {response.ReasonPhrase}");
        //        //    }
        //        //}
        //    }
        //    catch (Exception ex)
        //    {
        //        // Log the error for this specific row
        //        // You might want to collect all errors and show them at the end
        //        throw new Exception($"Error saving row {row.RowIndex + 1}: {ex.Message}");
        //    }
        //}


        //private void SaveDocumentsToDatabase(DataTable dt, string victimIncidentId)
        //{
        //    foreach (DataRow row in dt.Rows)
        //    {

        //        string userid = Session["UserId"].ToString();
        //        string roleId = Session["RoleId"].ToString();

        //        string documentTypeId = row["DocumentType"].ToString();
        //        string fileName = row["FileName"].ToString();
        //        string filePath = row["FilePath"].ToString();  // Relative path
        //        byte[] fileContent = row["FileContent"] as byte[];

        //        try
        //        {
        //            using (var client = new HttpClient())
        //            {
        //                using (var form = new MultipartFormDataContent())
        //                {
        //                    form.Add(new StringContent(victimIncidentId), "IncidentId");
        //                    form.Add(new StringContent(userid), "UserId");
        //                    form.Add(new StringContent(roleId), "RoleId");
        //                    form.Add(new StringContent(documentTypeId), "DocumentId");
        //                    form.Add(new StringContent(filePath), "FilePath");

        //                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
        //                    var url = $"{apiUrl}TblDocuments/PostTblDocument";

        //                    var response = client.PostAsync(url, form).Result;

        //                    if (response.IsSuccessStatusCode)
        //                    {

        //                    }
        //                    else
        //                    {

        //                    }
        //                }
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //        }
        //    }
        //}


        private void SaveDocumentsToDatabase(DataTable dt, string victimIncidentId)
        {
            foreach (DataRow row in dt.Rows)
            {
                string userid = Session["UserId"].ToString();
                string roleId = Session["RoleId"].ToString();

                string documentTypeId = row["DocumentType"].ToString();
                string fileName = row["FileName"].ToString();
                string filePath = row["FilePath"].ToString(); // Relative path
                byte[] fileContent = row["FileContent"] as byte[];

                DropDownList ddl = null;

                int rowIndex = dt.Rows.IndexOf(row);
                if (rowIndex < gvDocuments.Rows.Count)
                {
                    GridViewRow gvRow = gvDocuments.Rows[rowIndex];
                    ddl = gvRow.FindControl("ddlDocType") as DropDownList;
                }

                string ddlDocType = ddl?.SelectedItem?.Text ?? string.Empty;

                try
                {
                    using (var client = new HttpClient())
                    using (var form = new MultipartFormDataContent())
                    {
                        // Send metadata
                        form.Add(new StringContent(victimIncidentId), "IncidentId");
                        form.Add(new StringContent(userid), "UserId");
                        form.Add(new StringContent(roleId), "RoleId");
                        form.Add(new StringContent(documentTypeId), "DocumentId");
                        form.Add(new StringContent(filePath), "FilePath");
                        form.Add(new StringContent(ddlDocType), "documentName");

                        // Send file
                        if (fileContent != null)
                        {
                            var fileContentPart = new ByteArrayContent(fileContent);
                            fileContentPart.Headers.ContentType = MediaTypeHeaderValue.Parse("application/octet-stream");
                            form.Add(fileContentPart, "fileDoc", fileName); // "fileDoc" must match API parameter name
                        }

                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                        var url = $"{apiUrl}TblDocuments/PostTblDocument";

                        var response = client.PostAsync(url, form).Result;

                        if (response.IsSuccessStatusCode)
                        {
                            // success
                        }
                        else
                        {
                            // log or handle failure
                        }
                    }
                }
                catch (Exception ex)
                {
                    // log error
                }
            }
        }





        //private void SaveAllSelections(DataTable dt)
        //{
        //    try
        //    {
        //        for (int i = 0; i < gvDocuments.Rows.Count; i++)
        //        {
        //            GridViewRow gridRow = gvDocuments.Rows[i];

        //            DropDownList ddl = (DropDownList)gridRow.FindControl("ddlDocType");
        //            FileUpload fu = (FileUpload)gridRow.FindControl("fuDoc");

        //            string selectedDocType = ddl != null ? ddl.SelectedValue : "";

        //            if (fu != null && fu.HasFile)
        //            {
        //                string originalFileName = Path.GetFileName(fu.FileName);
        //                //string fullPath = Path.Combine(originalFileName);





        //                string folderPath = Server.MapPath("~/Doc/");
        //                if (!Directory.Exists(folderPath))
        //                {
        //                    Directory.CreateDirectory(folderPath);
        //                }

        //                string fullPath = Path.Combine(folderPath, originalFileName);
        //                fu.SaveAs(fullPath);

        //                // Update DataTable
        //                dt.Rows[i]["DocumentType"] = selectedDocType;
        //                dt.Rows[i]["FileName"] = originalFileName;
        //                dt.Rows[i]["FileContent"] = File.ReadAllBytes(fullPath); // Optional
        //                dt.Rows[i]["FilePath"] = "~/Doc/" + originalFileName;
        //            }
        //            else
        //            {
        //                // Still store the document type even if no file selected
        //                dt.Rows[i]["DocumentType"] = selectedDocType;
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}



        private void SaveAllSelections(DataTable dt)
        {
            try
            {
                for (int i = 0; i < gvDocuments.Rows.Count; i++)
                {
                    GridViewRow gridRow = gvDocuments.Rows[i];

                    DropDownList ddl = (DropDownList)gridRow.FindControl("ddlDocType");
                    FileUpload fu = (FileUpload)gridRow.FindControl("fuDoc");

                    string selectedDocType = ddl != null ? ddl.SelectedValue : "";

                    if (fu != null && fu.HasFile)
                    {
                        string originalFileName = Path.GetFileName(fu.FileName);
                        byte[] fileBytes = fu.FileBytes;

                        // Update DataTable
                        dt.Rows[i]["DocumentType"] = selectedDocType;
                        dt.Rows[i]["FileName"] = originalFileName;
                        dt.Rows[i]["FileContent"] = fileBytes;
                        dt.Rows[i]["FilePath"] = ""; // You may skip or keep it empty; path will be set from API response
                    }
                    else
                    {
                        // Still store the document type even if no file selected
                        dt.Rows[i]["DocumentType"] = selectedDocType;
                    }
                }
            }
            catch (Exception ex)
            {
                // Consider logging exception
            }
        }





        public string AddVictimProfile(string Name, string Age, string Gender, string AadharNo, string fileName_Aadhardoc, Stream fileStream_Aadhardoc)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    using (var form = new MultipartFormDataContent())
                    {
                        form.Add(new StringContent(Name), "Name");
                        form.Add(new StringContent(Age), "Age");
                        form.Add(new StringContent(Gender), "Gender");
                        form.Add(new StringContent(AadharNo), "AadharNo");

                        if (fileStream_Aadhardoc != null)
                        {
                            var fileContent = new StreamContent(fileStream_Aadhardoc);

                            fileContent.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("form-data")
                            {
                                Name = "aadharDoc",
                                FileName = fileName_Aadhardoc
                            };

                            fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
                            form.Add(fileContent);
                        }

                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                        var url = $"{apiUrl}TblVictimProfiles/PostTblVictimProfile";

                        var response = client.PostAsync(url, form).Result;

                        if (response.IsSuccessStatusCode)
                        {
                            return response.Content.ReadAsStringAsync().Result;
                        }
                        else
                        {
                            return $"Error: {response.ReasonPhrase}";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return $"Error: {ex.Message}";
            }
        }


        public string AddVictimIncident(string victimProfileId, string applicantId, DateTime incidentDate, TimeSpan incidentTime, string incidentPlace, string killedBy, string activity, decimal lat, decimal longitude, string status, string rangeOfficerId, int DivisionId, int SubDivisionId, string incidentSummary, string HumanLoss)
        {
            try
            {
                HttpClient client = new HttpClient();

                var data = new
                {
                    victimProfileId = victimProfileId,
                    applicantId = applicantId,
                    incidentDate = incidentDate,
                    incidentTime = incidentTime,
                    incidentPlace = incidentPlace,
                    killedBy = killedBy,
                    activity = activity,
                    latitude = lat,
                    longitude = longitude,
                    status = status,
                    rangeOfficerId = rangeOfficerId,
                    incidentSummary = incidentSummary,
                    humanLoss = HumanLoss,
                    divisionId = DivisionId,
                    subDivisionId = SubDivisionId
                };

                var json = JsonConvert.SerializeObject(data);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblVictimIncidents/PostTblVictimIncident"; // Make sure this is the correct endpoint
                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                HttpResponseMessage response = response1.Result;

                if (response.IsSuccessStatusCode)
                {
                    // Handle success if needed
                }

                string result = response.Content.ReadAsStringAsync().Result;
                return result;
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message; // Better to return the error message for debugging
            }
        }

        void BindDivision()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblDivisionMasters/GetTblDivisionMasters")).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddlDivision.Items.Clear();
                        ddlDivision.DataSource = dt;
                        //ddlDivision.DataValueField = "Gid";
                        ddlDivision.DataValueField = "Id";
                        ddlDivision.DataTextField = "Division";
                        ddlDivision.DataBind();
                        ddlDivision.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0"));
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
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblRangeMasters/GetRangeMaster_ByDivisionId?zoneId=" + zoneId + "&circleId=" + circleId + "&divisionId=" + divisionId)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddlRange.Items.Clear();
                        ddlRange.DataSource = dt;
                        ddlRange.DataValueField = "rangeId";
                        ddlRange.DataTextField = "rangeName";
                        ddlRange.DataBind();
                        ddlRange.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0"));
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void lnkViewDetails_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect("incident_list.aspx", false);
            }
            catch (Exception ex)
            {

            }
        }
    }
}
