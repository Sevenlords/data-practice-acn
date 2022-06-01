









CREATE PROCEDURE [dbo].[LoadResellerSales]
as

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 1, @Comment = 'Start procedure'
BEGIN TRY
drop table if exists #resellersales

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
	CAST('AW' as varchar(25)) AS [SourceID],
	DP.ManufactoryId AS [ManufactoryID],
	DP.ManufactoryName AS [ManufactoryName],
	DP.DateFrom AS [DateFrom],
	DP.DateTo AS [DateTo],
	DP.CurrentRowIndicator AS [CurrentRowIndicator]
INTO #resellersales
FROM stg.Sales_SalesOrderHeader AS OH JOIN
	stg.Sales_SalesOrderDetail AS OD ON OH.SalesOrderID = OD.SalesOrderID
	JOIN dbo.DimReseller AS DR ON OH.CustomerID = DR.CustomerID
	JOIN dbo.DimProduct AS DP ON (DP.ProductID = OD.ProductID AND OH.OrderDate BETWEEN DP.DateFrom AND DP.DateTo)
	JOIN dbo.DimDate AS DD ON OH.OrderDate = DD.Date

INSERT INTO #resellersales
(
	[SalesOrderID],
	[SalesOrderDetailID],
	[SalesOrderNumber],
	[DateKey],
	[ResellerKey],
	[ProductKey],
	[OrderQuantity],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscountPct],
	[DiscountAmount],
	[ProductStandardCost],
	[TotalProductCost],
	[SalesAmount],
	[SourceID],
	[ManufactoryID],
	[ManufactoryName],
	[DateFrom],
	[DateTo],
	[CurrentRowIndicator]
)
SELECT
	st.order_number AS [SalesOrderID],
	-1 AS [SalesOrderNumber],
	-1 AS [SalesOrderDetailID],
	DD.DateKey AS [DateKey],
	DR.ResellerKey AS [ResellerKey],
	DP.ProductKey AS [ProductKey],
	-- DC.CurrencyKey AS [CurrencyKey],
	CAST(st.qty AS int) AS [OrderQuantity],
	CAST(REPLACE(st.unit_price, ',', '.') AS money) AS [UnitPrice],
	CAST(REPLACE(st.unit_price, ',', '.') AS money) * CAST(st.qty AS int) AS [ExtendedAmount],
	-1 AS [UnitPriceDiscountPct],
	-1 AS [DiscountAmount],
	DP.StandardCost AS [ProductStandardCost],
	(DP.StandardCost* CAST(REPLACE(st.unit_price, ',', '.') AS money) * CAST(st.qty AS int)) AS [TotalProductCost],
	-1 AS [SalesAmount],
	st.[Filename] AS [SourceID],
	-1 AS [ManufactoryID],
	'N/D' AS [ManufactoryName],
	'11111111' AS [DateFrom],
	'11111111' AS [DateTo],
	'N/D' AS [CurrentRowIndicator]

FROM stg.sales_txt AS st
	JOIN dbo.DimReseller AS DR ON st.customer = DR.ResellerAlternateKey
	JOIN dbo.DimProduct AS DP ON st.product = DP.ProductAlternateKey
	JOIN dbo.DimDate AS DD ON st.date = DD.Date

	--select * from #resellersales

