using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace uk_forest.Forest
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    btnSendReset.Text = "Verify Email";
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void btnSendReset_Click(object sender, EventArgs e)
        {
            try
            {
                if (btnSendReset.Text == "Verify Email")
                {
                    otpdiv.Visible = true;
                    btnSendReset.Text = "Send Otp";
                }
                else if (btnSendReset.Text == "Send Otp")
                {
                    Divpassword.Visible = true;
                    Divpasswordconfirm.Visible = true;
                    btnSendReset.Text = "Change Password";
                }
                if (btnSendReset.Text == "Change Password")
                {
                    // Your password change logic

                    // Show the popup    
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "showPopup", "showPopup();", true);
                }
            }
            catch (Exception ex)
            {
                // Handle error (optional)
            }
        }

    }
}