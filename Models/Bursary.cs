using System;

namespace HouseServices.Models
{
    public class Bursary
    {
        public int BursaryID { get; set; }

        public int ProviderID { get; set; }

        public string BursaryName { get; set; } = string.Empty;

        public string? Description { get; set; }

        public string? WebsiteURL { get; set; }

        public string? ApplicationURL { get; set; }

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

        public DateTime? LastVerified { get; set; }

        public DateTime CreatedDate { get; set; }

        // Navigation property
        public BursaryProvider? Provider { get; set; }
    }
}