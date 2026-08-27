using HouseServices.Models;
using Microsoft.EntityFrameworkCore;

namespace HouseServices.Data
{
    public class BursaryFlowDbContext : DbContext
    {
        public BursaryFlowDbContext(
            DbContextOptions<BursaryFlowDbContext> options)
            : base(options)
        {
        }

        // =====================================================
        // TABLES
        // =====================================================

        public DbSet<Application> Applications { get; set; }

        public DbSet<ApplicationDocument> ApplicationDocuments { get; set; }

        public DbSet<ApplicationStatusHistory> ApplicationStatusHistories { get; set; }

        public DbSet<Bursary> Bursaries { get; set; }

        public DbSet<BursaryCycle> BursaryCycles { get; set; }

        public DbSet<BursaryDocumentRequirement> BursaryDocumentRequirements { get; set; }

        public DbSet<BursaryProvider> BursaryProviders { get; set; }

        public DbSet<BursaryRequirement> BursaryRequirements { get; set; }

        public DbSet<DocumentType> DocumentTypes { get; set; }

        public DbSet<RequirementOption> RequirementOptions { get; set; }

        public DbSet<StudentDocument> StudentDocuments { get; set; }

        public DbSet<StudentProfile> StudentProfiles { get; set; }

        public DbSet<BursaryDirectoryView> BursaryDirectory { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);


            // =====================================================
            // PRIMARY KEYS
            // =====================================================

            modelBuilder.Entity<Application>()
                .HasKey(x => x.ApplicationID);

            modelBuilder.Entity<ApplicationDocument>()
                .HasKey(x => x.ApplicationDocumentID);

            modelBuilder.Entity<ApplicationStatusHistory>()
                .HasKey(x => x.HistoryID);

            modelBuilder.Entity<Bursary>()
                .HasKey(x => x.BursaryID);

            modelBuilder.Entity<BursaryCycle>()
                .HasKey(x => x.CycleID);

            modelBuilder.Entity<BursaryDocumentRequirement>()
                .HasKey(x => x.BursaryDocumentRequirementID);

            modelBuilder.Entity<BursaryProvider>()
                .HasKey(x => x.ProviderID);

            modelBuilder.Entity<BursaryRequirement>()
                .HasKey(x => x.RequirementID);

            modelBuilder.Entity<DocumentType>()
                .HasKey(x => x.DocumentTypeID);

            modelBuilder.Entity<RequirementOption>()
                .HasKey(x => x.OptionID);

            modelBuilder.Entity<StudentDocument>()
                .HasKey(x => x.StudentDocumentID);

            modelBuilder.Entity<StudentProfile>()
                .HasKey(x => x.StudentID);


            // =====================================================
            // TABLE NAMES
            // =====================================================

            modelBuilder.Entity<Application>()
                .ToTable("Application");

            modelBuilder.Entity<ApplicationDocument>()
                .ToTable("ApplicationDocument");

            modelBuilder.Entity<ApplicationStatusHistory>()
                .ToTable("ApplicationStatusHistory");

            modelBuilder.Entity<Bursary>()
                .ToTable("Bursary");

            modelBuilder.Entity<BursaryCycle>()
                .ToTable("BursaryCycle");

            modelBuilder.Entity<BursaryDocumentRequirement>()
                .ToTable("BursaryDocumentRequirement");

            modelBuilder.Entity<BursaryProvider>()
                .ToTable("BursaryProvider");

            modelBuilder.Entity<BursaryRequirement>()
                .ToTable("BursaryRequirement");

            modelBuilder.Entity<DocumentType>()
                .ToTable("DocumentType");

            modelBuilder.Entity<RequirementOption>()
                .ToTable("RequirementOption");

            modelBuilder.Entity<StudentDocument>()
                .ToTable("StudentDocument");

            modelBuilder.Entity<StudentProfile>()
                .ToTable("StudentProfile");


            // =====================================================
            // BURSARY → PROVIDER
            // =====================================================

            modelBuilder.Entity<Bursary>()
                .HasOne(b => b.Provider)
                .WithMany(p => p.Bursaries)
                .HasForeignKey(b => b.ProviderID)
                .HasPrincipalKey(p => p.ProviderID)
                .OnDelete(DeleteBehavior.Restrict);


