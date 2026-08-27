using Microsoft.AspNetCore.Mvc;

namespace BursaryFlow.Controllers
{
    public class ApplicationsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}