/* ============================================================
   BURSARYFLOW DATABASE
   COMPLETE DATABASE RESET + TABLES + DATA
   ============================================================ */

USE BursaryFlowDB;
GO


/* ============================================================
   PART 1
   REMOVE OLD OBJECTS
   ============================================================ */

IF OBJECT_ID('dbo.vw_BursaryDirectory', 'V') IS NOT NULL
    DROP VIEW dbo.vw_BursaryDirectory;
GO


/* Drop child tables first */

IF OBJECT_ID('dbo.ApplicationStatusHistory', 'U') IS NOT NULL
    DROP TABLE dbo.ApplicationStatusHistory;
GO

IF OBJECT_ID('dbo.ApplicationDocument', 'U') IS NOT NULL
    DROP TABLE dbo.ApplicationDocument;
GO

IF OBJECT_ID('dbo.Application', 'U') IS NOT NULL
    DROP TABLE dbo.Application;
GO

IF OBJECT_ID('dbo.StudentDocument', 'U') IS NOT NULL
    DROP TABLE dbo.StudentDocument;
GO

IF OBJECT_ID('dbo.StudentProfile', 'U') IS NOT NULL
    DROP TABLE dbo.StudentProfile;
GO

IF OBJECT_ID('dbo.BursaryDocumentRequirement', 'U') IS NOT NULL
    DROP TABLE dbo.BursaryDocumentRequirement;
GO

IF OBJECT_ID('dbo.DocumentType', 'U') IS NOT NULL
    DROP TABLE dbo.DocumentType;
GO

IF OBJECT_ID('dbo.RequirementOption', 'U') IS NOT NULL
    DROP TABLE dbo.RequirementOption;
GO

IF OBJECT_ID('dbo.BursaryRequirement', 'U') IS NOT NULL
    DROP TABLE dbo.BursaryRequirement;
GO

IF OBJECT_ID('dbo.BursaryCycle', 'U') IS NOT NULL
    DROP TABLE dbo.BursaryCycle;
GO

IF OBJECT_ID('dbo.Bursary', 'U') IS NOT NULL
    DROP TABLE dbo.Bursary;
GO

IF OBJECT_ID('dbo.BursaryProvider', 'U') IS NOT NULL
    DROP TABLE dbo.BursaryProvider;
GO


/* ============================================================
   PART 2
   BURSARY PROVIDER
   ============================================================ */

CREATE TABLE BursaryProvider
(
    ProviderID INT IDENTITY(1,1) PRIMARY KEY,

    ProviderName NVARCHAR(255) NOT NULL,

    ProviderType NVARCHAR(100) NULL,

    Description NVARCHAR(MAX) NULL,

    WebsiteURL NVARCHAR(1000) NULL,

    ApplicationPortalURL NVARCHAR(1000) NULL,

    ContactEmail NVARCHAR(255) NULL,

    ContactPhone NVARCHAR(50) NULL,

    IsOfficial BIT NOT NULL DEFAULT 1,

    IsActive BIT NOT NULL DEFAULT 1,

    LastVerified DATETIME2 NULL,

    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE()
);

GO


/* ============================================================
   PART 3
   BURSARY
   ============================================================ */

