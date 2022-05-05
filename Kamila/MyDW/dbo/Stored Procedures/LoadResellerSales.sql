





CREATE PROCEDURE [dbo].[LoadResellerSales]
as

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
	CAST('AW' as varchar(20)) AS [SourceID]
INTO #resellersales
FROM stg.Sales_SalesOrderHeader AS OH JOIN
	stg.Sales_SalesOrderDetail AS OD ON OH.SalesOrderID = OD.SalesOrderID
	JOIN dbo.DimReseller AS DR ON OH.CustomerID = DR.CustomerID
	JOIN dbo.DimProduct AS DP ON DP.ProductID = OD.ProductID
	--JOIN dbo.DimCurrency AS DC ON DC.
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
	[SourceID]
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
	'SALES_TXT' AS [SourceID]

FROM stg.sales_txt AS st
	JOIN dbo.DimReseller AS DR ON st.customer = DR.ResellerAlternateKey
	JOIN dbo.DimProduct AS DP ON st.product = DP.ProductAlternateKey
	JOIN dbo.DimDate AS DD ON CONVERT(datetime, st.date, 104) = DD.Date


MERGE INTO dbo.factResellerSales AS TARGET
USING #resellersales as SOURCE
ON TARGET.[SalesOrderDetailID] = SOURCE.[SalesOrderDetailID]
WHEN MATCHED
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
	[SourceID] = SOURCE.[SourceID]
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
	[ModifiedDate]
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
	GETDATE()
	)
	;
