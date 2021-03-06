



CREATE procedure [dbo].[loadFactResellerSales]
as
BEGIN TRY
exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=1, @Comment='Start Proc'


drop table if exists #resellerSales
declare @startDate datetime
select @startDate = ISNULL(max(timesthamp),'1900-01-01') from [dbo].[FactResellerSales] 


select SalesOrderID
into #resellerSales
from [stg].Sales_SalesOrderHeader a
WHERE OnlineOrderFlag = 0
	and timeshtamp >= @startDate


	delete a
	from [FactInternetSales] a
	join #resellerSales b on a.SalesOrderID = b.SalesOrderID



insert into dbo.FactResellerSales(
	[SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[DateKey],
	[ResellerKey],
	[ProductKey],
	[OrderQty],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscount],
	[DiscountAmount],
	[StandardCost],
	[TotalProductCost],
	[SalesAmount],
	[SourceID])
select 
	soh.SalesOrderID,
	isnull(soh.SalesOrderNumber,-1),
	isnull(sod.SalesOrderDetailID,-1),
	isnull(date.DateKey, 19000101),
	isnull(ress.ResellerKey,-1),
	isnull(prod.ProductKey,-1),
	sod.OrderQty,
	sod.UnitPrice,
	isnull(sod.OrderQty*sod.UnitPrice,0.0) as ExtendedAmount,
	sod.UnitPriceDiscount,
	isnull(sod.OrderQty*sod.UnitPrice*sod.UnitPriceDiscount,0.0) as DiscountAmount,
	prod.StandardCost,
	isnull(prod.StandardCost*sod.OrderQty,0.0),
	isnull(sod.OrderQty*sod.UnitPrice-sod.OrderQty*sod.UnitPrice*sod.UnitPriceDiscount, 0.0) as SalesAmount,
	'AW'
from 
	stg.Sales_SalesOrderDetail sod
	join stg.Sales_SalesOrderHeader soh
	join #resellerSales r on soh.SalesOrderID=r.SalesOrderID
	on sod.SalesOrderID=soh.SalesOrderID
	left JOIN DimDate date
	on CONVERT(char(8),(soh.OrderDate),112)=date.datekey
	left join DimReseller ress
	on soh.CustomerID=ress.CustomerID
	left join DimProduct prod
	on prod.ProductID=sod.ProductID and soh.OrderDate between prod.datefrom and prod.dateto
	where SOH.OnlineOrderFlag = 0


--z pliku
--declare @startDate datetime
select @startDate = ISNULL(max([Timesthamp]),'1900-01-01') from [dbo].[factResellerSales] where [SourceID]='SALES_TXT'

	drop table if exists #salesRS

	select distinct order_number
	into #salesRS
	from [stg].[Sales_txt]
	where [timesthamp] >= @startDate

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
		[OrderQty],
		[UnitPrice],
		[ExtendedAmount],
		[UnitPriceDiscount],
		[DiscountAmount],
		[StandardCost],
		[TotalProductCost],
		[SalesAmount],
		timesthamp,
		SourceID)
	select
		ST.order_number [SalesOrderID],
		0 [SalesOrderNumber],
		isnull(ST.line_number,-1) [SalesOrderDetailID],
		isnull(D.DateKey, 19000101) [DateKey],
		isnull(R.ResellerKey,-1) [ResellerKey],
		isnull(P.ProductKey,-1) [ProductKey],
		ST.qty  [OrderQuantity],
		ST.unit_price [UnitPrice],
		isnull(ST.qty*ST.unit_price, 0.0) [ExtendedAmount],
		0 [UnitPriceDiscountPct],
		0 [DiscountAmount],
		P.StandardCost [ProductStandardCost],
		isnull(ST.qty *P.StandardCost, 0.00) [TotalProductCost],
		isnull(ST.qty*ST.unit_price,0.0) [SalesAmount],
		getdate() timesthamp,
		'SALES_TXT' [SourceID]
	from [stg].[Sales_txt] ST
	join #salesRS on ST.order_number = #salesRS.order_number
	join [dbo].[dimReseller] R on ST.reseller = R.ResellerAlternateKey
	left join [dbo].[dimProduct] P on ST.product = P.ProductAlternateKey
	left join [dbo].[dimDate] D on IIF(charindex('-',ST.date)=0, convert(datetime, ST.date ,104), convert(datetime, ST.date)) = D.Date

