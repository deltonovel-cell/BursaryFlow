using Microsoft.AspNetCore.Mvc;

namespace BursaryFlow.Controllers
{
    public class SettingsController : Controller
    {
        // GET: /Settings
        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        // POST: /Settings/Save
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Save(
            string fullName,
            string email,
            string studyLevel,
            string institution,
            string fieldOfStudy,
            bool bursaryAlerts,
            bool applicationUpdates,
            bool documentReminders,
            bool aiRecommendations,
            bool profileVisibility,
            bool documentPrivacy,
            bool personalisedMatching,
            bool aiDocumentAssistance)
        {
            // -------------------------------------------------
            // TEMPORARY SETTINGS HANDLING
            // -------------------------------------------------
            //
            // For now, we simply confirm that the settings
            // were submitted successfully.
            //
            // Later we will connect this to the database and
            // save the user's actual preferences.
            // -------------------------------------------------

            TempData["SettingsSuccess"] =
                "Your settings have been saved successfully.";

            return RedirectToAction(nameof(Index));
        }

        // POST: /Settings/ChangePassword
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ChangePassword(
            string currentPassword,
            string newPassword,
            string confirmPassword)
        {
            if (string.IsNullOrWhiteSpace(currentPassword) ||
                string.IsNullOrWhiteSpace(newPassword) ||
                string.IsNullOrWhiteSpace(confirmPassword))
            {
                TempData["PasswordError"] =
                    "Please complete all password fields.";

                return RedirectToAction(nameof(Index));
            }

            if (newPassword != confirmPassword)
            {
                TempData["PasswordError"] =
                    "The new passwords do not match.";

                return RedirectToAction(nameof(Index));
            }

            if (newPassword.Length < 8)
            {
                TempData["PasswordError"] =
                    "Your new password must contain at least 8 characters.";

                return RedirectToAction(nameof(Index));
            }

            // -------------------------------------------------
            // PASSWORD UPDATE
            // -------------------------------------------------
            //
            // We will connect this to your AppUser database
            // and BCrypt password hashing later.
            // -------------------------------------------------

            TempData["PasswordSuccess"] =
                "Your password has been updated successfully.";

            return RedirectToAction(nameof(Index));
        }

        // POST: /Settings/ResetPreferences
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ResetPreferences()
        {
            TempData["SettingsSuccess"] =
                "Your preferences have been reset.";

            return RedirectToAction(nameof(Index));
        }

        // POST: /Settings/DeleteAccount
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteAccount(
            string confirmation)
        {
            if (confirmation != "DELETE")
            {
                TempData["DeleteError"] =
                    "Please type DELETE to confirm account deletion.";

                return RedirectToAction(nameof(Index));
            }

            // -------------------------------------------------
            // ACCOUNT DELETION
            // -------------------------------------------------
            //
            // Do NOT delete anything yet.
            //
            // Once we connect this to your database, this
            // action will permanently remove the user's
            // account and associated data.
            // -------------------------------------------------

            TempData["DeleteError"] =
                "Account deletion is not yet enabled.";

            return RedirectToAction(nameof(Index));
        }
    }

}