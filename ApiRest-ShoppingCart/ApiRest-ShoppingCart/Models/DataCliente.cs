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
        private static Entidades.Excepcion excepcion = new Entidades.Excepcion();

        public static DataTable registrarUsuario(Entidades.Cliente cliente)
        {
            try
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

                dt = Conexion.execCommandSelect(command);
            }catch(Exception ex)
            {
                excepcion.estado = false;
                excepcion.message = "Ha ocurrido un error";
                excepcion.errorMessage = ex.Message;
                dt = Funciones.retornarException(excepcion);
            }

            return dt;
        }

        public static DataTable loginCliente(Entidades.LoginValidate loginValidate)
        {

            try
            {
                SqlCommand command = Conexion.commandSP("SPLoginCliente");
                command.Parameters.AddWithValue("@_email", loginValidate.email);
                command.Parameters.AddWithValue("@_password", Funciones.EncriptarSHA512(loginValidate.password));
                command.Parameters.AddWithValue("@_token", Funciones.getTokenSession());
                dt = Conexion.execCommandSelect(command);
            }
            catch (Exception ex)
            {
                excepcion.estado = false;
                excepcion.message = "Ha ocurrido un error";
                excepcion.errorMessage = ex.Message;
                dt = Funciones.retornarException(excepcion);
            }
            return dt;
        }

        public static DataTable cambiarPassword(DTO.DTOChangePassword changePassword)
        {

            try
            {
                SqlCommand command = Conexion.commandSP("SPCambiarPassword");
                command.Parameters.AddWithValue("@_password", Funciones.EncriptarSHA512(changePassword.password));
                command.Parameters.AddWithValue("@_nuevaPassword", Funciones.EncriptarSHA512(changePassword.nuevaPassword));
                command.Parameters.AddWithValue("@_token", changePassword.token);
                command.Parameters.AddWithValue("@_idCliente", changePassword.idCliente);
                dt = Conexion.execCommandSelect(command);

            }
            catch (Exception ex)
            {
                excepcion.estado = false;
                excepcion.message = "Ha ocurrido un error";
                excepcion.errorMessage = ex.Message;
                dt = Funciones.retornarException(excepcion);
            }
            return dt;
        }
        
        public static DataTable guardarDatosEnvio(Entidades.DireccionEnvío direccionEnvio)
        {
            try
            {
                SqlCommand command = Conexion.commandSP("SPGuardarDatosEnvio");
                command.Parameters.AddWithValue("@_nombre", direccionEnvio.nombre);
                command.Parameters.AddWithValue("@_direccion", direccionEnvio.direccion);
                command.Parameters.AddWithValue("@_detalles", direccionEnvio.detalles);
                command.Parameters.AddWithValue("@_idMunicipio", direccionEnvio.idMunicipio);
                command.Parameters.AddWithValue("@_idCliente", direccionEnvio.idCliente);
                command.Parameters.AddWithValue("@_token", direccionEnvio.token);

                dt = Conexion.execCommandSelect(command);
                
            }
            catch (Exception ex)
            {
                excepcion.estado = false;
                excepcion.message = "Ha ocurrido un error";
                excepcion.errorMessage = ex.Message;
                dt = Funciones.retornarException(excepcion);
            }
            return dt;
        }
    }
}