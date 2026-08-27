USE BursaryFlowDB;
GO

CREATE TABLE BursaryProvider
(
    ProviderID INT IDENTITY(1,1) PRIMARY KEY,

    ProviderName NVARCHAR(255) NOT NULL,

    Description NVARCHAR(MAX),

    OfficialWebsite NVARCHAR(1000),

    ApplicationWebsite NVARCHAR(1000),

    ContactEmail NVARCHAR(255),

    ContactPhone NVARCHAR(50),

    ProviderType NVARCHAR(100),

    IsVerified BIT NOT NULL DEFAULT 0,

    IsActive BIT NOT NULL DEFAULT 1,

    VerificationStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending',

    VerificationDate DATETIME2 NULL,

    OfficialApplicationRequired BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    LastChecked DATETIME2 NULL
);
GO
