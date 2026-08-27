using HouseServices.Models;

namespace BursaryFlow.Services
{
    public class StudentProfileService
    {
        public StudentProfile GetCurrentStudent()
        {
            return new StudentProfile
            {
                StudentID = 1,
                FirstName = "Delton",
                LastName = "",
                Email = "delton@example.com",
                Institution = "University of Johannesburg",
                Course = "Computer Science",
                Faculty = "College of Business and Economics",
                StudyLevel = "Undergraduate",
                YearOfStudy = 2,
                AverageMark = 75,
                Province = "Gauteng",
                HouseholdIncome = 120000,
                HasDisability = false,
                IsFirstGenerationStudent = false,
                CreatedDate = DateTime.Now
            };
        }
    }
}