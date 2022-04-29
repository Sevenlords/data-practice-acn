create procedure [dbo].[LoadFactResellerSales]
as
truncate table dbo.FactResellerSales

insert into dbo.FactResellerSales
([SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[DateKey],
	[ResellerKey],
	[ProductKey],
	[OrderQuantity],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscountPct],
	[DiscountAmount],
	[ProductStandardCost],
	[TotalProductCost],
	[SalesAmount])

SELECT   
	h.SalesOrderID as [SalesOrderID],
	h.SalesOrderNumber as [SalesOrderNumber],
	o.SalesOrderDetailID as [SalesOrderDetailID],
	d.DateKey as [DateKey],
	r.ResellerKey as [ResellerKey],
	p.ProductKey as [ProductKey],
	o.OrderQty as [OrderQuantity],
	o.UnitPrice as [UnitPrice],
	(o.OrderQty*o.UnitPrice) as [ExtendedAmount],
	o.UnitPriceDiscount as [UnitPriceDiscountPct],
	((o.OrderQty*o.UnitPrice)*o.UnitPriceDiscount) as [DiscountAmount],
	p.Standardcost as [ProductStandardCost],
	(p.Standardcost*o.OrderQty) as [TotalProductCost],
	((o.OrderQty*o.UnitPrice)-((o.OrderQty*o.UnitPrice)*o.UnitPriceDiscount)) as [SalesAmount]
	from
	[stg].[Sales_SalesOrderHeader] as h
	join [stg].[Sales_SalesOrderDetail] as o on h.SalesOrderID = o.SalesOrderID
	join [MyDW].[dbo].DimProduct as p on p.ProductID = o.ProductID
	join [MyDW].[dbo].DimReseller as r on r.CustomerID = h.CustomerID
	join[MyDW].[dbo].DimDate as d on h.OrderDate = d.Date
	

exec [dbo].[LoadFactResellerSales]
