CREATE procedure [dbo].[LoadDimCurrency] as

	--truncate table [dbo].[dimCurrency]

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 1, @Comment = 'Start Proc'

	begin try

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

	/*update a
	set
		[CurrencyAlternateKey] = b.[CurrencyAlternateKey], 
		[CurrencyName] = b.[CurrencyName], 
		[SourceModifiedDate] = b.[SourceModifiedDate],
		[ModifiedDate] = getdate()
	from [dbo].[dimCurrency] a
	join #currencies b on a.CurrencyAlternateKey = b.CurrencyAlternateKey
	where hashbytes('sha2_256', concat_ws(' ',a.[CurrencyAlternateKey], a.[CurrencyName], cast(a.[SourceModifiedDate] as char(23)))) != 
	hashbytes('sha2_256', concat_ws(' ',b.[CurrencyAlternateKey], b.[CurrencyName], cast(b.[SourceModifiedDate] as char(23))))*/

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

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 999, @Comment = 'End Proc'

	end try
	begin catch
		--declare @ErrorNumber int = ERROR_NUMBER(), 
		--		@ErrorState int = ERROR_STATE(), 
		--		@ErrorSeverity int = ERROR_SEVERITY(), 
		--		@ErrorLine int = ERROR_LINE(), 
		--		@ErrorProcedure nvarchar(max) = ERROR_PROCEDURE(), 
		--		@ErrorMessage nvarchar(max) = ERROR_MESSAGE()

		--exec [log].[ErrorCall]	@ErrorNumber = @ErrorNumber, @ErrorState = @ErrorState, @ErrorSeverity = @ErrorSeverity, 
		--						@ErrorLine = @ErrorLine, @ErrorProcedure = @ErrorProcedure, @ErrorMessage = @ErrorMessage

		exec [log].[ErrorCall]
	end catch