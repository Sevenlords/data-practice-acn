

/*** dbo.LoadDimCustomer Date: 21.04.2022 ***/

CREATE PROCEDURE [dbo].[LoadDimCustomer]
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
	ISNULL(PP.PhoneNumber, 'N/D') AS [PhoneNumber],
	-- audyt kolumny
	GETDATE() as [CreatedDate],
	P.Timestamp as [ModifiedDate]
INTO #customer
FROM stg.Sales_Customer AS C
JOIN stg.Person_Person AS P
	ON C.PersonID = P.BusinessEntityID
LEFT JOIN stg.Person_EmailAddress AS EA 
	ON P.BusinessEntityID = EA.BusinessEntityID
LEFT JOIN stg.Person_PersonPhone AS PP 
	ON P.BusinessEntityID = PP.BusinessEntityID

MERGE INTO dbo.DimCustomer as TARGET
USING #customer as SOURCE
ON SOURCE.CustomerID = TARGET.CustomerID
WHEN MATCHED
THEN UPDATE SET
	[CustomerID] = SOURCE.[CustomerID],
	[CustomerAlternateKey] = SOURCE.[CustomerAlternateKey],
	[PersonType] = SOURCE.[PersonType],
	[Title] = SOURCE.[Title],
	[FirstName] = SOURCE.[FirstName],
	[MiddleName] = SOURCE.[MiddleName],
	[LastName] = SOURCE.[LastName],
	[NameStyle] = SOURCE.[NameStyle],
	[EmailPromotion] = SOURCE.[EmailPromotion],
	[Suffix] = SOURCE.[Suffix],
	[EmailAddress] = SOURCE.[EmailAddress],
	[PhoneNumber] = SOURCE.[PhoneNumber],
	[ModifiedDate]  = GETDATE()
WHEN NOT MATCHED BY TARGET
THEN INSERT
	(
	[CustomerID],
	[CustomerAlternateKey],
	[PersonType],
	[Title],
	[FirstName],
	[MiddleName],
	[LastName],
	[NameStyle],
	[EmailPromotion],
	[Suffix],
	[EmailAddress],
	[PhoneNumber],
	[CreatedDate],
	[ModifiedDate]
	)
	VALUES(
	SOURCE.[CustomerID],
	SOURCE.[CustomerAlternateKey],
	SOURCE.[PersonType],
	SOURCE.[Title],
	SOURCE.[FirstName],
	SOURCE.[MiddleName],
	SOURCE.[LastName],
	SOURCE.[NameStyle],
	SOURCE.[EmailPromotion],
	SOURCE.[Suffix],
	SOURCE.[EmailAddress],
	SOURCE.[PhoneNumber],
	GETDATE(),
	GETDATE()
	);

