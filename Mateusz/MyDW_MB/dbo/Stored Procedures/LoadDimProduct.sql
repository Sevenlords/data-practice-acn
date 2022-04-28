

CREATE procedure [dbo].[LoadDimProduct]
as

truncate table dbo.DimProduct

INSERT INTO [dbo].[DimProduct]
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
           ,[SourceModifiedDate])


select ProductID
,ProductName
,ProductAlternateKey
,StandardCost
,FinishedGoodsFlag
,Color
,ListPrice
,Size
,SizeUnitMeasureCode
,Weight
,WeightUnitMeasureCode
,DaysToManufacture
,ISNULL(ProductLine, 'N/D')
,ISNULL(Class, 'N/D')
,ISNULL(Style, 'N/D')
,ProductCategoryID
,ProductCategoryName
,ProductSubcategoryID
,ProductSubcategoryName
,ProductModelID
,ProductModelName
,SellStartDate
,SellEndDate
,SourceModifiedDate
from(
Select p.ProductID
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
,cast(p.ProductLine as nvarchar(3)) ProductLine
,cast(p.Class as nvarchar(3)) Class
,cast(p.Style as nvarchar(3)) Style
,ISNULL(c.ProductCategoryID, 0) ProductCategoryID
,ISNULL(c.Name, 'ND') ProductCategoryName
,ISNULL(s.ProductSubcategoryID, 0) ProductSubcategoryID
,ISNULL(s.Name, 'N/D') ProductSubcategoryName
,ISNULL(m.ProductModelID, 0) ProductModelID
,ISNULL(m.Name, 'N/D') ProductModelName
,p.SellStartDate
,ISNULL(p.SellEndDate, '21001231') SellEndDate
,p.ModifiedDate SourceModifiedDate
from [STG].[Production_Product] p 
left join [STG].[Production_ProductModel] m on p.ProductModelID=m.ProductModelID 
left join [STG].[Production_ProductSubcategory]  s on p.ProductSubcategoryID=s.ProductSubcategoryID
left join [STG].[Production_ProductCategory] c on s.ProductCategoryID=c.ProductCategoryID) t1

