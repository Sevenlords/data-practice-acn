
CREATE procedure [dbo].[LoadDimProduct]
as

truncate table dbo.DimProduct

insert into [dbo].[DimProduct]
(
[ProductID] ,
[ProductName] , 
[ProductAlternateKey], 
[StandardCost] , 
[FinishedGoodFlag] ,
[Color], 
[ListPrice], 
[Size], 
[SizeUnitMeasureCode] , 
[Weight], 
[WeightUnitMeasureCode],
[DaysToManufacture],
[ProductLine],
[Class], 
[Style], 
[ProductCategoryID] ,
[ProductCategoryName] ,
[ProductSubcategoryID] ,
[ProductSubcategoryName] ,
[ProductModelID],
[ProductModelName],
[SellStartDate] ,
[SellEndDate],
[SoureceModifiedDate] 
)
select 
p.ProductID as [ProductID], 
p.Name as [ProductName], 
p.ProductNumber as [ProductAlternateKey] , 
p.StandardCost as [StandardCost], 
p.FinishedGoodsFlag as [FinishedGoodFlag],
isnull(p.Color, 'N/D') as[Color],
p.ListPrice as [ListPrice], 
isnull(p.size, 'N/D') as[Size],
isnull(p.SizeUnitMeasureCode, 'N/D') as [SizeUnitMeasureCode],
isnull(p.Weight, 0) as[Weight],
isnull(p.WeightUnitMeasureCode, 'N/D') as [WeightUnitMeasureCode],
p.DaysToManufacture as [DaysToManufacture], 
p.ProductLine as [ProductLine],
p.Class as Class,
p.Style as [Style], 
isnull (ps.ProductCategoryID,0 )as [ProductCategoryID],
isnull(pc.Name, 'N/D') as [ProductCategoryName],
isnull(p.ProductSubcategoryID, 0) as [ProductSubcategoryID],
isnull (ps.Name, 'N/D') as [ProductSubcategoryName],
isnull (p.ProductModelID, 0) as [ProductModelID],
isnull (pm.Name, 'N/D') as [ProductModelName],
p.SellStartDate as [SellStartDate],
isnull(p.SellEndDate, '19001231') as [SellEndDate],
p.ModifiedDate as [SoureceModifiedDate]
---audit column

from 
mydw.stg.Production_Product as p
left join mydw.stg.Production_ProductSubcategory as ps
on p.ProductSubcategoryID=ps.ProductSubcategoryID
left join mydw.stg.production_productcategory as pc
on ps.ProductCategoryID=pc.ProductCategoryID
left join mydw.stg.Production_ProductModel as pm
on p.ProductModelID=pm.ProductModelID

update mydw.dbo.dimProduct 
set 
ProductLine=coalesce(ProductLine, 'N/D'),
class=isnull(Class, 'N/D'),
style=isnull(Style, 'N/D')
GO



