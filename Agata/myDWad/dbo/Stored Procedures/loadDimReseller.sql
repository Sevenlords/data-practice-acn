
CREATE procedure [dbo].[loadDimReseller]
as

drop table if exists #reseller

select 
c.CustomerID,
c.AccountNumber as [ResellerAlternateKey],
s.Name as [ResellerName]
into #reseller
from stg.sales_store s
left join stg.Sales_customer c 
on c.StoreID=s.BusinessEntityID


update a 
set reselleralternatekey=b.reselleralternatekey,
	resellername=b.resellername,
	ModifiedDate = getdate()
from DimReseller a 
	join #reseller b on a.CustomerID=b.CustomerID

insert into DimReseller
	(CustomerID,
	reselleralternatekey,
	resellername,
	Timeshtamp,
	ModifiedDate)
select a.*, getdate(), getdate()
	from #reseller a 
	left join DimReseller b on a.CustomerID=b.CustomerID
	where b.CustomerID is null


