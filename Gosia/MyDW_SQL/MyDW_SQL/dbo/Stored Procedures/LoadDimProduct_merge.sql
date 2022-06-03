--MAM 504 REKORDY Z CZEGO 134 Z EXPIRED I 370 CURRENT, ZAMIAST 134 Z EXPIRED I 504 Z CURRENT
--SELECT * FROM [DBO].[DimProduct] WHERE ProductId = 1
--DROP TABLE dbo.DimProduct

CREATE procedure [dbo].[LoadDimProduct_merge]
as

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 1, @Comment = 'Start proc'

BEGIN TRY

--truncate table dbo.DimProduct
DELETE FROM dimProduct
WHERE ProductKey = -1 

SET IDENTITY_INSERT DimProduct ON
INSERT INTO dimProduct
(	
		[ProductKey]
      ,[ProductID]
      ,[ProductName]
      ,[ProductAlternateKey]
      ,[StandardCost]
      ,[FinishedGoodFlag]
      ,[Color]
      ,[ListPrice]
      ,[Size]
      ,[SizeUnitMeasureCode]
      ,[Weight]
      ,[WeightUnitMeasureCode]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[Class]
      ,[Style]
      ,[ProductCategoryID]
      ,[ProductCategoryName]
      ,[ProductSubcategoryID]
      ,[ProductSubcategoryName]
      ,[ProductModelID]
      ,[ProductModelName]
      ,[SellStartDate]
      ,[SellEndDate]
      ,[SourceModifiedDate]
      ,[CreatedDate]
      ,[ModifiedDate]
      ,[ManufactoryID]
      ,[ManufactoryName]
      ,[DateFrom]
      ,[DateTo]
      ,[CurrentRowIndicator]
)
SELECT 
-1				AS	[ProductKey]
,-1				AS	[ProductID]
,'Unknown'		AS	[ProductName]
,'Unknown'		AS	[ProductAlternateKey]
,0				AS	[StandardCost]
,0				AS	[FinishedGoodFlag]
,'Unknown'		AS	[Color]
,-1				AS	[ListPrice]
,'-1'			AS	[Size]
,'-1'			AS	[SizeUnitMeasureCode]
,0				AS	[Weight]
,'-1'			AS	[WeightUnitMeasureCode]
,-1				AS	[DaysToManufacture]
,'-1'			AS	[ProductLine]
,'-1'			AS	[Class]
,'-1'			AS	[Style]
,-1				AS	[ProductCategoryID]
,'Unknown'		AS	[ProductCategoryName]
,-1				AS	[ProductSubcategoryID]
,'Unknown'		AS	[ProductSubcategoryName]
,-1				AS	[ProductModelID]
,'Unknown'		AS	[ProductModelName]
,'1900-01-01'	AS	[SellStartDate]
,'2100-12-30'	AS	[SellEndDate]
,getdate()		AS	[SourceModifiedDate]
,getdate()		AS	[CreatedDate]
,getdate()		AS	[ModifiedDate]
,-1				AS	[ManufactoryID]
,'Unknown'		AS	[ManufactoryName]
,'1900-01-01'	AS	[DateFrom]
,'2100-12-30'	AS	[DateTo]
,'Unknown'		AS	[CurrentRowIndicator]

SET IDENTITY_INSERT DimProduct OFF

UPDATE a
SET 
	CurrentRowIndicator = 'Expired'
	,DateTo =  CONVERT(char(255),CAST(DATEADD(DD, -1, c.Date) as date),112)  --b.DateFrom  
--
----SELECT a.ProductID, a.ManufactoryID, b.ManufactoryId, a.CurrentRowIndicator,  a.DateFrom, a.DateTo, CONVERT(int,CONVERT(char(8),CAST(DATEADD(DD, -1, c.Date)as date),112))
FROM DimProduct a JOIN [STG].[Product_Manufactory] b 
ON a.ProductID = b.ProductID AND a.ManufactoryID <> b.ManufactoryId
JOIN DimDate c ON b.DateFrom = c.DateKey
WHERE CurrentRowIndicator = 'Current'

DROP TABLE if exists #product

SELECT
	--ROW_NUMBER()OVER (ORDER BY ProductID) 			
	--											AS ProductKey],
	P.ProductID									AS [ProductID]
	,P.Name										AS [ProductName]
	,P.ProductNumber							AS [ProductAlternateKey]
	,P.StandardCost								AS [StandardCost]
	,P.FinishedGoodsFlag						AS [FinishedGoodFlag]
	,ISNULL(P.Color, 'N/D')						AS [Color]
	,P.ListPrice								AS [ListPrice]
	,ISNULL(P.Size, 'N/D')						AS [Size]
	,ISNULL(P.SizeUnitMeasureCode, 'N/D')		AS [SizeUnitMeasureCode]
	,P.Weight									AS [Weight]
	,ISNULL(P.WeightUnitMeasureCode, 'N/D')		AS [WeightUnitMeasureCode]
	,P.DaysToManufacture						AS [DaysToManufacture]
	,ISNULL(P.ProductLine, 'N/D')				   
												AS [ProductLine]
	,ISNULL(P.Class, 'N/D')						AS [Class]
	,ISNULL(P.Style, 'N/D')						AS [Style]
	,S.ProductCategoryID						AS [ProductCategoryID]
	,ISNULL(C.Name, 'N/D')						AS [ProductCategoryName]
	,S.ProductSubcategoryID						AS [ProductSubcategoryID]
	,ISNULL(S.Name, 'N/D')						AS [ProductSubcategoryName]
	,P.ProductModelID 							AS [ProductModelID]
	,ISNULL(M.Name, 'N/D')						AS [ProductModelName]
	,P.SellStartDate							AS [SellStartDate]
	,P.SellEndDate								AS [SellEndDate]
	,P.ModifiedDate								AS [SourceModifiedDate]
	,PM.ManufactoryID							AS [ManufactoryID]
	,Ma.ManufactoryName							AS [ManufactoryName]
	,PM.DateFrom								AS [DateFrom]
	,PM.DateTo									AS [DateTo]
	,'Current'									AS CurrentRowIndicator 
