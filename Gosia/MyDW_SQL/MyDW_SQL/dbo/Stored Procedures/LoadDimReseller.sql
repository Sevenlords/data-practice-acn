CREATE procedure [dbo].[LoadDimReseller]
as

--truncate table dbo.DimReseller
DROP TABLE IF EXISTS #reseller

SELECT   
	C.CustomerID		AS [CustomerID],
	C.AccountNumber		AS [ResellerAlternateKey],
	S.Name				AS [ResellerName]

INTO #reseller

FROM [AdventureWorks2017].[Sales].[Customer] AS C
	JOIN [AdventureWorks2017].[Sales].[Store] AS S
	ON C.StoreID = S.BusinessEntityID

UPDATE a
SET [CustomerID] = b.[CustomerID],
	[ResellerAlternateKey] = b.[ResellerAlternateKey],
	[ResellerName] = b.[ResellerName],
	[ModifiedDate] = getdate()

FROM DimReseller a JOIN #reseller b ON a.CustomerID = b.CustomerID

INSERT INTO [dbo].[DimReseller]
(	[CustomerID],
	[ResellerAlternateKey],
	[ResellerName],
	[CreatedDate],
	[ModifiedDate])

SELECT a.*, getdate(), getdate()  FROM #reseller a LEFT JOIN DimReseller b ON a.CustomerID = b.CustomerID WHERE b.CustomerID IS NULL

--SELECT * FROM DimReseller