CREATE TABLE Bursary
(
    BursaryID INT IDENTITY(1,1) PRIMARY KEY,

    ProviderID INT NOT NULL,

    BursaryName NVARCHAR(255) NOT NULL,

    Description NVARCHAR(MAX) NULL,

    WebsiteURL NVARCHAR(1000) NULL,

    ApplicationURL NVARCHAR(1000) NULL,

    InformationURL NVARCHAR(1000) NULL,

    StudyLevel NVARCHAR(255) NULL,

    StudyFields NVARCHAR(MAX) NULL,

    MinimumAverage DECIMAL(5,2) NULL,

    MaximumHouseholdIncome DECIMAL(18,2) NULL,

    MinimumYearOfStudy INT NULL,

    MaximumYearOfStudy INT NULL,

    MinimumAge INT NULL,

    MaximumAge INT NULL,

    CitizenshipRequirement NVARCHAR(500) NULL,

    InstitutionRequirement NVARCHAR(MAX) NULL,

    FinancialNeedRequired BIT NOT NULL DEFAULT 0,

    TuitionIncluded BIT NOT NULL DEFAULT 0,

    BooksIncluded BIT NOT NULL DEFAULT 0,

    AccommodationIncluded BIT NOT NULL DEFAULT 0,

    AccommodationAllowanceIncluded BIT NOT NULL DEFAULT 0,

    LivingAllowanceIncluded BIT NOT NULL DEFAULT 0,

    TransportAllowanceIncluded BIT NOT NULL DEFAULT 0,

    IsVerified BIT NOT NULL DEFAULT 0,

    VerificationStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending',

    IsActive BIT NOT NULL DEFAULT 1,

    LastVerified DATETIME2 NULL,

    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Bursary_Provider
        FOREIGN KEY (ProviderID)
        REFERENCES BursaryProvider(ProviderID)
);

GO


/* ============================================================
   PART 4
   BURSARY CYCLE
   ============================================================ */

CREATE TABLE BursaryCycle
(
    CycleID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryID INT NOT NULL,

    AcademicYear INT NOT NULL,

    CycleName NVARCHAR(255) NULL,

    OpeningDate DATE NULL,

    ClosingDate DATE NULL,

    ApplicationURL NVARCHAR(1000) NULL,

    Status NVARCHAR(30) NOT NULL DEFAULT 'Unknown',

    IsVerified BIT NOT NULL DEFAULT 0,

    LastChecked DATETIME2 NULL,

    SourceURL NVARCHAR(1000) NULL,

    Notes NVARCHAR(MAX) NULL,

    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_BursaryCycle_Bursary
        FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID),

    CONSTRAINT UQ_BursaryCycle_Year
        UNIQUE (BursaryID, AcademicYear)
);

GO


/* ============================================================
   PART 5
   BURSARY REQUIREMENTS
   ============================================================ */

CREATE TABLE BursaryRequirement
(
    RequirementID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryID INT NOT NULL,

    RequirementType NVARCHAR(100) NOT NULL,

    RequirementName NVARCHAR(255) NOT NULL,

    RequirementDescription NVARCHAR(MAX) NULL,

    RequiredValue NVARCHAR(MAX) NULL,

    ComparisonOperator NVARCHAR(20) NULL,

    IsMandatory BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_BursaryRequirement_Bursary
        FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID)
);

GO


/* ============================================================
   PART 6
   REQUIREMENT OPTIONS
   ============================================================ */

CREATE TABLE RequirementOption
(
    OptionID INT IDENTITY(1,1) PRIMARY KEY,

    RequirementID INT NOT NULL,

    OptionValue NVARCHAR(500) NOT NULL,

    CONSTRAINT FK_RequirementOption_Requirement
        FOREIGN KEY (RequirementID)
        REFERENCES BursaryRequirement(RequirementID)
);

GO


/* ============================================================
   PART 7
   DOCUMENT TYPES
   ============================================================ */

CREATE TABLE DocumentType
(
    DocumentTypeID INT IDENTITY(1,1) PRIMARY KEY,

    DocumentName NVARCHAR(255) NOT NULL,

    Description NVARCHAR(MAX) NULL,

    IsCommonDocument BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE()
);

GO


/* ============================================================
   PART 8
   BURSARY DOCUMENT REQUIREMENTS
   ============================================================ */

