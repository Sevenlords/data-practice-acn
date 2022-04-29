

CREATE procedure dbo.loadDimReseller
as
truncate table dbo.dimReseller

insert into dbo.DimReseller(
[CustomerID],
[ResellerAlternateKey],
[ResellerName] )
select 
c.CustomerID,
c.AccountNumber as [ResellerAlternateKey],
s.Name as [ResellerName]
from stg.sales_store s
left join stg.Sales_customer c 
on c.StoreID=s.BusinessEntityID

exec dbo.loadDimReseller


