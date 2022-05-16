CREATE Procedure [dbo].[LoadDimCurrency]
AS
drop table if exists #Currency
--Truncate table DW.DimCurrency

SELECT 
ISNULL(CurrencyCode,'N\D') AS [CurrencyAlternateKey],
ISNULL(Name,'N\D') AS CurrencyName,
ISNULL(ModifiedDate,1900-01-01) AS [SourceModifiedDate]
INTO #Currency
From STG.Sales_Currency


Update a
SET
[CurrencyAlternateKey] = b.[CurrencyAlternateKey],
[CurrencyName] = b.[CurrencyName],
[SourceModifiedDate] = b.[SourceModifiedDate],
ModifiedDate = getdate()
FROM DW.DimCurrency a JOIN #Currency b ON a.CurrencyAlternateKey = b.CurrencyAlternateKey

INSERT INTO DW.DimCurrency(
[CurrencyAlternateKey],
[CurrencyName],
[SourceModifiedDate],
ModifiedDate
)

SELECT b.*,GETDATE()
from #Currency b 
	left join DW.DimCurrency a on a.CurrencyAlternateKey = b.CurrencyAlternateKey
where b.CurrencyAlternateKey is null 



--EXEC LoadDimCurrency
