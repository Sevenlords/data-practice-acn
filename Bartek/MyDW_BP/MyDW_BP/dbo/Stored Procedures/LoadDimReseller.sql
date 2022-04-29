CREATE Procedure [LoadDimReseller]

AS

Truncate table DW.DimReseller

Insert INTO DW.[DimReseller](
	[CustomerID],
	[ResellerAlternateKey],
	[ResellerName]
) 

SELECT C.CustomerID AS [CustomerID], 
C.AccountNumber AS [ResellerAlternateKey],
ISNULL(S.Name, 'N\D') AS [ResellerName]
From STG.Sales_Store S
RIGHT JOIN STG.Sales_Customer C
ON S.BusinessEntityID = C.StoreID