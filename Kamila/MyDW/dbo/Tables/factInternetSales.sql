CREATE TABLE [dbo].[factInternetSales] (
    [SalesOrderID]         INT             NULL,
    [SalesOrderNumber]     NVARCHAR (20)   NULL,
    [SalesOrderDetailID]   INT             NULL,
    [DateKey]              INT             NULL,
    [CustomerKey]          INT             NULL,
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

