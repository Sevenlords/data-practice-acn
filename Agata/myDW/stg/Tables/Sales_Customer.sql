﻿CREATE TABLE [stg].[Sales_Customer] (
    [rowguid]       UNIQUEIDENTIFIER NULL,
    [ModifiedDate]  DATETIME         NULL,
    [CustomerID]    INT              NULL,
    [PersonID]      INT              NULL,
    [StoreID]       INT              NULL,
    [TerritoryID]   INT              NULL,
    [AccountNumber] VARCHAR (10)     NULL,
    [timeshtamp]    DATETIME         DEFAULT (getdate()) NULL
);

