using System.Configuration;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

public class GerichtModel
{
    public int ID { get; set; }
    public string Name { get; set; }
    public string Beschreibung { get; set; }
    public int Stock { get; set; }
    public bool Verfuegbar { get; set; }
    public Object Bilddaten { get; set; }
    public string Bildtitel { get; set; }
    public List<string> Zutatenliste { get; set; }
    public float Gastpreis { get; set; }
    public float Studentpreis { get; set; }
    public float Mitarbeiterpreis { get; set; }
    public GerichtModel()
    {
        ID = 0;
        Name = "";
        Beschreibung = "";
        Stock = 0;
        Verfuegbar = false;
        Bilddaten = null;
        Bildtitel = "";
        Zutatenliste = new List<string>();
        Gastpreis = 0;
        Studentpreis = 0;
        Mitarbeiterpreis = 0;
    }

    // TODO: Set doesnt make any sense. Whe should call it getGerichtByID
    // because we fetch our information from the connected DB and map them
    // to our model.
    public bool SetGerichtByID(int id)
    {
        string conString = ConfigurationManager.ConnectionStrings["dbConStr"].ConnectionString;
        MySqlConnection con = new MySqlConnection(conString);
        var G = new GerichtModel { };
        bool OK = false;
        try
        {
            con.Open();
            MySqlCommand cmd;
            cmd = con.CreateCommand();
            cmd.CommandText = @"
                           SELECT
                               p.id, p.description, p.name, p.stock, p.available,
                               i.`blob_data`, i.title,
                               v.guest, v.student, v.employee
                           FROM products p
                           JOIN products_images pi ON (p.image_id = pi.image_id)
                           JOIN images i ON (i.id = pi.image_id)
                           JOIN prices v ON (v.id = p.id)
                           WHERE p.id = @id
                           ";
            cmd.Parameters.Add(new SqlParameter("@id", id));
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
                this.Gastpreis = (float)Convert.ToDouble(r["guest"]);
                this.Studentpreis = (float)Convert.ToDouble(r["student"]);
                this.Mitarbeiterpreis = (float)Convert.ToDouble(r["employee"]);
                OK = true;
            }
            else
            {
                OK = false;
            }
            r.Close();

            //Speichere Zutatenliste zum Gericht
            cmd.CommandText = "Select ingredients.id, ingredients.name, `products_ingredients`.`product_id` FROM ingredients, `products_ingredients` WHERE ingredients.id = `products_ingredients`.`ingredient_id` and `products_ingredients`.`product_id` = " + this.ID + ";";
            MySqlDataReader r2 = cmd.ExecuteReader();
            while (r2.Read())
            {
                this.Zutatenliste.Add(r2["name"].ToString() + " ".ToString());
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
