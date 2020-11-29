using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ApiRest_ShoppingCart.Controllers
{
    public class ClienteController : ApiController
    {
        [HttpPost]
        [Route("api/RegistroCliente")]
        public DataTable registrarCliente(Entidades.Cliente cliente)
        {
            return Models.DataCliente.registrarUsuario(cliente);
        }

        [HttpPost]
        [Route("api/LoginCliente")]
        public DataTable login(Entidades.LoginValidate loginValidate)
        {
            return Models.DataCliente.loginCliente(loginValidate);
        }
        [HttpPost]
        [Route("api/cambiarPassword")]
        public DataTable cambiarPassword(DTO.DTOChangePassword changePassword)
        {
            return Models.DataCliente.cambiarPassword(changePassword);
        }

        [HttpPost]
        [Route("api/guardarDatosEnvio")]
        public DataTable guardarDatosEnvio(Entidades.DireccionEnvío direccionEnvio)
        {
            return Models.DataCliente.guardarDatosEnvio(direccionEnvio);
        } 
        
        [HttpPost]
        [Route("api/modificarDatosEnvio")]
        public DataTable modificarDatosEnvio(Entidades.DireccionEnvío direccionEnvio)
        {
            return Models.DataCliente.modificarDatosEnvio(direccionEnvio);
        }

        [HttpPost]
        [Route("api/obtenerDireccionesEnvio")]
        public DataTable obtenerDireccionesEnvio(Entidades.DireccionEnvío direccionEnvio)
        {
            return Models.DataCliente.obtenerDireccionesEnvio(direccionEnvio);
        }

        [HttpPost]
        [Route("api/obtenerDireccionEnvio")]
        public DataTable obtenerDireccionEnvio(Entidades.DireccionEnvío direccionEnvio)
        {
            return Models.DataCliente.obtenerDireccionEnvio(direccionEnvio);
        }

    }
}
