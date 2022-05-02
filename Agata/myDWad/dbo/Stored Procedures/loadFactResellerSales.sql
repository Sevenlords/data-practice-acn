
CREATE procedure [dbo].[loadFactResellerSales]
as
truncate table dbo.FactResellerSales

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
	[SalesAmount])
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
	sod.OrderQty*sod.UnitPrice-sod.OrderQty*sod.UnitPrice*sod.UnitPriceDiscount as SalesAmount
from 
	stg.Sales_SalesOrderDetail sod
	join stg.Sales_SalesOrderHeader soh
	on sod.SalesOrderID=soh.SalesOrderID
	JOIN DimDate date
	on CONVERT(char(8),(soh.OrderDate),112)=date.datekey
	join DimReseller ress
	on soh.CustomerID=ress.CustomerID
	join DimProduct prod
	on prod.ProductID=sod.ProductID

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
	[SalesAmount])

select 
	s.order_number,
	0,
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



	from stg.sales_txt s
	join DimDate date
	on CONVERT(char(8),(s.date),112)=date.datekey
	join DimReseller ress
	on s.reseller=ress.ResellerAlternateKey
	join DimProduct prod
	on prod.ProductAlternateKey=s.product
