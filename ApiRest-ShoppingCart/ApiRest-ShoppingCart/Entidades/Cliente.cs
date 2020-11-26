using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ApiRest_ShoppingCart.Entidades
{
    public class Cliente : TokenSecurity
    {
        public int idCliente { get; set; }
        public string nombre { get; set; }
        public string apellidos { get; set; }
        public string fechaNacimiento { get; set; }
        public string fechaRegistro { get; set; }
        public string email { get; set; }
        public string password { get; set; }
        public string ultimaSession { get; set; }
        public string telefono { get; set; }
        public string telefono2 { get; set; }
        public int  estado { get; set; }

    }
}