using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.common_email;

namespace uk_forest.Forest
{
    public partial class user_registration_new : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        private string currentUserId = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    BindRoles();
                    BindHoffs(3);
                    BindPccfs(4);
                    BindApccfs(5);
                    BindCcfs(6);
                    BindCfs(7);
                    BindZones();
                    BindUserGrid();
                    //divstatus.Visible = false;
                    btn_approve.Visible = false;
                    btn_reject.Visible = false;
                    string a = Request.QueryString["permission"];
                    string ID = Request.QueryString["id"];
                    string pageName = Request.QueryString["pageName"];
                    btnback.Visible = false;
                    //user_details(ID);
                    //string pageName = Session["pageName"].ToString();
                    if (a == "Edit")
                    {
                        LoadUserForEditing(ID, pageName);
                        DisableControls();
                        btn_update.Visible = true;
                        btn_save.Visible = false;
                        //divstatus.Visible = false;
                        btnback.Visible = true;
                    }
                    else if (a == "View")
                    {
                        LoadUserForEditing(ID, pageName);
                        DisableControls();
                        btn_update.Visible = false;
                        btn_save.Visible = false;
                        //divstatus.Visible = true;
                        btnback.Visible = true;
                    }
                    else if (a == "Approve/Reject")
                    {
                        LoadUserForEditing(ID, pageName);
                        DisableControls();
                        btn_update.Visible = false;
                        btn_save.Visible = false;
                        //divAction.Visible = true;
                        //divstatus.Visible = false;
                        btn_reject.Visible = true;
                        btn_approve.Visible = true;
                        btnback.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred: " + ex.Message);
            }
        }

        private void BindRoles()
        {
            // Roles are hardcoded in the dropdown for simplicity
            // Could be loaded from API if needed
        }

        private void BindHoffs(Int32 role_id = 0, string user_id = "0")
        {
            try
            {
                string url = apiUrl + "TblUserRegistrations/GetUsersByRole?role_id=" + role_id + "&user_id=" + user_id;
                HttpResponseMessage response = client.GetAsync(url).Result;
                if (response.IsSuccessStatusCode)
                {
                    if (Convert.ToInt32(response.StatusCode) == 201)
                    {
                        ddl_hoff.Items.Clear();
                        ddl_hoff.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select HOFF --", ""));
                    }
                    else if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                        ddl_hoff.DataSource = dt;
                        ddl_hoff.DataValueField = "UserId";
                        ddl_hoff.DataTextField = "Name";
                        ddl_hoff.DataBind();
                        ddl_hoff.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select HOFF --", ""));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading HOFFs: " + ex.Message);
            }
        }

        private void BindPccfs(Int32 role_id = 0, string user_id = "0")
        {
            try
            {
                string url = apiUrl + "TblUserRegistrations/GetUsersByRole?role_id=" + role_id + "&user_id=" + user_id;

                HttpResponseMessage response = client.GetAsync(url).Result;

                if (response.IsSuccessStatusCode)
                {
                    if (Convert.ToInt32(response.StatusCode) == 201)
                    {
                        ddl_pccf.Items.Clear();
                        ddl_pccf.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select PCCF --", ""));
                    }
                    else if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                        ddl_pccf.DataSource = dt;
                        ddl_pccf.DataValueField = "UserId";
                        ddl_pccf.DataTextField = "Name";
                        ddl_pccf.DataBind();
                        ddl_pccf.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select PCCF --", ""));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading PCCFs: " + ex.Message);
            }
        }
        private void BindApccfs(Int32 role_id = 0, string user_id = "0")
        {
            try
            {
                string url = apiUrl + "TblUserRegistrations/GetUsersByRole?role_id=" + role_id + "&user_id=" + user_id;

                HttpResponseMessage response = client.GetAsync(url).Result;

                if (response.IsSuccessStatusCode)
                {
                    if (Convert.ToInt32(response.StatusCode) == 201)
                    {
                        ddl_apccf.Items.Clear();
                        ddl_apccf.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select APCCF --", ""));
                    }
                    else if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                        ddl_apccf.DataSource = dt;
                        ddl_apccf.DataValueField = "UserId";
                        ddl_apccf.DataTextField = "Name";
                        ddl_apccf.DataBind();
                        ddl_apccf.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select APCCF --", ""));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading APCCFs: " + ex.Message);
            }
        }
        private void BindCcfs(Int32 role_id = 0, string user_id = "0")
        {
            try
            {
                string url = apiUrl + "TblUserRegistrations/GetUsersByRole?role_id=" + role_id + "&user_id=" + user_id;

                HttpResponseMessage response = client.GetAsync(url).Result;

                if (response.IsSuccessStatusCode)
                {
                    if (Convert.ToInt32(response.StatusCode) == 201)
                    {
                        ddl_ccf.Items.Clear();
                        ddl_ccf.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select CCF --", ""));
                    }
                    else if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                        ddl_ccf.DataSource = dt;
                        ddl_ccf.DataValueField = "UserId";
                        ddl_ccf.DataTextField = "Name";
                        ddl_ccf.DataBind();
                        ddl_ccf.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select CCF --", ""));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading CCFs: " + ex.Message);
            }
        }
        private void BindCfs(Int32 role_id = 0, string user_id = "0")
        {
            try
            {
                string url = apiUrl + "TblUserRegistrations/GetUsersByRole?role_id=" + role_id + "&user_id=" + user_id;

                HttpResponseMessage response = client.GetAsync(url).Result;

                if (response.IsSuccessStatusCode)
                {
                    if (Convert.ToInt32(response.StatusCode) == 201)
                    {
                        ddl_cf.Items.Clear();
                        ddl_cf.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select CF --", ""));
                    }
                    else if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                        ddl_cf.DataSource = dt;
                        ddl_cf.DataValueField = "UserId";
                        ddl_cf.DataTextField = "Name";
                        ddl_cf.DataBind();
                        ddl_cf.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select CF --", ""));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading CFs: " + ex.Message);
            }
        }

        private void BindZones()
        {
            try
            {
                HttpResponseMessage response = client.GetAsync(apiUrl + "TblZoneMasters/GetTblZoneMasters").Result;

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                    ddl_zone.DataSource = dt;
                    ddl_zone.DataValueField = "gId";
                    ddl_zone.DataTextField = "zone";
                    ddl_zone.DataBind();
                    ddl_zone.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Zone --", "0"));
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading Zones: " + ex.Message);
            }
        }

        private void BindCircles(Int32 zoneId = 0)
        {
            try
            {
                string url = apiUrl + "TblCircleMasters/GetTblCircleMasterByZoneId?zone_id=" + zoneId;

                HttpResponseMessage response = client.GetAsync(url).Result;

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                    ddl_circle.DataSource = dt;
                    ddl_circle.DataValueField = "circleId";
                    ddl_circle.DataTextField = "circleName";
                    ddl_circle.DataBind();
                    ddl_circle.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Circle --", "0"));
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading Circles: " + ex.Message);
            }
        }

        private void BindDivisions(Int32 circleId = 0)
        {
            try
            {
                string url = apiUrl + "TblDivisionMasters/GetTblDivisionMasterByCircleId?circle_id=" + circleId;

                HttpResponseMessage response = client.GetAsync(url).Result;

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                    ddl_division.DataSource = dt;
                    ddl_division.DataValueField = "DivisionId";
                    ddl_division.DataTextField = "DivisionName";
                    ddl_division.DataBind();
                    ddl_division.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Division --", "0"));
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading Divisions: " + ex.Message);
            }
        }


        private void BindUserGrid()
        {
            try
            {
                HttpResponseMessage response = client.GetAsync(apiUrl + "TblUserRegistrationTemps/GetTblUserRegistrationTemps").Result;

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                    if (!dt.Columns.Contains("RoleName"))
                    {
                        dt.Columns.Add("RoleName", typeof(string));
                        foreach (DataRow row in dt.Rows)
                        {
                            switch (row["RoleId"].ToString())
                            {
                                case "3": row["RoleName"] = "HOFF"; break;
                                case "4": row["RoleName"] = "PCCF"; break;
                                case "5": row["RoleName"] = "APCCF"; break;
                                case "6": row["RoleName"] = "CCF"; break;
                                case "7": row["RoleName"] = "CF"; break;
                                case "8": row["RoleName"] = "DFO"; break;
                                default: row["RoleName"] = "Unknown"; break;
                            }
                        }
                    }

                    gv_users.DataSource = dt;
                    gv_users.DataBind();
                    gv_users.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading users: " + ex.Message);
            }
        }

        private void UpdateUIForSelectedRole(string selectedRoleValue, string reportingTo = "")
        {
            divHierarchy.Visible = false;
            divHoff.Visible = false;
            divPccf.Visible = false;
            divApccf.Visible = false;
            divCcf.Visible = false;
            divCF.Visible = false;
            divZone.Visible = false;
            divCircle.Visible = false;
            divDivision.Visible = false;

            if (!string.IsNullOrEmpty(selectedRoleValue))
            {
                divHierarchy.Visible = true;

                if (selectedRoleValue == "0")
                {
                    litTitle.Text = "Add User";
                }
                else
                {
                    litTitle.Text = "Add " + ddl_role.SelectedItem.Text;
                }

                //divHierarchy.Visible = true;
                //litTitle.Text = "Add " + ddl_role.SelectedItem.Text;

                switch (selectedRoleValue)
                {
                    case "0":
                        //Response.Redirect("user_registration_new.aspx");
                        BindRoles();
                        BindHoffs(3);
                        BindPccfs(4);
                        BindApccfs(5);
                        BindCcfs(6);
                        BindCfs(7);
                        BindZones();
                        BindUserGrid();
                        divReporting.Visible = false;
                        divHierarchy.Visible = false;
                        break;

                    case "3": // HOFF
                        divReporting.Visible = false;

                        rbl_reporting_to.SelectedValue = "HOFF";

                        break;

                    case "4": // PCCF
                        divReporting.Visible = false;
                        divHoff.Visible = true;

                        rbl_reporting_to.SelectedValue = "HOFF";

                        //BindHoffs(3);

                        break;

                    case "5": // APCCF
                        divReporting.Visible = true;
                        ListItem itemToHideAPCCF = rbl_reporting_to.Items.FindByValue("APCCF");
                        itemToHideAPCCF.Attributes["style"] = "display:none";
                        ListItem itemToHideCCF = rbl_reporting_to.Items.FindByValue("CCF");
                        itemToHideCCF.Attributes["style"] = "display:none";
                        ListItem itemToHideCF = rbl_reporting_to.Items.FindByValue("CF");
                        itemToHideCF.Attributes["style"] = "display:none";

                        rbl_reporting_to.SelectedValue = "HOFF";
                        divHoff.Visible = true;

                        if (reportingTo == "HOFF")
                        {
                            rbl_reporting_to.SelectedValue = "HOFF";
                            divHoff.Visible = true;
                        }
                        else if (reportingTo == "PCCF")
                        {
                            rbl_reporting_to.SelectedValue = "PCCF";
                            divHoff.Visible = false;
                            divPccf.Visible = true;
                            //BindPccfs(4);

                        }
                        break;

                    case "6": // CCF
                        divReporting.Visible = true;
                        ListItem itemToHideCCF1 = rbl_reporting_to.Items.FindByValue("CCF");
                        itemToHideCCF1.Attributes["style"] = "display:none";
                        ListItem itemToHideCF1 = rbl_reporting_to.Items.FindByValue("CF");
                        itemToHideCF1.Attributes["style"] = "display:none";

                        rbl_reporting_to.SelectedValue = "HOFF";
                        divHoff.Visible = true;

                        //BindApccfs(5);

                        if (reportingTo == "HOFF")
                        {
                            rbl_reporting_to.SelectedValue = "HOFF";
                            divHoff.Visible = true;
                        }
                        else if (reportingTo == "PCCF")
                        {
                            rbl_reporting_to.SelectedValue = "PCCF";
                            divHoff.Visible = false;
                            divPccf.Visible = true;
                        }
                        else if (reportingTo == "APCCF")
                        {
                            rbl_reporting_to.SelectedValue = "APCCF";
                            divHoff.Visible = false;
                            divPccf.Visible = false;
                            divApccf.Visible = true;
                        }

                        divZone.Visible = true;
                        break;

                    case "7": // CF
                        divReporting.Visible = true;
                        ListItem itemToHideHOFF = rbl_reporting_to.Items.FindByValue("HOFF");
                        itemToHideHOFF.Attributes["style"] = "display:none";
                        ListItem itemToHidePCCF = rbl_reporting_to.Items.FindByValue("PCCF");
                        itemToHidePCCF.Attributes["style"] = "display:none";
                        ListItem itemToHideCF2 = rbl_reporting_to.Items.FindByValue("CF");
                        itemToHideCF2.Attributes["style"] = "display:none";

                        rbl_reporting_to.SelectedValue = "APCCF";
                        divHoff.Visible = false;
                        divPccf.Visible = false;
                        divApccf.Visible = true;

                        //BindCcfs(6);

                        if (reportingTo == "CCF")
                        {
                            rbl_reporting_to.SelectedValue = "CCF";
                            divHoff.Visible = false;
                            divPccf.Visible = false;
                            divApccf.Visible = false;
                            divCcf.Visible = true;
                        }
                        else if (reportingTo == "APCCF")
                        {
                            rbl_reporting_to.SelectedValue = "APCCF";
                            divHoff.Visible = false;
                            divPccf.Visible = false;
                            divApccf.Visible = true;
                        }

                        divZone.Visible = true;
                        divCircle.Visible = true;
                        break;

                    case "8": // DFO
                        divReporting.Visible = true;
                        ListItem itemToHideHOFF1 = rbl_reporting_to.Items.FindByValue("HOFF");
                        itemToHideHOFF1.Attributes["style"] = "display:none";
                        ListItem itemToHidePCCF1 = rbl_reporting_to.Items.FindByValue("PCCF");
                        itemToHidePCCF1.Attributes["style"] = "display:none";

                        rbl_reporting_to.SelectedValue = "APCCF";
                        divHoff.Visible = false;
                        divPccf.Visible = false;
                        divApccf.Visible = true;

                        //BindCfs(7);

                        if (reportingTo == "APCCF")
                        {
                            rbl_reporting_to.SelectedValue = "APCCF";
                            divHoff.Visible = false;
                            divPccf.Visible = false;
                            divApccf.Visible = true;
                        }
                        else if (reportingTo == "CCF")
                        {
                            rbl_reporting_to.SelectedValue = "CCF";
                            divHoff.Visible = false;
                            divPccf.Visible = false;
                            divApccf.Visible = false;
                            divCcf.Visible = true;
                        }
                        else if (reportingTo == "CF")
                        {
                            rbl_reporting_to.SelectedValue = "CF";
                            divHoff.Visible = false;
                            divPccf.Visible = false;
                            divApccf.Visible = false;
                            divCcf.Visible = false;
                            divCF.Visible = true;
                        }

                        divZone.Visible = true;
                        divCircle.Visible = true;
                        divDivision.Visible = true;
                        break;
                }
            }
        }

        protected void ddl_role_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(ddl_role.SelectedValue))
                {
                    string selectedReportingTo = rbl_reporting_to.SelectedValue;
                    UpdateUIForSelectedRole(ddl_role.SelectedValue, selectedReportingTo);
                }
            }
            catch (Exception ex)
            {
                ShowError("Error changing role: " + ex.Message);
            }
        }

        protected void ddl_hoff_SelectedIndexChanged(object sender, EventArgs e)
        {
            //BindPccfs(ddl_hoff.SelectedValue);
            //BindPccfs(ddl_hoff.SelectedValue, Convert.ToInt32(ddl_role.SelectedValue));

            //BindPccfs(4);

            string selectedReportingTo = rbl_reporting_to.SelectedValue;
            UpdateUIForSelectedRole(ddl_role.SelectedValue, selectedReportingTo);
        }

        protected void ddl_pccf_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (!string.IsNullOrEmpty(ddl_pccf.SelectedValue))
            //{
            //BindApccfs(ddl_pccf.SelectedValue);
            //UpdateUIForSelectedRole(ddl_role.SelectedValue);
            //}

            //if (!string.IsNullOrEmpty(ddl_pccf.SelectedValue))
            //{
            string selectedReportingTo = rbl_reporting_to.SelectedValue;
            UpdateUIForSelectedRole(ddl_role.SelectedValue, selectedReportingTo);
            //}

        }

        protected void ddl_apccf_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (!string.IsNullOrEmpty(ddl_apccf.SelectedValue))
            //{
            //UpdateUIForSelectedRole(ddl_role.SelectedValue);
            //BindCcfs(ddl_apccf.SelectedValue);
            //}

            //if (!string.IsNullOrEmpty(ddl_apccf.SelectedValue))
            //{
            string selectedReportingTo = rbl_reporting_to.SelectedValue;
            UpdateUIForSelectedRole(ddl_role.SelectedValue, selectedReportingTo);
            //}
        }

        protected void ddl_ccf_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (!string.IsNullOrEmpty(ddl_ccf.SelectedValue))
            //{
            //UpdateUIForSelectedRole(ddl_role.SelectedValue);
            //BindCfs(ddl_ccf.SelectedValue);
            //}

            //if (!string.IsNullOrEmpty(ddl_ccf.SelectedValue))
            //{
            string selectedReportingTo = rbl_reporting_to.SelectedValue;
            UpdateUIForSelectedRole(ddl_role.SelectedValue, selectedReportingTo);
            //}
        }

        protected void ddl_cf_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (!string.IsNullOrEmpty(ddl_ccf.SelectedValue))
            //{
            //UpdateUIForSelectedRole(ddl_role.SelectedValue);
            //BindCfs(ddl_ccf.SelectedValue);
            //}

            //if (!string.IsNullOrEmpty(ddl_cf.SelectedValue))
            //{
            string selectedReportingTo = rbl_reporting_to.SelectedValue;
            UpdateUIForSelectedRole(ddl_role.SelectedValue, selectedReportingTo);
            //}
        }

        protected void ddl_zone_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddl_zone.SelectedValue))
            {
                BindCircles(Convert.ToInt32(ddl_zone.SelectedValue));
                if (!string.IsNullOrEmpty(ddl_circle.SelectedValue))
                {
                    BindDivisions(Convert.ToInt32(ddl_circle.SelectedValue));
                }
                //string selected = rbl_reporting_to.SelectedValue;
                //ToggleReportingPanels(selected);

                string selectedReportingTo = rbl_reporting_to.SelectedValue;
                UpdateUIForSelectedRole(ddl_role.SelectedValue, selectedReportingTo);

            }
        }

        protected void ddl_circle_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddl_circle.SelectedValue))
            {
                BindDivisions(Convert.ToInt32(ddl_circle.SelectedValue));

                //string selected = rbl_reporting_to.SelectedValue;
                //ToggleReportingPanels(selected);

                string selectedReportingTo = rbl_reporting_to.SelectedValue;
                UpdateUIForSelectedRole(ddl_role.SelectedValue, selectedReportingTo);
            }
        }

        public string add_user_name(string name, string mobileNo, string emailId, Int32 roleId, Int32 zoneId, Int32 circleId, Int32 divisionId, string password, string otp, string groupId, Int32 groupRoleId, string status, string createdBy)
        {
            try
            {
                var userData = new
                {
                    //EmpId = empId,
                    Name = name,
                    MobileNo = mobileNo,
                    EmailId = emailId,
                    //AadharNo = aadharNo,
                    RoleId = roleId,
                    //DeptId = deptId,
                    //DesignationId = designationId,
                    ZoneId = zoneId,
                    CircleId = circleId,
                    DivisionId = divisionId,
                    Password = password,
                    Otp = otp,
                    GroupId = groupId,
                    GroupRoleId = groupRoleId,
                    Status = status,
                    CreatedBy = createdBy
                    //Remarks = remarks,
                };

                var json = JsonConvert.SerializeObject(userData);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                //var url = apiUrl + "TblUserRegistrationTemps/PostTblUserRegistrationTemp";
                var url = apiUrl + "TblUserRegistrations/PostTblUserRegistration";

                var response1 = client.PostAsync(url, data1);
                response1.Wait();
                // HttpResponseMessage response;

                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                    //ResetForm();
                    BindUserGrid();
                }
                string result = response.Content.ReadAsStringAsync().Result;
                return result;
            }
            catch (Exception ex)
            {
                return "Not Found";
            }
        }

        public string GeneratePassword()
        {
            Random random = new Random();
            int pwd = random.Next(100000, 1000000);
            return pwd.ToString("D6");
        }

        protected void btn_save_Click(object sender, EventArgs e)
        {
            try
            {
                if (ValidateInputs())
                {
                    string groupId = "";
                    string zoneId = "";
                    string circleId = "";
                    string divisionId = "";
                    Int32 grouproleId = 0;
                    string status = "pending";

                    //Determine group ID based on role(same as before)
                    // ... [keep your existing switch case logic here] ...

                    // Determine group ID based on role
                    switch (ddl_role.SelectedValue)
                    {
                        case "3": // HOFF
                            groupId = "0";
                            grouproleId = 0;
                            break;

                        case "4": // PCCF
                            groupId = ddl_hoff.SelectedValue;
                            grouproleId = 3;
                            break;

                        case "5": // APCCF
                            if (rbl_reporting_to.SelectedValue == "HOFF")
                            {
                                groupId = ddl_hoff.SelectedValue;
                                grouproleId = 3;
                            }
                            else if (rbl_reporting_to.SelectedValue == "PCCF")
                            {
                                groupId = ddl_pccf.SelectedValue;
                                grouproleId = 4;
                            }
                            break;

                        case "6": // CCF
                            if (rbl_reporting_to.SelectedValue == "HOFF")
                            {
                                groupId = ddl_hoff.SelectedValue;
                                grouproleId = 3;
                            }
                            else if (rbl_reporting_to.SelectedValue == "PCCF")
                            {
                                groupId = ddl_pccf.SelectedValue;
                                grouproleId = 4;
                            }
                            else if (rbl_reporting_to.SelectedValue == "APCCF")
                            {
                                groupId = ddl_apccf.SelectedValue;
                                grouproleId = 5;
                            }
                            zoneId = ddl_zone.SelectedValue;
                            break;

                        case "7": // CF
                            if (rbl_reporting_to.SelectedValue == "HOFF")
                            {
                                groupId = ddl_hoff.SelectedValue;
                                grouproleId = 3;
                            }
                            else if (rbl_reporting_to.SelectedValue == "PCCF")
                            {
                                groupId = ddl_pccf.SelectedValue;
                                grouproleId = 4;
                            }
                            else if (rbl_reporting_to.SelectedValue == "APCCF")
                            {
                                groupId = ddl_apccf.SelectedValue;
                                grouproleId = 5;
                            }
                            else if (rbl_reporting_to.SelectedValue == "CCF")
                            {
                                groupId = ddl_ccf.SelectedValue;
                                grouproleId = 6;
                            }
                            circleId = ddl_circle.SelectedValue;
                            break;

                        case "8": // DFO
                            if (rbl_reporting_to.SelectedValue == "HOFF")
                            {
                                groupId = ddl_hoff.SelectedValue;
                                grouproleId = 3;
                            }
                            else if (rbl_reporting_to.SelectedValue == "PCCF")
                            {
                                groupId = ddl_pccf.SelectedValue;
                                grouproleId = 4;
                            }
                            else if (rbl_reporting_to.SelectedValue == "APCCF")
                            {
                                groupId = ddl_apccf.SelectedValue;
                                grouproleId = 5;
                            }
                            else if (rbl_reporting_to.SelectedValue == "CCF")
                            {
                                groupId = ddl_ccf.SelectedValue;
                                grouproleId = 6;
                            }
                            else if (rbl_reporting_to.SelectedValue == "CF")
                            {
                                groupId = ddl_cf.SelectedValue;
                                grouproleId = 7;
                            }
                            divisionId = ddl_division.SelectedValue;
                            break;
                    }

                    int CircleId = 0;
                    if (string.IsNullOrEmpty(ddl_circle.SelectedValue))
                        CircleId = 0;
                    else
                        CircleId = Convert.ToInt32(ddl_circle.SelectedValue);

                    int DivisionId = 0;
                    if (string.IsNullOrEmpty(ddl_division.SelectedValue))
                        DivisionId = 0;
                    else
                        DivisionId = Convert.ToInt32(ddl_division.SelectedValue);

                    if (string.IsNullOrEmpty(currentUserId))
                    {
                        string password = GeneratePassword();

                        // Create new user
                        string result = add_user_name(txt_name.Text, txt_mobile.Text, txt_email.Text, Convert.ToInt32(ddl_role.SelectedValue), Convert.ToInt32(ddl_zone.SelectedValue), CircleId, DivisionId, password, "1", groupId, grouproleId, status, Session["UserId"].ToString());

                        var resultObj = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(result);
                        string message = resultObj.message;

                        //string UserId = resultObj.userId;
                        string UserId = txt_email.Text;
                        string pass = resultObj.password;


                        if (!string.IsNullOrEmpty(message))
                        {

                            MailsHandling.send_mail_for_user_credential(txt_email.Text, txt_name.Text, "http://180.151.15.18:9008/uk_forest_web/web/index", UserId, pass);

                            //HttpResponseMessage Res = client.GetAsync(apiUrl + $"TblUserRegistrations/GetTblUserRegistration?id={groupId}").Result; 
                            HttpResponseMessage Res = client.GetAsync(apiUrl + $"TblUserRegistrations/GetAllUsers?user_id={groupId}").Result;
                            if (Res.IsSuccessStatusCode)
                            {
                                var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                                dynamic userData = JsonConvert.DeserializeObject(EmpResponse);
                                
                                //if (userData != null && userData.emailId != null)
                                if (userData != null)
                                {
                                    var firstUser = userData[0];
                                    string group_email_id = firstUser.emailId;
                                    string user_role_name = firstUser.roleName;
                                    string group_name = firstUser.name;

                                    MailsHandling.send_mail_to_group(group_email_id, group_name, txt_name.Text, "http://180.151.15.18:9008/uk_forest_web/web/index", UserId, ddl_role.SelectedItem.Text);
                                }                                
                            }

                            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{message}');", true);

                            ResetForm();
                        }
                    }
                    else
                    {
                        // Update existing user data
                        var userData = new
                        {
                            UserId = currentUserId,
                            //EmpId = txt_emp_id.Text,
                            Name = txt_name.Text,
                            MobileNo = txt_mobile.Text,
                            EmailId = txt_email.Text,
                            //Remarks = txt_remarks.Text,
                            RoleId = Convert.ToInt32(ddl_role.SelectedValue),
                            ZoneId = Convert.ToInt32(ddl_zone.SelectedValue),
                            CircleId = CircleId,
                            DivisionId = DivisionId,
                            GroupId = groupId,
                            GroupRoleId = grouproleId
                        };

                        var json = JsonConvert.SerializeObject(userData);
                        var content = new StringContent(json, Encoding.UTF8, "application/json");

                        using (var client = new HttpClient())
                        {
                            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                            var response = client.PutAsync(apiUrl + "TblUserRegistrationTemps/PutTblUserRegistrationTemp?id=" + currentUserId, content).Result;

                            if (response.IsSuccessStatusCode)
                            {
                                string result = response.Content.ReadAsStringAsync().Result;
                                var resultObj = JsonConvert.DeserializeObject<dynamic>(result);
                                ShowSuccess(resultObj.message.ToString());
                                ResetForm();
                                BindUserGrid();
                            }
                            else
                            {
                                ShowError("Failed to update user. Please try again.");
                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error during user save/update: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('An unexpected error occurred. Please try again.');", true);
            }
        }

        private bool ValidateInputs()
        {
            // Implement validation logic here
            // Check required fields based on role
            return true;
        }

        protected void btn_reset_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            currentUserId = "";
            txt_name.Text = "";
            txt_mobile.Text = "";
            txt_email.Text = "";
            //txt_aadhar.Text = "";
            //txt_emp_id.Text = "";
            //txt_remarks.Text = "";

            ddl_role.SelectedIndex = 0;
            //ddl_dept.SelectedIndex = 0;
            //ddl_designation.SelectedIndex = 0;

            // Reset all dropdowns
            ddl_hoff.SelectedIndex = 0;
            ddl_pccf.SelectedIndex = 0;
            ddl_apccf.SelectedIndex = 0;
            ddl_ccf.SelectedIndex = 0;
            ddl_cf.SelectedIndex = 0;
            ddl_zone.SelectedIndex = 0;
            ddl_circle.SelectedIndex = 0;
            ddl_division.SelectedIndex = 0;

            // Reset radio button list
            rbl_reporting_to.SelectedIndex = -1;

            // Update UI
            UpdateUIForSelectedRole(ddl_role.SelectedValue);

            // Change button text back to "Save"
            btn_save.Text = "Save";
        }

        protected void lnk_edit_Click(object sender, EventArgs e)
        {
            try
            {
                var lnk = (System.Web.UI.WebControls.LinkButton)sender;
                currentUserId = lnk.CommandArgument;

                HttpResponseMessage response = client.GetAsync(apiUrl + "TblUserRegistrations/GetTblUserRegistration?id=" + currentUserId).Result;

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    dynamic user = JsonConvert.DeserializeObject(result);

                    // Populate form fields
                    txt_name.Text = user.name;
                    txt_mobile.Text = user.mobile_no;
                    txt_email.Text = user.email_id;
                    //txt_emp_id.Text = user.emp_id;

                    ddl_role.SelectedValue = user.role_id.ToString();

                    // Trigger role change to load appropriate hierarchy
                    ddl_role_SelectedIndexChanged(null, null);

                    // TODO: Set hierarchy dropdowns based on group_id and group_role_id
                    // This would require additional API calls to determine the hierarchy

                    //ShowSuccess("User loaded for editing");
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading user: " + ex.Message);
            }
        }

        protected void gv_users_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gv_users.PageIndex = e.NewPageIndex;
            BindUserGrid();
        }

        private void ShowSuccess(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"alert('Error: {message.Replace("'", "\\'")}');", true);
        }

        protected void rbl_reporting_to_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedReportingTo = rbl_reporting_to.SelectedValue;
            UpdateUIForSelectedRole(ddl_role.SelectedValue, selectedReportingTo);
        }

        private void ToggleReportingPanels(string reportingTo)
        {
            UpdateUIForSelectedRole(ddl_role.SelectedValue);
            if (reportingTo == "HOFF")
            {
                divHoff.Visible = true;
                divPccf.Visible = false;
                divApccf.Visible = false;
                divCcf.Visible = false;
                divCF.Visible = false;
            }
            else if (reportingTo == "PCCF")
            {
                divHoff.Visible = true;
                divPccf.Visible = true;
                divApccf.Visible = false;
                divCcf.Visible = false;
                divCF.Visible = false;
            }
            else if (reportingTo == "APCCF")
            {
                divHoff.Visible = true;
                divPccf.Visible = true;
                divApccf.Visible = true;
                divCcf.Visible = false;
                divCF.Visible = false;
            }
            else if (reportingTo == "CCF")
            {
                divHoff.Visible = true;
                divPccf.Visible = true;
                divApccf.Visible = true;
                divCcf.Visible = true;
                divCF.Visible = false;
            }
            else if (reportingTo == "CF")
            {
                divPccf.Visible = true;
                divHoff.Visible = true;
                divApccf.Visible = true;
                divCcf.Visible = true;
                divCF.Visible = true;
            }
        }

        protected void gv_users_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditUser")
            {
                currentUserId = e.CommandArgument.ToString();
                //LoadUserForEditing(currentUserId);
                LoadUserForEditing(currentUserId, Session["pageName"].ToString());
            }
        }

        private void LoadUserForEditing(string userId, string pageName)
        {
            try
            {
                string url = "";
                if (pageName == "Temp")
                {
                    url = "TblUserRegistrationTemps/GetTblUserRegistrationTemp";
                }
                else if (pageName == "Main")
                {
                    url = "TblUserRegistrations/GetTblUserRegistration";
                }

                //HttpResponseMessage response = client.GetAsync(apiUrl + "TblUserRegistrationTemps/GetTblUserRegistrationTemp?id=" + userId).Result;
                HttpResponseMessage response = client.GetAsync(apiUrl + url + "?id=" + userId).Result;

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    dynamic user = JsonConvert.DeserializeObject(result);
                    ddl_role.SelectedValue = user.roleId;
                    //txt_emp_id.Text = user.empId;
                    txt_name.Text = user.name;
                    txt_mobile.Text = user.mobileNo;
                    txt_email.Text = user.emailId;
                    //txt_status.Text = user.status;
                    //txt_remarks.Text = user.remarks;
                    ddl_role_SelectedIndexChanged(null, null);

                    switch (user.roleId.ToString())
                    {
                        case "4": // PCCF
                            ddl_hoff.SelectedValue = user.groupId;
                            break;
                        case "5": // APCCF
                            if (user.groupRoleId == 3) // HOFF
                            {
                                rbl_reporting_to.SelectedValue = "HOFF";
                                ddl_hoff.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 4) // PCCF
                            {
                                rbl_reporting_to.SelectedValue = "PCCF";
                                ddl_pccf.SelectedValue = user.groupId;
                            }
                            break;
                        case "6": // CCF
                            if (user.groupRoleId == 3) // HOFF
                            {
                                rbl_reporting_to.SelectedValue = "HOFF";
                                ddl_hoff.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 4) // PCCF
                            {
                                rbl_reporting_to.SelectedValue = "PCCF";
                                ddl_pccf.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 5) // APCCF
                            {
                                rbl_reporting_to.SelectedValue = "APCCF";
                                ddl_apccf.SelectedValue = user.groupId;
                            }
                            ddl_zone.SelectedValue = user.zoneId.ToString();
                            break;
                        case "7": // CF
                            if (user.groupRoleId == 3) // HOFF
                            {
                                rbl_reporting_to.SelectedValue = "HOFF";
                                ddl_hoff.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 4) // PCCF
                            {
                                rbl_reporting_to.SelectedValue = "PCCF";
                                ddl_pccf.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 5) // APCCF
                            {
                                rbl_reporting_to.SelectedValue = "APCCF";
                                ddl_apccf.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 6) // CCF
                            {
                                rbl_reporting_to.SelectedValue = "CCF";
                                ddl_ccf.SelectedValue = user.groupId;
                            }
                            ddl_zone.SelectedValue = user.zoneId.ToString();
                            BindCircles(Convert.ToInt32(ddl_zone.SelectedValue));
                            ddl_circle.SelectedValue = user.circleId.ToString();
                            break;
                        case "8": // DFO
                            if (user.groupRoleId == 3) // HOFF
                            {
                                rbl_reporting_to.SelectedValue = "HOFF";
                                ddl_hoff.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 4) // PCCF
                            {
                                rbl_reporting_to.SelectedValue = "PCCF";
                                ddl_pccf.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 5) // APCCF
                            {
                                rbl_reporting_to.SelectedValue = "APCCF";
                                ddl_apccf.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 6) // CCF
                            {
                                rbl_reporting_to.SelectedValue = "CCF";
                                ddl_ccf.SelectedValue = user.groupId;
                            }
                            else if (user.groupRoleId == 7) // CF
                            {
                                rbl_reporting_to.SelectedValue = "CF";
                                ddl_cf.SelectedValue = user.groupId;
                            }
                            ddl_zone.SelectedValue = user.zoneId.ToString();

                            BindCircles(Convert.ToInt32(ddl_zone.SelectedValue));
                            ddl_circle.SelectedValue = user.circleId.ToString();

                            BindDivisions(Convert.ToInt32(ddl_circle.SelectedValue));
                            ddl_division.SelectedValue = user.divisionId.ToString();

                            break;
                    }

                    // Update UI based on selections
                    UpdateUIForSelectedRole(ddl_role.SelectedValue, rbl_reporting_to.SelectedValue);

                    // Change button text to "Update"
                    btn_save.Text = "Update";

                    //ShowSuccess("User loaded for editing");
                }
                else
                {
                    ShowError("Failed to load user data.");
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading user: " + ex.Message);
            }
        }


        protected void btn_update_Click(object sender, EventArgs e)
        {
            try
            {
                string id = Request.QueryString["id"];
                //string pageName = Request.QueryString["pageName"];

                //if (pageName == "Temp")
                //{

                //}
                //else if (pageName == "Main")
                //{
                //    using (var client = new HttpClient())
                //    {
                //        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                //        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                //        // API expects ID in query string
                //        string url = apiUrl + $"TblUserRegistrationTemps/RevertUserFromMain?id={id}";

                //        HttpResponseMessage response = client.PostAsync(url, null).Result;

                //        if (response.IsSuccessStatusCode)
                //        {

                //            string id_ = Request.QueryString["id"];


                //            //data_moveToMainTbl(id);
                //            ResetForm();
                //            ClearControls();
                //        }
                //        else
                //        {

                //        }
                //    }
                //}
                update_user(id, txt_name.Text, txt_mobile.Text, txt_email.Text, int.Parse(ddl_role.SelectedValue), Session["UserId"]?.ToString());

                string message = "User Updated Successfully.";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{message}');", true);

                btn_update.Visible = false;
                btn_save.Visible = true;
                ResetForm();
                ClearControls();

            }
            catch (Exception ex)
            {
                // Optionally log the exception
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Error updating user.');", true);
            }
        }

        public async Task<string> update_user(string UserId, string Name, string MobileNo, string EmailId, int roleId, string UpdatedBy)
        {
            try
            {
                string id = Request.QueryString["id"];
                string pageName = Request.QueryString["pageName"];

                if (pageName != "Temp" && pageName != "Main")
                {
                    return "Invalid page name.";
                }

                //string status = pageName == "Temp" ? "pending" : "edit";
                string status = pageName == "Temp" ? "pending" : "edit";

                var data = new
                {
                    UserId = UserId,
                    Name = Name,
                    MobileNo = MobileNo,
                    EmailId = EmailId,
                    RoleId = roleId,
                    Status = status,
                    //Remarks = remarks,
                    UpdatedBy = Session["UserId"]?.ToString()
                };

                var json = JsonConvert.SerializeObject(data);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblUserRegistrations/PutTblUserRegistration";

                var response = await client.PostAsync(url, content);
                var result = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    ClearControls();
                    string message = "User Updated Successfully.";
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('{message}');", true);
                }
                //return "{\"message\": \"User updated successfully.\"}";
                return result;
            }
            catch (Exception ex)
            {
                // Consider logging ex here
                return $"Error: {ex.Message}";
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

        private void DisableControls()
        {
            string a = Request.QueryString["permission"];
            if (a == "View")
            {
                txt_name.Enabled = false;
                txt_mobile.Enabled = false;
                txt_email.Enabled = false;
                //txt_emp_id.Enabled = false;
                //txt_remarks.Enabled = false;
                //txt_status.Enabled = false;
                ddl_role.Enabled = false;
                //ddl_dept.Enabled = false;
                //ddl_designation.Enabled = false;

                // Reset all dropdowns
                ddl_hoff.Enabled = false;
                ddl_pccf.Enabled = false;
                ddl_apccf.Enabled = false;
                ddl_ccf.Enabled = false;
                ddl_cf.Enabled = false;
                ddl_zone.Enabled = false;
                ddl_circle.Enabled = false;
                ddl_division.Enabled = false;


                rbl_reporting_to.Enabled = false;
                btn_save.Visible = false;

            }
            else if (a == "Edit")
            {
                txt_name.Enabled = true;
                txt_mobile.Enabled = true;
                txt_email.Enabled = false;
                //txt_emp_id.Enabled = false;
                //txt_remarks.Enabled = true;
                //txt_status.Enabled = false;
                ddl_role.Enabled = false;
                //ddl_dept.Enabled = false;
                //ddl_designation.Enabled = false;
                // Reset all dropdowns
                ddl_hoff.Enabled = false;
                ddl_pccf.Enabled = false;
                ddl_apccf.Enabled = false;
                ddl_ccf.Enabled = false;
                ddl_cf.Enabled = false;
                ddl_zone.Enabled = false;
                ddl_circle.Enabled = false;
                ddl_division.Enabled = false;
                rbl_reporting_to.Enabled = false;
                //currentUserId = "";
                //txt_name.Text = "";
                //txt_mobile.Text = "";
                //txt_email.Text = "";
                ////txt_aadhar.Text = "";
                //txt_emp_id.Text = "";
                //txt_emp_id.Enabled = false;
                //txt_remarks.Enabled = true;
                //ddl_role.SelectedIndex = 0;
                ////ddl_dept.SelectedIndex = 0;
                ////ddl_designation.SelectedIndex = 0;

                //// Reset all dropdowns
                //ddl_hoff.SelectedIndex = 0;
                //ddl_pccf.SelectedIndex = 0;
                //ddl_apccf.SelectedIndex = 0;
                //ddl_ccf.SelectedIndex = 0;
                //ddl_cf.SelectedIndex = 0;
                //ddl_zone.SelectedIndex = 0;
                //ddl_circle.SelectedIndex = 0;
                //ddl_division.SelectedIndex = 0;

                // Reset radio button list
                //rbl_reporting_to.SelectedIndex = -1;

                // Update UI
                // UpdateUIForSelectedRole(ddl_role.SelectedValue);

                // Change button text back to "Save"
                btn_save.Text = "Save";
            }
            else if (a == "Approve/Reject")
            {
                txt_name.Enabled = false;
                txt_mobile.Enabled = false;
                txt_email.Enabled = false;
                //txt_aadhar.Enabled = false;
                //txt_emp_id.Enabled = false;
                //txt_remarks.Enabled = true;
                ddl_role.Enabled = false;
                //ddl_dept.Enabled = false;
                //ddl_designation.Enabled = false;
                // Reset all dropdowns
                ddl_hoff.Enabled = false;
                ddl_pccf.Enabled = false;
                ddl_apccf.Enabled = false;
                ddl_ccf.Enabled = false;
                ddl_cf.Enabled = false;
                ddl_zone.Enabled = false;
                ddl_circle.Enabled = false;
                ddl_division.Enabled = false;

                //txt_status.Visible = false;
                rbl_reporting_to.Enabled = false;
                btn_save.Visible = true;

                //ddl_action.Enabled = true;

                btn_save.Text = "Save";
            }
        }

        protected void user_details(string id)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    // Construct the URL
                    string url = apiUrl + string.Format("TblUserRegistrationTemps/GetTblUserRegistrationTemp?id={0}", id);

                    // Make the request
                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        // Deserialize as a single object (not a list)
                        var data = JsonConvert.DeserializeObject<Dictionary<string, object>>(EmpResponse);

                        if (data != null && data.Count > 0)
                        {
                            ddl_role.SelectedValue = data.ContainsKey("roleId") ? data["roleId"]?.ToString() : "";
                            //txt_emp_id.Text = data.ContainsKey("empId") ? data["empId"]?.ToString() : "";
                            txt_name.Text = data.ContainsKey("name") ? data["name"]?.ToString() : "";
                            txt_email.Text = data.ContainsKey("emailId") ? data["emailId"]?.ToString() : "";
                            txt_mobile.Text = data.ContainsKey("mobileNo") ? data["mobileNo"]?.ToString() : "";
                            //txt_status.Text = data.ContainsKey("status") ? data["status"]?.ToString() : "";
                            //txt_remarks.Text = data.ContainsKey("remarks") ? data["remarks"]?.ToString() : "";
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, GetType(), "alert", "alert('No user data found.');", true);
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "alert", $"alert('Error: {Res.ReasonPhrase}');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error in user_details: {ex.Message}");
                ScriptManager.RegisterClientScriptBlock(this, GetType(), "alert", $"alert('An error occurred: {ex.Message}');", true);
            }
        }

        private object AddSquareBrackets(string empResponse)
        {
            throw new NotImplementedException();
        }

        //public string get_approve(string id, string remarks)
        //{
        //    try
        //    {
        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

        //            // API expects ID in query string
        //            string url = apiUrl + $"TblUserRegistrations/MigrateUserFromTemp?id={id}";

        //            HttpResponseMessage response = client.PostAsync(url, null).Result;

        //            if (response.IsSuccessStatusCode)
        //            {
        //                data_moveToMainTbl(id);
        //                ResetForm();
        //                string result = response.Content.ReadAsStringAsync().Result;
        //                return result;
        //            }
        //            else
        //            {
        //                return $"Error: {response.StatusCode} - {response.ReasonPhrase}";
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return "Not Found: " + ex.Message;
        //    }
        //}

        public string get_approve(string id, string remarks, string pageName, string status)
        {
            try
            {
                if (pageName == "Temp" && status == "pending")
                {
                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                        // API expects ID in query string
                        string url = apiUrl + $"TblUserRegistrations/MigrateUserFromTemp?id={id}";

                        HttpResponseMessage response = client.PostAsync(url, null).Result;

                        if (response.IsSuccessStatusCode)
                        {
                            data_moveToMainTbl(id);
                            ResetForm();
                            string result = response.Content.ReadAsStringAsync().Result;
                            return result;
                        }
                        else
                        {
                            return $"Error: {response.StatusCode} - {response.ReasonPhrase}";
                        }
                    }
                }
                else if (pageName == "Temp" && status == "edit")
                {
                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                        // Step 1: Get user data from Temp table
                        string getUrl = apiUrl + $"TblUserRegistrations/GetTempUserById?id={id}";
                        HttpResponseMessage getResponse = client.GetAsync(getUrl).Result;

                        if (getResponse.IsSuccessStatusCode)
                        {

                            string tempUserJson = getResponse.Content.ReadAsStringAsync().Result;

                            JObject tempUserObj = JObject.Parse(tempUserJson);
                            var content = new StringContent(JsonConvert.SerializeObject(tempUserObj), Encoding.UTF8, "application/json");


                            // Step 2: Post that data to Main Table
                            string postUrl = apiUrl + "TblUserRegistrations/UpdateMainUser";

                            HttpResponseMessage postResponse = client.PostAsync(postUrl, content).Result;

                            if (postResponse.IsSuccessStatusCode)
                            {
                                ResetForm();
                                return postResponse.Content.ReadAsStringAsync().Result;
                            }
                            else
                            {
                                return $"Error updating main: {postResponse.StatusCode} - {postResponse.ReasonPhrase}";
                            }
                        }
                        else
                        {
                            return $"Error retrieving temp data: {getResponse.StatusCode} - {getResponse.ReasonPhrase}";
                        }
                    }
                }
                else
                {
                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                        // API expects ID in query string
                        string url = apiUrl + $"TblUserRegistrationTemps/RevertUserFromMain?id={id}";

                        HttpResponseMessage response = client.PostAsync(url, null).Result;

                        if (response.IsSuccessStatusCode)
                        {

                            string id_ = Request.QueryString["id"];
                            update_user(id_, txt_name.Text, txt_mobile.Text, txt_email.Text, int.Parse(ddl_role.SelectedValue), Session["UserId"]?.ToString());

                            //data_moveToMainTbl(id);
                            ResetForm();
                            string result = response.Content.ReadAsStringAsync().Result;
                            return result;
                        }
                        else
                        {
                            return $"Error: {response.StatusCode} - {response.ReasonPhrase}";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "Not Found: " + ex.Message;
            }
        }


        protected void btn_approve_Click(object sender, EventArgs e)
        {
            try
            {
                string ID = Request.QueryString["id"];
                string pageName = Request.QueryString["pageName"];
                //get_approve(ID, txt_remarks.Text);
                //get_approve(ID, txt_remarks.Text, pageName, txt_status.Text);
            }
            catch (Exception ex)
            {
                ShowError("Error processing action: " + ex.Message);
            }
        }
        public string get_reject(string id, string remarks)
        {
            try
            {
                var userData = new
                {
                    UserId = id,
                    Remarks = remarks,
                    Status = "rejected",
                    //Status = ddl_action.SelectedValue,

                };

                var json = JsonConvert.SerializeObject(userData);
                var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblUserRegistrationTemps/PutTblUserRegistrationTemp";

                var response1 = client.PostAsync(url, data1);
                response1.Wait();

                HttpResponseMessage response = response1.Result;
                if (response.IsSuccessStatusCode)
                {
                    ResetForm();

                }
                string result = response.Content.ReadAsStringAsync().Result;
                return result;
            }
            catch (Exception ex)
            {
                return "Not Found";
            }
        }

        protected void btn_reject_Click(object sender, EventArgs e)
        {
            try
            {
                string ID = Request.QueryString["id"];
                //get_reject(ID, txt_remarks.Text);
            }
            catch (Exception ex)
            {
                ShowError("Error changing role: " + ex.Message);
            }
        }

        public string data_moveToMainTbl(string id)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    var dummyPayload = new
                    {
                        UserId = id
                    };

                    var json = JsonConvert.SerializeObject(dummyPayload);
                    var content = new StringContent(json, Encoding.UTF8, "application/json");

                    string url = apiUrl + $"TblUserRegistrationTemps/DeleteTblUserRegistrationTemp?id={id}";

                    HttpResponseMessage response = client.PostAsync(url, content).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        return result;
                    }
                    else
                    {
                        return $"Error: {response.StatusCode} - {response.ReasonPhrase}";
                    }
                }
            }
            catch (Exception ex)
            {
                return "Not Found: " + ex.Message;
            }
        }
        protected void btnback_Click(object sender, EventArgs e)
        {
            try
            {
                //string pageNameFromQueryString = Request.QueryString["pageName"];
                //if (pageNameFromQueryString == "Temp")
                //{
                //    Response.Redirect("user_Registration_List_pending.aspx");
                //}
                //else
                //{
                //    Response.Redirect("user_Registration_List.aspx");
                //}
                Response.Redirect("user_Registration_List_new.aspx");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}