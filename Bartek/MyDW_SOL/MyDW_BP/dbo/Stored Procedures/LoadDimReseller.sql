CREATE Procedure [dbo].[LoadDimReseller]

AS

--Truncate table DW.DimReseller
drop table if exists #Reseller

SELECT C.CustomerID AS [CustomerID], 
C.AccountNumber AS [ResellerAlternateKey],
ISNULL(S.Name, 'N\D') AS [ResellerName]
INTO #Reseller
From STG.Sales_Store S
RIGHT JOIN STG.Sales_Customer C
ON S.BusinessEntityID = C.StoreID

UPDATE a
SET
	[CustomerID] = b.CustomerID,
	[ResellerAlternateKey] = b.ResellerAlternateKey,
	[ResellerName] = b.ResellerName,
	ModifiedDate = GETDATE()
FROM DW.DimReseller a 
JOIN #Reseller b ON a.CustomerID= b.CustomerID

Insert INTO DW.[DimReseller](
	[CustomerID],
	[ResellerAlternateKey],
	[ResellerName],
	ModifiedDate,
	CreatedDate
) 

SELECT b.*,GETDATE(),GETDATE()
from DW.DimReseller a 
	Right join #Reseller b on a.CustomerID = b.CustomerID
where a.CustomerID is null 

--EXEC LoadDimReseller