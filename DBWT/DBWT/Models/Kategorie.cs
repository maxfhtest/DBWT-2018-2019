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
    }
}
