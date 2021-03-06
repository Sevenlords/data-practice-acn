alter procedure dw.load_fact_ResellerSales
as

declare @startDate datetime
select @startDate = ISNULL(max([ModifiedDate]),'1900-01-01') from dw.fact_ResellerSales

drop table if exists #saless

select SalesOrderID
into #saless
from stg.sales_sales_orderheader SOH
where
	OnlineOrderFlag = 0 and SOH.[Timestamp] >= @startDate


	delete a
	from dw.fact_ResellerSales a
	join #saless b on a.SalesOrderID = b.SalesOrderID

insert into dw.fact_ResellerSales
(
	SalesOrderID,
	SalesOrderNumber,
	SalesOrderDetailID,
	datekey,
	ResellerKey, 
	ProductKey,
	--currencyKey,
	OrderQty,
	UnitPrice,
	ExtendedAmount,
	UnitPriceDiscount,
	DiscountAmount,
	StandardCost,
	TotalProductCost,
	SalesAmount,
	CreatedDate,
	ModifiedDate,
	SourceID
)
select
	oh.SalesOrderID,
	oh.SalesOrderNumber,
	od.SalesOrderDetailID,
	d.datekey,
	re.ResellerKey, 
	p.ProductKey,
	--cn.currencyKey,
	od.OrderQty,
	od.UnitPrice,
	(od.OrderQty * od.UnitPrice) as ExtendedAmount,
	od.UnitPriceDiscount,
	((od.OrderQty * od.UnitPrice)* od.UnitPriceDiscount) as DiscountAmount,
	p.StandardCost,
	(p.StandardCost * od.OrderQty) as TotalProductCost,
	((od.OrderQty * od.UnitPrice) - ((od.OrderQty * od.UnitPrice)* od.UnitPriceDiscount)) as SalesAmount,
	re.CreatedDate as CreatedDate,
	getdate()  as ModifiedDate,
	'DW' as SourceID
from
	[AdventureWorks2017].[Sales].[SalesOrderHeader] AS oh
	join [AdventureWorks2017].[Sales].[SalesOrderDetail] AS od on  oh.SalesOrderID = od.SalesOrderID -- ADW?
	join #saless o on oh.SalesOrderID = o.SalesOrderID

	left join dw.dim_product p on p.ProductID = od.ProductID
	left join dw.dim_date d on d.Date = oh.OrderDate
--	left join dw.dim_customer cu on cu.CustomerID = oh.CustomerID
	left join dw.dim_reseller re on re.CustomerID = oh.CustomerID
WHERE OH.OnlineOrderFlag = 0


----LOAD FROM SALES_TXT
drop table if exists #salestxt

select *
into #salestxt
from stg.sales_txt st
where
	st.[Timestamp] >= @startDate and 
	st.filename = 'sales_txt'

	delete a
	from dw.fact_ResellerSales a
	join #salestxt st on a.SalesOrderID = st.order_number


insert into dw.fact_ResellerSales
(
	SalesOrderID,
	SalesOrderNumber,
	SalesOrderDetailID, 
	DateKey,
	ProductKey,
	ResellerKey, 
	--CurrencyKey,
	OrderQty,
	UnitPrice, 
	ExtendedAmount, 
	UnitPriceDiscount, 
	DiscountAmount, 
	StandardCost, 
	TotalProductCost, 
	SalesAmount, 
	CreatedDate,
	ModifiedDate,
	SourceID
)
select
	cast(st.order_number as int) SalesOrderID,
	0 as SalesOrderNumber,
	cast(st.line_number as int) SalesOrderDetailID,
	dd.DateKey, 
	dr.ResellerKey, 
	dp.ProductKey,
	st.qty as OrderQty,
	st.unit_price as Unit_Price,
	st.qty * st.unit_price as ExtendedAmount,
	0 as UnitPriceDiscount,
	0 as DiscountAmount,
	dp.StandardCost as StandardCost,
	dp.StandardCost * st.qty as TotalProductCost,
	((st.qty * st.unit_price) - (0*0)) as SalesAmount,
	st.Timestamp as CreatedDate,
	getdate() ModifiedDate,
	st.Filename as SourceID

