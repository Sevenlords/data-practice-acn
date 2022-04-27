CREATE procedure dw.load_dim_currency
as

truncate table dw.dim_currency

insert into dw.dim_currency (
	[CurrencyAlternateKey],
	[CurrencyName],
	[SourceModifiedDate],
	[Timestamp] )

select
	sc.CurrencyCode as CurrencyAlternateKey,
	sc.name as [CurrencyName],
	sc.ModifiedDate as [SourceModifiedDate],
	[Timestamp] 
from 
	stg.sales_currency sc