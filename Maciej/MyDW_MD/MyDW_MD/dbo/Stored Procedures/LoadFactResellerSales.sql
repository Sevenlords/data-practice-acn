
CREATE procedure [dbo].[LoadFactResellerSales]
as

exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'


BEGIN TRY

drop table if exists #RSales


SELECT 
	cast(s.order_number as int) as [SalesOrderID],
	cast(0 as nvarchar) as [SalesOrderNumber],
	0 as [SalesOrderDetailID],
	isnull(d.DateKey, '1900-01-01') as [DateKey],
	isnull(r.ResellerKey, -1) as [ResellerKey],
	isnull(p.ProductKey, -1) as [ProductKey],
	cast(s.qty as money) [OrderQuantity],
	parse(s.unit_price as money using 'de-DE') as [UnitPrice],
	cast(s.qty as money)*(parse(s.unit_price as money using 'de-DE')) as [ExtendedAmount],
	0 as [UnitPriceDiscountPct],
	0 as [DiscountAmount],
	cast(p.Standardcost as money) as [ProductStandardCost],
	(cast(p.Standardcost as money)*cast(s.qty as money)) as [TotalProductCost],
	cast(s.qty as money)*parse(s.unit_price as money using 'de-DE') as [SalesAmount],
	'SALES_TXT' as [SourceID]
	into #RSales
	from
	[stg].[sales_txt] as s
	left join [MyDW].[dbo].DimProduct as p on p.ProductAlternateKey = s.product
	join [MyDW].[dbo].DimReseller r on r.ResellerAlternateKey = s.customer
	left join [dbo].[dimDate] D on IIF(charindex('-',s.date)=0, convert(datetime, s.date ,104), convert(datetime, s.date)) = d.Date





insert into #RSales
([SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[DateKey],
	[ResellerKey],
	[ProductKey],
	[OrderQuantity],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscountPct],
	[DiscountAmount],
	[ProductStandardCost],
	[TotalProductCost],
	[SalesAmount],
	[SourceID])
SELECT   
	isnull(h.SalesOrderID, -1) as [SalesOrderID],
	isnull(h.SalesOrderNumber, -1) as [SalesOrderNumber],
	isnull(o.SalesOrderDetailID, -1) as [SalesOrderDetailID],
	isnull(d.DateKey, '1900-01-01') as [DateKey],
	isnull(r.ResellerKey, -1) as [ResellerKey],
	isnull(p.ProductKey, -1) as [ProductKey],
	o.OrderQty as [OrderQuantity],
	o.UnitPrice as [UnitPrice],
	(o.OrderQty*o.UnitPrice) as [ExtendedAmount],
	o.UnitPriceDiscount as [UnitPriceDiscountPct],
	((o.OrderQty*o.UnitPrice)*o.UnitPriceDiscount) as [DiscountAmount],
	p.Standardcost as [ProductStandardCost],
	(p.Standardcost*o.OrderQty) as [TotalProductCost],
	((o.OrderQty*o.UnitPrice)-((o.OrderQty*o.UnitPrice)*o.UnitPriceDiscount)) as [SalesAmount],
	'AW' as [SourceID]
	from
	[stg].[Sales_SalesOrderHeader] as h
	join [stg].[Sales_SalesOrderDetail] as o on h.SalesOrderID = o.SalesOrderID
	join [MyDW].[dbo].DimProduct as p on p.ProductID = o.ProductID
	join [MyDW].[dbo].DimReseller as r on r.CustomerID = h.CustomerID
	join[MyDW].[dbo].DimDate as d on h.OrderDate = d.Date






MERGE INTO dbo.factResellerSales AS TARGET
USING #RSales as SOURCE
ON TARGET.[SalesOrderDetailID] = SOURCE.[SalesOrderDetailID]
WHEN MATCHED
THEN UPDATE SET
	[SalesOrderID] = SOURCE.[SalesOrderID],
	[SalesOrderDetailID] = SOURCE.[SalesOrderDetailID],
	[SalesOrderNumber] = SOURCE.[SalesOrderNumber],
	[DateKey] = SOURCE.[DateKey],
	[ResellerKey] = SOURCE.[ResellerKey],
	[ProductKey] = SOURCE.[ProductKey],
	[OrderQuantity] = SOURCE.[OrderQuantity],
	[UnitPrice] = SOURCE.[UnitPrice],
	[ExtendedAmount] = SOURCE.[ExtendedAmount],
	[UnitPriceDiscountPct] = SOURCE.[UnitPriceDiscountPct],
	[DiscountAmount] = SOURCE.[DiscountAmount],
	[ProductStandardCost] = SOURCE.[ProductStandardCost],
	[TotalProductCost] = SOURCE.[TotalProductCost],
	[SalesAmount] = SOURCE.[SalesAmount],
	[ModifiedDate] = GETDATE(),
	[SourceID] = SOURCE.[SourceID]
WHEN NOT MATCHED BY TARGET
THEN INSERT 
	(
	[SalesOrderID],
	[SalesOrderDetailID],
	[SalesOrderNumber],
	[DateKey],
	[ResellerKey],
	[ProductKey],
	[OrderQuantity],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscountPct],
	[DiscountAmount],
	[ProductStandardCost],
	[TotalProductCost],
	[SalesAmount],
	[SourceID],
	[CreatedDate],
	[ModifiedDate]
	)
	VALUES
	(
	SOURCE.[SalesOrderID],
	SOURCE.[SalesOrderDetailID],
	SOURCE.[SalesOrderNumber],
	SOURCE.[DateKey],
	SOURCE.[ResellerKey],
	SOURCE.[ProductKey],
	SOURCE.[OrderQuantity],
	SOURCE.[UnitPrice],
	SOURCE.[ExtendedAmount],
	SOURCE.[UnitPriceDiscountPct],
	SOURCE.[DiscountAmount],
	SOURCE.[ProductStandardCost],
	SOURCE.[TotalProductCost],
	SOURCE.[SalesAmount],
	SOURCE.[SourceID],
	GETDATE(),
	GETDATE()
	);

exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'
	
END TRY

BEGIN CATCH 

exec [log].[ErrorCall] 
end catch