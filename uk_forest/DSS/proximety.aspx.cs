using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.DSS
{
    public partial class proximety : System.Web.UI.Page
    {
        dbquery connectDB = new dbquery();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    bindzone();
                }

            }
            catch (Exception ex)
            {

            }
        }

        protected void bindzone()
        {
            try
            {
                string q = "select zone from tbl_zone_master order by zone";
                DataTable dt = connectDB.executeGetData(q);
                ddlzone.Items.Clear();
                if (dt.Rows.Count > 0)
                {
                    ddlzone.DataSource = dt;
                    ddlzone.DataValueField = "zone";
                    ddlzone.DataTextField = "zone";
                    ddlzone.DataBind();
                }
                // Optional: Add default item
                ddlzone.Items.Insert(0, new ListItem(" Select Zone ", "0"));
                ddlcircle.Items.Clear();
                ddlcircle.Items.Insert(0, new ListItem(" Select Circel ", "0"));
                ddldivision.Items.Clear();
                ddldivision.Items.Insert(0, new ListItem(" Select Division ", "0"));
                ddlrange.Items.Clear();
                ddlrange.Items.Insert(0, new ListItem(" Select Range ", "0"));
            }
            catch (Exception ex)
            {

            }
        } 
        
        protected void bindcircle(string zone)
        {
            try
            {
                string q = "select circle from tbl_circle_master where zone = '"+zone+"'order by circle";
                DataTable dt = connectDB.executeGetData(q);
                ddlcircle.Items.Clear();
                if (dt.Rows.Count > 0)
                {
                    ddlcircle.DataSource = dt;
                    ddlcircle.DataValueField = "circle";
                    ddlcircle.DataTextField = "circle";
                    ddlcircle.DataBind();
                }
                // Optional: Add default item
                ddlcircle.Items.Insert(0, new ListItem(" Select Circel ", "0"));
                ddldivision.Items.Clear();
                ddldivision.Items.Insert(0, new ListItem(" Select Division ", "0"));
                ddlrange.Items.Clear();
                ddlrange.Items.Insert(0, new ListItem(" Select Range ", "0"));
            }
            catch (Exception ex)
            {

            }
        }
        
        protected void bindrange(string division,string circle)
        {
            try
            {
                string q = "select range from tbl_range_master where circle='"+ circle + "' and division='" + division + "' order by range";
                DataTable dt = connectDB.executeGetData(q);
                ddlrange.Items.Clear();
                if (dt.Rows.Count > 0)
                {
                    ddlrange.DataSource = dt;
                    ddlrange.DataValueField = "range";
                    ddlrange.DataTextField = "range";
                    ddlrange.DataBind();
                }
                // Optional: Add default item
                ddlrange.Items.Insert(0, new ListItem(" Select Range ", "0"));
            }
            catch (Exception ex)
            {

            }
        }protected void binddivision(string circle)
        {
            try
            {
                string q = "select division from tbl_division_master  where circle='" + circle + "'  order by division";
                DataTable dt = connectDB.executeGetData(q);
                ddldivision.Items.Clear();
                if (dt.Rows.Count > 0)
                {
                    ddldivision.DataSource = dt;
                    ddldivision.DataValueField = "division";
                    ddldivision.DataTextField = "division";
                    ddldivision.DataBind();
                }
                // Optional: Add default item

                ddldivision.Items.Insert(0, new ListItem(" Select Division ", "0"));
                ddlrange.Items.Clear();
                ddlrange.Items.Insert(0, new ListItem(" Select Range ", "0"));
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddlrange_SelectedIndexChanged(object sender, EventArgs e)
        {
            callmap();
        }

        protected void ddlcircle_SelectedIndexChanged(object sender, EventArgs e)
        {
            binddivision(ddlcircle.SelectedValue);
            ddlrange.Items.Clear();
            ddlrange.Items.Insert(0, new ListItem(" Select Range ", "0"));
            callmap();
        }

        protected void ddldivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindrange(ddldivision.SelectedValue,ddlcircle.SelectedValue);
            callmap();
        }

        private void callmap()
        {
            string script1 = "applyfilter();";
            ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script1, true);
        }

        protected void ddlzone_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindcircle(ddlzone.SelectedValue);
            callmap();
        }
    }
}