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
using uk_forest.DSS;

namespace uk_forest.Forest
{
    public partial class forestmaster : System.Web.UI.MasterPage
    {
        string token_sess;
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        protected void lnkSignOut_Click(object sender, EventArgs e)
        {
            try
            {
                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.Abandon();
                Response.Redirect("../web/indexs.aspx");
            }
            catch (Exception ex)
            {
                //throw ex;
            }

        }

        
    }
}