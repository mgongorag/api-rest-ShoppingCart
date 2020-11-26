using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ApiRest_ShoppingCart.Entidades
{
    public class TokenSecurity
    {
        public  int idToken { get; set; }
        public  string token { get; set; }
        public  int expiration { get; set; }
        public  int idUsuario { get; set; }
        public string fechaIngreso { get; set; }
        public int estadoToken { get; set; }
        
    }
}