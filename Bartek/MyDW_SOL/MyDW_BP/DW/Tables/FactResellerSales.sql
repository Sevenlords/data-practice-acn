CREATE TABLE [DW].[FactResellerSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NULL,
    [SalesOrderDetailID]   INT           NULL,
    [DateKey]              INT           NOT NULL,
    [ResellerKey]          INT           NULL,
    [ProductKey]           INT           NULL,
    [CurrencyKey]          INT           NULL,
    [OrderQuantity]        INT           NULL,
    [UnitPrice]            MONEY         NULL,
    [ExtendedAmount]       MONEY         NULL,
    [UnitPriceDiscountPct] MONEY         NULL,
    [DiscountAmount]       MONEY         NULL,
    [ProductStandartCost]  MONEY         NULL,
    [TotalProductCost]     MONEY         NULL,
    [SalesAmount]          MONEY         NULL,
    [TimeStamp]            DATETIME      DEFAULT (getdate()) NOT NULL
);


GO
  Create TRIGGER [DW].[ResselerSalesMD]
ON DW.FactResellerSales AFTER UPDATE
AS
BEGIN
    IF UPDATE( [SalesOrderID])
        RETURN
 
    UPDATE DW.FactResellerSales
        SET ModifiedDate = DEFAULT

	FROM DW.FactResellerSales
    JOIN Inserted
        ON DW.FactResellerSales.SalesOrderID = Inserted.SalesOrderID
END;
