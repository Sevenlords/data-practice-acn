create procedure stg.LoadDimVendor
as

truncate table stg.dim_vendor

insert into stg.dim_vendor(
	sso.SalesPersonID,
	sso.TerritoryID,
	sso.orderdate,
	sso.CustomerID,
	ssp.SalesQuota,
	ssp.Bonus,
	ssp.CommissionPct,
	sc.StoreID,
	ss.Name,
	ss.Timestamp)


select 
	sso.SalesPersonID,
	sso.TerritoryID,
	sso.orderdate,
	sso.CustomerID,
	ssp.SalesQuota,
	ssp.Bonus,
	ssp.CommissionPct,
	sc.StoreID,
	ss.Name,
	ss.Timestamp

from 
	stg.sales_sales_orderheader sso 
	join stg.sales_sales_person ssp on sso.SalesPersonID = ssp.BusinessEntityID
	join stg.sales_customer sc on sc.customerid = sso.customerid
	join stg.sales_store ss on ss.BusinessEntityID = sc.StoreID 

where ssp.salesquota is not null