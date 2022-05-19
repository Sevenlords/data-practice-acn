CREATE TABLE [dbo].[FactInternetSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID]   INT           NOT NULL,
    [DateKey]              INT           NULL,
    [CustomerKey]          INT           NULL,
    [ProductKey]           INT           NULL,
    [CurrencyKey]          INT           NULL,
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

