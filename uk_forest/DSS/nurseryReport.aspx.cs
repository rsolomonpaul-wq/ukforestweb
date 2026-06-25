using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.DSS
{
    public partial class nurseryReport : System.Web.UI.Page
    {
        dbquery connectDB = new dbquery();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    if (Session["UserId"] != null && Session["UserId"].ToString() != "")
                    {
                        string role = Session["RoleId"].ToString();
                        string userid = Session["UserId"].ToString();
                        string password = Session["Password"].ToString();

                        InitializeReport(role, userid, password);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        public string LabelText
        {
            get { return LabelInContent.Text; }
        }

        protected void InitializeReport(string role, string userid, string password)
        {
            try
            {
                string query = "";
                if (role == "1" || role == "2")
                {
                    query = "select * from tbl_user_master where role_id='" + role + "' and user_id='" + userid + "' and password = '" + password + "'";
                    AdminLevel(query);
                }
                else
                {
                    query = @"SELECT ur.*, zm.zone, cm.circle, dm.division 
                             FROM tbl_user_registration ur 
                             LEFT JOIN tbl_zone_master zm ON ur.zone_id = zm.id 
                             LEFT JOIN tbl_circle_master cm ON ur.circle_id = cm.id 
                             LEFT JOIN tbl_division_master dm ON ur.division_id = dm.id 
                             WHERE ur.role_id = '" + role + "' AND ur.user_id = '" + userid + "' AND ur.password = '" + password + "'";
                    UserLevel(query, userid);
                }
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        protected void AdminLevel(string query)
        {
            try
            {
                DataTable dt = connectDB.executeGetData(query);
                if (dt.Rows.Count > 0)
                {
                    BindZone();
                }
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        protected void UserLevel(string query, string userid)
        {
            try
            {
                DataTable dt = connectDB.executeGetData(query);
                if (dt.Rows.Count > 0)
                {
                    BindZone();

                    string userZone = dt.Rows[0]["zone"].ToString();
                    string userCircle = dt.Rows[0]["circle"].ToString();
                    string userDivision = dt.Rows[0]["division"].ToString();

                    // Set user-specific filters via JavaScript
                    string script = "";

                    if (!string.IsNullOrEmpty(userZone))
                    {
                        script += $"document.getElementById('{ddlZone.ClientID}').value = '{userZone}'; updateCircles();";
                    }

                    // Disable dropdowns based on user role
                    string[] parts = userid.Split('-');
                    string userType = parts[0];

                    switch (userType)
                    {
                        case "RO":
                            script += $"document.getElementById('{ddlRange.ClientID}').disabled = true;";
                            script += $"document.getElementById('{ddlDivision.ClientID}').disabled = true;";
                            script += $"document.getElementById('{ddlCircle.ClientID}').disabled = true;";
                            script += $"document.getElementById('{ddlZone.ClientID}').disabled = true;";
                            break;
                        case "DFO":
                            script += $"document.getElementById('{ddlDivision.ClientID}').disabled = true;";
                            script += $"document.getElementById('{ddlCircle.ClientID}').disabled = true;";
                            script += $"document.getElementById('{ddlZone.ClientID}').disabled = true;";
                            break;
                        case "CCF":
                            script += $"document.getElementById('{ddlZone.ClientID}').disabled = true;";
                            break;
                        case "CF":
                            script += $"document.getElementById('{ddlCircle.ClientID}').disabled = true;";
                            script += $"document.getElementById('{ddlZone.ClientID}').disabled = true;";
                            break;
                    }

                    if (!string.IsNullOrEmpty(script))
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "setUserFilters", script, true);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        protected void BindZone()
        {
            try
            {
                string query = "SELECT DISTINCT zone FROM tbl_zone_master ORDER BY zone ASC";
                DataTable dt = connectDB.executeGetData(query);

                ddlZone.Items.Clear();
                ddlZone.Items.Insert(0, new ListItem("All Zones", ""));

                if (dt.Rows.Count > 0)
                {
                    ddlZone.DataSource = dt;
                    ddlZone.DataTextField = "zone";
                    ddlZone.DataValueField = "zone";
                    ddlZone.DataBind();
                    ddlZone.Items.Insert(0, new ListItem("All Zones", ""));
                }

                // Clear dependent dropdowns
                ddlCircle.Items.Clear();
                ddlCircle.Items.Insert(0, new ListItem("All Circles", ""));
                ddlDivision.Items.Clear();
                ddlDivision.Items.Insert(0, new ListItem("All Divisions", ""));
                ddlRange.Items.Clear();
                ddlRange.Items.Insert(0, new ListItem("All Ranges", ""));
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        protected void BindCircle()
        {
            try
            {
                string zone = ddlZone.SelectedValue;
                string query = "SELECT DISTINCT circle FROM tbl_circle_master";

                if (!string.IsNullOrEmpty(zone))
                {
                    query += " WHERE zone = '" + zone + "'";
                }
                query += " ORDER BY circle ASC";

                DataTable dt = connectDB.executeGetData(query);

                ddlCircle.Items.Clear();
                ddlCircle.Items.Insert(0, new ListItem("All Circles", ""));

                if (dt.Rows.Count > 0)
                {
                    ddlCircle.DataSource = dt;
                    ddlCircle.DataTextField = "circle";
                    ddlCircle.DataValueField = "circle";
                    ddlCircle.DataBind();
                    ddlCircle.Items.Insert(0, new ListItem("All Circles", ""));
                }

                // Clear dependent dropdowns
                ddlDivision.Items.Clear();
                ddlDivision.Items.Insert(0, new ListItem("All Divisions", ""));
                ddlRange.Items.Clear();
                ddlRange.Items.Insert(0, new ListItem("All Ranges", ""));
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        protected void BindDivision()
        {
            try
            {
                string circle = ddlCircle.SelectedValue;
                string query = "SELECT DISTINCT division FROM tbl_division_master";

                if (!string.IsNullOrEmpty(circle))
                {
                    query += " WHERE circle = '" + circle + "'";
                }
                query += " ORDER BY division ASC";

                DataTable dt = connectDB.executeGetData(query);

                ddlDivision.Items.Clear();
                ddlDivision.Items.Insert(0, new ListItem("All Divisions", ""));

                if (dt.Rows.Count > 0)
                {
                    ddlDivision.DataSource = dt;
                    ddlDivision.DataTextField = "division";
                    ddlDivision.DataValueField = "division";
                    ddlDivision.DataBind();
                    ddlDivision.Items.Insert(0, new ListItem("All Divisions", ""));
                }

                // Clear dependent dropdown
                ddlRange.Items.Clear();
                ddlRange.Items.Insert(0, new ListItem("All Ranges", ""));
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        protected void BindRange()
        {
            try
            {
                string division = ddlDivision.SelectedValue;
                string query = "SELECT DISTINCT range FROM tbl_range_master";

                if (!string.IsNullOrEmpty(division))
                {
                    query += " WHERE division = '" + division + "'";
                }
                query += " ORDER BY range ASC";

                DataTable dt = connectDB.executeGetData(query);

                ddlRange.Items.Clear();
                ddlRange.Items.Insert(0, new ListItem("All Ranges", ""));

                if (dt.Rows.Count > 0)
                {
                    ddlRange.DataSource = dt;
                    ddlRange.DataTextField = "range";
                    ddlRange.DataValueField = "range";
                    ddlRange.DataBind();
                    ddlRange.Items.Insert(0, new ListItem("All Ranges", ""));
                }
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        // Event Handlers
        protected void ddlZone_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindCircle();
        }

        protected void ddlCircle_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindDivision();
        }

        protected void ddlDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindRange();
        }

        protected void ddlRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Just postback, JavaScript will handle filtering
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // JavaScript will handle the filtering
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlZone.SelectedIndex = 0;
            BindCircle();
        }
    }
}