CREATE TABLE BursaryDocumentRequirement
(
    BursaryDocumentRequirementID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryID INT NOT NULL,

    DocumentTypeID INT NOT NULL,

    IsMandatory BIT NOT NULL DEFAULT 1,

    AdditionalInstructions NVARCHAR(MAX) NULL,

    CONSTRAINT FK_BDR_Bursary
        FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID),

    CONSTRAINT FK_BDR_Document
        FOREIGN KEY (DocumentTypeID)
        REFERENCES DocumentType(DocumentTypeID),

    CONSTRAINT UQ_BursaryDocument
        UNIQUE (BursaryID, DocumentTypeID)
);

GO


/* ============================================================
   PART 9
   STUDENT PROFILE
   ============================================================ */

CREATE TABLE StudentProfile
(
    StudentID INT IDENTITY(1,1) PRIMARY KEY,

    FirstName NVARCHAR(100) NOT NULL,

    MiddleName NVARCHAR(100) NULL,

    LastName NVARCHAR(100) NOT NULL,

    Email NVARCHAR(255) NOT NULL,

    PhoneNumber NVARCHAR(30) NULL,

    IDNumber NVARCHAR(50) NULL,

    DateOfBirth DATE NULL,

    Citizenship NVARCHAR(100) NULL,

    Gender NVARCHAR(50) NULL,

    Province NVARCHAR(100) NULL,

    City NVARCHAR(100) NULL,

    Institution NVARCHAR(255) NULL,

    StudentNumber NVARCHAR(100) NULL,

    StudyLevel NVARCHAR(100) NULL,

    Course NVARCHAR(255) NULL,

    Faculty NVARCHAR(255) NULL,

    YearOfStudy INT NULL,

    AverageMark DECIMAL(5,2) NULL,

    HouseholdIncome DECIMAL(18,2) NULL,

    HasDisability BIT NOT NULL DEFAULT 0,

    IsFirstGenerationStudent BIT NOT NULL DEFAULT 0,

    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    UpdatedDate DATETIME2 NULL
);

GO


/* ============================================================
   PART 10
   STUDENT DOCUMENT
   ============================================================ */

CREATE TABLE StudentDocument
(
    StudentDocumentID INT IDENTITY(1,1) PRIMARY KEY,

    StudentID INT NOT NULL,

    DocumentTypeID INT NOT NULL,

    FileName NVARCHAR(255) NOT NULL,

    FilePath NVARCHAR(1000) NULL,

    FileType NVARCHAR(100) NULL,

    FileSize BIGINT NULL,

    UploadedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    VerificationStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending',

    IsReadable BIT NULL,

    IsLowQuality BIT NULL,

    ContainsPotentialTypos BIT NULL,

    HasMismatchingInformation BIT NULL,

    AIAnalysisNotes NVARCHAR(MAX) NULL,

    VerifiedDate DATETIME2 NULL,

    CONSTRAINT FK_StudentDocument_Student
        FOREIGN KEY (StudentID)
        REFERENCES StudentProfile(StudentID),

    CONSTRAINT FK_StudentDocument_Type
        FOREIGN KEY (DocumentTypeID)
        REFERENCES DocumentType(DocumentTypeID)
);

GO


/* ============================================================
   PART 11
   APPLICATION
   ============================================================ */

CREATE TABLE Application
(
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,

    StudentID INT NOT NULL,

    BursaryID INT NOT NULL,

    CycleID INT NULL,

    ApplicationDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    Status NVARCHAR(50) NOT NULL DEFAULT 'Draft',

    EligibilityScore DECIMAL(5,2) NULL,

    EligibilityStatus NVARCHAR(50) NULL,

    MissingDocumentsCount INT NOT NULL DEFAULT 0,

    MissingRequirementsCount INT NOT NULL DEFAULT 0,

    SubmittedDate DATETIME2 NULL,

    ExternalApplicationURL NVARCHAR(1000) NULL,

    ExternalReference NVARCHAR(255) NULL,

    Notes NVARCHAR(MAX) NULL,

    CONSTRAINT FK_Application_Student
        FOREIGN KEY (StudentID)
        REFERENCES StudentProfile(StudentID),

    CONSTRAINT FK_Application_Bursary
        FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID),

    CONSTRAINT FK_Application_Cycle
        FOREIGN KEY (CycleID)
        REFERENCES BursaryCycle(CycleID)
);

