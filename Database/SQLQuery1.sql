USE BursaryFlowDB;
GO

/* =========================================================
   1. USERS
   ========================================================= */

CREATE TABLE AppUser
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,

    FirstName NVARCHAR(100) NOT NULL,

    LastName NVARCHAR(100) NOT NULL,

    Email NVARCHAR(255) NOT NULL UNIQUE,

    PasswordHash NVARCHAR(500) NOT NULL,

    PhoneNumber NVARCHAR(30),

    DateCreated DATETIME2 NOT NULL
        DEFAULT GETDATE(),

    IsVerified BIT NOT NULL
        DEFAULT 0,

    IsActive BIT NOT NULL
        DEFAULT 1
);
GO


/* =========================================================
   2. STUDENT PROFILE
   ========================================================= */

CREATE TABLE StudentProfile
(
    StudentProfileID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL UNIQUE,

    IDNumber NVARCHAR(50),

    DateOfBirth DATE,

    Gender NVARCHAR(50),

    Province NVARCHAR(100),

    City NVARCHAR(100),

    ResidentialAddress NVARCHAR(500),

    Citizenship NVARCHAR(100),

    FOREIGN KEY (UserID)
        REFERENCES AppUser(UserID)
        ON DELETE CASCADE
);
GO


/* =========================================================
   3. ACADEMIC PROFILE
   ========================================================= */

