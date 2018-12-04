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

    public class Produkt
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
        public Produkt()
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
        public List<Produkt> GetProdukte()
        {
            string conString = ConfigurationManager.ConnectionStrings["dbConStr"].ConnectionString;
            MySqlConnection con = new MySqlConnection(conString);
            List<Produkt> AlleProdukte = new List<Produkt>();
            try
            {
                con.Open();
                MySqlCommand cmd;
                cmd = con.CreateCommand();
                cmd.CommandText = @"SELECT *  FROM `Extended Product View`;";
                MySqlDataReader r = cmd.ExecuteReader();

                //Speichere Informationen zum Gericht
                while (r.Read())
                {
                    var G = new Produkt { };
                    G.ID = Convert.ToInt32(r["id"]);
                    G.Name = r["name"].ToString();
                    G.Beschreibung = r["description"].ToString();
                    G.Stock = Convert.ToInt32(r["stock"]);
                    G.Verfuegbar = Convert.ToBoolean(r["available"]);
                    G.Bilddaten = r["blob_data"];
                    G.Bildtitel = r["alttext"].ToString();
                    if (r["guest"] != DBNull.Value)
                    {
                        G.Gastpreis = (float)Convert.ToDouble(r["guest"]);
                    }
                    if (r["student"] != DBNull.Value)
                    {
                        G.Studentpreis = (float)Convert.ToDouble(r["student"]);
                    }
                    if (r["employee"] != DBNull.Value)
                    {
                        G.Mitarbeiterpreis = (float)Convert.ToDouble(r["employee"]);
                    }

                    AlleProdukte.Add(G);
                }
                r.Close();
                //Speichere Zutatenliste zum Gericht
                cmd.CommandText = "Select ingredients.id, ingredients.name, ingredients.bio, ingredients.vegetarian, ingredients.vegan, ingredients.glutenfree, `products_ingredients`.`product_id` FROM ingredients, `products_ingredients` WHERE ingredients.id = `products_ingredients`.`ingredient_id`;";
                MySqlDataReader r2 = cmd.ExecuteReader();
                while (r2.Read())
                {
                    Zutat Z = new Zutat();
                    Z.ID = Convert.ToInt32(r2["id"]);
                    Z.Name = r2["name"].ToString();
                    Z.Bio = Convert.ToBoolean(r2["bio"]);
                    Z.Vegetarisch = Convert.ToBoolean(r2["vegetarian"]);
                    Z.Vegan = Convert.ToBoolean(r2["vegan"]);
                    Z.Glutenfrei = Convert.ToBoolean(r2["glutenfree"]);
                    foreach (var G in AlleProdukte)
                    {
                        if (G.ID == Convert.ToInt32(r2["product_id"]))
                        {
                            G.Zutatenliste.Add(Z);
                            break;
                        }
                    }
                }
                r2.Close();

                con.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            return AlleProdukte;
        }
        public bool SelectGerichtByID(int id)
        {
            string conString = ConfigurationManager.ConnectionStrings["dbConStr"].ConnectionString;
            MySqlConnection con = new MySqlConnection(conString);
            var G = new Produkt { };
            bool OK = false;
            try
            {
                con.Open();
                MySqlCommand cmd;
                cmd = con.CreateCommand();
                cmd.CommandText = @"SELECT *  FROM `Extended Product View` WHERE id = " + id + ";";
                MySqlDataReader r = cmd.ExecuteReader();

                //Speichere Informationen zum Gericht
                if (r.Read())
                {
                    this.ID = Convert.ToInt32(r["id"]);
                    this.Name = r["name"].ToString();
                    this.Beschreibung = r["description"].ToString();
                    this.Stock = Convert.ToInt32(r["stock"]);
                    this.Verfuegbar = Convert.ToBoolean(r["available"]);
                    this.Bilddaten = r["blob_data"];
                    this.Bildtitel = r["alttext"].ToString();
                    if (r["guest"] != DBNull.Value)
                    {
                        this.Gastpreis = (float)Convert.ToDouble(r["guest"]);
                    }
                    if (r["student"] != DBNull.Value)
                    {
                        this.Studentpreis = (float)Convert.ToDouble(r["student"]);
                    }
                    if (r["employee"] != DBNull.Value)
                    {
                        this.Mitarbeiterpreis = (float)Convert.ToDouble(r["employee"]);
                    }
                    OK = true;
                }
                else
                {
                    OK = false;
                }
                r.Close();

                //Speichere Zutatenliste zum Gericht
                cmd.CommandText = "Select ingredients.id, ingredients.name, ingredients.bio, ingredients.vegetarian, ingredients.vegan, ingredients.glutenfree, `products_ingredients`.`product_id` FROM ingredients, `products_ingredients` WHERE ingredients.id = `products_ingredients`.`ingredient_id` and `products_ingredients`.`product_id` = " + this.ID + ";";
                MySqlDataReader r2 = cmd.ExecuteReader();
                while (r2.Read())
                {
                    Zutat z = new Zutat();
                    z.ID = Convert.ToInt32(r2["id"]);
                    z.Name = r2["name"].ToString();
                    z.Bio = Convert.ToBoolean(r2["bio"]);
                    z.Vegetarisch = Convert.ToBoolean(r2["vegetarian"]);
                    z.Vegan = Convert.ToBoolean(r2["vegan"]);
                    z.Glutenfrei = Convert.ToBoolean(r2["glutenfree"]);
                    this.Zutatenliste.Add(z);
                }
                r2.Close();

                con.Close();
            }
            catch (Exception e)
            {
                this.Beschreibung = e.Message;
                this.ID = 0;
                this.Stock = 0;
                this.Verfuegbar = false;
                OK = false;
            }
            return OK;
        }
    }
}