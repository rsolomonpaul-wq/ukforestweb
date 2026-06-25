using Npgsql;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;

namespace uk_forest.datalayer
{
    public class dbquery
    {
        DataTable resultdt = new DataTable();
        NpgsqlConnection conn = null;
        NpgsqlCommand cmd = null;
        NpgsqlDataReader DataReader = null;
        NpgsqlDataAdapter dataAdapter = null;

        string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        public NpgsqlConnection CreateConnection()
        {
            conn = new NpgsqlConnection(connStr);
            return conn;
        }
        //public DataTable executeGetData(string _query)
        //{
        //    DataTable dt_1 = null;
        //    try
        //    {

        //        using (conn = CreateConnection())
        //        {
        //            using (dataAdapter = new NpgsqlDataAdapter(_query, conn))
        //            {
        //                using (dt_1 = new DataTable())
        //                {
        //                    dataAdapter.Fill(dt_1);

        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        //throw;
        //    }
        //    return dt_1;
        //}


        public DataTable executeGetData(string _query)
        {
            DataTable dt_1 = new DataTable();

            try
            {
                LogMessage("Executing Query: " + _query);

                using (var conn = CreateConnection())
                {
                    using (var dataAdapter = new NpgsqlDataAdapter(_query, conn))
                    {
                        dataAdapter.Fill(dt_1);
                    }
                }

                LogMessage("Success. Rows: " + dt_1.Rows.Count);
            }
            catch (Exception ex)
            {
                LogMessage("ERROR: " + ex.Message);
            }

            return dt_1;
        }
        public void LogMessage(string message)
        {
            try
            {
                string folderPath = @"C:\Logs";
                string fileName = "db_log.txt"; // single file
                string filePath = Path.Combine(folderPath, fileName);

                // Create directory if not exists
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                // Log format with date & time
                string log = $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} - {message}";

                // Append text (auto create if not exists)
                File.AppendAllText(filePath, log + Environment.NewLine);
            }
            catch
            {
                // avoid crash if logging fails
            }
        }
        public int executeNonQuery(string _query)
        {
            int rowsAffected = 0;
            try
            {
                using (conn = CreateConnection())
                {
                    using (cmd = new NpgsqlCommand(_query, conn))
                    {
                        conn.Open();
                        rowsAffected = cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log exception
            }
            return rowsAffected;
        }
    }
}