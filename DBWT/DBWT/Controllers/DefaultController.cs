using DBWT.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DBWT.Controllers
{
    public class DefaultController : Controller
    {
       public ActionResult Index() { return View(); }

        public ActionResult Start() { return View(); }

        public ActionResult Zutaten()
        {
            List<Zutat> Zutatenliste = new Zutat().GetZutaten();
            return View(Zutatenliste);
        }

        public ActionResult Produkte()
        {
            List<Produkt> ProduktListe = new Produkt().GetProdukte();
            return View(ProduktListe);
        }
    }
}
