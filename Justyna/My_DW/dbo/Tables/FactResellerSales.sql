CREATE TABLE [dbo].[FactResellerSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID]   INT           NOT NULL,
    [DateKey]              INT           NOT NULL,
    [ResellerKey]          INT           NOT NULL,
    [ProductKey]           INT           NOT NULL,
    [OrderQty]             SMALLINT      NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [ExtendedAmount]       MONEY         NOT NULL,
    [UnitPriceDiscountPct] MONEY         NOT NULL,
    [DiscountAmount]       MONEY         NOT NULL,
    [ProductStandartCost]  MONEY         NOT NULL,
    [TotalProductCost]     MONEY         NOT NULL,
    [SalesAmount]          MONEY         NOT NULL,
    [Timestamp]            DATETIME      DEFAULT (getdate()) NULL,
	[ModifiedDate]		   DATETIME		 NULL,
	[SourceID]			   VARCHAR (9)   NULL
);

