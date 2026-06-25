using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Npgsql;
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
    public partial class patrollingInputForm : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        dbquery connectDB = new dbquery();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                HandleTrackTypeVisibility();
                HandleAnimalSightingVisibility();

                if (Session["UserId"] != null && Session["UserId"].ToString() != "")
                {
                    string role = Session["RoleId"].ToString();
                    string userid = Session["UserId"].ToString();
                    string password = Session["Password"].ToString();

                    getuser(role, userid, password);
                }
            }
        }

        public string LabelText
        {
            get { return LabelInContent.Text; }
        }

        // ─── User / Role Loading ───────────────────────────────────────────────────

        protected void getuser(string role, string userid, string password)
        {
            try
            {
                if (role == "1" || role == "2")
                {
                    string query = "SELECT * FROM tbl_user_master WHERE role_id='" + role
                                 + "' AND user_id='" + userid
                                 + "' AND password='" + password + "'";
                    adminlevel(query, userid);
                }
                else
                {
                    string query = @"SELECT ur.*, zm.zone, cm.circle, dm.division, rm.range
                                     FROM tbl_user_registration ur
                                     LEFT JOIN tbl_zone_master     zm ON ur.zone_id     = zm.id
                                     LEFT JOIN tbl_circle_master   cm ON ur.circle_id   = cm.id
                                     LEFT JOIN tbl_division_master dm ON ur.division_id = dm.id
                                     LEFT JOIN tbl_range_master    rm ON ur.range_id    = rm.id
                                     WHERE ur.role_id='" + role
                                   + "' AND ur.user_id='" + userid
                                   + "' AND ur.password='" + password + "';";
                    userlevel(query, userid);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in getuser: " + ex.Message);
            }
        }

        protected void adminlevel(string q, string userid)
        {
            try
            {
                bindddldivision();

                DataTable dt = connectDB.executeGetData(q);
                if (dt.Rows.Count > 0)
                {
                    // admin-level extra logic can go here if needed
                }

                // Bind tracks after division is loaded (no filter yet for admin)
                bindddltrack();
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
                bindddldivision();

                if (dt.Rows.Count > 0)
                {
                    string qry = "SELECT zone, circle, division, range, beat FROM tbl_beat_master"
                               + " WHERE range='" + dt.Rows[0]["range"].ToString() + "'";
                    DataTable dtbeat = connectDB.executeGetData(qry);

                    if (dtbeat.Rows.Count > 0)
                    {
                        ddlBeat.DataSource = dtbeat;
                        ddlBeat.DataValueField = "beat";
                        ddlBeat.DataTextField = "beat";
                        ddlBeat.DataBind();

                        if (dtbeat.Rows[0]["division"].ToString() != "")
                        {
                            ddldivision.SelectedValue = dtbeat.Rows[0]["division"].ToString();
                            bindddlrange();
                            ddldivision.Attributes.Add("disabled", "disabled");
                        }

                        if (dtbeat.Rows[0]["range"].ToString() != "")
                        {
                            ddlrange.SelectedValue = dtbeat.Rows[0]["range"].ToString();
                            ddlrange.Attributes.Add("disabled", "disabled");
                        }
                    }
                }

                // Bind tracks filtered by the user's division + range
                bindddltrack();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in userlevel: " + ex.Message);
            }
        }

        // ─── Track Type Visibility ─────────────────────────────────────────────────

        protected void rblTrackType_SelectedIndexChanged(object sender, EventArgs e)
        {
            HandleTrackTypeVisibility();
        }

        private void HandleTrackTypeVisibility()
        {
            bool isDefined = rblTrackType.SelectedValue == "Defined";
            pnlDefinedTrackFields.Visible = isDefined;
            pnlTrackName.Visible = !isDefined;
        }

        // ─── Animal Sighting Visibility ────────────────────────────────────────────

        protected void rblAnimalSighting_SelectedIndexChanged(object sender, EventArgs e)
        {
            HandleAnimalSightingVisibility();
        }

        private void HandleAnimalSightingVisibility()
        {
            switch (rblAnimalSighting.SelectedValue)
            {
                case "Active":
                    pnlSpeciesType.Visible = true;
                    pnlFileUpload.Visible = true;
                    pnlDescription.Visible = false;
                    break;
                case "Passive":
                    pnlSpeciesType.Visible = true;
                    pnlFileUpload.Visible = false;
                    pnlDescription.Visible = true;
                    break;
                case "None":
                    pnlSpeciesType.Visible = false;
                    pnlFileUpload.Visible = false;
                    pnlDescription.Visible = false;
                    break;
            }
        }

        // ─── DropDownList Binding ──────────────────────────────────────────────────

        protected void bindddldivision()
        {
            try
            {
                string q = "SELECT DISTINCT division FROM tbl_division_master ORDER BY division ASC";
                DataTable dt = connectDB.executeGetData(q);

                ddldivision.Items.Clear();
                ddlrange.Items.Clear();

                if (dt.Rows.Count > 0)
                {
                    ddldivision.DataSource = dt;
                    ddldivision.DataValueField = "division";
                    ddldivision.DataTextField = "division";
                    ddldivision.DataBind();
                }

                ddldivision.Items.Insert(0, new ListItem("All", "All"));
                ddlrange.Items.Insert(0, new ListItem("All", "All"));
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in bindddldivision: " + ex.Message);
            }
        }

        protected void bindddlrange()
        {
            try
            {
                string q = "SELECT DISTINCT range FROM tbl_range_master"
                         + " WHERE division='" + ddldivision.SelectedValue + "'"
                         + " ORDER BY range ASC";
                DataTable dt = connectDB.executeGetData(q);

                ddlrange.Items.Clear();

                if (dt.Rows.Count > 0)
                {
                    ddlrange.DataSource = dt;
                    ddlrange.DataValueField = "range";
                    ddlrange.DataTextField = "range";
                    ddlrange.DataBind();
                }

                ddlrange.Items.Insert(0, new ListItem("All", "All"));
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in bindddlrange: " + ex.Message);
            }
        }

        protected void bindddlbeat()
        {
            try
            {
                string q = "SELECT DISTINCT beat FROM tbl_beat_master"
                         + " WHERE range='" + ddlrange.SelectedValue + "'"
                         + " ORDER BY beat ASC";
                DataTable dt = connectDB.executeGetData(q);

                ddlBeat.Items.Clear();

                if (dt.Rows.Count > 0)
                {
                    ddlBeat.DataSource = dt;
                    ddlBeat.DataValueField = "beat";
                    ddlBeat.DataTextField = "beat";
                    ddlBeat.DataBind();
                }

                ddlBeat.Items.Insert(0, new ListItem("All", "All"));
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in bindddlbeat: " + ex.Message);
            }
        }

        /// <summary>
        /// Binds ddlDefinedTrack from tbl_track_master.
        /// No filter applied — shows all active tracks always.
        /// Division/range filter applied only when specifically selected (not "All").
        /// </summary>
        protected void bindddltrack()
        {
            try
            {
                // Exclude tracks already inserted in tbl_patrolling_input
                string q = @"SELECT trackid, trackname FROM public.tbl_track_master 
                             WHERE isactive = true 
                             AND CAST(trackid AS varchar) NOT IN (
                                 SELECT defined_track FROM tbl_patrolling_input 
                                 WHERE defined_track IS NOT NULL
                             )
                             ORDER BY trackname ASC";

                DataTable dt = connectDB.executeGetData(q);

                ddlDefinedTrack.Items.Clear();
                ddlDefinedTrack.Items.Add(new ListItem("Select Existing Track", ""));

                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        ddlDefinedTrack.Items.Add(new ListItem(
                            row["trackname"].ToString(),
                            row["trackid"].ToString()
                        ));
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in bindddltrack: " + ex.Message);
            }
        }

        // ─── DropDownList Event Handlers ───────────────────────────────────────────

        protected void ddldivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindddlrange();
            bindddltrack();
        }

        protected void ddlrange_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindddlbeat();
            bindddltrack();
        }

        // ─── Submit ────────────────────────────────────────────────────────────────

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            InsertPatrollingRecord();
        }

        // ─── JSON Helper ───────────────────────────────────────────────────────────

        public static DataTable ConvertJsonToDataTable(string json)
        {
            try
            {
                return JsonConvert.DeserializeObject<DataTable>(json);
            }
            catch (Exception ex)
            {
                throw new Exception("Invalid JSON format.", ex);
            }
        }

        // ─── Insert Record ─────────────────────────────────────────────────────────

        protected void InsertPatrollingRecord()
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;

                // Animal document file path
                string animalDocRelativePath = null;

                // Save Animal Document (if uploaded)
                if (fuAnimalDocument.HasFile)
                {
                    string docFileName = Path.GetFileName(fuAnimalDocument.FileName);
                    string docFolder = Server.MapPath("~/files/Animal/");
                    if (!Directory.Exists(docFolder)) Directory.CreateDirectory(docFolder);
                    string docFullPath = Path.Combine(docFolder, docFileName);
                    fuAnimalDocument.SaveAs(docFullPath);
                    animalDocRelativePath = "/files/Animal/" + docFileName;
                }

                // KML file path
                string kmlRelativePath = null;

                // Save KML File (if uploaded)
                if (fuKML.HasFile)
                {
                    string kmlFileName = Path.GetFileNameWithoutExtension(fuKML.FileName)
                                       + "_" + DateTime.Now.Ticks
                                       + Path.GetExtension(fuKML.FileName);
                    string kmlFolder = Server.MapPath("~/files/KML/");
                    if (!Directory.Exists(kmlFolder)) Directory.CreateDirectory(kmlFolder);
                    string kmlFullPath = Path.Combine(kmlFolder, kmlFileName);
                    fuKML.SaveAs(kmlFullPath);
                    kmlRelativePath = "/files/KML/" + kmlFileName;
                }

                // Get zone and circle from division master
                string qDiv = "SELECT division, circle, zone FROM tbl_division_master"
                                  + " WHERE division='" + ddldivision.SelectedValue + "' LIMIT 1";
                DataTable dtdata = connectDB.executeGetData(qDiv);

                // Safe fallback if division not found
                string zoneVal = (dtdata != null && dtdata.Rows.Count > 0) ? dtdata.Rows[0]["zone"].ToString() : "";
                string circleVal = (dtdata != null && dtdata.Rows.Count > 0) ? dtdata.Rows[0]["circle"].ToString() : "";

                using (NpgsqlConnection conn = new NpgsqlConnection(connStr))
                {
                    conn.Open();

                    // ── Duplicate Check: same track already inserted? ─────────────────
                    if (!string.IsNullOrWhiteSpace(ddlDefinedTrack.SelectedValue))
                    {
                        string dupQ = "SELECT COUNT(*) FROM tbl_patrolling_input WHERE defined_track = '"
                                    + ddlDefinedTrack.SelectedValue + "'";
                        DataTable dtDup = connectDB.executeGetData(dupQ);
                        if (dtDup != null && dtDup.Rows.Count > 0 && Convert.ToInt32(dtDup.Rows[0][0]) > 0)
                        {
                            ScriptManager.RegisterStartupScript(
                                this, this.GetType(), Guid.NewGuid().ToString(),
                                "alert('This track has already been submitted. Duplicate entry not allowed.');",
                                true
                            );
                            return;
                        }
                    }

                    // ── Step 1: Insert into tbl_patrolling_input ──────────────────────
                    string insertQuery = @"
                        INSERT INTO tbl_patrolling_input (
                            zone, circle,
                            division, range_name, beat,
                            track_type, defined_track, track_name,
                            kml_file_path,
                            slope, land_cover,
                            animal_sighting_type, species_type, sighting_description,
                            animal_document_path,
                            patrolling_type, total_distance_km, forest_type,
                            track_leader_name, tracking_date,
                            isactive, created_by, created_date
                        ) VALUES (
                            @zone, @circle,
                            @division, @range_name, @beat,
                            @track_type, @defined_track, @track_name,
                            @kml_file_path,
                            @slope, @land_cover,
                            @animal_sighting_type, @species_type, @sighting_description,
                            @animal_document_path,
                            @patrolling_type, @total_distance_km, @forest_type,
                            @track_leader_name, @tracking_date,
                            @isactive, @created_by, CURRENT_TIMESTAMP
                        );";

                    using (NpgsqlCommand cmd = new NpgsqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@zone", string.IsNullOrEmpty(zoneVal) ? (object)DBNull.Value : zoneVal);
                        cmd.Parameters.AddWithValue("@circle", string.IsNullOrEmpty(circleVal) ? (object)DBNull.Value : circleVal);
                        cmd.Parameters.AddWithValue("@division", ddldivision.SelectedValue);
                        cmd.Parameters.AddWithValue("@range_name", ddlrange.SelectedValue);
                        cmd.Parameters.AddWithValue("@beat", ddlBeat.SelectedValue);
                        cmd.Parameters.AddWithValue("@track_type", rblTrackType.SelectedValue);

                        cmd.Parameters.AddWithValue("@defined_track",
                            string.IsNullOrWhiteSpace(ddlDefinedTrack.SelectedValue)
                                ? (object)DBNull.Value
                                : ddlDefinedTrack.SelectedValue);

                        // track_name - send the display text (trackname) from ddlDefinedTrack
                        cmd.Parameters.AddWithValue("@track_name",
                            ddlDefinedTrack.SelectedIndex > 0
                                ? (object)ddlDefinedTrack.SelectedItem.Text
                                : DBNull.Value);

                        // KML file path - save if uploaded
                        cmd.Parameters.AddWithValue("@kml_file_path",
                            (object)kmlRelativePath ?? DBNull.Value);

                        cmd.Parameters.AddWithValue("@slope", ddlSlope.SelectedValue);
                        cmd.Parameters.AddWithValue("@land_cover", ddlLandCover.SelectedValue);
                        cmd.Parameters.AddWithValue("@animal_sighting_type", rblAnimalSighting.SelectedValue);

                        // species_type - null when sighting is None
                        cmd.Parameters.AddWithValue("@species_type",
                            rblAnimalSighting.SelectedValue == "None"
                                ? (object)DBNull.Value
                                : ddlSpeciesType.SelectedValue);

                        cmd.Parameters.AddWithValue("@sighting_description",
                            string.IsNullOrWhiteSpace(txtDescription.Text)
                                ? (object)DBNull.Value
                                : txtDescription.Text);

                        cmd.Parameters.AddWithValue("@animal_document_path",
                            (object)animalDocRelativePath ?? DBNull.Value);

                        cmd.Parameters.AddWithValue("@patrolling_type", ddlPatrollingType.SelectedValue);
                        cmd.Parameters.AddWithValue("@total_distance_km",
                            decimal.TryParse(txtDistance.Text, out decimal distance) ? distance : 0);
                        cmd.Parameters.AddWithValue("@forest_type", ddlForestType.SelectedValue);

                        cmd.Parameters.AddWithValue("@track_leader_name",
                            string.IsNullOrWhiteSpace(txtTrackLeaderName.Text)
                                ? (object)DBNull.Value
                                : txtTrackLeaderName.Text.Trim());

                        cmd.Parameters.AddWithValue("@tracking_date",
                            DateTime.TryParse(txtTracingDate.Text, out DateTime trackingDate)
                                ? (object)trackingDate.Date
                                : DBNull.Value);

                        cmd.Parameters.AddWithValue("@isactive", true);
                        cmd.Parameters.AddWithValue("@created_by",
                            Session["UserId"] != null ? Session["UserId"].ToString() : "system");

                        cmd.ExecuteNonQuery();
                    }

                    // ── Step 2: Get latest patrolling_id ──────────────────────────────
                    string getq = "SELECT MAX(patrolling_id) AS patrolling_id FROM public.tbl_patrolling_input";
                    DataTable dtId = connectDB.executeGetData(getq);
                    var patrollingId = dtId.Rows[0]["patrolling_id"];

                    // ── Step 3: Insert KML JSON coordinates into lines_raw ─────────────
                    string json = hfjson.Value;
                    if (!string.IsNullOrWhiteSpace(json) && json != "[]")
                    {
                        DataTable sdt = ConvertJsonToDataTable(json);
                        foreach (DataRow row in sdt.Rows)
                        {
                            using (NpgsqlCommand cmd2 = new NpgsqlCommand(
                                "INSERT INTO public.lines_raw (coord_string, type, pat_id) VALUES (@coord_string, @type, @pat_id)",
                                conn))
                            {
                                cmd2.Parameters.AddWithValue("@coord_string", row["coordinates"]);
                                cmd2.Parameters.AddWithValue("@type", row["type"]);
                                cmd2.Parameters.AddWithValue("@pat_id", patrollingId);
                                cmd2.ExecuteNonQuery();
                            }
                        }
                    }

                    conn.Close();
                }

                // Success message
                ScriptManager.RegisterStartupScript(
                    this, this.GetType(), Guid.NewGuid().ToString(),
                    "alert('Data saved successfully!');",
                    true
                );

                // Reset form after successful insert
                bindddltrack(); // refresh track dropdown - removes submitted track
                txtTrackLeaderName.Text = "";
                txtTracingDate.Text = "";
                txtDistance.Text = "";
                txtDescription.Text = "";
                hfjson.Value = "";
                ddlDefinedTrack.SelectedIndex = 0;
                ddlSlope.SelectedIndex = 0;
                ddlLandCover.SelectedIndex = 0;
                ddlForestType.SelectedIndex = 0;
                ddlPatrollingType.SelectedIndex = 0;
                ddlSpeciesType.SelectedIndex = 0;
                rblAnimalSighting.SelectedIndex = 0;
                HandleAnimalSightingVisibility();
            }
            catch (Exception ex)
            {
                // Show actual error on UI so you know what went wrong
                string safeMsg = ex.Message.Replace("'", "\\'").Replace("\r\n", " ").Replace("\n", " ");
                ScriptManager.RegisterStartupScript(
                    this, this.GetType(), Guid.NewGuid().ToString(),
                    "alert('Error: " + safeMsg + "');",
                    true
                );
            }
        }
    }
}