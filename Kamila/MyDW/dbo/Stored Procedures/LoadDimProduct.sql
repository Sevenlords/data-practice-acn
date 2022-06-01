











CREATE PROCEDURE [dbo].[LoadDimProduct]
as

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 1, @Comment = 'Start procedure'

BEGIN TRY

DELETE FROM DimProduct where ProductKey=-1

SET IDENTITY_INSERT DimProduct ON

INSERT INTO DimProduct ([ProductKey]
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
      ,[ManufactoryId]
      ,[ManufactoryName]
      ,[DateFrom]
      ,[DateTo]
      ,[CurrentRowIndicator])
	  SELECT
	  -1 [ProductKey]
      ,-1[ProductID]
      ,'N/D'[ProductName]
      ,'N/D'[ProductAlternateKey]
      ,-1[StandardCost]
      ,0[FinishedGoodFlag]
      ,'N/D'[Color]
      ,-1[ListPrice]
      ,-1[Size]
      ,'N/D' [SizeUnitMeasureCode]
      ,-1 [Weight]
      ,'N/D' [WeightUnitMeasureCode]
      ,-1 [DaysToManufacture]
      ,'-1' [ProductLine]
      ,'-1'[Class]
      ,'-1'[Style]
      ,-1[ProductCategoryID]
      ,'-1'[ProductCategoryName]
      ,-1[ProductSubcategoryID]
      ,'-1'[ProductSubcategoryName]
      ,-1[ProductModelID]
      ,'-1'[ProductModelName]
      ,getdate()[SellStartDate]
      ,getdate()[SellEndDate]
      ,getdate()[SourceModifiedDate]
      ,getdate()[CreatedDate]
      ,getdate()[ModifiedDate]
      ,-1[ManufactoryId]
      ,'-1'[ManufactoryName]
      ,getdate()[DateFrom]
      ,getdate()[DateTo]
      ,'-1'[CurrentRowIndicator]

SET IDENTITY_INSERT DimProduct OFF

UPDATE a SET CurrentRowIndicator = 'Expired',
	DateTo = cast(DATEADD(DD, -1, c.Date) as date)
--SELECT a.ProductID, a.ManufactoryID, b.ManufactoryID, a.CurrentRowIndicator, a.DateTo, b.DateFrom, DATEADD(DD, -1, c.Date)
FROM DimProduct a 
	JOIN stg.product_manufactory b ON a.ProductID=b.ProductID AND a.ManufactoryId <> b.ManufactoryId
	JOIN dimDate c ON b.DateFrom = c.DateKey

drop table if exists #product

SELECT
		P.ProductID AS [ProductID],
		P.Name AS [ProductName],
		P.ProductNumber AS [ProductAlternateKey],
		P.StandardCost AS [StandardCost],
		P.FinishedGoodsFlag AS [FinishedGoodsFlag],
		ISNULL(P.Color, 'N/D') AS [Color],
		P.ListPrice AS [ListPrice],
		ISNULL(P.Size, 'N/D') AS [Size],
		ISNULL(P.SizeUnitMeasureCode, 'N/D') AS [SizeUnitMeasureCode],
		ISNULL(P.Weight, -1) AS [Weight],
		ISNULL(P.WeightUnitMeasureCode, 'N/D') AS [WeightUnitMeasureCode],
		P.DaysToManufacture AS [DaysToManufacture],
		ISNULL(CONVERT(nchar(3),P.ProductLine), 'N/D') AS [ProductLine],
		ISNULL(CONVERT(nchar(3),P.Class), 'N/D') AS [Class],
		ISNULL(CONVERT(nchar(3),P.Style), 'N/D') AS [Style],
		ISNULL(PS.ProductCategoryID, 0) AS [ProductCategoryID],
		ISNULL(PC.Name, 'N/D') AS [ProductCategoryName],
		ISNULL(P.ProductSubcategoryID, -1) AS [ProductSubcategoryID],
		ISNULL(PS.Name, 'N/D')  AS [ProductSubcategoryName],
		ISNULL(P.ProductModelID, -1) AS [ProductModelID],
		ISNULL(PM.Name, 'N/D')  AS [ProductModelName],
		ISNULL(P.SellStartDate, '1900-01-01 00:00:00.000') AS [SellStartDate],
		ISNULL(P.SellEndDate, '2100-12-31 00:00:00.000') AS [SellEndDate],
		P.ModifiedDate AS [SourceModifiedDate],
		PrMa.ManufactoryId AS [ManufactoryID],
		Ma.ManufactoryName AS [ManufactoryName],
		PrMa.DateFrom AS [DateFrom],
		PrMa.DateTo AS [DateTo],
		'Current' AS [CurrentRowIndicator]
into #product
FROM [stg].[Production_Product] AS P
		LEFT JOIN [stg].[Production_ProductSubcategory] AS PS
		ON P.ProductSubcategoryID = PS.ProductSubcategoryID
		LEFT JOIN [stg].[Production_ProductCategory] AS PC
		ON PS.ProductCategoryID = PC.ProductCategoryID
		LEFT JOIN [stg].[Production_ProductModel] AS PM
		ON P.ProductModelID = PM.ProductModelID
		LEFT JOIN [stg].[product_manufactory] PrMa
		ON P.ProductID = PrMa.ProductID
		LEFT JOIN [stg].[manufactories] Ma
		ON PrMa.ManufactoryId = Ma.ManufactoryId

