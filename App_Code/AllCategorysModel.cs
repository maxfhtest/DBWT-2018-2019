using System.Configuration;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class AllCategorysModel
{
    public List<KategorieModel> ListOfCategorys { get; set; }
    public List<String> ListOfUpperCategorys { get; set; }
    public AllCategorysModel()
    {
        ListOfCategorys = new List<KategorieModel>();
        ListOfUpperCategorys = new List<string>();
    }
    public void SetAllCategorys()
    {
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
                KategorieModel currK = new KategorieModel();
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
                this.ListOfCategorys.Add(currK);
            }
            r.Close();
            cmd.CommandText = @"SELECT parent FROM `Extended Category View` WHERE parentID is not NUll GROUP BY parent ORDER BY parentID;";
            r = cmd.ExecuteReader();
            while (r.Read())
            {
                this.ListOfUpperCategorys.Add(r["parent"].ToString());
            }
            r.Close();
        }
        catch
        {
            this.ListOfCategorys = new List<KategorieModel>();
            this.ListOfUpperCategorys = new List<string>();
        }
        con.Close();
    }
    public KategorieModel GetCurrentCategory(int id)
    {
        KategorieModel myCategory = new KategorieModel();
        foreach (var item in ListOfCategorys)
        {
            if (item.ID == id)
            {
                myCategory = item;
            }
        }
        return myCategory;
    }
}