﻿
create procedure [dbo].[LoadDimInternetSales]
as
truncate table dbo.DimInternetSales

insert into dbo.DimInternetSales
([SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[DateKey],
	[CustomerKey],
	[ProductKey],
	[CurrencyKey],
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
	c.CustomerKey as [CustomerKey],
	p.ProductKey as [ProductKey],
	cr.CurrencyKey as [CurrencyKey],
	o.OrderQty as [OrderQuantity],
	o.UnitPrice as [UnitPrice],
	(o.OrderQty*o.UnitPrice) as [ExtendedAmount],
	o.UnitPriceDiscount as [UnitPriceDiscountPct],
	((o.OrderQty*o.UnitPrice)*o.UnitPriceDiscount) as [DiscountAmount],
	p.Standardcost as [ProductStandardCost],
	(p.Standardcost*o.OrderQty) as [TotalProductCost],
	((o.OrderQty*o.UnitPrice)-((o.OrderQty*o.UnitPrice)*o.UnitPriceDiscount)) as [SalesAmount]
	from
	[AdventureWorks2017].[Sales].[SalesOrderHeader] as h
	join [AdventureWorks2017].[Sales].[SalesOrderDetail] as o on h.SalesOrderID = o.SalesOrderID
	join [MyDW].[dbo].DimProduct as p on p.ProductID = o.ProductID
	join [MyDW].[dbo].DimCustomer c on c.CustomerID = h.CustomerID
	join [AdventureWorks2017].[Sales].[CurrencyRate] as cra on cra.CurrencyRateID = h.CurrencyRateID
	join [AdventureWorks2017].[Sales].[Currency] as cur on cur.CurrencyCode = cra.ToCurrencyCode
	join[MyDW].[dbo].DimCurrency as cr on cr.CurrencyAlternateKey = cur.CurrencyCode
	join[MyDW].[dbo].DimDate as d on h.OrderDate = d.Date