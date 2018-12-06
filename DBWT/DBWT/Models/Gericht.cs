using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DBWT.Models
{
    using System.Configuration;
    using MySql.Data.MySqlClient;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Data.SqlClient;

    public class Gericht
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Beschreibung { get; set; }
        public int Stock { get; set; }
        public bool Verfuegbar { get; set; }
        public Object Bilddaten { get; set; }
        public string Bildtitel { get; set; }
        public List<Zutat> Zutatenliste { get; set; }
        public float Gastpreis { get; set; }
        public float Studentpreis { get; set; }
        public float Mitarbeiterpreis { get; set; }

        //========== Konstruktur ===============
        public Gericht()
        {
            ID = 0;
            Name = "";
            Beschreibung = "";
            Stock = 0;
            Verfuegbar = false;
            Bilddaten = null;
            Bildtitel = "";
            Zutatenliste = new List<Zutat>();
            Gastpreis = 0;
            Studentpreis = 0;
            Mitarbeiterpreis = 0;
        }
    } //End of Class "Produkt"
}
