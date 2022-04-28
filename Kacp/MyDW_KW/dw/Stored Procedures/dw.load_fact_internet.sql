use KW_DW
go

create procedure dw.load_fact_InternetSales
as

truncate table dw.fact_internetsales

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
	p.Timestamp
)

select 
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
	p.Timestamp -- ok?

from
	stg.sales_sales_orderheader oh
	join stg.sales_sales_orderdetail od on  oh.SalesOrderID = od.SalesOrderID
	join dw.dim_product p on p.ProductID = od.ProductID
	join dw.dim_date d on d.Date = oh.OrderDate
	join dw.dim_customer cu on cu.CustomerID = oh.CustomerID
--	left join dw.dim_currency_new cn on oh.CurrencyRateID = cn.currencyrateid

--select * from dw.dim_currency_new