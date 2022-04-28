create procedure [dbo].[LoadDimReseller] as

truncate table [dbo].[dimReseller]

insert into [dbo].[dimReseller](
	[CustomerID],
	[ResellerAlternateKey],
	[ResellerName]
)

select --więcej niż jeden numer konta dla C.StoreID
	C.CustomerID [CustomerID], 
	C.AccountNumber [ResellerAlternateKey], 
	S.Name [ResellerName]
from stg.Sales_Customer C
join stg.Sales_Store S
on C.StoreID = S.BusinessEntityID