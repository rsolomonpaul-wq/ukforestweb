using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class addAccessRight : System.Web.UI.Page
    {
        string token_sess;
        string query = "";
        //DataSet ObjDB = new DataSet();
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //if ((Session["token"] == null))
                //{
                //    Response.Redirect("~/Index.aspx");
                //}
                string a = Session["userid_dataKey"].ToString();
                int b = Convert.ToInt32(Session["roleid_dataKey"]);

                // token_sess = Session["token"].ToString();
                if (!IsPostBack)
                {
                    user_details(a);
                    bindModule();
                    userAccess(Session["userid_dataKey"].ToString(), Convert.ToInt32(Session["roleid_dataKey"]));
                }
            }
            catch (Exception ex)
            {

            }
        }
        void bindModule()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblModules/GetTblModules")).Result;

                    if (Res.IsSuccessStatusCode)
                    {

                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddl_module_list.Items.Clear();
                        ddl_module_list.DataSource = dt;
                        ddl_module_list.DataValueField = "ModuleId";
                        ddl_module_list.DataTextField = "ModuleName";
                        ddl_module_list.DataBind();
                        ddl_module_list.Items.Insert(0, new System.Web.UI.WebControls.ListItem("--Select--", "All"));
                    }
                }
            }
            catch (Exception ex)
            {
                //throw ex;
            }
        }
        protected void ddl_module_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                //string username = txt_user_name.Text;
                string username = Session["userid_dataKey"].ToString();
                string mId = ddl_module_list.SelectedValue;
                bind_sub_modules(username, mId);
                bind_sub_modules_not(username, mId);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        void bind_sub_modules(string username, string mId)
        {

            try
            {
                using (var client = new HttpClient())
                {
                    var data = new
                    {
                        username = username,
                        module_id = ddl_module_list.SelectedValue
                    };

                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblSubModules/AccessRightSubModuleBind?username=" + username + "&mId=" + mId)).Result;

                    if (Res.IsSuccessStatusCode)
                    {

                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));
                        ListBox2.DataSource = dt;
                        ListBox2.DataValueField = "sub_module_id";
                        ListBox2.DataTextField = "sub_module_name";
                        ListBox2.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                //throw ex;
            }
        }
        void bind_sub_modules_not(string username, string ModuleId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var data = new
                    {
                        username = username,
                        module_id = ddl_module_list.SelectedValue
                    };

                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblSubModules/GetUserNotAccessRightSm?UserId=" + username + "&ModuleId=" + ModuleId)).Result;
                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));
                        ListBox1.DataSource = dt;

                        ListBox1.DataValueField = "subModuleId";
                        ListBox1.DataTextField = "subModuleName";
                        ListBox1.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                //throw ex;
            }
        }
        protected void userAccess(string username, int roleId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblAccessRights/Get_access_right_grid_for_user?username=" + username + "&roleId=" + roleId)).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        if (dt.Rows.Count > 0)
                        {
                            lbl_msg_alert.Visible = false;
                            grid_accessRight_name.Visible = true;
                            grid_accessRight_name.DataSource = dt;
                            grid_accessRight_name.DataBind();
                        }
                        else
                        {
                            lbl_msg_alert.Visible = true;
                            lbl_msg_alert.ForeColor = System.Drawing.Color.Red;
                            lbl_msg_alert.Text = "Data Not Found !!!";
                            grid_accessRight_name.Visible = false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                //throw ex;
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
                    string url = apiUrl + string.Format("TblAccessRights/GetUsername?id={0}", id);

                    // Make the request
                    HttpResponseMessage Res = client.GetAsync(url).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        if (!string.IsNullOrEmpty(EmpResponse))
                        {
                            // Deserialize and handle the response
                            DataTable dt = JsonConvert.DeserializeObject<DataTable>(AddSquareBrackets(EmpResponse).ToString());
                            if (dt != null && dt.Rows.Count > 0)
                            {
                                txtrole.Text = dt.Rows[0]["roleName"].ToString();
                                //txt_user_name.Text = dt.Rows[0]["Username"].ToString();
                                //txt_user_name.Text = dt.Rows[0]["UserId"].ToString();
                                txt_user_name.Text = dt.Rows[0]["email"].ToString();
                                txt_email.Text = dt.Rows[0]["email"].ToString();
                            }
                        }
                        else
                        {
                            // Handle case where response is empty or null
                            ScriptManager.RegisterClientScriptBlock(this, GetType(), "alert", "alert('No user data found.');", true);
                        }
                    }
                    else
                    {
                        // Log error or show appropriate message
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "alert", $"alert('Error: {Res.ReasonPhrase}');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception details to troubleshoot
                Console.WriteLine($"Error in user_details: {ex.Message}");
                ScriptManager.RegisterClientScriptBlock(this, GetType(), "alert", $"alert('An error occurred: {ex.Message}');", true);
            }
        }
        //protected void chkAll_CheckedChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        foreach (ListItem item in chkAccess.Items)
        //        {
        //            item.Selected = chkAll.Checked;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}
        protected void btnAssign_Click(object sender, EventArgs e)
        {
            string user_id = Session["userid_dataKey"].ToString();
            //var userid_supper = Session["user_id"];
            int role_id = Convert.ToInt32(Session["roleid_dataKey"]);
            try
             {
                delete_access_rights(ddl_module_list.SelectedValue, user_id);
                for (var i = 0; i < ListBox1.Items.Count; i++)
                {
                    var data = new
                    {
                        UserId = user_id,
                        ModuleId = ddl_module_list.SelectedValue.ToString(),
                        SubModuleId = ListBox1.Items[i].Value,
                        CreatedBy = "Admin",
                        AddAccess = true,
                        EditAccess = true,
                        ViewAccess = true,
                        DeleteAccess = true,
                    };

                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                        var url = apiUrl + "TblAccessRights/PostTblAccessRight";

                        var json = JsonConvert.SerializeObject(data);
                        var data1 = new StringContent(json, Encoding.UTF8, "application/json");
                        var response1 = client.PostAsync(url, data1);
                        response1.Wait();
                        HttpResponseMessage response = response1.Result;

                        if (response.IsSuccessStatusCode)
                        {
                            Console.Write("Success");
                        }
                        else
                            Console.Write("Error");
                    }
                }
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "btn", "<script type = 'text/javascript'>alert('Access Right Create Successfully');</script>");
                userAccess(Session["userid_dataKey"].ToString(), Convert.ToInt32(Session["roleid_dataKey"]));
            }
            catch (Exception ex)
            {
                throw ex;
            }

            Response.Redirect("addAccessRight.aspx");
        }
        private string delete_access_rights(string module_id, string username)
        {
            try
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                HttpResponseMessage response = client.GetAsync(apiUrl + string.Format("TblAccessRights/DeleteAccessRight/" + module_id + "/" + username)).Result;

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    return result;
                }
                else
                {
                    // Handle unsuccessful response (optional)
                    return "Failed to delete access rights. Status code: " + response.StatusCode;
                }
            }
            catch (Exception ex)
            {
                return "Something went wrong !!!";
            }
        }
        protected void bind_Access_data()
        {

        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                List<ListItem> list1 = new List<ListItem>();

                if (ListBox2.SelectedIndex >= 0)
                {
                    for (int i = 0; i < ListBox2.Items.Count; i++)
                    {
                        if (ListBox2.Items[i].Selected)
                        {
                            ListBox1.Items.Add(ListBox2.Items[i]);
                        }
                    }
                }
                else
                {

                }
                foreach (ListItem item in ListBox2.Items)
                {
                    if (item.Selected)
                    {
                        list1.Add(item);
                    }
                }
                foreach (ListItem item in list1)
                {
                    ListBox2.Items.Remove(item);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        protected void btn_Back_Click(object sender, EventArgs e)
        {
            try
            {

                //Response.Redirect("~/uk_forest/Forest/user_Registration_List.aspx");
                //Response.Redirect("user_Registration_List.aspx");
                Response.Redirect("user_Registration_List_new.aspx");
            }
            catch (Exception ex)
            {
                //throw ex;
            }
        }
        protected void btnback_Click(object sender, EventArgs e)
        {
            try
            {
                List<ListItem> list2 = new List<ListItem>();

                if (ListBox1.SelectedIndex >= 0)
                {
                    for (int i = 0; i < ListBox1.Items.Count; i++)
                    {
                        if (ListBox1.Items[i].Selected)
                        {
                            ListBox2.Items.Add(ListBox1.Items[i]);
                        }
                    }
                }
                else
                {

                }
                foreach (ListItem item in ListBox1.Items)
                {
                    if (item.Selected)
                    {
                        list2.Add(item);
                    }
                }
                foreach (ListItem item in list2)
                {
                    ListBox1.Items.Remove(item);
                }
            }
            catch (Exception ex)
            {
                //throw ex;
            }
        }
        protected void grid_accessRight_name_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                grid_accessRight_name.PageIndex = e.NewPageIndex;
                userAccess(Session["userid_dataKey"].ToString(), Convert.ToInt32(Session["roleid_dataKey"]));
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('An error occurred while changing the page index.')", true);
            }
        }

        private string AddSquareBrackets(string input)
        {
            if (!input.StartsWith("["))
            {
                input = "[" + input;
            }
            if (!input.EndsWith("]"))
            {
                input = input + "]";
            }
            return input;
        }

    }
}