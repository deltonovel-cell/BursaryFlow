USE BursaryFlowDB;
GO

/* =========================================================
   POPULATE BURSARY PROGRAMMES
   ========================================================= */

/* ---------------- NSFAS ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    FinancialNeedRequired,
    TuitionIncluded,
    BooksIncluded,
    AccommodationIncluded,
    LivingAllowanceIncluded,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'NSFAS Bursary',
    'Financial aid programme supporting qualifying students at public universities and TVET colleges in South Africa.',
    'Undergraduate',
    'Multiple eligible programmes',
    'South African citizens and qualifying applicants according to NSFAS rules.',
    'Eligible public universities and TVET colleges.',
    1,
    1,
    1,
    1,
    1,
    'https://www.nsfas.org.za/',
    'https://www.nsfas.org.za/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'National Student Financial Aid Scheme (NSFAS)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'NSFAS Bursary'
);


/* ---------------- FUNZA LUSHAKA ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    TuitionIncluded,
    BooksIncluded,
    AccommodationIncluded,
    LivingAllowanceIncluded,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'Funza Lushaka Bursary',
    'Government bursary supporting qualifying students studying towards teaching qualifications in priority subject areas.',
    'Undergraduate / Postgraduate',
    'Teaching and Education',
    'South African citizens meeting programme requirements.',
    'Approved higher education institutions.',
    1,
    1,
    1,
    1,
    'https://www.eservices.gov.za/FunzaLushaka/',
    'https://www.education.gov.za/Programmes/FunzaLushaka.aspx',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Funza Lushaka Bursary Programme'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Funza Lushaka Bursary'
);


/* ---------------- SASOL ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'Sasol Mainstream Bursary',
    'Sasol bursary programme supporting qualifying students studying selected disciplines relevant to the organisation.',
    'Undergraduate',
    'Engineering, Science, Technology and selected disciplines',
    'South African citizens meeting Sasol requirements.',
    'Recognised South African universities.',
    'https://www.sasolbursaries.com/',
    'https://www.sasolbursaries.com/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Sasol'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Sasol Mainstream Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'Sasol Foundation Bursary',
    'Sasol Foundation bursary supporting students in selected fields of study.',
    'Undergraduate',
    'STEM and selected disciplines',
    'South African citizens meeting programme requirements.',
    'Recognised South African universities.',
    'https://www.sasolbursaries.com/',
    'https://www.sasolbursaries.com/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Sasol'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Sasol Foundation Bursary'
);


/* ---------------- CSIR ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'CSIR Bursary',
    'CSIR bursary programme supporting students in priority science, engineering and technology fields.',
    'Undergraduate / Honours / Masters / Doctoral',
    'Science, Engineering and Technology',
    'South African citizens meeting CSIR requirements.',
    'Recognised South African universities.',
    'https://bursaryconnect.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Council for Scientific and Industrial Research (CSIR)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'CSIR Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'CSIR-Sasol Foundation Bursary',
    'Joint CSIR and Sasol Foundation programme supporting qualifying students in priority science, engineering and technology fields.',
    'Undergraduate / Honours / Masters / Doctoral',
    'Science, Engineering and Technology',
    'South African citizens meeting programme requirements.',
    'Recognised South African universities.',
    'https://bursaryconnect.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Council for Scientific and Industrial Research (CSIR)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'CSIR-Sasol Foundation Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'CSIR-DSTI Inter-Programme Bursary',
    'Research-focused bursary supporting postgraduate students in priority science, engineering and technology areas.',
    'Honours / Masters / Doctoral',
    'Science, Engineering and Technology',
    'South African citizens meeting programme requirements.',
    'Recognised South African universities.',
    'https://bursaryconnect.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Council for Scientific and Industrial Research (CSIR)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'CSIR-DSTI Inter-Programme Bursary'
);


/* ---------------- ESKOM ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'Eskom Bursary',
    'Eskom bursary programme supporting students in fields relevant to the energy and electricity sector.',
    'Undergraduate',
    'Engineering, Science, Technology and related fields',
    'South African citizens meeting Eskom requirements.',
    'Recognised South African universities.',
    'https://www.eskom.co.za/',
    'https://www.eskom.co.za/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Eskom'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Eskom Bursary'
);


/* ---------------- EXXARO ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'Exxaro Bursary',
    'Exxaro student bursary programme supporting qualifying students in selected disciplines.',
    'Undergraduate',
    'Engineering, Mining, Science, Technology and related fields',
    'South African citizens meeting programme requirements.',
    'Recognised South African universities.',
    'https://www.exxaro.com/careers/student-hub/',
    'https://www.exxaro.com/careers/student-hub/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Exxaro'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Exxaro Bursary'
);


/* ---------------- HARMONY ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'Harmony Gold Bursary',
    'Harmony Gold bursary programme supporting qualifying students in mining and related disciplines.',
    'Undergraduate',
    'Engineering, Mining, Geology, Finance and related fields',
    'South African citizens meeting Harmony requirements.',
    'Recognised South African universities.',
    'https://www.harmony.co.za/careers/opportunities-for-students/',
    'https://www.harmony.co.za/careers/opportunities-for-students/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Harmony Gold Mining Company'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Harmony Gold Bursary'
);


/* ---------------- NATIONAL TREASURY ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'National Treasury External Bursary',
    'National Treasury external bursary programme for qualifying university students.',
    'Undergraduate',
    'Selected fields specified by National Treasury',
    'South African citizens meeting National Treasury requirements.',
    'Recognised South African universities.',
    'https://www.treasury.gov.za/graduate/',
    'https://www.treasury.gov.za/graduate/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'National Treasury'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'National Treasury External Bursary'
);


/* ---------------- PIC ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'PIC Bursary',
    'Public Investment Corporation bursary supporting students in selected academic disciplines.',
    'Undergraduate',
    'Accounting, Actuarial Science, Computer Science, Finance, Information Technology, Statistics, Risk Management and related fields',
    'South African citizens meeting PIC requirements.',
    'Recognised South African universities.',
    'https://www.pic.gov.za/bursaries',
    'https://www.pic.gov.za/bursaries',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Public Investment Corporation (PIC)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'PIC Bursary'
);


/* ---------------- SARB ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'SARB External Bursary',
    'South African Reserve Bank external bursary programme supporting qualifying students.',
    'Undergraduate',
    'Economics, Finance, Statistics, Mathematics, Computer Science, Information Technology and related fields',
    'South African citizens meeting SARB requirements.',
    'Recognised South African universities.',
    'https://www.resbank.co.za/',
    'https://www.resbank.co.za/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'South African Reserve Bank (SARB)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'SARB External Bursary'
);


/* ---------------- DEPARTMENT OF TOURISM ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'Department of Tourism External Bursary',
    'Government external bursary supporting qualifying students in tourism and related fields.',
    'Undergraduate / Postgraduate',
    'Tourism, Hospitality and related fields',
    'South African citizens meeting programme requirements.',
    'Recognised South African institutions.',
    'https://www.tourism.gov.za/Careers/Pages/Bursaries.aspx',
    'https://www.tourism.gov.za/Careers/Pages/Bursaries.aspx',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'Department of Tourism'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Department of Tourism External Bursary'
);


/* ---------------- NDMC ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'NDMC Bursary',
    'National Disaster Management Centre bursary supporting students studying disaster management and fire-related qualifications.',
    'Undergraduate',
    'Disaster Management, Fire Technology and Fire Engineering',
    'South African citizens meeting NDMC requirements.',
    'Recognised South African institutions.',
    'https://onlinebursary.ndmc.gov.za/',
    'https://www.ndmc.gov.za/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'National Disaster Management Centre'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'NDMC Bursary'
);


/* ---------------- SANZAF ---------------- */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    FinancialNeedRequired,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    ProviderID,
    'SANZAF Education Bursary',
    'Educational funding programme supporting qualifying students experiencing financial need.',
    'Undergraduate',
    'Multiple fields subject to programme requirements',
    'South African applicants meeting SANZAF requirements.',
    'Recognised institutions.',
    1,
    'https://seed.sanzaf.org.za/',
    'https://www.sanzaf.org.za/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider
