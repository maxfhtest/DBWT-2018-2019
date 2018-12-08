using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MySql.Data.MySqlClient;
using System.Configuration;

namespace DBWT.Models
{
    public static class Service
    {
        private static readonly MySqlConnection Connection;

        static Service()
        {
            Connection = new MySqlConnection(ConfigurationManager.ConnectionStrings["dbConStr"].ConnectionString);
            Connection.Open();
        }

        public static void CreateStudent(User u)
        {
            
        }

        public static void CreateEmployee(User u)
        {
        }

        public static bool CreateGuest(User u)
        {
            var transaction = Service.Connection.BeginTransaction();
            try
            {
                var query = "INSERT INTO `meilenstein2`.`users` (`firstname`, `lastname`, `loginname`, `salt`, `hash`, `mail`) VALUES ('@firstname', '@lastname', '@username', '@salt', '@hash', '@mail')";
                var command = new MySqlCommand(query, Service.Connection);
                command.Transaction = transaction;
                command.Parameters.AddWithValue("username", u.Loginname);
                command.Parameters.AddWithValue("firstname", u.Firstname);
                command.Parameters.AddWithValue("lastname", u.Lastname);
                command.Parameters.AddWithValue("@mail", u.Mail);
                command.Parameters.AddWithValue("hash", u.Hash);
                command.Parameters.AddWithValue("salt", u.Salt);
  
                //  command.Parameters.AddWithValue("birthday", u.Birthday.ToString("yyyy-MM-dd"));
                command.ExecuteNonQuery();

                command.CommandText = "SELECT LAST_INSERT_ID() AS id";
                using (var r = command.ExecuteReader())
                {
                    if (r.Read())
                    {
                        u.ID = Convert.ToInt32(r["id"]);
                    }
                }

                // command.CommandText = "INSERT INTO `meilenstein2`.`guests` (`id`, `reason`) VALUES (SELECT LAST_INSERT_ID(), @reason)";
                command.CommandText = "INSERT INTO `meilenstein2`.`guests` (`id`, `reason`) VALUES (@id, @reason)";
                command.Parameters.AddWithValue("id", u.ID);
                command.Parameters.AddWithValue("reason", u.Reason);
                command.ExecuteNonQuery();
                transaction.Commit();
            }
            catch
            {
                transaction.Rollback();
                return false;
            }
            return true;
        }

        public static List<Gericht> GetGerichte()
        {
            List<Gericht> AlleGerichte = new List<Gericht>();
            MySqlCommand cmd;

            try
            {
                cmd = Connection.CreateCommand();
                cmd.CommandText = @"SELECT *  FROM `Extended Product View`;";
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        var G = new Gericht();
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
                        AlleGerichte.Add(G);
                    }
                }  // end using

                using (var r = cmd.ExecuteReader())
                {
                    cmd = Connection.CreateCommand();
                    cmd.CommandText = "Select ingredients.id, ingredients.name, ingredients.bio, ingredients.vegetarian, ingredients.vegan, ingredients.glutenfree, `products_ingredients`.`product_id` FROM ingredients, `products_ingredients` WHERE ingredients.id = `products_ingredients`.`ingredient_id`";
                    while (r.Read())
                    {
                        Zutat Z = new Zutat();
                        Z.ID = Convert.ToInt32(r["id"]);
                        Z.Name = r["name"].ToString();
                        Z.Bio = Convert.ToBoolean(r["bio"]);
                        Z.Vegetarisch = Convert.ToBoolean(r["vegetarian"]);
                        Z.Vegan = Convert.ToBoolean(r["vegan"]);
                        Z.Glutenfrei = Convert.ToBoolean(r["glutenfree"]);
                        foreach (var G in AlleGerichte)
                        {
                            if (G.ID == Convert.ToInt32(r["product_id"]))
                            {
                                G.Zutatenliste.Add(Z);
                                break;
                            }
                        }
                    }
                }

            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            return AlleGerichte;
        }