GO


/* ============================================================
   PART 12
   APPLICATION DOCUMENT
   ============================================================ */

CREATE TABLE ApplicationDocument
(
    ApplicationDocumentID INT IDENTITY(1,1) PRIMARY KEY,

    ApplicationID INT NOT NULL,

    StudentDocumentID INT NOT NULL,

    IsAccepted BIT NULL,

    ReviewNotes NVARCHAR(MAX) NULL,

    CONSTRAINT FK_ApplicationDocument_Application
        FOREIGN KEY (ApplicationID)
        REFERENCES Application(ApplicationID),

    CONSTRAINT FK_ApplicationDocument_Document
        FOREIGN KEY (StudentDocumentID)
        REFERENCES StudentDocument(StudentDocumentID)
);

GO


/* ============================================================
   PART 13
   APPLICATION STATUS HISTORY
   ============================================================ */

CREATE TABLE ApplicationStatusHistory
(
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,

    ApplicationID INT NOT NULL,

    OldStatus NVARCHAR(50) NULL,

    NewStatus NVARCHAR(50) NOT NULL,

    StatusMessage NVARCHAR(MAX) NULL,

    ChangedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_StatusHistory_Application
        FOREIGN KEY (ApplicationID)
        REFERENCES Application(ApplicationID)
);

GO


/* ============================================================
   PART 14
   INSERT PROVIDERS
   ============================================================ */

INSERT INTO BursaryProvider
(
    ProviderName,
    ProviderType,
    Description,
    WebsiteURL,
    ApplicationPortalURL,
    IsOfficial,
    IsActive,
    LastVerified
)
VALUES
(
    'National Student Financial Aid Scheme (NSFAS)',
    'Government',
    'South African government student financial aid organisation.',
    'https://www.nsfas.org.za/',
    'https://www.nsfas.org.za/',
    1,
    1,
    GETDATE()
),

(
    'Funza Lushaka Bursary Programme',
    'Government',
    'Government programme supporting qualifying students pursuing teaching qualifications.',
    'https://www.education.gov.za/',
    'https://www.education.gov.za/',
    1,
    1,
    GETDATE()
),

(
    'Sasol',
    'Corporate',
    'South African energy and chemicals company.',
    'https://www.sasol.com/',
    'https://www.sasol.com/',
    1,
    1,
    GETDATE()
),

(
    'Council for Scientific and Industrial Research (CSIR)',
    'Research Organisation',
    'South African scientific research and technology organisation.',
    'https://www.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    1,
    1,
    GETDATE()
),

(
    'Eskom',
    'State-Owned Company',
    'South African electricity utility.',
    'https://www.eskom.co.za/',
    'https://www.eskom.co.za/',
    1,
    1,
    GETDATE()
),

(
    'Exxaro',
    'Corporate',
    'South African resources company.',
    'https://www.exxaro.com/',
    'https://www.exxaro.com/',
    1,
    1,
    GETDATE()
),

(
    'Public Investment Corporation (PIC)',
    'State-Owned Company',
    'South African public investment manager.',
    'https://www.pic.gov.za/',
    'https://www.pic.gov.za/',
    1,
    1,
    GETDATE()
),

(
    'National Treasury',
    'Government',
    'South African National Treasury.',
    'https://www.treasury.gov.za/',
    'https://www.treasury.gov.za/',
    1,
    1,
    GETDATE()
),

(
    'South African Reserve Bank',
    'Financial Institution',
    'Central bank of South Africa.',
    'https://www.resbank.co.za/',
    'https://www.resbank.co.za/',
    1,
    1,
    GETDATE()
),

