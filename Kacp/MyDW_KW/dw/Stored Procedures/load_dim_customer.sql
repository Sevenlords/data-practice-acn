
CREATE procedure [dw].[load_dim_customer]
as

insert into log.procedures (
	procedureName,
	Step,
	Comment
)
select
	object_name(@@PROCID), 1, 'Start Proc'


begin try

--drop table if exists #customers
drop table if exists dw.customers_temp

select
	isnull(SC.CustomerID, -1)	AS [CustomerID],
	isnull(SC.AccountNumber, 'unknown')		AS [CustomerAlternateKey],
	isnull(PP.PersonType, 'ND')			AS [PersonType],
	ISNULL(PP.Title, 'N/D') AS [Title],
	isnull(PP.FirstName, 'unknown')			AS [FirstName],
	ISNULL(PP.MiddleName, 'N/D') AS [MiddleName],
	isnull(PP.LastName, 'unknown')			AS [LastName],
	isnull(PP.NameStyle, -1)			AS [NameStyle],
	isnull(PP.EmailPromotion, -1)		AS [EmailPromotion],
	ISNULL(PP.Suffix, 'N/D') AS [Suffix],
	ISNULL(EA.EmailAddress, 'N/D') AS [EmailAddress],
	ISNULL(PPH.PhoneNumber, 'N/D') AS [PhoneNumber],
	cast(null as varbinary(30)) as HashCode

--into #customers
into dw.customers_temp

FROM stg.sales_customer AS SC
	JOIN stg.person_person AS PP
	ON SC.PersonID = PP.BusinessEntityID
	LEFT JOIN stg.person_email AS EA
	ON PP.BusinessEntityID = EA.BusinessEntityID
	LEFT JOIN stg.person_phone AS PPH
	ON PP.BusinessEntityID = PPH.BusinessEntityID;

update dw.customers_temp
set HashCode = Hashbytes('MD5', concat(CustomerID,CustomerAlternateKey,PersonType,title, FirstName, 
										MiddleName, LastName,EmailPromotion, Suffix, EmailAddress, PhoneNumber))


update a
	set 
		[CustomerID] =	b.[CustomerID],
		[CustomerAlternateKey] =b.[CustomerAlternateKey],
		[PersonType]=	b.[PersonType],
		[Title] =		b.[Title],
		[FirstName] =	b.[FirstName],
		[MiddleName] =	b.[MiddleName],
		[LastName] =	b.[LastName],
		[NameStyle] =	b.[NameStyle],
		[EmailPromotion] = b.[EmailPromotion],
		[Suffix] = b.[Suffix],
		[EmailAddress] = b.[EmailAddress],
		[PhoneNumber] = b.[PhoneNumber],
		HashCode = b.HashCode
		
	from
		dw.dim_customer a join dw.customers_temp b on a.CustomerID = b.CustomerID 
	where
		a.HashCode <> b.HashCode or a.hashcode is null

--select * from dw.dim_customer
---

insert into dw.dim_customer
(	[CustomerID]
      ,[CustomerAlternateKey]
      ,[PersonType]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[NameStyle]
      ,[EmailPromotion]
      ,[Suffix]
      ,[EmailAddress]
      ,[PhoneNumber]
	  --,[CreatedDate] --sure?
	  ,HashCode
	  ,[ModifiedDate]
	  )

select b.*, getdate() --,getdate()
from dw.dim_customer a right join dw.customers_temp b on a.CustomerID = b.CustomerID
where a.CustomerID is null


insert into log.procedures (
	procedureName,
	Step,
	Comment
)
select
	object_name(@@PROCID), 999, 'End Proc'

--select 1/0
--select * from log.procedures order by logDate
end try

begin catch

--insert into log.errors(
--ErrorNumber , ... )
--select error_number(), error_state(), ERROR_SEVERITY(),  error_line(), ERROR_PROCEDURE(), ERROR_MESSAGE()

exec log.handle_error

end catch

--select * from log.errors