
ALTER PROCEDURE [dbo].[LoadDimCustomer]
AS

--TRUNCATE TABLE dbo.DimCustomer
DROP TABLE IF EXISTS #customer

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
INTO #customer
	FROM [stg].[Sales_Customer] AS C
	JOIN [stg].[Person_Person] AS P
	ON C.PersonID = P.BusinessEntityID
	LEFT JOIN [stg].[Person_EmailAddress] AS EA
	ON P.BusinessEntityID = EA.BusinessEntityID
	LEFT JOIN [stg].[Person_PersonPhone] AS PP
	ON P.BusinessEntityID = PP.BusinessEntityID

MERGE dbo.dimCustomer AS dC
USING #customer AS C
ON dC.CustomerID = C.CustomerID
WHEN MATCHED AND dC.CustomerAlternateKey <> C.CustomerAlternateKey
	OR dC.PersonType <> C.PersonType
	OR dC.Title <> C.Title
	OR dC.FirstName <> C.FirstName
	OR dC.MiddleName <> C.MiddleName
	OR dC.LastName <> C.LastName
	OR dC.NameStyle <> C.NameStyle
	OR dC.EmailPromotion <> C.EmailPromotion
	OR dC.Suffix <> C.Suffix
	OR dC.EmailAddress <> C.EmailAddress
	OR dC.PhoneNumber <> C.PhoneNumber
THEN UPDATE SET 
    dC.CustomerAlternateKey = C.CustomerAlternateKey,
	dC.PersonType = C.PersonType,
	dC.Title = C.Title,
	dC.FirstName = C.FirstName,
	dC.MiddleName = C.MiddleName,
	dC.LastName = C.LastName,
	dC.NameStyle = C.NameStyle,
	dC.EmailPromotion = C.EmailPromotion,
	dC.Suffix = C.Suffix,
	dC.EmailAddress = C.EmailAddress,
	dC.PhoneNumber = C.PhoneNumber,
	dC.ModifiedDate = GETDATE()

WHEN NOT MATCHED BY TARGET
THEN INSERT (
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
	[ModifiedDate])
VALUES (C.[CustomerID],
	C.[CustomerAlternateKey],
	C.[PersonType],
	C.[Title],
	C.[FirstName],
	C.[MiddleName],
	C.[LastName],
	C.[NameStyle],
	C.[EmailPromotion],
	C.[Suffix],
	C.[EmailAddress],
	C.[PhoneNumber],
	GETDATE(),
	GETDATE());