(
    'Department of Tourism',
    'Government',
    'South African government department responsible for tourism.',
    'https://www.tourism.gov.za/',
    'https://www.tourism.gov.za/',
    1,
    1,
    GETDATE()
),

(
    'Harmony Gold',
    'Corporate',
    'South African mining company.',
    'https://www.harmony.co.za/',
    'https://www.harmony.co.za/',
    1,
    1,
    GETDATE()
),

(
    'SANZAF',
    'Non-Profit Organisation',
    'South African educational support organisation.',
    'https://www.sanzaf.org.za/',
    'https://www.sanzaf.org.za/',
    1,
    1,
    GETDATE()
);

GO


/* ============================================================
   PART 15
   INSERT BURSARIES
   ============================================================ */


/* NSFAS */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    MaximumHouseholdIncome,
    CitizenshipRequirement,
    InstitutionRequirement,
    FinancialNeedRequired,
    TuitionIncluded,
    BooksIncluded,
    AccommodationIncluded,
    LivingAllowanceIncluded,
    TransportAllowanceIncluded,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'NSFAS Bursary',
    'Financial aid for qualifying students studying at eligible public universities and TVET colleges.',
    'https://www.nsfas.org.za/',
    'https://www.nsfas.org.za/',
    'https://www.nsfas.org.za/content/how-to-apply.html',
    'Undergraduate',
    'Multiple eligible programmes',
    350000,
    'South African citizens and qualifying permanent residents',
    'Eligible public universities and TVET colleges',
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName =
'National Student Financial Aid Scheme (NSFAS)';


/* Funza Lushaka */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'Funza Lushaka Bursary',
    'Government bursary programme supporting qualifying teaching students.',
    'https://www.education.gov.za/',
    'https://www.education.gov.za/',
    'https://www.education.gov.za/',
    'Undergraduate',
    'Teaching and Education',
    'South African',
    'Approved South African higher education institutions',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName =
'Funza Lushaka Bursary Programme';


/* Sasol */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'Sasol Bursary',
    'Sasol bursary opportunities for qualifying students in selected fields.',
    'https://www.sasol.com/',
    'https://www.sasol.com/',
    'https://www.sasol.com/',
    'Undergraduate',
    'Engineering, Science, Technology and selected fields',
    'South African',
    'Recognised South African institutions',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName = 'Sasol';


/* CSIR Main Bursary */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    TuitionIncluded,
    BooksIncluded,
    AccommodationIncluded,
    LivingAllowanceIncluded,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'CSIR Bursary Programme',
    'CSIR bursary programme supporting full-time students in priority science, engineering and technology fields.',
    'https://www.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    'Undergraduate / Honours / Masters / Doctoral',
    'Science, Engineering, Technology, Computer Science, Information Technology, Data Science and related fields',
    'South African',
    'South African public universities',
    1,
    1,
    1,
    1,
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName =
'Council for Scientific and Industrial Research (CSIR)';


/* CSIR-Sasol Foundation */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    TuitionIncluded,
    BooksIncluded,
    AccommodationIncluded,
    LivingAllowanceIncluded,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'CSIR-Sasol Foundation Bursary',
    'Bursary programme delivered by CSIR in collaboration with the Sasol Foundation.',
    'https://www.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries/sasol-foundation-bursary',
    'https://www.csir.co.za/careers/students-graduates/bursaries/sasol-foundation-bursary',
    'Undergraduate',
    'Science, Engineering, Technology, Computer Science, Information Technology and related fields',
    'South African',
    'South African public universities',
    1,
    1,
    1,
    1,
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName =
'Council for Scientific and Industrial Research (CSIR)';


/* Eskom */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'Eskom Bursary',
    'Eskom bursary programme for qualifying students.',
    'https://www.eskom.co.za/',
    'https://www.eskom.co.za/',
    'https://www.eskom.co.za/',
    'Undergraduate',
    'Engineering, Science, Technology and selected fields',
    'South African',
    'Recognised South African institutions',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName = 'Eskom';


