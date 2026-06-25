using Npgsql;
using System;
using System.Configuration;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.DSS
{
    public partial class TrackMasterList : System.Web.UI.Page
    {
        string connectionS = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        string connectionP = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;
        dbquery connectDB = new dbquery();

        // ── Page Load ─────────────────────────────────────────────────────────────

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTrackMasterList();
            }
        }

        // ── Helper: Status badge HTML ─────────────────────────────────────────────

        public string GetStatusBadge(string status)
        {
            if (string.IsNullOrEmpty(status)) return "<span class='badge-pending'>Pending</span>";
            switch (status.ToLower())
            {
                case "approved": return "<span class='badge-approved'>Approved</span>";
                case "rejected": return "<span class='badge-rejected'>Rejected</span>";
                default: return "<span class='badge-pending'>Pending</span>";
            }
        }

        // ── Load Grid (JOIN both tables) ──────────────────────────────────────────

        private void LoadTrackMasterList()
        {
            try
            {
                string role = Session["RoleId"] != null ? Session["RoleId"].ToString() : "";
                string currentUser = Session["UserId"] != null ? Session["UserId"].ToString() : "Admin";

                // JOIN tbl_track_master with tbl_patrolling_input
                // has_patrolling = true if a patrolling record exists for this track
                string q = @"
                    SELECT
                        tm.trackid,
                        tm.trackname,
                        tm.zone,
                        tm.circle,
                        tm.division,
                        tm.range,
                        tm.remark,
                        tm.status,
                        tm.isactive,
                        tm.createdby,
                        tm.createdon,
                        tm.updatedby,
                        tm.updatedon,
                        CASE WHEN pi.patrolling_id IS NOT NULL THEN true ELSE false END AS has_patrolling,
                        pi.patrolling_id,
                        pi.patrolling_type,
                        pi.total_distance_km,
                        pi.track_leader_name,
                        pi.tracking_date,
                        pi.animal_sighting_type,
                        pi.species_type,
                        pi.forest_type,
                        pi.slope,
                        pi.land_cover
                    FROM tbl_track_master tm
                    LEFT JOIN tbl_patrolling_input pi
                        ON CAST(tm.trackid AS VARCHAR) = pi.defined_track";

                if (role != "1")
                {
                    q += $" WHERE tm.createdby = '{currentUser.Replace("'", "''")}'";
                }

                q += " ORDER BY tm.createdon DESC";

                DataTable dt = connectDB.executeGetData(q);
                gvTrackMaster.DataSource = dt;
                gvTrackMaster.DataBind();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in LoadTrackMasterList: " + ex.Message);
            }
        }

        // ── RowDataBound: disable Edit button if no patrolling ────────────────────

        protected void gvTrackMaster_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HiddenField hfHasPatrolling = (HiddenField)e.Row.FindControl("hfHasPatrolling");
                LinkButton btnEdit = (LinkButton)e.Row.FindControl("btnEdit");

                if (hfHasPatrolling != null && btnEdit != null)
                {
                    bool hasPatrolling = hfHasPatrolling.Value.ToLower() == "true";
                    if (!hasPatrolling)
                    {
                        btnEdit.CssClass = "item-disabled";
                        btnEdit.Enabled = false;
                        btnEdit.ToolTip = "Patrolling not done yet. Cannot edit.";
                        btnEdit.OnClientClick = "return false;";
                    }
                }
            }
        }

        // ── VIEW ─────────────────────────────────────────────────────────────────

        protected void btnView_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int trackId = Convert.ToInt32(btn.CommandArgument);

                string q = @"
                    SELECT
                        tm.trackid, tm.trackname, tm.zone, tm.circle,
                        tm.division, tm.range, tm.remark, tm.status,
                        pi.patrolling_type, pi.total_distance_km,
                        pi.track_leader_name, pi.tracking_date,
                        pi.animal_sighting_type, pi.species_type,
                        pi.forest_type, pi.slope, pi.land_cover
                    FROM tbl_track_master tm
                    LEFT JOIN tbl_patrolling_input pi
                        ON CAST(tm.trackid AS VARCHAR) = pi.defined_track
                    WHERE tm.trackid = " + trackId;

                DataTable dt = connectDB.executeGetData(q);
                if (dt == null || dt.Rows.Count == 0) return;

                DataRow dr = dt.Rows[0];

                lblViewTrackName.Text = dr["trackname"].ToString();
                lblViewZone.Text = dr["zone"].ToString();
                lblViewCircle.Text = dr["circle"].ToString();
                lblViewDivision.Text = dr["division"].ToString();
                lblViewRange.Text = dr["range"].ToString();
                lblViewRemark.Text = dr["remark"].ToString();
                lblViewStatus.Text = dr["status"].ToString();
                lblViewPatrollingType.Text = dr["patrolling_type"].ToString();
                lblViewDistance.Text = dr["total_distance_km"] != DBNull.Value
                                             ? dr["total_distance_km"].ToString() + " km" : "-";
                lblViewLeader.Text = dr["track_leader_name"] != DBNull.Value
                                             ? dr["track_leader_name"].ToString() : "-";
                lblViewTrackingDate.Text = dr["tracking_date"] != DBNull.Value
                                             ? Convert.ToDateTime(dr["tracking_date"]).ToString("yyyy-MM-dd") : "-";
                lblViewAnimalSighting.Text = dr["animal_sighting_type"].ToString();
                lblViewSpecies.Text = dr["species_type"].ToString();
                lblViewForestType.Text = dr["forest_type"].ToString();
                lblViewSlope.Text = dr["slope"].ToString();
                lblViewLandCover.Text = dr["land_cover"].ToString();

                viewPopup.Style["display"] = "block";
                editPopup.Style["display"] = "none";

                // Load track on map
                ScriptManager.RegisterStartupScript(this, GetType(), "loadmap",
                    $"addTrackOnMap('{trackId}');", true);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in btnView_Click: " + ex.Message);
            }
        }

        // ── EDIT (open popup with existing data) ──────────────────────────────────

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int trackId = Convert.ToInt32(btn.CommandArgument);

                // Only allow edit if patrolling record exists
                string checkQ = @"SELECT patrolling_id, patrolling_type, total_distance_km,
                                         track_leader_name, tracking_date, slope, land_cover,
                                         forest_type, animal_sighting_type, species_type
                                  FROM tbl_patrolling_input
                                  WHERE defined_track = '" + trackId.ToString() + "'  LIMIT 1";

                DataTable dt = connectDB.executeGetData(checkQ);
                if (dt == null || dt.Rows.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "nopat",
                        "alert('No patrolling record found for this track. Edit not allowed.');", true);
                    return;
                }

                DataRow dr = dt.Rows[0];
                Session["EditTrackId"] = trackId;
                Session["EditPatrollingId"] = Convert.ToInt32(dr["patrolling_id"]);

                // Pre-fill edit form
                ddlEditPatrollingType.SelectedValue = dr["patrolling_type"].ToString();
                txtEditDistance.Text = dr["total_distance_km"].ToString();
                txtEditLeaderName.Text = dr["track_leader_name"].ToString();
                txtEditTrackingDate.Text = dr["tracking_date"] != DBNull.Value
                                                      ? Convert.ToDateTime(dr["tracking_date"]).ToString("yyyy-MM-dd") : "";
                ddlEditSlope.SelectedValue = dr["slope"].ToString();
                ddlEditLandCover.SelectedValue = dr["land_cover"].ToString();
                ddlEditForestType.SelectedValue = dr["forest_type"].ToString();
                ddlEditAnimalSighting.SelectedValue = dr["animal_sighting_type"].ToString();
                ddlEditSpeciesType.SelectedValue = dr["species_type"].ToString();

                editPopup.Style["display"] = "block";
                viewPopup.Style["display"] = "none";
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in btnEdit_Click: " + ex.Message);
            }
        }

        // ── SAVE EDIT ────────────────────────────────────────────────────────────

        protected void btnSaveEdit_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["EditPatrollingId"] == null) return;

                int patrollingId = Convert.ToInt32(Session["EditPatrollingId"]);
                string currentUser = Session["UserId"] != null ? Session["UserId"].ToString() : "system";

                string updateQ = @"
                    UPDATE tbl_patrolling_input SET
                        patrolling_type      = @patrolling_type,
                        total_distance_km    = @total_distance_km,
                        track_leader_name    = @track_leader_name,
                        tracking_date        = @tracking_date,
                        slope                = @slope,
                        land_cover           = @land_cover,
                        forest_type          = @forest_type,
                        animal_sighting_type = @animal_sighting_type,
                        species_type         = @species_type,
                        updated_by           = @updated_by,
                        updated_date         = CURRENT_TIMESTAMP
                    WHERE patrolling_id = @patrolling_id";

                using (NpgsqlConnection conn = new NpgsqlConnection(connectionP))
                {
                    conn.Open();
                    using (NpgsqlCommand cmd = new NpgsqlCommand(updateQ, conn))
                    {
                        cmd.Parameters.AddWithValue("@patrolling_type", ddlEditPatrollingType.SelectedValue);
                        cmd.Parameters.AddWithValue("@total_distance_km",
                            decimal.TryParse(txtEditDistance.Text, out decimal dist) ? dist : 0);
                        cmd.Parameters.AddWithValue("@track_leader_name",
                            string.IsNullOrWhiteSpace(txtEditLeaderName.Text)
                                ? (object)DBNull.Value : txtEditLeaderName.Text.Trim());
                        cmd.Parameters.AddWithValue("@tracking_date",
                            DateTime.TryParse(txtEditTrackingDate.Text, out DateTime td)
                                ? (object)td.Date : DBNull.Value);
                        cmd.Parameters.AddWithValue("@slope", ddlEditSlope.SelectedValue);
                        cmd.Parameters.AddWithValue("@land_cover", ddlEditLandCover.SelectedValue);
                        cmd.Parameters.AddWithValue("@forest_type", ddlEditForestType.SelectedValue);
                        cmd.Parameters.AddWithValue("@animal_sighting_type", ddlEditAnimalSighting.SelectedValue);
                        cmd.Parameters.AddWithValue("@species_type",
                            string.IsNullOrWhiteSpace(ddlEditSpeciesType.SelectedValue)
                                ? (object)DBNull.Value : ddlEditSpeciesType.SelectedValue);
                        cmd.Parameters.AddWithValue("@updated_by", currentUser);
                        cmd.Parameters.AddWithValue("@patrolling_id", patrollingId);

                        cmd.ExecuteNonQuery();
                    }
                }

                Session.Remove("EditPatrollingId");
                Session.Remove("EditTrackId");

                editPopup.Style["display"] = "none";
                viewPopup.Style["display"] = "none";
                LoadTrackMasterList();

                ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(),
                    "alert('Record updated successfully!');", true);
            }
            catch (Exception ex)
            {
                string safeMsg = ex.Message.Replace("'", "\\'").Replace("\n", " ");
                ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(),
                    $"alert('Error: {safeMsg}');", true);
            }
        }

        // ── REMOVE ───────────────────────────────────────────────────────────────

        protected void btnRemove_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int trackId = Convert.ToInt32(btn.CommandArgument);

                // Delete from patrolling_input first (if exists), then track_master
                using (NpgsqlConnection conn = new NpgsqlConnection(connectionP))
                {
                    conn.Open();
                    using (NpgsqlCommand cmd = new NpgsqlCommand(
                        "DELETE FROM tbl_patrolling_input WHERE defined_track = @tid", conn))
                    {
                        cmd.Parameters.AddWithValue("@tid", trackId.ToString());
                        cmd.ExecuteNonQuery();
                    }
                }

                // Delete from track master
                string delQ = $"DELETE FROM tbl_track_master WHERE trackid = {trackId}";
                connectDB.executeNonQuery(delQ);

                LoadTrackMasterList();

                ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(),
                    "alert('Track removed successfully!');", true);
            }
            catch (Exception ex)
            {
                string safeMsg = ex.Message.Replace("'", "\\'").Replace("\n", " ");
                ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(),
                    $"alert('Error: {safeMsg}');", true);
            }
        }

        // ── TrackMaster Model ─────────────────────────────────────────────────────

        public class TrackMaster
        {
            public int trackid { get; set; }
            public string trackname { get; set; }
            public string cordstr { get; set; }
            public string zone { get; set; }
            public string circle { get; set; }
            public string division { get; set; }
            public string range { get; set; }
            public string remark { get; set; }
            public string status { get; set; }
            public bool isactive { get; set; }
            public string createdby { get; set; }
            public DateTime createdon { get; set; }
            public string updatedby { get; set; }
            public DateTime? updatedon { get; set; }
        }
    }
}