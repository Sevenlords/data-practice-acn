CREATE procedure dw.load_dim_reseller
as

drop table if exists #resellers

select	C.CustomerID [CustomerID], 
		C.AccountNumber [ResellerAlternateKey], 
		S.Name [ResellerName]

into #resellers

from stg.sales_customer C 
	join stg.sales_store S on C.StoreID = S.BusinessEntityID

---
update a
	set [CustomerID] = b.[CustomerID],
		[ResellerAlternateKey] = b.[ResellerAlternateKey],
		[ResellerName] = b.[ResellerName],
		[ModifiedDate] = getdate()
	from dw.dim_reseller a
	join #resellers b on a.CustomerID = b.customerID	
---
insert into dw.dim_reseller(
		[CustomerID],
		[ResellerAlternateKey],
		[ResellerName],
		[CreatedDate],
		[ModifiedDate])
select b.*, getdate(), getdate()
from dw.dim_reseller a
	right join #resellers b on a.CustomerID = b.CustomerID
where a.CustomerID is null



--truncate table dw.dim_reseller


--insert into dw.dim_reseller (
--	CustomerID,
--	ResellerAlternateKey,
--	ResellerName,
--	ModifiedDate -- how to insert data into specific column ? 
--	)
--select 
--	sc.CustomerID as CustomerID,
--	sc.AccountNumber as ResellerAlternateKey,
--	ss.Name as ResellerName,
--	ss.Timestamp as ModifiedDate
--from 
--	stg.sales_store ss
--	join stg.sales_customer sc on ss.BusinessEntityID = sc.storeID