/* Exxaro */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'Exxaro Bursary',
    'Exxaro bursary programme for qualifying students.',
    'https://www.exxaro.com/',
    'https://www.exxaro.com/',
    'https://www.exxaro.com/',
    'Undergraduate',
    'Engineering, Mining, Science and Technology',
    'South African',
    'Recognised South African institutions',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName = 'Exxaro';


/* PIC */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'PIC Bursary',
    'Public Investment Corporation bursary programme.',
    'https://www.pic.gov.za/',
    'https://www.pic.gov.za/',
    'https://www.pic.gov.za/',
    'Undergraduate',
    'Accounting, Actuarial Science, Computer Science, Finance, Information Technology, Statistics and related fields',
    'South African',
    'Recognised South African universities',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName =
'Public Investment Corporation (PIC)';


/* National Treasury */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'National Treasury Bursary',
    'National Treasury bursary opportunity for qualifying students.',
    'https://www.treasury.gov.za/',
    'https://www.treasury.gov.za/',
    'https://www.treasury.gov.za/',
    'Undergraduate',
    'Economics, Finance, Accounting, Statistics and related fields',
    'South African',
    'Recognised South African universities',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName = 'National Treasury';


/* SARB */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'South African Reserve Bank Bursary',
    'Student funding opportunity associated with the South African Reserve Bank.',
    'https://www.resbank.co.za/',
    'https://www.resbank.co.za/',
    'https://www.resbank.co.za/',
    'Undergraduate',
    'Economics, Finance, Statistics, Mathematics, Computer Science and related fields',
    'South African',
    'Recognised South African universities',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName =
'South African Reserve Bank';


/* Department of Tourism */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'Department of Tourism Bursary',
    'Government tourism-related bursary opportunity.',
    'https://www.tourism.gov.za/',
    'https://www.tourism.gov.za/',
    'https://www.tourism.gov.za/',
    'Undergraduate',
    'Tourism and Hospitality',
    'South African',
    'Recognised South African institutions',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName = 'Department of Tourism';


/* Harmony */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'Harmony Gold Bursary',
    'Harmony Gold bursary opportunity for qualifying students.',
    'https://www.harmony.co.za/',
    'https://www.harmony.co.za/',
    'https://www.harmony.co.za/',
    'Undergraduate',
    'Engineering, Mining, Geology and related fields',
    'South African',
    'Recognised South African institutions',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName = 'Harmony Gold';


/* SANZAF */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    WebsiteURL,
    ApplicationURL,
    InformationURL,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    IsVerified,
    VerificationStatus
)
SELECT
    ProviderID,
    'SANZAF Education Bursary',
    'Educational assistance programme.',
    'https://www.sanzaf.org.za/',
    'https://www.sanzaf.org.za/',
    'https://www.sanzaf.org.za/',
    'Undergraduate',
    'Multiple fields',
    'South African',
    'Recognised institutions',
    1,
    'Verified'
FROM BursaryProvider
WHERE ProviderName = 'SANZAF';

GO


/* ============================================================
   PART 16
   DOCUMENT TYPES
   ============================================================ */

INSERT INTO DocumentType
(
    DocumentName,
    Description
)
VALUES
(
    'South African ID',
    'Applicant South African identity document.'
),
(
    'Birth Certificate',
    'Official birth certificate.'
),
(
    'Matric Certificate',
    'National Senior Certificate or equivalent.'
),
(
    'Academic Transcript',
    'Latest academic record or transcript.'
),
(
    'Proof of Registration',
    'Current university or college registration document.'
),
(
    'Proof of Household Income',
    'Documentation showing household income.'
),
(
    'Parent or Guardian ID',
    'Identity document of parent or guardian.'
),
(
    'Proof of Residence',
    'Recent proof of residential address.'
),
(
    'Bank Statement',
    'Recent bank statement where required.'
),
(
    'Disability Documentation',
    'Supporting disability documentation where applicable.'
),
(
    'Motivation Letter',
    'Applicant motivation letter.'
),
(
    'CV',
    'Applicant curriculum vitae.'
),
(
    'Proof of Admission',
    'Official admission or acceptance letter.'
),
(
    'Proof of Unemployment',
    'Supporting documentation where required.'
);

