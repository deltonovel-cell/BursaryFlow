namespace HouseServices.Models
{
    public class ApplicationStatusHistory
    {
        public int HistoryID { get; set; }

        public int ApplicationID { get; set; }

        public string? OldStatus { get; set; }
        public string NewStatus { get; set; } = "";

        public string? StatusMessage { get; set; }

        public DateTime ChangedDate { get; set; }

        public Application? Application { get; set; }
    }
}