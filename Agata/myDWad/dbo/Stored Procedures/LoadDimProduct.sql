

CREATE procedure [dbo].[LoadDimProduct]
as
BEGIN TRY
exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=1, @Comment='Start Proc'

delete from DimProduct
where ProductKey=-1

SET IDENTITY_INSERT DimProduct ON

insert into DimProduct
([ProductKey]
      ,[ProductID]
      ,[ProductName]
      ,[ProductAlternateKey]
      ,[StandardCost]
      ,[FinishedGoodFlag]
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
      ,[Timeshtamp]
      ,[ModifiedDate]
      ,[ManufactoryId]
      ,[ManufactoryName]
      ,[DateFrom]
      ,[DateTo]
      ,[CurrentRowIndicator])
select -1 [ProductKey]
      ,-1 [ProductID]
      ,'-1' [ProductName]
      ,'-1'[ProductAlternateKey]
      ,-1 [StandardCost]
      ,0 [FinishedGoodFlag]
      ,'-1'[Color]
      ,-1[ListPrice]
      ,'-1'[Size]
      ,'-1'[SizeUnitMeasureCode]
      ,-1 [Weight]
      ,'-1'[WeightUnitMeasureCode]
      ,-1[DaysToManufacture]
      ,'-1'[ProductLine]
      ,'-1'[Class]
      ,'-1'[Style]
      ,-1[ProductCategoryID]
      ,'-1'[ProductCategoryName]
      ,-1[ProductSubcategoryID]
      ,'-1'[ProductSubcategoryName]
      ,-1[ProductModelID]
      ,'-1'[ProductModelName]
      ,'1900-01-01'[SellStartDate]
      ,'2100-01-01'[SellEndDate]
      ,getdate() [SourceModifiedDate]
      ,getdate() [Timeshtamp]
      ,getdate() [ModifiedDate]
      ,-1[ManufactoryId]
      ,'-1'[ManufactoryName]
      ,'1900-01-01'[DateFrom]
      ,'2100-01-01'[DateTo]
      ,null[CurrentRowIndicator]

SET IDENTITY_INSERT DimProduct OFF

update a
set CurrentRowIndicator='Expired'
	,DateTo=cast(DATEADD(DD, -1, c.Date) as date)
from DimProduct a
	join stg.Product_manufactory b on a.ProductID=b.ProductID and a.ManufactoryId<>b.ManufactoryId
	join DimDate c on b.DateFrom=c.DateKey
where a.CurrentRowIndicator='Curent'


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
		a.ManufactoryId,
		b.ManufactoryName,
		a.DateFrom,
		a.DateTo,
		'Current' as CurrentRowIndicator
into #product
FROM stg.Production_Product AS P
		LEFT JOIN stg.Production_ProductSubcategory AS PS
		ON P.ProductSubcategoryID = PS.ProductSubcategoryID
		LEFT JOIN stg.Production_ProductCategory PC
		ON PS.ProductCategoryID = PC.ProductCategoryID
		LEFT JOIN stg.Production_ProductModel AS PM
		ON P.ProductModelID = PM.ProductModelID
		left join [stg].[Product_manufactory] a on a.ProductID=p.ProductID
		left join [stg].[manufactories] b on b.ManufactoryId=a.ManufactoryId


		
update a
set [ProductName] = b.[ProductName]
      ,[ProductAlternateKey]=b.[ProductAlternateKey]
      ,[StandardCost]=b.[StandardCost]
      ,[FinishedGoodFlag]=b.[FinishedGoodsFlag]
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
	  ,ManufactoryId=b.ManufactoryId
	  ,ManufactoryName=b.ManufactoryName
	  ,DateFrom=b.DateFrom
	  ,DateTo=b.DateTo
	  ,CurrentRowIndicator=b.CurrentRowIndicator
	  ,SourceModifiedDate=B.SourceModifiedDate
	  ,ModifiedDate = getdate()  
from DimProduct a 
	join #product b ON a.ProductID = b.ProductID and a.ManufactoryId=b.ManufactoryId


insert into [dbo].[DimProduct]
(   [ProductID]
      ,[ProductName]
      ,[ProductAlternateKey]
      ,[StandardCost]
      ,[FinishedGoodFlag]
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
      ,ProductCategoryID
      ,[ProductCategoryName]
      ,[ProductSubcategoryID]
      ,[ProductSubcategoryName]
      ,[ProductModelID]
      ,[ProductModelName]
      ,[SellStartDate]
      ,[SellEndDate]
      ,SourceModifiedDate
	  ,ManufactoryId
	  ,ManufactoryName
	  ,DateFrom
	  ,DateTo
	  ,CurrentRowIndicator
	  ,Timeshtamp
	  ,ModifiedDate
	  )
SELECT a.*, getdate(), getdate()
from #product a 
	left join DimProduct b on a.ProductID = b.ProductID and a.ManufactoryId=b.ManufactoryId
where b.ProductID is null 



--delete a
---- select *
--from DimProduct a 
--	left join #product b on a.ProductID = b.ProductID



exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=999, @Comment='End Proc'
END TRY
BEGIN CATCH

declare @ErrorNumber int = (select ERROR_NUMBER())
declare @ErrorState int = (select ERROR_STATE())
declare @ErrorSeverity int = (select ERROR_SEVERITY())
declare @ErrorLine int = (select ERROR_LINE())
declare @ErrorProcedure varchar(max) = (select ERROR_PROCEDURE())
declare @ErrorMessage varchar(max) = (select ERROR_MESSAGE())

exec log.ErrorCall @ErrorNumber,@ErrorState,@ErrorSeverity,@ErrorLine, @ErrorProcedure,@ErrorMessage


END CATCH
GO



