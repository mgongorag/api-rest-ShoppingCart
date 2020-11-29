using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ApiRest_ShoppingCart.Entidades
{
    public class DireccionEnvío : Municipio
    {
        public int idDireccion { get; set; }
        public int idCliente { get; set; }
        public string nombre { get; set; }
        public string direccion { get; set; }
        public string detalles { get; set; }
        public string token { get; set; }
        
    }
}