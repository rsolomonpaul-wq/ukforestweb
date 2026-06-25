using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.DSS
{
    public partial class assetDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public string LabelText
        {
            get { return LabelInContent.Text; }
        }
    }
}