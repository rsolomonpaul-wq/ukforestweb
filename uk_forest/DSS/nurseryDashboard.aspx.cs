using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.DSS
{
    public partial class nurseryDashboard : System.Web.UI.Page
    {
        dbquery connectDB = new dbquery();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string role = Session["RoleId"].ToString();
                string userid = Session["UserId"].ToString();
                string password = Session["Password"].ToString();

                getuser(role, userid, password);
               // BindZone();
            }
        }
        protected void getuser(string role, string userid, string password)
        {
            try
            {
                string query = "";
                if (role == "1" || role == "2")
                {
                    query = "select * from tbl_user_master where role_id='" + role + "' and user_id='" + userid + "' and password = '" + password + "'";
                    adminlevel(query, userid);
                }
                else
                {
                    query = "SELECT ur.*,zm.zone,cm.circle,dm.division,rm.range FROM tbl_user_registration ur LEFT JOIN tbl_zone_master zm ON ur.zone_id = zm.id LEFT JOIN tbl_circle_master cm ON ur.circle_id = cm.id LEFT JOIN tbl_division_master dm ON ur.division_id = dm.id LEFT JOIN tbl_range_master rm ON ur.range_id = rm.id WHERE  ur.role_id = '" + role + "' AND ur.user_id = '" + userid + "'  AND ur.password = '" + password + "';";
                    userlevel(query, userid);
                }

            }
            catch (Exception ex)
            {

            }
        }

        protected void adminlevel(string q, string userid)
        {
            try
            {

                // (Optional) use the provided query for further logic
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    BindZone();
                    calljs();
                    ddlcircle.Items.Clear();
                    ddlcircle.Items.Insert(0, new ListItem("All", "All"));

                    ddldivision.Items.Clear();
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));

                    ddlrange.Items.Clear();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));

                }
            }
            catch (Exception ex)
            {
                // Log exception (don't ignore it in production)
                Console.WriteLine("Error in userlevel: " + ex.Message);
            }
        }
        protected void userlevel(string q, string userid)
        {
            try
            {

                // (Optional) use the provided query for further logic
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    BindZone();
                    if (dt.Rows[0]["zone"].ToString() != "")
                    {

                        ddlzone.SelectedValue = dt.Rows[0]["zone"].ToString();
                    }
                    BindCircle();
                    ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                    if (dt.Rows[0]["circle"].ToString() != "")
                    {

                        ddlcircle.SelectedValue = dt.Rows[0]["circle"].ToString();
                        
                       

                    }
                    BindDivision();
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                    if (dt.Rows[0]["division"].ToString() != "")
                    {

                        ddldivision.SelectedValue = dt.Rows[0]["division"].ToString();

                        
                       

                       
                    }
                    //if (dt.Rows[0]["range"].ToString() != "")
                    //{
                    //    bindddldivision();
                    //    division.SelectedValue = dt.Rows[0]["division"].ToString();
                    //}

                    BindRange();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));
                    if (dt.Rows[0]["range"].ToString() != "")
                    {

                        ddlrange.SelectedValue = dt.Rows[0]["range"].ToString();
                      
                    }
                   // bindddlplantation();
                    //ddlzone.SelectedValue = dt.Rows[0]["zone"].ToString();
                    string[] parts = userid.Split('-');
                    string userType = parts[0];
                    string userId = parts.Length > 1 ? parts[1] : "";

                    if (userType == "RO")
                    {

                        ddlrange.Enabled = false;
                        ddldivision.Enabled = false;
                        ddlcircle.Enabled = false;
                        ddlzone.Enabled = false;

                    }
                    else if (userType == "DFO")
                    {
                        ddldivision.Enabled = false;
                        ddlcircle.Enabled = false;
                        ddlzone.Enabled = false;

                    }
                    else if (userType == "SDO")
                    {
                    }
                    else if (userType == "CCF")
                    {
                        ddlzone.Enabled = false;
                    }
                    else if (userType == "PCCF")
                    {
                    }
                    else if (userType == "CF")
                    {
                        ddlcircle.Enabled = false;
                        ddlzone.Enabled = false;
                    }
                    else
                    {
                        Console.WriteLine("Unknown user type: " + userType);
                    }

                    calljs();
                }
            }
            catch (Exception ex)
            {
                // Log exception (don't ignore it in production)
                Console.WriteLine("Error in userlevel: " + ex.Message);
            }
        }

        private void BindZone()
        {
            string q = @"SELECT DISTINCT zone 
                         FROM tbl_zone_master 
                         ORDER BY zone";

            DataTable dt = connectDB.executeGetData(q);

            ddlzone.Items.Clear();
            ddlzone.DataSource = dt;
            ddlzone.DataTextField = "zone";
            ddlzone.DataValueField = "zone";
            ddlzone.DataBind();
            ddlzone.Items.Insert(0, new ListItem("All", "All"));

           
            //calljs();
        }

        private void BindCircle()
        {
            ddlcircle.Items.Clear();

            if (ddlzone.SelectedValue == "All")
            {
                ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                return;
            }

            string q = @"SELECT DISTINCT circle
                         FROM tbl_circle_master
                         WHERE zone = '" + ddlzone.SelectedValue + @"'
                         ORDER BY circle";

            DataTable dt = connectDB.executeGetData(q);

            ddlcircle.DataSource = dt;
            ddlcircle.DataTextField = "circle";
            ddlcircle.DataValueField = "circle";
            ddlcircle.DataBind();

            if (ddlzone.SelectedValue == "All")
            {
                ddlcircle.Items.Insert(0, new ListItem("All", "All"));
            }
        
        }

        private void BindDivision()
        {
            ddldivision.Items.Clear();

            if (ddlzone.SelectedValue == "All" ||
                ddlcircle.SelectedValue == "All")
            {
                ddldivision.Items.Insert(0, new ListItem("All", "All"));
                return;
            }

            string q = @"SELECT DISTINCT division
                         FROM tbl_division_master
                         WHERE zone = '" + ddlzone.SelectedValue + @"'
                           AND circle = '" + ddlcircle.SelectedValue + @"'
                         ORDER BY division";

            DataTable dt = connectDB.executeGetData(q);

            ddldivision.DataSource = dt;
            ddldivision.DataTextField = "division";
            ddldivision.DataValueField = "division";
            ddldivision.DataBind();
            ////ddldivision.Items.Insert(0, new ListItem("All", "All"));
        }

        private void BindRange()
        {
            ddlrange.Items.Clear();

            if (ddlzone.SelectedValue == "All" ||
                ddlcircle.SelectedValue == "All" ||
                ddldivision.SelectedValue == "All")
            {
                ddlrange.Items.Insert(0, new ListItem("All", "All"));
                return;
            }

            string q = @"SELECT DISTINCT range
                         FROM tbl_range_master
                         WHERE zone = '" + ddlzone.SelectedValue + @"'
                           AND circle = '" + ddlcircle.SelectedValue + @"'
                           AND division = '" + ddldivision.SelectedValue + @"'
                         ORDER BY range";

            DataTable dt = connectDB.executeGetData(q);

            ddlrange.DataSource = dt;
            ddlrange.DataTextField = "range";
            ddlrange.DataValueField = "range";
            ddlrange.DataBind();
            //ddlrange.Items.Insert(0, new ListItem("All", "All"));
        }

        private void calljs()
        {
            try
            {
                //string script1 = "applyFilters();";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script1, true);
                //ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), "applyFilter();", true);
                ScriptManager.RegisterStartupScript(
                       this,
                       GetType(),
                       Guid.NewGuid().ToString(),
                       "applyFilter();",
                       true);
            }
            catch (Exception ex)
            {

            }
        }
        protected void zone_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindCircle();
          
            ddlcircle.Items.Insert(0, new ListItem("All", "All"));

            ddldivision.Items.Clear();
            ddldivision.Items.Insert(0, new ListItem("All", "All"));

            ddlrange.Items.Clear();
            ddlrange.Items.Insert(0, new ListItem("All", "All"));
            calljs();
        }

        protected void circle_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindDivision();
          
            ddldivision.Items.Insert(0, new ListItem("All", "All"));

            ddlrange.Items.Clear();
            ddlrange.Items.Insert(0, new ListItem("All", "All"));
            calljs();
        }

        protected void division_SelectedIndexChanged(object sender, EventArgs e)
        {

            BindRange();
           
            ddlrange.Items.Insert(0, new ListItem("All", "All"));
            calljs();
        }

        protected void range_SelectedIndexChanged(object sender, EventArgs e)
        {
            string zone = ddlzone.SelectedValue;
            string circle = ddlcircle.SelectedValue;
            string division = ddldivision.SelectedValue;
            string range = ddlrange.SelectedValue;
            calljs();

            // Add your logic here
        }
    }
}