            // =====================================================
            // BURSARY → CYCLES
            // =====================================================

            modelBuilder.Entity<BursaryCycle>()
                .HasOne<Bursary>()
                .WithMany()
                .HasForeignKey(x => x.BursaryID)
                .OnDelete(DeleteBehavior.Cascade);


            // =====================================================
            // BURSARY → REQUIREMENTS
            // =====================================================

            modelBuilder.Entity<BursaryRequirement>()
                .HasOne<Bursary>()
                .WithMany()
                .HasForeignKey(x => x.BursaryID)
                .OnDelete(DeleteBehavior.Cascade);


            // =====================================================
            // REQUIREMENT → OPTIONS
            // =====================================================

            modelBuilder.Entity<RequirementOption>()
                .HasOne<BursaryRequirement>()
                .WithMany()
                .HasForeignKey(x => x.RequirementID)
                .OnDelete(DeleteBehavior.Cascade);


            // =====================================================
            // STUDENT DOCUMENT → DOCUMENT TYPE
            // =====================================================

            modelBuilder.Entity<StudentDocument>()
                .HasOne<DocumentType>()
                .WithMany()
                .HasForeignKey(x => x.DocumentTypeID)
                .OnDelete(DeleteBehavior.Restrict);


            // =====================================================
            // BURSARY DOCUMENT REQUIREMENT → DOCUMENT TYPE
            // =====================================================

            modelBuilder.Entity<BursaryDocumentRequirement>()
                .HasOne<DocumentType>()
                .WithMany()
                .HasForeignKey(x => x.DocumentTypeID)
                .OnDelete(DeleteBehavior.Restrict);


            // =====================================================
            // BURSARY DOCUMENT REQUIREMENT → BURSARY
            // =====================================================

            modelBuilder.Entity<BursaryDocumentRequirement>()
                .HasOne<Bursary>()
                .WithMany()
                .HasForeignKey(x => x.BursaryID)
                .OnDelete(DeleteBehavior.Cascade);


            // =====================================================
            // APPLICATION → STUDENT
            // =====================================================

            modelBuilder.Entity<Application>()
                .HasOne<StudentProfile>()
                .WithMany()
                .HasForeignKey(x => x.StudentID)
                .OnDelete(DeleteBehavior.Restrict);


            // =====================================================
            // APPLICATION → BURSARY
            // =====================================================

            modelBuilder.Entity<Application>()
                .HasOne<Bursary>()
                .WithMany()
                .HasForeignKey(x => x.BursaryID)
                .OnDelete(DeleteBehavior.Restrict);


            // =====================================================
            // APPLICATION → BURSARY CYCLE
            // =====================================================

            modelBuilder.Entity<Application>()
                .HasOne<BursaryCycle>()
                .WithMany()
                .HasForeignKey(x => x.CycleID)
                .OnDelete(DeleteBehavior.Restrict);


            // =====================================================
            // APPLICATION DOCUMENT → APPLICATION
            // =====================================================

            modelBuilder.Entity<ApplicationDocument>()
                .HasOne<Application>()
                .WithMany()
                .HasForeignKey(x => x.ApplicationID)
                .OnDelete(DeleteBehavior.Cascade);


            // =====================================================
            // APPLICATION DOCUMENT → STUDENT DOCUMENT
            // =====================================================

            modelBuilder.Entity<ApplicationDocument>()
                .HasOne<StudentDocument>()
                .WithMany()
                .HasForeignKey(x => x.StudentDocumentID)
                .OnDelete(DeleteBehavior.Restrict);


            // =====================================================
            // APPLICATION STATUS HISTORY → APPLICATION
            // =====================================================

            modelBuilder.Entity<ApplicationStatusHistory>()
                .HasOne<Application>()
                .WithMany()
                .HasForeignKey(x => x.ApplicationID)
                .OnDelete(DeleteBehavior.Cascade);


            // =====================================================
            // DECIMAL PRECISION
            // =====================================================

