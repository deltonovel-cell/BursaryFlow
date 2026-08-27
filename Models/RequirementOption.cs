namespace HouseServices.Models
{
    public class RequirementOption
    {
        public int OptionID { get; set; }
        public int RequirementID { get; set; }

        public string OptionValue { get; set; } = "";

        public BursaryRequirement? Requirement { get; set; }
    }
}