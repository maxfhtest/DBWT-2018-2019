﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DBWT.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return RedirectToAction("Start");
        }

        public ActionResult Start()
        {
            return View();
        }
        public ActionResult Impressum()
        {
            return View();
        }
    }
}