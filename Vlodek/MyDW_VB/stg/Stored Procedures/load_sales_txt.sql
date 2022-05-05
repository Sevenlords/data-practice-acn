  CREATE procedure [stg].[load_sales_txt]
  as
  begin

  delete a
  from [stg].[sales_txt] a
  join [stg].[sales_txt_delta] b on a.order_number = b.order_number


  insert into [stg].[sales_txt]
  select [order_number]
      ,[line_number]
      ,[date]
      ,[customer]
      ,[country]
      ,[product]
      ,[qty]
      ,[unit_price]
      ,[timeshtamp]
      ,[filename]
  from [stg].[sales_txt_delta]

  end


  select * from [stg].[sales_txt]

    select * from [stg].[sales_txt_delta]