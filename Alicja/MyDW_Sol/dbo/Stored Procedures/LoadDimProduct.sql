CREATE procedure [dbo].[LoadDimProduct] as

	--truncate table [dbo].[dimProduct]

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 1, @Comment = 'Start Proc'

	begin try

	delete from [dbo].[dimProduct]
	where ProductKey = -1

	set identity_insert [dbo].[dimProduct] ON

	insert into [dbo].[dimProduct](
		[ProductKey], [ProductID], [ProductName], [ProductAlternateKey], [StandardCost], [FinishedGoodsFlag],
		[Color], [ListPrice], [Size], [SizeUnitMeasureCode], [Weight], [WeightUnitMeasureCode],	[DaysToManufacture],
		[ProductLine], [Class],	[Style], [ProductCategoryID], [ProductCategoryName], [ProductSubCategoryID],
		[ProductSubCategoryName], [ProductModelID],	[ProductModelName],	[SellStartDate], [SellEndDate],
		[SourceModifiedDate], [CreatedDate], [ModifiedDate], [ManufactoryId], [ManufactoryName], [DateFrom],
		[DateTo], [CurrentRowIndicator]
	)
	select
		-1 as [ProductKey],
		-1 as [ProductID],
		'-1' as [ProductName],
		'-1' as [ProductAlternateKey],
		0 as [StandardCost],
		0 as [FinishedGoodsFlag],
		'-1' as [Color],
		-1 as [ListPrice],
		'-1' as [Size],
		'-1' as [SizeUnitMeasureCode],
		0 as [Weight],
		'-1' as [WeightUnitMeasureCode],
		-1 as [DaysToManufacture],
		'-1' as [ProductLine],
		'-1' as [Class],
		'-1' as [Style],
		-1 as [ProductCategoryID],
		'-1' as [ProductCategoryName],
		-1 as [ProductSubCategoryID],
		'-1' as [ProductSubCategoryName],
		-1 as [ProductModelID],
		'-1' as [ProductModelName],
		'1900-01-01' as [SellStartDate],
		'2100-12-31' as [SellEndDate],
		getdate() as [SourceModifiedDate],
		getdate() as [CreatedDate],
		getdate() as [ModifiedDate],
		-1 as [ManufactoryId],
		'-1' as [ManufactoryName],
		'1900-01-01' as [DateFrom],
		'2100-12-31' as [DateTo],
		'-1' as [CurrentRowIndicator]

	set identity_insert [dbo].[dimProduct] OFF

	update P
	set CurrentRowIndicator = 'Expired',
		DateTo = cast(dateadd(DD, -1, D.Date) as date)
	from dbo.dimProduct P
	join stg.Product_Manufactory PM on P.ProductID = PM.ProductID and P.ManufactoryId != PM.ManufactoryId
	join dbo.dimDate D on PM.DateFrom = D.DateKey

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
		P.[Weight] as [Weight],													--NULL nie jest zamieniany
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
		P.ModifiedDate as [SourceModifiedDate],
		MD_M.ManufactoryId [ManufactoryId],
		MD_M.ManufactoryName [ManufactoryName],
		MD_PM.DateFrom [DateFrom],
		MD_PM.DateTo [DateTo],
		'Current' [CurrentRowIndicator]
	into #products
	from stg.Production_Product P
	left join stg.Production_ProductModel PM on P.ProductModelID = PM.ProductModelID
	left join stg.Production_ProductSubcategory PS on P.ProductSubcategoryID = PS.ProductSubcategoryID
	left join stg.Production_ProductCategory PC	on PS.ProductCategoryID = PC.ProductCategoryID
	left join [stg].[Product_Manufactory] MD_PM on P.ProductID = MD_PM.ProductID
	left join [stg].[Manufactories] MD_M on MD_PM.ManufactoryId = MD_M.ManufactoryId

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
		[ModifiedDate] = getdate(),
		[ManufactoryId] = b.ManufactoryId,
		[ManufactoryName] = b.ManufactoryName,
		[DateFrom] = b.DateFrom,							
		[DateTo] = b.DateTo,								
		[CurrentRowIndicator] = b.CurrentRowIndicator	
	from [dbo].[dimProduct] a
	join #products b on a.ProductID = b.ProductID and a.ManufactoryId = b.ManufactoryId
	where
		a.[ProductID] != b.[ProductID]
		or a.[ProductName] != b.[ProductName]	
		or a.[ProductAlternateKey] != b.[ProductAlternateKey] 
		or a.[StandardCost] != b.[StandardCost] 
		or a.[FinishedGoodsFlag] != b.[FinishedGoodsFlag]
		or a.[Color] != b.[Color] 
		or a.[ListPrice] != b.[ListPrice]
		or a.[Size] != b.[Size]
		or a.[SizeUnitMeasureCode] != b.[SizeUnitMeasureCode]
		or a.[Weight] != b.[Weight] 
		or a.[WeightUnitMeasureCode] != b.[WeightUnitMeasureCode] 
		or a.[DaysToManufacture] != b.[DaysToManufacture] 
		or a.[ProductLine] != b.[ProductLine] 
		or a.[Class] != b.[Class]
		or a.[Style] != b.[Style]
		or a.[ProductCategoryID] != b.[ProductCategoryID]
		or a.[ProductCategoryName] != b.[ProductCategoryName] 
		or a.[ProductSubcategoryID] != b.[ProductSubcategoryID]	
		or a.[ProductSubcategoryName] != b.[ProductSubcategoryName]
		or a.[ProductModelID] != b.[ProductModelID] 
		or a.[ProductModelName] != b.[ProductModelName]
		or a.[SellStartDate] != b.[SellStartDate] 
		or a.[SellEndDate] != b.[SellEndDate]	
		or a.[SourceModifiedDate] != b.[SourceModifiedDate]
		or a.[ManufactoryId] != b.[ManufactoryId] or a.[ManufactoryId] is null 
		or a.[ManufactoryName] != b.[ManufactoryName] or a.[ManufactoryName] is null 
		or a.[DateFrom] != b.[DateFrom] or a.[DateFrom] is null 
		or a.[DateTo] != b.[DateTo] or a.[DateTo] is null 
		or a.[CurrentRowIndicator] is null 

	insert into [dbo].[dimProduct](
		[ProductID], [ProductName],	[ProductAlternateKey], [StandardCost], [FinishedGoodsFlag],	[Color], [ListPrice], [Size], 
		[SizeUnitMeasureCode],	[Weight], [WeightUnitMeasureCode], [DaysToManufacture], [ProductLine], [Class],	[Style], 
		[ProductCategoryID], [ProductCategoryName], 
		[ProductSubcategoryID],	[ProductSubcategoryName], 
		[ProductModelID], [ProductModelName],
		[SellStartDate], [SellEndDate],	[SourceModifiedDate],
		[ManufactoryId], [ManufactoryName], [DateFrom], [DateTo], [CurrentRowIndicator],
		[CreatedDate], [ModifiedDate])
	select b.*, getdate(), getdate()
	from [dbo].[dimProduct] a
	right join #products b on a.ProductID = b.ProductID and a.ManufactoryId = b.ManufactoryId
	where a.ProductID is null 

	/*
	delete a
	from [dbo].[dimProduct] a
	left join #products b on a.ProductID = b.ProductID
	where b.ProductID = null
	*/

	drop table if exists #tempLateProd

	select distinct ST.product
	into #tempLateProd
	from [stg].[Sales_txt] ST
	left join [dbo].[dimProduct] DP on ST.product = DP.ProductAlternateKey
	where DP.ProductAlternateKey is null

	--delete from dbo.dimProduct
	--where ProductID = -2

	insert into [dbo].[dimProduct](
		[ProductID], [ProductName], [ProductAlternateKey], [StandardCost], [FinishedGoodsFlag],
		[Color], [ListPrice], [Size], [SizeUnitMeasureCode], [Weight], [WeightUnitMeasureCode],	[DaysToManufacture],
		[ProductLine], [Class],	[Style], [ProductCategoryID], [ProductCategoryName], [ProductSubCategoryID],
		[ProductSubCategoryName], [ProductModelID],	[ProductModelName],	[SellStartDate], [SellEndDate],
		[SourceModifiedDate], [CreatedDate], [ModifiedDate], [ManufactoryId], [ManufactoryName], [DateFrom],
		[DateTo], [CurrentRowIndicator]
	)
	select
		-2 as [ProductID],
		'-2' as [ProductName],
		product as [ProductAlternateKey],
		0 as [StandardCost],
		0 as [FinishedGoodsFlag],
		'-2' as [Color],
		-2 as [ListPrice],
		'-2' as [Size],
		'-2' as [SizeUnitMeasureCode],
		0 as [Weight],
		'-2' as [WeightUnitMeasureCode],
		-2 as [DaysToManufacture],
		'-2' as [ProductLine],
		'-2' as [Class],
		'-2' as [Style],
		-2 as [ProductCategoryID],
		'-2' as [ProductCategoryName],
		-2 as [ProductSubCategoryID],
		'-2' as [ProductSubCategoryName],
		-2 as [ProductModelID],
		'-1' as [ProductModelName],
		'1900-01-01' as [SellStartDate],
		'2100-12-31' as [SellEndDate],
		getdate() as [SourceModifiedDate],
		getdate() as [CreatedDate],
		getdate() as [ModifiedDate],
		-2 as [ManufactoryId],
		'-2' as [ManufactoryName],
		'1900-01-01' as [DateFrom],
		'2100-12-31' as [DateTo],
		'-2' as [CurrentRowIndicator]
	from #tempLateProd

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 999, @Comment = 'End Proc'
	
	end try

	begin catch
		exec [log].[ErrorCall]
	end catch
