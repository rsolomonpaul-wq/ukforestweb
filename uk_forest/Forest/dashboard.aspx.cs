using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.Forest
{
    public partial class dashboard : System.Web.UI.Page
    {
        dbquery connectDB = new dbquery();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                     
                    bindddlzone();
                     
                     bindddlcircle();
                    bindddldivision();
                }
            }
            catch (Exception ex)
            {

            }
        }
        protected void bindddlzone()
        {
            try
            {
                string q = "select zone,rf_area_sq_km,nf_area_sq_km from tbl_zone_master";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    grd_zone.DataSource = dt;
                    grd_zone.DataBind();
                }
                
            }
            catch (Exception ex)
            {

            }
        }
        protected void bindddlcircle()
        {
            try
            {
                string q = "select zone, circle ,rf_area_sq_km,nf_area_sq_km from tbl_circle_master";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    grd_circle.DataSource = dt;
                    grd_circle.DataBind();
                }
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
                string q = "select zone, circle,division ,rf_area_sq_km,nf_area_sq_km from tbl_division_master order by zone,circle";
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    grd_division.DataSource = dt;
                    grd_division.DataBind();
                }

            }
            catch (Exception ex)
            {

            }
        }
    }
}