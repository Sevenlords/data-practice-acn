
--DROP TABLE dbo.DimProduct

CREATE procedure [dbo].[LoadDimProduct]
as

--truncate table dbo.DimProduct

DROP TABLE if exists #product


SELECT
	--ROW_NUMBER()OVER (ORDER BY ProductID) 			
	--											AS	[ProductKey],
	P.ProductID									AS	[ProductID]
	,P.Name										AS	[ProductName]
	,P.ProductNumber							AS	[ProductAlternateKey]
	,P.StandardCost								AS	[StandardCost]
	,P.FinishedGoodsFlag						AS	[FinishedGoodFlag]
	,ISNULL(P.Color, 'N/D')						AS	[Color]
	,P.ListPrice								AS	[ListPrice]
	,ISNULL(P.Size, 'N/D')						AS	[Size]
	,ISNULL(P.SizeUnitMeasureCode, 'N/D')		AS	[SizeUnitMeasureCode]
	,P.Weight									AS	[Weight]
	,ISNULL(P.WeightUnitMeasureCode, 'N/D')		AS	[WeightUnitMeasureCode]
	,P.DaysToManufacture						AS	[DaysToManufacture]
	,ISNULL(P.ProductLine, 'N/D')			
												AS	[ProductLine]
	,ISNULL(P.Class, 'N/D')						AS	[Class]
	,ISNULL(P.Style, 'N/D')						AS	[Style]
	,S.ProductCategoryID						AS	[ProductCategoryID]
	,ISNULL(C.Name, 'N/D')						AS	[ProductCategoryName]
	,S.ProductSubcategoryID						AS	[ProductSubcategoryID]
	,ISNULL(S.Name, 'N/D')						AS	[ProductSubcategoryName]
	,P.ProductModelID 							AS	[ProductModelID]
	,ISNULL(M.Name, 'N/D')						AS	[ProductModelName]
	,P.SellStartDate							AS	[SellStartDate]
	,P.SellEndDate								AS	[SellEndDate]
	,P.ModifiedDate								AS	[SourceModifiedDate]		
INTO #product	
FROM [AdventureWorks2017].[Production].[Product] AS P
	LEFT JOIN [AdventureWorks2017].[Production].[ProductModel] AS M
	ON M.ProductModelID = P.ProductModelID
	LEFT JOIN [AdventureWorks2017].[Production].[ProductSubcategory] AS S
	ON	S.ProductSubcategoryID = P.ProductSubcategoryID
	LEFT JOIN [AdventureWorks2017].[Production].[ProductCategory] AS C
	ON S.ProductCategoryID = C.ProductcategoryID
			
UPDATE a
SET 
	[ProductName] = b.[ProductName]
	,[ProductAlternateKey] = b.[ProductAlternateKey]
	,[StandardCost] = b.[StandardCost]
	,[FinishedGoodFlag] = b.[FinishedGoodFlag]
	,[Color] = b.[Color]
	,[ListPrice] = b.[ListPrice]
	,[Size] = b.[Size]
	,[SizeUnitMeasureCode] = b.[SizeUnitMeasureCode]
	,[Weight] = b.[Weight]
	,[WeightUnitMeasureCode] = b.[WeightUnitMeasureCode]
	,[DaysToManufacture] = b.[DaysToManufacture]
	,[ProductLine] = b.[ProductLine]
	,[Class] = b.[Class]
	,[Style] = b.[Style]
	,[ProductCategoryID] = b.[ProductCategoryID]
	--,[ProductCategoryName] 
	--,[ProductSubcategoryID]
	--,[ProductSubcategoryName]
	--,[ProductModelID]
	--,[ProductModelName] 
	--,[SellStartDate]
	--,[SellEndDate] 
	,[SourceModifiedDate] = b.[SourceModifiedDate]	
FROM dimProduct a
	JOIN #product b ON a.ProductID = b.ProductID

INSERT INTO [dbo].[DimProduct]
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
	,[CreatedDate] 
	,[ModifiedDate] 
)

SELECT a.*, getdate(), getdate()
FROM #product a
LEFT JOIN dimProduct b ON a.ProductID = b.ProductID
WHERE b.ProductID IS NULL

			
SELECT * FROM dimProduct