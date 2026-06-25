using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;

namespace uk_forest
{
    public static class ApiHelper
    {
        private static readonly HttpClient _client = new HttpClient();
        private static readonly string _apiBaseUrl = ConfigurationSettings.AppSettings["api_path"];



        public static ApiResult PostIncidentProgressLog(Page page, string incidentId, string roleId, string roleName, string action, string createdBy, string remarks)
        {
            try
            {
                var incidentProgressLog = new
                {
                    LogId = 0,
                    IncidentId = incidentId,
                    RoleId = roleId,
                    RoleName = roleName,
                    Action = action,
                    CreatedBy = createdBy,
                    CreatedDate = DateTime.Now,
                    Remarks = remarks
                };

                var json = JsonSerializer.Serialize(incidentProgressLog);
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                var apiUrl = $"{_apiBaseUrl}IncidentProgressLogs/PostIncidentProgressLog";

                System.Diagnostics.Debug.WriteLine($"Posting to {apiUrl}: {json}");

                var response = _client.PostAsync(apiUrl, content).Result;
                var result = response.Content.ReadAsStringAsync().Result;

                System.Diagnostics.Debug.WriteLine($"Response from PostIncidentProgressLog: StatusCode={response.StatusCode}, Content={result}");

                if (response.IsSuccessStatusCode)
                {
                    return new ApiResult
                    {
                        Success = true,
                        Message = "Incident log saved successfully.",
                        RawResponse = result
                    };
                }
                else
                {
                    string errorMessage = "Unknown error";
                    try
                    {
                        var jsonError = JsonSerializer.Deserialize<JsonElement>(result);
                        errorMessage = jsonError.TryGetProperty("Status", out var status)
                            ? status.GetString()
                            : jsonError.TryGetProperty("errors", out var errors)
                                ? errors.ToString()
                                : jsonError.TryGetProperty("title", out var title)
                                    ? title.GetString()
                                    : result;
                    }
                    catch
                    {
                        errorMessage = result;
                    }

                    ScriptManager.RegisterStartupScript(page, page.GetType(), "showalert", $"alert('Error saving incident progress log: {errorMessage}');", true);

                    return new ApiResult
                    {
                        Success = false,
                        Message = errorMessage,
                        RawResponse = result
                    };
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(page, page.GetType(), "showalert", $"alert('Exception in PostIncidentProgressLog: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Exception in PostIncidentProgressLog: {ex.StackTrace}");

                return new ApiResult
                {
                    Success = false,
                    Message = ex.Message,
                    RawResponse = null
                };
            }
        }
        public class ApiResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public string RawResponse { get; set; }
        }



        //public static async Task<bool> PostIncidentProgressLog(Page page, string incidentId, string roleId, string roleName, string action, string createdBy, string remarks)
        //{
        //    try
        //    {
        //        var incidentProgressLog = new
        //        {
        //            LogId = 0, 
        //            IncidentId = incidentId,
        //            RoleId = roleId, // string roleid = Session["RoleId"]?.ToString();
        //            RoleName = roleName,  //string userId = Session["UserId"]?.ToString();
        //            Action = action,
        //            CreatedBy = createdBy,  // string userId = Session["UserId"]?.ToString();
        //            CreatedDate = DateTime.Now, 
        //            Remarks = remarks
        //        };

        //        var json = JsonSerializer.Serialize(incidentProgressLog);
        //        var content = new StringContent(json, Encoding.UTF8, "application/json");
        //        var apiUrl = $"{_apiBaseUrl}IncidentProgressLogs/PostIncidentProgressLog";

        //        // Log the request for debugging
        //        System.Diagnostics.Debug.WriteLine($"Posting to {apiUrl}: {json}");

        //        var response = await _client.PostAsync(apiUrl, content);
        //        var result = await response.Content.ReadAsStringAsync();
        //        System.Diagnostics.Debug.WriteLine($"Response from PostIncidentProgressLog: StatusCode={response.StatusCode}, Content={result}");

        //        if (response.IsSuccessStatusCode)
        //        {
        //            return true;
        //        }
        //        else
        //        {
        //            string errorMessage = "Unknown error";
        //            try
        //            {
        //                var jsonError = JsonSerializer.Deserialize<JsonElement>(result);
        //                errorMessage = jsonError.TryGetProperty("Status", out var status)
        //                    ? status.GetString()
        //                    : jsonError.TryGetProperty("errors", out var errors)
        //                        ? errors.ToString()
        //                        : jsonError.TryGetProperty("title", out var title)
        //                            ? title.GetString()
        //                            : result;
        //            }
        //            catch
        //            {
        //                errorMessage = result;
        //            }
        //            ScriptManager.RegisterStartupScript(page, page.GetType(), "showalert", $"alert('Error saving incident progress log: {errorMessage}');", true);
        //            return false;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ScriptManager.RegisterStartupScript(page, page.GetType(), "showalert", $"alert('Exception in PostIncidentProgressLog: {ex.Message}');", true);
        //        System.Diagnostics.Debug.WriteLine($"Exception in PostIncidentProgressLog: {ex.StackTrace}");
        //        return false;
        //    }
        //}
    }
}