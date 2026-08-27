namespace HouseServices.Models
{
    public class ApplicationDocument
    {
        public int ApplicationDocumentID { get; set; }

        public int ApplicationID { get; set; }
        public int StudentDocumentID { get; set; }

        public bool? IsAccepted { get; set; }

        public string? ReviewNotes { get; set; }

        public Application? Application { get; set; }
        public StudentDocument? StudentDocument { get; set; }
    }
}