WHERE ProviderName = 'South African National Zakah Fund (SANZAF)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'SANZAF Education Bursary'
);

GO


USE BursaryFlowDB;
GO

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Bursary'
ORDER BY ORDINAL_POSITION;


IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Bursary_BursaryProvider'
)
BEGIN
    ALTER TABLE Bursary
    ADD CONSTRAINT FK_Bursary_BursaryProvider
    FOREIGN KEY (ProviderID)
    REFERENCES BursaryProvider(ProviderID);
END
GO



ALTER TABLE Bursary
ALTER COLUMN ProviderName NVARCHAR(255) NULL;
GO







USE BursaryFlowDB;
GO

/* =========================================================
   NSFAS
   ========================================================= */

INSERT INTO Bursary
(
    BursaryName,
    ProviderName,
    ProviderID,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    FinancialNeedRequired,
    TuitionIncluded,
    BooksIncluded,
    AccommodationIncluded,
    LivingAllowanceIncluded,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified,
    CreatedDate
)
SELECT
    'NSFAS Bursary',
    p.ProviderName,
    p.ProviderID,
    'Financial aid programme supporting qualifying students at public universities and TVET colleges in South Africa.',
    'Undergraduate',
    'Multiple eligible programmes',
    'South African citizens and qualifying applicants according to NSFAS rules.',
    'Eligible public universities and TVET colleges.',
    1,
    1,
    1,
    1,
    1,
    'https://www.nsfas.org.za/',
    'https://www.nsfas.org.za/',
    1,
    1,
    'Verified',
    GETDATE(),
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'National Student Financial Aid Scheme (NSFAS)'
AND NOT EXISTS
(
    SELECT 1
    FROM Bursary b
    WHERE b.BursaryName = 'NSFAS Bursary'
);


