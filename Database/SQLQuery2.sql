USE BursaryFlowDB;
GO

CREATE TABLE BursaryCycle
(
    CycleID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryID INT NOT NULL,

    AcademicYear INT NOT NULL,

    OpeningDate DATETIME2,

    ClosingDate DATETIME2,

    Status NVARCHAR(50) NOT NULL DEFAULT 'Unknown',

    OfficialInformationURL NVARCHAR(1000),

    OfficialApplicationURL NVARCHAR(1000),

    ApplicationMethod NVARCHAR(100),

    LastVerified DATETIME2,

    VerificationStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending',

    IsCurrent BIT NOT NULL DEFAULT 0,

    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID)
        ON DELETE CASCADE,

    CONSTRAINT CK_BursaryCycle_Status
        CHECK
        (
            Status IN
            (
                'Upcoming',
                'Open',
                'Closed',
                'Extended',
                'Cancelled',
                'Unknown'
            )
        )
);
GO

ALTER TABLE BursaryCycle
ADD
    LastStatusCheck DATETIME2,
    NextExpectedCheck DATETIME2,
    StatusSourceURL NVARCHAR(1000);
GO