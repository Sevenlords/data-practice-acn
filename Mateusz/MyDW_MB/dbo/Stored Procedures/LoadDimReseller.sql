

create procedure [dbo].[LoadDimReseller]
as

truncate table dbo.DimReseller

INSERT INTO [dbo].[DimReseller]
           ([CustomerID],
			[ResellerAlternateKey],
			[ResellerName])


select 
c.CustomerID
,c.AccountNumber ResellerAlternateKey
,s.Name ResellerName
from [STG].[Sales_Store] s 
join [STG].[Sales_Customer] c on s.BusinessEntityID=c.StoreID

