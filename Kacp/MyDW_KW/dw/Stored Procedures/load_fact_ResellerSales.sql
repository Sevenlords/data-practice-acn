alter procedure dw.load_fact_ResellerSales
as

truncate table dw.fact_ResellerSales



insert into dw.fact_ResellerSales
(
	oh.SalesOrderID, oh.SalesOrderNumber, od.SalesOrderDetailID,
	d.datekey, -- distinct date as uid in dim_date
	re.ResellerKey, 
	p.ProductKey,
	cn.currencyKey,
	od.OrderQty,
	od.UnitPrice,
	ExtendedAmount,
	od.UnitPriceDiscount,
	DiscountAmount,
	p.StandardCost,
	TotalProductCost,
	SalesAmount,
	p.Timestamp
--	CreatedDate
--	CurrentDate
)
select
	oh.SalesOrderID,
	oh.SalesOrderNumber,
	od.SalesOrderDetailID,
	d.datekey, -- distinct date as uid in dim_date
	re.ResellerKey, 
	p.ProductKey,
	cn.currencyKey,
	od.OrderQty,
	od.UnitPrice,
	(od.OrderQty * od.UnitPrice) as ExtendedAmount,
	od.UnitPriceDiscount,
	((od.OrderQty * od.UnitPrice)* od.UnitPriceDiscount) as DiscountAmount,
	p.StandardCost,
	(p.StandardCost * od.OrderQty) as TotalProductCost,
	((od.OrderQty * od.UnitPrice) - ((od.OrderQty * od.UnitPrice)* od.UnitPriceDiscount)) as SalesAmount,
	p.Timestamp-- as CreatedDate-- p.ok?
--	getdate() as CurrentDate
--into dw.fact_ResellerSales

from
	stg.sales_sales_orderheader oh
	join stg.sales_sales_orderdetail od on  oh.SalesOrderID = od.SalesOrderID
	join dw.dim_product p on p.ProductID = od.ProductID
	join dw.dim_date d on d.Date = oh.OrderDate
	join dw.dim_reseller re on re.CustomerID = oh.CustomerID
	left join dw.dim_currency_new cn on oh.CurrencyRateID = cn.currencyrateid