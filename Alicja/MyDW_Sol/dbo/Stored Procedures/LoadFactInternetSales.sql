CREATE procedure [dbo].[LoadFactInternetSales] as
	truncate table [dbo].[factInternetSales]
	insert into [dbo].[factInternetSales](
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
		[SalesAmount])
	select 
		SOH.SalesOrderID [SalesOrderID],
		SOH.SalesOrderNumber [SalesOrderNumber],
		SOD.SalesOrderDetailID [SalesOrderDetailID],
		D.DateKey [DateKey],
		C.CustomerKey [CustomerKey],
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
	join dbo.dimCustomer C
	on SOH.CustomerID = C.CustomerID
	join dbo.dimProduct P
	on SOD.ProductID = P.ProductID
	where SOH.OnlineOrderFlag = 1
