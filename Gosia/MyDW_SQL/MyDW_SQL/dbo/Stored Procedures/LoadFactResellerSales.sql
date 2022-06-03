
CREATE procedure [dbo].[LoadFactResellerSales]
as

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 1, @Comment = 'Start proc'

BEGIN TRY

--truncate table dbo.FactResellerSales

DECLARE @StartDate datetime
SELECT @StartDate = ISNULL(max(ModifiedDate), '1900-01-01')
FROM [dbo].[FactResellerSales]

SELECT SalesOrderID
INTO #Orders
FROM [STG].[Sales_SalesOrderHeader]
WHERE OnlineOrderFlag = 0
AND timeshtamp >=@StartDate

DELETE a
FROM [FactResellerSales] a
JOIN #Orders b ON a.SalesOrderID = b.SalesOrderID

INSERT INTO [dbo].[FactResellerSales]
([SalesOrderID]
,[SalesOrderNumber]
,[SalesOrderDetailID]
,[DateKey]
,[ResellerKey]
,[ProductKey]
,[OrderQuantity]
,[UnitPrice]				
,[ExtendedAmount]
,[UnitPriceDiscountPct]	
,[DiscountAmount]
,[ProductStandardCost]
,[TotalProductCost]	
,[SalesAmount]
,[ModifiedDate]
)

SELECT 
	SOH.SalesOrderID							AS [SalesOrderID]
	,ISNULL(SOH.SalesOrderNumber, -1)			AS [SalesOrderNumber]
	,ISNULL(SOD.SalesOrderDetailID, -1)			AS [SalesOrderDetailID]
	,ISNULL(D.DateKey, 19000101)				AS [DateKey]
	,ISNULL(R.ResellerKey, -1)					AS [ResellerKey]
	,ISNULL(P.ProductKey, -1)					AS [ProductKey]
	,SOD.OrderQty								AS [OrderQuantity]
	,SOD.UnitPrice								AS [UnitPrice]
	,ISNULL((SOD.OrderQty)*(SOD.UnitPrice),(0))							
												AS [ExtendedAmount]
	,SOD.UnitPriceDiscount						AS [UnitPriceDiscountPct]
	,ISNULL((SOD.OrderQty)*(SOD.UnitPrice)*(SOD.UnitPriceDiscount),(0))	
												AS [DiscountAmount]
	,P.[StandardCost]							AS [ProductStandardCost]
	,ISNULL((P.StandardCost)*(SOD.OrderQty),(0))AS [TotalProductCost]
	,ISNULL(((SOD.OrderQty)*(SOD.UnitPrice)		   						
	- (SOD.OrderQty)*(SOD.UnitPrice)*(SOD.UnitPriceDiscount)),(0))		
												AS [SalesAmount]
	,getdate()									AS [ModifiedDate]


FROM 
[STG].[Sales_SalesOrderHeader] AS SOH 
JOIN [STG].[Sales_SalesOrderDetail] AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN #orders AS o ON SOH.SalesOrderID = o.SalesOrderID
LEFT JOIN DimDate AS D ON SOH.OrderDate = D.Date
LEFT JOIN DimReseller AS R ON SOH.CustomerID = R.CustomerID
LEFT JOIN dimProduct AS P ON SOD.ProductID = P.[ProductID]
AND SOH.OrderDate BETWEEN P.DateFrom AND P.DateTo
WHERE SOH.OnlineOrderFlag = 0 

UPDATE a
SET a.ProductKey = b.ProductKey
FROM [dbo].[FactResellerSales] a 
JOIN
(SELECT SOH.SalesOrderID, SalesOrderDetailID, P.ProductKey
FROM 
[STG].[Sales_SalesOrderHeader] AS SOH 
LEFT JOIN [STG].[Sales_SalesOrderDetail] AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN dimProduct AS P ON SOD.ProductID = P.[ProductID] AND SOH.OrderDate BETWEEN P.DateFrom AND P.DateTo
WHERE SOH.OnlineOrderFlag = 0 ) b 
ON a.SalesOrderID =b.SalesOrderID AND a.SalesOrderDetailID = b.SalesOrderDetailID 
WHERE a.ProductKey <> b.ProductKey

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 999, @Comment = 'End proc'

END TRY

BEGIN CATCH

EXEC [log].[ErrorCall] 

END CATCH

--SELECT * FROM FactResellerSales