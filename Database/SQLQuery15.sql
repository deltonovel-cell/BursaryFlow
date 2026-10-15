USE BursaryFlowDB;
GO

/* ============================================================
   1. CLEAR REQUIREMENTS ONLY
   ============================================================ */

DELETE FROM RequirementOption;
DELETE FROM BursaryRequirement;

DBCC CHECKIDENT ('RequirementOption', RESEED, 0);
DBCC CHECKIDENT ('BursaryRequirement', RESEED, 0);

PRINT 'Old requirement data cleared.';
GO


/* ============================================================
   2. NSFAS
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

    (@BursaryID, 'Financial', 'Household Income',
     'Household income must meet the applicable NSFAS threshold.',
     '350000', '<=', 1, GETDATE()),

    (@BursaryID, 'StudyLevel', 'Undergraduate Study',
     'Applicant must be studying at an approved institution.',
     'Undergraduate', '=', 1, GETDATE());
END;
GO


/* ============================================================
   3. FUNZA LUSHAKA
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

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'Teaching Qualification',
     'Applicant must be pursuing an approved teaching qualification.',
     'Education/Teaching', '=', 1, GETDATE());
END;
GO


/* ============================================================
   4. SASOL
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
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'Approved Study Field',
     'Applicant must study an approved field.',
     'STEM', '=', 1, GETDATE());
END;
GO


/* ============================================================
   5. CSIR
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
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'STEM Field',
     'Applicant must study an approved science, engineering or technology field.',
     'STEM', '=', 1, GETDATE());
END;
GO


/* ============================================================
   6. CSIR-SASOL FOUNDATION
   ============================================================ */

DECLARE @BursaryID INT;

SELECT @BursaryID = BursaryID
FROM Bursary
WHERE BursaryName = 'CSIR-Sasol Foundation Bursary';

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
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'STEM Field',
     'Applicant must study an approved STEM field.',
     'STEM', '=', 1, GETDATE());
END;
GO


/* ============================================================
   7. ESKOM
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
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'Approved Field',
     'Applicant must study an Eskom-supported field.',
     'Engineering/Science', '=', 1, GETDATE());
END;
GO


/* ============================================================
   8. EXXARO
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
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE()),

    (@BursaryID, 'StudyField', 'Approved Field',
     'Applicant must study an approved field.',
     'STEM', '=', 1, GETDATE());
END;
GO


/* ============================================================
   9. PIC
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
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE());
END;
GO


/* ============================================================
   10. NATIONAL TREASURY
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

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE());
END;
GO


/* ============================================================
   11. SOUTH AFRICAN RESERVE BANK
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
     'Applicant must meet the required academic standard.',
     '65', '>=', 1, GETDATE());
END;
GO


/* ============================================================
   12. DEPARTMENT OF TOURISM
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

    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the required academic standard.',
     '60', '>=', 1, GETDATE());
END;
GO


/* ============================================================
   13. HARMONY GOLD
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
   14. SANZAF
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
    (@BursaryID, 'Academic', 'Minimum Average',
     'Applicant must meet the required academic standard.',
     '60', '>=', 1, GETDATE()),

    (@BursaryID, 'Financial', 'Financial Need',
     'Financial need may be considered.',
     'true', '=', 0, GETDATE());
END;
GO


/* ============================================================
   FINAL CHECK
   ============================================================ */

SELECT
    b.BursaryID,
    b.BursaryName,
    br.RequirementID,
    br.RequirementType,
    br.RequirementName,
    br.RequiredValue,
    br.ComparisonOperator,
    br.IsMandatory
FROM Bursary b
LEFT JOIN BursaryRequirement br
    ON b.BursaryID = br.BursaryID
ORDER BY b.BursaryID, br.RequirementID;

PRINT 'Requirements populated successfully.';
GO