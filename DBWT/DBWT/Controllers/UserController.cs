using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

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
            if (!String.IsNullOrEmpty(Session["user"] as String)){
                return RedirectToAction("Login");
            }
            return View();
        }
        public ActionResult Login()
        {
            bool LoginSuccess = false;
            bool AccessDenied = false;

            //Initial Session
            if (Session["user"] == null || Session["role"] == null)
            {
                Session["user"] = "";
                Session["role"] = "";
            }
            else
            {
                if (String.IsNullOrEmpty(Session["user"].ToString()))
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
                        
                        if(active == 0 && LoginSuccess)
                        {
                            Session["user"] = "";
                            Session["role"] = "";
                            AccessDenied = true;
                            LoginSuccess = false;
                        }
                    } //End of if(ParamsGiven)
                }
                else //If Session was already set
                {
                    LoginSuccess = true; //User was already signed in
                }
            } //End of Initial Session Else-Case
            ViewBag.LoginSuccess = LoginSuccess;
            ViewBag.AccessDenied = AccessDenied;
            return View();
        } //End of ActionResult Login
    } //End of Controller
} //End  of Namespace