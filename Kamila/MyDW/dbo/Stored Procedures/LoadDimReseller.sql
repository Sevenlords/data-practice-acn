








CREATE PROCEDURE [dbo].[LoadDimReseller]
as

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 1, @Comment = 'Start procedure'
BEGIN TRY

DELETE FROM DimReseller where ResellerKey=-1

SET IDENTITY_INSERT DimReseller ON

INSERT INTO DimReseller ([ResellerKey]
      ,[CustomerID]
      ,[ResellerAlternateKey]
      ,[ResellerName]
      ,[CreatedDate]
      ,[ModifiedDate])
SELECT -1 [ResellerKey]
      ,-1 [CustomerID]
      ,'Unknown' [ResellerAlternateKey]
      ,'Unknown'[ResellerName]
      ,GETDATE() [CreatedDate]
      ,GETDATE() [ModifiedDate]

SET IDENTITY_INSERT DimReseller OFF

drop table if exists #reseller

SELECT
	SC.CustomerID AS [CustomerID],
	SC.AccountNumber AS [ResellerAlternateKey],
	SS.Name AS [ResellerName],
	GETDATE() as [CreatedDate],
	SC.Timestamp as [ModifiedDate]
INTO #reseller
FROM stg.Sales_Store AS SS
	JOIN stg.Sales_Customer AS SC
	ON SS.BusinessEntityID = SC.StoreID

MERGE INTO dbo.DimReseller AS TARGET
USING #reseller as SOURCE
ON TARGET.CustomerID = SOURCE.CustomerID
WHEN MATCHED AND TARGET.[ResellerAlternateKey] <> SOURCE.[ResellerAlternateKey]
	OR TARGET.[CustomerID] <> SOURCE.[CustomerID]
	OR TARGET.[ResellerName] <> SOURCE.[ResellerName]
THEN UPDATE SET
	[CustomerID] = SOURCE.[CustomerID],
	[ResellerAlternateKey] = SOURCE.[ResellerAlternateKey],
	[ResellerName] = SOURCE.[ResellerName],
	[ModifiedDate] = GETDATE()
WHEN NOT MATCHED BY TARGET
THEN INSERT 
	(
	[CustomerID],
	[ResellerAlternateKey],
	[ResellerName],
	[CreatedDate],
	[ModifiedDate]
	)
	VALUES(
	SOURCE.[CustomerID],
	SOURCE.[ResellerAlternateKey],
	SOURCE.[ResellerName],
	GETDATE(),
	GETDATE()
	);



EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 99, @Comment = 'Finish procedure'

END TRY

BEGIN CATCH

EXEC [log].[ErrorCall]


END CATCH
