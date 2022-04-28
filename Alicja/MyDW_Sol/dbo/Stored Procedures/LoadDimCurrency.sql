create procedure [dbo].[LoadDimCurrency] as
	truncate table [dbo].[dimCurrency]
	insert into [dbo].[dimCurrency] (
		[CurrencyAlternateKey], [CurrencyName], [SourceModifiedDate])
	select
		CurrencyCode as [CurrencyAlternateKey],
		Name as [CurrencyName],
		ModifiedDate as [SourceModifiedDate]
	from stg.Sales_Currency