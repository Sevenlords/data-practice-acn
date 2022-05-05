



CREATE PROCEDURE [dbo].[LoadInternetSales]
as

drop table if exists #internetsales

SELECT
	OH.SalesOrderID AS [SalesOrderID],
	OH.SalesOrderNumber AS [SalesOrderNumber],
	OD.SalesOrderDetailID AS [SalesOrderDetailID],
	DD.DateKey AS [DateKey],
	DC.CustomerKey AS [CustomerKey],
	DP.ProductKey AS [ProductKey],
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
INTO #internetsales
FROM stg.Sales_SalesOrderHeader AS OH JOIN
	stg.Sales_SalesOrderDetail AS OD ON OH.SalesOrderID = OD.SalesOrderID
	INNER JOIN dbo.DimCustomer AS DC ON OH.CustomerID = DC.CustomerID
	INNER JOIN dbo.DimProduct AS DP ON DP.ProductID = OD.ProductID
	JOIN dbo.DimDate AS DD ON OH.OrderDate = DD.Date
WHERE OH.OnlineOrderFlag = 1

MERGE INTO dbo.factInternetSales AS TARGET
USING #internetsales AS SOURCE
ON SOURCE.SalesOrderDetailID = TARGET.SalesOrderDetailID
WHEN MATCHED
THEN UPDATE SET
	[SalesOrderID] = SOURCE.[SalesOrderID],
	[SalesOrderNumber] = SOURCE.[SalesOrderNumber],
	[SalesOrderDetailID] = SOURCE.[SalesOrderDetailID],
	[DateKey] = SOURCE.[DateKey],
	[CustomerKey] = SOURCE.[CustomerKey],
	[ProductKey] = SOURCE.[ProductKey],
	[OrderQuantity] = SOURCE.[OrderQuantity],
	[UnitPrice] = SOURCE.[UnitPrice],
	[ExtendedAmount] = SOURCE.[ExtendedAmount],
	[UnitPriceDiscountPct] = SOURCE.[UnitPriceDiscountPct],
	[DiscountAmount] = SOURCE.[DiscountAmount],
	[ProductStandardCost] = SOURCE.[ProductStandardCost],
	[TotalProductCost] = SOURCE.[TotalProductCost],
	[SalesAmount] = SOURCE.[SalesAmount],
	[ModifiedDate] = GETDATE()
WHEN NOT MATCHED BY TARGET
THEN INSERT
	(
	[SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[DateKey],
	[CustomerKey],
	[ProductKey],
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
	VALUES(
	SOURCE.[SalesOrderID],
	SOURCE.[SalesOrderNumber],
	SOURCE.[SalesOrderDetailID],
	SOURCE.[DateKey],
	SOURCE.[CustomerKey],
	SOURCE.[ProductKey],
	SOURCE.[OrderQuantity],
	SOURCE.[UnitPrice],
	SOURCE.[ExtendedAmount],
	SOURCE.[UnitPriceDiscountPct],
	SOURCE.[DiscountAmount],
	SOURCE.[ProductStandardCost],
	SOURCE.[TotalProductCost],
	SOURCE.[SalesAmount],
	GETDATE(),
	GETDATE()
	);
