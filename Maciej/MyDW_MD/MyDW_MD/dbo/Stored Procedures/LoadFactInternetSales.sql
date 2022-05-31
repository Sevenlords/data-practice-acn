CREATE procedure [dbo].[LoadFactInternetSales]
as

exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'

BEGIN TRY

declare @startDate datetime
select @startDate = ISNULL(max(ModifiedDate),'1900-01-01') from [dbo].[FactInternetSales] 


drop table if exists #orders

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
	isnull(h.SalesOrderNumber, -1) as [SalesOrderNumber],
	isnull(o.SalesOrderDetailID, -1) as [SalesOrderDetailID],
	isnull(d.DateKey, '1900-01-01') as [DateKey],
	isnull(c.CustomerKey, -1) as [CustomerKey],
	isnull(p.ProductKey, -1) as [ProductKey],
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

	update a
set a.productKey = b.productKey
from dbo.FactInternetSales a 
	join ( select h.SalesOrderID ,od.SalesOrderDetailID, p.ProductKey
			from [stg].[Sales_SalesOrderHeader] h
				left join [stg].[Sales_SalesOrderDetail] od on h.SalesOrderID = od.SalesOrderID
				left join DimProduct p on od.ProductID = p.ProductID and h.OrderDate between p.datefrom and p.dateto
			where h.OnlineOrderFlag = 1) b
				on a.SalesOrderID = b.SalesOrderID and a.SalesOrderDetailID = b.salesorderdetailid
where a.ProductKey <> b.ProductKey

exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'

END TRY

BEGIN CATCH 

exec [log].[ErrorCall] 
end catch