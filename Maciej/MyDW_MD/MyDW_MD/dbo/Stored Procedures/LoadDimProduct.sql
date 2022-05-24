
CREATE procedure [dbo].[LoadDimProduct]
as

exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'

BEGIN TRY

drop table if exists #product


update a 
set CurrentRowIndicator = 'Expired', Dateto =cast(dateadd(dd,-1,c.Date) as date)
from DimProduct a 
join [stg].[product_manufactory] b on a.ProductID = b.ProductID and a.ManufactoryID <> b.ManufactoryId
join Dimdate c on b.DateFrom = c.DateKey
where CurrentRowIndicator = 'Current'



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
	,pm.ManufactoryId
	,ma.ManufactoryName
	,pm.DateFrom
	,pm.DateTo
	,'Current' as CurrentRowIndicator
into #product
FROM [stg].Production_Product p 
	left join [stg].Production_ProductModel m on p.ProductModelID = m.ProductModelID
	left join [stg].[Production_ProductSubcategory] s on p.ProductSubcategoryID = s.ProductSubcategoryID
	left join [stg].Production_ProductCategory c on s.ProductCategoryID = c.ProductCategoryID
	left join [stg].[product_manufactory] pm on pm.ProductID = p.ProductID
	left join [stg].[manufactories] ma on ma.ManufactoryId = pm.ManufactoryId
/*
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
where b.ProductID is null */


Merge dbo.DimProduct as target
	using ( select * from #product) as source
	on target.ProductID = source.ProductID and target.ManufactoryID  = source.ManufactoryID
	when matched 
	then update set 
			[ProductName] = source.[ProductName]
      ,[ProductAlternateKey]=source.[ProductAlternateKey]
      ,[StandardCost]=source.[StandardCost]
      ,[FinishedGoodsFlag]=source.[FinishedGoodsFlag]
      ,[Color]=source.[Color]
      ,[ListPrice]=source.[ListPrice]
      ,[Size]=source.[Size]
      ,[SizeUnitMeasureCode]=source.[SizeUnitMeasureCode]
      ,[Weight]=source.[Weight]
      ,[WeightUnitMeasureCode]=source.[WeightUnitMeasureCode]
      ,[DaysToManufacture]=source.[DaysToManufacture]
      ,[ProductLine]=source.[ProductLine]
      ,[Class]=source.[Class]
      ,[Style]=source.[Style]
      ,[ProductCategoryID]=source.[ProductCategoryID]
      ,[ProductCategoryName]=source.[ProductCategoryName]
      ,[ProductSubcategoryID]=source.[ProductSubcategoryID]
      ,[ProductSubcategoryName]=source.[ProductSubcategoryName]
      ,[ProductModelID]=source.[ProductModelID]
      ,[ProductModelName]=source.[ProductModelName]
      ,[SellStartDate]=source.[SellStartDate]
      ,[SellEndDate]=source.[SellEndDate]
	  ,[SourceModifiedDate] = source.[SourceModifiedDate]
	  ,[ManufactoryID] = source.[ManufactoryID]
	  ,[ManufactoryName] = source.[ManufactoryName]
	  ,[ModifiedDate] = getdate()
	  ,[DateFrom] = source.[DateFrom]
	  ,[DateTo] = source.[DateTo]
	  ,[CurrentRowIndicator] = source.[CurrentRowIndicator]
	  when not matched by target 
	  then insert 
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
	  ,[ManufactoryID]
	  ,[ManufactoryName]
	  ,[CreatedDate]
	  ,[ModifiedDate]
	  ,[DateFrom]
	  ,[DateTo]
	  ,[CurrentRowIndicator])
	  values 
	  (source.[ProductID]
      ,source.[ProductName]
      ,source.[ProductAlternateKey]
      ,source.[StandardCost]
      ,source.[FinishedGoodsFlag]
      ,source.[Color]
      ,source.[ListPrice]
      ,source.[Size]
      ,source.[SizeUnitMeasureCode]
      ,source.[Weight]
      ,source.[WeightUnitMeasureCode]
      ,source.[DaysToManufacture]
	  ,source.[ProductLine]
	  ,source.[Class]
	  ,source.[Style]
	  ,source.[ProductCategoryID]
	  ,source.[ProductCategoryName]
	  ,source.[ProductSubcategoryID]
	  ,source.[ProductSubcategoryName]
	  ,source.[ProductModelID]
	  ,source.[ProductModelName]
	  ,source.[SellStartDate]
	  ,source.[SellEndDate]
	  ,source.[SourceModifiedDate]
	  ,source.[ManufactoryID]
	  ,source.[ManufactoryName]
	  ,getdate()
	  ,getdate()
	  , source.[DateFrom]
	  ,source.[DateTo]
	  ,source.[CurrentRowIndicator]);

	exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'

END TRY

BEGIN CATCH 
declare @Errornumber int =  ERROR_NUMBER(), @ErrorState int = error_state(), @ErrorSeverity int = error_severity(), @ErrorLine int = error_Line(), @ErrorProcedure nvarchar(max)= error_procedure(), @ErrorMessage nvarchar(max) = error_message()

exec [log].[ErrorCall] @ErrorNumber = @ErrorNumber, @ErrorState = @ErrorState, @ErrorSeverity = @ErrorSeverity, @ErrorLine = @ErrorLine, @ErrorProcedure = @ErrorProcedure, @ErrorMessage = @ErrorMessage

end catch
