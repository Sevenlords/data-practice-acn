
Create Procedure [LoadDimProduct]

AS

Truncate table DW.DimProduct

Insert into DW.DimProduct(
[ProductID],
[ProductName],
[ProductAlternateKey],
[StandardCost],
[FinishedGoodFlag] ,
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
[SourceModifiedDate])

SELECT P.ProductID AS [ProductID],
P.Name AS [ProductName],
P.ProductNumber AS [ProductAlternateKey],
P.StandardCost AS [StandardCost],
P.FinishedGoodsFlag AS [FinishedGoodFlag] ,
ISNULL(P.Color,'N\D') AS [Color],
P.ListPrice AS [ListPrice],
ISNULL(P.Size,'N\D') AS [Size],
ISNULL(P.SizeUnitMeasureCode,'N\D') AS [SizeUnitMeasureCode],
ISNULL(P.Weight,0) AS [Weight],
ISNULL(P.WeightUnitMeasureCode,'N\D') AS WeightUnitMeasureCode,
P.DaysToManufacture AS DaysToManufacture,
ISNULL(P.ProductLine,'N\D') AS ProductLine,
ISNULL(P.Class,'N\D') AS Class,
ISNULL(P.Style,'N\D') AS Style,
ISNULL(C.ProductCategoryID,'0') AS [ProductCategoryID],
ISNULL(C.Name,'N\D') AS [ProductCategoryName],
ISNULL(S.ProductSubcategoryID,'0') AS [ProductSubcategoryID],
ISNULL(S.Name,'N\D') AS [ProductSubcategoryName],
ISNULL(M.ProductModelID,'0') AS [ProductModelID],
ISNULL(M.Name,'N\D') AS [ProductModelName],
P.SellStartDate AS [SellStartDate],
ISNULL(P.SellEndDate,2100-01-01) AS [SellEndDate],
P.ModifiedDate AS [SourceModifiedDate]

FROM stg.Production_Product p LEFT JOIN stg.Production_ProductSubcategory S
ON P.ProductSubcategoryID = S.ProductSubcategoryID
LEFT JOIN STG.Production_ProductCategory C
ON S.ProductCategoryID = C.ProductCategoryID
LEFT JOIN STG.Production_ProductModel M
ON P.ProductModelID = M.ProductModelID

