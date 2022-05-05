CREATE PROCEDURE [stg].[LoadSalesTXT]
AS
BEGIN
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
		,[filename] = 'sales_01'
	FROM [stg].[SalesTXT_Delta]
END