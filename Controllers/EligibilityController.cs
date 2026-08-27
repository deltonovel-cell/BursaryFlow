using HouseServices.Data;
using HouseServices.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HouseServices.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EligibilityController : ControllerBase
    {
        private readonly BursaryFlowDbContext _context;

        public EligibilityController(BursaryFlowDbContext context)
        {
            _context = context;
        }

        // =====================================================
        // GET: api/Eligibility/student/1
        // =====================================================

        [HttpGet("student/{studentId}")]
        public async Task<IActionResult> CheckEligibility(int studentId)
        {
            try
            {
                // -------------------------------------------------
                // FIND STUDENT
                // -------------------------------------------------

                var student = await _context.StudentProfiles
                    .FirstOrDefaultAsync(s => s.StudentID == studentId);

                if (student == null)
                {
                    return NotFound(new
                    {
                        success = false,
                        message = "Student profile not found."
                    });
                }


                // -------------------------------------------------
                // GET ACTIVE BURSARIES
                // -------------------------------------------------

                var bursaries = await _context.Bursaries
                    .Where(b => b.IsActive)
                    .OrderBy(b => b.BursaryName)
                    .ToListAsync();


                var results = new List<object>();


                // -------------------------------------------------
                // CHECK EACH BURSARY
                // -------------------------------------------------

                foreach (var bursary in bursaries)
                {
                    var requirements =
                        await _context.BursaryRequirements
                            .Where(r => r.BursaryID == bursary.BursaryID)
                            .ToListAsync();


                    int totalRequirements = requirements.Count;
                    int passedRequirements = 0;
                    int failedRequirements = 0;
                    int mandatoryFailures = 0;


                    // -------------------------------------------------
                    // CHECK REQUIREMENTS
                    // -------------------------------------------------

                    foreach (var requirement in requirements)
                    {
                        bool passed =
                            CheckRequirement(
                                student,
                                requirement
                            );


                        if (passed)
                        {
                            passedRequirements++;
                        }
                        else
                        {
                            failedRequirements++;

                            if (requirement.IsMandatory)
                            {
                                mandatoryFailures++;
                            }
                        }
                    }


                    // -------------------------------------------------
                    // CALCULATE SCORE
                    // -------------------------------------------------

                    decimal score;

                    if (totalRequirements == 0)
                    {
                        score = 0;
                    }
                    else
                    {
                        score = Math.Round(
                            ((decimal)passedRequirements /
                             totalRequirements) * 100,
                            2
                        );
                    }


                    // -------------------------------------------------
                    // DETERMINE STATUS
                    // -------------------------------------------------

                    string status;

                    if (
                        totalRequirements > 0 &&
                        mandatoryFailures == 0 &&
                        passedRequirements == totalRequirements
                    )
                    {
                        status = "Eligible";
                    }
                    else if (
                        mandatoryFailures == 0 &&
                        score >= 60
                    )
                    {
                        status = "Partially Eligible";
                    }
                    else
                    {
                        status = "Not Eligible";
                    }


                    // -------------------------------------------------
                    // GET CURRENT / LATEST CYCLE
                    // -------------------------------------------------

                    var currentCycle =
                        await _context.BursaryCycles
                            .Where(c =>
                                c.BursaryID ==
                                bursary.BursaryID)
                            .OrderByDescending(c =>
                                c.AcademicYear)
                            .ThenByDescending(c =>
                                c.OpeningDate)
                            .FirstOrDefaultAsync();


                    // -------------------------------------------------
                    // DETERMINE WHETHER APPLICATION IS OPEN
                    // -------------------------------------------------

                    bool applicationOpen = false;

                    if (currentCycle != null)
                    {
                        DateTime today = DateTime.Today;

                        if (
                            currentCycle.OpeningDate.HasValue &&
                            currentCycle.ClosingDate.HasValue
                        )
                        {
                            applicationOpen =
                                today >=
                                currentCycle.OpeningDate.Value
                                &&
                                today <=
                                currentCycle.ClosingDate.Value;
                        }
                    }


                    // -------------------------------------------------
                    // CURRENT APPLICATION URL
                    // -------------------------------------------------

                    string? applicationUrl =
                        currentCycle?.ApplicationURL
                        ?? bursary.ApplicationURL;


                    // -------------------------------------------------
                    // ADD RESULT
                    // -------------------------------------------------

                    results.Add(new
                    {
                        bursaryId = bursary.BursaryID,

                        bursaryName = bursary.BursaryName,

                        providerId = bursary.ProviderID,

                        score = score,

                        status = status,

                        totalRequirements =
                            totalRequirements,

                        passedRequirements =
                            passedRequirements,

                        failedRequirements =
                            failedRequirements,

                        mandatoryFailures =
                            mandatoryFailures,

                        applicationOpen =
                            applicationOpen,

                        openingDate =
                            currentCycle?.OpeningDate,

                        closingDate =
                            currentCycle?.ClosingDate,

                        applicationUrl =
                            applicationUrl,

                        websiteUrl =
                            bursary.WebsiteURL,

                        informationUrl =
                            bursary.InformationURL
                    });
                }


                // -------------------------------------------------
                // RETURN RESPONSE
                // -------------------------------------------------

                return Ok(new
                {
                    success = true,

                    student = new
                    {
                        studentId =
                            student.StudentID,

                        firstName =
                            student.FirstName,

                        lastName =
                            student.LastName,

                        averageMark =
                            student.AverageMark,

                        householdIncome =
                            student.HouseholdIncome,

                        citizenship =
                            student.Citizenship,

                        studyLevel =
                            student.StudyLevel,

                        course =
                            student.Course,

                        faculty =
                            student.Faculty,

                        yearOfStudy =
                            student.YearOfStudy
                    },

                    totalBursaries =
                        results.Count,

                    eligibleBursaries =
                        results.Count(r =>
                            GetPropertyValue(
                                r,
                                "status"
                            ) == "Eligible"),

                    results = results
                });
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    new
                    {
                        success = false,

                        message =
                            "Could not calculate eligibility.",

                        error = ex.Message,

                        innerError =
                            ex.InnerException?.Message
                    }
                );
            }
        }


        // =====================================================
        // CHECK REQUIREMENT
        // =====================================================

        private bool CheckRequirement(
            StudentProfile student,
            BursaryRequirement requirement)
        {
            string type =
                requirement.RequirementType?
                    .Trim()
                    .ToLower()
                ?? "";

            string requiredValue =
                requirement.RequiredValue?
                    .Trim()
                ?? "";

            string comparison =
                requirement.ComparisonOperator?
                    .Trim()
                ?? "=";


            // -------------------------------------------------
            // CITIZENSHIP
            // -------------------------------------------------

            if (type == "citizenship")
            {
                return CompareText(
                    student.Citizenship,
                    requiredValue,
                    comparison
                );
            }


            // -------------------------------------------------
            // ACADEMIC
            // -------------------------------------------------

            if (type == "academic")
            {
                if (!student.AverageMark.HasValue)
                    return false;

                if (!decimal.TryParse(
                    requiredValue,
                    out decimal requiredAverage))
                {
                    return false;
                }

                return CompareDecimal(
                    student.AverageMark.Value,
                    requiredAverage,
                    comparison
                );
            }


            // -------------------------------------------------
            // FINANCIAL
            // -------------------------------------------------

            if (type == "financial")
            {
                if (!student.HouseholdIncome.HasValue)
                    return false;

                if (!decimal.TryParse(
                    requiredValue,
                    out decimal requiredIncome))
                {
                    return false;
                }

                return CompareDecimal(
                    student.HouseholdIncome.Value,
                    requiredIncome,
                    comparison
                );
            }


            // -------------------------------------------------
            // STUDY LEVEL
            // -------------------------------------------------

            if (type == "studylevel")
            {
                return CompareText(
                    student.StudyLevel,
                    requiredValue,
                    comparison
                );
            }


            // -------------------------------------------------
            // STUDY FIELD
            // -------------------------------------------------

            if (type == "studyfield")
            {
                string studentField =
                    $"{student.Course} {student.Faculty}";


                return FieldMatches(
                    studentField,
                    requiredValue
                );
            }


            // -------------------------------------------------
            // UNKNOWN REQUIREMENT
            // -------------------------------------------------

            // Don't automatically fail requirements
            // that the engine doesn't understand yet.
            return true;
        }


        // =====================================================
        // TEXT COMPARISON
        // =====================================================

        private bool CompareText(
            string? actual,
            string required,
            string comparison)
        {
            if (string.IsNullOrWhiteSpace(actual))
                return false;


            if (comparison == "=")
            {
                return actual.Trim()
                    .Equals(
                        required.Trim(),
                        StringComparison.OrdinalIgnoreCase
                    );
            }


            return false;
        }


        // =====================================================
        // DECIMAL COMPARISON
        // =====================================================

        private bool CompareDecimal(
            decimal actual,
            decimal required,
            string comparison)
        {
            return comparison switch
            {
                "=" => actual == required,

                ">=" => actual >= required,

                "<=" => actual <= required,

                ">" => actual > required,

                "<" => actual < required,

                _ => false
            };
        }


        // =====================================================
        // STUDY FIELD MATCHING
        // =====================================================

        private bool FieldMatches(
            string? studentField,
            string requiredField)
        {
            if (string.IsNullOrWhiteSpace(studentField))
                return false;


            studentField =
                studentField.ToLower();

            requiredField =
                requiredField.ToLower();


            // -------------------------------------------------
            // STEM
            // -------------------------------------------------

            if (requiredField.Contains("stem"))
            {
                string[] keywords =
                {
                    "computer",
                    "computing",
                    "informatics",
                    "information technology",
                    "it ",
                    "engineering",
                    "science",
                    "mathematics",
                    "mathematical",
                    "statistics",
                    "technology",
                    "physics",
                    "chemistry"
                };


                return keywords.Any(
                    keyword =>
                        studentField.Contains(keyword)
                );
            }


            // -------------------------------------------------
            // TEACHING / EDUCATION
            // -------------------------------------------------

            if (
                requiredField.Contains("teaching") ||
                requiredField.Contains("education")
            )
            {
                return
                    studentField.Contains("education") ||
                    studentField.Contains("teaching");
            }


            // -------------------------------------------------
            // ENGINEERING
            // -------------------------------------------------

            if (requiredField.Contains("engineering"))
            {
                return studentField.Contains(
                    "engineering"
                );
            }


            // -------------------------------------------------
            // SCIENCE
            // -------------------------------------------------

            if (requiredField.Contains("science"))
            {
                return studentField.Contains(
                    "science"
                );
            }


            // -------------------------------------------------
            // GENERAL MATCH
            // -------------------------------------------------

            return studentField.Contains(
                requiredField
            );
        }


        // =====================================================
        // GET ANONYMOUS OBJECT PROPERTY
        // =====================================================

        private string? GetPropertyValue(
            object obj,
            string propertyName)
        {
            return obj.GetType()
                .GetProperty(propertyName)?
                .GetValue(obj)?
                .ToString();
        }
    }
}