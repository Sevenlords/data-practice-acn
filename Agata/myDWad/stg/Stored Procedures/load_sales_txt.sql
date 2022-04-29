


  CREATE proc [stg].[load_sales_txt]
  as
  begin

  delete a
  from stg.sales_txt a
  join stg.sales_txt_delta b 
  on a.order_number=b.order_number

  insert into stg.sales_txt
  select 
	cast([order_number] as int)
      ,cast([line_number] as int)
      ,try_cast(date as datetime)
      ,cast([reseller] as varchar(10))
      ,[country]
      ,cast([product] as varchar(25))
      ,cast([qty] as smallint)
      ,cast([unit_price] as money)
      ,[timesthamp]
      ,[filename]
  from stg.sales_txt_delta

  end