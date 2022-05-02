


CREATE PROCEDURE [dbo].[LoadSalesTxt]
as

truncate table stg.sales_txt

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
   ,[timestamp]

FROM stg.sales_txt_delta