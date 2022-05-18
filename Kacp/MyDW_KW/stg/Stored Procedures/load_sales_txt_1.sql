CREATE procedure stg.load_sales_txt
as
--delete from stg.sales_txt
delete a
from stg.sales_txt a join stg.sales_txt_delta b
	on a.order_number = b.order_number

--truncate table stg.sales_txt
-- czyszczenie danych

insert into stg.sales_txt
(
	[order_number],
	[line_number] ,
	[date] ,
	[customer],
	[country] ,
	[product] ,
	[qty],
	[unit_price],
	[Timestamp],
	[Filename]
)
select 
	[order_number],
	[line_number] ,
	[date] ,
	[customer],
	[country] ,
	[product] ,
	[qty],
	[unit_price],
	getdate() as [Timestamp],
	'sales_txt' as [Filename]
from stg.sales_txt_delta