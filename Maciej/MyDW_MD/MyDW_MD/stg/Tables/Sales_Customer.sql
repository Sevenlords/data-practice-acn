CREATE TABLE [stg].[Sales_Customer] (
    [ModifiedDate]  DATETIME         NULL,
    [rowguid]       UNIQUEIDENTIFIER NULL,
    [CustomerID]    INT              NULL,
    [PersonID]      INT              NULL,
    [StoreID]       INT              NULL,
    [TerritoryID]   INT              NULL,
    [AccountNumber] VARCHAR (10)     NULL,
    [timestamp]     DATETIME         DEFAULT (getdate()) NULL
);

