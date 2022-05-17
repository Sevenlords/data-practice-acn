CREATE Procedure [dbo].[LoadFactResellerSales] 
AS
Truncate table DW.FactResellerSales

Insert Into DW.FactResellerSales(
SalesOrderID,
SalesOrderNumber,
SalesOrderDetailID,
DateKey,
ResellerKey,
ProductKey,
OrderQuantity,
UnitPrice,
ExtendedAmount,
UnitPriceDiscountPct,
DiscountAmount,
ProductStandartCost,
TotalProductCost,
SalesAmount,
[SourceID]
)

Select H.SalesOrderID AS SalesOrderID,
H.SalesOrderNumber AS SalesOrderNumber,
D.SalesOrderDetailID AS SalesOrderDetailID,
ISNULL(Da.DateKey,1970-01-01) AS DateKey,
R.ResellerKey AS ResellerKey,
P.ProductKey AS ProductKey,
D.OrderQty AS OrderQuantity,
D.UnitPrice AS UnitPrice,
D.OrderQty * D.UnitPrice AS ExtendedAmount,
D.UnitPriceDiscount AS UnitPriceDiscountPct,
D.OrderQty * D.UnitPrice * D.UnitPriceDiscount AS DiscountAmount,
P.StandardCost AS ProductStandardCost,
P.StandardCost * D.OrderQty AS TotalProductCost,
D.OrderQty * D.UnitPrice - D.OrderQty * D.UnitPrice * D.UnitPriceDiscount AS SalesAmount,
'AW' [SourceID]

FROM STG.Sales_SalesOrderHeader H RIGHT JOIN STG.Sales_SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
JOIN DW.DimProduct P ON
D.ProductID = P.ProductID
Join Dw.DimDate Da
ON H.OrderDate = Da.Date
JOIN DW.DimReseller R
ON H.CustomerID = R.CustomerID
WHERE H.OnlineOrderFlag = 0

Insert into DW.FactResellerSales(
SalesOrderID,
SalesOrderNumber,
SalesOrderDetailID,
DateKey,
ResellerKey,
ProductKey,
OrderQuantity,
UnitPrice,
ExtendedAmount,
UnitPriceDiscountPct,
DiscountAmount,
ProductStandartCost,
TotalProductCost,
SalesAmount,
[SourceID]
)

select
cast(txt.order_number as int) [SalesOrderID],
0 [SalesOrderNumber],
cast(txt.Line_Number as int) [SalesOrderDetailID],
ISNULL(D.DateKey, 1900-01-01) [DateKey],
R.ResellerKey [ResellerKey],
P.ProductKey [ProductKey],
cast(txt.qty as int) [OrderQuantity],
txt.unit_price [UnitPrice],
txt.qty * txt.unit_price [ExtendedAmount],
0 [UnitPriceDiscountPct],
0 [DiscountAmount],
P.StandardCost [ProductStandardCost],
txt.qty * P.StandardCost [TotalProductCost],
txt.qty * txt.unit_price [SalesAmount],
'SALES_TXT' [SourceID]
FROM stg.Sales_txt txt JOIN DW.DimReseller R on txt.Reseller = R.ResellerAlternateKey
LEFT JOIN DW.DimProduct P on txt.Product = P.ProductAlternateKey
LEFT JOIN DW.DimDate D ON txt.Date = D.Date

--EXEC LoadFactResellerSales
