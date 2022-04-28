create procedure dw.load_dim_product as

truncate table dw.dim_product

insert into dw.dim_product(
	PP.ProductID, ProductName, 
	ProductAlternateKey,
	PP.StandardCost, PP.FinishedGoodsFlag, PP.Color, 
	pp.ListPrice, PP.Size, PP.SizeUnitMeasureCode, PP.Weight,
	PP.WeightUnitMeasureCode, PP.DaysToManufacture,
	PP.ProductLine, PP.Class, PP.Style, 
	PS.ProductCategoryID, ProductCategoryName, PS.ProductSubcategoryID, 
	ProductSubcategoryName, pm.ProductModelID, ProductModelName, 
	pp.SellStartDate, pp.SellEndDate,SourceModifiedDate, pp.Timestamp
)
select
	PP.ProductID, PP.name ProductName, 
	PP.ProductNumber as ProductAlternateKey,
	PP.StandardCost, PP.FinishedGoodsFlag, PP.Color, 
	pp.ListPrice, PP.Size, PP.SizeUnitMeasureCode, PP.Weight,
	PP.WeightUnitMeasureCode, PP.DaysToManufacture,
	PP.ProductLine, PP.Class, PP.Style, 
	PS.ProductCategoryID, PC.Name ProductCategoryName, PS.ProductSubcategoryID, 
	PS.Name ProductSubcategoryName, pm.ProductModelID, pm.Name ProductModelName, 
	pp.SellStartDate, pp.SellEndDate, pp.ModifiedDate SourceModifiedDate, pp.Timestamp

from
	stg.production_product PP
	left join stg.prod_prod_subcategory PS on PP.ProductSubcategoryID = PS.ProductSubcategoryID
	full outer join stg.prod_prod_category PC on PC.ProductCategoryID = PS.ProductCategoryID
	left join stg.product_model PM on PP.ProductID = PM.ProductModelID