using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;

namespace ApiRest_ShoppingCart.WsEmail
{
    public class WsEmail
    {
        public static SmtpClient server = new SmtpClient("ServerAdress");
        
        public static void correoRegistro(Entidades.Cliente cliente)
        {
            string html;
            server.Port = 587;
            server.EnableSsl = true;
            server.Host = "smtp.gmail.com";
            server.Credentials = new System.Net.NetworkCredential("arketsgt@gmail.com", "G0ngora007*");

            MailMessage mail = new MailMessage();
            mail.IsBodyHtml = true;
            mail.Priority = MailPriority.Normal;
            mail.From = new MailAddress("arketsgt@gmail.com");
            mail.Subject = "Bienvenido/a a Arket's";
            html = "<table align='center' margin='auto' style='margin: auto; margin-top:16px; border-collapse:collapse; ' border='0' cellspacing='0' cellpadding='0' width='480'>";
            html += "<tbody>";
            html += "<tr>";
            html += "<td  colspan='2' style='text-align:center;  background:#42433d'>";
            html += "<div style='padding: 10px; border-bottom:1px solid rgb(34, 67, 250); display: block; text-align:center'>";
            html += "<h1 style='color:#f2f2f2'>ARKET's</h1>";
            html += "</div>";
            html += "</td>" ;
            html += "</tr>";
            html += "<tr>";
            html += "<td colspan='2'>";
            html += "<div style='margin-bottom:24px'>";
            html += "<h2 style='font-size:25px; color:#333'>Bienvenido/a : " + cliente.nombre + " " + cliente.apellidos + "</h2>";
            html += "</div>";
            html += "</td>";
            html += "</tr>";
            html += "<tr>";
            html += "<td colspan='2' style='text-align:center; font-weight:bold'>";
            html += "<div style='margin-bottom:24px'>";
            html += "<span style='padding: 48px; font-size:18px; color:#333'>Arkets te da la <span class='il'>bienvenida</span>.</span>";
            html += "</div>";
            html += "</td>";
            html += "</tr>";
            html += "<tr>";
            html += "<td colspan='2'>";
            html += "<h2 style= 'color:#333'>Con tu cuenta puedes...</h2>";
            html += "<ul style='text-align:justify; margin: 36px; color:#333'>";
            html += "<li>";
            html += "Tener acceso fácil y rápido a tu historial de ordenes.";
            html += "</li>";
            html += "<li>";
            html += "Rastrear tu orden en tiempo real.";
            html += "</li>";
            html += "<li>";
            html += "Disfrutar de promociones exclusivas para usuarios registrados.";
            html += "</li>";
            html += "</ul>";
            html += "</td>";
            html += "</tr>";
            html += "</tbody>";
            html += "</table>";
            mail.Body = html;
            mail.To.Add(new MailAddress(cliente.email));
            server.Send(mail);
        }

    }
}