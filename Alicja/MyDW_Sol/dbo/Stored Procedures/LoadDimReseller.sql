CREATE procedure [dbo].[LoadDimReseller] as

	--truncate table [dbo].[dimReseller]

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 1, @Comment = 'Start Proc'

	begin try

	delete from [dbo].[dimReseller]
	where ResellerKey = -1

	set identity_insert [dbo].[dimReseller] ON

	insert into [dbo].[dimReseller](
		[ResellerKey],
		[CustomerID],
		[ResellerAlternateKey],
		[ResellerName],
		[CreatedDate], 
		[ModifiedDate])
	select
		-1 as [ResellerKey],
		-1 as [CustomerID],
		'-1' as [ResellerAlternateKey],
		'-1' as [ResellerName],
		getdate() as [CreatedDate], 
		getdate() as [ModifiedDate]

	set identity_insert [dbo].[dimReseller] OFF

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
		exec [log].[ErrorCall]
	end catch