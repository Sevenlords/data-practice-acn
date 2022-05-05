ALTER PROCEDURE [dbo].[LoadDimProduct]
AS

--TRUNCATE TABLE dbo.DimProduct

DROP TABLE IF EXISTS #product


SELECT   
	P.ProductID AS [ProductID],
	P.Name AS [ProductName],
	P.ProductNumber AS [ProductAlternateKey],
	P.StandardCost AS [StandartCost],
	P.FinishedGoodsFlag AS [FinishedGoodFlag],
	ISNULL(P.Color, 'N/D') AS [Color],
	P.ListPrice AS [ListPrice],
	ISNULL(P.Size, 'N/D') AS [Size],
	ISNULL(P.SizeUnitMeasureCode, 'N/D') AS [SizeUnitMeasureCode],
	ISNULL(CAST(P.Weight AS char), 0) AS [Weight],
	ISNULL(P.WeightUnitMeasureCode, 'N/D') AS [WeightUnitMeasureCode],
	P.DaysToManufacture AS [DaysToManufacture],
	ISNULL(CAST(P.ProductLine AS nvarchar(3)), 'N/D') AS [ProductLine],
	ISNULL(CAST(P.Class AS nvarchar(3)), 'N/D') AS [Class],
	ISNULL(CAST(P.Style AS nvarchar(3)), 'N/D') AS [Style],
	ISNULL(PS.ProductCategoryID, 0) AS [ProductCategoryID],
	ISNULL(PC.Name, 'N/D') AS [ProductCategoryName],
	ISNULL(PS.ProductSubcategoryID, 0) AS [ProductSubcategoryID],
	ISNULL(PS.Name, 'N/D') AS [ProductSubcategoryName],
	ISNULL(P.ProductModelID, 0) AS [ProductModelID],
	ISNULL(PM.Name, 'N/D') AS [ProductModelName],
	P.SellStartDate AS [SellStartDate],
	ISNULL(P.SellEndDate, '2100') AS [SellEndDate],
	P.ModifiedDate AS [SourceModifiedDate]
INTO #product
	FROM [stg].[Production_Product] AS P
	LEFT JOIN [stg].[Production_ProductModel] AS PM
	ON P.ProductModelID = PM.ProductModelID
	LEFT JOIN [stg].[Production_ProductSubcategory] AS PS
	ON P.ProductSubcategoryID = PS.ProductSubcategoryID
	LEFT JOIN [stg].[Production_ProductCategory] AS PC
	ON PC.ProductCategoryID = PS.ProductCategoryID

MERGE dbo.dimProduct AS dP
USING #product AS P
ON dP.ProductID = P.ProductID
WHEN MATCHED AND dP.[ProductName] <> P.[ProductName]
      OR dP.[ProductAlternateKey] <> P.[ProductAlternateKey]
      OR dP.[StandartCost] <> P.[StandartCost]
      OR dP.[FinishedGoodFlag] <> P.[FinishedGoodFlag] 
      OR dP.[Color] <> P.[Color]
      OR dP.[ListPrice] <> P.[ListPrice]
      OR dP.[Size] <> P.[Size]
      OR dP.[SizeUnitMeasureCode] <> P.[SizeUnitMeasureCode]
      OR dP.[Weight] <> P.[Weight]
      OR dP.[WeightUnitMeasureCode] <> P.[WeightUnitMeasureCode]
      OR dP.[DaysToManufacture] <> P.[DaysToManufacture]
	  OR dP.[ProductLine] <> P.[ProductLine] 
	  OR dP.[Class] <> P.[Class]
	  OR dP.[Style] <> P.[Style]
	  OR dP.[ProductCategoryID] <> P.[ProductCategoryID]
	  OR dP.[ProductCategoryName] <> P.[ProductCategoryName]
	  OR dP.[ProductSubcategoryID] <> P.[ProductSubcategoryID]
	  OR dP.[ProductSubcategoryName] <> P.[ProductSubcategoryName] 
	  OR dP.[ProductModelID] <> P.[ProductModelID]
	  OR dP.[ProductModelName] <> P.[ProductModelName]
	  OR dP.[SellStartDate] <>  P.[SellStartDate]
	  OR dP.[SellEndDate] <> P.[SellEndDate]
   THEN UPDATE SET 
         dP.[ProductName] = P.[ProductName],
      dP.[ProductAlternateKey] = P.[ProductAlternateKey],
      dP.[StandartCost] = P.[StandartCost],
      dP.[FinishedGoodFlag] = P.[FinishedGoodFlag] ,
      dP.[Color] = P.[Color],
      dP.[ListPrice] = P.[ListPrice],
      dP.[Size] = P.[Size],
      dP.[SizeUnitMeasureCode] = P.[SizeUnitMeasureCode],
      dP.[Weight] = P.[Weight],
      dP.[WeightUnitMeasureCode] = P.[WeightUnitMeasureCode],
      dP.[DaysToManufacture] = P.[DaysToManufacture],
	  dP.[ProductLine] = P.[ProductLine],
	  dP.[Class] = P.[Class],
	  dP.[Style] = P.[Style],
	  dP.[ProductCategoryID] = P.[ProductCategoryID],
	  dP.[ProductCategoryName] = P.[ProductCategoryName],
	  dP.[ProductSubcategoryID] = P.[ProductSubcategoryID],
	  dP.[ProductSubcategoryName] = P.[ProductSubcategoryName],
	  dP.[ProductModelID] = P.[ProductModelID],
	  dP.[ProductModelName] = P.[ProductModelName],
	  dP.[SellStartDate] =  P.[SellStartDate],
	  dP.[SellEndDate] = P.[SellEndDate],
	  dP.[ModifiedDate] = GETDATE()

WHEN NOT MATCHED BY TARGET
THEN INSERT (
	[ProductID],
	[ProductName],
	[ProductAlternateKey],
	[StandartCost],
	[FinishedGoodFlag],
	[Color],
	[ListPrice],
	[Size],
	[SizeUnitMeasureCode],
	[Weight],
	[WeightUnitMeasureCode],
	[DaysToManufacture],
	[ProductLine],
	[Class],
	[Style],
	[ProductCategoryID],
	[ProductCategoryName],
	[ProductSubcategoryID],
	[ProductSubcategoryName],
	[ProductModelID],
	[ProductModelName],
	[SellStartDate],
	[SellEndDate],
	[SourceModifiedDate],
	[CreatedDate],
	[ModifiedDate])
VALUES (
	P.[ProductID],
	P.[ProductName],
	P.[ProductAlternateKey],
	P.[StandartCost],
	P.[FinishedGoodFlag],
	P.[Color],
	P.[ListPrice],
	P.[Size],
	P.[SizeUnitMeasureCode],
	P.[Weight],
	P.[WeightUnitMeasureCode],
	P.[DaysToManufacture],
	P.[ProductLine],
	P.[Class],
	P.[Style],
	P.[ProductCategoryID],
	P.[ProductCategoryName],
	P.[ProductSubcategoryID],
	P.[ProductSubcategoryName],
	P.[ProductModelID],
	P.[ProductModelName],
	P.[SellStartDate],
	P.[SellEndDate],
	P.[SourceModifiedDate],
	GETDATE(),
	GETDATE());
