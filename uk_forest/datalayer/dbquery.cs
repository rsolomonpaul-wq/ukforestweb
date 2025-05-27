using Npgsql;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
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
        public DataTable executeGetData(string _query)
        {
            DataTable dt_1 = null;
            try
            {

                using (conn = CreateConnection())
                {
                    using (dataAdapter = new NpgsqlDataAdapter(_query, conn))
                    {
                        using (dt_1 = new DataTable())
                        {
                            dataAdapter.Fill(dt_1);
                             
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                //throw;
            }
            return dt_1;
        }
    }
}