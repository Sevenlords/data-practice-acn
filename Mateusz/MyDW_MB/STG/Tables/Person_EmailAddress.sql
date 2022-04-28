CREATE TABLE [STG].[Person_EmailAddress] (
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [ModifiedDate]     DATETIME         NULL,
    [BusinessEntityID] INT              NULL,
    [EmailAddressID]   INT              NULL,
    [EmailAddress]     NVARCHAR (50)    NULL,
    [timeshtamp]       DATETIME         DEFAULT (getdate()) NULL
);

