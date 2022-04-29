CREATE TABLE [DW].[FactInternetSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID]   INT           NOT NULL,
    [DateKey]              INT           NOT NULL,
    [CustomerKey]          INT           NOT NULL,
    [ProductKey]           INT           NOT NULL,
    [OrderQuantity]        INT           NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [ExtendedAmount]       MONEY         NOT NULL,
    [UnitPriceDiscountPct] MONEY         NOT NULL,
    [DiscountAmount]       MONEY         NOT NULL,
    [ProductStandartCost]  MONEY         NOT NULL,
    [TotalProductCost]     MONEY         NOT NULL,
    [SalesAmount]          MONEY         NOT NULL,
    [TimeStamp]            DATETIME      DEFAULT (getdate()) NOT NULL
);

