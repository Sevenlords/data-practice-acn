CREATE procedure [dbo].[LoadFactResellerSales] as
	truncate table [dbo].[factResellerSales]
	insert into [dbo].[factResellerSales](
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
		[SalesAmount])
	select 
		SOH.SalesOrderID [SalesOrderID],
		SOH.SalesOrderNumber [SalesOrderNumber],
		SOD.SalesOrderDetailID [SalesOrderDetailID],
		D.DateKey [DateKey],
		R.ResellerKey [ResellerKey],
		P.ProductKey [ProductKey],
		SOD.OrderQty [OrderQuantity],
		SOD.UnitPrice [UnitPrice],
		SOD.OrderQty*SOD.UnitPrice [ExtendedAmount],
		SOD.UnitPriceDiscount [UnitPriceDiscountPct],
		SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount [DiscountAmount],
		P.StandardCost [ProductStandardCost],
		P.StandardCost*SOD.OrderQty [TotalProductCost],
		SOD.OrderQty*SOD.UnitPrice - SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount [SalesAmount]
	from stg.Sales_SalesOrderHeader SOH
	join stg.Sales_SalesOrderDetail SOD
	on SOH.SalesOrderID = SOD.SalesOrderID
	join dbo.dimDate D
	on cast(SOH.OrderDate as date) = D.Date
	left join dbo.dimReseller R
	on SOH.CustomerID = R.CustomerID
	join dbo.dimProduct P
	on SOD.ProductID = P.ProductID
	where SOH.OnlineOrderFlag = 0

	insert into [dbo].[factResellerSales](
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
		[SalesAmount])
	select
		cast(ST.order_number as int) [SalesOrderID],
		0 [SalesOrderNumber],
		cast(ST.line_number as int) [SalesOrderDetailID],
		D.DateKey [DateKey],
		R.ResellerKey [ResellerKey],
		P.ProductKey [ProductKey],
		cast(ST.qty as int) [OrderQuantity],
		parse(ST.unit_price as money using 'de-DE') [[UnitPrice],
		cast(ST.qty as int)*parse(ST.unit_price as money using 'de-DE') [ExtendedAmount],
		0 [UnitPriceDiscountPct],
		0 [DiscountAmount],
		P.StandardCost [ProductStandardCost],
		cast(ST.qty as int)*P.StandardCost [TotalProductCost],
		cast(ST.qty as int)*parse(ST.unit_price as money using 'de-DE') [SalesAmount]
	from [stg].[Sales_txt] ST
	join [dbo].[dimReseller] R on ST.customer = R.ResellerAlternateKey
	join [dbo].[dimProduct] P on ST.product = P.ProductAlternateKey
	join [dbo].[dimDate] D on convert(datetime, ST.date, 104) = D.Date
