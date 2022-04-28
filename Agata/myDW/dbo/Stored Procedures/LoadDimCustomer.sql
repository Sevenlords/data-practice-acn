﻿



CREATE procedure [dbo].[LoadDimCustomer]
as
--first commit from vs

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
		
	FROM mydw.stg.Sales_Customer AS C
	JOIN mydw.stg.Person_Person AS P
	ON C.PersonID = P.BusinessEntityID
	LEFT JOIN mydw.stg.Person_EmailAddress AS EA
	ON P.BusinessEntityID = EA.BusinessEntityID
	LEFT JOIN mydw.stg.Person_PersonPhone AS PP
	ON P.BusinessEntityID = PP.BusinessEntityID
		