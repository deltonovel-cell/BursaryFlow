using Microsoft.AspNetCore.Mvc;

namespace HouseServices.Controllers
{
    public class DashboardController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}