
--COMMENT

CREATE procedure [dbo].[LoadDimCurrency]
as
drop table if exists #currency


select name, CurrencyCode, ModifiedDate
into #currency
from stg.sales_currency

update a 
set 
	[CurrencyName]=name,
	[CurrencyALternateKey]=CurrencyCode,
	[SourceModifiedDate]=b.ModifiedDate,
	ModifiedDate=getdate()
from dimCurrency a
	join #currency b on a.CurrencyALternateKey=b.CurrencyCode



insert into dbo.dimCurrency(
	[CurrencyName],	
	[CurrencyALternateKey],
	[SourceModifiedDate],
	timeshtamp,
	ModifiedDate)
select a.*, getdate(), getdate()
from #currency a
	left join DimCurrency b on a.CurrencyCode=b.CurrencyALternateKey
where b.CurrencyALternateKey is null