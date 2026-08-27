USE BursaryFlowDB;
GO

/* =========================================================
   VERIFIED BURSARY PROVIDERS
   ========================================================= */

INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'National Student Financial Aid Scheme (NSFAS)',
    'Government-funded student financial aid scheme for eligible students at public universities and TVET colleges.',
    'https://www.nsfas.org.za/',
    'https://www.nsfas.org.za/',
    'Government',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'National Student Financial Aid Scheme (NSFAS)'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Funza Lushaka Bursary Programme',
    'Government bursary programme supporting qualifying students studying towards teaching qualifications in priority subject areas.',
    'https://www.education.gov.za/Programmes/FunzaLushaka.aspx',
    'https://www.eservices.gov.za/FunzaLushaka/',
    'Government',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Funza Lushaka Bursary Programme'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Sasol',
    'South African energy and chemicals company offering several bursary programmes including mainstream, foundation and mining-related opportunities.',
    'https://www.sasol.com/',
    'https://www.sasolbursaries.com/',
    'Corporate',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Sasol'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Eskom',
    'South African electricity utility with a long-running bursary programme supporting critical engineering, science, technology and related skills.',
    'https://www.eskom.co.za/',
    'https://www.eskom.co.za/',
    'State Owned Company',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Eskom'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Exxaro',
    'South African mining company offering student bursaries and development opportunities, particularly for students from its host communities.',
    'https://www.exxaro.com/',
    'https://www.exxaro.com/careers/student-hub/',
    'Corporate',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Exxaro'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Harmony Gold Mining Company',
    'Mining company offering full-time bursaries in core, mining-related and other disciplines for qualifying South African students.',
    'https://www.harmony.co.za/',
    'https://www.harmony.co.za/careers/opportunities-for-students/',
    'Corporate',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Harmony Gold Mining Company'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Council for Scientific and Industrial Research (CSIR)',
    'South African scientific research organisation offering undergraduate, honours, masters and doctoral bursaries in priority science, engineering and technology fields.',
    'https://www.csir.co.za/',
    'https://bursaryconnect.csir.co.za/',
    'Research Organisation',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Council for Scientific and Industrial Research (CSIR)'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Public Investment Corporation (PIC)',
    'South African public investment management organisation offering bursaries in fields including accounting, actuarial science, computer science, finance, information technology, statistics and risk management.',
    'https://www.pic.gov.za/',
    'https://www.pic.gov.za/bursaries',
    'State Owned Company',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Public Investment Corporation (PIC)'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'National Treasury',
    'South African National Treasury offering external bursaries for qualifying university students.',
    'https://www.treasury.gov.za/',
    'https://www.treasury.gov.za/graduate/',
    'Government',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'National Treasury'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'South African Reserve Bank (SARB)',
    'South African Reserve Bank offering external bursaries and specialised scholarship opportunities.',
    'https://www.resbank.co.za/',
    'https://www.sarb.co.za/en/home/publications/publication-detail-pages/bursary/2025/external-2026',
    'Government Institution',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'South African Reserve Bank (SARB)'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Department of Tourism',
    'South African government department offering external bursaries for qualifying students in tourism and a broad range of related academic fields.',
    'https://www.tourism.gov.za/',
    'https://www.tourism.gov.za/Careers/Pages/Bursaries.aspx',
    'Government',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Department of Tourism'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Department of Agriculture',
    'South African government department offering external bursaries for qualifying students pursuing agriculture and related qualifications.',
    'https://www.nda.gov.za/',
    'https://www.nda.gov.za/index.php/vacancies',
    'Government',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Department of Agriculture'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'Department of Sport, Arts and Culture',
    'South African government department offering bursaries for qualifying students pursuing heritage-related studies.',
    'https://www.dsac.gov.za/',
    'https://www.dsac.gov.za/node/529',
    'Government',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'Department of Sport, Arts and Culture'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'National Disaster Management Centre (NDMC)',
    'Government bursary programme supporting qualifying students pursuing disaster management and fire technology or fire engineering qualifications.',
    'https://www.ndmc.gov.za/',
    'https://onlinebursary.ndmc.gov.za/',
    'Government',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'National Disaster Management Centre (NDMC)'
);


INSERT INTO BursaryProvider
(
    ProviderName,
    Description,
    OfficialWebsite,
    ApplicationWebsite,
    ProviderType,
    IsVerified,
    IsActive,
    VerificationStatus,
    VerificationDate,
    OfficialApplicationRequired
)
SELECT
    'South African National Zakah Fund (SANZAF)',
    'South African charitable organisation providing partial bursary funding to qualifying students.',
    'https://www.sanzaf.org.za/',
    'https://seed.sanzaf.org.za/',
    'Non Profit Organisation',
    1,
    1,
    'Verified',
    GETDATE(),
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM BursaryProvider
    WHERE ProviderName = 'South African National Zakah Fund (SANZAF)'
);

GO