MERGE INTO dbo.factResellerSales AS TARGET
USING #resellersales as SOURCE
ON TARGET.[SalesOrderDetailID] = SOURCE.[SalesOrderDetailID] AND SOURCE.[ManufactoryId] = TARGET.[ManufactoryId]
WHEN MATCHED AND TARGET.[SalesOrderID] <> SOURCE.[SalesOrderID]
	OR TARGET.[SalesOrderDetailID] <> SOURCE.[SalesOrderDetailID]
	OR TARGET.[SalesOrderNumber] <> SOURCE.[SalesOrderNumber]
	OR TARGET.[DateKey] <> SOURCE.[DateKey]
	OR TARGET.[ResellerKey] <> SOURCE.[ResellerKey]
	OR TARGET.[ProductKey] <> SOURCE.[ProductKey]
	OR TARGET.[OrderQuantity] <> SOURCE.[OrderQuantity]
	OR TARGET.[UnitPrice] <> SOURCE.[UnitPrice]
	OR TARGET.[ExtendedAmount] <> SOURCE.[ExtendedAmount]
	OR TARGET.[UnitPriceDiscountPct] <> SOURCE.[UnitPriceDiscountPct]
	OR TARGET.[DiscountAmount] <> SOURCE.[DiscountAmount]
	OR TARGET.[ProductStandardCost] <> SOURCE.[ProductStandardCost]
	OR TARGET.[TotalProductCost] <> SOURCE.[TotalProductCost]
	OR TARGET.[SalesAmount] <> SOURCE.[SalesAmount]
	OR TARGET.[SourceID] <> SOURCE.[SourceID]
	OR TARGET.[ManufactoryID] <> SOURCE.[ManufactoryID] OR SOURCE.[ManufactoryID] IS NULL
	OR TARGET.[ManufactoryName] <> SOURCE.[ManufactoryName] OR SOURCE.[ManufactoryName] IS NULL
	OR TARGET.[DateFrom] <> SOURCE.[DateFrom] OR SOURCE.[DateFrom] IS NULL
	OR TARGET.[DateTo] <> SOURCE.[DateTo] OR SOURCE.[DateTo] IS NULL
	OR TARGET.[CurrentRowIndicator] <> SOURCE.[CurrentRowIndicator] OR SOURCE.[CurrentRowIndicator] IS NULL

THEN UPDATE SET
	[SalesOrderID] = SOURCE.[SalesOrderID],
	[SalesOrderDetailID] = SOURCE.[SalesOrderDetailID],
	[SalesOrderNumber] = SOURCE.[SalesOrderNumber],
	[DateKey] = SOURCE.[DateKey],
	[ResellerKey] = SOURCE.[ResellerKey],
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
	[SourceID] = SOURCE.[SourceID],
	[ManufactoryID] = SOURCE.[ManufactoryID],
	[ManufactoryName] = SOURCE.[ManufactoryName],
	[DateFrom] = SOURCE.[DateFrom],
	[DateTo] = SOURCE.[DateTo],
	[CurrentRowIndicator] = SOURCE.[CurrentRowIndicator]
WHEN NOT MATCHED BY TARGET
THEN INSERT 
	(
	[SalesOrderID],
	[SalesOrderDetailID],
	[SalesOrderNumber],
	[DateKey],
	[ResellerKey],
	[ProductKey],
	[OrderQuantity],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscountPct],
	[DiscountAmount],
	[ProductStandardCost],
	[TotalProductCost],
	[SalesAmount],
	[SourceID],
	[CreatedDate],
	[ModifiedDate],
	[ManufactoryID],
	[ManufactoryName],
	[DateFrom],
	[DateTo],
	[CurrentRowIndicator]
	)
	VALUES
	(
	SOURCE.[SalesOrderID],
	SOURCE.[SalesOrderDetailID],
	SOURCE.[SalesOrderNumber],
	SOURCE.[DateKey],
	SOURCE.[ResellerKey],
	SOURCE.[ProductKey],
	SOURCE.[OrderQuantity],
	SOURCE.[UnitPrice],
	SOURCE.[ExtendedAmount],
	SOURCE.[UnitPriceDiscountPct],
	SOURCE.[DiscountAmount],
	SOURCE.[ProductStandardCost],
	SOURCE.[TotalProductCost],
	SOURCE.[SalesAmount],
	SOURCE.[SourceID],
	GETDATE(),
	GETDATE(),
	SOURCE.[ManufactoryID],
	SOURCE.[ManufactoryName],
	SOURCE.[DateFrom],
	SOURCE.[DateTo],
	SOURCE.[CurrentRowIndicator]
	)
	;

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step =99, @Comment = 'Finish procedure'

END TRY

BEGIN CATCH

EXEC [log].[ErrorCall] 

END CATCH
