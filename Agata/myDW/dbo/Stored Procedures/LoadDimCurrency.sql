

create procedure dbo.LoadDimCurrency
as
truncate table dbo.dimCurrency

insert into dbo.dimCurrency(
	[CurrencyName],	
	[CurrencyALternateKey],
	[SourceModifiedDate])
select name, CurrencyCode, ModifiedDate
from stg.sales_currency

exec dbo.LoadDimCurrency