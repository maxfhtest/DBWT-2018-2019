using System.Configuration;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
public class KategorieModel
{
    public string Name { get; set; }
    public int ID { get; set; }
    public string UpperCategoryName { get; set; }
    public int UpperCategoryID { get; set; }
    public KategorieModel()
    {
        Name = "";
        ID = 0;
        UpperCategoryName = "";
        UpperCategoryID = 0;
    }
    public KategorieModel(string N, int I, string UN, int UI)
    {
        this.Name = N;
        this.ID = I;
        this.UpperCategoryName = UN;
        this.UpperCategoryID = UI;
    }
}