CREATE procedure [dbo].[LoadSalesTxt]

as

 delete a
  from stg.sales_txt a
  join stg.sales_txt_delta b 
  on a.order_number=b.order_number

INSERT INTO [STG].[Sales_txt]
           ([order_number]
           ,[line_number]
           ,[date]
           ,[Customer]
           ,[country]
           ,[product]
           ,[qty]
           ,[unit_price]
		   ,timeshtamp
		   ,filename
           )
		   select [order_number]
           ,cast([line_number] as int) as line_number
           ,convert(datetime,[date],104) as date
           ,cast([Customer] as varchar(10)) as Customer
           ,[country]
           ,cast([product] as nvarchar(25)) as product
           ,cast([qty] as smallint) as qty
           ,parse(unit_price as money using 'de-DE') as unit_price
		   ,timeshtamp
		   ,'N/D'
		   from STG.Sales_txt_delta