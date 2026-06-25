using Newtonsoft.Json;
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

namespace uk_forest.Forest
{
    public partial class user_Registration_List_new : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        string pageName = "";

        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    Session["Page"] = "user_Registration_List.aspx";
        //    Session["pageName"] = "Main";
        //    if (!IsPostBack)
        //    {
        //        string userId = "";

        //        Int32 userRoleId = Convert.ToInt32(Session["RoleId"]);
        //        if (userRoleId == 1 || userRoleId == 2)
        //        {
        //            userId = "0";
        //            lbl_role.Visible = true;
        //            ddl_role.Visible = true; // Show all roles
        //        }
        //        else
        //        {
        //            userId = Session["UserId"].ToString();
        //            lbl_role.Visible = false;
        //            ddl_role.Visible = false;
        //        }
        //        BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), userId);
        //        bind_role("User");
        //    }
        //}


        protected void Page_Load(object sender, EventArgs e)
        {
            Session["Page"] = "user_Registration_List.aspx";
            Session["pageName"] = "Main";
            if (!IsPostBack)
            {
                string sessionUserId = "";

                Int32 sessionRoleId = Convert.ToInt32(Session["RoleId"]);
                if (sessionRoleId == 1 || sessionRoleId == 2)
                {
                    sessionUserId = "0";
                }
                else
                {
                    sessionUserId = Session["UserId"].ToString();
                }
                bind_role("User", sessionRoleId);
                BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), sessionRoleId, sessionUserId);
            }
        }

        //void bind_role(string role_type)
        //{
        //    try
        //    {
        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
        //            HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblRolesMasters/GetTblRolesMastersbyRoleType?roleType=" + role_type)).Result;
        //            if (Res.IsSuccessStatusCode)
        //            {
        //                var EmpResponse = Res.Content.ReadAsStringAsync().Result;

        //                DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

        //                ddl_role.Items.Clear();
        //                ddl_role.DataSource = dt;
        //                ddl_role.DataValueField = "roleId";
        //                ddl_role.DataTextField = "roleName";
        //                ddl_role.DataBind();
        //                ddl_role.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        //throw ex;
        //    }
        //}

        void bind_role(string role_type, int role_id)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblRolesMasters/GetTblRolesMastersbyRoleTypeandId?roleType=" + role_type + "&roleId=" + role_id)).Result;
                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        if(dt.Rows.Count > 0)
                        {
                            ddl_role.Items.Clear();
                            ddl_role.DataSource = dt;
                            ddl_role.DataValueField = "roleId";
                            ddl_role.DataTextField = "roleName";
                            ddl_role.DataBind();
                            ddl_role.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                //throw ex;
            }
        }

        protected void ddl_role_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(ddl_role.SelectedValue))
                {
                    //string userId = "";
                    //if (Convert.ToInt32(Session["RoleId"]) == 1 || Convert.ToInt32(Session["RoleId"]) == 2)
                    //{
                    //    userId = "0";
                    //}
                    //else
                    //{
                    //    userId = Session["UserId"].ToString();
                    //}

                    ////BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), Session["UserId"].ToString());
                    //BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), userId);


                    string sessionUserId = "";

                    Int32 sessionRoleId = Convert.ToInt32(Session["RoleId"]);
                    if (sessionRoleId == 1 || sessionRoleId == 2)
                    {
                        sessionUserId = "0";
                    }
                    else
                    {
                        sessionUserId = Session["UserId"].ToString();
                    }
                    BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), sessionRoleId, sessionUserId);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //private void BindUserGrid(int roleId = 0, string userId = "0")
        //{
        //    try
        //    {
        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
        //            HttpResponseMessage response = client.GetAsync(apiUrl + "TblUserRegistrations/GetUsersByRole?role_id=" + roleId + "&user_id=" + userId).Result;
        //            if (Convert.ToInt32(response.StatusCode) == 201)
        //            {
        //                lbl_msg_alert.Visible = true;
        //                lbl_msg_alert.Text = "No Record Found...!!!";
        //                lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
        //                gv_user.Visible = false;
        //            }
        //            else if (response.IsSuccessStatusCode)
        //            {
        //                string result = response.Content.ReadAsStringAsync().Result;
        //                DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

        //                if (dt != null)
        //                {
        //                    gv_user.DataSource = dt;
        //                    gv_user.DataBind();
        //                    gv_user.Visible = true;
        //                    lbl_msg_alert.Visible = false;
        //                }
        //                else
        //                {
        //                    lbl_msg_alert.Visible = true;
        //                    lbl_msg_alert.Text = "No Record Found...!!!";
        //                    lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
        //                    gv_user.Visible = false;
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}


        private void BindUserGrid(int selected_role_id = 0, int session_role_id = 0, string session_user_id = "0")
        {
            try
            {
                using (var client = new HttpClient())
                {
                    int currentRoleId = Convert.ToInt32(Session["RoleId"]);

                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    
                    HttpResponseMessage response = client.GetAsync(apiUrl + $"TblUserRegistrations/GetUsersByRole_Test?selected_role_id={selected_role_id}&session_role_id={session_role_id}&session_user_id={session_user_id}").Result;

                    if (Convert.ToInt32(response.StatusCode) == 201)
                    {
                        lbl_msg_alert.Visible = true;
                        lbl_msg_alert.Text = "No Record Found...!!!";
                        lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
                        gv_user.Visible = false;
                    }
                    else if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        DataTable dt = JsonConvert.DeserializeObject<DataTable>(result);

                        if (dt != null)
                        {
                            gv_user.DataSource = dt;
                            gv_user.DataBind();
                            gv_user.Visible = true;
                            lbl_msg_alert.Visible = false;
                        }
                        else
                        {
                            lbl_msg_alert.Visible = true;
                            lbl_msg_alert.Text = "No Record Found...!!!";
                            lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
                            gv_user.Visible = false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        protected void gv_users_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                gv_user.PageIndex = e.NewPageIndex;
                //this.BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), Session["UserId"].ToString());
                BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), Convert.ToInt32(Session["RoleId"]), Session["UserId"].ToString());
            }
            catch (Exception ex)
            {

            }
        }

        protected void gv_users_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Get roleId from session
                int roleId = Session["RoleId"] != null ? Convert.ToInt32(Session["RoleId"]) : 0;

                DropDownList ddl = (DropDownList)e.Row.FindControl("ddl_status_approved");
                if (ddl != null)
                {
                    if (roleId != 1 && roleId != 2)
                    {
                        ListItem hideaccess_right = ddl.Items.FindByValue("AccessRight");
                        ListItem hideDelete = ddl.Items.FindByValue("Delete");

                        if (hideaccess_right != null)
                        {
                            ddl.Items.Remove(hideaccess_right);
                            ddl.Items.Remove(hideDelete);
                        }
                    }
                    else
                    {
                        ddl.Visible = true;
                    }
                }
            }
        }

        //protected void ddl_status_approved_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        GridViewRow gvrow = (sender as DropDownList)?.NamingContainer as GridViewRow;

        //        if (gvrow != null)
        //        {
        //            DropDownList ddl_action = (DropDownList)gvrow.FindControl("ddl_status_approved");
        //            Label lblUserId = (Label)gvrow.FindControl("lbl_UserId");
        //            Label lblRoleId = (Label)gvrow.FindControl("lbl_RoleId");

        //            string userId = lblUserId?.Text;
        //            string permission = ddl_action?.SelectedValue;
        //            string pageName = "Main";
        //            Session["userid_dataKey"] = lblUserId.Text;
        //            Session["roleid_dataKey"] = lblRoleId.Text;

        //            if (ddl_action != null && !string.IsNullOrEmpty(permission))
        //            {
        //                string redirectUrl = "";

        //                if (permission == "View" || permission == "Edit")
        //                {
        //                    //redirectUrl = $"user_Registration1_test.aspx?id={userId}&permission={permission}";
        //                    redirectUrl = $"user_registration_new.aspx?id={userId}&permission={permission}&pageName={pageName}";
        //                }
        //                else if (permission == "AccessRight")
        //                {
        //                    redirectUrl = $"addAccessRight.aspx?id={userId}&permission={permission}";
        //                }
        //                else if (permission == "Delete")
        //                {
        //                    try
        //                    {
        //                        delete_user(userId);
        //                        string Message = "User Deleted Successfully.";
        //                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('{Message}');", true);
        //                        //BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), Session["UserId"].ToString());


        //                        //string sessionUserId = "";

        //                        //Int32 sessionRoleId = Convert.ToInt32(Session["RoleId"]);
        //                        //if (sessionRoleId == 1 || sessionRoleId == 2)
        //                        //{
        //                        //    sessionUserId = "0";
        //                        //}
        //                        //else
        //                        //{
        //                        //    sessionUserId = Session["UserId"].ToString();
        //                        //}
        //                        //bind_role("User", sessionRoleId);
        //                        BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), Convert.ToInt32(Session["RoleId"]), Session["UserId"].ToString());


        //                    }
        //                    catch (Exception ex)
        //                    {
        //                        ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error deleting user: {ex.Message}');", true);
        //                    }
        //                }

        //                if (!string.IsNullOrEmpty(redirectUrl))
        //                {
        //                    Response.Redirect(redirectUrl, false);
        //                    Context.ApplicationInstance.CompleteRequest();
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine($"Error: {ex.Message}");

        //        ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('An error occurred: {ex.Message}');", true);
        //    }
        //}


        protected void ddl_status_approved_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                GridViewRow gvrow = (sender as DropDownList)?.NamingContainer as GridViewRow;

                if (gvrow != null)
                {
                    DropDownList ddl_action = (DropDownList)gvrow.FindControl("ddl_status_approved");
                    Label lblUserId = (Label)gvrow.FindControl("lbl_UserId");
                    Label lblRoleId = (Label)gvrow.FindControl("lbl_RoleId");

                    string userId = lblUserId?.Text;
                    string permission = ddl_action?.SelectedValue;
                    string pageName = "Main";
                    Session["userid_dataKey"] = lblUserId.Text;
                    Session["roleid_dataKey"] = lblRoleId.Text;

                    if (ddl_action != null && !string.IsNullOrEmpty(permission))
                    {
                        string redirectUrl = "";

                        if (permission == "View" || permission == "Edit")
                        {
                            //redirectUrl = $"user_registration_new.aspx?id={userId}&permission={permission}&pageName={pageName}";
                            redirectUrl = $"user_registration.aspx?id={userId}&permission={permission}&pageName={pageName}";
                        }
                        else if (permission == "AccessRight")
                        {
                            redirectUrl = $"addAccessRight.aspx?id={userId}&permission={permission}";
                        }
                        else if (permission == "Delete")
                        {
                            try
                            {
                                delete_user(userId);
                                //string Message = "User Deleted Successfully.";
                                //ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('{Message}');", true);


                                string successScript = @"
    Swal.fire({
        title: 'User Deleted!',
        text: 'User deleted successfully.',
        icon: 'success',
        showConfirmButton: true,
        confirmButtonText: 'OK',
        background: '#f0f9ff',
        color: '#1a202c',
        iconColor: '#38a169',
        showClass: { popup: 'animate__animated animate__fadeInDown' },
        hideClass: { popup: 'animate__animated animate__fadeOutUp' }
    });";

                                ScriptManager.RegisterStartupScript(this, this.GetType(), "deleteAlert", successScript, true);



                                BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), Convert.ToInt32(Session["RoleId"]), Session["UserId"].ToString());

                            }
                            catch (Exception ex)
                            {
                                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error deleting user: {ex.Message}');", true);
                            }
                        }
                        if (!string.IsNullOrEmpty(redirectUrl))
                        {
                            Response.Redirect(redirectUrl, false);
                            Context.ApplicationInstance.CompleteRequest();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");

                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('An error occurred: {ex.Message}');", true);
            }
        }


        public async Task<string> delete_user(string UserId)
        {
            try
            {
                var data = new
                {
                    UserId = UserId
                };

                var json = JsonConvert.SerializeObject(data);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                var url = apiUrl + "TblUserRegistrations/DeleteTblUserRegistration";
                var response1 = client.PostAsync(url, content);
                response1.Wait();
                HttpResponseMessage response = response1.Result;

                if (response.IsSuccessStatusCode)
                {
                    //BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), Session["UserId"].ToString());
                    BindUserGrid(Convert.ToInt32(ddl_role.SelectedValue), Convert.ToInt32(Session["RoleId"]), Session["UserId"].ToString());
                }

                string result = await response.Content.ReadAsStringAsync();
                return result;
            }
            catch (HttpRequestException httpEx)
            {
                Console.WriteLine($"HTTP Request Error: {httpEx.Message}");
                return "HTTP Request Error: " + httpEx.Message;
            }
            catch (JsonSerializationException jsonEx)
            {
                Console.WriteLine($"JSON Serialization Error: {jsonEx.Message}");
                return "JSON Serialization Error: " + jsonEx.Message;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An unexpected error occurred: {ex.Message}");
                return "Error: " + ex.Message;
            }
        }

    }
}