/* =========================================================
   FUNZA LUSHAKA
   ========================================================= */

INSERT INTO Bursary
(
    BursaryName,
    ProviderName,
    ProviderID,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    TuitionIncluded,
    BooksIncluded,
    AccommodationIncluded,
    LivingAllowanceIncluded,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified,
    CreatedDate
)
SELECT
    'Funza Lushaka Bursary',
    p.ProviderName,
    p.ProviderID,
    'Government bursary supporting qualifying students studying towards teaching qualifications in priority subject areas.',
    'Undergraduate / Postgraduate',
    'Teaching and Education',
    'South African citizens meeting programme requirements.',
    'Approved higher education institutions.',
    1,
    1,
    1,
    1,
    'https://www.eservices.gov.za/FunzaLushaka/',
    'https://www.education.gov.za/Programmes/FunzaLushaka.aspx',
    1,
    1,
    'Verified',
    GETDATE(),
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Funza Lushaka Bursary Programme'
AND NOT EXISTS
(
    SELECT 1
    FROM Bursary b
    WHERE b.BursaryName = 'Funza Lushaka Bursary'
);


/* =========================================================
   SASOL MAINSTREAM
   ========================================================= */

INSERT INTO Bursary
(
    BursaryName,
    ProviderName,
    ProviderID,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified,
    CreatedDate
)
SELECT
    'Sasol Mainstream Bursary',
    p.ProviderName,
    p.ProviderID,
    'Sasol bursary programme supporting qualifying students studying selected disciplines relevant to Sasol.',
    'Undergraduate',
    'Engineering, Science, Technology and selected disciplines',
    'South African citizens meeting Sasol requirements.',
    'Recognised South African universities.',
    'https://www.sasolbursaries.com/',
    'https://www.sasolbursaries.com/',
    1,
    1,
    'Verified',
    GETDATE(),
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Sasol'
AND NOT EXISTS
(
    SELECT 1
    FROM Bursary b
    WHERE b.BursaryName = 'Sasol Mainstream Bursary'
);


/* =========================================================
   SASOL FOUNDATION
   ========================================================= */

