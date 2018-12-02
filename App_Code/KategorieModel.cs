using System.Configuration;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class KategorieModel
{
    public int ID { get; set; }
    public string Parent { get; set; }
    public string Current { get; set; }
    public KategorieModel()
    {
        ID = 0;
        Parent = "";
        Current = "";
    }

    public KategorieModel GetCategorys(int id)
    {
        string conString = ConfigurationManager.ConnectionStrings["dbConStr"].ConnectionString;
        MySqlConnection con = new MySqlConnection(conString);
        var K = new KategorieModel { };
        try
        {
            con.Open();
            MySqlCommand cmd;
            cmd = con.CreateCommand();
            cmd.CommandText = @"
                            WITH RECURSIVE category AS (
                                SELECT
                                    c.upper_category_id,
                                    c.name AS child,
                                    p.name AS parent,
                                    p.id
                                FROM categorys AS c
                                LEFT JOIN categorys AS p ON c.upper_category_id = p.id
                            UNION
                                SELECT
                                    c.upper_category_id,
                                    c.name,
                                    p.name,
                                    p.id
                                FROM categorys AS c
                                LEFT JOIN categorys AS p ON c.upper_category_id = p.id
                                JOIN config AS j ON j.upper_category_id = c.id
                            )
                            SELECT
                                child,
                                parent
                            FROM category
                           ";
            //cmd.Parameters.Add(new SqlParameter("@id", id));
            cmd.Parameters.Add("@id", MySqlDbType.Int32);
            MySqlDataReader r = cmd.ExecuteReader();

            // Speichere Informationen zur Kategorie
            if (r.Read())
            {
                this.ID = Convert.ToInt32(r["id"]);
                this.Parent = r["parent"].ToString();
                this.Current = r["child"].ToString();
            }
            r.Close();
        }
        catch
        {

        }
        return K;
    }
}