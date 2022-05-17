CREATE TABLE [stg].[Person_BusinessEntityAddress] (
    [ModifiedDate]     DATETIME         NULL,
    [BusinessEntityID] INT              NULL,
    [AddressID]        INT              NULL,
    [AddressTypeID]    INT              NULL,
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [timestamp]        DATETIME         DEFAULT (getdate()) NULL
);

