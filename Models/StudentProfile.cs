using static System.Net.Mime.MediaTypeNames;

namespace HouseServices.Models
{
    public class StudentProfile
    {
        public int StudentID { get; set; }

        public string FirstName { get; set; } = "";
        public string? MiddleName { get; set; }
        public string LastName { get; set; } = "";

        public string Email { get; set; } = "";
        public string? PhoneNumber { get; set; }

        public string? IDNumber { get; set; }
        public DateTime? DateOfBirth { get; set; }

        public string? Citizenship { get; set; }
        public string? Gender { get; set; }

        public string? Province { get; set; }
        public string? City { get; set; }

        public string? Institution { get; set; }
        public string? StudentNumber { get; set; }

        public string? StudyLevel { get; set; }
        public string? Course { get; set; }
        public string? Faculty { get; set; }

        public int? YearOfStudy { get; set; }

        public decimal? AverageMark { get; set; }
        public decimal? HouseholdIncome { get; set; }

        public bool HasDisability { get; set; }
        public bool IsFirstGenerationStudent { get; set; }

        public DateTime CreatedDate { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public ICollection<StudentDocument> Documents { get; set; }
            = new List<StudentDocument>();

        public ICollection<Application> Applications { get; set; }
            = new List<Application>();
    }
}