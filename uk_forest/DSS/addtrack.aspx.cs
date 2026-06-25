using Newtonsoft.Json;
using Npgsql;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.DSS
{
    public partial class addtrack : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
       string connectionS = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        dbquery connectDB = new dbquery();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    if (Session["UserId"].ToString() != "")
                    {
                        string role = Session["RoleId"].ToString();
                        string userid = Session["UserId"].ToString();
                        string password = Session["Password"].ToString();

                        getuser(role, userid, password);
                    }

                }
            }
            catch (Exception ex)
            {

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
                    query = "SELECT ur.*,zm.zone,cm.circle,dm.division,rm.range FROM tbl_user_registration ur LEFT JOIN tbl_zone_master zm ON ur.zone_id = zm.id LEFT JOIN tbl_circle_master cm ON ur.circle_id = cm.id LEFT JOIN tbl_division_master dm ON ur.division_id = dm.id LEFT JOIN tbl_range_master rm ON ur.range_id = rm.id WHERE ur.role_id = '" + role + "' AND ur.user_id = '" + userid + "' AND ur.password = '" + password + "';";
                    userlevel(query, userid);
                }
               // bindchartfiest();
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        protected void adminlevel(string q, string userid)
        {
            try
            {
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    bindddlzone();
                   // bindchartfiest();
                    //calljs();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in adminlevel: " + ex.Message);
            }
        }

        protected void userlevel(string q, string userid)
        {
            try
            {
                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    bindddlzone();
                    if (dt.Rows[0]["zone"].ToString() != "")
                    {
                        ddlzone.SelectedValue = dt.Rows[0]["zone"].ToString();
                    }
                    bindddlcircle();
                    if (dt.Rows[0]["circle"].ToString() != "")
                    {
                        ddlcircle.SelectedValue = dt.Rows[0]["circle"].ToString();
                    }
                    bindddldivision();
                    if (dt.Rows[0]["division"].ToString() != "")
                    {
                        ddldivision.SelectedValue = dt.Rows[0]["division"].ToString();
                    }

                    bindddlrange();
                    if (dt.Rows[0]["range"].ToString() != "")
                    {
                        ddlrange.SelectedValue = dt.Rows[0]["range"].ToString();
                    }

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
                    else if (userType == "CCF")
                    {
                        ddlzone.Enabled = false;
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
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in userlevel: " + ex.Message);
            }
        }


        protected void ddlzone_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindddlcircle();
                calljs();
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
                calljs();
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
                calljs();
                //binddataaccrodingfilter();
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
                calljs();
                // binddataaccrodingfilter();
            }
            catch (Exception ex)
            {

            }
        }
        protected void ddlbeat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
               // bindddlbeat();
                calljs();
                // binddataaccrodingfilter();
            }
            catch (Exception ex)
            {

            }
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
                //ddlbeat.Items.Insert(0, new ListItem("All", "All"));

               // binddataaccrodingfilter();
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
                    //ddlbeat.Items.Clear();
                   // ddlbeat.Items.Insert(0, new ListItem("All", "All"));
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
                   // ddlbeat.Items.Clear();
                    //ddlbeat.Items.Insert(0, new ListItem("All", "All"));

                }
               // binddataaccrodingfilter();
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
                   // ddlbeat.Items.Clear();
                   // ddlbeat.Items.Insert(0, new ListItem("All", "All"));
                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    //ddlcircle.Items.Insert(0, new ListItem("All", "All"));

                    ddldivision.Items.Clear();
                    ddldivision.Items.Insert(0, new ListItem("All", "All"));
                    ddlrange.Items.Clear();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));
                    //ddlbeat.Items.Clear();
                    //ddlbeat.Items.Insert(0, new ListItem("All", "All"));
                }
                calljs();
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
                    //ddlbeat.Items.Clear();
                  //  ddlbeat.Items.Insert(0, new ListItem("All", "All"));

                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    //ddlcircle.Items.Insert(0, new ListItem("All", "All"));

                    ddlrange.Items.Clear();
                    ddlrange.Items.Insert(0, new ListItem("All", "All"));
                    //ddlbeat.Items.Clear();
                   // ddlbeat.Items.Insert(0, new ListItem("All", "All"));
                }
                //binddataaccrodingfilter();
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
                    //ddlbeat.Items.Clear();
                    //ddlbeat.DataSource = dt;
                    //ddlbeat.DataValueField = "beat";
                    //ddlbeat.DataTextField = "beat";
                    //ddlbeat.DataBind();
                    //ddlbeat.Items.Insert(0, new ListItem("All", "All"));


                }
                else
                {
                    // ddlzone.Items.Insert(0, new ListItem("All", "All"));
                    //ddlcircle.Items.Insert(0, new ListItem("All", "All"));


                   // ddlbeat.Items.Clear();
                   // ddlbeat.Items.Insert(0, new ListItem("All", "All"));
                }
               // binddataaccrodingfilter();
                // Optional: Add default item

            }
            catch (Exception ex)
            {

            }
        }


        private void calljs()
        {
            try
            {
                string script1 = "applyfilter();";
                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script1, true);
            }
            catch (Exception ex)
            {
                // Log exception
            }
        }

        protected void InsertPatrollingRecord(DataTable dt)
        {
            string trackname = "";
            //  string trackname = "Track 1";
            if (txttrackName.Text != string.Empty)
            {
                trackname = txttrackName.Text;
            }

            string cordstr = cordStr.Value;

            string status = "Pending";
            bool isactive = true;

            string createdby = Session["UserId"].ToString();
            DateTime createdon = DateTime.UtcNow;
            string updatedby = Session["UserId"].ToString();
            DateTime updatedon = DateTime.UtcNow;

            using (var conn = new NpgsqlConnection(connectionS))
            {
                conn.Open();

                string sql = @"
                INSERT INTO tbl_track_master
                    (trackname, cordstr,  status, isactive, createdby, createdon, updatedby, updatedon,type)
                VALUES
                    (@trackname, @cordstr, @status, @isactive, @createdby, @createdon, @updatedby, @updatedon,@type)
                RETURNING trackid;";

                //using (var cmd = new NpgsqlCommand(sql, conn))
                //{
                //    cmd.Parameters.AddWithValue("trackname", trackname);
                //    cmd.Parameters.AddWithValue("cordstr", cordstr);
                //    //cmd.Parameters.AddWithValue("zone", zone);
                //    //cmd.Parameters.AddWithValue("circle", circle);
                //    //cmd.Parameters.AddWithValue("division", division);
                //    //cmd.Parameters.AddWithValue("range", range);
                //    //cmd.Parameters.AddWithValue("beat", beat);
                //    cmd.Parameters.AddWithValue("status", status);
                //    cmd.Parameters.AddWithValue("isactive", isactive);
                //    cmd.Parameters.AddWithValue("createdby", createdby);
                //    cmd.Parameters.AddWithValue("createdon", createdon);
                //    cmd.Parameters.AddWithValue("updatedby", updatedby);
                //    cmd.Parameters.AddWithValue("updatedon", updatedon);
                //    cmd.Parameters.AddWithValue("type", "multilinestring");


                //    // Execute and get the generated trackid
                //    int trackId = (int)cmd.ExecuteScalar();
                //    Console.WriteLine("Inserted track ID: " + trackId);
                //}
                using (var cmd = new NpgsqlCommand(sql, conn))
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        if(row["type"].ToString() == "MultiLineString")
                        {
                            cmd.Parameters.AddWithValue("trackname", trackname);
                            cmd.Parameters.AddWithValue("cordstr", row["coordinates"]);
                            //cmd.Parameters.AddWithValue("zone", zone);
                            //cmd.Parameters.AddWithValue("circle", circle);
                            //cmd.Parameters.AddWithValue("division", division);
                            //cmd.Parameters.AddWithValue("range", range);
                            //cmd.Parameters.AddWithValue("beat", beat);
                            cmd.Parameters.AddWithValue("status", status);
                            cmd.Parameters.AddWithValue("isactive", isactive);
                            cmd.Parameters.AddWithValue("createdby", createdby);
                            cmd.Parameters.AddWithValue("createdon", createdon);
                            cmd.Parameters.AddWithValue("updatedby", updatedby);
                            cmd.Parameters.AddWithValue("updatedon", updatedon);
                            cmd.Parameters.AddWithValue("type", row["type"]);


                            // Execute and get the generated trackid
                            int trackId = (int)cmd.ExecuteScalar();
                            Console.WriteLine("Inserted track ID: " + trackId);
                        }
                        else
                        {

                        }
                        
                    }
                }
            }


        }

        public static DataTable ConvertJsonToDataTable(string json)
        {
            try
            {
                return JsonConvert.DeserializeObject<DataTable>(json);
            }
            catch (Exception ex)
            {
                // Log or handle error
                throw new Exception("Invalid JSON format.", ex);
            }
        }
        protected void btnsavetrack_Click(object sender, EventArgs e)
        {
            try
            {
                if (fuKML.HasFile)
                {
                    string json = hfjson.Value;
                    DataTable sdt = ConvertJsonToDataTable(json);
                    InsertPatrollingRecord(sdt);
                }
                else
                {

                    //string connString = "Host=localhost;Username=your_user;Password=your_password;Database=your_db";
                    string zone = ddlzone.SelectedValue;
                    string circle = ddlcircle.SelectedValue;
                    string division = ddldivision.SelectedValue;
                    string range = ddlrange.SelectedValue;
                    string remark = "";
                    string trackname = "";
                    //  string trackname = "Track 1";
                    if (txttrackName.Text != string.Empty)
                    {
                        trackname = txttrackName.Text;
                    }if (txtremark.Text != string.Empty)
                    {
                        remark = txtremark.Text; ;
                    }

                    string cordstr = cordStr.Value;

                    string status = "Pending";
                    bool isactive = true;

                    string createdby = Session["UserId"].ToString();
                    DateTime createdon = DateTime.UtcNow;
                    string updatedby = Session["UserId"].ToString();
                    DateTime updatedon = DateTime.UtcNow;

                    using (var conn = new NpgsqlConnection(connectionS))
                    {
                        conn.Open();

                        string sql = @"
                INSERT INTO tbl_track_master
                    (trackname, cordstr, zone, circle, division, range,remark,  status, isactive, createdby, createdon, updatedby, updatedon,type)
                VALUES
                    (@trackname, @cordstr, @zone, @circle, @division, @range, @remark, @status, @isactive, @createdby, @createdon, @updatedby, @updatedon,@type)
                RETURNING trackid;";

                        using (var cmd = new NpgsqlCommand(sql, conn))
                        {
                            cmd.Parameters.AddWithValue("trackname", trackname);
                            cmd.Parameters.AddWithValue("cordstr", cordstr);
                            cmd.Parameters.AddWithValue("zone", zone);
                            cmd.Parameters.AddWithValue("circle", circle);
                            cmd.Parameters.AddWithValue("division", division);
                            cmd.Parameters.AddWithValue("range", range);
                            cmd.Parameters.AddWithValue("remark", remark);
                            cmd.Parameters.AddWithValue("status", status);
                            cmd.Parameters.AddWithValue("isactive", isactive);
                            cmd.Parameters.AddWithValue("createdby", createdby);
                            cmd.Parameters.AddWithValue("createdon", createdon);
                            cmd.Parameters.AddWithValue("updatedby", updatedby);
                            cmd.Parameters.AddWithValue("updatedon", updatedon);
                            cmd.Parameters.AddWithValue("type", "multilinestring");


                            // Execute and get the generated trackid
                            int trackId = (int)cmd.ExecuteScalar();
                            Console.WriteLine("Inserted track ID: " + trackId);
                        }
                    }
                }

                
            }
            catch (Exception ex)
            {

            }
        }
    }
}