CREATE TABLE [STG].[Person_BusinessEntityAddress] (
    [BusinessEntityID] INT      NULL,
    [ModifiedDate]     DATETIME NULL,
    [AddressID]        INT      NULL,
    [AddressTypeID]    INT      NULL,
    [timeshtamp]       DATETIME DEFAULT (getdate()) NULL
);

