


CREATE procedure [dbo].[LoadFactResellerSales]
as

truncate table [dbo].[FactResellerSales]

insert into [dbo].[FactResellerSales](
	[SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[DateKey],
	[ResellerKey] ,
	[ProductKey],
	[OrderQty] ,
	[UnitPrice] ,
	[ExtendedAmount],
	[UnitPriceDiscount],
	[DiscountAmount] ,
	[ProductStandardCost] ,
	[TotalProductCost],
	[SalesAmount]) 

select soh.SalesOrderID
,soh.SalesOrderNumber
,sod.SalesOrderDetailID
,dd.DateKey
,dr.ResellerKey
,dp.ProductKey
,sod.OrderQty
,sod.UnitPrice
,sod.OrderQty*sod.UnitPrice as ExtendedAmount
,sod.UnitPriceDiscount
,(sod.OrderQty*sod.UnitPrice)*sod.UnitPriceDiscount as DiscountAmount
,dp.StandardCost as ProductStandardCost
,dp.StandardCost*sod.OrderQty as TotalProductCost
,sod.OrderQty*sod.UnitPrice-((sod.OrderQty*sod.UnitPrice)*sod.UnitPriceDiscount) as SalesAmount
from STG.Sales_SalesOrderDetail sod 
join STG.Sales_SalesOrderHeader soh on sod.SalesOrderID=soh.SalesOrderID 
join dbo.DimDate dd on sod.ModifiedDate=dd.Date
join dbo.DimProduct dp on dp.ProductID=sod.ProductID
join dbo.DimReseller dr on dr.CustomerID=soh.CustomerID


exec loadfactResellerSales


