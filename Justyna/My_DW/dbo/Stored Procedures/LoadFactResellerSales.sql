
ALTER PROCEDURE [dbo].[LoadFactResellerSales]
AS

--TRUNCATE TABLE dbo.FactResellerSales

DECLARE @startDate datetime
SELECT @startDate = ISNULL(MAX(ModifiedDate),'1900-01-01') 
FROM [dbo].[FactResellerSales] 


SELECT SalesOrderID
INTO #resellersales
FROM [stg].[Sales_SalesOrderHeader]
WHERE Timestamp >= @startDate


DELETE a
FROM [dbo].[FactResellerSales] a
JOIN #resellersales b 
ON a.SalesOrderID = b.SalesOrderID

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
	[SalesAmount],
	[ModifiedDate],
	[SourceID])

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
	SOD.OrderQty*SOD.UnitPrice-SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount AS [SalesAmount],
	GETDATE() AS [ModifiedDate],
	'AW' AS [SourceID]
FROM stg.Sales_SalesOrderHeader SOH
JOIN stg.Sales_SalesOrderDetail SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN dbo.DimDate D
ON SOH.OrderDate = D.Date
JOIN dbo.DimReseller R
ON SOH.CustomerID = R.CustomerID
JOIN dbo.DimProduct P
ON SOD.ProductID = P.ProductID
UNION
SELECT STXT.order_number,
		'0',
		STXT.line_number,
		D.DateKey,
		R.ResellerKey,
		P.ProductKey,
		STXT.qty,
		STXT.unit_price,
		CAST(STXT.qty AS INT)*CAST(STXT.unit_price AS money) AS [ExtendedAmount],
		0 AS [UnitPriceDiscountPct],
		0 AS [DiscountAmount],
		P.StandartCost AS [ProductStandartCost],
		P.StandartCost*CAST(STXT.qty AS INT) AS [TotalProductCost],
		0 AS [SalesAmount],
		GETDATE() AS [ModifiedDate],
		'SALES_TXT' AS [SourceID]
FROM stg.SalesTXT STXT
JOIN dbo.DimReseller R
ON STXT.reseller = R.ResellerAlternateKey
JOIN stg.Sales_SalesOrderDetail SOD
ON STXT.line_number = SOD.SalesOrderDetailID
LEFT JOIN stg.Sales_SalesOrderHeader SOH
ON STXT.order_number = SOH.SalesOrderID
JOIN dbo.DimDate D
ON CONVERT(datetime, STXT.date, 104) = D.Date
JOIN DimProduct P
ON STXT.product = P.ProductAlternateKey


