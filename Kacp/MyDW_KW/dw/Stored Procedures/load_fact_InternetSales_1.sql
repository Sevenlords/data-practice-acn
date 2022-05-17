CREATE procedure [dw].[load_fact_InternetSales]
as

declare @startDate datetime
select @startDate = ISNULL(max([Timestamp]),'1900-01-01') from dw.fact_InternetSales

drop table if exists #orders

select SalesOrderID

into #orders

from stg.sales_sales_orderheader SOH

where
	OnlineOrderFlag = 1 and soh.[Timestamp] >= @startDate
--

	delete a
	from dw.fact_InternetSales a
	join #orders b on a.SalesOrderID = b.SalesOrderID
--

insert into dw.fact_internetsales
(
	oh.SalesOrderID, oh.SalesOrderNumber, od.SalesOrderDetailID,
	d.datekey, 
	cu.CustomerKey, 
	p.ProductKey,
--	CurrencyKey, 
	od.OrderQty, od.UnitPrice,
	ExtendedAmount,
	od.UnitPriceDiscount,
	DiscountAmount,
	p.StandardCost,
	TotalProductCost,
	SalesAmount,
	Timestamp
)
select-- p.datefrom, p.dateto, p.manufactoryname, p.manufactoryid, oh.OrderDate,
	oh.SalesOrderID,
	oh.SalesOrderNumber,
	od.SalesOrderDetailID,
	d.datekey, 
	cu.CustomerKey, 
	p.ProductKey,
--	cn.currencyKey as CurrencyKey, --dw.sales_currency_NEW
	od.OrderQty,
	od.UnitPrice,
	(od.OrderQty * od.UnitPrice) as ExtendedAmount,
	od.UnitPriceDiscount,
	((od.OrderQty * od.UnitPrice)* od.UnitPriceDiscount) as DiscountAmount,
	p.StandardCost,
	(p.StandardCost * od.OrderQty) as TotalProductCost,
	((od.OrderQty * od.UnitPrice) - ((od.OrderQty * od.UnitPrice)* od.UnitPriceDiscount)) as SalesAmount,
	getdate() Timestamp
from
	[AdventureWorks2017].[Sales].[SalesOrderHeader] AS oh
	join [AdventureWorks2017].[Sales].[SalesOrderDetail] AS od on  oh.SalesOrderID = od.SalesOrderID -- ADW?
	join #orders o on oh.SalesOrderID = o.SalesOrderID

	left join dw.dim_product p on p.ProductID = od.ProductID and oh.OrderDate between p.DateFrom and p.DateTo
	left join dw.dim_date d on d.Date = oh.OrderDate
	left join dw.dim_customer cu on cu.CustomerID = oh.CustomerID
WHERE  OH.OnlineOrderFlag = 1

--select * from dw.fact_internetsales