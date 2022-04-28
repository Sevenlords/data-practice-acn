CREATE procedure dw.load_dim_currency_new
as

truncate table dw.dim_currency_new

insert into dw.dim_currency_new (
	[CurrencyRateID],
	[CurrencyAlternateKey],
	[CurrencyName],
	[AverageRate],
	[EndOfDayRate],
	[SourceModifiedDate],
	[Timestamp] )

select
	scr.CurrencyRateID,
	sc.CurrencyCode as CurrencyAlternateKey,
	sc.name as [CurrencyName],
	scr.[AverageRate],
	scr.[EndOfDayRate],
	sc.ModifiedDate as [SourceModifiedDate],
	sc.[Timestamp] 
from 
	stg.sales_currency sc join stg.sales_currency_rate scr on sc.CurrencyCode = scr.ToCurrencyCode
