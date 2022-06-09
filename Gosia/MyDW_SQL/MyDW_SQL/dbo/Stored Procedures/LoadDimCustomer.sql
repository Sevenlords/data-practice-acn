
CREATE procedure [dbo].[LoadDimCustomer]
as

--truncate table dbo.DimCustomer

DROP TABLE if exists #customer

SELECT   
	C.CustomerID					AS [CustomerID],
	C.AccountNumber					AS [CustomerAlternateKey],
	P.PersonType					AS [PersonType],
	ISNULL(P.Title, 'N/D')			AS [Title],
	P.FirstName						AS [FirstName],
	ISNULL(P.MiddleName, 'N/D')		AS [MiddleName],
	P.LastName						AS [LastName],
	P.NameStyle						AS [NameStyle],
	P.EmailPromotion				AS [EmailPromotion],
	ISNULL(P.Suffix, 'N/D')			AS [Suffix],
	ISNULL(EA.EmailAddress, 'N/D')	AS [EmailAddress],
	ISNULL(PP.PhoneNumber, 'N/D')	AS [PhoneNumber]								
INTO #customer	
FROM [AdventureWorks2017].[Sales].[Customer] AS C
JOIN [AdventureWorks2017].[Person].[Person] AS P
ON C.PersonID = P.BusinessEntityID
LEFT JOIN [AdventureWorks2017].[Person].[EmailAddress] AS EA
ON P.BusinessEntityID = EA.BusinessEntityID
LEFT JOIN [AdventureWorks2017].[Person].[PersonPhone] AS PP
ON P.BusinessEntityID = PP.BusinessEntityID

UPDATE a
SET 
	[CustomerID] = b.[CustomerID],
	[CustomerAlternateKey] = b.[CustomerAlternateKey],
	[PersonType] = b.[PersonType],
	[Title] = b.[Title],
	[FirstName] = b.[FirstName],
	[MiddleName] = b.[MiddleName],
	[LastName] = b.[LastName],
	[NameStyle] = b.[NameStyle],
	[EmailPromotion] = b.[EmailPromotion],
	[Suffix] = b.[Suffix],
	[EmailAddress] = b.[EmailAddress],
	[PhoneNumber] = b.[PhoneNumber],
	[ModifiedDate] = getdate()
FROM DimCustomer a
JOIN #customer b ON a.CustomerID = b.CustomerID

INSERT INTO [dbo].[DimCustomer]
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

SELECT a.*, getdate(), getdate()
FROM #customer a LEFT JOIN DimCustomer b ON a.CustomerID = b.CustomerID
WHERE b.CustomerID IS NULL

