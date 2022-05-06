CREATE procedure [dbo].[LoadDimProduct]
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
		ISNULL(P.Weight, 0) AS [Weight],
		ISNULL(P.WeightUnitMeasureCode, 'N/D') AS [WeightUnitMeasureCode],
		P.DaysToManufacture AS [DaysToManufacture],
		ISNULL(CONVERT(nchar(3),P.ProductLine), 'N/D') AS [ProductLine],
		ISNULL(CONVERT(nchar(3),P.Class), 'N/D') AS [Class],
		ISNULL(CONVERT(nchar(3),P.Style), 'N/D') AS [Style],
		isnull(PS.ProductCategoryID, 0) AS [ProductCategoryID],
		ISNULL(PC.Name, 'N/D') AS [ProductCategoryName],
		isnull(P.ProductSubcategoryID, 0) AS [ProductSubcategoryID],
		ISNULL(PS.Name, 'N/D')  AS [ProductSubcategoryName],
		isnull(P.ProductModelID, 0) AS [ProductModelID],
		ISNULL(PM.Name, 'N/D')  AS [ProductModelName],
		P.SellStartDate AS [SellStartDate],
		isnull(P.SellEndDate, '20990101') AS [SellEndDate],
		P.ModifiedDate AS [SourceModifiedDate]
into #product
FROM [AdventureWorks2017].[Production].[Product] AS P
		LEFT JOIN [AdventureWorks2017].[Production].[ProductSubcategory] AS PS
		ON P.ProductSubcategoryID = PS.ProductSubcategoryID
		LEFT JOIN [AdventureWorks2017].[Production].[ProductCategory] AS PC
		ON PS.ProductCategoryID = PC.ProductCategoryID
		LEFT JOIN [AdventureWorks2017].[Production].[ProductModel] AS PM
		ON P.ProductModelID = PM.ProductModelID



insert into [dbo].[DimProduct]
([ProductID]
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
	  ,[SourceModifiedDate]
	  ,[CreatedDate]
	  ,[ModifiedDate])
	  SELECT a.*, getdate(), getdate()
from #product a 
	left join DimProduct b on a.ProductID = b.ProductID 
where b.ProductID is null 

update a 
set [ProductName] = b.[ProductName]
      ,[ProductAlternateKey]=b.[ProductAlternateKey]
      ,[StandardCost]=b.[StandardCost]
      ,[FinishedGoodsFlag]=b.[FinishedGoodsFlag]
      ,[Color]=b.[Color]
      ,[ListPrice]=b.[ListPrice]
      ,[Size]=b.[Size]
      ,[SizeUnitMeasureCode]=b.[SizeUnitMeasureCode]
      ,[Weight]=b.[Weight]
      ,[WeightUnitMeasureCode]=b.[WeightUnitMeasureCode]
      ,[DaysToManufacture]=b.[DaysToManufacture]
      ,[ProductLine]=b.[ProductLine]
      ,[Class]=b.[Class]
      ,[Style]=b.[Style]
      ,[ProductCategoryID]=b.[ProductCategoryID]
      ,[ProductCategoryName]=b.[ProductCategoryName]
      ,[ProductSubcategoryID]=b.[ProductSubcategoryID]
      ,[ProductSubcategoryName]=b.[ProductSubcategoryName]
      ,[ProductModelID]=b.[ProductModelID]
      ,[ProductModelName]=b.[ProductModelName]
      ,[SellStartDate]=b.[SellStartDate]
      ,[SellEndDate]=b.[SellEndDate]
	  ,[ModifiedDate] = getdate()
from DimProduct a 
	join #product b ON a.ProductID = b.ProductID

	delete a
from DimProduct a 
left join #product b on a.ProductID = b.ProductID
where b.ProductID is null
