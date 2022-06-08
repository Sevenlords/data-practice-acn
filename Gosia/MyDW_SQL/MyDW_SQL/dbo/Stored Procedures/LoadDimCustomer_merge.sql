CREATE procedure [dbo].[LoadDimCustomer_merge]
as

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 1, @Comment = 'Start proc'

BEGIN TRY

--truncate table dbo.DimCustomer

DROP TABLE if exists dbo.DimCustomerTmp

DELETE FROM DimCustomer
WHERE CustomerKey = -1

SET IDENTITY_INSERT DimCustomer ON

INSERT INTO DimCustomer	
(	
	[CustomerKey]
      ,[CustomerID]
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
      ,[CreatedDate]
      ,[ModifiedDate]
      ,[HashCode]
)

SELECT 
-1				AS	[CustomerKey]
,-1				AS	[CustomerID]
,'-1'			AS	[CustomerAlternateKey]
,'-1'			AS	[PersonType]
,'-1'			AS	[Title]
,'Unknown'		AS	[FirstName]
,'Unknown'		AS	[MiddleName]
,'Unknown'		AS	[LastName]
,0				AS	[NameStyle]
,-1				AS	[EmailPromotion]
,'-1'			AS	[Suffix]
,'Uknown'		AS	[EmailAddress]
,'-1'			AS	[PhoneNumber]
,getdate()		AS	[CreatedDate]
,getdate()		AS	[ModifiedDate]
,null			AS	[HashCode]

SET IDENTITY_INSERT DimCustomer OFF



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
	ISNULL(PP.PhoneNumber, 'N/D')	AS [PhoneNumber],
	cast(NULL as varbinary(30))		AS HashCode
INTO dbo.DimCustomerTmp	
FROM  [STG].[Sales_Customer]AS C
JOIN [STG].[Person_Person] AS P
ON C.PersonID = P.BusinessEntityID
LEFT JOIN [STG].[Person_EmailAddress] AS EA
ON P.BusinessEntityID = EA.BusinessEntityID
LEFT JOIN [STG].[Person_Phone] AS PP
ON P.BusinessEntityID = PP.BusinessEntityID 

UPDATE dbo.DimCustomerTmp	
set HashCode =  HASHBYTES ('MD5', convert(varchar(10),[CustomerID]) + [CustomerAlternateKey] + [PersonType] + [Title] + [FirstName] +
[MiddleName] + [LastName] + convert(varchar(10),[NameStyle]) + convert(varchar(10),[EmailPromotion]) + [Suffix] + [EmailAddress] + [PhoneNumber])

-- = set HashCode =  HASHBYTES ('MD5', concat([CustomerID], [CustomerAlternateKey], [PersonType], [Title], [FirstName],
-- [MiddleName], [LastName], [NameStyle], [EmailPromotion]), [Suffix], [EmailAddress], [PhoneNumber])


--SELECT HASHBYTES ('MD5', convert(varchar(10),[CustomerID]) + [CustomerAlternateKey] + [PersonType] + [Title] + [FirstName] +
--[MiddleName] + [LastName] + convert(varchar(10),[NameStyle]) + convert(varchar(10),[EmailPromotion]) + [Suffix] + [EmailAddress] + [PhoneNumber])
--SELECT *
--FROM dbo.DimCustomerTmp	
--
MERGE [dbo].[dimCustomer] AS Target
	USING(
	SELECT * FROM dbo.DimCustomerTmp)
AS source
ON target.CustomerID = source.CustomerID
WHEN MATCHED AND source.HashCode <> target.HashCode
THEN UPDATE SET 
	[CustomerID] = source.[CustomerID],
	[CustomerAlternateKey] = source.[CustomerAlternateKey],
	[PersonType] = source.[PersonType],
	[Title] = source.[Title],
	[FirstName] = source.[FirstName],
	[MiddleName] = source.[MiddleName],
	[LastName] = source.[LastName],
	[NameStyle] = source.[NameStyle],
	[EmailPromotion] = source.[EmailPromotion],
	[Suffix] = source.[Suffix],
	[EmailAddress] = source.[EmailAddress],
	[PhoneNumber] = source.[PhoneNumber],
	[ModifiedDate] = getdate(),
	[HashCode] = source.[HashCode]

WHEN NOT MATCHED BY Target
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
	[HashCode]
	
)
	VALUES(
		source.[CustomerID],
		source.[CustomerAlternateKey],
		source.[PersonType],
		source.[Title],
		source.[FirstName],
		source.[MiddleName],
		source.[LastName],
		source.[NameStyle],
		source.[EmailPromotion],
		source.[Suffix],
		source.[EmailAddress],
		source.[PhoneNumber],
		source.[HashCode]
	);

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 999, @Comment = 'End proc'
SELECT 1/0

END TRY

BEGIN CATCH

EXEC [log].[ErrorCall] 

END CATCH

-- SELECT * FROM  DimCustomer
