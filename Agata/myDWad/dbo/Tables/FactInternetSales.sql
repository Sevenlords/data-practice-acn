CREATE TABLE [dbo].[FactInternetSales] (
    [SalesOrderID]       INT           NOT NULL,
    [SalesOrderNumber]   NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID] INT           NOT NULL,
    [dateKey]            INT           NOT NULL,
    [CustomerKey]        INT           NOT NULL,
    [ProductKey]         INT           NOT NULL,
    [OrderQty]           SMALLINT      NOT NULL,
    [UnitPrice]          MONEY         NOT NULL,
    [ExtendedAmount]     MONEY         NOT NULL,
    [UnitPriceDiscount]  MONEY         NOT NULL,
    [DiscountAmount]     MONEY         NOT NULL,
    [StandardCost]       MONEY         NOT NULL,
    [TotalProductCost]   MONEY         NOT NULL,
    [SalesAmount]        MONEY         NOT NULL,
    [Timeshtamp]         DATETIME      DEFAULT (getdate()) NOT NULL
);

