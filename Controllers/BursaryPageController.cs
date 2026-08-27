using Microsoft.AspNetCore.Mvc;

namespace BursaryFlow.Controllers
{
    [Route("Bursary")]
    public class BursaryPageController : Controller
    {
        [HttpGet("")]
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet("Details/{id:int}")]
        public IActionResult Details(int id)
        {
            ViewBag.BursaryID = id;
            return View();
        }
    }
}