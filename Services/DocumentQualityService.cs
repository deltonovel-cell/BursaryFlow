using BursaryFlow.Models;
using Microsoft.AspNetCore.Http;
using System.Text.RegularExpressions;

namespace BursaryFlow.Services
{
    public class DocumentQualityService
    {
        private readonly IWebHostEnvironment _environment;

        public DocumentQualityService(IWebHostEnvironment environment)
        {
            _environment = environment;
        }

        // =========================================================
        // ANALYSE DOCUMENT
        // =========================================================

        public DocumentAnalysisResult Analyse(
            IFormFile file,
            string savedFilePath)
        {
            var result = new DocumentAnalysisResult
            {
                Success = true,

                FileName = file.FileName,

                FileType = Path.GetExtension(file.FileName)
                    .TrimStart('.')
                    .ToUpperInvariant(),

                FileSize = file.Length,

                QualityScore = 100,

                QualityLevel = "Excellent",

                NeedsEnhancement = false,

                ContainsText = false,

                IsScannedDocument = false
            };

            string extension =
                Path.GetExtension(file.FileName)
                    .ToLowerInvariant();


            // =====================================================
            // BASIC FILE CHECK
            // =====================================================

            if (file.Length == 0)
            {
                result.Success = false;

                result.QualityScore = 0;

                result.QualityLevel = "Invalid";

                result.NeedsEnhancement = false;

                result.Message =
                    "The uploaded document is empty.";

                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "File",

                        Severity = "Critical",

                        Field = "File",

                        Message =
                            "The file does not contain any data."
                    }
                );

                return result;
            }


            // =====================================================
            // FILE SIZE
            // =====================================================

