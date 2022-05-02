



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


INSERT INTO dbo.factResellerSales
(
	[SalesOrderID],
	--[SalesOrderNumber],
	--[SalesOrderDetailID],
	[DateKey],
	[ResellerKey],
	[ProductKey],
	--[CurrencyKey],
	[OrderQuantity],
	[UnitPrice],
	[ExtendedAmount],
	--[UnitPriceDiscountPct],
	--[DiscountAmount],
	[ProductStandardCost],
	[TotalProductCost],
	--[SalesAmount],
	[CreatedDate],
	[ModifiedDate]
)
SELECT
	st.order_number AS [SalesOrderID],
	--OH.SalesOrderNumber AS [SalesOrderNumber],
	--OD.SalesOrderDetailID AS [SalesOrderDetailID],
	DD.DateKey AS [DateKey],
	DR.ResellerKey AS [ResellerKey],
	DP.ProductKey AS [ProductKey],
	-- DC.CurrencyKey AS [CurrencyKey],
	CAST(st.qty AS int) AS [OrderQuantity],
	CAST(st.unit_price AS money)/1000  AS [UnitPrice],
	CAST(st.unit_price AS money)/1000  * CAST(st.qty AS int) AS [ExtendedAmount],
	--OD.UnitPriceDiscount AS [UnitPriceDiscountPct],
	--OD.UnitPriceDiscount*OD.UnitPrice*OD.OrderQty AS [DiscountAmount],
	DP.StandardCost AS [ProductStandardCost],
	(DP.StandardCost* CAST(st.unit_price AS money)/1000 * CAST(st.qty AS int)) AS [TotalProductCost],
	--OD.UnitPrice*OD.OrderQty-OD.UnitPriceDiscount*OD.UnitPrice*OD.OrderQty AS [SalesAmount],
	GETDATE() AS [CreatedDate],
	GETDATE() AS [ModifiedDate]

FROM stg.sales_txt AS st
	JOIN dbo.DimReseller AS DR ON st.customer = DR.ResellerAlternateKey
	JOIN dbo.DimProduct AS DP ON st.product = DP.ProductAlternateKey
	JOIN dbo.DimDate AS DD ON CONVERT(datetime, st.date, 104) = DD.Date