INSERT INTO Bursary
(
    BursaryName,
    ProviderName,
    ProviderID,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified,
    CreatedDate
)
SELECT
    'Sasol Foundation Bursary',
    p.ProviderName,
    p.ProviderID,
    'Sasol Foundation bursary supporting qualifying students in selected fields of study.',
    'Undergraduate',
    'STEM and selected disciplines',
    'South African citizens meeting programme requirements.',
    'Recognised South African universities.',
    'https://www.sasolbursaries.com/',
    'https://www.sasolbursaries.com/',
    1,
    1,
    'Verified',
    GETDATE(),
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Sasol'
AND NOT EXISTS
(
    SELECT 1
    FROM Bursary b
    WHERE b.BursaryName = 'Sasol Foundation Bursary'
);


/* =========================================================
   CSIR
   ========================================================= */

INSERT INTO Bursary
(
    BursaryName,
    ProviderName,
    ProviderID,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified,
    CreatedDate
)
SELECT
    'CSIR Bursary',
    p.ProviderName,
    p.ProviderID,
    'CSIR bursary programme supporting students in priority science, engineering and technology fields.',
    'Undergraduate / Honours / Masters / Doctoral',
    'Science, Engineering and Technology',
    'South African citizens meeting CSIR requirements.',
    'Recognised South African universities.',
    'https://bursaryconnect.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    1,
    1,
    'Verified',
    GETDATE(),
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Council for Scientific and Industrial Research (CSIR)'
AND NOT EXISTS
(
    SELECT 1
    FROM Bursary b
    WHERE b.BursaryName = 'CSIR Bursary'
);


/* =========================================================
   ESKOM
   ========================================================= */

INSERT INTO Bursary
(
    BursaryName,
    ProviderName,
    ProviderID,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified,
    CreatedDate
)
SELECT
    'Eskom Bursary',
    p.ProviderName,
    p.ProviderID,
    'Eskom bursary programme supporting students in fields relevant to the energy and electricity sector.',
    'Undergraduate',
    'Engineering, Science, Technology and related fields',
    'South African citizens meeting Eskom requirements.',
    'Recognised South African universities.',
    'https://www.eskom.co.za/',
    'https://www.eskom.co.za/',
    1,
    1,
    'Verified',
    GETDATE(),
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Eskom'
AND NOT EXISTS
(
    SELECT 1
    FROM Bursary b
    WHERE b.BursaryName = 'Eskom Bursary'
);


/* =========================================================
   EXXARO
   ========================================================= */

INSERT INTO Bursary
(
    BursaryName,
    ProviderName,
    ProviderID,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified,
    CreatedDate
)
SELECT
    'Exxaro Bursary',
    p.ProviderName,
    p.ProviderID,
    'Exxaro student bursary programme supporting qualifying students in selected disciplines.',
    'Undergraduate',
    'Engineering, Mining, Science, Technology and related fields',
    'South African citizens meeting programme requirements.',
    'Recognised South African universities.',
    'https://www.exxaro.com/careers/student-hub/',
    'https://www.exxaro.com/careers/student-hub/',
    1,
    1,
    'Verified',
    GETDATE(),
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Exxaro'
AND NOT EXISTS
(
    SELECT 1
    FROM Bursary b
    WHERE b.BursaryName = 'Exxaro Bursary'
);


/* =========================================================
   PIC
   ========================================================= */

INSERT INTO Bursary
(
    BursaryName,
    ProviderName,
    ProviderID,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    InstitutionRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified,
    CreatedDate
)
SELECT
    'PIC Bursary',
    p.ProviderName,
    p.ProviderID,
    'Public Investment Corporation bursary supporting students in selected academic disciplines.',
    'Undergraduate',
    'Accounting, Actuarial Science, Computer Science, Finance, Information Technology, Statistics, Risk Management and related fields',
    'South African citizens meeting PIC requirements.',
    'Recognised South African universities.',
    'https://www.pic.gov.za/bursaries',
    'https://www.pic.gov.za/bursaries',
    1,
    1,
    'Verified',
    GETDATE(),
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Public Investment Corporation (PIC)'
AND NOT EXISTS
(
    SELECT 1
    FROM Bursary b
    WHERE b.BursaryName = 'PIC Bursary'
);

GO