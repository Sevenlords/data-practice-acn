CREATE TABLE [stg].[Person_EmailAddress] (
    [ModifiedDate]     DATETIME      NULL,
    [BusinessEntityID] INT           NULL,
    [EmailAddressID]   INT           NULL,
    [EmailAddress]     NVARCHAR (50) NULL,
    [timestamp]        DATETIME      DEFAULT (getdate()) NULL
);

