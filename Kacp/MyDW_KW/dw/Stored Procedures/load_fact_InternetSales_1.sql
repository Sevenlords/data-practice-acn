CREATE procedure [dw].[load_fact_InternetSales]
as

exec log.write_proc_call @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'

begin try

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

update a
set a.productKey = b.productKey
from dw.fact_InternetSales a 
	join ( select soh.SalesOrderID ,sod.SalesOrderDetailID, dp.ProductKey
			from stg.sales_sales_orderheader soh 
				left join stg.sales_sales_orderdetail sod on soh.SalesOrderID = sod.SalesOrderID
				left join dim_product dp on sod.ProductID = dp.ProductID and soh.OrderDate between dp.datefrom and dp.dateto
			where soh.OnlineOrderFlag = 1) b
				on a.SalesOrderID = b.SalesOrderID and a.SalesOrderDetailID = b.salesorderdetailid
where a.ProductKey <> b.ProductKey
--select * from dw.fact_internetsales

exec log.write_proc_call @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'

end try

begin catch
exec log.handle_error
end catch