        public static Gericht SelectGerichtByID(int id)
        {
            Gericht G = new Gericht();
            MySqlCommand cmd;

            try
            {
                cmd = Connection.CreateCommand();
                cmd.CommandText = @"SELECT *  FROM `Extended Product View` WHERE id = " + id + ";";
                using (var r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
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
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            try
            {
                cmd = Connection.CreateCommand();
                cmd.CommandText = "Select ingredients.id, ingredients.name, ingredients.bio, ingredients.vegetarian, ingredients.vegan, ingredients.glutenfree, `products_ingredients`.`product_id` FROM ingredients, `products_ingredients` WHERE ingredients.id = `products_ingredients`.`ingredient_id` and `products_ingredients`.`product_id` = " + G.ID + " ORDER BY bio DESC, name, vegetarian, vegan;";
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        Zutat z = new Zutat();
                        z.ID = Convert.ToInt32(r["id"]);
                        z.Name = r["name"].ToString();
                        z.Bio = Convert.ToBoolean(r["bio"]);
                        z.Vegetarisch = Convert.ToBoolean(r["vegetarian"]);
                        z.Vegan = Convert.ToBoolean(r["vegan"]);
                        z.Glutenfrei = Convert.ToBoolean(r["glutenfree"]);
                        G.Zutatenliste.Add(z);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            return G;
        }

        public static List<Gericht> GetProdukteWithFilter(int categoryid, bool available, bool vegetarian, bool vegan)
        {
            List<Gericht> GerichtListe = new List<Gericht>();
            MySqlCommand cmd;
            try
            {
                cmd = Connection.CreateCommand();
                cmd.CommandText = @"SELECT * FROM `extended product view`";

                if (available || vegan || vegetarian || categoryid > 0)
                {
                    cmd.CommandText += " WHERE";
                }
                if (available)
                {
                    cmd.CommandText += " available = 1";
                }
                if (vegetarian)
                {
                    if (available) { cmd.CommandText += " AND"; }
                    cmd.CommandText += " VGT = 1";
                }
                if (vegan)
                {
                    if (available || vegetarian) { cmd.CommandText += " AND"; }
                    cmd.CommandText += " VGN = 1";
                }
                if (categoryid > 0)
                {
                    if (available || vegetarian || vegan) { cmd.CommandText += " AND"; }
                    cmd.CommandText += " category_id = " + categoryid;
                }
                cmd.CommandText += ";";
                using (var r = cmd.ExecuteReader())
                {
                    int count = 0;
                    while (r.Read() || (r.Read() && count < 8)) //für jede id in der Tabelle Products (jedoch max. 8) :
                    {
                        Gericht G = new Gericht();
                        try
                        {
                            G.ID = Convert.ToInt32(r["id"]);
                            G.Name = r["name"].ToString();
                            G.Beschreibung = r["description"].ToString();
                            G.Stock = Convert.ToInt32(r["stock"]);
                            G.Verfuegbar = Convert.ToBoolean(r["available"]);
                            G.Bilddaten = r["blob_data"];
                            G.Bildtitel = r["alttext"].ToString();
                        }
                        catch
                        {
                            G.ID = 0;
                            G.Name = "";
                            G.Beschreibung = "";
                            G.Stock = 0;
                            G.Verfuegbar = false;
                            G.Bilddaten = null;
                            G.Bildtitel = "";
                        }
                        count++;
                        GerichtListe.Add(G);
                    }
                }

            }
            catch
            {
            }
            return GerichtListe;
        }

        public static List<Kategorie> GetKategorien()
        {
            List<Kategorie> AlleKategorien = new List<Kategorie>();
            MySqlCommand cmd = Connection.CreateCommand();
            try
            {
                cmd.CommandText = @"SELECT child, childID, parent, parentID FROM `Extended Category View`;";

                using (var r = cmd.ExecuteReader())
                {
                    // Speichere Informationen zur Kategorie
                    while (r.Read())
                    {
                        Kategorie currK = new Kategorie();
                        currK.Name = r["child"].ToString();
                        currK.ID = Convert.ToInt32(r["childID"]);
                        if (r["parent"] != DBNull.Value)
                        {
                            currK.UpperCategoryName = r["parent"].ToString();
                        }
                        if (r["parentID"] != DBNull.Value)
                        {
                            currK.UpperCategoryID = Convert.ToInt32(r["parentID"]);
                        }
                        AlleKategorien.Add(currK);
                    }
                }
            }
            catch
            {

            }
            return AlleKategorien;
        }

        public static Kategorie GetKategorieByID(int id)
        {
            // build custom query
            var AlleKategorien = Service.GetKategorien();
            Kategorie myCategory = new Kategorie();
            if (id == 0)
            {
                myCategory.Name = "Alles";
            }
            else
            {
                foreach (var item in AlleKategorien)
                {
                    if (item.ID == id)
                    {
                        myCategory = item;
                    }
                }
            }
            return myCategory;
        }

        public static List<string> GetUpperKategorien(List<Kategorie> AlleKategorien)
        {
            List<string> Überkategorien = new List<string>();
            foreach (var Kat in AlleKategorien)
            {
                if (Kat.UpperCategoryID == 0)
                {
                    Überkategorien.Add(Kat.Name);
                }
            }
            return Überkategorien;
        }

        public static List<Zutat> GetZutaten()
        {
            List<Zutat> AlleZutaten = new List<Zutat>();
            MySqlCommand cmd = Connection.CreateCommand();

            try
            {
                cmd.CommandText = "SELECT id, name, glutenfree, bio, vegetarian, vegan FROM ingredients ORDER BY bio DESC,Name ASC";
                using (var r = cmd.ExecuteReader())
                {
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
                }
            }
            catch
            {

            }
            return AlleZutaten;
        }
    }
}
