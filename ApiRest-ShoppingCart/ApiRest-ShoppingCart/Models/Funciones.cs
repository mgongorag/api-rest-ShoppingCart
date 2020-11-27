using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace ApiRest_ShoppingCart.Models
{
    public class Funciones
    {
        private static string secretKey = "K@rA$sHnik0b";
        private static DataTable dt = new DataTable();
        public static string EncriptarSHA512(String cadena)
        {
            System.Security.Cryptography.SHA512Managed HashTool = new System.Security.Cryptography.SHA512Managed();
            Byte[] hashByte = Encoding.UTF8.GetBytes(string.Concat(cadena, secretKey));
            Byte[] encryptedByte = HashTool.ComputeHash(hashByte);
            HashTool.Clear();
            return Convert.ToBase64String(encryptedByte);
        }

        public static string getTokenSession()
        {
            Random rnd = new Random();
            int random = rnd.Next(1, 999999999);
            string date = DateTime.Now.ToString("dd/MM/yyyy");
            string hour = DateTime.Now.ToString("hh:mm:ss:fffff");
            string token = EncriptarSHA512("SystemWeb2020" + date + hour + random);
            token = Regex.Replace(token, @"[^0-9A-Za-z]", "K", RegexOptions.None);

            return token;

        }

        public static int ObtenerEstadoToken(string TxtToken)
        {
            SqlCommand Comando = Conexion.commandSP("SPObtenerEstadoToken");
            Comando.Parameters.AddWithValue("@_token", TxtToken);

            dt.Reset();
            dt.Clear();

            dt = Conexion.execCommandSelect(Comando);
            return Convert.ToInt32(dt.Rows[0][0].ToString());
        }

        public static DataTable AgregarEstadoToken(DataTable dt, string Estado)
        {
            if (dt.Rows.Count > 0)
            {
                dt.Columns.Add("EstatoToken", typeof(string), Estado).SetOrdinal(0);
            }
            else
            {
                dt.Reset();
                dt.Clear();

                try
                {
                    DataColumn Col = new DataColumn();
                    Col.ColumnName = "EstadoToken";
                    dt.Columns.Add(Col);

                    DataRow Fila = dt.NewRow();
                    Fila["EstadoToken"] = Estado;
                    dt.Rows.Add(Fila);
                }
                catch
                {
                    DataRow Fila = dt.NewRow();
                    Fila["EstadoToken"] = Estado;
                    dt.Rows.Add(Fila);
                }
            }
            return dt;
        }



        public static DataTable retornarException(Entidades.Excepcion excepcion)
        {

            DataRow row = dt.NewRow();
            dt.Clear();
            dt.Reset();
            

            dt.Columns.Add("estado", typeof(bool));
            dt.Columns.Add("message", typeof(string));
            dt.Columns.Add("errorMessage", typeof(string));

            row["estado"] = excepcion.estado;
            row["message"] = excepcion.message;
            row["errorMessage"] = excepcion.errorMessage;


            dt.Rows.Add(row);
            return dt;

        }

    }
}