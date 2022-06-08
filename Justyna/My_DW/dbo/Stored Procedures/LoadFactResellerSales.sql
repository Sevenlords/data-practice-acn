CREATE PROCEDURE [dbo].[LoadFactResellerSales]
AS

EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 1, @Comment = 'Start Proc'

BEGIN TRY
	--TRUNCATE TABLE dbo.FactResellerSales
	--last modified date in FactResellerSales AW
	DECLARE @startDate datetime
	SELECT @startDate = ISNULL(MAX(Timestamp),'1900-01-01') 
	FROM [dbo].[FactResellerSales] 
	WHERE SourceID = 'AW'

	--updated and new rows
	SELECT SalesOrderID
	INTO #resellersales
	FROM [stg].[Sales_SalesOrderHeader]
	WHERE Timestamp >= @startDate

	--delete rows before update
	DELETE a
	FROM [dbo].[FactResellerSales] a
	JOIN #resellersales b 
	ON a.SalesOrderID = b.SalesOrderID

	INSERT INTO  dbo.FactResellerSales([SalesOrderID],
		[SalesOrderNumber],
		[SalesOrderDetailID],
		[DateKey],
		[ResellerKey],
		[ProductKey],
		[OrderQty],
		[UnitPrice],
		[ExtendedAmount],
		[UnitPriceDiscountPct],
		[DiscountAmount],
		[ProductStandartCost],
		[TotalProductCost],
		[SalesAmount],
		[SourceID])
	SELECT
		SOH.SalesOrderID,
		SOH.SalesOrderNumber,
		SOD.SalesOrderDetailID,
		ISNULL(D.DateKey, 19000101),
		ISNULL(R.ResellerKey, -1),
		ISNULL(P.ProductKey, -1),
		SOD.OrderQty,
		SOD.UnitPrice,
		SOD.OrderQty*SOD.UnitPrice AS [ExtendedAmount],
		SOD.UnitPriceDiscount AS [UnitPriceDiscountPct],
		SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount AS [DiscountAmount],
		P.StandartCost AS [ProductStandartCost],
		P.StandartCost*SOD.OrderQty AS [TotalProductCost],
		SOD.OrderQty*SOD.UnitPrice-SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount AS [SalesAmount],
		'AW' AS [SourceID]
	FROM stg.Sales_SalesOrderHeader SOH
	JOIN stg.Sales_SalesOrderDetail SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
	JOIN #resellersales RS
	ON SOH.SalesOrderID = RS.SalesOrderID
	LEFT JOIN dbo.DimDate D
	ON SOH.OrderDate = D.Date
	JOIN dbo.DimReseller R
	ON SOH.CustomerID = R.CustomerID
	JOIN dbo.DimProduct P
	ON SOD.ProductID = P.ProductID AND SOH.OrderDate BETWEEN P.DateFrom AND P.DateTo


	--last modified date in FactResellerSales SALES_TXT
	DECLARE @startDate2 datetime
	SELECT @startDate2 = ISNULL(MAX(Timestamp),'1900-01-01') 
	FROM [dbo].[FactResellerSales] 
	WHERE SourceID = 'SALES_TXT'

	--updated and new rows
	SELECT Order_number, Line_number
	INTO #resellersales2
	FROM [stg].[SalesTXT]
	WHERE Timestamp >= @startDate2

	--delete rows before update
	DELETE a
	FROM [dbo].[FactResellerSales] a
	JOIN #resellersales2 b 
	ON a.SalesOrderID = b.Order_number

	INSERT INTO  dbo.FactResellerSales([SalesOrderID],
		[SalesOrderNumber],
		[SalesOrderDetailID],
		[DateKey],
		[ResellerKey],
		[ProductKey],
		[OrderQty],
		[UnitPrice],
		[ExtendedAmount],
		[UnitPriceDiscountPct],
		[DiscountAmount],
		[ProductStandartCost],
		[TotalProductCost],
		[SalesAmount],
		[SourceID])
	SELECT STXT.order_number,
			'0',
			STXT.line_number,
			ISNULL(D.DateKey, 19000101),
			ISNULL(R.ResellerKey, -1),
			ISNULL(P.ProductKey, -1),
			STXT.qty,
			CAST(REPLACE(STXT.unit_price, ',','.') AS money),
			CAST(STXT.qty AS INT)*CAST(REPLACE(STXT.unit_price, ',','.') AS money) AS [ExtendedAmount],
			0 AS [UnitPriceDiscountPct],
			0 AS [DiscountAmount],
			P.StandartCost AS [ProductStandartCost],
			P.StandartCost*CAST(STXT.qty AS INT) AS [TotalProductCost],
			CAST(STXT.qty AS INT)*CAST(REPLACE(STXT.unit_price, ',','.') AS money) AS [SalesAmount],
			'SALES_TXT' AS [SourceID]
	FROM stg.SalesTXT STXT
	JOIN dbo.DimReseller R
	ON STXT.reseller = R.ResellerAlternateKey
	JOIN #resellersales2 RS2
	ON STXT.Order_number = RS2.Order_number AND STXT.Line_number = RS2.Line_number
	LEFT JOIN dbo.DimDate D
	ON TRY_CONVERT(datetime, STXT.Date, CASE WHEN STXT.Date LIKE '[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9]' THEN 104
											 WHEN STXT.Date LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' THEN 121
									END) = D.Date
	JOIN DimProduct P
	ON STXT.product = P.ProductAlternateKey AND D.Date BETWEEN P.DateFrom AND P.DateTo

	UPDATE FRS
	SET FRS.ProductKey = B.ProductKey
	FROM [dbo].[FactResellerSales] FRS
		JOIN (SELECT SOH.SalesOrderID, SalesOrderDetailID, dP.ProductKey
			  FROM [stg].[Sales_SalesOrderHeader] AS SOH
				  LEFT JOIN [stg].[Sales_SalesOrderDetail] AS SOD
				  ON SOH.SalesOrderID = SOD.SalesOrderID
				  LEFT JOIN [dbo].[DimProduct] AS dP
				  ON dP.ProductID = SOD.ProductID AND SOH.OrderDate BETWEEN dP.DateFrom AND dP.DateTo) B
		ON FRS.SalesOrderID  = B.SalesOrderID AND FRS.SalesOrderDetailID = B.SalesOrderDetailID
	WHERE FRS.PRoductKey <> B.ProductKey

	EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 999, @Comment = 'End Proc'
END TRY

BEGIN CATCH
	EXEC [log].[ErrorCall]
END CATCH