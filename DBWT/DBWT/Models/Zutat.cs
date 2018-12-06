using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace DBWT.Models
{

    public class Zutat
    {
        public int ID { get; set; }
        public string Name { get; set; }
        //public string Beschreibung { get; set; }
        public bool Bio { get; set; }
        public bool Vegetarisch { get; set; }
        public bool Vegan { get; set; }
        public bool Glutenfrei { get; set; }

        public Zutat()
        {
            ID = 0;
            Name = "";
            Bio = false;
            Vegetarisch = false;
            Vegan = false;
            Glutenfrei = false;
        }
    }
}
