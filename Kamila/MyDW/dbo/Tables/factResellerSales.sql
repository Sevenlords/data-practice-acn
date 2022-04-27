CREATE TABLE [dbo].[factResellerSales] (
    [SalesOrderID]         INT             NULL,
    [SalesOrderNumber]     NVARCHAR (20)   NULL,
    [SalesOrderDetailID]   INT             NULL,
    [DateKey]              INT             NULL,
    [ResellerKey]          INT             NULL,
    [ProductKey]           INT             NULL,
    [CurrencyKey]          INT             NULL,
    [OrderQuantity]        SMALLINT        NULL,
    [UnitPrice]            MONEY           NULL,
    [ExtendedAmount]       MONEY           NULL,
    [UnitPriceDiscountPct] NUMERIC (38, 6) NULL,
    [DiscountAmount]       MONEY           NULL,
    [ProductStandardCost]  MONEY           NULL,
    [TotalProductCost]     MONEY           NULL,
    [SalesAmount]          MONEY           NULL,
    [CreatedDate]          DATETIME        NULL,
    [ModifiedDate]         DATETIME        NULL
);

