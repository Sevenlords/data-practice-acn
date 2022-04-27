﻿
CREATE PROCEDURE [dbo].[LoadDimCustomer]
AS

TRUNCATE TABLE dbo.DimCustomer

INSERT INTO dbo.DimCustomer
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
		
	FROM [stg].[Sales_Customer] AS C
	JOIN [stg].[Person_Person] AS P
	ON C.PersonID = P.BusinessEntityID
	LEFT JOIN [stg].[Person_EmailAddress] AS EA
	ON P.BusinessEntityID = EA.BusinessEntityID
	LEFT JOIN [stg].[Person_PersonPhone] AS PP
	ON P.BusinessEntityID = PP.BusinessEntityID

EXEC LoadDimCustomer
		