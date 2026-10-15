USE BursaryFlowDB;
GO

/* =========================================================
   REAL BURSARY PROGRAMMES
   ProviderID is resolved by ProviderName so this does not
   depend on the IDs being exactly 1,2,3...
   ========================================================= */

INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    MinimumAverage,
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
    p.ProviderID,
    'NSFAS Bursary',
    'Government-funded financial aid for qualifying students studying at eligible public universities and TVET colleges in South Africa.',
    'Undergraduate',
    'Multiple eligible programmes',
    NULL,
    'South African citizens and qualifying persons according to NSFAS rules.',
    'Eligible public universities and TVET colleges.',
    NULL,
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
FROM BursaryProvider p
WHERE p.ProviderName = 'National Student Financial Aid Scheme (NSFAS)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'NSFAS Bursary'
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
    p.ProviderID,
    'Funza Lushaka Bursary',
    'Government bursary supporting qualifying students studying towards teaching qualifications in priority subject areas.',
    'Undergraduate / Postgraduate',
    'Teaching / Education',
    'South African citizens who meet the programme requirements.',
    'Eligible South African higher education institutions.',
    'https://www.eservices.gov.za/FunzaLushaka/',
    'https://www.education.gov.za/Programmes/FunzaLushaka.aspx',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Funza Lushaka Bursary Programme'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Funza Lushaka Bursary'
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
    p.ProviderID,
    'Sasol Mainstream Bursary',
    'Sasol bursary programme supporting qualifying students studying selected disciplines relevant to Sasol.',
    'Undergraduate',
    'Engineering, Science, Technology and selected disciplines',
    'South African citizens meeting the programme requirements.',
    'Recognised South African universities.',
    'https://www.sasolbursaries.com/',
    'https://www.sasolbursaries.com/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Sasol'
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
    p.ProviderID,
    'Sasol Foundation Bursary',
    'Sasol Foundation bursary supporting qualifying students in selected study fields.',
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
FROM BursaryProvider p
WHERE p.ProviderName = 'Sasol'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Sasol Foundation Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'CSIR Bursary',
    'CSIR bursary supporting students in priority science, engineering and technology fields.',
    'Undergraduate / Honours / Masters / Doctoral',
    'Science, Engineering and Technology',
    'South African citizens meeting CSIR requirements.',
    'https://bursaryconnect.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Council for Scientific and Industrial Research (CSIR)'
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
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'CSIR-Sasol Foundation Bursary',
    'Joint CSIR and Sasol Foundation bursary supporting qualifying students in priority STEM fields.',
    'Undergraduate / Honours / Masters / Doctoral',
    'Science, Engineering and Technology',
    'South African citizens meeting programme requirements.',
    'https://bursaryconnect.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Council for Scientific and Industrial Research (CSIR)'
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
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'Eskom Bursary',
    'Eskom bursary programme supporting qualifying students in fields relevant to the electricity and energy sector.',
    'Undergraduate',
    'Engineering, Science, Technology and related fields',
    'South African citizens meeting Eskom requirements.',
    'https://www.eskom.co.za/',
    'https://www.eskom.co.za/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Eskom'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Eskom Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'Exxaro Student Bursary',
    'Exxaro student bursary programme supporting qualifying students in selected fields.',
    'Undergraduate',
    'Engineering, Mining, Science, Technology and related fields',
    'South African citizens meeting programme requirements.',
    'https://www.exxaro.com/careers/student-hub/',
    'https://www.exxaro.com/careers/student-hub/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Exxaro'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Exxaro Student Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'Harmony Gold Bursary',
    'Harmony Gold bursary programme supporting qualifying students in core and mining-related disciplines.',
    'Undergraduate',
    'Engineering, Mining, Geology, Finance and related fields',
    'South African citizens meeting Harmony requirements.',
    'https://www.harmony.co.za/careers/opportunities-for-students/',
    'https://www.harmony.co.za/careers/opportunities-for-students/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Harmony Gold Mining Company'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Harmony Gold Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'National Treasury External Bursary',
    'National Treasury external bursary programme for qualifying university students.',
    'Undergraduate',
    'Selected fields specified by National Treasury',
    'South African citizens meeting National Treasury requirements.',
    'https://www.treasury.gov.za/graduate/',
    'https://www.treasury.gov.za/graduate/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'National Treasury'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'National Treasury External Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'PIC Bursary',
    'Public Investment Corporation bursary programme supporting students in selected academic disciplines.',
    'Undergraduate',
    'Accounting, Actuarial Science, Computer Science, Finance, Information Technology, Statistics, Risk Management and related fields',
    'South African citizens meeting PIC requirements.',
    'https://www.pic.gov.za/bursaries',
    'https://www.pic.gov.za/bursaries',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Public Investment Corporation (PIC)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'PIC Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'SARB External Bursary',
    'South African Reserve Bank external bursary programme for qualifying students.',
    'Undergraduate',
    'Economics, Finance, Statistics, Mathematics, Computer Science, Information Technology and related fields',
    'South African citizens meeting SARB requirements.',
    'https://www.resbank.co.za/',
    'https://www.resbank.co.za/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'South African Reserve Bank (SARB)'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'SARB External Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'Department of Tourism External Bursary',
    'Government external bursary supporting qualifying students in tourism and related fields.',
    'Undergraduate / Postgraduate',
    'Tourism, Hospitality and related fields',
    'South African citizens meeting programme requirements.',
    'https://www.tourism.gov.za/Careers/Pages/Bursaries.aspx',
    'https://www.tourism.gov.za/Careers/Pages/Bursaries.aspx',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'Department of Tourism'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'Department of Tourism External Bursary'
);


INSERT INTO Bursary
(
    ProviderID,
    BursaryName,
    Description,
    StudyLevel,
    StudyFields,
    CitizenshipRequirement,
    ApplicationURL,
    InformationURL,
    IsVerified,
    IsActive,
    VerificationStatus,
    LastVerified
)
SELECT
    p.ProviderID,
    'NDMC Bursary',
    'National Disaster Management Centre bursary programme supporting students studying disaster management and fire-related qualifications.',
    'Undergraduate',
    'Disaster Management, Fire Technology, Fire Engineering',
    'South African citizens meeting NDMC requirements.',
    'https://onlinebursary.ndmc.gov.za/',
    'https://www.ndmc.gov.za/',
    1,
    1,
    'Verified',
    GETDATE()
FROM BursaryProvider p
WHERE p.ProviderName = 'National Disaster Management Centre'
AND NOT EXISTS
(
    SELECT 1 FROM Bursary
    WHERE BursaryName = 'NDMC Bursary'
);

GO