CREATE procedure [dbo].[LoadDimReseller] as

	--truncate table [dbo].[dimReseller]

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 1, @Comment = 'Start Proc'

	begin try

	drop table if exists #resellers
	
	select
		C.CustomerID [CustomerID], 
		C.AccountNumber [ResellerAlternateKey], 
		S.Name [ResellerName]
	into #resellers
	from stg.Sales_Customer C
	join stg.Sales_Store S
	on C.StoreID = S.BusinessEntityID

	update a
	set
		[CustomerID] = b.[CustomerID],
		[ResellerAlternateKey] = b.[ResellerAlternateKey],
		[ResellerName] = b.[ResellerName],
		[ModifiedDate] = getdate()
	from [dbo].[dimReseller] a
	join #resellers b on a.CustomerID = b.CustomerID
	where
		a.[CustomerID] != b.[CustomerID]
		or a.[ResellerAlternateKey] != b.[ResellerAlternateKey]
		or a.[ResellerName] != b.[ResellerName]

	insert into [dbo].[dimReseller](
		[CustomerID],
		[ResellerAlternateKey],
		[ResellerName],
		[CreatedDate],
		[ModifiedDate])
	select b.*, getdate(), getdate()
	from [dbo].[dimReseller] a
	right join #resellers b on a.CustomerID = b.CustomerID
	where a.CustomerID is null

	/*
	delete a
	from [dbo].[dimReseller] a
	left join #resellers b on a.CustomerID = b.CustomerID
	where b.CustomerID is null
	*/

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 999, @Comment = 'End Proc'

	end try
	begin catch
		--	declare @ErrorNumber int = ERROR_NUMBER(), 
		--		@ErrorState int = ERROR_STATE(), 
		--		@ErrorSeverity int = ERROR_SEVERITY(), 
		--		@ErrorLine int = ERROR_LINE(), 
		--		@ErrorProcedure nvarchar(max) = ERROR_PROCEDURE(), 
		--		@ErrorMessage nvarchar(max) = ERROR_MESSAGE()

		--exec [log].[ErrorCall]	@ErrorNumber = @ErrorNumber, @ErrorState = @ErrorState, @ErrorSeverity = @ErrorSeverity, 
		--						@ErrorLine = @ErrorLine, @ErrorProcedure = @ErrorProcedure, @ErrorMessage = @ErrorMessage
		exec [log].[ErrorCall]
	end catch