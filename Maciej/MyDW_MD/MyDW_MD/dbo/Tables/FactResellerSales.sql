CREATE TABLE [dbo].[FactResellerSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID]   INT           NOT NULL,
    [DateKey]              INT           NOT NULL,
    [ResellerKey]          INT           NOT NULL,
    [ProductKey]           INT           NOT NULL,
    [OrderQuantity]        SMALLINT      NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [ExtendedAmount]       INT           NOT NULL,
    [UnitPriceDiscountPct] MONEY         NOT NULL,
    [DiscountAmount]       MONEY         NOT NULL,
    [ProductStandardCost]  MONEY         NOT NULL,
    [TotalProductCost]     MONEY         NOT NULL,
    [SalesAmount]          MONEY         NOT NULL,
    [SourceID]             NVARCHAR (40) NOT NULL,
    [CreatedDate]          DATETIME      DEFAULT (getdate()) NULL,
    [ModifiedDate]         DATETIME      NULL
);


GO
