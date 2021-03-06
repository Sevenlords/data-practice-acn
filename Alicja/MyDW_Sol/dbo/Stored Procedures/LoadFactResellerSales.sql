CREATE procedure [dbo].[LoadFactResellerSales] as

	--truncate table [dbo].[factResellerSales]

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 1, @Comment = 'Start Proc'

	begin try

	declare @startDate datetime
	select @startDate = ISNULL(max([Timestamp]),'1900-01-01') from [dbo].[factResellerSales] where [SourceID]='AW'

	drop table if exists #salesR

	select SalesOrderID
	into #salesR
	from [stg].[Sales_SalesOrderHeader]
	where
	OnlineOrderFlag = 0 and [Timestamp] >= @startDate

	--select * from #salesR

	delete a
	from [dbo].[factResellerSales] a
	join #salesR b on a.SalesOrderID = b.SalesOrderID

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
		[SalesAmount],
		[Timestamp],
		[SourceID])
	select 
		SOH.SalesOrderID [SalesOrderID],
		SOH.SalesOrderNumber [SalesOrderNumber],
		SOD.SalesOrderDetailID [SalesOrderDetailID],
		isnull(D.DateKey,-1) [DateKey],
		isnull(R.ResellerKey,-1) [ResellerKey],
		isnull(P.ProductKey,-1) [ProductKey],
		SOD.OrderQty [OrderQuantity],
		SOD.UnitPrice [UnitPrice],
		SOD.OrderQty*SOD.UnitPrice [ExtendedAmount],
		SOD.UnitPriceDiscount [UnitPriceDiscountPct],
		SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount [DiscountAmount],
		P.StandardCost [ProductStandardCost],
		P.StandardCost*SOD.OrderQty [TotalProductCost],
		SOD.OrderQty*SOD.UnitPrice - SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount [SalesAmount],
		getdate() [Timestamp],
		'AW' [SourceID]
	from stg.Sales_SalesOrderHeader SOH
	join stg.Sales_SalesOrderDetail SOD	on SOH.SalesOrderID = SOD.SalesOrderID
	join #salesR on SOH.SalesOrderID = #salesR.SalesOrderID
	join dbo.dimDate D	on cast(SOH.OrderDate as date) = D.Date
	left join dbo.dimReseller R	on SOH.CustomerID = R.CustomerID
	join dbo.dimProduct P on SOD.ProductID = P.ProductID and SOH.OrderDate between P.DateFrom and P.DateTo
	where SOH.OnlineOrderFlag = 0

	-- z sales_txt
	--declare @startDate datetime
	select @startDate = ISNULL(max([Timestamp]),'1900-01-01') from [dbo].[factResellerSales] where [SourceID]='SALES_TXT'

	drop table if exists #salesRS

	select distinct order_number
	into #salesRS
	from [stg].[Sales_txt]
	where [Timestamp] >= @startDate

	--select * from #salesRS

	delete a
	from [dbo].[factResellerSales] a
	join #salesRS b on a.SalesOrderID = b.order_number

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
		[SalesAmount],
		[SourceID])
	select
		cast(ST.order_number as int) [SalesOrderID],
		-1 [SalesOrderNumber],
		cast(ST.line_number as int) [SalesOrderDetailID],
		isnull(D.DateKey,-1) [DateKey],
		isnull(R.ResellerKey,-1) [ResellerKey],
		isnull(P.ProductKey,-1) [ProductKey],
		cast(ST.qty as int) [OrderQuantity],
		parse(ST.unit_price as money using 'de-DE') [UnitPrice],
		cast(ST.qty as int)*parse(ST.unit_price as money using 'de-DE') [ExtendedAmount],
		null [UnitPriceDiscountPct],
		null [DiscountAmount],
		P.StandardCost [ProductStandardCost],
		cast(ST.qty as int)*P.StandardCost [TotalProductCost],
		cast(ST.qty as int)*parse(ST.unit_price as money using 'de-DE') [SalesAmount],
		'SALES_TXT' [SourceID]
	from [stg].[Sales_txt] ST
	join #salesRS on ST.order_number = #salesRS.order_number
	join [dbo].[dimReseller] R on ST.customer = R.ResellerAlternateKey
	left join [dbo].[dimProduct] P on ST.product = P.ProductAlternateKey
	left join [dbo].[dimDate] D on IIF(charindex('-',ST.date)=0, convert(datetime, ST.date ,104), convert(datetime, ST.date)) = D.Date
	--where p.ProductKey=-1
	
	-- update ProductKey
	update FRS
	set FRS.ProductKey = b.ProductKey
	from [dbo].[factResellerSales] FRS
	join (
		select SOH.SalesOrderID, SOD.SalesOrderDetailID, P.ProductKey
		from [stg].[Sales_SalesOrderHeader] SOH
		left join stg.Sales_SalesOrderDetail SOD on SOH.SalesOrderID = SOD.SalesOrderID
		left join dbo.dimProduct P on SOD.ProductID = P.ProductID and SOH.OrderDate between P.DateFrom and P.DateTo
		where SOH.OnlineOrderFlag = 0
	) b on FRS.SalesOrderID = b.SalesOrderID and FRS.SalesOrderDetailID = b.SalesOrderDetailID
	where FRS.ProductKey != b.ProductKey
	
	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 999, @Comment = 'End Proc'

	end try

	begin catch
		exec [log].[ErrorCall]
	end catch
