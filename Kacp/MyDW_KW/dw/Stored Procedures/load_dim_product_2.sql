CREATE procedure [dw].[load_dim_product] as

exec log.write_proc_call @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'


begin try

--truncate table dw.dim_product
update a
set CurrentFlag = 'Expired',
	DateTo = cast(dateadd(dd,-1,c.date) as date)

--select a.ProductID, a.ManufactoryID, b.manufactoryid, a.CurrentFlag, b.datefrom--cast(dateadd(dd,-1,b.datefrom) as date)
from dw.dim_product a 
	join stg.prod_manu_v1 b on a.ProductID = b.productID --and a.ManufactoryID <> b.ManufactoryID
	join dw.dim_date c on c.DateKey = b.DateFrom
	where a.ManufactoryID <> b.ManufactoryID and a.currentflag = 'current'

drop table if exists dw.dim_product_temp --#product
-- select * from dw.dim_product order by 1
--select * from dw.fact_InternetSales order by 5
SELECT
		isnull(P.ProductID, -1) AS [ProductID],
		isnull(P.Name, 'unknown') as [ProductName],
		isnull(P.ProductNumber, 'unknown') AS [ProductAlternateKey],
		isnull(P.StandardCost, 0)  AS [StandardCost],
		isnull(P.FinishedGoodsFlag, -1) AS [FinishedGoodsFlag],
		ISNULL(P.Color, 'N/D') AS [Color],
		isnull(P.ListPrice, -1) AS [ListPrice],
		ISNULL(P.Size, 'N/D') AS [Size],
		ISNULL(P.SizeUnitMeasureCode, 'N/D') AS [SizeUnitMeasureCode],
		isnull(P.Weight, -1) AS [Weight],
		ISNULL(P.WeightUnitMeasureCode, 'N/D') AS [WeightUnitMeasureCode],
		isnull(P.DaysToManufacture, -1) AS [DaysToManufacture],
		ISNULL(CONVERT(nchar(3),P.ProductLine), 'N/D') AS [ProductLine],
		ISNULL(CONVERT(nchar(3),P.Class), 'N/D') AS [Class],
		ISNULL(CONVERT(nchar(3),P.Style), 'N/D') AS [Style],
		isnull(PS.ProductCategoryID, -1) AS [ProductCategoryID],
		ISNULL(PC.Name, 'N/D') AS [ProductCategoryName],
		isnull(P.ProductSubcategoryID, -1) AS [ProductSubcategoryID],
		ISNULL(PS.Name, 'N/D')  AS [ProductSubcategoryName],
		isnull(P.ProductModelID, -1) AS [ProductModelID],
		ISNULL(PM.Name, 'N/D')  AS [ProductModelName],
		isnull(P.SellStartDate, '1990-01-01') AS [SellStartDate],
		isnull(P.SellEndDate, '2100-12-31') AS [SellEndDate],
		isnull(P.ModifiedDate, getdate()) AS [SourceModifiedDate],
		isnull(v1.ManufactoryID, -1) as ManufactoryID,
		isnull(m1.ManufactoryName, 'unknown') as ManufactoryName,
		isnull(v1.DateFrom,'1990=01-01') as DateFrom,
		isnull(v1.DateTo,'2100,12-31') as Dateto,
		'Current' as CurrentFlag,
		cast(null as varbinary(30)) as HashCode
--into #product
into dw.dim_product_temp
FROM [AdventureWorks2017].[Production].[Product] AS P
		LEFT JOIN [AdventureWorks2017].[Production].[ProductSubcategory] AS PS
		ON P.ProductSubcategoryID = PS.ProductSubcategoryID
		LEFT JOIN [AdventureWorks2017].[Production].[ProductCategory] AS PC
		ON PS.ProductCategoryID = PC.ProductCategoryID
		LEFT JOIN STG.product_model PM
		ON P.ProductModelID = PM.ProductModelID
		left join stg.prod_manu_v1 v1 on v1.productid = p.ProductID
		left join stg.manu_manu_v1 m1 on m1.manufactoryID = v1.manufactoryID

update dw.dim_product_temp
set HashCode = HASHBYTES('MD5', concat([ProductID],[ProductName],[ProductAlternateKey],[StandardCost]
									,[FinishedGoodsFlag],[Color],[ListPrice]
									,[Size],[SizeUnitMeasureCode],[Weight],[WeightUnitMeasureCode],[DaysToManufacture]
									,[ProductLine]
									,[Class],[Style],[ProductCategoryID],[ProductCategoryName],[ProductSubcategoryID]
									,[ProductSubcategoryName],[ProductModelID]
									,[ProductModelName],[SellStartDate],[SellEndDate],[SourceModifiedDate],ManufactoryID,ManufactoryName
									,DateFrom ,DateTo ,CurrentFlag))

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
	  ,HashCode = b.HashCode
from dw.dim_product a 
	join dw.dim_product_temp b ON a.ProductID = b.ProductID and a.ManufactoryID = b.ManufactoryID 
where 
	a.HashCode <> b.HashCode or a.hashcode is null



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
	  ,HashCode 
	  ,CreatedDate
	  ,ModifiedDate
	  )

SELECT a.*, getdate(), getdate()
from dw.dim_product_temp a 
	left join dw.dim_product b on a.ProductID = b.ProductID
where b.ProductID is null 
	or (a.ManufactoryID != b.ManufactoryID 
			 and b.ProductID not in (select ProductID from dw.dim_product where CurrentFlag='Current'))



--late ariving dimension

--select distinct product, b.productalternatekey
--from stg.sales_txt a
--left join dw.dim_product b on a.product = b.ProductAlternateKey
--where b.ProductAlternateKey is null

--begin tran

insert into dw.dim_product(
		[ProductID]
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
	  ,HashCode 
	  ,CreatedDate
	  ,ModifiedDate
	  )
select
	isnull(ProductID, -2) AS [ProductID],
	'unknown' as [ProductName],
	product AS [ProductAlternateKey],
	0 AS [StandardCost],
	-1 AS [FinishedGoodsFlag],
	'N/D' AS [Color],
	-1 AS [ListPrice],
	'N/D' AS [Size],
	 'N/D' AS [SizeUnitMeasureCode],
	 -1 AS [Weight],
	 'N/D' AS [WeightUnitMeasureCode],
	-1 AS [DaysToManufacture],
	 'N/D' AS [ProductLine],
	 'N/D' AS [Class],
	 'N/D' AS [Style],
	-1 AS [ProductCategoryID],
	'N/D' AS [ProductCategoryName],
	-1 AS [ProductSubcategoryID],
	'N/D'  AS [ProductSubcategoryName],
	-1 AS [ProductModelID],
	'N/D'  AS [ProductModelName],
	'1990-01-01' AS [SellStartDate],
	'2100-12-31' AS [SellEndDate],
	getdate() AS [SourceModifiedDate],
	-1 as ManufactoryID,
	'unknown' as ManufactoryName,
	'1990-01-01' as DateFrom,
	'2100-12-31' as Dateto,
	'Current' as CurrentFlag,
	cast(null as varbinary(30)) as HashCode,
	getdate() as CreatedDate,
	getdate() as ModifiedDate
from stg.sales_txt a
left join dw.dim_product b on a.product = b.ProductAlternateKey
where b.ProductAlternateKey is null

--select @@trancount
--rollback tran



exec log.write_proc_call @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'

end try

begin catch

exec log.handle_error

end catch


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