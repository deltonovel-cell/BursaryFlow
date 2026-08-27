USE BursaryFlowDB;
GO

/* ============================================================
   CLEAR OLD REQUIREMENTS
   ============================================================ */

DELETE FROM RequirementOption;
DELETE FROM BursaryRequirement;

DBCC CHECKIDENT ('RequirementOption', RESEED, 0);
DBCC CHECKIDENT ('BursaryRequirement', RESEED, 0);

PRINT 'Old requirement data cleared.';
GO


/* ============================================================
   DOCUMENT TYPES
   ============================================================ */

DELETE FROM DocumentType;

DBCC CHECKIDENT ('DocumentType', RESEED, 0);

INSERT INTO DocumentType
(
    DocumentName,
    Description,
    IsCommonDocument,
    CreatedDate
)
VALUES
('ID Document',
 'Certified copy of South African identity document.',
 1, GETDATE()),

('Proof of Registration',
 'Official proof of registration from the institution.',
 1, GETDATE()),

('Academic Transcript',
 'Latest academic record or transcript.',
 1, GETDATE()),

('Matric Certificate',
 'Certified matric certificate or statement of results.',
 1, GETDATE()),

('Proof of Household Income',
 'Proof of income for parents or guardians.',
 1, GETDATE()),

('Proof of Residence',
 'Recent proof of residential address.',
 1, GETDATE()),

('Motivation Letter',
 'Motivation explaining why the student requires funding.',
 0, GETDATE()),

('Acceptance Letter',
 'University or college acceptance letter.',
 0, GETDATE()),

('Disability Documentation',
 'Relevant documentation confirming disability.',
 0, GETDATE()),

('Death Certificate',
 'Death certificate where applicable.',
 0, GETDATE());

PRINT 'Document types populated.';
GO


/* ============================================================
   NSFAS
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'NSFAS Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Study Level',
     'Applicant must be studying at an approved institution.',
     'Undergraduate', '=', 1, GETDATE()),

    (@BursaryID, 'Financial', 'Household Income',
     'Household income must meet NSFAS requirements.',
     '350000', '<=', 1, GETDATE());
END;
GO


/* ============================================================
   FUNZA LUSHAKA
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'Funza Lushaka Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Academic Performance',
     'Applicant must meet the required academic performance.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'Teaching Qualification',
     'Applicant must be studying an approved teaching qualification.',
     'Education/Teaching', '=', 1, GETDATE());
END;
GO


/* ============================================================
   SASOL
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'Sasol Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must achieve the required academic average.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'Approved Field',
     'Applicant must study an approved field such as engineering, science or related disciplines.',
     'STEM', '=', 1, GETDATE());
END;
GO


/* ============================================================
   CSIR
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'CSIR Bursary Programme';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the required academic average.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'Science and Engineering',
     'Applicant must be studying an approved science, engineering or technology field.',
     'STEM', '=', 1, GETDATE());
END;
GO


/* ============================================================
   ESKOM
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'Eskom Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the academic requirement.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'Approved Field',
     'Applicant must study an Eskom-supported field.',
     'Engineering/Science', '=', 1, GETDATE());
END;
GO


/* ============================================================
   EXXARO
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'Exxaro Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the required academic performance.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'Approved Field',
     'Applicant must study an approved field.',
     'STEM', '=', 1, GETDATE());
END;
GO


/* ============================================================
   PIC
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'PIC Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the required academic average.',
     '65', '>=', 1, GETDATE());
END;
GO


/* ============================================================
   NATIONAL TREASURY
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'National Treasury Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Academic Performance',
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE());
END;
GO


/* ============================================================
   SOUTH AFRICAN RESERVE BANK
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'South African Reserve Bank Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the required academic performance.',
     '65', '>=', 1, GETDATE());
END;
GO


/* ============================================================
   DEPARTMENT OF TOURISM
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'Department of Tourism Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Academic Performance',
     'Applicant must meet the academic requirement.',
     '60', '>=', 1, GETDATE());
END;
GO


/* ============================================================
   HARMONY GOLD
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'Harmony Gold Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Citizenship', 'South African Citizenship',
     'Applicant must be a South African citizen.',
     'South African', '=', 1, GETDATE()),

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE());
END;
GO


/* ============================================================
   SANZAF
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'SANZAF Education Bursary';

IF @BursaryID IS NOT NULL
BEGIN
    INSERT INTO BursaryRequirement
    (BursaryID, RequirementType, RequirementName,
     RequirementDescription, RequiredValue,
     ComparisonOperator, IsMandatory, CreatedDate)
    VALUES
    (@BursaryID, 'Academic', 'Academic Performance',
     'Applicant must meet the academic requirement.',
     '60', '>=', 1, GETDATE()),

    (@BursaryID, 'Financial', 'Financial Need',
     'Financial need may be considered when assessing the application.',
     'true', '=', 0, GETDATE());
END;
GO


/* ============================================================
   VERIFY
   ============================================================ */

SELECT
    br.RequirementID,
    b.BursaryName,
    br.RequirementType,
    br.RequirementName,
    br.RequiredValue,
    br.ComparisonOperator,
    br.IsMandatory
FROM BursaryRequirement br
INNER JOIN Bursary b
    ON br.BursaryID = b.BursaryID
ORDER BY b.BursaryID, br.RequirementID;

PRINT 'Requirement and document data populated successfully.';
GO