            modelBuilder.Entity<Bursary>()
                .Property(x => x.MinimumAverage)
                .HasPrecision(5, 2);

            modelBuilder.Entity<Bursary>()
                .Property(x => x.MaximumHouseholdIncome)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Application>()
                .Property(x => x.EligibilityScore)
                .HasPrecision(5, 2);

            modelBuilder.Entity<StudentProfile>()
                .Property(x => x.AverageMark)
                .HasPrecision(5, 2);

            modelBuilder.Entity<StudentProfile>()
                .Property(x => x.HouseholdIncome)
                .HasPrecision(18, 2);


            // =====================================================
            // BURSARY DEFAULTS
            // =====================================================

            modelBuilder.Entity<Bursary>()
                .Property(x => x.IsVerified)
                .HasDefaultValue(false);

            modelBuilder.Entity<Bursary>()
                .Property(x => x.IsActive)
                .HasDefaultValue(true);

            modelBuilder.Entity<Bursary>()
                .Property(x => x.VerificationStatus)
                .HasDefaultValue("Pending");

            modelBuilder.Entity<Bursary>()
                .Property(x => x.CreatedDate)
                .HasDefaultValueSql("GETDATE()");


            // =====================================================
            // PROVIDER DEFAULTS
            // =====================================================

            modelBuilder.Entity<BursaryProvider>()
                .Property(x => x.IsOfficial)
                .HasDefaultValue(false);

            modelBuilder.Entity<BursaryProvider>()
                .Property(x => x.IsActive)
                .HasDefaultValue(true);

            modelBuilder.Entity<BursaryProvider>()
                .Property(x => x.CreatedDate)
                .HasDefaultValueSql("GETDATE()");


            // =====================================================
            // CYCLE DEFAULTS
            // =====================================================

            modelBuilder.Entity<BursaryCycle>()
                .Property(x => x.IsVerified)
                .HasDefaultValue(false);

            modelBuilder.Entity<BursaryCycle>()
                .Property(x => x.Status)
                .HasDefaultValue("Unknown");

            modelBuilder.Entity<BursaryCycle>()
                .Property(x => x.CreatedDate)
                .HasDefaultValueSql("GETDATE()");


            // =====================================================
            // STUDENT DEFAULTS
            // =====================================================

            modelBuilder.Entity<StudentProfile>()
                .Property(x => x.HasDisability)
                .HasDefaultValue(false);

            modelBuilder.Entity<StudentProfile>()
                .Property(x => x.IsFirstGenerationStudent)
                .HasDefaultValue(false);

            modelBuilder.Entity<StudentProfile>()
                .Property(x => x.CreatedDate)
                .HasDefaultValueSql("GETDATE()");


            // =====================================================
            // STUDENT DOCUMENT DEFAULTS
            // =====================================================

            modelBuilder.Entity<StudentDocument>()
                .Property(x => x.VerificationStatus)
                .HasDefaultValue("Pending");

            modelBuilder.Entity<StudentDocument>()
                .Property(x => x.UploadedDate)
                .HasDefaultValueSql("GETDATE()");


            // =====================================================
            // APPLICATION DEFAULTS
            // =====================================================

            modelBuilder.Entity<Application>()
                .Property(x => x.Status)
                .HasDefaultValue("Draft");

            modelBuilder.Entity<Application>()
                .Property(x => x.MissingDocumentsCount)
                .HasDefaultValue(0);

            modelBuilder.Entity<Application>()
                .Property(x => x.MissingRequirementsCount)
                .HasDefaultValue(0);

            modelBuilder.Entity<Application>()
                .Property(x => x.ApplicationDate)
                .HasDefaultValueSql("GETDATE()");


            // =====================================================
            // STATUS HISTORY DEFAULTS
            // =====================================================

            modelBuilder.Entity<ApplicationStatusHistory>()
                .Property(x => x.ChangedDate)
                .HasDefaultValueSql("GETDATE()");


            // =====================================================
            // BURSARY DIRECTORY VIEW
            // =====================================================

            modelBuilder.Entity<BursaryDirectoryView>()
                .HasNoKey()
                .ToView("vw_BursaryDirectory");
        }
    }
}