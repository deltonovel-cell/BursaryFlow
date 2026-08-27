using HouseServices.Data;
using HouseServices.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HouseServices.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StudentProfileController : ControllerBase
    {
        private readonly BursaryFlowDbContext _context;

        public StudentProfileController(BursaryFlowDbContext context)
        {
            _context = context;
        }

        // =========================================================
        // GET ALL STUDENTS
        // GET: /api/StudentProfile
        // =========================================================

        [HttpGet]
        public async Task<IActionResult> GetStudents()
        {
            try
            {
                var students = await _context.StudentProfiles
                    .AsNoTracking()
                    .OrderByDescending(s => s.CreatedDate)
                    .ToListAsync();

                return Ok(new
                {
                    success = true,
                    count = students.Count,
                    data = students
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Could not retrieve student profiles.",
                    error = ex.Message
                });
            }
        }


        // =========================================================
        // GET STUDENT BY ID
        // GET: /api/StudentProfile/1
        // =========================================================

        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetStudent(int id)
        {
            try
            {
                var student = await _context.StudentProfiles
                    .AsNoTracking()
                    .FirstOrDefaultAsync(s => s.StudentID == id);

                if (student == null)
                {
                    return NotFound(new
                    {
                        success = false,
                        message = "Student profile not found."
                    });
                }

                return Ok(new
                {
                    success = true,
                    data = student
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Could not retrieve student profile.",
                    error = ex.Message
                });
            }
        }


        // =========================================================
        // CREATE STUDENT PROFILE
        // POST: /api/StudentProfile
        // =========================================================

        [HttpPost]
        public async Task<IActionResult> CreateStudent(
            [FromBody] StudentProfile student)
        {
            try
            {
                if (student == null)
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = "Student information is required."
                    });
                }

                // ---------------------------------------------
                // Basic validation
                // ---------------------------------------------

                if (string.IsNullOrWhiteSpace(student.FirstName))
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = "First name is required."
                    });
                }

                if (string.IsNullOrWhiteSpace(student.LastName))
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = "Last name is required."
                    });
                }

                if (string.IsNullOrWhiteSpace(student.Email))
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = "Email is required."
                    });
                }


                // ---------------------------------------------
                // Prevent duplicate email
                // ---------------------------------------------

                var existingEmail = await _context.StudentProfiles
                    .AnyAsync(s => s.Email == student.Email);

                if (existingEmail)
                {
                    return Conflict(new
                    {
                        success = false,
                        message = "A student profile with this email already exists."
                    });
                }


                // ---------------------------------------------
                // Prevent duplicate ID number
                // ---------------------------------------------

                if (!string.IsNullOrWhiteSpace(student.IDNumber))
                {
                    var existingID = await _context.StudentProfiles
                        .AnyAsync(s => s.IDNumber == student.IDNumber);

                    if (existingID)
                    {
                        return Conflict(new
                        {
                            success = false,
                            message = "A student profile with this ID number already exists."
                        });
                    }
                }


                // ---------------------------------------------
                // Dates
                // ---------------------------------------------

                student.CreatedDate = DateTime.UtcNow;
                student.UpdatedDate = DateTime.UtcNow;


                // ---------------------------------------------
                // Save
                // ---------------------------------------------

                _context.StudentProfiles.Add(student);

                await _context.SaveChangesAsync();


                return CreatedAtAction(
                    nameof(GetStudent),
                    new { id = student.StudentID },
                    new
                    {
                        success = true,
                        message = "Student profile created successfully.",
                        data = student
                    });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Could not create student profile.",
                    error = ex.Message
                });
            }
        }


        // =========================================================
        // UPDATE STUDENT PROFILE
        // PUT: /api/StudentProfile/1
        // =========================================================

        [HttpPut("{id:int}")]
        public async Task<IActionResult> UpdateStudent(
            int id,
            [FromBody] StudentProfile updatedStudent)
        {
            try
            {
                if (updatedStudent == null)
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = "Student information is required."
                    });
                }

                var student = await _context.StudentProfiles
                    .FirstOrDefaultAsync(s => s.StudentID == id);

                if (student == null)
                {
                    return NotFound(new
                    {
                        success = false,
                        message = "Student profile not found."
                    });
                }


                // ---------------------------------------------
                // Update fields
                // ---------------------------------------------

                student.FirstName = updatedStudent.FirstName;
                student.MiddleName = updatedStudent.MiddleName;
                student.LastName = updatedStudent.LastName;

                student.Email = updatedStudent.Email;
                student.PhoneNumber = updatedStudent.PhoneNumber;

                student.IDNumber = updatedStudent.IDNumber;
                student.DateOfBirth = updatedStudent.DateOfBirth;

                student.Citizenship = updatedStudent.Citizenship;
                student.Gender = updatedStudent.Gender;

                student.Province = updatedStudent.Province;
                student.City = updatedStudent.City;

                student.Institution = updatedStudent.Institution;
                student.StudentNumber = updatedStudent.StudentNumber;

                student.StudyLevel = updatedStudent.StudyLevel;
                student.Course = updatedStudent.Course;
                student.Faculty = updatedStudent.Faculty;

                student.YearOfStudy = updatedStudent.YearOfStudy;
                student.AverageMark = updatedStudent.AverageMark;

                student.HouseholdIncome = updatedStudent.HouseholdIncome;

                student.HasDisability = updatedStudent.HasDisability;
                student.IsFirstGenerationStudent =
                    updatedStudent.IsFirstGenerationStudent;

                student.UpdatedDate = DateTime.UtcNow;


                await _context.SaveChangesAsync();


                return Ok(new
                {
                    success = true,
                    message = "Student profile updated successfully.",
                    data = student
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Could not update student profile.",
                    error = ex.Message
                });
            }
        }


        // =========================================================
        // DELETE STUDENT
        // DELETE: /api/StudentProfile/1
        // =========================================================

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> DeleteStudent(int id)
        {
            try
            {
                var student = await _context.StudentProfiles
                    .FirstOrDefaultAsync(s => s.StudentID == id);

                if (student == null)
                {
                    return NotFound(new
                    {
                        success = false,
                        message = "Student profile not found."
                    });
                }

                _context.StudentProfiles.Remove(student);

                await _context.SaveChangesAsync();

                return Ok(new
                {
                    success = true,
                    message = "Student profile deleted successfully."
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Could not delete student profile.",
                    error = ex.Message
                });
            }
        }
    }
}