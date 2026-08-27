using System.Xml.Linq;

namespace HouseServices.Models
{
    public class StudentDocument
    {
        public int StudentDocumentID { get; set; }

        public int StudentID { get; set; }
        public int DocumentTypeID { get; set; }

        public string FileName { get; set; } = "";
        public string? FilePath { get; set; }
        public string? FileType { get; set; }
        public long? FileSize { get; set; }

        public DateTime UploadedDate { get; set; }

        public string VerificationStatus { get; set; } = "";

        public bool? IsReadable { get; set; }
        public bool? IsLowQuality { get; set; }
        public bool? ContainsPotentialTypos { get; set; }
        public bool? HasMismatchingInformation { get; set; }

        public string? AIAnalysisNotes { get; set; }

        public DateTime? VerifiedDate { get; set; }

        public StudentProfile? Student { get; set; }
        public DocumentType? DocumentType { get; set; }

        public ICollection<ApplicationDocument> ApplicationDocuments { get; set; }
            = new List<ApplicationDocument>();
    }
}