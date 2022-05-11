CREATE PROCEDURE [dbo].[LoadDimCustomer] AS
--truncate table DW.DimCustomer
drop table if exists #Customer

SELECT
C.CustomerID AS CustomerID, 
C.AccountNumber AS CustomerAlternateID, 
P.PersonType AS PersonType, 
ISNULL(P.Title,'N\D') AS Title,
P.FirstName AS FirstName,
ISNULL(P.MiddleName,'N\D') AS MiddleName,
P.LastName AS LastName,
P.NameStyle AS NameStyle,
ISNULL(P.Suffix,'N\D') AS Suffix,
ISNULL(EA.EmailAddress,'N\D') AS EmailAdress,
ISNULL(PP.PhoneNumber,'N\D') AS PhoneNumber
INTO #Customer
From stg.Sales_Customer C JOIN stg.Person_Person P ON P.BusinessEntityID = C.PersonID
LEFT JOIN stg.Person_EmailAddress EA ON P.BusinessEntityID = EA.BusinessEntityID
LEFT JOIN STG.Person_PersonPhone PP ON PP.BusinessEntityID = P.BusinessEntityID

Update DW.DimCustomer
SET
	[CustomerID] = b.[CustomerID],
	[CustomerAlternateKey] = b.[CustomerAlternateID],
	[PersonType] = b.[PersonType],
	[Title] = b.Title,
	[FirstName]  = b.FirstName,
	[MiddleName] = b.MiddleName,
	[LastName] = b.LastName,
	[NameStyle] = b.NameStyle,
	[Suffix] = b.Suffix,
	[EmailAddress] = b.EmailAdress,
	[PhoneNumber] = b.PhoneNumber,
	ModifiedDate = getdate()
FROM DW.DimCustomer a 
JOIN #Customer b ON a.CustomerID= b.CustomerID

Insert Into DW.[DimCustomer](
	[CustomerID],
	[CustomerAlternateKey],
	[PersonType],
	[Title] ,
	[FirstName] ,
	[MiddleName] ,
	[LastName] ,
	[NameStyle] ,
	[Suffix] ,
	[EmailAddress] ,
	[PhoneNumber],
	ModifiedDate,
	CreatedDate)

SELECT b.*,GETDATE(),GETDATE()
from DW.DimCustomer a 
	Right join #Customer b on a.CustomerID = b.CustomerID
where a.CustomerID is null 

--EXEC LoadDimCustomer