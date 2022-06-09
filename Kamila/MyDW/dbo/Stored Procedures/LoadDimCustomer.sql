









/*** dbo.LoadDimCustomer Date: 21.04.2022 ***/

CREATE PROCEDURE [dbo].[LoadDimCustomer]
as

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 1, @Comment = 'Start procedure'

BEGIN TRY

drop table if exists #customer

DELETE FROM DimCustomer where CustomerKey=-1

SET IDENTITY_INSERT DimCustomer ON

INSERT INTO DimCustomer (
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
	   -1 AS [CustomerKey]
      ,-1 AS [CustomerID]
      ,'Unknown' AS [CustomerAlternateKey]
      ,'-1' AS [PersonType]
      ,'Unknown' AS [Title]
      ,'Unknown' AS [FirstName]
      ,'Unknown' AS[MiddleName]
      ,'Unknown' AS[LastName]
      ,0 AS [NameStyle]
      ,-1 AS [EmailPromotion]
      ,'Unknown' AS [Suffix]
      ,'Unknown' AS [EmailAddress]
      ,'Unknown' AS [PhoneNumber]
      ,GETDATE() AS[CreatedDate]
      ,GETDATE() AS [ModifiedDate]
      ,null as [HashCode]
SET IDENTITY_INSERT DimCustomer OFF


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
	P.Timestamp as [ModifiedDate],
	cast(null as varbinary(30)) as [HashCode]
INTO #customer
FROM stg.Sales_Customer AS C
JOIN stg.Person_Person AS P
	ON C.PersonID = P.BusinessEntityID
LEFT JOIN stg.Person_EmailAddress AS EA 
	ON P.BusinessEntityID = EA.BusinessEntityID
LEFT JOIN stg.Person_PersonPhone AS PP 
	ON P.BusinessEntityID = PP.BusinessEntityID

UPDATE dbo.DimCustomer
SET HashCode = HASHBYTES('MD5', CONVERT(varchar(10), CustomerID)+[CustomerAlternateKey]+[PersonType]+[Title]+
[FirstName]+[MiddleName]+[LastName]+CONVERT(varchar(10),[NameStyle])+CONVERT(varchar(10),[EmailPromotion])+[Suffix]+[EmailAddress]+CONVERT(varchar(10),[PhoneNumber])
)

UPDATE #customer
SET HashCode = HASHBYTES('MD5', CONVERT(varchar(10), CustomerID)+[CustomerAlternateKey]+[PersonType]+[Title]+
[FirstName]+[MiddleName]+[LastName]+CONVERT(varchar(10),[NameStyle])+CONVERT(varchar(10),[EmailPromotion])+[Suffix]+[EmailAddress]+CONVERT(varchar(10),[PhoneNumber])
)

MERGE INTO dbo.DimCustomer as TARGET
USING #customer as SOURCE
ON SOURCE.CustomerID = TARGET.CustomerID
WHEN MATCHED AND TARGET.HashCode <> SOURCE.HashCode
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
	[ModifiedDate]  = GETDATE(),
	[HashCode] = SOURCE.[HashCode]
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
	[ModifiedDate],
	[HashCode]
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
	GETDATE(),
	SOURCE.[HashCode]
	);

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 99, @Comment = 'Finish procedure'

END TRY

BEGIN CATCH

EXEC [log].[ErrorCall] --@ErrorNumber =  ERROR_NUMBER(), @ErrorState = ERROR_STATE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorLine =  ERROR_LINE(), @ErrorProcedure = ERROR_PROCEDURE(), @ErrorMessage = ERROR_MESSAGE()


END CATCH

