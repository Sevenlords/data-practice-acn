CREATE TABLE [stg].[Person_EmailAddress] (
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [ModifiedDate]     DATETIME         NULL,
    [BusinessEntityID] INT              NULL,
    [EmailAddressID]   INT              NULL,
    [EmailAddress]     NVARCHAR (50)    NULL,
    [Timestamp]        DATETIME         DEFAULT (getdate()) NULL
);

