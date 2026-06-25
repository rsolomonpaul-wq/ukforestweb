using System;
using System.Configuration;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace uk_forest.web
{
    public partial class forgotpassword : Page
    {
        // EncryptionKey — same jo SendResetEmail mein use kiya hai
        private static readonly string EncryptionKey =
            ConfigurationManager.AppSettings["EncryptionKey"] ?? "UKForest@2026#SecretKey!@#$%^&*()";
        string apiUrl = ConfigurationSettings.AppSettings["api_path"];
        // ===================================================
        // PAGE LOAD — URL se em & t parameter lo
        // ===================================================
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string encryptedEm = Request.QueryString["em"];
                string encryptedT = Request.QueryString["t"];

                if (string.IsNullOrEmpty(encryptedEm) || string.IsNullOrEmpty(encryptedT))
                {
                    ShowPanel("invalid");
                    return;
                }

                string decryptedEmail = DecryptString(encryptedEm);

                if (string.IsNullOrEmpty(decryptedEmail))
                {
                    ShowPanel("invalid");
                    return;
                }

                // ✅ Encrypted time hidden field mein store karo
                // (Backend compare karega jab user Submit karega)
                hfEncryptedTime.Value = encryptedT;

                ViewState["DecryptedEmail"] = decryptedEmail;
                lblMaskedEmail.Text = MaskEmail(decryptedEmail);
                ShowPanel("verify");
            }
        }

        // ===================================================
        // STEP 1 — EMAIL VERIFY BUTTON
        // ===================================================
        protected void btnVerifyEmail_Click(object sender, EventArgs e)
        {
            // ✅ Yahan time check karo — hidden field se encrypted time lo
            string encryptedT = hfEncryptedTime.Value;

            if (!string.IsNullOrEmpty(encryptedT))
            {
                string decryptedTime = DecryptString(encryptedT);

                if (!string.IsNullOrEmpty(decryptedTime))
                {
                    DateTime linkTime;
                    bool parsed = DateTime.TryParseExact(
                        decryptedTime,
                        "yyyy-MM-dd HH:mm:ss",
                        System.Globalization.CultureInfo.InvariantCulture,
                        System.Globalization.DateTimeStyles.None,
                        out linkTime
                    );

                    if (!parsed || (DateTime.Now - linkTime).TotalMinutes > 15)
                    {
                        // ✅ 15 minutes se zyada ho gaye
                        ShowPanel("expired");
                        return;
                    }
                }
            }

            // Email match check
            string entered = txtConfirmEmail.Text.Trim().ToLower();
            string decrypted = (ViewState["DecryptedEmail"]?.ToString() ?? "").ToLower();

            if (string.IsNullOrEmpty(entered))
            {
                ShowVerifyError("Please enter your email address.");
                return;
            }

            if (entered != decrypted)
            {
                ShowVerifyError("Email address does not match. Please try again.");
                return;
            }

            // ✅ Match — Step 2 dikhao
            ViewState["VerifiedEmail"] = decrypted;
            ShowPanel("password");
        }

        // ===================================================
        // STEP 2 — RESET PASSWORD BUTTON
        // ===================================================
        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string newPwd = txtNewPassword.Text.Trim();
            string confirmPwd = txtConfirmPassword.Text.Trim();

            if (string.IsNullOrEmpty(newPwd) || string.IsNullOrEmpty(confirmPwd))
            {
                ShowPasswordError("Please fill in both password fields.");
                return;
            }

            if (newPwd.Length < 6)
            {
                ShowPasswordError("Password must be at least 6 characters long.");
                return;
            }

            if (newPwd != confirmPwd)
            {
                ShowPasswordError("Passwords do not match. Please try again.");
                return;
            }

            try
            {
                string email = ViewState["VerifiedEmail"]?.ToString() ?? "";

                using (HttpClient client = new HttpClient())
                {
                    string url = apiUrl + "TblUserMasters/UpdatePasswordByEmail";

                    var content = new StringContent(
                        Newtonsoft.Json.JsonConvert.SerializeObject(new
                        {
                            emailId = email,
                            password = newPwd
                        }),
                        Encoding.UTF8,
                        "application/json"
                    );

                    HttpResponseMessage response = client.PostAsync(url, content).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        ShowPanel("success");
                    }
                    else
                    {
                        ShowPasswordError("Something went wrong. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowPasswordError("An error occurred. Please try again.");
                Console.WriteLine("Reset Error: " + ex.Message);
            }
        }

        // ===================================================
        // HELPERS
        // ===================================================
        private void ShowPanel(string panel)
        {
            pnlVerify.Visible = panel == "verify";
            pnlPassword.Visible = panel == "password";
            pnlSuccess.Visible = panel == "success";
            pnlInvalid.Visible = panel == "invalid";
            pnlExpired.Visible = panel == "expired";

            // Error panels reset
            if (panel != "verify")
            {
                pnlVerifyError.Visible = false;
            }
            if (panel != "password")
            {
                pnlPasswordError.Visible = false;
            }

            // Step bar
            bool showSteps = (panel == "verify" || panel == "password" || panel == "success");
            stepsBar.Visible = showSteps;

            if (!showSteps) return;

            switch (panel)
            {
                case "verify":
                    step1Div.Attributes["class"] = "step active";
                    step2Div.Attributes["class"] = "step";
                    step3Div.Attributes["class"] = "step";
                    stepLine1.Attributes["class"] = "step-line";
                    stepLine2.Attributes["class"] = "step-line";
                    break;

                case "password":
                    step1Div.Attributes["class"] = "step done";
                    step2Div.Attributes["class"] = "step active";
                    step3Div.Attributes["class"] = "step";
                    stepLine1.Attributes["class"] = "step-line done";
                    stepLine2.Attributes["class"] = "step-line";
                    break;

                case "success":
                    step1Div.Attributes["class"] = "step done";
                    step2Div.Attributes["class"] = "step done";
                    step3Div.Attributes["class"] = "step done";
                    stepLine1.Attributes["class"] = "step-line done";
                    stepLine2.Attributes["class"] = "step-line done";
                    break;
            }
        }

        private void ShowVerifyError(string msg)
        {
            pnlVerifyError.Visible = true;
            lblVerifyError.Text = msg;
            ShowPanel("verify");
        }

        private void ShowPasswordError(string msg)
        {
            pnlPasswordError.Visible = true;
            lblPasswordError.Text = msg;
            ShowPanel("password");
        }

        private string MaskEmail(string email)
        {
            try
            {
                int atIndex = email.IndexOf('@');
                if (atIndex <= 1) return email;
                string local = email.Substring(0, atIndex);
                string domain = email.Substring(atIndex);
                if (local.Length <= 4)
                    return new string('*', local.Length) + domain;
                return local.Substring(0, 2)
                     + new string('*', local.Length - 4)
                     + local.Substring(local.Length - 2, 2)
                     + domain;
            }
            catch { return "***@***.com"; }
        }

        private string DecryptString(string encryptedText)
        {
            try
            {
                if (string.IsNullOrEmpty(encryptedText)) return string.Empty;
                if (string.IsNullOrEmpty(EncryptionKey)) return string.Empty;

                string base64 = encryptedText.Replace("-", "+").Replace("_", "/").Replace("~", "=");
                byte[] encryptedBytes = Convert.FromBase64String(base64);
                byte[] key = SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(EncryptionKey));
                byte[] iv = new byte[16];

                using (Aes aes = Aes.Create())
                {
                    aes.Key = key;
                    aes.IV = iv;
                    aes.Mode = CipherMode.CBC;
                    aes.Padding = PaddingMode.PKCS7;

                    using (ICryptoTransform decryptor = aes.CreateDecryptor())
                    {
                        byte[] plainBytes = decryptor.TransformFinalBlock(
                            encryptedBytes, 0, encryptedBytes.Length);
                        return Encoding.UTF8.GetString(plainBytes);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Decrypt Error: " + ex.Message);
                return string.Empty;
            }
        }
    }
}