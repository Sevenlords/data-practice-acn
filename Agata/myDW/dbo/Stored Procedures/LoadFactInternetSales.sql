


CREATE procedure [dbo].[LoadFactInternetSales]
as
truncate table dbo.FactInternetSales

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
	left join dbo.dimDate date
	on CONVERT(char(8),(soh.OrderDate),112)=date.datekey
	join dbo.DimCustomer cust
	on cust.CustomerID=soh.CustomerID
	left join dbo.DimProduct as prod
	on sod.ProductID=prod.ProductID
where soh.OnlineOrderFlag=1
