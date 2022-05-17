CREATE TABLE [dbo].[factResellerSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID]   INT           NOT NULL,
    [DateKey]              INT           NOT NULL,
    [ResellerKey]          INT           NOT NULL,
    [ProductKey]           INT           NOT NULL,
    [OrderQuantity]        SMALLINT      NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [ExtendedAmount]       MONEY         NOT NULL,
    [UnitPriceDiscountPct] MONEY         NOT NULL,
    [DiscountAmount]       MONEY         NULL,
    [ProductStandardCost]  MONEY         NOT NULL,
    [TotalProductCost]     MONEY         NOT NULL,
    [SalesAmount]          MONEY         NULL,
    [Timestamp]            DATETIME      DEFAULT (getdate()) NULL,
    [SourceID]             VARCHAR (10)  NULL
);









