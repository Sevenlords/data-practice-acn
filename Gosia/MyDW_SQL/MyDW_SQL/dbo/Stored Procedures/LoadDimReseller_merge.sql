CREATE procedure [dbo].[LoadDimReseller_merge]
as

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 1, @Comment = 'Start proc'

BEGIN TRY

--truncate table dbo.DimReseller
DELETE FROM DimReseller
WHERE ResellerKey = -1 

SET IDENTITY_INSERT DimReseller ON

INSERT INTO DimReseller
( [ResellerKey]
      ,[CustomerID]
      ,[ResellerAlternateKey]
      ,[ResellerName]
      ,[CreatedDate]
      ,[ModifiedDate]
)
SELECT
-1			AS	[ResellerKey]
,-1			AS	[CustomerID]
,'-1'		AS	[ResellerAlternateKey]
,'Unknown'	AS	[ResellerName]
,getdate()	AS	[CreatedDate]
,getdate()  AS	[ModifiedDate]

SET IDENTITY_INSERT DimReseller OFF

DROP TABLE IF EXISTS #reseller

SELECT   
	C.CustomerID		AS [CustomerID],
	C.AccountNumber		AS [ResellerAlternateKey],
	S.Name				AS [ResellerName]

INTO #reseller

FROM [STG].[Sales_Customer] AS C
	JOIN [STG].[Sales_Store] AS S
	ON C.StoreID = S.BusinessEntityID

MERGE [dbo].[dimReseller] AS TARGET
	USING (
	SELECT * FROM #reseller)
	AS source
ON target.CustomerID = source.CustomerID
WHEN MATCHED
THEN UPDATE SET
[CustomerID] = source.[CustomerID],
	[ResellerAlternateKey] = source.[ResellerAlternateKey],
	[ResellerName] = source.[ResellerName],
	[ModifiedDate] = getdate()
WHEN NOT MATCHED BY TARGET
THEN INSERT
(
	[CustomerID],
	[ResellerAlternateKey],
	[ResellerName]
	)
		values (
			source.[CustomerID],
			source.[ResellerAlternateKey],
			source.[ResellerName]
		);

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 999, @Comment = 'End proc'

END TRY

BEGIN CATCH

EXEC [log].[ErrorCall] 

END CATCH

--SELECT * FROM DimReseller