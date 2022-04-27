 

CREATE PROCEDURE [dbo].[LoadFactInternetSales] 
AS

truncate table [dbo].[FactInternetSales]
 
	INSERT INTO [dbo].[FactInternetSales] (
	[SalesOrderID]
      ,[SalesOrderNumber]
      ,[SalesOrderDetailID]
      ,[DateKey]
      ,[CustomerKey]
      ,[ProductKey]
      ,[OrderQuantity]
      ,[UnitPrice]
      ,[ExtendedAmount]
      ,[UnitPriceDiscountPct]
      ,[DiscountAmount]
      ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      ,[TaxAmount]
      ,[ModifiedDate])
	SELECT	SOH.SalesOrderID AS [SalesOrderID],
			SOH.SalesOrderNumber AS [SalesOrderNumber],
			SOD.SalesOrderDetailID AS [SalesOrderDetailID],
			DD.DateKey AS [DateKey],
			DC.CustomerKey AS [CustomerKey],
			DP.ProductKey AS [ProductKey],
			SOD.OrderQty AS [OrderQuantity],
			SOD.UnitPrice AS [UnitPrice],
			(ISNULL(SOD.UnitPrice * SOD.OrderQty,(0.0))) AS [ExtendedAmount],
			SOD.UnitPriceDiscount * 100 AS [UnitPriceDiscountPct],
			(ISNULL((SOD.UnitPrice * SOD.OrderQty) * (SOD.UnitPriceDiscount),(0.0))) AS [DiscountAmount],
			DP.StandardCost AS [ProductStandardCost],
			(ISNULL(DP.StandardCost * SOD.OrderQty,(0.0))) AS [TotalProductCost],
			(ISNULL((SOD.UnitPrice * SOD.OrderQty)-((SOD.UnitPrice * SOD.OrderQty) * (SOD.UnitPriceDiscount)),(0.0))) AS [SalesAmount],
			(CAST(ISNULL((SOD.UnitPrice * SOD.OrderQty)-((SOD.UnitPrice * SOD.OrderQty) * (SOD.UnitPriceDiscount)),(0.0)) AS FLOAT) / SOH.Subtotal) * SOH.TaxAmt AS [TaxAmount],
			GETDATE() AS [ModifiedDate]
	FROM [AdventureWorks2017].[Sales].[SalesOrderHeader] AS SOH
	JOIN [AdventureWorks2017].[Sales].[SalesOrderDetail] AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
	LEFT JOIN DimDate AS DD ON SOH.OrderDate = DD.Date
	JOIN DimCustomer AS DC ON SOH.CustomerID = DC.CustomerID
	LEFT JOIN DimProduct AS DP ON SOD.ProductID = DP.ProductID 
	WHERE SOH.OnlineOrderFlag = 1

 
