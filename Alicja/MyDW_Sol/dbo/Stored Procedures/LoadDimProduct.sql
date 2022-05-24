CREATE procedure [dbo].[LoadDimProduct] as

	--truncate table [dbo].[dimProduct]

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 1, @Comment = 'Start Proc'

	begin try

	update P
	set CurrentRowIndicator = 'Expired',
		DateTo = cast(dateadd(DD, -1, D.Date) as date)
	--select P.ProductID, P.ManufactoryId, PM.ManufactoryId, P.CurrentRowIndicator, P.DateTo, PM.DateFrom, cast(dateadd(DD, -1, D.Date) as date)
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

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 999, @Comment = 'End Proc'
	
	end try
	begin catch
		--		declare @ErrorNumber int = ERROR_NUMBER(), 
		--		@ErrorState int = ERROR_STATE(), 
		--		@ErrorSeverity int = ERROR_SEVERITY(), 
		--		@ErrorLine int = ERROR_LINE(), 
		--		@ErrorProcedure nvarchar(max) = ERROR_PROCEDURE(), 
		--		@ErrorMessage nvarchar(max) = ERROR_MESSAGE()

		--exec [log].[ErrorCall]	@ErrorNumber = @ErrorNumber, @ErrorState = @ErrorState, @ErrorSeverity = @ErrorSeverity, 
		--						@ErrorLine = @ErrorLine, @ErrorProcedure = @ErrorProcedure, @ErrorMessage = @ErrorMessage
		exec [log].[ErrorCall]
	end catch
