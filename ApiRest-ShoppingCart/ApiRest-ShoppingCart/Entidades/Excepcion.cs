using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ApiRest_ShoppingCart.Entidades
{
    public class Excepcion
    {
        public bool estado { get; set; }
        public string message { get; set; }
        public string errorMessage { get; set; }
    }
}