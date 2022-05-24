CREATE procedure [stg].[Load_sales_txt]
as
begin
exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'

drop table if exists #sales


	select [order_number]
      ,[line_number]
      ,[date]
      ,[customer]
      ,[country]
      ,[product]
      ,[qty]
      ,[unit_price]
      ,[timestamp]
      ,[filename]
into #sales
from [stg].[sales_txt_delta]

insert into [stg].[sales_txt]
([order_number]
      ,[line_number]
      ,[date]
      ,[customer]
      ,[country]
      ,[product]
      ,[qty]
      ,[unit_price]
      ,[timestamp]
      ,[filename])
	  SELECT a.*
from #sales a 
	left join stg.[sales_txt] b on b.order_number = a.order_number
where b.order_number is null 

update a 
set [order_number] = b.[order_number]
      ,[line_number] = b.[line_number]
      ,[date] = b.[date]
      ,[customer] = b.[customer]
      ,[country] = b.[country]
      ,[product] = b.[product]
      ,[qty] = b.[qty]
      ,[unit_price] = b.[unit_price]
      ,[timestamp] = b.[timestamp]
      ,[filename] = b. [filename]
from [stg].[sales_txt] a
join #sales b on a.order_number = b.order_number

delete a
from [stg].[sales_txt] a
join #sales b on a.order_number = b.order_number
where b.order_number is null

exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'

end