CREATE procedure dw.load_dim_reseller
as

truncate table dw.dim_reseller


insert into dw.dim_reseller (
	CustomerID,
	ResellerAlternateKey,
	ResellerName,
	ModifiedDate -- how to insert data into specific column ? 
	)
select 
	sc.CustomerID as CustomerID,
	sc.AccountNumber as ResellerAlternateKey,
	ss.Name as ResellerName,
	ss.Timestamp as ModifiedDate
from 
	stg.sales_store ss
	join stg.sales_customer sc on ss.BusinessEntityID = sc.storeID