CREATE PROCEDURE [stg].[LoadSalesTXT]
AS
BEGIN

EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 1, @Comment = 'Start Proc'

	DELETE a
	FROM [stg].[SalesTXT] a
	JOIN [stg].[SalesTXT_Delta] b 
	ON a.Order_number = b.Order_number

	INSERT INTO [stg].[SalesTXT]
	SELECT  [order_number]
		,[line_number]
		,[date]
		,[reseller]
		,[country]
		,[product]
		,[qty]
		,[unit_price]
		,[timestamp]
		,[filename]
	FROM [stg].[SalesTXT_Delta]
	
EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 999, @Comment = 'End Proc'
END