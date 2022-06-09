CREATE TABLE [dbo].[FactResellerSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NULL,
    [SalesOrderDetailID]   INT           NULL,
    [DateKey]              INT           NULL,
    [ResellerKey]          INT           NULL,
    [ProductKey]           INT           NULL,
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

