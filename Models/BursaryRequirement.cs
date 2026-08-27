namespace HouseServices.Models
{
    public class BursaryRequirement
    {
        public int RequirementID { get; set; }
        public int BursaryID { get; set; }

        public string RequirementType { get; set; } = "";
        public string RequirementName { get; set; } = "";

        public string? RequirementDescription { get; set; }
        public string? RequiredValue { get; set; }
        public string? ComparisonOperator { get; set; }

        public bool IsMandatory { get; set; }

        public DateTime CreatedDate { get; set; }

        public Bursary? Bursary { get; set; }

        public ICollection<RequirementOption> Options { get; set; }
            = new List<RequirementOption>();
    }
}