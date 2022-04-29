CREATE TABLE [STG].[Person_BusinessEntityAddress] (
    [BusinessEntityID] INT      NULL,
    [AddressID]        INT      NULL,
    [AddressTypeID]    INT      NULL,
    [ModifiedDate]     DATETIME NULL,
    [Time_Stamp]       DATETIME CONSTRAINT [DF_Time_Stamp_Person_BusinessEntityAddress] DEFAULT (getdate()) NULL
);

