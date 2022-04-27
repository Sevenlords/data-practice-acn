CREATE TABLE [stg].[Person_BusinessEntityAddress] (
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [ModifiedDate]     DATETIME         NULL,
    [AddressID]        INT              NULL,
    [BusinessEntityID] INT              NULL,
    [AddressTypeID]    INT              NULL,
    [Timestamp]        DATETIME         DEFAULT (getdate()) NULL
);

