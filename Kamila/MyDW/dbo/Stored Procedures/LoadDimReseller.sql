

CREATE PROCEDURE [dbo].[LoadDimReseller]
as

truncate table dbo.DimReseller

INSERT INTO dbo.DimReseller
(
	[CustomerID],
	[ResellerAlternateKey],
	[ResellerName],
	[CreatedDate],
	[ModifiedDate]
)


SELECT
	SC.CustomerID AS [CustomerID],
	SC.AccountNumber AS [ResellerAlternateKey],
	SS.Name AS [ResellerName],
	GETDATE() as [CreatedDate],
	SC.Timestamp as [ModifiedDate]

FROM stg.Sales_Store AS SS
	JOIN stg.Sales_Customer AS SC
	ON SS.BusinessEntityID = SC.StoreID
