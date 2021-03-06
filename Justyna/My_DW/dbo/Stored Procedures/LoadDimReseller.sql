CREATE PROCEDURE [dbo].[LoadDimReseller]
AS
BEGIN

EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 1, @Comment = 'Start Proc'

BEGIN TRY
	DELETE FROM [dbo].[DimReseller]
	WHERE ResellerKey = -1

	SET IDENTITY_INSERT DimReseller ON	

	INSERT INTO [dbo].[DimReseller](
		[ResellerKey],
		[CustomerID],
		[ResellerAlternateKey],
		[ResellerName],
		[CreatedDate],
		[ModifiedDate])
	
	SELECT -1 AS [ResellerKey],
		   -1 AS [CustomerID],
		  '-1' AS [ResellerAlternateKey],
		  '-1' AS [ResellerName],
		  GETDATE() AS [CreatedDate],
		  GETDATE() AS [ModifiedDate]
	
	SET IDENTITY_INSERT DimReseller OFF

	--TRUNCATE TABLE dbo.DimReseller
	DROP TABLE IF EXISTS #reseller

	SELECT   
		ISNULL(C.CustomerID, -1) AS [CustomerID],
		ISNULL(C.AccountNumber, 'N/D') AS [ResellerAlternateKey],
		ISNULL(S.Name, 'N/D') AS [ResellerName]
	INTO #reseller
	FROM [stg].[Sales_Store] AS S
	JOIN [stg].[Sales_Customer] AS C
	ON S.BusinessEntityID = C.StoreID

	MERGE dbo.DimReseller AS dR
	USING #reseller AS R
	ON dR.CustomerID = R.CustomerID
	WHEN MATCHED AND dR.ResellerAlternateKey <> R.ResellerAlternateKey
		OR dR.ResellerName <> R.ResellerName
	THEN UPDATE SET 
		dR.ResellerAlternateKey = R.ResellerAlternateKey,
		dR.ResellerName = R.ResellerName,
		dR.ModifiedDate = GETDATE()

	WHEN NOT MATCHED
	THEN INSERT (
		[CustomerID],
		[ResellerAlternateKey],
		[ResellerName],
		[CreatedDate],
		[ModifiedDate])
	VALUES (R.[CustomerID],
		R.[ResellerAlternateKey],
		R.[ResellerName],
		GETDATE(),
		GETDATE());

	EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 999, @Comment = 'End Proc'
END TRY

BEGIN CATCH
	EXEC [log].[ErrorCall]
END CATCH
END