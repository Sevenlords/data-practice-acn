
CREATE PROCEDURE [dbo].[LoadFactResellerSales]
AS

TRUNCATE TABLE dbo.FactResellerSales

INSERT INTO  dbo.FactResellerSales([SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[DateKey],
	[ResellerKey],
	[ProductKey],
	[OrderQty],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscountPct],
	[DiscountAmount],
	[ProductStandartCost],
	[TotalProductCost],
	[SalesAmount])

SELECT
	SOH.SalesOrderID,
	SOH.SalesOrderNumber,
	SOD.SalesOrderDetailID,
	D.DateKey,
	R.ResellerKey,
	P.ProductKey,
	SOD.OrderQty,
	SOD.UnitPrice,
	SOD.OrderQty*SOD.UnitPrice AS [ExtendedAmount],
	SOD.UnitPriceDiscount AS [UnitPriceDiscountPct],
	SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount AS [DiscountAmount],
	P.StandartCost AS [ProductStandartCost],
	P.StandartCost*SOD.OrderQty AS [TotalProductCost],
	SOD.OrderQty*SOD.UnitPrice-SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount AS [SalesAmount]
FROM stg.Sales_SalesOrderHeader SOH
JOIN stg.Sales_SalesOrderDetail SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN dbo.DimDate D
ON SOH.OrderDate = D.Date
JOIN dbo.DimReseller R
ON SOH.CustomerID = R.CustomerID
JOIN dbo.DimProduct P
ON SOD.ProductID = P.ProductID