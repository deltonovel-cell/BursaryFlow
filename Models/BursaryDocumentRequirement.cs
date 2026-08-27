using System.Xml.Linq;

namespace HouseServices.Models
{
    public class BursaryDocumentRequirement
    {
        public int BursaryDocumentRequirementID { get; set; }

        public int BursaryID { get; set; }
        public int DocumentTypeID { get; set; }

        public bool IsMandatory { get; set; }

        public string? AdditionalInstructions { get; set; }

        public Bursary? Bursary { get; set; }
        public DocumentType? DocumentType { get; set; }
    }
}