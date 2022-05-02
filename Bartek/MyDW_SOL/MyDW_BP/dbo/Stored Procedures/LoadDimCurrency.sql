CREATE Procedure [dbo].[LoadDimCurrency]
AS
Truncate table DW.DimCurrency

INSERT INTO DW.DimCurrency(
[CurrencyAlternateKey],
[CurrencyName],
[SourceModifiedDate]
)

SELECT ISNULL(CurrencyCode,'N\D') AS [CurrentAlternateKey],
ISNULL(Name,'N\D') AS CurrenctName,
ISNULL(ModifiedDate,1970-01-01) AS [SourceModifiedDate]
From STG.Sales_Currency
