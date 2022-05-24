
CREATE PROCEDURE [dbo].[LoadFactInternetSales]
AS
BEGIN

EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 1, @Comment = 'Start Proc'

BEGIN TRY
	--TRUNCATE TABLE dbo.FactInternetSales
	DECLARE @startDate datetime

	SELECT  @startDate = ISNULL(max(Timestamp),'1900-01-01') 
	FROM[dbo].[FactInternetSales] 

	SELECT SalesOrderID
	INTO #internet
	FROM [stg].[Sales_SalesOrderHeader]
	WHERE OnlineOrderFlag = 1
		AND Timestamp >= @startDate

	DELETE a
	FROM [dbo].[FactInternetSales] a
	JOIN #internet b 
	ON a.SalesOrderID = b.SalesOrderID

	INSERT INTO  dbo.FactInternetSales([SalesOrderID]
		,[SalesOrderNumber]
		,[SalesOrderDetailID]
		,[DateKey]
		,[CustomerKey]
		,[ProductKey]
		,[OrderQty]
		,[UnitPrice]
		,[ExtendedAmout]
		,[UnitPriceDiscountPct]
		,[DiscountAmount]
		,[ProductStandartCost]
		,[TotalProductCost]
		,[SalesAmount])

	SELECT
		SOH.SalesOrderID,
		SOH.SalesOrderNumber,
		SOD.SalesOrderDetailID,
		D.DateKey,
		C.CustomerKey,
		P.ProductKey,
		SOD.OrderQty,
		SOD.UnitPrice,
		SOD.OrderQty*SOD.UnitPrice AS [ExtendedAmout],
		SOD.UnitPriceDiscount AS [UnitPriceDiscountPct],
		SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount AS [DiscountAmount],
		P.StandartCost AS [ProductStandartCost],
		P.StandartCost*SOD.OrderQty AS [TotalProductCost],
		SOD.OrderQty*SOD.UnitPrice-SOD.OrderQty*SOD.UnitPrice*SOD.UnitPriceDiscount AS [SalesAmount]
	FROM stg.Sales_SalesOrderHeader SOH
	JOIN stg.Sales_SalesOrderDetail SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
	JOIN #internet I
	ON SOH.SalesOrderID = I.SalesOrderID
	LEFT JOIN dbo.DimDate D
	ON SOH.OrderDate = D.Date
	JOIN dbo.DimCustomer C
	ON SOH.CustomerID = C.CustomerID
	JOIN dbo.DimProduct P
	ON SOD.ProductID = P.ProductID AND SOH.OrderDate BETWEEN P.DateFrom AND P.DateTo
	WHERE SOH.OnlineOrderFlag = 1

	UPDATE FIS
	SET FIS.ProductKey = B.ProductKey
	FROM [dbo].[FactInternetSales] FIS
		JOIN (SELECT SOH.SalesOrderID, SalesOrderDetailID, dP.ProductKey
			  FROM [stg].[Sales_SalesOrderHeader] AS SOH
				  LEFT JOIN [stg].[Sales_SalesOrderDetail] AS SOD
				  ON SOH.SalesOrderID = SOD.SalesOrderID
				  LEFT JOIN [dbo].[DimProduct] AS dP
				  ON dP.ProductID = SOD.ProductID AND SOH.OrderDate BETWEEN dP.DateFrom AND dP.DateTo
			  WHERE SOH.OnlineOrderFlag = 1) B
		ON FIS.SalesOrderID  = B.SalesOrderID AND FIS.SalesOrderDetailID = B.SalesOrderDetailID
	WHERE FIS.PRoductKey <> B.ProductKey

	EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 999, @Comment = 'End Proc'
END TRY


BEGIN CATCH
	EXEC [log].[ErrorCall]
END CATCH
END