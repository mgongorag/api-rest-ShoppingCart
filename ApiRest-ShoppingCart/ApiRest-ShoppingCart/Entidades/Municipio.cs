using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ApiRest_ShoppingCart.Entidades
{
    public class Municipio : Departamento
    {
        public int idMunicipio { get; set; }
        public string municipio { get; set; }
    }
}