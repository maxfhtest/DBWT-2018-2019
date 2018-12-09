using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DBWT.Models;
using System.Security.Cryptography;

namespace DBWT.Controllers
{
    public class UserController : Controller
    {
        public ActionResult Index()
        {
            return RedirectToAction("Login");
        }
        public ActionResult Logout()
        {
            Session["user"] = "";
            Session["role"] = "";
            return View();
        }
        public ActionResult Register()
        {
            if (!String.IsNullOrEmpty(Session["user"] as String))
            {
                return RedirectToAction("Login");
            }

            if (Request.HttpMethod == "GET")
            {
                return View();
            }

            User u = new User();
            u.Firstname = Request.Params.Get("first_name");
            u.Lastname = Request.Params.Get("last_name");
            u.Loginname = Request.Params.Get("display_name");
            u.Mail = Request.Params.Get("email");
            u.Reason = Request.Params.Get("reason");
            u.Birthday = Request.Params.Get("birthday");
            u.Matric_no = Request.Params.Get("matric_no");
            u.Course = Request.Params.Get("course");
            u.Building = Request.Params.Get("building");
            u.Office = Request.Params.Get("office");
            u.Telephone = Request.Params.Get("phone_number");

            string pwd = Request.Params.Get("password");
            byte[] saltBytes = new byte[24];
            var key = PasswordSecurity.PasswordStorage.CreateHash(pwd).Split(':');

            u.Hash = key[key.Length - 1];
            u.Salt = key[key.Length - 2];

            String role = Request["role"];
            if (role == "guest")
            {
                Service.CreateGuest(u);
            }

            if (role == "student")
            {
                Service.CreateStudent(u);
            }

            if (role == "employee")
            {
                Service.CreateEmployee(u);
            }

            return View();
        }
        public ActionResult Login()
        {
            bool LoginSuccess = false;
            bool AccessDenied = false;

            if (String.IsNullOrEmpty(Session["user"] as String))
            {
                Boolean ParamsGiven = false;
                if (Request["pass"] != "" && Request["pass"] != null || Request["user"] != "" && Request["user"] != null)
                {
                    ParamsGiven = true;
                }

                //Avoid Logging Out if Visiting this View again
                if (ParamsGiven)
                {
                    String PW = "";
                    String User = "";

                    PW = Request["pass"];
                    User = Request["user"];

                    string conString = ConfigurationManager.ConnectionStrings["dbConStr"].ConnectionString;
                    MySqlConnection con = new MySqlConnection(conString);
                    string GoodHash = "";
                    String Role = "";
                    int active = 0;
                    try
                    {
                        //HASH_ALGORITHM_INDEX      = 0 = "sha1"
                        //ITERATION_INDEX           = 1 = 64000 (laut Folien)
                        //HASH_SIZE_INDEX           = 2 = 18 (laut Folien)
                        //SALT_INDEX                = 3 =
                        //PBKDF2_INDEX              = 4 = SALT
                        //HASH_SECTIONS             = 5 = HASH
                        con.Open();
                        MySqlCommand cmd;
                        cmd = con.CreateCommand();
                        cmd.CommandText = "SELECT * FROM `extended user view` where loginname = '" + User + "'";

                        MySqlDataReader r = cmd.ExecuteReader();
                        if (r.Read()) //für jede id in der Tabelle incredients
                        {
                            Role = r["Rolle"].ToString();
                            GoodHash = "sha1:64000:18:" + r["salt"].ToString() + ":" + r["hash"].ToString();
                            active = Convert.ToInt32(r["active"]);
                        }
                        r.Close();
                        con.Close();
                    }
                    catch
                    {
                        con.Close();
                    }

                    if (GoodHash != "")
                    {
                        LoginSuccess = PasswordSecurity.PasswordStorage.VerifyPassword(PW, GoodHash);
                    }

                    if (LoginSuccess)
                    {
                        Session["user"] = User;
                        Session["role"] = Role;
                    }
                    else
                    {
                        Session["user"] = "";
                        Session["role"] = "";
                        AccessDenied = true;
                    }

                    //Only Allow Active Users to Log In
                    if (active == 0 && LoginSuccess)
                    {
                        Session["user"] = "";
                        Session["role"] = "";
                        AccessDenied = true;
                        LoginSuccess = false;
                    }
                } //End of if(ParamsGiven)
            } //End of Initial Session Else-Case
            ViewBag.LoginSuccess = LoginSuccess;
            ViewBag.AccessDenied = AccessDenied;
            return View();
        } //End of ActionResult Login
    } //End of Controller
} //End  of Namespace