CREATE TABLE AcademicProfile
(
    AcademicProfileID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL UNIQUE,

    Institution NVARCHAR(255),

    StudentNumber NVARCHAR(100),

    Degree NVARCHAR(255),

    Faculty NVARCHAR(255),

    FieldOfStudy NVARCHAR(255),

    YearOfStudy INT,

    AverageMark DECIMAL(5,2),

    MatricAverage DECIMAL(5,2),

    ExpectedGraduationYear INT,

    FOREIGN KEY (UserID)
        REFERENCES AppUser(UserID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Academic_Year
        CHECK (YearOfStudy IS NULL OR YearOfStudy BETWEEN 1 AND 10),

    CONSTRAINT CK_Academic_Average
        CHECK (AverageMark IS NULL OR AverageMark BETWEEN 0 AND 100),

    CONSTRAINT CK_Matric_Average
        CHECK (MatricAverage IS NULL OR MatricAverage BETWEEN 0 AND 100)
);
GO


/* =========================================================
   4. FINANCIAL PROFILE
   ========================================================= */

CREATE TABLE FinancialProfile
(
    FinancialProfileID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL UNIQUE,

    HouseholdIncome DECIMAL(12,2),

    NumberOfDependants INT,

    ParentOrGuardianEmployed BIT,

    HasOtherFunding BIT,

    OtherFundingAmount DECIMAL(12,2),

    FinanciallyDependent BIT,

    FOREIGN KEY (UserID)
        REFERENCES AppUser(UserID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Financial_Dependants
        CHECK (
            NumberOfDependants IS NULL
            OR NumberOfDependants >= 0
        ),

    CONSTRAINT CK_Financial_Income
        CHECK (
            HouseholdIncome IS NULL
            OR HouseholdIncome >= 0
        )
);
GO


/* =========================================================
   5. DOCUMENTS
   ========================================================= */

CREATE TABLE Document
(
    DocumentID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    DocumentType NVARCHAR(100) NOT NULL,

    FileName NVARCHAR(255) NOT NULL,

    FilePath NVARCHAR(500),

    FileExtension NVARCHAR(20),

    FileSize BIGINT,

    UploadDate DATETIME2 NOT NULL
        DEFAULT GETDATE(),

    VerificationStatus NVARCHAR(50) NOT NULL
        DEFAULT 'Pending',

    IsRequired BIT NOT NULL
        DEFAULT 0,

    FOREIGN KEY (UserID)
        REFERENCES AppUser(UserID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Document_Status
        CHECK (
            VerificationStatus IN
            (
                'Pending',
                'Processing',
                'Verified',
                'Rejected',
                'NeedsReview'
            )
        )
);
GO


/* =========================================================
   6. DOCUMENT ANALYSIS
   ========================================================= */

CREATE TABLE DocumentAnalysis
(
    AnalysisID INT IDENTITY(1,1) PRIMARY KEY,

    DocumentID INT NOT NULL UNIQUE,

    QualityScore DECIMAL(5,2),

    IsBlurry BIT,

    IsReadable BIT,

    IsComplete BIT,

    OCRCompleted BIT,

    ExtractedText NVARCHAR(MAX),

    DetectedName NVARCHAR(255),

    DetectedIDNumber NVARCHAR(100),

    DetectedDateOfBirth DATE,

    HasTypographicalErrors BIT,

    HasInformationMismatch BIT,

    AnalysisMessage NVARCHAR(MAX),

    AnalysisDate DATETIME2
        DEFAULT GETDATE(),

    FOREIGN KEY (DocumentID)
        REFERENCES Document(DocumentID)
        ON DELETE CASCADE,

    CONSTRAINT CK_QualityScore
        CHECK (
            QualityScore IS NULL
            OR QualityScore BETWEEN 0 AND 100
        )
);
GO


/* =========================================================
   7. DOCUMENT ISSUES
   ========================================================= */

CREATE TABLE DocumentIssue
(
    IssueID INT IDENTITY(1,1) PRIMARY KEY,

    DocumentID INT NOT NULL,

    IssueType NVARCHAR(100) NOT NULL,

    FieldName NVARCHAR(100),

    DetectedValue NVARCHAR(500),

    ExpectedValue NVARCHAR(500),

    Description NVARCHAR(MAX),

    Severity NVARCHAR(50) NOT NULL
        DEFAULT 'Warning',

    IsResolved BIT NOT NULL
        DEFAULT 0,

    CreatedDate DATETIME2
        DEFAULT GETDATE(),

    FOREIGN KEY (DocumentID)
        REFERENCES Document(DocumentID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Issue_Severity
        CHECK (
            Severity IN
            (
                'Info',
                'Warning',
                'Critical'
            )
        )
);
GO


/* =========================================================
   8. BURSARIES
   ========================================================= */

CREATE TABLE Bursary
(
    BursaryID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryName NVARCHAR(255) NOT NULL,

    ProviderName NVARCHAR(255) NOT NULL,

    Description NVARCHAR(MAX),

    WebsiteURL NVARCHAR(500),

    ApplicationURL NVARCHAR(500),

    OpeningDate DATE,

    ClosingDate DATE,

    MinimumAverage DECIMAL(5,2),

    MaximumHouseholdIncome DECIMAL(12,2),

    MinimumYearOfStudy INT,

    MaximumYearOfStudy INT,

    IsActive BIT NOT NULL
        DEFAULT 1,

    DateAdded DATETIME2
        DEFAULT GETDATE(),

    CONSTRAINT CK_Bursary_Average
        CHECK (
            MinimumAverage IS NULL
            OR MinimumAverage BETWEEN 0 AND 100
        ),

    CONSTRAINT CK_Bursary_Income
        CHECK (
            MaximumHouseholdIncome IS NULL
            OR MaximumHouseholdIncome >= 0
        )
);
GO


/* =========================================================
   9. BURSARY COURSES
   ========================================================= */

CREATE TABLE BursaryCourse
(
    BursaryCourseID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryID INT NOT NULL,

    CourseName NVARCHAR(255) NOT NULL,

    FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID)
        ON DELETE CASCADE
);
GO


/* =========================================================
   10. BURSARY INSTITUTIONS
   ========================================================= */

CREATE TABLE BursaryInstitution
(
    BursaryInstitutionID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryID INT NOT NULL,

    InstitutionName NVARCHAR(255) NOT NULL,

    FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID)
        ON DELETE CASCADE
);
GO


/* =========================================================
   11. BURSARY REQUIREMENTS
   ========================================================= */

CREATE TABLE BursaryRequirement
(
    RequirementID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryID INT NOT NULL,

    RequirementName NVARCHAR(255) NOT NULL,

    RequirementDescription NVARCHAR(MAX),

    RequirementType NVARCHAR(100),

    IsMandatory BIT NOT NULL
        DEFAULT 1,

    FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID)
        ON DELETE CASCADE
);
GO


/* =========================================================
   12. BURSARY APPLICATIONS
   ========================================================= */

CREATE TABLE BursaryApplication
(
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    BursaryID INT NOT NULL,

    MatchScore DECIMAL(5,2),

    ApplicationStatus NVARCHAR(50) NOT NULL
        DEFAULT 'Draft',

    SubmittedDate DATETIME2,

    LastUpdated DATETIME2
        DEFAULT GETDATE(),

    ApplicationReference NVARCHAR(100),

    Notes NVARCHAR(MAX),

    FOREIGN KEY (UserID)
        REFERENCES AppUser(UserID),

    FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID),

    CONSTRAINT CK_Application_MatchScore
        CHECK (
            MatchScore IS NULL
            OR MatchScore BETWEEN 0 AND 100
        ),

    CONSTRAINT CK_Application_Status
        CHECK (
            ApplicationStatus IN
            (
                'Draft',
                'Ready',
                'Submitted',
                'UnderReview',
                'Approved',
                'Rejected',
                'Withdrawn'
            )
        )
);
GO


