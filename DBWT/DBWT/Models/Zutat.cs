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
        public List<Zutat> GetZutaten()
        {
            List<Zutat> AlleZutaten = new List<Zutat>();
            string conString = ConfigurationManager.ConnectionStrings["dbConStr"].ConnectionString;
            MySqlConnection con = new MySqlConnection(conString);
            try
            {
                con.Open();
                MySqlCommand cmd;
                cmd = con.CreateCommand();
                cmd.CommandText = "SELECT id, name, glutenfree, bio, vegetarian, vegan FROM ingredients ORDER BY bio DESC,Name ASC;";
                MySqlDataReader r = cmd.ExecuteReader();
                while (r.Read()) //für jede id in der Tabelle incredients
                {
                    Zutat Z = new Zutat();
                    try
                    {
                        Z.ID = Convert.ToInt32(r["id"]);
                        Z.Name = r["name"].ToString();
                        //Z.Beschreibung = r["Beschreibung"].ToString(),
                        Z.Bio = Convert.ToBoolean(r["bio"]);
                        Z.Vegetarisch = Convert.ToBoolean(r["vegetarian"]);
                        Z.Vegan = Convert.ToBoolean(r["vegan"]);
                        Z.Glutenfrei = Convert.ToBoolean(r["glutenfree"]);
                    }
                    catch
                    {
                        Z.ID = 0;
                        Z.Name = "";
                        Z.Bio = false;
                        Z.Vegetarisch = false;
                        Z.Vegan = false;
                        Z.Glutenfrei = false;
                    }
                    AlleZutaten.Add(Z);
                }
                r.Close();
                con.Close();
            }
            catch
            {

            }
            return AlleZutaten;
        }
    }
}