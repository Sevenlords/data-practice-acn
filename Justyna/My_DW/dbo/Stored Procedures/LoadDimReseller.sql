USE [My_DW]
GO
/****** Object:  StoredProcedure [dbo].[LoadDimReseller]    Script Date: 5/10/2022 9:54:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LoadDimReseller]
AS
BEGIN
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

WHEN NOT MATCHED
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
END 
GO 

EXEC dbo.LoadDimReseller