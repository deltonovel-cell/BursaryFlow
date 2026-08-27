namespace HouseServices.Models
{
    public class Application
    {
        public int ApplicationID { get; set; }

        public int StudentID { get; set; }
        public int BursaryID { get; set; }
        public int? CycleID { get; set; }

        public DateTime ApplicationDate { get; set; }

        public string Status { get; set; } = "";

        public decimal? EligibilityScore { get; set; }

        public string? EligibilityStatus { get; set; }

        public int MissingDocumentsCount { get; set; }
        public int MissingRequirementsCount { get; set; }

        public DateTime? SubmittedDate { get; set; }

        public string? ExternalApplicationURL { get; set; }
        public string? ExternalReference { get; set; }

        public string? Notes { get; set; }

        public StudentProfile? Student { get; set; }
        public Bursary? Bursary { get; set; }
        public BursaryCycle? Cycle { get; set; }

        public ICollection<ApplicationDocument> Documents { get; set; }
            = new List<ApplicationDocument>();

        public ICollection<ApplicationStatusHistory> StatusHistory { get; set; }
            = new List<ApplicationStatusHistory>();
    }
}