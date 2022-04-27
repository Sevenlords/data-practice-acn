CREATE TABLE [dbo].[FactInternetSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID]   INT           NOT NULL,
    [DateKey]              INT           NULL,
    [CustomerKey]          INT           NOT NULL,
    [ProductKey]           INT           NULL,
    [OrderQty]             SMALLINT      NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [ExtendedAmout]        MONEY         NOT NULL,
    [UnitPriceDiscountPct] MONEY         NOT NULL,
    [DiscountAmount]       MONEY         NULL,
    [ProductStandartCost]  MONEY         NULL,
    [TotalProductCost]     MONEY         NOT NULL,
    [SalesAmount]          MONEY         NOT NULL,
    [Timestamp]            DATETIME      DEFAULT (getdate()) NULL
);

