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

--LOAD FROM SALES_TXT
insert into dw.fact_ResellerSales
(
	SalesOrderID, --> Orderheader lub sales_txt_delta
	SalesOrderNumber, --> N/D
	SalesOrderDetailID, --> N/D ?
	DateKey, -- OK
	ResellerKey, -- OK
	CurrencyKey, -- later
	OrderQty, --> sales_txt
	Unit_Price, --> sales_txt
	ExtendedAmount, --> sales_txt calculate
	UnitPriceDiscount, --> 0
	DiscountAmount, --> 0
	 StandardCost, --> dp.product
	TotalProductCost, -- calculate or 0
	SalesAmount, -- calculate
	timestamp 
)

select 
	'N/D' AS SalesOrderID,
	'N/D' as SalesOrderNumber,
	'N/D' as SalesOrderDetailID,
	dd.DateKey, 
	dr.ResellerKey, 
	dp.ProductKey,
	'N/D' as CurrencyKey,
	st.qty as OrderQty,
	st.unit_price as Unit_Price,
	st.qty * st.unit_price as ExtendedAmount,
	0 as UnitPriceDiscount,
	0 as DiscountAmount,
	dp.StandardCost as StandardCost,
	dp.StandardCost * st.qty as TotalProductCost,
	((st.qty * st.unit_price) - (0*0)) as SalesAmount,
	st.Timestamp
from
	stg.sales_txt st
	join dw.dim_reseller dr on st.customer = dr.ResellerAlternateKey -- ResellerKey
	left join dw.dim_date dd on dd.Date = st.date
	join dw.dim_product dp on st.product = dp.ProductAlternateKey