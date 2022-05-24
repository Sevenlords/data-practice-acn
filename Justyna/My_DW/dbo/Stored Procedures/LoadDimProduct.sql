CREATE PROCEDURE [dbo].[LoadDimProduct]
AS
BEGIN
--TRUNCATE TABLE dbo.DimProduct

EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 1, @Comment = 'Start Proc'
BEGIN TRY
	UPDATE dP
	SET CurrentRowIndicator = 'Expired',
		DateTo = CAST(DATEADD(DD, -1,D.Date) AS date)
	FROM [dbo].[DimProduct] dP
		JOIN [stg].[Product_manufactory] PMAN
			ON dP.ProductID = PMAN.ProductID AND dP.ManufactoryId <> PMAN.ManufactoryId
		JOIN [dbo].[DimDate]  D
			ON D.DateKey = PMAN.DateFrom

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
		P.ModifiedDate AS [SourceModifiedDate],
		ISNULL(PMAN.ManufactoryId, 'N/D') AS [ManufactoryId],
		ISNULL(MAN.ManufactoryName, 'N/D') AS [ManufactoryName],
		ISNULL(PMAN.DateFrom, 'N/D') AS [DateFrom],
		ISNULL(PMAN.DateTo, 'N/D') AS [DateTo],
		'Current' AS [CurrentRowIndicator]

	INTO #product
		FROM [stg].[Production_Product] AS P
		LEFT JOIN [stg].[Production_ProductModel] AS PM
		ON P.ProductModelID = PM.ProductModelID
		LEFT JOIN [stg].[Production_ProductSubcategory] AS PS
		ON P.ProductSubcategoryID = PS.ProductSubcategoryID
		LEFT JOIN [stg].[Production_ProductCategory] AS PC
		ON PC.ProductCategoryID = PS.ProductCategoryID
		LEFT JOIN [stg].[Product_manufactory] PMAN
		ON P.ProductID = PMAN.ProductId
		LEFT JOIN [stg].[Manufactories] MAN
		ON PMAN.ManufactoryId = MAN.ManufactoryId



	MERGE dbo.dimProduct AS TARGET
	USING #product AS SOURCE
	ON TARGET.ProductID = SOURCE.ProductID AND TARGET.ManufactoryId = SOURCE.ManufactoryId
	WHEN MATCHED AND TARGET.[ProductName] <> SOURCE.[ProductName]
		  OR TARGET.[ProductAlternateKey] <> SOURCE.[ProductAlternateKey]
		  OR TARGET.[StandartCost] <> SOURCE.[StandartCost]
		  OR TARGET.[FinishedGoodFlag] <> SOURCE.[FinishedGoodFlag] 
		  OR TARGET.[Color] <> SOURCE.[Color]
		  OR TARGET.[ListPrice] <> SOURCE.[ListPrice]
		  OR TARGET.[Size] <> SOURCE.[Size]
		  OR TARGET.[SizeUnitMeasureCode] <> SOURCE.[SizeUnitMeasureCode]
		  OR TARGET.[Weight] <> SOURCE.[Weight]
		  OR TARGET.[WeightUnitMeasureCode] <> SOURCE.[WeightUnitMeasureCode]
		  OR TARGET.[DaysToManufacture] <> SOURCE.[DaysToManufacture]
		  OR TARGET.[ProductLine] <> SOURCE.[ProductLine] 
		  OR TARGET.[Class] <> SOURCE.[Class]
		  OR TARGET.[Style] <> SOURCE.[Style]
		  OR TARGET.[ProductCategoryID] <> SOURCE.[ProductCategoryID]
		  OR TARGET.[ProductCategoryName] <> SOURCE.[ProductCategoryName]
		  OR TARGET.[ProductSubcategoryID] <> SOURCE.[ProductSubcategoryID]
		  OR TARGET.[ProductSubcategoryName] <> SOURCE.[ProductSubcategoryName] 
		  OR TARGET.[ProductModelID] <> SOURCE.[ProductModelID]
		  OR TARGET.[ProductModelName] <> SOURCE.[ProductModelName]
		  OR TARGET.[SellStartDate] <>  SOURCE.[SellStartDate]
		  OR TARGET.[SellEndDate] <> SOURCE.[SellEndDate]
		  OR TARGET.[ManufactoryId] <> SOURCE.[ManufactoryId] OR TARGET.[ManufactoryId] IS NULL
		  OR TARGET.[ManufactoryName] <> SOURCE.[ManufactoryName] OR TARGET.[ManufactoryName] IS NULL
		  OR TARGET.[DateFrom] <> SOURCE.[DateFrom] OR TARGET.[DateFrom] IS NULL
		  OR TARGET.[DateTo] <> SOURCE.[DateTo] OR TARGET.[DateTo] IS NULL
		  OR TARGET.[CurrentRowIndicator] <> SOURCE.[CurrentRowIndicator] OR TARGET.[CurrentRowIndicator] IS NULL
	   THEN UPDATE SET 
		  [ProductName] = SOURCE.[ProductName],
		  [ProductAlternateKey] = SOURCE.[ProductAlternateKey],
		  [StandartCost] = SOURCE.[StandartCost],
		  [FinishedGoodFlag] = SOURCE.[FinishedGoodFlag] ,
		  [Color] = SOURCE.[Color],
		  [ListPrice] = SOURCE.[ListPrice],
		  [Size] = SOURCE.[Size],
		  [SizeUnitMeasureCode] = SOURCE.[SizeUnitMeasureCode],
		  [Weight] = SOURCE.[Weight],
		  [WeightUnitMeasureCode] = SOURCE.[WeightUnitMeasureCode],
		  [DaysToManufacture] = SOURCE.[DaysToManufacture],
		  [ProductLine] = SOURCE.[ProductLine],
		  [Class] = SOURCE.[Class],
		  [Style] = SOURCE.[Style],
		  [ProductCategoryID] = SOURCE.[ProductCategoryID],
		  [ProductCategoryName] = SOURCE.[ProductCategoryName],
		  [ProductSubcategoryID] = SOURCE.[ProductSubcategoryID],
		  [ProductSubcategoryName] = SOURCE.[ProductSubcategoryName],
		  [ProductModelID] = SOURCE.[ProductModelID],
		  [ProductModelName] = SOURCE.[ProductModelName],
		  [SellStartDate] = SOURCE.[SellStartDate],
		  [SellEndDate] = SOURCE.[SellEndDate],
		  [ModifiedDate] = GETDATE(),
		  [ManufactoryId] = SOURCE.[ManufactoryId],
		  [ManufactoryName] = SOURCE.[ManufactoryName],
		  [DateFrom] = SOURCE.[DateFrom],
		  [DateTo] = SOURCE.[DateTo],
		  [CurrentRowIndicator] = SOURCE.[CurrentRowIndicator]
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
		[ModifiedDate],
		[ManufactoryId],
		[ManufactoryName],
		[DateFrom],
		[DateTo],
		[CurrentRowIndicator])
	VALUES (
		SOURCE.[ProductID],
		SOURCE.[ProductName],
		SOURCE.[ProductAlternateKey],
		SOURCE.[StandartCost],
		SOURCE.[FinishedGoodFlag],
		SOURCE.[Color],
		SOURCE.[ListPrice],
		SOURCE.[Size],
		SOURCE.[SizeUnitMeasureCode],
		SOURCE.[Weight],
		SOURCE.[WeightUnitMeasureCode],
		SOURCE.[DaysToManufacture],
		SOURCE.[ProductLine],
		SOURCE.[Class],
		SOURCE.[Style],
		SOURCE.[ProductCategoryID],
		SOURCE.[ProductCategoryName],
		SOURCE.[ProductSubcategoryID],
		SOURCE.[ProductSubcategoryName],
		SOURCE.[ProductModelID],
		SOURCE.[ProductModelName],
		SOURCE.[SellStartDate],
		SOURCE.[SellEndDate],
		SOURCE.[SourceModifiedDate],
		GETDATE(),
		GETDATE(),
		SOURCE.[ManufactoryId],
		SOURCE.[ManufactoryName],
		SOURCE.[DateFrom],
		SOURCE.[DateTo],
		SOURCE.[CurrentRowIndicator]);

	EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 999, @Comment = 'End Proc'
END TRY

BEGIN CATCH
	EXEC [log].[ErrorCall]
END CATCH
END