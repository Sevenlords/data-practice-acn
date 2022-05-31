 CREATE proc [stg].[load_sales_txt]
  as
  BEGIN TRY
  exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=1, @Comment='Start Proc'

  begin

  delete a
  from stg.sales_txt a
  join stg.sales_txt_delta b 
  on a.order_number=b.order_number

  insert into stg.sales_txt
  select 
	   cast([order_number] as int)
      ,cast([line_number] as int)
      ,coalesce(try_convert(datetime, date, 104), convert(datetime, date))
      ,cast([reseller] as varchar(10))
      ,[country]
      ,cast([product] as varchar(25))
      ,cast([qty] as smallint)
      ,REPLACE(unit_price, ',', '.')
      ,[timesthamp]
      ,[filename]
  from stg.sales_txt_delta

  end

 exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=999, @Comment='End Proc'

 END TRY
BEGIN CATCH

declare @ErrorNumber int = (select ERROR_NUMBER())
declare @ErrorState int = (select ERROR_STATE())
declare @ErrorSeverity int = (select ERROR_SEVERITY())
declare @ErrorLine int = (select ERROR_LINE())
declare @ErrorProcedure varchar(max) = (select ERROR_PROCEDURE())
declare @ErrorMessage varchar(max) = (select ERROR_MESSAGE())

exec log.ErrorCall @ErrorNumber,@ErrorState,@ErrorSeverity,@ErrorLine, @ErrorProcedure,@ErrorMessage


END CATCH