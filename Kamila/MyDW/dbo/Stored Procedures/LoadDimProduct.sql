


CREATE PROCEDURE [dbo].[LoadDimProduct]
as

truncate table dbo.DimProduct

INSERT INTO dbo.DimProduct
(
	[ProductID],
	[ProductName],
	[ProductAlternateKey],
	[StandardCost],
	[FinishedGoodFlag],
	[Color],
	[ListPrice],
	[Size],
	[SizeUnitMeasureCode],
	[Weight],
	[WeightUnitMeasureCode],
	[DaysToManufacture],
	[ProductLine],
	[Class],
	[Style],
	[ProductCategoryID],
	[ProductCategoryName],
	[ProductSubcategoryID],
	[ProductSubcategoryName],
	[ProductModelID],
	[ProductModelName],
	[SellStartDate],
	[SellEndDate],
	[SourceModifiedDate],
	[CreatedDate],
	[ModifiedDate]
)


SELECT
	P.ProductID AS [ProductID],
	P.Name AS [ProductName],
	P.ProductNumber AS [ProductAlternateKey],
	P.StandardCost AS [StandardCost],
	P.FinishedGoodsFlag AS [FinishedGoodFlag],
	ISNULL(P.Color, 'N/D') AS [Color],
	P.ListPrice AS [ListPrice],
	ISNULL(P.Size, 'N/D') AS [Size],
	ISNULL(P.SizeUnitMeasureCode, 'N/D') AS [SizeUnitMeasureCode],
	ISNULL(P.Weight, 0) AS [Weight],
	ISNULL(P.WeightUnitMeasureCode, 'N/D') AS [WeightUnitMeasureCode],
	P.DaysToManufacture AS [DaysToManufacture],
	ISNULL(P.ProductLine, 'N/D') AS [ProductLine],
	ISNULL(P.Class, 'N/D') AS [Class],
	ISNULL(P.Style, 'N/D') AS [Style],
	PC.ProductCategoryID AS [ProductCategoryID],
	ISNULL(PC.Name, 'N/D') AS [ProductCategoryName],
	PS.ProductSubcategoryID AS [ProductSubcategoryID],
	ISNULL(PS.Name, 'N/D') AS [ProductSubcategoryName],
	PM.ProductModelID AS [ProductModelID],
	PM.Name AS [ProductModelName],
	ISNULL(P.SellStartDate, '1900-01-01 00:00:00.000') AS [SellStartDate],
	ISNULL(P.SellEndDate, '2100-12-31 00:00:00.000') AS [SellEndDate],
	P.ModifiedDate AS [SourceModifiedDate],
	GETDATE() as [CreatedDate],
	P.Timestamp as [ModifiedDate]

FROM stg.Production_Product AS P
LEFT JOIN stg.Production_ProductSubcategory AS PS
	ON P.ProductSubcategoryID = PS.ProductSubcategoryID
LEFT JOIN stg.Production_ProductCategory AS PC
	ON PS.ProductCategoryID = PC.ProductCategoryID
LEFT JOIN stg.Production_ProductModel AS PM
	ON P.ProductModelID = PM.ProductModelID
