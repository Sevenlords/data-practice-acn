





CREATE PROCEDURE [dbo].[LoadSalesTxt]
as

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 1, @Comment = 'Start procedure'

truncate table stg.sales_txt


UPDATE stg.sales_txt_delta
SET [date] = TRY_CONVERT(date, cast([date] as date), 104 )


INSERT INTO stg.sales_txt
(
	[order_number]
   ,[line_number]
   ,[date]
   ,[customer]
   ,[country]
   ,[product]
   ,[qty]
   ,[unit_price]
   ,[Filename]
   ,[timestamp]
)


SELECT
	[order_number]
   ,[line_number]
   ,[date]
   ,[customer]
   ,[country]
   ,[product]
   ,[qty]
   ,[unit_price]
   ,[filename]
   ,[timestamp]

FROM stg.sales_txt_delta

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 99, @Comment = 'Finish procedure'