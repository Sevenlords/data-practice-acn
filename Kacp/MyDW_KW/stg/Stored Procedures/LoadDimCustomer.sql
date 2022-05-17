
create procedure [stg].[LoadDimCustomer]
as

truncate table stg.dim_customer

insert into stg.dim_customer
	(
	pp.PersonType, Title, pp.FirstName, MiddleName, pp.LastName, pp.Timestamp, --pp.Suffix, 
	sc.CustomerID, sc.AccountNumber,
	pa.AddressLine1, pa.City, pa.StateProvinceID, pa.PostalCode,
	pe.EmailAddress,
	pph.PhoneNumber, pph.PhoneNumberTypeID 
	)


select 
	pp.PersonType, 
	ISNULL(pp.Title, 'N/D') Title, pp.FirstName, 
	ISNULL(pp.MiddleName, 'N/D') AS MiddleName, 
	pp.LastName, pp.Timestamp, --pp.Suffix, 
	sc.CustomerID, sc.AccountNumber, 
	pa.AddressLine1, pa.City, pa.StateProvinceID, pa.PostalCode,
	pe.EmailAddress,
	pph.PhoneNumber, pph.PhoneNumberTypeID--, pph.Timestamp


from
	stg.person_person pp 
	left join	stg.person_email pe		on pp.BusinessEntityID = pe.BusinessEntityID
	left join	stg.person_phone pph	on pp.BusinessEntityID = pph.BusinessEntityID
	join		stg.sales_customer sc	on pp.BusinessEntityID= sc.CustomerID
	join		stg.sales_sales_orderheader sso on sc.CustomerID = sso.CustomerID
	left join	stg.person_address pa	on pa.addressID = sso.ShipToAddressID