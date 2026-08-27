using BursaryFlow.Models;
using BursaryFlow.Services;
using Microsoft.AspNetCore.Mvc;

namespace BursaryFlow.Controllers
{
    public class DocumentsController : Controller
    {
        private readonly IWebHostEnvironment _environment;
        private readonly DocumentQualityService _documentQualityService;

        public DocumentsController(
            IWebHostEnvironment environment,
            DocumentQualityService documentQualityService)
        {
            _environment = environment;
            _documentQualityService = documentQualityService;
        }


        // =========================================================
        // DOCUMENTS HOME
        // =========================================================

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }


        // =========================================================
        // CREATE DOCUMENT
        // =========================================================

        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }


        // =========================================================
        // CREATE DOCUMENT
        // =========================================================

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(
            string documentType,
            string fullName,
            string institution,
            string degree,
            string yearOfStudy,
            string bursaryName,
            string motivation,
            string financialSituation,
            string careerGoals,
            string additionalInformation)
        {
            if (string.IsNullOrWhiteSpace(documentType))
            {
                ViewBag.Error = "Please select a document type.";
                return View();
            }

            if (string.IsNullOrWhiteSpace(fullName))
            {
                ViewBag.Error = "Please enter your full name.";
                return View();
            }

            TempData["DocumentType"] = documentType;
            TempData["FullName"] = fullName;
            TempData["Institution"] = institution;
            TempData["Degree"] = degree;
            TempData["YearOfStudy"] = yearOfStudy;
            TempData["BursaryName"] = bursaryName;
            TempData["Motivation"] = motivation;
            TempData["FinancialSituation"] = financialSituation;
            TempData["CareerGoals"] = careerGoals;
            TempData["AdditionalInformation"] = additionalInformation;

            return RedirectToAction(
                "Preview",
                new { type = documentType }
            );
        }


        // =========================================================
        // DOCUMENT PREVIEW
        // =========================================================

        [HttpGet]
        public IActionResult Preview(string type)
        {
            if (string.IsNullOrWhiteSpace(type))
            {
                return RedirectToAction(nameof(Create));
            }

            ViewBag.DocumentType = type;

            ViewBag.FullName =
                TempData["FullName"]?.ToString() ?? "";

            ViewBag.Institution =
                TempData["Institution"]?.ToString() ?? "";

            ViewBag.Degree =
                TempData["Degree"]?.ToString() ?? "";

            ViewBag.YearOfStudy =
                TempData["YearOfStudy"]?.ToString() ?? "";

            ViewBag.BursaryName =
                TempData["BursaryName"]?.ToString() ?? "";

            ViewBag.Motivation =
                TempData["Motivation"]?.ToString() ?? "";

            ViewBag.FinancialSituation =
                TempData["FinancialSituation"]?.ToString() ?? "";

            ViewBag.CareerGoals =
                TempData["CareerGoals"]?.ToString() ?? "";

            ViewBag.AdditionalInformation =
                TempData["AdditionalInformation"]?.ToString() ?? "";

            return View();
        }


        // =========================================================
        // SAVE CREATED DOCUMENT
        // =========================================================

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Save(
            string documentType,
            string documentTitle,
            string documentContent)
        {
            if (string.IsNullOrWhiteSpace(documentContent))
            {
                TempData["Error"] =
                    "The document cannot be saved because it is empty.";

                return RedirectToAction(nameof(Create));
            }

            TempData["SavedDocumentTitle"] =
                string.IsNullOrWhiteSpace(documentTitle)
                    ? "Untitled Document"
                    : documentTitle;

            TempData["SavedDocumentType"] =
                documentType;

            TempData["DocumentSaved"] = true;

            return RedirectToAction(nameof(Index));
        }


        // =========================================================
        // DOWNLOAD CREATED DOCUMENT
        // =========================================================

        [HttpGet]
        public IActionResult Download(
            string documentTitle,
            string documentContent)
        {
            if (string.IsNullOrWhiteSpace(documentContent))
            {
                return RedirectToAction(nameof(Create));
            }

            string safeTitle =
                string.IsNullOrWhiteSpace(documentTitle)
                    ? "BursaryFlow-Document"
                    : documentTitle;

            foreach (
                char invalidCharacter
                in Path.GetInvalidFileNameChars())
            {
                safeTitle =
                    safeTitle.Replace(
                        invalidCharacter.ToString(),
                        ""
                    );
            }

            string fileName =
                safeTitle + ".txt";

            byte[] fileBytes =
                System.Text.Encoding.UTF8.GetBytes(
                    documentContent
                );

            return File(
                fileBytes,
                "text/plain",
                fileName
            );
        }


        // =========================================================
        // DELETE DOCUMENT
        // =========================================================

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Delete(int id)
        {
            TempData["DocumentDeleted"] = true;

            return RedirectToAction(nameof(Index));
        }


        // =========================================================
        // EDIT DOCUMENT
        // =========================================================

        [HttpGet]
        public IActionResult Edit(int id)
        {
            ViewBag.DocumentId = id;

            return View();
        }


        // =========================================================
        // UPDATE DOCUMENT
        // =========================================================

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(
            int id,
            string documentTitle,
            string documentContent)
        {
            if (string.IsNullOrWhiteSpace(documentContent))
            {
                ViewBag.Error =
                    "Document content cannot be empty.";

                ViewBag.DocumentId = id;

                return View();
            }

            TempData["DocumentUpdated"] = true;

            return RedirectToAction(nameof(Index));
        }


        // =========================================================
        // UPLOAD AND ANALYSE DOCUMENT
        // =========================================================

        [HttpPost]
        [RequestSizeLimit(10 * 1024 * 1024)]
        public async Task<IActionResult> AnalyzeDocument(
            IFormFile file)
        {
            // -----------------------------------------------------
            // CHECK FILE
            // -----------------------------------------------------

            if (file == null || file.Length == 0)
            {
                return BadRequest(new
                {
                    success = false,
                    message = "Please select a document."
                });
            }


            // -----------------------------------------------------
            // MAXIMUM FILE SIZE
            // -----------------------------------------------------

            const long maximumFileSize =
                10 * 1024 * 1024;

            if (file.Length > maximumFileSize)
            {
                return BadRequest(new
                {
                    success = false,
                    message =
                        "The document must be smaller than 10 MB."
                });
            }


            // -----------------------------------------------------
            // FILE EXTENSION
            // -----------------------------------------------------

            string extension =
                Path.GetExtension(file.FileName)
                    .ToLowerInvariant();

            string[] allowedExtensions =
            {
                ".pdf",
                ".jpg",
                ".jpeg",
                ".png",
                ".doc",
                ".docx",
                ".txt"
            };


            if (!allowedExtensions.Contains(extension))
            {
                return BadRequest(new
                {
                    success = false,
                    message =
                        "This file type is not supported."
                });
            }


            // -----------------------------------------------------
            // CREATE UPLOAD DIRECTORY
            // -----------------------------------------------------

            string uploadDirectory =
                Path.Combine(
                    _environment.WebRootPath,
                    "uploads",
                    "documents"
                );


            if (!Directory.Exists(uploadDirectory))
            {
                Directory.CreateDirectory(
                    uploadDirectory
                );
            }


            // -----------------------------------------------------
            // CREATE SAFE FILE NAME
            // -----------------------------------------------------

            string originalFileName =
                Path.GetFileName(
                    file.FileName
                );

            string uniqueFileName =
                Guid.NewGuid().ToString("N")
                + extension;


            string savedFilePath =
                Path.Combine(
                    uploadDirectory,
                    uniqueFileName
                );


            // -----------------------------------------------------
            // SAVE FILE
            // -----------------------------------------------------

            try
            {
                using FileStream stream =
                    new FileStream(
                        savedFilePath,
                        FileMode.Create
                    );

                await file.CopyToAsync(stream);
            }
            catch
            {
                return StatusCode(
                    500,
                    new
                    {
                        success = false,
                        message =
                            "The document could not be saved on the server."
                    }
                );
            }


            // -----------------------------------------------------
            // ANALYSE SAVED DOCUMENT
            // -----------------------------------------------------

            DocumentAnalysisResult analysis;

            try
            {
                analysis =
                    _documentQualityService.Analyse(
                        file,
                        savedFilePath
                    );
            }
            catch
            {
                // Remove file if analysis fails.

                if (System.IO.File.Exists(savedFilePath))
                {
                    System.IO.File.Delete(
                        savedFilePath
                    );
                }

                return StatusCode(
                    500,
                    new
                    {
                        success = false,
                        message =
                            "The document was uploaded, but BursaryFlow could not analyse it."
                    }
                );
            }


            // -----------------------------------------------------
            // ANALYSIS FAILED
            // -----------------------------------------------------

            if (!analysis.Success)
            {
                return BadRequest(
                    new
                    {
                        success = false,

                        message =
                            analysis.Message,

                        fileName =
                            analysis.FileName,

                        qualityScore =
                            analysis.QualityScore,

                        qualityLevel =
                            analysis.QualityLevel,

                        needsEnhancement =
                            analysis.NeedsEnhancement,

                        containsText =
                            analysis.ContainsText,

                        isScannedDocument =
                            analysis.IsScannedDocument,

                        issues =
                            analysis.Issues
                    }
                );
            }


            // -----------------------------------------------------
            // RETURN ANALYSIS TO FRONTEND
            // -----------------------------------------------------

            return Ok(
                new
                {
                    success = true,

                    documentId =
                        uniqueFileName,

                    fileName =
                        analysis.FileName,

                    storedFileName =
                        uniqueFileName,

                    fileSize =
                        analysis.FileSize,

                    fileType =
                        analysis.FileType,

                    qualityScore =
                        analysis.QualityScore,

                    qualityLevel =
                        analysis.QualityLevel,

                    needsEnhancement =
                        analysis.NeedsEnhancement,

                    containsText =
                        analysis.ContainsText,

                    isScannedDocument =
                        analysis.IsScannedDocument,

                    message =
                        analysis.Message,

                    issues =
                        analysis.Issues,

                    canEnhance = true,

                    canEdit =
                        extension == ".pdf" ||
                        extension == ".doc" ||
                        extension == ".docx" ||
                        extension == ".txt"
                }
            );
        }


        // =========================================================
        // ENHANCE DOCUMENT
        // =========================================================

        [HttpPost]
        [RequestSizeLimit(10 * 1024 * 1024)]
        public async Task<IActionResult> EnhanceDocument(
            IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest(new
                {
                    success = false,
                    message =
                        "No document was provided."
                });
            }


            const long maximumFileSize =
                10 * 1024 * 1024;


            if (file.Length > maximumFileSize)
            {
                return BadRequest(new
                {
                    success = false,
                    message =
                        "The document must be smaller than 10 MB."
                });
            }


            string extension =
                Path.GetExtension(
                    file.FileName
                ).ToLowerInvariant();


            string uploadDirectory =
                Path.Combine(
                    _environment.WebRootPath,
                    "uploads",
                    "documents"
                );


            if (!Directory.Exists(uploadDirectory))
            {
                Directory.CreateDirectory(
                    uploadDirectory
                );
            }


            string enhancedFileName =
                "Enhanced_"
                + Guid.NewGuid().ToString("N")
                + extension;


            string enhancedPath =
                Path.Combine(
                    uploadDirectory,
                    enhancedFileName
                );


            try
            {
                using FileStream stream =
                    new FileStream(
                        enhancedPath,
                        FileMode.Create
                    );

                await file.CopyToAsync(stream);
            }
            catch
            {
                return StatusCode(
                    500,
                    new
                    {
                        success = false,
                        message =
                            "The document could not be processed."
                    }
                );
            }


            return Ok(
                new
                {
                    success = true,

                    message =
                        "The document has been prepared for enhancement.",

                    fileName =
                        file.FileName,

                    storedFileName =
                        enhancedFileName,

                    downloadUrl =
                        "/uploads/documents/"
                        + enhancedFileName
                }
            );
        }


        // =========================================================
        // PREPARE PDF EDITOR
        // =========================================================

        [HttpPost]
        [RequestSizeLimit(10 * 1024 * 1024)]
        public async Task<IActionResult> PreparePdfEditor(
            IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest(new
                {
                    success = false,
                    message =
                        "Please select a PDF."
                });
            }


            string extension =
                Path.GetExtension(
                    file.FileName
                ).ToLowerInvariant();


            if (extension != ".pdf")
            {
                return BadRequest(new
                {
                    success = false,
                    message =
                        "Only PDF files can be opened in the PDF editor."
                });
            }


            string uploadDirectory =
                Path.Combine(
                    _environment.WebRootPath,
                    "uploads",
                    "documents"
                );


            if (!Directory.Exists(uploadDirectory))
            {
                Directory.CreateDirectory(
                    uploadDirectory
                );
            }


            string storedFileName =
                Guid.NewGuid().ToString("N")
                + ".pdf";


            string savedPath =
                Path.Combine(
                    uploadDirectory,
                    storedFileName
                );


            try
            {
                using FileStream stream =
                    new FileStream(
                        savedPath,
                        FileMode.Create
                    );

                await file.CopyToAsync(stream);
            }
            catch
            {
                return StatusCode(
                    500,
                    new
                    {
                        success = false,
                        message =
                            "The PDF could not be prepared for editing."
                    }
                );
            }


            return Ok(
                new
                {
                    success = true,

                    fileName =
                        file.FileName,

                    fileSize =
                        file.Length,

                    storedFileName =
                        storedFileName,

                    editorReady = true,

                    editorUrl =
                        "/uploads/documents/"
                        + storedFileName,

                    message =
                        "PDF is ready for editing."
                }
            );
        }


        // =========================================================
        // SAVE EDITED DOCUMENT
        // =========================================================

        [HttpPost]
        [RequestSizeLimit(10 * 1024 * 1024)]
        public async Task<IActionResult> SaveEditedDocument(
            IFormFile file,
            string documentId)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest(new
                {
                    success = false,
                    message =
                        "No edited document was provided."
                });
            }


            string extension =
                Path.GetExtension(
                    file.FileName
                ).ToLowerInvariant();


            string uploadDirectory =
                Path.Combine(
                    _environment.WebRootPath,
                    "uploads",
                    "documents"
                );


            if (!Directory.Exists(uploadDirectory))
            {
                Directory.CreateDirectory(
                    uploadDirectory
                );
            }


            string editedFileName =
                "Edited_"
                + Guid.NewGuid().ToString("N")
                + extension;


            string editedPath =
                Path.Combine(
                    uploadDirectory,
                    editedFileName
                );


            try
            {
                using FileStream stream =
                    new FileStream(
                        editedPath,
                        FileMode.Create
                    );

                await file.CopyToAsync(stream);
            }
            catch
            {
                return StatusCode(
                    500,
                    new
                    {
                        success = false,
                        message =
                            "The edited document could not be saved."
                    }
                );
            }


            return Ok(
                new
                {
                    success = true,

                    message =
                        "Your edited document has been saved.",

                    documentId =
                        editedFileName,

                    fileName =
                        file.FileName,

                    downloadUrl =
                        "/uploads/documents/"
                        + editedFileName
                }
            );
        }

        [HttpPost]
        public async Task<IActionResult> Upload(
        IFormFile file,
        string documentType,
        string quality)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest(new
                {
                    success = false,
                    message = "No document was received."
                });
            }

            try
            {
                const long maxFileSize = 10 * 1024 * 1024;

                if (file.Length > maxFileSize)
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = "The document is larger than the 10 MB limit."
                    });
                }

                string extension =
                    Path.GetExtension(file.FileName)
                        .ToLowerInvariant();

                string[] allowedExtensions =
                {
            ".pdf",
            ".jpg",
            ".jpeg",
            ".png",
            ".doc",
            ".docx"
        };

                if (!allowedExtensions.Contains(extension))
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = "This document type is not supported."
                    });
                }

                string uploadsFolder =
                    Path.Combine(
                        _environment.WebRootPath,
                        "uploads",
                        "documents"
                    );

                if (!Directory.Exists(uploadsFolder))
                {
                    Directory.CreateDirectory(uploadsFolder);
                }

                string uniqueFileName =
                    $"{Guid.NewGuid()}{extension}";

                string filePath =
                    Path.Combine(
                        uploadsFolder,
                        uniqueFileName
                    );

                await using (
                    FileStream stream =
                        new FileStream(
                            filePath,
                            FileMode.Create
                        ))
                {
                    await file.CopyToAsync(stream);
                }

                return Ok(new
                {
                    success = true,
                    message = "Document uploaded successfully.",
                    fileName = file.FileName,
                    storedFileName = uniqueFileName,
                    documentType = documentType ?? "",
                    quality = quality ?? "Good",
                    size = file.Length
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine(
                    "Final document upload error: " +
                    ex
                );

                return StatusCode(
                    500,
                    new
                    {
                        success = false,
                        message =
                            "The document could not be saved."
                    }
                );
            }
        }
    }

}