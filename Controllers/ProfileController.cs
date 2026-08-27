using Microsoft.AspNetCore.Mvc;

namespace HouseServices.Controllers
{
    [Route("Profile")]
    public class ProfileController : Controller
    {
        [HttpGet("")]
        public IActionResult Index()
        {
            return View();
        }
    }
}