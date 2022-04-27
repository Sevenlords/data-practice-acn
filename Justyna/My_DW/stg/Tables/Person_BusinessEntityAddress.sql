CREATE TABLE [stg].[Person_BusinessEntityAddress] (
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [ModifiedDate]     DATETIME         NULL,
    [BusinessEntityID] INT              NULL,
    [AddressID]        INT              NULL,
    [AddressTypeID]    INT              NULL,
    [Timestamp]        DATETIME         DEFAULT (getdate()) NULL
);