            if (file.Length < 20 * 1024)
            {
                result.QualityScore -= 15;

                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "Quality",

                        Severity = "Warning",

                        Field = "File size",

                        Message =
                            "The document file is unusually small and may have reduced quality."
                    }
                );
            }


            // =====================================================
            // PDF
            // =====================================================

            if (extension == ".pdf")
            {
                AnalysePdf(
                    savedFilePath,
                    result
                );
            }


            // =====================================================
            // IMAGE
            // =====================================================

            if (
                extension == ".jpg" ||
                extension == ".jpeg" ||
                extension == ".png"
            )
            {
                AnalyseImage(
                    savedFilePath,
                    result
                );
            }


            // =====================================================
            // WORD DOCUMENT
            // =====================================================

            if (
                extension == ".doc" ||
                extension == ".docx"
            )
            {
                result.ContainsText = true;

                result.QualityScore =
                    Math.Max(
                        result.QualityScore,
                        85
                    );

                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "Information",

                        Severity = "Info",

                        Field = "Document",

                        Message =
                            "Text-based document detected. Content can be reviewed for spelling and consistency."
                    }
                );
            }


            // =====================================================
            // TEXT CONTENT
            // =====================================================

            if (extension == ".txt")
            {
                AnalyseTextContent(
                    savedFilePath,
                    result
                );
            }


            // =====================================================
            // QUALITY LEVEL
            // =====================================================

            if (result.QualityScore >= 85)
            {
                result.QualityLevel = "Excellent";

                result.NeedsEnhancement = false;
            }
            else if (result.QualityScore >= 70)
            {
                result.QualityLevel = "Good";

                result.NeedsEnhancement = false;
            }
            else if (result.QualityScore >= 50)
            {
                result.QualityLevel = "Needs improvement";

                result.NeedsEnhancement = true;
            }
            else
            {
                result.QualityLevel = "Poor";

                result.NeedsEnhancement = true;
            }


            // =====================================================
            // FINAL MESSAGE
            // =====================================================

            if (result.NeedsEnhancement)
            {
                result.Message =
                    "This document may be difficult to read. " +
                    "BursaryFlow recommends enhancing it before submission.";
            }
            else if (
                result.Issues.Any(
                    issue =>
                        issue.Severity == "Warning" ||
                        issue.Severity == "Critical"))
            {
                result.Message =
                    "The document can be used, but BursaryFlow has detected issues that should be reviewed.";
            }
            else
            {
                result.Message =
                    "This document appears to have good quality and should be suitable for use.";
            }

            return result;
        }


        // =========================================================
        // PDF ANALYSIS
        // =========================================================

        private void AnalysePdf(
            string filePath,
            DocumentAnalysisResult result)
        {
            FileInfo fileInfo =
                new FileInfo(filePath);


            if (!fileInfo.Exists)
            {
                result.Success = false;

                result.Message =
                    "The PDF could not be analysed.";

                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "File",

                        Severity = "Critical",

                        Field = "PDF",

                        Message =
                            "The PDF file could not be located after upload."
                    }
                );

                return;
            }


            // =====================================================
            // PDF SIZE
            // =====================================================

            if (fileInfo.Length < 10 * 1024)
            {
                result.QualityScore -= 20;

                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "Quality",

                        Severity = "Warning",

                        Field = "PDF",

                        Message =
                            "The PDF is unusually small and may be incomplete or difficult to read."
                    }
                );
            }


            // =====================================================
            // PDF TYPE
            // =====================================================

            result.IsScannedDocument = true;

            result.ContainsText = false;

            result.Issues.Add(
                new DocumentIssue
                {
                    Type = "Information",

                    Severity = "Info",

                    Field = "Document type",

                    Message =
                        "PDF document detected. Text and OCR analysis can be performed before final submission."
                }
            );
        }


        // =========================================================
        // IMAGE ANALYSIS
        // =========================================================

        private void AnalyseImage(
            string filePath,
            DocumentAnalysisResult result)
        {
            FileInfo fileInfo =
                new FileInfo(filePath);


            if (!fileInfo.Exists)
            {
                result.Success = false;

                result.Message =
                    "The image could not be analysed.";

                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "File",

                        Severity = "Critical",

                        Field = "Image",

                        Message =
                            "The uploaded image could not be located."
                    }
                );

                return;
            }


            // =====================================================
            // IMAGE SIZE
            // =====================================================

            if (fileInfo.Length < 100 * 1024)
            {
                result.QualityScore -= 20;

                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "Quality",

                        Severity = "Warning",

                        Field = "Image quality",

                        Message =
                            "The image file is unusually small and may have reduced resolution."
                    }
                );
            }


            // =====================================================
            // SCANNED DOCUMENT
            // =====================================================

            result.IsScannedDocument = true;

            result.Issues.Add(
                new DocumentIssue
                {
                    Type = "Information",

                    Severity = "Info",

                    Field = "Document type",

                    Message =
                        "Image-based document detected. OCR and image quality checks can be used to improve readability."
                }
            );
        }


        // =========================================================
        // TEXT CONTENT ANALYSIS
        // =========================================================

        private void AnalyseTextContent(
            string filePath,
            DocumentAnalysisResult result)
        {
            if (!File.Exists(filePath))
            {
                return;
            }


            try
            {
                string text =
                    File.ReadAllText(filePath);


                if (string.IsNullOrWhiteSpace(text))
                {
                    result.Issues.Add(
                        new DocumentIssue
                        {
                            Type = "Content",

                            Severity = "Warning",

                            Field = "Document content",

                            Message =
                                "No readable text was detected in the document."
                        }
                    );

                    return;
                }


                result.ContainsText = true;


                DetectPossibleSpellingMistakes(
                    text,
                    result
                );


                DetectCommonMismatches(
                    text,
                    result
                );
            }
            catch
            {
                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "Content",

                        Severity = "Warning",

                        Field = "Document content",

                        Message =
                            "The document could not be fully inspected for text errors."
                    }
                );
            }
        }


        // =========================================================
        // SPELLING DETECTION
        // =========================================================

        private void DetectPossibleSpellingMistakes(
            string text,
            DocumentAnalysisResult result)
        {
            var commonMistakes =
                new Dictionary<string, string>(
                    StringComparer.OrdinalIgnoreCase)
                {
                    { "univeristy", "university" },
                    { "universiy", "university" },
                    { "universitiy", "university" },

                    { "studnet", "student" },
                    { "studentt", "student" },

                    { "bursaray", "bursary" },
                    { "bursarry", "bursary" },

                    { "applicaton", "application" },
                    { "aplication", "application" },
                    { "applicantion", "application" },

                    { "certifcate", "certificate" },
                    { "certficate", "certificate" },

                    { "transciprt", "transcript" },
                    { "transript", "transcript" },

                    { "registartion", "registration" },
                    { "registraton", "registration" },

                    { "finacial", "financial" },
                    { "finanical", "financial" },

                    { "qualifcation", "qualification" },
                    { "qualificaton", "qualification" },

                    { "accomodation", "accommodation" },
                    { "accommadation", "accommodation" },

                    { "instituion", "institution" },
                    { "instution", "institution" },

                    { "enginnering", "engineering" },
                    { "engineerng", "engineering" },

                    { "informaton", "information" },
                    { "educaton", "education" }
                };


            foreach (
                var mistake
                in commonMistakes)
            {
                bool found =
                    Regex.IsMatch(
                        text,

                        $@"\b{Regex.Escape(mistake.Key)}\b",

                        RegexOptions.IgnoreCase
                    );


                if (!found)
                {
                    continue;
                }


                result.QualityScore =
                    Math.Max(
                        0,
                        result.QualityScore - 2
                    );


                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "Spelling",

                        Severity = "Warning",

                        Field = "Text",

                        DetectedText =
                            mistake.Key,

                        SuggestedText =
                            mistake.Value,

                        Message =
                            $"Possible spelling mistake detected: \"{mistake.Key}\". Suggested correction: \"{mistake.Value}\"."
                    }
                );
            }
        }


        // =========================================================
        // CONSISTENCY / MISMATCH DETECTION
        // =========================================================

        private void DetectCommonMismatches(
            string text,
            DocumentAnalysisResult result)
        {
            string[] suspiciousPatterns =
            {
                "date of birth",
                "student number",
                "student id",
                "institution",
                "university",
                "surname",
                "full name"
            };


            foreach (
                string pattern
                in suspiciousPatterns)
            {
                int occurrences =
                    Regex.Matches(
                        text,

                        Regex.Escape(pattern),

                        RegexOptions.IgnoreCase
                    ).Count;


                if (occurrences > 1)
                {
                    result.Issues.Add(
                        new DocumentIssue
                        {
                            Type = "Consistency",

                            Severity = "Info",

                            Field = pattern,

                            Message =
                                $"The document contains multiple references to \"{pattern}\". BursaryFlow will check these values for consistency before final submission."
                        }
                    );
                }
            }


            // =====================================================
            // YEAR CONSISTENCY
            // =====================================================

            MatchCollection years =
                Regex.Matches(
                    text,
                    @"\b20\d{2}\b"
                );


            var uniqueYears =
                years
                    .Select(
                        match =>
                            match.Value
                    )
                    .Distinct()
                    .ToList();


            if (uniqueYears.Count >= 3)
            {
                result.Issues.Add(
                    new DocumentIssue
                    {
                        Type = "Mismatch",

                        Severity = "Warning",

                        Field = "Year",

                        DetectedText =
                            string.Join(
                                ", ",
                                uniqueYears
                            ),

                        Message =
                            "Multiple different years were detected in the document. Please confirm that the dates and academic year information are correct."
                    }
                );
            }
        }
    }
}