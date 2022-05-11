create procedure dw.load_dim_product as

--truncate table dw.dim_product

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
into #product
FROM [AdventureWorks2017].[Production].[Product] AS P
		LEFT JOIN [AdventureWorks2017].[Production].[ProductSubcategory] AS PS
		ON P.ProductSubcategoryID = PS.ProductSubcategoryID
		LEFT JOIN [AdventureWorks2017].[Production].[ProductCategory] AS PC
		ON PS.ProductCategoryID = PC.ProductCategoryID
		LEFT JOIN [AdventureWorks2017].[Production].[ProductModel] AS PM
		ON P.ProductModelID = PM.ProductModelID

select * from #product

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
      ,[ProductCategoryName] = b.[ProductCategoryName]
      ,[ProductSubcategoryID] = b.[ProductSubcategoryID]
      ,[ProductSubcategoryName] = b.[ProductSubcategoryName]
      ,[ProductModelID]=b.[ProductModelID]
      ,[ProductModelName]=b.[ProductModelName]
      ,[SellStartDate]=b.[SellStartDate]
      ,[SellEndDate] = b.[SellEndDate]
	  ,ModifiedDate = getdate()
from DimProduct a 
	join #product b ON a.ProductID = b.ProductID


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
      ,[SourceModifiedDate]
	  ,CreatedDate
	  ,ModifiedDate)

SELECT a.*, getdate(), getdate()
from #product a 
	left join DimProduct b on a.ProductID = b.ProductID 
where b.ProductID is null 







--insert into dw.dim_product(
--	PP.ProductID, ProductName, 
--	ProductAlternateKey,
--	PP.StandardCost, PP.FinishedGoodsFlag, PP.Color, 
--	pp.ListPrice, PP.Size, PP.SizeUnitMeasureCode, PP.Weight,
--	PP.WeightUnitMeasureCode, PP.DaysToManufacture,
--	PP.ProductLine, PP.Class, PP.Style, 
--	PS.ProductCategoryID, ProductCategoryName, PS.ProductSubcategoryID, 
--	ProductSubcategoryName, pm.ProductModelID, ProductModelName, 
--	pp.SellStartDate, pp.SellEndDate,SourceModifiedDate, pp.Timestamp
--)
--select
--	PP.ProductID, PP.name ProductName, 
--	PP.ProductNumber as ProductAlternateKey,
--	PP.StandardCost, PP.FinishedGoodsFlag, PP.Color, 
--	pp.ListPrice, PP.Size, PP.SizeUnitMeasureCode, PP.Weight,
--	PP.WeightUnitMeasureCode, PP.DaysToManufacture,
--	PP.ProductLine, PP.Class, PP.Style, 
--	PS.ProductCategoryID, PC.Name ProductCategoryName, PS.ProductSubcategoryID, 
--	PS.Name ProductSubcategoryName, pm.ProductModelID, pm.Name ProductModelName, 
--	pp.SellStartDate, pp.SellEndDate, pp.ModifiedDate SourceModifiedDate, pp.Timestamp

--from
--	stg.production_product PP
--	left join stg.prod_prod_subcategory PS on PP.ProductSubcategoryID = PS.ProductSubcategoryID
--	full outer join stg.prod_prod_category PC on PC.ProductCategoryID = PS.ProductCategoryID
--	left join stg.product_model PM on PP.ProductID = PM.ProductModelID