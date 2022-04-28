create procedure dw.load_dim_customer as

truncate table dw.dim_customer

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
      ,[PhoneNumber])

SELECT   
	SC.CustomerID AS [CustomerID],
	SC.AccountNumber AS [CustomerAlternateKey],
	PP.PersonType AS [PersonType],
	ISNULL(PP.Title, 'N/D') AS [Title],
	PP.FirstName AS [FirstName],
	ISNULL(PP.MiddleName, 'N/D') AS [MiddleName],
	PP.LastName AS [LastName],
	PP.NameStyle AS [NameStyle],
	PP.EmailPromotion AS [EmailPromotion],
	ISNULL(PP.Suffix, 'N/D') AS [Suffix],
	ISNULL(EA.EmailAddress, 'N/D') AS [EmailAddress],
	ISNULL(PPH.PhoneNumber, 'N/D') AS [PhoneNumber]
		
	FROM stg.sales_customer AS SC
	JOIN stg.person_person AS PP
	ON SC.PersonID = PP.BusinessEntityID
	LEFT JOIN stg.person_email AS EA
	ON PP.BusinessEntityID = EA.BusinessEntityID
	LEFT JOIN stg.person_phone AS PPH
	ON PP.BusinessEntityID = PPH.BusinessEntityID;