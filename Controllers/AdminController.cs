using Microsoft.AspNetCore.Mvc;
using BursaryFlow.Models;

namespace BursaryFlow.Controllers
{
    public class AdminController : Controller
    {
        // =====================================================
        // ADMIN DASHBOARD
        // =====================================================

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }


        // =====================================================
        // BURSARY MANAGEMENT
        // =====================================================

        [HttpGet]
        public IActionResult Bursaries()
        {
            return View();
        }


        // =====================================================
        // ADD BURSARY
        // =====================================================

        [HttpGet]
        public IActionResult AddBursary()
        {
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult AddBursary(string name, string provider)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                ViewBag.Error = "Please enter the bursary name.";
                return View();
            }

            // -------------------------------------------------
            // DATABASE LOGIC WILL GO HERE
            // -------------------------------------------------
            //
            // For now we are only preparing the controller.
            //
            // Later:
            // 1. Create bursary
            // 2. Save bursary information
            // 3. Attach required documents
            // 4. Attach application questions
            // 5. Attach eligibility requirements
            //

            TempData["Success"] = "Bursary created successfully.";

            return RedirectToAction(nameof(Bursaries));
        }


        // =====================================================
        // REQUIRED DOCUMENTS
        // =====================================================

        [HttpGet]
        public IActionResult Documents(int? bursaryId)
        {
            ViewBag.BursaryId = bursaryId;

            return View();
        }


        // =====================================================
        // ADD REQUIRED DOCUMENT
        // =====================================================

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult AddDocument(
            int bursaryId,
            string documentName,
            bool mandatory = true)
        {
            if (string.IsNullOrWhiteSpace(documentName))
            {
                TempData["Error"] = "Please enter a document name.";

                return RedirectToAction(
                    nameof(Documents),
                    new { bursaryId }
                );
            }

            // -------------------------------------------------
            // DATABASE LOGIC WILL GO HERE
            // -------------------------------------------------
            //
            // Example:
            //
            // new RequiredDocument
            // {
            //     BursaryId = bursaryId,
            //     Name = documentName,
            //     IsMandatory = mandatory
            // };
            //
            // db.RequiredDocuments.Add(document);
            // db.SaveChanges();
            //

            TempData["Success"] = "Required document added.";

            return RedirectToAction(
                nameof(Documents),
                new { bursaryId }
            );
        }


        // =====================================================
        // APPLICATION QUESTIONS
        // =====================================================

        [HttpGet]
        public IActionResult Questions(int? bursaryId)
        {
            ViewBag.BursaryId = bursaryId;

            return View();
        }


        // =====================================================
        // ADD APPLICATION QUESTION
        // =====================================================

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult AddQuestion(
            int bursaryId,
            string question,
            bool required = true)
        {
            if (string.IsNullOrWhiteSpace(question))
            {
                TempData["Error"] = "Please enter a question.";

                return RedirectToAction(
                    nameof(Questions),
                    new { bursaryId }
                );
            }

            // -------------------------------------------------
            // DATABASE LOGIC WILL GO HERE
            // -------------------------------------------------
            //
            // Later this will save questions such as:
            //
            // "What is your household income?"
            // "Are you a South African citizen?"
            // "Why should you receive this bursary?"
            //
            // Delton will use these questions during
            // application preparation.
            //

            TempData["Success"] = "Application question added.";

            return RedirectToAction(
                nameof(Questions),
                new { bursaryId }
            );
        }


        // =====================================================
        // APPLICATION FORMS
        // =====================================================

        [HttpGet]
        public IActionResult ApplicationForms()
        {
            return View();
        }


        // =====================================================
        // ANNOUNCEMENTS
        // =====================================================

        [HttpGet]
        public IActionResult Announcements()
        {
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult CreateAnnouncement(
            string title,
            string message)
        {
            if (string.IsNullOrWhiteSpace(title) ||
                string.IsNullOrWhiteSpace(message))
            {
                TempData["Error"] =
                    "Please complete the announcement.";

                return RedirectToAction(nameof(Announcements));
            }

            // -------------------------------------------------
            // DATABASE LOGIC WILL GO HERE
            // -------------------------------------------------
            //
            // Later this will create notifications such as:
            //
            // "New bursary application available"
            //
            // "Delton needs your answer"
            //
            // "Application ready for review"
            //

            TempData["Success"] =
                "Announcement created successfully.";

            return RedirectToAction(nameof(Announcements));
        }
    }
}