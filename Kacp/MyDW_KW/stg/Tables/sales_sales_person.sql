CREATE TABLE [stg].[sales_sales_person] (
    [ModifiedDate]     DATETIME NULL,
    [BusinessEntityID] INT      NULL,
    [TerritoryID]      INT      NULL,
    [SalesQuota]       MONEY    NULL,
    [Bonus]            MONEY    NULL,
    [CommissionPct]    MONEY    NULL,
    [SalesYTD]         MONEY    NULL,
    [SalesLastYear]    MONEY    NULL,
    [Timestamp]        DATETIME DEFAULT (getdate()) NULL
);