GO


/* ============================================================
   PART 17
   BURSARY CYCLES
   ============================================================ */

/*
   We deliberately do NOT invent opening/closing dates.
   These will later be populated by the automatic
   bursary monitoring service.
*/

INSERT INTO BursaryCycle
(
    BursaryID,
    AcademicYear,
    CycleName,
    Status,
    IsVerified,
    LastChecked,
    SourceURL,
    Notes
)
SELECT
    BursaryID,
    2026,
    BursaryName + ' - 2026',
    'Unknown',
    0,
    GETDATE(),
    COALESCE(ApplicationURL, WebsiteURL),
    'Initial cycle record. Opening and closing dates require verification from the official provider.'
FROM Bursary;

GO


/* ============================================================
   PART 18
   COMMON DOCUMENT REQUIREMENTS
   ============================================================ */

INSERT INTO BursaryDocumentRequirement
(
    BursaryID,
    DocumentTypeID,
    IsMandatory
)
SELECT
    B.BursaryID,
    D.DocumentTypeID,
    1
FROM Bursary B
CROSS JOIN DocumentType D
WHERE D.DocumentName IN
(
    'South African ID',
    'Academic Transcript',
    'Proof of Registration'
);

GO


/* ============================================================
   PART 19
   REQUIREMENTS
   ============================================================ */


/* South African citizenship */

INSERT INTO BursaryRequirement
(
    BursaryID,
    RequirementType,
    RequirementName,
    RequirementDescription,
    RequiredValue,
    ComparisonOperator,
    IsMandatory
)
SELECT
    BursaryID,
    'Citizenship',
    'South African Citizenship',
    'Applicant must satisfy the citizenship requirement specified by the provider.',
    'South African',
    '=',
    1
FROM Bursary
WHERE CitizenshipRequirement LIKE '%South African%';

GO


/* ============================================================
   PART 20
   INDEXES
   ============================================================ */

CREATE INDEX IX_Bursary_ProviderID
ON Bursary(ProviderID);

CREATE INDEX IX_Bursary_BursaryName
ON Bursary(BursaryName);

CREATE INDEX IX_Bursary_Active
ON Bursary(IsActive);

CREATE INDEX IX_BursaryCycle_BursaryID
ON BursaryCycle(BursaryID);

CREATE INDEX IX_BursaryCycle_Status
ON BursaryCycle(Status);

CREATE INDEX IX_BursaryCycle_ClosingDate
ON BursaryCycle(ClosingDate);

CREATE INDEX IX_BursaryRequirement_BursaryID
ON BursaryRequirement(BursaryID);

CREATE INDEX IX_BursaryDocumentRequirement_BursaryID
ON BursaryDocumentRequirement(BursaryID);

CREATE INDEX IX_StudentDocument_StudentID
ON StudentDocument(StudentID);

CREATE INDEX IX_StudentDocument_VerificationStatus
ON StudentDocument(VerificationStatus);

CREATE INDEX IX_Application_StudentID
ON Application(StudentID);

CREATE INDEX IX_Application_BursaryID
ON Application(BursaryID);

CREATE INDEX IX_Application_Status
ON Application(Status);

GO


/* ============================================================
   PART 21
   BURSARY DIRECTORY VIEW
   ============================================================ */

