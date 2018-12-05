using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace DBWT.Models
{
    public class Kategorie
    {
        public string Name { get; set; }
        public int ID { get; set; }
        public string UpperCategoryName { get; set; }
        public int UpperCategoryID { get; set; }
        public Kategorie()
        {
            Name = "";
            ID = 0;
            UpperCategoryName = "";
            UpperCategoryID = 0;
        }
        public List<Kategorie> GetKategorien()
        {
            List<Kategorie> AlleKategorien = new List<Kategorie>();
            string conString = ConfigurationManager.ConnectionStrings["dbConStr"].ConnectionString;
            MySqlConnection con = new MySqlConnection(conString);
            try
            {
                con.Open();
                MySqlCommand cmd;
                cmd = con.CreateCommand();
                cmd.CommandText = @"SELECT child, childID, parent, parentID FROM `Extended Category View`;";
                MySqlDataReader r = cmd.ExecuteReader();
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
                r.Close();
            }
            catch
            {
                
            }
            con.Close();
            return AlleKategorien;
        }
        public Kategorie GetKategorieByID(List<Kategorie> AlleKategorien, int id)
        {
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
        public List<string> GetUpperKategorien(List<Kategorie> AlleKategorien)
        {
            List<string> Überkategorien = new List<string>();
            foreach(var Kat in AlleKategorien)
            {
                if(Kat.UpperCategoryID == 0)
                {
                    Überkategorien.Add(Kat.Name);
                }
            }
            return Überkategorien;
        }
    }
}