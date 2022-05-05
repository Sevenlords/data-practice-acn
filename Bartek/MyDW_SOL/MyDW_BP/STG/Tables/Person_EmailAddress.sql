CREATE TABLE [STG].[Person_EmailAddress] (
    [BusinessEntityID] INT           NULL,
    [EmailAddressID]   INT           NULL,
    [EmailAddress]     NVARCHAR (50) NULL,
    [ModifiedDate]     DATETIME      NULL,
    [Time_stamp]       DATETIME      CONSTRAINT [DF_Time_Stamp_Person_EmailAddress] DEFAULT (getdate()) NULL
);

