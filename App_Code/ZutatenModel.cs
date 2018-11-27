using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class ZutatenModel
{
    public int ID { get; set; }
    public string Name { get; set; }
    //public string Beschreibung { get; set; }
    public bool Bio { get; set; }
    public bool Vegetarisch { get; set; }
    public bool Vegan { get; set; }
    public bool Glutenfrei { get; set; }
    public ZutatenModel()
    {
        ID = 0;
        Name = "";
        Bio = false;
        Vegetarisch = false;
        Vegan = false;
        Glutenfrei = false;
    }
}