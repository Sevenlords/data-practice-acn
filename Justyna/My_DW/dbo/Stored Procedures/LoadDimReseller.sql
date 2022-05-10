ALTER PROCEDURE [dbo].[LoadDimReseller]
AS

--TRUNCATE TABLE dbo.DimReseller
DROP TABLE IF EXISTS #reseller

SELECT   
	C.CustomerID AS [CustomerID],
	C.AccountNumber AS [ResellerAlternateKey],
	S.Name AS [ResellerName]
INTO #reseller
FROM [stg].[Sales_Store] AS S
JOIN [stg].[Sales_Customer] AS C
ON S.BusinessEntityID = C.StoreID

MERGE dbo.DimReseller AS dR
USING #reseller AS R
ON dR.CustomerID = R.CustomerID
WHEN MATCHED AND dR.ResellerAlternateKey <> R.ResellerAlternateKey
	OR dR.ResellerName <> R.ResellerName
THEN UPDATE SET 
    dR.ResellerAlternateKey = R.ResellerAlternateKey,
	dR.ResellerName = R.ResellerName,
	dR.ModifiedDate = GETDATE()

WHEN NOT MATCHED BY TARGET
THEN INSERT (
	[CustomerID],
	[ResellerAlternateKey],
	[ResellerName],
	[CreatedDate],
	[ModifiedDate])
VALUES (R.[CustomerID],
	R.[ResellerAlternateKey],
	R.[ResellerName],
	GETDATE(),
	GETDATE());