from
	#salestxt st
	join dw.dim_reseller dr on st.customer = dr.ResellerAlternateKey
	join dw.dim_date dd on dd.Date = st.date
	join dw.dim_product dp on st.product = dp.ProductAlternateKey



-- exec dw.load_fact_ResellerSales
-- exec stg.load_sales_txt
-- 
-- select * from dw.fact_ResellerSales
-- select * from stg.sales_txt_delta
-- 
-- delete from dw.fact_ResellerSales
-- delete from stg.sales_txt

-- OLD

--truncate table dw.fact_ResellerSales
--
--insert into dw.fact_ResellerSales
--(
--	SalesOrderID,
--	SalesOrderNumber,
--	SalesOrderDetailID,
--	datekey, -- distinct date as uid in dim_date
--	ResellerKey, 
--	ProductKey,
--	currencyKey,
--	OrderQty,
--	UnitPrice,
--	ExtendedAmount,
--	UnitPriceDiscount,
--	DiscountAmount,
--	StandardCost,
--	TotalProductCost,
--	SalesAmount,
--	CreatedDate
--	CurrentDate
--)
--select
--	oh.SalesOrderID,
--	oh.SalesOrderNumber,
--	od.SalesOrderDetailID,
--	d.datekey, -- distinct date as uid in dim_date
--	re.ResellerKey, 
--	p.ProductKey,
--	cn.currencyKey,
--	od.OrderQty,
--	od.UnitPrice,
--	(od.OrderQty * od.UnitPrice) as ExtendedAmount,
--	od.UnitPriceDiscount,
--	((od.OrderQty * od.UnitPrice)* od.UnitPriceDiscount) as DiscountAmount,
--	p.StandardCost,
--	(p.StandardCost * od.OrderQty) as TotalProductCost,
--	((od.OrderQty * od.UnitPrice) - ((od.OrderQty * od.UnitPrice)* od.UnitPriceDiscount)) as SalesAmount,
--	getdate() Timestamp-- as CreatedDate-- p.ok?
----	getdate() as CurrentDate
----into dw.fact_ResellerSales
--
--from
--	stg.sales_sales_orderheader oh
--	join stg.sales_sales_orderdetail od on  oh.SalesOrderID = od.SalesOrderID
--	join dw.dim_product p on p.ProductID = od.ProductID
--	join dw.dim_date d on d.Date = oh.OrderDate
--	join dw.dim_reseller re on re.CustomerID = oh.CustomerID
--	left join dw.dim_currency_new cn on oh.CurrencyRateID = cn.currencyrateid
--
----LOAD FROM SALES_TXT
--insert into dw.fact_ResellerSales
--(
--	SalesOrderID, --> Orderheader lub sales_txt_delta
--	SalesOrderNumber, --> N/D
--	SalesOrderDetailID, --> N/D ?
--	DateKey,
--	ProductKey,
--	ResellerKey, -- OK
--	CurrencyKey, -- later
--	OrderQty, --> sales_txt
--	UnitPrice, --> sales_txt
--	ExtendedAmount, --> sales_txt calculate
--	UnitPriceDiscount, --> 0
--	DiscountAmount, --> 0
--	StandardCost, --> dp.product
--	TotalProductCost, -- calculate or 0
--	SalesAmount, -- calculate
--	timestamp 
--)
--
--select 
--	null AS SalesOrderID,
--	null as SalesOrderNumber,
--	null as SalesOrderDetailID,
--	dd.DateKey, 
--	dr.ResellerKey, 
--	dp.ProductKey,
--	null as CurrencyKey,
--	st.qty as OrderQty,
--	st.unit_price as Unit_Price,
--	st.qty * st.unit_price as ExtendedAmount,
--	0 as UnitPriceDiscount,
--	0 as DiscountAmount,
--	dp.StandardCost as StandardCost,
--	dp.StandardCost * st.qty as TotalProductCost,
--	((st.qty * st.unit_price) - (0*0)) as SalesAmount,
--	getdate() Timestamp
--from
--	stg.sales_txt st
--	join dw.dim_reseller dr on st.customer = dr.ResellerAlternateKey -- ResellerKey
--	left join dw.dim_date dd on dd.Date = st.date
--	join dw.dim_product dp on st.product = dp.ProductAlternateKey