using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ApiRest_ShoppingCart.Models
{
    public class Conexion
    {
        private static string user = "sa";
        private static string password = "admin";
        private static string server = "GODLIKE";
        private static string database = "ShoppingCart";

        public static string getConString()
        {
            return "Persist Security Info = false; User ID = '" + user
                      + "'; Password = '" + password
                      + "'; Initial Catalog = '" + database
                      + "'; Server = '" + server + "'";
        }

        public static SqlCommand commandSP(string SP)
        {
            string strConnection = Conexion.getConString();
            SqlConnection myConString = new SqlConnection(strConnection);
            SqlCommand command = new SqlCommand(SP, myConString);
            command.CommandType = System.Data.CommandType.StoredProcedure;
            return command;
        }

        public static DataTable execCommandSelect(SqlCommand command)
        {
            DataTable dt = new DataTable();
            try
            {
                command.Connection.Open();
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                adapter.Fill(dt);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                command.Connection.Dispose();
                command.Connection.Close();
            }
            return dt;
        }
    }


}
