



CREATE PROCEDURE [dbo].[LoadDimProduct]
as

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
		P.ModifiedDate AS [SourceModifiedDate]
into #product
FROM [stg].[Production_Product] AS P
		LEFT JOIN [stg].[Production_ProductSubcategory] AS PS
		ON P.ProductSubcategoryID = PS.ProductSubcategoryID
		LEFT JOIN [stg].[Production_ProductCategory] AS PC
		ON PS.ProductCategoryID = PC.ProductCategoryID
		LEFT JOIN [stg].[Production_ProductModel] AS PM
		ON P.ProductModelID = PM.ProductModelID


MERGE INTO dbo.DimProduct as a
USING #product as b
ON a.ProductID = b.ProductID
WHEN MATCHED
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
	a.[ModifiedDate] = GETDATE()
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
		[ModifiedDate]
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
		GETDATE()
		);
