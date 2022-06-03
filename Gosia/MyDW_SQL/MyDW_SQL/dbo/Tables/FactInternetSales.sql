CREATE TABLE [dbo].[FactInternetSales] (
    [SalesOrderID]         INT           NULL,
    [SalesOrderNumber]     NVARCHAR (25) NULL,
    [SalesOrderDetailID]   INT           NULL,
    [DateKey]              INT           NULL,
    [CustomerKey]          INT           NULL,
    [ProductKey]           SMALLINT      NULL,
    [OrderQuantity]        SMALLINT      NULL,
    [UnitPrice]            MONEY         NULL,
    [ExtendedAmount]       MONEY         NULL,
    [UnitPriceDiscountPct] MONEY         NULL,
    [DiscountAmount]       MONEY         NULL,
    [ProductStandardCost]  MONEY         NULL,
    [TotalProductCost]     MONEY         NULL,
    [SalesAmount]          MONEY         NULL,
    [CreatedDate]          DATETIME      DEFAULT (getdate()) NULL,
    [ModifiedDate]         DATETIME      NULL
);

