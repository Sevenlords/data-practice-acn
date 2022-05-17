CREATE procedure [dbo].[LoadDimCurrency] as

	--truncate table [dbo].[dimCurrency]

	drop table if exists #currencies

	select
		[CurrencyCode] as [CurrencyAlternateKey],
		[Name] as [CurrencyName],
		[ModifiedDate] as [SourceModifiedDate]
	into #currencies
	from stg.Sales_Currency

	update a
	set
		[CurrencyAlternateKey] = b.[CurrencyAlternateKey], 
		[CurrencyName] = b.[CurrencyName], 
		[SourceModifiedDate] = b.[SourceModifiedDate],
		[ModifiedDate] = getdate()
	from [dbo].[dimCurrency] a
	join #currencies b on a.CurrencyAlternateKey = b.CurrencyAlternateKey
	where 
		a.[CurrencyAlternateKey] != b.[CurrencyAlternateKey] 
		or a.[CurrencyName] != b.[CurrencyName] 
		or a.[SourceModifiedDate] != b.[SourceModifiedDate]

	insert into [dbo].[dimCurrency] (
		[CurrencyAlternateKey], 
		[CurrencyName], 
		[SourceModifiedDate],
		[CreatedDate],
		[ModifiedDate])
	select b.*, getdate(), getdate()
	from [dbo].[dimCurrency] a
	right join #currencies b on a.CurrencyAlternateKey = b.CurrencyAlternateKey
	where a.CurrencyAlternateKey is null

	/*
	delete a
	from [dbo].[dimCurrency] a
	left join #currencies b on a.CurrencyAlternateKey = b.CurrencyAlternateKey
	where b.CurrencyAlternateKey = null
	*/