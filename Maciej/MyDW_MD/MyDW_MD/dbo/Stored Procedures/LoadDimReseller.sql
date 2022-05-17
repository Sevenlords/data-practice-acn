CREATE procedure [dbo].[LoadDimReseller]
as

drop table if exists #reseller


SELECT   
	c.CustomerID AS [CustomerID],
	c.AccountNumber AS [ResellerAlternateKey],
	s.Name AS [ResellerName]
	into #reseller
FROM [AdventureWorks2017].[Sales].[Customer] AS c
	JOIN [AdventureWorks2017].[Sales].[Store] as s on s.BusinessEntityID = c.StoreID


update a
set [CustomerID] = b.[CustomerID]
      ,[ResellerAlternateKey] = b.[ResellerAlternateKey]
      ,[ResellerName] = b.[ResellerName]
	  ,[ModifiedDate] = Getdate()
from DimReseller a
	join #reseller b on a.CustomerID = b.CustomerID

	insert into dbo.DimReseller
([CustomerID]
      ,[ResellerAlternateKey]
      ,[ResellerName]
      ,[CreatedDate]
	  ,[ModifiedDate])

	  select a.*, getdate(), getdate()
	  from #reseller a
	  left join DimReseller b on a.CustomerID = b.CustomerID
	  where b.CustomerID is null 

delete a
from DimReseller a 
	left join #reseller b on a.CustomerID = b.CustomerID
where b.CustomerID is null