CREATE PROCEDURE [dbo].[LoadDimReseller]
AS

TRUNCATE TABLE dbo.DimReseller

INSERT INTO dbo.DimReseller
		([CustomerID],
		[ResellerAlternateKey],
		[ResellerName])
SELECT   
	C.CustomerID AS [CustomerID],
	C.AccountNumber AS [ResellerAlternateKey],
	S.Name AS [ResellerName]

FROM [stg].[Sales_Store] AS S
JOIN [stg].[Sales_Customer] AS C
ON S.BusinessEntityID = C.StoreID