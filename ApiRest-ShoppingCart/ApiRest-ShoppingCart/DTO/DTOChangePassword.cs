using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ApiRest_ShoppingCart.DTO
{
    public class DTOChangePassword
    {
        public int idCliente { get; set; }
        public string password { get; set; }
        public string nuevaPassword { get; set; }
        public string token { get; set; }
    }
}