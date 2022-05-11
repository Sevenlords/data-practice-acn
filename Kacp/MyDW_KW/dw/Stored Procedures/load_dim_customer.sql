create procedure dw.load_dim_customer as


drop table if exists #customers

select
	SC.CustomerID			AS [CustomerID],
	SC.AccountNumber		AS [CustomerAlternateKey],
	PP.PersonType			AS [PersonType],
	ISNULL(PP.Title, 'N/D') AS [Title],
	PP.FirstName			AS [FirstName],
	ISNULL(PP.MiddleName, 'N/D') AS [MiddleName],
	PP.LastName				AS [LastName],
	PP.NameStyle			AS [NameStyle],
	PP.EmailPromotion		AS [EmailPromotion],
	ISNULL(PP.Suffix, 'N/D') AS [Suffix],
	ISNULL(EA.EmailAddress, 'N/D') AS [EmailAddress],
	ISNULL(PPH.PhoneNumber, 'N/D') AS [PhoneNumber]

into #customers

FROM stg.sales_customer AS SC
	JOIN stg.person_person AS PP
	ON SC.PersonID = PP.BusinessEntityID
	LEFT JOIN stg.person_email AS EA
	ON PP.BusinessEntityID = EA.BusinessEntityID
	LEFT JOIN stg.person_phone AS PPH
	ON PP.BusinessEntityID = PPH.BusinessEntityID;

----

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
		[PhoneNumber] = b.[PhoneNumber]
	from
		dw.dim_customer a join #customers b on a.CustomerID = b.CustomerID

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
	  ,[CreatedDate] --sure?
	  ,[ModifiedDate])

select b.*, getdate(), getdate()
from dw.dim_customer a right join #customers b on a.CustomerID = b.CustomerID
where a.CustomerID is null


--truncate table dw.dim_customer
--
--insert into dw.dim_customer
--(	[CustomerID]
--      ,[CustomerAlternateKey]
--      ,[PersonType]
--      ,[Title]
--      ,[FirstName]
--      ,[MiddleName]
--      ,[LastName]
--      ,[NameStyle]
--      ,[EmailPromotion]
--      ,[Suffix]
--      ,[EmailAddress]
--      ,[PhoneNumber])
--
--SELECT   
--	SC.CustomerID AS [CustomerID],
--	SC.AccountNumber AS [CustomerAlternateKey],
--	PP.PersonType AS [PersonType],
--	ISNULL(PP.Title, 'N/D') AS [Title],
--	PP.FirstName AS [FirstName],
--	ISNULL(PP.MiddleName, 'N/D') AS [MiddleName],
--	PP.LastName AS [LastName],
--	PP.NameStyle AS [NameStyle],
--	PP.EmailPromotion AS [EmailPromotion],
--	ISNULL(PP.Suffix, 'N/D') AS [Suffix],
--	ISNULL(EA.EmailAddress, 'N/D') AS [EmailAddress],
--	ISNULL(PPH.PhoneNumber, 'N/D') AS [PhoneNumber]
--		
--	FROM stg.sales_customer AS SC
--	JOIN stg.person_person AS PP
--	ON SC.PersonID = PP.BusinessEntityID
--	LEFT JOIN stg.person_email AS EA
--	ON PP.BusinessEntityID = EA.BusinessEntityID
--	LEFT JOIN stg.person_phone AS PPH
--	ON PP.BusinessEntityID = PPH.BusinessEntityID;