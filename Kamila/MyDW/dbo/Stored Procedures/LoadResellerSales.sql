


CREATE PROCEDURE [dbo].[LoadResellerSales]
as

truncate table dbo.factResellerSales


INSERT INTO dbo.factResellerSales
(
	[SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[DateKey],
	[ResellerKey],
	[ProductKey],
	--[CurrencyKey],
	[OrderQuantity],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscountPct],
	[DiscountAmount],
	[ProductStandardCost],
	[TotalProductCost],
	[SalesAmount],
	[CreatedDate],
	[ModifiedDate]
)
SELECT
	OH.SalesOrderID AS [SalesOrderID],
	OH.SalesOrderNumber AS [SalesOrderNumber],
	OD.SalesOrderDetailID AS [SalesOrderDetailID],
	DD.DateKey AS [DateKey],
	DR.ResellerKey AS [ResellerKey],
	DP.ProductKey AS [ProductKey],
	-- DC.CurrencyKey AS [CurrencyKey],
	OD.OrderQty AS [OrderQuantity],
	OD.UnitPrice AS [UnitPrice],
	OD.UnitPrice*OD.OrderQty AS [ExtendedAmount],
	OD.UnitPriceDiscount AS [UnitPriceDiscountPct],
	OD.UnitPriceDiscount*OD.UnitPrice*OD.OrderQty AS [DiscountAmount],
	DP.StandardCost AS [ProductStandardCost],
	DP.StandardCost*OD.UnitPrice*OD.OrderQty AS [TotalProductCost],
	OD.UnitPrice*OD.OrderQty-OD.UnitPriceDiscount*OD.UnitPrice*OD.OrderQty AS [SalesAmount],
	GETDATE() AS [CreatedDate],
	GETDATE() AS [ModifiedDate]

FROM stg.Sales_SalesOrderHeader AS OH JOIN
	stg.Sales_SalesOrderDetail AS OD ON OH.SalesOrderID = OD.SalesOrderID
	JOIN dbo.DimReseller AS DR ON OH.CustomerID = DR.CustomerID
	JOIN dbo.DimProduct AS DP ON DP.ProductID = OD.ProductID
	--JOIN dbo.DimCurrency AS DC ON DC.
	JOIN dbo.DimDate AS DD ON OH.OrderDate = DD.Date
