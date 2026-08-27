namespace HouseServices.Models
{
    public class DocumentType
    {
        public int DocumentTypeID { get; set; }

        public string DocumentName { get; set; } = "";
        public string? Description { get; set; }

        public bool IsCommonDocument { get; set; }

        public DateTime CreatedDate { get; set; }

        public ICollection<StudentDocument> StudentDocuments { get; set; }
            = new List<StudentDocument>();

        public ICollection<BursaryDocumentRequirement> BursaryRequirements { get; set; }
            = new List<BursaryDocumentRequirement>();
    }
}