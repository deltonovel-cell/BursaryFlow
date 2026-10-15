USE BursaryFlowDB;
GO

/* =========================================================
   ADD MISSING COLUMNS TO EXISTING BURSARY TABLE
   ========================================================= */

IF COL_LENGTH('dbo.Bursary', 'ProviderID') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD ProviderID INT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'StudyLevel') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD StudyLevel NVARCHAR(255) NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'StudyFields') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD StudyFields NVARCHAR(MAX) NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'MinimumAverage') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD MinimumAverage DECIMAL(5,2) NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'MinimumAge') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD MinimumAge INT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'MaximumAge') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD MaximumAge INT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'CitizenshipRequirement') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD CitizenshipRequirement NVARCHAR(500) NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'InstitutionRequirement') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD InstitutionRequirement NVARCHAR(MAX) NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'FinancialNeedRequired') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD FinancialNeedRequired BIT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'AccommodationIncluded') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD AccommodationIncluded BIT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'TuitionIncluded') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD TuitionIncluded BIT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'BooksIncluded') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD BooksIncluded BIT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'AccommodationAllowanceIncluded') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD AccommodationAllowanceIncluded BIT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'LivingAllowanceIncluded') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD LivingAllowanceIncluded BIT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'TransportAllowanceIncluded') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD TransportAllowanceIncluded BIT NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'ApplicationURL') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD ApplicationURL NVARCHAR(1000) NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'InformationURL') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD InformationURL NVARCHAR(1000) NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'IsVerified') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD IsVerified BIT NOT NULL
        CONSTRAINT DF_Bursary_IsVerified DEFAULT 0;
END
GO


IF COL_LENGTH('dbo.Bursary', 'IsActive') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD IsActive BIT NOT NULL
        CONSTRAINT DF_Bursary_IsActive DEFAULT 1;
END
GO


IF COL_LENGTH('dbo.Bursary', 'VerificationStatus') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD VerificationStatus NVARCHAR(50) NOT NULL
        CONSTRAINT DF_Bursary_VerificationStatus DEFAULT 'Pending';
END
GO


IF COL_LENGTH('dbo.Bursary', 'LastVerified') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD LastVerified DATETIME2 NULL;
END
GO


IF COL_LENGTH('dbo.Bursary', 'CreatedDate') IS NULL
BEGIN
    ALTER TABLE dbo.Bursary
    ADD CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Bursary_CreatedDate DEFAULT GETDATE();
END
GO

ALTER TABLE Bursary
ADD CONSTRAINT FK_Bursary_BursaryProvider
FOREIGN KEY (ProviderID)
REFERENCES BursaryProvider(ProviderID);
GO

SELECT COUNT(*) AS TotalProviders
FROM BursaryProvider;