MERGE INTO dbo.DimProduct as a
USING #product as b
ON a.ProductID = b.ProductID AND a.[ManufactoryId] = b.[ManufactoryId]
WHEN MATCHED AND a.[ProductName] <> b.[ProductName]
      OR a.[ProductAlternateKey] <> b.[ProductAlternateKey]
      OR a.[StandardCost] <> b.[StandardCost]
      OR a.[FinishedGoodFlag] <> b.[FinishedGoodsFlag] 
      OR a.[Color] <> b.[Color]
      OR a.[ListPrice] <> b.[ListPrice]
      OR a.[Size] <> b.[Size]
      OR a.[SizeUnitMeasureCode] <> b.[SizeUnitMeasureCode]
      OR a.[Weight] <> b.[Weight]
      OR a.[WeightUnitMeasureCode] <> b.[WeightUnitMeasureCode]
      OR a.[DaysToManufacture] <> b.[DaysToManufacture]
	  OR a.[ProductLine] <> b.[ProductLine] 
	  OR a.[Class] <> b.[Class]
	  OR a.[Style] <> b.[Style]
	  OR a.[ProductCategoryID] <> b.[ProductCategoryID]
	  OR a.[ProductCategoryName] <> b.[ProductCategoryName]
	  OR a.[ProductSubcategoryID] <> b.[ProductSubcategoryID]
	  OR a.[ProductSubcategoryName] <> b.[ProductSubcategoryName] 
	  OR a.[ProductModelID] <> b.[ProductModelID]
	  OR a.[ProductModelName] <> b.[ProductModelName]
	  OR a.[SellStartDate] <>  b.[SellStartDate]
	  OR a.[SellEndDate] <> b.[SellEndDate]
	  OR a.[ManufactoryId] <> b.[ManufactoryId] OR b.[ManufactoryId] IS NULL
	  OR a.[ManufactoryName] <> b.[ManufactoryName] OR b.[ManufactoryName] IS NULL
	  OR a.[DateFrom] <> b.[DateFrom] OR b.[DateFrom] IS NULL
	  OR a.[DateTo] <> b.[DateTo] OR b.[DateTo] IS NULL
      OR a.[CurrentRowIndicator] <> a.[CurrentRowIndicator] OR b.[CurrentRowIndicator] IS NULL
THEN UPDATE SET
	a.[ProductID] = b.[ProductID],
	a.[ProductName]= b.[ProductName],
	a.[ProductAlternateKey]= b.[ProductAlternateKey],
	a.[StandardCost]= b.[StandardCost],
	a.[FinishedGoodFlag]= b.[FinishedGoodsFlag],
	a.[Color]= b.[Color],
	a.[ListPrice]= b.[ListPrice],
	a.[Size]= b.[Size],
	a.[SizeUnitMeasureCode]= b.[SizeUnitMeasureCode],
	a.[Weight]= b.[Weight],
	a.[WeightUnitMeasureCode]= b.[WeightUnitMeasureCode],
	a.[DaysToManufacture]= b.[DaysToManufacture],
	a.[ProductLine]= b.[ProductLine],
	a.[Class]= b.[Class],
	a.[Style]= b.[Style],
	a.[ProductCategoryID]= b.[ProductCategoryID],
	a.[ProductCategoryName]= b.[ProductCategoryName],
	a.[ProductSubcategoryID]= b.[ProductSubcategoryID],
	a.[ProductSubcategoryName]= b.[ProductSubcategoryName],
	a.[ProductModelID]= b.[ProductModelID],
	a.[ProductModelName]= b.[ProductModelName],
	a.[SellStartDate]= b.[SellStartDate],
	a.[SellEndDate]= b.[SellEndDate],
	a.[SourceModifiedDate]= b.[SourceModifiedDate],
	--a.[CreatedDate] = GETDATE(),
	a.[ModifiedDate] = GETDATE(),
	a.[ManufactoryId] = b.[ManufactoryID],
	a.[ManufactoryName] = b.[ManufactoryName],
	a.[DateFrom] = b.[DateFrom],
	a.[DateTo] = b.[DateTo],
	a.[CurrentRowIndicator] = b.[CurrentRowIndicator]
WHEN NOT MATCHED THEN
INSERT (
		[ProductID],
		[ProductName],
		[ProductAlternateKey],
		[StandardCost],
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
		[ModifiedDate],
		[ManufactoryId],
		[ManufactoryName],
		[DateFrom],
		[DateTo],
		[CurrentRowIndicator]
		)
	VALUES(
		b.[ProductID],
		b.[ProductName],
		b.[ProductAlternateKey],
		b.[StandardCost],
		b.[FinishedGoodsFlag],
		b.[Color],
		b.[ListPrice],
		b.[Size],
		b.[SizeUnitMeasureCode],
		b.[Weight],
		b.[WeightUnitMeasureCode],
		b.[DaysToManufacture],
		b.[ProductLine],
		b.[Class],
		b.[Style],
		b.[ProductCategoryID],
		b.[ProductCategoryName],
		b.[ProductSubcategoryID],
		b.[ProductSubcategoryName],
		b.[ProductModelID],
		b.[ProductModelName],
		b.[SellStartDate],
		b.[SellEndDate],
		b.[SourceModifiedDate],
		GETDATE(),
		GETDATE(),
		b.[ManufactoryId],
		b.[ManufactoryName],
		b.[DateFrom],
		b.[DateTo],
		b.[CurrentRowIndicator]
		);

EXEC [log].[ProcedureCall] @ProcedureName = @@PROCID, @Step = 99, @Comment = 'Finish procedure'

END TRY

BEGIN CATCH

EXEC [log].[ErrorCall] --@ErrorNumber =  ERROR_NUMBER(), @ErrorState = ERROR_STATE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorLine =  ERROR_LINE(), @ErrorProcedure = ERROR_PROCEDURE(), @ErrorMessage = ERROR_MESSAGE()


END CATCH
