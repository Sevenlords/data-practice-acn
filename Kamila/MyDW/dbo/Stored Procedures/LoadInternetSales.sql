








CREATE PROCEDURE [dbo].[LoadInternetSales]
as

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 1, @Comment = 'Start procedure'

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
	GETDATE() AS [ModifiedDate],
	DP.ManufactoryId AS [ManufactoryID],
	DP.ManufactoryName AS [ManufactoryName],
	DP.DateFrom AS [DateFrom],
	DP.DateTo AS [DateTo],
	DP.CurrentRowIndicator AS [CurrentRowIndicator]
INTO #internetsales
FROM stg.Sales_SalesOrderHeader AS OH JOIN
	stg.Sales_SalesOrderDetail AS OD ON OH.SalesOrderID = OD.SalesOrderID
	INNER JOIN dbo.DimCustomer AS DC ON OH.CustomerID = DC.CustomerID
	INNER JOIN dbo.DimProduct AS DP ON (DP.ProductID = OD.ProductID AND OH.OrderDate BETWEEN DP.DateFrom AND DP.DateTo)
	JOIN dbo.DimDate AS DD ON OH.OrderDate = DD.Date
WHERE OH.OnlineOrderFlag = 1

MERGE INTO dbo.factInternetSales AS TARGET
USING #internetsales AS SOURCE
ON SOURCE.[SalesOrderDetailID] = TARGET.[SalesOrderDetailID] AND SOURCE.[ManufactoryId] = TARGET.[ManufactoryId]
WHEN MATCHED AND TARGET.[SalesOrderID] <> SOURCE.[SalesOrderID]
	OR TARGET.[SalesOrderDetailID] <> SOURCE.[SalesOrderDetailID]
	OR TARGET.[SalesOrderNumber] <> SOURCE.[SalesOrderNumber]
	OR TARGET.[DateKey] <> SOURCE.[DateKey]
	OR TARGET.[CustomerKey] <> SOURCE.[CustomerKey]
	OR TARGET.[ProductKey] <> SOURCE.[ProductKey]
	OR TARGET.[OrderQuantity] <> SOURCE.[OrderQuantity]
	OR TARGET.[UnitPrice] <> SOURCE.[UnitPrice]
	OR TARGET.[ExtendedAmount] <> SOURCE.[ExtendedAmount]
	OR TARGET.[UnitPriceDiscountPct] <> SOURCE.[UnitPriceDiscountPct]
	OR TARGET.[DiscountAmount] <> SOURCE.[DiscountAmount]
	OR TARGET.[ProductStandardCost] <> SOURCE.[ProductStandardCost]
	OR TARGET.[TotalProductCost] <> SOURCE.[TotalProductCost]
	OR TARGET.[SalesAmount] <> SOURCE.[SalesAmount]
	OR TARGET.[ManufactoryID] <> SOURCE.[ManufactoryID] OR SOURCE.[ManufactoryID] IS NULL
	OR TARGET.[ManufactoryName] <> SOURCE.[ManufactoryName] OR SOURCE.[ManufactoryName] IS NULL
	OR TARGET.[DateFrom] <> SOURCE.[DateFrom] OR SOURCE.[DateFrom] IS NULL
	OR TARGET.[DateTo] <> SOURCE.[DateTo] OR SOURCE.[DateTo] IS NULL
	OR TARGET.[CurrentRowIndicator] <> SOURCE.[CurrentRowIndicator] OR SOURCE.[CurrentRowIndicator] IS NULL
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
	[ModifiedDate] = GETDATE(),
	[ManufactoryID] = SOURCE.[ManufactoryID],
	[ManufactoryName] = SOURCE.[ManufactoryName],
	[DateFrom] = SOURCE.[DateFrom],
	[DateTo] = SOURCE.[DateTo],
	[CurrentRowIndicator] = SOURCE.[CurrentRowIndicator]
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
	[ModifiedDate],
	[ManufactoryID],
	[ManufactoryName],
	[DateFrom],
	[DateTo],
	[CurrentRowIndicator]
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
	GETDATE(),
	SOURCE.[ManufactoryID],
	SOURCE.[ManufactoryName],
	SOURCE.[DateFrom],
	SOURCE.[DateTo],
	SOURCE.[CurrentRowIndicator]
	);

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 99, @Comment = 'Finish procedure'
