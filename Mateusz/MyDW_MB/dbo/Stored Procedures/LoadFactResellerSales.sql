



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


--LOAD FROM SALES_TXT

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

select sst.order_number
,'N/D'
,00000
,dd.DateKey
,dr.ResellerKey
,dp.ProductKey
,sst.qty
,sst.unit_price
,sst.qty*sst.unit_price as ExtendedAmount
,0.00
,(sst.qty*sst.unit_price)*0.00 as DiscountAmount
,dp.StandardCost as ProductStandardCost
,dp.StandardCost*sst.qty as TotalProductCost
,sst.qty*sst.unit_price-((sst.qty*sst.unit_price)*0.00) as SalesAmount
from STG.Sales_txt sst 
left join dbo.DimDate dd on sst.date=dd.Date
left join dbo.DimProduct dp on dp.ProductAlternateKey=sst.Product
left join dbo.DimReseller dr on dr.ResellerAlternateKey=sst.Customer


