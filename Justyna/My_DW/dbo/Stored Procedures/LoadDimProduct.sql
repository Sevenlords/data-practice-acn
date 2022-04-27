CREATE PROCEDURE [dbo].[LoadDimProduct]
AS

TRUNCATE TABLE dbo.DimProduct

INSERT INTO dbo.DimProduct
		([ProductID]
      ,[ProductName]
      ,[ProductAlternateKey]
      ,[StandartCost]
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
)

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

	FROM [stg].[Production_Product] AS P
	LEFT JOIN [stg].[Production_ProductModel] AS PM
	ON P.ProductModelID = PM.ProductModelID
	LEFT JOIN [stg].[Production_ProductSubcategory] AS PS
	ON P.ProductSubcategoryID = PS.ProductSubcategoryID
	LEFT JOIN [stg].[Production_ProductCategory] AS PC
	ON PC.ProductCategoryID = PS.ProductCategoryID