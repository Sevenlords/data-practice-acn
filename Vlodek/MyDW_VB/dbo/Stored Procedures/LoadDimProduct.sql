create procedure [dbo].[LoadDimProduct]
as

truncate table [dbo].[DimProduct]

insert into [dbo].[DimProduct]
(   [ProductID]
      ,[ProductName]
      ,[ProductAlternateKey]
      ,[StandardCost]
      ,[FinishedGoodsFlag]
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
      ,[SourceModifiedDate])
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
		P.Weight AS [Weight],
		ISNULL(P.WeightUnitMeasureCode, 'N/D') AS [WeightUnitMeasureCode],
		P.DaysToManufacture AS [DaysToManufacture],
		ISNULL(CONVERT(nchar(3),P.ProductLine), 'N/D') AS [ProductLine],
		ISNULL(CONVERT(nchar(3),P.Class), 'N/D') AS [Class],
		ISNULL(CONVERT(nchar(3),P.Style), 'N/D') AS [Style],
		PS.ProductCategoryID AS [ProductCategoryID],
		ISNULL(PC.Name, 'N/D') AS [ProductCategoryName],
		P.ProductSubcategoryID AS [ProductSubcategoryID],
		ISNULL(PS.Name, 'N/D')  AS [ProductSubcategoryName],
		P.ProductModelID AS [ProductModelID],
		ISNULL(PM.Name, 'N/D')  AS [ProductModelName],
		P.SellStartDate AS [SellStartDate],
		P.SellEndDate AS [SellEndDate],
		P.ModifiedDate AS [SourceModifiedDate]
		FROM [AdventureWorks2017].[Production].[Product] AS P
		LEFT JOIN [AdventureWorks2017].[Production].[ProductSubcategory] AS PS
		ON P.ProductSubcategoryID = PS.ProductSubcategoryID
		LEFT JOIN [AdventureWorks2017].[Production].[ProductCategory] AS PC
		ON PS.ProductCategoryID = PC.ProductCategoryID
		LEFT JOIN [AdventureWorks2017].[Production].[ProductModel] AS PM
		ON P.ProductModelID = PM.ProductModelID
