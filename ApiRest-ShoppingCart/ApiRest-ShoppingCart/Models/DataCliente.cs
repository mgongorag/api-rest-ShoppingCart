using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ApiRest_ShoppingCart.Models
{
    public class DataCliente
    {
        private static Funciones function = new Funciones();
        private static DataTable dt = new DataTable();
        private static int estado = 0;

        public static DataTable registrarUsuario(Entidades.Cliente cliente)
        {
            SqlCommand command = Conexion.commandSP("SPRegistroCliente");
            command.Parameters.AddWithValue("@_nombre", cliente.nombre);
            command.Parameters.AddWithValue("@_apellido", cliente.apellidos);
            command.Parameters.AddWithValue("@_fechaNacimiento", cliente.fechaNacimiento);
            command.Parameters.AddWithValue("@_email", cliente.email);
            command.Parameters.AddWithValue("@_password", Funciones.EncriptarSHA512(cliente.password));
            command.Parameters.AddWithValue("@_telefono", cliente.telefono);
            command.Parameters.AddWithValue("@_telefono2", cliente.telefono2);
            command.Parameters.AddWithValue("@_token", Funciones.getTokenSession());

            return  Conexion.execCommandSelect(command);

        }

        public static DataTable loginCliente(Entidades.LoginValidate loginValidate)
        {
            SqlCommand command = Conexion.commandSP("SPLoginCliente");
            command.Parameters.AddWithValue("@_email", loginValidate.email);
            command.Parameters.AddWithValue("@_password", Funciones.EncriptarSHA512(loginValidate.password));
            command.Parameters.AddWithValue("@_token", Funciones.getTokenSession());

            return Conexion.execCommandSelect(command);

        }
    }
}