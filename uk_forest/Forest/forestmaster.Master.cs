using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class forestmaster : System.Web.UI.MasterPage
    {
        string token_sess;
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string apiUrl = ConfigurationManager.AppSettings["sentinel2fcckey"];
                string apiUrl1 = ConfigurationManager.AppSettings["sentinel2ncckey"];
                sentinel2fcckey.Value = apiUrl;
                sentinel2ncckey.Value = apiUrl1;

                if (!string.IsNullOrEmpty(Session["UserId"]?.ToString()))
                {
                    user_access(Session["UserId"].ToString());
                }
                else
                {
                    Response.Redirect("../web/index.aspx");
                }

            }
        }

        protected void lnkSignOut_Click(object sender, EventArgs e)
        {
            try
            {
                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.Abandon();
                Response.Redirect("../web/index.aspx");
            }
            catch (Exception ex)
            {
                //throw ex;
            }

        }

        void user_access(string username)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", Session["token"].ToString());

                    // HttpResponseMessage Res = client.GetAsync(apiUrl + "TblAccessRights/GetUsername?id=" + username).Result;
                    HttpResponseMessage Res = client.GetAsync(apiUrl + "TblAccessRights/GetTblAccessRight?UserId=" + username).Result;
                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                        // Parse JSON into JArray
                        JArray jsonArray = JArray.Parse(EmpResponse);

                        // Convert JArray to DataTable
                        DataTable dt = JsonConvert.DeserializeObject<DataTable>(jsonArray.ToString());

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            foreach (DataRow dr in dt.Rows)
                            {
                                bool is_active = Convert.ToBoolean(dr["IsActive"]);
                                string mid = dr["ModuleId"].ToString();
                                string sm_id = dr["SubModuleId"].ToString();

                                if (is_active)
                                {
                                    Control myControl1 = FindControl(mid);
                                    if (myControl1 != null)
                                        myControl1.Visible = true;

                                    Control myControl2 = FindControl(sm_id);
                                    if (myControl2 != null)
                                        myControl2.Visible = true;
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log or handle the error appropriately
                // e.g., System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

    }
}