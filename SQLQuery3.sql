CREATE TABLE BursaryURLHistory
(
    URLHistoryID INT IDENTITY(1,1) PRIMARY KEY,

    CycleID INT NOT NULL,

    URLType NVARCHAR(50) NOT NULL,

    URL NVARCHAR(1000) NOT NULL,

    FirstSeen DATETIME2 NOT NULL DEFAULT GETDATE(),

    LastSeen DATETIME2 NOT NULL DEFAULT GETDATE(),

    IsCurrent BIT NOT NULL DEFAULT 1,

    IsWorking BIT,

    HTTPStatusCode INT,

    FOREIGN KEY (CycleID)
        REFERENCES BursaryCycle(CycleID)
        ON DELETE CASCADE
);
GO


CREATE TABLE BursaryChangeLog
(
    ChangeID INT IDENTITY(1,1) PRIMARY KEY,

    BursaryID INT,

    CycleID INT,

    ChangeType NVARCHAR(100) NOT NULL,

    FieldName NVARCHAR(255),

    OldValue NVARCHAR(MAX),

    NewValue NVARCHAR(MAX),

    DetectedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    SourceURL NVARCHAR(1000),

    FOREIGN KEY (BursaryID)
        REFERENCES Bursary(BursaryID),

    FOREIGN KEY (CycleID)
        REFERENCES BursaryCycle(CycleID)
);
GO