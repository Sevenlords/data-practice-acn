﻿CREATE procedure [dbo].[LoadFactInternetSales] as

	--truncate table [dbo].[factInternetSales]

	declare @startDate datetime
	select @startDate = ISNULL(max([Timestamp]),'1900-01-01') from [dbo].[factInternetSales]

	drop table if exists #salesI

	select SalesOrderID
	into #salesI
	from [stg].[Sales_SalesOrderHeader] SOH
	where
	OnlineOrderFlag = 1 and [Timestamp]>=@startDate

	--select * from #salesI

	delete a
	from [dbo].[factInternetSales] a
	join #salesI b on a.SalesOrderID = b.SalesOrderID
	
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
		[SalesAmount],
		[Timestamp])
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
		SOD.OrderQty*SOD.UnitPrice - SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount [SalesAmount],
		getdate() [Timestamp]
	from stg.Sales_SalesOrderHeader SOH
	join stg.Sales_SalesOrderDetail SOD	on SOH.SalesOrderID = SOD.SalesOrderID
	join #salesI on SOH.SalesOrderID = #salesI.SalesOrderID
	left join dbo.dimDate D	on cast(SOH.OrderDate as date) = D.Date
	join dbo.dimCustomer C	on SOH.CustomerID = C.CustomerID
	left join dbo.dimProduct P on SOD.ProductID = P.ProductID and SOH.OrderDate between P.DateFrom and P.DateTo
	where SOH.OnlineOrderFlag = 1
