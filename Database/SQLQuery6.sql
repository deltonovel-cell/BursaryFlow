USE BursaryFlowDB;
GO

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
VALUES

-- GOVERNMENT / PUBLIC FUNDING
(
    'National Student Financial Aid Scheme (NSFAS)',
    'National student financial aid scheme providing financial support to eligible students.',
    'https://www.nsfas.org.za/',
    'https://www.nsfas.org.za/',
    'Government',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Funza Lushaka Bursary Programme',
    'Government bursary programme supporting qualifying students pursuing teaching qualifications.',
    'https://www.education.gov.za/',
    'https://www.eservices.gov.za/',
    'Government',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'National Treasury',
    'South African National Treasury external bursary programme.',
    'https://www.treasury.gov.za/',
    'https://www.treasury.gov.za/graduate/',
    'Government',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Department of Tourism',
    'Government bursary programme supporting students in tourism and related fields.',
    'https://www.tourism.gov.za/',
    'https://www.tourism.gov.za/Careers/Pages/Bursaries.aspx',
    'Government',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Department of Agriculture',
    'Government bursary opportunities for agriculture and related qualifications.',
    'https://www.nda.gov.za/',
    'https://www.nda.gov.za/',
    'Government',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Department of Sport, Arts and Culture',
    'Government bursary programme supporting qualifying students in heritage and related fields.',
    'https://www.dsac.gov.za/',
    'https://www.dsac.gov.za/',
    'Government',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'National Disaster Management Centre',
    'Government bursary programme for disaster management and fire technology or fire engineering.',
    'https://www.ndmc.gov.za/',
    'https://onlinebursary.ndmc.gov.za/',
    'Government',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Public Investment Corporation (PIC)',
    'Public investment organisation offering undergraduate bursary opportunities.',
    'https://www.pic.gov.za/',
    'https://www.pic.gov.za/bursaries',
    'State Owned Company',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'South African Reserve Bank (SARB)',
    'South African central bank offering external bursary and scholarship opportunities.',
    'https://www.resbank.co.za/',
    'https://www.resbank.co.za/',
    'Government Institution',
    1, 1, 'Verified', GETDATE(), 1
),

-- SCIENCE / TECHNOLOGY
(
    'Council for Scientific and Industrial Research (CSIR)',
    'Scientific and industrial research organisation offering undergraduate, honours, masters and doctoral bursaries.',
    'https://www.csir.co.za/',
    'https://www.csir.co.za/careers/students-graduates/bursaries',
    'Research Organisation',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'National Research Foundation (NRF)',
    'National research funding organisation supporting postgraduate research and academic development.',
    'https://www.nrf.ac.za/',
    'https://www.nrf.ac.za/',
    'Research Organisation',
    1, 1, 'Verified', GETDATE(), 1
),

-- ENERGY / MINING
(
    'Eskom',
    'South African electricity utility offering bursary opportunities in critical technical and professional fields.',
    'https://www.eskom.co.za/',
    'https://www.eskom.co.za/',
    'State Owned Company',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Sasol',
    'Energy and chemicals company offering multiple bursary programmes.',
    'https://www.sasol.com/',
    'https://www.sasolbursaries.com/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Exxaro',
    'Mining company offering student bursary and development opportunities.',
    'https://www.exxaro.com/',
    'https://www.exxaro.com/careers/student-hub/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Harmony Gold Mining Company',
    'Mining company offering bursaries and student development opportunities.',
    'https://www.harmony.co.za/',
    'https://www.harmony.co.za/careers/opportunities-for-students/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Anglo American',
    'Global mining company offering student and graduate development opportunities.',
    'https://www.angloamerican.com/',
    'https://www.angloamerican.com/careers',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'De Beers Group',
    'Diamond mining company offering bursary and student development opportunities.',
    'https://www.debeersgroup.com/',
    'https://www.debeersgroup.com/careers',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Gold Fields',
    'Gold mining company offering bursaries and opportunities for students in relevant fields.',
    'https://www.goldfields.com/',
    'https://www.goldfields.com/careers/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Sibanye-Stillwater',
    'Mining and metals company offering bursary and learner development opportunities.',
    'https://www.sibanyestillwater.com/',
    'https://www.sibanyestillwater.com/careers/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Impala Platinum (Implats)',
    'Platinum group metals mining company offering student development and bursary opportunities.',
    'https://www.implats.co.za/',
    'https://www.implats.co.za/careers',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

-- TRANSPORT / INFRASTRUCTURE
(
    'Transnet',
    'South African state-owned freight logistics company offering student bursary opportunities.',
    'https://www.transnet.net/',
    'https://www.transnet.net/Careers/Pages/default.aspx',
    'State Owned Company',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'PRASA',
    'Passenger Rail Agency of South Africa offering student development opportunities.',
    'https://www.prasa.com/',
    'https://www.prasa.com/',
    'State Owned Company',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'South African National Roads Agency (SANRAL)',
    'National roads agency supporting education and skills development programmes.',
    'https://www.nra.co.za/',
    'https://www.nra.co.za/',
    'State Owned Company',
    1, 1, 'Verified', GETDATE(), 1
),

-- FINANCIAL SERVICES
(
    'Investec',
    'Financial services group offering education funding and student development opportunities.',
    'https://www.investec.com/',
    'https://www.investec.com/en_za/careers.html',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Standard Bank',
    'Financial services group offering education and student development programmes.',
    'https://www.standardbank.co.za/',
    'https://www.standardbank.co.za/southafrica/personal/about-us/careers',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Nedbank',
    'Financial services group supporting education and youth development initiatives.',
    'https://www.nedbank.co.za/',
    'https://jobs.nedbank.co.za/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'FirstRand',
    'Financial services group supporting education and development initiatives through its businesses and foundations.',
    'https://www.firstrand.co.za/',
    'https://www.firstrand.co.za/careers/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Old Mutual',
    'Financial services organisation offering education and actuarial development opportunities.',
    'https://www.oldmutual.co.za/',
    'https://www.oldmutual.co.za/careers/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

-- TELECOMMUNICATIONS
(
    'Vodacom',
    'Telecommunications company supporting education, technology and youth development initiatives.',
    'https://www.vodacom.co.za/',
    'https://www.vodacom.co.za/vodacom/careers',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'MTN',
    'Telecommunications company supporting education and digital skills development.',
    'https://www.mtn.com/',
    'https://www.mtn.com/careers/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

-- RETAIL / CONSUMER
(
    'Shoprite Group',
    'Retail group offering bursary and student development opportunities.',
    'https://www.shopriteholdings.co.za/',
    'https://www.shopriteholdings.co.za/careers.html',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Pick n Pay',
    'South African retail group supporting education and youth development initiatives.',
    'https://www.pnp.co.za/',
    'https://www.picknpay.co.za/careers',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

-- ENGINEERING / CONSTRUCTION
(
    'AECI',
    'South African chemicals and industrial group supporting students and future technical professionals.',
    'https://www.aeci.co.za/',
    'https://www.aeci.co.za/careers/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'WBHO',
    'South African construction company offering bursary opportunities for students in construction and engineering fields.',
    'https://www.wbho.co.za/',
    'https://www.wbho.co.za/careers/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
),

(
    'Aveng',
    'Engineering and infrastructure group supporting skills development and student opportunities.',
    'https://www.aveng.co.za/',
    'https://www.aveng.co.za/careers/',
    'Corporate',
    1, 1, 'Verified', GETDATE(), 1
);

GO