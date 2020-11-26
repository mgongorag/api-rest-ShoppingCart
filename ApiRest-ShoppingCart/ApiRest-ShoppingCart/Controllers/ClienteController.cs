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
    }
}