CREATE VIEW vw_BursaryDirectory
AS
SELECT

    B.BursaryID,

    B.BursaryName,

    P.ProviderID,

    P.ProviderName,

    P.ProviderType,

    B.Description,

    B.WebsiteURL,

    B.InformationURL,

    B.StudyLevel,

    B.StudyFields,

    B.MinimumAverage,

    B.MaximumHouseholdIncome,

    B.MinimumYearOfStudy,

    B.MaximumYearOfStudy,

    B.MinimumAge,

    B.MaximumAge,

    B.CitizenshipRequirement,

    B.InstitutionRequirement,

    B.FinancialNeedRequired,

    B.TuitionIncluded,

    B.BooksIncluded,

    B.AccommodationIncluded,

    B.AccommodationAllowanceIncluded,

    B.LivingAllowanceIncluded,

    B.TransportAllowanceIncluded,

    B.IsVerified,

    B.VerificationStatus,

    B.IsActive,

    C.CycleID,

    C.AcademicYear,

    C.CycleName,

    C.OpeningDate,

    C.ClosingDate,

    C.ApplicationURL AS CycleApplicationURL,

    C.Status AS CycleStatus,

    C.IsVerified AS CycleIsVerified,

    C.LastChecked,

    C.SourceURL,

    CASE
        WHEN C.ApplicationURL IS NOT NULL
            THEN C.ApplicationURL
        ELSE B.ApplicationURL
    END AS CurrentApplicationURL

FROM Bursary B

INNER JOIN BursaryProvider P
    ON B.ProviderID = P.ProviderID

LEFT JOIN BursaryCycle C
    ON B.BursaryID = C.BursaryID;

GO


/* ============================================================
   PART 22
   FINAL COUNTS
   ============================================================ */

SELECT
    'BursaryProvider' AS TableName,
    COUNT(*) AS TotalRecords
FROM BursaryProvider

UNION ALL

SELECT
    'Bursary',
    COUNT(*)
FROM Bursary

UNION ALL

SELECT
    'BursaryCycle',
    COUNT(*)
FROM BursaryCycle

UNION ALL

SELECT
    'BursaryRequirement',
    COUNT(*)
FROM BursaryRequirement

UNION ALL

SELECT
    'DocumentType',
    COUNT(*)
FROM DocumentType

UNION ALL

SELECT
    'BursaryDocumentRequirement',
    COUNT(*)
FROM BursaryDocumentRequirement;

GO


/* ============================================================
   PART 23
   SHOW PROVIDERS
   ============================================================ */

SELECT
    ProviderID,
    ProviderName,
    ProviderType,
    WebsiteURL,
    IsOfficial,
    IsActive
FROM BursaryProvider
ORDER BY ProviderName;

GO


/* ============================================================
   PART 24
   SHOW BURSARIES
   ============================================================ */

SELECT
    B.BursaryID,
    P.ProviderName,
    B.BursaryName,
    B.StudyLevel,
    B.StudyFields,
    B.VerificationStatus,
    B.IsActive
FROM Bursary B
INNER JOIN BursaryProvider P
    ON B.ProviderID = P.ProviderID
ORDER BY
    P.ProviderName,
    B.BursaryName;

GO


/* ============================================================
   PART 25
   SHOW BURSARY CYCLES
   ============================================================ */

SELECT
    C.CycleID,
    B.BursaryName,
    P.ProviderName,
    C.AcademicYear,
    C.Status,
    C.OpeningDate,
    C.ClosingDate,
    C.IsVerified,
    C.LastChecked
FROM BursaryCycle C
INNER JOIN Bursary B
    ON C.BursaryID = B.BursaryID
INNER JOIN BursaryProvider P
    ON B.ProviderID = P.ProviderID
ORDER BY
    P.ProviderName,
    B.BursaryName;

GO


/* ============================================================
   COMPLETE
   ============================================================ */

PRINT '================================================';
PRINT ' BURSARYFLOW DATABASE CREATED SUCCESSFULLY';
PRINT '================================================';
PRINT 'Tables, relationships, providers, bursaries,';
PRINT 'document types, requirements, cycles, indexes';
PRINT 'and bursary directory view have been created.';
PRINT '================================================';

GO