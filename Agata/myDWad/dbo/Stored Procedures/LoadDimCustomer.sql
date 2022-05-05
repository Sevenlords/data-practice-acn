




CREATE procedure [dbo].[LoadDimCustomer]
as

drop table if exists #customer


SELECT   
	C.CustomerID AS [CustomerID],
	C.AccountNumber AS [CustomerAlternateKey],
	P.PersonType AS [PersonType],
	ISNULL(P.Title, 'N/D') AS [Title],
	P.FirstName AS [FirstName],
	ISNULL(P.MiddleName, 'N/D') AS [MiddleName],
	P.LastName AS [LastName],
	P.NameStyle AS [NameStyle],
	P.EmailPromotion AS [EmailPromotion],
	ISNULL(P.Suffix, 'N/D') AS [Suffix],
	ISNULL(EA.EmailAddress, 'N/D') AS [EmailAddress],
	ISNULL(PP.PhoneNumber, 'N/D') AS [PhoneNumber]
		into #customer
	FROM mydw.stg.Sales_Customer AS C
	JOIN mydw.stg.Person_Person AS P
	ON C.PersonID = P.BusinessEntityID
	LEFT JOIN mydw.stg.Person_EmailAddress AS EA
	ON P.BusinessEntityID = EA.BusinessEntityID
	LEFT JOIN mydw.stg.Person_PersonPhone AS PP
	ON P.BusinessEntityID = PP.BusinessEntityID

	update a 
	set 
	   [CustomerID]=b.[CustomerID]
      ,[CustomerAlternateKey]=b.[CustomerAlternateKey]
      ,[PersonType]=b.[PersonType]
      ,[Title]=b.[Title]
      ,[FirstName]=b.[FirstName]
      ,[MiddleName]=b.[MiddleName]
      ,[LastName]=b.[LastName]
      ,[NameStyle]=b.[NameStyle]
      ,[EmailPromotion]=b.[EmailPromotion]
      ,[Suffix]=b.[Suffix]
      ,[EmailAddress]=b.[EmailAddress]
      ,[PhoneNumber]=b.phonenumber
	  ,ModifiedDate = getdate()
	from DimCustomer a 
		join #customer b on a.CustomerID=b.customerID

insert into dbo.DimCustomer
([CustomerID]
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
	  ,Timeshtamp
	  ,ModifiedDate)

SELECT  a.*, GETDATE(), getdate()
from #customer a 
	 left join DimCustomer b on a.CustomerID=b.CustomerID
	where b.CustomerID is null
		