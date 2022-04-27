CREATE TABLE [dw].[fact_ResellerSales] (
    [SalesOrderID]       INT           NULL,
    [SalesOrderNumber]   NVARCHAR (25) NULL,
    [SalesOrderDetailID] INT           NULL,
    [datekey]            INT           NOT NULL,
    [ResellerKey]        INT           NOT NULL,
    [ProductKey]         INT           NOT NULL,
    [currencyKey]        INT           NULL,
    [OrderQty]           SMALLINT      NULL,
    [UnitPrice]          MONEY         NULL,
    [ExtendedAmount]     MONEY         NULL,
    [UnitPriceDiscount]  MONEY         NULL,
    [DiscountAmount]     MONEY         NULL,
    [StandardCost]       MONEY         NULL,
    [TotalProductCost]   MONEY         NULL,
    [SalesAmount]        MONEY         NULL,
    [Timestamp]          DATETIME      NULL
);

