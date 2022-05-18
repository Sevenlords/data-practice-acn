




CREATE procedure [dbo].[LoadFactInternetSales]
as

drop table if exists #orders

declare @startDate datetime 
select @startDate= isnull(max(Timeshtamp), '1900-01-01') from  dbo.FactInternetSales

select SalesOrderID
into #orders
from stg.Sales_SalesOrderHeader
where OnlineOrderFlag=1
	and timeshtamp>=@startDate


	delete a
	from FactInternetSales a 
	join #orders b on a.SalesOrderID=b.SalesOrderID


insert into dbo.FactInternetSales (
	[SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[dateKey],
	[CustomerKey],
	[ProductKey],
	[OrderQty],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscount],
	[DiscountAmount],
	[StandardCost],
	[TotalProductCost],
	[SalesAmount])
select 
	soh.SalesOrderID,
	soh.SalesOrderNumber,
	sod.SalesOrderDetailID,
	date.dateKey,
	cust.CustomerKey,
	prod.ProductKey,
	sod.OrderQty,
	sod.UnitPrice,
	sod.UnitPrice*sod.OrderQty as [ExtendedAmount],
	sod.UnitPriceDiscount,
	(sod.UnitPrice*sod.OrderQty)*sod.UnitPriceDiscount as [DiscountAmount],
	prod.StandardCost,
	prod.StandardCost*sod.OrderQty as [TotalProductCost],
	(sod.UnitPrice*sod.OrderQty)-((sod.UnitPrice*sod.OrderQty)*sod.UnitPriceDiscount) as SalesAmount
from stg.Sales_SalesOrderHeader soh
	join stg.Sales_SalesOrderDetail sod
	on soh.SalesOrderID=sod.SalesOrderID
	join #orders o on soh.SalesOrderID=o.SalesOrderID
	left join dbo.dimDate date
	on CONVERT(char(8),(soh.OrderDate),112)=date.datekey
	left join dbo.DimCustomer cust
	on cust.CustomerID=soh.CustomerID
	left join dbo.DimProduct as prod
	on sod.ProductID=prod.ProductID and soh.OrderDate between prod.datefrom and prod.dateto
where soh.OnlineOrderFlag=1
