using HouseServices.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HouseServices.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BursaryController : ControllerBase
    {
        private readonly BursaryFlowDbContext _context;

        public BursaryController(BursaryFlowDbContext context)
        {
            _context = context;
        }

        // =========================================================
        // GET ALL BURSARIES
        // GET: /api/Bursary
        // =========================================================

        [HttpGet]
        public async Task<IActionResult> GetBursaries()
        {
            try
            {
                var bursaries = await _context.Bursaries
                    .AsNoTracking()
                    .Include(b => b.Provider)
                    .OrderBy(b => b.BursaryName)
                    .Select(b => new
                    {
                        b.BursaryID,
                        b.BursaryName,
                        b.Description,

                        Provider = b.Provider == null
                            ? null
                            : b.Provider.ProviderName,

                        b.WebsiteURL,
                        b.ApplicationURL,
                        b.InformationURL,

                        b.StudyLevel,
                        b.StudyFields,

                        b.MinimumAverage,
                        b.MaximumHouseholdIncome,

                        b.MinimumYearOfStudy,
                        b.MaximumYearOfStudy,

                        b.MinimumAge,
                        b.MaximumAge,

                        b.CitizenshipRequirement,
                        b.InstitutionRequirement,

                        b.FinancialNeedRequired,

                        b.TuitionIncluded,
                        b.BooksIncluded,
                        b.AccommodationIncluded,
                        b.AccommodationAllowanceIncluded,
                        b.LivingAllowanceIncluded,
                        b.TransportAllowanceIncluded,

                        b.IsVerified,
                        b.VerificationStatus,
                        b.IsActive,

                        b.LastVerified,
                        b.CreatedDate
                    })
                    .ToListAsync();

                return Ok(new
                {
                    success = true,
                    count = bursaries.Count,
                    data = bursaries
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Could not retrieve bursaries.",
                    error = ex.Message
                });
            }
        }


        // =========================================================
        // GET BURSARY BY ID
        // GET: /api/Bursary/16
        // =========================================================

        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetBursary(int id)
        {
            try
            {
                var bursary = await _context.Bursaries
                    .AsNoTracking()
                    .Include(b => b.Provider)
                    .Where(b => b.BursaryID == id)
                    .Select(b => new
                    {
                        b.BursaryID,
                        b.BursaryName,
                        b.Description,

                        Provider = b.Provider == null
                            ? null
                            : new
                            {
                                b.Provider.ProviderID,
                                b.Provider.ProviderName,
                                b.Provider.ProviderType,
                                b.Provider.WebsiteURL,
                                b.Provider.ApplicationPortalURL,
                                b.Provider.ContactEmail,
                                b.Provider.ContactPhone,
                                b.Provider.IsOfficial
                            },

                        b.WebsiteURL,
                        b.ApplicationURL,
                        b.InformationURL,

                        b.StudyLevel,
                        b.StudyFields,

                        b.MinimumAverage,
                        b.MaximumHouseholdIncome,

                        b.MinimumYearOfStudy,
                        b.MaximumYearOfStudy,

                        b.MinimumAge,
                        b.MaximumAge,

                        b.CitizenshipRequirement,
                        b.InstitutionRequirement,

                        b.FinancialNeedRequired,

                        b.TuitionIncluded,
                        b.BooksIncluded,
                        b.AccommodationIncluded,
                        b.AccommodationAllowanceIncluded,
                        b.LivingAllowanceIncluded,
                        b.TransportAllowanceIncluded,

                        b.IsVerified,
                        b.VerificationStatus,
                        b.IsActive,

                        b.LastVerified,
                        b.CreatedDate
                    })
                    .FirstOrDefaultAsync();

                if (bursary == null)
                {
                    return NotFound(new
                    {
                        success = false,
                        message = "Bursary not found."
                    });
                }

                return Ok(new
                {
                    success = true,
                    data = bursary
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Could not retrieve bursary.",
                    error = ex.Message
                });
            }
        }


        // =========================================================
        // SEARCH BURSARIES
        //
        // Example:
        // /api/Bursary/search?search=engineering
        // =========================================================

        [HttpGet("search")]
        public async Task<IActionResult> SearchBursaries(
            [FromQuery] string? search)
        {
            try
            {
                var query = _context.Bursaries
                    .AsNoTracking()
                    .Include(b => b.Provider)
                    .Where(b => b.IsActive);

                if (!string.IsNullOrWhiteSpace(search))
                {
                    search = search.Trim();

                    query = query.Where(b =>
                        b.BursaryName.Contains(search) ||
                        (b.Description != null &&
                         b.Description.Contains(search)) ||
                        (b.StudyFields != null &&
                         b.StudyFields.Contains(search)) ||
                        (b.StudyLevel != null &&
                         b.StudyLevel.Contains(search)) ||
                        (b.Provider != null &&
                         b.Provider.ProviderName.Contains(search)));
                }

                var results = await query
                    .OrderBy(b => b.BursaryName)
                    .Select(b => new
                    {
                        b.BursaryID,
                        b.BursaryName,

                        Provider = b.Provider == null
                            ? null
                            : b.Provider.ProviderName,

                        b.StudyLevel,
                        b.StudyFields,

                        b.MinimumAverage,
                        b.MaximumHouseholdIncome,

                        b.ApplicationURL,
                        b.WebsiteURL,

                        b.IsVerified,
                        b.VerificationStatus
                    })
                    .ToListAsync();

                return Ok(new
                {
                    success = true,
                    count = results.Count,
                    data = results
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Search failed.",
                    error = ex.Message
                });
            }
        }


        // =========================================================
        // CURRENTLY OPEN BURSARIES
        //
        // GET:
        // /api/Bursary/open
        // =========================================================

        [HttpGet("open")]
        public async Task<IActionResult> GetOpenBursaries()
        {
            try
            {
                var today = DateTime.Today;

                var results = await _context.BursaryCycles
                    .AsNoTracking()
                    .Include(c => c.Bursary)
                    .Where(c =>
                        c.Status == "Open" &&
                        c.OpeningDate <= today &&
                        c.ClosingDate >= today &&
                        c.Bursary.IsActive)
                    .OrderBy(c => c.ClosingDate)
                    .Select(c => new
                    {
                        c.CycleID,

                        c.BursaryID,

                        BursaryName = c.Bursary.BursaryName,

                        c.AcademicYear,
                        c.CycleName,

                        c.OpeningDate,
                        c.ClosingDate,

                        ApplicationURL =
                            c.ApplicationURL ??
                            c.Bursary.ApplicationURL,

                        c.Status,
                        DaysRemaining =
    c.ClosingDate.HasValue
        ? (c.ClosingDate.Value - today).Days
        : (int?)null
                    })
                    .ToListAsync();

                return Ok(new
                {
                    success = true,
                    count = results.Count,
                    data = results
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Could not retrieve open bursaries.",
                    error = ex.Message
                });
            }
        }


        // =========================================================
        // FILTER FOR A STUDENT
        //
        // Example:
        //
        // /api/Bursary/match
        // ?studyLevel=Undergraduate
        // &studyField=Computer Science
        // &yearOfStudy=2
        // &average=70
        // &householdIncome=120000
        // =========================================================

        [HttpGet("match")]
        public async Task<IActionResult> MatchBursaries(
            [FromQuery] string? studyLevel,
            [FromQuery] string? studyField,
            [FromQuery] int? yearOfStudy,
            [FromQuery] decimal? average,
            [FromQuery] decimal? householdIncome)
        {
            try
            {
                var query = _context.Bursaries
                    .AsNoTracking()
                    .Include(b => b.Provider)
                    .Where(b => b.IsActive);

                // STUDY LEVEL

                if (!string.IsNullOrWhiteSpace(studyLevel))
                {
                    query = query.Where(b =>
                        b.StudyLevel == null ||
                        b.StudyLevel.Contains(studyLevel));
                }

                // STUDY FIELD

                if (!string.IsNullOrWhiteSpace(studyField))
                {
                    query = query.Where(b =>
                        b.StudyFields == null ||
                        b.StudyFields.Contains(studyField));
                }

                // YEAR OF STUDY

                if (yearOfStudy.HasValue)
                {
                    query = query.Where(b =>
                        (!b.MinimumYearOfStudy.HasValue ||
                         yearOfStudy >= b.MinimumYearOfStudy) &&

                        (!b.MaximumYearOfStudy.HasValue ||
                         yearOfStudy <= b.MaximumYearOfStudy));
                }

                // AVERAGE

                if (average.HasValue)
                {
                    query = query.Where(b =>
                        !b.MinimumAverage.HasValue ||
                        average >= b.MinimumAverage);
                }

                // HOUSEHOLD INCOME

                if (householdIncome.HasValue)
                {
                    query = query.Where(b =>
                        !b.MaximumHouseholdIncome.HasValue ||
                        householdIncome <= b.MaximumHouseholdIncome);
                }

                var results = await query
                    .OrderByDescending(b => b.IsVerified)
                    .ThenBy(b => b.BursaryName)
                    .Select(b => new
                    {
                        b.BursaryID,
                        b.BursaryName,

                        Provider = b.Provider == null
                            ? null
                            : b.Provider.ProviderName,

                        b.Description,

                        b.StudyLevel,
                        b.StudyFields,

                        b.MinimumAverage,
                        b.MaximumHouseholdIncome,

                        b.MinimumYearOfStudy,
                        b.MaximumYearOfStudy,

                        b.ApplicationURL,
                        b.WebsiteURL,

                        b.IsVerified,
                        b.VerificationStatus
                    })
                    .ToListAsync();

                return Ok(new
                {
                    success = true,
                    count = results.Count,
                    data = results
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Could not match bursaries.",
                    error = ex.Message
                });
            }
        }
    }
}