--drop table if exists #sales
--declare @startDate2 datetime
--select @startDate2 = ISNULL(max(timesthamp),'1900-01-01') from [dbo].[FactResellerSales] 


--select 
--	s.order_number,
--	0 as salesordernumber,
--	s.line_number,
--	date.[DateKey],
--	ress.[ResellerKey],
--	prod.[ProductKey],
--	s.[Qty],
--	s.[Unit_Price],
--	s.Qty*s.Unit_Price as ExtendedAmount,
--	0 as UnitPriceDiscount,
--	s.Qty*s.Unit_Price*0 as DiscountAmount,
--	prod.StandardCost,
--	prod.StandardCost*s.Qty as TotalProductCost,
--	s.Qty*s.Unit_Price-s.Qty*s.Unit_Price*0 as SalesAmount
--	into #sales
--from 
--	stg.sales_txt s
--	join DimDate date
--	on CONVERT(char(8),(s.date),112)=date.datekey
--	join DimReseller ress
--	on s.reseller=ress.ResellerAlternateKey
--	join DimProduct prod
--	on prod.ProductAlternateKey=s.product and s.date between prod.datefrom and prod.dateto
--where	s.[timesthamp] >= @startDate2 



--insert into dbo.FactResellerSales(
--	[SalesOrderID],
--	[SalesOrderNumber],
--	[SalesOrderDetailID],
--	[DateKey],
--	[ResellerKey],
--	[ProductKey],
--	[OrderQty],
--	[UnitPrice],
--	[ExtendedAmount],
--	[UnitPriceDiscount],
--	[DiscountAmount],
--	[StandardCost],
--	[TotalProductCost],
--	[SalesAmount],
--	timesthamp,
--	SourceID)
--select *,  GETDATE(), 'SALES_TXT'
--from #sales a
--	--join DimReseller dr on a.reseller = dr.ResellerAlternateKey
--	--join DimDate dd on dd.Date = a.date
--	--join DimProduct dp on a.product = dp.ProductAlternateKey

	update FACT
	set FACT.ProductKey = b.ProductKey
	from [dbo].[factInternetSales] FACT
	join (
		select SOH.SalesOrderID, SOD.SalesOrderDetailID, P.ProductKey
		from stg.Sales_SalesOrderHeader SOH
		left join stg.Sales_SalesOrderDetail SOD on SOH.SalesOrderID = SOD.SalesOrderID
		left join dbo.dimProduct P on SOD.ProductID = P.ProductID and SOH.OrderDate between P.DateFrom and P.DateTo
		where SOH.OnlineOrderFlag = 0
	) b on FACT.SalesOrderID = b.SalesOrderID and FACT.SalesOrderDetailID = b.SalesOrderDetailID
	where FACT.ProductKey != b.ProductKey


	exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=999, @Comment='End Proc'
	END TRY
BEGIN CATCH

declare @ErrorNumber int = (select ERROR_NUMBER())
declare @ErrorState int = (select ERROR_STATE())
declare @ErrorSeverity int = (select ERROR_SEVERITY())
declare @ErrorLine int = (select ERROR_LINE())
declare @ErrorProcedure varchar(max) = (select ERROR_PROCEDURE())
declare @ErrorMessage varchar(max) = (select ERROR_MESSAGE())

exec log.ErrorCall @ErrorNumber,@ErrorState,@ErrorSeverity,@ErrorLine, @ErrorProcedure,@ErrorMessage


END CATCH
