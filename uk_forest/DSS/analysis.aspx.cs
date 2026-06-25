using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;
namespace uk_forest.DSS
{
    public partial class analysis : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        dbquery connectDB = new dbquery();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    
                }
            }
            catch (Exception ex)
            {

            }
        }
        public string LabelText
        {
            get { return LabelInContent.Text; }
        }
        protected void bindddlzone()
        {
            try
            {
                string q = "select distinct zone from tbl_zone_master order by zone asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddlzone.Items.Clear();
                    ddlzone.DataSource = dt;
                    ddlzone.DataValueField = "zone";
                    ddlzone.DataTextField = "zone";
                    ddlzone.DataBind();
                }
                ddlzone.Items.Insert(0, new ListItem("All", "All"));
                ddlcircle.Items.Clear();
                ddldivision.Items.Clear();
                ddlrange.Items.Clear();
                ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                ddldivision.Items.Insert(0, new ListItem("All", "All"));
                ddlrange.Items.Insert(0, new ListItem("All", "All"));
                ddlbeat.Items.Insert(0, new ListItem("All", "All"));

                //binddataaccrodingfilter();
            }
            catch (Exception ex)
            {

            }
        }

        protected void bindddlcircle()
        {
            try
            {
                string q = "select distinct circle from tbl_circle_master where zone ='" + ddlzone.SelectedValue + "' order by circle asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddlcircle.Items.Clear();
                    ddlcircle.DataSource = dt;
                    ddlcircle.DataValueField = "circle";
                    ddlcircle.DataTextField = "circle";
                    ddlcircle.DataBind();
                    ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                    ddldivision.Items.Clear();
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                    ddlrange.Items.Clear();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));
                    ddlbeat.Items.Clear();
                    ddlbeat.Items.Insert(0, new ListItem("All", "All"));
                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    ddlcircle.Items.Clear();
                    ddldivision.Items.Clear();
                    ddlcircle.Items.Insert(0, new ListItem("All", "All"));
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                    ddlrange.Items.Clear();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));
                    ddlbeat.Items.Clear();
                    ddlbeat.Items.Insert(0, new ListItem("All", "All"));

                }
                //binddataaccrodingfilter();
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }
        protected void bindddldivision()
        {
            try
            {
                string q = "select distinct division from tbl_division_master where  zone='" + ddlzone.SelectedValue + "' and circle='" + ddlcircle.SelectedValue + "' order by division asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddldivision.Items.Clear();
                    ddldivision.DataSource = dt;
                    ddldivision.DataValueField = "division";
                    ddldivision.DataTextField = "division";
                    ddldivision.DataBind();
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                    ddlrange.Items.Clear();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));
                    ddlbeat.Items.Clear();
                    ddlbeat.Items.Insert(0, new ListItem("All", "All"));
                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    //ddlcircle.Items.Insert(0, new ListItem("All", "All"));

                    ddldivision.Items.Clear();
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                    ddlrange.Items.Clear();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));
                    ddlbeat.Items.Clear();
                    ddlbeat.Items.Insert(0, new ListItem("All", "All"));
                }
                //binddataaccrodingfilter();
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }

        protected void bindddlrange()
        {
            try
            {
                string q = "select distinct range from tbl_range_master where  zone='" + ddlzone.SelectedValue + "' and circle='" + ddlcircle.SelectedValue + "'  and division='" + ddldivision.SelectedValue + "' order by range asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddlrange.Items.Clear();
                    ddlrange.DataSource = dt;
                    ddlrange.DataValueField = "range";
                    ddlrange.DataTextField = "range";
                    ddlrange.DataBind();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));
                    ddlbeat.Items.Clear();
                    ddlbeat.Items.Insert(0, new ListItem("All", "All"));

                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    //ddlcircle.Items.Insert(0, new ListItem("All", "All"));

                    ddlrange.Items.Clear();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));
                    ddlbeat.Items.Clear();
                    ddlbeat.Items.Insert(0, new ListItem("All", "All"));
                }
               // binddataaccrodingfilter();
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }

        protected void bindddlbeat()
        {
            try
            {
                string q = "select distinct beat from tbl_beat_master where  zone='" + ddlzone.SelectedValue + "' and circle='" + ddlcircle.SelectedValue + "'  and division='" + ddldivision.SelectedValue + "'and range='" + ddlrange.SelectedValue + "' order by beat asc";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    ddlbeat.Items.Clear();
                    ddlbeat.DataSource = dt;
                    ddlbeat.DataValueField = "beat";
                    ddlbeat.DataTextField = "beat";
                    ddlbeat.DataBind();
                    ddlbeat.Items.Insert(0, new ListItem("All", "All"));


                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    //ddlcircle.Items.Insert(0, new ListItem("All", "All"));


                    ddlbeat.Items.Clear();
                    ddlbeat.Items.Insert(0, new ListItem("All", "All"));
                }
                //binddataaccrodingfilter();
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }
        protected void ddlzone_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddlcircle();

                
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddlcircle_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddldivision();

                
            }
            catch (Exception ex)
            {

            }
        }


        protected void ddldivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddlrange();

                 
            }
            catch (Exception ex)
            {

            }

        }

        protected void ddlrange_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddlbeat();

               
            }
            catch (Exception ex)
            {

            }
        }


        protected void ddlbeat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                 

                
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddllevel_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if(ddllevel.SelectedValue != "")
                {
                    string layer = "tbl_" + ddllevel.SelectedValue + "_master";
                    string q = "select "+ ddllevel.SelectedValue + " from "+ layer + " order by " + ddllevel.SelectedValue + " asc";
                    DataTable dt = connectDB.executeGetData(q);
                    if(dt.Rows.Count >0)
                    {
                        ddlsection.Items.Clear();
                        ddlsection.DataSource = dt;
                        ddlsection.DataValueField = ddllevel.SelectedValue ;
                        ddlsection.DataTextField = ddllevel.SelectedValue  ;
                        ddlsection.DataBind();
                        ddlsection.Items.Insert(0, new ListItem("All", "All"));
                    }
                }

            }catch(Exception ex)
            {

            }
        }

        protected void ddlsection_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                 

            }
            catch (Exception ex)
            {

            }
        }
    }
}