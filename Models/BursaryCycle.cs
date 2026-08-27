using static System.Net.Mime.MediaTypeNames;

namespace HouseServices.Models
{
    public class BursaryCycle
    {
        public int CycleID { get; set; }
        public int BursaryID { get; set; }

        public int AcademicYear { get; set; }
        public string? CycleName { get; set; }

        public DateTime? OpeningDate { get; set; }
        public DateTime? ClosingDate { get; set; }

        public string? ApplicationURL { get; set; }

        public string Status { get; set; } = "";

        public bool IsVerified { get; set; }

        public DateTime? LastChecked { get; set; }

        public string? SourceURL { get; set; }
        public string? Notes { get; set; }

        public DateTime CreatedDate { get; set; }

        public Bursary? Bursary { get; set; }

        public ICollection<Application> Applications { get; set; }
            = new List<Application>();
    }
}