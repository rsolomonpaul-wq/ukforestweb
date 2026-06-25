using Aspose.Zip;
//using Aspose.Zip.Rar;
using Aspose.Zip.Saving;
using Npgsql;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.IO.Compression;
using SharpCompress.Archives;
using SharpCompress.Archives.Rar;
using SharpCompress.Common;

namespace uk_forest.Forest
{
    public partial class upload_data : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if ((Session["UserId"] == null))
            {
                Response.Redirect("~/index.aspx");
            }

            if (!IsPostBack)
            {
                binduser_name(Session["UserId"].ToString(), Convert.ToInt32(Session["RoleId"]));
                //bindtype();
                //binddatatpe();
                //layergroupname();
                bindGrid(ddl_user_name.SelectedValue, ddlfiletype.SelectedItem.Text);
            }
        }

        void binduser_name(string user_id, Int32 role_id)
        {
            try
            {
                string q = "";
                if (role_id == 1 || role_id == 2)
                {
                    q = "select user_id, emp_id, name, user_id || ' - ' || name as display_text from public.tbl_user_registration order by role_id, user_id asc";
                }
                else
                {
                    q = "select user_id, emp_id, name, user_id || ' - ' || name as display_text from public.tbl_user_registration where user_id = '" + user_id + "' order by role_id, user_id asc";
                }
                //q = "select user_id, emp_id, name, user_id || ' - ' || name as display_text from public.tbl_user_registration where user_id = '" + user_id + "' order by user_id asc";
                DataTable dt = executeGetData(q);

                ddl_user_name.DataSource = dt;
                ddl_user_name.DataTextField = "display_text";
                ddl_user_name.DataValueField = "user_id";
                ddl_user_name.DataBind();
                //ddl_user_name.Items.Insert(0, new ListItem("--- Select ---", "--- Select ---"));
                if (dt.Rows.Count > 1)
                {
                    ddl_user_name.Items.Insert(0, new ListItem("--- Select ---", "0"));
                }
            }
            catch (Exception ex)
            {

            }
        }

        //void bindtype()
        //{
        //    ddl_file_status.Items.Clear();
        //    //ddl_toc.Items.Clear();
        //    switch (ddlfiletype.SelectedItem.ToString())
        //    {
        //        case "Vector":
        //        case "Raster":
        //        case "KML":
        //        case "GeoJson":
        //            //ddl_toc.Items.Insert(0, new ListItem("Yes", "Yes"));
        //            //ddl_toc.Items.Insert(1, new ListItem("No", "No"));

        //            ddl_file_status.Items.Insert(0, new ListItem("Data Repositories", "Data Repositories"));
        //            ddl_file_status.Items.Insert(1, new ListItem("Publish a map services", "Published"));
        //            break;
        //        case "Excel":
        //            //ddl_toc.Items.Insert(0, new ListItem("No", "No"));
        //            ddl_file_status.Items.Insert(0, new ListItem("Data Repositories", "Data Repositories"));
        //            break;
        //        case "PDF":
        //            //ddl_toc.Items.Insert(0, new ListItem("No", "No"));
        //            ddl_file_status.Items.Insert(0, new ListItem("Data Repositories", "Data Repositories"));
        //            break;
        //        case "Image":
        //            //ddl_toc.Items.Insert(0, new ListItem("No", "No"));
        //            ddl_file_status.Items.Insert(0, new ListItem("Data Repositories", "Data Repositories"));
        //            break;
        //    }
        //}

        //protected void binddatatpe()
        //{
        //    try
        //    {
        //        string q = null;
        //        switch (ddlfiletype.SelectedItem.ToString())
        //        {
        //            case "Vector":
        //            case "KML":
        //            case "GeoJson":
        //                q = "select * from tbl_datatype where sno in(1,2,3) order by sno";
        //                lbluploadstyle.Visible = true;
        //                upload_style.Visible = true;
        //                break;
        //            case "Raster":
        //                q = "select * from tbl_datatype where sno in(4,5) order by sno";
        //                lbluploadstyle.Visible = true;
        //                upload_style.Visible = true;
        //                break;
        //            case "Excel":
        //                q = "select * from tbl_datatype where sno in(6) order by sno";
        //                lbluploadstyle.Visible = false;
        //                upload_style.Visible = false;
        //                break;
        //            case "PDF":
        //                q = "select * from tbl_datatype where sno in(7) order by sno";
        //                lbluploadstyle.Visible = false;
        //                upload_style.Visible = false;
        //                break;
        //            case "Image":
        //                q = "select * from tbl_datatype where sno in(8) order by sno";
        //                lbluploadstyle.Visible = false;
        //                upload_style.Visible = false;
        //                break;
        //        }

        //        DataTable dt = executeGetData(q);
        //        ddldatatype.DataTextField = "typename";
        //        ddldatatype.DataValueField = "sno";
        //        ddldatatype.DataSource = dt;
        //        ddldatatype.DataBind();
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}

        //protected void layergroupname()
        //{
        //    try
        //    {
        //        string q = null;
        //        switch (ddlfiletype.SelectedItem.ToString())
        //        {
        //            case "Vector":
        //            case "KML":
        //            case "GeoJson":
        //            case "Raster":
        //                q = "select module_id,module_name from tbl_modules_map  where sno not in (1,6) order by sno";
        //                break;
        //            default:
        //                q = "select module_id,module_name from tbl_modules_map  where sno in (6) order by sno";
        //                break;
        //        }
        //        DataTable dt = executeGetData(q);
        //        ddllayergroupname.DataTextField = "module_name";
        //        ddllayergroupname.DataValueField = "module_id";
        //        ddllayergroupname.DataSource = dt;
        //        ddllayergroupname.DataBind();
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}

        protected void bindGrid(string user_id, string file_type)
        {
            try
            {
                //string q = "select b.user_id, c.name, c.emp_id, b.sno, a.module_name, b.sub_module_id, b.sub_module_name, b.layer_path, b.layer_type, b.data_type, b.file_status from public.tbl_modules_map a, tbl_sub_modules_map b, tbl_user_registration c where a.module_id = b.module_id and b.user_id = c.user_id and b.is_active = true and a.module_id='" + ddllayergroupname.SelectedValue.ToString() + "' and b.user_id ='" + user_id + "' and layer_type='" + file_type + "' order by b.sno";

                string q = "select b.user_id, c.name, c.emp_id, b.sno, c.email_id, a.module_name, b.sub_module_id, b.sub_module_name, b.layer_path, b.layer_type, b.data_type, b.file_status from public.tbl_modules_map a, tbl_sub_modules_map b, tbl_user_registration c where a.module_id = b.module_id and b.user_id = c.user_id and b.is_active = true and a.module_id='m_6' and b.user_id ='" + user_id + "' and layer_type='" + file_type + "' order by b.sno";

                DataTable dt = executeGetData(q);
                if (dt.Rows.Count == 0)
                {
                    grid_Modules.DataSource = null;
                    grid_Modules.DataBind();
                }
                else
                {
                    grid_Modules.DataSource = dt;
                    grid_Modules.DataBind();
                }
            }
            catch (Exception ex)
            {

            }
        }

        void add_map_toc(string sm_id, string type)
        {
            try
            {
                string user_id = null;
                string connectionString = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;
                string query = "select(case when max(sno) is null then 0 else max(sno) end) as sno from tbl_access_right_map";
                DataTable dt = executeGetData(query);
                int sno = Convert.ToInt32(dt.Rows[0]["sno"]);
                if (type == "Yes")
                {
                    string query1 = "select user_id from tbl_user_master";
                    DataTable dt1 = executeGetData(query1);
                    foreach (DataRow dtRow in dt1.Rows)
                    {
                        user_id = dtRow["user_id"].ToString();
                        sno = sno + 1;
                        string q = "INSERT INTO tbl_access_right_map(sno, user_id, module_id, sub_module_id, is_active, created_by, created_date, updated_by, updated_date, add_access, edit_access, view_access, delete_access) VALUES(@sno, @user_id, @module_id, @sub_module_id, @is_active, @created_by, @created_date, @updated_by, @updated_date, @add_access, @edit_access, @view_access, @delete_access);";

                        using (NpgsqlConnection conn = new NpgsqlConnection(connectionString))
                        {
                            conn.Open();
                            using (NpgsqlCommand cmd = new NpgsqlCommand(q, conn))
                            {
                                cmd.Parameters.AddWithValue("@sno", sno);
                                cmd.Parameters.AddWithValue("@user_id", user_id);
                                //cmd.Parameters.AddWithValue("@module_id", ddllayergroupname.SelectedValue);
                                cmd.Parameters.AddWithValue("@module_id", "m_6");
                                cmd.Parameters.AddWithValue("@sub_module_id", sm_id);
                                cmd.Parameters.AddWithValue("@is_active", true);
                                cmd.Parameters.AddWithValue("@created_by", Session["UserId"]);
                                cmd.Parameters.AddWithValue("@created_date", DateTime.Now);
                                cmd.Parameters.AddWithValue("@updated_by", "NA");
                                cmd.Parameters.AddWithValue("@updated_date", DateTime.Now);
                                cmd.Parameters.AddWithValue("@add_access", true);
                                cmd.Parameters.AddWithValue("@edit_access", true);
                                cmd.Parameters.AddWithValue("@view_access", true);
                                cmd.Parameters.AddWithValue("@delete_access", true);

                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
                else
                {
                    string query1 = "select user_id from tbl_user_master where role_id=1 ";
                    DataTable dt1 = executeGetData(query1);
                    foreach (DataRow dtRow in dt1.Rows)
                    {
                        user_id = dtRow["user_id"].ToString();
                        sno = sno + 1;
                        string q = "INSERT INTO tbl_access_right_map(sno, user_id, module_id, sub_module_id, is_active, created_by, created_date, updated_by, updated_date, add_access, edit_access, view_access, delete_access) VALUES(@sno, @user_id, @module_id, @sub_module_id, @is_active, @created_by, @created_date, @updated_by, @updated_date, @add_access, @edit_access, @view_access, @delete_access);";

                        using (NpgsqlConnection conn = new NpgsqlConnection(connectionString))
                        {
                            conn.Open();
                            using (NpgsqlCommand cmd = new NpgsqlCommand(q, conn))
                            {
                                cmd.Parameters.AddWithValue("@sno", sno);
                                cmd.Parameters.AddWithValue("@user_id", user_id);
                                //cmd.Parameters.AddWithValue("@module_id", ddllayergroupname.SelectedValue);
                                cmd.Parameters.AddWithValue("@module_id", "m_6");
                                cmd.Parameters.AddWithValue("@sub_module_id", sm_id);
                                cmd.Parameters.AddWithValue("@is_active", true);
                                cmd.Parameters.AddWithValue("@created_by", Session["UserId"]);
                                cmd.Parameters.AddWithValue("@created_date", DateTime.Now);
                                cmd.Parameters.AddWithValue("@updated_by", "NA");
                                cmd.Parameters.AddWithValue("@updated_date", DateTime.Now);
                                cmd.Parameters.AddWithValue("@add_access", true);
                                cmd.Parameters.AddWithValue("@edit_access", true);
                                cmd.Parameters.AddWithValue("@view_access", true);
                                cmd.Parameters.AddWithValue("@delete_access", true);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }
        protected void btn_uploaddata_Click(object sender, EventArgs e)
        {
            string message = "Please select User";
            if (ddl_user_name.SelectedValue == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{message}');", true);
            }
            if (ddlfiletype.SelectedItem.Text == "Vector")
            {
                //string sm_id = upload_vector_data(Session["UserId"].ToString(), Session["UserId"].ToString());
                string sm_id = upload_vector_data(ddl_user_name.SelectedValue, Session["UserId"].ToString());
                //add_map_toc(sm_id, ddl_toc.SelectedItem.ToString());
            }
            else if (ddlfiletype.SelectedItem.Text == "KML" || ddlfiletype.SelectedItem.Text == "GeoJson")
            {
                //string sm_id = upload_kml_data(Session["UserId"].ToString(), Session["UserId"].ToString());
                string sm_id = upload_kml_data(ddl_user_name.SelectedValue, Session["UserId"].ToString());
                //add_map_toc(sm_id, ddl_toc.SelectedItem.ToString());
            }
            else if (ddlfiletype.SelectedItem.Text == "Raster")
            {
                //string sm_id = upload_raster_data(Session["UserId"].ToString(), Session["UserId"].ToString());
                string sm_id = upload_raster_data(ddl_user_name.SelectedValue, Session["UserId"].ToString());
                //add_map_toc(sm_id, ddl_toc.SelectedItem.ToString());
            }
            else if (ddlfiletype.SelectedItem.Text == "Excel" || ddlfiletype.SelectedItem.Text == "PDF" || ddlfiletype.SelectedItem.Text == "Image")
            {
                //string sm_id = upload_excel_pdf_image_data(Session["UserId"].ToString(), Session["UserId"].ToString());
                string sm_id = upload_excel_pdf_image_data(ddl_user_name.SelectedValue, Session["UserId"].ToString());
                //add_map_toc(sm_id, ddl_toc.SelectedItem.ToString());
            }
            bindGrid(ddl_user_name.SelectedValue, ddlfiletype.SelectedItem.Text);
        }





        //string upload_vector_data(string user, string uname)
        //{
        //    try
        //    {
        //        if (upload_shape_file.HasFile)
        //        {
        //            string filename = Path.GetFileName(upload_shape_file.FileName);
        //            string file_name = Path.GetFileNameWithoutExtension(upload_shape_file.FileName);
        //            string fullpath = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name; //Zip File Save On ServerSide.
        //            string file_save = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name + "/" + filename;
        //            string filename_1 = Path.GetFileName(upload_style.FileName);
        //            string file_save_1 = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name + "/" + filename_1;
        //            if (Directory.Exists(fullpath))
        //            {
        //                Directory.Delete(fullpath, true);
        //                Directory.CreateDirectory(fullpath);
        //            }
        //            else
        //            {
        //                Directory.CreateDirectory(fullpath);
        //            }
        //            upload_shape_file.SaveAs(file_save);
        //            using (var archive = new RarArchive(file_save))
        //            {
        //                string pt = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name;
        //                archive.ExtractToDirectory(pt);
        //            }
        //            System.IO.DirectoryInfo dir = new System.IO.DirectoryInfo(fullpath);
        //            int count = dir.GetFiles().Length;
        //            var firstFilename = "";
        //            var firstFilename_1 = "";
        //            var ext = "";
        //            var ext_1 = "";
        //            string file_path_1 = "";
        //            if (upload_style.HasFile)
        //            {
        //                upload_style.SaveAs(file_save_1);
        //                var shpFiles1 = new DirectoryInfo(fullpath).GetFiles("*.sld");
        //                firstFilename_1 = shpFiles1[0].Name.Split('.')[0];
        //                ext_1 = shpFiles1[0].Name.Split('.')[1];
        //                file_path_1 = user + "\\" + ddlfiletype.SelectedValue + "\\" + file_name + "\\" + firstFilename_1 + "." + ext_1; ;
        //            }
        //            if (count > 4)
        //            {
        //                //GetFiles on DirectoryInfo returns a FileInfo object.
        //                var shpFiles = new DirectoryInfo(fullpath).GetFiles("*.shp");
        //                firstFilename = shpFiles[0].Name.Split('.')[0];
        //                ext = shpFiles[0].Name.Split('.')[1];
        //            }
        //            else
        //            {
        //                string srcDir = fullpath + "\\" + file_name;
        //                string destDir = fullpath;
        //                DirectoryInfo dir1 = new DirectoryInfo(srcDir);
        //                foreach (FileInfo file in dir1.GetFiles())
        //                {
        //                    file.MoveTo($@"{destDir}\{file.Name}");
        //                }
        //                Directory.Delete(srcDir, true);
        //                var shpFiles = new DirectoryInfo(fullpath).GetFiles("*.shp");
        //                firstFilename = shpFiles[0].Name.Split('.')[0];
        //                ext = shpFiles[0].Name.Split('.')[1];
        //            }
        //            //FileInfo has a Name property that only contains the filename part.
        //            string cmdpath1 = Environment.SystemDirectory;
        //            //string path = Server.MapPath("~/Files/");
        //            string file_path = user + "\\" + ddlfiletype.SelectedValue + "\\" + file_name + "\\" + firstFilename + "." + ext;
        //            string table_name = firstFilename.ToLower();
        //            string layer_name = firstFilename.ToLower();
        //            string style_name = firstFilename_1;
        //            //string m_id = ddllayergroupname.SelectedValue.ToString();
        //            string m_id = "m_6";
        //            string database_name = "doon_forest";
        //            string sub_module_id = null;
        //            string str = "select case when max(sno) is null then 0 else max(sno) end srno from tbl_sub_modules_map";
        //            DataTable maxSrno = this.executeGetData(str);

        //            int sno = (Convert.ToInt32(maxSrno.Rows[0]["srno"].ToString()) + 1);
        //            string user_id = ddl_user_name.SelectedValue;

        //            if (string.IsNullOrEmpty(maxSrno.Rows[0]["srno"].ToString()))
        //                sub_module_id = "sm_1";
        //            else
        //                sub_module_id = "sm_" + sno;

        //            string sub_module_name = fileUploadTextBox.Text;
        //            string module_id = ddlfiletype.SelectedValue;

        //            string layer_path = file_path;
        //            string style_path = file_path_1;
        //            string layer_type = ddlfiletype.SelectedItem.Text;
        //            Boolean layer_publish_status = false;
        //            string data_type = "";
        //            string projection_sys = "4326";
        //            string elevation_field = "";
        //            data_type = "2D";

        //            string constr = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;
        //            using (NpgsqlConnection con = new NpgsqlConnection(constr))
        //            {
        //                NpgsqlCommand cmd = new NpgsqlCommand();
        //                cmd.CommandType = CommandType.Text;
        //                cmd.CommandText = "insert into tbl_sub_modules_map (sno, user_id, sub_module_id, sub_module_name, module_id, is_active, tbl_name, layer_path, style_path, layer_type, layer_publish_status,layer_name,style_name,data_type,projection_sys,elevation_field,created_by,created_date,file_status) values(@sno, @user_id, @sub_module_id,@sub_module_name,@module_id,@is_active,@tbl_name,@layer_path,@style_path,@layer_type,@layer_publish_status,@layer_name,@style_name,@data_type,@projection_sys,@elevation_field,@created_by,@created_date,@file_status)";
        //                cmd.Parameters.Add("@sno", NpgsqlTypes.NpgsqlDbType.Integer).Value = sno;
        //                cmd.Parameters.Add("@user_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = user_id;
        //                cmd.Parameters.Add("@sub_module_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = sub_module_id;
        //                cmd.Parameters.Add("@sub_module_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = sub_module_name;
        //                cmd.Parameters.Add("@module_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = m_id;
        //                cmd.Parameters.Add("@is_active", NpgsqlTypes.NpgsqlDbType.Boolean).Value = true;
        //                cmd.Parameters.Add("@tbl_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = table_name;
        //                cmd.Parameters.Add("@layer_path", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_path;
        //                cmd.Parameters.Add("@style_path", NpgsqlTypes.NpgsqlDbType.Varchar).Value = style_path;
        //                cmd.Parameters.Add("@layer_type", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_type;
        //                cmd.Parameters.Add("@layer_publish_status", NpgsqlTypes.NpgsqlDbType.Boolean).Value = layer_publish_status;
        //                cmd.Parameters.Add("@layer_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_name;
        //                cmd.Parameters.Add("@style_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = style_name;
        //                cmd.Parameters.Add("@data_type", NpgsqlTypes.NpgsqlDbType.Varchar).Value = data_type;
        //                cmd.Parameters.Add("@projection_sys", NpgsqlTypes.NpgsqlDbType.Varchar).Value = projection_sys;
        //                cmd.Parameters.Add("@elevation_field", NpgsqlTypes.NpgsqlDbType.Varchar).Value = elevation_field;
        //                cmd.Parameters.Add("@created_by", NpgsqlTypes.NpgsqlDbType.Varchar).Value = Session["UserId"].ToString();
        //                cmd.Parameters.Add("@created_date", NpgsqlTypes.NpgsqlDbType.Date).Value = DateTime.Now;
        //                //cmd.Parameters.Add("@file_status", NpgsqlTypes.NpgsqlDbType.Varchar).Value = ddl_file_status.SelectedItem.ToString(); 
        //                cmd.Parameters.Add("@file_status", NpgsqlTypes.NpgsqlDbType.Varchar).Value = "Data Repositories";

        //                cmd.Connection = con;
        //                con.Open();
        //                cmd.ExecuteNonQuery();
        //                fileUploadTextBox.Text = "";
        //            }
        //            //if (ddl_file_status.SelectedItem.ToString() == "Map Publishing")
        //            //{
        //            //    //string data_upload_in_database = ConfigurationManager.AppSettings["data_upload_in_database"].ToString();
        //            //    //ProcessStartInfo startInfotide = new ProcessStartInfo();
        //            //    //startInfotide.Verb = "runas";
        //            //    //startInfotide.CreateNoWindow = false;
        //            //    //startInfotide.UseShellExecute = false;
        //            //    //startInfotide.FileName = cmdpath1 + @"\cmd.exe";
        //            //    //startInfotide.WorkingDirectory = cmdpath1;

        //            //    //startInfotide.Arguments = string.Format("/C {0} \"{1}\" \"{2}\" \"{3}\" \"{4}\" \"{5}\"", data_upload_in_database, file_path, table_name, database_name, "Vector", uname);

        //            //    //using (Process exeProcess = Process.Start(startInfotide))
        //            //    //{
        //            //    //    exeProcess.WaitForExit();
        //            //    //}
        //            //    //string data_upload_in_geoserver = ConfigurationManager.AppSettings["data_upload_in_geoserver"].ToString();
        //            //    //ProcessStartInfo startInfotide1 = new ProcessStartInfo();
        //            //    //startInfotide1.Verb = "runas";
        //            //    //startInfotide1.CreateNoWindow = false;
        //            //    //startInfotide1.UseShellExecute = false;
        //            //    //startInfotide1.FileName = cmdpath1 + @"\cmd.exe";
        //            //    //startInfotide1.WorkingDirectory = cmdpath1;

        //            //    //startInfotide1.Arguments = string.Format("/C {0} \"{1}\" \"{2}\"", data_upload_in_geoserver, sub_module_id, uname);

        //            //    //using (Process exeProcess1 = Process.Start(startInfotide1))
        //            //    //{
        //            //    //    exeProcess1.WaitForExit();
        //            //    //}
        //            //    //binddata();
        //            //    //ScriptManager.RegisterStartupScript(this, GetType(), "Message", "alert('Data Uploaded Successfully.');", true);
        //            //    //  ScriptManager.RegisterStartupScript(this, GetType(), "Javascript", "javascript:removeLoader(); ", true);
        //            //}
        //            return sub_module_id;
        //        }
        //        return null;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}





        public string upload_vector_data(string user, string uname)
        {
            try
            {
                if (upload_shape_file.HasFile)
                {
                    string filename = Path.GetFileName(upload_shape_file.FileName);
                    string file_name = Path.GetFileNameWithoutExtension(upload_shape_file.FileName);
                    string fullpath = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name;
                    string file_save = Path.Combine(fullpath, filename);

                    string filename_1 = Path.GetFileName(upload_style.FileName);
                    string file_save_1 = Path.Combine(fullpath, filename_1);

                    if (Directory.Exists(fullpath))
                    {
                        Directory.Delete(fullpath, true);
                    }
                    Directory.CreateDirectory(fullpath);

                    // Save the uploaded archive file
                    upload_shape_file.SaveAs(file_save);

                    // Extract based on file extension
                    string extension = Path.GetExtension(upload_shape_file.FileName).ToLower();

                    if (extension == ".rar")
                    {
                        using (var archive = RarArchive.Open(file_save))
                        {
                            foreach (var entry in archive.Entries.Where(entry => !entry.IsDirectory))
                            {
                                entry.WriteToDirectory(fullpath, new ExtractionOptions()
                                {
                                    ExtractFullPath = true,
                                    Overwrite = true
                                });
                            }
                        }
                    }
                    else if (extension == ".zip")
                    {
                        ZipFile.ExtractToDirectory(file_save, fullpath);
                    }
                    else
                    {
                        throw new Exception("Only .zip and .rar files are supported.");
                    }

                    DirectoryInfo dir = new DirectoryInfo(fullpath);
                    int count = dir.GetFiles().Length;
                    string firstFilename = "", firstFilename_1 = "", ext = "", ext_1 = "", file_path_1 = "";

                    if (upload_style.HasFile)
                    {
                        upload_style.SaveAs(file_save_1);
                        var shpFiles1 = new DirectoryInfo(fullpath).GetFiles("*.sld");
                        if (shpFiles1.Length > 0)
                        {
                            firstFilename_1 = Path.GetFileNameWithoutExtension(shpFiles1[0].Name);
                            ext_1 = Path.GetExtension(shpFiles1[0].Name).Trim('.');
                            file_path_1 = $"{user}\\{ddlfiletype.SelectedValue}\\{file_name}\\{firstFilename_1}.{ext_1}";
                        }
                    }
                    if (count > 4)
                    {
                        var shpFiles = new DirectoryInfo(fullpath).GetFiles("*.shp");
                        if (shpFiles.Length > 0)
                        {
                            firstFilename = Path.GetFileNameWithoutExtension(shpFiles[0].Name);
                            ext = Path.GetExtension(shpFiles[0].Name).Trim('.');
                        }
                    }
                    else
                    {
                        string srcDir = Path.Combine(fullpath, file_name);
                        string destDir = fullpath;
                        if (Directory.Exists(srcDir))
                        {
                            foreach (FileInfo file in new DirectoryInfo(srcDir).GetFiles())
                            {
                                //file.MoveTo(Path.Combine(destDir, file.Name), true);
                                file.MoveTo(Path.Combine(destDir, file.Name));
                            }
                            Directory.Delete(srcDir, true);
                        }

                        var shpFiles = new DirectoryInfo(fullpath).GetFiles("*.shp");
                        if (shpFiles.Length > 0)
                        {
                            firstFilename = Path.GetFileNameWithoutExtension(shpFiles[0].Name);
                            ext = Path.GetExtension(shpFiles[0].Name).Trim('.');
                        }
                    }

                    string file_path = $"{user}\\{ddlfiletype.SelectedValue}\\{file_name}\\{firstFilename}.{ext}";
                    string table_name = firstFilename.ToLower();
                    string layer_name = table_name;
                    string style_name = firstFilename_1;
                    string m_id = "m_6";
                    string database_name = "doon_forest";

                    DataTable maxSrno = this.executeGetData("SELECT COALESCE(MAX(sno), 0) AS srno FROM tbl_sub_modules_map");
                    int sno = Convert.ToInt32(maxSrno.Rows[0]["srno"]) + 1;
                    string user_id = ddl_user_name.SelectedValue;
                    string sub_module_id = $"sm_{sno}";
                    string sub_module_name = fileUploadTextBox.Text;
                    string module_id = ddlfiletype.SelectedValue;
                    string layer_path = file_path;
                    string style_path = file_path_1;
                    string layer_type = ddlfiletype.SelectedItem.Text;
                    bool layer_publish_status = false;
                    string data_type = "2D";
                    string projection_sys = "4326";
                    string elevation_field = "";

                    string constr = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;
                    using (NpgsqlConnection con = new NpgsqlConnection(constr))
                    {
                        NpgsqlCommand cmd = new NpgsqlCommand
                        {
                            Connection = con,
                            CommandType = CommandType.Text,
                            CommandText = @"INSERT INTO tbl_sub_modules_map (
                                        sno, user_id, sub_module_id, sub_module_name, module_id,
                                        is_active, tbl_name, layer_path, style_path, layer_type,
                                        layer_publish_status, layer_name, style_name, data_type,
                                        projection_sys, elevation_field, created_by, created_date, file_status
                                    ) VALUES (
                                        @sno, @user_id, @sub_module_id, @sub_module_name, @module_id,
                                        @is_active, @tbl_name, @layer_path, @style_path, @layer_type,
                                        @layer_publish_status, @layer_name, @style_name, @data_type,
                                        @projection_sys, @elevation_field, @created_by, @created_date, @file_status
                                    )"
                        };

                        cmd.Parameters.AddWithValue("@sno", sno);
                        cmd.Parameters.AddWithValue("@user_id", user_id);
                        cmd.Parameters.AddWithValue("@sub_module_id", sub_module_id);
                        cmd.Parameters.AddWithValue("@sub_module_name", sub_module_name);
                        cmd.Parameters.AddWithValue("@module_id", m_id);
                        cmd.Parameters.AddWithValue("@is_active", true);
                        cmd.Parameters.AddWithValue("@tbl_name", table_name);
                        cmd.Parameters.AddWithValue("@layer_path", layer_path);
                        cmd.Parameters.AddWithValue("@style_path", style_path);
                        cmd.Parameters.AddWithValue("@layer_type", layer_type);
                        cmd.Parameters.AddWithValue("@layer_publish_status", layer_publish_status);
                        cmd.Parameters.AddWithValue("@layer_name", layer_name);
                        cmd.Parameters.AddWithValue("@style_name", style_name);
                        cmd.Parameters.AddWithValue("@data_type", data_type);
                        cmd.Parameters.AddWithValue("@projection_sys", projection_sys);
                        cmd.Parameters.AddWithValue("@elevation_field", elevation_field);
                        cmd.Parameters.AddWithValue("@created_by", Session["UserId"].ToString());
                        cmd.Parameters.AddWithValue("@created_date", DateTime.Now.Date);
                        cmd.Parameters.AddWithValue("@file_status", "Data Repositories");

                        con.Open();
                        cmd.ExecuteNonQuery();
                        fileUploadTextBox.Text = "";
                    }

                    return sub_module_id;
                }

                return null;
            }
            catch (Exception ex)
            {
                // Consider logging the error for diagnostics
                return null;
            }
        }




        //string upload_vector_data1(string user, string uname)
        //{
        //    try
        //    {
        //        if (upload_shape_file.HasFile)
        //        {
        //            string filename = Path.GetFileName(upload_shape_file.FileName);
        //            string file_name = Path.GetFileNameWithoutExtension(upload_shape_file.FileName);
        //            string extension = Path.GetExtension(filename).ToLower();

        //            string fullpath = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name;
        //            string file_save = fullpath + "/" + filename;

        //            string filename_1 = Path.GetFileName(upload_style.FileName);
        //            string file_save_1 = fullpath + "/" + filename_1;

        //            if (Directory.Exists(fullpath))
        //            {
        //                Directory.Delete(fullpath, true);
        //            }
        //            Directory.CreateDirectory(fullpath);

        //            // Save uploaded archive file (ZIP or RAR)
        //            upload_shape_file.SaveAs(file_save);

        //            // === Unzip or Unrar ===
        //            string extractPath = fullpath;

        //            if (extension == ".rar")
        //            {
        //                //using (var archive = RarArchive.Open(file_save))
        //                //{
        //                //    foreach (var entry in archive.Entries.Where(entry => !entry.IsDirectory))
        //                //    {
        //                //        entry.WriteToDirectory(extractPath, new SharpCompress.Common.ExtractionOptions() { ExtractFullPath = true, Overwrite = true });
        //                //    }
        //                //}
        //                //using (var archive = RarArchive.Open(file_save))
        //                using (var archive = SharpCompress.Archives.Rar.RarArchive.Open(file_save))
        //                {
        //                    foreach (var entry in archive.Entries.Where(entry => !entry.IsDirectory))
        //                    {
        //                        entry.WriteToDirectory(extractPath, new ExtractionOptions()
        //                        {
        //                            ExtractFullPath = true,
        //                            Overwrite = true
        //                        });
        //                    }
        //                }
        //            }
        //            else if (extension == ".zip")
        //            {
        //                ZipFile.ExtractToDirectory(file_save, extractPath);
        //            }
        //            else
        //            {
        //                throw new Exception("Unsupported file format. Please upload .rar or .zip files.");
        //            }

        //            // ======= (Rest of your original logic stays same, truncated for brevity) =======
        //            // Move nested folders up if necessary
        //            DirectoryInfo dir = new DirectoryInfo(fullpath);
        //            if (dir.GetFiles("*.shp", SearchOption.AllDirectories).Length > 0 && dir.GetFiles("*.shp").Length == 0)
        //            {
        //                string srcDir = fullpath + "/" + file_name;
        //                if (Directory.Exists(srcDir))
        //                {
        //                    foreach (FileInfo file in new DirectoryInfo(srcDir).GetFiles())
        //                    {
        //                        file.MoveTo(Path.Combine(fullpath, file.Name));
        //                    }
        //                    Directory.Delete(srcDir, true);
        //                }
        //            }

        //            // Extract layer and style filenames
        //            var shpFiles = new DirectoryInfo(fullpath).GetFiles("*.shp");
        //            var firstFilename = shpFiles[0].Name.Split('.')[0];
        //            var ext = shpFiles[0].Extension.TrimStart('.');

        //            string file_path = $"{user}\\{ddlfiletype.SelectedValue}\\{file_name}\\{firstFilename}.{ext}";
        //            string file_path_1 = "";

        //            if (upload_style.HasFile)
        //            {
        //                upload_style.SaveAs(file_save_1);
        //                var sldFiles = new DirectoryInfo(fullpath).GetFiles("*.sld");
        //                var styleFilename = sldFiles[0].Name.Split('.');
        //                file_path_1 = $"{user}\\{ddlfiletype.SelectedValue}\\{file_name}\\{styleFilename[0]}.{styleFilename[1]}";
        //            }

        //            // DB insert logic (unchanged)
        //            // ...

        //            //return "sm_" + sno; // or sub_module_id;
        //            return "sm_" + "25"; // or sub_module_id;
        //        }
        //        return null;
        //    }
        //    catch (Exception ex)
        //    {
        //        // Log ex.Message for debugging (optional)
        //        return null;
        //    }
        //}




        string upload_kml_data(string user, string uname)
        {
            try
            {
                if (upload_shape_file.HasFile)
                {
                    string filename = Path.GetFileName(upload_shape_file.FileName);
                    string file_name = Path.GetFileNameWithoutExtension(upload_shape_file.FileName);
                    string fullpath = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name; //Zip File Save On ServerSide.
                    string file_save = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name + "/" + filename;
                    string filename_1 = Path.GetFileName(upload_style.FileName);
                    string file_save_1 = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name + "/" + filename_1;

                    if (Directory.Exists(fullpath))
                    {
                        Directory.Delete(fullpath, true);
                        Directory.CreateDirectory(fullpath);
                    }
                    else
                    {
                        Directory.CreateDirectory(fullpath);
                    }
                    upload_shape_file.SaveAs(file_save);
                    var firstFilename = "";
                    var firstFilename_1 = "";
                    var ext = "";
                    var ext_1 = "";
                    string file_path_1 = "";
                    if (upload_style.HasFile)
                    {
                        upload_style.SaveAs(file_save_1);
                        var shpFiles1 = new DirectoryInfo(fullpath).GetFiles("*.sld");
                        firstFilename_1 = shpFiles1[0].Name.Split('.')[0];
                        ext_1 = shpFiles1[0].Name.Split('.')[1];
                        file_path_1 = user + "\\" + ddlfiletype.SelectedValue + "\\" + file_name + "\\" + firstFilename_1 + "." + ext_1; ;
                    }
                    //if (count > 4)
                    //{
                    //GetFiles on DirectoryInfo returns a FileInfo object.
                    if (ddlfiletype.SelectedItem.Text == "KML")
                    {
                        var shpFiles = new DirectoryInfo(fullpath).GetFiles("*.kml");
                        firstFilename = shpFiles[0].Name.Split('.')[0];
                        ext = shpFiles[0].Name.Split('.')[1];
                    }
                    else
                    {
                        var shpFiles = new DirectoryInfo(fullpath).GetFiles("*.Json");
                        firstFilename = shpFiles[0].Name.Split('.')[0];
                        ext = shpFiles[0].Name.Split('.')[1];
                    }
                    string cmdpath1 = Environment.SystemDirectory;
                    //string path = Server.MapPath("~/Files/");
                    string file_path = user + "\\" + ddlfiletype.SelectedValue + "\\" + file_name + "\\" + firstFilename + "." + ext;
                    string table_name = firstFilename.ToLower();
                    string layer_name = firstFilename.ToLower();
                    string style_name = firstFilename_1;
                    //string m_id = ddllayergroupname.SelectedValue.ToString();
                    string m_id = "m_6";
                    string database_name = "doon_forest";

                    string sub_module_id = null;

                    string str = "select case when max(sno) is null then 0 else max(sno) end srno from tbl_sub_modules_map";
                    DataTable maxSrno = this.executeGetData(str);

                    int sno = (Convert.ToInt32(maxSrno.Rows[0]["srno"].ToString()) + 1);
                    string user_id = ddl_user_name.SelectedValue;

                    if (string.IsNullOrEmpty(maxSrno.Rows[0]["srno"].ToString()))
                        sub_module_id = "sm_1";
                    else
                        sub_module_id = "sm_" + sno;

                    string sub_module_name = fileUploadTextBox.Text;
                    string module_id = ddlfiletype.SelectedValue;
                    string layer_path = file_path;
                    string style_path = file_path_1;
                    string layer_type = ddlfiletype.SelectedItem.Text;
                    Boolean layer_publish_status = false;

                    string data_type = "";
                    string projection_sys = "4326";
                    string elevation_field = "";
                    data_type = "2D";

                    string constr = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;
                    using (NpgsqlConnection con = new NpgsqlConnection(constr))
                    {
                        NpgsqlCommand cmd = new NpgsqlCommand();
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "insert into tbl_sub_modules_map (sno, user_id, sub_module_id, sub_module_name, module_id, is_active, tbl_name, layer_path, style_path, layer_type, layer_publish_status,layer_name,style_name,data_type,projection_sys,elevation_field,created_by,created_date,file_status) values(@sno, @user_id, @sub_module_id,@sub_module_name,@module_id,@is_active,@tbl_name,@layer_path,@style_path,@layer_type,@layer_publish_status,@layer_name,@style_name,@data_type,@projection_sys,@elevation_field,@created_by,@created_date,@file_status)";
                        cmd.Parameters.Add("@sno", NpgsqlTypes.NpgsqlDbType.Integer).Value = sno;
                        cmd.Parameters.Add("@user_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = user_id;
                        cmd.Parameters.Add("@sub_module_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = sub_module_id;
                        cmd.Parameters.Add("@sub_module_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = sub_module_name;
                        cmd.Parameters.Add("@module_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = m_id;
                        cmd.Parameters.Add("@is_active", NpgsqlTypes.NpgsqlDbType.Boolean).Value = true;
                        cmd.Parameters.Add("@tbl_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = table_name;
                        cmd.Parameters.Add("@layer_path", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_path;
                        cmd.Parameters.Add("@style_path", NpgsqlTypes.NpgsqlDbType.Varchar).Value = style_path;
                        cmd.Parameters.Add("@layer_type", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_type;
                        cmd.Parameters.Add("@layer_publish_status", NpgsqlTypes.NpgsqlDbType.Boolean).Value = layer_publish_status;
                        cmd.Parameters.Add("@layer_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_name;
                        cmd.Parameters.Add("@style_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = style_name;
                        cmd.Parameters.Add("@data_type", NpgsqlTypes.NpgsqlDbType.Varchar).Value = data_type;
                        cmd.Parameters.Add("@projection_sys", NpgsqlTypes.NpgsqlDbType.Varchar).Value = projection_sys;
                        cmd.Parameters.Add("@elevation_field", NpgsqlTypes.NpgsqlDbType.Varchar).Value = elevation_field;
                        cmd.Parameters.Add("@created_by", NpgsqlTypes.NpgsqlDbType.Varchar).Value = Session["UserId"].ToString();
                        cmd.Parameters.Add("@created_date", NpgsqlTypes.NpgsqlDbType.Timestamp).Value = DateTime.Now;
                        //cmd.Parameters.Add("@file_status", NpgsqlTypes.NpgsqlDbType.Varchar).Value = ddl_file_status.SelectedItem.ToString();
                        cmd.Parameters.Add("@file_status", NpgsqlTypes.NpgsqlDbType.Varchar).Value = "Data Repositories";

                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();

                        fileUploadTextBox.Text = "";
                    }
                    //if (ddl_file_status.SelectedItem.ToString() == "Map Publishing")
                    //{
                    //    //string data_upload_in_database = ConfigurationManager.AppSettings["data_upload_in_database"].ToString();
                    //    //ProcessStartInfo startInfotide = new ProcessStartInfo();
                    //    //startInfotide.Verb = "runas";
                    //    //startInfotide.CreateNoWindow = false;
                    //    //startInfotide.UseShellExecute = false;
                    //    //startInfotide.FileName = cmdpath1 + @"\cmd.exe";
                    //    //startInfotide.WorkingDirectory = cmdpath1;
                    //    //startInfotide.Arguments = string.Format("/C {0} \"{1}\" \"{2}\" \"{3}\" \"{4}\" \"{5}\"", data_upload_in_database, file_path, table_name, database_name, "KML", uname);

                    //    //using (Process exeProcess = Process.Start(startInfotide))
                    //    //{
                    //    //    exeProcess.WaitForExit();
                    //    //}
                    //    //string data_upload_in_geoserver = ConfigurationManager.AppSettings["data_upload_in_geoserver"].ToString();
                    //    //ProcessStartInfo startInfotide1 = new ProcessStartInfo();
                    //    //startInfotide1.Verb = "runas";
                    //    //startInfotide1.CreateNoWindow = false;
                    //    //startInfotide1.UseShellExecute = false;
                    //    //startInfotide1.FileName = cmdpath1 + @"\cmd.exe";
                    //    //startInfotide1.WorkingDirectory = cmdpath1;
                    //    //startInfotide1.Arguments = string.Format("/C {0} \"{1}\" \"{2}\"", data_upload_in_geoserver, sub_module_id, uname);

                    //    //using (Process exeProcess1 = Process.Start(startInfotide1))
                    //    //{
                    //    //    exeProcess1.WaitForExit();
                    //    //}
                    //    //binddata();
                    //    //ScriptManager.RegisterStartupScript(this, GetType(), "Message", "alert('Data Uploaded Successfully.');", true);
                    //}
                    return sub_module_id;
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        string upload_raster_data(string user, string uname)
        {
            try
            {
                if (upload_shape_file.HasFile)
                {
                    string filename = Path.GetFileName(upload_shape_file.FileName);
                    string file_name = Path.GetFileNameWithoutExtension(upload_shape_file.FileName);
                    string fullpath = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name; //Zip File Save On ServerSide.
                    string file_save = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name + "/" + filename;
                    if (Directory.Exists(fullpath))
                    {
                        Directory.Delete(fullpath, true);
                        Directory.CreateDirectory(fullpath);
                    }
                    else
                    {
                        Directory.CreateDirectory(fullpath);
                    }
                    upload_shape_file.SaveAs(file_save);
                    var shpFiles = new DirectoryInfo(fullpath).GetFiles("*.tif");
                    var firstFilename = shpFiles[0].Name.Split('.')[0];
                    var ext = shpFiles[0].Name.Split('.')[1];
                    string file_path = user + "\\" + ddlfiletype.SelectedValue + "\\" + file_name + "\\" + firstFilename + "." + ext;
                    var firstFilename_1 = "";
                    string file_path_1 = "";
                    if (upload_style.HasFile)
                    {
                        string filename_1 = Path.GetFileName(upload_style.FileName);
                        string file_save_1 = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name + "/" + filename_1;
                        upload_style.SaveAs(file_save_1);
                        var shpFiles1 = new DirectoryInfo(fullpath).GetFiles("*.sld");
                        firstFilename_1 = shpFiles1[0].Name.Split('.')[0];
                        var ext_1 = shpFiles1[0].Name.Split('.')[1];
                        file_path_1 = user + "\\" + ddlfiletype.SelectedValue + "\\" + file_name + "\\" + firstFilename_1 + "." + ext_1; ;
                    }
                    string cmdpath1 = Environment.SystemDirectory;
                    //string path = Server.MapPath("~/Files/");
                    string table_name = "";
                    string layer_name = firstFilename;
                    string style_name = firstFilename_1;
                    //string m_id = ConfigurationManager.AppSettings["RasterId"].ToString();
                    //string m_id = ddllayergroupname.SelectedValue.ToString();
                    string m_id = "m_6";
                    string sub_module_id = null;
                    string str = "select case when max(sno) is null then 0 else max(sno) end srno from tbl_sub_modules_map";
                    DataTable maxSrno = this.executeGetData(str);

                    int sno = (Convert.ToInt32(maxSrno.Rows[0]["srno"].ToString()) + 1);
                    string user_id = ddl_user_name.SelectedValue;

                    if (string.IsNullOrEmpty(maxSrno.Rows[0]["srno"].ToString()))
                        sub_module_id = "sm_1";
                    else
                        sub_module_id = "sm_" + sno;
                    string sub_module_name = fileUploadTextBox.Text;
                    string module_id = ddlfiletype.SelectedValue;
                    string layer_path = file_path;
                    string style_path = file_path_1;
                    string layer_type = ddlfiletype.SelectedItem.Text;
                    Boolean layer_publish_status = false;
                    string data_type = "";
                    string projection_sys = "";
                    string elevation_field = "";
                    //data_type = ddldatatype.SelectedItem.ToString();
                    string constr = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;
                    using (NpgsqlConnection con = new NpgsqlConnection(constr))
                    {
                        NpgsqlCommand cmd = new NpgsqlCommand();
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "insert into tbl_sub_modules_map (sno, user_id, sub_module_id, sub_module_name, module_id, is_active, tbl_name, layer_path, style_path, layer_type, layer_publish_status,layer_name,style_name,data_type,projection_sys,elevation_field,created_by,file_status) values(@sno, @user_id, @sub_module_id,@sub_module_name,@module_id,@is_active,@tbl_name,@layer_path,@style_path,@layer_type,@layer_publish_status,@layer_name,@style_name,@data_type,@projection_sys,@elevation_field,@created_by,@file_status)";
                        cmd.Parameters.Add("@sno", NpgsqlTypes.NpgsqlDbType.Integer).Value = sno;
                        cmd.Parameters.Add("@user_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = user_id;
                        cmd.Parameters.Add("@sub_module_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = sub_module_id;
                        cmd.Parameters.Add("@sub_module_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = sub_module_name;
                        cmd.Parameters.Add("@module_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = m_id;
                        cmd.Parameters.Add("@is_active", NpgsqlTypes.NpgsqlDbType.Boolean).Value = true;
                        cmd.Parameters.Add("@tbl_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = table_name;
                        cmd.Parameters.Add("@layer_path", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_path;
                        cmd.Parameters.Add("@style_path", NpgsqlTypes.NpgsqlDbType.Varchar).Value = style_path;
                        cmd.Parameters.Add("@layer_type", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_type;
                        cmd.Parameters.Add("@layer_publish_status", NpgsqlTypes.NpgsqlDbType.Boolean).Value = layer_publish_status;
                        cmd.Parameters.Add("@layer_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_name;
                        cmd.Parameters.Add("@style_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = style_name;
                        cmd.Parameters.Add("@data_type", NpgsqlTypes.NpgsqlDbType.Varchar).Value = data_type;
                        cmd.Parameters.Add("@projection_sys", NpgsqlTypes.NpgsqlDbType.Varchar).Value = projection_sys;
                        cmd.Parameters.Add("@elevation_field", NpgsqlTypes.NpgsqlDbType.Varchar).Value = elevation_field;
                        cmd.Parameters.Add("@created_by", NpgsqlTypes.NpgsqlDbType.Varchar).Value = Session["UserId"].ToString();
                        cmd.Parameters.Add("@created_date", NpgsqlTypes.NpgsqlDbType.Timestamp).Value = DateTime.Now;
                        //cmd.Parameters.Add("@file_status", NpgsqlTypes.NpgsqlDbType.Varchar).Value = ddl_file_status.SelectedItem.ToString(); 
                        cmd.Parameters.Add("@file_status", NpgsqlTypes.NpgsqlDbType.Varchar).Value = "Data Repositories";
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();

                        fileUploadTextBox.Text = "";
                    }
                    //if (ddl_file_status.SelectedItem.ToString() == "Map Publishing")
                    //{
                    //    //string data_upload_in_geoserver = ConfigurationManager.AppSettings["data_upload_in_geoserver"].ToString();
                    //    //ProcessStartInfo startInfotide1 = new ProcessStartInfo();
                    //    //startInfotide1.Verb = "runas";
                    //    //startInfotide1.CreateNoWindow = false;
                    //    //startInfotide1.UseShellExecute = false;
                    //    //startInfotide1.FileName = cmdpath1 + @"\cmd.exe";
                    //    //startInfotide1.WorkingDirectory = cmdpath1;

                    //    //startInfotide1.Arguments = string.Format("/C {0} \"{1}\" \"{2}\"", data_upload_in_geoserver, sub_module_id, uname);

                    //    //using (Process exeProcess1 = Process.Start(startInfotide1))
                    //    //{
                    //    //    exeProcess1.WaitForExit();
                    //    //}
                    //    //   binddata();
                    //    // ScriptManager.RegisterStartupScript(this, GetType(), "Message", "alert('Data Uploaded Successfully.');", true);
                    //}
                    return sub_module_id;
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        string upload_excel_pdf_image_data(string user, string uname)
        {
            try
            {
                string sub_module_id = null;

                string str = "select case when max(sno) is null then 0 else max(sno) end srno from tbl_sub_modules_map";
                DataTable maxSrno = this.executeGetData(str);

                int sno = (Convert.ToInt32(maxSrno.Rows[0]["srno"].ToString()) + 1);
                if (string.IsNullOrEmpty(maxSrno.Rows[0]["srno"].ToString()))
                    sub_module_id = "sm_1";
                else
                    sub_module_id = "sm_" + sno;

                if (upload_shape_file.HasFile)
                {
                    string filename = Path.GetFileName(upload_shape_file.FileName);
                    string result = filename.Replace(" ", "");

                    string file_name = Path.GetFileNameWithoutExtension(upload_shape_file.FileName);
                    file_name = file_name + "_" + sno;
                    string file_extension = Path.GetExtension(upload_shape_file.FileName);

                    string fullpath = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue;
                    //string file_save = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name;

                    string file_save = Server.MapPath("~/Files") + "/" + user + "/" + ddlfiletype.SelectedValue + "/" + file_name + file_extension;

                    if (!Directory.Exists(fullpath))
                    {
                        Directory.CreateDirectory(fullpath);
                    }

                    upload_shape_file.SaveAs(file_save);
                    var firstFilename = "";
                    var firstFilename_1 = "";
                    var ext = "";

                    firstFilename = file_name;
                    ext = file_extension;

                    string file_path = user + "\\" + ddlfiletype.SelectedValue + "\\" + firstFilename + ext;
                    string table_name = firstFilename.ToLower();
                    string layer_name = firstFilename.ToLower();
                    string style_name = firstFilename_1;
                    //string m_id = ddllayergroupname.SelectedValue.ToString();
                    string m_id = "m_6";

                    string user_id = ddl_user_name.SelectedValue;
                    string sub_module_name = fileUploadTextBox.Text;
                    string module_id = ddlfiletype.SelectedValue;
                    string layer_path = file_path;
                    string style_path = "";
                    string layer_type = ddlfiletype.SelectedItem.Text;
                    Boolean layer_publish_status = false;

                    string data_type = "";
                    string projection_sys = "";
                    string elevation_field = "";

                    string constr = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;
                    using (NpgsqlConnection con = new NpgsqlConnection(constr))
                    {
                        NpgsqlCommand cmd = new NpgsqlCommand();
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "insert into tbl_sub_modules_map (sno, user_id, sub_module_id, sub_module_name, module_id, is_active, tbl_name, layer_path, style_path, layer_type, layer_publish_status,layer_name,style_name,data_type,projection_sys,elevation_field,created_by,created_date,file_status) values(@sno, @user_id,@sub_module_id,@sub_module_name,@module_id,@is_active,@tbl_name,@layer_path,@style_path,@layer_type,@layer_publish_status,@layer_name,@style_name,@data_type,@projection_sys,@elevation_field,@created_by,@created_date,@file_status)";
                        cmd.Parameters.Add("@sno", NpgsqlTypes.NpgsqlDbType.Integer).Value = sno;
                        cmd.Parameters.Add("@user_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = user_id;
                        cmd.Parameters.Add("@sub_module_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = sub_module_id;
                        cmd.Parameters.Add("@sub_module_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = sub_module_name;
                        cmd.Parameters.Add("@module_id", NpgsqlTypes.NpgsqlDbType.Varchar).Value = m_id;
                        cmd.Parameters.Add("@is_active", NpgsqlTypes.NpgsqlDbType.Boolean).Value = true;
                        cmd.Parameters.Add("@tbl_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = table_name;
                        cmd.Parameters.Add("@layer_path", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_path;
                        cmd.Parameters.Add("@style_path", NpgsqlTypes.NpgsqlDbType.Varchar).Value = style_path;
                        cmd.Parameters.Add("@layer_type", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_type;
                        cmd.Parameters.Add("@layer_publish_status", NpgsqlTypes.NpgsqlDbType.Boolean).Value = layer_publish_status;
                        cmd.Parameters.Add("@layer_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = layer_name;
                        cmd.Parameters.Add("@style_name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = style_name;
                        cmd.Parameters.Add("@data_type", NpgsqlTypes.NpgsqlDbType.Varchar).Value = data_type;
                        cmd.Parameters.Add("@projection_sys", NpgsqlTypes.NpgsqlDbType.Varchar).Value = projection_sys;
                        cmd.Parameters.Add("@elevation_field", NpgsqlTypes.NpgsqlDbType.Varchar).Value = elevation_field;
                        cmd.Parameters.Add("@created_by", NpgsqlTypes.NpgsqlDbType.Varchar).Value = Session["UserId"].ToString();
                        cmd.Parameters.Add("@created_date", NpgsqlTypes.NpgsqlDbType.Timestamp).Value = DateTime.Now;
                        //cmd.Parameters.Add("@file_status", NpgsqlTypes.NpgsqlDbType.Varchar).Value = ddl_file_status.SelectedItem.ToString(); 
                        cmd.Parameters.Add("@file_status", NpgsqlTypes.NpgsqlDbType.Varchar).Value = "Data Repositories";
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();

                        fileUploadTextBox.Text = "";
                    }
                    return sub_module_id;
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        protected void ddlfiletype_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                //bindtype();
                //binddatatpe();
                //layergroupname();
                bindGrid(ddl_user_name.SelectedValue, ddlfiletype.SelectedItem.Text);
            }
            catch (Exception ex)
            {

            }
        }
        protected void ddldatatype_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindGrid(ddl_user_name.SelectedValue, ddlfiletype.SelectedItem.Text);
            }
            catch (Exception ex)
            {

            }
        }
        protected void ddl_status_approved_SelectedIndexChanged(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;

            foreach (GridViewRow gvrow in grid_Modules.Rows)
            {
                DropDownList ddlaction = (DropDownList)gvrow.FindControl("ddl_status_approved");
                Label lblsno = (Label)gvrow.FindControl("lbl_sno");
                int sno = Convert.ToInt32(lblsno.Text);
                Label lblsub_module_id = (Label)gvrow.FindControl("lbl_sub_module_id");
                string sub_module_id = lblsub_module_id.Text;
                string updated_by = Session["UserId"].ToString();

                Label lbllayer_path = (Label)gvrow.FindControl("lbl_layer_path");
                string layer_path = lbllayer_path.Text;

                string filename_without_ext = "";
                //string folder = "";
                string folderPath = "";
                string ext = "";
                string extensionWithoutDot = "";

                if (layer_path != "")
                {
                    filename_without_ext = Path.GetFileNameWithoutExtension(layer_path);
                    //folder = Path.GetDirectoryName(layer_path);
                    folderPath = "~/Files/" + Path.GetDirectoryName(layer_path) + "/";
                    ext = Path.GetExtension(layer_path);
                    extensionWithoutDot = ext.TrimStart('.');
                }

                if (ddlaction.SelectedValue == "Download")
                {
                    string fullPath = Server.MapPath("~/Files/" + layer_path);
                    if (System.IO.File.Exists(fullPath))
                    {
                        if (ext != ".shp")
                        {
                            // Clear any existing response
                            Response.Clear();
                            Response.ContentType = "application/octet-stream";
                            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(fullPath));
                            Response.TransmitFile(fullPath);
                            //Response.End(); // Ensure response ends after file is sent

                            HttpContext.Current.ApplicationInstance.CompleteRequest();
                            return;
                        }
                        else
                        {
                            //string fileWithoutExtension = filename_without_ext;
                            //string folderPath = "~/Files/Admin/Vector/vector_data/";
                            //string folderPath1 = Server.MapPath("~/Files/" + layer_path);

                            DownloadFilesAsZip(filename_without_ext, folderPath);
                        }
                    }
                    else
                    {
                        // Handle the case where the file does not exist
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "fileNotFound", "alert('File not found.');", true);
                    }
                }
                else if (ddlaction.SelectedValue == "Delete")
                {
                    string query = "update tbl_sub_modules_map set is_active = false, updated_by = @updated_by, updated_date = @updated_date where sub_module_id = @sub_module_id";

                    using (NpgsqlConnection conn = new NpgsqlConnection(connectionString))
                    {
                        using (NpgsqlCommand cmd = new NpgsqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@is_active", false);
                            cmd.Parameters.AddWithValue("@updated_by", updated_by);
                            cmd.Parameters.AddWithValue("@updated_date", System.DateTime.Now);
                            cmd.Parameters.AddWithValue("@sub_module_id", sub_module_id);

                            conn.Open();
                            int rowsAffected = cmd.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                bindGrid(ddl_user_name.SelectedValue, ddlfiletype.SelectedItem.Text);
                            }

                        }
                    }
                }
                else if (ddlaction.SelectedValue == "Publish")
                {
                    //string data_upload_in_database = ConfigurationManager.AppSettings["data_upload_in_database"].ToString();
                    //ProcessStartInfo startInfotide = new ProcessStartInfo();
                    //startInfotide.Verb = "runas";
                    //startInfotide.CreateNoWindow = false;
                    //startInfotide.UseShellExecute = false;
                    //startInfotide.FileName = cmdpath1 + @"\cmd.exe";
                    //startInfotide.WorkingDirectory = cmdpath1;

                    //startInfotide.Arguments = string.Format("/C {0} \"{1}\" \"{2}\" \"{3}\" \"{4}\" \"{5}\"", data_upload_in_database, file_path, table_name, database_name, "Vector", uname);

                    //using (Process exeProcess = Process.Start(startInfotide))
                    //{
                    //    exeProcess.WaitForExit();
                    //}
                    //string data_upload_in_geoserver = ConfigurationManager.AppSettings["data_upload_in_geoserver"].ToString();
                    //ProcessStartInfo startInfotide1 = new ProcessStartInfo();
                    //startInfotide1.Verb = "runas";
                    //startInfotide1.CreateNoWindow = false;
                    //startInfotide1.UseShellExecute = false;
                    //startInfotide1.FileName = cmdpath1 + @"\cmd.exe";
                    //startInfotide1.WorkingDirectory = cmdpath1;

                    //startInfotide1.Arguments = string.Format("/C {0} \"{1}\" \"{2}\"", data_upload_in_geoserver, sub_module_id, uname);

                    //using (Process exeProcess1 = Process.Start(startInfotide1))
                    //{
                    //    exeProcess1.WaitForExit();
                    //}
                    //bindGrid(ddl_user_name.SelectedValue, ddlfiletype.SelectedItem.Text);
                    //ScriptManager.RegisterStartupScript(this, GetType(), "Message", "alert('Data Uploaded Successfully.');", true);
                    //ScriptManager.RegisterStartupScript(this, GetType(), "Javascript", "javascript:removeLoader(); ", true);
                }
            }
        }

        protected void DownloadFilesAsZip(string fileWithoutExtension, string folderPath)
        {
            string zipFilePath = null;
            try
            {
                // Directory where the files are located
                string fullDirectoryPath = Server.MapPath(folderPath);

                // Find all files with the given base name but different extensions
                string[] matchingFiles = Directory.GetFiles(fullDirectoryPath, fileWithoutExtension + ".*");

                if (matchingFiles.Length > 0)
                {
                    // Create a ZIP file to store the matched files
                    string zipFileName = fileWithoutExtension + ".zip";
                    zipFilePath = Server.MapPath("~/Files/" + zipFileName);

                    // Ensure Temp directory exists
                    string tempDir = Server.MapPath("~/Files/");
                    if (!Directory.Exists(tempDir))
                    {
                        Directory.CreateDirectory(tempDir);
                    }

                    // Create a ZIP archive
                    using (var archive = new Archive())
                    {
                        // Add each matching file to the ZIP archive
                        foreach (string file in matchingFiles)
                        {
                            archive.CreateEntry(Path.GetFileName(file), new FileInfo(file));
                        }

                        // Save the ZIP archive to the specified path
                        archive.Save(zipFilePath, new ArchiveSaveOptions());
                    }

                    // Serve the ZIP file for download
                    Response.Clear();
                    Response.ContentType = "application/zip";
                    Response.AppendHeader("Content-Disposition", "attachment; filename=" + zipFileName);
                    Response.TransmitFile(zipFilePath);
                    //Response.End();

                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                    return;

                    // Optionally delete the ZIP file after download
                    if (System.IO.File.Exists(zipFilePath))
                    {
                        System.IO.File.Delete(zipFilePath);
                    }
                }
                else
                {
                    // Handle the case where no files are found
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "fileNotFound", "alert('No matching files found.');", true);
                }
            }
            catch (Exception ex)
            {
                //if (System.IO.File.Exists(zipFilePath))
                //{
                //    System.IO.File.Delete(zipFilePath);
                //}
                // Handle any exceptions
                ScriptManager.RegisterStartupScript(this, this.GetType(), "downloadError", $"alert('An error occurred: {ex.Message}');", true);
            }
        }

        public DataTable executeGetData(string MyQuery)
        {
            NpgsqlConnection getconn;
            getconn = getConnPost();
            getconn.Open();
            DataTable ds = new DataTable();
            try
            {
                NpgsqlDataAdapter da = new NpgsqlDataAdapter(MyQuery, getconn);
                da.Fill(ds);
            }
            catch (Exception exr)
            {
            }
            finally
            {
                getconn.Close();
            }
            return ds;
        }

        public NpgsqlConnection getConnPost()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["conStrPost"].ConnectionString;
            NpgsqlConnection conn = new NpgsqlConnection(connectionString);
            return conn;
        }

        protected void ddllayergroupname_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindGrid(ddl_user_name.SelectedValue, ddlfiletype.SelectedItem.Text);
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddl_user_name_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bindGrid(ddl_user_name.SelectedValue, ddlfiletype.SelectedItem.Text);
            }
            catch (Exception ex)
            {

            }
        }
    }
}