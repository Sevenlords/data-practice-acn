
create procedure [dbo].[LoadDimCustomer]
as
-- first commit from VS
-- commit from clone
truncate table dbo.DimCustomer

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
      ,[PhoneNumber])

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
		
	FROM [AdventureWorks2017].[Sales].[Customer] AS C
	JOIN [AdventureWorks2017].[Person].[Person] AS P
	ON C.PersonID = P.BusinessEntityID
	LEFT JOIN [AdventureWorks2017].[Person].[EmailAddress] AS EA
	ON P.BusinessEntityID = EA.BusinessEntityID
	LEFT JOIN [AdventureWorks2017].[Person].[PersonPhone] AS PP
	ON P.BusinessEntityID = PP.BusinessEntityID
		
