CREATE Procedure [LoadFactResellerSales] 
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
SalesAmount
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
D.OrderQty * D.UnitPrice - D.OrderQty * D.UnitPrice * D.UnitPriceDiscount AS SalesAmount

FROM STG.Sales_SalesOrderHeader H Right JOIN STG.Sales_SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
LEFT JOIN DW.DimProduct P ON
D.ProductID = P.ProductID
LEFT Join Dw.DimDate Da
ON H.OrderDate = Da.Date
LEFT JOIN DW.DimReseller R
ON H.CustomerID = R.CustomerID
WHERE H.OnlineOrderFlag = 0
