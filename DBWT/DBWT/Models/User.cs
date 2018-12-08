using System.Configuration;
using System.Linq;
using System.Web;

namespace DBWT.Models
{
    public class User
    {
        public int ID { get; set; }
        public string Firstname { get; set; }
        public string Lastname { get; set; }
        public string Loginname { get; set; }
        public string Mail { get; set; }
        public string Salt { get; set; }
        public string Hash { get; set; }
        public string Reason { get; set; }
        public string Birthday { get; set; }
        public string Matric_no { get; set; }
        public string Course { get; set; }
        public string Building { get; set; }
        public string Office { get; set; }
        public string Telephone { get; set; }

        public User()
        {
            ID = 0;
            Firstname = "";
            Lastname = "";
            Loginname = "";
            Mail = "";
            Salt = "";
            Hash = "";
            Reason = "";
            Birthday = "";
            Matric_no = "";
            Course = "";
            Building = "";
            Office = "";
            Telephone = "";
        }
    }
}
