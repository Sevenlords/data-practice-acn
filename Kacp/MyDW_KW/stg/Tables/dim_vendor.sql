CREATE TABLE [stg].[dim_vendor] (
    [SalesPersonID] INT           NULL,
    [TerritoryID]   INT           NULL,
    [orderdate]     DATETIME      NULL,
    [CustomerID]    INT           NULL,
    [SalesQuota]    MONEY         NULL,
    [Bonus]         MONEY         NULL,
    [CommissionPct] MONEY         NULL,
    [StoreID]       INT           NULL,
    [Name]          NVARCHAR (50) NULL,
    [Timestamp]     DATETIME      NULL
);

