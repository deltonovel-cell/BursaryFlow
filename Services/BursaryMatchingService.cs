using BursaryFlow.Models;
using HouseServices.Models;

namespace BursaryFlow.Services
{
    public class BursaryMatchingService
    {
        public List<Bursary> MatchStudent(
            StudentProfile student,
            List<Bursary> bursaries)
        {
            if (student == null || bursaries == null)
            {
                return new List<Bursary>();
            }

            return bursaries
                .Where(b =>
                    b.IsActive &&

                    // ==========================================
                    // FIELD / COURSE MATCH
                    // ==========================================
                    (
                        string.IsNullOrWhiteSpace(b.StudyFields) ||
                        string.IsNullOrWhiteSpace(student.Course) ||
                        b.StudyFields.Contains(
                            student.Course,
                            StringComparison.OrdinalIgnoreCase)
                    )

                    &&

                    // ==========================================
                    // AVERAGE MARK
                    // ==========================================
                    (
                        !b.MinimumAverage.HasValue ||
                        (
                            student.AverageMark.HasValue &&
                            student.AverageMark.Value >= b.MinimumAverage.Value
                        )
                    )

                    &&

                    // ==========================================
                    // HOUSEHOLD INCOME
                    // ==========================================
                    (
                        !b.MaximumHouseholdIncome.HasValue ||
                        (
                            student.HouseholdIncome.HasValue &&
                            student.HouseholdIncome.Value <=
                            b.MaximumHouseholdIncome.Value
                        )
                    )

                    &&

                    // ==========================================
                    // YEAR OF STUDY
                    // ==========================================
                    (
                        !b.MinimumYearOfStudy.HasValue ||
                        (
                            student.YearOfStudy.HasValue &&
                            student.YearOfStudy.Value >=
                            b.MinimumYearOfStudy.Value
                        )
                    )

                    &&

                    (
                        !b.MaximumYearOfStudy.HasValue ||
                        (
                            student.YearOfStudy.HasValue &&
                            student.YearOfStudy.Value <=
                            b.MaximumYearOfStudy.Value
                        )
                    )

                    &&

                    // ==========================================
                    // INSTITUTION
                    // ==========================================
                    (
                        string.IsNullOrWhiteSpace(b.InstitutionRequirement) ||
                        string.IsNullOrWhiteSpace(student.Institution) ||
                        b.InstitutionRequirement.Contains(
                            student.Institution,
                            StringComparison.OrdinalIgnoreCase)
                    )
                )
                .ToList();
        }
    }
}