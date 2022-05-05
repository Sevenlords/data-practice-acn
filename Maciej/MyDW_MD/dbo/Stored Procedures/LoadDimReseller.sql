CREATE procedure [dbo].[LoadDimReseller]
as

truncate table dbo.DimReseller

insert into dbo.DimReseller
([CustomerID]
      ,[ResellerAlternateKey]
      ,[ResellerName]
      )
SELECT   
	c.CustomerID AS [CustomerID],
	c.AccountNumber AS [ResellerAlternateKey],
	s.Name AS [ResellerName]
FROM [AdventureWorks2017].[Sales].[Customer] AS c
	JOIN [AdventureWorks2017].[Sales].[Store] as s on s.BusinessEntityID = c.StoreID