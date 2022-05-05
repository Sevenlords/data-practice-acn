


CREATE procedure [dbo].[loadFactResellerSales]
as


drop table if exists #resellerSales
declare @startDate datetime
select @startDate = ISNULL(max(timesthamp),'1900-01-01') from [dbo].[FactResellerSales] 


select SalesOrderID
into #resellerSales
from [stg].Sales_SalesOrderHeader a
WHERE OnlineOrderFlag = 1
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
	soh.SalesOrderNumber,
	sod.SalesOrderDetailID,
	date.DateKey,
	ress.ResellerKey,
	prod.ProductKey,
	sod.OrderQty,
	sod.UnitPrice,
	sod.OrderQty*sod.UnitPrice as ExtendedAmount,
	sod.UnitPriceDiscount,
	sod.OrderQty*sod.UnitPrice*sod.UnitPriceDiscount as DiscountAmount,
	prod.StandardCost,
	prod.StandardCost*sod.OrderQty as TotalProductCost,
	sod.OrderQty*sod.UnitPrice-sod.OrderQty*sod.UnitPrice*sod.UnitPriceDiscount as SalesAmount,
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
	on prod.ProductID=sod.ProductID



--z pliku


drop table if exists #sales

--select @startDate = ISNULL(max(timesthamp),'1900-01-01') from [dbo].[FactResellerSales] 


select 
	s.order_number,
	0 as salesordernumber,
	s.line_number,
	date.[DateKey],
	ress.[ResellerKey],
	prod.[ProductKey],
	s.[Qty],
	s.[Unit_Price],
	s.Qty*s.Unit_Price as ExtendedAmount,
	0 as UnitPriceDiscount,
	s.Qty*s.Unit_Price*0 as DiscountAmount,
	prod.StandardCost,
	prod.StandardCost*s.Qty as TotalProductCost,
	s.Qty*s.Unit_Price-s.Qty*s.Unit_Price*0 as SalesAmount
	into #sales
from 
	stg.sales_txt s
	join DimDate date
	on CONVERT(char(8),(s.date),112)=date.datekey
	--left join #sales sal on s.order_number=sal.order_number  
	join DimReseller ress
	on s.reseller=ress.ResellerAlternateKey
	join DimProduct prod
	on prod.ProductAlternateKey=s.product


--	delete a
--	from [FactInternetSales] a
--	join #Sales b on a.SalesOrderID = b.order_number

update a 
set [SalesOrderID]=B.order_number,
	[SalesOrderNumber]=0,
	[SalesOrderDetailID]=line_number,
	[DateKey]=CONVERT(char(8),(B.DateKey),112),
	[ResellerKey]=b.ResellerKey,
	[ProductKey]=b.ProductKey,
	[OrderQty]=b.qty,
	[UnitPrice]=b.unit_pricE,
	[ExtendedAmount]=b.unit_price*b.qty,
	[UnitPriceDiscount]=0,
	[DiscountAmount]=b.qty*b.unit_price,
	[StandardCost]=b.standardCost,
	[TotalProductCost]=b.standardCost*b.qty,
	[SalesAmount]=b.qty*b.unit_price-b.qty*b.unit_price*0,
	timesthamp=getdate(),
	SourceID='SALES_TXT'
from FactResellerSales a 
	join #sales b on a.SalesOrderID=b.order_number

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
	timesthamp,
	SourceID)
select 
	a.*, GETDATE(), 'SALES_TXT'
from #sales a
	left join FactResellerSales b on a.order_number=b.SalesOrderID
	where b.SalesOrderID is null