INTO #product	
FROM [STG].[Production_Product] AS P
	LEFT JOIN [STG].[Production_ProductModel] AS M
	ON M.ProductModelID = P.ProductModelID
	LEFT JOIN [STG].[Production_ProductSubcategory] AS S
	ON	S.ProductSubcategoryID = P.ProductSubcategoryID
	LEFT JOIN [STG].[Production_ProductCategory] AS C
	ON S.ProductCategoryID = C.ProductcategoryID
	LEFT JOIN [STG].[Product_Manufactory] PM ON PM.ProductID = P.ProductID
	LEFT JOIN [STG].[Manufactories] Ma ON PM.ManufactoryID = Ma.ManufactoryID

--INSERT INTO #product (ProductID, ProductName, ProductAlternateKey)
--SELECT TOP 4
--10000 + ProductID, ProductName + ' New', ProductAlternateKey FROM #prodc

--SELECT * FROM #product
--DROP TABLE [STG].[Manufactories]
--select  * FROM [STG].[Manufactories]
--select * FROM [STG].[Product_Manufactory]
--SELECT * FROM dimProduct WHERE PRoductID = 1

MERGE [dbo].[dimProduct] AS target
	USING (
	SELECT * FROM #product)
	AS source
ON target.ProductID = source.ProductID AND target.ManufactoryID = source.ManufactoryID
WHEN MATCHED
THEN UPDATE SET

	[ProductName] = source.[ProductName]
	,[ProductAlternateKey] = source.[ProductAlternateKey]
	,[StandardCost] = source.[StandardCost]
	,[FinishedGoodFlag] = source.[FinishedGoodFlag]
	,[Color] = source.[Color]
	,[ListPrice] = source.[ListPrice]
	,[Size] = source.[Size]
	,[SizeUnitMeasureCode] = source.[SizeUnitMeasureCode]
	,[Weight] = source.[Weight]
	,[WeightUnitMeasureCode] = source.[WeightUnitMeasureCode]
	,[DaysToManufacture] = source.[DaysToManufacture]
	,[ProductLine] = source.[ProductLine]
	,[Class] = source.[Class]
	,[Style] = source.[Style]
	,[ProductCategoryID] = source.[ProductCategoryID]
	--,[ProductCategoryName] 
	--,[ProductSubcategoryID]
	--,[ProductSubcategoryName]
	--,[ProductModelID]
	--,[ProductModelName] 
	--,[SellStartDate]
	--,[SellEndDate] 
	--,[SourceModifiedDate] = b.[SourceModifiedDate]	
	,[ModifiedDate]= getdate()
	,[ManufactoryID] = source.[ManufactoryID]
	,[ManufactoryName] = source.[ManufactoryName]
	,DateFrom = source.DateFrom
	,DateTo	 = source.DateTo	
	,CurrentRowIndicator = source.CurrentRowIndicator
WHEN NOT MATCHED BY TARGET
THEN INSERT
( 
--[ProductKey],
	[ProductID]
	,[ProductName]
	,[ProductAlternateKey]
	,[StandardCost]
	,[FinishedGoodFlag]
	,[Color]
	,[ListPrice]
	,[Size]
	,[SizeUnitMeasureCode]
	,[Weight]
	,[WeightUnitMeasureCode]
	,[DaysToManufacture]
	,[ProductLine]
	,[Class]
	,[Style]
	,[ProductCategoryID]
	,[ProductCategoryName]
	,[ProductSubcategoryID]
	,[ProductSubcategoryName]
	,[ProductModelID]
	,[ProductModelName]
	,[SellStartDate]
	,[SellEndDate]
	,[SourceModifiedDate]
	,[ManufactoryID] 
	,[ManufactoryName]
	,[DateFrom]
	,[DateTo]
	,CurrentRowIndicator 
	)
	VALUES(
			source.[ProductID]
			,source.[ProductName]
			,source.[ProductAlternateKey]
			,source.[StandardCost]
			,source.[FinishedGoodFlag]
			,source.[Color]
			,source.[ListPrice]
			,source.[Size]
			,source.[SizeUnitMeasureCode]
			,source.[Weight]
			,source.[WeightUnitMeasureCode]
			,source.[DaysToManufacture]
			,source.[ProductLine]
			,source.[Class]
			,source.[Style]
			,source.[ProductCategoryID]
			,source.[ProductCategoryName]
			,source.[ProductSubcategoryID]
			,source.[ProductSubcategoryName]
			,source.[ProductModelID]
			,source.[ProductModelName]
			,source.[SellStartDate]
			,source.[SellEndDate]
			,source.[SourceModifiedDate]
			,source.[ManufactoryID]
			,source.[ManufactoryName]
			,source.[DateFrom]
			,source.[DateTo]
			,source.[CurrentRowIndicator] 
			);

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 999, @Comment = 'End proc'

END TRY

BEGIN CATCH

EXEC [log].[ErrorCall] 

END CATCH
		
--SELECT * FROM dimProduct