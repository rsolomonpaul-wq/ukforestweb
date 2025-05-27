using Npgsql;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.GIS
{
    public partial class maps : System.Web.UI.Page
    {
       dbquery connectDB=new dbquery();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    bindlayers();
                }

            }
            catch (Exception ex)
            {

            }
        }

        protected void bindlayers()
        {
            try
            {
                string q = "select displayname,tablename from tbl_data_layers where displayname is not null";
               DataTable dt= connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddllayer.DataSource = dt;
                    ddllayer.DataValueField = "tablename";
                    ddllayer.DataTextField = "displayname";
                    ddllayer.DataBind();
                }
                // Optional: Add default item
                ddllayer.Items.Insert(0, new ListItem("-- Select Layer --", "0"));
                ddlattrubutename.Items.Insert(0, new ListItem("-- Select Attribute --", "0"));
                ddlattributevalue.Items.Insert(0, new ListItem("-- Select Attribute Value --", "0"));
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddllayer_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string q = "SELECT column_name FROM information_schema.columns WHERE table_name = '"+ddllayer.SelectedValue+"'  AND table_schema = 'public' and column_name not in ('geom','gid'); ";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddlattrubutename.DataSource = dt;
                    ddlattrubutename.DataValueField = "column_name";
                    ddlattrubutename.DataTextField = "column_name";
                    ddlattrubutename.DataBind();
                }
                // Optional: Add default item
                ddlattrubutename.Items.Insert(0, new ListItem("-- Select Attribute --", "0"));
                querybuilderdivid.Style.Add("display", "block");
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddlattrubutename_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string q = "select distinct "+ddlattrubutename.SelectedValue+" from "+ddllayer.SelectedValue+"";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddlattributevalue.DataSource = dt;
                    ddlattributevalue.DataValueField = ddlattrubutename.SelectedValue;
                    ddlattributevalue.DataTextField = ddlattrubutename.SelectedValue;
                    ddlattributevalue.DataBind();
                }
                querybuilderdivid.Style.Add("display", "block");
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }

        
    }
}