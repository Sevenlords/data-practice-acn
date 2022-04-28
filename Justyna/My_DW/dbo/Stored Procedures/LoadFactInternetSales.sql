
CREATE PROCEDURE [dbo].[LoadFactInternetSales]
AS

TRUNCATE TABLE dbo.FactInternetSales

INSERT INTO  dbo.FactInternetSales([SalesOrderID]
	,[SalesOrderNumber]
	,[SalesOrderDetailID]
	,[DateKey]
	,[CustomerKey]
	,[ProductKey]
	,[OrderQty]
	,[UnitPrice]
	,[ExtendedAmout]
	,[UnitPriceDiscountPct]
	,[DiscountAmount]
	,[ProductStandartCost]
	,[TotalProductCost]
	,[SalesAmount])

SELECT
SOH.SalesOrderID,
SOH.SalesOrderNumber,
SOD.SalesOrderDetailID,
D.DateKey,
C.CustomerKey,
P.ProductKey,
SOD.OrderQty,
SOD.UnitPrice,
SOD.OrderQty*SOD.UnitPrice AS [ExtendedAmout],
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
JOIN dbo.DimCustomer C
ON SOH.CustomerID = C.CustomerID
JOIN dbo.DimProduct P
ON SOD.ProductID = P.ProductID
WHERE SOH.OnlineOrderFlag = 1