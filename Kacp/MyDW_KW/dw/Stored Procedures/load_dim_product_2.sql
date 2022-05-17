CREATE procedure [dw].[load_dim_product] as

--truncate table dw.dim_product
update a
set CurrentFlag = 'Expired',
	DateTo = cast(dateadd(dd,-1,c.date) as date)

--select a.ProductID, a.ManufactoryID, b.manufactoryid, a.CurrentFlag, b.datefrom--cast(dateadd(dd,-1,b.datefrom) as date)
from dw.dim_product a 
	join stg.prod_manu_v1 b on a.ProductID = b.productID --and a.ManufactoryID <> b.ManufactoryID
	join dw.dim_date c on c.DateKey = b.DateFrom
	where a.ManufactoryID <> b.ManufactoryID

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
		P.ModifiedDate AS [SourceModifiedDate],
		v1.ManufactoryID as ManufactoryID,
		m1.ManufactoryName as ManufactoryName,
		v1.DateFrom,
		v1.DateTo,
		'Current' as CurrentFlag
into #product
FROM [AdventureWorks2017].[Production].[Product] AS P
		LEFT JOIN [AdventureWorks2017].[Production].[ProductSubcategory] AS PS
		ON P.ProductSubcategoryID = PS.ProductSubcategoryID
		LEFT JOIN [AdventureWorks2017].[Production].[ProductCategory] AS PC
		ON PS.ProductCategoryID = PC.ProductCategoryID
		LEFT JOIN STG.product_model PM
		ON P.ProductModelID = PM.ProductModelID
		left join stg.prod_manu_v1 v1 on v1.productid = p.ProductID
		left join stg.manu_manu_v1 m1 on m1.manufactoryID = v1.manufactoryID

--select * from #product

update a
set 
--select	
	[ProductName] = b.[ProductName]
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
	  ,[ModifiedDate] = getdate()
	  ,ManufactoryID = b.ManufactoryID
	  ,ManufactoryName = b.ManufactoryName
	  ,DateFrom = b.DateFrom
	  ,DateTo = b.DateTo
	  ,CurrentFlag = b.CurrentFlag
from dw.dim_product a 
	join #product b ON a.ProductID = b.ProductID and a.ManufactoryID = b.ManufactoryID -- collate Polish_CI_AS



insert into dw.dim_product
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
	  ,ManufactoryID
	  ,ManufactoryName
	  ,DateFrom 
	  ,DateTo 
	  ,CurrentFlag
	  ,CreatedDate
	  ,ModifiedDate
	   )

SELECT a.*, getdate(), getdate()
from #product a 
	left join dw.dim_product b on a.ProductID = b.ProductID
where b.ProductID is null 
	or (a.ManufactoryID != b.ManufactoryID 
			 and b.ProductID not in (select ProductID from dw.dim_product where CurrentFlag='Current'))

--
--
--insert into dw.dim_product
--(   [ProductID]
--      ,[ProductName]  
--      ,[ProductAlternateKey]
--      ,[StandardCost]
--      ,[FinishedGoodsFlag]
--      ,[Color]
--      ,[ListPrice]
--      ,[Size]
--      ,[SizeUnitMeasureCode]
--      ,[Weight]
--      ,[WeightUnitMeasureCode]
--      ,[DaysToManufacture]
--      ,[ProductLine]
--      ,[Class]
--      ,[Style]
--      ,[ProductCategoryID]
--      ,[ProductCategoryName]
--      ,[ProductSubcategoryID]
--      ,[ProductSubcategoryName]
--      ,[ProductModelID]
--      ,[ProductModelName]
--      ,[SellStartDate]
--      ,[SellEndDate]
--      ,[SourceModifiedDate]
--	  ,ManufactoryID
--	  ,ManufactoryName
--	  ,DateFrom 
--	  ,DateTo 
--	  ,CurrentFlag
--	  ,CreatedDate
--	  ,ModifiedDate
--	   )
--
--	--select * from #product
--
--SELECT a.*, getdate(), getdate()
--from #product a 
--	left join dw.dim_product b on a.ProductID = b.ProductID 
--where
--	 a.ManufactoryID != b.ManufactoryID 
--	 and b.ProductID not in (select ProductID from dw.dim_product where CurrentFlag='Current')
--	 --and b.CurrentFlag = 'Expired' 
--

/*
from dw.dim_product a 
	join stg.prod_manu_v1 b on a.ProductID = b.productID --and a.ManufactoryID <> b.ManufactoryID
	join dw.dim_date c on c.DateKey = b.DateFrom
	where a.ManufactoryID <> b.ManufactoryID */