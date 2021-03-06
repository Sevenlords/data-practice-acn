CREATE TABLE [dbo].[FactInternetSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID]   INT           NOT NULL,
    [DateKey]              INT           NOT NULL,
    [CustomerKey]          INT           NOT NULL,
    [ProductKey]           INT           NOT NULL,
    [OrderQuantity]        SMALLINT      NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [ExtendedAmount]       MONEY         NOT NULL,
    [UnitPriceDiscountPct] MONEY         NOT NULL,
    [DiscountAmount]       INT           NOT NULL,
    [ProductStandardCost]  MONEY         NOT NULL,
    [TotalProductCost]     MONEY         NOT NULL,
    [SalesAmount]          MONEY         NOT NULL,
    [CreatedDate]          DATETIME      DEFAULT (getdate()) NULL,
    [ModifiedDate]         DATETIME      NULL
);


GO
