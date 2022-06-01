CREATE procedure [dbo].[LoadFactInternetSales] as

	--truncate table [dbo].[factInternetSales]

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 1, @Comment = 'Start Proc'

	begin try
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
		isnull(D.DateKey,-1) [DateKey],
		isnull(C.CustomerKey,-1) [CustomerKey],
		isnull(P.ProductKey,-1) [ProductKey],
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

	-- update ProductKey
	update FIS
	set FIS.ProductKey = b.ProductKey
	from [dbo].[factInternetSales] FIS
	join (
		select SOH.SalesOrderID, SOD.SalesOrderDetailID, P.ProductKey
		from [stg].[Sales_SalesOrderHeader] SOH
		left join stg.Sales_SalesOrderDetail SOD on SOH.SalesOrderID = SOD.SalesOrderID
		left join dbo.dimProduct P on SOD.ProductID = P.ProductID and SOH.OrderDate between P.DateFrom and P.DateTo
		where SOH.OnlineOrderFlag = 1
	) b on FIS.SalesOrderID = b.SalesOrderID and FIS.SalesOrderDetailID = b.SalesOrderDetailID
	where FIS.ProductKey != b.ProductKey

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 999, @Comment = 'End Proc'

	end try

	begin catch
		exec [log].[ErrorCall]
	end catch
