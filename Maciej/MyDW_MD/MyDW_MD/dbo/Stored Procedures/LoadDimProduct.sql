CREATE procedure [dbo].[LoadDimProduct]
as

drop table if exists #product

SELECT
		 p.ProductID
	,p.Name ProductName
	,p.ProductNumber ProductAlternateKey
	,p.StandardCost
	,p.FinishedGoodsFlag
	,ISNULL(p.Color, 'N/D') Color
	,p.ListPrice
	,ISNULL(p.Size, 'N/D') Size
	,ISNULL(p.SizeUnitMeasureCode, 'N/D') SizeUnitMeasureCode
	,ISNULL(p.Weight, 0) Weight
	,ISNULL(p.WeightUnitMeasureCode, 'N/D') WeightUnitMeasureCode
	,p.DaysToManufacture
	,ISNULL(cast(p.ProductLine as nvarchar(3)), 'N/D') ProductLine
	,ISNULL(cast(p.Class as nvarchar(3)),'N/D') Class
	,ISNULL(cast(p.Style as nvarchar(3)),'N/D') Style
	,ISNULL(c.ProductCategoryID, 0) ProductCategoryID
	,ISNULL(c.Name, 'N/D') ProductCategoryName
	,ISNULL(s.ProductSubcategoryID, 0) ProductSubcategoryID
	,ISNULL(s.Name, 'N/D') ProductSubcategoryName
	,ISNULL(m.ProductModelID, 0) ProductModelID
	,ISNULL(m.Name, 'N/D') ProductModelName
	,p.SellStartDate
	,ISNULL(p.SellEndDate,'20990101') SellEndDate
	,p.ModifiedDate SourceModifiedDate
into #product
FROM [stg].Production_Product p 
	left join [stg].Production_ProductModel m on p.ProductModelID = m.ProductModelID
	left join [stg].[Production_ProductSubcategory] s on p.ProductSubcategoryID = s.ProductSubcategoryID
	left join [stg].Production_ProductCategory c on s.ProductCategoryID = c.ProductCategoryID


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