/* =========================================================
   13. APPLICATION DOCUMENTS
   ========================================================= */

CREATE TABLE ApplicationDocument
(
    ApplicationDocumentID INT IDENTITY(1,1) PRIMARY KEY,

    ApplicationID INT NOT NULL,

    DocumentID INT NOT NULL,

    IsAccepted BIT,

    IsRequired BIT NOT NULL
        DEFAULT 1,

    Notes NVARCHAR(MAX),

    FOREIGN KEY (ApplicationID)
        REFERENCES BursaryApplication(ApplicationID)
        ON DELETE CASCADE,

    FOREIGN KEY (DocumentID)
        REFERENCES Document(DocumentID)
);
GO


/* =========================================================
   14. APPLICATION HISTORY
   ========================================================= */

CREATE TABLE ApplicationHistory
(
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,

    ApplicationID INT NOT NULL,

    Status NVARCHAR(100) NOT NULL,

    Message NVARCHAR(MAX),

    CreatedDate DATETIME2
        DEFAULT GETDATE(),

    FOREIGN KEY (ApplicationID)
        REFERENCES BursaryApplication(ApplicationID)
        ON DELETE CASCADE
);
GO


/* =========================================================
   15. NOTIFICATIONS
   ========================================================= */

CREATE TABLE Notification
(
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,

    UserID INT NOT NULL,

    Title NVARCHAR(255) NOT NULL,

    Message NVARCHAR(MAX) NOT NULL,

    NotificationType NVARCHAR(100),

    IsRead BIT NOT NULL
        DEFAULT 0,

    CreatedDate DATETIME2
        DEFAULT GETDATE(),

    FOREIGN KEY (UserID)
        REFERENCES AppUser(UserID)
        ON DELETE CASCADE
);
GO


/* =========================================================
   16. BURSARY ELIGIBILITY RULES
   ========================================================= */

CREATE TABLE BursaryEligibilityRule
(
    RuleID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryID INT NOT NULL,

    RuleType NVARCHAR(100) NOT NULL,

    Operator NVARCHAR(20),

    RuleValue NVARCHAR(500),

    IsMandatory BIT NOT NULL
        DEFAULT 1,

    FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID)
        ON DELETE CASCADE
);
GO


/* =========================================================
   17. INDEXES
   ========================================================= */

CREATE INDEX IX_AppUser_Email
ON AppUser(Email);
GO

CREATE INDEX IX_Document_UserID
ON Document(UserID);
GO

CREATE INDEX IX_Document_Status
ON Document(VerificationStatus);
GO

CREATE INDEX IX_Bursary_ClosingDate
ON Bursary(ClosingDate);
GO

CREATE INDEX IX_BursaryApplication_UserID
ON BursaryApplication(UserID);
GO

CREATE INDEX IX_BursaryApplication_BursaryID
ON BursaryApplication(BursaryID);
GO

CREATE INDEX IX_Notification_UserID
ON Notification(UserID);
GO

