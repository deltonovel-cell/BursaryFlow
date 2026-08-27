namespace HouseServices.Models
{
    public class BursaryDirectoryView
    {
        public int BursaryID { get; set; }

        public string BursaryName { get; set; } = string.Empty;

        public int ProviderID { get; set; }

        public string ProviderName { get; set; } = string.Empty;

        public string? ProviderType { get; set; }

        public string? Description { get; set; }

        public string? WebsiteURL { get; set; }

        public string? InformationURL { get; set; }

        public string? StudyLevel { get; set; }

        public string? StudyFields { get; set; }

        public decimal? MinimumAverage { get; set; }

        public decimal? MaximumHouseholdIncome { get; set; }

        public int? MinimumYearOfStudy { get; set; }

        public int? MaximumYearOfStudy { get; set; }

        public int? MinimumAge { get; set; }

        public int? MaximumAge { get; set; }

        public string? CitizenshipRequirement { get; set; }

        public string? InstitutionRequirement { get; set; }

        public bool FinancialNeedRequired { get; set; }

        public bool TuitionIncluded { get; set; }

        public bool BooksIncluded { get; set; }

        public bool AccommodationIncluded { get; set; }

        public bool AccommodationAllowanceIncluded { get; set; }

        public bool LivingAllowanceIncluded { get; set; }

        public bool TransportAllowanceIncluded { get; set; }

        public bool IsVerified { get; set; }

        public string VerificationStatus { get; set; } = string.Empty;

        public bool IsActive { get; set; }

        public int? CycleID { get; set; }

        public int? AcademicYear { get; set; }

        public string? CycleName { get; set; }

        public DateTime? OpeningDate { get; set; }

        public DateTime? ClosingDate { get; set; }

        public string? CycleApplicationURL { get; set; }

        public string? CycleStatus { get; set; }

        public bool? CycleIsVerified { get; set; }

        public DateTime? LastChecked { get; set; }

        public string? SourceURL { get; set; }

        public string? CurrentApplicationURL { get; set; }
    }
}
