using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using uk_forest.datalayer;

namespace uk_forest.Forest
{
    public partial class hwcApplicantDashboard : System.Web.UI.Page
    {
        string token_sess;
        HttpClient client = new HttpClient();
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        dbquery connectDB = new dbquery();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DateTime dtm = DateTime.Today;
                DateTime dtm1 = DateTime.Today.AddMonths(-1);

                txtStartDate.Text = dtm1.ToString("yyyy-MM-dd");
                txtEndDate.Text = dtm.ToString("yyyy-MM-dd");
                BindDivision();
                bindcarddata();
            }
        }



        void BindDivision()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblDivisionMasters/GetTblDivisionMasters")).Result;

                    if (Res.IsSuccessStatusCode)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                        ddlDivision.Items.Clear();
                        ddlDivision.DataSource = dt;
                        ddlDivision.DataValueField = "Gid";
                        ddlDivision.DataTextField = "Division";
                        ddlDivision.DataBind();
                        ddlDivision.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                        ddlRange.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddlDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                popup.Visible = false;
                Int32 zoneId = 0;
                Int32 circleId = 0;
                Int32 divisionId = Convert.ToInt32(ddlDivision.SelectedValue);
                BindRange(zoneId, circleId, divisionId);
            }
            catch (Exception ex)
            {

            }
        }

        void BindRange(Int32 zoneId, Int32 circleId, Int32 divisionId)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);

                    HttpResponseMessage Res = client.GetAsync(apiUrl + string.Format("TblRangeMasters/GetRangeMaster_ByDivisionId?zoneId=" + zoneId + "&circleId=" + circleId + "&divisionId=" + divisionId)).Result;
                    if (divisionId != 0)
                    {
                        if (Res.IsSuccessStatusCode)
                        {
                            var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                            DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));

                            ddlRange.Items.Clear();
                            ddlRange.DataSource = dt;
                            ddlRange.DataValueField = "rangeId";
                            ddlRange.DataTextField = "rangeName";
                            ddlRange.DataBind();
                            ddlRange.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                        }
                    }
                    else
                    {
                        ddlRange.Items.Clear();

                        ddlRange.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "0"));
                    }

                }
            }
            catch (Exception ex)
            {

            }
        }



        void bindcarddata()
        {
            try
            {
                popup.Visible = false;
                string conflictcategory = ddlDataType.SelectedValue;
                string datefrom = Convert.ToDateTime(txtStartDate.Text).ToString("yyyy-MM-dd");
                string dateto = Convert.ToDateTime(txtEndDate.Text).ToString("yyyy-MM-dd");
                string division = ddlDivision.SelectedValue;
                string range = ddlRange.SelectedValue;
                DataTable dt = new DataTable();
                DataTable filtered_activecases = new DataTable();
                DataTable filtered_pendingcases = new DataTable();
                DataTable filtered_inprocess = new DataTable();
                DataTable filtered_solved = new DataTable();

                string animalnames = "";
                string animaloccurance = "";
                string lblrange = "";
                string valrange = "";
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    string api_url = apiUrl + string.Format("TblVictimIncidents/GetIncidentDetailByDate?fromDate=" + datefrom + "&toDate=" + dateto + "&conflict_category=" + conflictcategory + "&division_id=" + division + "&range_id=" + range + "");
                    HttpResponseMessage Res = client.GetAsync(api_url).Result;

                    if (Res.StatusCode == HttpStatusCode.OK)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));
                        if (dt.Rows.Count > 0)
                        {
                            filtered_activecases = dt.Clone();
                            filtered_pendingcases = dt.Clone();
                            filtered_inprocess = dt.Clone();
                            filtered_solved = dt.Clone();

                            grdmastertable.DataSource = dt;
                            grdmastertable.DataBind();


                            foreach (DataRow row in dt.Select("status = 'Pending' OR status = 'Approved by RO' OR status = 'Approved by SDO'"))
                            {
                                filtered_activecases.ImportRow(row);

                            }
                            foreach (DataRow row in dt.Select("status = 'Pending'"))
                            {
                                filtered_pendingcases.ImportRow(row);
                            }
                            foreach (DataRow row in dt.Select("status = 'Approved by RO' OR status = 'Approved by SDO'"))
                            {
                                filtered_inprocess.ImportRow(row);
                            }
                            foreach (DataRow row in dt.Select("status = 'Approved by DFO'"))
                            {
                                filtered_solved.ImportRow(row);
                            }

                            totalcase.Value = Convert.ToString(dt.Rows.Count);
                            activecase.Value = Convert.ToString(filtered_activecases.Rows.Count);
                            pendingcase.Value = Convert.ToString(filtered_pendingcases.Rows.Count);
                            inprocesscase.Value = Convert.ToString(filtered_inprocess.Rows.Count);
                            solvedcase.Value = Convert.ToString(filtered_solved.Rows.Count);


                            var uniquerange = dt.AsEnumerable()
                                  .GroupBy(row => row.Field<string>("rangeName"))
                                  .Select(g => new
                                  {
                                      range = g.Key,
                                      rangecount = g.Count()
                                  });

                            int rangetot = uniquerange.Count();
                            int c = 0;


                            foreach (var item in uniquerange)
                            {
                                c++;
                                lblrange += item.range;
                                valrange += item.rangecount;

                                if (c != rangetot)
                                {
                                    lblrange += ",";
                                    valrange += ",";
                                }
                            }


                            var uniqueLocalNames = dt.AsEnumerable()
                                  .GroupBy(row => row.Field<string>("localName"))
                                  .Select(g => new
                                  {
                                      LocalName = g.Key,
                                      Count = g.Count()
                                  });

                            int total = uniqueLocalNames.Count();
                            int i = 0;

                            foreach (var item in uniqueLocalNames)
                            {
                                i++;
                                animalnames += item.LocalName;
                                animaloccurance += item.Count;

                                if (i != total)
                                {
                                    animalnames += ",";
                                    animaloccurance += ",";
                                }
                            }
                        }
                        else
                        {
                            DataTable emptydt = new DataTable();
                            grdmastertable.DataSource = emptydt;
                            grdmastertable.DataBind();
                        }



                    }
                    else
                    {
                        totalcase.Value = Convert.ToString(dt.Rows.Count);
                        activecase.Value = Convert.ToString(filtered_activecases.Rows.Count);
                        pendingcase.Value = Convert.ToString(filtered_pendingcases.Rows.Count);
                        inprocesscase.Value = Convert.ToString(filtered_inprocess.Rows.Count);
                        solvedcase.Value = Convert.ToString(filtered_solved.Rows.Count);
                        DataTable emptydt = new DataTable();
                        grdmastertable.DataSource = emptydt;
                        grdmastertable.DataBind();

                    }

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "runScript", "callmap();", true);
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "chartscript", "chartanimal();", true);
                    string script = $"chartanimal('{animalnames}', '{animaloccurance}');";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "chartscript", script, true);

                    string scriptrange = $"chartrange('{lblrange}', '{valrange}');";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "chartscript1", scriptrange, true);

                    string scriptrangecards = $"animateCases({totalcase.Value}, {activecase.Value}, {pendingcase.Value}, {inprocesscase.Value}, {solvedcase.Value});;";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "scriptrangecard", scriptrangecards, true);


                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            bindcarddata();
        }

        //protected void btnshowCase_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        string incidentId = "";
        //        LinkButton btn = (LinkButton)sender;
        //        GridViewRow row = (GridViewRow)btn.NamingContainer;

        //        incidentId = grdmastertable.DataKeys[row.RowIndex].Value.ToString();
        //        Response.Write("Clicked Incident ID: " + incidentId);

        //        using (var client = new HttpClient())
        //        {
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
        //            string api_url = apiUrl + string.Format("TblVictimIncidents/GetIncidentDetailsById?incidentId=" + incidentId + "");
        //            HttpResponseMessage Res = client.GetAsync(api_url).Result;

        //            if (Res.StatusCode == HttpStatusCode.OK)
        //            {
        //                var EmpResponse = Res.Content.ReadAsStringAsync().Result;
        //                // Assuming `jsonData` is a string containing your JSON
        //                var json = JObject.Parse(EmpResponse);

        //                // Top-level incident info
        //                lblIncidentId.Text = (string)json["incidentId"];
        //                lblIncidentDate.Text = DateTime.Parse((string)json["incidentDate"]).ToString("dd MMM yyyy");
        //                lblIncidentPlace.Text = (string)json["incidentPlace"];
        //                lblActivity.Text = (string)json["activity"];
        //                lblStatus.Text = (string)json["status"];
        //                lblLatitude.Text = (string)json["latitude"];
        //                lblLongitude.Text = (string)json["longitude"];

        //                // Victim Info
        //                lblVictimName.Text = (string)json["victim"]["name"];
        //                lblVictimAge.Text = json["victim"]["age"].ToString();
        //                lblVictimGender.Text = (string)json["victim"]["gender"];
        //                lblVictimAadhar.Text = (string)json["victim"]["aadharNo"];

        //                // Applicant Info
        //                lblApplicantName.Text = (string)json["applicant"]["name"];
        //                lblApplicantMobile.Text = (string)json["applicant"]["mobileNo"];
        //                lblApplicantAddress.Text = (string)json["applicant"]["address"];
        //                lblApplicantAadhar.Text = (string)json["applicant"]["aadharNo"];

        //                // Conflict Animal Info
        //                lblAnimalName.Text = (string)json["conflictAnimal"]["animalName"];
        //                lblAnimalLocalName.Text = (string)json["conflictAnimal"]["localName"];
        //                lblConflictCategory.Text = (string)json["conflictAnimal"]["conflictCategory"];

        //                // Location Info
        //                lblRange.Text = (string)json["location"]["range"];
        //                lblSubDivision.Text = (string)json["location"]["subDivision"];
        //                lblDivision.Text = (string)json["location"]["division"];
        //                lblCircle.Text = (string)json["location"]["circle"];
        //                lblZone.Text = (string)json["location"]["zone"];

        //                popup.Style.Add("display", "block");
        //                popup.Visible = true;
        //                //upd.Update();
        //                //DataTable dt = (DataTable)JsonConvert.DeserializeObject(EmpResponse, (typeof(DataTable)));
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}

        protected void btnshowCase_Click(object sender, EventArgs e)
        {
            try
            {
                popup.Visible = false;
                string incidentId = "";
                Button btn = (Button)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                incidentId = grdmastertable.DataKeys[row.RowIndex].Value.ToString();

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token_sess);
                    string api_url = apiUrl + $"TblVictimIncidents/GetIncidentDetailsById?incidentId={incidentId}";
                    HttpResponseMessage Res = client.GetAsync(api_url).Result;

                    if (Res.StatusCode == HttpStatusCode.OK)
                    {
                        var EmpResponse = Res.Content.ReadAsStringAsync().Result;
                        var json = JObject.Parse(EmpResponse);

                        // Show Popup


                        // Incident Info
                        lblIncidentId.Text = (string)json["incidentId"];
                        lblIncidentDate.Text = (string)json["incidentDate"];
                        lblIncidentPlace.Text = (string)json["incidentPlace"];
                        lblActivity.Text = (string)json["activity"];
                        lblStatus.Text = (string)json["status"];
                        lblLatitude.Text = json["latitude"].ToString();
                        lblLongitude.Text = json["longitude"].ToString();

                        // Victim Info
                        lblVictimName.Text = (string)json["victim"]["name"];
                        lblVictimAge.Text = json["victim"]["age"].ToString();
                        lblVictimGender.Text = (string)json["victim"]["gender"];
                        lblVictimAadhar.Text = (string)json["victim"]["aadharNo"];

                        // Applicant Info
                        lblApplicantName.Text = (string)json["applicant"]["name"];
                        lblApplicantMobile.Text = (string)json["applicant"]["mobileNo"];
                        lblApplicantAddress.Text = (string)json["applicant"]["address"];
                        lblApplicantAadhar.Text = (string)json["applicant"]["aadharNo"];

                        // Conflict Animal
                        lblAnimalName.Text = (string)json["conflictAnimal"]["animalName"];
                        lblAnimalLocalName.Text = (string)json["conflictAnimal"]["localName"];
                        lblConflictCategory.Text = (string)json["conflictAnimal"]["conflictCategory"];

                        // Location Info
                        lblRange.Text = (string)json["location"]["range"];
                        lblSubDivision.Text = (string)json["location"]["subDivision"];
                        lblDivision.Text = (string)json["location"]["division"];
                        lblCircle.Text = (string)json["location"]["circle"];
                        lblZone.Text = (string)json["location"]["zone"];

                        // Payment Info
                        var payments = json["payments"];
                        if (payments != null && payments.HasValues)
                        {
                            var adv = payments.FirstOrDefault(p => (string)p["paymentType"] == "Advance");
                            var rem = payments.FirstOrDefault(p => (string)p["paymentType"] == "Remaining");

                            if (adv != null)
                            {
                                lblAdvanceAmount.Text = adv["paymentAmount"]?.ToString();
                                lblAdvanceStatus.Text = (string)adv["paymentStatus"];
                                lblAdvanceMode.Text = (string)adv["paymentMode"];
                                lblAdvanceReference.Text = (string)adv["paymentReferenceNo"];
                                lblAdvanceDate.Text = adv["paymentDate"] != null ?
                                                      DateTime.Parse(adv["paymentDate"].ToString()).ToString("dd-MM-yyyy hh:mm tt") : "";
                                lblAdvanceRemarks.Text = (string)adv["remarks"];
                            }
                            else
                            {
                                lblAdvanceAmount.Text = "";
                                lblAdvanceStatus.Text = "";
                                lblAdvanceMode.Text = "";
                                lblAdvanceReference.Text = "";
                                lblAdvanceDate.Text = "";
                                lblAdvanceRemarks.Text = "";
                            }

                            if (rem != null)
                            {
                                lblRemainingAmount.Text = rem["paymentAmount"]?.ToString();
                                lblRemainingStatus.Text = (string)rem["paymentStatus"];
                                lblRemainingMode.Text = (string)rem["paymentMode"];
                                lblRemainingReference.Text = (string)rem["paymentReferenceNo"];
                                lblRemainingDate.Text = rem["paymentDate"] != null ?
                                                        DateTime.Parse(rem["paymentDate"].ToString()).ToString("dd-MM-yyyy hh:mm tt") : "";
                                lblRemainingRemarks.Text = (string)rem["remarks"];
                            }
                            else
                            {
                                lblRemainingAmount.Text = "";
                                lblRemainingStatus.Text = "";
                                lblRemainingMode.Text = "";
                                lblRemainingReference.Text = "";
                                lblRemainingDate.Text = "";
                                lblRemainingRemarks.Text = "";
                            }
                        }
                        else
                        {
                            lblAdvanceAmount.Text = "";
                            lblAdvanceStatus.Text = "";
                            lblAdvanceMode.Text = "";
                            lblAdvanceReference.Text = "";
                            lblAdvanceDate.Text = "";
                            lblAdvanceRemarks.Text = "";
                            lblRemainingAmount.Text = "";
                            lblRemainingStatus.Text = "";
                            lblRemainingMode.Text = "";
                            lblRemainingReference.Text = "";
                            lblRemainingDate.Text = "";
                            lblRemainingRemarks.Text = "";
                        }

                        // Document Info
                        var docs = json["documents"];
                        if (docs != null && docs.HasValues)
                        {
                            foreach (var doc in docs)
                            {
                                string docName = (string)doc["documentName"];
                                string path = (string)doc["filePath"];
                                if (docName == "Photograph")
                                {
                                    string pth = "";
                                    // lblPhotographDoc.Text = "http://203.122.5.18:9008/uk_forest_web/web/"+  path;
                                    if (path == null || path == "")
                                    {
                                        pth = "/web/img/icons/Image_not_available.png";
                                    }
                                    else
                                    {
                                        pth = path.Replace("\\", "/");
                                    }

                                    //PhotographDoc.Src = "http://203.122.5.18:9008/uk_forest_web/" + pth;

                                    PhotographDoc.Src = "https://ukforestgis.in/" + pth;
                                }
                                else if (docName == "Village Head Certificate")
                                {
                                    string pth = "";
                                    if (path == null || path == "")
                                    {
                                        pth = "/web/img/icons/Image_not_available.png";
                                    }
                                    else
                                    {
                                        pth = path.Replace("\\", "/");
                                    }
                                    //VillageHeadCert.Src = "http://203.122.5.18:9008/uk_forest_web/" + pth;

                                    VillageHeadCert.Src = "https://ukforestgis.in/" + pth;
                                }
                                else
                                {
                                    string pth = "";

                                    pth = "/web/img/icons/Image_not_available.png";

                                    //VillageHeadCert.Src = "http://203.122.5.18:9008/uk_forest_web/" + pth;
                                    //PhotographDoc.Src = "http://203.122.5.18:9008/uk_forest_web/" + pth;

                                    VillageHeadCert.Src = "https://ukforestgis.in/" + pth;
                                    PhotographDoc.Src = "https://ukforestgis.in/" + pth;
                                }
                            }
                        }

                        // Show popup


                        popup.Style.Add("display", "block");
                        popup.Visible = true;

                    }
                }
            }
            catch (Exception ex)
            {
                // Handle/log error
            }
        }

        protected void btnclosepopup_Click(object sender, EventArgs e)
        {
            popup.Visible = false;
        }
    }

}


