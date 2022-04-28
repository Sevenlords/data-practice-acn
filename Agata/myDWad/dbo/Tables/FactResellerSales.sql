CREATE TABLE [dbo].[FactResellerSales] (
    [SalesOrderID]       INT           NOT NULL,
    [SalesOrderNumber]   NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID] INT           NOT NULL,
    [DateKey]            INT           NULL,
    [ResellerKey]        INT           NOT NULL,
    [ProductKey]         INT           NOT NULL,
    [OrderQty]           SMALLINT      NOT NULL,
    [UnitPrice]          MONEY         NOT NULL,
    [ExtendedAmount]     MONEY         NOT NULL,
    [UnitPriceDiscount]  MONEY         NULL,
    [DiscountAmount]     MONEY         NOT NULL,
    [StandardCost]       MONEY         NULL,
    [TotalProductCost]   MONEY         NOT NULL,
    [SalesAmount]        MONEY         NOT NULL,
    [timesthamp]         DATETIME      DEFAULT (getdate()) NULL
);

