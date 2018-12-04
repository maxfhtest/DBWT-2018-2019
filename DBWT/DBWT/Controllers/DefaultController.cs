using DBWT.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using MySql.Data.MySqlClient;

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
            Boolean available = false; 
            Boolean vegetarian = false;
            Boolean vegan = false;
            int categoryid;
            if (Request["available"] != null)
            {
                available = (Request["available"].ToString() == "true");
            }
            if (Request["vegetarian"] != null)
            {
                vegetarian = (Request["vegetarian"].ToString() == "true");
            }
            if (Request["vegan"] != null)
            {
                 vegan = (Request["vegan"].ToString() == "true");
            }
            ViewBag.available = available;
            ViewBag.vegetarian = vegetarian;
            ViewBag.vegan = vegan;

            try
            {
                categoryid = Convert.ToInt32(Request["kat"].ToString());
            }
            catch
            {
                categoryid = 0;
            }
            List<Gericht> ProduktListe;
            if (categoryid == 0 && !available && !vegetarian && !vegan)
            {
                //Hole alle Produkte (Schnellere SQL Abfrage)
                ProduktListe = new Gericht().GetProdukte();
            }
            else
            {
                //Hole die gefilterten Gerichte
                ProduktListe = new Gericht().GetProdukteWithFilter(categoryid, available, vegetarian, vegan);
            }

            return View(ProduktListe);
        } //End of ActionResult Produkte
    }//End of Controller
}//End of Namespace
