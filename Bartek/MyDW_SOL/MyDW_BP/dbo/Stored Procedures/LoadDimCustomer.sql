CREATE PROCEDURE [LoadDimCustomer] AS
truncate table DW.DimCustomer

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
	[PhoneNumber])

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

From stg.Sales_Customer C JOIN stg.Person_Person P ON P.BusinessEntityID = C.PersonID
LEFT JOIN stg.Person_EmailAddress EA ON P.BusinessEntityID = EA.BusinessEntityID
LEFT JOIN STG.Person_PersonPhone PP ON PP.BusinessEntityID = P.BusinessEntityID