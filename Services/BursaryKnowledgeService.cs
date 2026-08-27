using HouseServices.Models;

namespace BursaryFlow.Services
{
    public class BursaryKnowledgeService
    {
        public List<Bursary> GetAll()
        {
            return new List<Bursary>
            {
                new Bursary
                {
                    BursaryID = 1,
                    ProviderID = 1,
                    BursaryName = "Tech Leaders Bursary",
                    Description = "Funding opportunity for Computer Science students.",
                    StudyFields = "Computer Science",
                    MinimumAverage = 70,
                    IsActive = true,
                    IsVerified = true,
                    VerificationStatus = "Verified"
                },

                new Bursary
                {
                    BursaryID = 2,
                    ProviderID = 2,
                    BursaryName = "Future Innovators Fund",
                    Description = "Funding opportunity for students pursuing technology and innovation.",
                    StudyFields = "Computer Science",
                    MinimumAverage = 65,
                    IsActive = true,
                    IsVerified = true,
                    VerificationStatus = "Verified"
                },

                new Bursary
                {
                    BursaryID = 3,
                    ProviderID = 3,
                    BursaryName = "Engineering Excellence",
                    Description = "Funding opportunity for Engineering students.",
                    StudyFields = "Engineering",
                    MinimumAverage = 75,
                    IsActive = true,
                    IsVerified = true,
                    VerificationStatus = "Verified"
                }
            };
        }
    }
}