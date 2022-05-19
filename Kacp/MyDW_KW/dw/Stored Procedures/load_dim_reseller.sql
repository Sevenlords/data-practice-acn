CREATE procedure [dw].[load_dim_reseller]
as

exec log.write_proc_call @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'

select	C.CustomerID [CustomerID], 
		C.AccountNumber [ResellerAlternateKey], 
		S.Name [ResellerName]

into #resellers

from stg.sales_customer C 
	join stg.sales_store S on C.StoreID = S.BusinessEntityID

---
update tab1
	set [CustomerID] = tab2.[CustomerID],
		[ResellerAlternateKey] = tab2.[ResellerAlternateKey],
		[ResellerName] = tab2.[ResellerName],
		[ModifiedDate] = getdate()
	from dw.dim_reseller tab1
	join #resellers tab2 on tab1.CustomerID = tab2.customerID	
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

exec log.write_proc_call @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'