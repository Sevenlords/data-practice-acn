
CREATE PROCEDURE [dbo].[LoadDimCustomer]
AS

EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 1, @Comment = 'Start Proc'


BEGIN TRY
	--TRUNCATE TABLE dbo.DimCustomer
	--DROP TABLE IF EXISTS #customer
	DROP TABLE IF EXISTS [dbo].[DimCustomerTmp]

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
		CAST(NULL AS varbinary(30)) AS [HashCode]
	INTO [dbo].[DimCustomerTmp]
		FROM [stg].[Sales_Customer] AS C
		JOIN [stg].[Person_Person] AS P
		ON C.PersonID = P.BusinessEntityID
		LEFT JOIN [stg].[Person_EmailAddress] AS EA
		ON P.BusinessEntityID = EA.BusinessEntityID
		LEFT JOIN [stg].[Person_PersonPhone] AS PP
		ON P.BusinessEntityID = PP.BusinessEntityID

	UPDATE [dbo].[DimCustomerTmp]
	SET HashCode = HASHBYTES('MD5', CONVERT(varchar(10), [CustomerID]) + [CustomerAlternateKey] + [PersonType] + [Title] + [FirstName] + [MiddleName] + 
	[LastName] + CONVERT(varchar(10), [NameStyle]) + CONVERT(varchar(10), [EmailPromotion]) + [PhoneNumber] + [Suffix] +  [EmailAddress] + [PhoneNumber])

	MERGE dbo.dimCustomer AS dC
	USING [dbo].[DimCustomerTmp] AS C
	ON dC.CustomerID = C.CustomerID
	WHEN MATCHED AND C.HashCode <> dC.HashCode
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
		dC.ModifiedDate = GETDATE(),
		dC.HashCode = C.HashCode

	WHEN NOT MATCHED
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
		[ModifiedDate],
		[HashCode])
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
		GETDATE(),
		C.[HashCode]);

	EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 999, @Comment = 'End Proc'

END TRY

BEGIN CATCH
	EXEC [log].[ErrorCall]
END CATCH