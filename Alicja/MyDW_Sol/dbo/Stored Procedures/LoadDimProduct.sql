﻿CREATE procedure [dbo].[LoadDimProduct] as

	--truncate table [dbo].[dimProduct]

	drop table if exists #products
	select
		P.ProductID as [ProductID],
		P.Name as [ProductName],
		P.ProductNumber as [ProductAlternateKey],
		P.StandardCost as [StandardCost],
		P.FinishedGoodsFlag as [FinishedGoodsFlag],
		isnull(P.Color, 'N/D') as [Color],
		P.ListPrice as [ListPrice],
		isnull(P.Size, 'N/D') as [Size],
		isnull(P.SizeUnitMeasureCode, 'N/D') as [SizeUnitMeasureCode],
		P.Weight as [Weight],													--NULL nie jest zamieniany
		isnull(P.WeightUnitMeasureCode, 'N/D') as [WeightUnitMeasureCode],
		P.DaysToManufacture as [DaysToManufacture],
		isnull(cast(P.ProductLine as nchar(3)), 'N/D') as [ProductLine],
		isnull(cast(P.Class as nchar(3)), 'N/D') as [Class],
		isnull(cast(P.Style as nchar(3)), 'N/D') as [Style],
		isnull(PC.ProductCategoryID, 0) as [ProductCategoryID],					--NULL zamieniany na 0
		isnull(PC.Name, 'N/D') as [ProductCategoryName],
		isnull(PS.ProductSubcategoryID, 0) as [ProductSubcategoryID],			--NULL zamieniany na 0
		isnull(PS.Name, 'N/D') as [ProductSubcategoryName],
		isnull(PM.ProductModelID, 0) as [ProductModelID],						--NULL zamieniany na 0
		isnull(PM.Name, 'N/D') as [ProductModelName],
		P.SellStartDate as [SellStartDate],
		isnull(P.SellEndDate, cast('21001231' as datetime)) as [SellEndDate],	--NULL zamieniany na dużą datę
		P.ModifiedDate as [SourceModifiedDate]
	into #products
	from stg.Production_Product P
	left join stg.Production_ProductModel PM
	on P.ProductModelID = PM.ProductModelID
	left join stg.Production_ProductSubcategory PS
	on P.ProductSubcategoryID = PS.ProductSubcategoryID
	left join stg.Production_ProductCategory PC
	on PS.ProductCategoryID = PC.ProductCategoryID

	--select * from #products

	update a
	set
		[ProductID] = b.[ProductID], 
		[ProductName] = b.[ProductName],	
		[ProductAlternateKey] = b.[ProductAlternateKey], 
		[StandardCost] = b.[StandardCost], 
		[FinishedGoodsFlag] = b.[FinishedGoodsFlag],
		[Color] = b.[Color], 
		[ListPrice] = b.[ListPrice], 
		[Size] = b.[Size], 
		[SizeUnitMeasureCode] = b.[SizeUnitMeasureCode],	
		[Weight] = b.[Weight], 
		[WeightUnitMeasureCode] = b.[WeightUnitMeasureCode], 
		[DaysToManufacture] = b.[DaysToManufacture], 
		[ProductLine] = b.[ProductLine], 
		[Class] = b.[Class],
		[Style] = b.[Style], 
		[ProductCategoryID] = b.[ProductCategoryID], 
		[ProductCategoryName] = b.[ProductCategoryName], 
		[ProductSubcategoryID] = b.[ProductSubcategoryID],	
		[ProductSubcategoryName] = b.[ProductSubcategoryName], 
		[ProductModelID] = b.[ProductModelID], 
		[ProductModelName] = b.[ProductModelName],
		[SellStartDate] = b.[SellStartDate], 
		[SellEndDate] = b.[SellEndDate],	
		[SourceModifiedDate] = b.[SourceModifiedDate],
		[ModifiedDate] = getdate()
	from [dbo].[dimProduct] a
	join #products b on a.ProductID = b.ProductID

	insert into [dbo].[dimProduct](
		[ProductID], [ProductName],	[ProductAlternateKey], [StandardCost], [FinishedGoodsFlag],	[Color], [ListPrice], [Size], 
		[SizeUnitMeasureCode],	[Weight], [WeightUnitMeasureCode], [DaysToManufacture], [ProductLine], [Class],	[Style], 
		[ProductCategoryID], [ProductCategoryName], 
		[ProductSubcategoryID],	[ProductSubcategoryName], 
		[ProductModelID], [ProductModelName],
		[SellStartDate], [SellEndDate],	[SourceModifiedDate],
		[CreatedDate], [ModifiedDate])
	select b.*, getdate(), getdate()
	from [dbo].[dimProduct] a
	right join #products b on a.ProductID = b.ProductID
	where a.ProductID is null

	/*
	delete a
	from [dbo].[dimProduct] a
	left join #products b on a.ProductID = b.ProductID
	where b.ProductID = null
	*/
