


CREATE PROCEDURE [dbo].[LoadDimReseller]
as

drop table if exists #reseller

SELECT
	SC.CustomerID AS [CustomerID],
	SC.AccountNumber AS [ResellerAlternateKey],
	SS.Name AS [ResellerName],
	GETDATE() as [CreatedDate],
	SC.Timestamp as [ModifiedDate]
INTO #reseller
FROM stg.Sales_Store AS SS
	JOIN stg.Sales_Customer AS SC
	ON SS.BusinessEntityID = SC.StoreID

MERGE INTO dbo.DimReseller AS TARGET
USING #reseller as SOURCE
ON TARGET.CustomerID = SOURCE.CustomerID
WHEN MATCHED
THEN UPDATE SET
	[CustomerID] = SOURCE.[CustomerID],
	[ResellerAlternateKey] = SOURCE.[ResellerAlternateKey],
	[ResellerName] = SOURCE.[ResellerName],
	[ModifiedDate] = GETDATE()
WHEN NOT MATCHED BY TARGET
THEN INSERT 
	(
	[CustomerID],
	[ResellerAlternateKey],
	[ResellerName],
	[CreatedDate],
	[ModifiedDate]
	)
	VALUES(
	SOURCE.[CustomerID],
	SOURCE.[ResellerAlternateKey],
	SOURCE.[ResellerName],
	GETDATE(),
	GETDATE()
	);
