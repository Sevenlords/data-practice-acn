CREATE procedure [dbo].[LoadFactInternetSales]
as
declare @startDate datetime
select @startDate = ISNULL(max(ModifiedDate),'1900-01-01') from [dbo].[FactInternetSales] 

select SalesOrderID
into #orders
from [stg].Sales_SalesOrderHeader
WHERE OnlineOrderFlag = 1
	and timestamp >= @startDate

		delete a
	from [FactInternetSales] a
	join #orders b on a.SalesOrderID = b.SalesOrderID

insert into dbo.FactInternetSales
([SalesOrderID],
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
	[ModifiedDate])

SELECT   
	h.SalesOrderID as [SalesOrderID],
	h.SalesOrderNumber as [SalesOrderNumber],
	o.SalesOrderDetailID as [SalesOrderDetailID],
	d.DateKey as [DateKey],
	c.CustomerKey as [CustomerKey],
	p.ProductKey as [ProductKey],
	o.OrderQty as [OrderQuantity],
	o.UnitPrice as [UnitPrice],
	(o.OrderQty*o.UnitPrice) as [ExtendedAmount],
	o.UnitPriceDiscount*100 as [UnitPriceDiscountPct],
	((o.OrderQty*o.UnitPrice)*o.UnitPriceDiscount) as [DiscountAmount],
	p.Standardcost as [ProductStandardCost],
	(p.Standardcost*o.OrderQty) as [TotalProductCost],
	((o.OrderQty*o.UnitPrice)-((o.OrderQty*o.UnitPrice)*o.UnitPriceDiscount)) as [SalesAmount],
	Getdate() as [ModifiedDate]
	from
	[stg].[Sales_SalesOrderHeader] as h
	join [stg].Sales_SalesOrderDetail as o on h.SalesOrderID = o.SalesOrderID
	join #orders as od on h.SalesOrderID = od.SalesOrderID
	left join [MyDW].[dbo].DimProduct as p on p.ProductID = o.ProductID
	left join [MyDW].[dbo].DimCustomer c on c.CustomerID = h.CustomerID
	left join[MyDW].[dbo].DimDate as d on h.OrderDate = d.Date
	where h.OnlineOrderFlag=1