

CREATE procedure insert_minusone
as

--select * from dw.dim_customer order by 1
delete from dw.dim_customer where CustomerID = -1

set identity_insert dw.dim_customer ON
insert into dw.dim_customer(
		[CustomerKey]
      ,[CustomerID]
      ,[CustomerAlternateKey]
      ,[PersonType]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[NameStyle]
      ,[EmailPromotion]
      ,[Suffix]
      ,[EmailAddress]
      ,[PhoneNumber]
      ,[CreatedDate]
      ,[ModifiedDate])
select
	  -1 as [CustomerKey]
	 ,-1 as [CustomerID]
	 ,'unknown' as [CustomerAlternateKey]
	 ,'ND' as [PersonType]
	 ,'N/D' as [Title]
	 ,'unknown' as [FirstName]
	 ,'N/D' as [MiddleName]
	 ,'unknown' as [LastName]
	 ,-1 as [NameStyle]
	 ,-1 as [EmailPromotion]
	 ,'N/D' as[Suffix]
	 ,'N/D' as [EmailAddress]
	 ,'N/D' as[PhoneNumber]
	 ,getdate() as [CreatedDate]
	 ,getdate() as [ModifiedDate]

set identity_insert dw.dim_customer OFF


--select * from dw.dim_product order by 2 asc
delete from dw.dim_product where ProductKey = -1

set identity_insert dw.dim_product ON
INSERT INTO [dw].[dim_product]
           ([ProductKey]
		   ,[ProductID]
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
           ,[ModifiedDate]
           ,[ManufactoryID]
           ,[ManufactoryName]
           ,[DateFrom]
           ,[DateTo]
           ,[CurrentFlag])
     select
			-1 as ProductKey	
           ,-1 as [ProductID]
           ,'unknown' as [ProductName]
           ,'unknown' as [ProductAlternateKey]
           ,0 as [StandardCost]
           ,-1 as[FinishedGoodsFlag]
           ,'N/D' as [Color]
           ,-1 as [ListPrice]
           ,'N/D' as [Size]
           ,'N/D' as [SizeUnitMeasureCode]
           ,-1 as [Weight]
           ,'N/D' as [WeightUnitMeasureCode]
           ,-1 as [DaysToManufacture]
           ,'N/D' as [ProductLine]
           ,'N/D' as  [Class]
           ,'N/D' as [Style]
           ,-1 as [ProductCategoryID]
           ,'N/D' as [ProductCategoryName]
           ,-1 as [ProductSubcategoryID]
           ,'N/D' as [ProductSubcategoryName]
           ,-1 as [ProductModelID]
           ,'N/D' as [ProductModelName]
           ,'1990-01-01' as [SellStartDate]
           ,'2100-01-01' as [SellEndDate]
           ,getdate() as [SourceModifiedDate]
           ,getdate() as [CreatedDate]
           ,getdate() as [ModifiedDate]
           ,-1 as [ManufactoryID]
           ,'unknown' as [ManufactoryName]
           ,'1990-01-01' as [DateFrom]
           ,'2100-01-01' as [DateTo]
           ,-1 as [CurrentFlag]
set identity_insert dw.dim_product OFF

delete from dw.dim_reseller 
where ResellerKey = -1

set identity_insert dw.dim_reseller ON
INSERT INTO [dw].[dim_reseller]
           (ResellerKey
		   ,[CustomerID]
           ,[ResellerAlternateKey]
           ,[ResellerName]
           ,[CreatedDate]
           ,[ModifiedDate])
     select
           -1 as ResellerKey
		   ,-1 as [CustomerID]
           ,'unknown' as [ResellerAlternateKey]
           ,'unk' as [ResellerName]
           ,getdate() as [CreatedDate]
           ,getdate() as [ModifiedDate]

set identity_insert dw.dim_reseller OFF