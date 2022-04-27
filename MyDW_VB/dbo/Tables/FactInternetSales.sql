CREATE TABLE [dbo].[FactInternetSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID]   INT           NOT NULL,
    [DateKey]              INT           NULL,
    [CustomerKey]          INT           NOT NULL,
    [ProductKey]           INT           NULL,
    [OrderQuantity]        SMALLINT      NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [ExtendedAmount]       MONEY         NOT NULL,
    [UnitPriceDiscountPct] MONEY         NULL,
    [DiscountAmount]       MONEY         NOT NULL,
    [ProductStandardCost]  MONEY         NULL,
    [TotalProductCost]     MONEY         NOT NULL,
    [SalesAmount]          MONEY         NOT NULL,
    [TaxAmount]            FLOAT (53)    NULL,
    [ModifiedDate]         DATETIME      NOT NULL
);

